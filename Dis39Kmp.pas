unit Dis39kmp;
(* Schenk Disomat B plus 3964R Protokoll
   30.06.04 MD GerNr in ProtGewicht
   05.07.04 MD Timeout be Protgewicht auf 12000
   21.11.11 md SCHENCK-Poll-Prozedur: DDP8785 Flag

   ------------------------------------------
   Beispielprotokoll (OK):
   46:41.359=o:^B
   46:41.429=i:^P
   46:41.439=o2:01#DR#01#A.W.Ost Disomat Waage
   46:41.479=o:^P
   46:41.479=o:^C
   46:41.479=o:d
   46:41.539=i:^P
   46:42.801=i:^B
   46:42.801=o:^P
   46:42.861=i:01#DR#0#^P^C
   46:42.871=i:^W
   46:42.881=o:^P
   46:42.951=i:^B
   46:42.961=o:^P
   46:43.31=i:01#DR#1#0#88#2003-10-15#20:44#37184#
   46:43.81=i:  0kg  B   ^P^C
   46:43.121=i:^
   46:43.141=o:^P

   Beispielprotokoll (Fehler):
   8:18.510=o:^B
   8:18.560=i:^P
   8:18.560=o2:01#DR#01#A.W.Ost Disomat Waage
   8:18.590=o:^P
   8:18.590=o:^C
   8:18.590=o:d
   8:18.640=i:^U[^U statt ^P]

   Beispielprotokoll (Fehler):
   28:43.343=o:^B
   28:43.393=i:^P
   28:43.393=o2:01#DR#01#A.W.Ost Disomat Waage
   28:43.423=o:^P
   28:43.423=o:^C
   28:43.423=o:d
   28:43.473=i:^P
   28:43.523=i:^B
   28:43.523=o:^P
   28:43.573=i:01#DR#1#^P^C
   28:43.573=i:^V
   28:43.573=o:^P
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp;

const
  MaxKontakte = 16;

type
  TKontakte = array [1..MaxKontakte] of Boolean;
  // 1..4:  Eingang
  // 5..10: Ausgang
  //11..14: virtuell EDV

  TKontakteEvent = procedure(ATelId: longint;
    Kontakte: TKontakte; AStatus: TFaWaStatus) of object;

type
  TDis39Kmp = class(TFaWaKmp)
  private
    FDDP8785: boolean;
    FOnKontakteLesen: TKontakteEvent;
    { Private-Deklarationen }
    //procedure TokToGewicht(Tok: PAnsiChar; var Gewicht: double);
    procedure StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
    procedure SetDDP8785(const Value: boolean);
    //procedure StrToSysStat(Tok: PAnsiChar; var Status: TFaWaStatus);
  protected
    { Protected-Deklarationen }
    DescDirekt, DescVerz: TStringList;
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    SetzeKontakteId, LeseKontakteId: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Loaded; override;
    function Nullstellen: longint; override;
    function HoleStatus: longint; override;
    function ProtGewicht(Beizeichen: string): longint; override;
    procedure DoAntwort(Sender: TObject; Tel_Id: Longint); override;
    function LeseKontakte: longint;
    function SetzeKontakte(Kontakte: TKontakte): longint;
  published
    { Published-Deklarationen }
    property DDP8785: boolean read FDDP8785 write SetDDP8785;
    property OnKontakteLesen: TKontakteEvent read FOnKontakteLesen write FOnKontakteLesen;
  end;

implementation

uses
  Prots, Err__Kmp;

(*** Initialisierung *********************************************************)

constructor TDis39Kmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DescDirekt := TStringList.Create;
  DescVerz := TStringList.Create;
  DDP8785 := false;
end;

procedure TDis39Kmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TDis39Kmp.Destroy;
begin
  DescDirekt.Free;
  DescVerz.Free;
  inherited Destroy;
end;

procedure TDis39Kmp.BuildDescription;
begin
  Description.Clear;
  if DDP8785 then
  begin
    {<STX>01#TG#<ETX><BCC>
     Antwort Waage:
     <STX>01#TG#netto#tara#dg/dt#status#<ETX><BCC>    }
    Description.Add(';DPP8785');
    Description.Add('I:');
    Description.Add('T:5000');
    Description.Add('S:^B');   {->STX}
    Description.Add('B:');     {01#TG#}
    Description.Add('S:^C[BCCDPP8785]');  {->ETX BCC,  BCC ohne STX (ohne DLE)}

    DescVerz.Assign(Description);

    Description.Add('W:1,^B');    {<- STX}
    Description.Add('A:255,^C');  {  <- Antwort, ETX }
    Description.Add('W:1');        {<-BCC}

    DescDirekt.Assign(Description);

    DescVerz.Add(';direkte Antwort:');
    DescVerz.Add('T:2000');
    DescVerz.Add('W:255,^C');
    DescVerz.Add('W:1');        {<-BCC}

    DescVerz.Add(';verzögerte Antwort:');
    DescVerz.Add('T:12000');     //05.07.04 bereits hier
    DescVerz.Add('W:1,^B');    {<- STX}
    DescVerz.Add('A:255,^C');  {  <- Antwort, ETX }
    DescVerz.Add('W:1');        {<-BCC}
  end else
  begin
    Description.Add(';do not edit');
    Description.Add('I:');
    Description.Add('T:5000');
    Description.Add('S:^B');   {->STX}
    Description.Add('W:1,^P');   {<-DLE}
    Description.Add('B:');     {01#TG#}
    Description.Add('S:^P^C[BCCDIS39]');  {->DLE ETX BCC,  BCC ohne STX}
    Description.Add('W:1,^P');    {<-DLE}

    DescVerz.Assign(Description);

    Description.Add(';Antwort:');
    Description.Add('T:2000');
    Description.Add('W:1,^B');
    Description.Add('S:^P');
    Description.Add('A:255,^P,^C');
    Description.Add('W:1');        {<-BCC}
    Description.Add('P:30');        {Verzögerung, damit DIS Zeit hat}
    Description.Add('S:^P');

    DescDirekt.Assign(Description);

    DescVerz.Add(';direkte Antwort:');
    DescVerz.Add('T:2000');
    DescVerz.Add('W:1,^B');
    DescVerz.Add('S:^P');
    DescVerz.Add('W:255,^P,^C');
    DescVerz.Add('W:1');        {<-BCC}
    DescVerz.Add('P:30');        {Verzögerung, damit DIS Zeit hat}
    DescVerz.Add('S:^P');

    DescVerz.Add(';verzögerte Antwort:');
    DescVerz.Add('T:12000');     //05.07.04 bereits hier
    DescVerz.Add('W:1,^B');
    DescVerz.Add('S:^P');
    DescVerz.Add('A:255,^P,^C');
    DescVerz.Add('W:1');        {<-BCC}
    DescVerz.Add('P:30');        {Verzögerung, damit DIS Zeit hat}
    DescVerz.Add('S:^P');
  end;
end;

(*** Methoden ***************************************************************)

procedure TDis39Kmp.Init;
//var
//  Befehl : array[0..128] of AnsiChar;
//  BefLen: integer;
begin
{21.11.11 Polen: besser nicht
  StrFmt(Befehl, '01#EU#%s#%s#',
    [FormatDateTime('dd.mm.yy', date), FormatDateTime('hh:nn:ss', time)]);
  BefLen := StrLen(Befehl);
  Start(Befehl, BefLen);
}

  {Zeilendruck(Format('%s %s',
    ['Wägeprotokoll ab', FormatDateTime('dd.mm.jj hh:nn:ss', now)]));
  Zeilendruck('Datum... Zeit. Num. Fahrzeug.... Wa Tara.... Brutto..');}
end;


(*** Interne Methoden *******************************************************)

//procedure TDis39Kmp.TokToGewicht(Tok: PAnsiChar; var Gewicht: double);
//begin
//  Gewicht := StrToFloatTol(StrPas(Tok));
//end;

procedure TDis39Kmp.SetDDP8785(const Value: boolean);
begin
  FDDP8785 := Value;
  BuildDescription;
end;

procedure TDis39Kmp.StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 2stellig, Bits 0-4 zählen *)
begin
  if BITIS(Ord(Tok[0]), $8) then Exclude(Status, fwsKeinStillstand) else
                                  Include(Status, fwsKeinStillstand);
  if BITIS(Ord(Tok[0]), $2) then Include(Status, fwsKeinGewicht);  {Gew.ungültig}
  if BITIS(Ord(Tok[0]), $1) then Include(Status, fwsNull);  {0t}

  if BITIS(Ord(Tok[1]), $8) then Include(Status, fwsNull);  {0t}
  if BITIS(Ord(Tok[1]), $2) then Include(Status, fwsKeinGewicht);  {Overflow}
  if BITIS(Ord(Tok[1]), $1) then Include(Status, fwsKeinGewicht);  {Underflow}
end;

//procedure TDis39Kmp.StrToSysStat(Tok: PAnsiChar; var Status: TFaWaStatus);
//(* Tok 1stellig, Bits 0-4 zählen *)
//begin
//  if BITIS(Ord(Tok[0]), $8) then Include(Status, fwsDruckerstoerung); {ohne Drucker}
//  if BITIS(Ord(Tok[0]), $4) then Include(Status, fwsWaagenstoerung);
//  if BITIS(Ord(Tok[0]), $1) then Include(Status, fwsDruckerstoerung);
//
//  if not (BITIS(Ord(Tok[0]), $F)) then
//    Include(Status, fwsGewichtOK);
//  {if [fwsNull,fwsKeinGewicht] * Status <> [] then
//    Exclude(Status, fwsGewichtOK);}
//end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDis39Kmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  Tok: PAnsiChar;
  ATel : TTel;
  S1, GewStr: string;
  NextStr: PAnsiChar;
  P1, P2: integer;
  I: Integer;
  Kontakte: TKontakte;
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

    if Tel_Id = LeseKontakteID then
    try
      LeseKontakteID := -1;
      ATel := GetTel(Tel_Id);
      if ATel.Status = cpsOK then
      try
        //STX 01#TK#0#0#0#0#0#1#0#0#0#0#0#0#0#0#     0.000#     0.000# ETX BCC
        {Waagenadresse:}
        StrTok(EmpfBuff, '#', NextStr);
        {TK:}
        Tok := StrTok(nil, '#', NextStr);
        if StrComp(Tok, 'TK') <> 0 then
          EError('%s:falsch',[Tok]);
        {Kontakt1..14:}
        for I := 1 to 14 do
        begin
          Tok := StrTok(nil, '#', NextStr);
          Kontakte[I] := Tok = '1';
        end;
        Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
      except
        on E:Exception do
        begin
          Display := E.Message;
          Prot0('Lesekontakte: %s',[E.Message]);
        end;
      end;
    finally
      if assigned(FOnKontakteLesen) then
        FOnKontakteLesen(Tel_Id, Kontakte, FaWaStatus);
    end else

    if Tel_Id = StatusId then
    try
      StatusId := -1;
      ATel := GetTel(Tel_Id);
      if ATel.Status = cpsOK then
      try
        {Waagenadresse:}
        StrTok(EmpfBuff, '#', NextStr);
        {TG:}
        Tok := StrTok(nil, '#', NextStr);
        if StrComp(Tok, 'TG') <> 0 then
          EError('%s:falsch',[Tok]);
        {netto:}
        Tok := StrTok(nil, '#', NextStr);
        StrToGewicht(String(StrPas(Tok)), Gewicht);   {definiert NachK, in FaWa}
        {tara:}
        StrTok(nil, '#', NextStr);
        {dG/dt:}
        StrTok(nil, '#', NextStr);
        {Waagenstatus:}
        Tok := StrTok(nil, '#', NextStr);
        StrToWaStat(Tok, FaWaStatus);
        //Gewicht := StrToFloatTol(Display);
        //GewichtToStr(Gewicht, Display);   {FaWa, +GE}  weg wg to 22.01.08
        // 25.02.14 Abfrage wieder aktiviert:
        if fwsKeinGewicht in FaWaStatus then  //overload:anzeigen
        begin
          Display := Format('----- %s', [GE]);
        end else
        begin
          Display := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Include(FaWaStatus, fwsGewichtOk);   {bei Status so}
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
      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else

    if Tel_Id = ProtGewichtId then
    try
      ProtGewichtId := -1;
      FaWaStatus := [];
      try
        if ATel.Status = cpsOK then
        begin                 // 01#DR#muster#0#wastat#dtm#zeit#protnr#gewicht#
          Prot0('TDis39Kmp.DoAntwort', [0]);
          ProtA('%s', [EmpfBuff]);
          {Waagenadresse:}
          StrTok(EmpfBuff, '#', NextStr);
          {DR:}
          Tok := StrTok(nil, '#', NextStr);
          if StrComp(Tok, 'DR') <> 0 then
            EError('%s:falsch',[Tok]);
          {Nummer Druckmuster:}
          StrTok(nil, '#', NextStr);
          {X:0=OK 1=Fehler Drucker:}
          Tok := StrTok(nil, '#', NextStr);
          if StrPas(Tok) <> '0' then
            Include(FaWaStatus, fwsDruckerstoerung);
          {Waagenstatus}
          Tok := StrTok(nil, '#', NextStr);
          StrToWaStat(Tok, FaWaStatus);
          {- Datum}
          StrTok(nil, '#', NextStr);
          {- Zeit}
          StrTok(nil, '#', NextStr);
          {- ProtNr}
          Tok := StrTok(nil, '#', NextStr);
          ProtNr := StrToInt(String(StrPas(Tok)));
          Include(FaWaStatus, fwsProtNr);
          {- Gewicht:}
          Tok := StrTok(nil, '#', NextStr);
          GewStr := String(StrPas(Tok));
          if Pos('<', GewStr) > 0 then
          begin
            P1 := Pos('<', GewStr);
            P2 := Pos('>', GewStr);
            GewStr := Copy(GewStr, P1 + 1, P2 - P1 - 1);
          end;
          StrToGewicht(GewStr, Gewicht);   {FaWa}
          //GewichtToStr(Gewicht, S1);   {FaWa, +GE} - weg wg to (0,00) 22.01.08
          S1 := Format('%5.*f %s', [NachK, Gewicht, GE]);
          Display := Format('<%s>', [S1]);

          if not (fwsKeinGewicht in FaWaStatus) then
            Include(FaWaStatus, fwsGewichtOk);

          //ProtNr := StrToInt(StrPas(Tok));
          //Display := StrPas(Tok);
          //TokToGewicht(Tok, Gewicht);
          {Systemstatus (Drucker)}
          //StrToSysStat(Tok, FaWaStatus);
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
        FOnProtGewicht(Tel_Id, Gewicht, ProtNr, FaWaStatus);
    end else

    if Tel_Id = NullstellenId then
    try
      NullstellenId := -1;
      FaWaStatus := [fwsTimeout];
      try
        if ATel.Status = cpsOK then
        begin
          {Waagenadresse;}
          StrTok(EmpfBuff, '#', NextStr);
          {AZ:}
          Tok := StrTok(nil, '#', NextStr);
          if StrComp(Tok, 'AZ') <> 0 then
            EError('%s:falsch',[Tok]);
          {0=OK /1}
          Tok := StrTok(nil, '#', NextStr);
          Display := String(StrPas(Tok));
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
        FOnNullstellen(Tel_Id, FaWaStatus);
    end else
    begin
    end;
  end;
end;

function TDis39Kmp.Nullstellen: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  //StrFmt(Befehl, 'AB34', [0]);  BCC Test
  Description.Assign(DescVerz);
  StrFmt(Befehl, '01#AZ#', [0]);
  BefLen := StrLen(Befehl);
  NullstellenId := Start(Befehl, BefLen);
  Result := NullstellenId;
end;

function TDis39Kmp.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescVerz);
  //StrFmt(Befehl, '01#DR#01#%s', [Beizeichen]);
  StrFmt(Befehl, '01#DR#%02.2d#%s', [GerNr, Beizeichen]);
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  Result := ProtGewichtId;
end;

function TDis39Kmp.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescDirekt);
  StrFmt(Befehl, '01#TG#', [0]);     {AKW mit #}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TDis39Kmp.LeseKontakte: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescDirekt);
  StrFmt(Befehl, '01#TK#', [0]);     {Polen}
  BefLen := StrLen(Befehl);
  LeseKontakteId := Start(Befehl, BefLen);
  Result := LeseKontakteId;
end;

function TDis39Kmp.SetzeKontakte(Kontakte: TKontakte): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  Description.Assign(DescDirekt);
  StrFmt(Befehl, '01#EK#%d#%d#%d#%d#', [Ord(Kontakte[1]), Ord(Kontakte[2]),
                 Ord(Kontakte[3]), Ord(Kontakte[4])]);     {Polen}
  BefLen := StrLen(Befehl);
  SetzeKontakteId := Start(Befehl, BefLen);
  Result := SetzeKontakteId;
end;

end.
