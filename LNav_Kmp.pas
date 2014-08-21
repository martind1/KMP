unit Lnav_kmp;
(* Lokaler Navigator: Komponente

   Autor: Martin Dambach
   Letzte Änderung
   08.06.11 md  UNI, Delphi2010
*)
(*
        Installationshinweise:
        - Bearbeiten/Erstellungsfolge: LNavigator ganz an den Anfang !

        Aufbau:
        1. Globale Variablen (GV) zum Aufnehmen der lokalen LN´s und ihrer
           zugeordneten Formulare
        2. Globaler Navigator (GN), der im Hauptformular plaziert wird.
           Er liefert die Speedbar.
        3. Lokale Navigatoren (LN) in jedem Formular, die DataSource des
           MasterSources und Lookup-Infos u.a. enthalten
        - LNCreate: Teilt GV sich und Form mit
        - GetLN(TForm): Liefert LN anhand Form
        - GNSetAktLN: Setzt LN für den globalen Gebrauch mit GN
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, DB, DBCtrls,  Uni, DBAccess, MemDS, Tabs, TabNotBk,
  Buttons, comctrls,
  QNav_Kmp, LuDefKmp, DPos_Kmp, BtnP_Kmp, NLnk_Kmp, MuGriKmp,
  Prots, UQue_Kmp, UTbl_Kmp;

type
  (* Kompatibilität: *)

  (* Local DataSource *)
  TLDataSource = class( TDataSource) end;

  (* Local Tabset *)
  TLTabSet = class( TTabset) end;

  (* qNotebook *)
  TqNoteBook = class(TNoteBook) end;

type
  TDetailInsertModus = (diPrepare, diReset, diRefresh, diClear, diSetFilter);       {für DetailInsert}

  TLNavOption = (
                 lnSavePosition,          {Formular Position in INI sichern}
                 lnNoLookupPos,           {keine Lookup-Positionierung}
                 lnAutoEditLu,            {AutoEdit Umschaltung bei Lookupdefs}
                 nlNoAutoMulti,           {kein Auto-Multi nach Insert/Edit}
                 lnDetailClose,           {Schließt unsichtbare Datasets bei DetailChange}
                 lnEnterAsTab             {Enter/Return geht aufs nächste Feld}
                );
  TLNavOptions = set of TLNavOption;

{ Forward declarations }
  TLNavigator = class;

  (* Ereignisse *)
  TPageChangeEvent = procedure(PageIndex: integer) of Object;
  TLNavPrnEvent = procedure(Sender: TObject; var fertig: boolean) of Object;
  TAfterReturnEvent =  procedure(Sender: TObject; LookUpModus: TLookUpModus;
                                  LookUpDef: TLookUpDef) of Object;
  TSetTitelEvent =  procedure(Sender: TObject; var Titel, Titel2: TCaption) of Object;
  TFormValueEvent =  procedure(Sender: TObject; ParamName: string; var Value: string) of Object;
  TSingleDataChangeEvent =  procedure(Sender: TLNavigator; Field: TField) of Object;

  (* Local Navigator *)
  TLNavigator = class(TComponent)
  private
    { Private-Deklarationen }
    FOptions: TLNavOptions;
    FAutoEditStart: boolean;
    FTitles: TStringList;
    FBackGround: TBitMap;
    FTabSet: TTabSet;
    FTabControl: TTabControl;
    FDetailBook: TTabbedNoteBook;
    FDetailControl: TPageControl;
    FDetailBookStart: string;
    FPageBook: TNoteBook;               {für BtnSingle/Multi, GNav}
    FPageControl: TPageControl;
    FPageBookStart: string;
    FBtnSingle: TBtnPage;
    FBtnMulti: TBtnPage;
    FFormKurz: string;
    FFirstControl: TWinControl;
    FStaticFields: boolean;        {true = Felder mit Feldeditor anlegen}
    FFormValues: TStrings;         //Formbezogene Werteliste
    FOnPrn: TLNavPrnEvent;
    FOnInit: TNotifyEvent;
    FOnStart: TNotifyEvent;
    FOnPostStart: TNotifyEvent;
    FOnStartReturn: TNotifyEvent;
    FAfterReturn: TAfterReturnEvent;
    FOnPageChange: TPageChangeEvent;
    FAfterPageChange: TPageChangeEvent;
    FOnSetTitel: TSetTitelEvent;
    FPollInterval: integer;
    FOnPoll: TNotifyEvent;
    PollAdded: boolean;
    InSetTitel: boolean;
    InOnStart: boolean;
    FReturnAktiv: boolean;                 {Flag ob in Lookup}
    FReturnLookUpModus: TLookUpModus;
    FActiveLookUpEdit: TCustomEdit;          {letztes LuEdit oder LuMemo Feld }
    FNavLink: TNavLink;                         { enthält FFltrList: TFltrList;
                                                  FKeyList: TValueList;
                                                  FKeyFields: string;   }
    OldDetailChange: TTabChangeEvent;
    OldDetailControlChange:  TNotifyEvent;
    OldPageChanged: TNotifyEvent;
    OldPageControlChanged: TNotifyEvent;
    OldTabSetClick: TNotifyEvent;
    OldStateChange: TNotifyEvent;
    FOnSetFormValue: TFormValueEvent;
    FOnGetFormValue: TFormValueEvent;
    FOnSingleDataChange: TSingleDataChangeEvent;
//    FOnDeleteError: TDataSetErrorEvent;
    procedure SetPollInterval(Value: integer);
    procedure SetOnPoll(Value: TNotifyEvent);
    procedure DetailChange(Sender: TObject; NewTab: Integer;
                           var AllowChange: Boolean);
    procedure SetPageIndex(Value: integer);
    function GetPageIndex: integer;
    procedure SetBackGround(Value: TBitMap);

    {NavLink}
    function GetNavLink: TNavLink;
    function GetDataSet: TDataSet;
    function GetQuery: TuQuery;
    function GetTable: TuTable;
    function GetAutoCommit: boolean;
    procedure SetAutoCommit(Value: boolean);
    function GetConfirmDelete: boolean;
    procedure SetConfirmDelete(Value: boolean);
    function GetAutoOpen: boolean;
    procedure SetAutoOpen(Value: boolean);
    function GetErfassSingle: boolean;
    procedure SetErfassSingle(Value: boolean);
    function GetEditSingle: boolean;
    procedure SetEditSingle(Value: boolean);
    function GetCalcOK: boolean;
    procedure SetCalcOK(Value: boolean);
    function GetDsQuery: boolean;
    function GetNlState: TNavLinkState;
    function GetNoOpen: boolean;
    procedure SetNoOpen(Value: boolean);
    function GetNoGotoPos: boolean;
    procedure SetNoGotoPos(Value: boolean);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetEditSource: TDataSource;
    procedure SetEditSource(Value: TDataSource);
    function GetCalcList: TValueList;
    procedure SetCalcList(Value: TValueList);
    procedure SetColumnList(Value: TValueList);
    function GetColumnList: TValueList;
    function GetDataPos: TDataPos;
    procedure SetDataPos(Value: TDataPos);
    function GetFltrList: TFltrList;
    procedure SetFltrList(Value: TFltrList);
    function GetFormatList: TValueList;
    procedure SetFormatList(Value: TValueList);
    function GetBemerkung: TStringList;
    procedure SetBemerkung(Value: TStringList);
    function GetKeyFields: string;
    procedure SetKeyFields(Value: string);
    function GetKeyList: TValueList;
    procedure SetKeyList(Value: TValueList);
    function GetPrimaryKeyFields: string;
    procedure SetPrimaryKeyFields(Value: string);
    function GetSqlFieldList: TValueList;
    procedure SetSqlFieldList(Value: TValueList);
    function GetReferences: TFltrList;
    procedure SetReferences(Value: TFltrList);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetTabTitel: string;
    procedure SetTabTitel(Value: string);
    function GetMasterFieldNames: string;
    function GetIndexFieldNames: string;
    function GetPrimaryKeyList: TValueList;
    function GetMasterSource: TDataSource;
    procedure SetMasterSource(Value: TDataSource);
    function GetOnValidate: TFieldNotifyEvent;
    procedure SetOnValidate(Value: TFieldNotifyEvent);
    function GetOnGet: TDataSetNotifyEvent;
    procedure SetOnGet(Value: TDataSetNotifyEvent);
    function GetOnErfass: TNotifyEvent;
    procedure SetOnErfass(Value: TNotifyEvent);
    function GetOnRech: TRechEvent;
    procedure SetOnRech(Value: TRechEvent);
    function GetOnBuildSql: TBuildSqlEvent;
    procedure SetOnBuildSql(Value: TBuildSqlEvent);
    function GetOnMsg: TMsgEvent;
    procedure SetOnMsg(Value: TMsgEvent);
    function GetBeforeQuery: TBeforeNotifyEvent;
    procedure SetBeforeQuery(Value: TBeforeNotifyEvent);
    function GetBeforeDelete: TBeforeNotifyEvent;
    procedure SetBeforeDelete(Value: TBeforeNotifyEvent);
    function GetBeforeDeleteMarked: TBeforeNotifyEvent;
    procedure SetBeforeDeleteMarked(Value: TBeforeNotifyEvent);
    function GetBeforeEdit: TBeforeNotifyEvent;
    procedure SetBeforeEdit(Value: TBeforeNotifyEvent);
    function GetBeforeInsert: TBeforeNotifyEvent;
    procedure SetBeforeInsert(Value: TBeforeNotifyEvent);
    function GetBeforePost: TBeforeNotifyEvent;
    procedure SetBeforePost(Value: TBeforeNotifyEvent);
    function GetBeforeCancel: TBeforeNotifyEvent;
    procedure SetBeforeCancel(Value: TBeforeNotifyEvent);
    function GetOnPostError: TDataSetErrorEvent;
    procedure SetOnPostError(Value: TDataSetErrorEvent);
    function GetDetailBook: TCustomTabControl;
    procedure SetDetailBook(const Value: TCustomTabControl);
    procedure DetailControlChange(Sender: TObject);
    function GetPageBook: TWinControl;
    procedure SetPageBook(const Value: TWinControl);
    procedure PageControlChanged(Sender: TObject);
    function GetTabSet: TWinControl;
    procedure SetTabSet(const Value: TWinControl);
    function GetOnDeleteError: TDataSetErrorEvent;
    procedure SetOnDeleteError(const Value: TDataSetErrorEvent);
    procedure SetSubCaption(const Value: string);
    function GetDsChangeAll: boolean;
    procedure SetPageBookStart(const Value: string);
    procedure SetDetailBookStart(const Value: string);
    procedure SetReturnAktiv(const Value: boolean);
    procedure SetReturnLookUpModus(const Value: TLookUpModus);
    procedure SetOptions(const Value: TLNavOptions);
    procedure SetExtCaption(const Value: string);
    function GetSqlHint: string;
    procedure SetSqlHint(const Value: string);
    function GetRecordCount: longint;

  protected
    { Protected-Deklarationen }
    LoadedOK: Boolean;
    FSubCaption: string;
    FExtCaption: string;
    TabIndexStartReturn, TabIndexTake, TabIndexClose: integer;  //Steuerung der TabClicks
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
    TabSetAktiv: boolean;
    HasInit: boolean;
    LoadedFirstControl: TWinControl;
    ActiveLookUpDef: TLookUpDef;          {Aktuelles Lookup}
    ErrorFieldName: string;               {von Build Sql}
    NewDetailPage: integer;               {Neue Detail Page für GetPageIndex}
    InDataPut: boolean;
    InDetailChange: boolean;
    InOldTabSetClick: boolean;
    NoPageChange: boolean;
    InStartLookUp: boolean;
    InDetailInsert: boolean;
    PageChangeCounter: integer;            {Zähler pro PageChange}
    BrowsePageIndex: integer;              {neuer PageIndex nach Edit/Insert}
    InStartReturn: boolean;                {Flag für doPost}
    InPoll: boolean;                       {Flag: im Ereignis OnPoll}
    IsAfterPostStart: boolean;             {Flag für Abfrage z.B. in NavPoll}
    InCheckAutoOpen: boolean;              {Flag für newdatachange}
    //02.10.02 LoadedTabs: TStringList;               {TabControl Buttons zwischenspeichern}
    NoAccelCharInTabs: boolean;            //true=kein '&' in &Zurück für LuGridSearch 'Z'

    ReturnKurz: string;                    {Form des Aufrufers}
    ReturnDataPos: TDataPos;               {Daten des Aufrufers}
    ReturnLuName: string;                  {Name LookupDef von Aufrufer}
    ReturnLuDef: TComponent;               {LookupDef von Aufrufer}
    //ReturnAktiv: boolean;                 {Flag ob in Lookup}
    //ReturnLookUpModus: TLookUpModus;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Init;
    procedure DoInit;  {Ruft OnInit wenn noch nicht aufgerufen}
    procedure InitPdfImage(UseDatn: boolean);
    procedure DoStart(Sender: TObject);
    procedure DoPostStart(Sender: TObject);
    procedure DoPoll(Sender: TObject);
    procedure Poll(Value: integer = 0);  //ruft Poll nach <Value> ms auf.
    procedure SetTitel;  {Titel aufbauen anhand Datenbankstatus}
    //procedure FillColumnList;  // Columnlist anhand FocusControl füllen
    procedure PaintBackGround(Sender: TForm);
    {Hintergrund malen}
    function MuDblClick(Sender: TMultiGrid): boolean;
    {Multi hat Doppelt geclickt}

    procedure AfterPost;
    procedure AfterCancel;
    procedure PageChanged(Sender: TObject);
    procedure TabSetClick(Sender: TObject);
    procedure StateChange(Sender: TObject);
    procedure DoOnSingleDataChange(AField: TField);

    procedure SetActiveLookUpEdit(ALuEdit: TCustomEdit); 
    function ActiveLookUpEdit: TDBEdit;            {letztes TLookupEdit Feld }
    function ActiveLookUpMemo: TDBMemo;            {letztes TLookupMemo Feld }
    procedure DoLookUp(lum: TLookUpModus);
    function FindLookUpDef(ATabTitel:string; var ALookUpDef: TLookUpDef): boolean;
    procedure SetReturn(Modus: integer; CallerKurz: string; ALookUpDef: TLookUpDef);
    procedure StartReturn;
    procedure Take;
    procedure Take1(Marked: boolean);
    procedure StartLookUp(lum: TLookUpModus; ALookUpDef: TLookUpDef);
    procedure DoAfterReturn(Sender: TObject; LookUpModus: TLookUpModus;
                             LookUpDef: TLookUpDef);

    procedure CheckDetailInsert;
    procedure DetailInsert(Modus: TDetailInsertModus);
    procedure DoPageChange(APageIndex: Integer);
    procedure CheckAutoOpen(OnlyDetail: boolean);{Öffnet/schließt Ludefs. für Anwendung}
    procedure GotoDataPos;
    procedure ReLoad2;
    procedure DoAfterPageChange(APageIndex: Integer);
    function PageBookPage(APage: string): string;
    function GetPage: string;
    procedure SetPage(NewPage: string);
    procedure SetDetail(NewDetail: string);
    procedure SetTabIndex(AIndex: integer);
    {Markieren des aktiven Tabs}
    procedure SetTabPage(APage: string);
    procedure SetTabs;
    procedure DoPrn;
    function GetFormValue(ParamName: string): string;
    procedure SetFormValue(ParamName, Value: string);

    property Titles: TStringList read FTitles write FTitles;
    property PageIndex: integer read GetPageIndex write SetPageIndex;
    property SubCaption: string read FSubCaption write SetSubCaption;
    property ExtCaption: string read FExtCaption write SetExtCaption;
    property ReturnAktiv: boolean read FReturnAktiv write SetReturnAktiv;
    property ReturnLookUpModus: TLookUpModus read FReturnLookUpModus write SetReturnLookUpModus;

    {NavLink:}
    procedure Commit;                                       {Explizit Speichern}
    procedure Refresh;                               {Aktualisieren}
    procedure Reload;
    procedure SafeRefresh;
    procedure SafeReload;
    function BuildSql: boolean;
    procedure AddCalcFields;
    procedure DeleteAll;

    procedure SetFieldFlags(AField: TField; Flags: TFieldFlags);
    procedure SetEditFlags(AEdit: TWinControl; Flags: TFieldFlags);
    procedure ToggleFieldFlags(AField: TField; Flags: TFieldFlags; Toggle: boolean); overload;
    procedure ToggleFieldFlags(AFieldName: string; Flags: TFieldFlags; Toggle: boolean); overload;
    procedure ToggleEditFlags(AEdit: TWinControl; Flags: TFieldFlags; Toggle: boolean);
    procedure DoValidate(Sender: TField);
    procedure DoRech(ADataSet: TDataSet; Field: TField; OnlyCalc: boolean;
      Sender: string);
    procedure DoQuery;
    procedure DoNavigate(Index: TQbeNavigateBtn);
    procedure DoEdit(CheckRights: boolean = false);
    procedure DoInsert(CheckRights: boolean = false);
    procedure DoPost(CheckRights: boolean = false);
    procedure DoCancel;
    procedure DoDelete;
    function AssignField(AFieldName: string; SrcField: TField): boolean; {mit Comp, DoEdit}
    function AssignValue(AFieldName, AValue: string): boolean;           {mit Comp, DoEdit}
    function AssignValueIfNull(AFieldName, AValue: string): boolean;
    function AssignDateTime(AFieldName: string; AValue: TDateTime): boolean;
    function AssignTimeStr(AFieldName: string; AValue: TDateTime): boolean;
    function AssignFloat(AFieldName: string; AValue: double): boolean;
    function AssignInteger(AFieldName: string; AValue: integer): boolean;
    function AssignMemoLine(AFieldName: string; ALine: integer; AValue: string): boolean;
    function AssignMemoValue(AFieldName, AParam, AValue: string): boolean;

    property NavLink: TNavLink read GetNavLink write FNavLink;
    property DataSet: TDataSet read GetDataSet;
    property Query: TuQuery read GetQuery;
    property Table: TuTable read GetTable;
    property DataPos: TDataPos read GetDataPos write SetDataPos;

    property RecordCount: longint read GetRecordCount;
    property CalcOK: Boolean read GetCalcOK write SetCalcOK;
    property dsQuery: boolean read GetDsQuery;
    property dsChangeAll: boolean read GetDsChangeAll;
    property NlState: TNavLinkState read GetNlState;
    {Status vom aktuellen DataSource inklusive Query(suchen)}
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
    property MasterFieldNames: string read GetMasterFieldNames;
    property IndexFieldNames: string read GetIndexFieldNames;
    property PrimaryKeyList: TValueList read GetPrimaryKeyList;
  published
    { Published-Deklarationen }
    property BackGround: TBitMap read FBackGround write SetBackGround;
    property TabSet: TWinControl read GetTabSet write SetTabSet;
    property PageBook: TWinControl read GetPageBook write SetPageBook;
    property DetailBook: TCustomTabControl read GetDetailBook write SetDetailBook;
    property FormKurz: string read FFormKurz write FFormKurz;
    property BtnSingle: TBtnPage read FBtnSingle write FBtnSingle;
    property BtnMulti: TBtnPage read FBtnMulti write FBtnMulti;
    property FirstControl: TWinControl read FFirstControl write FFirstControl;
    property AutoEditStart: boolean read FAutoEditStart write FAutoEditStart;
    property PageBookStart: string read FPageBookStart write SetPageBookStart;
    property DetailBookStart: string read FDetailBookStart write SetDetailBookStart;
    property StaticFields: boolean read FStaticFields write FStaticFields;
    property Options: TLNavOptions read FOptions write SetOptions;

    property OnPrn: TLNavPrnEvent read FOnPrn write FOnPrn;
    property OnInit: TNotifyEvent read FOnInit write FOnInit;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnPostStart: TNotifyEvent read FOnPostStart write FOnPostStart;
    property OnStartReturn: TNotifyEvent read FOnStartReturn write FOnStartReturn;
    property AfterReturn: TAfterReturnEvent read FAfterReturn write FAfterReturn;
    property OnSetTitel: TSetTitelEvent read FOnSetTitel write FOnSetTitel;
    property PollInterval: integer read FPollInterval write SetPollInterval;
    property OnPoll: TNotifyEvent read FOnPoll write SetOnPoll;

    property OnPageChange: TPageChangeEvent read FOnPageChange write FOnPageChange;
    property AfterPageChange: TPageChangeEvent read FAfterPageChange write FAfterPageChange;

    property OnGetFormValue: TFormValueEvent read FOnGetFormValue write FOnGetFormValue;
    property OnSetFormValue: TFormValueEvent read FOnSetFormValue write FOnSetFormValue;
    property OnSingleDataChange: TSingleDataChangeEvent read FOnSingleDataChange write FOnSingleDataChange;

    {OnStore: entspr. StateChange oder BeforePost, Store Sekundärtables möglich
     OnValid: entspr. OnExit, SetFocus möglich, Infos über LastKey
     OnEscKey: entspr. KeyDown, kann Key ändern, Setfocus
     OnOkKey:
     OnErfass: StateChange nach dsInsert}

    {NavLink:}
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property EditSource: TDataSource read GetEditSource write SetEditSource;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property AutoOpen: boolean read GetAutoOpen write SetAutoOpen;
    property ConfirmDelete: Boolean read GetConfirmDelete write SetConfirmDelete;
    property EditSingle: boolean read GetEditSingle write SetEditSingle;
    property ErfassSingle: boolean read GetErfassSingle write SetErfassSingle;
    property NoOpen: boolean read GetNoOpen write SetNoOpen;
    property NoGotoPos: boolean read GetNoGotoPos write SetNoGotoPos;
    property CalcList: TValueList read GetCalcList write SetCalcList;
    property ColumnList: TValueList read GetColumnList write SetColumnList;
    property FltrList: TFltrList read GetFltrList write SetFltrList;
    property FormatList: TValueList read GetFormatList write SetFormatList;
    property Bemerkung: TStringList read GetBemerkung write SetBemerkung;
    property KeyFields: string read GetKeyFields write SetKeyFields;
    property KeyList: TValueList read GetKeyList write SetKeyList;
    property PrimaryKeyFields: string read GetPrimaryKeyFields write SetPrimaryKeyFields;
    property References: TFltrList read GetReferences write SetReferences;
    property SqlFieldList: TValueList read GetSqlFieldList write SetSqlFieldList;
    property SqlHint: string read GetSqlHint write SetSqlHint;
    property TableName: string read GetTableName write SetTableName;
    property TabTitel: string read GetTabTitel write SetTabTitel;
    property OnValidate: TFieldNotifyEvent read GetOnValidate write SetOnValidate;
    property OnGet: TDataSetNotifyEvent read GetOnGet write SetOnGet;
    property OnRech: TRechEvent read GetOnRech write SetOnRech;
    property OnErfass: TNotifyEvent read GetOnErfass write SetOnErfass;
    property OnBuildSql: TBuildSqlEvent read GetOnBuildSql write SetOnBuildSql;
    property OnMsg: TMsgEvent read GetOnMsg write SetOnMsg;
    property BeforeQuery: TBeforeNotifyEvent read GetBeforeQuery write SetBeforeQuery;
    property BeforeDelete: TBeforeNotifyEvent read GetBeforeDelete write SetBeforeDelete;
    property BeforeDeleteMarked: TBeforeNotifyEvent read GetBeforeDeleteMarked write SetBeforeDeleteMarked;
    property BeforeEdit: TBeforeNotifyEvent read GetBeforeEdit write SetBeforeEdit;
    property BeforeInsert: TBeforeNotifyEvent read GetBeforeInsert write SetBeforeInsert;
    property BeforePost: TBeforeNotifyEvent read GetBeforePost write SetBeforePost;
    property BeforeCancel: TBeforeNotifyEvent read GetBeforeCancel write SetBeforeCancel;
    property OnPostError: TDataSetErrorEvent read GetOnPostError write SetOnPostError;
    property OnDeleteError: TDataSetErrorEvent read GetOnDeleteError write SetOnDeleteError;

  end;

implementation
{$R+} {$F+}
uses
  Vcl.Consts,
  itfPDFImage, Datn_Kmp,
  DBGrids, Mask, Printers, TabNbKmp, dbcgrids,
  GNav_Kmp, LuEdiKmp, Qwf_Form, QRepForm, Prn__Dlg, PSrc_Kmp, AbortDlg, nstr_Kmp,
  RechtKmp, Err__Kmp, Poll_Kmp, Tools, Ini__Kmp, KmpResString;

const
  StdPages: array[0..9] of string = ('Single', 'Multi', '2', '3', '4', '5', '6', '7', '8', '9');
type
  TControlAccess = class(TControl);

(* Properties setzen ****************************************************)

function TLNavigator.GetNavLink: TNavLink;
begin
  result := FNavLink;
  if not Assigned(FNavLink) then
    EError('%s:NavLink=nil',[Name]);
end;

function TLNavigator.GetDataSet: TDataSet;
begin
  if DataSource = nil then
    result := nil else
    result := DataSource.DataSet;
end;

function TLNavigator.GetQuery: TuQuery;
begin
  result := NavLink.Query;
end;

function TLNavigator.GetTable: TuTable;
begin
  result := NavLink.Table;
end;

function TLNavigator.GetDataSource: TDataSource;
begin
  result := NavLink.DataSource;
end;

procedure TLNavigator.SetDataSource(Value: TDataSource);
begin
  NavLink.DataSource := Value;
end;

function TLNavigator.GetEditSource: TDataSource;
begin
  result := NavLink.EditSource;
end;

procedure TLNavigator.SetEditSource(Value: TDataSource);
begin
  NavLink.EditSource := Value;
end;

function TLNavigator.GetCalcList: TValueList;
begin
  result := NavLink.CalcList;
end;

procedure TLNavigator.SetCalcList(Value: TValueList);
begin
  NavLink.CalcList := Value;
end;

procedure TLNavigator.SetColumnList(Value: TValueList);
begin
  NavLink.ColumnList:= Value;
end;

function TLNavigator.GetColumnList: TValueList;
begin
  result := NavLink.ColumnList;
end;

function TLNavigator.GetDataPos: TDataPos;
begin
  result := NavLink.DataPos;
end;

procedure TLNavigator.SetDataPos(Value: TDataPos);
begin
  NavLink.DataPos := Value;
end;

function TLNavigator.GetFltrList: TFltrList;
begin
  result := NavLink.FltrList;
end;

procedure TLNavigator.SetFltrList(Value: TFltrList);
begin
  NavLink.FltrList := Value;
end;

function TLNavigator.GetFormatList: TValueList;
begin
  result := NavLink.FormatList;
end;

procedure TLNavigator.SetFormatList(Value: TValueList);
begin
  NavLink.FormatList := Value;
end;

function TLNavigator.GetBemerkung: TStringList;
begin
  result := NavLink.Bemerkung;
end;

procedure TLNavigator.SetBemerkung(Value: TStringList);
begin
  NavLink.Bemerkung := Value;
end;
function TLNavigator.GetKeyFields: string;
begin
  result := NavLink.KeyFields;
end;

procedure TLNavigator.SetKeyFields(Value: string);
begin
  NavLink.KeyFields := Value;
end;

function TLNavigator.GetKeyList: TValueList;
begin
  result := NavLink.KeyList;
end;

procedure TLNavigator.SetKeyList(Value: TValueList);
begin
  NavLink.KeyList := Value;
end;

function TLNavigator.GetPrimaryKeyFields: string;
begin
  result := NavLink.PrimaryKeyFields;
end;

procedure TLNavigator.SetPrimaryKeyFields(Value: string);
begin
  NavLink.PrimaryKeyFields := Value;
end;

function TLNavigator.GetRecordCount: longint;
begin
  Result := NavLink.RecordCount;
end;

function TLNavigator.GetReferences: TFltrList;
begin
  result := NavLink.References;
end;

procedure TLNavigator.SetReferences(Value: TFltrList);
begin
  NavLink.References := Value;
end;

function TLNavigator.GetSqlFieldList: TValueList;
begin
  result := NavLink.SqlFieldList;
end;

procedure TLNavigator.SetSqlFieldList(Value: TValueList);
begin
  NavLink.SqlFieldList := Value;
end;

function TLNavigator.GetSqlHint: string;
begin
  result := NavLink.SqlHint;
end;

procedure TLNavigator.SetSqlHint(const Value: string);
begin
  NavLink.SqlHint := Value;
end;

procedure TLNavigator.SetTableName(Value: string);
begin
  NavLink.TableName := Value;
end;

function TLNavigator.GetTableName: string;
begin
  result := NavLink.TableName;
end;

function TLNavigator.GetTabTitel: string;
begin
  result := NavLink.TabTitel;
end;

procedure TLNavigator.SetTabTitel(Value: string);
begin
  NavLink.TabTitel := Value;
end;

function TLNavigator.GetMasterFieldNames: string;
begin
  Result := NavLink.MasterFieldNames;
end;

function TLNavigator.GetIndexFieldNames: string;
begin
  Result := NavLink.IndexFieldNames;
end;

function TLNavigator.GetPrimaryKeyList: TValueList;
begin
  Result := NavLink.PrimaryKeyList;
end;

function TLNavigator.GetMasterSource: TDataSource;
begin
  result := NavLink.MasterSource;
end;

procedure TLNavigator.SetMasterSource(Value: TDataSource);
begin
  NavLink.MasterSource := Value;
end;

function TLNavigator.GetOnValidate: TFieldNotifyEvent;
begin
  result := NavLink.OnValidate;
end;

procedure TLNavigator.SetOnValidate(Value: TFieldNotifyEvent);
begin
  NavLink.OnValidate := Value;
end;

function TLNavigator.GetOnGet: TDataSetNotifyEvent;
begin
  result := NavLink.OnGet;
end;

procedure TLNavigator.SetOnGet(Value: TDataSetNotifyEvent);
begin
  NavLink.OnGet := Value;
end;

function TLNavigator.GetOnErfass: TNotifyEvent;
begin
  result := NavLink.OnErfass;
end;

procedure TLNavigator.SetOnErfass(Value: TNotifyEvent);
begin
  NavLink.OnErfass := Value;
end;

function TLNavigator.GetOnRech: TRechEvent;
begin
  result := NavLink.OnRech;
end;

procedure TLNavigator.SetOnRech(Value: TRechEvent);
begin
  NavLink.OnRech := Value;
end;

function TLNavigator.GetOnBuildSql: TBuildSqlEvent;
begin
  result := NavLink.OnBuildSql;
end;

procedure TLNavigator.SetOnBuildSql(Value: TBuildSqlEvent);
begin
  NavLink.OnBuildSql := Value;
end;

function TLNavigator.GetOnMsg: TMsgEvent;
begin
  result := NavLink.OnMsg;
end;

procedure TLNavigator.SetOnMsg(Value: TMsgEvent);
begin
  NavLink.OnMsg := Value;
end;

function TLNavigator.GetBeforeQuery: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeQuery;
end;

procedure TLNavigator.SetBeforeQuery(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeQuery := Value;
end;

function TLNavigator.GetBeforeDelete: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeDelete;
end;

procedure TLNavigator.SetBeforeDelete(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeDelete := Value;
end;

function TLNavigator.GetBeforeDeleteMarked: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeDeleteMarked;
end;

procedure TLNavigator.SetBeforeDeleteMarked(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeDeleteMarked := Value;
end;

function TLNavigator.GetBeforeEdit: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeEdit;
end;

procedure TLNavigator.SetBeforeEdit(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeEdit := Value;
end;

function TLNavigator.GetBeforeInsert: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeInsert;
end;

procedure TLNavigator.SetBeforeInsert(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeInsert := Value;
end;

function TLNavigator.GetBeforePost: TBeforeNotifyEvent;
begin
  result := NavLink.BeforePost;
end;

procedure TLNavigator.SetBeforePost(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforePost := Value;
end;

function TLNavigator.GetBeforeCancel: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeCancel;
end;

procedure TLNavigator.SetBeforeCancel(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeCancel := Value;
end;

function TLNavigator.GetOnPostError: TDataSetErrorEvent;
begin
  result := NavLink.OnPostError;
end;

procedure TLNavigator.SetOnPostError(Value: TDataSetErrorEvent);
begin
  NavLink.OnPostError := Value;
end;

function TLNavigator.GetOnDeleteError: TDataSetErrorEvent;
begin
  result := NavLink.OnDeleteError;
end;

procedure TLNavigator.SetOnDeleteError(const Value: TDataSetErrorEvent);
begin
  NavLink.OnDeleteError := Value;
end;

procedure TLNavigator.SetNoOpen(Value: boolean);
begin
  NavLink.NoOpen:= Value;
end;

function TLNavigator.GetNoOpen: boolean;
begin
  result := NavLink.NoOpen;
end;

function TLNavigator.GetNoGotoPos: boolean;
begin
  result := NavLink.NoGotoPos;
end;

procedure TLNavigator.SetNoGotoPos(Value: boolean);
begin
  NavLink.NoGotoPos:= Value;
end;

function TLNavigator.GetDsQuery: boolean;
begin
  result := NavLink.dsQuery;
end;

function TLNavigator.GetDsChangeAll: boolean;
begin
  result := NavLink.dsChangeAll;
end;

function TLNavigator.GetNlState: TNavLinkState;
{Status über NavLink holen}
begin
  result := NavLink.NlState;
end;

function TLNavigator.GetCalcOK: boolean;
begin
  result := NavLink.CalcOK;
end;

procedure TLNavigator.SetCalcOK(Value: boolean);
begin
  NavLink.CalcOK := Value;
end;

function TLNavigator.GetAutoCommit: boolean;
begin
  result := NavLink.AutoCommit;
end;

procedure TLNavigator.SetAutoCommit(Value: boolean);
begin
  NavLink.AutoCommit := Value;
end;

function TLNavigator.GetConfirmDelete: boolean;
begin
  result := NavLink.ConfirmDelete;
end;

procedure TLNavigator.SetConfirmDelete(Value: boolean);
begin
  NavLink.ConfirmDelete := Value;
end;

function TLNavigator.GetAutoOpen: boolean;
begin
  result := NavLink.AutoOpen;
end;

procedure TLNavigator.SetAutoOpen(Value: boolean);
begin
  NavLink.AutoOpen := Value;
end;

function TLNavigator.GetEditSingle: boolean;
begin
  result := NavLink.EditSingle;
end;

procedure TLNavigator.SetEditSingle(Value: boolean);
begin
  NavLink.EditSingle := Value;
end;

function TLNavigator.GetErfassSingle: boolean;
begin
  result := NavLink.ErfassSingle;
end;

procedure TLNavigator.SetErfassSingle(Value: boolean);
begin
  NavLink.ErfassSingle := Value;
end;

procedure TLNavigator.Commit;
(* bei Autocommit kann nur hiermit gespeichert werden. Ersetzt Post. *)
begin
  NavLink.Commit;
end;

procedure TLNavigator.Refresh;
begin
  NavLink.Refresh;
end;
procedure TLNavigator.Reload;
begin
  NavLink.Reload;
end;
procedure TLNavigator.SafeRefresh;
begin
  NavLink.SafeRefresh;
end;
procedure TLNavigator.SafeReload;
begin
  NavLink.SafeReload;
end;

procedure TLNavigator.AddCalcFields;
begin
  NavLink.AddCalcFields;
end;

function TLNavigator.BuildSql: boolean;
begin
  result := NavLink.BuildSql;
end;

procedure TLNavigator.DeleteAll;
begin
  NavLink.DeleteAll;
end;

procedure TLNavigator.SetFieldFlags(AField: TField; Flags: TFieldFlags);
begin
  NavLink.SetFieldFlags(AField, Flags);
end;

procedure TLNavigator.SetEditFlags(AEdit: TWinControl; Flags: TFieldFlags);
begin
  NavLink.SetEditFlags(AEdit, Flags);
end;

procedure TLNavigator.ToggleFieldFlags(AField: TField; Flags: TFieldFlags; Toggle: boolean);
begin
  NavLink.ToggleFieldFlags(AField, Flags, Toggle);
end;

procedure TLNavigator.ToggleFieldFlags(AFieldName: string; Flags: TFieldFlags; Toggle: boolean);
begin
  if Dataset <> nil then  //15.04.13
    NavLink.ToggleFieldFlags(Dataset.FindField(AFieldName), Flags, Toggle);
end;

procedure TLNavigator.ToggleEditFlags(AEdit: TWinControl; Flags: TFieldFlags; Toggle: boolean);
begin
  NavLink.ToggleEditFlags(AEdit, Flags, Toggle);
end;

procedure TLNavigator.DoValidate(Sender: TField);
begin
  NavLink.DoValidate(Sender);
end;

procedure TLNavigator.DoRech(ADataSet: TDataSet; Field: TField;
  OnlyCalc: boolean; Sender: string);
begin
  NavLink.DoRech(ADataSet, Field, OnlyCalc, Sender);
end;

procedure TLNavigator.DoQuery;
begin
  NavLink.DoQuery;
end;

procedure TLNavigator.DoNavigate(Index: TQbeNavigateBtn);
begin
  NavLink.DoNavigate(Index);
end;

procedure TLNavigator.DoEdit(CheckRights: boolean = false);
begin
  NavLink.DoEdit(CheckRights);
end;

procedure TLNavigator.DoInsert(CheckRights: boolean = false);
begin
  NavLink.DoInsert(CheckRights);
end;

procedure TLNavigator.DoPost(CheckRights: boolean = false);
begin
  NavLink.DoPost(CheckRights);
end;

procedure TLNavigator.DoCancel;
begin
  NavLink.DoCancel;
end;

procedure TLNavigator.DoDelete;
begin
  NavLink.DoDelete;
end;

function TLNavigator.AssignField(AFieldName: string; SrcField: TField): boolean;
begin
  result := NavLink.AssignField(AFieldName, SrcField);
end;

function TLNavigator.AssignValue(AFieldName, AValue: string): boolean;
begin
  result := NavLink.AssignValue(AFieldName, AValue);
end;

function TLNavigator.AssignValueIfNull(AFieldName,
  AValue: string): boolean;
begin
  result := NavLink.AssignValueIfNull(AFieldName, AValue);
end;

function TLNavigator.AssignDateTime(AFieldName: string; AValue: TDateTime): boolean;
begin
  result := NavLink.AssignDateTime(AFieldName, AValue);
end;

function TLNavigator.AssignTimeStr(AFieldName: string;
  AValue: TDateTime): boolean;
begin
  result := NavLink.AssignTimeStr(AFieldName, AValue);
end;

function TLNavigator.AssignFloat(AFieldName: string; AValue: double): boolean;
begin
  result := NavLink.AssignFloat(AFieldName, AValue);
end;

function TLNavigator.AssignInteger(AFieldName: string; AValue: integer): boolean;
begin
  result := NavLink.AssignInteger(AFieldName, AValue);
end;

function TLNavigator.AssignMemoLine(AFieldName: string; ALine: integer;
  AValue: string): boolean;
begin
  result := NavLink.AssignMemoLine(AFieldName, ALine, AValue);
end;

function TLNavigator.AssignMemoValue(AFieldName, AParam, AValue: string): boolean;
begin
  result := NavLink.AssignMemoValue(AFieldName, AParam, AValue);
end;

procedure TLNavigator.SetPollInterval(Value: integer);
var
  Changed: boolean;
begin
  Changed := FPollInterval <> Value;
  if Changed then
    FPollInterval := Value;
  if not (csDesigning in ComponentState) and (PollKmp <> nil) and
     (assigned(FOnPoll)) then
  begin
    if not PollAdded then
    begin
      PollAdded := true;
      PollKmp.Add(DoPoll, self, FPollInterval);
    end else
    if Changed then
      PollKmp.SetPeriod(DoPoll, self, FPollInterval);
  end;
end;

procedure TLNavigator.Poll(Value: integer = 0);
//ruft Poll nach <Value> ms auf.
begin
  if PollAdded then
  begin
    PollKmp.Sleep(DoPoll, self, Value);
  end;
end;

procedure TLNavigator.SetOnPoll(Value: TNotifyEvent);
begin
  FOnPoll := Value;
  if not (csDesigning in ComponentState) and (PollKmp <> nil) and
     (assigned(FOnPoll)) and (FPollInterval > 0) then
  begin
    if not PollAdded then
    begin
      PollAdded := true;
      PollKmp.Add(DoPoll, self, FPollInterval);
    end;
  end;
end;

procedure TLNavigator.DoPoll(Sender: TObject);
begin
  if not TqForm(Owner).Started then  //von DoPostStart
    Exit;
  if not (csDesigning in ComponentState) and
     (FPollInterval > 0) and (assigned(FOnPoll)) and
     IsAfterPostStart and not InPoll then
  try
    InPoll := true;
    try
      FOnPoll(Sender);
    except on E:Exception do
      EProt(self, E, 'NavPoll', [0]);
    end;
  finally
    InPoll := false;
  end;
end;

(* LNavigator Initialisierung *********************************************)

constructor TLNavigator.Create(AOwner: TComponent);
var
  AForm: TqForm;
begin
  inherited Create(AOwner);
  LoadedOK := false;
  BrowsePageIndex := -1;
  if not (csDesigning in ComponentState) and (AOwner is TqForm) then
  begin
    AForm := Owner as TqForm;
    AForm.LNavigator := self;
  end;

  FBackGround := TBitMap.Create;
  FTitles := TStringList.Create;
  NavLink := TNavLink.create(self);
  FFormValues := TStringList.Create;
  NavLink.MDTyp := MDMaster;
  AutoCommit := false;
  FAutoEditStart := false;
  FPageBookStart := '1';   {Multi';}
  FDetailBookStart := '0';
  FActiveLookUpEdit := nil;
  ActiveLookUpDef := nil;
  ReturnDataPos := TDataPos.Create;
  FPollInterval := 0;
end;

destructor TLNavigator.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if PollAdded and (PollKmp <> nil) then
    begin
      PollAdded := false;
      PollKmp.Sub(DoPoll, self);
    end;
    if (GNavigator <> nil) and (GNavigator.X <> nil) and
       (GNavigator.LNavigator = self) and
       (dsQuery or dsChangeAll) then
      GNavigator.X.QueryCancel;
    (* in qwf/qrep Form
    if (Owner <> nil) and (Owner is TQRepForm) then
    begin
      {AName := (Owner as TQRepForm).ClassName;}
      {GNavigator.EndQRepForm(self, FormKurz);}
    end else
    if (Owner <> nil) and (Owner is TqForm) then
    begin
      AName := '';{(Owner as TqForm).ClassName;}
      if FormKurz = SysParam.OurKurz then
        ErrWarn('LNav:OurKurz(%s)',[AName]);
      GNavigator.EndForm(self, FormKurz);
    end;
    *)
    if (GNavigator <> nil) and (GNavigator.X <> nil) and
       (GNavigator.X.FNavLink = NavLink) then
      GNavigator.X.FNavLink := nil;
  end;
  FreeAndNil(FNavLink);
  FBackGround.Free;
  FreeAndNil(FTitles);
  FreeAndNil(ReturnDataPos);
  FreeAndNil(FFormValues);
  inherited Destroy;
end;

procedure TLNavigator.Loaded;
var
  AForm: TqForm;
begin
  inherited Loaded;
  AForm := nil;
  try
    (* zur Designzeit gibt es kein TqForm; nur TForm *)
    if not (csDesigning in ComponentState) then     {HLW 040797 - GetStaticFields}
    begin
      AForm := Owner as TqForm;
      AForm.LNavigator := self;
    end;
  except
    ErrWarn(SLNav_Kmp_001,[TForm(Owner).Caption]);	// '%s nicht TqForm'
    AForm := nil;
  end;
  if not (csDesigning in ComponentState) then
  begin
    if AForm = nil then
      Prot0('LNav.Loaded(%s):AForm=nil',[TForm(Owner).Caption]) else
    begin
      if BtnSingle <> nil then
      begin
        BtnSingle.NoteBook := FPageBook;
      end;
      if BtnMulti <> nil then
      begin
        BtnMulti.NoteBook := FPageBook;
      end;
      if FTabSet <> nil then
      begin
        if not assigned(OldTabSetClick) then
        begin
          OldTabSetClick := FTabSet.OnClick;
          FTabSet.OnClick := TabSetClick;
        end;
      end;
      if FTabControl <> nil then
      begin
        if not assigned(OldTabSetClick) then
        begin
          OldTabSetClick := FTabControl.OnChange;
          FTabControl.OnChange := TabSetClick;
        end;
      end;
      if FPageBook <> nil then
      begin
        if not assigned(OldPageChanged) then
        begin
          OldPageChanged := FPageBook.OnPageChanged;
          FPageBook.OnPageChanged := PageChanged;
        end;
      end;
      if FPageControl <> nil then
      begin
        if not assigned(OldPageControlChanged) then
        begin
          OldPageControlChanged := FPageControl.OnChange;
          FPageControl.OnChange := PageControlChanged;
        end;
      end;
      SetPage(PageBookPage(PageBookStart));     {hier noch kein Ereignis. Auch wenn PageBook=nil}
      if FDetailBook <> nil then
      begin
        if not assigned(OldDetailChange) then
        begin
          OldDetailChange := FDetailBook.OnChange;
          FDetailBook.OnChange := DetailChange;
        end;
        SetDetail(DetailBookStart); {hier noch kein Ereignis}
      end;
      if FDetailControl <> nil then
      begin
        if not assigned(OldDetailControlChange) then
        begin
          OldDetailControlChange := FDetailControl.OnChange;
          FDetailControl.OnChange := DetailControlChange;
        end;
        SetDetail(DetailBookStart); {hier noch kein Ereignis}
      end;
      SetTabs;                       {210399 nach init  nein}
      //SetTabIndex(-1);
      //SetTitel;    //08.05.08 zu früh ents                     {040699 zu früh OPT Hist}
    end;
    if (DataSource <> nil) then
    begin
      OldStateChange := DataSource.OnStateChange;
      DataSource.OnStateChange := StateChange;
      {DataSource.Autoedit := AutoEditStart;}
      if AutoEditStart then
        DataSource.Autoedit := true;     {30.10.01}

      //29.11.08 - Columnlist anhand FocusControl füllen
      //26.05.09: nach Navlink umgezogen FillColumnList;
      Navlink.FillColumnList;  //muss bereits hier sein
    end;
  end; {csDesigning}
  if TabTitel <> '' then
  begin
    if Char1(TabTitel) = ';' then
      NavLink.Display := copy(TabTitel, 2, MaxInt) else
      NavLink.Display := TabTitel;
  end else
  if FormKurz <> '' then
    NavLink.Display := FormKurz else
  if TableName <> '' then
    NavLink.Display := TableName else
  if DataSet <> nil then
    NavLink.Display := DataSet.Name else
    NavLink.Display := Name;
  NavLink.Loaded;
  LoadedFirstControl := FirstControl;
  LoadedOK := true;
  // GNav.LoadForm ruft nicht DoStart auf - qsbt touch 21.04.08
  if not Assigned(OnPostStart) then
  begin
    IsAfterPostStart := true;  //Polling erlauben. Für DCOM QSBTSvr
  end;
  { TODO : nach 3sek Polling erlauben. Hier Startzeit setzen. }
end;

procedure TLNavigator.Init;
(* von TqForm.Init. auch für LuGridlg. Nur 1 mal. Nach FormCreate und FormShow. *)
begin
  {SetTabs;
  //SetTabIndex(-1);
  SetTitel;}
  if not (Owner is TQRepForm) and (Owner is TqForm) and (GNavigator <> nil) then
    GNavigator.SetForm(FormKurz, Owner as TqForm);  //Tabellentechte - 21.01.05
  NavLink.Init;                                     {Sql, Open}
end;

procedure TLNavigator.DoInit;
(* von TqForm.Init. Nach Init, FormCreate und FormShow. Nur wenn Enabled. *)
var
  aPrnSource: TPrnSource;
begin
  if not HasInit then
  try
    if assigned(FOnInit) then
      FOnInit(self);
    //Hardcopy Ausdruck einfügen:
    aPrnSource := TPrnSource.Create(Owner);
    aPrnSource.DruckerTyp := SHardcopyPrinter;
    if IniKmp <> nil then
      IniKmp.DruckerTypen.Add(SHardcopyPrinter);
    aPrnSource.QRepKurz := SHardcopyKurz;
    aPrnSource.Name := 'ps' + SHardcopyKurz + '001';
    aPrnSource.Display := 'Hardcopy';
  finally
    HasInit := true;
  end;
end;

procedure TLNavigator.DoStart(Sender: TObject);
(* von StartForm,LookUp.aufgerufen zeitlich Nach DoInit *)
begin
  if not NoOpen and (DataSet <> nil) then
  try
    DataSet.Open; {DataSet öffnen}
  except on E:Exception do
    EMess(DataSet, E, 'Start', [0]);
  end;
  // entfernt wg quva.ausu launch Wartezeit:
  // NoOpen := false;                  {für wiederholte Starts  OPT 020699}
  try
    NoPageChange := true;
    SetPage(PageBookPage(PageBookStart)); {erst hier wg. Query1.Active und caMinimize}
    {PageBook setzten}
    SetDetail(DetailBookStart);       {erst hier wg. Query1.Active und caMinimize}
    {DetailBook setzten}          {111199 isa bereits in finally}
    try
      if (PageIndex >= 10) and (NavLink.DBGrid <> nil) then
        NavLink.DBGrid.SetFocus else  //SQVA - 06.02.07
      if (PageIndex < 10) and (FirstControl <> nil) then
        FirstControl.SetFocus;        //Testphase: Verhalten ok so?
    except  //wirft möglicherweise Exception!
      Debug0;
    end;
    //erst hier ist Übersetzung durchgeführt (NavLinkInit)
    // 26.05.09: zu spät:
//    NavLink.FillColumnList;
//    if (Owner <> nil) and (Owner is TqForm) then
//      TqForm(Owner).BroadcastMessage(Owner, TLookupDef, ldFillColumnList, 0);
  finally
    NoPageChange := false;
  end;
  if Owner is TqForm then
    TqForm(Owner).SetObjRechte;  //23.05.13 bereits hier damit in OnStart verfügbar.
  if assigned(FOnStart) then
  try
    InOnStart := true;
    FOnStart(Sender);                     {Eigene OnStart-Routine per Ereigniss}
  finally
    InOnStart := false;
  end;
  PostMessage((Owner as TForm).Handle, BC_POSTSTART, 0, 0);
  {Ruft DoPostStart über PostMessage mit Nachricht die von TQForm den Aufruf von
   DoPostStart auslösst von LNav}
end;

procedure TLNavigator.DoPostStart(Sender: TObject);
(* nach obiger Postmessage. Behandlung von BC_POSTSTART  *)
begin
//23.05.13 vor FOnStart
//  if Owner is TqForm then
//    TqForm(Owner).SetObjRechte;
  TqForm(Owner).Started := true;  //10.02.10
  if assigned(FOnPostStart) then
  try
    FOnPostStart(Sender);
  except on E:Exception do
    EProt(self, E, 'DoPostStart', [0]);
  end;
  IsAfterPostStart := true;
end;

procedure TLNavigator.DoOnSingleDataChange(AField: TField);
//Aufruf Ereignis
begin
  if not Navlink.CalcOK then
    Exit;  //noch nicht soweit

  //25.04.13
  if Owner is TqForm then
    TqForm(Owner).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgForceScrollBar);

  if assigned(FOnSingleDataChange) then
  try
    FOnSingleDataChange(self, AField);
  except on E:Exception do
    EProt(self, E, 'OnSingleDataChange', [0]);
  end;
end;

procedure TLNavigator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if (AComponent = TabSet) then
      TabSet := nil else
    if (AComponent = PageBook) then
      PageBook := nil else
    if (AComponent = DetailBook) then
      DetailBook := nil else
    if (AComponent = BtnSingle) then
      BtnSingle:= nil else
    if (AComponent = BtnMulti) then
      BtnMulti := nil;
    if (AComponent = FirstControl) then
      FirstControl := nil;
    if FNavLink <> nil then
      FNavLink.Notification(AComponent,Operation);
  end else
  if Operation = opInsert then
  begin
//    if AComponent is TumDBImage then
//    begin
//      InitPdfImage;
//    end;
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TLNavigator.InitPdfImage(UseDatn: boolean);
//setzt die Verzeichnisse für Gostscript für TPDFImage
//06.03.14 muss noch manuell aufgerufen werden
begin
  Datn.CheckOut(DatnPdfImage);
  Datn.CheckOut(DatnPdfImage + 'lib\');
  Datn.CheckOut(DatnPdfImage + 'fonts\');

  PathToGSDLL := Datn.BaseDir + DatnPdfImage;
  PathToGSLib := Datn.BaseDir + DatnPdfImage + 'lib\';
  PathToGSFonts := Datn.BaseDir + DatnPdfImage + 'fonts\';
end;

procedure TLNavigator.PaintBackGround(Sender: TForm);
var
  X, Y, W, H: LongInt;
begin
  if assigned(FBackGround) then
  begin
    W := FBackGround.Width;
    H := FBackGround.Height;
    Y := 0;
    if (W > 0) and (H > 0) then
      while Y < Sender.Height do begin
        X := 0;
        while X < Sender.Width do begin
          Sender.Canvas.Draw(X, Y, FBackGround);
          Inc(X, W);
        end;
        Inc(Y, H);
      end;
  end;
end;

function TLNavigator.MuDblClick(Sender: TMultiGrid): boolean;
begin
  result := true;
  if dsQuery or dsChangeAll then
  begin
    {stört beim Suchen - ISA md27.03.08
    if GNavigator.X <> nil then
      GNavigator.X.BtnClick(qnbPost);}
  end else
  if ReturnAktiv then
    DoLookUp(lumZeigMsk) else
  if Sender.ReturnSingle and (nlState = nlBrowse) then
    PageIndex := PageIndex mod 10 else                {SetPage('Single') else}
    result := false;
end;

(*** Ereignisse Drucken *********************************************)

procedure TLNavigator.DoPrn;
var                                        {Druckauswahl aufrufen und ausführen}
  Fertig: boolean;
  AForm: TqForm;
  APrnSource: TPrnSource;
  Reports: TValueList;
  I, IReport, PrinterIndex: integer;
  //MaxPSrcIndex: integer;
  FormName, PrinterName, PrinterFont: string;
begin
  if DlgPrn <> nil then
  begin
    DlgPrn.Show;
  end else
  begin
    Fertig := false;
    AForm := Owner as TqForm;
    if (EditSource <> nil) and (EditSource.State in dsEditModes) then  {DPE.VORF.BeforeCancel}
    begin
      DoCancel;            {Vollständiger Abbruch oder Speichern. Mit Bed.Abfrage}
    end else
      (Owner as TqForm).BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF,
        ldCancel);                                  {alle LuDefs Canceln 200400}
    if assigned(FOnPrn) then
      FOnPrn(self, Fertig);                          {Ereignissroutine von OnPrn}
    if not Fertig then
    begin
      if (EditSource <> nil) and (EditSource.State in dsEditModes) then
      begin
        // 'Bitte erst speichern'
        ErrWarn(SLNav_Kmp_002,[0]);                   {Nicht im Editmode}
      end else
      begin                                                    {vergl.Sort Dialog}
        DlgPrn := TDlgPrn.Create(Self);                          {Dialog aufrufen}
        //MaxPSrcIndex := -1;
        try
          DlgPrn.PrnList.Items.Clear;                      {Listen löschen Listen}
          DlgPrn.DevList.Items.Clear;                       {Windows Druckernamen}
          for i:= 0 to AForm.ComponentCount - 1 do         {über alle Komponenten}
          begin
            if AForm.Components[i] is TPrnSource then           {der Richtige Typ}
            begin
              APrnSource := AForm.Components[i] as TPrnSource;          {Variable}
              APrnSource.OneRecord := APrnSource.LoadedOneRecord;
              if not APrnSource.Visible then
                continue;
              if APrnSource.IsFiller then
              begin
                DlgPrn.DevList.Items.Add('');        //Leerzeile
                DlgPrn.PrnList.Items.AddObject(Replicate('-', 250), APrnSource);
              end else
              begin
                PrinterIndex := SysParam.GetPrinterIndex(APrnSource.DruckerTyp,
                  PrinterFont);                             {Index über Namen holen}
                if (PrinterIndex < 0) or (PrinterIndex >= Printer.Printers.Count) then
                  {'Standarddrucker'}
                  PrinterName := SLNav_Kmp_003 else          {sonst Standartdrucker}
                  PrinterName := Printer.Printers[PrinterIndex]; {Printername holen}
                if PrinterFont <> '' then
                  PrinterName := Format('%s,%s', [PrinterName, PrinterFont]);
                DlgPrn.DevList.Items.Add(PrinterName);        {Schreiben des Namens}
                DlgPrn.PrnList.Items.AddObject(APrnSource.Display, APrnSource);
              end;
              //Inc(MaxPSrcIndex);  {:Belegt Überschrift und Verweis auf PrnSource}
              Fertig := true;                               {ein gültiger Eintrag}
              if not APrnSource.Preview then
              begin
                DlgPrn.BtnScr.Default := false;
                DlgPrn.BtnPrn.Default := true;
              end;
            end;
          end;               {Restliche Formulare über die Rechteverwaltung holen}
          FormName := 'FRM' + Uppercase(FormKurz);           {Form Namen aufbauen}
          Reports := KmpRechte.GetReports(FormName);         {Holen von KmpRechte}
          if Reports <> nil then              {ist statischer Pointer: kein free!}
          begin                                     {Überschriften links anzeigen}
            for IReport := 0 to Reports.Count-1 do
              DlgPrn.PrnList.Items.AddObject(Reports.Param(IReport), Reports);
          end;
        finally
          DlgPrn.Dialog;            {immer wg free}
        end;
      end;
    end;
  end;
end;

(*** Ereignisse, Datenbank ****************************************)


procedure TLNavigator.AfterPost;
begin
  if (PageIndex <> BrowsePageIndex) and (BrowsePageIndex >= 0) and
     not (nlNoAutoMulti in Options) and             {wir wollen das nicht}
     ((NavLink.ErfassSingle and (NavLink.EditState = nlInsert)) or    {030500 SDO}
      (NavLink.EditSingle and (NavLink.EditState = nlEdit))) then
  begin
    if not InDetailInsert and //NavLink.InsertFlag then                    {von DetailInsert}
       not InStartReturn and           //qupp.fgebi 28.11.05
       not NavLink.InDoInsert and      {von DoInsert  Zak.Bhae 03.04.02}
       not NavLink.InDoCancel then     {von DoCancel  SDBL 02.05.02}
    begin
      if not NoGotoPos and (NavLink.EditState = nlInsert) and
         (BrowsePageIndex = 10) then
        ReLoad2;                           {QuPE}
      PageIndex := (PageIndex mod 10) + BrowsePageIndex;
    end;
  end;
end;

procedure TLNavigator.AfterCancel;
begin
  //AfterPost;  //GEN.Genehm.BtnProjekt: Page nicht wechseln bei Cancel - 28.01.04
  //27.05.09: ohne ReLoad2 - webab numm
  if (PageIndex <> BrowsePageIndex) and (BrowsePageIndex >= 0) and
     not (nlNoAutoMulti in Options) and             {wir wollen das nicht}
     ((NavLink.ErfassSingle and (NavLink.EditState = nlInsert)) or    {030500 SDO}
      (NavLink.EditSingle and (NavLink.EditState = nlEdit))) then
  begin
    if not InDetailInsert and //NavLink.InsertFlag then                    {von DetailInsert}
       not InStartReturn and           //qupp.fgebi 28.11.05
       not NavLink.InDoInsert and      {von DoInsert  Zak.Bhae 03.04.02}
       not NavLink.InDoCancel then     {von DoCancel  SDBL 02.05.02}
    begin
      PageIndex := (PageIndex mod 10) + BrowsePageIndex;
    end;
  end;
end;

procedure TLNavigator.StateChange(Sender: TObject);
var
  AForm: TqForm;
begin
  if ([csLoading,csDesigning,csDestroying] * ComponentState = []) then
  begin
    NavLink.StateChange(Sender);  {bereits hier wg. CheckReadOnly:TabStop}
    AForm := Owner as TqForm;
    try
      if assigned(OldStateChange) then
        OldStateChange(Sender);
      {if nlState = nlEdit then         hier nicht wg. QueryChanged. in DoEdit
        DoRech(DataSource.DataSet, nil, false, 'StateChange');}

      if (nlState = nlInsert) or
         ((nlState = nlEdit) and
          (AForm.ActiveControl <> nil) and
          ((not AForm.ActiveControl.TabStop) or
           (AForm.ActiveControl is TCustomTabControl) or
           (AForm.ActiveControl is TDBGrid))) then
      begin
        SetActiveLookUpEdit(nil);
        ActiveLookUpDef := nil;
      end;
      if (AForm.ActiveControl <> nil) and
         ((AForm.ActiveControl is TLookupEdit) or (AForm.ActiveControl is TLookupMemo)) then
        SetActiveLookUpEdit(AForm.ActiveControl as TCustomEdit);
      { TODO : AswCheckbox, AswCombobox, AswRadiogroup }

      if not InDetailInsert then
      begin
        if (nlState in nlEditStates) then
        begin
          if not InDetailInsert then
            BrowsePageIndex := (PageIndex div 10) * 10;     {0 oder 10}
        end else
        if (nlState = nlBrowse) then
        begin
          //in After Post    LAWA.MEST 19.08.02
        end else
          BrowsePageIndex := -1;
      end;
      (*if (DataSource <> nil) and not DataSource.AutoEdit then         {30.10.01}
      try
        AEdit := FirstControl;
        if (AEdit <> nil) and (AEdit.CanFocus) then
          AEDit.SetFocus;
      except end; {auch OK. kann nicht fokussieren}
      *)
    except on E:Exception do
      EProt(self, E, 'StateChange(%s)', [OwnerDotName(self)]);
    end;
    if AutoOpen and               {qupe.prob.llprn  26.04.02}
       HasInit and                //ISI - 11.01.07
       (nlState = nlBrowse) and not (Owner is TQRepForm) then
      CheckAutoOpen(false);                                    {180400 ISA.POSI}
  end;
end;

procedure TLNavigator.ReLoad2;
begin
  DataPos.Clear;                 {Bug 26.05.02: Zeile fehlte}
  DataPos.AddFieldsValue(DataSet, PrimaryKeyFields);
  PostMessage((Owner as TForm).Handle, BC_LNAVIGATOR, lnavGotoDataPos, 0);
end;

procedure TLNavigator.GotoDataPos;
begin
  NavLink.Refresh;   //DataSet.Open;
  DataPos.GotoPos(DataSet);
end;

(*** Ereignisse, Bildschirmkontrolle ****************************************)

procedure TLNavigator.TabSetClick(Sender: TObject);
{Clicken auf TabSet z.B. bei Lookup}
var
  TabIndex: integer;
  Titel: string;
  ALookUpDef: TLookUpDef;
  AForm: TqForm;
begin
  if csDesigning in ComponentState then
    Exit;
  if assigned(OldTabSetClick) and not InOldTabSetClick then
  try
    InOldTabSetClick := true;
    OldTabSetClick(Sender);      //muß TabSetClick aufrufen wenn nicht erledigt
  finally
    InOldTabSetClick := false;
  end else
  if TabSetAktiv then
  begin
    if FTabSet <> nil then
    begin
      TabIndex := FTabSet.TabIndex;
      Titel := FTabSet.Tabs.Strings[TabIndex];
    end else
    if FTabControl <> nil then
    begin
      TabIndex := FTabControl.TabIndex;
      Titel := FTabControl.Tabs.Strings[TabIndex];
    end else
      TabIndex := -1;
    if TabIndex >= 0 then
    begin
      //if (TabIndex = 1) and (ReturnAktiv = true) and
      //   (ReturnLookUpModus = lumDetailTab) then
      if TabIndex = TabIndexTake then
      begin
        Take;    {Übernehmen in die Detail-Tabelle des aufrufenden Formulars}
      end else
      //if (TabIndex = 0) and (ReturnAktiv = true) then
      if TabIndex = TabIndexStartReturn then
      begin
        StartReturn;
      end else
      if TabIndex = TabIndexClose then
      begin
        AForm := Owner as TqForm;
        AForm.Close;
      end else
      begin
        if FindLookUpDef(Titel, ALookUpDef) = true then
        begin
          //StartLookUp(lumTab, ALookUpDef);
//          if nlState = nlBrowse then               {07.12.01 QuVA.Lfsk.Auft}
//            StartLookUp(lumZeigMsk, ALookUpDef) else
//          if nlState = nlQuery then
//            StartLookUp(lumSuch, ALookUpDef) else
//            StartLookUp(lumAendMsk, ALookUpDef);  //lumTab  QuPE.erge.vers 27.04.02
          //von LuBtn - 21.12.02
          if ALookUpDef.MDTyp = mdDetail then
          begin
            StartLookUp(lumMasterTab, ALookUpDef);   {Fremdtabelle mit Detailfilter}
          end else
          if nlState = nlQuery then                 //von hier - 21.12.02
          begin
            StartLookUp(lumSuch, ALookUpDef);
          end else
          if nlState in nlEditStates then
          begin
            //13.05.14: Idee: Tabelle zum Übernehmen wenn Feld leer:
            //ALookUpDef.Dataset.Open;
            //if ALookUpDef.Dataset.BOF and ALookUpDef.Dataset.EOF then
            //  StartLookUp(lumTab, ALookUpDef) else  // Starte als Tabelle wenn keine Daten
            StartLookUp(lumAendMsk, ALookUpDef); //Starte als Ändern in Fremdmaske
          end else
          if nlState = nlBrowse then               {07.12.01 QuVA.Lfsk.Auft}
          begin
            StartLookUp(lumZeigMsk, ALookUpDef);
          end;
          //LuBtn
        end else
          ErrWarn(SLNav_Kmp_004,[Titel]);	// 'Click:LookUpDef(%s) fehlt'
      end
    end;
  end;
end;

procedure TLNavigator.SetActiveLookUpEdit(ALuEdit: TCustomEdit);
begin
  FActiveLookUpEdit := ALuEdit; 
end;

function TLNavigator.ActiveLookUpEdit: TDBEdit;
begin
  Result := nil;
  if (FActiveLookupEdit <> nil) and (FActiveLookupEdit is TLookupEdit) then
    Result := TLookupEdit(FActiveLookupEdit);
end;

function TLNavigator.ActiveLookUpMemo: TDBMemo;
begin
  Result := nil;
  if (FActiveLookupEdit <> nil) and (FActiveLookupEdit is TLookupMemo) then
    Result := TLookupMemo(FActiveLookupEdit);
end;

procedure TLNavigator.DoLookUp(lum: TLookUpModus);
(* Allg. LookUp von Button oder Taste *)
var
  ALookUpDef: TLookUpDef;
  AForm: TqForm;
  ALookUpEdit: TLookUpEdit;
  AGrid: TDBGrid;
  AField: TField;
  I: integer;
begin
  ALookUpDef := nil;
  AForm := Owner as TqForm;
  if ReturnAktiv and {Reiter mit Zurück existiert}
     ((EditSource.State = dsBrowse) or
      ((EditSource.State in [dsInsert,dsEdit]) and
       (ReturnLookUpModus = lumAendMsk))) then
  begin
    if (ReturnLookUpModus = lumDetailTab) then
      Take else {übernehmen im Detail Modus}
      StartReturn;  {Normales Übernehmen mit schliesen des Formulars}
  end else
  begin
    if (ActiveLookUpEdit <> nil) then {aktives LookUpEdit}
    begin
      ALookUpDef := TLookUpDef(TLookUpEdit(ActiveLookUpEdit).LookUpSource);
    end else
    if (ActiveLookUpMemo <> nil) then {aktives LookUpEdit}
    begin
      ALookUpDef := TLookUpDef(TLookupMemo(ActiveLookUpMemo).LookUpSource);
    end else
    if (AForm.ActiveControl is TDBGrid) then {Spalte für Lookup im Grid finden}
    begin
      AGrid := TDBGrid(AForm.ActiveControl);
      AField := AGrid.SelectedField; {aktive Spalte}
      if AGrid.DataSource = DataSource then {auf dem Multi}
      begin
        (* select a lookupdef where lookupdef.dataset.mastersource = grid.datasouce and
           selectedfield in lookupdef.dataset.masterfieldnames *)
        for I:= 0 to AForm.ComponentCount-1 do
        begin
          if AForm.Components[i] is TLookUpEdit then
          begin               {suchen nach LookupEdit das der Spalte entspricht}
            ALookUpEdit := AForm.Components[i] as TLookUpEdit;
            if (ALookUpEdit.DataSource = AGrid.DataSource) and
               (ALookUpEdit.DataField = AField.FieldName) then
            begin
              ALookUpDef := ALookUpEdit.LookUpSource;
              break;
            end;
          end;
        end;
      end else {Grid als Detail}
      begin              {Detailtabelle}
        ALookUpDef := AGrid.DataSource as TLookUpDef;
      end;
    end else {kein aktives LookUpEdit und Grid}
    if (AForm.ActiveControl is TLookUpEdit) then
      ALookUpDef := TLookUpDef(TLookUpEdit(AForm.ActiveControl).LookUpSource)
    else if (AForm.ActiveControl is TDBEdit) and
            (TDBEdit(AForm.ActiveControl).DataSource <> DataSource) then
      ALookUpDef := TLookUpDef(TDBEdit(AForm.ActiveControl).DataSource)
    else if (AForm.ActiveControl is TDBMemo) and
            (TDBMemo(AForm.ActiveControl).DataSource <> DataSource) then
      ALookUpDef := TLookUpDef(TDBMemo(AForm.ActiveControl).DataSource)
    else if ActiveLookUpDef <> nil then
      ALookUpDef := ActiveLookUpDef
    else
      ALookUpDef := FindClassComponent(AForm, TLookUpDef) as TLookUpDef;

    if ALookUpDef <> nil then
      StartLookUp(lum, ALookUpDef) else
      // 'LookUp hier nicht verfügbar (%s)'
      ErrWarn(SLNav_Kmp_005,[NavLink.Display]);
  end;
end;

procedure TLNavigator.CheckAutoOpen(OnlyDetail: boolean);
{Table.Active automatisch setzen}
var
  AList: TStringList;
  procedure AddComponent(AComponent: TComponent);
  begin
    if AComponent is TDBEdit then                    {060199}
    begin
      with TDBEdit(AComponent) do                           {TDBEdit}
        if (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource is TLookUpDef) and CanFocus then
        begin
          AList.Add(DataSource.Name);
        end else
        if AComponent is TLookUpEdit then               {TLookUpEdit}
        begin
          with TLookUpEdit(AComponent) do
            if (LookUpSource <> nil) and (LookUpSource.DataSet <> nil) and
               (LookUpSource is TLookUpDef) and CanFocus and
               ((TLookUpDef(LookUpSource).mdTyp = mdDetail) or not OnlyDetail) then
              AList.Add(LookUpSource.Name);
        end;
    end else
    if AComponent is TDBText then                    {090100 SDO}
    begin
      with TDBText(AComponent) do
        if (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource is TLookUpDef) and Parent.CanFocus then
        begin
          AList.Add(DataSource.Name);
        end;
    end else
    if AComponent is TDBMemo then                    {270199}
    begin
      with TDBMemo(AComponent) do
        if (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource is TLookUpDef) and CanFocus then
        begin
          AList.Add(DataSource.Name);
        end else
        if AComponent is TLookUpMemo then
        begin
          with TLookUpMemo(AComponent) do
            if (LookUpSource <> nil) and (LookUpSource.DataSet <> nil) and
               (LookUpSource is TLookUpDef) and CanFocus and
               ((TLookUpDef(LookUpSource).mdTyp = mdDetail) or not OnlyDetail) then
              AList.Add(LookUpSource.Name);
        end;
    end else
    if AComponent is TDBGrid then
    begin
      with TDBGrid(AComponent) do
        if (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource is TLookUpDef) and CanFocus and
           ((TLookUpDef(DataSource).mdTyp = mdDetail) or not OnlyDetail) then
          AList.Add(DataSource.Name);
    end else
    if AComponent is TDBCtrlGrid then                    {03.06.03 RALA3}
    begin
      with TDBCtrlGrid(AComponent) do
        if (DataSource <> nil) and (DataSource.DataSet <> nil) and
           (DataSource is TLookUpDef) and Parent.CanFocus then
        begin
          AList.Add(DataSource.Name);
        end;
    end else
    begin
      {AswCheckBox,...}
    end;
  end;
var
  AForm: TForm;
  I, J: integer;
  B: boolean;
begin { CheckAutoOpen}
  if not InCheckAutoOpen then
  try
    NavLink.DataSourceList.Clear;  // 23.03.09 Query iVm Single->Multi

    InCheckAutoOpen := true;
    AList := TStringList.Create;
    AList.Sorted := true;
    AList.Duplicates := dupIgnore;
    AForm := Owner as TForm;
    for I := 0 to AForm.ComponentCount - 1 do
    begin
      if AForm.Components[I] is TFrame then   //03.10.02 mit TFrame-Unterstützung
      begin
        for J := 0 to TFrame(AForm.Components[I]).ComponentCount - 1 do
          AddComponent(TFrame(AForm.Components[I]).Components[J]);
      end else
      begin
        if CompareText(AForm.Components[I].Name, SysParam.OurLookUpEdit) = 0 then
          Debug0;
        AddComponent(AForm.Components[I]);
      end;
    end;
    {Prot0('PI=%d',[Message.Data]);
     ProtStrings(AList);}
    for I := 0 to AForm.ComponentCount - 1 do
    begin
      if AForm.Components[I] is TLookUpDef then with TLookUpDef(AForm.Components[I]) do
      begin
        if AutoOpen and
           ((DataSource = nil) or (Name <> DataSource.Name)) and
           (DataSet <> nil) then
        begin
          B := true;
          try
            B := AList.IndexOf(Name) >= 0;
          except on E:Exception do
            EProt(DataSet, E, '%s:CheckAutoOpen.List', [OwnerDotName(self)]);
          end;
          if B then
          try
            DataSet.Open;
          except on E:Exception do
            EProt(DataSet, E, '%s:CheckAutoOpen', [OwnerDotName(self)]);
          end else
          if (PageIndex < 10) and not (lnDetailClose in self.Options) and
             (MasterSource = self.DataSource) then
          begin
            //Single-Sicht: Details von Nav geöffnet lassen 28.11.03
          end else
          begin
            DataSet.Close;
          end;
        end;
      end;
    end;
  finally
    AList.Free;
    InCheckAutoOpen := false;
  end;
end;

procedure TLNavigator.CheckDetailInsert;
begin
  if (nlState = nlInsert) and not NavLink.InsertFlag then
    DetailInsert(diPrepare);
end;

procedure TLNavigator.DetailInsert(Modus: TDetailInsertModus);
{Post + Filter auf PKey.        Über alle PKey Segmente 200400}
var
  I: integer;
  ADataPos: TDataPos;
  OldNlState: TNavLinkState;
  S1, NextS: string;
begin
  if (PrimaryKeyList.Count > 0) and not InDetailInsert then
  try
    InDetailInsert := true;                {u.a. für NewBeforeClose}
    if Modus in [diPrepare, diSetFilter] then    {diSetFilter: für Ausdruck bzgl. PrimaryKey QuPE 11.03.02}
    begin
      {if nlState = nlInsert then           190299 quku.rueckl}
        {if DataSet.FieldByName(APKey).IsNull then}
      if not NavLink.InsertFlag then      {250500 auch OK für quku.rueckl ?}
      begin
        NavLink.SaveFltrList.Assign(FltrList);
        NavLink.SaveReferences.Assign(References);
      end;
      try
        NavLink.InsertFlag := true;       {bereits hier für StateChange}
        GNavigator.TmpPrimaryKey := PrimaryKeyFields;
        DoPost;
        if Navlink.nlState <> nlBrowse then  //14.06.10 webab.lbel.Positionseingabe
          SysUtils.Abort;
      except
        NavLink.InsertFlag := false;       {für 2.Speicherversuch und DoCancel#Delete 27.02.04}
        raise;
      end;
      ADataPos := TDataPos.Create;            {muß da ansonsonsten DataSet seine Werte verliert}
      try                            {PrimaryKeyFields -> References}
        if StrParam(GNavigator.TmpPrimaryKey) = TableName then     {Workaround für ORA Blobs nachladen}
        begin
          S1 := PStrTok(StrValue(GNavigator.TmpPrimaryKey), ';', NextS);
          for I := 0 to PrimaryKeyList.Count - 1 do
          begin
            ADataPos.Values[PrimaryKeyList[I]] := S1;
            S1 := PStrTok('', ';', NextS);
          end;
        end else
        begin
          for I := 0 to PrimaryKeyList.Count - 1 do
            ADataPos.Values[PrimaryKeyList[I]] :=
              DataSet.FieldByName(PrimaryKeyList[I]).AsString;
        end;
        References.Assign(ADataPos);
        FltrList.Clear;
      finally
        ADataPos.Free;
      end;
      Refresh;          {statt DataSet.Open wegen Close Abort}
      if DataSet.EOF then
      begin
        Prot0('WARN DetailInsert EOF %s', [OwnerDotName(self)]);
        Protsql(DataSet);
      end;
      if not DataSet.EOF and (Modus <> diSetFilter) then
        DoEdit(true);
      NavLink.InsertFlag := true;                       {erst nach Edit! 090999}
    end else
    if Modus = diRefresh then           {falls PKey während Erfassen geändert wurde HDO.RZep dupl}
    begin
      if NavLink.InsertFlag {and References.Values[APKey] <> ''} then
      try
        References.BeginUpdate;
        for I := 0 to PrimaryKeyList.Count - 1 do
          References.Values[PrimaryKeyList[I]] :=
            DataSet.FieldByName(PrimaryKeyList[I]).AsString;
      finally
        References.EndUpdate;
      end;
    end else
    if Modus in [diReset, diClear] then
    begin                           {150400 auch für Aufruf in DoQuery geeignet}
      if nlState in nlEditStates then
        DoCancel;                   {mit Abfrage. 250400}
      if not (nlState in nlEditStates) then
      begin
        if NavLink.InsertFlag then
        begin
          NavLink.InsertFlag := false;
          OldNlState := nlState;
          ADataPos := TDataPos.Create;
          try                            {PrimaryKeyFields: References -> DataPos}
            for I := 0 to PrimaryKeyList.Count - 1 do
            begin
              if References.Values[PrimaryKeyList[I]] <> '' then
                ADataPos.Values[PrimaryKeyList[I]] := References.Values[PrimaryKeyList[I]];
            end;
            if Modus = diReset then                     {nicht bei Clear (Qnav)}
            begin
              FltrList.Assign(NavLink.SaveFltrList);
              References.Assign(NavLink.SaveReferences);
            end;
            if OldNlState = nlBrowse then          {nicht bei nlQuery}
            begin
//              DataPos.Assign(ADataPos);
//              PostMessage((Owner as TForm).Handle, BC_LNAVIGATOR, lnavGotoDataPos, 0);
              DataSet.Open;
              if not NoGotoPos then
                //if not ADataPos.GotoPosEx(DataSet, [dpoEnableControls{, dpoNoProcessMessages}]) then
                if not ADataPos.GotoPos(DataSet) then
                  Prot0(SLNav_Kmp_006 + CRLF + '%s', // 'DetailInsert(%s.%s):Positionierung schlug fehl'
                  [Owner.ClassName, Name, GetStringsText(ADataPos)]);
            end;
          finally
            ADataPos.Free;
            {NavLink.SaveFltrList.Clear;
            NavLink.SaveReferences.Clear;      erhalten für Debug}
          end;
        end;
      end;
    end;
  finally
    InDetailInsert := false;
  end;
end;

procedure TLNavigator.DoAfterPageChange(APageIndex: Integer);
{Table.Active automatisch setzen. BC_PAGECHANGE Antwort}
begin
  TControlAccess(Owner).Resize;
  if AutoOpen and              //nur wenn Query1 geöffnet oder nicht vorhanden
     ((DataSet = nil) or DataSet.Active) then  // (DataSet <> nil) and DataSet.Active then - 24.07.08
    CheckAutoOpen(nlState = nlInsert);  //focus

  if APageIndex < 10 then      //27.05.10 nach hier von Do Page Change
    DoOnSingleDataChange(nil);

  if Assigned(FAfterPageChange) and
     not (csLoading in ComponentState) then {111199 isa}
    FAfterPageChange(APageIndex);
end;

procedure TLNavigator.DoPageChange(APageIndex: Integer);
begin
  if not (csDesigning in ComponentState) and
     not dsQuery and not dsChangeAll and LoadedOK then
    try
      Inc(PageChangeCounter);
      if Assigned(FOnPageChange) and
         not (csLoading in ComponentState) then {111199 isa}
        FOnPageChange(APageIndex);
      (* beim Wechsel auf Multi wird Mastertabelle wieder komplett angezeigt.
         In TNavLink.DoInsert wurde Master gesichert, und mit Filter auf
         PKey-Value wieder geöffnet. Dieser Filter wird hier wieder entfernt
         und es wird auf den Filterwert positioniert.
      *)
      if csDestroying in ComponentState then
        Exit;  //iVm LuGrid und Single. Erst hier.
      if (APageIndex >= 10) and (nlState = nlBrowse) and NavLink.InsertFlag then
      begin
        DetailInsert(diReset);              {ReOpen + Positioning}
      end else
      if (nlState = nlBrowse) and (NavLink.EditState = nlInsert) and
         (APageIndex >= 10) then
      begin
        {if not NoGotoPos then
          NavLink.ReLoad;                           {QuPE: siehe w.u.}
      end;
      TqForm(Owner).CheckReadOnly;          {040501}
      {if AutoOpen then              weg um Ereignis immer auszulösen 01.11.01}
      PostMessage((Owner as TForm).Handle, BC_PAGECHANGE, APageIndex, 0);
                  {-> DoAfterPageChange}
                  {Muß Postm. sein da sich Detailbook in Pagewechsel befindet}
      PostMessage((Owner as TForm).Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
    except on E:Exception do
      EProt(self, E, 'DoPageChange(%d)',[APageIndex]);
  end;
  if ([csDesigning, csDestroying] * ComponentState = []) and (GNavigator <> nil) then
  try
    if (APageIndex >= 0) and (APageIndex div 10 < Length(StdPages)) then
      GNavigator.PageChanged(StdPages[APageIndex div 10]);
    {if GNavigator <> nil then
      if FPageBook = nil then
        GNavigator.PageChanged(PageBookPage(PageBookStart)) else
        GNavigator.PageChanged(FPageBook.ActivePage);
    if GNavigator <> nil then
      if (FPageControl = nil) or (FPageControl.ActivePage = nil) then
        GNavigator.PageChanged(PageBookPage(PageBookStart)) else
        GNavigator.PageChanged(StdPages[FPageControl.ActivePage.Tag]); }
  except on E:Exception do
    EProt(self, E, 'DoPageChange(%d).GNavigator.PageChanged',[APageIndex]);
  end;
end;

procedure TLNavigator.DetailChange(Sender: TObject; NewTab: Integer;
                                       var AllowChange: Boolean);
var
  APageIndex: integer;
begin
  if not (csDesigning in ComponentState) and not InDetailChange then
  begin
    InDetailChange := true;
    try
      if Assigned(OldDetailChange) then
        OldDetailChange(Sender,NewTab,AllowChange);
      if AllowChange and not NoPageChange then   {Assigned(FOnPageChange) and .. beware}
      begin
        NewDetailPage := NewTab;
        if Assigned(FPageBook) then
          APageIndex := FPageBook.PageIndex * 10 else
          APageIndex := 0;
        Inc(APageIndex, NewTab);
        DoPageChange(APageIndex);
      end;
    except
      on E:Exception do
        ErrWarn('DetailChange:%s',[E.Message]);
    end;
    InDetailChange := false;
  end;
end;

procedure TLNavigator.DetailControlChange(Sender: TObject);
var
  APageIndex: integer;
begin
  if not (csDesigning in ComponentState) and not InDetailChange then
  begin
    InDetailChange := true;
    try
      if Assigned(OldDetailControlChange) then
        OldDetailControlChange(Sender);
      if not NoPageChange then   {Assigned(FOnPageChange) and .. beware}
      begin
        NewDetailPage := FDetailControl.ActivePageIndex;
        if Assigned(FPageControl) and Assigned(FPageControl.ActivePage) then
          APageIndex := FPageControl.ActivePage.Tag * 10
        else if Assigned(FPageBook) then
          APageIndex := FPageBook.PageIndex * 10
        else
          APageIndex := 0;
        Inc(APageIndex, NewDetailPage);
        DoPageChange(APageIndex);
      end;
    except
      on E:Exception do
        ErrWarn('DetailControlChange:%s',[E.Message]);
    end;
    InDetailChange := false;
  end;
end;

procedure TLNavigator.PageChanged(Sender: TObject);
var
  APageIndex: integer;
  PraeFix: string;
  AName: string;
begin
  if not (csDesigning in ComponentState) then
    try
      PraeFix := 'OldPageChanged';
      AName := OwnerDotName(self);
      if assigned(OldPageChanged) then         {vor DoPageChange HLW.AuEr}
        OldPageChanged(Sender);
      if not NoPageChange then            {Assigned(FOnPageChange) and .. beware!}
      begin
        PraeFix := 'DoPageChange';
        if FPageBook = nil then
          APageIndex := 0 else
          APageIndex := FPageBook.PageIndex * 10;
        if FDetailBook <> nil then
          Inc(APageIndex, FDetailBook.PageIndex);
        if FDetailControl <> nil then
          Inc(APageIndex, FDetailControl.ActivePageIndex);
        DoPageChange(APageIndex);
      end;
      PraeFix := 'AfterPageChange';
      if GNavigator <> nil then
        if FPageBook = nil then
          GNavigator.PageChanged(PageBookPage(PageBookStart)) else
          GNavigator.PageChanged(FPageBook.ActivePage);
    except on E:Exception do
      EProt(Application, E, '%s %s',[PraeFix, AName]);  //self kann zerstört sein!
    end;
end;

procedure TLNavigator.PageControlChanged(Sender: TObject);
var
  APageIndex: integer;
  PraeFix: string;
begin
  if csDesigning in ComponentState then
    Exit;
  try
    PraeFix := 'OldPageChanged';
    if assigned(OldPageControlChanged) then         {vor DoPageChange HLW.AuEr}
      OldPageControlChanged(Sender);
    if not NoPageChange then            {Assigned(FOnPageChange) and .. beware!}
    begin
      PraeFix := 'DoPageChange';
      if (FPageControl = nil) or (FPageControl.ActivePage = nil) then
        APageIndex := 0 else
        APageIndex := FPageControl.ActivePage.Tag * 10;
      if FDetailBook <> nil then
        Inc(APageIndex, FDetailBook.PageIndex);
      if FDetailControl <> nil then
        Inc(APageIndex, FDetailControl.ActivePageIndex);
      DoPageChange(APageIndex);
    end;
    if GNavigator <> nil then
      if (FPageControl = nil) or (FPageControl.ActivePage = nil) then
        GNavigator.PageChanged(PageBookPage(PageBookStart)) else
        GNavigator.PageChanged(StdPages[FPageControl.ActivePage.Tag]);
  except
    on E:Exception do
      ErrWarn('%s:%s',[PraeFix, E.Message]);
  end;
end;

function TLNavigator.GetPage: string;
begin
  Result := '';
  if FPageBook <> nil then
  begin
    result := FPageBook.ActivePage;
  end else
  if (FPageControl <> nil) and (FPageControl.ActivePage <> nil) then
  begin
    //result := FPageControl.ActivePage.Name;
    result := StdPages[FPageControl.ActivePage.Tag];
  end;
end;

function TLNavigator.PageBookPage(APage: string): string;
begin
  (*if (StrToIntDef(APage, -1) > -1) and (PageBook <> nil) then
    result := PageBook.Pages[StrToInt(APage)] else
    result := APage;*)
  if StrToIntDef(APage, -1) > -1 then   {numerisch}
  try
    if FPageBook <> nil then
      result := FPageBook.Pages[StrToInt(APage)] else
//    if FPageControl <> nil then       {für Pagecontrol gilt StdPages und Tag}
//    begin
//      //result := FPageControl.Pages[StrToInt(APage)].Name;
//      for I := 0 to FPageControl.PageCount - 1 do
//        if FPageControl.Pages[I].Tag = StrToInt(APage) then
//        begin
//          result := FPageControl.Pages[I].Name;
//          break;
//        end;
//    end else
      result := StdPages[StrToInt(APage)];
  except on E:Exception do
    result := E.Message;
  end else
    result := APage;
end;

procedure TLNavigator.SetPage(NewPage: string);
// Pagebook-Index setzen: Newpage ist 'Multi' oder 'Single'.
// Numerische Werte müssen vorher werden in PageBookPage umgewandelt werden.
var
  I, J: integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if StrToIntDef(NewPage, -1) > -1 then   {LuDef.LuMultiName numerisch - neu 17.06.08 Lawa Faid>ZMes }
  begin
    SetPageIndex(StrToIntDef(NewPage, -1));
  end else
  if NewPage <> '' then
  begin
    if FPageBook <> nil then
    begin
      try
        if FPageBook.ActivePage = NewPage then
          PageChanged(self) else
          FPageBook.ActivePage := NewPage;
      except
        on E:EOutOfMemory do
          ErrException(FPageBook, E);
        on E:Exception do
          EMess(self, E, SLNav_Kmp_007, [NewPage]);	// 'Seite falsch (%s)'
      end;
    end;
    if FPageControl <> nil then
    begin
      try
        for I := low(StdPages) to high(StdPages) do
          if StdPages[I] = NewPage then
          begin
            if (FPageControl.ActivePage <> nil) and
               (FPageControl.ActivePage.Tag = I) then
            begin
              PageControlChanged(self);
            end else
            for J := 0 to FPageControl.PageCount - 1 do
              if FPageControl.Pages[J].Tag = I then
              begin
                FPageControl.ActivePageIndex := J;
                PageControlChanged(self);
                break;
              end;
          end;
//        if CompareText(FPageControl.ActivePage.Name, NewPage) = 0 then
//          PageControlChanged(self) else
//          for I := 0 to FPageControl.PageCount - 1 do
//            if CompareText(FPageControl.Pages[I].Name, NewPage) = 0 then
//            begin
//              FPageControl.ActivePageIndex := I;
//              PageControlChanged(self);
//              break;
//            end;
        {if FPageControl.ActivePage.Name <> NewPage then
          FPageControl.ActivePageIndex := -1;   erzeugt leider keinen Bereichsfehler}
      except
        on E:EOutOfMemory do
          ErrException(FPageControl, E);
        on E:Exception do
          EMess(self, E, SLNav_Kmp_007, [NewPage]);	// 'Seite falsch (%s)'
      end;
    end;
  end;
end;

procedure TLNavigator.SetDetail(NewDetail: string);
var
  APage, ANewPage: string;
  I, VisibleTabIndex: integer;
begin
  if csDesigning in ComponentState then
    Exit;
  if (FDetailBook <> nil) and (NewDetail <> '') then
  begin
    if StrToIntDef(NewDetail, -1) <> -1 then
      NewDetail := FDetailBook.Pages[StrToInt(NewDetail)];
    ANewPage := RemoveAccelChar(NewDetail);
    for I:= 0 to FDetailBook.Pages.Count-1 do
    begin
      APage := RemoveAccelChar(FDetailBook.Pages.Strings[I]);
      if CompareText(APage, ANewPage) = 0 then
      begin
        try
          if FDetailBook.PageIndex = I then
            PageChanged(self) else
            FDetailBook.PageIndex := I;
        except on E:Exception do
            ErrException(FDetailBook, E);
        end;
        exit;
      end;
    end;
  end;
  if (FDetailControl <> nil) and (NewDetail <> '') then
  begin
    if StrToIntDef(NewDetail, -1) <> -1 then
      NewDetail := FDetailControl.Pages[StrToInt(NewDetail)].Caption;
    ANewPage := RemoveAccelChar(NewDetail);
    VisibleTabIndex := -1;
    for I := 0 to FDetailControl.PageCount-1 do
      if FDetailControl.Pages[I].TabVisible then
      begin
        VisibleTabIndex := I;
        break;
      end;
    if VisibleTabIndex = -1 then
    begin
      Prot0('%s.SetDetail(%s): no TabVisible', [OwnerDotName(fDetailControl), NewDetail]);
      Exit;
    end;
    I := 0;
    while I < FDetailControl.PageCount do
    begin
      APage := RemoveAccelChar(FDetailControl.Pages[I].Caption);
      if CompareText(APage, ANewPage) = 0 then
      begin
        try
          if not FDetailControl.Pages[I].TabVisible then
            FDetailControl.ActivePageIndex := VisibleTabIndex;
          if (FDetailControl.ActivePageIndex = I) then
            PageChanged(self) else
            FDetailControl.ActivePageIndex := I;
        except on E:Exception do
          ErrException(FDetailControl, E);
        end;
        exit;
      end;
      Inc(I);
    end;
  end;
end;

function TLNavigator.GetPageIndex: integer;
begin
//    result := FPageControl.ActivePageIndex * 10 else
  if Assigned(FPageBook) then
  begin
    result := FPageBook.PageIndex * 10;
  end else
  if Assigned(FPageControl) then
  begin
    if FPageControl.ActivePage = nil then
      result := -1 else
      result := FPageControl.ActivePage.Tag * 10;
  end else
    result := 0;
  if Assigned(FDetailBook) then
  begin
    if InDetailChange then
      Inc(result, NewDetailPage) else
      Inc(result, FDetailBook.PageIndex);
  end;
  if Assigned(FDetailControl) then
  begin
    if InDetailChange then
      Inc(result, NewDetailPage) else
      Inc(result, FDetailControl.ActivePageIndex);
  end;
end;

type
  TDummyPageControl = class(TPageControl);

procedure TLNavigator.SetPageIndex(Value: integer);
(* Page * 10 + Detail, PageChange Ereignis immer *)
var
  Detail, Page: integer;
  Counter: integer;
  I: integer;
begin
  if not (csDesigning in ComponentState) then
  begin
    Counter := PageChangeCounter;
    if Value >= 0 then                       {HLW 230797}
    begin
      Detail := Value mod 10;
      Page := (Value div 10);
      if (FPageBook <> nil) and (FPageBook.PageIndex <> Page) then
      begin
        {PageBook.PageIndex := Page;}
        SetNoteBookPageIndex(FPageBook, Page);
      end;
      if (FPageControl <> nil) and ((FPageControl.ActivePage = nil) or
                                    (FPageControl.ActivePage.Tag <> Page)) then
      begin
        //FPageControl.ActivePageIndex := Page;
        for I := 0 to FPageControl.PageCount - 1 do
          if FPageControl.Pages[I].Tag = Page then
          begin
            { Aufruf der Ereignisse OnChanging und OnChange der DetailControl }
            if TDummyPageControl(FPageControl).CanChange then
            begin
              FPageControl.ActivePageIndex := I;
              //beware VOKLFrm - TDummyPageControl(FPageControl).Change;
            end;
          end;
      end;
      if (FDetailBook <> nil) and (FDetailBook.PageIndex <> Detail) then
      begin
        FDetailBook.PageIndex := Detail;
      end;
      if (FDetailControl <> nil) and (FDetailControl.ActivePageIndex <> Detail) then
      begin
        { Aufruf der Ereignisse OnChanging und OnChange der DetailControl }
        if TDummyPageControl(FDetailControl).CanChange then
        begin
          FDetailControl.ActivePageIndex := Detail;
          TDummyPageControl(FDetailControl).Change;
        end;
      end;
    end else
      Value := GetPageIndex;
    if Counter = PageChangeCounter then
      DoPageChange(Value);
  end;
end;

procedure TLNavigator.SetBackGround(Value: TBitMap);
begin
  FBackGround.Assign(Value);
end;

procedure TLNavigator.SetSubCaption(const Value: string);
begin
  if FSubCaption <> Value then
  begin
    FSubCaption := Value;
    SetTitel;
  end;  
end;

procedure TLNavigator.SetExtCaption(const Value: string);
begin
  if FExtCaption <> Value then
  begin
    FExtCaption := Value;
    SetTitel;
  end;
end;

procedure TLNavigator.SetReturnLookUpModus(const Value: TLookUpModus);
begin
  if FReturnLookUpModus <> Value then
  begin
    FReturnLookUpModus := Value;
    SetTitel;
  end;
end;

procedure TLNavigator.SetReturnAktiv(const Value: boolean);
begin
  FReturnAktiv := Value;
  SetTabs;
end;

procedure TLNavigator.SetTitel;
(* Setzt Titel von aktuellem Formular
16.09.10 Neustruktur:   Caption [SubCaption] * ExtCaption - Caption2
                                -          - -            -
         SubCaption: '[]'   Caption2:   ' - '   ExtCaption: '*'
         Neues Feld: ExtCaption (extended Caption)
*)
var
  AForm: TqForm;
  Titel, Titel2: TCaption;
  StateIndex: TNavLinkState;
  ADataSource : TDataSource;
  SubCap, ExtCap: string;
begin
  if not (csDesigning in ComponentState) and
     not (Owner is TQRepForm) and
     (Owner is TqForm) and {nur bei TQForm}
     not InSetTitel then
  try
    InSetTitel := true;
    SubCap := self.FSubCaption;  // zwischen []
    ExtCap := StringReplace(self.FExtCaption, ' - ', '-', [rfReplaceAll, rfIgnoreCase]);  // nach * - 29.10.10 qupp.gemiso
    AForm := Owner as TqForm;
    if (GNavigator <> nil) and
       (GNavigator.LNavigator = self) and  {bin ich selbst aktiv}
       (GNavigator.X <> nil) then
      ADataSource := GNavigator.X.DataSource else {funktioniert auch bei Detailtabelle}
      ADataSource := NavLink.ActiveSource; {sonst entweder EditSource oder DaraSource}
    if (ADataSource <> nil) then
    begin
      {if (EditSource is TLookUpDef) and
         (TLookUpDef(EditSource).nlState in [nlEdit,nlInsert]) then
        StateIndex := TLookUpDef(EditSource).nlState else
        StateIndex := nlState;}

      if (ADataSource is TLookUpDef) then {wenn ich in Detailtabelle bin}
      begin
        StateIndex := TLookUpDef(ADataSource).nlState;
        SubCap := StrParam(TLookUpDef(ADataSource).Navlink.Display);  //T=tablename -> T
      end else
        StateIndex := nlState; {nlState Status vom aktiven DataSource}
      Titel2 := NavLinkStateStr[StateIndex];        {Überschrift aufbauen}
    end else
      Titel2 := '';
    Titel := Prots.SubCaption(AForm.ShortCaption, SubCap); {Titel vor '-'}
    Titel := Prots.ExtCaption(Titel, ExtCap); {Titel nach '*'}
    if ReturnAktiv and not BeginsWith(Titel, 'Lookup') then
      Titel := 'Lookup ' + Titel;
    if Assigned(FOnSetTitel) then
      FOnSetTitel(self, Titel, Titel2);
    {neu: 16.09.10
    if Assigned(FOnSetCaption) then
      FOnSetCaption(self, Titel, Titel2);
    }
    AForm.Caption := LongCaption(Titel, Titel2);
  finally
    InSetTitel := false;
  end;
end;

//procedure TLNavigator.FillColumnList;
//// Columnlist anhand FocusControl füllen
//var
//  I: integer;
//  ALabel: TLabel;
//  AFocusControl: TWinControl;
//  L: TValueList;
//  ADBCheckBox: TDBCheckBox;
//  ADBComboBox: TDBComboBox;
//  ADBMemo: TDBMemo;
//  ADBEdit: TDBEdit;
//begin
//  if not (Owner is TForm) then
//    Exit;
//  if DataSource = nil then
//    Exit;
//  ColumnList.BeginUpdate;
//  L := TValueList.Create;
//  try
//    for I := 0 to TForm(Owner).ComponentCount - 1 do
//    begin
//      if TForm(Owner).Components[I] is TDBCheckBox then
//      begin
//        ADBCheckBox := TForm(Owner).Components[I] as TDBCheckBox;
//        if (ADBCheckBox.Caption <> '') and (ADBCheckBox.DataSource = DataSource) and
//           (ADBCheckBox.DataField <> '') then
//          L.Values[ADBCheckBox.Caption] := ADBCheckBox.DataField;
//      end else
//      if TForm(Owner).Components[I] is TLabel then
//      begin
//        ALabel := TForm(Owner).Components[I] as TLabel;
//        if ALabel.Caption <> '' then
//        begin
//          AFocusControl := ALabel.FocusControl;
//          if AFocusControl is TDBEdit then
//          begin
//            ADBEdit := AFocusControl as TDBEdit;
//            if (ADBEdit.DataSource = DataSource) and (ADBEdit.DataField <> '') then
//              L.Values[ALabel.Caption] := ADBEdit.DataField;
//          end else
//          if AFocusControl is TDBMemo then
//          begin
//            ADBMemo := AFocusControl as TDBMemo;
//            if (ADBMemo.DataSource = DataSource) and (ADBMemo.DataField <> '') then
//              L.Values[ALabel.Caption] := ADBMemo.DataField;
//          end else
//          if AFocusControl is TDBComboBox then
//          begin
//            ADBComboBox := AFocusControl as TDBComboBox;
//            if (ADBComboBox.DataSource = DataSource) and (ADBComboBox.DataField <> '') then
//              L.Values[ALabel.Caption] := ADBComboBox.DataField;
//          end;
//        end;
//      end;
//    end;
//    for I := 0 to L.Count - 1 do
//      if ColumnList.Params[L.Value(I)] = '' then
//      begin  //ohne ':' und ',' und '&'
//        ColumnList.Add(RemoveAccelChar(StrCgeChar(StrCgeChar(L[I], ':', #0), ',', #0)));
//      end;
//  finally
//    L.Free;
//    ColumnList.EndUpdate;
//  end;
//end;

(*** LookUp **************************************************************)

procedure TLNavigator.SetReturn(Modus: integer; CallerKurz: string;
  ALookUpDef: TLookUpDef);
{ Definiert "Übernehmen" in LookUp-Formular
   Positioniert in Tabelle
   * für GNav }
var
  UserData: TLookUpUserData;                 {Dekl. in LuDefKmp}
  AForm: TqForm;
  {ALeftTop: TPoint;}
  ALuRect: TRect;
  I, ALeft, ATop, AWidth, AHeight: integer;
begin                                  {vorbereiten des LNav für den Rücksprung}
  if ALookUpDef = nil then
  begin
    Prot0('WARN %s.SetReturn(%d,%s) ALookUpDef=nil', [OwnerDotName(self), Modus, CallerKurz]);
    Exit;
  end;
  UserData := TLookUpUserData.Create(ALookUpDef);
  try
    ReturnKurz := CallerKurz;
    if ALookUpDef <> nil then
    begin
      ReturnLookUpModus := ALookUpDef.LookUpModus;
      ReturnDataPos.Assign(ALookUpDef.DataPos);
      {ReturnTable := ALookUpDef.DataSet as TuTable;}
      ReturnLuName := ALookUpDef.Name;
    end else
    begin
      ReturnLookUpModus := lumZeigMsk;
      ReturnDataPos.Clear;
      ReturnLuName := '';
    end;
    ReturnAktiv := true;
    ReturnLuDef := ALookUpDef;
    AForm := TqForm(Owner);

    (* vor Öffnen *)
    if Modus = 0 then
    begin
      with AForm do
      begin                 {Position bestimmen. Siehe auch TDlgLuGrid.NavStart}
        WindowState := wsNormal;
        if not (lnNoLookupPos in Options) then
        begin
          MinMaxInit := false;
          //11.01.07 ALuRect.TopLeft := Application.MainForm.ScreenToClient(ALookUpDef.LuRect.TopLeft);
          ALuRect.TopLeft := GNavigator.ScreenToClient(ALookUpDef.LuRect.TopLeft);
          ALuRect.BottomRight := ALookUpDef.LuRect.BottomRight;
          ATop := ALuRect.Top;
          ALeft := ALuRect.Left;
          AWidth := Width;
          AHeight := Height;

          //neu: 1.wenns drunter passt dann drunter sonst drüber
          //     2.wenns rechts passt dto. - ab 11.01.07
          if (ATop + ALuRect.Bottom + AHeight <= GNavigator.ClientHeight) or
             (ATop <= GNavigator.ClientHeight div 2) then
            ATop := IMin(ATop + ALuRect.Bottom, GNavigator.ClientHeight - AHeight) else
            ATop := IMax(0, ATop - AHeight);
          if (ALeft + ALuRect.Right + AWidth <= GNavigator.ClientWidth) or
             (ALeft <= GNavigator.ClientWidth div 2) then
            ALeft := IMin(ALeft + ALuRect.Right, GNavigator.ClientWidth - AWidth) else
            ALeft := IMax(0, ALeft - AWidth);
          {if ATop < 0 then
          begin
            AHeight := AHeight + ATop;
            ATop := 0;
          end else
          if ATop + AHeight > GNavigator.ClientHeight then
          begin
            AHeight := GNavigator.ClientHeight - ATop;
          end;
          if ALeft < 0 then
          begin
            AWidth := AWidth + ALeft;
            ALeft := 0;
          end else
          if ALeft + AWidth > GNavigator.ClientWidth then
          begin
            AWidth := GNavigator.ClientWidth - ALeft;
          end;}

          (*if ATop <= AHeight then
            ATop := 0 else                       {0:nur wenn es oberhalb reinpasst}
            ATop := ATop + ALuRect.Bottom;
          if AWidth <= ALeft then
            ALeft := 0 else                         {0:nur wenn es links reinpasst}
            ALeft := ALeft + ALuRect.Right;
          AWidth := iMin(AWidth, GNavigator.ClientWidth);
          AHeight := iMin(AHeight, GNavigator.ClientHeight);
          if ALeft < 0 then
            ALeft := GNavigator.ClientWidth - AWidth else
            ALeft := IMin(ALeft, GNavigator.ClientWidth - AWidth);
          if ATop < 0 then
            ATop := GNavigator.ClientHeight - AHeight else
            ATop := IMin(ATop, GNavigator.ClientHeight - AHeight); *)

          SetBounds(ALeft, ATop, AWidth, AHeight);
          InitWidth := AWidth;
          InitHeight := AHeight;
          SetMinMaxInfo;

          (*MinMaxWidth := AWidth;
          MinMaxHeight := AHeight;
          MaxLeft := GNavigator.ClientWidth - AWidth;
          MaxTop := GNavigator.ClientHeight - AHeight;
          MinMaxInit := true;*)
        end;
      end;
      DataSet.Close;
      if ALookUpDef.LookUpModus in [lumZeigMsk, lumAendMsk] then
      begin
        try                  (* Select *)
          {FltrList.AssignIndexFields(ALookUpDef.DataPos, PrimaryKeyFields); {100597weg    300798 qugl.grst}
          //FltrList.Assign(ALookUpDef.DataPos);     {where Bedingung über DataPos definieren}
          FltrList.Clear;
          //Problem: Es gibt ungültige Filter-Felder wenn von LuDef mit anderem Tablename gestartet (Lawa FaId->LuFMes->FrmZMES)
          //  Lsg.: in Aufruf-LuDef.BeforeLuGrid.DataPos diese Felder entfernen (siehe GEN) 
          FltrList.AssignIndexFields(ALookUpDef.DataPos, '', true);   //19.01.04 sdbl.kusr#sdfr
        except on E:Exception do
	        // 'SetReturn:SQL-Positionierung nicht möglich (%s) in (%s)'
          EMess(self, E, SLNav_Kmp_008,
                   [ErrorFieldName, FormKurz]);
        end;
      end else
      if ALookUpDef.LookUpModus = lumTab then
      begin
        if ALookUpDef.MasterSource <> nil then
        begin
          FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.FltrList,
            false, not (luNoForceNull in ALookupDef.Options));
          References.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.FltrList,
            true, not (luNoForceNull in ALookupDef.Options));
          for I := References.Count - 1 downto 0 do
            if FltrList.IndexOf(References[I]) >= 0 then
              References.Delete(I);     {doppelte löschen}
        end else
        begin
          FltrList.AddStrings(ALookUpDef.FltrList);  {Filter kopieren}
        end;
        {if UserData.HasFltr then}
        FltrList.AddStrings(UserData.FltrList); {else  {User Filter kopieren
                                                    Immer. Wg. References als Fltr}
        if UserData.HasKey then                           {muß in KeyList sein}
        begin
          KeyFields := UserData.KeyFields;
        end else
        if ALookUpDef.KeyFields <> '' then
        begin
          KeyFields := ALookUpDef.KeyFields;
        end;
        if ALookUpDef.NavLink.PermanentKeysAllowed then
          TqForm(AForm).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
            mgLoadKeyList);  {wenn Multi mit KeyInfos: SetKeyFields (BuildSql)}
      end else
      if ALookUpDef.LookUpModus in [lumDetailTab] then
      begin  //Erfassen ab Detailtabelle
        if ALookUpDef.KeyFields <> '' then
        begin
          if ALookUpDef.KeyList.Values['LookUp'] <> '' then        //Spezialsortierung für LookupGrid
            KeyFields := ALookUpDef.KeyList.Values['LookUp']
          else
            KeyFields := ALookUpDef.KeyFields;        {150699}
          //NavLink.InitKeyFields := true;                    //28.02.04
        end;
        if ALookUpDef.MDTyp = mdMaster then         {n:m Zielsource}
        begin
          if ALookUpDef.MasterSource <> nil then
            FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.FltrList, true)
          else
            FltrList.AddStrings(ALookUpDef.FltrList);  {Filter kopieren}
        end else
        if ALookUpDef.ZuoSource = nil then              {<>nil wenn n:m Lookupsource}
        begin
          if ALookUpDef.MasterSource <> nil then        {280299 Filter kopieren}
            FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.FltrList, true) else
            FltrList.AddStrings(ALookUpDef.FltrList);
          FltrList.AddFieldListIsNull(ALookUpDef.DataPos);  //nur noch nicht zugeordnete Details anzeigen
        end;
      end else
      if ALookUpDef.LookUpModus in [lumMasterTab, lumErfassMsk] then
      begin  //Fremdmaske von Detailtabelle, Erfassen von ???
        {FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.References, true);}
        if ALookUpDef.MasterSource <> nil then
          FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.References, false); {16.04.02 QuPE.Anla.VSch}
        if ALookUpDef.KeyFields <> '' then
          KeyFields := ALookUpDef.KeyFields;        {28.02.04}
      end else
      if ALookUpDef.LookUpModus = lumFltrTab then
      begin
        FltrList.AddFltrList(ALookUpDef.MasterSource.DataSet, ALookUpDef.FltrList, true);
      end;

      if NavLink.DBGrid <> nil then
      begin                                    {Bedienerhilfe QuPE 17.04.02}
        (* auch bei Lookup sollen Zeilen markiert werden können,
           auch wen sie nicht alle übernommen werden - 21.12.03 QUPE
        if ReturnLookUpModus in [lumDetailTab, lumMasterTab] then
          NavLink.DBGrid.Options := NavLink.DBGrid.Options + [dgMultiSelect] else
          NavLink.DBGrid.Options := NavLink.DBGrid.Options - [dgMultiSelect];*)
        if NavLink.DBGrid is TMultiGrid then
          TMultiGrid(NavLink.DBGrid).SetOptions(NavLink.DBGrid.Options);
      end;
    end;

    (* nach Öffnen *)
    if Modus = 1 then
    begin
      if ALookUpDef.LookUpModus in [lumTab, lumMasterTab] then  {= lumTab then}
      begin
        if not ALookUpDef.NoGotoPos and not UserData.HasFltr and
           (UserData.HasData or (ALookUpDef.DataPos.ValueCount > 0)) and
           not DataSet.EOF then                          {010299  Dpe.Vsoa.Bhae}
        try
          //weg 27.12.08 CreateAbortDlg(SLNav_Kmp_009);   // 'Positionierung läuft'
          if UserData.HasData then
          begin
            if PosI(UserData.KeyFields, KeyFields) = 1 then
              UserData.DataPos.GotoNearest(DataSet) else  //korrekt sortiert
              UserData.DataPos.GotoPos(DataSet);
          end else
            ALookUpDef.DataPos.GotoPos(DataSet);
        finally
          FreeAbortDlg;
        end;
      end else
      if ALookUpDef.LookUpModus = lumAendMsk then
      begin
        {if ALookUpDef.DataSet.EOF then     080897}
        if ALookUpDef.DataPos.GotoPos(DataSet) then
        begin                            {gefunden}
          NavLink.DoEdit(true);
        end else
        begin
          NavLink.DoInsert(true);
        end;
      end else
      if ALookUpDef.LookUpModus = lumErfassMsk then
      begin
        NavLink.SOList.Assign(ALookUpDef.DataPos);
        NavLink.DoInsert(true);
        {ALookUpDef.DataPos.PutValues(NavLink.DataSet);}
      end else
      if ALookUpDef.LookUpModus = lumSuch then
      begin
        {GNavigator.X.BtnClick(qnbQuery);        so nicht }
      end;

      SetTabs;
      //SetTabIndex(-1);
    end;
  except on E:Exception do
    EMess(DataSet, E, 'SetReturn(%s)', [CallerKurz]);
  end;
  UserData.Free;
end;

procedure TLNavigator.StartReturn;
(* Übernehmen:ReturnDef Starten *)
var
  AForm: TqForm;
  Err: integer;
  ErrStr: string;
begin
  InStartReturn := true; {Flag für doPost}
  Err := 0;
  ErrStr := 'nil';
  try
    AForm := Owner as TqForm;
    ErrStr := AForm.Caption;
    if nlState in nlEditStates then
    begin
      if (ReturnLookUpModus in [lumAendMsk,lumErfassMsk]) then    {240798 lumTab }
      begin
        try
          (Owner as TqForm).BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF,
            ldCancel);                                  {alle LuDefs Canceln 200400}
          NavLink.SetEnable(false, false);     {290798 Optimierung}
          NavLink.DoPost(true);
        except
          NavLink.SetEnable(true, false);
          raise;
        end;
      end else
      begin
        NavLink.ClearEmptyFields(DataSet);
        {raise Exception.Create('Übernahme nur im Anzeigemodus möglich')}
        if NavLink.Modified and not dsQuery and not dsChangeAll then
        begin
          (*case MessageFmt('<<< %s >>>' +CRLF+ 'Daten wurden geändert.' +CRLF+
            'Speichern ?', [AForm.Caption], mtConfirmation, mbYesNoCancel, 0) of
            mrYes: NavLink.DoPost(True);
            mrNo: DataSet.Cancel;
          else
            SysUtils.Abort;
          end;*)
          NavLink.DoPost(true);
        end else
          try
            (Owner as TqForm).BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF,
              ldCancel);                                  {alle LuDefs Canceln 200400}
            NavLink.SetEnable(false, false);    {290798 Optimierung}
            NavLink.DoPost(true);              {zur Sicherheit}
          except
            NavLink.SetEnable(true, false);
            raise;
          end;
      end;
    end;
    if nlState <> nlBrowse then
      EError(SLNav_Kmp_023, [0]);  //'nichts ausgewählt'
    if (ReturnAktiv = true) then
    begin
      GNavigator.ProcessMessages; {alle Postmessages in Rech,AfterPost usw. erledigen. 250400 ISA}
      try                                                                       Err := 100;
        { Datapos mit aktuellen Werten füllen }
        ReturnDataPos.GetValues(DataSet);     {kann auch qbeTable sein}         Err := 101;
        { Grids abschließen: Layout speichern. hier wg. DataSet muß geöffnet sein }
        AForm.BroadcastMessage(self, TMultiGrid, BC_CANCLOSE, 0); {WriteColumns} Err := 102;
        if Assigned(FOnStartReturn) then
        begin
          FOnStartReturn(self);                                                 Err := 103;
        end;
        GNavigator.Return(AForm, ReturnKurz, ReturnLookUpModus, ReturnDataPos,
                          ReturnLuName);                                        Err := 104;
      except on E:Exception do
        EMess(Dataset, E, SLNav_Kmp_010,[AForm.Caption, Err]);	// '%s:Übernahme nicht mehr möglich:%d'
      end;
      AForm.Close;  // finally
    end else
      raise Exception.Create(SLNav_Kmp_011);	// 'Übernahme nicht vorgesehen'
  except on E:Exception do
    EMess(Dataset, E, SLNav_Kmp_012 + CRLF +	// 'Fehler bei Übernahme.'
          'StartReturn(%s):%d', [ErrStr, Err]);
  end;
  InStartReturn := false;
end;

procedure TLNavigator.Take;
(* Übernehmen: Aktueller Record oder Markierte *)
var
  I, N: integer;
begin
  N := 0;
  if NavLink.DBGrid <> nil then
  try
    N := NavLink.DBGrid.SelectedRows.Count;
    for I := 0 to N - 1 do
    begin
      DataSet.Bookmark := NavLink.DBGrid.SelectedRows[I];
      Take1(I < (N - 1));  // true);  02.05.02
    end;
  finally
    try
      NavLink.DBGrid.SelectedRows.Clear;       {Gelöschte Records demarkieren}
    except on E:Exception do
      EProt(self, E, 'Take', [0]);
    end;
  end;
  if N = 0 then       {nix markiert}
  begin
    Take1(false);
    if SysParam.TakeReturn then
      StartReturn;       {Ende wenn global so eingestellt}
  end else
    StartReturn;       {Ende wenn markierte übernommen}
end;

procedure TLNavigator.Take1(Marked: boolean);
(* Übernehmen: nach Caller. Kein Return. Marked:true=kein Refresh *)
var
  ADataPos: TDataPos;
  ZuoSource, RetSource: TLookUpDef;
  OldDetailInsert: boolean;
  OldEditSingle: boolean;
  Done: boolean;
begin
  InStartReturn := true; {Flag für doPost}
  try
    OldDetailInsert := InDetailInsert;
    if nlState in nlEditStates then
    try
      InDetailInsert := true;   {damit kein PageChange u.a.}
      NavLink.ClearEmptyFields(DataSet);
      if NavLink.Modified and not dsQuery and not dsChangeAll then
      begin
//        case MessageFmt('<<< %s >>>' +CRLF+ SLNav_Kmp_013 +CRLF+	// 'Daten wurden geändert.'
//          SLNav_Kmp_014, [AForm.Caption], mtConfirmation, mbYesNoCancel, 0) of	// 'Speichern ?'
//          mrYes: NavLink.DoPost(True);
//          mrNo: DataSet.Cancel;
//        else
//          SysUtils.Abort;
//        end
        {hier ohne Nachfrage speichern  - SDBL 02.05.02}
        NavLink.DoPost(true);
      end else
        NavLink.DoPost(true);              {zur Sicherheit}
    finally
      InDetailInsert := OldDetailInsert;
    end;
    GNavigator.ProcessMessages;                                   {250400 ISA}
    if nlState <> nlBrowse then
      EError(SLNav_Kmp_023, [0]);  //'nichts ausgewählt'
    if (TLookUpDef(ReturnLuDef).ZuoSource <> nil) then
    begin
      (* 1. ZuoMasterSource -> (Zuo.References) -> Zuo
         1a. ZuoMasterSource -> (Zuo.SOList) -> Zuo
         2. LuDef -> (LuDef.References) -> Zuo
         2a. LuDef -> (LuDef.SOList) -> Zuo
      *)
      RetSource := TLookUpDef(ReturnLuDef);
      ZuoSource := RetSource.ZuoSource as TLookUpDef;
      if not (reInsert in ZuoSource.NavLink.TabellenRechte) then
      begin
        EError(SQNav_Kmp_017, [ZuoSource.NavLink.Kennung]);	// 'Sie haben keine Rechte zum Erfassen (%s)'
      end;
      ADataPos := TDataPos.Create;
      try
        Screen.Cursor := crHourGlass;
        ZuoSource.InTake := true;         {Flag für Before/AfterInsert-Methoden}
        try
          //ZuoSource.DataSet.DisableControls;  //md11.12.03 s.u.          
          ZuoSource.NavLink.InDoInsert := true; {für MuGrid. u. Kennz. für BeforePost}
          if ZuoSource.DataSet.State = dsBrowse then
            ZuoSource.NavLink.Insert;    //ab 07.04.04
            //ZuoSource.DataSet.Insert;   bis 07.04.04
          if ZuoSource.MasterSource = nil then
            EError('%s.Mastersource=nil', [OwnerDotName(ZuoSource)]);
          ADataPos.GetValues(ZuoSource.MasterSource.DataSet);              {1.}
          ADataPos.PutReferenceFields(ZuoSource.MasterSource.DataSet,
            ZuoSource.MasterFieldNames, ZuoSource, ZuoSource.IndexFieldNames);
          ZuoSource.GetFields(ZuoSource.SOList);     {ZuoSource.MasterSource -> ZuoSource  1a.}

          ADataPos.Clear;
          ADataPos.GetValues(DataSet);                                     {2.}
          ADataPos.PutReferenceFields(DataSet, RetSource.IndexFieldNames,
            ZuoSource, RetSource.MasterFieldNames);
          RetSource.SOList.PutRefValues(ZuoSource.DataSet, DataSource);    {2a.}

          //ZuoSource.DataSet.EnableControls;   {rechnen} //md11.12.03 qupe.vers.vstosingle
          ZuoSource.NavLink.DoPost(true);      {mit GNav Post und LuDef.BeforePost Ereignis}
          if not Marked then
          begin
            ZuoSource.NavLink.Refresh;   {close,open}
            ZuoSource.DataSet.Last;      {ans Ende gehen}
          end;
        except
          on E:Exception do
          begin
            Screen.Cursor := crDefault;
            EMess(ZuoSource.DataSet, E, SLNav_Kmp_015,[0]);	// 'Zuordnung nicht möglich.'
            ADataPos.GetValues(ZuoSource.DataSet);
            ProtStrings(ADataPos);
            ZuoSource.DataSet.Cancel;
          end;
        end;
        ZuoSource.NavLink.InDoInsert := false;
      finally
        ZuoSource.InTake := false;
        ADataPos.Free;
        Screen.Cursor := crDefault;
      end;
    end else
    begin
      if not (reInsert in TLookUpDef(ReturnLuDef).NavLink.TabellenRechte) then
      begin
        EError(SQNav_Kmp_017, [TLookUpDef(ReturnLuDef).NavLink.Kennung]);	// 'Sie haben keine Rechte zum Erfassen (%s)'
      end;
      {DataSet.DisableControls;      160800 weg damit SO-Fields übernommen werden}
      try
        if (DataSet is TuQuery) and not TuQuery(DataSet).RequestLive then
        begin
          //Edit nicht möglich
        end else
        try                                   {qupe.MatrProb 09.04.02}
          OldEditSingle := EditSingle;
          //DataSet.Edit;
          try                                 //05.01.05 mit DoEdit
            EditSingle := false;
            DoEdit(true);
          finally
            EditSingle := OldEditSingle;
          end;
          if nlState = nlEdit then       //Abfrage. Edit kann verhindert werden (waage 17.08.08)
            ReturnDataPos.PutValues(DataSet);
        except on E:Exception do
          EProt(self, E, 'Datapos', [0]);  //kann vorkommen (qpilot.lpla)
        end;
        if nlState = nlEdit then with TLookUpDef(ReturnLuDef).NavLink do
        try                                   {fremdes Ereignis BeforePost}
          if assigned(OldBeforePost) then     {Query.BeforePost mit unserem Dataset aufrufen}
            OldBeforePost(self.DataSet);      {wichtig für BeforePost: DataSet}
          if assigned(BeforePost) then        {LuDef.BeforePost mit unserem Dataset aufrufen}
          begin
            Done := false;
            BeforePost(self.DataSet, Done);   {wichtig für BeforePost: DataSet - 05.01.05 QUPP}
            if Done then
              self.DataSet.Cancel;
          end;
          self.Commit;
          if not Marked then
          begin
            self.DataSet.Close;
            self.DataSet.Open;
          end;
        except on E:Exception do              {von Parameter verwenden !}
          begin
            if not (E is EAbort) then
            begin
              EProt(DataSet, E, SLNav_Kmp_016, [Display]);  // '%s.Take.OldBeforePost: übergebenes Dataset verwenden !',
              raise;
            end;
          end;
        end;
        if not Marked then
          TLookUpDef(ReturnLuDef).NavLink.Refresh;   {close,open}
      finally
        DataSet.Cancel;
        {DataSet.EnableControls;     160800 weg s.o.}
      end;
    end;
  except on E:Exception do
    begin
      Screen.Cursor := crDefault;
      if not (E is EAbort) then
      begin
        ErrWarn(SLNav_Kmp_017, [E.Message]);	// 'Übernehmen nicht möglich:%s'
        DataSet.Cancel;
      end;
    end;
  end;
  SetTabIndex(-1);
  InStartReturn := false;
end;

procedure TLNavigator.StartLookUp(lum: TLookUpModus; ALookUpDef: TLookUpDef);
(* LookUp Starten. lum:lumAendMsk oder default=lumTab *)
var
  AForm: TqForm;
  MQuery: TDataSet;
  ALookUpEdit: TLookUpEdit;
  AControl: TControl;
  TmpLNav: TLNavigator;
  TmpDbGrid: TMultiGrid;
  TmpFormObj: TqFormObj;
  TmpForm: TqForm;
  Done: boolean;
begin
  if not InStartLookUp then
  try
    InStartLookUp := true;
    AForm := Owner as TqForm;
    if ALookUpDef = nil then
      raise Exception.Create(SLNav_Kmp_018);	// 'ALookUpDef fehlt'
    if GNavigator.X.dsQuery or GNavigator.X.dsChangeAll then  {wenn im Suchmodus}
    begin
      //if GNavigator.X <> nil then
        ALookUpDef.LookUpModus := lumSuch {im Suchmodus}
    end else
    if (ALookUpDef.MasterSource = nil) or
       (ALookUpDef.MasterSource.DataSet = nil) then
    begin
      if lum = lumAendMsk then
        ALookUpDef.LookUpModus := lumZeigMsk else    {nein QDispo.Wagi 070401}
        ALookUpDef.LookUpModus := lum;                     {070799}
    end else
    begin
      {MQuery := DataSet;}
      MQuery := ALookUpDef.MasterSource.DataSet; {Holen von Mastertabelle}
      MQuery.Open;               {kann bei Multi inaktiv sein    quku.prod}
      {nicht von LNav weil über Hierarchien gehen kann}
      {Beladeeinrichtung}
      {MQuery ist Haupttabelle BEIN}
      if (MQuery.State in [dsEdit, dsInsert]) and   {wenn DataSet im SChreibmodus}
         (ALookUpDef.MDTyp = mdMaster) then
      begin
        if lum = lumAendMsk then
          ALookUpDef.LookUpModus := lumAendMsk else
        if lum = lumErfassMsk then
          ALookUpDef.LookUpModus := lumErfassMsk else
        if (lum <> lumDetailTab) and    //xxx?
           (lum <> lumZeigMsk) then     // 23.11.08 testweise ergänzt - webab.todofrm.vorfall anzeigen
          ALookUpDef.LookUpModus := lumTab else
          ALookUpDef.LookUpModus := lum;

        if AForm.ActiveControl is TLookUpEdit then
        begin
          {ALookUpEdit := AForm.ActiveControl as TLookUpEdit;
           ALookUpEdit.UpdateField;      weg 140897 HLW}
        end;
      end else                     {if MQuery.State = dsBrowse or mdDetail then}
      if (lum = lumDetailTab) or
         (lum = lumMasterTab) or (lum = lumFltrTab) then
        ALookUpDef.LookUpModus := lum else                     {setzt den Modus}
      if (ALookUpDef.MDTyp = mdDetail) and (lum = lumAendMsk) then
        ALookUpDef.LookUpModus := lumAendMsk else
      if {(ALookUpDef.MDTyp = mdDetail) and} (lum = lumErfassMsk) then   {150500 GEN}
        ALookUpDef.LookUpModus := lumErfassMsk else
      if (lum = lumAendMsk) then                                {von SingleEdit}
        ALookUpDef.LookUpModus := lum else
      if (lum = lumTab) then                                {QDispo LuAbruf 070401}
        ALookUpDef.LookUpModus := lum else
        ALookUpDef.LookUpModus := lumZeigMsk;
    end;
    if (ALookUpDef.LookUpModus <> lumSuch) then   {nicht im Suchmodus}
    begin
      ALookUpDef.DataSet.Open;   {DataSet ist Sekundärtabelle WERK Positionier auf den Datensatz}
    end;
    if ((ALookUpDef.LookUpModus in [lumZeigMsk]) or {,lumAendMsk 040200 hdo.rohs.dopa}
        ((ALookUpDef.LookUpModus = lumAendMsk) and  {20.01.02 qupe.arbp.proj}
         (ActiveLookUpEdit <> nil) and //?(ActiveLookUpEdit.LookUpSource = ALookUpDef) and
         (leForceEmpty in TLookUpEdit(ActiveLookUpEdit).Options))) and
       ALookUpDef.DataSet.EOF and ALookUpDef.DataSet.BOF then  {080998 qugl.grbu.nutz}
    begin
      ALookUpDef.DataSet.Close;
      ALookUpDef.DataSet.Open;              {300798 qugl.reab}
      {nach GNav#Lookup umgezogen - 19.01.04
      if (ALookUpDef.DataSet.EOF) then
      begin
        EError(SLNav_Kmp_019,[ALookUpDef.NavLink.Display]);
        // 'Anzeige nicht möglich, da Verweis in "%s" fehlt'
      end;}
    end;

    SetTabPage(ALookUpDef.TabTitel); {Register markieren}
    with ALookUpDef do
    begin
      lum := ALookUpDef.LookUpModus;
      {q if ALookUpDef.NavLink.HangingSql then
      begin
        ALookUpDef.BuildSql;
        ALookUpDef.DataSet.Open;
      end;}
      if lum = lumErfassMsk then
      begin
        {ErfassMsk: DataPos in NavLink.DoInsert mit FltrVorgaben gefüllt u.a.}
      end else
      begin
        DataPos.Clear;     {Löschen von DataPos}
        if (MDTyp = MDDetail) and                  {MDTyp MasterDetail-Typ}
           (lum in [lumDetailTab]) then {300798 qugl.reab lumZeigMsk}
        begin
          {DataPos.AddFieldsValue(DataSet, IndexFieldNames);}
          DataPos.GetMasterFields(DataSet, IndexFieldNames,
                                   MasterSource, MasterFieldNames);
        end else
        if (MDTyp = MDDetail) then
           {and not (self.DataSource.State in dsEditModes)  300798 qugl.reab weg}
        begin
          DataPos.AddFieldsValue(DataSet, PrimaryKeyFields);  {170300}
        end else
        if (MDTyp = MDMaster) then {bei Master Trefferliste = 1}
        begin                      {DataPos wird mit Werten gefüllt:}
          DataPos.GetMasterFields(DataSet, IndexFieldNames,
                                   MasterSource, MasterFieldNames);
        end;
      end;
    end; {with ALookUpDef}
    with ALookUpDef do
    begin
      if (AForm.ActiveControl is TLookUpEdit) and (AForm.ActiveControl <> nil) then
      begin
        ALookUpEdit := AForm.ActiveControl as TLookUpEdit;
        {LeftTop := ALookUpEdit.ClientToScreen(Point(0, 0));}
        LuRect.TopLeft  := ALookUpEdit.ClientToScreen(Point(0, 0));
        LuRect.BottomRight := Point(ALookUpEdit.Width, ALookUpEdit.Height);
      end else
      if (AForm.ActiveControl is TControl) and (AForm.ActiveControl <> nil) then
      begin
        AControl := AForm.ActiveControl as TControl;
        {LeftTop := AControl.ClientToScreen(Point(0, 0));}
        LuRect.TopLeft  := AControl.ClientToScreen(Point(0, 0));
        LuRect.BottomRight := Point(AControl.Width, AControl.Height);
        (*if AControl.Width > GNavigator.ClientWidth / 2 then   {unnötig wg 0,0}
          LeftTop.X := -1;                      {rechtsbündig}
        if AControl.Height > GNavigator.ClientHeight / 2 then
          LeftTop.Y := -1;                      {unten}
        *)
      end else
      begin
        {LeftTop := TControl(Owner).ClientToScreen(Point(0, 0));}
        LuRect.TopLeft  := TControl(Owner).ClientToScreen(Point(0, 0));
        LuRect.BottomRight := Point(TControl(Owner).Width, TControl(Owner).Height);
      end;
    end;
    if (ALookUpDef.LookUpTyp = lupGrid) and   {Grid wird im Hauptspeicher angelegt}
       (ALookUpDef.LookUpModus in [lumTab,lumDetailTab]) then
    begin
      ALookUpDef.LookUpGrid;      // erkennt ob dieses LuGrid bereits offen
    end else
    begin  {Wechsel der Maske über GNav}
      //Testen ob Formular in Verwendung. Wenn ja dann mit LuGrid weiter.
      TmpLNav := nil;
      TmpDbGrid := nil;
      Done := false;
      TmpFormObj := GNavigator.GetFormObj(ALookUpDef.LuKurz, false, false);
      if not assigned(TmpFormObj) then
        EError('Lookup "%s" nicht verfügbar', [ALookUpDef.LuKurz]);
      TmpForm := TmpFormObj.Form;
      if TmpForm <> nil then
        TmpLNav := FormGetLNav(TmpForm);
      if (TmpLNav <> nil) and (TmpLNav.NavLink.DbGrid is TMultiGrid) then
      begin
        TmpDbGrid := TMultiGrid(TmpLNav.NavLink.DbGrid);
        // 27.01.10 auf Datenposition testen
        if TmpLNav.ReturnAktiv and (TmpLNav.ReturnLuDef = ALookUpDef) and
           ALookUpDef.DataPos.IsPos(TmpLNav.Dataset) then
           //korrekt positioniert
        begin      // erkennt ob Fremdmaske bereits für uns offen
          TmpDbGrid := nil;
          Done := true;
          TmpForm.BringToFront;
          TmpForm.SetFocus;
        end;
      end;

      if not Done and (ALookUpDef.LookUpModus in [lumTab,lumDetailTab]) and
         (TmpDbGrid <> nil) then
      try
        Done := true;
        ALookUpDef.ColumnList.Assign(TmpDbGrid.ColumnList);
        ALookUpDef.LookUpGrid;
      except on E:Exception do
        begin
          Done := false;
          EProt(self, E, 'TryLuGrid', [0]);
        end;
      end;
      if not Done then
      begin
        ALookUpDef.DoBeforeLookUp;
        GNavigator.LookUp(self, ALookUpDef, ALookUpDef.LuKurz);
        ALookUpDef.DoAfterLookUp;
      end;
    end;
  except on E:Exception do begin
      //EProt(ALookUpDef.DataSet, E, 'StartLookUp(%s)', [OwnerDotName(self.ClassName]);  //silent wg Eventbeendung
      EMess(self, E, 'StartLookUp(%s)', [OwnerDotName(ALookupDef)]);  //Msg wg zak.EREC.LuVORF
      if E is EUniError then
        ProtSql(ALookUpDef.DataSet);
    end;
  end;
  InStartLookUp := false;
end;

procedure TLNavigator.DoAfterReturn(Sender: TObject; LookUpModus: TLookUpModus;
                                    LookUpDef: TLookUpDef);
var
  AForm: TqForm;
begin
  NavLink.InAfterReturn := true;  {für MuGri.BCStateChange}
  AForm := nil;
  try
    AForm := Owner as TqForm;
    SetTabIndex(-1);
    AForm.SetFocus;
    //10.10.12 alle von LookUpDef abhängigen Lookups refreshen:
    AForm.BroadcastMessage(LookUpDef, TLookUpDef, BC_LOOKUPDEF,
      ldSubRefresh);                          {alle abhängigen LuDefs refreshen}
    if LookUpDef <> nil then
    begin
      LookUpDef.HangingReturn := false;
      LookUpDef.DoAfterReturn(LookUpModus);                  {ruft Ereignis auf}
    end;
    if assigned(FAfterReturn) then
    begin
      FAfterReturn(Sender, LookUpModus, LookUpDef);
    end;
  except on E:Exception do
    EMess(AForm, E, SLNav_Kmp_012, [0]);   //'Fehler bei Übernahme.'
  end;
  NavLink.InAfterReturn := false;
end;

(*** Hilfsfunktionen Tabset *********************************************)

procedure TLNavigator.SetTabIndex(AIndex: integer);
{Markieren des aktiven Tabs bei -1 deaktivieren}
begin
  if not (csDesigning in ComponentState) then
  begin
    if FTabSet <> nil then
    try
      TabSetAktiv := false;
      FTabSet.TabIndex := AIndex;
    finally
      TabSetAktiv := true;
    end;
    if FTabControl <> nil then
    try
      TabSetAktiv := false;
      FTabControl.TabIndex := AIndex;
    finally
      TabSetAktiv := true;
    end;
  end;
end;

procedure TLNavigator.SetTabPage(APage: string);
begin
  if FTabSet <> nil then
  begin
    SetTabIndex(FTabSet.Tabs.IndexOf(APage));
  end;
  if FTabControl <> nil then
  begin
    SetTabIndex(FTabControl.Tabs.IndexOf(APage));
  end;
end;

procedure TLNavigator.SetTabs;
  function NiceTab(S: string): string;
  begin
    if NoAccelCharInTabs then
      Result := RemoveAccelChar(S) else
      Result := S;
  end;
  function TTl(Kat: integer; Save: boolean): string;
  // Tab Title:
  begin
    if SysParam.TabsBelegung = 0 then
    begin
      case Kat of
      0: if Save then Result := SLNav_Kmp_021 else Result := SLNav_Kmp_020;
      1: if Save then Result := SLNav_Kmp_021 else Result := SLNav_Kmp_020;
      2: if Save then Result := SLNav_Kmp_020 else Result := SSql_Dlg_001;
      end;
    end;
    if SysParam.TabsBelegung = 1 then
    begin
      if Save then Result := SOKButton else Result := SCancelButton;
    end;

  end;
var
  AForm: TForm;
  I:Integer;
begin
  if not (csDesigning in ComponentState) then
  begin
    if Titles = nil then
      ErrWarn('Titles:nil',[nil]) else
    if Owner = nil then
      ErrWarn('Owner:nil',[nil]) else
    begin
      AForm := Owner as TForm;
      Titles.Clear;
      TabIndexStartReturn := -1;
      TabIndexTake := -1;
      TabIndexClose := -1;
      if ReturnAktiv = true then
      begin
        { SysParam.Tabs[lumKat, boolean] lumKat(lukDetail, lukMaster, lukFremd)
          SysParam.TabsModus 0=Standard 1=Ok/Abbrechen 2=?
        }
        if ReturnLookUpModus in [lumDetailTab] then
        begin  //12.06.14 vertauscht
          TabIndexTake :=        Titles.Add(NiceTab(TTl(0, true)));	  // '&Übernehmen' - OK
          TabIndexStartReturn := Titles.Add(NiceTab(TTl(0, false)));	// '&Zurück' - Abbrechen
        end else
        if ReturnLookUpModus in [lumTab,lumAendMsk] then
        begin
          TabIndexStartReturn := Titles.Add(NiceTab(TTl(1, true)));	  // '&Übernehmen' - OK
          TabIndexClose :=       Titles.Add(NiceTab(TTl(1, false)));	// '&Zurück' - Abbrechen
        end else
        begin  //lumZeigMsk,lumErfassMsk,lumSuch,lumMasterTab,lumFltrTab
          TabIndexStartReturn := Titles.Add(NiceTab(TTl(2, true)));	  // '&Zurück' - OK
          TabIndexClose :=       Titles.Add(NiceTab(TTl(2, false)));	// 'Schließen' - Abbrechen
        end;
      end;
      for I:= 0 to AForm.ComponentCount - 1 do
      begin
        if AForm.Components[i] is TLookUpDef then
          with AForm.Components[i] as TLookUpDef do
            if Enabled and (TabTitel <> '') and (Char1(TabTitel) <> ';') and
              //beware! warum? webab.aufg -  nicht wenn Form da - 03.10.10
              //             weil sie in Webab.aufg *immer* angezeigt werden sollen
              //             Lsg: nur im Lookup-Modus nicht anzeigen
              ((GNavigator.GetForm(LuKurz) = nil) or (not ReturnAktiv)) then
              Titles.Add(StrDflt(Navlink.TrTabTitel, TabTitel));
      end;
      if FTabSet <> nil then
      try
        TabSetAktiv := false;
        FTabSet.Tabs.Assign(Titles);
      finally
        TabSetAktiv := true;
      end;
      if FTabControl <> nil then
      try
        TabSetAktiv := false;
        if FTabControl.TabPosition <> tpTop then
        begin  //kann keine &-Accells darstellen
          for I := 0 to Titles.Count - 1 do
            Titles[I] := RemoveAccelChar(Titles[I]);
        end;
        FTabControl.Tabs.Assign(Titles);
      finally
        TabSetAktiv := true;
      end;
    end;
  end;
  SetTabIndex(-1);
end;

(*** Controls finden *****************************************************)

function TLNavigator.FindLookUpDef(ATabTitel:string;
  var ALookUpDef: TLookUpDef): boolean;
// findet auch Übersetzte Titel
var
  AForm: TForm;
  I: Integer;
begin
  result := false;
  AForm := Owner as TForm;
  for I:= 0 to AForm.ComponentCount - 1 do
    if AForm.Components[i] is TLookUpDef then
    begin
      if (TLookUpDef(AForm.Components[i]).TabTitel = ATabTitel) or
         (TLookUpDef(AForm.Components[i]).Navlink.TrTabTitel = ATabTitel) then
      begin
        ALookUpDef := TLookUpDef(AForm.Components[i]);
        result := true;
        break;
      end;
    end;
end;

function TLNavigator.GetDetailBook: TCustomTabControl;
begin
  if FDetailBook <> nil then
    result := FDetailBook else
    result := FDetailControl;
end;

procedure TLNavigator.SetDetailBook(const Value: TCustomTabControl);
begin
  if Value = nil then
  begin
    FDetailBook := nil;
    FDetailControl := nil;
  end else
  if Value is TTabbedNoteBook then
  begin
    FDetailBook := TTabbedNoteBook(Value);
    FDetailControl := nil;
  end else
  if Value is TPageControl then
  begin
    FDetailControl := TPageControl(Value);
    FDetailBook := nil;
  end else
  begin
    FDetailBook := nil;
    FDetailControl := nil;
  end;
end;

function TLNavigator.GetPageBook: TWinControl;
begin
  if FPageBook <> nil then
    result := FPageBook else
    result := FPageControl;
end;

procedure TLNavigator.SetPageBook(const Value: TWinControl);
begin
  if Value = nil then
  begin
    FPageBook := nil;
    FPageControl := nil;
  end else
  if Value is TNoteBook then
  begin
    FPageBook := TNoteBook(Value);
    FPageControl := nil;
  end else
  if Value is TPageControl then
  begin
    FPageControl := TPageControl(Value);
    FPageBook := nil;
  end else
  begin
    FPageBook := nil;
    FPageControl := nil;
  end;
end;

procedure TLNavigator.SetPageBookStart(const Value: string);
begin
  FPageBookStart := Value;
  if InOnStart then
  begin
    SetPage(PageBookPage(FPageBookStart));
  end;
end;

procedure TLNavigator.SetDetailBookStart(const Value: string);
begin
  FDetailBookStart := Value;
  if InOnStart then
  begin
    SetDetail(FDetailBookStart);
  end;
end;

procedure TLNavigator.SetOptions(const Value: TLNavOptions);
var
  aForm: TqForm;
begin
  FOptions := Value;
  if (Owner <> nil) and (Owner is TqForm) then
  begin
    aForm := Owner as TqForm;
    if lnEnterAsTab in Options then
    begin
      aForm.KeyPreview := true;
      aForm.EnterAsTab := true;  //fängt KeyDown ab
    end;
  end;
end;

function TLNavigator.GetTabSet: TWinControl;
begin
  if FTabSet <> nil then
    result := FTabSet else
    result := FTabControl;
end;

procedure TLNavigator.SetTabSet(const Value: TWinControl);
begin
  if Value = nil then
  begin
    FTabSet := nil;
    FTabControl := nil;
  end else
  if Value is TTabSet then
  begin
    FTabSet := TTabSet(Value);
    FTabControl := nil;
  end else
  if Value is TTabControl then
  begin
    FTabControl := TTabControl(Value);
    FTabSet := nil;
  end else
  begin
    FTabSet := nil;
    FTabControl := nil;
  end;
end;

{ FormValue }

function TLNavigator.GetFormValue(ParamName: string): string;
begin
  Result := FFormValues.Values[ParamName];
  if assigned(OnGetFormValue) then
    OnGetFormValue(self, ParamName, Result);
end;

procedure TLNavigator.SetFormValue(ParamName, Value: string);
var
  S: string;
begin
  S := Value;
  if assigned(OnSetFormValue) then
    OnSetFormValue(self, ParamName, S);
  FFormValues.Values[ParamName] := S;
end;

end.

