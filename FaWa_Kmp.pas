unit Fawa_kmp;
(* Fahrzeugwaage allgemein
   19.07.00 TS +neue Fehlermeldungen
   17.12.02 TS +fwsProtNr
   16.01.03 JP +fwsWaageNr
   13.12.04 TS +fwsSpeicherfehler
   18.01.05 TS +SwitchMessNr(AMessNr: integer): longint;
   24.03.05 TS +OnSwitchMessNr
   03.11.07 MD ProtGewicht hierher (von Row7, wt65, wt60, it30)
   24.03.08 MD DoOnProtGewicht wg Compilerwarnung
   20.05.11 md DWT800 Net caminau: Bruecke, SwitchMessNr
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, CPro_kmp;

const
  SHoleGewicht = 'HoleGewicht';
  SZeilendruck = 'Zeilendruck';
  SNullstellen = 'Nullstellen';
  SHoleStatus = 'HoleStatus';
  SProtGewicht = 'ProtGewicht';
  SQuittieren = 'Quittieren';
  SDruckeBlock = 'DruckeBlock';
  SDelSpNr = 'DelSpNr';
  SProtNr = 'ProtNr';
  SSchranke = 'Schranke';
  SSwitchMessnummer = 'SwitchMessnummer';
  SSetzeAusgang = 'SetzeAusgang';
  SAmpel = 'Ampel';     //Ampel setzen  R=Rot  G=Grün Y=Gelb
    SAmpelRed = 'R';
    SAmpelGreen = 'G';
    SAmpelYellow = 'Y';
  SBarcode = 'Barcode'; //Barcode abfragen ergibt 0=kein Barcode

type
  TFaWaStatus = set of (fwsKeinStillstand, fwsGewichtOK,
    fwsKeinGewicht, fwsWaagenstoerung, fwsDruckerstoerung, fwsTimeOut,
    fwsNull,
    {Über/Unterbereich (Widra)}
    fwsBereichsfehler, fwsUeberlast, fwsUnterlast, fwsNullbereichsfehler,
    fwsGrenzwert,
    fwsPosition,            // Position Lichtschranke
    fwsProtNr,       // Flag, das Protnr. eine echte ProtNr und keine SpNr ist; Nr. wurde von
                     // Waage auf Alibidrucker gedruckt, darf nicht überschrieben werden
    fwsWaagenNr,             // Waage nicht kalibriert oder falscher Waagenkanal
    fwsSpeicherfehler        // Speicher voll oder Speicher nicht belegt
    );

  //TFaWaProtokoll = (fwpSOH, fwpSTX, fwpSTX_ACK, fwp3964, fwpSTX_ACK2 {OVACO});
  TFaWaProtokoll = (fwp3964, fwpSOH, fwpSTX, fwpSTX_ACK, fwpSTX_ACK2 {OVACO},
                    fwpDis8785, fwpDis8672);              {TS V3.12j, für Dwt10Kmp}
  TProtGewichtEvent = procedure(ATelId: longint; AGewicht: double;
    AProtNr: longint; AStatus: TFaWaStatus) of object;
  TFaWaStatusEvent = procedure(ATelId: longint; AGewicht: double;
    AStatus: TFaWaStatus) of object;
  TNullstellenEvent = procedure(ATelId: longint; AStatus: TFaWaStatus) of object;
  TGenProtNrEvent = function(GerNr: integer): longint of object;
  TSwitchMessNrEvent = procedure(ATelId: longint; NewMessNr: Integer;
    AStatus: TFaWaStatus) of object;

  TFaWaKmp = class(TComProt)
  private
    { Private-Deklarationen }
    FPolling : boolean;
    FPrgGerNr : Integer;     {Gerätenummer innerhalb Programm (für Waagenserver)}
    FGerNr : integer;        {Gerätenummer für Polling}
    FBcc : boolean;
    FNk : integer;           {0,-1,-2,+1,+2,...}
    FGE : string;            {t, kg}
    FAutoQuitt: boolean;     {automatisch Quittieren (Rowa)}
    FFormLen: integer;       {Formularlänge}
    FProtDruck: boolean;
    procedure SetPolling(Value: boolean);
    procedure SetGerNr(Value: integer);
    procedure SetGE(const Value: string);
  protected
    { Protected-Deklarationen }
    FMessNr: integer;                {Messverstärker Nr, WT65, Row7, Dwt410}
                                     //123, 12, 23, 1, 2, 3 (DWT800 CKW in DWT410kmp)
    FOnProtGewicht: TProtGewichtEvent;
    FOnStatus : TFaWaStatusEvent;
    FOnNullstellen : TNullstellenEvent;
    FOnZeilendruck: TNullstellenEvent;
    FOnGenProtNr: TGenProtNrEvent;
    FOnSwitchMessNr: TSwitchMessNrEvent;
    FOnSetzeAusgang: TNullstellenEvent;
    DruckIndex: integer;
    DruckBlock: TStringList;
    procedure BuildDescription; virtual;
  public
    { Public-Deklarationen }
    Display: string;
    Gewicht: double;
    NachK: integer;
    FaWaStatus: TFaWaStatus;
    ProtNr: longint;
    SpeicherNr: string;  // Soehnle: 'A' eintragen - 16.05.10
    ProtZeile1, ProtZeile2: string;         {Beizeichen in ProtGewicht}
    Beizeichen: string;                     {Beizeichen in ProtGewicht für Simul}
    StatusId,
    ProtGewichtId,
    NullstellenId,
    QuittId,
    DruckId,
    DelSpNrId: longint;
    DelTaraId: longint;
    SwitchMessNrId: longint;
    SetzeAusgangId: longint;
    Bruecke: string;  //A, B, C oder '' (DWT800)
    SimError, SimStoer, SimStill, SimSpNr: integer;
    SimProtNr,
    SimGewicht: longint;
    SimEing1, SimEing2: integer;  //Simulation Eingänge
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetActive(Value: boolean); override;
    procedure Init; virtual;
    procedure StrToGewichtGe(GewStr, WaGE: string; waNk: Integer; var Gewicht: double);
    // Gewicht und NachK anhand WaGe und Ge berechnen
    procedure StrToGewicht(GewStr: string; var Gewicht: double);
    procedure GewichtToStr(AGewicht: double; var GewStr: string);
    function FaWaStatusStr(AStatus: TFaWaStatus): string;
    function Zeilendruck(Zeile: string): longint; virtual;
    procedure HoleGewicht(var Gewicht: double); virtual;    {alt}
    function ProtGewicht(Beizeichen: string): longint; virtual;
    function HoleStatus: longint; virtual;
    function Nullstellen: longint; virtual;
    function Quittieren: longint; virtual;
    function DruckeBlock(ABlock: TStrings): longint; virtual;
    function DelSpNr(SpNr: integer): longint; virtual;
    function GenProtNr: longint; virtual;        {neue ProtNr erzeugen}
    function SwitchMessNr(AMessNr: integer): longint; virtual;
    function SetzeAusgang(Ausgang: Integer; Value: Boolean): longint; virtual;
    procedure DoOnProtGewicht(Tel_ID: longint; Gewicht: double; ProtNr: longint;
      FaWaStatus: TFaWaStatus);
    property MessNr: integer read FMessNr write FMessNr;
  published
    { Published-Deklarationen }
    property Polling : boolean read FPolling write SetPolling;
    property PrgGerNr : integer read FPrgGerNr write FPrgGerNr;
    property GerNr : integer read FGerNr write SetGerNr;
    property Bcc : boolean read FBcc write FBcc;
    property Nk : integer read FNk write FNk;
    property GE : string read FGE write SetGE;
    property AutoQuitt: boolean read FAutoQuitt write FAutoQuitt;
    property FormLen: integer read FFormLen write FFormLen;
    property ProtDruck: boolean read FProtDruck write FProtDruck;

    property OnProtGewicht: TProtGewichtEvent read FOnProtGewicht write FOnProtGewicht;
    property OnStatus : TFaWaStatusEvent read FOnStatus write FOnStatus;
    property OnNullstellen: TNullstellenEvent read FOnNullstellen write FOnNullstellen;
    property OnZeilendruck: TNullstellenEvent read FOnZeilendruck write FOnZeilendruck;
    property OnGenProtNr: TGenProtNrEvent read FOnGenProtNr write FOnGenProtNr;
    property OnSwitchMessNr: TSwitchMessNrEvent read FOnSwitchMessNr write FOnSwitchMessNr;
    property OnSetzeAusgang: TNullstellenEvent read FOnSetzeAusgang write FOnSetzeAusgang;
  end;

implementation

uses
  Math,
  Prots, Ini__Kmp, Err__Kmp;

(*** Hilfsfunktionen ********************************************************)

procedure TFaWaKmp.StrToGewichtGe(GewStr, WaGE: string; waNk : Integer;
                                  var Gewicht: double);
{ Gewicht und NachK anhand WaGe und Ge berechnen
   . oder , im String berücksichtigen
   Ist im String ein . oder , enthalten, dann wird waNk mit 0 angenommen
   waNk gibt an, wie viele Nk's im von der Waage gelieferten String implizit
   enthalten sind
   z.B. Pfister: GewStr '250' (t), WaNk=2 sind 2,5 Tonnen
     oder Widra: GewStr 8300 (kg), WaNk=3 sind 8,3 Tonnen  }
var
  pPkt, pKomma: Integer;
  OldThousandSeparator, OldDecimalSeparator: Char;
begin
  if GE = '' then GE := 't';
  if waGE = '' then waGE := GE;

  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  OldThousandSeparator := FormatSettings.ThousandSeparator;
  Nk := 0;
  NachK := 2;                           // t Standard

  pPkt := Pos('.', GewStr);
  pKomma := Pos(',', GewStr);
  if (pPkt) > 0 then
  begin
    waNk := 0;
    if FormatSettings.DecimalSeparator = ',' then
    begin
      FormatSettings.DecimalSeparator := '.';
      FormatSettings.ThousandSeparator := ',';
    end;
  end;
  if (pKomma > 0) and (pKomma > pPkt) then
  begin
    waNk := 0;
    if FormatSettings.DecimalSeparator = '.' then
    begin
      FormatSettings.DecimalSeparator := ',';
      FormatSettings.ThousandSeparator := '.';
    end;
  end;

  // nur "vernünftige" Kombinationen (t-t, t-kg, kg-kg, kg-t)
  if UpperCase(GE) = 'T' then           // Programm in t
  begin
    NachK := 2;
    if UpperCase(WaGE) = 'KG' then Nk := -3;
  end
  else if UpperCase(GE) = 'KG' then     // Programm in kg
  begin
    NachK := 0;
    if UpperCase(WaGE) = 'T' then Nk := 3;
  end;
  Nk := Nk - WaNk;

  Gewicht := RoundDec(StrToFloatTol(GewStr) * Power(10, Nk), NachK);
  FormatSettings.DecimalSeparator := OldDecimalSeparator;
  FormatSettings.ThousandSeparator := OldThousandSeparator;
end;

procedure TFaWaKmp.StrToGewicht(GewStr: string; var Gewicht: double);
var
  P: integer;
begin
  if Nk = 0 then  //SQVA Dwt410 '0,18'
  begin
    Gewicht := StrToFloatIntl(GewStr);
    P := IMax(Pos(',', GewStr), Pos('.', GewStr));
    if P > 0 then  //FaWaWS.WSWaaCliChange
      NachK := length(GewStr) - P else
      NachK := 0;
  end else
  begin
    if Nk < 0 then
      NachK := -Nk else
      NachK := 0;
    Gewicht := RoundDec(StrToFloatIntl(GewStr) * Power(10, Nk), NachK);
  end;
end;

procedure TFaWaKmp.GewichtToStr(AGewicht: double; var GewStr: string);
begin
  if Nk < 0 then
    NachK := -Nk else
    NachK := 0;
  GewStr := Format('%5.*f %s', [NachK, AGewicht, GE]);
end;

function TFaWaKmp.FaWaStatusStr(AStatus: TFaWaStatus): string;
var
  S: string;
begin
  S := '';
  if fwsKeinStillstand in AStatus then  AppendTok(S, 'Kein Stillstand', ',');
  if fwsGewichtOK in AStatus then       AppendTok(S, 'OK', ',');
  if fwsKeinGewicht in AStatus then     AppendTok(S, 'Kein Gewicht', ',');
  if fwsNull in AStatus then            AppendTok(S, 'Null Gewicht', ',');
  if fwsWaagenstoerung in AStatus then  AppendTok(S, 'Waagenstörung', ',');
  if fwsDruckerstoerung in AStatus then AppendTok(S, 'Druckerstörung', ',');
  if fwsTimeOut in AStatus then         AppendTok(S, 'Keine Verbindung', ',');
  if fwsBereichsfehler in AStatus then  AppendTok(S, 'Bereichsfehler', ',');
  if fwsUeberlast in AStatus then       AppendTok(S, 'Ueberlast', ',');
  if fwsUnterlast in AStatus then       AppendTok(S, 'Unterlast', ',');
  if fwsNullbereichsfehler in AStatus then AppendTok(S, 'Nullbereichsfehler', ',');
  if fwsGrenzwert in AStatus then       AppendTok(S, 'Grenzwertfehler', ',');
  if fwsPosition in AStatus then        AppendTok(S, 'Positionsfehler', ',');
  if fwsWaagenNr in AStatus then        AppendTok(S, 'Falsche Waagennummer', ',');
  if fwsSpeicherfehler in AStatus then  AppendTok(S, 'Speicherfehler', ',');
  result := '(' + S + ')';
end;

(*** Methoden ***************************************************************)

procedure TFaWaKmp.SetPolling(Value: boolean);
begin
  FPolling := Value;
  BuildDescription;
end;

procedure TFaWaKmp.SetGerNr(Value: integer);
begin
  FGerNr := Value;
  BuildDescription;
end;

procedure TFaWaKmp.SetGE(const Value: string);
begin
  FGE := Value;
  BuildDescription;  //Dwt410 hängt von GE ab
end;

procedure TFaWaKmp.BuildDescription;
begin
end;

constructor TFaWaKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DruckBlock := TStringList.Create;
  ProtDruck := true;  //ProtNr von Waage
end;

destructor TFaWaKmp.Destroy;
begin
  DruckBlock.Free;
  inherited Destroy;
end;

procedure TFaWaKmp.Init;
begin
end;

procedure TFaWaKmp.SetActive(Value: boolean);
begin
  inherited SetActive(Value);
  if not Value then
    Display := 'PAUSE';
end;

procedure TFaWaKmp.HoleGewicht(var Gewicht: double);
begin
  if assigned(FOnSimul) then
    Start(SHoleGewicht, length(SHoleGewicht));
end;

function TFaWaKmp.Zeilendruck(Zeile: string): longint;
begin
  if assigned(FOnSimul) then
    DruckId := Start(SZeilendruck, length(SZeilendruck)) else
    DruckId := -1;
  result := DruckId;
end;

function TFaWaKmp.Nullstellen: longint;
begin
  if assigned(FOnSimul) then
    NullstellenId := Start(SNullstellen, length(SNullstellen)) else
    NullstellenId := -1;
  result := NullstellenId;
end;

function TFaWaKmp.HoleStatus: longint;
begin
  if assigned(FOnSimul) then
    StatusId := Start(SHoleStatus, length(SHoleStatus)) else
    StatusId := -1;
  result := StatusId;
end;

function TFaWaKmp.ProtGewicht(Beizeichen: string): longint;
begin
  self.Beizeichen := Beizeichen;  //Zugriff von Simul
  if assigned(FOnSimul) then
    ProtGewichtId := Start(SProtGewicht, length(SProtGewicht)) else
    ProtGewichtId := -1;
  result := ProtGewichtId;
end;

function TFaWaKmp.Quittieren: longint;
begin
  if assigned(FOnSimul) then
    QuittId := Start(SQuittieren, length(SQuittieren)) else
    QuittId := -1;
  result := QuittId;
end;

function TFaWaKmp.DruckeBlock(ABlock: TStrings): longint;
begin
  if assigned(FOnSimul) then
    DruckId := Start(SDruckeBlock, length(SDruckeBlock)) else
    DruckId := -1;
  result := DruckId;
end;

function TFaWaKmp.DelSpNr(SpNr: integer): longint;
begin
  if assigned(FOnSimul) then
    DelSpNrId := Start(SDelSpNr, length(SDelSpNr)) else
    DelSpNrId := -1;
  result := DelSpNrId;
end;

function TFaWaKmp.GenProtNr: longint;
begin {neue ProtNr erzeugen.}
  if IniKmp <> nil then
  begin
    ProtNr := IniKmp.ReadInteger(Name, SProtNr, 100000);
    Inc(ProtNr);
    IniKmp.WriteInteger(Name, SProtNr, ProtNr);
  end else
  begin
    if ProtNr = 0 then
      ProtNr := 100000;
    Inc(ProtNr);
  end;
  result := ProtNr;
  Prot0('GENPROTNR %s %d', [Name, Result]);
end;

procedure TFaWaKmp.DoOnProtGewicht(Tel_ID: Integer; Gewicht: double;
  ProtNr: Integer; FaWaStatus: TFaWaStatus);
begin
  if assigned(FOnProtGewicht) then
  try
    FOnProtGewicht(Tel_ID, Gewicht, ProtNr, FaWaStatus);
  except on E:Exception do
    EProt(self, E, 'TFaWaKmp.DoOnProtGewicht(%d,%f,%d)', [Tel_ID, Gewicht, ProtNr]);
  end;
end;

function TFaWaKmp.SwitchMessNr(AMessNr: integer): longint;
begin
  if assigned( FOnSimul) then
    result := Start(SSwitchMessnummer, length(SSwitchMessnummer)) else
    result := -1;
end;

function TFaWaKmp.SetzeAusgang(Ausgang: Integer; Value: Boolean): longint;
begin
  if assigned(FOnSimul) then
    Result := Start(SSetzeAusgang, length(SSetzeAusgang)) else
    Result := -1;
end;

(*** User Funktions *******************************************************)


end.
