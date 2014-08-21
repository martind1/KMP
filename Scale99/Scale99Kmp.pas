unit Scale99Kmp;
(* Fahrzeugwaage Schröttle Scale99 OLE Schnittstelle
01.10.09 md  erstellt. Benötigt Scale99_TLB. Eigenes Package.
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  CPro_Kmp, FaWa_Kmp, Scale99_TLB;

type
  TScale99Kmp = class(TFaWaKmp)
  private
    FScale99Lib: TServ;
    Bef: string;
    Brutto: string;
    ZeroResult: integer;
    MessNr: integer;
    Scale99LibValue: string;
    Scale99LibRegist: string;
    function GetScale99Lib: TServ;
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    property ComPort;
  public
    { Public-Deklarationen }
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    function Nullstellen: longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function SwitchMessNr(AMessNr: integer): longint; override;
  published
    { Published-Deklarationen }
    property Scale99Lib: TServ read GetScale99Lib write FScale99Lib;
  end;

implementation

uses
  Prots, Err__Kmp;

var
  Scale99MessNr: integer;

(*** Initialisierung *********************************************************)

(*** Methoden ***************************************************************)


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TScale99Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  ATel : TTel;
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  try
    ATel := GetTel(Tel_Id);
  finally
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      if ATel.Status = cpsOK then
      try
        //function Value: string; Rückmeldung des aktuellen Anzeigewerts, z.B. “112,34kg”
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
        Bef := Scale99LibValue;

        Brutto := '';
        while CharInSet(Char1(Bef), ['0'..'9',',',' ']) do
        begin
          Brutto := Brutto + Char1(Bef);
          Bef := Copy(Bef, 2, MaxInt);
        end;
        StrToGewicht(Brutto, Gewicht);  //überschreibt NachK

        Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
        FaWaStatus := [fwsTimeOut];
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if (Tel_Id = ProtGewichtId) then
    try
      (* function Regist: string; Registrierung. Falls ein leerer String zurückgemeldet wird,
         konnte nicht registriert werden (z.B. wegen Stillstandswartezeit).
         Der registrierte Wert wird gemeldet in der Form
              "1   5    0    5
              “rrrrrrnnnnnnnddw”
         z.B. "0000180013,22kg1"  Waage=1
         Reg.Nr.=123456
         Netto=12,34kg
      *)
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := Scale99LibRegist;
          Gewicht := 0;
          if Trim(Bef) = '' then
            Include(FaWaStatus, fwsWaagenstoerung) else        //unbekannter Fehler
          begin
            Include(FaWaStatus, fwsGewichtOk);

            ProtNr := StrToInt(Copy(Bef, 1, 6));

            Brutto := Copy(Bef, 7, 7);      //hat Komma im Text
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

    {Antwort auf Befehl Nullstellen }
    if (Tel_Id = NullstellenId) then
    try
      NullstellenID := -1;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      try
        ZeroResult := 0;
        //Scale99Lib.Zero;     //liefert keinen Status!
        if ZeroResult = 0 then
          FaWaStatus := [fwsGewichtOK, fwsNull] else
          FaWaStatus := [fwsBereichsfehler];
      except on E:Exception do begin
          Include(FaWaStatus, fwsTimeout);
          EProt(self, E, 'Nullstellen', [0]);
          Display := E.Message;
        end;
      end else
      begin
        FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnNullstellen) then
        FOnNullstellen(Tel_Id, FaWaStatus);
    end else

    {Antwort auf Befehl SwitchMessNr(AMessNr) }
    if (Tel_Id = SwitchMessNrId) then
    try
      SwitchMessNrId := -1;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      try
        MessNr := StrToInt(String(CharN(String(StrLPas(ATel.OutData, ATel.OutDataLen)))));
        //Scale99Lib.Switch(MessNr);
        FaWaStatus := [fwsGewichtOK];
      except on E:Exception do begin
          Include(FaWaStatus, fwsTimeout);
          EProt(self, E, 'SwitchMessNr', [0]);
          Display := E.Message;
        end;
      end else
      begin
        FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnSwitchMessNr) then
        FOnSwitchMessNr(Tel_Id, MessNr, FaWaStatus);
    end else

    begin
    end;
  end;  //finally
end;

function TScale99Kmp.ProtGewicht(Beizeichen: string): longint;
var
  T1: integer;
begin
//  if not Simul then
//  begin
//    if Scale99MessNr <> GerNr then
//    begin
//      Scale99MessNr := GerNr;
//      Scale99Lib.Switch(GerNr);
//      Delay(600, true);
//    end;
//    Scale99LibRegist := Scale99Lib.Regist;
//  end;

  TicksReset(T1);
  repeat
    if Scale99MessNr <> GerNr then
    begin
      Scale99MessNr := GerNr;
      Scale99Lib.Switch(GerNr);
      Delay(600, true);
    end;
    if not Simul then
    begin
      Scale99LibRegist := Scale99Lib.Regist;
    end;
  until ((StrToIntTol(CharN(Scale99LibRegist)) = GerNr) and (Char1(Scale99LibRegist) <> '-')) or
        (TicksDelayed(T1) > 1000);
  if StrToIntTol(CharN(Scale99LibRegist)) <> GerNr then
    Scale99LibRegist := '';

  ProtZeile1 := Beizeichen;
  ProtGewichtId := StartFlags(SProtGewicht, length(SProtGewicht), [cpfPoll, cpfDummy], '', 0);
  Result := ProtGewichtId;
end;

function TScale99Kmp.HoleStatus: longint;
var
  T1: integer;
begin
  TicksReset(T1);
  repeat
    if Scale99MessNr <> GerNr then
    begin
      Scale99MessNr := GerNr;
      Scale99Lib.Switch(GerNr);
    end;
    Scale99LibValue := Scale99Lib.Value;
  until ((StrToIntTol(CharN(Scale99LibValue)) = GerNr) and (Char1(Scale99LibValue) <> '-')) or
        (TicksDelayed(T1) > 1000);
  if StrToIntTol(CharN(Scale99LibValue)) <> GerNr then
    Scale99LibValue := '';
  StatusId := StartFlags(SHoleStatus, length(SHoleStatus), [cpfPoll, cpfDummy], '', 0);
  Result := StatusId;
end;

function TScale99Kmp.Nullstellen: longint;
begin
  if Scale99MessNr <> GerNr then
  begin
    Scale99MessNr := GerNr;
    Scale99Lib.Switch(GerNr);
    Delay(100, true);
  end;
  Scale99Lib.Zero;
  NullstellenId := StartFlags(SNullstellen, length(SNullstellen), [cpfPoll, cpfDummy], '', 0);
  Result := NullstellenId;
end;

function TScale99Kmp.SwitchMessNr(AMessNr: integer): longint;
var
  S: AnsiString;
begin
  Scale99Lib.Switch(MessNr);
  S := AnsiString(SSwitchMessnummer) + AnsiString(IntToStr(AMessNr));
  SwitchMessNrId := StartFlags(PAnsiChar(S), length(S), [cpfPoll, cpfDummy], '', 0);
  Result := SwitchMessNrId;
end;

function TScale99Kmp.Zeilendruck(Zeile: string): longint;
begin
  DruckId := StartFlags(SZeilendruck, length(SZeilendruck), [cpfPoll, cpfDummy], '', 0);
  Result := DruckID;
end;

procedure TScale99Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if StrLComp(ATel.OutData, SProtGewicht, length(SProtGewicht)) = 0 then  //Registrieren
  begin
    //          “rrrrrrnnnnnnnddw”
    //     z.B. "0000180013,22kg1"  Waage=1
    SimError := 00; //Test
    if SimProtNr = 0 then
      SimProtNr := StrToInt(FormatDateTime('HHNNSS', now));

    Scale99LibRegist := Format('%06.6d%6.2fkg%d',
      [SimProtNr, Gew / 100, GerNr]);

    StrFmt(ATel.InData, '%s', [Scale99LibRegist]);
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

function TScale99Kmp.GetScale99Lib: TServ;
begin
  Result := FScale99Lib;
  Prot0('GetScale99Lib', [0]);
end;

end.
