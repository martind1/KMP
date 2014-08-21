unit wt65_kmp;
(* Fahrzeugwaage Widra WT 65-1
   22.06.99 MD Erstellt
   21.10.02 TS ROWA7-Anpassung
   14.01.03 TS Umschalten Waage (PS-Befehl)
*)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TWT65Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FMessNr: integer;                {Messverstärker Nr}
    FcanSwitchMess: Boolean;         {Umschaltung Messverstärker möglich}
    FProtNrVonWaage: Boolean;        {Waage schickt im Gewichtsstring die ProtNr}
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    WiTyp: AnsiChar;           {B oder N}
    Stoer : AnsiChar;
    WaGE: string[3];
    SxRunning: boolean;
    ExId, SwitchMessId: longint;
    IsRowa7 : Boolean;
    Antwort: PAnsiChar;
    AntwLen: integer;
    FNkMess2 : Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Quittieren: longint; override;
    function DruckeBlock(ABlock: TStrings): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function DelSpNr(SpNr: integer): longint; override;
    procedure StartEx;
    function SwitchMessNr(AMessNr: integer): longint; override;
  published
    { Published-Deklarationen }
    property MessNr: Integer read FMessNr;
    property canSwitchMess: Boolean read FcanSwitchMess write FcanSwitchMess;
    property ProtNrVonWaage: Boolean read FProtNrVonWaage write FProtNrVonWaage;
    property NkMess2: Integer read FNkMess2 write FNkMess2;
  end;

implementation

uses
  Err__Kmp, Prots, NStr_Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

procedure TWT65Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('B:');
  Description.Add('S:^M');
  Description.Add('A:255,^M,^J');
end;

constructor TWT65Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  IsRowa7 := False;
  FMessNr := 1;
  canSwitchMess := False;
end;

procedure TWT65Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TWT65Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TWT65Kmp.Init;
begin
  inherited Init;
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TWT65Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  Empf: array[0..255] of AnsiChar;
  L, offset : integer;
  S1 : string;
  cpStatus: TComProtStatus;
  NachKomma : Integer;
begin
  inherited DoAntwort(Sender, Tel_Id);
  FaWaStatus := [];
  L := sizeof(Empf) - 1;
  cpStatus := GetData(Tel_Id, Empf, L);
  Empf[L] := #0;

  if Tel_Id = StatusId then
  try
    StatusId := -1;
    if Empf[0] <> AnsiChar(STX) then
    begin
      {keine Aktion}
    end
    else if cpStatus = cpsOK then
    try
      // Waagennummer bei Waagen mit Umschaltung
      if canSwitchMess and (FMessNr <> StrToInt(String(Empf[12]))) then
      begin
        FMessNr := StrToInt(String(Empf[12]));
        FaWaStatus := [fwsWaagenNr];
        Display := 'WaNr';
        Gewicht := 0;
      end;

      S1 := String(StrLPas(Empf + 1, 8));
      Gewicht := StrToFloatTol(S1);
      case Empf[9] of
        'G': WaGE := 'g';
        'K': WaGE := 'kg';
        'T': WaGE := 't';
        else WaGE := Empf[9];
      end;
      if (Upcase(char1(GE)) = 'T') and (WaGE = 'kg') then
        Gewicht := Gewicht / 1000;
      case Empf[10] of
        'G': WiTyp := 'B';
        'N': WiTyp := 'N';
      else   WiTyp := Empf[10];
      end;
      case Empf[11] of
        ' ': begin
               Stoer := ' ';
             end;
        'M': begin
               Stoer := 'M';
               FaWaStatus := [fwsKeinStillStand];
             end;
        'O': begin
               Stoer := 'O';
               FaWaStatus := [fwsBereichsfehler];
             end;
        else Stoer := Empf[11];
      end;
      FaWaStatus := FaWaStatus + [fwsGewichtOK];
      Display := Trim(String(StrLPas(Empf + 1, 8)));
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s',[E.Message]);
      end;
    end else
      Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
  finally
    if assigned(FOnStatus) then
      FOnStatus(Tel_Id, Gewicht, FaWaStatus);
  end else

  if (Tel_Id = ProtGewichtId) then
  try     (* Gewicht eichfähig holen und Protokolldruck *)
    ProtGewichtId := -1;
    FaWaStatus := [];
    if cpStatus = cpsOK then
    try
      // Rowa7 schickt kein führendes STX
      if IsROWA7 then Offset := 0 else Offset := 1;

      // Waagennummer bei Waagen mit Umschaltung
      if canSwitchMess and (FMessNr <> StrToInt(String(Empf[9 + offset]))) then
      begin
        FMessNr := StrToInt(String(Empf[9 + offset]));
        FaWaStatus := [fwsWaagenNr];
        Display := 'WaNr';
        Gewicht := 0;
      end;

      NachKomma := Nk;
      if canSwitchMess and (FMessNr = 2) then
        NachKomma := FNkMess2;
      if NachKomma < 0  then NachKomma := -NachKomma;

      if Empf[8+offset] = ' ' then
      begin
        // Gewicht := StrToFloatTol(StrLPas(Empf + offset, 8))
        S1 := StringReplace(String(StrLPas(Empf + offset, 8)), '.', ',', []);
        Gewicht := StrToFloatTol(S1);
      end else
      begin
        // Gewicht := StrToFloatTol(StrLPas(Empf + offset, 9))
        S1 := StringReplace(String(StrLPas(Empf + offset, 8)), '.', ',', []);
        Gewicht := StrToFloatTol(String(StrLPas(Empf + offset, 9)));
      end;
      Display := Format('%.*f', [NachKomma, Gewicht]);

      Stoer := ' ';
      // wenn ProtNr im Antwortstring enthalten
      if ProtNrVonWaage then
      begin
         ProtNr := StrToIntTol(StrLPas(Empf + 13 + offset, 5));
      end;

      // Stillstandsflag
      if Ord(Empf[19 + offset]) and 1 = 0 then
      begin
        FaWaStatus := [fwsKeinStillStand];
        Stoer := 'O';
      end;
      // Gewichtseinheit
      case Empf[20 + offset] of
        '1': WaGE := 'g';
        '0': WaGE := 'kg';
        '3': WaGE := 't';
        else WaGE := Empf[20 + offset];
      end;
      if (Upcase(char1(GE)) = 'T') and (WaGE = 'kg') then
        Gewicht := Gewicht / 1000;
      if FaWaStatus = [] then
        FaWaStatus := [fwsGewichtOK];
      Include(FaWaStatus, fwsProtNr);  // immer, da entwed. Waage oder GenProt
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s',[E.Message]);
      end;
    end else
      Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
  finally
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
  end else

  if (Tel_Id = DruckId) then
  try
    (* 12: Drucke Zeile bzw. Block *)
    DruckId := -1;
    FaWaStatus := [];
    try
      if cpStatus = cpsOK then
      begin
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

  if (Tel_Id = ExId) then
  begin
    ExId := -1;
    Delay(400);              {Waage Zeit lassen zum Antworten}
    ClearInput;
  end else

  if (Tel_Id = SwitchMessId) then
  begin
    // keine Aktion, Waage sendet immer OK<CRLF>
    SwitchMessId := -1;
    ClearInput;
  end;
end;

procedure TWT65Kmp.StartEx;
begin                          {unterbricht fortlaufende Übertragung}
// T.S. EX immer senden
//  if SxRunning then begin
    SxRunning := false;
    ExId := Start('EX', 2);
end;

function TWT65Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
  NextS, S1: string;
  Teil1, Teil2 : array[0..100] of AnsiChar;
  Teil1Len, Teil2Len : integer;
  (* wenn eichf. Gewicht auf Drucker:
     1. PA + Beizeichen 1.Teil
     2. PG druckt und ergibt Gewicht                  ProtGewichtId
     3. PA + Beizeichen 2. Teil (wenn vorhanden)
        PE für Zeilenvorschub
     wenn eichf. Gewicht im RAM gespeichert:
     wenn Nicht ProtNrVonWaage
     1. neue ProtNr erzeugen
     2. PA + ProtNr
     3. PG ergibt Gewicht                             ProtGewichtId
  *)
begin
  StartEx;                  {unterbricht fortlaufende Übertragung}
  ProtZeile1 := PStrTok(Beizeichen, '<', NextS);
  S1 := PStrTok(Beizeichen, '>', NextS);               {Platzhalter}
  ProtZeile2 := NextS;
  if not ProtNrVonWaage then
    GenProtNr;                                         {nächste ProtNr}
  if ProtDruck then                                    {Waage mit Drucker}
  begin
    if ProtZeile1 <> '' then
    begin
      {>JP 19.03.2001 ProtNr => 9stellig, kompatibel mit Protokollspeicher}
      ProtZeile1 := StrCgeStrStr(ProtZeile1, '#N',
        Format('%9.9d', [ProtNr]), false);
      {<JP 19.03.2001}
      ProtZeile1 := StrCgeStrStr(ProtZeile1, '#G',
        Format('%2.2d', [GerNr]), false);
      StrFmt(Befehl, 'PA%s', [ProtZeile1]);
      BefLen := StrLen(Befehl);
      {>JP 19.03.2001 WT65 kann max. 45 Zeichen mit einem PA-Befehl drucken}
      if BefLen > 40 then begin
        StrFmt(Teil1, 'PA%s', [copy(ProtZeile1,1,40)]);
        Teil1Len := StrLen(Teil1);
        StrFmt(Teil2, 'PA%s', [copy(ProtZeile1,41,BefLen-Teil1Len)]);
        Teil2Len := StrLen(Teil2);
        Start(Teil1, Teil1Len);
        Start(Teil2, Teil2Len);
      end
      {<JP 19.03.2001}
      else begin
        BefLen := StrLen(Befehl);
        Start(Befehl, BefLen);
      end;
    end;
    StrFmt(Befehl, 'PG', [0]);
    BefLen := StrLen(Befehl);
    ProtGewichtId := Start(Befehl, BefLen);
    if ProtZeile2 <> '' then
    begin
      ProtZeile2 := StrCgeStrStr(ProtZeile2, '#N',
        Format('%6.6d>', [ProtNr]), false);
      ProtZeile2 := StrCgeStrStr(ProtZeile2, '#G',
        Format('%2.2d>', [GerNr]), false);
      StrFmt(Befehl, 'PA%s', [ProtZeile2]);
      BefLen := StrLen(Befehl);
      Start(Befehl, BefLen);
    end;
    StrFmt(Befehl, 'PE', [0]);
    BefLen := StrLen(Befehl);
    Start(Befehl, BefLen);
  end else
  begin
    {ProtNrVonWaage = True: Waage schickt ProtNr im Gewichststring mit,
     PA-Befehl kann entfallen}
    if not ProtNrVonWaage then   {Waage schickt mit Gewicht keine ProtNr: PA notwendig}
    begin
      StrFmt(Befehl, 'PA%9.9d', [ProtNr]);        {neue ProtNr}
      BefLen := StrLen(Befehl);
      Start(Befehl, BefLen);
    end;
    StrFmt(Befehl, 'PG', [0]);
    BefLen := StrLen(Befehl);
    ProtGewichtId := Start(Befehl, BefLen);
  end;
  Result := ProtGewichtId;
end;

function TWT65Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  SxRunning := true;
  StrFmt(Befehl, 'SX', [0]);
  BefLen := StrLen(Befehl);
  StatusId := StartFlags(Befehl, BefLen, [cpfPoll, cpfCache], '', 0);
  Result := StatusId;
end;

function TWT65Kmp.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TWT65Kmp.Quittieren: longint;
begin
  Result := -1;
end;

function TWT65Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StartEx;                  {unterbricht fortlaufende Übertragung}
  StrFmt(Befehl, 'PA%s', [Zeile]);
  BefLen := StrLen(Befehl);
  AnsiToOem(Befehl, Befehl);
  DruckID := Start(Befehl, BefLen);
  Result := DruckID;
  StrFmt(Befehl, 'PE', [0]);                {FormFeed}
  BefLen := StrLen(Befehl);
  Start(Befehl, BefLen);
end;

function TWT65Kmp.DruckeBlock(ABlock: TStrings): longint;
var
  I: integer;
begin
  StartEx;                  {unterbricht fortlaufende Übertragung}
  Result := -1;
  for I := 0 to ABlock.Count - 1 do
  begin
    Zeilendruck(ABlock.Strings[I]);
  end;
end;

function TWT65Kmp.SwitchMessNr(AMessNr: integer): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Result := -1;
  if not(canSwitchMess) or (AMessNr < 1) or (AMessNr > 9) then
    Exit;

  StartEx;                  {unterbricht fortlaufende Übertragung}
  FMessNr := AMessNr;
  StrFmt(Befehl, 'PS%d', [AMessNr]);
  BefLen := StrLen(Befehl);
  SwitchMessId := Start(Befehl, BefLen);
  Result := SwitchMessID;
end;

procedure TWT65Kmp.UserFnk(ATel: TTel; FnkName : string);
begin
  inherited UserFnk(ATel, FnkName);
end;

procedure TWT65Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: double;
  s: string;
  NachKomma : Integer;
  oldDecimalSeparator : Char;
begin
  oldDecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  Inc(SimProtNr);
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if Nk > 0 then
    Gew := Gew / Power(10, Nk) else
  if Nk < 0 then
    Gew := Gew * Power(10, Nk);
  SimStoer := Ord('1');
  (* if Gew < 0 then
    SimStoer := ord('O') else  {oh}
    SimStoer := ord(' '); *)
  if StrLComp(ATel.OutData, 'SX', 2) = 0 then
  begin
    NachKomma := Nk;
    try
      if canSwitchMess and (FMessNr = 2) then
        NachKomma := FNkMess2;
      if NachKomma < 0  then NachKomma := -NachKomma;
      s := Format('%s%08.*fKG ', [AnsiChar(STX), NachKomma, Gew]);

      if canSwitchMess then
        s := s + IntToStr(MessNr)
      else s := s + ' ';

      StrFmt(ATel.InData, '%s', [s]);
      {alte Version
      StrFmt(ATel.InData, '%s%08.*fKG%s',
        [STX, Gew, AnsiChar(SimStoer)]);}
    except on E:Exception do
      EMess(self, E, 'DoSimul PG: %s', [s]);
    end;
  end else
  if StrLComp(ATel.OutData, 'EX', 2) = 0 then
  begin
    StrFmt(ATel.InData, 'OK', [0]);
  end else
  if StrLComp(ATel.OutData, 'PA', 2) = 0 then
  begin
    StrFmt(ATel.InData, 'OK', [0]);
    SimProtNr := StrToIntTol(StrLPas(ATel.OutData + 2, 10));
  end else
  if StrLComp(ATel.OutData, 'PE', 2) = 0 then
  begin
    StrFmt(ATel.InData, 'OK', [0]);
  end else
  if StrLComp(ATel.OutData, 'PG', 2) = 0 then
  begin
    NachKomma := Nk;
    try
      if canSwitchMess and (FMessNr = 2) then
        NachKomma := FNkMess2;
      if NachKomma < 0  then NachKomma := -NachKomma;

      if canSwitchMess then
        s := Format('%s%08.*f ', [AnsiChar(STX), NachKomma, Gew])
      else
        s := Format('%s%09.*f', [AnsiChar(STX), NachKomma, Gew]);

      if canSwitchMess then
        s := s + IntToStr(MessNr)
      else s := s + ' ';
      s := s + '000';

      if ProtNrVonWaage then
        s := s + Format('%5.5d', [SimProtNr])
      else s := s + '     ';
      s := s + ' ';
      s := s + Format('%s0', [AnsiChar(SimStoer)]);
      StrFmt(ATel.InData, '%s', [s]);

      {alte Version
      StrFmt(ATel.InData, '%s%08.*fKG%s',
        [STX, Gew, AnsiChar(SimStoer)]);}
    except on E:Exception do
      EMess(self, E, 'DoSimul PG: %s', [s]);
    end;
  end else
  if StrLComp(ATel.OutData, 'PS', 2) = 0 then
  begin
    StrFmt(ATel.InData, 'OK', [0]);
  end;

  FormatSettings.DecimalSeparator := oldDecimalSeparator;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
