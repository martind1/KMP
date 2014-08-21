unit Ro8_3964Kmp;
(* Rowa8 3964R Protokoll mit bis zu 6 Waagen pro Datensatz
   17.01.05 TS erstellt (von Ro8EnqKmp)
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Math,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

const
  Ro8MaxWaagen = 6;
  Ro8MaxDigit = 7;

  MaxRepeatsSollwert = 3;   // Max. Versuche, einen Sollwert zu übertragen

type
  TWaagenRec = record
    Fehlercode: byte;
    Statuscode: byte;
    Status: TFaWaStatus;
    Gewicht: double;
    Dimension: string;
  end;

  TSollwert = record
    ID: Integer;
    repeatCnt: Integer;
    swAusgang: Integer;
    swKanal: Integer;
    swRichtung: AnsiChar;
    swFreigabe: AnsiChar;
    swNetto: AnsiChar;
    swSollUnten: Integer;
    swSollOben: Integer;
  end;
  PTSollWert = ^TSollwert;

  TWaagenRecArray = array[ 1..Ro8MaxWaagen ] of TWaagenRec;

type
  TRow8Digital = array [1..Ro8MaxDigit] of Boolean;

  TRowa8DigitalEvent = procedure(ATelId: longint;
    Inputs: TRow8Digital; AStatus: TFaWaStatus) of object;
  TRowa8SollwertEvent = procedure(ATelId: longint;
    SollWerte: TSollwert; AStatus: TFaWaStatus) of object;

  TRo8_3964 = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    readInputsId : Integer;
    readOutputsId : Integer;
    SetSollWertID : Integer;
    SollWertList: TList;
    RestartCntr: Integer;
    FSimWindow: Boolean;    // bei Simulation Fenster öffnen
    function IdIsSollID(id: Integer): boolean;
    {Prüft, ob die Übergebene ID in der Sollwertliste gespeichert ist}
    procedure GetSollRecByID(id: Integer; var SollRec: TSollwert);
    {liest Daten des Sollwertdatensatzes mit ID und löscht diesen aus Liste}
    procedure _SetzeSollwert(aAusgang, aKanal: Integer;
                             aRichtung, aFreigabe, aNetto: AnsiChar;
                             su, so, aRepeatCnt: Integer);
    procedure SetzeSollwertWork(Ausgang, Kanal: Integer;
                                Richtung, Freigabe, Netto: Boolean;
                                SollUnten, SollOben : Double);
  protected
    { Protected-Deklarationen }
    FOnInputs : TRowa8DigitalEvent;
    FOnOutputs : TRowa8DigitalEvent;
    FOnSetSollwert : TRowa8SollwertEvent;
    DescKurz, DescNorm : TStringList;
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    AnzahlWaagen: integer;
    Waage: TWaagenRecArray;
    Inputs: TRow8Digital;
    Outputs: TRow8Digital;
    Antwort: PAnsiChar;
    AntwLen: integer;
    Nks : array[1..Ro8MaxWaagen] of Integer;    // Nachkomma für einzelne Kanäle
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function HoleEingaenge: Longint;
    function HoleAusgaenge: Longint;
    function SetzeAusgang(Ausgang: Integer; Value: Boolean): longint; override;
    procedure SetzeSollwert(Ausgang, Kanal: Integer;
                            Richtung, Freigabe, Netto: Boolean;
                            SollUnten, SollOben : Double);
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;

    procedure ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
    procedure StatusToWaStat(Statuscode: integer; var Status: TFaWaStatus);
    function ResetOutChannels(msk: Integer): Boolean;
    {Rücksetzen der Ausgänge, damit Ausschalten der Sollwerte}
    procedure Restart;
  published
    { Published-Deklarationen }
    property SimWindow: Boolean read FSimWindow write FSimWindow;
    property OnInputs : TRowa8DigitalEvent read FOnInputs write FOnInputs;
    property OnOutputs : TRowa8DigitalEvent read FOnOutputs write FOnOutputs;
    property OnSetSollwert : TRowa8SollwertEvent read FOnSetSollwert write FOnSetSollwert;
  end;

implementation

uses
  Prots, CPor_Kmp, Err__Kmp, KmpResString, Ro8_3964Simul;
(*** Initialisierung *********************************************************)

procedure TRo8_3964.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  DescKurz.Clear;
  DescNorm.Clear;

{  if ComPort <> nil then
    Description.Add(Format('T:%d',[ComPort.TimeOut]))
  else
    Description.Add('T:7000');}
  Description.Add('S:^B');         // -> STX
  Description.Add('W:^P');         // <- DLE
  Description.Add('B:');
  Description.Add('S:^P^C');       // -> DLE ETX
  Description.Add('W:^P');         // <- DLE
  DescKurz.Assign(Description);    // ohne Antwort

  Description.Add('W:^B');         // <- STX
  Description.Add('S:^P');         // -> DLE
  Description.Add('A:255,^P,^C');  // <- DLE ETX
  Description.Add('S:^P');         // -> DLE
  DescNorm.Assign(Description);  // Zwischenspeichern
end;

constructor TRo8_3964.Create(AOwner: TComponent);
var i : Integer;
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  DescKurz := TStringList.Create;
  DescNorm := TStringList.Create;
  SollWertList := TList.Create;
  readInputsId := -1;
  readOutputsId := -1;
  RestartCntr := 0;
  for i := 1 to Ro8MaxWaagen do nks[i] := 0;    // Nachkomma für einzelne Kanäle
end;

procedure TRo8_3964.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TRo8_3964.Destroy;
begin
  if DlgRo8Simul <> nil then
    DlgRo8Simul.Release;
  StrDispose(Antwort);
  Antwort := nil;
  DescKurz.Free;
  DescNorm.Free;
  SollWertList.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TRo8_3964.Init;
begin
  inherited Init;
end;

(*** Interne Methoden *******************************************************)

procedure TRo8_3964.ErrorToWaStat(Error: integer; var Status: TFaWaStatus);
begin
  case Error of
    $40 : Include(Status, fwsGewichtOK);
    $41 : Include(Status, fwsUeberlast);
    $42, $44, $60 : Include(Status, fwsWaagenstoerung);
  end;
end;

procedure TRo8_3964.StatusToWaStat(Statuscode: integer; var Status: TFaWaStatus);
begin
  if Statuscode <> $41 then
  begin
    Include(Status, fwsKeinStillstand);
    Exclude(Status, fwsGewichtOK);
  end;
  if Statuscode in [$42, $44] then
    Include(Status, fwsNull);
end;

function TRo8_3964.ResetOutChannels(msk: Integer): Boolean;
{Rücksetzen der Ausgänge, damit Ausschalten der Sollwerte}
var i : integer;
begin
  Result := True;
  for i := 1 to Ro8MaxDigit do
    if ISBITSET(msk, i) then
      SetzeAusgang(i, False);  
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TRo8_3964.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L, i1 : integer;
  dig : AnsiChar;
  ATel : TTel;
  Offs: integer;
  OldDecimalSeparator, OldThousandSeparator: Char;
  tmpGewicht : Double;
  SollWert: TSollWert;
  {Vorz: string;}
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

    if ATel.Status = cpsOK then RestartCntr := 0;      // Reset
    {Antwort auf Befehl Status}
    OldDecimalSeparator := FormatSettings.DecimalSeparator;
    OldThousandSeparator := FormatSettings.ThousandSeparator;
    if Tel_Id = StatusId then
    try
      StatusId := -1;
      if ATel.Status = cpsOK then
      try
        AnzahlWaagen := StrToIntTol(StrLPas(EmpfBuff+2, 1));
        //Offs := 3;
        Gewicht := 0;
        for I1 := 1 to AnzahlWaagen do
        begin
          Offs := (I1-1)*11 + 3;
          Waage[I1].Status := [];
          Waage[I1].FehlerCode := Ord(EmpfBuff[Offs]);
          Waage[I1].StatusCode := Ord(EmpfBuff[Offs+1]);
          {Vorz := StrLPas(EmpfBuff+ Offs +2, 1);}
          FormatSettings.DecimalSeparator := ',';        {wegen Siemens-Bangkok, engl. W2000}
          FormatSettings.ThousandSeparator := '.';
          tmpGewicht := StrToFloatTol(String(StrLPas(EmpfBuff+ Offs +2, 7)));
          FormatSettings.DecimalSeparator := OldDecimalSeparator;
          FormatSettings.ThousandSeparator := OldThousandSeparator;
          Waage[I1].Gewicht := tmpGewicht;
          {if Vorz = '-' then
            Waage[I1].Gewicht := -Waage[I1].Gewicht;}
          Waage[I1].Dimension := String(StrLPas(EmpfBuff+ Offs +9, 2));
          Gewicht := Gewicht + Waage[I1].Gewicht;
          ErrorToWaStat(Waage[I1].Fehlercode, Waage[I1].Status);
          StatusToWaStat(Waage[I1].StatusCode, Waage[I1].Status);
        end;
        FormatSettings.DecimalSeparator := OldDecimalSeparator;
        FormatSettings.ThousandSeparator := OldThousandSeparator;
        GewichtToStr(Gewicht, Display);
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('%s',[E.Message]);
        end;
      end else
      begin
        Restart;
        Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      end;
    finally
      FormatSettings.DecimalSeparator := OldDecimalSeparator;
      FormatSettings.ThousandSeparator := OldThousandSeparator;
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    // Eingänge lesen
    if Tel_Id = readInputsId then
      try
        readInputsId := -1;
        FaWaStatus := [];
        if ATel.Status = cpsOK then
        try
          Offs := 1;
          for i1 := 1 to Ro8MaxDigit do
          begin
            dig := EmpfBuff[Offs + i1];
            if (dig = '0') or (dig = '1') then Inputs[i1] := (dig = '1')
            else begin
              Include(FaWaStatus, fwsWaagenstoerung);
              Inputs[i1] := False;
            end;
          end;
        except
          on E:Exception do
          begin
            Display := E.Message;
            Prot0('%s',[E.Message]);
          end;
        end else
          Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      finally
        if assigned(FOnInputs) then
          FOnInputs(Tel_Id, Inputs, FaWaStatus);
      end
    else
    // Ausgänge lesen
    if Tel_Id = readOutputsId then
      try
        readOutputsId := -1;
        FaWaStatus := [];
        if ATel.Status = cpsOK then
        try
          Offs := 1;
          for i1 := 1 to Ro8MaxDigit do
          begin
            dig := EmpfBuff[Offs + i1];
            if (dig = '0') or (dig = '1') then Outputs[i1] := (dig = '1')
            else begin
              Include(FaWaStatus, fwsWaagenstoerung);
              Outputs[i1] := False;
            end;
          end;
        except
          on E:Exception do
          begin
            Display := E.Message;
            Prot0('%s',[E.Message]);
          end;
        end else
          Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
      finally
        if assigned(FOnOutputs) then
          FOnOutputs(Tel_Id, Outputs, FaWaStatus);
      end
    else

    if IdIsSollID(Tel_Id) then
    try
      FaWaStatus := [];
      GetSollRecByID(Tel_Id, SollWert);
      {Wenn Status nicht OK, dann prüfen, ob wiederholt gesendet werden soll}
      if ATel.Status <> cpsOK then
      with Sollwert do
      begin
        if repeatCnt < MaxRepeatsSollwert then
        begin
          Restart;
          Inc(repeatCnt);
          _SetzeSollwert(swAusgang, swKanal, swRichtung, swFreigabe, swNetto,
                         swSollUnten, swSollOben, repeatCnt);
        end
        else begin
          Include(FaWaStatus, fwsWaagenstoerung);
          //WMessErr(SRo8_3964Kmp_001, [0]);
          if assigned(FOnSetSollwert) then
            FOnSetSollwert(Tel_ID, SollWert, FaWaStatus);
        end;
      end
      else begin
        Include(FaWaStatus, fwsGewichtOk);
        if assigned(FOnSetSollwert) then
          FOnSetSollwert(Tel_ID, SollWert, FaWaStatus);
      end;
    except
    end;
  end;
end;

function TRo8_3964.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  {ToDo: TS: Prüfen, ob Status der Ein/Ausgänge hier gelesen werden sollte}
  // if readInputsId = -1 then HoleEingaenge;
  // if readOutputsId = -1 then HoleAusgaenge;
  StrFmt(Befehl, '01', [0]);
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TRo8_3964.HoleEingaenge: Longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '33', [0]);
  BefLen := StrLen(Befehl);
  readInputsId := Start(Befehl, BefLen);
  Result := readInputsId;
end;

function TRo8_3964.HoleAusgaenge: Longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '31', [0]);
  BefLen := StrLen(Befehl);
  readOutputsId := Start(Befehl, BefLen);
  Result := readOutputsId;
end;

function TRo8_3964.SetzeAusgang(Ausgang: Integer; Value: Boolean): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Result := -1;
  if Ausgang > Ro8MaxDigit then
    Exit;

  Description.Assign(DescKurz);
  if Value then
    StrFmt(Befehl, '32%d1', [Ausgang])
  else StrFmt(Befehl, '32%d0', [Ausgang]);
  BefLen := StrLen(Befehl);
  SetzeAusgangID := Start(Befehl, BefLen);
  Description.Assign(DescNorm);           // wieder normale
  HoleAusgaenge;
  Result := SetzeAusgangID;
end;

procedure TRo8_3964._SetzeSollwert(aAusgang, aKanal: Integer;
                                   aRichtung, aFreigabe, aNetto: AnsiChar;
                                   su, so, aRepeatCnt: Integer);
{RepeatCnt ist für die automatische Wiederholung gedacht,
 RepeatCnt ist beim ersten Aufruf immer 0}
var
  Befehl : array[0..200] of AnsiChar;
  BefLen : Integer;
  PSollwert: PTSollwert;
begin
  PSollwert := New(PTSollwert);
  with PSollwert^ do
  begin
    repeatCnt := aRepeatCnt;
    swAusgang := aAusgang;
    swKanal := aKanal;
    swRichtung := aRichtung;
    swFreigabe := aFreigabe;
    swNetto := aNetto;
    swSollUnten := su;
    swSollOben := so;
  end;

  //md06.07.05 ComWait;
  //md06.07.05 Description.Assign(DescKurz);
  StrFmt(Befehl, '30%d0', [aAusgang]);
  StrFmt(Befehl, '30%d%d%s%s%s%-06.6d%-06.6d',
    [aAusgang, aKanal, aRichtung, aNetto, aFreigabe, su, so]);
  BefLen := StrLen(Befehl);
  SetSollWertID := Start(Befehl, BefLen);
  GetTel(SetSollWertID).Description.Assign(DescKurz);  //md06.07.05
  PSollwert^.ID := SetSollWertID;
  SollWertList.Add(PSollwert);
  //md06.07.05 Description.Assign(DescNorm);           // wieder normale
end;

procedure TRo8_3964.SetzeSollwert(Ausgang, Kanal: Integer;
                                  Richtung, Freigabe, Netto: Boolean;
                                  SollUnten, SollOben : Double);
begin
  // Wegen ROWA8-Problem Sollwerte 2x senden ??
  SetzeSollwertWork(Ausgang, Kanal, Richtung, Freigabe, Netto, SollUnten, SollOben);
end;

procedure TRo8_3964.SetzeSollwertWork(Ausgang, Kanal: Integer;
                                      Richtung, Freigabe, Netto: Boolean;
                                      SollUnten, SollOben : Double);
var su, so, nkKanal: Integer;
    cRichtung, cFreigabe, cNetto: AnsiChar;

begin
  if Ausgang > Ro8MaxDigit then
    Exit;
  if Kanal > Ro8MaxWaagen then
    Exit;

  nkKanal := Nks[Kanal];
  if SollUnten <> 0 then
  begin
    su := FloatToIntTolNk(SollUnten, nkKanal, nkKanal);
    if su = 0 then            // Fehler bei FloatToIntTolNk
      Exit;
  end
  else su := 0;
  if SollOben <> 0 then
  begin
    so := FloatToIntTolNk(SollOben, nkKanal, nkKanal);
    if so = 0 then            // Fehler bei FloatToIntTolNk
      Exit;
  end
  else so := 0;

  cRichtung := '0';
  cFreigabe := '0';
  cNetto := '0';
  if Richtung then cRichtung := '1';
  if Freigabe then cFreigabe := '1';
  if Netto then cNetto := '1';

  _SetzeSollwert(Ausgang, Kanal, cRichtung, cFreigabe, cNetto, su, so, 0);
end;

function TRo8_3964.IdIsSollID(id: Integer): boolean;
{Prüft, ob ide Übergebene ID in der Sollwertliste gespeichert ist}
var i : Integer;
    PSollwert : PTSollwert;
begin
  Result := False;
  for i := 0 to (SollWertList.Count-1) do
  begin
    PSollwert := PTSollwert(SollWertList.Items[i]);
    if PSollwert <> nil then
      if PSollwert^.ID = id then
      begin
        Result := True;
        Break;
      end;
  end;
end;

procedure TRo8_3964.GetSollRecByID(id: Integer; var SollRec: TSollwert);
{liest Daten des Sollwertdatensatzes mit ID und löscht diesen aus Liste}
var i : Integer;
    PSollwert : PTSollwert;
begin
  for i := 0 to (SollWertList.Count-1) do
  begin
    PSollwert := PTSollwert(SollWertList.Items[i]);
    if PSollwert <> nil then
      if PSollwert^.ID = id then
      begin
        SollRec.ID := PSollwert^.ID;
        SollRec.repeatCnt := PSollwert^.repeatCnt;
        SollRec.swAusgang := PSollwert^.swAusgang;
        SollRec.swKanal := PSollwert^.swKanal;
        SollRec.swRichtung := PSollwert^.swRichtung;
        SollRec.swFreigabe := PSollwert^.swFreigabe;
        SollRec.swNetto := PSollwert^.swNetto;
        SollRec.swSollUnten := PSollwert^.swSollUnten;
        SollRec.swSollOben := PSollwert^.swSollOben;
        SollWertList.Delete(i);
        Break;
      end;
  end;
end;

procedure TRo8_3964.Restart;
var
  Str: array[0..20] of AnsiChar;
begin
  if RestartCntr < 2 then
  begin
    Inc(RestartCntr);
    Str[0] := chr(DLE);
    ComWrite(Str, 1);                       {DLE ausgeben}
  end;
end;

procedure TRo8_3964.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
begin
  StrCopy(ATel.InData, '');
  if FSimWindow then
  begin
    if DlgRo8Simul = nil then
      TDlgRo8Simul.Execute(Application);
    if Assigned(DlgRo8Simul) then
      with DlgRo8Simul do
      begin
        StrFmt(ATel.InData, '01%d%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI',
            [6, AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[1]),
                AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[2]),
                AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[3]),
                AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[4]),
                AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[5]),
                AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr(SimGewichte[6])
            ]);
      end;
  end
  else begin
    StrFmt(ATel.InData, '%d%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI',
        [6, AnsiChar(ord($40)), AnsiChar(ord($41)), FloatToStr((SimGewicht + 1000) / 1000),
            AnsiChar(ord($41)), AnsiChar(ord($42)), FloatToStr((SimGewicht + 2000) / 1000),
            AnsiChar(ord($42)), AnsiChar(ord($44)), FloatToStr((SimGewicht + 3000) / 1000),
            AnsiChar(ord($44)), AnsiChar(ord($48)), FloatToStr((SimGewicht + 4000) / 1000),
            AnsiChar(ord($60)), AnsiChar(ord($50)), FloatToStr((SimGewicht + 4000) / 1000),
            AnsiChar(ord($01)), AnsiChar(ord($01)), FloatToStr((SimGewicht + 4000) / 1000)
        ]);
    StrFmt(ATel.InData, '%d%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI%s%s%7.7sDI',
        [6, AnsiChar(ord($40)), AnsiChar(ord($41)), FloatToStr(SimGewicht * 5 / 60000),
            AnsiChar(ord($41)), AnsiChar(ord($42)), FloatToStr(SimGewicht * 9 / 60000),
            AnsiChar(ord($42)), AnsiChar(ord($44)), FloatToStr(SimGewicht *10 / 60000),
            AnsiChar(ord($44)), AnsiChar(ord($48)), FloatToStr(SimGewicht *10 / 60000),
            AnsiChar(ord($60)), AnsiChar(ord($50)), FloatToStr(SimGewicht *11 / 60000),
            AnsiChar(ord($00)), AnsiChar(ord($00)), FloatToStr(SimGewicht *15 / 60000)
        ]);
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
