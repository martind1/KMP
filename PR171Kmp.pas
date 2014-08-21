unit PR171Kmp;
(* Philips 1713/31 mit vereinfachter Protokollierung mit WA
   26.09.03 MD erstellt
   09.10.03 MD Ereignis DoProtGewicht
*)
interface

uses
{$ifdef WIN32}
  Math,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, DPos_Kmp;

type
  TDoProtGewichtEvent = procedure(Sender: TObject; var ATelId: longint) of object;
  TUserBefEvent = procedure(ATelId: longint; AAntwort: string) of object;

type
  TPR1713 = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    Line1, Line2, Line3: integer;
    TimeOutList: TValueList;
    FDoProtGewicht: TDoProtGewichtEvent;
    function IsTimeOut(aID: longint): boolean;
    procedure DelTimeOut(aID: longint);
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    SimBuff: string;
    Antwort: PAnsiChar;
    AntwLen: integer;
    PollId, UserBefId: longint;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure UserFnk(ATel: TTel; FnkName : string); override;
    procedure Init; override;
    function AmpelGruen: longint;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
    function Quittieren: longint; override;
    function DruckeBlock(ABlock: TStrings): longint; override;
    function Zeilendruck(Zeile: string): longint; override;
    function DelSpNr(SpNr: integer): longint; override;
    function Nullstellen: longint; override;
    function StartUserBef(UserBef: string): longint;
    function StartPoll: longint;
    function GerAdr: AnsiChar;
    procedure DoOnProtGewicht(ATelId: longint);
  published
    { Published-Deklarationen }
    property DoProtGewicht: TDoProtGewichtEvent read FDoProtGewicht write FDoProtGewicht;
  end;

implementation

uses
  Prots, NStr_Kmp, CPor_Kmp;

const
  POL = 112;           {kleines p}

(*** Initialisierung *********************************************************)

procedure TPR1713.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('S:^A');
  Description.Add('S:[PR1613GERADR]');
  Description.Add('C:');                {Bcc=0}
  Description.Add('B:');                {POL oder STX + Block}
  Description.Add('S:[PR1613BCC]');     {ETX und Bcc senden. nicht bei POL}
  Description.Add('S:^E');
  Description.Add('A:1');               {EOT, ACK oder SOH}
  Description.Add('S:[PR1613FNK]');
  Line1 := Description.Count;
  Line2 := Line1 + 1;
  Line3 := Line2 + 1;
  Description.Add(';Line1');            {A:ETX}
  Description.Add(';Line2');            {W:BCC}
  Description.Add(';Line3');            {S:ACK}

end;

constructor TPR1713.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  TimeOutList := TValueList.Create;
end;

procedure TPR1713.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TPR1713.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  TimeOutList.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TPR1713.Init;
begin
  inherited Init;
  Antwort[0] := chr(EOT);
  ComWrite(Antwort, 1);
end;

function TPR1713.IsTimeOut(aID: longint): boolean;
begin
  if TimeOutList.Values[IntToStr(aID)] = '' then
    TimeOutList.Values[IntToStr(aID)] := IntToStr(Int64(GetCurrentTime));
  result := (ComPort <> nil) and
            (TicksDelayed(StrToIntTol(TimeOutList.Values[IntToStr(aID)])) >
            ComPort.TimeOut);
end;

procedure TPR1713.DelTimeOut(aID: longint);
begin
  TimeOutList.Values[IntToStr(aID)] := '';
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TPR1713.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  Empf: array[0..255] of AnsiChar;
  L: integer;
  GewStr: string;
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
  cpStatus: TComProtStatus;
  DoIt: boolean;
begin
  inherited DoAntwort(Sender, Tel_Id);
  FaWaStatus := [];
  L := sizeof(Empf) - 1;
  cpStatus := GetData(Tel_Id, Empf, L);
  Empf[L] := #0;
  DoIt := false;
  IsTimeOut(Tel_Id);                  {Startzeit setzen wenn neu}
  if cpStatus <> cpsOK then
  begin
    Befehl[0] := chr(EOT);
    ComWrite(Befehl, 1);
    DoIt := true;
  end else
  if ord(Empf[0]) = SOH then
  begin
    DoIt := true;
  end else
  if ord(Empf[0]) = ACK then
  begin                                           {Poll mit gleicher ID starten}
    StrFmt(Befehl, 'p', [0]);                     {Poll starten}
    BefLen := StrLen(Befehl);
    StartFlags(Befehl, BefLen, [cpfPoll, cpfUseId], '', Tel_Id);
  end else
  if (ord(Empf[0]) = EOT) and (Tel_Id <> PollId) then
  begin
    if IsTimeOut(Tel_Id) then
    begin
      cpStatus := cpsError;
      DoIt := true;
    end else
    begin                                         {Poll mit gleicher ID starten}
      StrFmt(Befehl, 'p', [0]);                   {Poll starten}
      BefLen := StrLen(Befehl);
      StartFlags(Befehl, BefLen, [cpfPoll, cpfUseId], '', Tel_Id);
    end;
  end else
  begin                         {unbekanntes Zeichen}
    cpStatus := cpsError;
    DoIt := true;
  end;
  if not DoIt then
    Exit;                   {keine Antwort hier}
  DelTimeOut(Tel_Id);                  {löschen}

  if (Tel_Id = ProtGewichtId) then
  try
    ProtGewichtId := -1;
    FaWaStatus := [];
    if cpStatus = cpsOK then
    try
      {0    5    1 }
      {SASQA-wwwwwesss(10)sssYYMMDDhhmmss}
      {ODT}
      {HRX}
      if StrLPas(Empf + 3, 2) <> 'QA' then
      begin
        Include(FaWaStatus, fwsWaagenstoerung);
        Display := String(StrLPas(Empf + 3, 6));
      end else
      begin
        {SASQA-wwwwwepppppppppp}
        GewStr := String(StrLPas(Empf + 6, 5));
        ProtNr := StrToInt(String(StrLPas(Empf + 12, 10)));
        StrToGewicht(GewStr, Gewicht);             {definiert NachK}
        {Display := Format('%5.*f %s', [NachK, Gewicht, GE]);}
        GewichtToStr(Gewicht, Display);
        FaWaStatus := [fwsGewichtOK];
      end;
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s:%s',[Name, E.Message]);
      end;
    end else
    begin
      Display := 'Timeout';
      Prot0('%s:%s', [Name, Display]);
      Include(FaWaStatus, fwsTimeOut);
    end;
  finally
    if assigned(FOnProtGewicht) then
      FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
  end else

  if Tel_Id = StatusId then
  try
    FaWaStatus := [];
    if cpStatus = cpsOK then
    try
      {0    5    1 }
      {SASQGA-wwwwwemz}
      {ODT}
      {HRX}
      if StrLPas(Empf + 3, 3) <> 'QGA' then
      begin
        Include(FaWaStatus, fwsWaagenstoerung);
        Display := String(StrLPas(Empf + 3, 6));
      end else
      begin
        GewStr := String(StrLPas(Empf + 7, 5));
        StrToGewicht(GewStr, Gewicht);             {definiert NachK}
        {Display := Format('%5.*f %s', [NachK, Gewicht, GE]);}
        GewichtToStr(Gewicht, Display);
        if Empf[13] <> '1' then
          Include(FaWaStatus, fwsKeinStillstand);
        if Empf[14] = '4' then
          Include(FaWaStatus, fwsNull);
        {if FaWaStatus = [] then}
          FaWaStatus := [fwsGewichtOK];
      end;
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s:%s',[Name, E.Message]);
      end;
    end else
    begin
      Display := 'Timeout';
      Prot0('%s:%s', [Name, Display]);
      Include(FaWaStatus, fwsTimeOut);
    end;
  finally
    StatusId := -1;
    if assigned(FOnStatus) then
      FOnStatus(Tel_Id, Gewicht, FaWaStatus);
  end else

  if Tel_Id = NullstellenId then
  try
    FaWaStatus := [];
    if cpStatus = cpsOK then
    try
      if StrLPas(Empf + 3, 1) <> 'Q' then
      begin
        Include(FaWaStatus, fwsWaagenstoerung);
        Display := String(StrLPas(Empf + 3, 6));
      end else
      begin
        FaWaStatus := [fwsNull];
        Display := 'OK';
      end;
    except
      on E:Exception do
      begin
        Display := E.Message;
        Prot0('%s:%s',[Name, E.Message]);
      end;
    end else
    begin
      Display := 'Timeout';
      Prot0('%s:%s', [Name, Display]);
      Include(FaWaStatus, fwsTimeOut);
    end;
  finally
    NullstellenId := -1;
    if assigned(FOnNullstellen) then
      FOnNullstellen(Tel_Id, FaWaStatus);
  end else

  if (Tel_Id = DruckId) then
  try
    (* Dummyfunktion für Ereignis OnZeilendruck *)
    DruckId := -1;
    FaWaStatus := [];
  finally
    if assigned(FOnZeilendruck) then
      FOnZeilendruck(Tel_Id, FaWaStatus);
  end;
end;

procedure TPR1713.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: double;
  Still, Null: integer;
  SimEichNr: integer;
const
  OldGewicht: integer = 0;
  OldTime: integer = 0;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  if Gew < 100 then
    Null := 4 else
    Null := 0;
  if OldGewicht <> SimGewicht then
    Still := 1 else
    Still := 0;
  if TicksDelayed(OldTime) > 2000 then
  begin
    TicksReset(OldTime);
    OldGewicht := SimGewicht;
  end;
  StrFmt(ATel.InData, '%s', [AnsiChar(ACK)]);
  if (StrLComp(ATel.OutData + 1, 'WGA', 3) = 0) then
  begin
    SimBuff := Format('QGA-%05.5de%d%d', [SimGewicht, Still, Null]);
    if Random(100) = 0 then
      SimBuff := Format('E30000', [0]);
  end else
  if (StrLComp(ATel.OutData + 1, 'WA', 2) = 0) then
  begin
    SimEichNr := StrToInt(FormatDateTime('HHNNSS', time));
    SimBuff := Format('QA-%05.5de%10.10d', [SimGewicht, SimEichNr]);
    if Random(5) = 0 then
      SimBuff := Format('E70000', [0]);
  end else
  if (StrLComp(ATel.OutData, 'p', 1) = 0) then
  begin
    if {(Random(3) = 0) and} (SimGewicht <> 800) then
    begin
      StrFmt(ATel.InData, '%sA%s%s%s', [AnsiChar(SOH), AnsiChar(STX), SimBuff, AnsiChar(ETX)]);
      {SimBuff := '';}
    end else
      StrFmt(ATel.InData, '%s', [AnsiChar(EOT)]);  //Fehler erzeugen
  end else
  begin
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TPR1713.StartPoll: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, 'p', [0]);                   {Poll starten}
  BefLen := StrLen(Befehl);
  PollId := Start(Befehl, BefLen);
  Result := PollId;
end;

function TPR1713.StartUserBef(UserBef: string): longint;
(* Beliebigen Befehl mit UserBefId starten
   ruft in Antwort bei Ende Ereignis OnUserBef auf
*)
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '%s%s', [AnsiChar(STX), UserBef]);         {Befehl starten}
  BefLen := StrLen(Befehl);
  UserBefId := Start(Befehl, BefLen);
  result := UserBefId;
end;

procedure TPR1713.DoOnProtGewicht(ATelId: longint);
begin
  if assigned(FOnProtGewicht) then
    FOnProtGewicht(ATelId, Gewicht, ProtNr, FaWaStatus);
end;

function TPR1713.ProtGewicht(Beizeichen: string): longint;
begin
(*  ProtZeile1 := BeiZeichen;
  result := -1;
  StrFmt(Befehl, '%sWA', [AnsiChar(STX)]);         {Alibi Druck auslösen}
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  result := ProtGewichtId;*)
  ProtZeile1 := BeiZeichen;
  if assigned(FDoProtGewicht) then
    FDoProtGewicht(self, ProtGewichtId);
  result := ProtGewichtId;
end;

function TPR1713.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '%sWGA', [AnsiChar(STX)]);         {Brutto holen}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TPR1713.AmpelGruen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  {StrFmt(Befehl, '%s', ['ZM10001']);         {SPM-Bit 100.0 setzen}
  StrFmt(Befehl, '%s%s', [AnsiChar(STX), 'ZM03001']);         {SPM-Bit 030.0 setzen}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TPR1713.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TPR1713.Quittieren: longint;
begin
  Result := -1;
end;

function TPR1713.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '%s%s', [AnsiChar(STX), Zeile]);         {Befehl starten}
  BefLen := StrLen(Befehl);
  DruckId := StartFlags(Befehl, BefLen, [cpfDummy], '', 0); {ohne Kommunikation}
  Result := DruckId;
end;

function TPR1713.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '%sWZA', [AnsiChar(STX)]);         {Nullstellen}
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  Result := NullstellenId;
end;

function TPR1713.DruckeBlock(ABlock: TStrings): longint;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to ABlock.Count - 1 do
  begin
    Zeilendruck(ABlock.Strings[I]);
  end;
end;

function TPR1713.GerAdr: AnsiChar;
begin
  Result := AnsiChar(chr(GerNr + ord('A') - 1));    {1 -> 'A'}
end;

procedure TPR1713.UserFnk(ATel: TTel; FnkName : string);
var
  Bcc : integer;
  Str: array[0..20] of AnsiChar;
begin
  if Uppercase(FnkName) = 'PR1613GERADR' then
  begin
    Str[0] := GerAdr;
    ComWrite(Str, 1);
  end else
  if Uppercase(FnkName) = 'PR1613FNK' then
  begin
    if ord(ATel.InData[0]) = SOH then
    begin
      {ATel.InDataLen := 0;       beware!}
      //20.12.02 ATel. fehlte
      ATel.Description[Line1] := 'A:128,^C';          {ETX}
      ATel.Description[Line2] := 'W:1';           {BCC}
      ATel.Description[Line3] := 'S:^F';          {ACK}
    end else
    begin                {EOT, ACK}
      Str[0] := chr(EOT);
      {Str[0] := ATel.InData[0];          {Test}
      ComWrite(Str, 1);
      ATel.Description[Line1] := ';';
      ATel.Description[Line2] := ';';
      ATel.Description[Line3] := ';';
    end;
  end else
  if Uppercase(FnkName) = 'PR1613BCC' then
  begin
    if ord(ATel.OutData[0]) <> POL then
    begin
      Str[0] := chr(ETX);
      ComWrite(Str, 1);
      Bcc := ComPort.Bcc xor STX;             {STX war zuviel}
	    ComWrite(Addr(Bcc), 1);            {vergl. CPro_Kmp}
    end;
  end else
    inherited UserFnk(ATel, FnkName);
end;

end.
