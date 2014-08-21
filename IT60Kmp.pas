unit IT60Kmp;
(* Industrie Wägeterminal IT6000 SysTec (Witterschlick)
   31.05.03 MD erstellt (it3000)
   22.12.08 MD erstellt

   ---------------------------------------
   ProtDruck: wenn gesetzt wird nach ProtGewicht eine Zeile gedruckt
              <Datum> <Zeit> <ProtNr> <Brutto>
              wenn nicht gesetzt kann das Anwendungsprogramm ZeilenDruck() aufrufen

   Zeilendruck: Platzhalter:  (Standard wenn leer = '#D #N <>')
                <> = Bruttogewicht in Eichklammern
                #D = Datum und Uhrzeit (PC)
                #N = Eichprotokoll Nummer
                #G = Gerätenummer

   String zum Testen der IT3000 RM Befehle mit Terminal (mit ^J abschließen)
   000012.34.5612:34123410001,2340001,0120000,012t PT123
   000012.34.5612:34123410002,2320001,0120000,012t PT123

   IT6000:
   <00000    1100       0    1100kg122.12.0812:59   0>
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TIT60Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Zeilendruck(Zeile: string): longint; override;
    function Nullstellen: longint; override;
    function DelTara: LongInt;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;

(*** Initialisierung *********************************************************)

procedure TIT60Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('T:11000');      //Stillstand
  Description.Add('B:');           //mit < >
  Description.Add('A:255,^J');     //LF ist Ende. Mit < >
end;

constructor TIT60Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TIT60Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TIT60Kmp.Destroy;
begin
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TIT60Kmp.Init;
begin
  inherited Init;
  DelTara;    //Tara löschen und auf Bruttoanzeige gehen
end;


(*** Interne Methoden *******************************************************)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TIT60Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L: integer;
  ATel : TTel;
  S1 : string;
  Fehlercode, WaagenStatus1, WaagenStatus2, WaagenStatus3: integer;
begin
  inherited DoAntwort(Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel(Tel_Id);
    GetData(Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    { Antwort auf Befehl Status }
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      if ATel.Status = cpsOK then
      try
        S1 := String(StrLPas(EmpfBuff + 1, 2));
        FehlerCode := StrToIntTol(S1);
        if not IsNum(Char1(S1)) then
        begin
          FaWaStatus := [fwsKeinGewicht];
          Include(FaWaStatus, fwsTimeout);
          S1 := String(StrLPas(EmpfBuff + 0, L));
          Prot0('%s:%s', [self.Name, S1]);
          Display := Format('%s', [S1]);
        end else
        if FehlerCode <> 0 then
        begin
          FaWaStatus := [fwsKeinGewicht];
          Prot0('%s:Fehlercode=%d', [self.Name, FehlerCode]);
          Display := Format('Fehler %s', [S1]);
        end else
        begin
          //<00000    1100       0    1100kg122.12.0812:59   0>
          // FFSSSBBBBBBBBTTTTTTTTNNNNNNNNEEWDDDDDDDDZZZZZIIII
          // 1   5    0    5    0    5    0    5    0    5
          //          1         2         3         4
          S1 := String(StrLPas(EmpfBuff + 3, 1));
          WaagenStatus1 := StrToIntTol(S1);
          if WaagenStatus1 <> 0 then
            include(FaWaStatus, fwsKeinStillstand);

          S1 := String(StrLPas(EmpfBuff + 4, 1));
          WaagenStatus2 := StrToIntTol(S1);
          if WaagenStatus2 <> 0 then
            include(FaWaStatus, fwsKeinGewicht);

          S1 := String(StrLPas(EmpfBuff + 5, 1));
          WaagenStatus3 := StrToIntTol(S1);
          if WaagenStatus3 <> 0 then
            include(FaWaStatus, fwsUnterlast);  //Gewicht ist negativ

          S1 := String(StrLPas(EmpfBuff + 30, 1));  //Einheit
          if GE = '' then
            GE := S1;
          S1 := String(StrLPas(EmpfBuff + 6, 8));  //Brutto
          S1 := StrCgeChar(S1, ',', #0);
          S1 := StrCgeChar(S1, '.', #0);
          StrToGewicht(S1, Gewicht);
          GewichtToStr(Gewicht, Display);
          include(FaWaStatus, fwsGewichtOk);  //nur bei Status so!
        end;
      except
        on E:Exception do
        begin
          Include(FaWaStatus, fwsTimeout);
          Display := E.Message;
          Prot0('%s:%s',[self.Name, E.Message]);
        end;
      end else
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
    finally
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    { Antwort auf Befehl ProtGewicht }
    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      Gewicht := 0;
      try
        if ATel.Status = cpsOK then
        begin
          S1 := String(StrLPas(EmpfBuff + 1, 2));
          FehlerCode := StrToIntTol(S1);
          if not IsNum(Char1(S1)) then
          begin
            FaWaStatus := [fwsKeinGewicht];
            Include(FaWaStatus, fwsTimeout);
            S1 := String(StrLPas(EmpfBuff + 0, L));
            Prot0('%s:%s', [self.Name, S1]);
            Display := Format('%s', [S1]);
          end else
          if FehlerCode <> 0 then
          begin
            FaWaStatus := [fwsKeinGewicht];
            Prot0('%s:Fehlercode=%d', [self.Name, FehlerCode]);
            Display := Format('Fehler %s', [S1]);
          end else
          begin
            //<00000    1100       0    1100kg122.12.0812:59   0>
            // FFSSSBBBBBBBBTTTTTTTTNNNNNNNNEEWDDDDDDDDZZZZZIIII
            // 1   5    0    5    0    5    0    5    0    5
            //          1         2         3         4
            S1 := String(StrLPas(EmpfBuff + 3, 1));
            WaagenStatus1 := StrToIntTol(S1);
            if WaagenStatus1 <> 0 then
              include(FaWaStatus, fwsKeinStillstand);

            S1 := String(StrLPas(EmpfBuff + 4, 1));
            WaagenStatus2 := StrToIntTol(S1);
            if WaagenStatus2 <> 0 then
              include(FaWaStatus, fwsKeinGewicht);

            S1 := String(StrLPas(EmpfBuff + 5, 1));
            WaagenStatus3 := StrToIntTol(S1);
            if WaagenStatus3 <> 0 then
              include(FaWaStatus, fwsUnterlast);  //Gewicht ist negativ

            S1 := String(StrLPas(EmpfBuff + 46, 4));  //IdentNr
            ProtNr := StrToIntTol(S1);

            S1 := String(StrLPas(EmpfBuff + 30, 1));  //Einheit
            if GE = '' then
              GE := S1;
            S1 := String(StrLPas(EmpfBuff + 6, 8));  //Brutto
            S1 := StrCgeChar(S1, ',', #0);
            S1 := StrCgeChar(S1, '.', #0);
            StrToGewicht(S1, Gewicht);
            GewichtToStr(Gewicht, Display);
            if FehlerCode = 0 then
              include(FaWaStatus, fwsGewichtOk);  //nur wenn kein Fehler
          end;
          if ProtDruck and (Fehlercode = 0) then
          begin
            Include(FaWaStatus, fwsProtNr);
            ZeilenDruck(ProtZeile1);
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

    {Antwort auf Befehl Nullstellen (Bef F0)}
    if (Tel_Id = NullstellenId) then
    begin
      NullstellenID := -1;
      if assigned(FOnNullstellen) then
        FOnNullstellen(Tel_Id, FaWaStatus);
    end else

    { Antwort auf Befehl Zeilendruck }
    if (Tel_Id = DruckId) then
    try
      DruckId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          S1 := String(StrLPas(EmpfBuff + 0, 2));
          FehlerCode := StrToIntTol(S1);
          if FehlerCode <> 0 then
          begin
            FaWaStatus := [fwsDruckerstoerung];
            Prot0('%s:Druckerfehler=%d', [self.Name, FehlerCode]);
            Display := Format('Druck:%s', [S1]);
          end else
            FaWaStatus := [fwsGewichtOK];
        end else
        begin
          FaWaStatus := [fwsTimeout];
        end;
      except
        FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    begin
    end;
  end; //finally
end;

procedure TIT60Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
  Fehler, SimProtNr: integer;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;  //in kg
  if StrLComp(ATel.OutData, '<R', 2) = 0 then
  begin
    Fehler := 0;
    //SimError: 100 = kein Stillstand; 010 = kein gewicht; 001 = neg.gewicht
    SimProtNr := 1234;
    //<00000    1100       0    1100kg122.12.0812:59   0>
    // FFSSSBBBBBBBBTTTTTTTTNNNNNNNNEEWDDDDDDDDZZZZZIIII
    // 1   5    0    5    0    5    0    5    0    5
    StrFmt(ATel.InData, '<%02.2d%03.3d%8d%8d%8dkg122.11.1312:34%04.4d',
      [Fehler, SimError, Gew, 0, Gew, SimProtNr]);
  end else
  if StrLComp(ATel.OutData, '<SZ', 3) = 0 then        // Nullstellen
  begin
    SimGewicht := 0;
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TIT60Kmp.ProtGewicht(Beizeichen: string): longint;
begin
  ProtZeile1 := BeiZeichen;
  ProtGewichtId := StartFmt('<RN>', [0]);
  result := ProtGewichtId;
end;

function TIT60Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '<RM>', [0]);
  BefLen := StrLen(Befehl);
  StatusId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := StatusId;
end;


function TIT60Kmp.Zeilendruck(Zeile: string): longint;
begin
  if Zeile = '' then
    Zeile := '#D #N <>';

  Zeile := StrCgeStrStr(Zeile, '<>', '<PG>', false);
  Zeile := StrCgeStrStr(Zeile, '#D',
    DateToStr(date) + '  ' + TimeToStr(time), false);
  Zeile := StrCgeStrStr(Zeile, '#N',
    Format('%6.6d', [ProtNr]), false);
  Zeile := StrCgeStrStr(Zeile, '#G',
    Format('%2.2d', [GerNr]), false);

  StartFmt('<PR1>', [0]);
  DruckID := StartFmt('%s<PR0>', [Zeile]);
  Result := DruckID;
end;

function TIT60Kmp.DelTara: LongInt;
Begin
  DelTaraId := StartFmt('<TC%d>', [GerNr]);
  Result := DelTaraId;
End;

function TIT60Kmp.Nullstellen: longint;
begin
  NullstellenId := StartFmt('<SZ%d>', [GerNr]);
  Result := NullstellenId;
end;

end.
