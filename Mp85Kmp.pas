unit Mp85Kmp;
(*          Minipond 85
24.03.08 MD  Standard Ereignis (property DoProtGewicht entfernt)
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
  TMP85 = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FDoProtGewicht: TDoProtGewichtEvent;
    FOnUserBef: TUserBefEvent;
    procedure StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
  protected
    { Protected-Deklarationen }
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    SimBuff: string;
    Antwort: PAnsiChar;
    AntwLen: integer;
    PollId, UserBefId: longint;
    Descr1, Descr2: TStringList;     {mit/ohne Antwortdaten}
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
    function GerAdr: AnsiChar;
  published
    { Published-Deklarationen }
    property DoProtGewicht: TDoProtGewichtEvent read FDoProtGewicht write FDoProtGewicht;
    property OnUserBef: TUserBefEvent read FOnUserBef write FOnUserBef;
  end;

  procedure Register;

implementation

uses
  Prots, NStr_Kmp, CPor_Kmp;


(*** Initialisierung *********************************************************)

procedure TMP85.BuildDescription;
begin
  inherited BuildDescription;
  Descr1.Clear;
  Descr1.Add(';ohne Datenrückgabe.');
  Descr1.Add('S:^B');              {STX senden}
  Descr1.Add('C:');                {BCC init}
  Descr1.Add('B:');                {reine Daten}
  Descr1.Add('S:^C');              {ETX senden}
  Descr1.Add('S:[BCC]');           {Bcc senden}
  Descr1.Add('A:1');               {ACK oder STX}
  Descr1.Add('S:^D');              {EOT senden}

  Descr2.Clear;
  Descr2.Add(';mit Datenrückgabe.');
  Descr2.Add('S:^B');              {STX senden}
  Descr2.Add('C:');                {BCC init}
  Descr2.Add('B:');                {reine Daten}
  Descr2.Add('S:^C');              {ETX senden}
  Descr2.Add('S:[BCC]');           {Bcc senden}
  Descr2.Add('W:^B');               {BCC}
  Descr2.Add('A:255,^C');              {Daten incl ETX}

  Description.Assign(Descr2);

end;

constructor TMP85.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  Descr1 := TStringList.Create;
  Descr2 := TStringList.Create;
end;

procedure TMP85.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TMP85.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  Descr1.Free;
  Descr2.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TMP85.Init;
begin
  inherited Init;
  Antwort[0] := chr(EOT);
  ComWrite(Antwort, 1);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TMP85.StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 1stellig, Bits 0-4 zählen *)
begin
  if BITIS( Ord(Tok[0]), $1) then Include( Status, fwsKeinGewicht);  {Gew.ungültig}
  if BITIS( Ord(Tok[0]), $4) then Include( Status, fwsNull);  {0t}
  if BITIS( Ord(Tok[1]), $8) then Include( Status, fwsKeinGewicht);  {Overflow}
  if BITIS( Ord(Tok[0]), $10) then Exclude( Status, fwsKeinStillstand) else
                                   Include( Status, fwsKeinStillstand);
  if BITIS( Ord(Tok[1]), $20) then Include( Status, fwsKeinGewicht);  {Underflow}
end;

procedure TMP85.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  S1: string;
begin
  inherited DoAntwort( Sender, Tel_Id);

  FaWaStatus := [];
  ATel := nil;
  L := sizeof(EmpfBuff) - 1;
  try
    ATel := GetTel( Tel_Id);
    GetData( Tel_Id, EmpfBuff, L);
  finally
    EmpfBuff[L] := #0;

    if Tel_Id = StatusId then
    try
      StatusId := -1;
      FaWaStatus := [];
      if ATel.Status = cpsOK then
      try
        {Status:}
        StrToWaStat(EmpfBuff+0, FaWaStatus);

        S1 := String(StrLPas(EmpfBuff+ 1, 1)) + Trim(String(StrLPas(EmpfBuff+ 2, 6)));
        Gewicht := StrToFloatTol(S1);

        GewichtToStr(Gewicht, Display);   {FaWa, +GE}
        // if not (fwsKeinGewicht in FaWaStatus) then  overload:anzeigen
        Include( FaWaStatus, fwsGewichtOk);   {bei Status so}
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
        FOnStatus( Tel_Id, Gewicht, FaWaStatus);
    end else

    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          S1 := Trim(String(StrLPas(EmpfBuff+ 20, 5)));
          Gewicht := StrToFloatTol(S1);

          GewichtToStr(Gewicht, Display);   {FaWa, +GE}
          Display := Format('<%s>', [Display]);

          ProtNr := StrToInt(String(StrLPas(EmpfBuff+15, 4)));

          if not (fwsKeinGewicht in FaWaStatus) then
            Include( FaWaStatus, fwsGewichtOk);
        end else
        begin
          FaWaStatus := [fwsTimeout];
          Gewicht := 0;
        end;
      except
        FaWaStatus := [fwsTimeout];
        Gewicht := 0;
      end;
    finally
      if assigned(FOnProtGewicht) then
        FOnProtGewicht( Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    begin
    end;
  end;
end;

procedure TMP85.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
//  Gew: double;
const
  OldGewicht: integer = 0;
  OldTime: integer = 0;
begin
  StrCopy(ATel.InData, '00000000000000000000000000');
  {Gew := SimGewicht;
  if Gew < 100 then
    Null := 4 else
    Null := 0;}
  {if OldGewicht <> SimGewicht then
    Still := 1 else
    Still := 0;}
  if TicksDelayed(OldTime) > 2000 then
  begin
    TicksReset(OldTime);
    OldGewicht := SimGewicht;
  end;
  if (StrLComp(ATel.OutData, '@G', 2) = 0) then
  begin
    StrFmt(ATel.InData, '0+%6d', [SimGewicht]);
  end else
  if (StrLComp(ATel.OutData, '@L', 2) = 0) then
  begin
    StrFmt(ATel.InData, '%14s%4d-%6d%s', [' ', 1234, SimGewicht, CRLF]);
  end else
  begin
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TMP85.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  ProtZeile1 := BeiZeichen;
  Description.Assign(Descr2);       {mit Datenrückgabe}
  StrFmt(Befehl, '@L', [0]);         {Abdruck Gewicht}
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TMP85.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(Descr2);       {mit Datenrückgabe}
  StrFmt(Befehl, '@G', [0]);         {Brutto holen}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TMP85.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TMP85.Quittieren: longint;
begin
  Result := -1;
end;

function TMP85.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '@P', [0]);         {Befehl starten}
  BefLen := StrLen(Befehl);
  DruckId := Start(Befehl, BefLen);
  Result := DruckId;
end;

function TMP85.DruckeBlock(ABlock: TStrings): longint;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to ABlock.Count - 1 do
  begin
    Zeilendruck(ABlock.Strings[I]);
  end;
end;

function TMP85.GerAdr: AnsiChar;
begin
  Result := AnsiChar(Chr(GerNr + ord('A') - 1));    {1 -> 'A'}
end;

procedure TMP85.UserFnk(ATel: TTel; FnkName : string);
var
  Str: array[0..20] of AnsiChar;
begin
  if Uppercase(FnkName) = 'MP85GERADR' then
  begin
    Str[0] := GerAdr;
    ComWrite(Str, 1);
  end else
    inherited UserFnk(ATel, FnkName);
end;

procedure Register;
begin
  RegisterComponents('COM', [TMP85]);
end;

end.
