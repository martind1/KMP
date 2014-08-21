unit Asws_Kmp;
(* Auswahl Definitionen
   Autor: Martin Dambach
   Letzte Änderung:
   10.05.97        Erstellen
   11.05.97        TAswComboBox
   05.07.97        #65 auf linker Seite entspr. 'A'
   26.07.98        FieldAsw, FieldAswIndex
   06.01.01        LoadFromIni
   25.04.01        function Asw()
   09.09.04        TComboBoxAsw: ohne DB mit Asw
   24.11.09        TAswCheckListBox: Wertet Field.ToStrings aus (http://www.delphipages.com/comp/tdbmulticheck-6079.html)
   17.02.10        TCheckListBoxAsw (ohne DB)
   18.02.10        TRadioGroupAsw (ohne DB)
                   NiceItems: Kommentare (;...) und Leerzeilen in Items ignorieren
   09.09.10        Bug bei Translate.
   17.07.11        FlagsAdd
   08.03.12        AutoComplete := false;
*)
interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBCtrls, StdCtrls, checklst,
  DPos_Kmp, LuDefKmp, Radios;

const
  CheckListTrenner = #$D#$A;  //CRLF - Trenner zwischen 2 Flags in AswCheckListBox Speicherformat

type
  TAsw = class(TComponent)
  private
    { Private-Deklarationen }
    FItems: TValueList;
    FNiceItems: TValueList;
    FParams: TStringList;
    FValues: TStringList;
    FLoadedItems: TValueList;  //enthält Originalwerte. i.V.m. AswsFrm/AswEdDlg
    procedure SetItems(Value: TValueList);
    procedure ItemsChange(Sender: TObject);
    function GetAswName: string;
    function IsNiceItem(I: integer): boolean;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure DeleteInIni;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindValue(Param: string): string;
    function FindIndex(Param: string): integer;
    function GetParam(Index: integer): string;
    function FindParam(Value: string): string;
    function MaxWidth: integer;
    function DlgValue(Titel: string; Fontsize: integer = 0): string; //Auswahldialog - Rückgabe Value oder ''
    function DlgIndex(Titel: string; Fontsize: integer = 0): integer; //Auswahldialog - Rückgabe Index oder -1
    function FormatFilter(S: string): string;  //ersetzt die Params durch Values, getrennt durch Blockzeichen
    function UnFormatFilter(S: string): string;  //ergibt Speicherformat von Klartext Filter
    property AswName: string read GetAswName;
    property LoadedItems: TValueList read FLoadedItems;
    property Params: TStringList read FParams;
    property Values: TStringList read FValues;
    property NiceItems: TValueList read FNiceItems;
  published
    { Published-Deklarationen }
    property Items: TValueList read FItems write SetItems;
  end;

  TAsws = class(TObject)
  private
    function GetAsws(const AswName: string): TAsw;
  public
    procedure TrInit; (* Initialisierung der Translations *)
    function IndexOf(const AswName: string): integer;
    function Asw(Index: integer): TAsw;
    function FirstAsw(var ResultAsw: TAsw): integer;
    function NextAsw(Handle: integer; var ResultAsw: TAsw): integer;
    function FindAsw(const AswName: string): TAsw;
    (* Findet Asw ohne Exception wenn fehlt *)
    function AswByName(const AswName: string): TAsw;
    (* Findet Asw mit Exception wenn fehlt *)
    property Asws[const AswName: string]: TAsw read GetAsws; default;
  end;

  function Asws: TAsws;
  function Asw(const AswName: string): TAsw;

type

  TAswComboBox = class(TDBComboBox)
  private
    { Private-Deklarationen }
    FAswName: string;
    FLookUpSource: TLookUpDef;
    FLookUpField: string;
    procedure SetAswName(Value: string);
    function AswGetDataField: string;
    procedure AswSetDataField(const Value: string);

  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    //12.11.12 ist tödlich warum=unknown - procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    function Asw: TAsw;
  published
    { Published-Deklarationen }
    property AswName: string read FAswName write SetAswName;
    property DataField: string read AswGetDataField write AswSetDataField;
    property LookupSource: TLookUpDef read FLookUpSource write FLookUpSource;
    property LookupField: string read FLookUpField write FLookUpField;
  end;

  TAswCheckBox = class(TDBCheckBox)
  private
    { Private-Deklarationen }
    FAswName: string;
    FLookUpSource: TLookUpDef;
    FLookUpField: string;
    procedure SetAswName(Value: string);
    function AswGetDataField: string;
    procedure AswSetDataField(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    { Public-Deklarationen }
    LoadedAllowGrayed: boolean;
  published
    { Published-Deklarationen }
    property AswName: string read FAswName write SetAswName;
    property DataField: string read AswGetDataField write AswSetDataField;
    property LookupSource: TLookUpDef read FLookUpSource write FLookUpSource;
    property LookupField: string read FLookUpField write FLookUpField;
  end;

  TAswRadioGroup = class(TDBRadioGroup)
  private
    { Private-Deklarationen }
    FAswName: string;
    FLookUpSource: TLookUpDef;
    FLookUpField: string;
    FFrame: TFrameStyle;
    procedure SetAswName(Value: string);
    function AswGetDataField: string;
    procedure AswSetDataField(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    { Public-Deklarationen }
  published
    { Published-Deklarationen }
    property AswName: string read FAswName write SetAswName;
    property DataField: string read AswGetDataField write AswSetDataField;
    property LookupSource: TLookUpDef read FLookUpSource write FLookUpSource;
    property LookupField: string read FLookUpField write FLookUpField;
    property Frame: TFrameStyle read FFrame write FFrame;
  end;

  //*** StringField, Trenner ist CRLF, Flags  ***
  TAswCheckListBox = class(TCheckListBox)
  private
    FDataLink:TFieldDataLink;
    FAswName: string;
    FValues: TStrings;
    procedure SetDataSource(const Value: TDataSource);
    function GetDataSource: TDataSource;
    function AswGetDataField: string;
    procedure AswSetDataField(const Value: string);
    procedure SetAswName(const Value: string);
    procedure SetValues(const Value: TStrings);
    function GetField: TField;
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
  protected
    procedure Loaded; override;
  public
    Modified:Boolean;
    LoadedColor: TColor;  //clWindow oder clBtnFace
    constructor Create(AOwner:TComponent);override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    destructor Destroy; override;
    procedure DataChange(Sender:TObject);
    procedure UpdateData(Sender:TObject);
    procedure EditingChange(Sender:TObject);
    procedure ClickCheck; override;
    property Field: TField read GetField;
  published
    property AswName: string read FAswName write SetAswName;
    property DataField: string read AswGetDataField write AswSetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Values: TStrings read FValues write SetValues;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  //*** String ohne DB, Trenner ist CRLF, Flags  ***
  TCheckListBoxAsw = class(TCheckListBox)
  private
    FAswName: string;
    FValues: TStrings;
    fReadOnly: Boolean;
    FFlags: string;
    procedure SetAswName(const Value: string);
    procedure SetValues(const Value: TStrings);
    procedure SetFlags(const Value: string);
  protected
    procedure Loaded; override;
  public
    Modified:Boolean;
    LoadedColor: TColor;  //clWindow oder clBtnFace
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    procedure DataChange(Sender:TObject);
    procedure UpdateData(Sender:TObject);
    procedure ClickCheck; override;
    function FlagsString(Trenner: string): string;  //falls CRLF als Trenner unpassend
  published
    property AswName: string read FAswName write SetAswName;
    property Values: TStrings read FValues write SetValues;
    property ReadOnly: Boolean read fReadOnly write fReadOnly default False;
    property Flags: string read FFlags write SetFlags;
  end;

  TComboBoxAsw = class(TCustomComboBox)
  private
    { Private-Deklarationen }
    FAswName: string;
    FValues: TStrings;
    procedure SetAswName(Value: string);
    function GetValue: string;
    procedure SetValue(const Value: string);
    procedure SetValues(const Value: TStrings);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Asw: TAsw;
    property Value: string read GetValue write SetValue;
  published
    { Published-Deklarationen }
    property Values: TStrings read FValues write SetValues;
    {property Style; {den nicht. fest auf csDropDownList}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    //property Style;  //09.02.11
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
    property Items; { Must be published after OnMeasureItem }
    property AswName: string read FAswName write SetAswName;  //muß hinter items
    property ItemIndex;  //hinter Items?
  end;

  TRadioGroupAsw = class(TRadios)
  private
    { Private-Deklarationen }
    FAswName: string;
    FValues: TStrings;
    procedure SetAswName(Value: string);
    function GetValue: string;
    procedure SetValue(const Value: string);
    procedure SetValues(const Value: TStrings);
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Asw: TAsw;
  published
    { Published-Deklarationen }
    property Values: TStrings read FValues write SetValues;
    property Value: string read GetValue write SetValue;
    property Items; { Must be published after OnMeasureItem }
    property AswName: string read FAswName write SetAswName;  //muß hinter items
  end;

  function FieldAsw(AField: TField): TAsw;
  {Liefert die Asw eines Fields}
  function FieldAswIndex(AField: TField): integer;
  {Liefert den Index der Asw eines Fields bzgl. aktuellem Feldinhalt oder -1}

  function FlagsTest(Flags, Test: string): boolean;
  //TAswCheckListBox: Liefert true wenn Test in Flags enthalten ist
  function FlagsAdd(Flags: string; Values: array of string): string;
  //Baut Flags mit dem richtigen Trenner zusammen

implementation

uses
  Types,
  IniFiles,
  Prots, GNav_Kmp, Ini__Kmp, IniDbKmp, Err__Kmp, Asw__dlg, nstr_Kmp;

const
  AswSect = 'Asw.';
  IniName = 'ASWS.INI';

var
  FAsws: TAsws;

{ ohne Klasse }

function FieldAsw(AField: TField): TAsw;
{Liefert die Asw eines Fields}
begin
  result := Asws.Asw(AField.Tag);
end;

function FieldAswIndex(AField: TField): integer;
  {Liefert den Index der Asw eines Fields bzgl. aktuellem Feldinhalt oder -1}
begin
  try
    result := FieldAsw(AField).FindIndex(AField.AsString);
  except on E:Exception do
    begin
      result := -1;
      Prot0('FieldAswIndex:%s', [E.Message]);
    end;
  end;
end;

function FlagsTest(Flags, Test: string): boolean;
//Liefert true wenn Test in Flags enthalten ist
begin
  //24.01.10 mit IgnoreCase (WFAUSL)
  Result := IndexOfToken(Test, Flags, CRLF, true) >= 0;  //CRLF siehe TAswCheckListBox.UpdateData
  if Sysparam.ProtBeforeOpen then
    Prot0('FlagsTest(%s,%s):%d', [Flags, Test, Ord(Result)]);
end;

function FlagsAdd(Flags: string; Values: array of string): string;
//Baut Flags mit dem richtigen Trenner zusammen
var
  I: integer;
begin
  Result := Flags;
  for I := Low(Values) to High(Values) do
    AppendTok(Result, Values[I], CheckListTrenner);
end;

{ Asw }

function TAsw.DlgValue(Titel: string; Fontsize: integer = 0): string;
begin
  result := TDlgAsw.Execute(AswName, Titel, Fontsize);
end;

function TAsw.DlgIndex(Titel: string; Fontsize: integer): integer;
begin
  result := FindIndex(DlgValue(Titel, Fontsize));
end;

function TAsw.IsNiceItem(I: integer): boolean;
begin
  Result := (Trim(FItems[I]) <> '') and not BeginsWith(FItems[I], ';');
end;

procedure TAsw.ItemsChange(Sender: TObject);
var
  I: integer;
begin
  //nur gültige Items. Keine Leerzeilen, keine komentare die mit ';' beginnen
  FNiceItems.Clear;
  FParams.Clear;
  FValues.Clear;
  for I := 0 to FItems.Count - 1 do
    if IsNiceItem(I) then
    begin
      FNiceItems.Add(FItems[I]);
      FParams.Add(FItems.Param(I));
      FValues.Add(FItems.Value(I));
    end;
end;

procedure TAsw.SetItems(Value: TValueList);
begin
  if Value <> FItems then
    FItems.Assign(Value);
end;

function TAsw.GetAswName: string;
begin
  result := copy(Name, 4, 30);
end;

constructor TAsw.Create(AOwner: TComponent);
var
  I: integer;
begin
  inherited Create(AOwner);
  FItems := TValueList.Create;
  FNiceItems := TValueList.Create;
  FParams := TStringList.Create;
  FValues := TStringList.Create;
  FLoadedItems := TValueList.Create;
  FItems.OnChange := ItemsChange;
  if csDesigning in ComponentState then
  begin
    Tag := 1;
    for I:= 0 to Owner.ComponentCount-1 do
      if (Owner.Components[I] is TAsw) and (Owner.Components[I] <> self) then
        Tag := IMax((Owner.Components[I] as TAsw).Tag + 1, Tag);
  end;
end;

destructor TAsw.Destroy;
begin
  FreeAndNil(FItems);     {060100 Destroy;}
  FreeAndNil(FNiceItems);
  FreeAndNil(FParams);
  FreeAndNil(FValues);
  FreeAndNil(FLoadedItems);
  inherited Destroy;
end;

procedure TAsw.Loaded;
var
  I: integer;
begin
  inherited Loaded;
  {ShowMessage(Format('AswLoad Name(%s) Tag(%d)',[Name,Tag]));}
  if Tag = 0 then
  begin
    for I := 0 to Owner.ComponentCount - 1 do
      if (Owner.Components[I] is TAsw) and (Owner.Components[I] <> self) then
        Tag := IMax((Owner.Components[I] as TAsw).Tag + 1, Tag);
  end;
  if not (csDesigning in ComponentState) then
  begin
    (* wird nicht so angezeigt
    for I := 0 to FItems.Count - 1 do
    begin
      S1 := FItems.Param(I);
      S2 := StringReplace(FItems.Value(I), '\r', CRLF, [rfReplaceAll, rfIgnoreCase]);
      FItems[I] := Format('%s=%s', [S1, S2]);
    end; *)

    FLoadedItems.Assign(FItems);
    LoadFromIni;  //nur wenn IniDb.AswsFromIni=true bzw. 'ASWS.INI' existiert
  end;
end;

procedure TAsw.LoadFromIni;
var
  AIniFile: TIniFile;
begin
  if (IniKmp = IniDb) and IniDb.AswsFromIni then
  begin  //nur wenn Kennzeichen 'AswsFromIni' gesetzt
    IniKmp.ReadSectionValues(AswSect + AswName, FItems);
  end else
  if FileExists(AppDir + IniName) then
  begin  //nur wenn File 'ASWS.INI'; existiert:   (AswEdDlg)
    AIniFile := TIniFile.Create(AppDir + IniName);
    try
      AIniFile.ReadSectionValues(AswName, FItems);
    finally
      AIniFile.Free;
    end;
  end;
end;

procedure TAsw.SaveToIni;
var
  I: integer;
  AIniFile: TIniFile;
begin
  if IniKmp = IniDb then
  begin
    IniKmp.SectionTyp[AswSect + AswName] := stAnwendung;
    IniKmp.ReplaceSection(AswSect + AswName, FItems);
  end else
  begin
    AIniFile := TIniFile.Create(AppDir + IniName);
    try  //nur wenn File 'ASWS.INI'; existiert:   (AswEdDlg)
      AIniFile.EraseSection(AswName);
      for I := 0 to Items.Count - 1 do
        AIniFile.WriteString(AswName, Items.Param(I), Items.Value(I));
    finally
      AIniFile.Free;
    end;
  end;
end;

procedure TAsw.DeleteInIni;
var
  AIniFile: TIniFile;
begin
  if FileExists(AppDir + IniName) then            {'ASWS.INI';}
  begin
    AIniFile := TIniFile.Create(AppDir + IniName);
    try
      AIniFile.EraseSection(AswName);
    finally
      AIniFile.Free;
    end;
  end;
end;

function TAsw.FindValue(Param: string): string;
(* ergibt Langtext oder Param wenn nicht gefunden. Case sensitiv.
   für TNavLink.FieldOnGetText
*)
var
  I: integer;
begin
  {result := Items.Values[Param];  nein, denn wir wollen case sensitiv!}
  result := Param;                             {neu 1303000, bisher ''}
  for I:= 0 to NiceItems.Count-1 do
    if NiceItems.Param(I) = Param then
    begin
      result := NiceItems.Value(I);
      exit;
    end;
  {result := '';                                 weg 1303000}
end;

function TAsw.FormatFilter(S: string): string;
// für Ausgabe:  J;N -> Ja;Nein
var
  SL: TStringList;
  I: integer;
begin              //Konstanten von nstr_Kmp
  Result := '';
  SL := TStringList.Create;
  try                                     //IncludeTrenner, DoTrim
    StrTokenize(S, BlockTrenner + BetweenTrenner, SL, true, true);
    for I := 0 to SL.Count - 1 do
    begin
      if CharInSet(Char1(SL[I]), BlockTrenner + BetweenTrenner) then
        Result := Result + SL[I] else
        Result := Result + self.FindValue(SL[I]);  //J->Ja
    end;
  finally
    SL.Free;
  end;
end;

function TAsw.UnFormatFilter(S: string): string;
// für Speichern:  Ja;Nein -> J;N
// von TDlgAusw.Prepare
// 29.10.13 für TNavLink.FieldOnSetText
var
  S1, S2: string;
  I1: integer;
begin
  Result := '';
  S1 := '';
  S2 := TranslateSql(S);
  for I1 := 1 to length(S2) do
  begin
    if CharInSet(S2[I1], ['%', '?'] + OptTokens + BlockTrenner) then  {def.in nstr_kmp}
    begin
      if S1 <> '' then
      begin
        Result := Result + FindParam(S1);
        S1 := '';
      end;
      Result := Result + S2[I1];
    end else
      S1 := S1 + S2[I1];
  end;
  if S1 <> '' then
    Result := Result + FindParam(S1);
end;

function TAsw.FindIndex(Param: string): integer;
(* ergibt Index oder -1 wenn nicht gefunden *)
var
  I: integer;
begin
  for I:= 0 to NiceItems.Count-1 do
    if NiceItems.Param(I) = Param then
    begin
      result := I;
      exit;
    end;
  result := -1;
end;

function TAsw.GetParam(Index: integer): string;
(* ergibt bereinigte Linke Seite (#65 wird zu 'A' *)
begin
  result := Items.Param(Index);
  if copy(result, 1, 1) = '#' then
  try
    result := chr(StrToInt(copy(result, 2, length(result)-1)));
  except on E:Exception do
      ErrWarn('GetParam(%s):%d:%s',[Name, Index, E.Message]);
  end;
end;

function TAsw.FindParam(Value: string): string;
(* ergibt Kürzel oder '' wenn nicht gefunden. tolerant über max. Länge
   für TNavLink.FieldOnSetText
*)
var
  I, N, nMax: integer;
begin
  result := '';
  nMax := 0;
  for I:= 0 to NiceItems.Count-1 do      //Exakter Vergleich mit Value
  begin
    if AnsiCompareStr(Value, NiceItems.Value(I)) = 0 then
    begin
      result := GetParam(I);
      break;
    end else
      nMax := IMax(nMax, length(NiceItems.Value(I)));
  end;
  if result = '' then                //Case-Insensitiver Vergleich mit Value
    for I:= 0 to NiceItems.Count-1 do
    begin
      if AnsiCompareText(Value, NiceItems.Value(I)) = 0 then
      begin
        result := GetParam(I);
        break;
      end else
        nMax := IMax(nMax, length(NiceItems.Value(I)));
    end;
  if (result = '') and (length(Value) >= 2) then //exakter Vergleich mit Teilstrings ab 2 von Value
  begin
    for N := nMax-1 downto 2 do
    begin
      for I:= 0 to NiceItems.Count-1 do
        if AnsiCompareStr(copy(Value,1,N), copy(NiceItems.Value(I),1,N)) = 0 then
        begin
          result := GetParam(I);
          break;
        end;
      if result <> '' then break;
    end;
  end;
  if (result = '') and (length(Value) >= 2) then //case-insensitiver Vergleich mit Teilstrings ab 2 von Value
  begin
    for N := nMax-1 downto 2 do
    begin
      for I:= 0 to NiceItems.Count-1 do
        if AnsiCompareText(copy(Value,1,N), copy(NiceItems.Value(I),1,N)) = 0 then
        begin
          result := GetParam(I);
          break;
        end;
      if result <> '' then break;
    end;
  end;
  if result = '' then                //exakter Vergleich mit Param ab 17.10.13
    for I:= 0 to NiceItems.Count-1 do
    begin
      if AnsiCompareStr(Value, NiceItems.Param(I)) = 0 then
      begin
        result := GetParam(I);
        break;
      end;
    end;
  if result = '' then                //case insensitiver Vergleich mit Param
    for I:= 0 to NiceItems.Count-1 do
    begin
      if AnsiCompareText(Value, NiceItems.Param(I)) = 0 then
      begin
        result := GetParam(I);
        break;
      end;
    end;
  if (result = '') and (length(Value) >= 1) then //exakter Vergleich 1. Zeichen
  begin
    for I:= 0 to NiceItems.Count-1 do
      if AnsiCompareStr(copy(Value,1,1), copy(NiceItems.Value(I),1,1)) = 0 then
      begin
        result := GetParam(I);
        break;
      end;
  end;
  if (result = '') and (length(Value) >= 1) then //case insensitiver Vergleich 1. Zeichen
  begin
    for I:= 0 to NiceItems.Count-1 do
      if AnsiCompareText(copy(Value,1,1), copy(NiceItems.Value(I),1,1)) = 0 then
      begin
        result := GetParam(I);
        break;
      end;
  end;
end;

function TAsw.MaxWidth: integer;
//Ergibt größte Breite der Values
var
  I: integer;
begin
  result := 0;
  for I:= 0 to NiceItems.Count-1 do
  begin
    result := IMax(result, length(NiceItems.Value(I)));
  end;
end;

{ TAsws }

function TAsws.GetAsws(const AswName: string): TAsw;
begin
  result := FindAsw(AswName);
end;

function TAsws.FindAsw(const AswName: string): TAsw;
(* Findet Asw. Ergibt nil wenn fehlt *)
begin
  if GNavigator = nil then
    result := nil else
    result := (GNavigator.Owner as TForm).FindComponent('ASW' + AswName) as TAsw;
end;

function TAsws.AswByName(const AswName: string): TAsw;
(* Findet Asw. Exception wenn fehlt *)
begin
  result := FindAsw(AswName);
  if result = nil then
  begin
    EError('Auswahl (%s) fehlt', [AswName]);
  end;
end;

function TAsws.IndexOf(const AswName: string): integer;
begin
  result := AswByName(AswName).Tag;
end;

function TAsws.Asw(Index: integer): TAsw;
(* Ergibt Asw oder nil wenn nicht gefunden *)
var
  I: integer;
begin
  Result := nil;
  I := FirstAsw(Result);
  while I > 0 do
  begin
    if Result.Tag = Index then
      Exit;
    I := NextAsw(I, Result);
  end;
end;

function TAsws.FirstAsw(var ResultAsw: TAsw): integer;
(* Ergibt erste gefundene Asw (unsortiert) oder 0 *)
var
  I: integer;
  AForm: TForm;
begin
  result := 0;
  if GNavigator <> nil then
  begin
    AForm := GNavigator.Owner as TForm;
    for I:= 0 to AForm.ComponentCount-1 do
    begin
      if (AForm.Components[I] is TAsw) then
      begin
        resultAsw := AForm.Components[I] as TAsw;
        result := I;
        Exit;
      end;
    end;
  end;
end;

function TAsws.NextAsw(Handle: integer; var ResultAsw: TAsw): integer;
(* Ergibt erste gefundene Asw (unsortiert) oder 0  (für PropEd)
 * Handle: Ergebnis von FirstAsw bzw. vorherigem NextAsw *)
var
  I: integer;
  AForm: TForm;
begin
  result := 0;
  if GNavigator <> nil then
  begin
    AForm := GNavigator.Owner as TForm;
    for I:= Handle + 1 to AForm.ComponentCount-1 do
    begin
      if (AForm.Components[I] is TAsw) then
      begin
        resultAsw := AForm.Components[I] as TAsw;
        result := I;
        Exit;
      end;
    end;
  end;
end;

procedure TAsws.TrInit;
(* Initialisierung der Translations
   die Asws müssen auf der gleichen Form wie der GNavigator liegen
*)
var
  I, I1: integer;
  AForm: TForm;
  AAsw: TAsw;
begin
  if GNavigator <> nil then
  begin
    AForm := GNavigator.Owner as TForm;
    AAsw := nil;
    for I := 0 to AForm.ComponentCount- 1 do
      if AForm.Components[I] is TAsw then
      try
        AAsw := AForm.Components[I] as TAsw;
        AAsw.Items.BeginUpdate;
        for I1 := 0 to AAsw.Items.Count - 1 do
          if AAsw.IsNiceItem(I1) then
          begin
            AAsw.Items[I1] := Format('%s=%s', [AAsw.Items.Param(I1),
              GNavigator.TranslateStr(AAsw, AAsw.Items.Value(I1))]);
          end;
      finally
        AAsw.Items.EndUpdate;
      end;
  end;
end;

function Asws: TAsws;
begin
  if FAsws = nil then
    FAsws := TAsws.Create;
  result := FAsws;
end;

function Asw(const AswName: string): TAsw;
begin
  result := Asws.FindAsw(AswName);
end;

{ TAswComboBox }

function TAswComboBox.AswGetDataField: string;
begin
  result := inherited DataField;
end;

procedure TAswComboBox.AswSetDataField(const Value: string);
begin
  inherited DataField := Value;
  if not (csLoading in ComponentState) then
    SetAswName(FAswName);
end;

constructor TAswComboBox.Create(AOwner: TComponent);
begin
  inherited;
  AutoComplete := false;
end;

function TAswComboBox.Asw: TAsw;
begin
  result := Asws.FindAsw(FAswName);
end;

procedure TAswComboBox.SetAswName(Value: string);
var
  AAsw: TAsw;
  AField: TField;
  I: integer;
begin
  if GNavigator = nil then  {zu früh}
  begin
    FAswName := Value;
    exit;
  end;
  AAsw := nil;
  AField := Field;
  if (AField = nil) and (DataField <> '') and (DataSource <> nil) and
     (DataSource.DataSet <> nil) then
  begin
    if DataSource.DataSet.FieldCount > 0 then
      AField := DataSource.DataSet.FindField(DataField);
    (*if DataSource.DataSet.FieldCount = 0 then
    begin
      FldDsc.Update(DataSource.DataSet, DsGetNavLink(DataSource).TblName,
        DsGetNavLink(DataSource).SqlFieldList);
      {UpdateFieldDefs(DataSource.DataSet);}
    end;
    AField := DataSource.DataSet.FieldByName(DataField);*)
  end;
  if (AField <> nil) and (AField.Tag > 0) then
  begin
    AAsw := Asws.Asw(AField.Tag);
    if AAsw = nil then
      EError('Asw(%d) fehlt',[AField.Tag]);
    FAswName := AAsw.AswName;
  end else
  begin
    FAswName := Value;
    if Value <> '' then
      AAsw := Asws.AswByName(FAswName);       {Exc wenn fehlt}
  end;
  if AAsw <> nil then
  begin
    //09.09.10 weg Items.Assign(AAsw.Values);
    Items.Clear;
    for I := 0 to AAsw.NiceItems.Count-1 do
      Items.Add(AAsw.NiceItems.Value(I));
  end;
end;

procedure TAswComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpSource then
      LookUpSource := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

//procedure TAswComboBox.WMPaint(var Message: TWMPaint);
//begin
//  if (Field = nil) or (Field.IsNull) then
//    ItemIndex := -1;
//  inherited;
//end;

{ TAswCheckBox }

procedure TAswCheckBox.Loaded;
begin
  inherited Loaded;
  LoadedAllowGrayed := AllowGrayed;
end;

function TAswCheckBox.AswGetDataField: string;
begin
  result := inherited DataField;
end;

procedure TAswCheckBox.AswSetDataField(const Value: string);
begin
  inherited DataField := Value;
  if not (csLoading in ComponentState) then
    SetAswName(FAswName);
end;

procedure TAswCheckBox.SetAswName(Value: string);
var
  AAsw: TAsw;
  AField: TField;
begin
  if GNavigator = nil then  {zu früh}
  begin
    FAswName := Value;
    exit;
  end;
  AAsw := nil;
  AField := Field;
  if (AField = nil) and (DataField <> '') and (DataSource <> nil) and
     (DataSource.DataSet <> nil) then
  begin
    if DataSource.DataSet.FieldCount > 0 then
      AField := DataSource.DataSet.FieldByName(DataField);
  end;
  if (AField <> nil) and (AField.Tag <> 0) then
  begin
    AAsw := Asws.Asw(AField.Tag);
    if AAsw = nil then
      EError('Asw(%d) fehlt',[AField.Tag]);
    FAswName := AAsw.AswName;
  end else
  begin
    FAswName := Value;
    if Value <> '' then
      AAsw := Asws.AswByName(FAswName);        {Exc wenn fehlt}
  end;
  if AAsw <> nil then
  begin
    if AAsw.NiceItems.Count < 2 then
      EError('Auswahl(%s) muß mindestens 2 Einträge haben.',
        [AAsw.Name]);
    ValueChecked := AAsw.NiceItems.Value(0);
    ValueUnChecked := AAsw.NiceItems.Value(1);
  end;
end;

procedure TAswCheckBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpSource then
      LookUpSource := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

{ TAswRadioGroup }

function TAswRadioGroup.AswGetDataField: string;
begin
  result := inherited DataField;
end;

procedure TAswRadioGroup.AswSetDataField(const Value: string);
begin
  inherited DataField := Value;
  if not (csLoading in ComponentState) then
    SetAswName(FAswName);
end;

procedure TAswRadioGroup.SetAswName(Value: string);
var
  I: integer;
  AAsw: TAsw;
  Done: boolean;
  AField: TField;
begin
  if GNavigator = nil then  {zu früh}
  begin
    FAswName := Value;
    exit;
  end;
  Done := false;
  AAsw := nil;
  AField := Field;
  if (AField = nil) and (DataField <> '') and (DataSource <> nil) and
     (DataSource.DataSet <> nil) then
  begin
    if DataSource.DataSet.FieldCount > 0 then
      AField := DataSource.DataSet.FieldByName(DataField);
    (*if DataSource.DataSet.FieldCount = 0 then
      UpdateFieldDefs(DataSource.DataSet);
    AField := DataSource.DataSet.FieldByName(DataField);*)
  end;
  if (AField <> nil) and (AField.Tag <> 0) then
  begin
    AAsw := Asws.Asw(AField.Tag);
    if AAsw = nil then
      EError('Asw(%d) fehlt',[AField.Tag]);
    FAswName := AAsw.AswName;
  end else
  begin
    FAswName := Value;
    if Value <> '' then
      AAsw := Asws.AswByName(FAswName) else        {Exc wenn fehlt}
      Done := true;
  end;
  if not Done then
  begin
    Values.Clear;
    for I:= 0 to AAsw.NiceItems.Count-1 do
    begin
      Values.Add(AAsw.NiceItems.Value(I));
    end;
    Items.Assign(Values);  //Speicherwert wird in TNavLink.FieldOnSetText gesetzt
  end;
end;

procedure TAswRadioGroup.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if AComponent = LookUpSource then
      LookUpSource := nil;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TAswRadioGroup.Paint;
var
  H: Integer;
  R: TRect;
  C: array [Byte] of Char;
  CLen: Integer;
begin
  if FFrame = frLowered then
  begin
    inherited Paint;
  end else
  with Canvas do        {else nix. kein Rahmen!}
  begin
    Font := Self.Font;
    H := TextHeight('0');
    R := Rect(0, H div 2 - 1, Width, Height);
    StrPCopy(C, Text);
    if C[0] <> #0 then
    begin
      StrPCopy(C, Text);
      CLen := StrLen(C);
      R := Rect(8, 0, 0, H);
      DrawText(Handle, C, CLen, R, DT_LEFT or DT_SINGLELINE or DT_CALCRECT);
      Brush.Color := Color;
      DrawText(Handle, C, CLen, R, DT_LEFT or DT_SINGLELINE);
    end;
  end;
end;

{ TComboBoxAsw }

constructor TComboBoxAsw.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TStringList.Create;
  Style := csDropDownList;
  AutoComplete := false;
end;

destructor TComboBoxAsw.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TComboBoxAsw.Asw: TAsw;
begin
  result := Asws.FindAsw(FAswName);
end;

function TComboBoxAsw.GetValue: string;
begin
  if ItemIndex >= 0 then
    result := Values[ItemIndex] else
    result := '';
end;

procedure TComboBoxAsw.SetValue(const Value: string);
begin
  ItemIndex := Values.IndexOf(Value);
end;

procedure TComboBoxAsw.SetAswName(Value: string);
var
  I: integer;
  AAsw: TAsw;
begin
  FAswName := Value;
  if Value <> '' then
  begin
    if (csLoading in ComponentState) then
      AAsw := Asws.FindAsw(FAswName) else      {nil wenn fehlt}
      AAsw := Asws.AswByName(FAswName);        {Exc wenn fehlt}
    if AAsw <> nil then
    begin
      Values.Clear;
      Items.Clear;
      for I:= 0 to AAsw.NiceItems.Count-1 do
      begin
        Values.Add(AAsw.NiceItems.Param(I));
        Items.Add(AAsw.NiceItems.Value(I));
      end;
    end;
  end;
end;

procedure TComboBoxAsw.SetValues(const Value: TStrings);
begin
  if FValues <> Value then
    FValues.Assign(Value);
end;

{ TRadioGroupAsw }

constructor TRadioGroupAsw.Create(AOwner: TComponent);
begin
  inherited;
  FValues := TStringList.Create;
end;

destructor TRadioGroupAsw.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TRadioGroupAsw.Asw: TAsw;
begin
  result := Asws.FindAsw(FAswName);
end;

function TRadioGroupAsw.GetValue: string;
begin  //linke Seite der Asw
  if ItemIndex >= 0 then
    result := Values[ItemIndex] else
    result := '';
end;

procedure TRadioGroupAsw.SetValue(const Value: string);
begin
  ItemIndex := Values.IndexOf(Value);
end;

procedure TRadioGroupAsw.SetAswName(Value: string);
var
  AAsw: TAsw;
  I: integer;
begin
  FAswName := Value;
  if Value <> '' then
  begin
    if (csLoading in ComponentState) then
      AAsw := Asws.FindAsw(FAswName) else      {nil wenn fehlt}
      AAsw := Asws.AswByName(FAswName);        {Exc wenn fehlt}
    if AAsw <> nil then
    begin  //09.09.10 mit NiceItems
      Values.Clear;
      Items.Clear;
      for I:= 0 to AAsw.NiceItems.Count-1 do
      begin
        Values.Add(AAsw.NiceItems.Param(I));  //linke Seiten der Asw
        Items.Add(AAsw.NiceItems.Value(I));   //rechte Seiten der Asw
      end;
      //Values.Assign(AAsw.Params);
      //Items.Assign(AAsw.Values);
    end;
  end;
end;

procedure TRadioGroupAsw.SetValues(const Value: TStrings);
begin
  if FValues <> Value then
    FValues.Assign(Value);
end;

{ TAswCheckListBox }

function TAswCheckListBox.AswGetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TAswCheckListBox.AswSetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
  if not (csLoading in ComponentState) then
    SetAswName(FAswName);
end;

constructor TAswCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnEditingChange := EditingChange;
end;

procedure TAswCheckListBox.ClickCheck;
begin
  inherited ClickCheck;
  Modified := True;
  FDataLink.Modified;
  FDataLink.Edit;
  FDataLink.Modified;
end;

destructor TAswCheckListBox.Destroy;
begin
  FValues.Free;  //17.02.10
  FDataLink.Free;
  FDataLink := nil;
  inherited;
end;

procedure TAswCheckListBox.DataChange(Sender: TObject);
var
  I, N: Integer;
  L: TStringList;
begin
  if FDataLink.Field <> nil then
  begin
    //24.01.10 weg damit programmatisch änderbar. if not Modified then
    begin
      for I := 0 to Items.Count-1 do
        Checked[I] := False;
      L := TStringList.Create;
      L.Text := FDataLink.Field.AsString;
      for I := 0 to L.Count-1 do
      begin
        N := Values.IndexOf(L[I]);  //nicht Items!
        if N <> -1 then
          Checked[N] := True;
      end;
      L.Free;
    end;
  end;
end;

procedure TAswCheckListBox.UpdateData(Sender: TObject);
var
  I: Integer;
  L: TStringList;
begin
  L := nil;
  if FDataLink.Field <> nil then
  try
    L := TStringList.Create;
    for I := 0 to Items.Count-1 do
    begin
      if Checked[I] then
        L.Add(Values[I]);  //nicht Items!
    end;
    FDataLink.Field.AsString := RemoveTrailCrlf(L.Text);  //MD 24.11.09
  finally
    L.Free;
    Modified := False;
  end;
end;

procedure TAswCheckListBox.EditingChange(Sender: TObject);
begin
  if FDataLink.DataSet = nil then
    Exit;
  //ReadOnly := Not FDataLink.Editing;
  if FDataLink.DataSet.State = dsBrowse then
    Modified := False;
  if FDataLink.DataSet.State = dsEdit then
    Modified := True;
end;

function TAswCheckListBox.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TAswCheckListBox.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TAswCheckListBox.SetReadOnly(const Value: Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TAswCheckListBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TAswCheckListBox.SetAswName(const Value: string);
var
  AAsw: TAsw;
  AField: TField;
  I: integer;
begin
  if GNavigator = nil then  {zu früh}
  begin
    FAswName := Value;
    exit;
  end;
  AAsw := nil;
  AField := Field;
  if (AField = nil) and (DataField <> '') and (DataSource <> nil) and
     (DataSource.DataSet <> nil) then
  begin
    if DataSource.DataSet.FieldCount > 0 then
      AField := DataSource.DataSet.FieldByName(DataField);
  end;
  if (AField <> nil) and (AField.Tag <> 0) then
  begin
    AAsw := Asws.Asw(AField.Tag);
    if AAsw = nil then
      EError('TAswCheckListBox: Asw(%d) fehlt', [AField.Tag]);
    FAswName := AAsw.AswName;
  end else
  begin
    FAswName := Value;
    if Value <> '' then
      AAsw := Asws.AswByName(FAswName);       {Exc wenn fehlt}
  end;
  if AAsw <> nil then
  begin
    //Asws-Zeile: FLAG1=Mein 1. Flag -> Values[]=FLAG1  Items[]=Mein 1. Flag
    Values.Clear;
    Items.Clear;
    for I := 0 to AAsw.NiceItems.Count-1 do
    begin
      Values.Add(AAsw.NiceItems.Param(I));
      Items.Add(AAsw.NiceItems.Value(I));
    end;
    //09.09.10 weg Items.Assign(AAsw.Values);
    //             Values.Assign(AAsw.Params);
  end;
end;

procedure TAswCheckListBox.SetDataSource(const Value: TDataSource);
begin
  if FDataLink.DataSource <> Value then
  begin
    if Value <> nil then
    begin
      FDataLink.DataSource := Value;
      Value.FreeNotification(self);
    end;
  end;
end;

procedure TAswCheckListBox.SetValues(const Value: TStrings);
begin
  if FValues <> Value then
    FValues.Assign(Value);
end;

function TAswCheckListBox.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TAswCheckListBox.Loaded;
begin
  inherited Loaded;
  LoadedColor := Color;  //für BCCheckReadOnly
end;

{ TCheckListBoxAsw }

constructor TCheckListBoxAsw.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValues := TStringList.Create;
end;

destructor TCheckListBoxAsw.Destroy;
begin
  FValues.Free;
  inherited;
end;

procedure TCheckListBoxAsw.Loaded;
begin
  inherited Loaded;
  LoadedColor := Color;  //für BCCheckReadOnly
end;

procedure TCheckListBoxAsw.SetAswName(const Value: string);
var
  AAsw: TAsw;
  I: integer;
begin
  if GNavigator = nil then  {zu früh}
  begin
    FAswName := Value;
    exit;
  end;
  AAsw := nil;
  FAswName := Value;
  if Value <> '' then
    AAsw := Asws.AswByName(FAswName);       {Exc wenn fehlt}
  if AAsw <> nil then
  begin
    //Asws-Zeile: FLAG1=Mein 1. Flag -> Values[]=FLAG1  Items[]=Mein 1. Flag
    Values.Clear;
    Items.Clear;
    for I:= 0 to AAsw.NiceItems.Count-1 do
    begin
      Values.Add(AAsw.NiceItems.Param(I));
      Items.Add(AAsw.NiceItems.Value(I));
    end;
    //09.09.10 weg Items.Assign(AAsw.Values);
    //             Values.Assign(AAsw.Params);
  end;
end;

procedure TCheckListBoxAsw.SetValues(const Value: TStrings);
begin
  if FValues <> Value then
    FValues.Assign(Value);
end;

procedure TCheckListBoxAsw.ClickCheck;
begin
  inherited ClickCheck;
  UpdateData(self);  //berücksichtigt ReadOnly
  DataChange(self);
end;

procedure TCheckListBoxAsw.SetFlags(const Value: string);
begin
  FFlags := Value;
  DataChange(self);
end;

procedure TCheckListBoxAsw.DataChange(Sender: TObject);
// Flags -> Checked
var
  I, N: Integer;
  L: TStringList;
begin
  for I := 0 to Items.Count-1 do
    Checked[I] := False;
  L := TStringList.Create;
  try
    L.Text := FFlags;  //ist string
    for I := 0 to L.Count-1 do
    begin
      N := Values.IndexOf(L[I]);  //nicht Items!
      if N <> -1 then
        Checked[N] := True;
    end;
  finally
    L.Free;
  end;
end;

procedure TCheckListBoxAsw.UpdateData(Sender: TObject);
// Checked -> Flags
var
  I: Integer;
  L: TStringList;
begin
  L := nil;
  if not ReadOnly then
  try
    L := TStringList.Create;
    for I := 0 to Items.Count-1 do
    begin
      if Checked[I] then
        L.Add(Values[I]);  //nicht Items!
    end;
    FFlags := RemoveTrailCrlf(L.Text);  //MD 24.11.09
  finally
    L.Free;
  end;
end;

function TCheckListBoxAsw.FlagsString(Trenner: string): string;
begin
  Result := StringReplace(FFlags, CRLF, Trenner, [rfReplaceAll, rfIgnoreCase]);
end;

initialization

finalization
  FAsws.Free;
end.
