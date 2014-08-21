unit wt60_kmp;
(* Fahrzeugwaage Widra WT 65-1
   22.06.99 MD Erstellt
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
  TWT60Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FWaName: string;           {konstante Bez der Waage 'WAAGE'}
    FPcName: string;           {konstante Bez des PCs 'PCX01'}
  protected
    { Protected-Deklarationen }
    WdhlgId: longint;
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    WiTyp: AnsiChar;           {B oder N}
    Stoer : AnsiChar;
    WaGE: string[3];
    SxRunning: boolean;
    ExId: longint;

    Antwort: PAnsiChar;
    AntwLen: integer;
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
  published
    { Published-Deklarationen }
    property WaName: string read FWaName write FWaName;
    property PcName: string read FPcName write FPcName;
  end;

implementation

uses
  Prots, NStr_Kmp, CPor_Kmp;
(*** Initialisierung *********************************************************)

procedure TWT60Kmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('S:^E');
  Description.Add('W:^F');
  Description.Add('S:^B');
  Description.Add('S:[WT60PC]');
  Description.Add('S:[WT60WA]');
  Description.Add('B:');
  Description.Add('S:^C');
  Description.Add('S:[WT60BCC]');
  Description.Add('W:^F');
  Description.Add('S:^D');
  Description.Add(';Antwort:');
  Description.Add('W:^E');
  Description.Add('S:^F');
  Description.Add('W:^B');
  Description.Add('A:255,^C');
  Description.Add('W:2');
  Description.Add('S:^F');
  Description.Add('W:^D');

end;

constructor TWT60Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  WaName := 'WAAGE';
  PcName := 'PCX01';
end;

procedure TWT60Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TWT60Kmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TWT60Kmp.Init;
begin
  inherited Init;
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TWT60Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  Empf: array[0..255] of AnsiChar;
  L: integer;
  S1, GewStr: string;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
  cpStatus: TComProtStatus;
begin
  inherited DoAntwort(Sender, Tel_Id);
  FaWaStatus := [];
  L := sizeof(Empf) - 1;
  cpStatus := GetData(Tel_Id, Empf, L);
  Empf[L] := #0;

  if (Tel_Id = ProtGewichtId) or   (* Gewicht eichfähig holen und Protokolldruck *)
     (Tel_Id = WdhlgId) or
     (Tel_Id = StatusId) then
  try                                {Protdruck=false: von AFB ->in Rollspeicher}
    FaWaStatus := [];                {Protdruck=true: von PRB1 }
    if cpStatus = cpsOK then
    try
      {AFB und PRB:
      0    5    10   5    20   5    30   5    40   5    50   5    60   5    70
      wwwwwpppppOKYAFB dd.mm.yyhh:nn:ssnnnnnnnnnnnnnn+bbbbbbbbbbbbGSNN1BNNN1
      WAAGEPC01X.......................Lfd.Nr........Brutto.......__________}
      Stoer := ' ';
      if Empf[60] <> 'G' then
      begin
        FaWaStatus := FaWaStatus + [fwsWaagenstoerung];
        Stoer := Empf[60];
      end;
      if Empf[61] <> 'S' then
      begin
        FaWaStatus := FaWaStatus + [fwsKeinStillstand];
        Stoer := Empf[61];
      end;
      if Empf[62] <> 'N' then
      begin
        FaWaStatus := FaWaStatus + [fwsBereichsfehler];
        Stoer := Empf[62];          {o = Überlast}
      end;
      if Empf[63] <> 'N' then
      begin
        FaWaStatus := FaWaStatus + [fwsBereichsfehler];
        Stoer := Empf[63];          {U = Unterlast}
      end;
      GerNr := StrToIntTol(Empf[64]);
      WiTyp := Empf[65];
      {Tariert := StrToIntTol(Empf[66]) = 'T';}
      if Empf[67] <> 'N' then
      begin
        FaWaStatus := FaWaStatus + [fwsBereichsfehler];
        Stoer := Empf[67];          {4 = im Nullbereich}
      end;
      if Empf[68] <> 'N' then
      begin
        FaWaStatus := FaWaStatus + [fwsBereichsfehler];
        Stoer := Empf[68];          {0 = im eingeschränkten Nullbereich}
      end;
      FaWaStatus := FaWaStatus - [fwsBereichsfehler];

      GewStr := String(StrLPas(Empf + 47, 13));
      {StrToGewicht(GewStr, Gewicht);             {definiert NachK}
      StrToGewicht(StrCgeChar(GewStr, '.', #0), Gewicht);
      Gewicht := Gewicht / 1000;
      {StrToGewicht(StrCgeChar(GewStr, '.', DecimalSeparator), Gewicht);}
      Display := Format('%.*f', [NachK, Gewicht]);
      S1 := String(StrLPas(Empf + 34, 14));                 {LfNr: ergibt immer 0}
      {ProtNr := StrToIntTol(S1);  (wird beim Start generiert)}
      if (Upcase(char1(GE)) = 'T') and (UpperCase(String(WaGE)) = 'KG') then
        Gewicht := Gewicht / 1000;     {Waage:kg PC:to}
      if (Upcase(char1(WaGE)) = 'T') and (UpperCase(GE) = 'KG') then
        Gewicht := Gewicht * 1000;     {Waage:to PC:kg}
      if FaWaStatus = [] then
      begin
        FaWaStatus := [fwsGewichtOK];
        if Tel_Id = ProtGewichtId then
          if not ProtDruck then              {in Rollspeicher}
          begin
            StrFmt(Befehl, 'STA 021KTR\%09.9d\%6s\',
              [ProtNr, copy(GewStr, 8, 6)]);
            BefLen := StrLen(Befehl);
            Start(Befehl, BefLen);
          end;
      end;
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s:%s',[Name, E.Message]);
      end;
    end else
      Display := Format('%d:%s',[Comport.ErrorCode, Comport.ErrorStr]);
  finally
    if (Tel_Id = ProtGewichtId) or
       (Tel_Id = WdhlgId) then
    begin
      ProtGewichtId := -1;
      WdhlgId := -1;
      if fwsKeinStillstand in FaWaStatus then
      begin
        SMess('kein Stillstand', [0]);
        StrFmt(Befehl, 'PRB1000', [0]);             {Ergibt Gewichstdaten}
        BefLen := StrLen(Befehl);
        WdhlgId := StartFlags(Befehl, BefLen, [cpfPoll, cpfOnTop], '', 0);
      end else
      begin
        if assigned(FOnProtGewicht) then
          FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
      end;
    end else
    begin
      StatusId := -1;
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end;
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
  end;
end;

procedure TWT60Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: double;
  P1: PAnsiChar;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if Gew < 0 then
    SimStoer := ord('O') else  {oh}
    SimStoer := ord(' ');
  if (StrLComp(ATel.OutData, 'PRB1000', 7) = 0) or
     (StrLComp(ATel.OutData, 'AFB 000', 7) = 0) then
  begin
    StrFmt(ATel.InData, '%47s+%08.8d.000GSNN1BNNN1',
      [' ', round(Gew)]);
  end else
  if (StrLComp(ATel.OutData, 'PDR', 3) = 0) then
  begin
    P1 := StrPos('<', ATel.OutData);
    if P1 <> nil then
    begin
      StrMove(P1 + 8, P1 + 1, StrLen(P1));
      StrMove(P1 + 1, '12345kg', 7);
    end;
  end else
  begin
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TWT60Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
  NextS, S1: string;
  (* wenn eichf. Gewicht auf Drucker (ProtDruck=true):
     1. PDR + Beizeichen 1.Teil
     2. PBR druckt und ergibt Gewicht                  ProtGewichtId
     3. PDR + Beizeichen 2. Teil (wenn vorhanden)
        PE für Zeilenvorschub
     wenn eichf. Gewicht im RAM gespeichert (ProtDruck=false):
     1. neue ProtNr erzeugen
     2. AFB druckt und ergibt Gewicht                  ProtGewichtId
     3. (in DoAntwort) STA..KTR schreibt Gewicht+ProtNr in Rollspeicher
  *)
begin
  ProtZeile1 := PStrTok(Beizeichen, '<', NextS);
  S1 := PStrTok(Beizeichen, '>', NextS);               {Platzhalter}
  ProtZeile2 := NextS;
  GenProtNr;                                          {nächste ProtNr}
  if ProtDruck then
  begin
    if ProtZeile1 <> '' then
    begin
      ProtZeile1 := StrCgeStrStr(ProtZeile1, '#N',
        Format('%6.6d', [ProtNr]), false);
      ProtZeile1 := StrCgeStrStr(ProtZeile1, '#G',
        Format('%2.2d', [GerNr]), false);
      StrFmt(Befehl, 'PDR1%03.3d%s', [length(ProtZeile1), ProtZeile1]);
      BefLen := StrLen(Befehl);
      Start(Befehl, BefLen);
    end;
    StrFmt(Befehl, 'PRB1000', [0]);             {Ergibt Gewichstdaten}
    BefLen := StrLen(Befehl);
    ProtGewichtId := Start(Befehl, BefLen);
    if ProtZeile2 <> '' then
    begin
      ProtZeile2 := StrCgeStrStr(ProtZeile2, '#N',
        Format('%6.6d', [ProtNr]), false);
      ProtZeile2 := StrCgeStrStr(ProtZeile2, '#G',
        Format('%2.2d', [GerNr]), false);
      ProtZeile2 := ProtZeile2 + CRLF;
      StrFmt(Befehl, 'PDR1%03.3d%s', [length(ProtZeile2), ProtZeile2]);
      BefLen := StrLen(Befehl);
      Start(Befehl, BefLen);
    end;
  end else
  begin                              {Rollspeicher}
    {StrFmt(Befehl, 'KTR\%9.9d\%6.6s', [ProtNr]);        {neue ProtNr}
    StrFmt(Befehl, 'AFB 000', [0]);         {Brutto holen}
    BefLen := StrLen(Befehl);
    ProtGewichtId := Start(Befehl, BefLen);
  end;
  Result := ProtGewichtId;
end;

function TWT60Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, 'AFB 000', [0]);         {Brutto holen}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TWT60Kmp.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TWT60Kmp.Quittieren: longint;
begin
  Result := -1;
end;

function TWT60Kmp.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  ProtZeile1 := Zeile + CRLF;
  StrFmt(Befehl, 'PDR1%03.3d%s', [length(ProtZeile1), ProtZeile1]);
  BefLen := StrLen(Befehl);
  AnsiToOem(Befehl, Befehl);
  DruckID := Start(Befehl, BefLen);
  Result := DruckID;
end;

function TWT60Kmp.DruckeBlock(ABlock: TStrings): longint;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to ABlock.Count - 1 do
  begin
    Zeilendruck(ABlock.Strings[I]);
  end;
end;

procedure TWT60Kmp.UserFnk(ATel: TTel; FnkName : string);
var
  I : integer;
  BccCh : Byte;
  GerNrStr: array[0..20] of AnsiChar;
begin
  if Uppercase(FnkName) = 'WT60WA' then
  begin
    StrFmt(GerNrStr, '%-5.5s', [WaName]);
    ComPort.Write(GerNrStr, 5);
  end else
  if Uppercase(FnkName) = 'WT60PC' then
  begin
    StrFmt(GerNrStr, '%-5.5s', [PcName]);
    ComPort.Write(GerNrStr, 5);
  end else
  if Uppercase(FnkName) = 'WT60BCC' then
  begin
    BccCh := 0;
    for I:= 1 to length(PcName) do
      BccCh := BccCh xor ord(PcName[I]);
    for I:= 1 to length(WaName) do
      BccCh := BccCh xor ord(WaName[I]);
    for I:= 0 to ATel.OutDataLen-1 do
      BccCh := BccCh xor ord(ATel.OutData[I]);
    BccCh := BccCh xor ETX;   {^C}
    StrFmt(GerNrStr, '%02.2X', [BccCh]);
    ComPort.Write(GerNrStr, 2);
  end else
    inherited UserFnk(ATel, FnkName);
end;

end.
