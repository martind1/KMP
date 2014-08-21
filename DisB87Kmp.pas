unit DisB87Kmp;
(* Schenk Disomat B+ mit DDP 8785 Protokoll (Schenk Poll-Prozedur)
   - direkte Anforderung mit STX <Daten>ETX<BCC>

*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

type
  TDisB87Kmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    {procedure TokToGewicht( Tok: PAnsiChar; var Gewicht: double);}
    procedure StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
    {procedure StrToSysStat( Tok: PAnsiChar; var Status: TFaWaStatus);}
  protected
    { Protected-Deklarationen }
    DescDirekt, DescVerz: TStringList;
  public
    { Public-Deklarationen }
    StatusPolling: Boolean;
    NrDruckmuster : Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Loaded; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht( Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    procedure DoSimul(ATel: TTel); override;
  published
    { Published-Deklarationen }
  end;

implementation

uses
  Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TDisB87Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DescDirekt := TStringList.Create;
  DescVerz := TStringList.Create;
end;

procedure TDisB87Kmp.Loaded;
begin
  inherited Loaded;

  Description.Clear;
  Description.Add(';do not edit');
  Description.Add('T:3000');      {fester Timeout}
  Description.Add('S:^B');        {->STX}
  Description.Add('B:');          {"00#DR#2# "}
  Description.Add('S:^C[BCCSCHENK]');  {ETX BCC, BCC ohne STX}
  // Description.Add('W:1,^P');    {<-DLE}

  DescVerz.Assign(Description);   {Befehl senden für direkt/verzögert gleich}

  Description.Add(';Antwort:');
  Description.Add('T:5000');
  Description.Add('W:1,^B');      {<-STX}
  Description.Add('A:255,^C');    {<-Daten, ETX}
  Description.Add('W:1');         {<-BCC}
  // Description.Add('S:^P');

  DescDirekt.Assign(Description); {nur Direkte Antwort erwarten}

  DescVerz.Add(';direkte Antwort:');
  DescVerz.Add('T:3000');
  DescVerz.Add('W:1,^B');         {<-STX}
  DescVerz.Add('W:255,^C');       {<-Daten, ETX}
  DescVerz.Add('W:1');            {<-BCC}

  DescVerz.Add(';verzögerte Antwort:');  {nach Direkter Antwort kommt noch verzögerte Antwort}
  DescVerz.Add('T:3000');
  DescVerz.Add('W:1,^B');         {<-STX}
  // DescVerz.Add('S:^P');
  DescVerz.Add('A:255,^C');       {<-Antwort, ETX}
  DescVerz.Add('W:1');            {<-BCC}
end;

destructor TDisB87Kmp.Destroy;
begin
  DescDirekt.Free;
  DescVerz.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDisB87Kmp.Init;
begin
  inherited init;
end;


(*** Interne Methoden *******************************************************)

{procedure TDisB87Kmp.TokToGewicht( Tok: PAnsiChar; var Gewicht: double);
begin
  Gewicht := StrToFloatTol( StrPas( Tok));
end;}

procedure TDisB87Kmp.StrToWaStat( Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 2stellig, Bits 0-4 zählen *)
Var stat : Byte;
begin
  stat := StrToInt(String(Tok[0]));
  if BITIS( stat, $8) then Exclude( Status, fwsKeinStillstand) else
                                  Include( Status, fwsKeinStillstand);
  if BITIS( stat, $2) then Include( Status, fwsKeinStillstand);
  if BITIS( stat, $0) then Include( Status, fwsKeinStillstand);
  if BITIS( stat, $10) then Include( Status, fwsUeberlast);    {Overflow}

  stat := StrToInt(String(Tok[1]));
  if BITIS( stat, $8) then Include( Status, fwsNull);  {0t}
  if BITIS( stat, $2) then Include( Status, fwsUeberlast);    {Overflow}
  if BITIS( stat, $1) then Include( Status, fwsUnterlast);    {Underflow}
  if BITIS( stat, $0) then Include( Status, fwsGewichtOk);
end;

(* procedure TDis39Kmp.StrToSysStat( Tok: PAnsiChar; var Status: TFaWaStatus);
{ Tok 1stellig, Bits 0-4 zählen }
begin
  if BITIS( Ord(Tok[0]), $8) then Include( Status, fwsDruckerstoerung); {ohne Drucker}
  if BITIS( Ord(Tok[0]), $4) then Include( Status, fwsWaagenstoerung);
  if BITIS( Ord(Tok[0]), $1) then Include( Status, fwsDruckerstoerung);

  if not (BITIS( Ord(Tok[0]), $F)) then
    Include( Status, fwsGewichtOK);
  {if [fwsNull,fwsKeinGewicht] * Status <> [] then
    Exclude( Status, fwsGewichtOK);}
end; *)

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDisB87Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  Tok: PAnsiChar;
  ATel : TTel;
  S1: string;
  NextStr: PAnsiChar;
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
      ATel := GetTel( Tel_Id);
      if ATel.Status = cpsOK then
      try
        {Waagenadresse:}
        StrTok( EmpfBuff, '#', NextStr);
        {TG:}
        Tok := StrTok( nil, '#', NextStr);
        if StrComp(Tok, 'TG') <> 0 then
          EError('%s:falsch',[Tok]);
        {netto:}
        Tok := StrTok( nil, '#', NextStr);
        StrToGewicht(String(StrPas(Tok)), Gewicht);   {FaWa}
        {tara:}
        StrTok( nil, '#', NextStr);
        {dG/dt:}
        StrTok( nil, '#', NextStr);
        {Waagenstatus:}
        Tok := StrTok( nil, '#', NextStr);
        StrToWaStat( Tok, FaWaStatus);
        //Gewicht := StrToFloatTol( Display);
        GewichtToStr(Gewicht, Display);   {FaWa, +GE}
        // if not (fwsKeinGewicht in FaWaStatus) then  overload:anzeigen
        Include( FaWaStatus, fwsGewichtOk);   {bei Status so}
        GewichtToStr(Gewicht, S1);   {FaWa, +GE}
        Display := Format('%s', [S1]);
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

    {ProtGewicht}
    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin
          {Waagenadresse:}
          StrTok( EmpfBuff, '#', NextStr);
          {DR:}
          Tok := StrTok( nil, '#', NextStr);
          if StrComp(Tok, 'DR') <> 0 then
            EError('%s:falsch',[Tok]);
          {Nummer Druckmuster: muß 2 sein}
          Tok := StrTok( nil, '#', NextStr);
          if StrPas(Tok) <> '2' then begin
            EError('Druckmuster %s in Disomat-B falsch einegestellt',[Tok]);
            Include(FaWaStatus, fwsDruckerstoerung);
          end;
          {Druckstatus X: 0=OK 1=Fehler Drucker:}
          Tok := StrTok( nil, '#', NextStr);
          if StrPas(Tok) <> '0' then
            Include(FaWaStatus, fwsDruckerstoerung);
          {Waagenstatus}
          Tok := StrTok( nil, '#', NextStr);
          StrToWaStat( Tok, FaWaStatus);

          {- Datum}
          StrTok( nil, '#', NextStr);
          {- Zeit}
          StrTok( nil, '#', NextStr);
          {- ProtNr}
          Tok := StrTok( nil, '#', NextStr);
          ProtNr := StrToInt(String(StrPas(Tok)));
          Include(FaWaStatus, fwsProtNr);
          {- Gewicht:}
          {Überprüfung auf Einheit Tonnen}
          {Achtung: bei Überlast werden im String-Feld nur Blank ausgegeben!}
          if (Not(fwsUeberlast in FaWaStatus)) AND (EmpfBuff[43] <> 't') then
          begin
            EError('Waage nicht auf Tonnen eingestellt',[0]);
            Include(FaWaStatus, fwsKeinGewicht);
          end
          else begin
            Tok := StrTok( nil, '#', NextStr);
            StrToGewicht(String(StrPas(Tok)), Gewicht);   {FaWa}
            GewichtToStr(Gewicht, S1);   {FaWa, +GE}
            Display := Format('<%s>', [S1]);
            Include(FaWaStatus, fwsGewichtOK);
          end;
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

    (* if Tel_Id = NullstellenId then
    try
      NullstellenId := -1;
      FaWaStatus := [fwsTimeout];
      try
        if ATel.Status = cpsOK then
        begin
          {Waagenadresse;}
          Tok := StrTok( EmpfBuff, '#', NextStr);
          {AZ:}
          Tok := StrTok( nil, '#', NextStr);
          if StrComp(Tok, 'AZ') <> 0 then
            EError('%s:falsch',[Tok]);
          {0=OK /1}
          Tok := StrTok( nil, '#', NextStr);
          Display := StrPas(Tok);
          if Tok[0] = '0' then
            FaWaStatus := [fwsNull] else
            FaWaStatus := [];
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
      if assigned(FOnNullstellen) then
        FOnNullstellen( Tel_Id, FaWaStatus);
    end;
    *)
  end;
end;

function TDisB87Kmp.Nullstellen: longint;
{Nullstellen nicht möglich}
begin
  NullstellenId := -1;
  result := NullstellenId;
end;

function TDisB87Kmp.ProtGewicht( Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescVerz);
  StrFmt( Befehl, '%-02.2d#DR#%1.1d#', [GerNr, NrDruckmuster]);
  BefLen := StrLen( Befehl);
  ProtGewichtId := Start( Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDisB87Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StatusId := -1;
  if StatusPolling then begin
    Description.Assign(DescDirekt);
    StrFmt( Befehl, '%-02.2d#TG#', [GerNr]);     {AKW mit #}
    BefLen := StrLen( Befehl);
    StatusId := Start( Befehl, BefLen);
  end;
  Result := StatusId;
end;

procedure TDisB87Kmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
//  Gew: Double;
  Tok: PAnsiChar;
  NextStr: PAnsiChar;
begin
  StrCopy(ATel.InData, '');
//  Gew := SimGewicht;
  SimError := 80;
//  if SimGewicht < 0 then
//    Gew := -SimGewicht;

  // ProtGewicht
  {Waagenadresse:}
  StrTok( ATel.OutData, '#', NextStr);
  {Befehl}
  Tok := StrTok( nil, '#', NextStr);

  if (Tok <> nil) AND (StrComp(Tok, 'DR') = 0) then
  begin
    Inc(SimProtNr);
    // GerNr#Befehl#Druckmuster#DruckStatus#Waagenstatus
    StrFmt(ATel.InData, '%-02.2d#DR#2#0#%-2.2d#%s#%05.5d#  %02.2d.00t   B   ' + Chr(3) + Chr(13),
      [GerNr, SimError, FormatDateTime('yyyy-mm-dd#hh:nn', Date), SimProtNr, SimGewicht DIV 100]);
  end;

  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

end.
