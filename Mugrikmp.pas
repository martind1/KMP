unit Mugrikmp;
(* MultiGrid Komponente. Ersetzt DBGrid

   Autor: Martin Dambach
   Letzte Änderung
   02.10.96    Erstellen
   05.03.98    PopupMenu
   03.06.99    RowHeight
   17.03.00    mit SlideBar
   02.04.00    mgDisable: Datasource=nil während NavLink.DoInsert bei mdDetail
   05.04.00    mit RowHeight
   07.04.00    nur noch Delphi32: DbGrid.TBookMarkString statt MarkList
   18.04.00    während csDesigning CalcFields automatisch laden
   20.04.00    Color-Steuerung über CheckFocus, von SetLink
   10.07.00    Rowheight komplett durch defaultrowheight ersetzt
   04.11.00    InvalidateEditor löscht 1.Eingabe bei Autoedit fixed
   04.01.01    CopyToHtml (markierte Zeilen zum Clipboard im Html Format +Rtf +Csv +Txt)
   05.01.01    EditLayout: Layout Editor: MuGriDlg
   17.01.01    SetIniSection(Name): 'Spalten.' + ClassName NICHT mehr angeben
   20.05.01    GridLineWidth im Public Bereich
   23.07.01    TranslateStr
   02.05.02    muNoAskLayout beerdigt
   28.01.03    vertikale Größenänderung (goRowSizing) wurde bei LuDef.AutoEdit=false nicht gesetzt
   15.10.03    Grossschrift anhand DBEdit. Standard-Btn setzt auch vertikale Größe zurück.
   31.12.03    Readonly:Farbe nicht umschlagen
   16.02.04    Anzahl markierte Datensätze in Statuszeile
   08.04.04    Hint:Reihenfolge mit der Maus ziehen;  KeyPressKey (GHS/Ibase)
   08.07.05    MarkAll (ohne Klasse)
   27.06.06    Sortieren bei Doubleclick in Spaltenüberschrift
   19.11.07
   09.01.08    Mittlere Maustaste markiert (auschließlich) aktuelle Zeile
   05.08.08    Tabellenlayout auch im Suchen-Modus: WriteColumns; GetDataSet
   12.07.09    proc AbortLoop
*  05.11.09    rechte Maustaste focussiert Grid
               OnPopup Ereignis
   26.08.10    CheckMusiButtons auch von egSetRecCount aus aufrufen (von nl.newafteropen) wg query.controlsdisabled
   21.12.11    Options: ,E = Ellipsis Button [...] anzeigen -> OnEditButtonClick
   25.04.13    Scrollbar bei lookup nicht sichtbar: UpdateScrollbar: override
   31.01.14    GlobalCount private statt lokal in SelectedRowsChanged. NameCounter global
               DragOver:OldRow private statt lokal
   30.05.14    OptimizeWidth Flag
   16.07.14    aktive Zeile hellblau färben (muColorActiveRow)
   ----------------------------------------------

   ColumnList zur Laufzeit temporär ändern (ohne Speichern): TempColumnList


*)
{ TODO : Optimale Tabellenbreite }

{ TODO : Auswahl als Picklist darstellen (esPickList) }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBCtrls, menus,
  DPos_Kmp, NLnk_Kmp, Prots;

type
  TMultiGrid = class;  //darf nicht in eigenem type-Abschnitt stehen - Delphi 5 Bug

  TMuOption = (muNoSaveLayout,       {Geändertes Layout nicht speichern}
               muNoAskLayout,        {Nicht fragen ob Layout speichern}
               muAutoExpand,         {Autom. in Erfassen bei neuer Zeile}
               muPostOnExit,         {Autom. Post bei Verlassen}
               muCustColor,          {Farbe (gelb,grün) nicht automatisch ändern}
               muSlideBar,           {dynamische Scrollbar}
               muNoSlideBar,         {keine dynamische Scrollbar trotz SysParam}
               muNoRowSize,          {Zeilenhöhe nicht änderbar.}
               muDrag,               {Ziehen innerhalb Grid erlauben}
               muEditColor,          {Farbe Edit-Zeile setzen trotz muCustColor}
               muAddPopUp,           {Standard Popup-Menü anhängen}
               muDuplPopUp,          {Popup duplizieren muss true sein wenn AddPopup und Popup mehrmals zugeordnet }
               muIncSearch,          {Test: Incrementelle Suche}
               muToggleEditor,       {true=Editor bei Eingabe sofort aktivieren }
                                     {     (1.Eingabetaste nicht verwerfen)     }
                                     {     verdoppelt 1.Taste in manchen Fällen!}
               muColorActiveRow,     {aktive Zeile färben}
               muNoColorActiveRow);  {aktive Zeile *nicht* färben (trotz Sysparam)}

  TBeginDragEvent = procedure(Sender: TObject; X, Y: Integer;
    var Allow: boolean) of object;

  TAbortLoopStep = (alsInit, alsDoIt, alsDone);
  TMuLoopOption = (mloSelected, mloShowAbort, mloDisableControls,
                   mloNotify, mloErrorNotify, mloConfirmation);
  TMuLoopOptions = set of TMuLoopOption;

  TAbortLoopEvent = procedure(Sender: TMultiGrid; Step: TAbortLoopStep; var Done: boolean) of object;

  TMuOptions = set of TMuOption;

  TMultiGrid = class(TDBGrid)
  private
    { Private-Deklarationen }
    FColumnList: TValueList;
    FVisibleColumnList: TValueList;
    FReturnSingle: boolean;
    FNoColumnSave: boolean;             {wird nicht mehr benutzt}
    FRowHeight: integer;                {RowHeight temporär speichern}
    LoadedRowHeight: integer;
    FMuOptions: TMuOptions;
    FIniSection: string;                {Section in .INI für Spaltenlayout}
    FOnLayoutChanged: TNotifyEvent;
    FOnBeginDrag: TBeginDragEvent;
    FOnAbortLoop: TAbortLoopEvent;  //nur zum Erzeugen des Skeletts
    FOnPopup: TNotifyEvent;
    FPopupOnPopup: TNotifyEvent;
    FActiveRow: longint;
    //OldDragOver: TDragOverEvent;
    //OldDragDrop: TDragDropEvent;
    //OldEndDrag: TEndDragEvent;
    SavedColumns: TValueList;
    TmpBookMark: TBookMark;
    InDefineColumns: boolean;
    //InBCMarkRows: boolean;
    InResize: boolean;                   {Flag für Resize}
    TextWidth_Of_0: integer;
    ColorInactive: TColor;
    OldDataSource: TDataSource;
    //weg 28.10.08 P: array [0..4096] of char;    {array size is number of characters needed}
    NextOptions: TDBGridOptions;
    FDrag0Value: string;           {Drag: Wert für Austauschwert. Darf in Daten nicht vorkommen}
    FDragFieldName: string;        {letztes Keysegment. Muß in Sortierfolge sein}
    KeyPressKey: char;
    ReloadDiff: integer;
    DataChangedCount: integer;
    OptiWidthHandled: boolean;
    GlobalCount: integer;  //SelectedRowsChanged: damit andere DMess nicht unnötigerweise gelöscht wird
    DragOverOldRow: longint;


    InWmSize: boolean;                                   {Slidebar}
    DataChangedFlag: boolean;                            {Slidebar}
    FPosition: LongInt;                                  {Slidebar}
    FRecCount: LongInt;                                  {Slidebar}
    FSelRow: Integer;                                    {Slidebar}
    FTitleOffset, FIndicatorOffset: Byte;                {Slidebar}
    ThumbtrackFlag: boolean;
    fTempLayout: boolean;                             {Slidebar}

    LoopTitle: string;
    LoopOptions: TMuLoopOptions;
    LoopDoItEvent: TNotifyEvent;

    function AcquireFocus: Boolean;                      {Slidebar}
    procedure SetRecCount(Value: LongInt);               {Slidebar}
    procedure UpdateActive;                              {Slidebar}
    //25.04.13 s.u. procedure UpdateScrollBar; reintroduce;              {Slidebar}
    //25.04.13 procedure UpdateScrollBar; override;              {Slidebar}
    //procedure UpdateScrollBarX;           //deaktiviert
    procedure SlideBarScroll(Distance: Integer);         {Slidebar}

    procedure SetIniSection(Value: string);
    function GetIniSection: string;
    function GetSortSection: string;
    function GetForm: TForm;
    function GetqForm: TForm;                            //muss noch ge-cast-ed werden
    procedure SetColumnList(Value: TValueList);
    procedure SetActiveRow(Value: longint);
    procedure ColumnListChange(Sender: TObject);
    procedure TempColumnListChange(Sender: TObject);
    procedure SaveColumns;
    procedure ReadColumns;
    procedure PopupClick(Sender: TObject);
    procedure WMPaint(var Message: TWMPaint); message wm_Paint;
    function GetIniFormName: string;
    procedure AL(S: string; L1, L2: TStrings);
    function GetDBEdit(AFieldname: string): TDBEdit;
    procedure SelectedRowsChanged;
    procedure SetMuOptions(const Value: TMuOptions);
    function GetVisibleColumnList: TValueList;
    procedure WriteIniSlideBar(SlideBar: boolean);
    function GetToggleEditor: boolean;
    procedure SetToggleEditor(const Value: boolean);
    procedure SetTempLayout(const Value: boolean);
    procedure StripColumnList(SrcList, DstList: TStrings);
    procedure LoopDoIt(Sender: TMultiGrid; Step: TAbortLoopStep;
      var Done: Boolean);
    procedure MuPopup(Sender: TObject);
    procedure CheckMusiButtons;
    procedure DoCellChanged(ClearFlag: boolean);
  protected
    { Protected-Deklarationen }
    LoadedOptions: TDBGridOptions;
    LoadedPopupMenu: TPopupMenu;
    InTempColumnListChange: boolean;
    {procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;}
    procedure Loaded; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure ColEnter; override;
    procedure DefineFieldMap; override;
    procedure KeyPress(var Key: Char); override;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
    procedure DblClick; override;
    procedure Scroll(Distance: Integer); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
      Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
      Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override; {SlideBar}
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); override;
    {procedure DrawColumnCell(const Rect:TRect; DataCol:Integer; Column:TColumn;
              State:TGridDrawState); override;}
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure SetColumnAttributes; override;  //Test Tmb 24.07.06
    procedure BCStateChange(var Message: TWMBroadcast); message BC_STATECHANGE;
    procedure BCCanClose(var Message: TWMBroadcast); message BC_CANCLOSE;
    procedure BCMultiGrid(var Message: TWMBroadcast); message BC_MULTIGRID;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL; {Slidebar}
    procedure WMSize(var Message: TWMSize); message WM_SIZE;          {Slidebar}
    {procedure Scroll(Distance: Integer); override;                    {Slidebar}
    procedure LayoutChanged; override;                                {Slidebar}
    procedure BcExtGridScr(var Msg: TMessage); message BC_EXTGRIDSCR; {Slidebar}
    procedure RowHeightsChanged; override;                            {RowHeight}
    procedure ColWidthsChanged; override;                             {RowHeight}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function  CreateEditor: TInplaceEdit; override;
    procedure DefineColumns;
    procedure LoadKeyList;       {für BCMultiGrid}
    procedure SaveKeyList;       {für BCMultiGrid}
    procedure SaveSelectedField;
    procedure LoadSelectedField;
    function GetNavLink: TNavLink;
    function GetDataSet: TDataSet;
    function GetRealDataSet: TDataSet;
    procedure SetDefaultRowHeight(Value: Integer);
    function GetDefaultRowHeight: Integer;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure Resize; override;
  public
    { Public-Deklarationen }
    LoadedColumnList: TValueList;
    TempColumnList: TValueList;  //für temporäre Änderungen an ColumnList
    DisplayList: TValueList;
    OptiWidthList: TStringList;
    ColumnsDefined: boolean;
    ColumnsRead: boolean;
    SelectedRow: longint;
    RowOffset: longint;
    DragOverRow: longint;
    DragRow: longint;
    Closed: boolean;                     {für DragDrop}
    RowSelect: boolean;
    SelectedFieldName: string;
    SpalteFehlt: boolean;                {false=Warnung daß Spalte fehlt}
    ColorDetail: TColor;
    IsActiveRow: boolean;                {true=aktuelle Zeile wird gezeichnet. für Draw-Ereignis}
    DragPosVon, DragPos0: integer; {Anker: welcher Pos-Wert wird gezogen. 0-Value}
    DragScroll: integer;           {für Poll: Richtung des Scrollings}
    TM: TTextMetric;               {für Umrechnung Colwidth <-> Displaywidth}
    LastColResize: boolean;        {manuelle Steuerung für letzte Spalte der Größe anpassen}
    OptiWidthFlag: boolean;        //Flag:Optimale Breite über alle Spalten
    CRChar: string;                //Ersatz für Anzeige CRLF
    MouseDownX, MouseDownY: integer;  {Sortieren bei Doubleclick}
    MouseDownShift: TShiftState;
    DropTablename: string;            {Differierender Tablename für DragDrop ->OnDragDrop}
    DropNoRefresh: boolean;           { }
    DrawMultiLine: boolean;         //true=mehrzeilig ausgeben, d.h. height>normal
    ClpHtml, ClpRtf, ClpTxt, ClpCsv: TStringList;  //Ergebnisse von CopyToHtml
    InAbortLoop: boolean;   //kann vom Form abgefragt werden
    MinRowHeight: integer;  //06.06.11
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EditLayout;
    procedure SaveLayout;
    procedure WriteColumns;                {230699 private}
    procedure ReadIniSection(AList: TStrings);
    procedure WriteIniSection(AList: TStrings; DoStore: boolean = true);
    procedure RefreshColumns;
    function CheckFocus: boolean;
    procedure SetOptions(NewOptions: TDBGridOptions);
    procedure AddKeyList;
    procedure AddSortList;
    procedure AddPopup;
    procedure Loop(Title: string; Options: TMuLoopOptions; DoIt: TNotifyEvent);
    procedure AbortLoop(Event: TAbortLoopEvent);
    function FindMenuItem(aCaption: string): TMenuItem;
    {}
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    procedure MuDragPoll;                                     //auch für Aufruf in Drag-Ereignissen
    procedure MuEndDrag(Target: TObject; X, Y: Integer);
    procedure MuBeginDrag(X, Y: Integer; var Allow: Boolean);
    procedure MuDragOver(Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure MuDragDrop(Source: TObject; X, Y: Integer);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function CellCoord(ACol, ARow: Longint): TRect;

    procedure UpdateField;
    function DBRowFromXY(X, Y: integer): longint;
    function RowFromXY(X, Y: integer): longint;
    procedure CopyToHtml; {Copy to Clipboard Html Format}
    procedure SortColumn(Key: string);
    procedure AfterReload;
    procedure BeforeReload;

    property NavLink: TNavLink read GetNavLink;
    property DataSet: TDataSet read GetDataSet;
    property RealDataSet: TDataSet read GetRealDataSet;
    property IniSection: string read GetIniSection write SetIniSection;
    property SortSection: string read GetSortSection;
    property Form: TForm read GetForm;
    property ActiveRow: longint read FActiveRow write SetActiveRow;
    property ColWidths;             //sichtbar machen
    property ColCount;
    property FixedCols;
    property FixedRows;
    property LeftCol;
    property DataLink;
    property InplaceEditor;                            {130400 ISA.POSI}
    property GridLineWidth;
    property ScrollBars;
    property Row;
    property VisibleRowCount;

    property Canvas;                                                  {Slidebar}
    property Position: LongInt read FPosition write FPosition;        {Slidebar}
{$ifndef windows}
    property SelectedRows;                                            {Slidebar}
{$endif}
    property RecCount: LongInt read FRecCount write SetRecCount;      {Slidebar}
    property VisibleColumnList: TValueList read GetVisibleColumnList; {nur sichtbare Spalten (width>0)}
    property ToggleEditor: boolean read GetToggleEditor write SetToggleEditor;  {Imex: Editor ein/aus}
    property TempLayout: boolean read fTempLayout write SetTempLayout;  {FltrFrm mit Columnlist}

  published
    { Published-Deklarationen }
    property ColumnList: TValueList read FColumnList write SetColumnList;
    property ReturnSingle: boolean read FReturnSingle write FReturnSingle;
    property NoColumnSave: boolean read FNoColumnSave write FNoColumnSave;
    property MuOptions: TMuOptions read FMuOptions write SetMuOptions;
    property DefaultRowHeight:Integer read GetDefaultRowHeight write SetDefaultRowHeight; {überschreibt original}
    property Drag0Value: string read FDrag0Value write FDrag0Value;
    property DragFieldName: string read FDragFieldName write FDragFieldName;
    property OnBeginDrag: TBeginDragEvent read FOnBeginDrag write FOnBeginDrag;
    property OnAbortLoop: TAbortLoopEvent read FOnAbortLoop write FOnAbortLoop;
    property OnLayoutChanged: TNotifyEvent read FOnLayoutChanged write FOnLayoutChanged;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
    property OnMouseDown;
    property OnMouseMove;
  end;

const
  fColOffs: integer = 0;              {0 = Dflt. Manchmal=1, Layouteditor}

const
  SSpalten = 'Spalten';
  SSortierung = 'Sortierung';
  SRowHeight = ':DefaultRowHeight';
  SStoredVersion = ':Version';
  sNoSlideBar = 'NoSlideBar';
  sSlideBar = 'SlideBar';

  function ColOffs: integer;
  procedure SetColOffs(Value: integer);
  procedure MarkAll(ADBGrid: TDBGrid);

implementation

uses
   Clipbrd,
   Uni, DBAccess, MemDS, StdCtrls, DbiProcs, DbiTypes, DbiErrs,
  {TypInfo, }
  Qwf_Form, LNav_Kmp, LuDefKmp, GNav_Kmp, Err__Kmp, Ini__kmp, RechtKmp, AbortDlg,
  PropsDlg, Sql__Dlg, Sort_Dlg, FldDsKmp, HtmlClp, MuGriDlg, KmpResString, MuSiFr,
  XmlExpDlg, UQue_Kmp;

type
  TCustomGridHack = class(TCustomGrid)
  public
    property Options;
  end;

var
  NameCounter: integer;

(*** global ******************************************************************)

function ColOffs: integer;
begin
  result := IniKmp.ReadInteger(SSortierung, 'ColOffs', 0);
end;

procedure SetColOffs(Value: integer);
begin
  IniKmp.WriteInteger(SSortierung, 'ColOffs', Value);
end;


(*** TMultiGrid ***************************************************************)

(*** Properties ***************************************************************)

function TMultiGrid.GetDataSet: TDataSet;
begin
  if DataSource = nil then
    result := nil else
    result := DataSource.DataSet;
end;

function TMultiGrid.GetRealDataSet: TDataSet;
// wirkliches Dataset. Bei Query ist das versteckt. Für SaveColumns o.ä.
begin
  Result := nil;
  if Navlink <> nil then
  begin
    if Navlink.nlState = nlQuery then
      Result := Navlink.SaveDataSet else
      Result := Navlink.DataSet;
  end;
end;

function TMultiGrid.GetNavLink: TNavLink;
begin
  if DataSource = nil then
    result := nil else
  if DataSource is TLookUpDef then
    result := (DataSource as TLookUpDef).NavLink else
  if FormGetLNav(Form) <> nil then
    result := FormGetLNav(Form).NavLink else
    result := nil;
end;

function TMultiGrid.RowFromXY(X, Y: integer): longint;
begin
  result := MouseCoord(X, Y).Y - 1;
end;

function TMultiGrid.DBRowFromXY(X, Y: integer): longint;
begin
  result := RowFromXY(X, Y) + RowOffset;
end;

function TMultiGrid.GetIniFormName: string;
begin
  if Owner is TFrame then
    result := Owner.Owner.ClassName + '.' + Owner.Name else
    result := Owner.ClassName;
end;

procedure TMultiGrid.SetIniSection(Value: string);
var
  S: string;
  DoIt: boolean;
begin
  if [csDesigning, csLoading] * ComponentState <> [] then
  begin
    FIniSection := Value;
  end else
  begin             {Änderung zur Laufzeit}
    S := Value;
    if S = '' then
    begin
      S := Format('%s.%s.%s', [SSpalten, GetIniFormName, Name]);
    end else
    if Pos('.', S) = 0 then
    begin
      S := Format('%s.%s.%s', [SSpalten, GetIniFormName, S]);
    end else
    if CompareText(SSpalten, copy(S, 1, length(SSpalten))) <> 0 then
    begin
      S := Format('%s.%s', [SSpalten, S]);
    end;
    DoIt := CompareText(FIniSection, S) <> 0;
    FIniSection := S;
    if DoIt then
    begin
      ColumnsDefined := false;
      //DefineColumns;  (muss nicht mehr sein)
    end;
  end;
end;

function TMultiGrid.GetIniSection: string;
var
  P: integer;
begin
  if FIniSection = '' then
    FIniSection := Format('%s.%s.%s', [SSpalten, GetIniFormName, Name]) else
  if CompareText(SSpalten, copy(FIniSection, 1, length(SSpalten))) <> 0 then
    FIniSection := Format('%s.%s', [SSpalten, FIniSection]);

  //Wir unterstützen max. 3stellige Sprachbezeichner
  P := PosR('_', FIniSection);
  if P >= length(FIniSection) - 3 then                     //12345_789
    System.Delete(FIniSection, P, 100);                    //12345
  if (SysParam.Sprache <> '') and
     not EndsWith(FIniSection, SysParam.Sprache) then
    FIniSection := FIniSection + '_' + SysParam.Sprache;   //12345_E

  result := FIniSection;
end;

function TMultiGrid.GetSortSection: string;
var
  Spr: string;
begin
  Spr := SysParam.Sprache;
  try
    SysParam.Sprache := '';
    result := Format('%s%s', [SSortierung, copy(IniSection, length(SSpalten) + 1, 200)]);
  finally
    SysParam.Sprache := Spr;
  end;
end;

function TMultiGrid.GetForm: TForm;
begin
  result := nil;
  try
    if Owner <> nil then
      if Owner is TFrame then
      result := Owner.Owner as TForm else
      result := Owner as TForm;
  except
    result := nil;
  end;
end;

function TMultiGrid.GetqForm: TForm;
begin
  result := GetForm;
  if (result <> nil) and not (result is TqForm) then
    result := nil;
end;

procedure TMultiGrid.SetColumnList(Value: TValueList);
begin
  if FColumnList <> Value then                   {This conditional is optional.}
    FColumnList.Assign(Value);
end;

procedure TMultiGrid.SetActiveRow(Value: longint);
(* für Property setzen: Markiert später wenn Shiftstatus gesetzt *)
begin
  FActiveRow := Value;
end;

procedure TMultiGrid.ColumnListChange(Sender: TObject);
begin
  if not InTempColumnListChange then
    TempColumnList.Assign(FColumnList);
  if not InDefineColumns then              {wg. Read Columns}
  begin
    ColumnsDefined := false;
    {ColWidthsChanged;}
    {DefineFieldMap;}
    DefineColumns;
  end;
end;

procedure TMultiGrid.TempColumnListChange(Sender: TObject);
var
  B1: boolean;
begin
  InTempColumnListChange := true;
  B1 := MuNoSaveLayout in MuOptions;
  try
    if not B1 then
      MuOptions := MuOptions + [MuNoSaveLayout];  //ReadColumns liest nicht von INI
    ColumnList.Assign(TempColumnList);
  finally
    if not B1 then
      MuOptions := MuOptions - [MuNoSaveLayout];
    ColumnsDefined := true;
    InTempColumnListChange := false;
  end;
end;

procedure TMultiGrid.RefreshColumns;
begin
  if not InDefineColumns then              {wg. Read Columns}
  begin
    ColumnsDefined := false;
    {ColWidthsChanged;}
    {DefineFieldMap;}
    DefineColumns;
  end;
end;

procedure TMultiGrid.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

(*** RowHeight: ***************************************************************)

procedure TMultiGrid.CMFontChanged(var Message: TMessage);
var
  h: integer;
begin
  inherited;
  if (csDesigning in ComponentState) then     //16.10.03
  begin
    Canvas.Font.Assign(Font);
    h := Canvas.TextHeight('Wg');
    if DefaultRowHeight <> h then
      SetDefaultRowHeight(h);
  end;
  if (csDesigning in ComponentState) then
    Invalidate;
end;

procedure TMultiGrid.ColWidthsChanged;  {override;}
var
  RowHeight: integer;
begin          {rowheight retten 080800}
  RowHeight := DefaultRowHeight;
  if not InResize then            //ansonsten würden alle Lookups refreshen
    inherited ColWidthsChanged;
  if DefaultRowHeight <> RowHeight then
    DefaultRowHeight := RowHeight;
end;

function TMultiGrid.GetDefaultRowHeight: Integer;
begin
  Result := inherited DefaultRowHeight;
end;


procedure TMultiGrid.SetDefaultRowHeight(Value: Integer);
var
  AWmSize: TWMSize;
begin
  if csDesigning in ComponentState then
  begin
    inherited DefaultRowHeight := Value;
    Exit;
  end;
  {if (ComponentState = []) and (DefaultRowHeight <> Value) then}
  try
    inherited DefaultRowHeight := Value;
    if dgTitles in Options then
    begin
      Canvas.Font := TitleFont;
      RowHeights[0] := Canvas.TextHeight('Wg') + 4;
    end;

       //if R.Bottom - R.Top > (TextHeight('Wg') * 3) div 2 then   {Multiline }
    //DrawMultiLine := Value > (Canvas.TextHeight('Wg') * 3) div 2;  - orig. >1.5
    DrawMultiLine := Value >= (Canvas.TextHeight('Wg') * 9) div 5;  //>=1.8

    if (ComponentState * [csDesigning,csLoading,csDestroying] = []) and (Value > 0) then
    begin                                    {-> damit Aufruf UpdateRowCount}
      AWMSize.Msg := WM_SIZE;
      AWMSize.SizeType := SIZE_RESTORED;
      AWMSize.Width := Width;
      AWMSize.Height := Height;
      Dispatch(AWMSize);
      {PostMessage(Handle, WM_SIZE, WPARAM(SIZE_RESTORED),
        LPARAM(MAKELONG(Width, Height)));}
    end;
  except on E:Exception do
    EProt(self, E, 'SetDefaultRowHeight(%d):%d', [Value, 0]);
  end;
end;

procedure TMultiGrid.RowHeightsChanged;
var
  I, h: Integer;
begin
  if csDesigning in ComponentState then
  begin
    inherited;
    Exit;
  end;
  if csDestroying in ComponentState then
    Exit;
  h := DefaultRowHeight;
  for I := Ord(dgTitles in Options) to pred(RowCount) do
    if RowHeights[I] <> h then             {vom Bediener gezogen:}
    begin
      FRowHeight := h;
      SetDefaultRowHeight(RowHeights[I]);
      RecreateWnd;
      break;
    end;
  inherited;
end;

function TMultiGrid.GetVisibleColumnList: TValueList;
//ergibt Auszug von Columnlist nur mit sichtbaren Feldspalten. Für Doppelklick/Sort.
//14.07.10 Umstellung auf Field.Visible da Columnlist auch ungültige Spalten enthalten kann.
var
  S1: string;
  I: integer;
  AField: TField;
begin
  FVisibleColumnList.Clear;
  for I := 0 to ColumnList.Count - 1 do
  begin              //Bsp: Menge:7,M,S=MY_MENGE oder Menge=MYMENGE
    (* 14.07.10 ersetzt
    S1 := PStrTok(ColumnList.Param(I), ':;,', NextS);  //Caption
    S1 := PStrTok('', ':;,', NextS);  //Länge ohne Summen etc.
    if (S1 = '') or (StrToIntTol(S1) > 0) then
      FVisibleColumnList.Add(ColumnList[I]);
    *)
    S1 := ColumnList.Value(I);
    AField := Dataset.FindField(S1);
    if (AField <> nil) and AField.Visible then
      FVisibleColumnList.Add(ColumnList[I]);
  end;
  result := FVisibleColumnList;
end;

procedure TMultiGrid.Resize; //override;
var
  I, WidthOfCols, DiffWidth: integer;
  MaxCol: integer;
  AField: TField;
begin
  inherited Resize;
  try
    InResize := true;
    WidthOfCols := 0;

    (* nein Imex/LovDlg 07.07.04
    if ClientWidth > 20 then
    begin
      for I := 0 to ColCount - 1 do
      begin
        if ColWidths[I] > ClientWidth then
          ColWidths[I] := ClientWidth;
      end;
    end;*)

    if not (csDesigning in ComponentState) and
       {not InResize and}
       (SysParam.MuResize or LastColResize) and             //nicht bei Imex!
       (DataSet <> nil) and (DataSet.Active) then
    begin
      MaxCol := ColCount - 1;
      for I := 0 to DisplayList.Count - 1 do
        if Pos('X', DisplayList.Value(I)) > 0 then
        begin
          AField := DataSet.FindField(DisplayList.Param(I));
          if AField <> nil then
            MaxCol := AField.Index + 1 else
            Debug0;
        end;

      if (MaxCol >= 0) and (MaxCol < ColCount) and (ColCount > 1) then  //>2 07.07.04
         //CanFocus then  //MD 01.11.03
      begin
        for I := 0 to ColCount - 1 do
        begin
          Inc(WidthOfCols, ColWidths[I]);
        end;
        Inc( WidthOfCols, ColCount + 1);
        DiffWidth := ClientWidth - NonClientMetrics.iScrollWidth - WidthOfCols;
        if DiffWidth > 0 then                       {letzte Spalte vergrößern}
        begin
          ColWidths[MaxCol] := ColWidths[MaxCol] + DiffWidth;
        end else
        begin           {DiffWidth <= 0}
          if ColWidths[MaxCol] + DiffWidth > 20 then
            ColWidths[MaxCol] := ColWidths[MaxCol] + DiffWidth;
        end;
      end else
        debug0;
    end;
  finally
    InResize := false;
  end;
  MuOptions := MuOptions + [muNoAskLayout];  //muNoAskLayout am 02.05.02 beerdigt
end;

(*** Methoden *****************************************************************)

constructor TMultiGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  (*if not (csDesigning in ComponentState) then        in BC..
  begin
    TCustomGridHack(self).Options := TCustomGridHack(Self).Options + [goRowSizing];
  end;*)
  FColumnList:= TValueList.Create;
  FVisibleColumnList:= TValueList.Create;
  FColumnList.OnChange := ColumnListChange;
  DragOverRow := -1;
  SavedColumns := TValueList.Create;
  DisplayList := TValueList.Create;
  OptiWidthList := TStringList.Create;
  LoadedColumnList:= TValueList.Create;
  TempColumnList:= TValueList.Create;
  TempColumnList.OnChange := TempColumnListChange;
  ClpHtml := TStringList.Create;
  ClpRtf := TStringList.Create;
  ClpTxt := TStringList.Create;
  ClpCsv := TStringList.Create;
  RecCount := 0;         {SlideBar}
  FPosition := 0;        {SlideBar}
  MinRowHeight := 17;    //06.06.11
  FDrag0Value := '0';
  // ColOffs := 0;
  Options := Options + [dgMultiSelect];
  MuOptions := [muPostOnExit, muNoAskLayout];  //muNoAskLayout am 02.05.02 beerdigt
  CRChar := Sysparam.CRChar;
  if not (csDesigning in ComponentState) then
    DrawingStyle := Sysparam.MuDrawingStyle;
end;

destructor TMultiGrid.Destroy;
begin
  {if not Application.Terminated then
    WriteColumns;  in BC_CanClose}
  FreeAndNil(FColumnList);
  FreeAndNil(FVisibleColumnList);
  FreeAndNil(SavedColumns);
  if DataSet <> nil then
    if TmpBookmark <> nil then
      DataSet.FreeBookMark(TmpBookMark);
  FreeAndNil(DisplayList);
  FreeAndNil(OptiWidthList);
  FreeAndNil(LoadedColumnList);
  FreeAndNil(TempColumnList);
  FreeAndNil(ClpHtml);
  FreeAndNil(ClpRtf);
  FreeAndNil(ClpTxt);
  FreeAndNil(ClpCsv);
  inherited Destroy;
end;

procedure TMultiGrid.BCCanClose(var Message: TWMBroadcast);
begin
  if (NavLink <> nil) and (DataSource is TLookUpDef) then
    NavLink.DoCancel;                     {130400}
  WriteColumns;
end;

procedure TMultiGrid.BCMultiGrid(var Message: TWMBroadcast);  // message BC_MULTIGRID
var
  I, W, OldHeight: integer;
  AFieldName: string;
  AField: TField;
begin
  case Byte(Message.Data) of
    mgForceScrollBar:
      //Delphi-Bug - untergeordnete oder Haupt- Grid: Anzeige Scrollbar erzwingen
      if (Dataset <> nil) and Dataset.Active and (Dataset is TuQuery) and
         ((TDataSource(Message.Sender) = TuQuery(Dataset).MasterSource) or  //LuDef
          (TDataSource(Message.Sender) = DataSource)) then     //Nav, von QNav
      begin  //25.04.13 - http://qc.embarcadero.com/wc/qcmain.aspx?d=7527
        OldHeight := Height;
        Height := Height + 1;
        Height := OldHeight;
        CheckMusiButtons;  //10.06.13
      end;
    mgAddSortList:
      if TDataSource(Message.Sender) = DataSource then
        AddSortList;
    mgLoadKeyList:
      if TDataSource(Message.Sender) = DataSource then
        LoadKeyList;
    mgSaveKeyList:
      if TDataSource(Message.Sender) = DataSource then
        SaveKeyList;
    mgLoadSelectedField:
      if TDataSource(Message.Sender) = DataSource then
        LoadSelectedField;
    mgSaveSelectedField:
      if TDataSource(Message.Sender) = DataSource then
        SaveSelectedField;
    mgColDefChanged:                           {010401}
      ColumnsDefined := false;
    mgColorChanged:
      if Color <> ColorDetail then
        ColorInactive := Color;
    mgCheckColor:
      if (DataSource is TLookUpDef) and
         (TDataSource(Message.Sender) = DataSource) then
      begin
        if not (muCustColor in MuOptions) and not ReadOnly then
          if Color <> ColorDetail then
            Color := ColorDetail;           {Fokussiert: Grün färben}
      end else
      begin
        if not (muCustColor in MuOptions) and not ReadOnly then
          if Color <> ColorInactive then
            Color := ColorInactive;         {Weiß oder Gelb}
      end;
    mgDisable: begin
      OldDataSource := DataSource;
      DataSource := nil;
      end;
    mgEnable:
      DataSource := OldDataSource;
    mgSetRecCount:
      if TDataSource(Message.Sender) = DataSource then
        PostMessage(Handle, BC_EXTGRIDSCR, egSetRecCount, 0);        {RecCount := NavLink.RecordCount;}
    mgDataChanged:
      if TDataSource(Message.Sender) = DataSource then
      begin
        DoCellChanged(true);
        if DataChangedCount = 0 then
        begin
          Inc(DataChangedCount);
          PostMessage(Handle, BC_EXTGRIDSCR, egDataChanged, 0);
        end;
      end;
    mgDragPoll:
      if muDrag in MuOptions then
        MuDragPoll;
    mgSaveLayout:
      SaveLayout;
    mgSelectedRowsChanged:
    begin
      SelectedRowsChanged;
      try                                              //QuPP#LPLAFrm - 19.01.05
        SendMessage(Form.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count Bug
      except on E:Exception do
        EProt(self, E, 'mgSelectedRowsChanged(%s)', [OwnerDotName(self)]);
      end;
    end;
    mgPopupClick:
    begin
      PopupClick(TMenuItem(Message.Sender));
    end;
    mgOptiWidth:
    begin
      OptiWidthHandled := true;  //Flag dass verarbeitet für DrawDataCell
      if OptiWidthFlag and (DisplayList.Count = 0) then
      begin  //für sql_dlg 30.05.14
        for I := 0 to OptiWidthList.Count - 1 do
        begin
          AFieldName := StrParam(OptiWidthList[I]);
          AField := DataSet.FindField(AFieldName);
          if (AField <> nil) and (OptiWidthList.Values[AFieldName] <> '') then
          begin
            W := 6 + StrToIntDef(OptiWidthList.Values[AFieldName], 30);
            if ColWidths[AField.Index + 1] <> W then
              ColWidths[AField.Index + 1] := W;
          end;
        end;
      end;
      for I := 0 to DisplayList.Count - 1 do
      begin
        if (DataSet <> nil) and (OptiWidthFlag or               {Optimize Width}
            (PosI('O', DisplayList.Value(I)) > 0)) then
        begin
          AFieldName := DisplayList.Param(I);
          AField := DataSet.FindField(AFieldName);
          if (AField <> nil) and (OptiWidthList.Values[AFieldName] <> '') then
          begin
            W := 6 + StrToIntDef(OptiWidthList.Values[AFieldName], 30);
            if ColWidths[AField.Index + 1] <> W then
              ColWidths[AField.Index + 1] := W;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMultiGrid.SelectedRowsChanged;
var
  N: integer;
begin
  N := SelectedRows.Count;
  if GlobalCount <> N then
  begin
    GlobalCount := N;
    if N > 0 then
    begin
      if muSlideBar in MuOptions then
      begin
        DMess(SMugriKmp_012, [N, FRecCount]); //'%d von %d Datensätzen markiert'
      end else
      begin
        if N = 1 then
          DMess(SMugriKmp_013, [N]) else      //'%d Datensatz markiert'
          DMess(SMugriKmp_014, [N]);          //'%d Datensätze markiert'
      end;
    end else
      DMess0;
  end;
end;

procedure TMultiGrid.LoadKeyList;
(* User-Sortierung laden. Sektion = [Sortierung.<SpaltenSektionsTeil>] *)
begin
  if NavLink <> nil then
  begin
    NavLink.KeyFields :=
      IniKmp.ReadString(SortSection, 'KeyFields', NavLink.KeyFields);
    if NavLink.LoadedKeyFields = '' then
      NavLink.LoadedKeyFields := NavLink.KeyFields;
  end;
end;

procedure TMultiGrid.SaveKeyList;
(* User-Sortierung Speichern. Sektion siehe loadkeylist *)
begin
  if NavLink <> nil then
  begin
    if NavLink.KeyList.Values[SStandardKey] = NavLink.KeyFields then
    begin
      IniKmp.DeleteKey(SortSection, 'KeyFields');
    end else
      IniKmp.WriteString(SortSection, 'KeyFields', NavLink.KeyFields);
  end;
end;

procedure TMultiGrid.SaveSelectedField;
begin
  if SelectedField <> nil then
    SelectedFieldName := SelectedField.FieldName else
    SelectedFieldName := '';
end;

procedure TMultiGrid.LoadSelectedField;
begin
  if (SelectedFieldName <> '') and (SelectedField <> nil) then
    SelectedField := DataSet.FindField(SelectedFieldName);
end;

procedure TMultiGrid.AddKeyList;            {extrahiert wg. LuGrid}
(* KeyList anhand Spalten ergänzen. Dataset ist hier noch nicht init:
   nicht sortierbare Spalten anhand CalcFields und SqlFieldList *)
var
  I, J, L, P: integer;
  ATitle, AFieldName, ATblName, NextS: string;
  DoAdd: boolean;
  AFieldDefs: TFieldDefs;
begin
  if (NavLink <> nil) and false and {SortList: hier keine Aktion mehr}
     not (csDesigning in ComponentState) and (DataSource <> nil) then
  try
    for I := 0 to ColumnList.Count - 1 do
    begin
      ATitle := ColumnList.Param(I);
      AFieldName := ColumnList.Value(I);
      P := Pos(':', ATitle);
      if P > 0 then
        System.Delete(ATitle, P, 250);
      DoAdd := true;
      for J := 0 to NavLink.KeyList.Count - 1 do
      begin
        L := IMax(length(PStrTok(ColumnList.Value(I), ';', NextS)),
                  length(PStrTok(NavLink.KeyList.Value(J), ';', NextS)));
        if (CompareText(ATitle, NavLink.KeyList.Param(J)) = 0) or
           (CompareTextLen(ColumnList.Value(I), NavLink.KeyList.Value(J), L) = 0) then
          DoAdd := false;              {gleiche Felder auf der rechten seite}
      end;
      if NavLink.CalcList.Values[AFieldName] <> '' then
        DoAdd := false;                                {CalcField}
      if NavLink.SqlFieldList.Values[AFieldName] <> '' then
        DoAdd := false;                  {I.d.F. M=max(X) -> select max(x) as M}
      if DoAdd then
      begin
        NavLink.KeyList.AddFmt('%s=%s', [ATitle, AFieldName]);
      end;
    end;
    (* alle restl. Felder: *)
    if (NavLink.Query <> nil) and (NavLink.TableName <> '') then
    begin
      ATblName := PStrTok(NavLink.TableName, '; ', NextS);
      AFieldDefs := FldDsc.CreateFieldDefs(QueryDatabase(NavLink.Query), ATblName);
      for I := 0 to AFieldDefs.Count - 1 do
      begin
        AFieldName := AFieldDefs[I].Name;
        if NavLink.KeyList.Params[AFieldName] = '' then
          NavLink.KeyList.AddFmt('%s=%s', [AFieldName, AFieldName]);
      end;
    end;
  except on E:Exception do
    ErrWarn('TMultiGrid.AddKeyList(%s):%s', [GetName(self), E.Message]);
  end;
end;

procedure TMultiGrid.AddSortList;            {extrahiert wg. LuGrid}
(* SortList anhand Spalten ergänzen.
   nicht sortierbare Spalten anhand CalcFields und SqlFieldList *)
var
  I, J, L, P: integer;
  ATitle, AFieldName, ATblName, NextS: string;
  DoAdd: boolean;
  AFieldDefs: TFieldDefs;
begin
  if (NavLink <> nil) and
     not (csDesigning in ComponentState) and (DataSource <> nil) then
  try
    NavLink.SortList.Assign(NavLink.KeyList);
    for I := 0 to ColumnList.Count - 1 do
    begin
      ATitle := ColumnList.Param(I);
      AFieldName := ColumnList.Value(I);
      P := Pos(':', ATitle);
      if P > 0 then
        System.Delete(ATitle, P, 250);
      DoAdd := true;
      for J := 0 to NavLink.SortList.Count - 1 do
      begin
        L := IMax(length(PStrTok(ColumnList.Value(I), ';', NextS)),
                  length(PStrTok(NavLink.SortList.Value(J), ';', NextS)));
        if (CompareText(ATitle, NavLink.SortList.Param(J)) = 0) or
           (CompareTextLen(ColumnList.Value(I), NavLink.SortList.Value(J), L) = 0) then
          DoAdd := false;              {gleiche Felder auf der rechten seite}
      end;
      if NavLink.CalcList.Values[AFieldName] <> '' then
        DoAdd := false;                                {CalcField}
      if NavLink.SqlFieldList.Values[AFieldName] <> '' then
        DoAdd := false;                  {I.d.F. M=max(X) -> select max(x) as M}
      if DoAdd then
      begin
        NavLink.SortList.AddFmt('%s=%s', [ATitle, AFieldName]);
      end;
    end;
    (* alle restl. Felder: *)
    if (NavLink.Query <> nil) and (NavLink.TableName <> '') then
    begin
      ATblName := PStrTok(NavLink.TableName, '; ', NextS);
      AFieldDefs := FldDsc.CreateFieldDefs(QueryDatabase(NavLink.Query), ATblName);
      for I := 0 to AFieldDefs.Count - 1 do
      begin
        AFieldName := AFieldDefs[I].Name;
        if NavLink.SortList.Params[AFieldName] = '' then
          NavLink.SortList.AddFmt('%s=%s', [AFieldName, AFieldName]);
      end;
    end;
  except on E:Exception do
    ErrWarn('TMultiGrid.AddSortList(%s):%s', [GetName(self), E.Message]);
  end;
end;

procedure TMultiGrid.MuPopup(Sender: TObject);
begin
  //WMess('%s', [OwnerDotName(Sender)]);
  if not AcquireFocus then Exit;
  if Assigned(FOnPopup) then
    FOnPopup(self);
  if Assigned(FPopupOnPopup) then
    FPopupOnPopup(self);  //Ereignis des Original-Popup mit unserer Grid aufrufen
end;

function TMultiGrid.FindMenuItem(aCaption: string): TMenuItem;
begin
  Result := Prots.FindMenuItem(PopupMenu, aCaption);
end;

procedure TMultiGrid.AddPopup;
(* Fügt Standard Popup-Menü hinzu *)
var
  PopupItem, NewItem: TMenuItem;
  I, N, J: integer;
  S, S1, NextS: string;
  PopupMenu1: TPopupMenu;
  DoIt: boolean;
const
  Captions: array[1..19] of string = (
    'Formular, N',
    'Fremdtabelle, D',
    'Ändern in Tabelle, C',
    '-',
    'Aufsteigend, N',
    'Absteigend, N',
    'Sortieren, N',
    'Suchen, N',
    'Drucken, N',
    '-',
    'Markieren',
    'Ausschneiden',
    'Kopieren',
    'Einfügen',
    '-',
    'Eigenschaften, N',
    'Tabellenlayout, L',
    'Layout speichern, L',        {visible md11.10.08 wg Abfragen; invisible - md21.03.08}
    'XML Export, N'
  );

begin {AddPopup}
  {if (PopupMenu = nil) and not (csDesigning in ComponentState) then  (im Aufruf)}
  begin
    PopupMenu1 := PopupMenu;
    if PopupMenu = nil then
      PopupMenu := TPopupMenu.Create(Form);
    PopupMenu.OnPopup := MuPopup;  //Ereignis
    PopupItem := PopupMenu.Items;    {Erzeugen der Menüeinträge}

    (*PopupMenu1 := PopupMenu;
    PopupMenu := TPopupMenu.Create(Form);
    PopupItem := PopupMenu.Items;    {Erzeugen der Menüeinträge}
    if PopupMenu1 <> nil then
    begin
      for I := 0 to PopupMenu1.Items.Count - 1 do
      begin
        PopupItem.Add(PopupMenu1.Items[I]);          {Fehler:doppelter Menüeintrag}
      end;
    end;*)

    N := 0;
    DoIt := true;
    for I := low(Captions) to high(Captions) do  //Test ob Standardeinträge bereits vorhanden
    begin
      if (Captions[I] = '') or (Char1(Captions[I]) = '-') then
        continue;
      S := PStrTok(Captions[I], ',', NextS);
      for J := 0 to PopUpItem.Count - 1 do
        if PopUpItem[J].Caption = S then
          DoIt := false;
    end;
    if not DoIt then       //alle Standardeinträge bereits vorhanden
      Exit;
    for I := low(Captions) to high(Captions) do
    begin
      if Captions[I] = '' then
        continue;
      NewItem := TMenuItem.Create(PopupMenu);  {Erzeugen des neuen Menüeintrags}
      if PopupMenu1 <> nil then
      begin
        if I = low(Captions) then
          NewItem.Break := mbBarBreak;
      end;
      S := PStrTok(Captions[I], ',', NextS);
      S1 := S;
      NewItem.Caption := GNavigator.TranslateStr(self, S1); {Titelzeile für den neuen Menüeintrag}
      S1 := PStrTok('', ',', NextS);
      if Pos('D', S1) > 0 then                            {D = nur bei mdDetail}
        NewItem.Enabled := (DataSource <> nil) and (DataSource is TLookupDef) and
                           (TLookupDef(DataSource).mdTyp = mdDetail) else
      if Pos('L', S1) > 0 then             {L = Layout nur bei not NoSaveLayout}
        NewItem.Enabled := not (muNoSaveLayout in MuOptions) else
      if Pos('N', S1) > 0 then                      {N = Layout nur bei NavLink}
        NewItem.Enabled := DsGetNavLink(DataSource) <> nil else
        NewItem.Enabled := Pos('I', S1) <= 0;                       {I=Disabled}
      if Pos('V', S1) > 0 then     {V = invisible - md21.03.08 Layout speichern}
        NewItem.Visible := false;
      if Pos('C', S1) > 0 then    {C = Checked=EditSingle für Ändern in Tabelle}
        NewItem.Checked := (NavLink <> nil) and not NavLink.EditSingle;
      NewItem.Tag := I;                                          {Tag für Click}
      if S <> '-' then
        NewItem.OnClick := PopupClick;       {OnClick für den neuen Menüeintrag}
      PopupItem.Add(NewItem);                  {Einfügen des neuen Menüeintrags}
      Inc(N);
    end;
    if N = 0 then
      Debug('N=%d', [N]);
  end;
end;

procedure TMultiGrid.SortColumn(Key: string);
var
  ADataPos: TDataPos;
  S1, nextS: string;
  KeepPosition: boolean;
begin
  if NavLink.KeyFields <> Key then
  begin
    KeepPosition := SysParam.GotoPos or ShiftKeyDown;

    ADataPos := TDataPos.Create;
    try
      if KeepPosition and NavLink.DataSet.Active then
      begin
        ADataPos.AddFieldsValue(NavLink.DataSet, NavLink.PrimaryKeyFields);
      end;
      S1 := PStrTok(Key, ' ', NextS);     {'desc' entfernen für FindField}
      if (NavLink.DataSet.FindField(S1) <> nil) and
         (NavLink.DataSet.FindField(S1).FieldNo >= 0) then
      begin
        if NavLink.KeyFields <> Key then
          NavLink.KeyFields := Key;
        NavLink.DataSet.Open;
        if KeepPosition then
        begin
          {SendMessage(Handle, BC_EXTGRIDSCR, egSetRecCount, 0);        {RecCount := NavLink.RecordCount;}
          ADataPos.GotoPosEx(NavLink.DataSet, [dpoEnableControls]);
        end;
      end else
        //'nach dieser Spalte kann nicht sortiert werden (%s)'
        ErrWarn(SMugriKmp_016, [S1]);
    finally
      ADataPos.Free;
    end;
  end;
end;

procedure TMultiGrid.PopupClick(Sender: TObject);
begin
   {'Formular',            1
    'Fremdtabelle, D',     2
    'Ändern in Tabelle, C',3
    '-',                   4
    'Aufsteigend',         5
    'Absteigend',          6
    'Sortieren ...',       7
    'Suchen',              8
    'Drucken',             9
    '-',                  10
    'Markieren',          11
    'Ausschneiden',       12
    'Kopieren',           13
    'Einfügen',           14
    '-',                  15
    'Eigenschaften',      16
    'Tabellenlayout',     17
    'Layout speichern     18
    'XML Export           19}
  case Byte(TMenuItem(Sender).Tag) of
    1: if DataSource is TLookUpDef then
         TLookUpDef(DataSource).LookUp(lumZeigMsk) else
         GNavigator.BtnSingleClick(self);
       (*begin
         if (dgEditing in Options) then
           SetOptions(NextOptions - [dgEditing]) else
           SetOptions(NextOptions + [dgEditing]);
         TMenuItem(Sender).Checked := dgEditing in Options;
       end;*)

    2: if (DataSource is TLookUpDef) and
          (TLookupDef(DataSource).mdTyp = mdDetail) then
         TLookupDef(DataSource).LookUp(lumMasterTab);

    3: if NavLink <> nil then
       begin
         NavLink.EditSingle := not NavLink.EditSingle;
         TMenuItem(Sender).Checked := not NavLink.EditSingle;
       end;

    5: if (NavLink <> nil) and (SelectedField <> nil) then
         SortColumn(SelectedField.FieldName);
    6: if (NavLink <> nil) and (SelectedField <> nil)  then
         SortColumn(SelectedField.FieldName + ' desc');
    7: GNavigator.BtnSortClick(self);
    8: PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(qnbQuery), 0);
    9: GNavigator.BtnDruckClick(self);
       {for I := 0 to DataSet.FieldCount - 1 do
         ProtA('%d. %s:%d', [I, DataSet.Fields[I].FieldName, DataSet.Fields[I].Index]);}
    11: begin
          SelectedRows.CurrentRowSelected := not SelectedRows.CurrentRowSelected;
          SendMessage(Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
        end;
    12: GNavigator.CutItem(self);
    13: GNavigator.CopyItem(self);
    14: GNavigator.PasteItem(self);
    16: TDlgProps.Execute(NavLink);
    17: if not (muNoSaveLayout in MuOptions) then
          EditLayout;
    18: begin
          SavedColumns.Clear;  //Schreiben erzwingen
          TempLayout := false; //Schreiben erzwingen
          SaveLayout;
        end;
    19: TDlgXMLEXP.Execute(NavLink);
  end;
end;

procedure TMultiGrid.EditLayout;
var
  SlideBar, SlideBarNew, Standard: boolean;
begin
  SaveLayout;
  SlideBar := (Sysparam.SlideBar or (muSlideBar in MuOptions)) and
              not (muNoSlideBar in MuOptions);
  SlideBarNew := SlideBar;
  if TDlgMuGri.Execute(SavedColumns, IniSection, SlideBarNew, Standard) then
  begin
    if TempLayout then
    begin
      if Standard then
        ColumnList.Assign(LoadedColumnList) else
        StripColumnList(SavedColumns, ColumnList);  //ohne Umweg über INI
    end else
      WriteIniSection(SavedColumns); {Count=0 wenn Standard. Als Replace}
    // if SlideBarNew <> SlideBar then  entfernt 30.10.08
      WriteIniSlidebar(SlideBarNew);
    RefreshColumns; {liest von INI}
  end;
end;

procedure TMultiGrid.Loaded;
var
  I1, P: integer;
  S, S1: string;
  NewItem: TMenuItem;
begin
  inherited Loaded;
  {Options := Options + [dgMultiSelect];     weg QDispo.StMe 050501}
  Options := Options - [dgCancelOnExit];           {080500 DPE.EPos}
  NextOptions := Options;
  LoadedOptions := Options;
  LoadedRowHeight := DefaultRowHeight;
  ColorInactive := Color;
  if csDesigning in ComponentState then
    Exit;
  try
    ColorDetail := GNavigator.ColorDetail;
  except on E:Exception do   {kein GNav}
    begin
      ColorDetail := Color;
      EProt(self, E, '%s:GNavigator.ColorDetail', [Name]);
    end;
  end;
  RowSelect := dgRowSelect in Options;
  if SysParam.SlideBar and not (muNoSlideBar in MuOptions) then
    MuOptions := MuOptions + [muSlideBar];
  if muNoSlideBar in MuOptions then
    MuOptions := MuOptions - [muSlideBar];
  // virtual statt events
  if NavLink <> nil then
    NavLink.DBGrid := self;
  //not (csDesigning in ComponentState)  --> bereits oben
  if GNavigator <> nil then
  begin
    for I1 := 0 to FColumnList.Count-1 do
    begin
      S := FColumnList.Param(I1);
      if Char1(S) <> ':' then    //keine Steuerzeilen übersetzen
      begin
        P := Pos(':', S);
        if P > 0 then
          S1 := GNavigator.TranslateStr(self, copy(S, 1, P- 1)) + copy(S, P, 100) else
          S1 := GNavigator.TranslateStr(self, S);
        if S1 <> S then
          FColumnList[I1] := S1 + '=' + FColumnList.Value(I1);
      end;
    end;
  end;
  LoadedColumnList.Assign(FColumnList); {050101}
  AddKeyList;
  if not (csDesigning in ComponentState) then
  begin
    { Es wird ein Duplikat des Popupmenu mit dem Multi-Menü kombiniert.
      Verwendung: das PopupMenu bleibt für andere Zwecke unverändert. - 09.01.05
      Aktivierung: muDuplPopUp und muAddPopUp in MuOptions auf true setzen
      Status: produktiv }
    if PopupMenu <> nil then
    begin
      FPopupOnPopup := PopupMenu.OnPopup;   //Ereignis uns aneignen
    end;
    if (PopupMenu <> nil) and (muDuplPopUp in MuOptions) then
    begin
      LoadedPopupMenu := PopupMenu;
      PopupMenu := TPopupMenu.Create(Form);  //beware (self) !
      //PopupMenu.Items.Add(LoadedPopupMenu.Items); - ergibt leeres
      //PopupMenu.Assign(LoadedPopupMenu); - ergibt Runtime Fehler Stack
      for I1 := 0 to LoadedPopupMenu.Items.Count - 1 do
      begin
        //PopupMenu.Items.Add(LoadedPopupMenu.Items[I1]);
        NewItem := TMenuItem.Create(Form); //PopupMenu);  {Erzeugen des neuen Menüeintrags}
        with LoadedPopupMenu.Items[I1] do
        begin
          Inc(NameCounter);
          NewItem.Name := Name + '_' + IntToStr(NameCounter);
          NewItem.Break := Break;
          NewItem.Caption := Caption;
          NewItem.Enabled := Enabled;
          NewItem.HelpContext := HelpContext;
          NewItem.Hint := Hint;
          NewItem.ImageIndex := ImageIndex;
          NewItem.ShortCut := ShortCut;
          NewItem.Tag := Tag;
          NewItem.Visible := Visible;
          NewItem.OnAdvancedDrawItem := OnAdvancedDrawItem;
          NewItem.OnClick := OnClick;
          NewItem.OnDrawItem := OnDrawItem;
          NewItem.OnMeasureItem := OnMeasureItem;
          //ProtA('NewItem(%s)', [NewItem.Name]);
        end;
        PopupMenu.Items.Add(NewItem);                  {Einfügen des neuen Menüeintrags}
      end;
    end;
    if (PopupMenu = nil) or (muAddPopUp in MuOptions) then
      AddPopup;
  end;
end;

procedure TMultiGrid.DefineFieldMap;             {override;}
begin
  if (csDesigning in ComponentState) then        {130597}
    ColumnsDefined := false;
  DefineColumns;
  inherited DefineFieldMap;
  if csDesigning in ComponentState then
    Exit;
  if Assigned(FOnLayoutChanged) then
    FOnLayoutChanged(self);
  PostMessage(Handle, BC_MULTIGRID, mgSaveLayout, 0);
end;

procedure TMultiGrid.UpdateField;
(* für UpdäteEdit *)
var
  S: string;
begin
  if (SelectedField <> nil) and not (SelectedField is TBlobField) and
     (InplaceEditor <> nil) and EditorMode and InplaceEditor.Modified then
  begin
    S := InplaceEditor.Text;
    if SelectedField.Text <> S then
      SelectedField.Text := S;
  end;
  (*
  if (SelectedField <> nil) and not (SelectedField is TBlobField) then
  begin
    S := GetEditText(SelectedField.Index, ActiveRow);   ungenau
    if SelectedField.Text <> S then
      SelectedField.Text := S;
  end;*)
end;

function TMultiGrid.CheckFocus: boolean;
(* MultiGrid ist ActiveControl. Hier wird bestimmt ob der GNavigator sich
   auf die Multigrid beziehen soll.
   > true=SetLink auf self wurde durchgeführt.
   * für doEnter, und für GNav.ActiveFormChanged *)
var
  ALuDef: TLookUpDef;
begin
  result := false;
  if (DataSource <> nil) and (DataSource is TLookUpDef) then
  begin
    ALuDef := DataSource as TLookUpDef;
    if ALuDef.LinkToGNav then   {Wenn verbunden mit GNav}
    begin
      //AForm := (Form as TqForm);
      GNavigator.SetLink(Form, ALuDef.NavLink, ALuDef);       {-> Checkt Color}
      result := true;
      GNavigator.PageChanged('Multi');      {Buttons auf Multi Sicht einstellen}
      {SMess('Zuordnung Erfassen oder Löschen',[0]);}
      if ALuDef.AutoOpen and (ALuDef.DataSet <> nil) then
        ALuDef.DataSet.Active := true;       {301098 - Öffnen I.V.m. AutoOpen}
    end;
  end;
end;

procedure TMultiGrid.DoEnter;
begin
  {DefineColumns;}
  inherited DoEnter;
  CheckFocus;
end;

procedure TMultiGrid.DoExit;
var
  ALNav: TLNavigator;
  ALuDef: TLookUpDef;
begin
  {ColumnsDefined := false;}
  if csDesigning in ComponentState then
  begin
    inherited DoExit;
    Exit;
  end;
  if muPostOnExit in MuOptions then
    if (NavLink <> nil) and (NavLink.DataSet <> nil) then
      NavLink.DoPost(True);
  if DataSource is TLookUpDef then
  begin
    ALuDef := DataSource as TLookUpDef;
    if ALuDef.LinkToGNav then
    begin
      ALNav := FormGetLNav(Form);
      GNavigator.SetLink(Form, ALNav.NavLink, ALNav.NavLink.ActiveSource); {Checkt Color}
      if ALNav.PageBook <> nil then
        GNavigator.PageChanged(ALNav.GetPage);
      SMess('',[0]);
    end;
  end;
  inherited DoExit;            {erst hier !}
end;

procedure TMultiGrid.KeyPress(var Key: char);
var
  Param: string;
  I: integer;
  ADBEdit: TDBEdit;
  Done: boolean;
  S1: string;
begin
  Done := false;

  if SelectedField <> nil then
  begin
    I := SavedColumns.ParamIndex(SelectedField.FieldName, @Param);
    if I >= 0 then                   {realisiert Uppercase über entspr. DBEdit}
    begin
      if SavedColumns.Objects[I] is TDBEdit then
        ADBEdit := SavedColumns.Objects[I] as TDBEdit else
        ADBEdit := nil;
      if ADBEDit <> nil then
      begin
        if ADBEdit.ReadOnly and    // Readonly Felder nicht editierbar - 17.08.08 dpe
           not SysParam.AllowEditReadOnly then
        begin
          S1 := ADBEdit.DataField;
          if (DataSet <> nil) and (DataSet.FindField(S1) <> nil) then
            S1 := DataSet.FindField(S1).DisplayName;
          SMess(SMugriKmp_017, [S1]); //'Ändern dieser Spalte nicht erlaubt (%s)'
          if not DelphiRunning then
          begin
            Key := #0;
            Done := true;
          end;  
        end else
        if ADBEdit.CharCase = ecUpperCase then
        begin
          Key := AnsiUpperCase(Key)[1];
          Done := true;
        end;
      end;
    end;
  end;
  if not Done then
    inherited KeyPress(Key);
  if (Dataset <> nil) and (Dataset.State = dsBrowse) then
  begin
    KeyPressKey := Key;
    if SysParam.UseKeyPressKey and (KeyPressKey <> #0) and
       DataSource.AutoEdit and DataSource.DataSet.CanModify and
       not DataSource.DataSet.EOF then
    try
      Key := #0;
      DataSource.Edit;
    except on E:Exception do
      EProt(self, E, 'KeyPress %s', [Key]);
    end;
  end;
end;

procedure TMultiGrid.SetMuOptions(const Value: TMuOptions);
var
  S: string;
begin
  FMuOptions := Value;
  S := SMugriKmp_015; //'Reihenfolge mit der Maus ziehen';
  if (muDrag in FMuOptions) and
     ((Hint = '') or (Hint = 'Reihenfolge mit der Maus ziehen')) then  //25.04.13
  begin
    Hint := S;
  end else
  if not (muDrag in FMuOptions) and (Hint = S) then
    Hint := '';

  //25.04.13
  if (muSlideBar in MuOptions) and (Dataset <> nil) and (Dataset is TuQuery) then
  begin
    TuQuery(Dataset).Options.QueryRecCount := true;
  end;
end;

procedure TMultiGrid.SetOptions(NewOptions: TDBGridOptions);
begin
{  if Options <> NewOptions then
    Options := NewOptions;}
  NextOptions := NewOptions;
  if ToggleEditor and Focused then
    SendMessage(self.Handle, BC_EXTGRIDSCR, egSetOptions, 0)  {171100 ELP}
  else
    PostMessage(self.Handle, BC_EXTGRIDSCR, egSetOptions, 0);  //19.08.02 LAWA.MEST Positioniert sonst auf 0 nach Insert/Post
//  TCustomGridHack(self).Options := TCustomGridHack(Self).Options + [goRowSizing];
end;

procedure TMultiGrid.CNKeyDown(var Message: TWMKeyDown);
(* Besser als KeyDown, da dort RETURN I.V.m. PokupMenu nicht geht *)
var
  ALNav: TLNavigator;
  ShiftState: TShiftState;
begin
  if csDesigning in ComponentState then
  begin
    inherited;
    Exit;
  end;
  with Message do
  try
    ALNav := FormGetLNav(Form);
    ShiftState := KeyDataToShiftState(KeyData);
    if (CharCode = VK_RETURN) and (ALNav <> nil) and
       not ALNav.dsQuery and not ALNav.dsChangeAll then
    begin
      if not ALNav.MuDblClick(self) then             {ALNav.SetPage('Single');}
        EditorMode := True;
    end else
    if (CharCode = VK_RIGHT) and (ShiftState = []) and (dgRowSelect in Options) then
    begin
      {SendMessage(Handle, WM_HSCROLL, SB_LINEDOWN, 0);  auch OK}
      SetOptions(NextOptions - [dgRowSelect]);
      {Col := MouseCoord(Width-10, 0).X;  ok so aber schlecht wenn fit}
      Col := FixedCols + 1;
    end else
    if (CharCode = VK_LEFT) and (ShiftState = []) and RowSelect and (Col = 1) then
    begin
      {SendMessage(Handle, WM_HSCROLL, SB_LINEUP, 0);}
      SetOptions(NextOptions + [dgRowSelect]);
    end else
    if (CharCode = VK_END) and (ShiftState = []) and RowSelect and (Col = 1) then
    begin
      SetOptions(NextOptions - [dgRowSelect]);
      inherited;
    end else
    if (CharCode = VK_HOME) and (ShiftState = []) and RowSelect then
    begin
      SetOptions(NextOptions + [dgRowSelect]);
    end else
    begin
      inherited;
    end;
  except on E:Exception do
      ErrException(DataSource.DataSet, E);
  end;
end;

procedure TMultiGrid.KeyDown(var Key: Word; Shift: TShiftState);
(* nur noch um Shift+Ctrl+Up/Down von dbgrid fernzuhalten *)
begin
  if csDesigning in ComponentState then
  begin
    inherited KeyDown(Key, Shift);
    Exit;
  end;
  if Shift = [ssShift,ssCtrl] then
  begin
    case Key of
      VK_UP: DataSet.Prior;
      VK_DOWN: DataSet.Next;
    end;
  end else
  try                                                {kein Insert über Down-Key}
    if NavLink <> nil then
      NavLink.InMuKeyDown := not (muAutoExpand in MuOptions); {Flag für NewAfterInsert}
    inherited KeyDown(Key,Shift);
    SendMessage(Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
  finally
    if NavLink <> nil then
      NavLink.InMuKeyDown := false;
  end;
  if (ComponentState + [csFreeNotification] = [csFreeNotification]) and
     (NavLink <> nil) and
     (NavLink.nlState in nlEditStates) and
     (Shift = []) and (Key = VK_RETURN) then  //Speichern bei Enter
  begin
    //GNavigator.X.BtnClick(qnbPost);  kann falschen NL haben
    NavLink.DoPost(True);
  end;
end;

procedure TMultiGrid.DblClick;
var
  ALNav: TLNavigator;
  ALookUpDef: TLookUpDef;
  aKeyField: string;
  aCol, aRow: integer;
begin
  if csDesigning in ComponentState then
  begin
    inherited DblClick;
    Exit;
  end;
  try
    ALNav := FormGetLNav(Form);
    aKeyField := '';
    ARow := MouseCoord(MouseDownX, MouseDownY).Y;
    if ARow < FixedRows then
    begin  //nur Ueberschrift
      aCol := MouseCoord(MouseDownX, MouseDownY).X;
      aKeyField := VisibleColumnList.Value(ACol - FixedCols);
      if aKeyField <> '' then
      begin
        //if BeginsWith(ALNav.KeyFields, aKeyField, true) and
        //   (PosI('desc', ALNav.KeyFields) = 0) then
        if ssCtrl	in MouseDownShift then
          aKeyField := aKeyField + ' desc';
      end;
      if (aKeyField <> '') and (Navlink <> nil) and (Navlink.nlState in [nlBrowse, nlInactive]) then
      begin
        SortColumn(aKeyField);
      end;
    end else
    {if (ALNav <> nil) and ReturnSingle and not ALNav.dsQuery dsChangeAll then
    begin
      ALNav.SetPage('Single');
    end else}
    if ReturnSingle and (DataSource <> nil) and (DataSource is TLookUpDef) and
       (TLookUpDef(DataSource).NavLink.nlState = nlBrowse) then
    begin
      {TLookUpDef(DataSource).LookUp(lumZeigMsk);}
      ALookUpDef := TLookUpDef(DataSource);
      if (ALookUpDef.LookUpSource <> nil) then
      begin
        TLookUpDef(ALookUpDef.LookUpSource).LookUp(lumZeigMsk);
      end else
        ALookUpDef.LookUp(lumZeigMsk);
    end else
    if (ALNav <> nil) and (ALNav.DataSource = self.DataSource) then
    begin
      if not ALNav.MuDblClick(self) then
        inherited DblClick;
    end else
    begin
      if DataSet <> nil then
        DataSet.Open;
      inherited DblClick;          //jetzt immer. 17.09.02 ISA
    end;
  except on E:Exception do
      ErrException(DataSource.DataSet, E);
  end;
end;

procedure TMultiGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Err: integer;
  //isMultiSelect: boolean;
  Cell: TGridCoord;
begin
  if csDesigning in ComponentState then
  begin
    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;
  if not AcquireFocus then
     Exit;  //von DBGrids
  Err := 0;
  MouseDownX := X;
  MouseDownY := Y;
  MouseDownShift := Shift;
  if Button = mbRight then
  try
    //if (Form = nil) or not Form.Active then
    //  Exit;
    //if (Form <> nil) and not Form.Active then
    //  Form.SetFocus;
    Cell := MouseCoord(X, Y);
    with Cell do
    begin
      if (Y >= FTitleOffset) and (Y - Row <> 0) then
        DataLink.DataSet.MoveBy(Y - Row);
      //14.07.10 Columnlist zeigt falsche Spalte wenn sie unbekannte Felder enthält.
      if X >= FIndicatorOffset then
        SelectedField := DataSet.FindField(VisibleColumnList.Value(X - FIndicatorOffset)); //MoveCol(X, 0);
    end;


//    isMultiSelect := dgMultiSelect in Options;
//    try
//      Options := Options - [dgMultiSelect];       //Selection vermeiden
//      inherited MouseDown(Button, Shift, X, Y);  //Fokussiert und geht gleich zur Zelle
//    finally
//      if isMultiSelect then
//        Options := Options + [dgMultiSelect];
//    end;

//      inherited MouseDown(Button, Shift, X, Y);  //Fokussiert und geht gleich zur Zelle
//      if (SelectedRows.Count = 1) and SelectedRows.CurrentRowSelected then    {Std-Verhalten von Delphi ändern:}
//        SelectedRows.CurrentRowSelected := false; {das einfache klicken bewirkt jetzt keine Markierung}
  except on E:Exception do
    EProt(self, E, 'TMultiGrid.MouseDown.mbRight(%s):%d', [OwnerDotName(self), Err]);
  end else
  if Button = mbLeft then
  try                                                          (* Drag & Drop *)
    Err := 10;
    inherited MouseDown(Button, Shift, X, Y);
    Err := 20;
    if (SelectedRows.Count = 1) and SelectedRows.CurrentRowSelected and
       (Button = mbLeft) and
       ([ssCtrl, ssShift] * Shift = []) then    {Std-Verhalten von Delphi ändern:}
    begin
      Err := 30;
      SelectedRows.CurrentRowSelected := false; {das einfache klicken bewirkt jetzt keine Markierung}
    end;
    Err := 40;
    if (Shift = [ssLeft]) and
       (Button = mbLeft) and
       (RowFromXY(X,  Y) >= 0) and (X > ColWidths[0]) and
       (GNavigator.DragCount = 0) then
    begin                   {hier müsste auf aktuellen Record positioniert sein}
      Err := 50;
      DragRow := RowFromXY(X, Y);                {Zeile die gezogen werden soll}
      Err := 60;
      BeginDrag(false);
    end;
    Err := 70;
    SendMessage(Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
  except on E:Exception do
    EProt(self, E, 'TMultiGrid.MouseDown(%s):%d', [OwnerDotName(self), Err]);
  end else
  if Button = mbMiddle then
  begin
    inherited MouseDown(mbLeft, Shift, X, Y);
    // Std-Verhalten von Delphi ist bereits 'markieren'
    //SelectedRows.CurrentRowSelected := not SelectedRows.CurrentRowSelected;
    SendMessage(Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
  end;
end;

procedure TMultiGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if csDesigning in ComponentState then
  begin
    inherited MouseUp(Button, Shift, X, Y);
    Exit;
  end;
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TMultiGrid.BeforeReload;
//neu Laden, auf gleiche Zeile gehen und: Position innerhalb sichtbarem Bereich behalten!
begin
  ReloadDiff := VisibleRowCount - DataLink.ActiveRecord - 1;  //+ 1
end;

procedure TMultiGrid.AfterReload;
//neu Laden, auf gleiche Zeile gehen und: Position innerhalb sichtbarem Bereich behalten!
var
  I, N: integer;
begin
  N := 0;
  for I := 1 to ReloadDiff do
  begin
    DataSet.Next;    //delay(200);  ProtL('next %d', [DataLink.ActiveRecord]);
    if not DataSet.EOF then
      Inc(N);
  end;
  for I := 1 to N do
  begin
    DataSet.Prior;     //delay(200);  ProtL('prior %d', [DataLink.ActiveRecord]);
  end;
  //wmess('hallo', [0]);
  //Application.ProcessMessages;
  //ProtL('hallo %d', [DataLink.ActiveRecord]);
end;

procedure TMultiGrid.DragOver(Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  ARow: longint;
  OldActive: integer;
  Allow, MuAllow: boolean;
begin
  Accept := false;
  if (GNavigator.DragCount = 0) and
     (Assigned(FOnBeginDrag) or (muDrag in MuOptions)) then
  begin
    (* BeginDrag: *)
    Inc(GNavigator.DragCount);
    MuAllow := false;
    Allow := Assigned(FOnBeginDrag);
    OldActive := DataLink.ActiveRecord;
    DataLink.ActiveRecord := DragRow; {zu ziehende als aktuellen von DataSet setzen}
    if muDrag in MuOptions then
      MuBeginDrag(X, Y, MuAllow);                       {internes Drag&Drop}
    if Assigned(FOnBeginDrag) {and not Allow} then
    try
      FOnBeginDrag(self, X, Y, Allow);                {erst hier !}
    except on E:Exception do
      begin
        ErrWarn('%s',[E.Message]);
        Allow := false;
      end;
    end;
    DataLink.ActiveRecord := OldActive;
    if not Allow and not MuAllow then {nicht erlaubt}
    begin
      Accept := false;
      //EndDrag(false);
      Exit;
    end;
  end;
  (* DragOver: *)
  ARow := RowFromXY(X, Y);
  OldActive := DataLink.ActiveRecord;
  try
    if ARow >= 0 then
    begin
      DataLink.ActiveRecord := ARow;        {von Sender}
      //if (muDrag in MuOptions) and not (muUserDragOver in MuOptions) then
      if (muDrag in MuOptions) and not assigned(OnDragOver) then  //Bsp. für Event in lawa.frzgfrm 30.03.03
        MuDragOver(Source, X, Y, State, Accept);              {internes Drag&Drop}
    end;
    if not Accept then
    begin
      inherited DragOver(Source, X, Y, State, Accept);      {mit Ereignis OnDragOver}
    end;
  finally
    DataLink.ActiveRecord := OldActive;
  end;
  if Accept then
    DragOverRow := DBRowFromXY(X, Y) else
    DragOverRow := -1;
  if (DragOverOldRow <> DragOverRow) then
  begin
    DragOverOldRow := DragOverRow;
    Invalidate;
  end;
end;

procedure TMultiGrid.DragDrop(Source: TObject; X, Y: Integer);
var
  ARow: longint;
  OldActive: integer;
begin
  DragOverRow := -1;
  ARow := RowFromXY(X, Y);
  OldActive := DataLink.ActiveRecord;
  try
    Closed := false;
    if DropTablename = '' then
      DropTablename := NavLink.TableName;
    if ARow >= 0 then
    begin
      DataLink.ActiveRecord := ARow;
      if muDrag in MuOptions then
        MuDragDrop(Source, X, Y);                             {internes Drag&Drop}
    end;
    inherited DragDrop(Source, X, Y);
  finally
    if muDrag in MuOptions then  //13.07.10 nicht wenn selbst verwaltet
      if not Closed then
        DataLink.ActiveRecord := OldActive;
  end;
end;

procedure TMultiGrid.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  try
    if muDrag in MuOptions then
      MuEndDrag(Target, X, Y);                              {internes Drag&Drop}
    inherited DoEndDrag(Target, X, Y);
  finally
    DragOverRow := -1;
    if GNavigator.DragCount > 0 then                      {040400}
      Invalidate;
    GNavigator.DragCount := 0;
  end;
end;

procedure TMultiGrid.Scroll(Distance: Integer);
begin
  if csDesigning in ComponentState then
  begin
    inherited Scroll(Distance);
    Exit;
  end;
  try
    if muSlideBar in MuOptions then
      SlideBarScroll(Distance) else
      inherited Scroll(Distance);
    if csDesigning in ComponentState then
      Exit;
    RowOffset := RowOffset + Distance;
    ActiveRow := ActiveRow + Distance;   {-   020398}
  except on E:Exception do
    EProt(self, E, 'Scroll(%d)', [Distance]);
  end;
end;

procedure TMultiGrid.DoCellChanged(ClearFlag: boolean);
//bei bestimmten Spalten vollständigen Text in Statuszeile anzeigen
begin
  if (SelectedField <> nil) and
     (Pos('H', DisplayList.Values[SelectedField.FieldName]) > 0) then
  begin
    SMess('%s', [SelectedField.AsString]);
  end else
  if ClearFlag then
    SMess0;
end;

procedure TMultiGrid.ColEnter;
begin
  inherited;
  DoCellChanged(false);
end;

function TMultiGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  result := inherited SelectCell(ACol, ARow);
  if csDesigning in ComponentState then
    Exit;
  if result then
  begin
    SelectedRow := ARow-1 + RowOffset;
  end;
  if DataSet <> nil then
  begin
    if TmpBookmark <> nil then
      DataSet.FreeBookMark(TmpBookMark);
    TmpBookMark := DataSet.GetBookMark;
  end;
end;

procedure TMultiGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
(* Markierungen zeichnen *)
var
  AField: TField;
  FontStyle: TFontStyles;
  iot: integer;
  ChangeFont: integer;
begin
  if csDesigning in ComponentState then
  begin
    inherited DrawCell(ACol, ARow, ARect, AState);
    Exit;
  end;
  try
    IsActiveRow := Assigned(DataLink) and DataLink.Active and
                   (ARow - FixedRows = DataLink.ActiveRecord);  //FixedRows statt 1 - 23.07.06
    if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    try
     inherited DrawCell(ACol, ARow, ARect, AState);          {ruft DrawDataCell}
    except on E:Exception do
      EProt(self, E, 'DrawCell(%d,%d)', [ACol, ARow]);
    end;
    with Canvas, ARect do
    begin
      //Test Tmb 24.07.06
//       if (ACol = 0) and (ARow >= FixedRows) then
//       begin
//         FillRect(ARect);                                        {clear the cell}
//         TextOut(ARect.Left+2, ARect.Top+2, IntToStr(ARow));
//       end;
      //
      if (DragOverRow >= 0) and (ARow >= FixedRows) and
         (ARow-FixedRows + RowOffset = DragOverRow) and (ACol = 0) then
      begin
        Brush.Color := clHighLight;               {Dragover-Zeile links markieren}
        //FloodFill(Left, Top, clBlack, fsBorder);
        FloodFill(Left, Top, FixedColor, fsSurface);
      end;
      if (ARow = 0) then
      begin
        AField := GetColField(ACol - FixedCols);
        FontStyle := [];
        ChangeFont := 0;
        if (AField <> nil) and (NavLink <> nil) and        {(AField.IsIndexField)}
           (dgTitles in Options) then
        begin
          if AField.Tag = -2 then
          begin
            ChangeFont := -1;
            FontStyle := FontStyle + [fsBold]; {Italic]; {Bold];}
          end;
          iot := IndexOfToken(UpperCase(AField.FieldName), UpperCase(NavLink.KeyFields), '; ');
          if iot >= 0 then
          begin
            ChangeFont := 1;
            //todo: nur ersten SICHTBAREN Key markieren
            if iot = 0 then  //nur ersten Key markieren. Restl. nur 'platt' anzeigen
              FontStyle := FontStyle + [fsUnderline];      {Italic]; {Bold];}
          end;
        end;
        if ChangeFont <> 0 then  //FontStyle <> [] then
        begin
          FillRect(ARect);                                        {clear the cell}
          Font.Style := Font.Style + FontStyle; {Italic]; {Bold];}
          TextOut(ARect.Left+2, ARect.Top+2, AField.DisplayLabel);
          if ChangeFont > 0 then
          begin  //Sortkey: Button gedrückt
            {ist zwar ok aber sieht nicht so toll aus (oben zu viel black). Besser plain
            DrawEdge(Canvas.Handle, ARect, BDR_SUNKENINNER, BF_BOTTOMRIGHT);
            DrawEdge(Canvas.Handle, ARect, BDR_SUNKENINNER, BF_TOPLEFT); }
          end else
          begin  //Standard: Button losgelassen
            DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);
            DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOPLEFT);
          end;
        end;
      end;
    end; {with}
  except on E:Exception do
    EProt(self, E, 'DrawCell', [0]);
  end;
  if TextWidth_Of_0 = 0 then
  begin
    TextWidth_Of_0 := Canvas.TextWidth('0');
    GetTextMetrics(Canvas.Handle, TM);
  end;
end;

procedure TMultiGrid.DrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
// Memos, Asw Felder: ausgeben. Act ive Ro w definieren
var
  BS: tBlobStream;                                        {from the memo field}
  S: string;
  notFocused: boolean;
  R: TRect;
  Buffer: PChar;
  MemSize: Integer;
  W: integer;
  OldClBrush: TColor;
begin
  if csDesigning in ComponentState then
  begin
    inherited DrawDataCell(Rect, Field, State);
    DefaultDrawDataCell(Rect, Field, State);
    Exit;
  end;
  try
    notFocused := not (gdFocused in State) {or (Canvas.Font.Color = Font.Color)};
    if notFocused and (IsActiveRow) and Assigned(Field) then
    begin
      if (Field.DataSet.State in [dsInsert,dsEdit]) and (Field.CanModify) and
         not IsBlobField(Field) and
         ((not (muCustColor in MuOptions) and not ReadOnly) or
          (muEditColor in MuOptions)) then
      begin
        Canvas.Brush.Color := GNavigator.ColorEditWhite;
      end;
    end;

    OldClBrush := clWindow;  // warum so nicht? Canvas.Brush.Color;
    if (NavLink <> nil) and (NavLink.NlState <> nlQuery) then
      inherited DrawDataCell(Rect, Field, State);  //Ereignis aufrufen

    if not (gdFocused in State) and
       not SelectedRows.CurrentRowSelected and
       (Field.DataSet.State = dsBrowse) and
       IsActiveRow and
       ((OldClBrush = Color) or (OldClBrush = clWindow)) and
       ((muColorActiveRow in MuOptions) or
        (SysParam.ColorActiveRow and not (muNoColorActiveRow in MuOptions))) then
    begin  //16.07.14 neu: aktive Zeile hellblau färben
      Canvas.Brush.Color := GNavigator.ColorMarkAll;
    end;

    if not Assigned(Field) or
       ((Field is TBlobField) and (NavLink <> nil) and NavLink.InsertFlag) then
    begin
      DefaultDrawDataCell(Rect, Field, State);
    end else
    begin //neu
      S := '';
      if Pos('S', DisplayList.Values[Field.FieldName]) > 0 then     {S=AsString zB für Asw}
      begin
        (* 25.04.09: Test: auch auf Einzelsicht keinen Auswahltext zeigen
        Field.Tag := -1;
        Field.OnGetText := nil;
        Field.OnSetText := nil; *)
        S := Field.AsString;
        with Canvas do
        begin
          FillRect(Rect);                              {clear the cell}
          TextOut(Rect.Left+2, Rect.Top+2, S);         {fill cell with data}
        end;
      end else
      if (Field is TStringField) or (Field is TMemoField) then with Canvas do
      begin
        R := Rect;
        InflateRect(R, -2, -2);
        FillRect(Rect);
        if Field is TMemoField then
           S := Field.AsString else
           S := Field.DisplayText;         //22.01.13 Display ergänzt  //Text wg Asw
        //if R.Bottom - R.Top > (TextHeight('Wg') * 3) div 2  then
        if DrawMultiLine then
        begin                                        {mehrzeilig ausgeben}
          if Field.Alignment = taRightJustify then
            DrawText(Handle, pchar(S), -1, R, DT_WORDBREAK or DT_NOPREFIX or DT_RIGHT)
          else
            DrawText(Handle, pchar(S), -1, R, DT_WORDBREAK or DT_NOPREFIX or DT_LEFT);
        end else
        begin
          if CRChar <> #0 then    //nur für DOS Zeilentrenner CRLF
          begin
            //S := StrCgeChar(StrCgeChar(S, CR, CRChar), LF, #0);
            S := StringReplace(StringReplace(S, CR, CRChar, [rfReplaceAll]), LF, '', [rfReplaceAll]);
          end;
          if Field.Alignment = taRightJustify then
            DrawText(Handle, pchar(S), -1, R, DT_SINGLELINE or DT_NOPREFIX or DT_RIGHT)
          else
            DrawText(Handle, pchar(S), -1, R, DT_SINGLELINE or DT_NOPREFIX);
        end;
      end else
      if Field is TBooleanField then
      begin
        if Field.IsNull then
          S := '' else
        if Field.AsBoolean then
          S := 'X' else     {'Ja' else}
          S := '-';         {'Nein';}
        with Canvas do
        begin
          FillRect(Rect);                              {clear the cell}
          TextOut(Rect.Left+2, Rect.Top+2, S);         {fill cell with data}
        end;
      end else
      if Field is TBlobField then
      try
        BS := TBlobStream.Create(Field as TBlobField, bmRead);
        MemSize := BS.Size;
        Inc(MemSize); {Platz für das abschließende NULL-Zeichen des Puffers machen}
        Buffer := AllocMem(MemSize);     {Speicher einrichten}
        try
          BS.Read(Buffer^, MemSize); {Das Feld in den Puffer lesen}
          BS.Free;
          with Canvas do
          begin
            FillRect(Rect);                              {clear the cell}
            R := Rect;
            InflateRect(R, -2, -2);                      {mehrzeilig ausgeben}
            {R.Right := R.Right - GetSystemMetrics(SM_CXVSCROLL);}
            //if R.Bottom - R.Top > (TextHeight('Wg') * 3) div 2 then   {Multiline }
            if DrawMultiLine then
              DrawText(Canvas.Handle, Buffer, -1, R, DT_WORDBREAK or DT_NOPREFIX) else
              DrawText(Canvas.Handle, Buffer, -1, R, DT_SINGLELINE or DT_NOPREFIX);
          end;
        finally
          FreeMem(Buffer);
        end;
      except
        DefaultDrawDataCell(Rect, Field, State);
      end else
      begin
        S := Field.Text;  //Numeric, Date usw. für Optimize Width
        DefaultDrawDataCell(Rect, Field, State);
      end;
      if (S <> '') and (OptiWidthFlag or                        {Optimize Width}
          (PosI('O', DisplayList.Values[Field.FieldName]) > 0)) then
      begin
        W := IMax(StrToIntDef(OptiWidthList.Values[Field.FieldName], 0),
                  IMax(Canvas.TextWidth(S), Canvas.TextWidth(Field.DisplayLabel)));
        OptiWidthList.Values[Field.FieldName] := IntToStr(W);
        if OptiWidthHandled then
        begin
          OptiWidthHandled := false;
          PostMessage(Handle, BC_MULTIGRID, mgOptiWidth, 0);
        end;
      end;
    end;
  except on E:Exception do
    EProt(self, E, 'DrawDataCell', [0]);
  end;
end;

procedure TMultiGrid.CheckMusiButtons;
var
  aFrMuSi: TFrMuSi;
  B1: boolean;
begin
  if (Parent is TFrMuSi) and (DataSource <> nil) then
  begin
    aFrMuSi := TFrMuSi(Parent);
    B1 := (DataSet <> nil) and (Dataset.State = dsBrowse) and not (DataSet.BOF and DataSet.EOF);
    if DataSource is TLookUpDef then
    begin
      aFrMusi.btnSingle.Enabled := B1;
      aFrMusi.btnEdit.Enabled := B1;
      aFrMusi.btnDelete.Enabled := B1;
    end else
    begin
      aFrMusi.btnSingle.Enabled := B1;
      aFrMusi.btnEdit.Enabled := B1;
      aFrMusi.btnDelete.Enabled := B1;
    end;
  end;
end;

procedure TMultiGrid.BCStateChange(var Message: TWMBroadcast);
var
  AnlState: TNavLinkState;
  ALNav: TLNavigator;
begin
  AnlState := TNavLinkState(Message.Data);
  ALNav := FormGetLNav(Form);

  CheckMusiButtons;

  if (NavLink <> nil) and (Message.Sender = NavLink.MasterSource) and
     (DataSource is TLookUpDef) and (ALNav <> nil) and
     (lnAutoEditLu in ALNav.Options) then
  begin            {wir bearbeiten hier die Nachricht an die Haupt-Grid}
    if not TLookUpDef(DataSource).LoadedAutoEdit then   {24.07.01}
      DataSource.AutoEdit := AnlState in nlEditStates;
    if (NavLink.nlState = nlQuery) or
       (((NavLink.nlState in [nlEdit,nlInsert]) or (DataSource.AutoEdit)) and
        (reUpdate in NavLink.TabellenRechte)) then
      SetOptions(NextOptions + [dgEditing]) else
      SetOptions(NextOptions - [dgEditing]);
  end else

  if (NavLink <> nil) and (Message.Sender = DataSource) then
  try
    if (AnlState = nlQuery) or not (dgCancelOnExit in LoadedOptions) or
       (NavLink.ErfassSingle and not (DataSource is TLookUpDef)) then
      SetOptions(NextOptions - [dgCancelOnExit]) else
      SetOptions(NextOptions + [dgCancelOnExit]);

    if not (muAutoExpand in MuOptions) and (AnlState = nlInsert) and
       not NavLink.InDoInsert and not NavLink.InDoPost then
       //04.06.09 NavLink.InAfterReturn then
       //04.06.09 Focused then
    begin
      Prot0(SMugriKmp_001, [NavLink.Kennung]);	// '%s:Einfügen abgebrochen'
      DataSet.Cancel;
      KeyPressKey := #0;
    end;

    {if (AnlState in [nlEdit,nlInsert,nlQuery]) or (muAutoExpand in MuOptions) then
      SetOptions(NextOptions + [dgEditing,dgAlwaysShowEditor]) else
      SetOptions(NextOptions - [dgEditing,dgAlwaysShowEditor]);}
    {if DataSource.AutoEdit then
      SetOptions(NextOptions + [dgAlwaysShowEditor]);}

    {das führt zu leeren Zellen bei StateChanged nach Cancel!}
    {26.09.02 FÜR imex SO ok}
//04.12.02 beware:akzeptiert nicht immer Suchkrits (Gen). Verfälscht Eingabe (Quva.lfsk)!
    if ToggleEditor then
    begin
      if (AnlState in [nlEdit,nlInsert,nlQuery]) then
        SetOptions(NextOptions + [dgAlwaysShowEditor]) else
        SetOptions(NextOptions - [dgAlwaysShowEditor]);
    end else
    if SysParam.UseKeyPressKey and (KeyPressKey <> #0) then
    begin
      if (muAutoExpand in MuOptions) or not DataSet.EOF then
        PostMessage(self.Handle, WM_CHAR, WPARAM(KeyPressKey), 0);
      KeyPressKey := #0;
    end;

//     //Versuch 17.09.02 ISA  nicht mehr zurücknehmen. Schlecht
//     if (AnlState in [nlEdit,nlInsert,nlQuery]) then
//      SetOptions(NextOptions + [dgAlwaysShowEditor]);

    if (AnlState = nlQuery) or
       (((AnlState in [nlEdit,nlInsert]) or (DataSource.AutoEdit)) and
        (reUpdate in NavLink.TabellenRechte)) then
      SetOptions(NextOptions + [dgEditing]) else
      SetOptions(NextOptions - [dgEditing]);            //Y Pos. falsch wenn in Post

    if (AnlState in [nlEdit,nlInsert,nlQuery]) then
      SetOptions(NextOptions - [dgRowSelect]) else
    if dgRowSelect in LoadedOptions then
      SetOptions(NextOptions + [dgRowSelect]);

    if (AnlState = nlInactive) then
    begin
      RowOffset := 0;
      Closed := true;             {für DragDrop}
      ColumnsDefined := false;    {sonst verliert er Col-Infos da Felder weg}
    end else
    if DataChangedCount = 0 then
    begin
      Inc(DataChangedCount);
      PostMessage(self.Handle, BC_EXTGRIDSCR, egDataChanged, 0);   //Y
    end;
    if (AnlState = nlBrowse) then
    begin  //Gen - 10.01.07 - OK (letzte Zeile wird nicht komplett gezeigt)
      PostMessage(self.Handle, BC_EXTGRIDSCR, egSetRowSize, FRowHeight - 1);
      PostMessage(self.Handle, BC_EXTGRIDSCR, egSetRowSize, FRowHeight);
    end;
  finally
  end;
  SendMessage(Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
end;

procedure TMultiGrid.DefineColumns;
var
  I, P, N: integer;
  ADisplay, ADisplayOptions, AFieldName, NextS: string;
  AField: TField;
  IsVisible: boolean;
  DispWidth: integer;
begin                                                     {ColumnList -> Fields}
  if (DataSource = nil) or (DataSource.DataSet = nil) or
     (DataSource.DataSet.FieldCount = 0) or
     (csLoading in ComponentState) then
  begin
    //23.05.02 ReSize;
    Exit;
  end;
  if not InDefineColumns and not ColumnsDefined then
  try
    InDefineColumns := true;
    DataSource.DataSet.DisableControls;
    (* Userdefined Columns einlesen nach Col.List *)
    ReadColumns;                                         {INI -> ColumnList}
    if {(csDesigning in ComponentState) and  weg 07.09.04}
       (NavLink <> nil) and not NavLink.CalcOK then
    begin                                                {OK mit Delphi2 180400}
      NavLink.CalcOK := true;
      NavLink.AddCalcFields;
    end;
    (* Feldspalten: Visible, Reihenfolge *)
    with DataSource.DataSet do with ColumnList do        {Display:Len=Fieldname}
    begin
      RightestEqual := true;  //'(9=test):0=FLD1
      if Count > 0 then
      begin
        for I := 0 to FieldCount - 1 do
        begin
          Fields[I].Visible := false; {in der Tabelle nicht anzeigen}
        end;
        I := -1;
      end else
      begin                                            {wenn leer dann aufbauen}
        for I := 0 to FieldCount - 1 do
          Add(Format('%s=%s', [Fields[I].FieldName, Fields[I].FieldName]));
        I := -1;
      end;
      try
        N := 0;
        for I := 0 to Count - 1 do
        begin
          ADisplay := Param(I);                 {Display[:Len]=FieldName}
          if Char1(ADisplay) = ':' then
            Continue;                           {:Steuerzeile für Height usw.}
          AFieldName := Value(I);
          try
            AField := FieldByName(AFieldName); {lokale Variable aufbauen}
            IsVisible := true;
            P := Pos(':',ADisplay);             {Name:20,S    S=ohne Aswtext}
            if P > 0 then                       {             M=Summierung}
            begin                               {X=max.Breite O=OptiBreite }
              AField.DisplayLabel := copy(ADisplay, 1, P - 1);
              ADisplayOptions := PStrTok(copy(ADisplay, P+1, Maxint), ',', NextS);  //Length(ADisplay) - P 21.12.11
              DisplayList.Values[AFieldName] := PStrTok('', '', NextS);  {Rest nach ,}
              try
                DispWidth := StrToInt(ADisplayOptions);
                if DispWidth = 0 then
                  IsVisible := false else
                  AField.DisplayWidth := DispWidth;
              except on E:Exception do
                EMess(self, E, SMugriKmp_002 +		// 'Fehler bei Format (%s). '
                  SMugriKmp_003, [ADisplay]);		// 'Flags mit "," trennen.'
              end;
              //if DisplayList.Values[AFieldName] <> '' then
              //  ProtP('',[0]);
            end else
              AField.DisplayLabel := ADisplay;
            AField.Visible := IsVisible;
            if IsVisible then
            begin
              AField.Index := N;                  {in Tabelle   280401}
              {ProtA('%s: %d (N=%d)', [AField.FieldName, AField.Index, N]);}
              Inc(N);
            end;
            (* schlecht da wir noch nicht alle Felder haben: GPF
                ColumnMoved(iField+1, I+1);                {from, to ab 1}
            *)
          except on E:Exception do
            begin
              EProt(self, E, SMugriKmp_004, [ADisplay, Strings[I]]);	// 'Spalte(%s) fehlt (%s)'
              (*if DataSource.DataSet is TuQuery then (warum geht das nicht bei TWRep ?)
                ProtStrings(TuQuery(DataSource.DataSet).SQL);*)
              (*for I1 := 0 to DataSource.DataSet.FieldCount - 1 do
                Prot0('%d:%s', [I1, DataSource.DataSet.Fields[I1].FieldName]);*)
            end;
          end;
        end;
        I := -1;
        ColumnsDefined := true;
        SaveColumns;
      except on E:Exception do
        EMess(self, E, SMugriKmp_005,[I, Strings[I]]);	// 'Fehler bei ColumnList:%d(%s)'
      end;
    end;
    DataSource.DataSet.EnableControls;
    { test if not (csDesigning in ComponentState) then
      if Assigned(FOnLayoutChanged) then
        FOnLayoutChanged(self); }
  finally
    if (self <> nil) and not (csDestroying in self.ComponentState) then
    begin
      InDefineColumns := false;
      OptiWidthHandled := true;  //Flag für Optimize Width
      OptiWidthList.Clear;
    end;
  end;
  //23.05.02 ReSize;
end;

function TMultiGrid.GetDBEdit(AFieldname: string): TDBEdit;
//ergibt DBEdit anhand Fieldname. 
var
  I1: integer;
  aDBEdit: TDBEdit;
begin
  result := nil;
  for I1 := 0 to Form.ComponentCount-1 do
    if Form.Components[I1] is TDBEdit then
    begin
      aDBEdit := Form.Components[I1] as TDBEdit;
      if (aDBEdit.DataSource = self.DataSource) and  //15.02.10 gleicher Datasource
         SameText(aDBEdit.DataField, AFieldName) then
      begin
        result := aDBEdit;
        exit;
      end;
    end;
end;

procedure TMultiGrid.SaveColumns;
var
  I: integer;
  AField: TField;
  ADBEdit: TDBEdit;
  ALine, ADisplayOptions: string;
begin                                          {Fields,RowHeigt -> SavedColumns}
  if csDesigning in ComponentState then
    Exit;
  if MuNoSaveLayout in MuOptions then
    Exit;
  with DataSource.DataSet do with SavedColumns do           {Display:Len=Fieldname}
  begin
    Clear;
    for I := 0 to FieldCount-1 do
    begin
      AField := Fields[I];
      ADBEdit := nil;
      if AField.Visible then
      begin
        ADBEdit := GetDbEdit(AField.FieldName);
        ADisplayOptions := IntToStr(AField.DisplayWidth);
      end else
        ADisplayOptions := '0';
      if DisplayList.Values[AField.FieldName] <> '' then
        AppendTok(ADisplayOptions, DisplayList.Values[AField.FieldName], ',');
      ALine := Format('%s:%s=%s', [AField.DisplayLabel, ADisplayOptions,
        AField.FieldName]);
      // if ADBEdit <> nil then   weg 09.09.08 Standard nie schreiben
        AddObject(ALine, ADBEdit);
    end;
    {Add(SRowHeight + '=' + IntToStr(DefaultRowHeight)); 080800 weg}
    if FRowHeight > 0 then
      Add(SRowHeight + '=' + IntToStr(FRowHeight)) else
      Add(SRowHeight + '=' + IntToStr(DefaultRowHeight));
  end;
end;

procedure TMultiGrid.AL(S: string; L1, L2: TStrings);
var
  I: integer;
begin
  if (L1.Text <> L2.Text) and (Name = Sysparam.OurLookUpEdit) then
  begin
    Prot0('AL(%s): %s', [OwnerDotName(self), S]);
    for I := 0 to L1.Count + L2.Count do
      if (I < L1.Count) and (I < L2.Count) then
      begin
        if L1[I] <> L2[I] then
          ProtA('(%s)<-(%s)', [L1[I], L2[I]]);
      end else
        break;
//      if I < L1.Count then
//        ProtA('(%s)<-()', [L1[I]]) else
//      if I < L2.Count then
//        ProtA('()<-(%s)', [L2[I]]) else
//        break;
  end;
  L1.Assign(L2);
end;

procedure TMultiGrid.ReadIniSection(AList: TStrings);
begin  //nur von einer Section lesen (U oder V)
  IniKmp.ReadSectionValuesUniqueTyp(IniSection, AList);
end;

procedure TMultiGrid.ReadColumns;
var
  AList: TValueList;
  DoCopy: boolean;
begin                                      {IniSection -> ColumnList, RowHeight}
  if csDesigning in ComponentState then
    Exit;
  if MuNoSaveLayout in MuOptions then
    Exit;
  AList := TValueList.Create;
  FRowHeight := LoadedRowHeight;
  try
    {ASection := Format('%s.%s.%s', [SSpalten, Form.ClassName, Name]);}
    ReadIniSection(AList);    //IniKmp.ReadSectionValuesUniqueTyp(IniSection, AList);
    if AList.Values[SRowHeight] <> '' then
    begin
      try
        {DefaultRowHeight := StrToInt(AList.Values[SRowHeight]); {080800 weg}
        //ergibt 1mm Rows 06.06.11 - FRowHeight := StrToInt(AList.Values[SRowHeight]);
        FRowHeight := IMax(MinRowHeight, StrToInt(AList.Values[SRowHeight]));
        //PostMessage(self.Handle, BC_EXTGRIDSCR, egSetRowSize, FRowHeight);
      except end;
      AList.Values[SRowHeight] := '';            {löschen}
    end;
    {DoCopy := AList.Count = ColumnList.Count; 050101}
    DoCopy := AList.Count > 0; {INI Section existiert 050101}
    if DoCopy then
    begin
      // Layouteditor kann alles Ändern - 050101
    end;
    if TempLayout then
    begin
      if FColumnList.Values[SRowHeight] <> '' then
      try
        FRowHeight := StrToInt(FColumnList.Values[SRowHeight]);
      except end;
    end;
    if not TempLayout then
    begin
      if DoCopy then
        AL('ReadColumns:FColumnList<-INI', FColumnList, AList) else
      if LoadedColumnList.Count > 0 then      {ist 0 bei LuGrid 050101}
        AL('ReadColumns:FColumnList<-LoadedColumnList', FColumnList, LoadedColumnList);
    end;
    if FRowHeight <> DefaultRowHeight then
    try
      PostMessage(self.Handle, BC_EXTGRIDSCR, egSetRowSize, FRowHeight);
    except on E:Exception do
      Debug0;  //self.Handle nich verfügbar
    end;
    ColumnsRead := true;
    //Slide partiell aus-/einschalten:
    if GetqForm <> nil then
    begin
      if IniKmp.ReadBool(TqForm(GetqForm).Kurz,  Name + '.' + sNoSlideBar, false) then
        MuOptions := MuOptions - [muSlideBar] + [muNoSlideBar];
      if IniKmp.ReadBool(TqForm(GetqForm).Kurz, Name + '.' + sSlideBar, false) then
        MuOptions := MuOptions - [muNoSlideBar] + [muSlideBar];
    end;
  finally
    AList.Free;
  end;
end;

procedure TMultiGrid.SaveLayout;
var
  OldMuOptions: TMuOptions;
begin               (* für manuellen Aufruf *)
  OldMuOptions := MuOptions;
  try
    MuOptions := MuOptions + [MuNoAskLayout] - [MuNoSaveLayout];
    WriteColumns;
  finally
    MuOptions := OldMuOptions;
  end;
end;

procedure TMultiGrid.WriteColumns;
var
  I: integer;
  AField: TField;
  OldSavedColumns: TValueList;
  ALine, ADisplayOptions: string;
  ColChanged, DoStore, DoNotErase: boolean;
  ADBEdit: TDBEdit;
  function StoreDlg: boolean;
  var
    Btn: word;
  begin
    result := true;
    if not ColChanged then
    begin
      ColChanged := true;
      if not (MuNoAskLayout in MuOptions) then
      begin
        Btn := WMessYesNo(SMugriKmp_006+CRLF+	// 'Layout wurde geändert. Speichern ?'
                          SMugriKmp_007+CRLF+	// '(Abbruch = Standard wiederherstellen)'
                          '[%s]',[IniSection]);
        if Btn = mrYes then DoStore := true else
        if Btn = mrNo then DoNotErase := true else
        result := false;
      end else
        DoStore := true;
    end;
  end;
begin                                                      {SavedColumns -> INI}
  if csDesigning in ComponentState then
    Exit;
  if MuNoSaveLayout in MuOptions then
    Exit;
  if not ColumnsRead then
    Exit;
  if (NavLink <> nil) and (NavLink.nlState in [nlInactive]) then  //nlQuery,
  begin
    Debug('%s.WriteColumns abgebrochen da Inaktiv', [OwnerDotName(self)]);
    Exit;
    //QBETable ist kein genaues Abbild bzgl. AField.DisplayLabel u.a.
    //  wir verwenden es trotzdem - 05.08.08 wunn
  end;
  OldSavedColumns := TValueList.Create;
  // klappt auch bei nlQuery:
  with DataSet do {with SavedColumns do}           {Display:Len=Fieldname}
  try
    OldSavedColumns.Assign(SavedColumns);
    SavedColumns.Clear;
    ColChanged := false;
    DoStore := false;
    DoNotErase := false;
    ALine := '';
    for I := 0 to FieldCount-1 do
    begin
      AField := Fields[I];
      if AField.Visible then {050101 Invisible Field mit Länge=0 mit aufnehmen}
        ADisplayOptions := IntToStr(AField.DisplayWidth) else {Win32: Indikator daß Spalten überhaupt geändert wurden}
        ADisplayOptions := '0';
      if DisplayList.Values[AField.FieldName] <> '' then
        AppendTok(ADisplayOptions, DisplayList.Values[AField.FieldName], ',');
      ALine := Format('%s:%s=%s', [AField.DisplayLabel, ADisplayOptions,
        AField.FieldName]);
      if AField.Visible and
         ((SavedColumns.Count >= OldSavedColumns.Count) or
          (ALine <> OldSavedColumns.Strings[SavedColumns.Count])) then
        if not StoreDlg then
          break;
      {für NT!:}
      if ColChanged and AField.Visible and
         (DataSet <> nil) and DataSet.Active and (TextWidth_Of_0 > 0) then
      try                   {Tatsächliche DisplayWidth in Win32 !}
        {AField.DisplayWidth := (ColWidths[SavedColumns.Count + ColOffs] - 4)
                               div TextWidth_Of_0}
        AField.DisplayWidth := (ColWidths[AField.Index + 1] - 4)     //#2474
                               div TextWidth_Of_0;        {OK 280401 und 03.02.03}
        {AField.DisplayWidth := (ColWidths[AField.Index + 1] - TM.tmOverhang - 3)
                               div TM.tmAveCharWidth;  {beware 03.02.03}
        {AField.DisplayWidth := (ColWidths[AField.Index + 1] +
          (TM.tmAveCharWidth div 2) - TM.tmOverhang - 3) div TM.tmAveCharWidth;  {beware 30.01.03}
        ADisplayOptions := IntToStr(AField.DisplayWidth);
        if DisplayList.Values[AField.FieldName] <> '' then
          AppendTok(ADisplayOptions, DisplayList.Values[AField.FieldName], ',');
        ALine := Format('%s:%s=%s', [AField.DisplayLabel, ADisplayOptions,
          AField.FieldName]);
      except on E:Exception do
        EProt(self, E, 'WriteColumns(%s)',[ALine]);
      end;
      {if (ALine <> OldSavedColumns.Strings[Count]) then Prot0('(%s)<>(%s)',[ALine, OldSavedColumns.Strings[Count]]);}
      ADBEdit := GetDbEdit(AField.FieldName);
      SavedColumns.AddObject(ALine, ADBEdit);
    end;
    //if OldSavedColumns.Values[SRowHeight] <> '' then
    if DefaultRowHeight <> LoadedRowHeight then
    try
      //if StrToInt(OldSavedColumns.Values[SRowHeight]) <> DefaultRowHeight then
      //if StrToInt(OldSavedColumns.Values[SRowHeight]) <> LoadedRowHeight then
      begin
        StoreDlg;
        ALine := Format('%s=%d', [SRowHeight, DefaultRowHeight]);
        SavedColumns.Add(ALine);     //nur wenn <>Default 15.10.03
      end;
    except on E:Exception do
      EProt(self, E, 'WriteColumns:RowHeight(%s)', [OldSavedColumns.Values[SRowHeight]]);
    end;
    if ColChanged and not DoNotErase then
    begin
      AL('WriteColumns:OldSavedColumns<-SavedColumns', OldSavedColumns, SavedColumns); //neu
      WriteIniSection(SavedColumns, DoStore);
      InDefineColumns := true; //X
      AL('WriteColumns:FColumnList<-SavedColumns', FColumnList, SavedColumns); //FColumnList.Assign(SavedColumns);
      InDefineColumns := false; //X
    end;
  except on E:Exception do
    EProt(self, E, 'WriteColumns', [0]);
  end;
  OldSavedColumns.Free;
end;

procedure TMultiGrid.StripColumnList(SrcList, DstList: TStrings);
// kopiert nur sichtbare Zeilen (Breite>0) von Src nach Dst
var
  I: integer;
  S, S1, NextS: string;
begin
  DstList.BeginUpdate;
  try
    DstList.Clear;  //27.01.10 ist das für FltrList mit Tabellenlayout OK?
    for I := 0 to SrcList.Count - 1 do
    begin
      S := StrParam(SrcList[I]);  //linke Seite
      S1 := PStrTok(S, ':', NextS);
      S1 := PStrTok('', ',', NextS); {Länge}
      if (StrToIntTol(S1) > 0) or (Char1(S) = ':') then
        DstList.Add(SrcList[I]);
    end;
  finally
    DstList.EndUpdate;
  end;
end;

procedure TMultiGrid.WriteIniSection(AList: TStrings; DoStore: boolean = true);
(* Beschreibt INI. Nur mit Visible Fields (L > 0) *)
var
  L: TValueList;
begin
  if TempLayout then
    Exit;
  if DoStore and (AList.Count > 0) then
  begin
    L := TValueList.Create;
    try
      StripColumnList(AList, L);
      {Prot0('WriteIniSection %s.%s %s', [Owner.ClassName, Name, IniSection]);
      ProtStrings(L);}
      IniKmp.ReplaceSection(IniSection, L);
    finally
      L.Free;
    end;
  end else
    IniKmp.EraseSection(IniSection);
end;

(*** Slidebar *****************************************************************)

procedure TMultiGrid.WriteIniSlideBar(SlideBar: boolean);
begin
  if SlideBar = Sysparam.SlideBar then
  begin
    IniKmp.DeleteKey(TqForm(GetqForm).Kurz,  Name + '.' + sNoSlideBar);
    IniKmp.DeleteKey(TqForm(GetqForm).Kurz,  Name + '.' + sSlideBar);
  end else
  if SlideBar then
  begin
    IniKmp.DeleteKey(TqForm(GetqForm).Kurz,  Name + '.' + sNoSlideBar);
    IniKmp.WriteBool(TqForm(GetqForm).Kurz,  Name + '.' + sSlideBar, true);
  end else
  begin
    IniKmp.DeleteKey(TqForm(GetqForm).Kurz,  Name + '.' + sSlideBar);
    IniKmp.WriteBool(TqForm(GetqForm).Kurz,  Name + '.' + sNoSlideBar, true);
  end;
  if SlideBar then
    MuOptions := MuOptions - [muNoSlideBar] + [muSlideBar] else
    MuOptions := MuOptions - [muSlideBar] + [muNoSlideBar];
end;

function TMultiGrid.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
  end;
end;

procedure TMultiGrid.LayoutChanged;
var
  OldRowHeight: integer;
begin
  OldRowHeight := DefaultRowHeight;
  inherited LayoutChanged;
  if (DefaultRowHeight <> OldRowHeight) and (FRowHeight > 0) then
    DefaultRowHeight := OldRowHeight;
  //29.07.10 weg SDBL - if muSlideBar in MuOptions then
  begin
    FTitleOffset := 0;
    if dgTitles in Options then FTitleOffset := 1;
    FIndicatorOffset := 0;
    if dgIndicator in Options then FIndicatorOffset := 1;
  end;
end;

procedure TMultiGrid.BcExtGridScr(var Msg: TMessage); {message BC_EXTGRIDSCR;}
var
  Distance: Integer;
  MaxPosition: integer;
  OldRowHeight: integer;
  DoIt: boolean;
begin
  if Msg.WParam = egSetRowSize then
  begin
    if Msg.LParam > 0 then
      DefaultRowHeight := Msg.LParam;
  end else
  if Msg.WParam = egSetOptions then
  begin
     {if not (muNoRowSize in MuOptions) then
       NextOptions := NextOptions + [goRowSizing];   28.01.03}
     DoIt := Options <> NextOptions; //19.08.02 wieder da LAWA.MEST: Positioniert sonst auf 0 nach Insert/Post
     if not (muNoRowSize in MuOptions) and
        not (goRowSizing in TCustomGridHack(self).Options) then
       DoIt := true;
     if DoIt then       // 28.01.03 DoIt eingeführt wg. goRowSizing falls AutoEdit=false
     begin
       OldRowHeight := DefaultRowHeight;
       Options := NextOptions;                       {setzt DefaultRowHeight zurück}
       if not (muNoRowSize in MuOptions) then
         TCustomGridHack(self).Options := TCustomGridHack(Self).Options + [goRowSizing];
       if (DefaultRowHeight <> OldRowHeight) and (FRowHeight > 0) then
         DefaultRowHeight := OldRowHeight;
     end;
  end else
  (*if Msg.WParam = egReLoad then
  begin
     if (DataSource <> nil) and (DataSource.DataSet <> nil) then
     begin
       DataSource.DataSet.Close;
       DataSource.DataSet.Open;
     end;
  end else*)
  if (muSlideBar in MuOptions) and
     (DataSet <> nil) then
     // and not DataSet.ControlsDisabled then * entfernt wg Lookup|GotoPosEx|Disable
  begin
    if Msg.WParam = egScrolled then
    begin
      Distance := Msg.LParam;
      //Vorauss.: (muSlideBar in MuOptions)
      FPosition := FPosition + Distance;
      if (FPosition < 1) or DataSource.DataSet.BOF then
        FPosition := 1;
      MaxPosition := RecCount - DataLink.RecordCount + 1;
      if (FPosition > MaxPosition) or DataSource.DataSet.EOF then
        FPosition := MaxPosition;
      UpdateScrollBar; //notwendig! TMB.DIBEST go down 29.09.06
      CheckMusiButtons;  //10.06.13
    end else
    if Msg.WParam = egSetRecCount then
    begin
      if (Dataset <> nil) and (Dataset.Active) then  //ab 01.08.14
        RecCount := NavLink.RecordCount;  {Msg.LParam};
      CheckMusiButtons;  //25.08.10
    end else
    if Msg.WParam = egUpdateScrollbar then
    begin
      UpdateScrollBar;
    end else
      DataChangedCount := 0;
    if Msg.WParam = egDataChanged then
    begin
      if Msg.LParam = 1 then
      begin
        if DataSet.Active then
        try                            {notwendig da Postmessage}
          DataSet.Prior;
          SendMessage(self.Handle, BC_EXTGRIDSCR, egDataChanged, 2);
        except end;
      end else
      if Msg.LParam = 2 then
      begin
        if DataSet.Active then
        try
          DataSet.Next;
          SendMessage(self.Handle, BC_EXTGRIDSCR, egDataChanged, 3);
        except end;
      end else
      if Msg.LParam = 3 then
      begin
        if DataSet.Active then
        try
          DataSet.Next;
          DataChangedFlag := false;
        except end;
      end else
      begin
        if not HandleAllocated then Exit;
        UpdateActive;   //23.07.06 nach vorne
        UpdateScrollBar;
        if not (dgAlwaysShowEditor in Options) then
          InvalidateEditor;
        ValidateRect(Handle, nil);
        Invalidate;
        DataChangedFlag := false;
      end;
    end;
  end;
end;

procedure TMultiGrid.SlideBarScroll(Distance: Integer);
var
  OldRect, NewRect: TRect;
  RowHeight: Integer;
begin
  SendMessage(Handle, BC_EXTGRIDSCR, egScrolled, LPARAM(Distance));
  OldRect := BoxRect(0, Row, ColCount - 1, Row);
  UpdateScrollBar;
  UpdateActive;
  NewRect := BoxRect(0, Row, ColCount - 1, Row);
  ValidateRect(Handle, @OldRect);
  InvalidateRect(Handle, @OldRect, False);
  InvalidateRect(Handle, @NewRect, False);
  if Distance <> 0 then
  begin
    HideEditor;
    try
      if Abs(Distance) > VisibleRowCount then
      begin
        Invalidate;
        Exit;
      end
      else
      begin
        RowHeight := DefaultRowHeight;
        if dgRowLines in Options then Inc(RowHeight, GridLineWidth);
        NewRect := BoxRect(FIndicatorOffset, FTitleOffset, ColCount - 1, 1000);
        ScrollWindowEx(Handle, 0, -RowHeight * Distance, @NewRect, @NewRect,
          0, nil, SW_Invalidate);
        if dgIndicator in Options then
        begin
          OldRect := BoxRect(0, FSelRow, ColCount - 1, FSelRow);
          InvalidateRect(Handle, @OldRect, False);
          NewRect := BoxRect(0, Row, ColCount - 1, Row);
          InvalidateRect(Handle, @NewRect, False);
        end;
      end;
    finally
      if dgAlwaysShowEditor in Options then ShowEditor;
    end;
  end;
  if UpdateLock = 0 then
    Update;
end;

procedure TMultiGrid.SetRecCount(Value: LongInt);
const
  MaxRecordCount = 32767;
var
  MaxPosition: integer;
begin
  if not (muSlideBar in MuOptions) then
    Exit;
  if Value <> FRecCount then begin
    FRecCount := Value;
    if FPosition < 1 then FPosition := 1;
    if DataLink = nil then Exit;
    if DataSource = nil then Exit;
    if DataSource.DataSet = nil then Exit;
    if (FPosition < 1) or DataSource.DataSet.BOF then
      FPosition := 1;
    MaxPosition := RecCount - DataLink.RecordCount + 1;
    if (FPosition > MaxPosition) or DataSource.DataSet.EOF then
      FPosition := MaxPosition;
    UpdateScrollBar;
  end;
end;

procedure TMultiGrid.UpdateActive;
var
  NewRow: Integer;
  Field: TField;
begin
  if Datalink.Active and HandleAllocated and not (csLoading in ComponentState) then
  begin
    NewRow := Datalink.ActiveRecord + FTitleOffset;
    if Row <> NewRow then
    begin
      if not (dgAlwaysShowEditor in Options) then HideEditor;
      if (NewRow >= 0) and (NewRow < RowCount) then
        MoveColRow(Col, NewRow, False, False);
      if not (dgAlwaysShowEditor in Options) then
        InvalidateEditor;
    end;
    Field := SelectedField;
    if Assigned(Field) {and (Field.Text <> FEditText)} then
      if not (dgAlwaysShowEditor in Options) then
        InvalidateEditor;
  end;
end;

//procedure TMultiGrid.UpdateScrollBarX;
//var
//  ScrollInfo: TScrollInfo;
//  Pos: Integer;
//begin
//  if DataLink = nil then Exit;
//  if DataLink.DataSource = nil then Exit;
//  if DataLink.DataSource.DataSet = nil then Exit;
//  if not DataLink.DataSource.DataSet.Active then Exit;
//  if not (muSlideBar in MuOptions) then
//  begin
//    //25.04.13 immer sichtber
//    ShowScrollBar(Self.Handle, SB_VERT, true);
//
//    ScrollInfo.cbSize := SizeOf(TScrollInfo);
//    ScrollInfo.fMask := SIF_PAGE;
//    GetScrollInfo(self.Handle, SB_VERT, ScrollInfo);
//    if ScrollInfo.nPage <> 0 then
//    begin
//      ScrollInfo.fMask := SIF_PAGE and not SIF_DISABLENOSCROLL;  //14.08.06
//      ScrollInfo.nPage := 0;
//      SetScrollInfo(Handle, SB_VERT, ScrollInfo, True);
//    end;
//    SetScrollRange(Self.Handle, SB_VERT, 0, 4, True);
//    if DataSource.Dataset.BOF then Pos := 0
//    else if DataSource.Dataset.EOF then Pos := 4
//    else Pos := 2;
//    if GetScrollPos(Self.Handle, SB_VERT) <> Pos then
//      SetScrollPos(Self.Handle, SB_VERT, Pos, True);
//  end else
//  begin                              {muSlideBar in MuOptions}
//    ScrollInfo.cbSize := SizeOf(TScrollInfo);
//    ScrollInfo.fMask := SIF_ALL;
//    GetScrollInfo(self.Handle, SB_VERT, ScrollInfo);
//
//    ScrollInfo.nMin := 1;
//    if FRecCount <= VisibleRowCount then
//      ScrollInfo.nMax := FRecCount else
//      ScrollInfo.nMax := FRecCount + DataLink.RecordCount - 1;
//    {ScrollInfo.nPos := FPosition; (IMax(1, FPosition - DataLink.ActiveRecord);}
//    ScrollInfo.nPos := FPosition + DataLink.ActiveRecord;
//    if ScrollInfo.nPos < ScrollInfo.nMin then ScrollInfo.nPos := ScrollInfo.nMin;
//    if ScrollInfo.nPos > ScrollInfo.nMax then ScrollInfo.nPos := ScrollInfo.nMax;
//    if DataSource.Dataset.BOF then ScrollInfo.nPos := ScrollInfo.nMin;
//    if DataSource.Dataset.EOF then
//    begin
//      ScrollInfo.nPos := ScrollInfo.nMax;
//      {Workaround eines Systembugs. Bei .Last positioniert Scrollbar falsch:}
//      if not DataChangedFlag and InWmSize and (FRecCount > VisibleRowCount) and
//         (Navlink.nlState = nlBrowse) then
//      begin                                   {nicht bei dsQuery / Scrollbar unnötig}
//        DataChangedFlag := true;
//        PostMessage(self.Handle, BC_EXTGRIDSCR, egDataChanged, 0); {1 Delphis DbGrid überlisten}
//      end;
//    end;
//    ScrollInfo.nPage := DataLink.RecordCount;
//    ScrollInfo.cbSize := SizeOf(TScrollInfo);
//    ScrollInfo.fMask := SIF_ALL and not SIF_DISABLENOSCROLL;  //14.08.06
//    SetScrollInfo(self.Handle, SB_VERT, ScrollInfo, True);
//    Pos := ScrollInfo.nPos;
//
//    ScrollInfo.cbSize := SizeOf(TScrollInfo);
//    ScrollInfo.fMask := SIF_ALL and not SIF_DISABLENOSCROLL;  //14.08.06
//    GetScrollInfo(self.Handle, SB_VERT, ScrollInfo);
//    if (ScrollInfo.nPage <> UINT(DataLink.RecordCount)) or
//       (ScrollInfo.nPos <> Pos) then
//      SMess0;
//  end;
//end;

procedure TMultiGrid.WMVScroll(var Message: TWMVScroll);
var
  ScrollInfo: TScrollInfo;
  NDiff: integer;
begin
  if not (muSlideBar in MuOptions) then
  begin
    inherited;
    if Message.ScrollCode = SB_THUMBTRACK then
      SMess(SMugriKmp_019, [DataLink.DataSet.RecordCount]);	// '%d Zeilen geladen'
    Exit;
  end;
  if not AcquireFocus then Exit;
  if Datalink.Active then
    with Message, DataLink.DataSet, Datalink do
      case ScrollCode of
        SB_LINEUP: MoveBy(-1); {-ActiveRecord - 1);}
        SB_LINEDOWN: MoveBy(1);  {RecordCount - ActiveRecord);}
        SB_PAGEUP: MoveBy(-VisibleRowCount);
        SB_PAGEDOWN: MoveBy(VisibleRowCount);
        SB_THUMBTRACK:
          begin
            ScrollInfo.cbSize := SizeOf(TScrollInfo);
            ScrollInfo.fMask := SIF_ALL;
            GetScrollInfo(self.Handle, SB_VERT, ScrollInfo);
            nDiff := ScrollInfo.nTrackPos - ScrollInfo.nPos;
            if SysParam.ProtBeforeOpen then
              ProtP('nTrackPos(%d) nPos(%d) nDiff(%d)', [ScrollInfo.nTrackPos, ScrollInfo.nPos, nDiff]);
            if (nDiff > 0) and EOF then
              ScrollInfo.nTrackPos := FRecCount;
            //SMess(SMugriKmp_008, [ScrollInfo.nTrackPos, FRecCount]);	// weg 14.08.06
            ThumbtrackFlag := true;
            if (nDiff < 0) and (ScrollInfo.nTrackPos = 1) then   //PostMessage(Handle, WM_VSCROLL, WPARAM(SB_TOP), 0);
              nDiff := -FRecCount;
            if (nDiff > 0) and (ScrollInfo.nTrackPos + nDiff >= FRecCount) then
              nDiff := FRecCount;
            MoveBy(nDiff);
            ScrollInfo.cbSize := SizeOf(TScrollInfo);
            ScrollInfo.fMask := SIF_POS and not SIF_DISABLENOSCROLL;  //14.08.06
            ScrollInfo.nPos := ScrollInfo.nTrackPos;
            SetScrollInfo(self.Handle, SB_VERT, ScrollInfo, True);
            //SMess(SMugriKmp_008, [ScrollInfo.nTrackPos, FRecCount]);	// 'Datensatz %d von %d'
            SMess(SMugriKmp_008, [ScrollInfo.nTrackPos, DataLink.DataSet.RecordCount]);	// 'Datensatz %d von %d'
          end;
        SB_BOTTOM: Last;
        SB_TOP: First;
      end;
end;

procedure TMultiGrid.MouseMove(Shift: TShiftState; X, Y: Integer); {override;}
begin
  inherited MouseMove(Shift, X, Y);
  if muSlideBar in MuOptions then
  begin
    if ThumbtrackFlag then        {Es wird gerade Datensatz %d von %d gezeigt}
      SMess0;
    ThumbtrackFlag := false;
  end;
end;

procedure TMultiGrid.WMSize(var Message: TWMSize);
begin
  inherited;
  try
    InWmSize := true;
    //25.04.13 if muSlideBar in MuOptions then
      UpdateScrollBar;
    Invalidate;
  finally
    InWmSize := false;
  end;
end;

(*** MuDrag&Drop ***************************************************************)

procedure TMultiGrid.MuDragPoll;
begin                                    {als Idle in GNav}
  if DragScroll = 1 then
    SendMessage(self.Handle, WM_VSCROLL, SB_LINEDOWN, 0);
  if DragScroll = -1 then
    SendMessage(self.Handle, WM_VSCROLL, SB_LINEUP, 0);
end;

procedure TMultiGrid.MuEndDrag(Target: TObject; X, Y: Integer);
begin
  DragScroll := 0;
end;

procedure TMultiGrid.MuBeginDrag(X, Y: Integer; var Allow: Boolean);
var
  S, S1, NextS: string;
begin
  Allow := false;
  try
    S1 := PStrTok(NavLink.KeyFields, ';', NextS);
    S := '';
    while S1 <> '' do
    begin
      S := S1;
      S1 := PStrTok('', ';', NextS);   {letztes Keysegment erkennen}
    end;
    if (DragFieldName <> '') and (S = DragFieldName) then
    begin
      DragPosVon := DataSet.FieldByName(DragFieldName).AsInteger;
      Allow := true;
    end else
    begin
      DragPosVon := StrToInt(Drag0Value);  //DragOver verhindern
      if DragFieldName <> '' then
        ProtL('%s.%s:Drag&Drop nicht möglich:Sortierung(%s) enthält nicht %s',
          [Owner.ClassName, Name, NavLink.KeyFields, DragFieldName]);
    end;
    DragPos0 := StrToInt(Drag0Value);
  except on E:Exception do
    EProt(DataSet, E, 'MuBeginDrag', [0]);
  end;
end;

procedure TMultiGrid.MuDragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
const
  SDragState: array[TDragState] of string  = ('DragEnter', 'DragLeave', 'DragMove');
var
  DragPosNach: integer;
begin
  Accept := (Source = self) and (DragPosVon <> DragPos0);
  if Accept then
  begin
    DragPosNach := DataSet.FieldByName(DragFieldName).AsInteger;
    if DragPosNach > DragPosVon then
      SMess('Position %d hinter Position %d verschieben', [DragPosVon, DragPosNach]) else
    if DragPosNach < DragPosVon then
      SMess('Position %d vor Position %d verschieben', [DragPosVon, DragPosNach]) else
      SMess0;
  end else
  begin
    if Source <> self then
      SMess('Source <> self', [0]) else
    if DragPosVon = DragPos0 then
       SMess('Position %d gleich', [DragPos0]);
  end;
end;

procedure TMultiGrid.MuDragDrop(Source: TObject; X, Y: Integer);
// Fallenlassen

  procedure Drag1(von, nach: integer);
  var
    Que: TuQuery;
    ErrorFieldName, Op: string;
    AList: TFltrList;
    I: integer;
  begin
    Que := TuQuery.Create(QueryDatabase(TuQuery(DataSet))); //self);
    AList := TFltrList.Create;
    try
      Que.MasterSource := self.DataSource;  //UNI 14.06.11
      Que.RequestLive := true;
      AList.Assign(NavLink.References);
      if not (DataSource is TLookUpDef) or NavLink.UseFltrList then
        AList.AddStrings(NavLink.FltrList);
      for I := 0 to AList.Count - 1 do
        if char1(AList.Value(I)) = ':' then
          AList.Strings[I] := AList.Param(I) + '=:' + AList.Param(I);
      //AList.BuildSQL(Que, NavLink.TableName, '', nil, ErrorFieldName);
      AList.BuildSQL(Que, DropTableName, '', nil, ErrorFieldName);
      if AList.Count >= 1 then     //if Que.Sql.Count > 1 then  19.08.02
        Op := 'and' else
        Op := 'where';
      Que.Sql.Add(Format('%s (%s=%s)', [Op, DragFieldName, IntToStr(von)]));
      try
        Que.Open;
        if Que.EOF then
        begin
          {TDlgSql.Execute(self, Que, false);
          EError('Position %d nicht gefunden', [von]);  passiert wenn Nummerierung nicht fortlaufend}
          SMess('Drag1(%d->%d)...', [von, nach]);
        end else
        begin
          Que.Edit;
          Que.FieldByName(DragFieldName).AsInteger := nach;
          Que.Post;
          ProtL('%s Drag1(%d->%d) OK', [OwnerDotName(self), von, nach]);
        end;
      except on E:Exception do
        begin
          EProt(Que, E, '%s Drag1(%d->%d)', [OwnerDotName(self), von, nach]);
          EError(SMugriKmp_009, [von, nach]);	// 'Fehler beim Ablegen von %d nach %d'
        end;
      end;
    finally
      AList.Free;
      Que.Free;
    end;
  end; {Drag1}

  procedure MuDrag(PosVon, PosNach: Integer);
  var
    I: integer;
  begin
    if PosVon = PosNach then
      Exit;
    try
      DataSet.DisableControls;
      Screen.Cursor := crHourGlass;
      self.Closed := true;
      if PosVon < PosNach  then                 {nach unten: hinter PosNach}
      begin
        Drag1(PosVon, DragPos0);
        for I := PosVon + 1 to PosNach do
        begin
          Drag1(I, I - 1);
        end;
        Drag1(DragPos0, PosNach);
      end else
      if PosVon > PosNach  then                     {nach oben: vor PosNach}
      begin
        Drag1(PosVon, DragPos0);
        for I := PosVon - 1 downto PosNach do
        begin
          Drag1(I, I + 1);
        end;
        Drag1(DragPos0, PosNach);
      end;
    finally
      {NavLink.References.Values[DragFieldName] := '';}
      SMess0;
      if not DropNoRefresh then
      begin
        NavLink.Refresh;
        NavLink.DataPos.Clear;
        NavLink.DataPos.Values[DragFieldName] := IntToStr(PosNach);
        NavLink.DataPos.GotoPos(DataSet);
      end;
      DataSet.EnableControls;
      Screen.Cursor := crDefault;
    end;
  end; {MuDrag}
begin {MuDragDrop}
  if Source = self then
  try
    MuDrag(DragPosVon, DataSet.FieldByName(DragFieldName).AsInteger);
  except on E:Exception do
    EMess(self, E, 'MuDragDrop', [0]);
  end;
end;

(* Clipboard ***)

procedure TMultiGrid.CopyToHtml; {Copy to Clipboard Html Format}
var
  L, Html, Rtf, Txt, Csv: TStringList;
  AField: TField;
  iCol, iRow, I1, N: integer;
  T, C, S1, S2, ContextStart, ContextEnd: string;
begin
  L := TStringList.Create;
  Html := ClpHtml;
  Rtf := ClpRtf;
  Txt := ClpTxt;
  Csv := ClpCsv;
  Html.Clear;
  Rtf.Clear;
  Txt.Clear;
  Csv.Clear;
  (*
  {\rtf1 {1 \tab 2das ist länger als tab \tab 3 \par 4 \tab {\b\I 5} \tab 6}}
  *)
  try
    DataSet.DisableControls;
    Screen.Cursor := crHourGlass;
    GetStringsStrings(GNavigator.HtmlTable, 'ContextStart', L);
    ContextStart := L.Text;
    GetStringsStrings(GNavigator.HtmlTable, 'ContextEnd', L);
    ContextEnd := L.Text;

    GetStringsStrings(GNavigator.HtmlTable, 'HdrTable', L);
    Html.AddStrings(L);
    GetStringsStrings(GNavigator.HtmlTable, 'HdrCaptions', L);
    Html.AddStrings(L);

    Rtf.Add('{\rtf1 {'); {Rtf}
    N := 0;              {Rtf}
    T := '';             {Txt}
    C := '';             {Csv}
    GetStringsStrings(GNavigator.HtmlTable, 'Captions', L);
    for iCol := 0 to FieldCount-1 do
    begin
      AField := Fields[iCol];
      if AField.Visible then
      begin
        {ADisplayOptions := IntToStr(AField.DisplayWidth);}
        for I1 := 0 to L.Count - 1 do
        begin
          S1 := L.Strings[I1];
          S1 := Format(S1, [StrToHtml(AField.DisplayLabel)]);
          Html.Add(S1);                                           {HTM}
        end;
        if N > 0 then                                             {Rtf}
          Rtf.Add('\tab');                                        {Rtf}
        S1 := Format('{\b\I %s}', [AField.DisplayLabel]);         {Rtf}
        Rtf.Add(S1);                                              {Rtf}
        Inc(N);                                                   {Rtf}
        AppendTok(T, Format('%s', [AField.DisplayLabel]), TAB);   {Txt}
        AppendTok(C, Format('"%s"', [AField.DisplayLabel]), ';'); {Csv}
      end;
    end;
    GetStringsStrings(GNavigator.HtmlTable, 'FtrCaptions', L);
    Html.AddStrings(L);                                   {HTM}
    Txt.Add(T);                                           {Txt}
    Csv.Add(C);                                           {Csv}

    Rtf.Add('\par');                                      {Rtf}
    for iRow := 0 to SelectedRows.Count - 1 do
    begin
      GMessA(iRow, (SelectedRows.Count * 10) div 9);  //bis ca.90%
      DMess(SMugriKmp_018, [iRow, SelectedRows.Count]); //'%d von %d Datensätzen kopiert'
      GNavigator.ProcessMessages;  // soll einfrieren verhindern

      GetStringsStrings(GNavigator.HtmlTable, 'HdrLine', L);
      Html.AddStrings(L);                                 {HTM}

      GetStringsStrings(GNavigator.HtmlTable, 'Line', L);
      DataSet.Bookmark := SelectedRows[iRow];
      N := 0;                                             {Rtf}
      T := '';                                            {Txt}
      C := '';                                            {Csv}
      for iCol := 0 to FieldCount-1 do
      begin
        AField := Fields[iCol];
        if AField.Visible then
        begin
          {ADisplayOptions := IntToStr(AField.DisplayWidth);}
          for I1 := 0 to L.Count - 1 do
          begin
            S1 := L.Strings[I1];
            S1 := Format(S1, [StrToHtml(Prots.GetFieldText(AField))]);
            Html.Add(S1);                                 {HTM}
          end;
          if N > 0 then                                   {Rtf}
            Rtf.Add('\tab');                              {Rtf}
          S1 := Prots.GetFieldText(AField);               {Rtf}
          Rtf.Add(S1);                                    {Rtf}
          Inc(N);                                         {Rtf}
          S2 := StringReplace(S1, TAB, '|', [rfReplaceAll, rfIgnoreCase]);
          S2 := StringReplace(S1, CRLF, '/', [rfReplaceAll, rfIgnoreCase]);
          AppendTok(T, Format('%s', [S2]), TAB);          {Txt}
          AppendTok(C, Format('"%s"', [S1]), ';');        {Csv}
        end;
      end;
      Rtf.Add('\par');                                    {Rtf}
      Txt.Add(T);                                         {Txt}
      Csv.Add(C);                                         {Csv}
      GetStringsStrings(GNavigator.HtmlTable, 'FtrLine', L);
      Html.AddStrings(L);                                 {HTM}
    end;
    Screen.Cursor := crHourGlass;
    GetStringsStrings(GNavigator.HtmlTable, 'FtrTable', L);
    ClipBoard.Open;
    try
      Html.AddStrings(L);                                   {HTM}
      try
        CopyHtml(Html.Text, '', '');                          {HTM}
      except on E:Exception do
        EProt(Html, E, 'CopyHtml', [0]);
      end;
      Rtf.Add('}}');                                        {Rtf}
      try
        CopyRtf(Rtf.Text);                                    {Rtf}
      except on E:Exception do
        EProt(Rtf, E, 'CopyRtf', [0]);
      end;
      try
        CopyTxt(Txt.Text);                                    {Txt}
      except on E:Exception do
        EProt(Txt, E, 'CopyTxt', [0]);
      end;
      try
        CopyCsv(Csv.Text);                                    {Csv}
      except on E:Exception do
        EProt(Csv, E, 'CopyCsv', [0]);
      end;
    finally
      ClipBoard.Close;  //Klammer muss sein
    end;
  finally
    L.Free;
    {beware 10.11.09
    Html.Free;
    Rtf.Free;
    Txt.Free;
    Csv.Free; }
    Screen.Cursor := crDefault;
    DataSet.EnableControls;
    GMess0;
  end;
end;

{ ohne Klasse }

procedure MarkAll(ADBGrid: TDBGrid);
begin
  ADBGrid.DataSource.DataSet.EnableControls;  //falls bereits disabled
  ADBGrid.DataSource.DataSet.First;
  GMess0;
  //ohne Aktualisierung der Anzeige (ohne Nav.Rech mit LuCalc, Nav.Get) - 18.09.07
  ADBGrid.DataSource.DataSet.DisableControls;
  try
    while not ADBGrid.DataSource.DataSet.EOF and not GNavigator.Canceled do
    begin
      ADBGrid.SelectedRows.CurrentRowSelected := true;
      SendMessage(ADBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
      ADBGrid.DataSource.DataSet.Next;
    end;
  finally
    ADBGrid.DataSource.DataSet.EnableControls;
  end;
end;

procedure TMultiGrid.SetColumnAttributes;
begin
  inherited;
  //Test Tmb 24.07.06
//    if (dgIndicator in Options) then
//      ColWidths[0] := 22;
end;

function TMultiGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if DataLink.DataSet.State = dsBrowse then
    DataLink.DataSet.MoveBy(1);
  Result := True;
end;

function TMultiGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
begin
  if DataLink.DataSet.State = dsBrowse then
    DataLink.DataSet.MoveBy(-1);
  Result := True;
end;

function TMultiGrid.CreateEditor: TInplaceEdit;
var
  I: integer;
  S: string;
begin
  //Ellipse
  for I := 0 to Columns.Count - 1 do
  begin
    if Columns[I].Field <> nil then
    begin
      S := DisplayList.Values[Columns[I].Field.FieldName];
      if Pos('E', S) > 0 then
        Columns[I].ButtonStyle := cbsEllipsis;
    end;
  end;
  Result := inherited CreateEditor;
end;

function TMultiGrid.CellCoord(ACol, ARow: Integer): TRect;
begin
  result := CellRect(ACol, ARow);
end;

function TMultiGrid.GetToggleEditor: boolean;
begin
  result := muToggleEditor in MuOptions;
end;

procedure TMultiGrid.SetToggleEditor(const Value: boolean);
begin
  if Value then
    MuOptions := MuOptions + [muToggleEditor] else
    MuOptions := MuOptions - [muToggleEditor];
end;

procedure TMultiGrid.SetTempLayout(const Value: boolean);
begin
  if fTempLayout <> Value then
  begin
    fTempLayout := Value;

    if not Value then
      ColumnsDefined := false;  // neu laden
  end;
end;

{ Loop }

procedure TMultiGrid.LoopDoIt(Sender: TMultiGrid; Step: TAbortLoopStep; var Done: Boolean);
var
  DoIt: boolean;
  Btn: WORD;
begin
  if mloDisableControls in LoopOptions then
  begin
    if not DataSet.ControlsDisabled then
    begin
      DataSet.DisableControls;
      SMess('Controlsdisabled', [0]);
    end;
  end;
  case Step of
    AlsInit: if (Sender.SelectedRows.Count = 0) and (mloSelected in LoopOptions) then
             begin
               Done := true;
               if Assigned(LoopDoItEvent) then
                 LoopDoItEvent(self);
             end else
             if Sender.SelectedRows.Count > 0 then
             begin
               if not (mloConfirmation in LoopOptions) then
                 Btn := mrYes else
                 Btn := WMessYesNo('Alle %d markierten Datensätze durchlaufen? - %s', [
                   Sender.SelectedRows.Count, LoopTitle]);
               if Btn <> mrYes then
                 Done := true;
             end else
             begin
               DoIt := true;
               if (Sender.SelectedRows.Count = 0) and not (mloSelected in LoopOptions) then
               begin
                 DoIt := false;
                 if not (mloConfirmation in LoopOptions) then
                   Btn := mrYes else
                   Btn := WMessYesNo('Alle %d Datensätze durchlaufen? - %s', [
                     NavLink.RecordCount, LoopTitle]);
                 if Btn = mrCancel then
                   Done := true else
                 if Btn = mrNo then
                 begin
                   Done := true;
                   if Assigned(LoopDoItEvent) then
                     LoopDoItEvent(self);
                 end else
                   DoIt := true;
               end;
               if DoIt then
               begin
                 if mloShowAbort in LoopOptions then
                   TDlgAbort.CreateDlg(LoopTitle);
               end;
             end;
    AlsDoIt: if Assigned(LoopDoItEvent) then
               LoopDoItEvent(self);
    AlsDone: if Done and (mloNotify in LoopOptions) then
               WMess('%s OK', [LoopTitle]) else
             if not Done and ([mloNotify, mloErrorNotify] * LoopOptions <> []) then
               ErrWarn('%s Abbruch'+CRLF+'%s', [LoopTitle, OwnerDotName(self)]);
  end; { case }
end;

procedure TMultiGrid.Loop(Title: string; Options: TMuLoopOptions; DoIt: TNotifyEvent);
// Simples AbortLoop. Nur ein DoIt-Event. Options siehe oben.
// - mloSelected = nur markierte bzw. aktuelle Zeile bearbeiten sonst: wenn nichts markiert dann alle bearbeiten
// - mloShowAbort = Fortschritsfenster
// - mloConfirmation = Fragen ob alle / markierte durchlaufen werden sollen
// - mloDisableControls = DataSet.DisableControls
// - mloNotify = Meldung am Ende immer
// - mloErrorNotify = Meldung am Ende nur bei Abbruch
// | mloMulti = gehe auf Tabellensicht
// | = noch nicht realisiert
begin
  Prot0('%s.Loop(%s)', [OwnerDotName(self), Title]);
  LoopTitle := Title;
  LoopOptions := Options;
  LoopDoItEvent := DoIt;
  try
    if mloDisableControls in Options then
      DataSet.DisableControls;
    DMess('%s', [Title]);
    AbortLoop(LoopDoIt);
  finally
    if mloDisableControls in Options then
      DataSet.EnableControls;
    DMess0;
    SMess0;
  end;
end;

procedure TMultiGrid.AbortLoop(Event: TAbortLoopEvent);
// Realisierung eines Loops über aktuelle, alle, markierte Zeile(n).
// Vergl. AbortDlg#BtnTestClick
(* Beispiel für Event
procedure TFrmTEST.TestAbortLoop(Sender: TMultiGrid; Step: TAbortLoopStep; var Done: Boolean);
  procedure DoIt;
  begin
    Nav.AssignValue('TEST', 'failed');
    Nav.DoPost;
  end;
begin
  case Step of
    AlsInit: if Sender.SelectedRows.Count = 0 then
             begin
               Done := true;
               DoIt;
             end else
               TDlgAbort.CreateDlg(BtnTest.Caption);
    AlsDoIt: DoIt;
  end;
end;
*)
var
  Done: boolean;
  I: integer;
begin
  try
    InAbortLoop := true;
    Done := false;
    NavLink.DoCancel;  //setzt disabledControls=false
    if Navlink.nlState in nlEditStates then
    begin
      // 'Daten wurden geändert (%s).' +CRLF+ 'Speichern ?',
      case WMessYesNo(SNLnk_Kmp_009 +CRLF+ SNLnk_Kmp_010, [Navlink.Display]) of
        mrYes: NavLink.DoPost;
        mrNo:  DataSet.Cancel;
        mrCancel: SysUtils.Abort;
      end;
    end;
    GNavigator.Canceled := false;
    DataSet.Open;
    if Navlink.nlState <> nlBrowse then
      EError('%s', [NavLinkStateStr[Navlink.nlState]]);
    Event(self, alsInit, Done);  // calls TDlgAbort.CreateDlg(Caption);
                                 // calls DisableControls
                                 // calls Mu.SelectedRows.Clear to loop all rows
    if not Done then
    begin
      if SelectedRows.Count > 0 then
      begin                             //markierte Zeilen
        I := 0;
        while I < SelectedRows.Count do
        begin
          Inc(I);
          TDlgAbort.GMessA(I, SelectedRows.Count);
          if TDlgAbort.Canceled then
            SysUtils.Abort;  //Done bleibt false
          DataSet.Bookmark := SelectedRows[I - 1];
          Event(self, alsDoIt, Done);
          if Done then
            Break;
        end;
      end else
      begin                             //alle Zeilen
        I := 0;
        DataSet.First;
        GNavigator.Canceled := false;               {170198}
        while not DataSet.EOF do
        begin
          Inc(I);
          TDlgAbort.GMessA(I, NavLink.RecordCount);  //Prots.GMess wenn kein AbortDlg
          if TDlgAbort.Canceled then
            SysUtils.Abort;  //Done bleibt false
          Event(self, alsDoIt, Done);
          GNavigator.Canceled := false;               {170198}
          if Done then
            Break;
          DataSet.Next;
        end;
      end;
      Done := true;
    end;
  finally
    TDlgAbort.FreeDlg;
    try
      Event(self, alsDone, Done);  //Done: true=normales Ende false=Exception/Canceled
                                   //calls EnableControls
    finally
      InAbortLoop := false;
      GMess0;
    end;
  end;
end;

begin
  NameCounter := 0;
end.

