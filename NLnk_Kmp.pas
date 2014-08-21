unit NLnk_Kmp;
(* Gemeinsamer Bereich für QBENav, Gnavigator, LNavigator und LookUpDef
   07.06.11  UniDAC
   12.03.12  Top bzw Rownum in Ora: SqlHint
   17.04.12  Form kann nil sein, d.h. TDataModule oder TForm. Nur TqForm gültig
   14.05.12  LuDef.DeleteAll: mit Events wenn OnDelete/BeforeDelete zugeordnet (kein Sql direkt)
   25.04.13  GetRecordCount deaktiviert. Jetzt direkt von UniDAC (QueryRecCount!)
   12.06.13  AppendFlag
   16.05.14  "Zuordnung entfernen?"
   13.06.14  AssignAswName
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB,  Uni, DBAccess, MemDS, StdCtrls, DBGrids,
  VirtualTable,
  DPos_Kmp, RechtKmp, KmpResString, UQue_Kmp, UTbl_Kmp, UMem_Kmp;

const
  sStandardKey = 'Standard';
  sKeyFields = 'KeyFields';
const
  //Nav.Navlink.RechSender
  rsCalcFields = 'CalcFields';
  rsDataChange = 'DataChange';
  rsDoEdit = 'DoEdit';
  rsDoInsert = 'DoInsert';

type
  TNavLink = class;  {forward}

  (* von QbeNav *)
  TQbeNavigateBtn = (qnbQuery, qnbFirst, qnbPrior, qnbNext, qnbLast,
                  qnbReadOnly, qnbInsert, qnbDelete, qnbEdit,
                  qnbPost, qnbCancel, qnbRefresh);
  TQbeButtonSet = set of TQbeNavigateBtn;

  TMDTyp = (mdMaster,mdDetail);
  TNavLinkState = (nlInactive, nlBrowse, nlEdit, nlInsert, nlSetKey, nlCalcFields,
                   nlUpdateNew, nlUpdateOld, nlFilter,
                   nlCurValue, nlBlockRead, nlInternalCalc, nlOpening,
                   nlQuery, nlChangeAll);

  TFieldFlag = (ffReadOnly, ffRequired, ffClear,
                ffNotReadOnly, ffNotRequired);
  TFieldFlags = set of TFieldFlag;

  TMsgTyp = (mtWMessConfirmation, mtWMessInformation);
  TBuildSqlEvent = procedure(DataSet: TDataSet; var OK: boolean; var fertig: boolean)
                   of Object;
  TBeforeNotifyEvent = procedure(ADataSet: TDataSet; var Done: boolean) of Object;
  TRechEvent = procedure(ADataSet: TDataSet; Field: TField; OnlyCalcFields: boolean) of Object;
  TMsgEvent = procedure(Sender: TNavLink; MsgTyp: TMsgTyp; MsgNr: longint;
                         MsgText: string; var MsgResult: word) of Object;
{$ifdef WIN32}
{$else}
  TDataAction = (daFail, daAbort, daRetry);
  TDataSetErrorEvent = procedure(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction) of object;
{$endif}

  TNavLink = class(TObject)
  private
    { Private-Deklarationen }
    TmpDataPos : TDataPos;
    FMasterAktiv: boolean;            {für New Before Open}
    FCalcOK: boolean;
    FdsQuery: boolean;
    FdsChangeAll: boolean;
    FNoBuildSql: boolean;
    FRecordCount: longint;
    InGetReferences: boolean;

    FAutoCommit: boolean;               {für beforepost, für LNav.Pos}
    FAutoOpen: boolean;            {Automatisches Open wenn nachzuladen}
    FConfirmDelete: Boolean;
    FNoOpen: boolean;
    FNoGotoPos: boolean;
    FErfassSingle: boolean;        {true = Erfassen auf Single umschalten}
    FEditSingle: boolean;          {true = Ändern: auf Single umschalten}
    FMDTyp: TMDTyp;             {Master/Detail}
    FDataPos: TDataPos;
    FDataSource: TDataSource;
    FEditSource: TDataSource;
    FCalcList: TValueList;
    FChangeList: TValueList;
    FDBGrid: TDBGrid;
    FColumnList: TValueList;    {Spalten für Lookup Tabelle}
    FFltrList: TFltrList;
    FFormatList: TValueList;
    FBemerkung: TStringList;
    FKeyFields: string;
    FKeyList: TValueList;
    FPrimaryKeyFields: string;
    FReferences: TFltrList;
    FSOList: TFltrList;                 {Synonymliste}
    FSqlFieldList: TValueList;
    FSqlHint: string;                   //wird hinter select plaziert
    FTableName: string;
    FTabTitel: string;                  {Titel des Tabset.Tabs/Lnavs}
    FPrimaryKeyList: TValueList;
    FKeyFieldList: TValueList;
    FTableList: TValueList;
    FLookUpSource: TDataSource;
    FDisabledButtons: TQbeButtonSet;    {QBE Buttons manuell deaktivieren}
    FEnabledButtons: TQbeButtonSet;     {QBE Buttons manuell aktivieren}
    FTabellenRechte: TRechteSet;

    FOnValidate: TFieldNotifyEvent;
    FOnRech: TRechEvent;
    FOnGet: TDataSetNotifyEvent;
    FOnErfass: TNotifyEvent;
    FOnBuildSql: TBuildSqlEvent;
    FOnMsg: TMsgEvent;
    FBeforeQuery: TBeforeNotifyEvent;
    FBeforeEdit: TBeforeNotifyEvent;
    FBeforeInsert: TBeforeNotifyEvent;
    FBeforePost: TBeforeNotifyEvent;
    FBeforeCancel: TBeforeNotifyEvent;
    FBeforeDelete: TBeforeNotifyEvent;
    FBeforeDeleteMarked: TBeforeNotifyEvent;
    FOnPostError: TDataSetErrorEvent;
    FOnDeleteError: TDataSetErrorEvent;
    FUseFltrList: boolean;

    procedure NewBeforeOpen(ADataSet: TDataSet);
    procedure NewAfterOpen(ADataSet: TDataSet);
    procedure NewAfterScroll(ADataSet: TDataSet);
    procedure NewBeforeClose(ADataSet: TDataSet);
    procedure NewCalcFields(ADataSet: TDataset);
    procedure NewDataChange(Sender: TObject; Field: TField);
    {Umbiegung von OnDataChange von DataSource}
    procedure NewBeforeInsert(ADataSet: TDataset);
    procedure NewAfterInsert(ADataSet: TDataset);
    procedure NewBeforePost(ADataSet: TDataSet);
    procedure NewBeforeDelete(ADataSet: TDataSet);
    procedure NewAfterPost(ADataSet: TDataSet);
    procedure NewAfterCancel(ADataSet: TDataSet);

    procedure DoPostEx(Level: integer);
    function GetStaticFields: boolean;
    procedure SetStaticFields(Value: boolean);
    procedure SetInsertFlag(Value: boolean);
    function GetRecordCount: longint;

    function GetActiveSource: TDataSource;          {liefert den aktiven Source}
    function GetNlState: TNavLinkState;       {gibt den DatSource-Status zurück}
    function GetKennung: string;          {Liefert Kennung für Rechteverwaltung}
    procedure SetCalcOK(Value: boolean);
    procedure SetNoBuildSql(Value: boolean);
    function GetDataSet: TDataSet;
    procedure SetDataSet(Value: TDataSet);
    function GetQuery: TuQuery;
    function GetTable: TuTable;
    function GetInEdit: boolean;
    function GetForm: TForm;
    function GetLNav: TObject;
    procedure SetDataSource(Value: TDataSource);
    function GetEditSource: TDataSource;
    procedure SetDataPos(Value: TDataPos);
    procedure DataPosChange(Sender: TObject);
    procedure SetCalcList(Value: TValueList);
    procedure CalcListChange(Sender: TObject);
    procedure SetChangeList(Value: TValueList);
    procedure SetColumnList(Value: TValueList);
    procedure ColumnListChange(Sender: TObject);
    procedure SetFltrList(Value: TFltrList);
    procedure FltrListChange(Sender: TObject);
    procedure SetFormatList(Value: TValueList);
    procedure SetBemerkung(Value: TStringList);
    procedure FormatListChange(Sender: TObject);
    procedure SetKeyFields(Value: string);
    procedure SetKeyList(Value: TValueList);
    procedure SetLookUpSource(Value: TDataSource);
    function GetPrimaryKeyFields: string;
    procedure SetPrimaryKeyFields(Value: string);
    function GetReferences: TFltrList;
    procedure SetReferences(Value: TFltrList);
    procedure SetSOList(Value: TFltrList);
    procedure ReferencesChange(Sender: TObject);
    procedure SetSqlFieldList(Value: TValueList);
    procedure SqlFieldListChange(Sender: TObject);
    procedure SetTableName(Value: string);
    procedure SetMasterSource(Value: TDataSource);
    function GetMasterSource: TDataSource;
    function GetMasterFieldNames: string;
    function GetIndexFieldNames: string;
    procedure DoDeleteEx(aDataset: TDataset; Level: integer);
    procedure SetInitKeyFields(const Value: boolean);
    procedure SetTabellenRechte(const Value: TRechteSet);
    procedure SetDisabledButtons(const Value: TQbeButtonSet);
    procedure SetEnabledButtons(const Value: TQbeButtonSet);
    function GetLiveRequest: boolean;
    procedure SetLiveRequest(const Value: boolean);
    function GetMultiGrid: TDBGrid;
    function GetNoOpenSMess: boolean;
    procedure CheckTablePrefix;
    procedure CheckKeyFields(SqlSensitive: boolean);
    procedure BuildSOList1;
    function GetSOList: TFltrList;
    procedure CacheCalcFields(ADataSet: TDataset; Modus: integer);
    procedure SetUseFltrList(const Value: boolean);
    procedure SetSqlHint(const Value: string);
    procedure CheckFltrFields;
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    OldCalcFields: TDataSetNotifyEvent;
    OldBeforeInsert: TDataSetNotifyEvent;
    OldAfterInsert: TDataSetNotifyEvent;
    OldAfterOpen: TDataSetNotifyEvent;
    OldAfterScroll: TDataSetNotifyEvent;
    OldBeforeOpen: TDataSetNotifyEvent;
    OldBeforeClose: TDataSetNotifyEvent;
    OldBeforePost: TDataSetNotifyEvent;
    OldBeforeDelete: TDataSetNotifyEvent;
    OldAfterPost: TDataSetNotifyEvent;
    OldAfterCancel: TDataSetNotifyEvent;

    Owner: TComponent;
    MemTable: TuMemTable;                 {für QNav}
    SaveDataSet: TuQuery;                      {für QNav}
    DataSourceList: TList;                    {für QNav}
    ReadOnlyList: TList;                      {für QNav}
    LoadedFltrList : TFltrList;
    LoadedReferences: TFltrList;
    SaveFltrList : TFltrList;                 {für DetailInsert}
    SaveReferences: TFltrList;                {für DetailInsert}
    SortList: TFltrList;                      {Sort Dlg}
    LoadedKeyFields: string;
    PermanentKeysAllowed: boolean;
    LoadedRequestLive: boolean;
    OldRequestLive: boolean;
    Display: string;
    TrTabTitel: string;                       //enthält Übersetzung von TabTitel (falls aktiv)
    InAddCalcFields: boolean;
    InCalcFields: boolean;
    InBuildSql, InOnBuildSql: boolean;
    InDataChange: boolean;
    InDoInsert: boolean;
    InDoEdit: boolean;
    InDoPost, InDoPostEx: boolean;
    InDoCancel: boolean;
    InDoDelete, InDoDeleteMarked: boolean;
    InInsertCancel: boolean;
    InEditCancel: boolean;
    InBeforeCancel: boolean;
    InBeforeEdit: boolean;               {Ereignis BeforeEdit nicht 2mal aufrufen}
    InBeforeInsert: boolean;             {Ereignis BeforeInsert nicht 2mal aufrufen}
    InBeforePost: boolean;               {Ereignis BeforePost nicht 2mal aufrufen}
    InNewBeforePost: boolean;
    InOldBeforePost: boolean;            {Ereignis DataSet.BeforePost nicht 2mal aufrufen}
    InNewAfterOpen: boolean;
    InAfterPost: boolean;
    InAfterCancel: boolean;
    InBeforeClose: boolean;              {Ereignis DataSet.BeforeClose nicht 2mal aufrufen}
    InDoValidate: boolean;
    InRecordCount: boolean;
    InOnRech: boolean;
    InBeforeDelete, InBeforeDeleteMarked: boolean;
    InSqlFieldListChange: boolean;
    InRefresh: boolean;
    InMuKeyDown: boolean;
    InAfterReturn: boolean;
    InClearEmptyFields: boolean;  //ChangedField nicht schreiben
    ErrorFieldName: string;                                       {für buildsql}
    HangingSql: boolean;                                    {i.V.m. NoBuildSqql}
    Modified: boolean;
    HangingLookUp: boolean;
    HasRecordCount: boolean;
    NoTransaction: boolean;
    NullParam: boolean;
    FInsertFlag: boolean;
    pmDataChange: boolean;             {BCDataChange über PostMessage abwickeln}
    KeyIndex: integer;                                              {für LuEdit}
    CalcCacheList: TValueList;                               {CalcFields Cachen}
    ChangedFields: TStringList;          {Liste geänderter Felder=OldValue}
    ConfirmCancel: Boolean;              {vergl. ConfirmDelete.}
    DuplicateFlag: Boolean;              {für Erfass-Ereignis: Duplizieren.}
    EditState: TNavLinkState;            {für AfterPost o.ä. zum Erkennen ob von Insert oder Edit}
    RechSender: string;                  {für Debugging}
    ButtonHints: TStringList;            {für QNav. Vergl. DisabledButtons}
    FInitKeyFields: boolean;             {Flag 'Permanent'-Keyfields geladen. Für FltrFrm}
    BuildSOListFlag: boolean;            {Flag für SetSOList}
    SafeRefreshFlag: boolean;
    SafeReloadFlag: boolean;
    AppendFlag: boolean;                 //Steuert ob DoInsert mit Insert oder Append 12.06.13

    { für Zugriff von außerhalb: }
    OldDataChange: TDataChangeEvent;     {Zugrif von LuGrid}
    EditControl: TWinControl;            {erstes Eingabefeld. z.B. in BeforeEdit setzen}

    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Loaded;
    procedure Init;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
    procedure StateChange(Sender: TObject);
    function IsLookUpDef: boolean;
    function AssignField1(AFieldName1, AFieldName2: string; CheckRights: boolean = false): boolean;
    function AssignField(AFieldName: string; SrcField: TField; CheckRights: boolean = false): boolean; {mit Comp, DoEdit}
    function EnterValue(AFieldName, AValue: string; CheckRights: boolean = false): boolean;
    function AssignValue(AFieldName, AValue: string; CheckRights: boolean = false): boolean;           {mit Comp, DoEdit}
    function AssignValueIfNull(AFieldName, AValue: string; CheckRights: boolean = false): boolean;
    function AssignValueEx(AFieldName, AValue: string; IfNull: boolean; CheckRights: boolean = false; PrepareEnter: boolean = false): boolean;
    function AssignFloat(AFieldName: string; AValue: double; CheckRights: boolean = false): boolean; // Weist eigenem Feld einen Double  Wert zu.
    function AssignDateTime(AFieldName: string; AValue: TDateTime; CheckRights: boolean = false): boolean; // Weist eigenem Feld einen DateTime Wert zu.
    function AssignTimeStr(AFieldName: string; AValue: TDateTime; CheckRights: boolean = false): boolean;  // Weist eigenem Feld einen Time Wert als String zu.
    function AssignInteger(AFieldName: string; AValue: integer; CheckRights: boolean = false): boolean; // Weist eigenem Feld einen Integer Wert zu.
    function AssignMemoLine(AFieldName: string; ALine: integer; AValue: string; CheckRights: boolean = false): boolean;  // Weist eigenem mehrzeiligem Feld (Blob, String) einen Text in einer Zeile zu.
    function AssignMemoValue(AFieldName, AParam, AValue: string; CheckRights: boolean = false): boolean;
    procedure AssignAswName(AFieldName, AAswName: string);  // Weist zur Laufzeit eigenem Feld eine Auswahl zu.
    procedure Commit;                                {Explizit Speichern}
    procedure SafeRefresh;
    procedure SafeReload;
    procedure Refresh;                               {Aktualisieren}
    {procedure LoadAgain;       100100 ersetzt durch Re Load}
    function ReLoad(ToDataPos: TStrings = nil): boolean; {Tabelle neu öffnen und dann positionieren. true wenn OK}
    procedure FetchAll;
    procedure ResetFields;
    procedure AddCalcFields;
    function BuildSql: boolean;
    procedure BuildSOList;
    procedure ClearCalcCache;
    procedure ClearCalcField;
    function LongFieldName(AFieldName: string): string;
    procedure DeleteAll;
    procedure ChangeRecord;
    procedure ChangeAll;
    procedure FillColumnList;
    procedure ClearEmptyFields(ADataSet: TDataSet);
    procedure SetEnable(Enable: boolean; SetReadOnly: boolean);
    procedure SetFieldFlags(AField: TField; Flags: TFieldFlags);
    procedure SetEditFlags(AEdit: TWinControl; Flags: TFieldFlags);
    procedure ToggleEditFlags(AEdit: TWinControl; Flags: TFieldFlags; Toggle: boolean);
    (* einfacherere Schnittstelle für SetEditFlags *)
    function ToggleFlags(Flags: TFieldFlags; Toggle: boolean): TFieldFlags;
    procedure ToggleFieldFlags(AField: TField; Flags: TFieldFlags;
      Toggle: boolean); overload;
    procedure ToggleFieldFlags(AFieldName: string; Flags: TFieldFlags;
      Toggle: boolean); overload;
    procedure SetTagFlags(TagMask: longint; Flags: TFieldFlags);
    (* ruft SetEditFlags auf für alle Componenten des Formulars deren Tag auf TagMask passt (and-Verknüpfung *)
    procedure FieldOnGetText(Sender: TField; var Text: string; DisplayText: Boolean); {Zum Anzeigen übersetzen}
    procedure FieldOnSetText(Sender: TField; const Text: string); {Zum Speichern übersetzen}
    procedure FieldOnGetTextTrimL0(Sender: TField; var Text: string;
      DisplayText: Boolean);    {führende 0en in Anzeige weg}
    procedure CalcFields;       {Dataset.OnCalcFields und Nav.OnGet durchführen}
    procedure DoValidate(Sender: TField);
    procedure DoRech(ADataSet: TDataSet; Field: TField; OnlyCalc: boolean;
      Sender: string);
    procedure DoQuery;
    procedure DoNavigate(Index: TQbeNavigateBtn);
    procedure DoEdit(CheckRights: boolean = false);
    procedure DoInsert(CheckRights: boolean = false);
    procedure Insert;              {Internes Einfügen ohne ErfassSingle u.ä.}
    procedure Duplicate;
    procedure DoPost(CheckRights: boolean = false);
    procedure DoCancel;
    procedure DoDelete;
    procedure DoDeleteMarked(MarkAll: boolean);
    function DeleteMarkedConfirmed: boolean;
    function DeleteRecordConfirmed: boolean;  //Datensatz löschen (Display)?
    class procedure TrInit;
    function DoMsgFmt(MsgTyp: TMsgTyp; MsgNr: longint; const Fmt: string;
                       const Args: array of const): word; {virtual}
    procedure IncludeEditFields(ExcludeTag: integer);

    property StaticFields: boolean read GetStaticFields write SetStaticFields;
    property InsertFlag: boolean read FInsertFlag write SetInsertFlag;

    property RecordCount: longint read GetRecordCount write FRecordCount;
    property CalcOK: boolean read FCalcOK write SetCalcOK;
    property dsQuery: boolean read FdsQuery write FdsQuery;
    property dsChangeAll: boolean read FdsChangeAll write FdsChangeAll;
    property NoBuildSql: boolean read FNoBuildSql write SetNoBuildSql;
    property UseFltrList: boolean read FUseFltrList write SetUseFltrList; {LuDef: FltrList für BuildSql verwenden}
    property NlState: TNavLinkState read GetNlState;     {DataSource Status}
    property AutoCommit: boolean read FAutoCommit write FAutoCommit;
    property AutoOpen: boolean read FAutoOpen write FAutoOpen;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property NoOpen: boolean read FNoOpen write FNoOpen;
    property NoGotoPos: boolean read FNoGotoPos write FNoGotoPos;
    property EditSingle: boolean read FEditSingle write FEditSingle;
    property ErfassSingle: boolean read FErfassSingle write FErfassSingle;
    property MDTyp: TMDTyp read FMDTyp write FMDTyp;
    property Kennung: string read GetKennung;            {für Rechteverwaltung}
    property Form: TForm read GetForm;
    property LNav: TObject read GetLNav;
    property ActiveSource: TDataSource read GetActiveSource; {darf nur lesen}
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property EditSource: TDataSource read GetEditSource write FEditSource;
    property DataSet: TDataSet read GetDataSet write SetDataSet;
    property Query: TuQuery read GetQuery;
    property Table: TuTable read GetTable;
    property LiveRequest: boolean read GetLiveRequest write SetLiveRequest; {requestlive}
    property InEdit: boolean read GetInEdit;
    property DataPos: TDataPos read FDataPos write SetDataPos;
    property CalcList: TValueList read FCalcList write SetCalcList;
    property ChangeList: TValueList read FChangeList write SetChangeList;
    property DBGrid: TDBGrid read FDBGrid write FDBGrid;
    property MultiGrid: TDBGrid read GetMultiGrid;

    property ColumnList: TValueList read FColumnList write SetColumnList;
    property FltrList: TFltrList read FFltrList write SetFltrList;
    property FormatList: TValueList read FFormatList write SetFormatList;
    property Bemerkung: TStringList read FBemerkung write SetBemerkung;
    property KeyFields: string read FKeyFields write SetKeyFields;
    property InitKeyFields: boolean read FInitKeyFields write SetInitKeyFields;
    property KeyList: TValueList read FKeyList write SetKeyList;
    property PrimaryKeyFields: string read GetPrimaryKeyFields write SetPrimaryKeyFields;
    property References: TFltrList read GetReferences write SetReferences;
    property SOList: TFltrList read GetSOList write SetSOList;
    property SqlFieldList: TValueList read FSqlFieldList write SetSqlFieldList;
    property SqlHint: string read FSqlHint write SetSqlHint;
    property TableName: string read FTableName write SetTableName;
    property TabTitel: string read FTabTitel write FTabTitel;
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
    property MasterFieldNames: string read GetMasterFieldNames;
    property IndexFieldNames: string read GetIndexFieldNames;
    property LookUpSource: TDataSource read FLookUpSource write SetLookUpSource;
    property DisabledButtons: TQbeButtonSet read FDisabledButtons write SetDisabledButtons;
    property EnabledButtons: TQbeButtonSet read FEnabledButtons write SetEnabledButtons;
    property TabellenRechte: TRechteSet read FTabellenRechte write SetTabellenRechte;
    property PrimaryKeyList: TValueList read FPrimaryKeyList;
    property KeyFieldList: TValueList read FKeyFieldList;
    property TableList: TValueList read FTableList;
    property NoOpenSMess: boolean read GetNoOpenSMess;

    property OnValidate: TFieldNotifyEvent read FOnValidate write FOnValidate;
    property OnGet: TDataSetNotifyEvent read FOnGet write FOnGet;
    property OnErfass: TNotifyEvent read FOnErfass write FOnErfass;
    property OnRech: TRechEvent read FOnRech write FOnRech;
    property OnBuildSql: TBuildSqlEvent read FOnBuildSql write FOnBuildSql;
    property OnMsg: TMsgEvent read FOnMsg write FOnMsg;
    property BeforeQuery: TBeforeNotifyEvent read FBeforeQuery write FBeforeQuery;
    property BeforeEdit: TBeforeNotifyEvent read FBeforeEdit write FBeforeEdit;
    property BeforeInsert: TBeforeNotifyEvent read FBeforeInsert write FBeforeInsert;
    property BeforePost: TBeforeNotifyEvent read FBeforePost write FBeforePost;
    property BeforeCancel: TBeforeNotifyEvent read FBeforeCancel write FBeforeCancel;
    property BeforeDelete: TBeforeNotifyEvent read FBeforeDelete write FBeforeDelete;
    property BeforeDeleteMarked: TBeforeNotifyEvent read FBeforeDeleteMarked write FBeforeDeleteMarked;
    property OnPostError: TDataSetErrorEvent read FOnPostError write FOnPostError;
    property OnDeleteError: TDataSetErrorEvent read FOnDeleteError write FOnDeleteError;
  end;

const
  nlEditStates = [nlEdit,nlInsert];
  NavLinkStateStr: array[TNavLinkState] of string =
    ('initialisieren', 'anzeigen', 'ändern', 'erfassen',
    'sortieren', 'rechnen', 'speichern Alt', 'speichern Neu', 'Filter',
    'CurValue', 'BlockRead', 'InternalCalc', 'Opening', 'suchen', 'global ändern');

  function DsGetNavLink(ADataSource: TDataSource): TNavLink;

implementation

uses
  DBCtrls, DbiErrs, Grids, extctrls, Math, IBQuery, System.TypInfo,
  Prots, LNav_Kmp, GNav_Kmp, QNav_Kmp, LuDefKmp, Qwf_Form, LuEdiKmp, Err__Kmp, Poll_Kmp,
  Asws_Kmp, ChangDlg, CPro_Kmp, Repl_Kmp, MuGriKmp, FldDsKmp, nstr_kmp, UDB__KMP,
  AbortDlg, CalcCache;

(*** Properties Setzen/Lesen **************************************************)

class procedure TNavLink.TrInit;
var                   {Translation Init (erst aufrufen wenn Quelle aktiv}
  J: TNavLinkState;
begin
  for J := Low(TNavLinkState) to High(TNavLinkState) do
    NavLinkStateStr[J] := GNavigator.TranslateStr(GNavigator.X, NavLinkStateStr[J]);
end;

function TNavLink.GetRecordCount: longint;
begin
//25.04.13 - UniDAC macht das für uns.
//  if (DataSet is TuQuery) and not TuQuery(Dataset).Options.QueryRecCount then
//    TuQuery(Dataset).Options.QueryRecCount := true;
//  bis 29.04.13 if (DataSet is TuQuery) and not TuQuery(Dataset).Options.QueryRecCount then
//  try
//    InRecordCount := true;
//    TuQuery(Dataset).DoFetchAll;  //alle Records laden für Rec.Count
//  finally
//    InRecordCount := false;
//  end;


  if (DataSet is TuQuery) and not TuQuery(Dataset).Options.QueryRecCount and
     not TuQuery(Dataset).FetchAll then
  begin                     // führt SQL count * aus
    TuQuery(Dataset).Options.QueryRecCount := true;  //nicht nochmal hier her
    if not Dataset.Active then
    begin
      //29.04.13 ohne FetchAll und damit ohne Datachange.
      Result := 0;  // TuQuery(Dataset).DoGetRecCount ist bei Inactive immer 0
    end else
    begin   //hat hier nur die fetched gezählt (normal 25). 24.07.13 lawa
      //um dies zu vermeiden: setze Query.Options.QueryRecCount = true
      Prot0('WARN %s Recordcount: Dataset closing because QueryRecCount=false and already open',
            [OwnerDotName(Dataset)]);
      Dataset.Close;
      Result := 0;
    end;
  end else
  begin
    Result := Dataset.RecordCount;  // 26.04.13 geht so auch ohne QueryRecCount
  end;
  if (Result = 0) and not DataSet.Active then
     //14.03.14 beware not TuQuery(Dataset).Options.QueryRecCount then  //27.12.13
     //         GetRecCount funktioniert nur bei geöffnetem Dataset
  begin
    Prot0('WARN %s Recordcount: Dataset was not open', [OwnerDotName(Dataset)]);
    Dataset.Open;
    Result := Dataset.RecordCount;
  end;
Exit;

//  result := IMax(0, FRecordCount);
//  AQuery := nil;
//  if dsQuery or dsChangeAll then
//  begin
//    result := 1;
//  end else
//  if (DataSet.State in [dsBrowse,dsInactive]) and not InRecordCount then
//  try
//    InRecordCount := true;
//    if HasRecordCount then
//    try
//      if SysParam.Standard then
//        result := DataSet.RecordCount else     {nur bei Paradox OK! 120298}
//        HasRecordCount := false;
//    except
//      HasRecordCount := false;
//    end;
//    if not HasRecordCount and
//       (FRecordCount = 0) and (Query <> nil) and
//       (not Query.EOF or not Query.BOF or (DataSet.State = dsInactive)) then
//    begin
//      FRecordCount := -1;
//      try
//        try
//          S1 := nil;     //wg Compilerwarnung
//          S2 := nil;
//          S3 := nil;
//          PCols := nil;
//          if not Sysparam.Interbase and
//             ((PosI('DISTINCT', Query.SQL.Text) > 0) or     {and not Sysparam.MSSQL}
//             (PosI('GROUP BY', Query.SQL.Text) > 0) or   //klappt für mssql 02.10.08
//             (PosI('select', copy(Query.SQL.Text, 6, Maxint)) > 0)) then   //where .. in (select ..)
//          begin  //Interbase kann das nicht: "select count(*) from (select * from ..)"
//            P1 := PosI('order by', Query.SQL.Text);
//            if P1 > 0 then
//              Str1 := copy(Query.SQL.Text, 1, P1 - 1) else
//              Str1 := Query.SQL.Text;
//            QueryText := Format('select count(*) as Anzahl from (%s)', [Str1]);
//            if Sysparam.MsSql then
//              QueryText := QueryText + ' derived_table';  //MSSQL Syntax!
//          end else
//          try
//            PCols := StrAlloc(1024);
//            StrCopy(PCols, ' count(*) as Anzahl ');
//            S1 := StrUpper(Query.SQL.GetText);
//            PS1 := StrPos(S1, 'SELECT');
//            if PS1 = nil then
//              SysUtils.Abort;
//            P1 := PS1 - S1 + 6;
//
//            PS0 := StrPos(S1, 'DISTINCT');
//            if PS0 <> nil then
//            begin
//              if SqlFieldList.Count > 0 then
//              begin            //F1=distinct F2 -> select distinct F2 as F1
//                Str1 := PStrTok(SqlFieldList[0], ' =', NextS); //distinct oder F1
//                Str2 := PStrTok('', ' =', NextS);   //F1 oder F2 oder ''
//                Str3 := PStrTok('', ' =', NextS);   //F2 oder ''
//                FieldName := StrDflt(Str3, StrDflt(Str2, Str1));
//              end else
//                FieldName := Query.Fields[0].FieldName;
//              StrFmt(PCols, ' count(distinct %s) as Anzahl ', [FieldName]);
//              {geht nicht weil count(distinct nur 1 Feld zulässt ...}
//            end;
//
//            PS2 := S1;                           //qupp.mara
//            while StrPos(PS2 + 1, ' AS ') <> nil do
//              PS2 := StrPos(PS2 + 1, ' AS ');
//
//            //PS2 := StrPos(PS2, 'FROM');         //select EMAI_FROM from EMAI
//            while StrPos(PS2 + 1, 'FROM') <> nil do
//              PS2 := StrPos(PS2 + 1, 'FROM');
//            if PS2 = nil then
//              SysUtils.Abort;
//            P2 := PS2 - S1;
//
//            PS3 := StrPos(S1, 'ORDER BY');
//            if PS3 = nil then
//              P3 := StrLen(S1) else
//              P3 := PS3 - S1;
//
//            PS4 := StrPos(S1, 'GROUP BY');
//            if PS4 = nil then
//              P4 := P3 else
//              P4 := IMin(P3, PS4 - S1);
//            //
//            S3 := Query.SQL.GetText;              {normalschrift}
//            S2 := StrAlloc(StrLen(S3) + 32);
//            StrLCopy(S2, S3, P1);
//            StrCat(S2, PCols);            {StrCat(S2, ' count(* ) as Anzahl ');}
//            StrLCat(S2, S3+P2, StrLen(S2)+P4-P2);  //16.03.03 P4<-P3
//            if Query.RequestLive then
//            repeat  {Filename "user.db" i.V.m. RequestLive -> user.db}
//              Ps1 := StrPos(S2, '"');
//              if Ps1 <> nil then
//                StrDelete(Ps1, 0, 1);
//            until Ps1 = nil;
//            QueryText := S2;            //04.08.06
//          finally
//            StrDispose(S1);
//            StrDispose(S2);
//            StrDispose(S3);
//            StrDispose(PCols);
//          end;
//          SMess(SNLnk_Kmp_001, [TableName]);	// 'Bestimme Anzahl der Datensätze ..'
//          AQuery := TuQuery.Create(nil);  //kein Owner da hier free
//          try
//            AQuery.Name := StrToValidIdent(Format('%s.RecordCount', [OwnerDotName(Owner)]));
//            GNavigator.SetDuplDB(AQuery, QueryDatabase(Query), 4);
//            AQuery.MasterSource := Query.DataSource;
//            AQuery.RequestLive := false;
//            AQuery.SQL.Text := QueryText;
//            AQuery.Params.AssignValues(Query.Params);
//            if Sysparam.ProtBeforeOpen then
//            begin
//              Prot0('GetRecordCount(%s)', [Display]);
//              ProtSql(AQuery);
//            end;
//            AQuery.Params.AssignValues(Query.Params);  //23.02.11 webab liste>25000
//            AQuery.Open;  //QueryOpenCommitted(AQuery);  //01.05.09 AQuery.Open;
//          finally
//            FRecordCount := AQuery.FieldByName('Anzahl').AsInteger;
//            if FRecordCount = 0 then
//              FRecordCount := -1;
//            if Sysparam.ProtBeforeOpen then
//            begin
//              Prot0('GetRecordCount(%s):%d', [Display, FRecordCount]);
//            end;
//            AQuery.Close;
//            AQuery.Unprepare;
//            AQuery.Free;
//            SMess('',[0]);
//          end;
//        except on E:Exception do
//          EProt(AQuery, E, 'GetRecordCount(%s)'+CRLF+'%s',[Display, Query.SQL.Text]);
//        end;
//      finally
//        result := IMax(0, FRecordCount);
//      end;
//    end;
//  finally
//    InRecordCount := false;
//  end;
end;

function TNavLink.GetStaticFields: boolean;
begin
  try
    if Owner is TLNavigator then
      result := (Owner as TLNavigator).StaticFields else
    if (Form is TqForm) and (FormGetLNav(Form) <> nil) then    {X}
      result := FormGetLNav(Form).StaticFields else
      result := false;
  except on E:Exception do
    begin
      ShowMessage('GetStaticFields: '+E.Message);
      result := false;
    end;
  end;
end;

procedure TNavLink.SetStaticFields(Value: boolean);
begin
  if Owner is TLNavigator then
    (Owner as TLNavigator).StaticFields := Value;
end;

procedure TNavLink.SetInsertFlag(Value: boolean);
begin
  FInsertFlag := Value;
end;

function TNavLink.GetForm: TForm;
//Ergibt Form des Steuerelement aber nur wenn Typ = TqForm, sonst nil.
begin
  result := nil;
  if (Owner <> nil) and (Owner.Owner is TqForm) then
  try
    result := Owner.Owner as TForm;
  except
    result := nil;
  end else
    Debug0;
end;

function TNavLink.GetLNav: TObject;
begin
  Result := nil;
  if Form <> nil then
    result := FormGetLNav(Form);
end;

procedure TNavLink.SetDataSource(Value: TDataSource);
{Bei Änderung von DataSource}
begin
  FDataSource := Value;
  if FEditSource = nil then
    FEditSource := Value;
  if Value = nil then
    Debug0;
  if (Value <> nil) and
     (Owner is TLNavigator) and not (csLoading in Owner.Componentstate) then
  begin
    ResetFields;  {Alle Feldinformationen löschem}
    AddCalcFields; {Neu einlesen und aufbauen}
  end;
end;

function TNavLink.GetEditSource: TDataSource;
begin
  if FEditSource = nil then
    result := FDataSource else
    result := FEditSource;
end;

procedure TNavLink.SetDataSet(Value: TDataSet);
{Bei Änderung von DataSet: setzt Recordcounter, CalcFields zurück. Für LlPrn}
begin
  if FDataSource <> nil then
  begin
    if FDataSource.DataSet <> Value then
    begin
      HasRecordCount := false;
      FDataSource.DataSet := Value;
      Value.OnCalcFields := NewCalcFields;      {Changed auch LNav.DS}
      Value.BeforeInsert := NewBeforeInsert;
      Value.AfterInsert := NewAfterInsert;
      Value.AfterOpen := NewAfterOpen;
      Value.AfterScroll := NewAfterScroll;
      Value.BeforeOpen := NewBeforeOpen;
      Value.BeforeClose := NewBeforeClose;
      Value.BeforePost := NewBeforePost;
      Value.BeforeDelete := NewBeforeDelete;
      Value.AfterPost := NewAfterPost;
      Value.AfterCancel := NewAfterCancel;
      AddCalcFields; {Neu einlesen und aufbauen}
    end;
  end;
end;

function TNavLink.GetDataSet: TDataSet;
begin
  if DataSource = nil then
    result := nil else
    result := DataSource.DataSet;
end;

function TNavLink.GetQuery: TuQuery;
begin
  if (DataSet = nil) or (DataSet is TuMemTable) then
    result := nil else
  if DataSet is TuQuery then
    result := DataSet as TuQuery else
    result := nil;
end;

function TNavLink.GetTable: TuTable;
begin
  if (DataSet = nil) or (DataSet is TuMemTable) then
    result := nil else
  if DataSet is TuTable then
    result := DataSet as TuTable else
    result := nil;
end;

function TNavLink.GetInEdit: boolean;
begin
  result := InDoEdit;    // or InDoInsert;  Nein 04.06.02. Wir brauchen Flag+DataChange!
end;

procedure TNavLink.SetCalcOK(Value: boolean);
begin
  FCalcOK := Value;
  (* Idee: Nachricht an Multigrids usw. *)
end;

procedure TNavLink.SetNoBuildSql(Value: boolean);
begin
  FNoBuildSql := Value;
  if Value then
    HangingSql := true;
end;

procedure TNavLink.SetUseFltrList(const Value: boolean);
begin
  if FUseFltrList <> Value then
  begin
    FUseFltrList := Value;
    HangingSql := true;  //beim nächsten Öffnen Sql neu aufbauen - 22.06.09 
  end;
end;

function TNavLink.GetLiveRequest: boolean;
var
  aDataSet: TDataSet;
begin
  result := false;
  if dsQuery or dsChangeAll then
    aDataSet := SaveDataSet else
    aDataSet := DataSet;
  if aDataSet <> nil then
  begin
    if aDataSet is TuQuery then
      result := TuQuery(aDataSet).RequestLive else
    if aDataSet is TuTable then
      result := not TuTable(aDataSet).ReadOnly;
  end;
end;

procedure TNavLink.SetLiveRequest(const Value: boolean);
var
  OldActive: boolean;
  aDataSet: TDataSet;
begin
  if GetLiveRequest <> Value then
  begin
    if dsQuery or dsChangeAll then
      aDataSet := SaveDataSet else
      aDataSet := DataSet;
    OldActive := false;  //wg Compilerwarnung
    if aDataSet <> nil then
    try
      OldActive := aDataSet.Active;
      aDataSet.Active := false;
      if Value then
        Debug0;
      if aDataSet is TuQuery then
        TuQuery(aDataSet).RequestLive := Value else
      if aDataSet is TuTable then
        TuTable(aDataSet).ReadOnly := not Value;
    finally
      if not dsQuery and not dsChangeAll and OldActive then
        aDataSet.Active := OldActive else
      if (GNavigator <> nil) and (GNavigator.X <> nil) and
         (GNavigator.X.NavLink <> nil) and (GNavigator.X.NavLink = self) then
        PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(gnEditingChanged), 0);
    end;
  end;
end;

function TNavLink.GetActiveSource: TDataSource;
{Liefert aktuellen Source work around bei request life über mehreren Tabellen}
begin
  if (EditSource <> nil) and (EditSource.DataSet <> nil) and
     (EditSource <> DataSource) and (EditSource.DataSet.Active) and
     (EditSource.DataSet.State in [dsInsert,dsEdit]) then      {290497}
  begin
    result := EditSource;
  end else
    result := DataSource;
end;

function TNavLink.GetNlState: TNavLinkState;
{gibt den DataSource-Status}
var
  ANavLink: TNavLink;
begin
  try
    if (EditSource <> nil) and (EditSource.DataSet <> nil) and
       (EditSource <> DataSource) and (EditSource.DataSet.Active) then
    begin                                             {Wenn EditSource aktiv ist}
      ANavLink := DsGetNavLink(EditSource);
    end else {sonst eigener NavLink}
      ANavLink := self;
    result := nlInactive; {vorbelegen}
    if ANavLink.dsQuery then
      result := nlQuery else
    if ANavLink.dsChangeAll then
      result := nlChangeAll else
    if (ANavLink.DataSource <> nil) and (ANavLink.DataSource.DataSet <> nil) then
      case ANavLink.DataSource.DataSet.State of
        dsInactive:   result := nlInactive;
        dsBrowse:     result := nlBrowse;
        dsEdit:       result := nlEdit;
        dsInsert:     result := nlInsert;
        dsSetKey:     result := nlSetKey;
        dsCalcFields: result := nlCalcFields;
    {$ifdef WIN32}
        dsNewValue:     result := nlUpdateNew;
        dsOldValue:     result := nlUpdateOld;
        dsFilter:       result := nlFilter;
        dsCurValue:     result := nlCurValue;
        dsBlockRead:    result := nlBlockRead;
        dsInternalCalc: result := nlInternalCalc;
        dsOpening:      result := nlOpening;
    {$endif}
      end;
  except on E:Exception do
    begin
      result := nlInactive;
      EProt(Owner, E, 'nlState', [0]);
    end;
  end;
end;

function TNavLink.GetKennung: string;
(* Liefert Kennung für Rechteverwaltung *)
var
  S: string;
begin
  try
    if IsLookUpDef then
      S := TLookUpDef(Owner).LuKurz else
      S := FormGetLNav(Form).FormKurz;
    if S = '' then
      S := Display;
  except
    S := Display;
  end;
  result := 'FRM' + S;
end;

procedure TNavLink.SetCalcList(Value: TValueList);
begin
  if Value <> nil then
    FCalcList.Assign(Value) else
    FCalcList.Clear;
end;

procedure TNavLink.CalcListChange(Sender: TObject);
begin
  if not (csLoading in Owner.Componentstate) {or          bringt nix
     (csDesigning in Owner.Componentstate)} and
     not InAddCalcFields then                             //wg _cfOnGet - 25.10.03
  begin
    ResetFields;
    AddCalcFields;
  end;
end;

procedure TNavLink.SetChangeList(Value: TValueList);
begin
  if FChangeList <> Value then                  {This conditional is optional.}
    FChangeList.Assign(Value);
end;

procedure TNavLink.SetColumnList(Value: TValueList);
begin
  if FColumnList <> Value then                  {This conditional is optional.}
    FColumnList.Assign(Value);
end;

procedure TNavLink.ColumnListChange(Sender: TObject);
var
  I: integer;
begin
  if {(([csDesigning] = Owner.ComponentState) and		{sonst nix!
      (Owner is TLookUpDef) and (FColumnList.Count = 0)) or}
     (DataSet <> nil) and
     ((FColumnList.Count = 1) and (FColumnList.Strings[0] = '*')) then
  begin
    try
      if DataSet.FieldCount > 0 then
      begin
        if FColumnList.Count > 0 then
          FColumnList.Clear;
        for I:= 0 to DataSet.FieldCount-1 do
          with DataSet.Fields[I] do
            FColumnList.Add(Format('%s=%s', [DisplayLabel,FieldName]));
      end else
      with DataSet.FieldDefs do
      begin
        if (Count = 0) and not StaticFields then
          {Update;}
          {UpdateFieldDefs(DataSet);}
          FldDsc.Update(DataSet, FTableName, FSqlFieldList);
        if FColumnList.Count > 0 then
          FColumnList.Clear;
        for I:= 0 to Count-1 do
          FColumnList.Add(Format('%s=%s', [Items[I].Name,Items[I].Name]));
      end;
    except
      on E:Exception do
      begin
        MessageFmt('SetColumnList:%s',[E.Message],mtWarning,[mbOK],0);
      end;
    end;
  end;
end;

procedure TNavLink.FillColumnList;
// Columnlist anhand FocusControl füllen
var
  I: integer;
  ALabel: TLabel;
  AFocusControl: TWinControl;
  L: TValueList;
  ADBCheckBox: TDBCheckBox;
  ADBComboBox: TDBComboBox;
  ADBMemo: TDBMemo;
  ADBEdit: TDBEdit;
  AForm: TForm;
begin
  AForm := Form;
  if AForm = nil then
    Exit;
  if DataSource = nil then
    Exit;
  ColumnList.BeginUpdate;
  L := TValueList.Create;
  try
    for I := 0 to AForm.ComponentCount - 1 do
    begin
      if AForm.Components[I] is TDBCheckBox then
      begin
        ADBCheckBox := AForm.Components[I] as TDBCheckBox;
        if (ADBCheckBox.Caption <> '') and (ADBCheckBox.DataSource = DataSource) and
           (ADBCheckBox.DataField <> '') then
          L.Values[ADBCheckBox.Caption] := ADBCheckBox.DataField;
      end else
      if AForm.Components[I] is TLabel then
      begin
        ALabel := AForm.Components[I] as TLabel;
        if ALabel.Caption <> '' then
        begin
          AFocusControl := ALabel.FocusControl;
          if AFocusControl is TDBEdit then
          begin
            ADBEdit := AFocusControl as TDBEdit;
            if (ADBEdit.DataSource = DataSource) and (ADBEdit.DataField <> '') then
              L.Values[ALabel.Caption] := ADBEdit.DataField;
          end else
          if AFocusControl is TDBMemo then
          begin
            ADBMemo := AFocusControl as TDBMemo;
            if (ADBMemo.DataSource = DataSource) and (ADBMemo.DataField <> '') then
              L.Values[ALabel.Caption] := ADBMemo.DataField;
          end else
          if AFocusControl is TDBComboBox then
          begin
            ADBComboBox := AFocusControl as TDBComboBox;
            if (ADBComboBox.DataSource = DataSource) and (ADBComboBox.DataField <> '') then
              L.Values[ALabel.Caption] := ADBComboBox.DataField;
          end;
        end;
      end;
    end;
    for I := 0 to L.Count - 1 do
      if ColumnList.Params[L.Value(I)] = '' then
      begin  //ohne ':' und ',' und '&'
        ColumnList.Add(RemoveAccelChar(StrCgeChar(StrCgeChar(L[I], ':', #0), ',', #0)));
      end;
  finally
    L.Free;
    ColumnList.EndUpdate;
  end;
end;

procedure TNavLink.SetDataPos(Value: TDataPos);
begin
  if Value <> nil then
    FDataPos.Assign(Value) else
    FDataPos.Clear;
end;

procedure TNavLink.DataPosChange(Sender: TObject);
begin
  Debug0;
end;

procedure TNavLink.SetFltrList(Value: TFltrList);
begin
  if Value <> FFltrList then
    FFltrList.Assign(Value); //else
  {buildsql in change}
end;

procedure TNavLink.FltrListChange(Sender: TObject);
begin
  if not (csLoading in Owner.Componentstate) then
  begin
    FRecordCount := 0;
    if not InOnBuildSql then
      BuildSql;
  end;
end;

procedure TNavLink.SetBemerkung(Value: TStringList);
begin
  FBemerkung.Assign(Value);
end;

procedure TNavLink.SetFormatList(Value: TValueList);
begin
  if Value <> nil then
    FFormatList.Assign(Value) else
    FFormatList.Clear;
end;

procedure TNavLink.FormatListChange(Sender: TObject);
begin
  if not (csLoading in Owner.Componentstate) and not NoBuildSql then
  begin
    ResetFields;
    AddCalcFields;
  end;
end;

procedure TNavLink.SetInitKeyFields(const Value: boolean);
begin
  FInitKeyFields := Value;
end;

procedure TNavLink.SetKeyFields(Value: string);
begin
  FKeyFields := Value;
  FKeyFieldList.Clear;
  FKeyFieldList.AddTokens(FKeyFields, ';');
  if not (csLoading in Owner.Componentstate) then
  begin
    InitKeyFields := true;         {s.a. newbeforeopen}
    if not InOnBuildSql then
      BuildSql;
  end;
end;

procedure TNavLink.SetKeyList(Value: TValueList);
begin
  FKeyList.Assign(Value);
  KeyIndex := -1;
end;

procedure TNavLink.SetLookUpSource(Value: TDataSource);
begin
  FLookUpSource := Value;
  if not (csLoading in Owner.Componentstate) then
  begin
    BuildSOList;
  end;
end;

function TNavLink.GetPrimaryKeyFields: string;
begin
  if (FPrimaryKeyFields = '') and (FKeyFields <> '') then
    result := FKeyFields else
    result := FPrimaryKeyFields;
end;

procedure TNavLink.SetPrimaryKeyFields(Value: string);
begin
  FPrimaryKeyFields := Value;
  FPrimaryKeyList.Clear;
  FPrimaryKeyList.AddTokens(PrimaryKeyFields, ';');
end;

procedure TNavLink.SetTabellenRechte(const Value: TRechteSet);
begin
  FTabellenRechte := Value;
  if not (reUpdate in FTabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbEdit];
  if not (reInsert in FTabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbInsert];
  if not (reDelete in FTabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbDelete];
end;

procedure TNavLink.BuildSOList;
begin
  BuildSOListFlag := true;
end;

procedure TNavLink.BuildSOList1;
var
  I: integer;
  TmpList: TFltrList;
  procedure AddLeObject(aLookUpField, aDataField: string; LeOptions: TLeOptions);
  var
    I1: integer;
  begin
    try
      TmpList.Values[aLookUpField] := ':' + aDataField;
      if LeOptions <> [] then
      begin
        I1 := TmpList.ValueIndex(aLookUpField, nil);
        if TmpList.Objects[I1] <> nil then
        begin
          TLeObject(TmpList.Objects[I1]).Options :=
            TLeObject(TmpList.Objects[I1]).Options + LeOptions;
        end else
          TmpList.Objects[I1] := TLeObject.Create(LeOptions);
      end;
    except on E:Exception do
      MessageFmt('SOList: %s', [E.Message], mtWarning, [mbOK], 0);
    end;
  end;
begin      {SOList nur überschreiben wenn mind. 1 LuEdit Feld existiert  130400}
  BuildSOListFlag := false;
  TmpList := TFltrList.Create;
  if Form <> nil then
  try       {Enabled=false in LookUpFelder bewirkt keine Aufnahme in SOList}
    for I := 0 to Form.ComponentCount-1 do
    begin
      if Form.Components[I] is TLookUpEdit then
      begin
        with Form.Components[I] as TLookUpEdit do if Enabled then
          if (LookUpSource = self.DataSource) and (LookUpField <> '') and
             (DataSource = self.MasterSource) and (DataField <> '') then
            AddLeObject(LookUpField, DataField, Options);
      end else
      if Form.Components[I] is TLookUpMemo then
      begin
        with Form.Components[I] as TLookUpMemo do if Enabled then
          if (LookUpSource = self.DataSource) and (LookUpField <> '') and
             (DataSource = self.MasterSource) and (DataField <> '') then
            AddLeObject(LookUpField, DataField, Options);
      end else
      if Form.Components[I] is TAswComboBox then
      begin
        with Form.Components[I] as TAswComboBox do if Enabled then
          if (LookUpSource = self.DataSource) and (LookUpField <> '') and
             (DataSource = self.MasterSource) and (DataField <> '') then
            TmpList.Values[LookUpField] := ':' + DataField;
      end else
      if Form.Components[I] is TAswCheckBox then
      begin
        with Form.Components[I] as TAswCheckBox do if Enabled then
          if (LookUpSource = self.DataSource) and (LookUpField <> '') and
             (DataSource = self.MasterSource) and (DataField <> '') then
            TmpList.Values[LookUpField] := ':' + DataField;
      end else
      if Form.Components[I] is TAswRadioGroup then
      begin
        with Form.Components[I] as TAswRadioGroup do if Enabled then
          if (LookUpSource = self.DataSource) and (LookUpField <> '') and
             (DataSource = self.MasterSource) and (DataField <> '') then
            TmpList.Values[LookUpField] := ':' + DataField;
      end;
    end; {for}
    if TmpList.Count > 0 then
    begin
      //fSOList.FreeObjects;
      fSOList.Assign(TmpList);
    end;
  finally
    TmpList.Free;
  end;
end;

function TNavLink.GetSOList: TFltrList;
begin
  if BuildSOListFlag then
    BuildSOList1;
  result := FSOList;
end;

procedure TNavLink.SetSOList(Value: TFltrList);
begin
  if FSOList <> Value then
    FSOList.Assign(Value);
end;

function TNavLink.GetReferences: TFltrList;
var
  I: integer;
  AMasterList: TValueList;
  AIndexName: string;
begin
  if (Table <> nil) and
     (Table.IndexFieldNames <> '') and (Table.MasterFields <> '') then
  begin
    InGetReferences := true;
    AMasterList := TValueList.Create;
    try
      FReferences.Clear;
      FReferences.AddTokens(Table.IndexFieldNames, ';');
      AMasterList.AddTokens(Table.MasterFields, ';');
      I := 0;
      try
        for I := 0 to FReferences.Count-1 do
        begin
          if I < AMasterList.Count then
          begin
            AIndexName := FReferences.Strings[I];
            FReferences.Strings[I] :=
              Format('%s=:%s',[AIndexName, AMasterList.Strings[I]]);
          end;
        end;
        I := 0;
      except on E:Exception do
          ErrWarn('GetReferences(%s):%d:%s',[Owner.Name, I, E.Message]);
      end;
    finally
      AMasterList.Free;
      InGetReferences := false;
    end;
  end;
  result := FReferences;
end;

procedure TNavLink.SetReferences(Value: TFltrList);
begin
  if FReferences <> Value then
    FReferences.Assign(Value);
end;

procedure TNavLink.ReferencesChange(Sender: TObject);
var
  I: integer;
  AFieldName: string;
  MNames, INames: string;
begin
  FRecordCount := 0;
  if (Table <> nil) and not InGetReferences then
  begin
    MNames := '';
    INames := '';
    for I:= 0 to FReferences.Count-1 do
    begin
      AFieldName := FReferences.Value(I);
      if AFieldName[1] = ':' then
      begin
        AppendTok(MNames, Copy(AFieldName, 2, length(AFieldName)-1), ';');
        AppendTok(INames, FReferences.Param(I), ';');
      end;
    end;
    Table.Close;
    Table.TableName := TableName;
    Table.MasterSource := MasterSource;
    Table.MasterFields := MNames;
    Table.IndexFieldNames := INames;
  end;
  if (Query <> nil) and
     not (csLoading in Owner.ComponentState) then
  begin
    if not InOnBuildSql then
      BuildSql;
  end;
end;

procedure TNavLink.SetSqlFieldList(Value: TValueList);
begin
  if (Value <> nil) then
    FSqlFieldList.Assign(Value) else
    FSqlFieldList.Clear;
end;

procedure TNavLink.SetSqlHint(const Value: string);
begin
  FSqlHint := Value;
  if not (csLoading in Owner.Componentstate) then
  begin
    BuildSql;
  end;
end;

procedure TNavLink.SqlFieldListChange(Sender: TObject);
var
  I: integer;
begin
  if not InSqlFieldListChange then
  try
    InSqlFieldListChange := true;
    if ((FSqlFieldList.Count = 1) and (FSqlFieldList.Strings[0] = '*')) then
    begin
      try
        if DataSet.FieldCount > 0 then
        begin
          FSqlFieldList.Clear;
          for I:= 0 to DataSet.FieldCount-1 do
          with DataSet.Fields[I] do
            FSqlFieldList.Add(FieldName);
        end else
        with DataSet.FieldDefs do
        begin
          if (Count = 0) and not StaticFields then
          begin
            {Update;}
            {UpdateFieldDefs(DataSet);}
            FSqlFieldList.Clear;
            FldDsc.Update(DataSet, FTableName, FSqlFieldList);
          end else
            FSqlFieldList.Clear;
          for I:= 0 to Count-1 do
            FSqlFieldList.Add(Items[I].Name);
        end;
      except
        on E:Exception do
        begin
          MessageFmt('SetSqlFieldList:%s',[E.Message],mtWarning,[mbOK],0);
        end;
      end;
    end;
    if not (csLoading in Owner.Componentstate) and (Query <> nil) then
    begin
      if not NoBuildSql then        {für Record count}
      try
        ResetFields;
        if not InOnBuildSql then
          BuildSql;
        AddCalcFields;
      except on E:Exception do
        EProt(Owner, E, 'SqlFieldListChange', [0]);
      end;
    end;
  finally
    InSqlFieldListChange := false;
  end;
end;

procedure TNavLink.SetTableName(Value: string);
var
  PKeys: string;
  AIndexList: TStrings;
begin
  FTableName := Value;
  FTableList.Clear;
  FTableList.AddTokens(TableName, ';');
  CheckTablePrefix;  //berücksichtigt csDesigning bei Prefix
  if Table <> nil then  //nur bei Verwendung von TuTable
  begin
    Table.TableName := FTableName;
  end else
  if not (csLoading in Owner.Componentstate) and (TableName <> '') then
  begin
    ResetFields;
    if not InOnBuildSql then
      BuildSql;
    AddCalcFields;
    //if (csDesigning in Owner.ComponentState) and (DataSet <> nil) then
    if (DataSet <> nil) and (DataSet is TuQuery) then    {11.03.02 QUPE}
    begin
      if (GetStringsText(KeyList) = '*'+CRLF) then
        AIndexList := TStringList.Create else
        AIndexList := nil;
      if (AIndexList <> nil) or (PrimaryKeyFields = '*') or   //09.08.02 ZAK Optimierung DfltRep
         (csDesigning in Owner.ComponentState) then
      begin
        if FTableList.Count > 0 then
        begin
          PKeys := IndexInfo(QueryDatabase((DataSet as TuQuery)),    //.DataBaseName
                             FTableList.Strings[0], AIndexList, nil);
          if PKeys <> '' then
            PrimaryKeyFields := PKeys; {Property setzen}

          if (AIndexList <> nil) then    {KeyList von DB einlesen}
          begin
            KeyList.Assign(AIndexList);
            AIndexList.Free;
          end;
        end;
      end;
    end;
    //if csDesigning in Owner.ComponentState then
    begin
      BuildSOList;
    end;
    if not (csDesigning in Owner.ComponentState) and (Form <> nil) then
    begin          {Tablename wird zur Laufzeit geändert (QDISPO.DISP.MuAbruf)}
      TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
        mgColDefChanged);  {Dataset.Fields.Displaylabel usw. neu definieren}
    end;
  end;
end;

procedure TNavLink.SetMasterSource(Value: TDataSource);
begin
  if (Table <> nil) then
    Table.MasterSource := Value else
  if (Query <> nil) then
    Query.MasterSource := Value;
end;

function TNavLink.GetMasterSource: TDataSource;
begin
  if (Table <> nil) then
    result := Table.MasterSource
  else if (Query <> nil) then
    result := Query.DataSource
  else
    result := nil;
end;

function TNavLink.GetMasterFieldNames: string;
begin
  if (Table <> nil) then
    result := Table.MasterFields
  else if (Query <> nil) then
  begin
    result := References.GetValueFieldNames;
    {result := '';
    for I:= 0 to References.Count-1 do
    begin
      AFieldName := PStrTok(References.Value(I), ';' + CharSetToStr(BlockTrenner), NextS);
      if Char1(AFieldName) = ':' then
        AppendTok(result, Copy(AFieldName, 2, length(AFieldName)-1), ';');
    end;}
  end else
    result := '';
end;

function TNavLink.GetIndexFieldNames: string;
begin
  if (Table <> nil) then
    result := Table.IndexFieldNames
  else if (Query <> nil) then
  begin
    result := References.GetParamFieldNames;
    {result := '';
    for I:= 0 to References.Count-1 do
    begin
      AFieldName := PStrTok(References.Value(I), ';', NextS);
      if Char1(AFieldName) = ':' then
        AppendTok(result, References.Param(I), ';');
    end;}
  end else
    result := '';
end;

function TNavLink.IsLookUpDef: boolean;
begin
  result := (Owner <> nil) and (Owner is TLookUpDef);
end;

function TNavLink.GetNoOpenSMess: boolean;
begin
  result := IsLookUpDef and (nlNoOpenSMess in TLookUpDef(Owner).Options);
end;

(*** Initialisierung *********************************************************)

constructor TNavLink.Create(AOwner: TComponent);
begin
  inherited Create;
  Owner := AOwner;
  DataSourceList := TList.Create;
  ReadOnlyList := TList.Create;
  LoadedFltrList := TFltrList.Create;
  LoadedReferences := TFltrList.Create;
  SaveFltrList := TFltrList.Create;
  SaveReferences := TFltrList.Create;
  FDataPos := TDataPos.Create;
  FCalcList := TValueList.Create;
  FChangeList := TValueList.Create;
  FColumnList:= TValueList.Create;
  FFltrList := TFltrList.create;
  FFormatList := TValueList.Create;
  FBemerkung := TStringList.Create;
  FKeyList := TValueList.create;
  FReferences := TFltrList.Create;
  FSOList := TFltrList.Create;
  FSQLFieldList := TValueList.Create;
  FPrimaryKeyList := TValueList.Create;
  FKeyFieldList := TValueList.Create;
  FTableList := TValueList.Create;
  CalcCacheList := TValueList.Create;
  {FLookUpSource := TDataSource.Create(Owner);}
  ChangedFields := TStringList.Create;
  ChangedFields.Sorted := true;
  ChangedFields.Duplicates := dupIgnore;
  SortList := TFltrList.Create;                      {Sort Dlg}
  ButtonHints := TStringList.Create;

  FDataPos.OnChange := DataPosChange;
  FFltrList.OnChange := FltrListChange;
  FFormatList.OnChange := FormatListChange;
  FCalcList.OnChange := CalcListChange;
  FColumnList.OnChange := ColumnListChange;
  FReferences.OnChange := ReferencesChange;
  FSqlFieldList.OnChange := SqlFieldListChange;
  FConfirmDelete := true;
  ConfirmCancel := true;
  HasRecordCount := true;
  BuildSOListFlag := true;
  TmpDataPos := nil;
  FColumnList.RightestEqual := true;  //Linke Seite kann '=' enthalten
end;

destructor TNavLink.Destroy;
begin
  FreeandNil(DataSourceList);
  FreeandNil(ReadOnlyList);
  FreeandNil(LoadedFltrList);
  FreeandNil(LoadedReferences);
  FreeandNil(SaveFltrList);
  FreeandNil(SaveReferences);
  FreeandNil(FDataPos);
  FreeandNil(FCalcList);
  FreeandNil(FChangeList);
  FreeandNil(FColumnList);
  FreeandNil(FFltrList);
  FreeandNil(FFormatList);
  FreeandNil(FBemerkung);
  FreeandNil(FKeyList);
  FreeandNil(FReferences);
  FreeandNil(FSQLFieldList);
  FreeandNil(FPrimaryKeyList);
  FreeandNil(FKeyFieldList);
  FreeandNil(FTableList);
  FreeandNil(ChangedFields);
  FreeandNil(SortList);
  FreeandNil(ButtonHints);
  FSOList.FreeObjects;       FSOList := nil;                {hat Objects !}
  CalcCacheList.FreeObjects; CalcCacheList := nil;
  {FLookUpSource.Free;      FLookUpSource := nil;}
  if MemTable <> nil then
  begin
{$ifdef WIN32}
    MemTable.Cancel;
    MemTable.Free;
    MemTable := nil;
{$else}
{$endif}
  end;
  inherited Destroy;
end;

procedure TNavLink.Loaded;
begin
  if not (csDesigning in Owner.ComponentState) then
  begin
    LoadedFltrList.Assign(FltrList);
    LoadedReferences.Assign(References);
    LoadedKeyFields := FKeyFields;
    if FKeyFields = '' then
      PermanentKeysAllowed := true;                    {permanent änderbar}
    (* if char1(FKeyFields) = ';' then                 {permanent änderbar}
    begin
      LoadedKeyFields := '';
      FKeyFields := copy(FKeyFields, 2, 200);
    end;    ---> besser mit Standard:*)
    if (FKeyList.Values[SStandardKey] <> '') and (FKeyFields = '') then        {'Standard'}
    begin
      FKeyFields := FKeyList.Values[SStandardKey];
      if LoadedKeyFields = '' then
        LoadedKeyFields := FKeyFields;
    end;
    if (DataSource <> nil) then
    begin
      if not assigned(OldDataChange) then
      begin
        OldDataChange := DataSource.OnDataChange;
        DataSource.OnDataChange := NewDataChange;      {ruft auch LNav.Rech}
      end;
    end;
    if (DataSet <> nil) then
    begin
      if (Query <> nil) then
      begin
        LoadedRequestLive := Query.RequestLive;
        OldRequestLive := Query.RequestLive;
      end;
      if Table <> nil then
      begin
        if Table.MasterFields = '' then
          ReferencesChange(self);    {falls umgetTyped}
      end;
      if not assigned(OldCalcFields) then
      begin
        OldCalcFields := DataSet.OnCalcFields;
        DataSet.OnCalcFields := NewCalcFields;      {Changed auch LNav.DS}
      end;
      if not assigned(OldBeforeInsert) then
      begin
        OldBeforeInsert := DataSet.BeforeInsert;
        DataSet.BeforeInsert := NewBeforeInsert;
      end;
      if not assigned(OldAfterInsert) then
      begin
        OldAfterInsert := DataSet.AfterInsert;
        DataSet.AfterInsert := NewAfterInsert;
      end;
      if not assigned(OldAfterOpen) then
      begin
        OldAfterOpen := DataSet.AfterOpen;
        DataSet.AfterOpen := NewAfterOpen;
      end;
      if not assigned(OldAfterScroll) then
      begin
        OldAfterScroll := DataSet.AfterScroll;
        DataSet.AfterScroll := NewAfterScroll;
      end;
      if not assigned(OldBeforeOpen) then
      begin
        OldBeforeOpen := DataSet.BeforeOpen;
        DataSet.BeforeOpen := NewBeforeOpen;
      end;
      if not assigned(OldBeforeClose) then
      begin
        OldBeforeClose := DataSet.BeforeClose;
        DataSet.BeforeClose := NewBeforeClose;
      end;
      if not assigned(OldBeforePost) then
      begin
        OldBeforePost := DataSet.BeforePost;
        DataSet.BeforePost := NewBeforePost;
      end;
      if not assigned(OldBeforeDelete) then
      begin
        OldBeforeDelete := DataSet.BeforeDelete;
        DataSet.BeforeDelete := NewBeforeDelete;
      end;
      if not assigned(OldAfterPost) then
      begin
        OldAfterPost := DataSet.AfterPost;
        DataSet.AfterPost := NewAfterPost;
      end;
      if not assigned(OldAfterCancel) then
      begin
        OldAfterCancel := DataSet.AfterCancel;
        DataSet.AfterCancel := NewAfterCancel;
      end;
      {DataSet.DisableControls;  041100 weg ELP:Rechnet CalcFields nicht }
      {if TableName <> '' then   (immer mit BuildSql)(evtl. iVm NoOpen)
        DataSet.Active := false;}
    end;
  end;
  if (csDesigning in Owner.ComponentState) then  {nur während designing: }
  begin
    try
{$ifdef WIN32}
      {BuildSql;         {040597weg - Objekt nicht gefunden (evtl. CheckParam) }
{$else}
      if (DataSet <> nil) and not DataSet.Active then
        BuildSql;          {090897weg - unnötig, Abbruch in sqld_ora.dll}
                         {100897 bzgl Active da Fehler beim Laden}
      {ShowMessage(Format('BuildOK(%s):FCount%d FDefs%d',
        [Owner.Name,DataSet.FieldCount,DataSet.Fielddefs.Count]));}
{$endif}
      AddCalcFields;
      {ShowMessage(Format('AddCalc(%s):FCount%d FDefs%d',
        [Owner.Name,DataSet.FieldCount,DataSet.Fielddefs.Count]));}
    except
      on E:Exception do
        if Prot <> nil then
          ErrWarn('NLnk.Loaded(%s):%s',[Owner.Name,E.Message])
        {else
          raise;}
    end;
  end else                  {Runtime:}
  begin
    {if SOList.IsEmpty then   (noch nicht)}
    if DataSet <> nil then
      BuildSOList;
  end;
end;

procedure TNavLink.Init;
(* auch für LuGridlg *)
begin
  {in property
  if not (reUpdate in TabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbEdit];
  if not (reInsert in TabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbInsert];
  if not (reDelete in TabellenRechte) then
    FDisabledButtons := FDisabledButtons + [qnbDelete];}
  if SysParam.ConfirmDelete then
    ConfirmDelete := true;
  if (DataSet <> nil) and not SysParam.NoDB then
  try
    if GNavigator.DB1.ReadOnly then
    begin
     if (DataSet is TuQuery) then
        TuQuery(DataSet).RequestLive := false;
     if (DataSet is TuTable) then
        TuTable(DataSet).ReadOnly := true;
    end;
    if not FNoOpen and DataSet.Active then
    begin
      //Prot0(SNLnk_Kmp_002,[Kennung, DataSet.Name]);	// '%s:%s war geöffnet'
      Prot0(SNLnk_Kmp_002,[Display, OwnerDotName(DataSet)]);	// '%s:%s war geöffnet'
      DataSet.Close;            {111198}
    end;
    if not DataSet.Active then       {wg lugrid. muß vorher Öffnen}
    begin
      (* User-Sortierung von INI über MultiGrid-Spalten Sektion laden *)
      BuildSql;                    {Öffnet nicht}
      if not CalcOK then             {24.04.97}
        AddCalcFields;
      GNavigator.DoNavLinkInit(self);
      if not FNoOpen then
      begin
        CheckFltrFields;  //entfernt Filter auf nicht vorhandene Felder - 08.01.12
        DataSet.Open;
      end;
    end else
      GNavigator.DoNavLinkInit(self);
    {DataSet.EnableControls;   in qForm.Init}
  except
    on E:Exception do
    begin
      if (Query <> nil) and (Prot <> nil) then
        ProtStrings(Query.Sql);
      EMess(Query, E, 'Init',[0]);
    end;
  end else
    GNavigator.DoNavLinkInit(self);     {z.B. für Translations}
end;

procedure TNavLink.CheckFltrFields;
//entfernt Filter auf nicht vorhandene FieldDefs-Felder - 08.01.12
//Vorauss.: FieldDefs
//Idee: in newboforeopen: schlecht wg userfilter?
  function CheckFltrField(S, ALine: string): boolean;
  var
    S1: string;
  begin
    Result := true;
    S1 := StrParam(ALine);
    if Pos('.', ALine) = 0 then  //beware SRTE.SRTE_NR=BHAE.SRTE_NR no field
    begin
      if DataSet.FieldDefList.IndexOf(S1) < 0 then
      begin
        Prot0('WARN CheckFltrFields %s.%s %s no field', [
              OwnerDotName(DataSet), S, ALine]);
        Result := false;
      end;
    end;
  end;
begin
  if DataSet = nil then
    Exit;
//beware! es gibt Filter-Felder die nicht in den Fielddefs sind
//
//  for I := FltrList.Count - 1 downto 0 do
//  begin
//    if not CheckFltrField('FltrList', FltrList[I]) then
//      FltrList.Delete(I);
//  end;
//  for I := References.Count - 1 downto 0 do
//  begin
//    if not CheckFltrField('References', References[I]) then
//      References.Delete(I);
//  end;
end;

procedure TNavLink.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if (AComponent = DataSource) then
      DataSource := nil;
    if (AComponent = EditSource) then
      EditSource := nil;
    if (AComponent = LookUpSource) then
      LookUpSource := nil;
    if (AComponent = FDBGrid) then
      FDBGrid := nil;
  end;
end;

procedure TNavLink.StateChange(Sender: TObject);
var
  AForm: TqForm;
begin
  if ([csLoading,csDesigning,csDestroying] * Owner.ComponentState = []) then
  begin
    if nlState in nlEditStates then     {AfterPost-Ereignis kann damit erkennen}
      EditState := nlState;             {               ob von Insert oder Edit}
    AForm := Form as TqForm;
    if AForm = nil then
      Exit;
    {if EditSource <> DataSource then
      GNavigator.X.EditingChanged;}
    AForm.BroadcastMessage(DataSource, TMultiGrid, BC_STATECHANGE, ord(nlState));
    PostMessage(AForm.Handle, BC_LNAVIGATOR, lnavSetTitel, 0);
    {SendMessage(AForm.Handle, BC_CHECKREADONLY, WPARAM(0), LPARAM(0)); {Post bis 020400}
    PostMessage(AForm.Handle, BC_CHECKREADONLY, WPARAM(0), LPARAM(0)); {Post! QDispo.Disp.AfterPost. else infinite recusion 050501}
  end;
end;

(*** Ereignisse *************************************************************)

procedure TNavLink.NewBeforeClose(ADataSet: TDataSet);
var
  ANavLink: TNavLink;
begin
  if not InBeforeClose then
  try
    InBeforeClose := true;
    if assigned(OldBeforeClose) then
      OldBeforeClose(DataSet);
    if IsLookUpDef and AutoOpen and (MasterSource <> nil) and
       ([csLoading,csDesigning,csDestroying] * Owner.ComponentState = []) then
    begin
      ANavLink := DsGetNavLink(MasterSource);
      if ((ANavLink <> nil) and
          (ANavLink.InDoEdit or ANavLink.InEditCancel or ANavLink.InDoPostEx or
           ((Form <> nil) and TqForm(Form).InCloseQuery)) and
          not ANavLink.InBeforeCancel and            {User-Routinen}
          not ANavLink.InAfterCancel and
          not ANavLink.InNewBeforePost and
          not ANavLink.InAfterPost and
          not ANavLink.InBeforeEdit and
          not ANavLink.InDoPostEx and
          not ANavLink.InAfterReturn) and            //')' 11.02.03
         not InBuildSql and
         not InRefresh then
      begin
        if SysParam.ProtBeforeOpen then    //weg 11.02.03 if ab 01.05.04
          Prot0(SNLnk_Kmp_003,[OwnerDotName(ADataSet)]);	// 'Abbruch Schließen (%s)'
        SysUtils.Abort;
      end;
    end else
    if (Owner <> nil) and (Owner is TLNavigator) then
    begin                                                   {160200 HDO.RZep dupl}
      if InsertFlag then                     {PKey Filter setzen ohne zu öffnen}
        TLNavigator(Owner).DetailInsert(diRefresh);
    end;
    if SysParam.ProtBeforeOpen then
      Prot0(SNLnk_Kmp_004,[OwnerDotName(ADataSet)]);		// 'Schließe (%s)'
  finally
    InBeforeClose := false;
  end;
end;

procedure TNavLink.NewBeforeOpen(ADataSet: TDataSet);
var
  AMasterSource: TDataSource;
  ANavLink: TNavLink;
  aDB: TuDataBase;
begin
  //cr := Screen.Cursor;
  if IsLookupDef then
    FRecordCount := 0;      {-> Buildsql}
  Inc(SysParam.NewBeforeOpenCount);
  try
    if (ADataSet.DataSource <> nil) and not dsQuery and not dsChangeAll then    {Params - Typen}
    begin
      AMasterSource := ADataSet.DataSource;
      if (AMasterSource.DataSet <> nil) then
      begin
        FMasterAktiv := AMasterSource.DataSet.Active;
        if not FMasterAktiv then
        begin
          Prot0('WARN %s: Master %s is not open', [OwnerDotName(ADataSet), OwnerDotName(AMasterSource.DataSet)]);
          AMasterSource.DataSet.Open;
        end;
      end;
      if (AMasterSource.DataSet <> nil) and
         (AMasterSource.DataSet.FieldDefs.Count = 0) and
         (AMasterSource.DataSet.FieldCount = 0) and
         not StaticFields then
      begin
        //Screen.Cursor := crHourGlass;
        SMess(SNLnk_Kmp_005,[TableName]);		// 'Lese O(%s)'
        {AMasterSource.DataSet.FieldDefs.Update;}
        {UpdateFieldDefs(AMasterSource.DataSet);}
        ANavLink := DsGetNavLink(MasterSource);
        if ANavLink <> nil then
          FldDsc.Update(AMasterSource.DataSet, ANavLink.TableName, ANavLink.SqlFieldList);
        SMess('',[0]);
        //Screen.Cursor := cr;
      end else
      if (Query <> nil) and
         (SysParam.Paradox or SysParam.Access) then    {Paradox Fehler}
      begin
      { Win16: if Query.ParamCount > 0 then
        try
          if NullParam <> Query.Params[0].IsNull then
          begin
            S1 := Query.SQL.GetText;
            Query.SQL.SetText(S1);
            StrDispose(S1);
          end;
          NullParam := Query.Params[0].IsNull;
        except on E:Exception do
          EProt(self, E, 'BeforeOpen.NullParam(%s,%s)',[Display, Query.Name]);
        end; }
      end;
    end;
    if assigned(OldBeforeOpen) then         {241099 : vor HangingSql wg. CheckSql}
      OldBeforeOpen(ADataSet);              //12.09.02Bug
    if SysParam.ReadOnly then
      LiveRequest := false;
    if (Query <> nil) and not NoBuildSql then        {q}
    begin
      if HangingSql or not CalcOK then     {Calcok 040398}
        BuildSql;
      if not InitKeyFields then
      begin
        InitKeyFields := true;
        if PermanentKeysAllowed and {LoadedKeyFields = '' then 06.04.02}
           (Form <> nil) then
          TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID,
            mgLoadKeyList);  {wenn Multi mit KeyInfos: SetKeyFields (BuildSql)}
      end;
      CheckKeyFields(true);
      CheckSql(Query);
    end;
    if SysParam.MSSQL and (Query <> nil) and
//       not InNewAfterOpen and
//       not InComWait and
       (SysParam.NewBeforeOpenCount = 1) then  //Rekursion/Schachtelaufruf vermeiden
    begin
      (* 24.05.09: wirkt iVm TuDatabase.DoConnect *)
      aDB := QueryDatabase(Query);
      if (aDB <> GNavigator.DB1) and (aDB is TuDatabase) then
        TuDatabase(aDB).ExecConnectSql;  //MSQL: SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    end;
    {if Query.ParamCount > 0 then
    begin
      if Query.DataSource <> nil then
        S1 := Query.DataSource.DataSet.FieldByName(Query.Params[0].Name).AsString;
      Sql0 := Query.Params[0].Text;
    end;}

  //   if Sysparam.MSSQL and
  //      ((Sysparam.SlideBar and (MultiGrid <> nil) and not (muNoSlideBar in TMultiGrid(MultiGrid).MuOptions)) or
  //       ((MultiGrid <> nil) and (muSlideBar in TMultiGrid(MultiGrid).MuOptions))) then
  //   begin
  //     GetRecordCount;
  //   end;
    if SysParam.ProtBeforeOpen then
    begin
      Prot0(SNLnk_Kmp_006,[OwnerDotName(ADataSet),	//    Prot0('Öffne (%s)F%dD%d:'
            ADataSet.FieldCount, ADataSet.FieldDefs.Count]);
      //24.03.09 in afteropen - ProtSql(ADataSet);
    end;
  //  if (GNavigator <> nil) and (SysParam.Delay > 0) then
  //  begin
  //    if not GNavigator.NoOpenSMess then
  //      SMess(SNLnk_Kmp_035, [Display, SysParam.Delay]);    // 'Öffne (%s) %dms'
  //    GNavigator.NoProcessMessages := true;
  //    Delay(SysParam.Delay);
  //    GNavigator.NoProcessMessages := false;
  //  end else
      if not GNavigator.NoOpenSMess and not NoOpenSMess then
        SMess(SNLnk_Kmp_007, [Display]);     // 'Öffne (%s)'
    ComWait;     {Warten bis serielle Kommunikation sicher}
  finally
    Dec(SysParam.NewBeforeOpenCount);
    InRefresh := false;  //wird für Ereignis BeforeOpen verwendet
  end;
end;

procedure TNavLink.NewAfterOpen(ADataSet: TDataSet);
{Nachdem DataSet geöffnet wurde}
var
  AMasterSource: TDataSource;
begin
  (*if (Query <> nil) and (Query.ParamCount > 0) then
  begin
    if (Query.DataSource <> nil) then
    try   //and (Query.DataSource.DataSet <> nil)
      S1 := Query.DataSource.DataSet.FieldByName(Query.Params[0].Name).AsString;
    except on E:Exception do
      S1 := E.Message;
    end;
    Sql0 := Query.Params[0].Text;
    b := Query.Params[0].IsNull;
  end;*)
  InNewAfterOpen := true;
  try
    if not CalcOK then
    begin
      CalcOK := true;           {wichtig wg. Rekursion}
      AddCalcFields;
    end;
    if assigned(OldAfterOpen) then
      OldAfterOpen(ADataSet);
    if (ADataSet.DataSource <> nil) and not dsQuery and not dsChangeAll then    {Params - Typen}
    begin
      AMasterSource := ADataSet.DataSource;
      if (AMasterSource.DataSet <> nil) and (AMasterSource.DataSet.Active <> FMasterAktiv) then
        AMasterSource.DataSet.Active := FMasterAktiv;    {restaurieren}
    end;
    if Form <> nil then
      TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgSetRecCount);
    if SysParam.ProtBeforeOpen then
    begin
      ProtA('%s', [QueryText(ADataSet, [])]);  //24.03.09: qtoOneLine weg
      Prot0(SNLnk_Kmp_008, [OwnerDotName(ADataSet), BoolToStr(ADataset.EOF)]);	// 'Geöffnet(%s):EOF=%s'
    end;
    if SysParam.MSSQL and (Query <> nil) then
    begin
      (* 24.05.09: wirkt hier nicht (zu spät)
      aDB := QueryDatabase(Query);
      if aDB is TuDatabase then
        TuDatabase(aDB).CheckIsolation;       *)
    end;
    if not GNavigator.NoOpenSMess and not NoOpenSMess then
      SMess0;
  finally
    InNewAfterOpen := false;
  end;
end;

procedure TNavLink.NewAfterScroll(ADataSet: TDataSet);
{Nachdem DataSet mit next,Prior usw. geändert wurde}
begin
  //25.04.13 Workaround für Scrollbars - jetzt in TLNavigator.DoOnSingleDataChange
//  AForm := Form;
//  if (AForm <> nil) and (AForm is TqForm) then
//    TqForm(AForm).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgForceScrollBar);
  if assigned(OldAfterScroll) then
    OldAfterScroll(ADataSet);
end;

procedure TNavLink.ClearCalcCache;
//Löscht Cache so dass Lookup Werte neu eingelesen werden
var
  I: integer;
begin
  for I := 0 to CalcCacheList.Count - 1 do
    TCalcCache(CalcCacheList.Objects[I]).Clear;
end;

procedure TNavLink.ClearCalcField;
//Löscht Cache so dass aktueller Lookup Wert neu eingelesen wird
var
  I: integer;
begin
  for I := 0 to CalcCacheList.Count - 1 do
    TCalcCache(CalcCacheList.Objects[I]).ClearCalcField(DataSet);
end;

procedure TNavLink.CacheCalcFields(ADataSet: TDataset; Modus: integer);
//mehrere CalcFields öffnen nur einmal die Table.
//Modus: +1 = mit Init (1,3); +2 = mit Exit (2,3)
var
  I: integer;
begin
  if CalcCacheList.Count > 0 then
  try
    if Modus and 1 <> 0 then
      for I := 0 to CalcCacheList.Count - 1 do
        TCalcCache(CalcCacheList.Objects[I]).InitLuDef;
    for I := 0 to CalcCacheList.Count - 1 do
      TCalcCache(CalcCacheList.Objects[I]).DoCalcField(ADataSet);
    if Modus and 2 <> 0 then
      for I := 0 to CalcCacheList.Count - 1 do
        TCalcCache(CalcCacheList.Objects[I]).ExitLuDef;
  except on E:Exception do
    EProt(self, E, 'CacheCalcFields(%d)', [Modus]);  //12.10.10
  end;
end;

procedure TNavLink.NewCalcFields(ADataSet: TDataset);
var
  oldPM: boolean;
begin
  oldPM := false;
  if not InCalcFields and CalcOK and not dsQuery and not dsChangeAll then
  try
    if GNavigator <> nil then
    begin
      oldPM := GNavigator.NoProcessMessages;
      GNavigator.NoProcessMessages := true;      {kein ComWait o.ä.}
    end;

    InCalcFields := true;
    try
      if ADataSet.State = dsCalcFields then
      begin
        CacheCalcFields(ADataSet, 1);
        if assigned(FOnGet) then
        try
          //Falls hier Keyfields für die Cache-Tabelle geändert werden, ist
          //(1) Navlink.ClearCalcCache aufzurufen und (2) die Cache-Table zu schließen - QURE 01.06.08
          FOnGet(ADataSet);
        except on E:Exception do
          EProt(Owner, E, 'CalcFields.OnGet(%s)', [OwnerDotName(ADataSet)]);
        end;
        //03.06.09 (webab.bvor.cf): auch bei Disabled sollen CalcFields gerechnet werden!
        //if not ADataSet.ControlsDisabled then                    {150400 ISA Import}
        //
          DoRech(ADataSet, nil, true, rsCalcFields);
        {nochmal hier aufrufen falls Calcfields als Keyfields verwendet werden, QSBT KAST 02.08.02 }
        CacheCalcFields(ADataSet, 2);
      end;
      if assigned(OldCalcFields) then
      try
        OldCalcFields(ADataSet);
      except on E:Exception do
        EProt(Owner, E, 'CalcFields.OldCalcFields(%s)',[OwnerDotName(ADataSet)]);
      end;
    finally
      InCalcFields := false;
    end;
  finally
    if GNavigator <> nil then
      GNavigator.NoProcessMessages := oldPM;
  end;
end;

procedure TNavLink.NewBeforeInsert(ADataSet: TDataset);
begin
  if not (csDesigning in Owner.ComponentState) and not dsQuery and not dsChangeAll then
  begin
    if InMuKeyDown then
      SysUtils.Abort;
    (*try      11.11.01 OldBeforeInsert darf mit Exception Insert abbrechen
      Prefix := 'OldBeforeInsert';
      if assigned(OldBeforeInsert) then
        OldBeforeInsert(ADataSet);
    except on E:Exception do
      EMess(ADataSet, E, 'NewBeforeInsert.%s',[Prefix]);
    end;*)
    if assigned(OldBeforeInsert) then
      OldBeforeInsert(ADataSet);
  end;
end;

procedure TNavLink.NewAfterInsert(ADataSet: TDataset);
var
  Prefix: string;
begin                                 (* Erfass *)
  if not (csDesigning in Owner.ComponentState) and not dsQuery and not dsChangeAll then
  begin
    try
      Prefix := 'OldAfterInsert';
      if assigned(OldAfterInsert) then
        OldAfterInsert(ADataSet);
    except on E:Exception do
      EMess(ADataSet, E, 'NewAfterInsert.%s',[Prefix]);
    end;
  end;
end;

procedure TNavLink.NewBeforePost(ADataSet: TDataSet);
(* autocommit verwalten *)
var
  Btn: word;
begin
  if not (csDesigning in Owner.ComponentState) and not dsQuery and not dsChangeAll then
  try
    InNewBeforePost := true;
    if assigned(OldBeforePost) and not InOldBeforePost then
    try
      InOldBeforePost := true;
      OldBeforePost(ADataSet);
    finally
      InOldBeforePost := false;
    end;
    DoValidate(ADataSet.Fields[0]); // DoValidate(nil); - ab 13.01.09
    if not AutoCommit and (ADataSet.State in [dsEdit,dsInsert]) then
    begin
      if (Owner is TLNavigator) or
         (IsLookUpDef and (TLookUpDef(Owner).MDTyp = MDDetail)) then
      begin
        MessageBeep(MB_OK);
        //Btn := MessageDlg(Format(SNLnk_Kmp_009 +CRLF+	// 'Daten wurden geändert (%s).'
        //  SNLnk_Kmp_010, [Display]), mtConfirmation, [mbYes,mbCancel], 0);	// 'Speichern ?'
        //unterstützt Batch Mode ab 03.01.10:
        Btn := MessageFmt(SNLnk_Kmp_009 +CRLF+	// 'Daten wurden geändert (%s).'
          SNLnk_Kmp_010, [Display], mtConfirmation, [mbYes,mbCancel], 0);	// 'Speichern ?'
        if Btn = mrCancel then                              {kein No hier}
          SysUtils.Abort;
        ClearEmptyFields(DataSet);
        GNavigator.DoBeforePost(EditSource.DataSet);     {291099 SDO.ToGr}
      end else
      if IsLookUpDef then    {nur mdMaster}
      begin
        DataSet.Cancel;
        SysUtils.Abort;                {Stille Exception}
      end;
    end;
    ComWait;     {Warten bis serielle Kommunikation sicher}
    if assigned(Repl) then
      if ADataSet.State = dsInsert then
        Repl.Ins(TableName, DataSet) else
      if ADataSet.State = dsEdit then
        Repl.Upd(TableName, DataSet);
  finally
    InNewBeforePost := false;
  end;
end;

procedure TNavLink.NewBeforeDelete(ADataSet: TDataSet);
(* Löschen an Details weitergeben *)
var
  I: integer;
  S: string;
  ALuDef: TLookUpDef;
begin
  if not (csDesigning in Owner.ComponentState) and not dsQuery and not dsChangeAll then
  begin
    GNavigator.DoBeforeDelete(ADataSet);
    if assigned(OldBeforeDelete) then
      OldBeforeDelete(ADataSet);
    if assigned(Repl) then
      Repl.Del(TableName, DataSet);
    if not SysParam.NoDeleteDetails then        {Einstellung GEN.RefIntegr}
    begin
      if SysParam.SoftDelete and (Form <> nil) then   //waage
      begin
        TqForm(Form).BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF, ldDeleteDtl);
      end else
      if Form <> nil then
      begin
        for I:= 0 to Form.ComponentCount-1 do
        begin
          if Form.Components[I] is TLookUpDef then
          begin
            ALuDef := Form.Components[I] as TLookUpDef;
            if (ALuDef.MasterSource = DataSource) and
               (ALuDef.MDTyp = mdDetail) and
               (ALuDef.DeleteDetails) then
              ALuDef.DeleteAll;
          end;
        end;
      end;
    end;
    S := '';
    try
      for I := 0 to PrimaryKeyList.Count - 1 do
        AppendTok(S, Format('%s=%s', [PrimaryKeyList[I],
          ADataSet.FieldByName(PrimaryKeyList[I]).AsString]), ';');
    except on E:Exception do
      EProt(self, E, 'Warnung:PrimaryKeyFields(%s) falsch', [FPrimaryKeyFields]);
    end;

    //Cached Updates entfernt unidac;
    if (TableName <> '') or (S <> '') then  //nicht bei MemTable
      Prot0(SNLnk_Kmp_011, [TableName, S, Sysparam.UserName + '@' + CompName]);    // 'Lösche %s(%s) User(%s)'
  end;
end;

procedure TNavLink.NewAfterPost(ADataSet: TDataSet);
begin
  if not InAfterPost then
  begin
    InAfterPost := true;
    try
      //Cached Updates entfernt unidac;

      //erst hier ist tatsächlich geschrieben
      if not IsLookUpDef then  //Reload2, PageIndex
        TLNavigator(Owner).AfterPost;    //19.08.02 LAWA.MEST
      GNavigator.DoAfterPost(self);
      if assigned(OldAfterPost) then
        OldAfterPost(ADataSet);
    finally
      InAfterPost := false;
    end;
    if SafeReloadFlag then
    begin
      SafeReloadFlag := false;
      SafeRefreshFlag := false;
      ReLoad;
    end;
    if SafeRefreshFlag then
    begin
      SafeRefreshFlag := false;
      Refresh;
    end;
  end;
end;

procedure TNavLink.NewAfterCancel(ADataSet: TDataSet);
begin
  if not InAfterCancel then
  begin
    InAfterCancel := true;
    try
      if not IsLookUpDef then
        TLNavigator(Owner).AfterCancel;    //30.09.02

      if assigned(OldAfterCancel) then
        OldAfterCancel(ADataSet);
    finally
      InAfterCancel := false;
    end;
    if SafeReloadFlag then
    begin
      SafeReloadFlag := false;
      SafeRefreshFlag := false;
      ReLoad;
    end;
    if SafeRefreshFlag then
    begin
      SafeRefreshFlag := false;
      Refresh;
    end;
  end;
end;

procedure TNavLink.NewDataChange(Sender: TObject; Field: TField);
(* zentrale Anlaufstelle für alle Felder. Startet OnRech *)
{Beim nächsten ist TField nil sonst TField <> nil siehe Delphi Hilfe OnDataChange}
var
  AField: TField;
  AFieldName, AFieldText: string;
  AForm: TqForm;
  ALNav: TLNavigator;
  ALuDef: TLookUpDef;
  ALuEdit: TLookUpEdit;
  EditSet: TDataSet;
  MasterLink: TNavLink;
  Btn: Word;
  OnlyCalcFields: boolean;
  Msg: TWMBroadcast;
  //OldInDataChange: boolean;
begin
  if dsQuery or dsChangeAll or
     ([csDesigning,csLoading,csDestroying] * Owner.ComponentState <> []) then
    Exit;
  AField := Field;
  AForm := TqForm(Form);
  if AForm = nil then exit;
  ALNav := AForm.LNavigator;
  if ALNav = nil then exit;
  if EditSource <> nil then
  begin
    EditSet := EditSource.DataSet;
    if EditSet.Modified then
    begin
      ALNav.NavLink.Modified := true;
      Modified := true;            {falls LuDef geändert wurde. 130400 ISA.POSI}
    end;
  end else
    EditSet := nil;
  if assigned(OldDataChange) and not InDataChange then
  try
    InDataChange := true;
    // neu 22.12.06 - bereits hier. Hat alle Möglichkeiten:
    // LuEdi Flags ändern (SQVA.VPOS);
    OldDataChange(Sender, Field);
  finally
    InDataChange := false;
  end;
  ALuEdit := TLookUpEdit(ALNav.ActiveLookUpEdit);  //nil bei Memo
  //TODO LookupMemo
  if Field = nil then
  begin
    if (NlState in nlEditStates) and      {erst beim nächsten ändern ! GEN.RefIntegr}
       not InDoPost then                  //ein Field.ReadOnly:=false von Gnav.BeforePost gelangt hier hin! - TMB 28.09.06
      ChangedFields.Clear;
  end else
  begin
    if not InClearEmptyFields and //12.01.11 ''->null nicht markieren
       not Field.Calculated then //15.04.10 Calcfields hier nicht listen (eanv.ents)
      ChangedFields.Add(UpperCase(Field.FieldName));  //Großbuchstaben 10.09.03
  end;

  (* von LNav *)
//  OldInDataChange := InDataChange;
  if (NlState in nlEditStates) and (Field <> nil) and (Query <> nil) then
  begin
    if SysParam.ProtBeforeOpen then
      Prot0('DATACHANGE(%s.%s):%.80s', [Owner.Name, Field.FieldName, Field.AsString]);
    if (ALuEdit <> nil) and (ALuEdit.DataSource = EditSource) and
       not ALNav.InDataPut then
//13.03.12       not ALuEdit.InDataChange then //12.03.12 test
    try
//      OldInDataChange := InDataChange;
//13.03.12      InDataChange := true;  //12.03.12
      Msg.Msg := BC_DATACHANGE;
      Msg.Data := Field.Index; //word(Field.Index);
      Msg.Sender := ALuEdit;          {wird abgefragt!}
      Msg.Result := 0;
      ALuEdit.Dispatch(Msg);
      {if Msg.result <> 0 then break}
    finally
//13.03.12      InDataChange := OldInDataChange;  //12.03.12
    end;
    AForm.BroadcastMessage(EditSource, TLookUpEdit, BC_DATACHANGE,
                           Field.Index);     {word(Field.Index) 20.07.03. FieldNo 140897}
    if SysParam.ProtBeforeOpen then	// 'endeCHANGE(%s.%s):%s'
      Prot0(SNLnk_Kmp_012, [Owner.Name, Field.FieldName, copy(Field.AsString, 1, 80)]);
  end else
  if NlState = nlBrowse then
  begin  //tmb 24.07.06
    //in NewAf ter Scroll     works!
    AForm.BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgDataChanged);
    // 21.02.12 - luedi änderte sql. Setzte hanging sql
    AForm.BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF, ldReOpen);
  end;
  MasterLink := nil;
  if not InDataChange then
  try
    InDataChange := true;
    if IsLookUpDef then
    begin
      ALuDef := Owner as TLookUpDef;
      MasterLink := dsGetNavLink(ALuDef.MasterSource);
    end else
      ALuDef := nil;
    ALuEdit := TLookUpEdit(ALNav.ActiveLookUpEdit);
    {if (ALuEdit <> nil) and (ALuEdit.LookUpSource <> EditSource) then
      ALuEdit := nil;           {nicht nötig da auch von Grid}

    (* von LuDef *)
    if (ALuDef <> nil) and (DataPos <> nil) and (EditSet <> nil) and
       {not DataPos.InPutMasterFields and}
       (Field = nil) and                       {16.02.98}
       (MasterLink <> nil) and                  {20.03.99}
       {not MasterLink.InDoPost and             nein 130201 GEN}
       not MasterLink.InDoCancel and            {130201}
       not MasterLink.InEdit and                {not ALNav.NavLink.InEdit then}
       not MasterLink.InBeforeInsert and        //25.04.03 SIZU
       not ALNav.InCheckAutoOpen and            //26.03.08 dpe.ents
// beware (not (luOnlyAfterReturn in ALuDef.Options) or (Field <> nil)) and  //06.04.10 dpe erzf
       true then
    begin
      try
        if (MDTyp = mdMaster) and
           (MasterSource <> nil) and
           (MasterSource.State in [dsEdit,dsInsert]) and
           (nlState in [nlBrowse]) then
//13.03.12           (MasterLink <> nil) and MasterLink.InDataChange then //12.03.12 test
        begin
          {DataPos.GetValues(EditSet);
          if not DataPos.IsEmpty then}
          if not EditSet.EOF then
          begin                   {Felder nicht leer: gefunden: PutSOFields}
            ALNav.InDataPut := true;
            {if SysParam.ProtBeforeOpen then Prot0('PutSOFields(%s)',[Owner.Name]); in LuDef}
            ALuDef.PutSOFields; {keine Key/Reference-Fields bzw. Identischen Inhalte}
            {if SysParam.ProtBeforeOpen then Prot0('EndSOFields(%s)',[Owner.Name]); in LuDef}
            ALNav.InDataPut := false;
          end else
          if ALNav.NavLink.InOnRech then  {wenn in Rech-Ereignis}
          begin
            if not (luTolerant in ALuDef.Options) then
              ALuDef.PutSOFields;  {Leere Felder übernehmen}
          end else                         {nur bei Bedienereingabe 140997}
          begin                   {Felder sind leer: nicht gefunden}
            AFieldName := '';           {keine Active Control für diese Lookup}
            // Grid:SelectedField   Single:ActiveLookUpField
            if (AForm.ActiveControl is TDBGrid) and
               (TDBGrid(AForm.ActiveControl).DataSource = ALuDef.MasterSource) and
               (Pos(TDBGrid(AForm.ActiveControl).SelectedField.Fieldname,
                    ALuDef.MasterFieldNames) > 0) then
            begin
              Field := TDBGrid(AForm.ActiveControl).SelectedField;
              AFieldName := Field.FieldName;
              AFieldText := GetFieldText(Field);
              //13.03.12 auch hier
              if not (luTolerant in ALuDef.Options) and not ALNav.InStartLookUp then
                ALuDef.PutSOFields;    {Leere Felder übernehmen 101198 bereits hier. Siehe auch LuEdi I.V.m AutoOpen}
            end else
            if (ALuEdit <> nil) and (ALuEdit.LookUpSource = EditSource) and
               ALuEdit.InDataChange then  //nur wenn in LuEdit geöffnet - 09.03.12 UniDAC
            begin
              try
  //              begin
  //13.03.12                ALuEdit.InDataChange := false; //damit nicht mehrmals aufblenden - 11.03.12
                  AFieldName := ALuEdit.LookUpField;
                  AFieldText := ALuEdit.EditText;
                  AField := EditSet.FieldByName(AFieldName);
                  if AField.EditMask <> '' then
                    AFieldText := TrimIdent(AFieldText);  {Sonderz. weg}
  //test 12.03.12 nach unten
  //                if AFieldText <> '' then
  //                  if [luTolerant,luMessage,luTabelle] * ALuDef.Options <> [luTolerant] then
  //                    AForm.ActiveControl := ALuEdit;
                  {if ALuEdit.CanFocus then ALuEdit.SetFocus;          schlecht wenn nicht ActiveForm}
  //              end else
  //                InDataChange := false;  //damit einmal aufblenden - test 11.03.12
              except
                {is hidden}
              end;
              if not (luTolerant in ALuDef.Options) and not ALNav.InStartLookUp then
                ALuDef.PutSOFields;    {Leere Felder übernehmen 101198 bereits hier. Siehe auch LuEdi I.V.m AutoOpen}
            end;
            if AFieldName <> '' then
            begin
              {if not (luTolerant in ALuDef.Options) and not ALNav.InStartLookUp then
                ALuDef.PutSOFields;    {Leere Felder übernehmen 101198 weg}
              if (AFieldText <> '') and not HangingLookUp then
              begin
                if MasterLink.InDoPost and not (luTolerant in ALuDef.Options) then
                  MasterLink.InDoPost := false;               {nicht speichern}
                if (luMessage in ALuDef.Options) and not ALNav.InStartLookUp then
                begin
                  //12.03.12 test hierher wg voklfrm
                  if ALuEdit <> nil then
                    if [luTolerant,luMessage,luTabelle] * ALuDef.Options <> [luTolerant] then
                      AForm.ActiveControl := ALuEdit;

                  {Prot0('Lookup nicht gefunden:', [0]);
                  if Query <> nil then
                    ProtStrings(Query.SQL);}
                  if luTabelle in ALuDef.Options then
                    Btn := DoMsgFmt(mtWMessConfirmation, MSG_VALUENOTFOUND,
                      SNLnk_Kmp_013+CRLF+SNLnk_Kmp_014,		// 'Wert(%s) in(%s.%s) nicht gefunden.'+CRLF+'Tabelle ?',
                      [AFieldText, Display, AFieldName]) else
                    Btn := DoMsgFmt(mtWMessConfirmation, MSG_VALUENOTFOUND,
                      SNLnk_Kmp_013,	// 'Wert(%s) in(%s.%s) nicht gefunden.',
                      [AFieldText, Display, AFieldName]);
                  {Btn := MessageFmt('Wert(%s) in(%s) nicht gefunden.'+CRLF+
                  'Tabelle ?',[AFieldText,Display], mtConfirmation,
                  mbYesNoCancel+[mbHelp], HI_21)}
                end else
                if luTabelle in ALuDef.Options then
                  Btn := mrYes else
                  Btn := mrNo;
                if Query <> nil then
                  ProtSQL(Query);
                if Btn = mrYes then
                begin
                  ALuDef.HangingReturn := false;
                  HangingLookUp := true;
                  ALNav.StartLookUp(lumTab, Owner as TLookUpDef)
                end
              end; {Feld nicht erkennbar: kein PutSOFields }
            end;
          end;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    if not ALNav.NavLink.InEdit then             {HLW, ROE}
    begin
      OnlyCalcFields := not (NlState in [nlEdit,nlInsert]);
      if not OnlyCalcFields or (CalcList.Count = 0) then
        DoRech(EditSet, AField, OnlyCalcFields, rsDataChange);
    end;
    { ab 22.12.06 nach vorne gebracht, um Flags zu ändern usw.
    if assigned(OldDataChange) then
      OldDataChange(Sender, Field); }
    {TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_EXTGRIDSCR, egDataChanged); Idee 2003 o.s.}

    //neu 29.11.09
    if not IsLookUpDef and (ALNav <> nil) and (ALNav.PageIndex < 10) then
      ALNav.DoOnSingleDataChange(AField);

    if HangingLookUp then
      HangingLookUp := false;
  finally
    InDataChange := false;
  end;
end; { NewDataChange }

procedure TNavLink.FieldOnGetTextTrimL0(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin {Anzeigewert ist Speicherwert ohne führende 0en}
  Text := LTrimCh(Sender.AsString, '0');
end;

procedure TNavLink.FieldOnGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  AAsw: TAsw;
begin {Auswahlstring statt gespeichertem Wert zu Anzeige bringen}
  AAsw := Asws.Asw(Sender.Tag); {Ausswahl über Tag holen}
  if AAsw <> nil then
  begin
    {Text := AAsw.Items.Values[Sender.AsString]; nicht case sensitiv !}
    Text := AAsw.FindValue(Sender.AsString); {Text dazu holen}
    if Text = '' then                {130300 kommt nicht mehr vor}
      Text := Sender.AsString;                  {nicht in Asw gefunden}
  end else
    Text := Sender.AsString;
end;

procedure TNavLink.FieldOnSetText(Sender: TField; const Text: string);
var
  S: string;
  AAsw: TAsw;
begin {Auswahlstring nach Speicherformat zum Übernehmen übersetzen}
  AAsw := Asws.Asw(Sender.Tag);
  if AAsw <> nil then
  begin
    if nlState = nlQuery then
    begin
//      S1 := '';
//      for I := 1 to Length(Text) do
//      begin
//        //['=', '<', '>', '~'] ['|',';','&'] ['~']
//        if CharInSet(Text[I], OptTokens + BlockTrenner + BetweenTrenner + ['%','?','~']) then
//        begin
//          if S1 <> '' then
//            S1 := StrDflt(AAsw.FindParam(S1), S1);  //05.07.10 StrDflt für Werte nicht in Asw
//          S := S + S1 + Text[I];
//          S1 := '';
//        end else
//          S1 := S1 + Text[I];
//      end;
//      if S1 <> '' then
//        S := S + StrDflt(AAsw.FindParam(S1), S1);
      S := AAsw.UnFormatFilter(Text);  //29.10.13
    end else
      S := AAsw.FindParam(Text);
  end else
    S := '';
  if S <> '' then
    Sender.AsString := S else
    Sender.AsString := Text;
end;

(*** Methoden ****************************************************************)

procedure TNavLink.CalcFields;
(* Dataset.OnCalcFields und Nav.OnGet durchführen.
   Statt Refresh verwenden wenn dort Fehlermeldung kommt *)
begin
  if Dataset = nil then
    Exit;
  if SysParam.Standard then
  begin
    DataSet.Refresh;
  end else
  if DataSet is TCustomDADataSet then
  begin
    TCustomDADataSet(Dataset).RefreshRecord;  //lädt neu von DB Cursor, Resync
  end else
  begin
    {Commit;                     {Auch bei dsBrowse ok}
    if DataSet.State in dsEditModes then
      DataSet.Cancel;
    DataSet.CheckBrowseMode;
    DataSet.UpdateCursorPos;
    DataSet.Resync([]);
  end;
end;

procedure TNavLink.DoValidate(Sender: TField);
(* Validate Ereignis für alle TField's *)
begin
  if not InDoValidate then
  try
    InDoValidate := true;
    (*
    if Sender is TFloatField then with Sender as TFloatField do   {zak men}
    begin
      P1 := Pos('.', DisplayFormat);
      if P1 > 0 then
      begin
        L := P1;
        while (L+1 <= length(DisplayFormat)) and
              (DisplayFormat[L+1] in ['0', '#']) do Inc(L);
        Nk := L - P1;
        D := AsFloat - RoundDec(AsFloat, Nk);
        if Abs(D) > 1E-9 then
          EError('%s: "%s" hat zu viele Nachkommastellen (%s)(%g)',
            [DisplayLabel, AsString, DisplayFormat, D]);
      end;
    end;
    *)
    if assigned(FOnValidate) then
      FOnValidate(Sender);
  finally
    InDoValidate := false;
  end;
end;

procedure TNavLink.DoRech(ADataSet: TDataSet; Field: TField; OnlyCalc: boolean;
 Sender: string);
var
  Calc, AFieldName: string;
begin
  RechSender := Sender;
  if assigned(FOnRech) and not InOnRech then
  begin
    {if SysParam.ProtBeforeOpen then Prot0('%s.%s.Rechnen(%s%s)',
          [Display, Sender, AFieldName, Calc]);}
    try
      InOnRech := true;
      FOnRech(ADataSet, Field, OnlyCalc);
    except
      on E:Exception do
      begin
        if OnlyCalc then
          Calc := ' OnlyCalc' else
          Calc := '';
        if Field <> nil then
          AFieldName := Field.FieldName else
          AFieldName := '(nil)';
        EMess(ADataSet, E, SNLnk_Kmp_015,	// '%s.%s.Rechnen(%s%s)',
          [Display, Sender, AFieldName, Calc]);
      end;
    end;
    {if SysParam.ProtBeforeOpen then Prot0('%s.%s.EndRech(%s%s)',
          [Display, Sender, AFieldName, Calc]);}
    InOnRech := false;
  end else
    Calc := 'Test';
end;

procedure TNavLink.DoNavigate(Index: TQbeNavigateBtn);
begin
  Screen.Cursor := crHourGlass;
  try
    case Index of
      qnbPrior: DataSource.DataSet.Prior;
      qnbNext: DataSource.DataSet.Next;
      qnbFirst: DataSource.DataSet.First;
      qnbLast: DataSource.DataSet.Last;
    end;
  except on E:Exception do
    if E is EInvalidGridOperation then
    begin
      //ErrException(DataSource.DataSet, E);
      Application.ProcessMessages;
      DoNavigate(Index);
    end else
      EMess(DataSource.DataSet, E, 'Positionierung', [0]);  //Owner
  end;
  (*  begin
      {ungültiges BLOB Handle}
      if E.Errors[0].ErrorCode = 10030 then    { $272E}
      begin
        ErrWarn('Zurückblättern nicht mehr möglich.' + CRLF +
                'Tabelle wird neu geladen.',[0]);
        DataSource.DataSet.Close;
        DataSource.DataSet.Open;
      end else
        raise;
    end;
  *)
  Screen.Cursor := crDefault;
end;

procedure TNavLink.DoQuery;
var
  Done: boolean;
begin
  Done := false;
  if assigned(FBeforeQuery) then
    FBeforeQuery(EditSource.DataSet, Done);
  if not Done and (GNavigator <> nil) then
    GNavigator.X.QueryActivate(qmQuery);
end;

procedure TNavLink.DoEdit(CheckRights: boolean = false);
var
  Done: boolean;
  ALNav: TLNavigator;
  AForm: TqForm;
  OldInDoEdit: boolean;
  Btn: word;
  OldAfterEdit: TDataSetNotifyEvent;
begin
  ALNav := nil;
  OldInDoEdit := false;
  if CheckRights and not (reUpdate in TabellenRechte) then
  begin
    ErrWarn(SQNav_Kmp_016, [Kennung]);	// 'Sie haben keine Rechte zum Ändern (%s)'
    Exit;
  end;
  AForm := Form as TqForm;
  if AForm <> nil then
    ALNav := AForm.LNavigator;
  Done := false;
  GNavigator.Canceled := false;               {240399}
  if ALNav <> nil then
  begin
    OldInDoEdit := ALNav.NavLink.InDoEdit;
    ALNav.NavLink.InDoEdit := true;
  end;
  InDoEdit := true;
  {InsertFlag := false;                 {160200 HDO.RZEP}
  try
    if assigned(Repl) then
      Repl.Edi(TableName, DataSet);     {hier passiert noch nichts}
    if assigned(FBeforeEdit) and not InBeforeEdit then
    try
      InBeforeEdit := true;
      FBeforeEdit(EditSource.DataSet, Done);
    finally
      InBeforeEdit := false;
    end;
    if not Done then
    begin
      EditSource.DataSet.Open;             //10.01.04 GEN
      if not (EditSource.DataSet.State in [dsInsert,dsEdit]) then
      begin
        try
          if FEditSingle and IsLookUpDef then
          begin
            if TLookupDef(EditSource).LookUpSource = nil then
              TLookupDef(EditSource).LookUp(lumAendMsk) else
              TLookupDef(TLookupDef(EditSource).LookUpSource).LookUp(lumAendMsk);
          end else
          begin
            try
              EditSource.DataSet.Edit;
            except                                 {Abort in AutoOpen.Close}
              if EditSource.DataSet.State = dsEdit then
              try
                OldAfterEdit := EditSource.DataSet.AfterEdit;
                if assigned(OldAfterEdit) then
                  OldAfterEdit(EditSource.DataSet); //wurde wg. except nicht normal aufgerufen
              except on E:Exception do
                EMess(EditSource.DataSet, E, 'DoEdit', [0]);
              end else
                raise;
            end;
            if FEditSingle and GNavigator.X.IsNavLink(self) then
            begin            {nicht bei LuDetails aktiv}
              GNavigator.BtnSingleClick(self);
            end;
            if Form <> nil then
            try
              if (EditControl <> nil) and EditControl.CanFocus then
              begin
                Form.ActiveControl := EditControl;    //10.02.04 gen
              end else
              if (ALNav <> nil) and (ALNav.NavLink = self) and
                 not ALNav.InDetailInsert and               //isa md17.05.08
                 (ALNav.FirstControl <> nil) and ALNav.FirstControl.CanFocus and
                 ((Form.ActiveControl = nil) or
                  (not (Form.ActiveControl is TCustomEdit) and
                   not (Form.ActiveControl is TCustomComboBox) and
                   not (Form.ActiveControl is TCustomRadioGroup) and
                   not (Form.ActiveControl is TRadioButton))) then
              begin
                Form.ActiveControl := ALNav.FirstControl;    //klappt beides nicht QUPE.ARBP
              end;
            except on E:Exception do
              EProt(ALNav, E, 'DoEdit.SetFocus', [0]);          {stille Behandlung}
            end;
          end;
        except
          on E:EDAError do
            //if ErrorCode = DBIERR_OPTRECLOCKFAILED then {2813H}
            begin
              Btn := DoMsgFmt(mtWMessConfirmation, MSG_LOADAGAIN,
                               '%s'+CRLF+SNLnk_Kmp_016, [E.Message]);	// '%s'+CRLF+'Neu Laden ?'
              if Btn = mrYes then
              begin
                {ResetFields;
                BuildSql;             nicht hier da loadagain dann nicht geht
                AddCalcFields;}
                ReLoad;           {selben Datensatz nochmal laden}
                EditSource.DataSet.Edit;
              end else
                SysUtils.Abort;
            end; //else raise;
          else
            raise;
        end;
      end;
      (* nicht in StateChange wg. QueryChanged *)
      if EditSource.DataSet.State in dsEditModes then
      try
        if EditSource.DataSet.State = dsInsert then
          EditState := nlInsert else  //wichtig für CachedObjects
          EditState := nlEdit;
        DoRech(EditSource.DataSet, nil, false, rsDoEdit);
      except
        on E:Exception do
          ErrWarn(SNLnk_Kmp_017,	// 'DoEdit.Rechnen(%s.%s):%s',
          [Owner.Name, EditSource.DataSet.Name, E.Message]);
      end;
    end;
    if GNavigator.X.IsNavLink(self) then
      GNavigator.X.DataSource := EditSource;
    Modified := false;
    ChangedFields.Clear; {03.06.02}
  finally
    InDoEdit := false;
    if ALNav <> nil then
      ALNav.NavLink.InDoEdit := OldInDoEdit;
  end;
end;

procedure TNavLink.DoInsert(CheckRights: boolean = false);
(* Erfassen als Reaktion auf Button, Key oder Programmaufruf: Empfohlen
  Berücksichtigt alle Einstellungen, insbesondere bei LookupDef
  Ruft OnErfass-Ereignis auf *)
var
  ALNav: TLNavigator;
  AForm: TqForm;
  Done: boolean;
  Prefix: string;
  OldInDoInsert: boolean;
  OldGotoPos: boolean;
  AField: TField;
  DisableFlag: boolean;
begin
  if CheckRights and not (reInsert in TabellenRechte) then
  begin
    ErrWarn(SQNav_Kmp_017, [Kennung]);	// 'Sie haben keine Rechte zum Erfassen (%s)'
    Exit;
  end;
  AField := nil;
  ALNav := nil;
  AForm := Form as TqForm;
  if AForm <> nil then
  begin
    ALNav := AForm.LNavigator;
    ALNav.NavLink.InDoInsert := true;
    OldInDoInsert := ALNav.NavLink.InDoInsert;
  end else
    OldInDoInsert := false;
  OldGotoPos := false;
  InDoInsert := true;                         {bereits hier wg. lnav.statechange 03.04.02}
  DisableFlag := false;
  try
    if (DsGetNavLink(EditSource) <> nil) and
       (DsGetNavLink(EditSource).nlState = nlInsert) then
      DsGetNavLink(EditSource).DoPost(CheckRights);                         {170399}
    GNavigator.Canceled := false;               {240399}

    if InsertFlag then                                 {Filter aufheben 18.02.02}
    try
      OldGotoPos := NoGotoPos;
      {NoGotoPos := true;    !beware ISA#Posi#Dupl          {nicht positionieren}
      if ALNav <> nil then
        ALNav.DetailInsert(diReset);
    finally
      NoGotoPos := OldGotoPos;
    end;
    InsertFlag := false;

    Done := false;
    if assigned(FBeforeInsert) and not InBeforeInsert then {Ereignis für Programmierer}
    try
      InBeforeInsert := true;
      FBeforeInsert(EditSource.DataSet, Done);
    finally
      //InBeforeInsert := false;  04.06.02 unten
    end;
    InBeforeInsert := true;   //Flag für InEdit
    if not Done then
    try
      if IsLookUpDef and (TLookUpDef(DataSource).LookUpSource <> nil) then
        TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgDisable);

      if (DataSource is TLookUpDef) and                   {Master sichern}
         (TLookUpDef(DataSource).MDTyp = mdDetail) and    {siehe auch LNav.DoPageChange}
         (ALNav <> nil) and
         (ALNav.nlState = nlInsert) and
         (ALNav.PrimaryKeyList.Count > 0) then
      begin
        ALNav.DetailInsert(diPrepare);              {Post + Filter auf PKey}
      end;
      if (DataSource is TLookUpDef) and
         not TLookUpDef(DataSource).DeleteDetails and          {vergl. DoDelete}
         FErfassSingle then                             {Erfassen in Fremdmaske}
      begin
          TLookUpDef(EditSource).LookUp(lumDetailTab); {Maske mit Detail-Filter}
      end else
      begin                    {LNav oder DeleteDetails oder kein ErfassSingle:}
        if not (EditSource.DataSet.State in [dsInsert,dsEdit]) then {hier noch Normalfall}
        begin
          Prefix := 'Insert';
          if AForm <> nil then
            AForm.BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF, ldCloseAuto);
          EditSource.DataSet.Open;                          {240798   qugl.bver}
          if DataSource is TLookUpDef then
          begin  //PseudoInsertGuiActions verhindern - 27.11.09
            DisableFlag := true;
            EditSource.DataSet.DisableControls;
          end;
          if AppendFlag then
            EditSource.DataSet.Append else
            EditSource.DataSet.Insert;
          if not (DataSource is TLookUpDef) then
          try                                                             {LNav}
            if FErfassSingle and GNavigator.X.IsNavLink(self) then  //nicht in FltrDlg
              GNavigator.BtnSingleClick(self);    {080500 dgCancelOnExit=false!}
          except on E:Exception do
            EProt(ALNav, E, '%s.Single', [Prefix]);       {stille Behandlung}
          end;
          (* entfernt 04.06.02 VOKL Flag muß auch in Rech/Erfass gültig sein.
          InDoInsert := false;         {Flag}
          ALNav.NavLink.InDoInsert := OldInDoInsert;         {Flag}
          dafür:*)
          InBeforeInsert := false;
        end;
        if (FltrList <> nil) then
        try
          Prefix := 'CopyFltrValues';
          if SysParam.ProtBeforeOpen then Prot0('%s(%s)',[Prefix, Owner.Name]);
          if not (DataSource is TLookUpDef) then  {für LNav.SetReturn  260798}
          begin                                       {Duplizieren: LNav.SOList}
            //von LuInsert+DeleteDetails=false: Null-Fltr mit Wert belegen:
            if (ALNav <> nil) and
               ALNav.ReturnAktiv and (ALNav.ReturnLuDef <> nil) and
               not TLookUpDef(ALNav.ReturnLuDef).DeleteDetails and
               not DuplicateFlag then  //qupp 12.09.04
            try
              SOList.Assign(TLookUpDef(ALNav.ReturnLuDef).DataPos);
              {for I := 0 to FltrList.Count - 1 do
                if FltrList.Value(I) = '=' then
                  AssignField(FltrList.Param(I),}
            except on E:Exception do
              EProt(Owner, E, '%s:Null-Filter-Vorbelegung', [Prefix]);
            end;
          end;
          if not (DataSource is TLookUpDef) or DuplicateFlag then
          begin                                    //LuDef auch duplizierbar - 30.05.07 QSBT CKW 
            SOList.PutFieldValues(EditSource.DataSet, DataSource); {siehe Duplicate}
          end;
          FltrList.CopyFltrValues(EditSource.DataSet);
          References.CopyFltrValues(EditSource.DataSet);  //Eqal-Filtern mit und ohne :Feldnamen
          if (DataSource is TLookUpDef) and
             (TLookUpDef(DataSource).MasterSource <> nil) then
          begin
            Prefix := 'PutFieldValues';                           {LuDef:SOList}
            if AForm <> nil then
              AForm.UpdateEdit;
            TLookUpDef(DataSource).SOList.PutFieldValues(EditSource.DataSet,
              TLookUpDef(DataSource).MasterSource);
            AField := EditSource.DataSet.FindField(
              TLookUpDef(DataSource).PrimaryKeyFields);
          end else
          begin
            if ALNav <> nil then
              AField := EditSource.DataSet.FindField(ALNav.PrimaryKeyFields);
          end;
          if AField <> nil then
          begin
            //AField.Clear;
            SetFieldValueRO(AField, '');
          end;
        except on E:Exception do
          EMess(Owner, E, 'DoInsert.%s',[Prefix]);
        end;
        Prefix := 'OnErfass';
        if SysParam.ProtBeforeOpen then
          Prot0('%s(%s)',[Prefix, Owner.Name]);
        if not (DataSource is TLookUpDef) and (ALNav <> nil) then
        try
          {if FErfassSingle then
            GNavigator.BtnSingleClick(self);                  {120400 erst hier}
          if ALNav.FirstControl <> nil then
          begin
            //ALNav.FirstControl.SetFocus;               {vergl. Lnav.StateChange}
            //Form.ActiveControl := ALNav.FirstControl;    //klappt beides nicht QUPE.ARBP
            ForceFocus(ALNav.FirstControl);  //ändert State?
          end;
        except on E:Exception do
          if Sysparam.ProtBeforeOpen then
            EProt(ALNav, E, '%s.SetFocus', [Prefix]);          {stille Behandlung}
        end;

        try
          if assigned(FOnErfass) then     {in diesem Block gesonderte Exception Behandlung}
            FOnErfass(EditSource.DataSet);       {Somit kann Erfassen abgebrochenn werden}
          DoRech(EditSource.DataSet, nil, false, rsDoInsert);
          CacheCalcFields(EditSource.DataSet, 3);             //neu 23.08.05 ELP
        except on E:Exception do
          begin
	          // 'Erfassen abgebrochen'
            EMess(ALNav, E, SNLnk_Kmp_018, [0]); {wirkt nicht bei EAbort}
            Modified := false;                     {keine Nachfrage in DoCancel}
            ChangedFields.Clear; {03.06.02}
            DoCancel;
            EditSource.DataSet.EnableControls;
            SysUtils.Abort;                                            {Beenden}
          end;
        end;

        if (DataSource is TLookUpDef) then
        try
          Prefix := 'LookUp';
          DataPos.GetNNValues(DataSet);      {alle nicht-leeren Felder in DataPos bereitstellen}
          if (TLookUpDef(DataSource).LookUpSource <> nil) then
          begin                                 {290798 erst hier !}
            TLookUpDef(TLookUpDef(DataSource).LookUpSource).LookUp(lumDetailTab);
            DataSet.Cancel;     {erst hier!}    {wir übernehmen in Fremdmaske}
          end else
          if FErfassSingle then
          begin
            DataSet.Cancel;                      {wir erfassen in Fremdmaske}
            TLookUpDef(EditSource).LookUp(lumErfassMsk);     {auf dem Detail}
          end;
        except on E:Exception do
          EMess(Owner, E, 'DoInsert.%s',[Prefix]);
        end;
      end;
    finally
      if DisableFlag then
        EditSource.DataSet.EnableControls;

      if IsLookUpDef and (TLookUpDef(DataSource).LookUpSource <> nil) and
         (AForm <> nil) then
        AForm.BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgEnable);
    end;
    EditSource.DataSet.EnableControls;
    {if GNavigator.LNavigator = TqForm(Form).LNavigator then}
    if GNavigator.X.IsNavLink(self) then
      GNavigator.X.DataSource := EditSource;
    Modified := false;
    ChangedFields.Clear; {03.06.02}
  finally
    DuplicateFlag := false;
    if ALNav <> nil then
      ALNav.NavLink.InDoInsert := OldInDoInsert;
    InDoInsert := false;
    InBeforeInsert := false;
  end;
end; { DoInsert }

procedure TNavLink.DoPost(CheckRights: boolean = false);
var
  Done: boolean;
  OldCommit, OldInDoPost: boolean;
begin
  OldInDoPost := InDoPost;
  OldCommit := false;
  if CheckRights and (qnbPost in DisabledButtons) then
  begin  //28.07.13 Quvae.SAUF
    if EditSource.State in dsEditModes then
      ErrWarn(SQNav_Kmp_030, [Kennung]);	// 'Speichern hier nicht erlaubt'
    Exit;
  end;
  try
    InDoPost := true;                           {siehe MuGri.State Change 20.02.02}
    GNavigator.Canceled := false;               {240399}
    //beware!
    //if (EditSource.State in dsEditModes) then   // 21.04.10 TMultiGrid.LoopDoIt / dpe.vorf.ProcessInstPauBer()
    begin
      EditSource.Enabled := true;                 {140501 - ruft State Change auf!}
      EditSource.DataSet.EnableControls;   {für ds.state. Muß sein QWF.Auft.QueSingleAfterPost}
    end;
  finally
    InDoPost := OldInDoPost;
  end;
  if (EditSource.State in dsEditModes) then    {weg 140100 and not InDoPost then}
  begin
    InDoPost := true;
    try
      if EditSource <> DataSource then
      begin
        OldCommit := TLookUpDef(EditSource).AutoCommit;
        TLookUpDef(EditSource).AutoCommit := true;
      end else
      begin                            {EditSource = DataSource}
        OldCommit := AutoCommit;
        AutoCommit := true;
      end;
      Done := false;
      ClearEmptyFields(EditSource.DataSet);     {ruft OnRech. vor FBeforePost !}
      if not InDoPost then                      {von NewDataChange   140201}
        Done := true;
      if assigned(FBeforePost) and not InBeforePost and not Done then
      try
        InBeforePost := true;
        FBeforePost(EditSource.DataSet, Done);
      finally
        InBeforePost := false;
      end;

      if not Done and (EditSource.State in dsEditModes) then  //neu 25.08.05
      begin
        GNavigator.DoBeforePost(EditSource.DataSet);   {kann DetailInsert aufrufen 20.02.02}
        {CheckRequired(EditSource.DataSet);           D2 Exception bei Notnull Fehler}
        //FocusRequired(Form, EditSource.DataSet);    // umgezogen nach Ex
        if EditSource.DataSet.State in dsEditModes then    {20.02.02 QuPE}
        try
          InDoPostEx := true;
          DoPostEx(0);
          Modified := false;
        finally
          InDoPostEx := false;
          try EditSource.DataSet.EnableControls;
          except on E:Exception do
            begin
              EProt(self, E, 'DoPost:EnableControls', [0]);
              if EditSource.DataSet.State <> dsBrowse then
                raise;
            end;
          end;
          TmpDataPos.Free;
          TmpDataPos := nil;
        end;
      end;
      {if GNavigator.LNavigator = TqForm(Form).LNavigator then}
      if GNavigator.X.IsNavLink(self) then
        GNavigator.X.DataSource := DataSource;
    finally
      if EditSource <> DataSource then
        TLookUpDef(EditSource).AutoCommit := OldCommit else
        AutoCommit := OldCommit;
      InDoPost := false;
      {InsertFlag := false;                 {12.02.02 ISA#ZFrm}
    end;
  end;
end;

procedure TNavLink.DoPostEx(Level: integer);
var
  ABookMark : TBookMark;
  I: integer;
  ADataAction: TDataAction;
  IsInsert: boolean;
begin
  try
    IsInsert := EditSource.DataSet.State = dsInsert;
    FocusRequired(Form, EditSource.DataSet);  {in D5 müssen wir selbst focusieren}
    EditSource.DataSet.Post;
    if Level > 0 then
    begin
      SMess0;  //geschafft
      Prot0('%s:DoPostEx(%d):OK', [OwnerDotName(EditSource), Level]);
    end;
    if IsInsert then
    begin
      if not HasRecordCount then
        FRecordCount := FRecordCount + 1;
      if Form <> nil then
        TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgSetRecCount);
    end;
  except
    on E:EDatabaseError do
    begin
      ProtL('%s:DoPostEx(%d):%s', [OwnerDotName(EditSource), Level, E.Message]);
      ADataAction := daFail;
      if assigned(FOnPostError) then
        FOnPostError(EditSource.DataSet, E, ADataAction);  //Achtung: darf IsFatalError ignorieren
      case ADataAction of
      daAbort: SysUtils.Abort;                          {Stille Exception 280400 raise;}
      daRetry: DoPostEx(0);
      else  {daFail, Default}
        if EIsDeadlockFehler(E) and (Level < 3) then
        begin
          Sleep(1500 + Random(1000));
          DoPostEx(Level + 1);  //Retry
        end else
        if (E is EDAError) and
           (Level < 3) and
           // (EDBEngineError(E).Errors[0].ErrorCode <> DBIERR_KEYVIOL) and  {nicht: Indexfehler 2601H}
           // (EDBEngineError(E).Errors[0].ErrorCode <> DBIERR_REQDERR) and  {nicht: Field Required 2604H}
           // (EDBEngineError(E).Errors[0].ErrorCode <> DBIERR_FORIEGNKEYERR) and  {nicht: Foreign Key 2605H}
           not EDAError(E).IsFatalError and
           not EDAError(E).IsKeyViolation and
           not dsQuery and not dsChangeAll and (EditSource.State = dsEdit) then
        try
          if TmpDataPos = nil then
          begin
            TmpDataPos := TDataPos.Create;
            TmpDataPos.GetValues(EditSource.DataSet);
          end;
          EditSource.DataSet.DisableControls;        {wg. Sperre anderer Benutzer}
          { TODO -oMD : wo ist EnableControls? }
          {if EditSource = DataSource then
          begin
            DataSet.Close;
            References.Values
          end else}
          begin
            EditSource.DataSet.Cancel;
            ABookMark := EditSource.DataSet.GetBookMark;
            EditSource.DataSet.First;
            EditSource.DataSet.Next;
            EditSource.DataSet.GotoBookMark(ABookMark);
            EditSource.DataSet.FreeBookMark(ABookMark);
          end;
          EditSource.DataSet.Edit;
          TmpDataPos.PutValues(EditSource.DataSet);
          DoPostEx(Level + 1);
        finally
          begin end;
        end else
        begin
          //if E.Errors[0].ErrorCode = DBIERR_REQDERR then       {not null Fehler}
          if EIsNotnullFehler(E) then
          begin
            for I := 0 to EditSource.DataSet.FieldCount - 1 do
              if EditSource.DataSet.Fields[I].IsNull then
                ProtA('%d:%s is null',
                [I, EditSource.DataSet.Fields[I].FieldName]);
          end;
          raise;  //Standardaktion bei daFail
        end;
      end; {daFail}
    end;
    on E:Exception do
    begin  //andere Exception
      if EditSource.DataSet.State = dsBrowse then   {von AutoOpen.Close}
      begin
        {EProt(EditSource.DataSet, E, 'DoPostEx(%d)', [Level]);  ist ja OK}
        if (EditSource.DataSet is TuQuery) and (TuQuery(EditSource.DataSet).CachedUpdates) then
        begin
          //ApplyUpdate bereits erfolgt
          EProt(EditSource.DataSet, E, 'DoPostEx(%d)', [Level]);
          raise;
        end else
          NewAfterPost(EditSource.DataSet);
      end else
      begin
        EProt(EditSource.DataSet, E, 'DoPostEx(%d)', [Level]);
        raise;
      end;
    end;
  end;
end;

procedure TNavLink.DoCancel;
var
  Done: boolean;
  Btn: Word;
  OldInBeforeCancel: boolean;
  S1: string;
  I1: integer;
begin
  if not InDoCancel and (EditSource <> nil) and (EditSource.DataSet <> nil) then
  begin
    if EditSource.DataSet.State = dsInsert then
      InInsertCancel := true else
    if EditSource.DataSet.State = dsEdit then
      InEditCancel := true;
    try
      Done := false;
      if assigned(FBeforeCancel) and not InBeforeCancel then
      try
        InBeforeCancel := true;
        FBeforeCancel(EditSource.DataSet, Done);
      finally
        InBeforeCancel := false;
      end;
      InDoCancel := true;                       {erst hier 261198 roe}
      if not Done then
      begin
        if Owner is TLNavigator then
          (Form as TqForm).BroadcastMessage(EditSource, TLookUpDef,
          BC_LOOKUPDEF, ldCancel);                  {alle LuDefs Canceln 200400}
        OldInBeforeCancel := InBeforeCancel;
        InBeforeCancel := false;                {für BeforeClose Abort}
        if nlState in nlEditStates then
        try
          (Form as TqForm).UpdateEdit;       {Änderungen in letztem Eingabefeld}
          if Modified and ConfirmCancel then {not (Form as TqForm).InCloseQuery then}
          begin
            S1 := '';
            for I1 := 0 to ChangedFields.Count - 1 do
            begin
              if (EditSource.DataSet.FindField(ChangedFields[I1]) <> nil) and
                 not EditSource.DataSet.FieldByName(ChangedFields[I1]).Calculated then
                 AppendTok(S1, ChangedFields[I1], ';');
            end;
            Prot0('ChangedFields: %s', [S1]);  //12.04.10 ersetzt ChangedFields.CommaText]);

            // 'Daten wurden geändert (%s).' +CRLF+ 'Speichern ?',
            Btn := WMessYesNo(SNLnk_Kmp_009 +CRLF+ SNLnk_Kmp_010, [Display]);
            if Btn = mrYes then
            begin
              InDoCancel := false;
              DoPost(true);
            end else
            if Btn = mrNo then
            begin
              InBeforeCancel := true;                {für BeforeClose Abort 060501}
              EditSource.DataSet.Cancel;
              if InsertFlag then
                DoDelete;                             {301098}
            end else
              Sysutils.Abort;                         {InDoCancel := false;}
          end else
          begin
            EditSource.DataSet.Cancel;
          end;
        except
          if nlState = nlBrowse then
          begin
            NewAfterCancel(EditSource.DataSet);     {Autoopen.close}
          end else
            raise;
        end;
        InBeforeCancel := OldInBeforeCancel;
      end;
      Modified := false;
      {if GNavigator.LNavigator = TqForm(Form).LNavigator then}
      if InDoCancel then
        if GNavigator.X.IsNavLink(self) then
          GNavigator.X.DataSource := DataSource;
    finally
      InDoCancel := false;
      InInsertCancel := false;
      InEditCancel := false;
      if EditSource.DataSet.State = dsBrowse then
        EditSource.DataSet.EnableControls;
    end;
  end;
  //warum? stört ReplaceDlg GNavigator.Canceled := true;               {170198}
end;

procedure TNavLink.DoDeleteMarked(MarkAll: boolean);
(* Alle markierten Datensätze löschen. MarkAll=true: Alle löschen *)
var
  I, N: integer;
  Done: boolean;
begin
  Done := false;
  InDoDeleteMarked := true;
  try
    if assigned(FBeforeDeleteMarked) and not InBeforeDeleteMarked then
    try
      InBeforeDeleteMarked := true;
      FBeforeDeleteMarked(EditSource.DataSet, Done);
    finally
      InBeforeDeleteMarked := false;
    end else
    if assigned(FBeforeDelete) then                  {Kennz. für Aufruf hier:  }
    begin                                      {NavLink.InBeforeDelete = false }
      InBeforeDelete := false;
      FBeforeDelete(EditSource.DataSet, Done);
    end;
    if not Done then
    try
      if MarkAll then
      try
        DataSet.DisableControls;
        DataSet.Open;
        DataSet.Last;  //04.07.12 Fetch all (MSSQL)
        DataSet.First;
        GMess0;
        while not DataSet.EOF and not GNavigator.Canceled do
        begin
          DoDelete;
          {DataSet.Next;   macht schon Delete}
        end;
      finally
        DataSet.EnableControls;
      end else
      if FDBGrid <> nil then
      try
        DataSet.DisableControls;
        TDlgAbort.CreateDlg(SNLnk_Kmp_019);	// 'Markierte Datensätze löschen'
        N := FDBGrid.SelectedRows.Count;
        for I := N - 1 downto 0 do
        begin
          TDlgAbort.GMessA(N - I, N);
          if TDlgAbort.Canceled then break;
          DataSet.Bookmark := FDBGrid.SelectedRows[I];
          DoDelete;
        end;
      finally
        TDlgAbort.FreeDlg;
        DataSet.EnableControls;
        {FDBGrid.SelectedRows.Refresh;       {Gelöschte Records demarkieren}
        FDBGrid.SelectedRows.Clear;  {Gelöschte Records demarkieren ab 08.03.02}
        SendMessage(FDBGrid.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
      end;
    except on E:Exception do
      EProt(DataSet, E, 'DoDeleteMarked(%d)', [ord(MarkAll)]);
    end;
  finally
    InDoDeleteMarked := false;
  end;
end;

procedure TNavLink.DoDelete;
{* Datensatz löschen. Die Confirm-Abfrage ist bereits erfolgt *}
var
  Done: boolean;
  DecrCount: boolean;
  OldGotoPos: boolean;
begin
  Done := false;
  OldGotoPos := false;
  DecrCount := false;
  if assigned(FBeforeDelete) and not InBeforeDelete then
  try
    InBeforeDelete := true;                         {kann dodelete aufrufen}
    // wenn NavLink.InBeforeDelete = false dann Start von DoDeleteMarked
    FBeforeDelete(EditSource.DataSet, Done);        { kann abbrechen mit Abort}
  finally
    InBeforeDelete := false;
  end;
  if not Done then
  try
    InDoDelete := true;                                   {170400 ISA.RECH.REPO}
    if DataSource is TLookUpDef then
    begin
      if (TLookUpDef(DataSource).MDTyp = mdMaster) or
         (TLookUpDef(DataSource).LookUpSource <> nil) or
         (TLookUpDef(DataSource).DeleteDetails) then
      begin                                                 {zuordnungstabelle}
        //DataSource.DataSet.Delete;
        DoDeleteEx(DataSource.DataSet, 0);
        DecrCount := true;
      end else
      begin
        DataPos.Clear;
        DataPos.AddFieldsValue(DataSet, IndexFieldNames);
        DataPos.AddStrings(SOList);   {diese Felder auch auf null setzen 160800}
        try
          DataSet.Edit;
          DataPos.PutValuesNull(DataSet);
          Commit;
          Refresh;             {könnte wegfallen wenn In DeleteMarked berücksichtigt}
        except
          on E:Exception do
          begin
            EMess(DataSet, E, SNLnk_Kmp_020+CRLF+	// 'Löschen nicht möglich.'
              SNLnk_Kmp_021, [DataSource.Name]);	// '%s.DeleteDetails muß true sein.'
            DataSet.Cancel;
            SysUtils.Abort;                      {Wichtig auch für DeleteMarked}
          end;
        end;
      end;
    end else
    begin                                                 {DataSource von LNav:}
      if EditSource.DataSet.Active then
        DoDeleteEx(EditSource.DataSet, 0) else
        DoDeleteEx(DataSource.DataSet, 0);

      if EditSource.DataSet.Active and FormGetLNav(Form).ReturnAktiv and
         EditSource.DataSet.BOF and EditSource.DataSet.EOF then
      begin
        FormGetLNav(Form).StartReturn;    {Schließen und Verweise in Master entfernen - 170800}
      end else
      begin
        DecrCount := true;
        if InsertFlag then with FormGetLNav(Form) do      {Filter aufheben 270400}
        try
          OldGotoPos := NoGotoPos;
          NoGotoPos := true;                                 {nicht positionieren}
          DetailInsert(diReset);
        finally
          NoGotoPos := OldGotoPos;
        end;
      end;
    end;
    if DecrCount then
    begin
      if not HasRecordCount then
        FRecordCount := FRecordCount - 1;
      TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgSetRecCount);
    end;
  finally
    InDoDelete := false;
  end;
end;

procedure TNavLink.DoDeleteEx(aDataset: TDataset; Level: integer);
var
  ADataAction: TDataAction;
  Btn: Word;
begin
  if Level > 0 then
    Prot0('%s:DoDeleteEx(%d)', [aDataset.Name, Level]);
  try
    aDataSet.Delete;
  except
    on E:EDAError do
    begin
      Prot0('%s.%s:DoDeleteEx(%d):%s', [aDataset.Owner.ClassName, aDataset.Name, Level, E.Message]);
      ADataAction := daFail;
      if assigned(FOnDeleteError) then
        FOnDeleteError(aDataSet, E, ADataAction);
      if InDoDeleteMarked then
      begin
        case ADataAction of
          daAbort: aDataSet.Next;                          {Stille Exception 280400 raise;}
          daRetry: DoPostEx(Level + 1);
        else  {daFail, Default}
          Btn := MessageDlg('Fehler beim Löschen' + CRLF + E.Message,
            mtError, [mbAbort,mbRetry,mbIgnore], 0);
          if Btn = mrAbort then
            raise;
          if Btn = mrRetry then
            DoPostEx(Level + 1) else
            aDataSet.Next;
        end;
      end else
      begin
        case ADataAction of
          daAbort: SysUtils.Abort;                          {Stille Exception 280400 raise;}
          daRetry: DoPostEx(Level + 1);
        else  {daFail, Default}
          raise;
        end;
      end;
    end;
  end;
end;

function TNavLink.DeleteRecordConfirmed: boolean;
var
  S: string;
begin
  S := SDeleteRecordQuestion;  //Datensatz löschen? \r (Tablename)
  if (DataSource is TLookUpDef) and
     not TLookUpDef(DataSource).DeleteDetails then
    S := SDeleteZuoQuestion;  //Zuordnung entfernen?

  result := DoMsgFmt(mtWMessConfirmation, MSG_CONFIRMDELETE,
    S + CRLF + '(%s)', [Display]) = mrYes;
end;

function TNavLink.DeleteMarkedConfirmed: boolean;
begin
  Result := DoMsgFmt(mtWMessConfirmation, MSG_CONFIRMDELMARKED,
    SQNav_Kmp_019,	// 'Wollen Sie alle markierten Datensätze löschen ?',
    [0]) = mrYes;
end;

function TNavLink.DoMsgFmt(MsgTyp: TMsgTyp; MsgNr: longint; const Fmt: string;
  const Args: array of const): word;
(* Aufruf des Ereignisses OnMsg oder Standardbehandlung  (Def. in prots)
   MsgTyp:                           MsgNr:
   mtWMessConfirmation  :            MSG_VALUENOTFOUND
           ~            :            MSG_CONFIRMDELETE
           ~            :            MSG_CONFIRMDELMARKED
   mtWMessInformation   :            MSG_LOADAGAIN
*)
var
  S: string;
begin
  S := Format(Fmt, Args);
  if SysParam.InReplace and (MsgNr = MSG_VALUENOTFOUND) then
    EError('InReplace:%s', [S]);  //von Replace Dialog
  result := mrNone;
  if assigned(FOnMsg) then
    FOnMsg(self, MsgTyp, MsgNr, S, result);
  if result = mrNone then
  begin
    case MsgTyp of
      mtWMessConfirmation:
        result := MessageFmt('%s', [S], mtConfirmation, mbYesNoCancel, 0);
      mtWMessInformation:
        result := MessageFmt('%s', [S], mtInformation, [mbOK], 0);
    end;
  end;
  Prot0('%s.DoMsgFmt:''%s'':%s', [OwnerDotName(Owner), S, mrToStr(result)]);
end;

function TNavLink.AssignField1(AFieldName1, AFieldName2: string; CheckRights: boolean = false): boolean;
begin
  Result := AssignField(AFieldName1, DataSet.FieldByName(AFieldName2), CheckRights);
end;

function TNavLink.AssignField(AFieldName: string; SrcField: TField;
  CheckRights: boolean = false): boolean;
(* Weist eigenem Feld den Wert eines anderen Felds zu.
   Geht auf Edit wenn notwendig (Werte verschieden). Vergl Prots.AssignFieldComp
   ergibt true wenn Feld tatsächlicht geändert wurde *)
var                                                     {250400 ISA.RECH}
  DstField: TField;
  OldEditSingle: boolean;
//  OldCheckAutoOpen: boolean;
begin
  result := false;
  OldEditSingle := false;
//  OldCheckAutoOpen := false;
  DstField := DataSet.FieldByName(AFieldName);
//  S1 := GetFieldValue(SrcField);
//  S2 := GetFieldValue(DstField);
  if CompFieldValue(DstField, GetFieldValue(SrcField)) <> 0 then
  try
    //TLNavigator(LNav).InCheckAutoOpen := true;  //beware  //26.03.08 ents
    result := true;
    OldEditSingle := EditSingle;
    EditSingle := false;
    if not (EditSource.DataSet.State in [dsInsert,dsEdit,dsCalcFields]) and
       not DstField.Calculated then
    begin
      //Warnung: if SrcField.Dataset.DataSource = self.DataSource then knallts!
      EditSource.DataSet.Open;
      DoEdit(CheckRights);  //ohne Rechteverwaltung
    end;
    AssignFieldRO(DstField, SrcField);              {RO: 250400 ISA.RECH}
  finally
    EditSingle := OldEditSingle;
    //TLNavigator(LNav).InCheckAutoOpen := OldCheckAutoOpen; beware 06.05.08 vokl}
  end;
end;

function TNavLink.EnterValue(AFieldName, AValue: string;
  CheckRights: boolean = false): boolean;
// Setzt Feldwert so als ob er eingetippt wurde. Mit HangingReturn, AfterReturn.
begin
  Result := AssignValueEx(AFieldName, AValue, false, CheckRights, true);
end;

function TNavLink.AssignValue(AFieldName, AValue: string;
  CheckRights: boolean = false): boolean;
begin
  Result := AssignValueEx(AFieldName, AValue, false, CheckRights, false);
end;

function TNavLink.AssignValueIfNull(AFieldName, AValue: string;
  CheckRights: boolean = false): boolean;
begin
  Result := AssignValueEx(AFieldName, AValue, true, CheckRights, false);
end;

function TNavLink.AssignValueEx(AFieldName, AValue: string; IfNull: boolean;
  CheckRights: boolean = false; PrepareEnter: boolean = false): boolean;
// Weist eigenem Feld einen Wert zu.
// Geht auf Edit wenn notwendig (Werte verschieden). Vergl Prots.AssignFieldComp
// ergibt true wenn Feld tatsächlicht geändert wurde    270400 ISA.RECH
// Enter: aktiviert LuEdit so als ob Bediener eingeben würde.
var
  DstField: TField;
  OldEditSingle: boolean;
//  OldCheckAutoOpen: boolean;
  AForm: TqForm;
begin
  result := false;
//  OldCheckAutoOpen := false;
  OldEditSingle := false;
  DstField := DataSet.FieldByName(AFieldName);
  if IfNull and not DstField.IsNull then
    Exit;  //nur Nullwerte überschreiben
  if IsBlobField(DstField) then
  begin
    // kein CRLF am Ende 170699 - vergl. Prots.GetFieldValue
    AValue := RemoveTrailCrlf(AValue);
  end;
  if CompFieldValue(DstField, AValue) <> 0 then
  try
    {warum das? 06.05.08
    if LNav <> nil then
    begin
      OldCheckAutoOpen := TLNavigator(LNav).InCheckAutoOpen;
      TLNavigator(LNav).InCheckAutoOpen := true;  //kein PutFields
    end; }
    result := true;
    OldEditSingle := EditSingle;
    EditSingle := false;
    if not (EditSource.DataSet.State in [dsInsert,dsEdit,dsCalcFields]) then
    begin
      EditSource.DataSet.Open;
      DoEdit(CheckRights);  //ohne Rechteverwaltung
    end;
    if EditSource.DataSet.State in [dsInsert,dsEdit,dsCalcFields] then  //nur wenn Edit geklappt
    try
      if PrepareEnter then
      begin
        AForm := TqForm(Form);
        if AForm <> nil then
          AForm.BroadcastMessage(EditSource, TLookUpEdit, BC_PREPAREENTER,
                                 DstField.Index);     //siehe newdatachange
      end;
      SetFieldValueRO(DstField, AValue);
    except on E:Exception do
      if not (E is EAbort) then
        EError('AssignValue(%s,%s):%s', [AFieldName, AValue, E.Message]);
    end;
  finally
    EditSingle := OldEditSingle;
    {if LNav <> nil then
      TLNavigator(LNav).InCheckAutoOpen := OldCheckAutoOpen;  weg 06.05.08 vokl }
  end;
end;

function TNavLink.AssignDateTime(AFieldName: string; AValue: TDateTime;
  CheckRights: boolean = false): boolean;
// Weist eigenem Feld einen DateTime Wert zu.
var
  DstField: TField;
begin
  DstField := DataSet.FieldByName(AFieldName);
  Result := DstField.IsNull or (DstField.AsDateTime <> AValue);
  if Result then
    AssignValue(AFieldName, DateTimeToStr(AValue), CheckRights);
end;

function TNavLink.AssignTimeStr(AFieldName: string; AValue: TDateTime;
  CheckRights: boolean = false): boolean;
// Weist eigenem Feld einen Time Wert als String zu.
var
  DstField: TField;
  N: integer;
begin
  DstField := DataSet.FieldByName(AFieldName);
  if DstField.Size >= 5*3 then  //UniDAC Bug bei Unicode *3
    N := DstField.Size div 3 else
  if DstField.Size >= 5*4 then  //UniDAC Bug bei Unicode *4
    N := DstField.Size div 4 else
    N := DstField.Size;
    Result := DstField.AsString <> Copy(TimeToStr(AValue), 1, N);
  if Result then
    AssignValue(AFieldName, Copy(TimeToStr(AValue), 1, N), CheckRights);
end;

function TNavLink.AssignFloat(AFieldName: string; AValue: double;
  CheckRights: boolean = false): boolean;
// Weist eigenem Feld einen Double  Wert zu.
var
  DstField: TField;
begin
  DstField := DataSet.FieldByName(AFieldName);
  Result := DstField.IsNull or (DstField.AsFloat <> AValue);
  if Result then
    AssignValue(AFieldName, FloatToStr(AValue), CheckRights);
end;

function TNavLink.AssignInteger(AFieldName: string; AValue: integer;
  CheckRights: boolean = false): boolean;
// Weist eigenem Feld einen Integer Wert zu.
var
  DstField: TField;
begin
  DstField := DataSet.FieldByName(AFieldName);
  Result := DstField.IsNull or (DstField.AsInteger <> AValue);
  if Result then
    AssignValue(AFieldName, IntToStr(AValue), CheckRights);
end;

function TNavLink.AssignMemoLine(AFieldName: string; ALine: integer; AValue: string;
  CheckRights: boolean = false): boolean;
// Weist eigenem mehrzeiligem Feld (Blob, String) einen Text in einer Zeile zu.
var
  DstField: TField;
  L: TStringList;
begin
  Result := false;
  DstField := DataSet.FieldByName(AFieldName);
  L := TStringList.Create;
  try
    if IsBlobField(DstField) then
      L.Assign(DstField) else
      SetStringsText(L, DstField.Text);

    if (Trim(AValue) <> '') and            //Leerzeilen mit CRLF realisieren!
       (L.IndexOf(AValue) < 0) then  //nur wenn diese Zeile noch nicht existiert
    begin
      if L.Count <= ALine then
        L.Add(AValue) else
        L.Insert(ALine, AValue);
      Result := AssignValue(AFieldName, L.Text, CheckRights);  //mit RemoveTrailCrlf
    end;
  finally
    L.Free;
  end;
end;

function TNavLink.AssignMemoValue(AFieldName: string; AParam, AValue: string;
  CheckRights: boolean = false): boolean;
// Weist eigenem mehrzeiligem Feld (Blob, String) einem Parameter einen Wert zu.
//  in der Form <Param>=<Value>
var
  DstField: TField;
  L: TStringList;
begin
  Result := false;
  DstField := DataSet.FieldByName(AFieldName);
  L := TStringList.Create;
  try
    if IsBlobField(DstField) then
      L.Assign(DstField) else
      SetStringsText(L, DstField.Text);

    if L.Values[AParam] <> AValue then  //nur wenn dieser Parameter differiert
    begin
      L.Values[AParam] := AValue;
      Result := AssignValue(AFieldName, L.Text, CheckRights);  //mit RemoveTrailCrlf
    end;
  finally
    L.Free;
  end;
end;

procedure TNavLink.AssignAswName(AFieldName, AAswName: string);
// Weist zur Laufzeit eigenem Feld eine Auswahl zu.
// Für Änderung der Auswahl zur Laufzeit (qupe.prob.CQ)
var
  AField: TField;
  I: integer;
  AAsw, OldAsw: TAsw;
  OldAswName: string;
begin
  AField := DataSet.FieldByName(AFieldName);
  AAsw := Asws.FindAsw(AAswName);   {nil bei Fehler}
  if AAsw = nil then
    EError('ASW %s not exists', [AAswName]);
  if AField.Tag <> AAsw.Tag then
  begin
    OldAsw := Asws.Asw(AField.Tag);
    AField.Tag := AAsw.Tag;
    //an Steuerelemente weitergeben:
    for I := 0 to Form.ComponentCount - 1 do
    begin
      if IsPublishedProp(Form.Components[I], 'AswName') then
      begin
        OldAswName := GetPropValue(Form.Components[I], 'AswName');
        if OldAswName = OldAsw.AswName then
          SetPropValue(Form.Components[I], 'AswName', AAswName);
      end;
    end;
  end;
end;

procedure TNavLink.Insert;
{* Internes Erfassen. Beachtet nicht ErfassSingle o.ä. Ohne DetailIsert. Keine Vorbelegung.
 * Stellt Insert-Modus sicher auch bei MuGrid.muAutoExpand=false
 * Ruft BeforeInsert und OnErfass-Ereignis auf
 * Für LNav.Take - 07.04.04 *}
var
  ALNav: TLNavigator;
  AForm: TqForm;
  OldInDoInsert: boolean;
  OldGotoPos: boolean;
  Done: boolean;
begin
  GNavigator.Canceled := false;               {240399}
  ALNav := nil;
  OldInDoInsert := false;
  AForm := Form as TqForm;
  if AForm <> nil then
  begin
    ALNav := AForm.LNavigator;
    OldInDoInsert := ALNav.NavLink.InDoInsert;
    ALNav.NavLink.InDoInsert := true;
  end;
  InDoInsert := true;
  OldGotoPos := false;
  if InsertFlag then                                 {Filter aufheben 18.02.02}
  try
    OldGotoPos := NoGotoPos;
    {NoGotoPos := true;    !beware ISA#Posi#Dupl          {nicht positionieren}
    if ALNav <> nil then
      ALNav.DetailInsert(diReset);
  finally
    NoGotoPos := OldGotoPos;
    InsertFlag := false;
  end;
  try
    Done := false;
    if assigned(FBeforeInsert) and not InBeforeInsert then {Ereignis für Programmierer}
    try
      InBeforeInsert := true;
      FBeforeInsert(EditSource.DataSet, Done);
    finally
      //InBeforeInsert := false;  04.06.02 unten
    end;
    InBeforeInsert := true;
    if not Done then
    begin
      if AForm <> nil then
        AForm.BroadcastMessage(EditSource, TLookUpDef, BC_LOOKUPDEF, ldCloseAuto);
      EditSource.DataSet.Open;                          {240798   qugl.bver}
      if AppendFlag then
        EditSource.DataSet.Append else
        EditSource.DataSet.Insert;
    end;
    try
      if assigned(FOnErfass) then     {in diesem Block gesonderte Exception Behandlung}
        FOnErfass(EditSource.DataSet);       {Somit kann Erfassen abgebrochenn werden}
      DoRech(EditSource.DataSet, nil, false, rsDoInsert);
    except on E:Exception do
      begin
        // 'Erfassen abgebrochen'
        EMess(ALNav, E, SNLnk_Kmp_018, [0]); {wirkt nicht bei EAbort}
        Modified := false;                     {keine Nachfrage in DoCancel}
        DoCancel;
        EditSource.DataSet.EnableControls;
        SysUtils.Abort;                                            {Beenden}
      end;
    end;
    Modified := false;
    ChangedFields.Clear; {03.06.02}
  finally
    InBeforeInsert := false;
    DuplicateFlag := false;
    InDoInsert := false;
    if ALNav <> nil then
      ALNav.NavLink.InDoInsert := OldInDoInsert;
  end;
end;

procedure TNavLink.Duplicate;
var
  L: TStringList;
  I: integer;
begin
  if NlState = nlBrowse then
  begin
    L := TStringList.Create;
    try
      L.Assign(SOList);
      SOList.GetValues(DataSet);
      for I := 0 to GNavigator.SysFields.Count-1 do
        SOList.Values[GNavigator.SysFields[I]] := '';  {Systemfelder nicht duplizieren}
      DuplicateFlag := true;                        {wird in DoInsert zurückgesetzt}
      DoInsert(true);
    finally
      SOList.Assign(L);      {SOList restaurieren}
      L.Free;
    end;
  end;
end;

 procedure TNavLink.Commit;
(* ersetzt Post. Speichert auch wenn Autocommit aus ist. *)
var
  OldAutoCommit: boolean;
  IsInsert: boolean;
begin
  if not (csDesigning in Owner.Componentstate) and not dsQuery and not dsChangeAll and
     (DataSet <> nil) and (DataSet.State in dsEditModes) then
  begin
    IsInsert := DataSet.State = dsInsert;         {vergl. DoPostEx}
    OldAutoCommit := FAutoCommit;
    FAutoCommit := true;
    try
      ClearEmptyFields(DataSet);
      try
        DataSet.Post;
        if IsInsert then
        begin
          if not HasRecordCount then
            FRecordCount := FRecordCount + 1;
          if Form <> nil then
            TqForm(Form).BroadcastMessage(DataSource, TMultiGrid, BC_MULTIGRID, mgSetRecCount);
        end;
      except on E:Exception do
        {if not EIsTabellenEnde(E) then}
          raise;
      end;
    finally
      FAutoCommit := OldAutoCommit;
    end;
  end;
end;

procedure TNavLink.SafeRefresh;
begin
  if nlState = nlInactive then
    DataSet.Open else
  if nlState in [nlBrowse] then
    Refresh else
  if nlState in nlEditStates then
    SafeRefreshFlag := true;  //später (Post, Chancel)
end;

procedure TNavLink.SafeReload;
begin
  if nlState = nlInactive then
    DataSet.Open else
  if nlState in [nlBrowse] then
    ReLoad else
  if nlState in nlEditStates then
    SafeReloadFlag := true;  //später (Post, Chancel)
end;

procedure TNavLink.Refresh;
(* Tabelle aktualisieren in abh. von DataSet Typ *)
var
  ErrLine: string[6];
  DB: TuDatabase;
begin
  if nlState <> nlQuery then
  begin
    InRefresh := true;
    DataSet.DisableControls;                          {011199 SDO}
    try
      try
        {if (Query <> nil) and not Query.Local then
        begin}
          ErrLine := 'Close';
          DataSet.Close;
          if (DataSet is TuQuery) and (TuQuery(DataSet).DataBase <> nil) then
          try
            { Fehlerquelle: andere Transaction wird hier zwangsweise commited
              TuQuery(DataSet).DataBase.Commit; - UniDAC: }
            DB := TuQuery(DataSet).DataBase;
            if DB.InTransaction then
              DB.Commit;
          except end;                      {kann vorkommen wenn keine aktive Trans}
          ErrLine := 'Open';
          DataSet.Open;
        {end else
        begin
          if DataSet.Active then
            DataSet.Refresh else
            DataSet.Open;
        end;}
      except on E:Exception do
        if not DataSet.Active then
        begin
          EProt(Owner, E, 'Refresh.%s(%s):', [ErrLine, Display]);
          GNavigator.ProcessMessages;
          DataSet.Open;
        end;
      end;
    finally
      InRefresh := false;
      try
        DataSet.EnableControls;
        StateChange(DataSet);  //neu 14.07.09 wg Mu.BCStateChange()#aFrMusi.btnEdit.Enabled
      except on E:Exception do
        EProt(DataSet, E, 'Refesh', [0]);
      end;
    end;
  end;
end;

function TNavLink.ReLoad(ToDataPos: TStrings = nil): boolean;
{ Tabelle neu öffnen und dann positionieren
  Verwendet PrimaryKeyFields zum Positionieren
  Ergibt true bei Erfolg
  13.07.10 Parameter ToDataPos: DataPos vorgeben statt von PrimaryKeys zu laden
}
var
  ADataPos: TDataPos;
begin
  if PrimaryKeyFields = '' then
    // 'Positionierung nicht möglich da Primary Key fehlt'
    EError(SNLnk_Kmp_022,[0]);
  ADataPos := TDatapos.Create;
  if (DBGrid <> nil) and (DBGrid is TMultiGrid) then
  begin
    TMultiGrid(DBGrid).BeforeReload;
  end;
  DataSet.DisableControls;                          {24.05.04 QPILOT}
  try
    if ToDataPos = nil then
    begin
      ADataPos.AddFieldsValue(DataSet, PrimaryKeyFields);
    end else
      ADataPos.Assign(ToDataPos);
    Refresh;                  {021199 SDO}
//     DataSet.Close;
//     {ResetFields;            falls Datensatz dauerhaft in BDE gesperrt
//     BuildSql;
//     AddCalcFields;}
//     DataSet.Open;
    result := ADataPos.GotoPosEx(DataSet, [dpoNoProcessMessages]);
    if result and (DBGrid <> nil) and (DBGrid is TMultiGrid) then
    begin
      TMultiGrid(DBGrid).AfterReload;
      result := ADataPos.GotoPosEx(DataSet, [dpoNoProcessMessages, dpoPrior]);
    end;
    if not result then
    try                                       {kein EError 220400 ISA.RECH.REPO}
      Prot0(SNLnk_Kmp_023+CRLF+'%s',	// '%s.%s.ReLoad:Positionierung fehlgeschlagen:'
        [Form.ClassName, Display, GetStringsText(ADataPos)]);
    except on E:Exception do
      EProt(self, E, 'ReLoad', [0]);
    end;
  finally
    ADatapos.Free;
    DataSet.EnableControls;                          {24.05.04 QPILOT}
    StateChange(DataSet);  //neu 14.07.09
  end;
end;

procedure TNavLink.FetchAll;
//Alle Datensätze spontan laden (ohne FetchAll=true setzen)
//für SQL Server damit Cursor-Lock aufgehoben wird
//das kann UniDAC leider nicht. BDE konnte es: procedure TBDEDataSet.FetchAll;
var
  ABookMark: TBookMark;
begin
  DataSet.DisableControls;                          {24.05.04 QPILOT}
  ABookMark := DataSet.GetBookMark;
  try
    DataSet.Last;
    DataSet.GotoBookMark(ABookMark);
  finally
    DataSet.FreeBookMark(ABookMark);
    DataSet.EnableControls;                          {24.05.04 QPILOT}
  end;
end;


procedure TNavLink.ResetFields;
(* Fielddefs und Fields löschen. Erzwingt neues einlesen der Felddefinitionen
   nur bei TuQuery *)
var
  I: integer;
begin
  if Query <> nil then
  try
    Query.Fielddefs.Clear;
    for I:= Query.FieldCount-1 downto 0 do
    begin
      Query.Fields[I].Free;
    end;
    try
      if (Form <> nil) and (FormGetLNav(Form) <> nil) then
        FormGetLNav(Form).StaticFields := false;
      {StaticFields := false;}
    except
    end;
  except on E:Exception do
    Prot0('ResetField:%s',[E.Message]);
  end;
end;

procedure TNavLink.AddCalcFields;
(* Verarbeitung von CalcList, Formatlist und ColumnList *)
var
  I, P1, P, DispWidth: integer;
  TypeName, SizeStr, ErrMsg: string;
  AFieldName, ColName, DispFormat, ADisplay, ADisplayOptions: string;
  AField: TField;
  IsActive, NoFields: boolean;
  AAsw: TAsw;
  LuName, LuFieldName, NextS: string;
  ALuDef: TLookupDef;
  ACalcCache: TCalcCache;
  AMinValue, AMaxValue: longint;
  LookupType: boolean;
begin
  ErrMsg := '';
  IsActive := false;
  if not InAddCalcFields and
     (DataSet <> nil) and
     (((Query <> nil) and (Query.Sql.Count > 0)) or
      (Table <> nil) or
      (Dataset is TIBQuery) or
      ((Dataset is TuMemTable) and (DataSet.FieldDefs.Count > 0))) then
  try
    InAddCalcFields := true;
    IsActive := DataSet.Active;
    NoFields := false;
    DataSet.Active := false;  {AddFields muß bei InActive gemacht werden}
    try
      ErrMsg := 'FieldDefs.Update';
      if (DataSet.FieldDefs.Count = 0) and (DataSet.FieldCount = 0) and
         not StaticFields then
      try                                                   {Fielddefs einlesen}
        //Screen.Cursor := crHourGlass;
        FldDsc.Update(DataSet, TableName, SqlFieldList);
        //Screen.Cursor := crDefault;
      except on E:Exception do begin
          EProt(DataSet, E, SNLnk_Kmp_024, [Display, '']);	// '%s:A UpdateFieldDefs nicht möglich (%s)'
          DataSet.Open;
          DataSet.Close;
        end;
      end;
      if DataSet.FieldCount = 0 then               {TFields sind nach close weg}
      begin
        NoFields := true;
        ErrMsg := 'CreateField';
        with DataSet.FieldDefs do
        begin
          for I := 0 to Count - 1 do
          begin
            AFieldName := Items[I].Name;
            AField := Items[I].CreateField(DataSet);
            AField.Name := Format('%s%s', [DataSet.Name, StrToValidIdent(AFieldName)]);
            AField.OnValidate := DoValidate;
          end;
        end;
      end else
      begin
        for I := 0 to DataSet.FieldCount - 1 do
          with DataSet.Fields[I] do
            OnValidate := DoValidate;               {Ereignis Validate zuordnen}
      end;
      with CalcList do                        {Liste der CalcFields durchgehen:}
      begin
        ErrMsg := 'CalcList';
        CalcCacheList.ClearObjects;               {Caches der Feldwerte löschen}
        if (Count = 0) and assigned(FOnGet) then
        begin                                 //damit OnGet bzw CalcFields immer zieht - 25.10.03
          Values['_cfOnGet'] := 'string:1';
        end;
        for I := 0 to Count - 1 do
        try
          ErrMsg := Format('CalcList(%s)',[Strings[I]]);
          AFieldName := Trim(Param(I));                     {FIELDNAME=TYP:SIZE}
          if Char1(AFieldName) = ';' then continue;                  {Kommentar}
          DispFormat := Value(I);
          P1 := Pos(':', DispFormat);
          if P1 = 0 then
            raise Exception.Create(SNLnk_Kmp_025);	// 'Formatfehler'
          TypeName := copy(DispFormat, 1, P1-1);
          LookupType := CompareText(TypeName, 'LookUp') = 0;           {Lookup:}
          ALuDef := nil;
          if LookupType or (CompareText(TypeName, 'Format') = 0) then  {Format:}
          begin                                 {FIELDNAME=LookUp:LuDef;LuField}
            LuName := Trim(PStrTok(copy(DispFormat, P1+1, length(DispFormat)),
              ';', NextS));
            LuFieldName := Trim(PStrTok('', ';', NextS));
            ErrMsg := Format('CalcList(%s).Lookup(%s,%s)',[Strings[I], LuName, LuFieldName]);
            if Form <> nil then
              ALuDef := TLookUpDef(Form.FindComponent(LuName));
            if ALuDef = nil then
              Prot0(SNLnk_Kmp_026, [ // LuName]);	// 'CalcCache:LookUpDef(%s) fehlt'
                OwnerDotName(DataSet) + ', ' + LuName + ',', LuFieldName]);
            ACalcCache := TCalcCache.Create(self, AFieldName,
              ALuDef, LuFieldName);

            TypeName := IntToStr(Ord(ACalcCache.LuDataType));
            SizeStr := IntToStr(ACalcCache.LuSize);
            ColName := AFieldName;           {erst hier!}
            ErrMsg := Format('CalcList(%s).LuCreate(%s,%s,%s)',
              [Strings[I], TypeName, SizeStr, ColName]);
            AField := CreateCalcField(DataSet, AFieldName, ColName,
                        GetFieldType(TypeName), StrToInt(SizeStr));
            if LookupType then
              CalcCacheList.AddObject(AFieldName, ACalcCache) else
              ACalcCache.Free;
          end else
          begin
            SizeStr := copy(DispFormat, P1+1, MaxInt);
            ColName := AFieldName;           {erst hier!}
            ErrMsg := Format('CalcList(%s).Create(%s,%s)',[Strings[I], SizeStr, ColName]);
            AField := CreateCalcField(DataSet, AFieldName, ColName,
                        GetFieldType(TypeName), StrToInt(SizeStr));
          end;
          AField.OnValidate := DoValidate;
        except on E:Exception do begin
            if Form <> nil then
              EProt(Owner, E, '%s.%s:%s', [Form.ClassName, Display, ErrMsg])
            else
              EProt(Owner, E, 'nil.%s:%s', [Display, ErrMsg]);
            if csDesigning in Owner.ComponentState then raise;
          end;
        end;
        CalcOK := true;           {damit calc während Active = IsActive}
      end;
      with FormatList do
      begin
        ErrMsg := 'FormatList';
        for I := 0 to Count - 1 do
        try
          AFieldName := Param(I);        {FIELDNAME=DisplayFormat}
          if CharInSet(Char1(AFieldName), [';',#0]) then continue;    {Kommentar}
          DispFormat := Value(I);        {N,R,[Asw,Aswname|#0.00|>aaa]}
          AField := DataSet.FindField(AFieldName);     {FieldByName von 010900}
          if AField = nil then
          begin
            if PosI('IGN,', DispFormat) <= 0 then  {Fehlenden Feldnamen ignorieren}
              // '%s.%s.FormatList(%s):Feld fehlt',
              if Form <> nil then
                Prot0(SNLnk_Kmp_027, [Form.ClassName, Owner.Name, FormatList[I]]) else
                Prot0(SNLnk_Kmp_027, ['nil', Owner.Name, FormatList[I]]);
          end else
          while Trim(DispFormat) <> '' do
          begin  //Reihenfolge jetzt unwichtig. 'else' ergänzt - 14.11.06
            DispFormat := Trim(DispFormat);
            if CompareText(Copy(DispFormat, 1, 4), 'IGN,') = 0 then
            begin  {Fehlenden Feldnamen ignorieren s.o.}
              DispFormat := Copy(DispFormat, 5, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'A,' then
            begin
              AField.AutoGenerateValue := arDefault; //Das Feld verfügt über einen vom Server verwalteten Vorgabewert.
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'N,' then
            begin
              AField.Required := true;
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'R,' then
            begin
              AField.ReadOnly := true;
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'C,' then
            begin
              AField.FieldKind := fkInternalCalc;  // Das Feld wird in der Datenbank berechnet und darf nicht zurückgeschrieben werden
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'r,' then
            begin
              AField.Alignment := taRightJustify;
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if Copy(DispFormat, 1, 2) = 'c,' then
            begin
              AField.Alignment := taCenter;
              DispFormat := Copy(DispFormat, 3, MaxInt);
            end else
            if CompareText(Copy(DispFormat, 1, 4), 'INT,') = 0 then
            begin  {Werte in Sql als Integer formatieren}
              AField.Tag := -1;
              DispFormat := Copy(DispFormat, 5, MaxInt);
              HangingSql := true;           //sql vor nächstem Öffnen generieren 31.03.03
            end else
            if CompareText(Copy(DispFormat, 1, 4), 'TL0,') = 0 then
            begin  {0en links weg}
              AField.OnGetText := FieldOnGetTextTrimL0;
              DispFormat := Copy(DispFormat, 5, MaxInt);
            end else
            if CompareText(Copy(DispFormat, 1, 4), 'ASW,') = 0 then  //Asw muss als letztes stehen
            begin
              (* bringt nix
              if (MultiGrid <> nil) and (Pos('S', TMultiGrid(MultiGrid).DisplayList.Values[
                AField.FieldName]) > 0) then     {siehe TMultiGrid.DrawDataCell()}
              begin  //Auswahl-Kennzeichen entfernen
                AField.Tag := -1;
                AField.OnGetText := nil;
                AField.OnSetText := nil;
              end else *)
              begin
                DispFormat := Copy(DispFormat, 5, MaxInt);
                AAsw := Asws.FindAsw(DispFormat);   {nil bei Fehler}
                if AAsw <> nil then
                begin
                  AField.Tag := AAsw.Tag; //ist >0
                  AField.Alignment := taLeftJustify;  //10.09.04 sdbl.spra
                  {AField.DisplayWidth := AAsw.MaxWidth;}
                end;
                AField.OnGetText := FieldOnGetText;
                AField.OnSetText := FieldOnSetText;
                if NoFields and (FltrList.Values[AFieldName] <> '') then
                  HangingSql := true;         {01.10.97 ROE Asw-Value in Fltr}
              end;
              DispFormat := '';   //Abbruchkriterium - 14.11.06
            end else
            begin
              {if (SysParam.WE <> 'DM') and (Pos(' DM', DispFormat) > 0) then
                DispFormat := StrCgeStrStr(DispFormat, ' DM',}
              //Währungssymbol (EUR) gemäß SysParam.WE ändern:
              if (SysParam.WE <> 'EUR') and (Pos(' EUR', DispFormat) > 0) then
                DispFormat := StrCgeStrStr(DispFormat, ' EUR', ' '+SysParam.WE, true);
              if AField is TNumericField then
              begin
                {99,990.00 beschreibt MinMax Format (ohne führende Nullen)
                 88,888.88 beschreibt MinMax Format (mit führenden Nullen)
                 00,000.00 beschreibt kein MinMax Format   (0000 ohne Komma wohl)
                 ##### beschreibt kein MinMax Format. #,##.# auch nicht.
                 todo: neg. Werte. Mehrere Grupen mit ';' trennen}
                if (Pos('9', DispFormat) > 0) or (Pos('8', DispFormat) > 0) then
                begin
                  if Pos('9', DispFormat) > 0 then
                    DispFormat := StrCgeChar(DispFormat, '9', '#') else
                    DispFormat := StrCgeChar(DispFormat, '8', '0');
                  TNumericField(AField).DisplayFormat := DispFormat;
                  {MinMax Vorbereitung:}
                  DispFormat := PStrTok(DispFormat, ';', NextS); {nur 1.Term verwenden}
                  P := Pos('.', DispFormat);
                  if P > 0 then                                 {Nachkommas weg}
                    DispFormat := copy(DispFormat, 1, P - 1);
                  DispFormat := StrCgeChar(DispFormat, ',', #0);  {Tau.Tren weg}
                  DispFormat := StrCgeChar(DispFormat, '#', '0');
                end else
                begin
                  TNumericField(AField).DisplayFormat := DispFormat;
                end;
                if EmptyCh(DispFormat, '0')  then            {nur 0en im string}
                begin
                  AMinValue := 0;
                  AMaxValue := IPower(10, length(DispFormat)) - 1;
                  if AField is TIntegerField then
                  begin
                    TIntegerField(AField).MinValue := AMinValue;
                    TIntegerField(AField).MaxValue := AMaxValue;
                  end else
                  if AField is TFloatField then
                  begin
                    TFloatField(AField).MinValue := AMinValue;
                    TFloatField(AField).MaxValue := AMaxValue;
                  end else
                  if AField is TBCDField then
                  begin
                    TBCDField(AField).MinValue := AMinValue;
                    TBCDField(AField).MaxValue := AMaxValue;
                  end;
                end;
              end else
              if AField is TDateTimeField then
                TDateTimeField(AField).DisplayFormat := DispFormat else
              if AField is TStringField then
                TStringField(AField).EditMask := DispFormat;       {060597}
              DispFormat := '';  //Ende Kennzeichen
            end;
          end;  //while
        except on E:Exception do begin
            ErrMsg := Format('Formatlist(%s)',[Strings[I]]);
            if Form <> nil then
              EProt(Owner, E, '%s.%s:%s', [Form.ClassName, Display, ErrMsg]) else
              EProt(Owner, E, 'nil.%s:%s', ['nil', Display, ErrMsg]);
            if csDesigning in Owner.ComponentState then raise;
          end;
        end;
      end;
      { TODO -omd : Temporäre Columnlist mit TLabel.FocusControl bilden }
      {if Owner is TLNavigator then   warum ? HLW.AuswCite.Lov braucht's auch}
      with DataSource.DataSet do with ColumnList do    {Display:Len=Fieldname}
      begin
        ErrMsg := 'ColumnList';
        if Count > 0 then
        begin
          for I := 0 to Count - 1 do
          try
            ADisplay := Param(I);
            if Char1(AFieldName) = ';' then continue;    {Kommentar}
            AFieldName := Value(I);
            if AFieldName = '' then
              AFieldName := ADisplay;
            AField := FindField(AFieldName);    {FieldByName(AFieldName); 010900}
            if AField = nil then
            begin
              if not BeginsWith(AFieldName, ';') then
              begin
                // '%s.%s.Columnlist(%s):Feld fehlt',
                if Form <> nil then
                  Prot0(SNLnk_Kmp_028, [Form.ClassName, Display, ColumnList[I]]) else
                  Prot0(SNLnk_Kmp_028, ['nil', Display, ColumnList[I]]);
                Debug('%s', [Param(I)]);
              end;
            end else
            begin
              P := Pos(':', ADisplay);             {Name:20}
              if P > 0 then
              begin
                AField.DisplayLabel := copy( ADisplay, 1, P - 1);
                ADisplayOptions :=
                  PStrTok(copy( ADisplay, P+1, Length(ADisplay) - P), ',', NextS);
                try
                  DispWidth := StrToInt(ADisplayOptions);
                  if DispWidth <> 0 then
                    AField.DisplayWidth := DispWidth;
                except on E:Exception do
                  EMess(self, E, SNLnk_Kmp_029 +	// 'ColumnList:Fehler bei Format(%s). '
                    SNLnk_Kmp_030,[ADisplay]);		// 'Flags mit "," trennen.'
                end;
              end else
                AField.DisplayLabel := ADisplay;
            end;
          except on E:Exception do begin
              smess0;
              ErrMsg := Format('Columnlist(%s)',[Strings[I]]);
              if Form <> nil then
                EProt(Owner, E, '%s.%s:%s', [Form.ClassName, Display, ErrMsg]) else
                EProt(Owner, E, '%s.%s:%s', ['nil', Display, ErrMsg]);
              if csDesigning in Owner.ComponentState then raise;
            end;
          end;
        end;
      end;
    except on E:Exception do
      begin
        if not (csDesigning in Owner.Componentstate) then
        begin
          if Form <> nil then
            EProt(Owner, E, '%s.%s:%s', [Form.ClassName, Display, ErrMsg]) else
            EProt(Owner, E, '%s.%s:%s', ['nil', Display, ErrMsg]);
          {raise;                        {170298  nein: 080101}
        end else
        if not (csLoading in Owner.Componentstate) and
           (GNavigator <> nil) and (GNavigator.DB1 <> nil) then
          MessageFmt('%s:AddCalcFields(%s):%s', [Display, ErrMsg, E.Message],
            mtWarning, [mbOK], 0);
      end;
    end;
//if not (csDesigning in Owner.Componentstate) then
//  MessageFmt('%s:AddCalcFields(%s):%s', [Display, ErrMsg, 'OK'],
//            mtWarning, [mbOK], 0);
  finally
    InAddCalcFields := false;
    DataSet.Active := IsActive;
  end;
end;

procedure TNavLink.CheckTablePrefix;
var
  DoIt: boolean;
  I: integer;
  S, ATblPrefix: string;
  ADatabase: TuDataBase;
begin  // ergänzt intern TableList (und TableName) mit TuDatabase.TblPrefix. In Build Sql
  DoIt := false;
  for I := 0 to FTableList.Count - 1 do
  begin
    S := FTableList[I];
//     verworfen. dbo.hallo -> 'dbo.hallo' failed. Achtung: (") wg. RecorCount vermeiden; nehme (')    
//     if (Char1(S) <> '"') and (Char1(S) <> '''') then
//     begin
//       if S <> StrToValidIdent(S) then
//       begin
//         DoIt := true;
//         S := '''' + S + '''';
//         FTableList[I] := S;
//       end;
//     end;
    if (Pos('.', S) <= 0) and not (csDesigning in Owner.ComponentState) then
    begin
      ATblPrefix := '';
      if (DataSet <> nil) and (DataSet is TuQuery) then
      begin  //bisher nur bei TuDatabase
        ADatabase := QueryDatabase(TuQuery(DataSet));
        if (ADatabase is TuDatabase) then
          ATblPrefix := TuDatabase(ADatabase).TblPrefix;
      end;
      if (ATblPrefix <> '') then
      begin   //MSSQL: 'dbo.'
        // S := SysParam.TblPrefix + S;
        FTableList[I] := ATblPrefix + S;
        DoIt := true;
      end;
    end;
  end;
  if DoIt then
    FTableName := FTableList.AsTokenString(';');
end;

procedure TNavLink.CheckKeyFields(SqlSensitive: boolean);
// Überprüft auf korrekte Keyfelder. Fehlende Feld werden aus KeyFields entfernt.
// Die Exception wird abgefangen und dient zum Debugging.
// Für Aufruf in Build Sql und evtl new before open
var
  S, S1, NextS: string;
  S2: string;
  P1: integer;
begin
  if Dataset.FieldDefs.Count = 0 then
    Exit;  //noch nicht soweit
  S := '';
  S1 := PStrTok(FKeyFields, ';', NextS, true);
  while S1 <> '' do
  begin
    try
      S2 := S1;
      P1 := Pos('.', S2);
      if P1 > 0 then
        S2 := copy(S2, P1 + 1, MaxInt);          //'VORF.ID desc' -> 'ID desc'
      P1 := Pos(' ', S2);
      if P1 > 1 then
        S2 := copy(S2, 1, P1 - 1);           //'ID desc' -> 'ID'
      if Dataset.FieldDefs.IndexOf(S2) < 0 then
        EError('%s WARN Keyfield %s not found (%s)', [OwnerDotName(DataSet), S2, FKeyFields]);
      AppendTok(S, S1, ';');
    except on E:Exception do
      Prot0('%s', [E.Message]);  //nur ein 1Zeiler
    end;
    S1 := PStrTok('', ';', NextS, true);
  end;
  if SqlSensitive then
  begin
    if FKeyFields <> S then
      KeyFields := S;
  end else
    FKeyFields := S;
end;

function TNavLink.BuildSql: boolean;
var
  Done, OK, AddFltr, OldBuildSql: boolean;
  AFltrList: TFltrList;
  NextS: string;
  I: integer;
  PKeys: string;
begin
  result := true;
  if NoBuildSql then
    Exit;
  if nlState in nlEditStates then
  begin                                           {Sql später generieren 200400}
    HangingSql := true;
    Exit;
  end;
  HangingSql := false;
  OldBuildSql := InBuildSql;
  if (Query <> nil) and
     ((Query.FieldDefs.Count > 0) or (Query.FieldCount > 0) or
      not StaticFields) then    {271097 nur FieldCount}
  try
    InBuildSql := true;
    Done := true;
    AFltrList := TFltrList.Create;
    try
      AFltrList.AddStrings(References);
      AddFltr := true;       {UseFltrList: für QNav}
      if IsLookUpDef and not UseFltrList then
        AddFltr := false;  {keine unnötigen Filter}
      if AddFltr then
      begin
        {AFltrList.AddStrings(FltrList);         {es werden keine Zeilen von References überschrieben}
        for I := 0 to FltrList.Count - 1 do      {keine doppelten Zeilen}
          if AFltrList.IndexOf(FltrList[I]) < 0 then
            AFltrList.Add(FltrList[I]);
      end;
      for I := FltrList.Count - 1 downto 0 do     {keine CalcFields}
        if CalcList.Values[FltrList.Param(I)] <> '' then
          FltrList.Delete(I);

      ErrorFieldName := PStrTok(PrimaryKeyFields, ',;', NextS);
      if (OldRequestLive = Query.RequestLive) and {Requestlive wurde nicht von}
         not (csDesigning in Query.ComponentState) then       {außen verändert}
        Query.RequestLive := LoadedRequestLive;
      Query.Close;  {08.07.01}

      CheckTablePrefix;
      CheckKeyFields(false);  //ungültige Felder entfernen

      result := AFltrList.BuildSQL(Query, TableName, KeyFields,
                                      SqlFieldList, ErrorFieldName, SqlHint);
      OldRequestLive := Query.RequestLive;
      if csDesigning in Owner.ComponentState then
      begin
        if IsLookUpDef and (MasterSource <> nil) and
           (MasterSource.DataSet <> nil) and
           (MasterSource.DataSet.FieldDefs.Count = 0) and
           (DsGetNavLink(MasterSource) <> nil) then
          DsGetNavLink(MasterSource).AddCalcFields;
      end;
    except
      on E:Exception do
      begin
        result := false;
        Done := false;
        {MessageFmt('NLnk.BuildSQL:%s',[E.Message], mtWarning, [mbOK], 0);}
        if csDesigning in Owner.ComponentState then
          EMess(Owner, E, 'NLnk.BuildSQL(%s)', [ErrorFieldName])
        else {QSBT.BarcodeOK 05.08.02}
          EError('NLnk.BuildSQL(%s):%s', [ErrorFieldName, E.Message])
      end;
    end;
    AFltrList.Free;
    if not InOnBuildSql then
    try
      InOnBuildSql := true;
      if assigned(FonBuildSql) then
      begin
        OK := result;
        try
          Done := true;                            {280500}
          FOnBuildSql(Query, OK, Done);
          if not Done then
            BuildSql;                              {280500 Rekursion}
        except
          on E:Exception do
            ErrWarn('OnBuildSql(%s):%s',[Owner.Name,E.Message]);
        end;
        result := OK;
      end;
      if Sysparam.Interbase then
      begin
        if FTableList.Count > 0 then
        begin
          PKeys := IndexInfo(QueryDatabase(Query), FTableList.Strings[0], nil, nil);
          if PKeys <> '' then
            Query.KeyFields := PKeys; {UniDAC Property für Update-SQL}
        end;
      end;
    finally
      InOnBuildSql := false;
      //erst hier damit Event Zugriff auf Original-SQL-Zeilen hat
      if length(Query.SQL.Text) > Sysparam.MaxSqlLine then                 //250
        Query.SQL.Text := RestrictSqlLine(Query.SQL.Text, Sysparam.MaxSqlLine);
      Query.SQL.Text := TrimParenthesis(Query.SQL.Text);   //unnötige Klammern weg
    end;
  finally
    InBuildSql := OldBuildSql;
    (* never
    if (Query.ParamCount > 0) and not Query.Active and
       not IsLocalQuery(Query) and not SysParam.InterBase {100298} and
       not SysParam.Odbc {240398} then
    try                                {InterBase:unprepare dauert zu lange}
      SMess('Prepare (%s)',[Display]);
      Query.Prepare;
      SMess('',[0]);
    except
      SMess('*',[0]);
    end;
    *)
  end;
end;

function TNavLink.LongFieldName(AFieldName: string): string;
{durchsucht FieldList. Ergibt TblName.FieldName anhand AFieldName od. nur FieldName}
var
  I: integer;
begin
  result := AFieldName;
  for I := 0 to SqlFieldList.Count - 1 do
    if CompareText(AFieldName, OnlyFieldName(SqlFieldList.Strings[I])) = 0 then
    begin
      result := SqlFieldList.Strings[I];
      break;
    end;
end;

procedure TNavLink.DeleteAll;
{Löscht alles was den Filtern und Referenzes entspricht}
//14.05.12 md  kein SQL direkt wenn Events vorhanden. webab.datafrm.LINV_DELETE_LBEL
var
  Counter, Anz: longint;
  AQuery: TuQuery;
  OldSql: TValueList;
  ErrFieldName: string;
  OldLive: boolean;
  OldActive: boolean;
  AStringList: TFltrList;
begin
  OldActive := DataSet.Active;
  if assigned(FBeforeDelete) or Assigned(OldBeforeDelete) then
  begin
    DoDeleteMarked(true);  //MarkAll
  end else
  try
    DataSet.DisableControls;
    Anz := 0;
    {entfernt 01.02.04 ZAK.voim
    DataSet.Open;
    DataSet.Last;
    Counter := 0;
    try Anz := DataSet.RecordCount;
    except Anz := 0;
    end;}
    if (DataSet is TuQuery) {and not NoSqlDelete} and
       not TuQuery(DataSet).CachedUpdates then    //05.11.09 ents.aysp
    begin
      SMess(SNLnk_Kmp_031, [Display,Anz]);		// 'Lösche (%s):%d'
      AQuery := DataSet as TuQuery;
      OldLive := AQuery.RequestLive;
      OldSql := TValueList.Create;
      AStringList := TFltrList.Create;
      try
        AQuery.Close;
        AQuery.RequestLive := false;
        OldSql.Assign(AQuery.Sql);
        {References.BuildSqlDelete(AQuery, TableName, ErrFieldName);}
        AStringList.AddStrings(References);
        if not IsLookUpDef or UseFltrList then
          AStringList.AddStrings(FltrList);       {220498 quku.prod.fpla#}
        if AStringList.BuildSQLDelete(AQuery, TableName, ErrFieldName) then
        begin
          Prot0('DeleteAll(%s)', [OwnerDotName(Owner)]);  //Form.ClassName, Display]);
          ProtSql(AQuery);
          QueryExecCommitted(AQuery);
        end;
      finally
        AStringList.Free;
        AQuery.RequestLive := OldLive;
        AQuery.Sql.Assign(OldSql);
        OldSql.Free;
      end;
    end else
    begin
      //hierher verschoben. siehe oben.
      DataSet.Open;
      DataSet.Last;
      Counter := 0;
      try Anz := DataSet.RecordCount;
      except Anz := 0;
      end;
      SMess(SNLnk_Kmp_031, [Display,Anz]);		// 'Lösche (%s):%d'
      DataSet.First;
      while not DataSet.Eof do
      begin
        DataSet.Delete;
        Inc(Counter);
        GMessA(Counter, Anz);
      end;
    end;
  finally
    DataSet.Active := OldActive;
    DataSet.EnableControls;
    SMess0;
    GMess0;
  end;
end;

procedure TNavLink.ChangeRecord;
(* DataSet in EditMode
   - const
   - [Feld]: String: SubStr
           Numeri: Rechnen
   - Sequenz: Start, Incr
*)
var
  I, P, N, Step: integer;
  AField, OpnField: TField;
  LuDataSet: TDataSet;
  AFieldName, AValue: string;
  Opn1, Opn2, OpnFieldName: string;
  CopyStart, CopyLen: string;
  Opt, EscCh, Ch: char;


  function IsOpt(ACh: char): boolean;
  begin
    result := CharInSet(ACh, ['+','-','*','/',#0]);
  end;

  procedure ParseOpn(var Opn: string);
  begin
    Step := 0;
    while (P <= N+1) and (Step <> 99) do
    begin
      if P > N then
        Ch := #0 else                 {End of Line Operator}
        Ch := AValue[P];
      case Step of
        0: if Ch = '[' then
           begin
             Step := 10;
             OpnFieldName := '';
           end else
           begin
             Step := 20;
             if Ch <> '=' then          {Formelzeichen wenn am Anfang}
               Opn := Ch;
           end;
        10: if Ch = ']' then
           begin
             if Pos('.',OpnFieldName) > 0 then       {Fremdtabelle}
             begin
               LuDataSet := Form.FindComponent(OnlyTableName(OpnFieldName))
                 as TDataSet;
               OpnField := LuDataSet.FieldByName(OnlyFieldName(OpnFieldName));
             end else
               OpnField := DataSet.FieldByName(OpnFieldName);
             Opn := GetFieldValue(OpnField);
             Step := 11;
           end else
             AddStr(OpnFieldName, Ch);
        11: if Ch = ',' then
            begin
              CopyStart := '';
              Step := 12;
            end else
            if IsOpt(Ch) then
             Step := 99;
        12: if not IsNum(Ch) then
            begin
              if Ch = ',' then
              begin
                CopyLen := '';
                Step := 13;
              end else
              if IsOpt(Ch) then
              begin
                Opn := copy(Opn, StrToInt(CopyStart), length(Opn));
                Step := 99;
              end;
            end else
              AddStr(CopyStart, Ch);
        13: if not IsNum(Ch) then
            begin
              if IsOpt(Ch) then
              begin
                Opn := copy(Opn, StrToInt(CopyStart), StrToInt(CopyLen));
                Step := 99;
              end;
            end else
              AddStr(CopyLen, Ch);

        20: if IsOpt(Ch) then
             Step := 99 else
             AddStr(Opn, Ch);
      end;
      Inc(P);
    end;
    EscCh := ch;                           {Escape Character}
    if Step <> 99 then
      EError(SNLnk_Kmp_032,[Step]);	// 'Syntaxfehler(%d)'
  end;

  function ParseValue: boolean;
  begin
    result := true;
    if Opn1 = '' then
      ParseOpn(Opn1);
    Opt := EscCh;
    if Opt = #0 then
    begin
      result := false;
      exit;
    end;
    ParseOpn(Opn2);
  end;

  procedure ChangeNumeric;
  var
    Dbl1, Dbl2: double;
  begin
    while ParseValue do
    begin
      Dbl1 := StrToFloat(Opn1);
      Dbl2 := StrToFloat(Opn2);
      case Opt of
        '+': Dbl1 := Dbl1 + Dbl2;
        '-': Dbl1 := Dbl1 - Dbl2;
        '*': Dbl1 := Dbl1 * Dbl2;
        '/': Dbl1 := Dbl1 / Dbl2;
      end;
      Opn1 := FloatToStr(Dbl1);
    end;
    if Opn1 <> '' then
    begin
      Dbl1 := StrToFloat(Opn1);
      AField.AsFloat := Dbl1;
    end else
      AField.Clear;
  end;

  procedure ChangeDateTime;
  var
    Dtm1: TDateTime;
    Dtm2: double;
  begin
    while ParseValue do
    begin
      if AField is TDateField then
        Dtm1 := StrToDateY2(Opn1) else
      if AField is TTimeField then
        Dtm1 := StrToTime(Opn1) else
        Dtm1 := StrToDateTimeY2(Opn1);
      Dtm2 := StrToInt(Opn2);
      case Opt of
        '+': Dtm1 := double(Dtm1) + Dtm2;        {Tage addieren}
        '-': Dtm1 := double(Dtm1) - Dtm2;
      end;
      Opn1 := DateToStr(Dtm1);
    end;
    if Opn1 <> '' then
    begin
      if AField is TDateField then
        Dtm1 := StrToDateY2(Opn1) else
      if AField is TTimeField then
        Dtm1 := StrToTime(Opn1) else
        Dtm1 := StrToDateTimeY2(Opn1);
      AField.AsDateTime := Dtm1;
    end else
      AField.Clear;
  end;

  procedure ChangeString;
  var
    Dbl1, Dbl2: double;
  begin
    while ParseValue do
    begin
      Dbl1 := StrToFloatDef(Opn1, 0);
      Dbl2 := StrToFloatDef(Opn2, 0);
      if (Dbl1 > 0) and (Dbl2 > 0) then
      begin
        case Opt of
          '+': Dbl1 := Dbl1 + Dbl2;
          '-': Dbl1 := Dbl1 - Dbl2;
          '*': Dbl1 := Dbl1 * Dbl2;
          '/': Dbl1 := Dbl1 / Dbl2;
        end;
        Opn1 := FloatToStr(Dbl1);
      end else
      begin
        case Opt of
          '+': Opn1 := Opn1 + Opn2;
        end;
      end;
    end;
    SetFieldText(AField, Opn1);
    if Opn1 = '' then
      AField.Clear;
  end;

  procedure ChangeSequence;
  var
    Start, Incr: longint;
    NextS: string;
  begin
    Opn1 := PStrTok(AValue, '#,', NextS);
    Opn2 := PStrTok('', '#,', NextS);
    Start := StrToIntDef(Opn1, 1);
    Incr := StrToIntDef(Opn2, 1);
    AField.AsInteger := Start;
    Inc(Start, Incr);
    ChangeList.Values[AFieldName] := Format('#%d,%d', [Start, Incr]);
  end;

begin       {ChangeRecord}
  for I:= 0 to ChangeList.Count-1 do
  begin
    AFieldName := ChangeList.Param(I);
    AField := DataSet.FieldByName(AFieldName);
    AValue := ChangeList.Value(I);
    N := length(AValue);
    if N = 0 then continue;
    P := 1;
    Opn1 := '';
    if (copy(ChangeList.Value(I), 1, 1) = '#') then
      ChangeSequence else
    if AField is TNumericField then
      ChangeNumeric else
    if AField is TDateTimeField then
      ChangeDateTime else
    if (copy(ChangeList.Value(I), 1, 1) = '=') or
       (copy(ChangeList.Value(I), 1, 1) = '[') then
       ChangeString else                               (* string-Formel *)
      SetFieldText(AField, AValue);                           (* const *)
  end;
end;

procedure TNavLink.ChangeAll;
var
  AChangeDlg: TDlgChange;
  I: longint;
begin
  Prot0('%s.ChangeAll:', [OwnerDotName(Owner)]);
  ProtStrings(ChangeList);
  if Query <> nil then
    ProtSql(Query);
  with DataSet do
  begin
    AChangeDlg := CreateChangeDlg(self, SNLnk_Kmp_033);		// 'Änderungen durchführen'
    try
      try
        DisableControls;
        if (Query <> nil) and Query.DataBase.IsSqlBased and not NoTransaction then
          Query.DataBase.StartTransaction;
        if (FDBGrid <> nil) and (FDBGrid.SelectedRows.Count > 0) then
        begin
          ProtA('%d SelectedRows', [FDBGrid.SelectedRows.Count]);
          for I := 0 to FDBGrid.SelectedRows.Count - 1 do
          begin
            DataSet.Bookmark := FDBGrid.SelectedRows[I];
            Edit;
            ChangeRecord;
            Commit;
            AChangeDlg.Increment;
          end;
        end else
        begin
          First;
          while not DataSet.EOF and not AChangeDlg.Cancel do
          begin
            Edit;
            ChangeRecord;
            Commit;
            Next;
            AChangeDlg.Increment;
          end;
        end;
        if (Query <> nil) and Query.DataBase.IsSqlBased and not NoTransaction then
          Query.DataBase.Commit;
        self.Refresh;               {besser wg blob Fehler bei first}
      except on E:Exception do
        begin
          Cancel;
          if (Query <> nil) and Query.DataBase.IsSqlBased and not NoTransaction then
            Query.DataBase.RollBack;
          NoTransaction := true;
          {raise;}
          //ErrWarn('%s'+CRLF+SNLnk_Kmp_034, [E.Message]);		// '%s'+CRLF+'Daten Ändern'
          EError('%s' + CRLF + SNLnk_Kmp_034, [E.Message]);		//27.01.05 - qnav#ChangeAllAccepted
        end;
      end;
    finally
      AChangeDlg.Release;
      EnableControls;
    end;
  end;
end;

procedure TNavLink.ClearEmptyFields(ADataSet: TDataSet);
// Leerer Text -> IsNull setzen. Für DoPost, Commit
// 12.01.11 nicht in ChangedFields aufnehmen (webab.bvor.bemerkung)
var
  I: integer;
  AStringField: TStringField;
  AFloatField: TFloatField;
  P1, Nk, L: integer;
  D: double;
begin
  try
    (* letztes Eingabefeld speichern *)
    if not ADataSet.ControlsDisabled then            //28.01.05 ChangeAll
    begin
      if Form <> nil then
        (Form as TqForm).UpdateEdit;
    end;
    InClearEmptyFields := true;
    try
      for I:= 0 to ADataSet.FieldCount-1 do
      begin
        if not ADataSet.Fields[I].IsNull then
        begin
          //if ADataSet.Fields[I] is TStringField then
          if not IsBlobField(ADataSet.Fields[I]) then
          begin
            AStringField := TStringField(ADataSet.Fields[I]);
            if (AStringField.AsString = '') and not AStringField.IsNull and    //not...:09.08.02
               not AStringField.ReadOnly then                                  //29.08.06 RO
              AStringField.Clear;
          //end else
          end;
          if (ADataSet.Fields[I] is TFloatField) and SysParam.NkCheck then
          begin
            AFloatField := ADataSet.Fields[I] as TFloatField;
            P1 := Pos('.', AFloatField.DisplayFormat);
            if P1 > 0 then
            begin
              L := P1;
              while (L+1 <= length(AFloatField.DisplayFormat)) and
                    CharInSet(AFloatField.DisplayFormat[L+1], ['0', '#']) do Inc(L);
              Nk := L - P1;
              D := RoundDec(AFloatField.AsFloat, Nk);
              if (AFloatField.AsFloat <> D) and not AFloatField.ReadOnly then  //29.08.06 RO
                AFloatField.AsFloat := D;
              (*D := AFloatField.AsFloat - RoundDec(AFloatField.AsFloat, Nk);
              if Abs(D) > 1E-9 then
                EError('%s: "%s" hat zu viele Nachkommastellen (%s)(%g)',
                  [DisplayLabel, AsString, DisplayFormat, D]);
              *)
            end;
          end;
          {end else
          if ADataSet.Fields[I] is TMemoField then
          begin
            AMemoField := TMemoField(ADataSet.Fields[I]);
            if AMemoField.DataSize = 0 then    geht nicht, da immer 0
              AMemoField.Clear;}
        end;
      end;
      {for I:= 0 to AForm.ComponentCount-1 do
        if AForm.Components[I] is TDBMemo then
          if ((AForm.Components[I] as TDBMemo).Text = '') and
             ((AForm.Components[I] as TDBMemo).Field <> nil) then
            (AForm.Components[I] as TDBMemo).Field.Clear; setzt isnull=false!!!}
    finally
      InClearEmptyFields := false;
    end;
  except on E:Exception do
    if Form <> nil then
      EProt(Form, E, '%s:ClearEmptyFields', [Display]) else
      EProt(Form, E, '%s:ClearEmptyFields', ['nil']);
  end;
end;

procedure TNavLink.SetEnable(Enable: boolean; SetReadOnly: boolean);
(* alle Verbindunge zu LookUpDefs trennen
   SetReadOnly=true: löscht bei Enable=false Readonly in DBEdit's,
                     aber merkt sich Status
                     und restauriert ihn wenn Enable=true
   * QNav: da wir Format MasterSource u. Masterfields ändern
   * DoInsert + Paradox
*)
var
  I, iField:Integer;
  ADataSet: TDataSet;
  AWinControl: TWinControl;
  ADBEdit: TDBEdit;
  ADBMemo: TDBMemo;
  ADBComboBox: TDBComboBox;
  ADBCheckBox: TDBCheckBox;
  ADBRadioGroup: TDBRadioGroup;
  AForm: TForm;
begin
  if Enable = false then
  begin
    DataSourceList.Clear;
    ReadOnlyList.Clear;
    AForm := Form as TForm;
    if Form <> nil then with AForm do         {todo in LNav}
      for I:=0 to ComponentCount - 1 do
        {if Components[I] is TDataSet then
        begin
          ADataSet := Components[I] as TDataSet;
          if ADataSet.Active then
          begin
            ADataSet.Active := false;
            DataSourceList.Add(ADataSet);
          end;
        end else}
        if Components[I] is TLookUpDef then
        begin
          ADataSet := TLookUpDef(Components[I]).DataSet;
          if (ADataSet <> nil) and ADataSet.Active then
          begin
            try
              ADataSet.Active := false;
            except {EAbort in NewBeforeClose} end;
            if (ADataSet is TuQuery) and (TuQuery(ADataSet).ParamCount > 0) then
              for IField:= 0 to TuQuery(ADataSet).ParamCount-1 do
                TuQuery(ADataSet).Params[IField].Clear;
            DataSourceList.Add(ADataSet);
          end;
        end else
        if SetReadOnly and (Components[I] is TDBMemo) then
        begin
          ADBMemo := Components[I] as TDBMemo;
          if (ADBMemo.DataSource = EditSource) and ADBMemo.ReadOnly and
             (ADBMemo.Field <> nil) and not (ADBMemo.Field.Calculated) then
          begin
            ADBMemo.ReadOnly := false;
            ReadOnlyList.Add(ADBMemo);
          end;
        end else
        if SetReadOnly and (Components[I] is TDBEdit) then
        begin
          ADBEdit := Components[I] as TDBEdit;
          if (ADBEdit.DataSource = EditSource) and ADBEdit.ReadOnly and
             (ADBEdit.Field <> nil) and not (ADBEdit.Field.Calculated) then
          begin
            ADBEdit.ReadOnly := false;
            ReadOnlyList.Add(ADBEdit);
          end;
        end else
        if SetReadOnly and (Components[I] is TDBComboBox) then
        begin
          ADBComboBox := Components[I] as TDBComboBox;
          if (ADBComboBox.DataSource = EditSource) and ADBComboBox.ReadOnly and
             (ADBComboBox.Field <> nil) and not (ADBComboBox.Field.Calculated) then
          begin
            ADBComboBox.ReadOnly := false;
            ReadOnlyList.Add(ADBComboBox);
          end;
        end else
        if SetReadOnly and (Components[I] is TDBCheckBox) then
        begin
          ADBCheckBox := Components[I] as TDBCheckBox;
          if (ADBCheckBox.DataSource = EditSource) and ADBCheckBox.ReadOnly and
             (ADBCheckBox.Field <> nil) and not (ADBCheckBox.Field.Calculated) then
          begin
            ADBCheckBox.ReadOnly := false;
            ReadOnlyList.Add(ADBCheckBox);
          end;
        end else
        if SetReadOnly and (Components[I] is TDBRadioGroup) then
        begin
          ADBRadioGroup := Components[I] as TDBRadioGroup;
          if (ADBRadioGroup.DataSource = EditSource) and ADBRadioGroup.ReadOnly and
             (ADBRadioGroup.Field <> nil) and not (ADBRadioGroup.Field.Calculated) then
          begin
            ADBRadioGroup.ReadOnly := false;
            ReadOnlyList.Add(ADBRadioGroup);
          end;
        end else
        begin
        end;
  end else
  //Enable = true:
  begin
    for I:= 0 to DataSourceList.Count-1 do
    begin
      ADataSet := TDataSet(DataSourceList.Items[I]);
      ADataSet.Active := true;
    end;
    DataSourceList.Clear;
    if SetReadOnly then
    begin
      for I:= 0 to ReadOnlyList.Count-1 do
      begin
        AWinControl := TWinControl(ReadOnlyList.Items[I]);
        if AWinControl is TDBEdit then
        begin
          ADBEdit := TDBEdit(AWinControl);
          ADBEdit.ReadOnly := true;
        end else
        if AWinControl is TDBMemo then
        begin
          ADBMemo := TDBMemo(AWinControl);
          ADBMemo.ReadOnly := true;
        end else
        if AWinControl is TDBComboBox then
        begin
          ADBComboBox := TDBComboBox(AWinControl);
          ADBComboBox.ReadOnly := true;
        end else
        if AWinControl is TDBCheckBox then
        begin
          ADBCheckBox := TDBCheckBox(AWinControl);
          ADBCheckBox.ReadOnly := true;
        end else
        if AWinControl is TDBRadioGroup then
        begin
          ADBRadioGroup := TDBRadioGroup(AWinControl);
          ADBRadioGroup.ReadOnly := true;
        end;
      end;
      ReadOnlyList.Clear;
    end;
  end;
end;

procedure TNavLink.SetFieldFlags(AField: TField; Flags: TFieldFlags);
var
  OldReadOnly: boolean;
begin
  OldReadOnly := AField.ReadOnly;
  if ffNotReadOnly in Flags then
    AField.ReadOnly := false;
  if (ffClear in Flags) and not AField.IsNull then
    if OldReadOnly then
    try
      AField.ReadOnly := false;
      AField.Clear;
    finally
      AField.ReadOnly := OldReadOnly;
    end else
      AField.Clear;
  if ffReadOnly in Flags then
    AField.ReadOnly := true;
  if ffRequired in Flags then
    AField.Required := true;
  if ffNotRequired in Flags then
    AField.Required := false;
  if (AField.ReadOnly <> OldReadOnly) and (Form <> nil) then
    (Form as TqForm).CheckReadOnly;         //Farben setzen
end;

procedure TNavLink.SetEditFlags(AEdit: TWinControl; Flags: TFieldFlags);
var
  OldReadOnly: boolean;
begin
  if AEdit is TDBEdit then
    with AEdit as TDBEdit do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if Field <> nil then
        SetFieldFlags(Field, Flags - [ffNotReadOnly,ffReadOnly]);
      if (ReadOnly <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;     //Farben setzen, PostMessage
    end else
  if AEdit is TDBMemo then
    with AEdit as TDBMemo do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if Field <> nil then
        SetFieldFlags(Field, Flags - [ffNotReadOnly,ffReadOnly]);
      if ReadOnly <> OldReadOnly then
        (Form as TqForm).CheckReadOnly;
    end else
  if AEdit is TDBCheckBox then
    with AEdit as TDBCheckBox do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if Field <> nil then
        SetFieldFlags(Field, Flags - [ffNotReadOnly,ffReadOnly]);
      if (ReadOnly <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;
    end else
  if AEdit is TDBComboBox then
    with AEdit as TDBComboBox do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if Field <> nil then
        SetFieldFlags(Field, Flags - [ffNotReadOnly,ffReadOnly]);
      if (ReadOnly <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;
    end else
  if AEdit is TDBRadioGroup then
    with AEdit as TDBRadioGroup do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if Field <> nil then
        SetFieldFlags(Field, Flags - [ffNotReadOnly,ffReadOnly]);
      if (ReadOnly <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;
    end else
  if AEdit is TEdit then
    with AEdit as TEdit do
    begin
      OldReadOnly := ReadOnly;
      if ffNotReadOnly in Flags then
        ReadOnly := false;
      if ffReadOnly in Flags then
        ReadOnly := true;
      if (ReadOnly <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;     //Farben setzen, PostMessage
    end else
  if AEdit is TComboBox then
    with AEdit as TComboBox do
    begin
      OldReadOnly := Enabled;
      if ffNotReadOnly in Flags then
        Enabled := true;
      if ffReadOnly in Flags then
        Enabled := false;
      if (Enabled <> OldReadOnly) and (Form <> nil) then
        (Form as TqForm).CheckReadOnly;
    end else
    begin
    end;
end;

function TNavLink.ToggleFlags(Flags: TFieldFlags; Toggle: boolean): TFieldFlags;
(* ergibt Parameter Flags, die bei Toggle=true invertiert werden *)
var                       {Interface für Toggle????Flags}
  f: TFieldFlag;          {Flags: ff(not)ReadOnly, ffRequired oder ffClear}
begin
  result := [];
  for f := low(TFieldFlag) to high(TFieldFlag) do
    if f in Flags then
      case f of
        ffReadOnly:    if Toggle then include(result, ffReadOnly) else
                                      include(result, ffNotReadOnly);
        ffNotReadOnly: if Toggle then include(result, ffNotReadOnly) else
                                      include(result, ffReadOnly);
        ffRequired:    if Toggle then include(result, ffRequired) else
                                      include(result, ffNotRequired);
        ffNotRequired: if Toggle then include(result, ffNotRequired) else
                                      include(result, ffRequired);
        ffClear:       if Toggle then include(result, ffClear);
      end;
end;

procedure TNavLink.ToggleFieldFlags(AFieldName: string; Flags: TFieldFlags;
  Toggle: boolean);
begin
  SetFieldFlags(Dataset.FieldByName(AFieldName), ToggleFlags(Flags, Toggle));
end;

procedure TNavLink.ToggleFieldFlags(AField: TField; Flags: TFieldFlags;
  Toggle: boolean);
begin
  SetFieldFlags(AField, ToggleFlags(Flags, Toggle));
end;

procedure TNavLink.ToggleEditFlags(AEdit: TWinControl; Flags: TFieldFlags;
  Toggle: boolean);
(*var                       {Interface für SetEditFlags}
  f: TFieldFlag;          {Flags: ffReadOnly, ffRequired oder ffClear}
  ff: TFieldFlags;        {Toggle: wenn false dann werden Not-Flags daraus}
begin
  ff := [];
  for f := low(TFieldFlag) to high(TFieldFlag) do
    if f in Flags then
      case f of
        ffReadOnly, ffNotReadOnly: if Toggle then
                                     include(ff, ffReadOnly) else
                                     include(ff, ffNotReadOnly);
        ffRequired, ffNotRequired: if Toggle then
                                     include(ff, ffRequired) else
                                     include(ff, ffNotRequired);
        ffClear: if Toggle then      include(ff, ffClear);
      end;
*)
begin
  SetEditFlags(AEdit, ToggleFlags(Flags, Toggle));
end;

procedure TNavLink.SetTagFlags(TagMask: longint; Flags: TFieldFlags);
(* ruft SetEditFlags auf für alle Componenten des Formulars deren
   Tag auf mind. 1Bit der TagMask passt (and-Verknüpfung *)
var
  I: integer;
begin
  if Form <> nil then
    for I := 0 to Form.ComponentCount - 1 do
      if Form.Components[I] is TWinControl then
        with Form.Components[I] do
          if (Tag and TagMask) <> 0 then
            SetEditFlags(TWinControl(Form.Components[I]), Flags);
end;

(*** Hilfsfunktionen für Anwendung *******************************************)

procedure TNavLink.IncludeEditFields(ExcludeTag: integer);
(* Baut spezielle SqlFieldList auf: mit Feldern aller DB-Componenten
   die Tag <> ExcludeTag haben *)
var
  I, I1: integer;
  AList: TStringList;
begin
  AList := TStringList.Create;
  if Form <> nil then
  try
    AList.Sorted := true;
    AList.Duplicates := dupIgnore;
    for I := 0 to Form.ComponentCount - 1 do
    begin
      if Form.Components[I] is TDBEdit then
      begin
        with Form.Components[I] as TDBEdit do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) and (DataField <> '') and
               (CalcList.Values[DataField] = '') then
              AList.Add(DataField)
          end else
            DataSource := nil;
      end else
      if Form.Components[I] is TDBComboBox then
      begin
        with Form.Components[I] as TDBComboBox do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) and (DataField <> '') and
               (CalcList.Values[DataField] = '') then
              AList.Add(DataField)
          end else
            DataSource := nil;
      end else
      if Form.Components[I] is TDBCheckBox then
      begin
        with Form.Components[I] as TDBCheckBox do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) and (DataField <> '') and
               (CalcList.Values[DataField] = '') then
              AList.Add(DataField)
          end else
            DataSource := nil;
      end else
      if Form.Components[I] is TDBRadioGroup then
      begin
        with Form.Components[I] as TDBRadioGroup do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) and (DataField <> '') and
               (CalcList.Values[DataField] = '') then
              AList.Add(DataField)
          end else
            DataSource := nil;
      end else
      if Form.Components[I] is TDBMemo then
      begin
        with Form.Components[I] as TDBMemo do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) and (DataField <> '') and
               (CalcList.Values[DataField] = '') then
              AList.Add(DataField)
          end else
            DataSource := nil;
      end;
      if Form.Components[I] is TMultiGrid then
      begin
        with Form.Components[I] as TMultiGrid  do
          if (Tag and ExcludeTag) = 0 then
          begin
            if (DataSource = self.DataSource) then
              for I1 := 0 to ColumnList.Count - 1 do
                if CalcList.Values[ColumnList.Value(I1)] = '' then
                  AList.Add(ColumnList.Value(I1));
          end else
            SpalteFehlt := true;               {Keine Warnung wenn Spalte fehlt}
      end;
    end;
    SqlFieldList.Assign(AList);
  finally
    AList.Free;
  end;
end; (* IncludeEditFields *)

(*** Hilfsfunktionen ohne Klasse *********************************************)

function DsGetNavLink(ADataSource: TDataSource): TNavLink;
begin
  result := nil;
  if ADataSource <> nil then
  begin
    if ADataSource is TLookUpDef then
    begin
      result := (ADataSource as TLookUpDef).NavLink;
    end else
    if FormGetLNav(ADataSource.Owner) <> nil then
    begin
      result := FormGetLNav(ADataSource.Owner).NavLink;
    end;
  end;
end;

procedure TNavLink.SetDisabledButtons(const Value: TQbeButtonSet);
begin
  FDisabledButtons := Value;
  if (Gnavigator <> nil) and (GNavigator.X <> nil) then
    PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(gnEditingChanged), 0);
end;

procedure TNavLink.SetEnabledButtons(const Value: TQbeButtonSet);
begin
  FEnabledButtons := Value;
  if (Gnavigator <> nil) and (GNavigator.X <> nil) then
    PostMessage(GNavigator.X.Handle, BC_GNAVCLICK, WPARAM(gnEditingChanged), 0);
end;

function TNavLink.GetMultiGrid: TDBGrid;
begin
  result := nil;
  if (FDBGrid <> nil) and (FDBGrid is TMultiGrid) then
    result := FDBGrid;
end;

end.
