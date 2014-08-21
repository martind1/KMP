unit RAG701Kmp;
(* RAG701 für Tanna
23.06.10 md  erstellt
09.07.10 md  Leerzeichen in DescProt weg
--------------------------------------------------
*)
interface

uses
  Math,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, DPos_Kmp;

type
  TDoProtGewichtEvent = procedure(Sender: TObject; var ATelId: longint) of object;
  TUserBefEvent = procedure(ATelId: longint; AAntwort: string) of object;

type
  TRAG701 = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    fSendACK: boolean;
    DescrProt: TStringList;
    procedure StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
    procedure SetSendACK(const Value: boolean);
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
    property SendACK: boolean read fSendACK write SetSendACK;
  end;

  // procedure Register;

implementation

uses
  Prots, NStr_Kmp, CPor_Kmp;


(*** Initialisierung *********************************************************)

procedure TRAG701.BuildDescription;
(*
Gewicht registrieren:
PC:    $02 24 41 03
Waage: ACK
       CR
       Nr.: [LfdNr] [Datum/Zeit] B: <[00000kg]>  N:~  T: ~
       $0A $0A
Wir verwenden den Brutto Wert (ab dem ersten '<')
*)
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add('S:^B');              {STX senden}
  Description.Add('B:');                {reine Daten}
  Description.Add('S:^C');              {ETX senden}
  if SendACK then
    Description.Add('W:^F');            {Warten auf ACK}
  Description.Add('W:^B');              {Warten auf STX}
  Description.Add('A:255,^C');          {Daten incl ETX}
  if SendACK then
    Description.Add('S:^F');            {ACK senden}

  //Protokolldruck:
  DescrProt.Clear;
  DescrProt.Add('S:^B');              {STX senden}
  DescrProt.Add('B:');                {reine Daten}
  DescrProt.Add('S:^C');              {ETX senden}
  if SendACK then
    DescrProt.Add('W:^F');              {Warten auf ACK}
  DescrProt.Add('A:255,$0A,$0A');       {Daten incl 2mal Linefeed $0A}
end;

constructor TRAG701.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  DescrProt := TStringList.Create;
end;

procedure TRAG701.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TRAG701.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  DescrProt.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TRAG701.Init;
begin
  inherited Init;
  Antwort[0] := chr(EOT);
  ComWrite(Antwort, 1);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TRAG701.StrToWaStat(Tok: PAnsiChar; var Status: TFaWaStatus);
(* Tok 1stellig, Bits 0-4 zählen
             Q = 51h = 0101 0001
                 Bit 0: (1)=Stillstand
                   2,1: (00)=OK, 01=Überlast, 10=Unterlast, 11=Fehler
                     3: (0)=OK  1=Exakt Null
                     4: (1)=OK  0=unter Mindestlast
                     5: (0)=Taraspeicher leer - egal
                     6: (1)=im Teilbereich - nicht ausgewertet
                     7: (0) immer
*)
begin
  if not BITIS( Ord(Tok[0]), $1) then Include( Status, fwsKeinStillstand);  {Gew.ungültig}
  if BITIS(Ord(Tok[0]), $2) and BITIS(Ord(Tok[0]), $1) then Include( Status, fwsKeinGewicht);
  if BITIS(Ord(Tok[0]), $2) and not BITIS(Ord(Tok[0]), $1) then Include( Status, fwsUnterlast);
  if not BITIS(Ord(Tok[0]), $2) and BITIS(Ord(Tok[0]), $1) then Include( Status, fwsUeberlast);
end;

procedure TRAG701.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  EmpfBuff : array[0..255] of AnsiChar;
  L : integer;
  ATel : TTel;
  S1, Netto: string;
  I, P: integer;
  S2, NextS: string;
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
        (* Antwort   Q1B5.234kg
             Q = 51h = 0101 0001
                 Bit 0: (1)=Stillstand
                   2,1: (00)=OK, 01=Überlast, 10=Unterlast, 11=Fehler
                     3: (0)=OK  1=Exakt Null
                     4: (1)=OK  0=unter Mindestlast
                     5: (0)=Taraspeicher leer - egal
                     6: (1)=im Teilbereich - nicht ausgewertet
                     7: (0) immer
             1 = Lastaufnehmer 1
             B = Brutto
        *)
        StrToWaStat(EmpfBuff+0, FaWaStatus);

        S1 := '';
        I := 3;
        while EmpfBuff[I] in ['0'..'9', ',', '.'] do
        begin
          if EmpfBuff[I] = '.' then
            S1 := S1 + ',' else
            S1 := S1 + String(EmpfBuff[I]);
          Inc(I);
        end;
        Netto := S1;

        S1 := '';
        while EmpfBuff[I] <> #0 do
        begin
          S1 := S1 + String(EmpfBuff[I]);
          Inc(I);
        end;
        GE := S1;

        P := Pos(',', Netto);
        if P > 0 then
        begin
          Nk := P - length(Netto);  //12,34 -> -2
          Netto := StrCgeChar(Netto, ',', #0);
        end;
        StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
        Display := Format('%5.*f %s', [NachK, Gewicht, GE]);

        if FaWaStatus = [] then
          Include(FaWaStatus, fwsGewichtOk);
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
          // CRNr.: [LfdNr] [Datum/Zeit] B: <[00000kg]>  N:~  T: ~

          S1 := String(StrPas(EmpfBuff));
          Prot0('Empfangener String (%s)', [S1]);

          S2 := PStrTok(S1, ' ', NextS);  //CRNr.:
          Prot0('Teil1(%s)', [S2]);

          S2 := PStrTok('', ' ', NextS);  //Eichnr
          Prot0('Eichnr(%s)', [S2]);
          ProtNr := StrToIntTol(S2);

          P := Pos('<', S1);
          Prot0('Brutto ab %d(%s)', [P, copy(S1, P, 9)]);
          I := P + 1;
          Netto := '';
          while CharInSet(S1[I], ['0'..'9', ',', '.']) do
          begin
            if S1[I] = '.' then
              Netto := Netto + ',' else
              Netto := Netto + S1[I];
            Inc(I);
          end;

          P := Pos(',', Netto);
          if P > 0 then
          begin
            Nk := P - length(Netto);  //12,34 -> -2
            Netto := StrCgeChar(Netto, ',', #0);
          end;
          StrToGewicht(Netto, Gewicht);   // bzgl.Nk, setzt NachK
          Display := Format('<%5.*f>', [NachK, Gewicht, GE]);

          if not (fwsKeinGewicht in FaWaStatus) then
            Include(FaWaStatus, fwsGewichtOk);
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

    {Antwort auf Befehl Zeilendruck}
    if (Tel_Id = DruckId) then
    begin  //nichts zu tun. nur Ereignis auslösen.
      DruckId := -1;
      FaWaStatus := [];
      if assigned(FOnZeilendruck) then
        FOnZeilendruck(Tel_Id, FaWaStatus);
    end else

    begin
    end;
  end;
end;

procedure TRAG701.DoSimul(ATel: TTel);
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
  if (StrLComp(ATel.OutData, '&', 1) = 0) then  //Status
  begin  //Q1B5.234kg
    StrFmt(ATel.InData, 'Q1B%dkg', [SimGewicht]);
  end else
  if (StrLComp(ATel.OutData, '$A', 2) = 0) then  //ProtGewicht
  begin  //experemental
    StrFmt(ATel.InData, '%sNr.: %d B: <%dkg> N: <1111kg> T:  <0kg>  ', [
      Chr(CR), SimProtNr, SimGewicht]);
    Inc(SimProtNr);
  end else
  begin
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TRAG701.ProtGewicht(Beizeichen: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  ProtZeile1 := BeiZeichen;
  StrFmt(Befehl, '$A', [0]);         { $24 $41 -> Taste 'A' - Drucktaste}
  BefLen := StrLen(Befehl);
  ProtGewichtId := Start(Befehl, BefLen);
  GetTel(ProtGewichtId).Description.Assign(DescrProt);
  Result := ProtGewichtId;
end;

function TRAG701.HoleStatus: longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '&', [0]);         {S_D_NSTI, 26h, 38d, '&'}
  BefLen := StrLen(Befehl);
  StatusId := Start(Befehl, BefLen);
  Result := StatusId;
end;

function TRAG701.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TRAG701.Quittieren: longint;
begin
  Result := -1;
end;

function TRAG701.Zeilendruck(Zeile: string): longint;
var
  Befehl : array[0..200] of AnsiChar;
  BefLen: integer;
begin
  StrFmt(Befehl, '', [0]);  //keine Kommunikation. Nur OnAntwort.
  BefLen := StrLen(Befehl);
  DruckID := StartFlags(Befehl, BefLen, [cpfPoll, cpfDummy], '', 0);
  Result := DruckID;
end;

function TRAG701.DruckeBlock(ABlock: TStrings): longint;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to ABlock.Count - 1 do
  begin
    Zeilendruck(ABlock.Strings[I]);
  end;
end;

function TRAG701.GerAdr: AnsiChar;
begin
  Result := AnsiChar(chr(GerNr + ord('A') - 1));    {1 -> 'A'}
end;

procedure TRAG701.UserFnk(ATel: TTel; FnkName : string);
var
  Str: array[0..20] of AnsiChar;
begin
  if Uppercase(FnkName) = 'RAG701GERADR' then
  begin
    Str[0] := GerAdr;
    ComWrite(Str, 1);
  end else
    inherited UserFnk(ATel, FnkName);
end;

//in KMP__REG.PAS
//procedure Register;
//begin
//  RegisterComponents('COM', [TRAG701]);
//end;

procedure TRAG701.SetSendACK(const Value: boolean);
begin
  fSendACK := Value;
  BuildDescription;
end;

end.
