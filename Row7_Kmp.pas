unit Row7_kmp;
(* Fahrzeugwaage Schröttle/Franz Rottner
22.11.01 MD MessNr, SwitchMessNr. 1,2. Messverstärker Nummer
29.02.02 TS Nullstellen
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TRow7Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FCanQuitt: boolean;  {kann quittieren (ab RT1v04)}
    FMessNr: integer;    {Messverstärker Nr}
    GWId, SetTaraId, DelTaraId: longint;
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    Bef : string[2];
    WaaNr : string[2];
    Error : string[2];
    Stoer : string[1];
    Netto : string[5];
    Brutto :  string[5];
    Still :  string[1];
    SpNr :  string[3];

    Rueckm: boolean;      {Rückmeldung. provisorisch da unklar bei SwitschMessNr}
    MessNrId: integer;

    Antwort: PAnsiChar;
    AntwLen: integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function SwitchMessNr: longint; reintroduce;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Quittieren: longint; override;
    function DruckeBlock(ABlock: TStrings): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function DelSpNr(SpNr: integer): longint; override;
    function Nullstellen: longint; override;

    procedure ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
    procedure StoerToWaStat(Stoer: integer; var Status: TFaWaStatus);

    Function SetGW(GWBrutto, GWNetto: Integer): LongInt;
    Function Tariere: LongInt;
    Function DelTara: LongInt;
  published
    { Published-Deklarationen }
    property CanQuitt: boolean read FCanQuitt write FCanQuitt;
    property MessNr: integer read FMessNr write FMessNr;
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp;
var
  GlobalMessNr: integer;

(*** Initialisierung *********************************************************)

procedure TRow7Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    Description.Add('T:7000');
  Description.Add('S:^B[ROWGERNR]');
  Description.Add('W:^P');
  if Polling then
    Description.Add('W:2');
  Description.Add('B:');
  Description.Add('S:^P^C');
  Description.Add('S:[ROWBCC]');
  Description.Add('W:^P');
  if Polling then
    Description.Add('W:2');

  Description.Add('W:^B');
  if Polling then
    Description.Add('W:2');
  Description.Add('S:^P[ROWGERNR]');
  Description.Add('A:255,^P,^C');
  if Bcc then
    Description.Add('W:1');   {BCC}
  Description.Add('S:^P[ROWGERNR]');
end;

constructor TRow7Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
end;

procedure TRow7Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TRow7Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TRow7Kmp.Init;
begin
  inherited Init;
end;


(*** Interne Methoden *******************************************************)

procedure TRow7Kmp.ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
begin
  if Error = 0 then
    Include(Status, fwsGewichtOK);
  if Error in [10,60,80,81,82,83,84,85] then
    Include(Status, fwsWaagenstoerung);
  if Error in [2,50,58,88] then
    Include(Status, fwsDruckerstoerung);
  if Error in [20] then
    Include(Status, fwsPosition);
  (*
  if BITIS(Ord(Tok[0]), $8) then Include(Status, fwsStillstand);
  if BITIS(Ord(Tok[0]), $2) then Include(Status, fwsKeinGewicht);  {Gew.ungültig}
  if BITIS(Ord(Tok[0]), $1) then Include(Status, fwsNull);  {0t}
  *)
end;

procedure TRow7Kmp.StoerToWaStat(Stoer: integer; var Status: TFaWaStatus);
begin
  (*
  if BITIS(Ord(Tok[0]), $8) then Include(Status, fwsDruckerstoerung); {ohne Drucker}
  if BITIS(Ord(Tok[0]), $4) then Include(Status, fwsWaagenstoerung);
  if BITIS(Ord(Tok[0]), $1) then Include(Status, fwsDruckerstoerung);
  *)
  if Stoer <> 0 then
    Exclude(Status, fwsGewichtOK);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TRow7Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L, I1 : integer;
  ATel : TTel;
  S1 : string;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
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

    {Antwort auf Befehl Status}
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      if ATel.Status = cpsOK then
      try
        Bef := StrLPas(EmpfBuff, 2);
        WaaNr := StrLPas(EmpfBuff+2, 2);
        Error := StrLPas(EmpfBuff+4, 2);
        if (Error = '04') and AutoQuitt and CanQuitt then
          Quittieren;
        Stoer := StrLPas(EmpfBuff+6, 1);
        Netto := StrLPas(EmpfBuff+7, 5);
        Brutto := StrLPas(EmpfBuff+12, 5);
        Still := StrLPas(EmpfBuff+17, 1);
        ErrorToWaStat(StrToIntTol(Error), FaWaStatus);
        StoerToWaStat(StrToIntTol(Stoer), FaWaStatus);
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
        StrToGewicht(String(Netto), Gewicht);
        if Error = '30' then
          Gewicht := -Gewicht;
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

    {Antwort auf Befehl ProtGewicht, ProtDruck}
    if (Tel_Id = ProtGewichtId) and ProtDruck then
    try
      (* 01: Gewicht holen und Protokolldruck *)
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff, 2);
          WaaNr := StrLPas(EmpfBuff+2, 2);
          Error := StrLPas(EmpfBuff+4, 2);
          ErrorToWaStat(StrToIntTol(Error), FaWaStatus);

          ProtNr := StrToInt(String(StrLPas(EmpfBuff+6, 6)));  {HLW}
          Include(FaWaStatus, fwsProtNr);
          Netto := StrLPas(EmpfBuff+12, 5);
          StrToGewicht(String(Netto), Gewicht);
          if Error = '30' then
            Gewicht := -Gewicht;

          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
        end else
        begin
          if FaWaStatus = [] then
            FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    {Antwort auf Befehl ProtGewicht mit Abdruck durch Programm (Bef. 10 & 12)}
    if (Tel_Id = ProtGewichtId) and not ProtDruck then
    try
      (* 10: Gewicht holen und Eichfähig speichern *)
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff, 2);
          WaaNr := StrLPas(EmpfBuff+2, 2);
          Error := StrLPas(EmpfBuff+4, 2);
          ErrorToWaStat(StrToIntTol(Error), FaWaStatus);

          SpNr := StrLPas(EmpfBuff+6, 3);
          ProtNr := StrToInt(String(SpNr));  {HLW}

          Netto := StrLPas(EmpfBuff+9, 5);
          StrToGewicht(String(Netto), Gewicht);
          if Error = '30' then
            Gewicht := -Gewicht;
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);

          if (ProtZeile1 <> '') and (StrToIntTol(Error) = 0) then
          begin
            GenProtNr;                                          {nächste ProtNr}
            Include(FaWaStatus, fwsProtNr);
            ProtZeile2 := StrCgeStrStr(ProtZeile1, '<>',
              Format('<%s>', [SpNr]), false);
            ProtZeile2 := StrCgeStrStr(ProtZeile2, '#D',
              DateToStr(date) + '  ' + TimeToStr(time), false);
            ProtZeile2 := StrCgeStrStr(ProtZeile2, '#N',
              Format('%6.6d', [ProtNr]), false);
            ProtZeile2 := StrCgeStrStr(ProtZeile2, '#G',
              Format('%2.2d', [GerNr]), false);
            ZeilenDruck(ProtZeile2);
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

    {Antwort auf Befehl Drucken (Bef 12)}
    if (Tel_Id = DruckId) then
    try
      (* 12: Drucke Zeile bzw. Block *)
      DruckId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Bef := StrLPas(EmpfBuff, 2);
          WaaNr := StrLPas(EmpfBuff+2, 2);
          Error := StrLPas(EmpfBuff+4, 2);
          ErrorToWaStat(StrToInt(String(Error)), FaWaStatus);
          if Error = '00' then
            if DruckIndex < DruckBlock.Count then
            begin
              StrFmt(Befehl, '12%-02.2d%s', [GerNr, DruckBlock.Strings[DruckIndex]]);
              BefLen := StrLen(Befehl);
              Inc(DruckIndex);
              SMess('Drucke Zeile %d',[DruckIndex]);
              DruckId := Start(Befehl, BefLen);
            end else
              SMess('',[0]);
        end else
        begin
          if FaWaStatus = [] then
            FaWaStatus := [fwsTimeout];
        end;
      except
        if FaWaStatus = [] then
          FaWaStatus := [fwsTimeout];
      end;
    finally
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    {Antwort auf Befehl Tara setzen (Bef 20, Version Rt1.04)}
    if (Tel_Id = SetTaraId) then
    try
      SetTaraId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Error := StrLPas(EmpfBuff+4, 2);
          ErrorToWaStat(StrToInt(String(Error)), FaWaStatus);
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

    {Antwort auf Befehl Grenzwerte setzen (Bef 30, Version Rt1.04)}
    if (Tel_Id = GWId) then
    try
      GWId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          Error := StrLPas(EmpfBuff+4, 2);
          if StrToIntTol(Error) <> 0 then
            FaWaStatus := FaWaStatus + [fwsGrenzwert]
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

    {Antwort auf Befehl Quittieren (Bef 90)}
    if (Tel_Id = QuittId) then
    begin
      SMess('',[0]);
    end else

    {Antwort auf Befehl Nullstellen (Bef F0)}
    if (Tel_Id = NullstellenId) then
    begin
      try
        NullstellenID := -1;
        FaWaStatus := [];
        if ATel.Status = cpsOK then
          try
            Bef := StrLPas(EmpfBuff, 2);
            WaaNr := StrLPas(EmpfBuff+2, 2);
            Error := StrLPas(EmpfBuff+4, 2);
            ErrorToWaStat(StrToIntTol(Error), FaWaStatus);
            Netto := StrLPas(EmpfBuff+12, 5);
            StrToGewicht(String(Netto), Gewicht);
            Include(FaWaStatus, fwsGewichtOk);
            // Nach Nullstellen Protokollabdruck auslösen
            if Gewicht = 0 then begin
              Include(FaWaStatus, fwsNull);
            end;
            if Error = '30' then
              Gewicht := -Gewicht;
            Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          except
            on E:Exception do
            begin
              Display := E.Message;
              Prot0('%s',[E.Message]);
            end;
          end
        else
          Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      finally
        if assigned(FOnNullstellen) then
          FOnNullstellen(Tel_Id, FaWaStatus);
      end;
    end else

    begin
      (* Speichernummer(n) löschen: Erfolg anzeigen *)
      if (L = 6) and (StrLComp(EmpfBuff, '11', 2) = 0) then
      begin
        I1 := StrToIntTol(StrLPas(EmpfBuff+4, 2));
        if I1 = 0 then
          S1 := 'gelöscht' else
          S1 := 'nicht belegt '+IntToStr(I1);
        SMess('Speichernummer %s %s',[StrLPas(ATel.OutData+4,3), S1]);
      end else
      (* Ausdruck Block 12wwff *)
      if (L = 6) and (StrLComp(EmpfBuff, '12', 2) = 0) then
      begin
        FaWaStatus := [];
        inc(DruckIndex);
        Error := StrLPas(EmpfBuff+4, 2);
        ErrorToWaStat(StrToInt(String(Error)), FaWaStatus);
        S1 := FaWaStatusStr(FaWaStatus);
        SMess('Zeile %d/%d gedruckt %s',[DruckIndex, DruckBlock.Count, S1]);
      end;
    end;
  end;
end;

procedure TRow7Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
  ZNr: string;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if SimGewicht < 0 then
  begin
    SimError := 30;
    Gew := -SimGewicht;
  end else
  if SimError = 30 then
    SimError := 0;
  if StrLComp(ATel.OutData, '00', 2) = 0 then
  begin
    StrFmt(ATel.InData, '00%02.2d%02.2d%01.1d%05.5d%05.5d%01.1d',
      [GerNr, SimError, SimStoer, Gew, Gew, SimStill]);
  end else
  if StrLComp(ATel.OutData, '01', 2) = 0 then
  begin
    SimError := 00; //Test
    if SimProtNr = 0 then
      SimProtNr := StrToInt(FormatDateTime('HHNNSS', now));
    StrFmt(ATel.InData, '01%02.2d%02.2d%06.6d%05.5d',
      [GerNr, SimError, SimProtNr, Gew]);
    SimProtNr := SimProtNr + 1;
  end else
  if StrLComp(ATel.OutData, '05', 2) = 0 then
  begin
    ZNr := String(StrLPas(ATel.OutData+ 4, 1));
    StrFmt(ATel.InData, '01%02.2d%s', [GerNr, ZNr]);
    if ZNr = '1' then
      SimProtNr := 1000 else
    {if ZNr = '2' then}
      SimProtNr := 2000;     {RALA#Row7Fme}
  end else
  if StrLComp(ATel.OutData, '05', 2) = 0 then         // Verbund umschalten
  begin
    StrFmt(ATel.InData, '05%02.2d%02.2d',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, '10', 2) = 0 then
  begin
    StrFmt(ATel.InData, '10%02.2d%02.2d%03.3d%05.5d',
      [GerNr, SimError, SimSpNr, Gew]);
  end else
  if StrLComp(ATel.OutData, '11', 2) = 0 then
  begin
    StrFmt(ATel.InData, '11%02.2d%02.2d',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, '12', 2) = 0 then
  begin
    StrFmt(ATel.InData, '12%02.2d%02.2d',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, '20', 2) = 0 then        // Tarieren
  begin
    StrFmt(ATel.InData, '20%02.2d%02.2d',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, '21', 2) = 0 then        // Tara löschen
  begin
    SimError := 0;                                   // immer 0
    StrFmt(ATel.InData, '20%02.2d%02.2d',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, '30', 2) = 0 then        // Grenzwerte/Ausgänge
  begin
    if ATel.OutDataLen = 6 then     //Ausgänge
      StrFmt(ATel.InData, '30%02.2d0', [GerNr]) else
      StrFmt(ATel.InData, '30%02.2d00', [GerNr]);    //Grenzwerte
  end else
  if StrLComp(ATel.OutData, '32', 2) = 0 then        // Eingänge
  begin
    StrFmt(ATel.InData, '32%02.2d%d%d',
      [GerNr, SimEing1, SimEing2]);
  end else
  if StrLComp(ATel.OutData, '90', 2) = 0 then        // Quittieren
  begin
    StrFmt(ATel.InData, '30%02.2d00',
      [GerNr, SimError]);
  end else
  if StrLComp(ATel.OutData, 'F0', 2) = 0 then        // Nullstellen
  begin
    SimError := 0;                                   // immer 0
    SimGewicht := 0;
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TRow7Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  ProtZeile1 := BeiZeichen;
  if ProtDruck then
    StrFmt(Befehl, '01%-02.2d', [GerNr]) else
    StrFmt(Befehl, '10%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TRow7Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '00%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  StatusId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := StatusId;
end;

function TRow7Kmp.SwitchMessNr: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Result := -1;
  if GlobalMessNr <> FMessNr then
  begin
    GlobalMessNr := FMessNr;
    {StrFmt(Befehl, 'F701010101Mo010101', [0]);  Test ohne Rueckm}
    {StrFmt(Befehl, 'F801', [0]);  {Test mit Rueckm}
    StrFmt(Befehl, '05%-02.2d%d', [GerNr, FMessNr]);
    BefLen := StrLen(Befehl);
    MessNrId := StartFlags(Befehl, BefLen, [cpfPoll], '', 0);
    Sleep(MessNrId, 200); {danach 200ms warten. lt. Scröttle,22.11.01}

    (*if not Rueckm then   (immer mit Rückmeldung 05 ww z)
    begin
      ATel := GetTel(MessNrId);
      ATel.Description.Clear;
      ATel.Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
      if ComPort <> nil then
        ATel.Description.Add(Format('T:%d',[ComPort.TimeOut])) else
        ATel.Description.Add('T:7000');
      ATel.Description.Add('S:^B[ROWGERNR]');
      ATel.Description.Add('W:^P');
      if Polling then
        ATel.Description.Add('W:2');
      ATel.Description.Add('B:');
      ATel.Description.Add('S:^P^C');
      ATel.Description.Add('S:[ROWBCC]');
      ATel.Description.Add('W:^P');
      if Polling then
        ATel.Description.Add('W:2');
    end;*)
    Result := MessNrId;
  end;
end;

function TRow7Kmp.DelSpNr(SpNr: integer): longint;
(* Speichernummern löschen
   SpNr: -1 = alle *)
var
  Befehl : array[0..255] of AnsiChar;
  BefLen: integer;
  I: integer;
begin
  Result := -1;
  for I:= 1 to 99 do
  begin
    if (I = SpNr) or (SpNr = -1) then
    begin
      StrFmt(Befehl, '11%-02.2d%03.3d', [GerNr,I]);
      BefLen := StrLen(Befehl);
      DelSpNrId := Start(Befehl, BefLen);    {geht schneller da im Hintergrund}
      Result := DelSpNrId;
      SMess('Lösche Speichernummer %d',[I]);
      {AntwLen := 255;
      cpStatus := WaitStart(Befehl, BefLen, Antwort, AntwLen);
      SMess('Lösche Speichernummer %d:%d(%2.2s)',
        [I, ord(cpStatus), StrLPas(Antwort+4, 2)]);}
    end;
  end;
end;

function TRow7Kmp.Quittieren: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '90%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  SMess('Quittieren',[0]);
  QuittId := Start(Befehl, BefLen);
  Result := QuittId;
end;

function TRow7Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '12%-02.2d%s', [GerNr, Zeile]);
  BefLen := StrLen(Befehl);
  AnsiToOem(Befehl, Befehl);
  DruckID := Start(Befehl, BefLen);
  Result := DruckID;
end;

function TRow7Kmp.DruckeBlock(ABlock: TStrings): longint;
var
  Befehl : array[0..200] of AnsiChar;
  I, BefLen: integer;
begin
  Result := -1;
  (* Formularlänge definieren *)
  if FormLen > 0 then
  begin
    StrFmt(Befehl, '13%-02.2d%-2.2d', [GerNr,FormLen]);
    BefLen := StrLen(Befehl);
    Start(Befehl, BefLen);
  end;
  DruckBlock.Assign(ABlock);
  {DruckIndex := 0;
  if DruckIndex+1 < DruckBlock.Count then
  begin
    StrFmt(Befehl, '1201%s', [DruckBlock.Strings[DruckIndex]]);
    BefLen := StrLen(Befehl);
    Inc(DruckIndex);
    SMess('Drucke Zeile %d',[DruckIndex]);
    DruckId := Start(Befehl, BefLen);
    Result := DruckId;
  end;}
  DruckIndex  := 0;
  for I:= DruckBlock.Count-1 downto 1 do with DruckBlock do      {Komprimieren}
  begin
    if (length(Strings[I-1]) + length(Strings[I]) <= 120) and
       (Pos('<', Strings[I-1]) = 0) and (Pos('<', Strings[I]) = 0) then
    begin
      Strings[I-1] := Format('%s'+#$A+'%s', [Strings[I-1], Strings[I]]);
      Delete(I);
    end;
  end;
  for I:= 0 to DruckBlock.Count-1 do
  begin
    StrFmt(Befehl, '12%-02.2d%s', [GerNr,DruckBlock.Strings[I]]);
    BefLen := StrLen(Befehl);
    AnsiToOem(Befehl, Befehl);
    Start(Befehl, BefLen);
  end;
  (* Formularvorschub *)
  if FormLen > 0 then
  begin
    StrFmt(Befehl, '14%-02.2d', [GerNr]);
    BefLen := StrLen(Befehl);
    Start(Befehl, BefLen);
  end;
end;

procedure TRow7Kmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
  GerNrStr: array[0..2] of AnsiChar;
begin
  if Uppercase(FnkName) = 'ROWGERNR' then
  begin
    if Polling then
    begin
      StrFmt(GerNrStr, '%-02.2d', [GerNr]);
      ComPort.Write(GerNrStr, 2);
    end;
  end else
  if Uppercase(FnkName) = 'ROWBCC' then
  begin
    if Bcc then
    begin
      BccCh := 0;
      for I:= 0 to ATel.OutDataLen-1 do
        BccCh := BccCh xor ord(ATel.OutData[I]);
      BccCh := BccCh xor DLE;   {^P}
      BccCh := BccCh xor ETX;   {^C}
      ComPort.Write(Addr(BccCh), 1);
    end;
  end else
    inherited UserFnk(ATel, FnkName);
end;

{Befehl 30, RT1.04: Grenzwerte setzen }
Function TRow7Kmp.SetGW(GWBrutto, GWNetto: Integer): LongInt;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '30%-02.2d%-05.5d%-05.5d', [GerNr, GWBrutto, GWNetto]);
  BefLen := StrLen(Befehl);
  GWId := Start(Befehl, BefLen);
  Result := GWId;
end;

{Befehl 20, RT1.04: Tarieren }
Function TRow7Kmp.Tariere: LongInt;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
Begin
  StrFmt(Befehl, '20%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  SetTaraId := Start(Befehl, BefLen);
  Result := SetTaraId;
End;

{Befehl 21, RT1.04: Tara löschen }
Function TRow7Kmp.DelTara: LongInt;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
Begin
  StrFmt(Befehl, '21%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  DelTaraId := Start(Befehl, BefLen);
  Result := DelTaraId;
End;

function TRow7Kmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
  tempID: longint;
  ATel: TTel;
begin
  StrFmt(Befehl, 'F0%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  tempId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);

  // Telegramm kürzen, keine Antwort
  ATel := GetTel(tempId);
  ATel.Description.Clear;
  ATel.Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  if ComPort <> nil then
    ATel.Description.Add(Format('T:%d',[ComPort.TimeOut])) else
    ATel.Description.Add('T:7000');
  ATel.Description.Add('S:^B[ROWGERNR]');
  ATel.Description.Add('W:^P');
  if Polling then
    ATel.Description.Add('W:2');
  ATel.Description.Add('B:');
  ATel.Description.Add('S:^P^C');
  ATel.Description.Add('S:[ROWBCC]');
  ATel.Description.Add('W:^P');
  if Polling then
    ATel.Description.Add('W:2');

  {// Status abrufen, zur Überprüfung
  StrFmt(Befehl, '00%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  NullstellenId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := NullstellenId;
  }
  // Protokolldruck durchführen, Status abrufen, zur Überprüfung
  StrFmt(Befehl, '01%-02.2d', [GerNr]);
  BefLen := StrLen(Befehl);
  NullstellenId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := NullstellenId;
end;

end.
