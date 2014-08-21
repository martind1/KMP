unit DisKKmp;
(* Schenk Disomat-K
   mit Fernanzeige (laufende EDV Übertragung)
   Statusereignis wird ohne Aufforderung gesendet

*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp, FaWa_Kmp, DPos_Kmp;

type
  TDoProtGewichtEvent = procedure(Sender: TObject; var ATelId: longint) of object;
  TUserBefEvent = procedure(ATelId: longint; AAntwort: string) of object;

type
  TDisKKmp = class(TFaWaKmp)
  private
    { Private-Deklarationen }
    FDescZykl: TStringList;
    FStep: integer;
  protected
    { Protected-Deklarationen }
    TmpProtId: longint;
    procedure BuildDescription; override;
  public
    { Public-Deklarationen }
    SimBuff: string;
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
  end;

implementation

uses
  Prots, NStr_Kmp, CPor_Kmp;

const
  POL = 112;           {kleines p}

(*** Initialisierung *********************************************************)

procedure TDisKKmp.BuildDescription;
begin
  inherited BuildDescription;
  Description.Clear;
  Description.Add(';Automatische Erzeugung. Ändern nicht möglich.');
  Description.Add('B:');
  Description.Add('S:^M');
  Description.Add('A:64,^J');               {EOL}
  { für zyklische Übertragung (AN5316 modifiziert) }
  FDescZykl.Clear;
  FDescZykl.Add('A:64,^J');               {EOL}
end;

constructor TDisKKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AntwLen := 255;
  Antwort := AnsiStrAlloc(AntwLen);
  FDescZykl := TStringList.Create;
end;

procedure TDisKKmp.Loaded;
begin
  inherited Loaded;
  BuildDescription;
end;

destructor TDisKKmp.Destroy;
begin
  StrDispose(Antwort);
  Antwort := nil;
  FDescZykl.Free;
  inherited Destroy;
end;

(*** Methoden ***************************************************************)

procedure TDisKKmp.Init;
begin
  inherited Init;
  StartFmt('ST%s', [FormatDateTime('hhnn', now)]);
  StartFmt('SD%s', [FormatDateTime('dd', date)]);
  StartFmt('SM%s', [FormatDateTime('mm', date)]);
  StartFmt('SY%s', [FormatDateTime('yy', date)]);
end;

(*** Ereignisgesteuerte Befehle **************************************)

procedure TDisKKmp.DoAntwort(Sender: TObject; Tel_Id: Longint);
var
  Empf: array[0..255] of AnsiChar;
  ATel: TTel;
  L, I1 : integer;
  S1, GewStr: string;
  cpStatus: TComProtStatus;
begin
  inherited DoAntwort(Sender, Tel_Id);   //Ereignis aufrufen
  L := sizeof(Empf) - 1;
  for I1 := 0 to L do
    Empf[I1] := #0;
  ATel := GetTel(Tel_Id);
  cpStatus := GetData(Tel_Id, Empf, L);
  Empf[L] := #0;
  if Tel_Id = StatusId then
  begin
    StatusID := -1;
    if (cpStatus = cpsOK) and (ord(Empf[0]) = STX) then
    begin
      FaWaStatus := [];
      S1 := String(StrLPas(Empf + 20, 1));
      I1 := Ord(Char1(S1));
      if (I1 and 1) <> 0 then
        FaWaStatus := FaWaStatus + [fwsGewichtOK];
      if (I1 and 2) = 0 then
        FaWaStatus := FaWaStatus + [fwsKeinStillstand];

      S1 := String(StrLPas(Empf + 21, 1));
      I1 := StrToIntTol(S1);
      case I1 of
        0: GE := 'kg';
        1: GE := 'g';
        2: GE := 'lb';
        3: GE := 't';
        4: GE := 'oz';
      end;

      GewStr := String(StrLPas(Empf + 1, 9));
      //StringReplace(GewStr, '.', ',', [rfReplaceAll, rfIgnoreCase]);
      GewStr := StrCgeChar(GewStr, '.', #0);
      GewStr := StrCgeChar(GewStr, ',', #0);
      StrToGewicht(GewStr, Gewicht);             {definiert NachK}
      GewichtToStr(Gewicht, Display);

      if assigned(FOnStatus) then
        FOnStatus(Tel_Id, Gewicht, FaWaStatus);
    end else
      Display := 'Fehler';
    if ProtGewichtId <= 0 then
    begin
      StatusId := Start('Status', 6);
      GetTel(StatusId).Description.Assign(FDescZykl); //kein Befehl senden
    end;
  end else
  if Tel_Id = TmpProtId then
  begin
    ATel.ID := ProtGewichtId;
    TmpProtId := -1;
    if (cpStatus <> cpsOK) or (Empf[0] = '?') then
    begin
      StatusId := StartFmt('SX', [0]);          //Start der zykl.Übertragung
      FaWaStatus := [fwsKeinGewicht];
      if assigned(FOnProtGewicht) then
        FOnProtGewicht(ProtGewichtId, Gewicht, ProtNr, FaWaStatus);
      ProtGewichtId := -1;
    end else
    begin
      ClearInput;
      case FStep of
        1: begin
             FStep := 2;
             TmpProtID := Start('XS', 2);
           end;
        2: begin //XS - Status
             //S1 := StrLPas(Empf + 0, 1);    //0=Tara 1=Brutto 2=Netto
             //S1 := StrLPas(Empf + 1, 1);    //1=Stillstand
             S1 := String(StrLPas(Empf + 0, 1));  //1=kein Stillstand 3=Stillstand 7=kein Mindestgewicht
             I1 := StrToIntTol(S1);
             if I1 in [1, 7] then
             begin
               StatusId := StartFmt('SX', [0]);          //Start der zykl.Übertragung
               if I1 = 1 then
                 FaWaStatus := [fwsKeinStillstand] else
                 FaWaStatus := [fwsUnterlast];
               if assigned(FOnProtGewicht) then
                 FOnProtGewicht(ProtGewichtId, Gewicht, ProtNr, FaWaStatus);
               ProtGewichtId := -1;
             end else
             begin
               FStep := 3;
               TmpProtID := Start('RN', 2);
             end;
           end;
        3: begin //RN
             S1 := String(StrLPas(Empf + 0, 7));
             ProtNr := StrToIntTol(S1);
             FStep := 4;
             TmpProtID := Start('PD', 2);
           end;
        4: begin //PD - Print Datum
             FStep := 5;
             TmpProtID := Start('PB04', 4);
           end;
        5: begin //PB - Print Blanks
             FStep := 6;
             TmpProtID := StartFmt('PW', [0]);
           end;
        6: begin //PW - Print Watch
             FStep := 7;
             TmpProtID := StartFmt('PO', [0]);
           end;
        7: begin //PO - Print Origin (ProtNr)
             FStep := 8;
             TmpProtID := StartFmt('PG', [0]);
           end;
        8: begin //PG - Print Gewicht
             GewStr := String(StrLPas(Empf + 5, 5));          //+6
             GewStr := StrCgeChar(GewStr, '.', #0);
             GewStr := StrCgeChar(GewStr, ',', #0);
             StrToGewicht(GewStr, Gewicht);             {definiert NachK}
             GewichtToStr(Gewicht, Display);
             FaWaStatus := [fwsGewichtOK];
             FStep := 9;
             TmpProtID := StartFmt('PE', [0]);
           end;
        9: begin //PE - Print EOL
             FStep := 10; //kein Result
             StatusId := StartFmt('SX', [0]);          //Start der zykl.Übertragung
             if assigned(FOnProtGewicht) then
               FOnProtGewicht(ProtGewichtId, Gewicht, ProtNr, FaWaStatus);
             ProtGewichtId := -1;
           end;
      end;
    end;
  end;
end;

procedure TDisKKmp.DoSimul(ATel: TTel);
(* Standard-Simulation. wird nur aufgerufen wenn OnSimul existiert *)
var
  Gew: Longint;
begin
  StrCopy(ATel.InData, '');
  Gew := SimGewicht;
  SimError := 3;
  if SimGewicht < 0 then
  begin
    SimError := 2;
    Gew := -SimGewicht;
  end;
  if StrLComp(ATel.OutData, 'Status', 6) = 0 then
  begin
    StrFmt(ATel.InData, '%s%9.2f%9.2f %s3',
      [chr(STX), Gew / 100, 0.0, IntToStr(SimError)]);
  end else
  if StrLComp(ATel.OutData, 'XS', 2) = 0 then
  begin
    StrFmt(ATel.InData, '%s', ['33']);
  end else
  if StrLComp(ATel.OutData, 'RN', 2) = 0 then
  begin
    if SimProtNr = 0 then
      SimProtNr := StrToInt(FormatDateTime('HHNNSS', now));
    StrFmt(ATel.InData, '%07.7d', [SimProtNr]);
    SimProtNr := SimProtNr + 1;
  end else
  if StrLComp(ATel.OutData, 'PG', 2) = 0 then
  begin
    StrFmt(ATel.InData, '%11.2f', [Gew / 100]);
  end else
  begin
    StrFmt(ATel.InData, '%s', ['OK']);
  end;
  ATel.InDataLen := StrLen(ATel.InData);
  inherited DoSimul(ATel);
end;

function TDisKKmp.ProtGewicht(Beizeichen: string): longint;
begin
  FStep := 1;
  ProtGewichtId := Start('EX', 2);
  TmpProtId := ProtGewichtId;
  Result := TmpProtId;
end;

function TDisKKmp.HoleStatus: longint;
begin
  if StatusID <= 0 then
  begin
    StatusId := Start('Status', 6);
    GetTel(StatusId).Description.Assign(FDescZykl);
  end;
  Result := StatusId;
end;

function TDisKKmp.DelSpNr(SpNr: integer): longint;
begin
  Result := -1;
end;

function TDisKKmp.Quittieren: longint;
begin
  Result := -1;
end;

function TDisKKmp.Zeilendruck(Zeile: string): longint;
begin
  Result := -1;
end;

function TDisKKmp.DruckeBlock(ABlock: TStrings): longint;
begin
  Result := -1;
end;

procedure TDisKKmp.UserFnk(ATel: TTel; FnkName : string);
begin
  inherited UserFnk(ATel, FnkName);
end;

end.
