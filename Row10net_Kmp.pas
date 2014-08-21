unit Row10net_Kmp;
(* Fahrzeugwaage Rowa 10 Schröttle/Franz Rottner
25.09.09 md  erstellt (Netzwerkversion)
                      kein Druckbefehl mehr.
                      Ohne Switch Messverstärker. Ohne Quittieren.
22.12.11 md  SBTRM Ampel SetzeAusgang als Function für WsFawa
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TRow10NetKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    SetTaraId, DelTaraId: longint;
    SetzeAusgangId: longint;
    ShortDescription: TStringList;
    function ErrorToStr(Error: integer): string;
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Bef: string;
    WaaNr: string;  //IP-Adresse
    Brutto: string;
    Error: string;
    Stoer: string;

    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Nullstellen: longint; override;
    function SetzeAusgang(Ausgang: Integer; Value: Boolean): longint; override;

    procedure ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
    procedure StoerToWaStat(Stoer: integer; var Status: TFaWaStatus);

    Function Tariere: LongInt;
    Function DelTara: LongInt;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;

(*** Initialisierung *********************************************************)

procedure TRow10NetKmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('T:3000');
  Description.Add('B:');
  Description.Add('A:200:2');

  ShortDescription.Clear;
  ShortDescription.Add('B:');  //ohne Rückmeldung
end;

constructor TRow10NetKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  ShortDescription := TStringList.Create;
end;

procedure TRow10NetKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TRow10NetKmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  FreeAndNil(ShortDescription);
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TRow10NetKmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

function TRow10NetKmp.ErrorToStr(Error: integer): string;
begin
  Result := '';
  if ISBITSET(Error, 0) then Result := Result + 'Quersumme';
  if ISBITSET(Error, 1) then Result := Result + 'Messsignal';
  if ISBITSET(Error, 2) then Result := Result + 'Ueberlast';
  if ISBITSET(Error, 3) then Result := Result + 'Drucker';
  if ISBITSET(Error, 4) then Result := Result + 'Langzeitspeicher';
  if ISBITSET(Error, 5) then Result := Result + 'Kallibrierung';
end;

procedure TRow10NetKmp.ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
begin
  if ISBITSET(Error, 0) then Include(Status, fwsWaagenstoerung);  //Quersumme
  if ISBITSET(Error, 1) then Include(Status, fwsWaagenstoerung);  //Messsignal
  if ISBITSET(Error, 2) then Include(Status, fwsUeberlast);
  if ISBITSET(Error, 3) then Include(Status, fwsDruckerstoerung);
  if ISBITSET(Error, 4) then Include(Status, fwsSpeicherfehler);  //Langzeitspeicher
  if ISBITSET(Error, 5) then Include(Status, fwsWaagenstoerung);  //Kallibrierung

//  if BITIS(Error, $3F) then  //2^0-5 gesetzt
//    Exclude(Status, fwsGewichtOK);
end;

procedure TRow10NetKmp.StoerToWaStat(Stoer: integer; var Status: TFaWaStatus);
begin
  if ISBITSET(Stoer, 0) then Exclude(Status, fwsKeinStillstand)
                        else Include(Status, fwsKeinStillstand);
  if ISBITSET(Stoer, 1) then Include(Status, fwsNullbereichsfehler);
  if ISBITSET(Stoer, 2) then Include(Status, fwsNull);
  if ISBITSET(Stoer, 4) then Include(Status, fwsUeberlast);


//  if not ISBITSET(Stoer, 0) or ISBITSET(Stoer, 4) then  //2^1 oder 2^4 gesetzt
//    Exclude(Status, fwsGewichtOK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TRow10NetKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  S1 : string;
  T1: integer;
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  L := sizeof(EmpfBuff) - 1;
  ATel := nil;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    {Antwort auf Befehl Status 'F8'}
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      if ATel.Status = cpsOK then
      try
        //            1
        //  0    5    0
        //  F8xkbfnnnnnnc
        //  F8AR@@  1985h   <- Juwit.exe   (F80)
        //  F8xfnnnnnnnc
        //  F8A@  11,79kgQ  <- Delphi WIR
        //  F8A@  19,85kgZ  <- S99_R1.exe  (F82)
        //  F8@@  27,03kgX     dto. kein Stillstand

        Bef := String(StrLPas(EmpfBuff+0, 2));
        if Bef = 'F8' then
        begin
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
          Stoer := String(StrLPas(EmpfBuff+2, 1));     //'x'
          StoerToWaStat(Ord(Char1(Stoer)), FaWaStatus);
          Error := String(StrLPas(EmpfBuff+3, 1));    // 'f'
          ErrorToWaStat(Ord(Char1(Error)), FaWaStatus);
        end else
        begin  //Fehler
          Stoer := '0';
          Error := '1';
          Include(FaWaStatus, fwsWaagenstoerung);   {bei Status so}
        end;

        //waanr ist IP-Adresse
        if EmpfBuff[5] = '@' then
        begin
          Brutto := String(StrLPas(EmpfBuff+6, 6));   //kein Komma im Text: Juwit.exe
        end else
        begin
          Brutto := String(StrLPas(EmpfBuff+5, 6));   //hat Komma im Text
        end;
        StrToGewicht(Brutto, Gewicht);  //überschreibt NachK

        S1 := ErrorToStr(Ord(Char1(Error)));
        TicksReset(T1);
        if (S1 <> '') and Odd(T1 div 1000) then
          Display := S1 else
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
        Display := Format('%d:%s',[Comport.ErrorCode, StrDflt(Comport.ErrorStr, 'Timeout')]);
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    {Antwort auf Befehl ProtGewicht }
    if (Tel_Id = ProtGewichtId) then
    try
      (* 10: Gewicht holen und Eichfähig speichern *)
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          //            1    1    2    2    3    3    4    4    5    5
          //  0    5    0    5    0    5    0    5    0    5    0    5
          //  10rrrrrrddmmjjjjhhmmssnnnnnnnddtttttttddiii.iii.iii.iiic
          //  10000006270920091958080023,77kg0000,00kg192.168.115.11 r
          Bef := String(StrLPas(EmpfBuff+0, 2));
          Error := Bef;
          Gewicht := 0;
          if Bef = 'E1' then
            Include(FaWaStatus, fwsSpeicherfehler) else    //Alibispeicher voll
          if Bef = 'E2' then
            Include(FaWaStatus, fwsKeinStillstand) else    //kein Stillstand, Überlast,..
          if Bef <> '10' then
            Include(FaWaStatus, fwsWaagenstoerung) else        //unbekannter Fehler
          begin
            Include(FaWaStatus, fwsGewichtOk);   {bei Status so}

            //waanr ist IP-Adresse
            WaaNr := String(StrLPas(EmpfBuff+40, 15));

            //Gewicht: vorher Komma einfügen gemäß Feld 'k'
            Brutto := String(StrLPas(EmpfBuff+22, 7));   //hat Komma im Text
            StrToGewicht(Brutto, Gewicht);  //überschreibt NachK

            Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          end;
        end else
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
        end;
      except on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Gewicht := 0;
          EProt(self, E, 'ProtGewicht', [0]);
        end;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    {Antwort auf Befehl Zeilendruck}
    if (Tel_Id = DruckId) then
    begin  //nichts zu tun. nur Ereignis auslösen.
      DruckId := -1;
      FaWaStatus := [];
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    {Antwort auf Befehl Tara setzen (Bef 02 }
    if (Tel_Id = SetTaraId) then
    try
      SetTaraId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Error := String(StrLPas(EmpfBuff+4, 2));
          ErrorToWaStat(StrToInt(Error), FaWaStatus);
        end else
        begin
          if FaWaStatus = [] then
            FaWaStatus := [fwsTimeout];
          Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    {Antwort auf Befehl Tara löschen (Bef 21, Version Rt1.04)}
    if (Tel_Id = DelTaraId) then
    try
      DelTaraID := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          {nicht notwendig, Waage antwortet immer mit 00}
          FaWaStatus := [fwsGewichtOK];
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    {Antwort auf Befehl Nullstellen (Bef F0)}
    if (Tel_Id = NullstellenId) then
    try
      NullstellenID := -1;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      begin
        {nicht notwendig, Waage antwortet nicht}
        FaWaStatus := [fwsGewichtOK, fwsNull];
      end else
      begin
        FaWaStatus := [fwsTimeout];
        Display := 'Nullstellenfehler';
      end;
    finally
      if assigned(FOnNullstellen) then
        FOnNullstellen(Tel_Id, FaWaStatus);
    end else

    begin
    end;
  end;
end;

procedure TRow10NetKmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if StrLComp(ATel.OutData, '00', 2) = 0 then
  begin
    StrFmt(ATel.InData, '00%02.2d%02.2d%01.1d%05.5d%05.5d%01.1d',
      [GerNr, SimError, SimStoer, Gew, Gew, SimStill]);
  end else
  if StrLComp(ATel.OutData, '10', 2) = 0 then  //Registrieren
  begin
          //  10rrrrrrddmmjjjjhhmmssnnnnnnnddtttttttddiii.iii.iii.iiic
          //  10000006270920091958080023,77kg0000,00kg192.168.115.11 r
    SimError := 00; //Test
    if SimProtNr = 0 then
      SimProtNr := StrToInt(FormatDateTime('HHNNSS', now));

    StrFmt(ATel.InData, '10%06.6d%s%6.2fkg0000,00kg192.168.115.11 c',
      [SimProtNr, FormatDateTime('DDMMYYYYHHNNSS', now), Gew / 100]);
    SimProtNr := SimProtNr + 1;
  end else
  if StrLComp(ATel.OutData, 'F8', 2) = 0 then  //Status
  begin
        //  F8xfnnnnnnnc
        //  F8A@  11,79kgQ  <- Delphi WIR
    StrFmt(ATel.InData, 'F8A@%6.2fc', [Gew / 100]);
  end else
  if StrLComp(ATel.OutData, '01', 2) = 0 then        // Nullstellen
  begin
    SimError := 0;                                   // immer 0
    SimGewicht := 0;
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TRow10NetKmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  ProtZeile1 := BeiZeichen;
  StrFmt(Befehl, '10', [0]);
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TRow10NetKmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, 'F8', [0]);
  BefLen := StrLen(Befehl);
  StatusId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := StatusId;
end;

{Befehl 20, RT1.04: Tarieren }
Function TRow10NetKmp.Tariere: LongInt;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
Begin
  StrFmt(Befehl, '02', [0]);  //Achtung: keine Rückmeldung
  BefLen := StrLen(Befehl);
  SetTaraId := Start(Befehl, BefLen);
  GetTel(SetTaraId).Description.Assign(ShortDescription);
  Result := SetTaraId;
End;

{Befehl 21, RT1.04: Tara löschen }
Function TRow10NetKmp.DelTara: LongInt;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
Begin
  StrFmt(Befehl, '03', [0]);  //Achtung: keine Rückmeldung
  BefLen := StrLen(Befehl);
  DelTaraId := Start(Befehl, BefLen);
  GetTel(DelTaraId).Description.Assign(ShortDescription);
  Result := DelTaraId;
End;

function TRow10NetKmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '01', [0]);  //Achtung: keine Rückmeldung
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  GetTel(NullstellenId).Description.Assign(ShortDescription);
  Result := NullstellenId;
end;

function TRow10NetKmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '', [0]);  //keine Kommunikation. Nur OnAntwort.
  BefLen := StrLen(Befehl);                         //Bug 10.12.09
  DruckID := StartFlags(Befehl, BefLen, [cpfPoll, cpfDummy], '', 0);
  Result := DruckID;
end;

function TRow10NetKmp.SetzeAusgang(Ausgang: Integer; Value: Boolean): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '32%d%d', [Ausgang, Ord(Value)]);  //Achtung: keine Rückmeldung
  BefLen := StrLen(Befehl);                         //Bug 10.12.09
  SetzeAusgangId := Start(Befehl, BefLen);
  //04.01.10 doch mit Rückmeldung GetTel(SetzeAusgangId).Description.Assign(ShortDescription);
  Result := SetzeAusgangId;
end;

end.
