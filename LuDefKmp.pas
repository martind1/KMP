unit LuDefKmp;
(* LookUps Komponente

   Autor: Martin Dambach
   Letzte Änderung
   02.10.96     Erstellen
   04.11.96     CalcFields
   25.11.96     LuGridEvent
   01.12.96     mit Query
   19.12.96     Init
   23.08.97     GetUser Data
   09.02.00     lumMasterTab
   03.04.00     GetFields
   13.04.00     OnAfterReturn
   18.04.00     Message BC-LOOKUPDEF ersetzt BC-CLOSE und BC-OPEN
   27.04.00     UserData: wenn HasData dann mit allen Keysegmenten
   24.07.01     LoadedAutoEdit: entspr. ObjInspector. Wenn true dann immer autoedit. Sonst: nur wenn Maste in Edit.
   20.03.04     OnDelete Error Ereignis
   29.05.04     luNoForceNull
   04.02.07     PutFields: zusätzlicher optionaler Parameter 'ToSource' (dflt=MasterSource)
   10.01.12     UniDAC: AutoEdit=false vorbelegen
   16.04.13     NoFltrChar (AVV Nr hat '*')
   ----------------------------------------------
   Verwaltet die für Lookup notwendigen Informationen
   Eigene Komponente pro Lookup
*)

interface

uses
  DB,  Uni, DBAccess, MemDS, DBGrids, Classes, WinTypes, Forms,
  Prots, NLnk_Kmp, DPos_Kmp, UQue_Kmp, UTbl_Kmp;


type
  TLookUpDef = class;

  TLookUpModus =               {Modus für Aufblenden einer Fremdmaske:}
               (lumTab,        {LookUpTabelle zum Übernehmen}
                lumAendMsk,    {Ändern auf einer Fremdmaske}
                lumZeigMsk,    {Anzeigen in der Fremdmaske}
                lumSuch,       {Suchen in Fremdmaske}
                lumReturn,     {nicht implementiert}
                lumDetailTab,  {LookUpTabelle zum Übernehmen eines Details}
                lumMasterTab,  {LookUpTabelle wie im Master. Filter=References}
                lumFltrTab,    {LookUpTabelle wie im Master. Filter=FltrList}
                lumDirect,     {nicht implementiert}
                lumErfassMsk); {Erfasst auf einer Fremdmaske}

  TLookUpTyp = (lupFMask,      {Fremdmaske aufblenden}
                lupGrid);      {Standard-Grid statt Fremdmaske aufblenden}

  TLookUpOption =              {Aktion wenn Wert in LookUp nicht gefunden:}
                (luTolerant,   {Daten nicht löschen}
                 luMessage,    {Meldung anzeigen (Wert nicht gefunden. Tabelle ?)}
                 LuTabelle,    {Tabelle automatisch aufblenden (wenn Message nicht gesetzt)}
                 LuPostMessage,{Nachladen über PostMessage}
                 luGridFltr,   {Suchfeld in LuGrid}
                 luUseFltr,    {letzte Abfrage (FltrFrm) bei LookUp verwenden}
                 luNoForceNull,  {kein 'is null'-Filter bei Lookup wenn in FltrList Feldwert=''}
                 nlNoOpenSMess,  {keine SMess bei Open}
                 LuNoOverride,  {Berücksichtigt Le.NoOverride und NoNullValue}
                 LuGridSavePos, {Position und Größe vom Bediener einstellbar}
                 LuGridSearch,  {positioniert per Anfangszeichen}
                 LuFillCache);  {befüllt Cache mit allen Datenzeilen}
  TLookUpOptions = set of TLookUpOption;

  TPutField =                  {Parameter für Putfields und Werte für PutStatus}
            (pfAddValues,      {Feldwerte mit ; getrennt anhängen}
             pfCompValues,     {nur geänderte Feldwerte schreiben (Compare)}
             pfActive,         {Status: PutFields() läuft}
             pfLastField,      {Status: letztes Feld der Liste wird kopiert}
             pfDataChanged);   {Aktion: Bereits über LuEdi.KeyField geladen}
  TPutFields = set of TPutField;

  TLuAfterReturnEvent =  procedure(Sender: TLookUpDef;
                                   LookUpModus: TLookUpModus) of Object;
  TLeOption = (LeNoNullValues,        {keine Null-Werte kopieren}
               LeReadOnly,            {keine Änderung zw. Data und LookupField}
               LeNoOverride,          {Kopieren nur wenn Ziel=Null}
               LeForceEmpty,          {Leere References als Fltr is null verwenden}
               LeNoDblClick,          {kein Lookup bei Doppelklick}
               LeNoFltrChar           {'*' oder '%' bewirken keinen Filter im Lookup}
              );
  TLeOptions = set of TLeOption;

  TLeObject = class(TObject)                {für SOList.Objects}
    Options: TLeOptions;
    constructor Create(AOptions: TLeOptions); virtual;
  end;

  (* LookUp Definition *)
  TLookUpDef = class(TDataSource)
  private
    { Private-Deklarationen }
    FLookUpTyp: TLookUpTyp;     {Mask oder Grid}
    FOptions: TLookUpOptions;
    FLuKurz: string;            {LoopUp-Formular}
    FLuMultiName: string;       {Name der Multi-Seite im Notebook}

    FDeleteDetails: boolean;
    FLinkToGNav: boolean;          {Link to GNavigator}

    FNavLink: TNavLink;                         { enthält FFltrList: TFltrList;
                                                  FKeyList: TValueList;
                                                  FKeyFields: string;   }

    FBeforeLuGrid: TNotifyEvent;
    FAfterLuGrid: TNotifyEvent;
    FGridDrawDataCell: TDrawDataCellEvent;        {LuGrid Event}
    FGridLayoutChanged: TNotifyEvent;             {LuGrid Event}
    FAfterReturn: TLuAfterReturnEvent;

    OldStateChange: TNotifyEvent;
    OldEnabled: boolean;
    FLookUpModus: TLookUpModus;
    FHangingReturn: boolean;

    function GetZuoSource: TDataSource;

    {NavLink}
    function GetNavLink: TNavLink;
    function GetQuery: TuQuery;
    function GetTable: TuTable;
    function GetAutoCommit: boolean;
    procedure SetAutoCommit(Value: boolean);
    function GetConfirmDelete: boolean;
    procedure SetConfirmDelete(Value: boolean);
    function GetAutoOpen: boolean;
    procedure SetAutoOpen(Value: boolean);
    function GetEditSingle: boolean;
    procedure SetEditSingle(Value: boolean);
    function GetErfassSingle: boolean;
    procedure SetErfassSingle(Value: boolean);
    function GetCalcOK: boolean;
    procedure SetCalcOK(Value: boolean);
    function GetKeyIndex: integer;
    procedure SetKeyIndex(Value: integer);
    function GetNlState: TNavLinkState;
    function GetNoOpen: boolean;
    procedure SetNoOpen(Value: boolean);
    function GetNoGotoPos: boolean;
    procedure SetNoGotoPos(Value: boolean);
    function GetMDTyp: TMDTyp;
    procedure SetMDTyp(Value: TMDTyp);
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
    function GetSOList: TFltrList;
    procedure SetSOList(Value: TFltrList);
    function GetTableName: string;
    procedure SetTableName(Value: string);
    function GetTabTitel: string;
    procedure SetTabTitel(Value: string);
    function GetMasterFieldNames: string;
    function GetIndexFieldNames: string;
    function GetMasterSource: TDataSource;
    procedure SetMasterSource(Value: TDataSource);
    function GetLookUpSource: TDataSource;
    procedure SetLookUpSource(Value: TDataSource);
    function GetDisabledButtons: TQbeButtonSet;
    procedure SetDisabledButtons(Value: TQbeButtonSet);
    function GetEnabledButtons: TQbeButtonSet;
    procedure SetEnabledButtons(Value: TQbeButtonSet);

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
    function GetOnDeleteError: TDataSetErrorEvent;
    procedure SetOnDeleteError(const Value: TDataSetErrorEvent);
    procedure SetLookUpModus(const Value: TLookUpModus);
    procedure SetLuEnabled(const Value: boolean);
    function GetLuEnabled: boolean;
    function GetSqlHint: string;
    procedure SetSqlHint(const Value: string);
    procedure SetHangingReturn(const Value: boolean);
    function GetRecordCount: longint;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure StateChange(Sender: TObject);
    procedure BCLookUpDef(var Message: TWMBroadcast); message BC_LOOKUPDEF;
  public
    { Public-Deklarationen }
    InTake: boolean;                     {Flag für Before/AfterInsert-Methoden}
    PutStatus: TPutFields;
    LuGridData: TObject;                  {für LuGrid}
    {LeftTop: TPoint;                     {-> jetzt: LuRect}
    LuRect: TRect;                        {für LuGrid}
    AdjustGridSize: boolean;              {für LuGrid}
    LoadedAutoEdit: boolean;              {für MuGrid}
    DfltLeOptions: TLeOptions;            {für PutSOField, Vorgabe = []}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    procedure DoBeforeLookup;
    procedure DoAfterLookup;
    procedure LookUpGrid;
    procedure LookUp(ALookUpModus: TLookUpModus);
    procedure PutReferenceFields;
    procedure PutValues(DataList: TDataPos; RefList: TValueList; PutOptions: TPutFields);
    procedure PutSOFields;
    procedure PutFields(RefList: TValueList; PutOptions: TPutFields;
      ToSource: TDataSource = nil);
    procedure GetFields(RefList: TValueList);
    procedure DoAfterReturn(LookUpModus: TLookUpModus);

    {NavLink:}
    procedure Commit;                                       {Explizit Speichern}
    function BuildSql: boolean;
    procedure AddCalcFields;
    procedure DeleteAll;
    procedure Refresh;
    function AssignField(AFieldName: string; SrcField: TField; CheckRights: boolean = false): boolean; {mit Comp, DoEdit}
    function AssignValue(AFieldName, AValue: string; CheckRights: boolean = false): boolean;           {mit Comp, DoEdit}
    function AssignValueIfNull(AFieldName, AValue: string): boolean;
    function AssignDateTime(AFieldName: string; AValue: TDateTime): boolean;
    function AssignTimeStr(AFieldName: string; AValue: TDateTime): boolean;
    function AssignFloat(AFieldName: string; AValue: double): boolean;
    function AssignInteger(AFieldName: string; AValue: integer): boolean;
    function AssignMemoLine(AFieldName: string; ALine: integer; AValue: string): boolean;
    function AssignMemoValue(AFieldName, AParam, AValue: string): boolean;
    procedure DoCancel;
    procedure DoDelete;
    procedure DoEdit(CheckRights: boolean = false);
    procedure DoInsert(CheckRights: boolean = false);
    procedure DoPost(CheckRights: boolean = false);

    property NavLink: TNavLink read GetNavLink write FNavLink;
    property Query: TuQuery read GetQuery;
    property Table: TuTable read GetTable;
    property DataPos: TDataPos read GetDataPos write SetDataPos;
    property RecordCount: longint read GetRecordCount;
    property CalcOK: Boolean read GetCalcOK write SetCalcOK;
    property NlState: TNavLinkState read GetNlState;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit;
    property MasterFieldNames: string read GetMasterFieldNames;
    property IndexFieldNames: string read GetIndexFieldNames;
    property ZuoSource: TDataSource read GetZuoSource;
    property KeyIndex: integer read GetKeyIndex write SetKeyIndex;
    property LookUpModus: TLookUpModus read FLookUpModus write SetLookUpModus;
    property LuEnabled: boolean read GetLuEnabled write SetLuEnabled;
    property HangingReturn: boolean read FHangingReturn write SetHangingReturn;
  published
    property AutoEdit default False;  //default Verhalten geändert
    { Published-Deklarationen }
    property LuKurz: string read FLuKurz write FLuKurz;
    property LuMultiName: string read FLuMultiName write FLuMultiName;
    property LookUpTyp: TLookUpTyp read FLookUpTyp write FLookUpTyp;
    property Options: TLookUpOptions read FOptions write FOptions;
    property ColumnList: TValueList read GetColumnList write SetColumnList;
    property DeleteDetails: boolean read FDeleteDetails write FDeleteDetails;
    property LinkToGNav: boolean read FLinkToGNav write FLinkToGNav;

    property BeforeLuGrid: TNotifyEvent read FBeforeLuGrid write FBeforeLuGrid;
    property AfterLuGrid: TNotifyEvent read FAfterLuGrid write FAfterLuGrid;
    {NavLink:}
    property AutoOpen: boolean read GetAutoOpen write SetAutoOpen;
    property ConfirmDelete: Boolean read GetConfirmDelete write SetConfirmDelete;
    property EditSingle: boolean read GetEditSingle write SetEditSingle;
    property ErfassSingle: boolean read GetErfassSingle write SetErfassSingle;
    property NoOpen: boolean read GetNoOpen write SetNoOpen;
    property NoGotoPos: boolean read GetNoGotoPos write SetNoGotoPos;
    property MDTyp: TMDTyp read GetMDTyp write SetMDTyp;
    property CalcList: TValueList read GetCalcList write SetCalcList;
    property FltrList: TFltrList read GetFltrList write SetFltrList;
    property FormatList: TValueList read GetFormatList write SetFormatList;
    property Bemerkung: TStringList read GetBemerkung write SetBemerkung;
    property KeyFields: string read GetKeyFields write SetKeyFields;
    property KeyList: TValueList read GetKeyList write SetKeyList;
    property PrimaryKeyFields: string read GetPrimaryKeyFields write SetPrimaryKeyFields;
    property References: TFltrList read GetReferences write SetReferences;
    property SOList: TFltrList read GetSOList write SetSOList;
    property SqlFieldList: TValueList read GetSqlFieldList write SetSqlFieldList;
    property SqlHint: string read GetSqlHint write SetSqlHint;
    property TableName: string read GetTableName write SetTableName;
    property TabTitel: string read GetTabTitel write SetTabTitel;
    property MasterSource: TDataSource read GetMasterSource write SetMasterSource;
    property LookUpSource: TDataSource read GetLookUpSource write SetLookUpSource;
    property DisabledButtons: TQbeButtonSet read GetDisabledButtons write SetDisabledButtons;
    property EnabledButtons: TQbeButtonSet read GetEnabledButtons write SetEnabledButtons;

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
    property GridDrawDataCell: TDrawDataCellEvent read FGridDrawDataCell write FGridDrawDataCell;
    property GridLayoutChanged: TNotifyEvent read FGridLayoutChanged write FGridLayoutChanged;
    property AfterReturn: TLuAfterReturnEvent read FAfterReturn write FAfterReturn;
  end;

  (* LookUp User Data *)
  TLookUpUserData = class(TObject)
  public
    { Public-Deklarationen }
    HasFltr: boolean;
    HasData: boolean;
    HasKey: boolean;
    FltrList: TFltrList;
    DataPos: TDataPos;
    KeyFields: string;
    constructor Create(ALookUpDef: TLookUpDef); virtual;
    destructor Destroy; override;
  end;

implementation
{$R+}
uses
  Mask, Dialogs, DbCtrls, SysUtils, Controls,
  nstr_Kmp, GNav_Kmp, LNav_Kmp, Qwf_Form, LuEdiKmp, LuGriDlg, Err__Kmp,
  MuGriKmp;

{ TLeObject }

constructor TLeObject.Create(AOptions: TLeOptions);
begin
  Options := AOptions;
end;

(* Nachrichten empfangen *)

procedure TLookUpDef.BCLookUpDef(var Message: TWMBroadcast);  {message BC_LOOKUPDEF}
begin
  case Byte(Message.Data) of
    ldReOpen:  //21.02.12 wenn abhängig und Active und HangingSQL dann neu laden:
      if (Message.Sender = MasterSource) and (DataSet <> nil) and
         (DataSet.State = dsBrowse) and Navlink.HangingSQL then
      begin
        DataSet.Close;
        DataSet.Open;
      end;
    ldSubRefresh:  //10.10.12 QUPE wenn abhängig dann neu laden:
      if (Message.Sender = MasterSource) and (DataSet <> nil) and
         (DataSet.State in [dsBrowse, dsInactive]) then
      begin
        Navlink.Refresh;
      end;
    ldOpen:
      if (Message.Sender = MasterSource) and (DataSet <> nil) then
        DataSet.Open;
    ldOpenAuto:
      if (Message.Sender = MasterSource) and (DataSet <> nil) and AutoOpen then
      try
        DataSet.Open;
      except on E:Exception do
        EProt(DataSet, E, 'Fehler bei ldOpenAuto', [0]);
      end;
    ldCloseAll:
      if (Message.Sender = MasterSource) and (DataSet <> nil) then
        DataSet.Close;
    ldCloseAuto:
      if (Message.Sender = MasterSource) and (DataSet <> nil) and AutoOpen then
        DataSet.Close;
    ldCancel:
      if (DataSet <> nil) and (NavLink.nlState in nlEditStates) then
        NavLink.DoCancel;             {Abort bei Bedienerabbruch}
    ldDisable:
      if (Message.Sender = MasterSource) and (DataSet <> nil) then
      begin
        if SysParam.ProtBeforeOpen then
          Prot0('%s.%s ldDisable', [Owner.Name, Name]);
        DataSet.DisableControls;
        // TqForm(Owner).BroadcastMessage(self, TLookUpDef, BC_LOOKUPDEF, ldDisable); test01.11.03
      end;
    ldEnable:
      if (Message.Sender = MasterSource) and (DataSet <> nil) then
      begin
        if SysParam.ProtBeforeOpen then
          Prot0('%s.%s ldEnable', [Owner.Name, Name]);
        DataSet.EnableControls;
        //TqForm(Owner).BroadcastMessage(self, TLookUpDef, BC_LOOKUPDEF, ldEnable); //test01.11.03
      end;
    ldDeleteDtl:  //26.05.09 entfernen da nicht verwendet
      if (Message.Sender = MasterSource) and (DataSet <> nil) and DeleteDetails then
      begin
        if DataSet.CanModify then    //Abfrage neu 01.11.09
          NavLink.DoDeleteMarked(true) else
          Prot0('ldDeleteDtl: %s ist ReadOnly', [OwnerDotName(DataSet)]);
      end;
    ldFillColumnList:
      NavLink.FillColumnList;
      //Idee: if (Message.Sender = MasterSource) and (DataSet <> nil) and (MDTyp = mdDetail) then
      //    wenn not DeleteDetails dann wird SetNull ausgeführt - 04.11.08
  end;
end;

(**procedure TLookUpDef.BCClose(var Message: TWMBroadcast);
begin
  if Message.Sender = MasterSource then
    if DataSet <> nil then
      if (Message.Data = 0) or AutoOpen then     {<>0 => nur wenn Autoopen}
        DataSet.Close;
end;

procedure TLookUpDef.BCOpen(var Message: TWMBroadcast);
begin
  if Message.Sender = MasterSource then
    if DataSet <> nil then
      DataSet.Open;
end;**)

(* Properties setzen *)

function TLookUpDef.GetNavLink: TNavLink;
begin
  result := FNavLink;
  if not Assigned(FNavLink) then
    EError('%s:NavLink=nil',[Name]);
end;

function TLookUpDef.GetQuery: TuQuery;
begin
  result := NavLink.Query;
end;

function TLookUpDef.GetTable: TuTable;
begin
  result := NavLink.Table;
end;

function TLookUpDef.GetMasterFieldNames: string;
begin
  Result := NavLink.MasterFieldNames;
end;

function TLookUpDef.GetIndexFieldNames: string;
begin
  Result := NavLink.IndexFieldNames;
end;

function TLookUpDef.GetDataPos: TDataPos;
begin
  result := NavLink.DataPos;
end;

procedure TLookUpDef.SetDataPos(Value: TDataPos);
begin
  NavLink.DataPos := Value;
end;

function TLookUpDef.GetMasterSource: TDataSource;
begin
  result := NavLink.MasterSource;
end;

procedure TLookUpDef.SetMasterSource(Value: TDataSource);
begin
  NavLink.MasterSource := Value;
end;

function TLookUpDef.GetLookUpSource: TDataSource;
begin
  result := NavLink.LookUpSource;
end;

procedure TLookUpDef.SetLookUpSource(Value: TDataSource);
begin
  NavLink.LookUpSource := Value;
end;

function TLookUpDef.GetDisabledButtons: TQbeButtonSet;
begin
  result := NavLink.DisabledButtons;
end;

procedure TLookUpDef.SetDisabledButtons(Value: TQbeButtonSet);
begin
  NavLink.DisabledButtons := Value;
end;

function TLookUpDef.GetEnabledButtons: TQbeButtonSet;
begin
  result := NavLink.EnabledButtons;
end;

procedure TLookUpDef.SetEnabledButtons(Value: TQbeButtonSet);
begin
  NavLink.EnabledButtons := Value;
end;

function TLookUpDef.GetCalcList: TValueList;
begin
  result := NavLink.CalcList;
end;

procedure TLookUpDef.SetCalcList(Value: TValueList);
begin
  NavLink.CalcList := Value;
end;

procedure TLookUpDef.SetColumnList(Value: TValueList);
begin
  NavLink.ColumnList:= Value;
end;

function TLookUpDef.GetColumnList: TValueList;
begin
  result := NavLink.ColumnList;
end;

function TLookUpDef.GetZuoSource: TDataSource;
begin
  if (MasterSource <> nil) and
     (MasterSource is TLookUpDef) and
     (TLookUpDef(MasterSource).LookUpSource <> nil) and
     (TLookUpDef(MasterSource).LookUpSource = self) then
    result := MasterSource else
    result := nil;
end;

(* NavLink: *)
function TLookUpDef.GetRecordCount: longint;
begin
  Result := NavLink.RecordCount;
end;

function TLookUpDef.GetReferences: TFltrList;
begin
  result := NavLink.References;
end;

procedure TLookUpDef.SetReferences(Value: TFltrList);
begin
  NavLink.References := Value;
end;

function TLookUpDef.GetSOList: TFltrList;
begin
  result := NavLink.SOList;
end;

procedure TLookUpDef.SetSOList(Value: TFltrList);
begin
  NavLink.SOList := Value;
end;

function TLookUpDef.GetSqlFieldList: TValueList;
begin
  result := NavLink.SqlFieldList;
end;

procedure TLookUpDef.SetSqlFieldList(Value: TValueList);
begin
  NavLink.SqlFieldList := Value;
end;

function TLookUpDef.GetSqlHint: string;
begin
  result := NavLink.SqlHint;
end;

procedure TLookUpDef.SetSqlHint(const Value: string);
begin
  NavLink.SqlHint := Value;
end;

function TLookUpDef.GetNlState: TNavLinkState;
begin
  result := NavLink.NlState;
end;

procedure TLookUpDef.SetFltrList(Value: TFltrList);
begin
  NavLink.FltrList := Value;
end;

function TLookUpDef.GetFltrList: TFltrList;
begin
  result := NavLink.FltrList;
end;

procedure TLookUpDef.SetFormatList(Value: TValueList);
begin
  NavLink.FormatList := Value;
end;

procedure TLookUpDef.SetHangingReturn(const Value: boolean);
begin
  FHangingReturn := Value;
end;

function TLookUpDef.GetFormatList: TValueList;
begin
  result := NavLink.FormatList;
end;

procedure TLookUpDef.SetBemerkung(Value: TStringList);
begin
  NavLink.Bemerkung := Value;
end;

function TLookUpDef.GetBemerkung: TStringList;
begin
  result := NavLink.Bemerkung;
end;

procedure TLookUpDef.SetKeyList(Value: TValueList);
begin
  NavLink.KeyList := Value;
end;

function TLookUpDef.GetKeyList: TValueList;
begin
  result := NavLink.KeyList;
end;

procedure TLookUpDef.SetKeyFields(Value: string);
begin
  NavLink.KeyFields := Value;
end;

function TLookUpDef.GetKeyFields: string;
begin
  result := NavLink.KeyFields;
end;

function TLookUpDef.GetPrimaryKeyFields: string;
begin
  result := NavLink.PrimaryKeyFields;
end;

procedure TLookUpDef.SetPrimaryKeyFields(Value: string);
begin
  NavLink.PrimaryKeyFields := Value;
end;

procedure TLookUpDef.SetTableName(Value: string);
begin
  NavLink.TableName := Value;
end;

function TLookUpDef.GetTableName: string;
begin
  result := NavLink.TableName;
end;

function TLookUpDef.GetTabTitel: string;
begin
  result := NavLink.TabTitel;
end;

procedure TLookUpDef.SetTabTitel(Value: string);
begin
  if NavLink.TabTitel <> Value then
  begin
    NavLink.TabTitel := Value;
    PostMessage(TWinControl(Owner).Handle, BC_LNAVIGATOR, lnavSetTabs, 0);
  end;
end;

function TLookUpDef.GetOnValidate: TFieldNotifyEvent;
begin
  result := NavLink.OnValidate;
end;

procedure TLookUpDef.SetOnValidate(Value: TFieldNotifyEvent);
begin
  NavLink.OnValidate := Value;
end;

function TLookUpDef.GetOnGet: TDataSetNotifyEvent;
begin
  result := NavLink.OnGet;
end;

procedure TLookUpDef.SetOnGet(Value: TDataSetNotifyEvent);
begin
  NavLink.OnGet := Value;
end;

function TLookUpDef.GetOnErfass: TNotifyEvent;
begin
  result := NavLink.OnErfass;
end;

procedure TLookUpDef.SetOnErfass(Value: TNotifyEvent);
begin
  NavLink.OnErfass := Value;
end;

function TLookUpDef.GetOnRech: TRechEvent;
begin
  result := NavLink.OnRech;
end;

procedure TLookUpDef.SetOnRech(Value: TRechEvent);
begin
  NavLink.OnRech := Value;
end;

function TLookUpDef.GetOnBuildSql: TBuildSqlEvent;
begin
  result := NavLink.OnBuildSql;
end;

procedure TLookUpDef.SetOnBuildSql(Value: TBuildSqlEvent);
begin
  NavLink.OnBuildSql := Value;
end;

function TLookUpDef.GetOnMsg: TMsgEvent;
begin
  result := NavLink.OnMsg;
end;

procedure TLookUpDef.SetOnMsg(Value: TMsgEvent);
begin
  NavLink.OnMsg := Value;
end;

function TLookUpDef.GetBeforeQuery: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeQuery;
end;

procedure TLookUpDef.SetBeforeQuery(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeQuery := Value;
end;

function TLookUpDef.GetBeforeDelete: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeDelete;
end;

procedure TLookUpDef.SetBeforeDelete(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeDelete := Value;
end;

function TLookUpDef.GetBeforeDeleteMarked: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeDeleteMarked;
end;

procedure TLookUpDef.SetBeforeDeleteMarked(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeDeleteMarked := Value;
end;

function TLookUpDef.GetBeforeEdit: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeEdit;
end;

procedure TLookUpDef.SetBeforeEdit(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeEdit := Value;
end;

function TLookUpDef.GetBeforeInsert: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeInsert;
end;

procedure TLookUpDef.SetBeforeInsert(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeInsert := Value;
end;

function TLookUpDef.GetBeforePost: TBeforeNotifyEvent;
begin
  result := NavLink.BeforePost;
end;

procedure TLookUpDef.SetBeforePost(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforePost := Value;
end;

function TLookUpDef.GetBeforeCancel: TBeforeNotifyEvent;
begin
  result := NavLink.BeforeCancel;
end;

procedure TLookUpDef.SetBeforeCancel(Value: TBeforeNotifyEvent);
begin
  NavLink.BeforeCancel := Value;
end;

function TLookUpDef.GetOnPostError: TDataSetErrorEvent;
begin
  result := NavLink.OnPostError;
end;

procedure TLookUpDef.SetOnPostError(Value: TDataSetErrorEvent);
begin
  NavLink.OnPostError := Value;
end;

function TLookUpDef.GetOnDeleteError: TDataSetErrorEvent;
begin
  result := NavLink.OnDeleteError;
end;

procedure TLookUpDef.SetOnDeleteError(const Value: TDataSetErrorEvent);
begin
  NavLink.OnDeleteError := Value;
end;

function TLookUpDef.GetCalcOK: boolean;
begin
  result := NavLink.CalcOK;
end;

procedure TLookUpDef.SetCalcOK(Value: boolean);
begin
  NavLink.CalcOK := Value;
end;

function TLookUpDef.GetKeyIndex: integer;
begin
  result := NavLink.KeyIndex;
end;

procedure TLookUpDef.SetKeyIndex(Value: integer);
begin
  NavLink.KeyIndex := Value;
end;

procedure TLookUpDef.SetLookUpModus(const Value: TLookUpModus);
begin
  if FLookUpModus <> Value then
    FLookUpModus := Value;
end;

function TLookUpDef.GetConfirmDelete: boolean;
begin
  result := NavLink.ConfirmDelete;
end;

procedure TLookUpDef.SetConfirmDelete(Value: boolean);
begin
  NavLink.ConfirmDelete := Value;
end;

function TLookUpDef.GetAutoOpen: boolean;
begin
  result := NavLink.AutoOpen;
end;

procedure TLookUpDef.SetAutoOpen(Value: boolean);
begin
  NavLink.AutoOpen := Value;
end;

function TLookUpDef.GetEditSingle: boolean;
begin
  result := NavLink.EditSingle;
end;

procedure TLookUpDef.SetEditSingle(Value: boolean);
begin
  NavLink.EditSingle := Value;
end;

function TLookUpDef.GetErfassSingle: boolean;
begin
  result := NavLink.ErfassSingle;
end;

procedure TLookUpDef.SetErfassSingle(Value: boolean);
begin
  NavLink.ErfassSingle := Value;
end;

function TLookUpDef.GetNoOpen: boolean;
begin
  result := NavLink.NoOpen;
end;

procedure TLookUpDef.SetNoOpen(Value: boolean);
begin
  NavLink.NoOpen:= Value;
end;

function TLookUpDef.GetNoGotoPos: boolean;
begin
  result := NavLink.NoGotoPos;
end;

procedure TLookUpDef.SetNoGotoPos(Value: boolean);
begin
  NavLink.NoGotoPos:= Value;
end;

function TLookUpDef.GetMDTyp: TMDTyp;
begin
  result := NavLink.MDTyp;
end;

procedure TLookUpDef.SetMDTyp(Value: TMDTyp);
begin
  NavLink.MDTyp:= Value;
end;

procedure TLookUpDef.SetAutoCommit(Value: boolean);
begin
  NavLink.AutoCommit := Value;
end;

function TLookUpDef.GetAutoCommit: boolean;
begin
  result := NavLink.AutoCommit;
end;

procedure TLookUpDef.Commit;
(* bei Autocommit kann nur hiermit gespeichert werden. Ersetzt Post. *)
begin
  NavLink.Commit;
end;

procedure TLookUpDef.AddCalcFields;
(* aus CalcList hinzufügen *)
begin
  NavLink.AddCalcFields;
end;

function TLookUpDef.BuildSql: boolean;
begin
  result := NavLink.BuildSql;
end;

procedure TLookUpDef.DeleteAll;
begin
  NavLink.DeleteAll;
end;

procedure TLookUpDef.Refresh;
begin
  NavLink.Refresh;
end;

function TLookUpDef.AssignField(AFieldName: string; SrcField: TField; CheckRights: boolean = false): boolean;
begin
  result := NavLink.AssignField(AFieldName, SrcField, CheckRights);
end;

function TLookUpDef.AssignValue(AFieldName, AValue: string; CheckRights: boolean = false): boolean;
begin
  result := NavLink.AssignValue(AFieldName, AValue, CheckRights);
end;

function TLookUpDef.AssignValueIfNull(AFieldName,
  AValue: string): boolean;
begin
  result := NavLink.AssignValueIfNull(AFieldName, AValue);
end;

function TLookUpDef.AssignDateTime(AFieldName: string;
  AValue: TDateTime): boolean;
begin
  result := NavLink.AssignDateTime(AFieldName, AValue);
end;

function TLookUpDef.AssignTimeStr(AFieldName: string;
  AValue: TDateTime): boolean;
begin
  result := NavLink.AssignTimeStr(AFieldName, AValue);
end;

function TLookUpDef.AssignFloat(AFieldName: string;
  AValue: double): boolean;
begin
  result := NavLink.AssignFloat(AFieldName, AValue);
end;

function TLookUpDef.AssignInteger(AFieldName: string;
  AValue: integer): boolean;
begin
  result := NavLink.AssignInteger(AFieldName, AValue);
end;

function TLookUpDef.AssignMemoLine(AFieldName: string; ALine: integer;
  AValue: string): boolean;
begin
  result := NavLink.AssignMemoLine(AFieldName, ALine, AValue);
end;

function TLookUpDef.AssignMemoValue(AFieldName, AParam,
  AValue: string): boolean;
begin
  result := NavLink.AssignMemoValue(AFieldName, AParam, AValue);
end;

procedure TLookUpDef.DoEdit(CheckRights: boolean = false);
begin
  NavLink.DoEdit(CheckRights);
end;

procedure TLookUpDef.DoInsert(CheckRights: boolean = false);
begin
  NavLink.DoInsert(CheckRights);
end;

procedure TLookUpDef.DoPost(CheckRights: boolean = false);
begin
  NavLink.DoPost(CheckRights);
end;

procedure TLookUpDef.DoCancel;
begin
  NavLink.DoCancel;
end;

procedure TLookUpDef.DoDelete;
begin
  NavLink.DoDelete;
end;

(* Initialisierung *******************************************************)

constructor TLookUpDef.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNavLink := TNavLink.Create(self);
  FNavLink.DataSource := self;
  FNavLink.Autocommit := true;
  LuMultiName := 'Multi';
  LookUpTyp := lupFMask;
  MDTyp := mdMaster;
  ConfirmDelete := true; // false; 20.10.04
  Options := [luMessage, LuTabelle];
  DfltLeOptions := [];
  NoOpen := true;
  AutoOpen := true;
  AutoEdit := false;  //10.01.12
end;

destructor TLookUpDef.Destroy;
begin
  FreeAndNil(FNavLink);
  inherited Destroy;
end;

procedure TLookUpDef.Loaded;
var
  ALNav: TLNavigator;
begin
  inherited Loaded;
  OldEnabled := Enabled;
  if not (csDesigning in ComponentState) then
  begin
    if not assigned(OldStateChange) then
    begin
      OldStateChange := OnStateChange;
      OnStateChange := StateChange;      {Changed auch LNav.DS}
    end;
    if Owner is TqForm then
    begin
      ALNav := TqForm(Owner).LNavigator;
      if ALNav <> nil then
          if ALNav.AutoEditStart then       {30.10.01}
          AutoEdit := true;
      (*  if not ALNav.AutoEditStart then
          AutoEdit := false;*)
    end;
  end;
  // Felder nur in LuDef noinput
  if TabTitel <> '' then
  begin
    if Char1(TabTitel) = ';' then
      NavLink.Display := copy(TabTitel, 2, MaxInt) else
      NavLink.Display := TabTitel;
  end else
  if TableName <> '' then
    NavLink.Display := TableName else
  if DataSet <> nil then
    NavLink.Display := DataSet.Name else
    NavLink.Display := Name;
  Navlink.FillColumnList;  //26.05.09: muss bereits hier sein
  LoadedAutoEdit := AutoEdit;
  NavLink.Loaded;
  { Prepare in BuildSql}
end;

procedure TLookUpDef.Init;
begin
  NavLink.Init;
  if not NoOpen and (DataSet <> nil) then
  try
    (*DataSet.Close;                     151299 warum ?
    DataSet.Open;                                      *)
  except
    on E:Exception do
      ErrWarn('LuDef.Init(%s):%s',[Name,E.Message]);
  end;
end;

procedure TLookUpDef.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
  begin
    if FNavLink <> nil then
      FNavLink.Notification(AComponent,Operation);
  end;
  inherited Notification(AComponent, Operation);
end;

(* Ereignisse ****************************************************************)

procedure TLookUpDef.StateChange(Sender: TObject);
var
  AForm: TqForm;
begin
  AForm := TqForm(Owner);
  case Navlink.nlState of
    nlEdit:
      NavLink.DoRech(DataSet, nil, false, 'StateChange');
    nlInsert:
    begin
    end;
    nlBrowse:
    begin
      AForm.BroadcastMessage(self, TLookUpDef, BC_LOOKUPDEF, ldOpenAuto);  //vergl. DoInsert
    end;
    nlInactive:
    begin
      //AForm.BroadcastMessage(self, TLookUpDef, BC_LOOKUPDEF, ldCloseAuto);  //22.03.02
    end;
  end;
  try
    if assigned(OldStateChange) then
      OldStateChange(Sender);
  except
    on E:Exception do
      ErrWarn('StateChange(%s):%s',[Name,E.Message]);
  end;
  NavLink.StateChange(Sender);
  if OldEnabled <> Enabled then
  begin  //erst nach User-Statechange (qupp.ausp.gebi) 
    OldEnabled := Enabled;
    PostMessage(AForm.Handle, BC_LNAVIGATOR, lnavSetTabs, 0);  //22.10.04
  end;
end;

(****** Zusatzfunktionen ***************************************************)

procedure TLookUpDef.DoBeforeLookup;
begin
  if assigned(FBeforeLuGrid) then
    FBeforeLuGrid(self);              {kann LuRect und AdjustGridSize setzen}
end;

procedure TLookUpDef.DoAfterLookup;
begin
  if assigned(FAfterLuGrid) then
    FAfterLuGrid(self);
end;

procedure TLookUpDef.LookUp(ALookUpModus: TLookUpModus);
(* z.B. für Detail Single Buttons, QWF:KUNR *)
var
  OldLookUpModus: TLookUpModus;
  ALNav: TLNavigator;
begin
  OldLookUpModus := LookUpModus;
  try
    ALNav := TqForm(Owner).LNavigator;
    if ALNav = nil then
      raise Exception.Create('LNavigator fehlt');
    {ALNav.DataSource.Edit;   {nur bei Autoedit und dsBrowse}
    ALNav.StartLookUp(ALookUpModus, self);
  except
    on E:Exception do
      EMess(DataSet, E, 'LookUp(%s/%s)', [Name, ord(ALookUpModus)]);
  end;
  LookUpModus := OldLookUpModus;
end;

procedure TLookUpDef.LookUpGrid;
(* LookUp mit Grid *)
var
  AForm: TqForm;
  ALookUpEdit: TLookUpEdit;
  AControl: TControl;
begin
  if (DlgLuGrid <> nil) and (DlgLuGrid.LuDlg.CallerLuDef = self) then
  begin
    DlgLuGrid.BringToFront;
    DlgLuGrid.SetFocus;
    Exit;
  end;

  AForm := TqForm(Owner);
  AdjustGridSize := false;
  if (AForm = nil) or (AForm.ActiveControl = nil) then
  begin
    AdjustGridSize := true;
  end else
  if AForm.ActiveControl is TLookUpEdit then
  begin                                     {siehe auch TLNavigator.StartLookUp}
    ALookUpEdit := AForm.ActiveControl as TLookUpEdit;
    {LeftTop := ALookUpEdit.ClientToScreen(Point(0, 0));}
    LuRect.TopLeft  := ALookUpEdit.ClientToScreen(Point(0, 0));
    LuRect.BottomRight := Point(ALookUpEdit.Width, ALookUpEdit.Height);
  end else
  if AForm.ActiveControl is TControl then
  begin
    AControl := AForm.ActiveControl as TControl;
    {LeftTop := AControl.ClientToScreen(Point(0, 0));}
    LuRect.TopLeft  := AControl.ClientToScreen(Point(0, 0));
    LuRect.BottomRight := Point(AControl.Width, AControl.Height);
  end else
  begin
    {LeftTop := TControl(Owner).ClientToScreen(Point(0,0));}
    LuRect.TopLeft  := AForm.ClientToScreen(Point(0, 0));
    LuRect.BottomRight := Point(AForm.Width, AForm.Height);
  end;
  AdjustGridSize := false;
  if LuGridData = nil then                         {nur einmal 020300}
  begin
    LuGridData := TLuDlg.Create;
    with LuGridData as TLuDlg do
    try
      DoBeforeLookUp;   {BeforeLuGrid Ereignis: kann LuRect und AdjustGridSize setzen}
      {LeftTop := self.LeftTop;}
      LuRect := self.LuRect;
      AdjustGridSize := self.AdjustGridSize;
      Execute(self);
      DoAfterLookUp;
    finally
      LuGridData := nil;           {free macht er selbst}
    end;
  end;
end;

procedure TLookUpDef.PutReferenceFields;
(* von GNav.Return. Setzt pf-Flags wie Put Fields. Für LuEdit *)
var
  OldPutStatus: TPutFields;
  OldInDataChange: boolean; //10.11.08 webab
begin
  OldPutStatus := PutStatus;
  if not (pfActive in OldPutStatus) then
    KeyIndex := -1;                 {241098}
  try
    PutStatus := [pfActive];
    if LuNoOverride in Options then
    begin  //neues Flag - SQVA.VPOS - ab 20.11.06
      //Berücksichtigt Le.NoOverride und NoNullValue
      PutValues(DataPos, References, []);  //pfCompValues]);
    end else
    begin
      if TokenCount(IndexFieldNames, ';') <= 1 then
      begin
        // bei nur einem Reference-Feld wie bisher verfahren:
        DataPos.PutReferenceFields(DataSet, IndexFieldNames, MasterSource, MasterFieldNames);  //kein Comp!
      end else
      begin
        // Neues Verfahren bei Verknüpfungen über mehrere Felder - webab PZUO - ab 10.11.08
        // 1. Kopieren ohne Ereignis (In Data Change = false)
        // 2. Alle Werte wurden übertragen: Kopieren mit Ereignis TLookUpEdit.BCDataChange
        OldInDataChange := Navlink.InDataChange;  // müsste immer false sein
        try
          Navlink.InDataChange := true;        //TLookUpEdit.BCDataChange für diesen LuDef verhindern
          DataPos.PutReferenceFields(DataSet, IndexFieldNames, MasterSource, MasterFieldNames);  //kein Comp!
        finally
          Navlink.InDataChange := OldInDataChange;
          //nochmal kopieren mit Nachladen der Nicht-Key-Felder
          DataPos.PutReferenceFields(DataSet, IndexFieldNames, MasterSource, MasterFieldNames);  //kein Comp!
        end;
      end;
    end;
  finally
    PutStatus := OldPutStatus;
  end;
end;

procedure TLookUpDef.PutValues(DataList: TDataPos; RefList: TValueList; PutOptions: TPutFields);
(* Kopiert Feldwerte in DataList nach MasterSource-Dataset.
   Zuordnung erfolgt über RefList (=References oder SOList).
   Flags (NoNulls, NoOverride) von SOList.Objects.
   neu für PutReferenceFields *)
var
  I: integer;
  MField, LField: TField;
  LeObject: TLeObject;
  LeOptions: TLeOptions;
  MDataSet: TDataSet;
  OldpmDataChange: boolean;
  SM: string;
  OldPutStatus: TPutFields;
  MFieldName, LFieldName, LFieldValue: string;
  SOIndex, RefIndex: integer;
begin
  //LogD(self, 'PutValues: %s', [DataList.Text]);
  if SysParam.ProtBeforeOpen then
  begin
    Prot0('PutValues(%s)',[OwnerDotName(self)]);
    ProtStrings(DataList);
  end;
  OldPutStatus := PutStatus;
  if not (pfActive in OldPutStatus) then
    KeyIndex := -1;                 {241098}
  PutStatus := PutOptions;
  if (MasterSource = nil) or (MasterSource.DataSet = nil) or (DataSet = nil) or
     (DataList.Count = 0) then
    Exit;
  MDataSet := MasterSource.DataSet;
  Include(PutStatus, pfActive);
  OldpmDataChange := false;  //wg Compilerwarnung
  if LuPostMessage in Options then
  begin
    OldpmDataChange := DsGetNavLink(MasterSource).pmDataChange;
    DsGetNavLink(MasterSource).pmDataChange := true;
  end;
  for I:= 0 to DataList.Count - 1 do
  try
    { falsch
    if I = DataList.Count - 1 then
      Include(PutStatus, pfLastField); }

    LFieldName := DataList.Param(I);
    RefIndex := RefList.ValueIndex(LFieldName, @SM);   //Habe Lookup will Master
    if RefIndex < 0 then
      continue;   //nicht kopieren da kein Reference Field
    if Char1(SM) <> ':' then
      continue;   //nicht kopieren da kein Masterfield
    LField := DataSet.FieldByName(LFieldName);  //muss hier immer gültiges Feld sein
    LFieldName := LField.Fieldname;             //Groß/Kleinschreibung korrigieren

    SOIndex := SOList.ValueIndex(LFieldName, nil);  //suche auf linker Seite
    if SOIndex < 0 then
      LeObject := nil else
      LeObject := TLeObject(SOList.Objects[SOIndex]);
    if LeObject <> nil then
      LeOptions := LeObject.Options else
      LeOptions := DfltLeOptions; //[];

    MFieldName := Trim(copy(SM, 2, 200));
    MField := MDataSet.FindField(MFieldName);
    if MField = nil then
      EError('PutValues:MFeld %s.%s fehlt', [OwnerDotName(MDataSet), MFieldName]);

    LFieldValue := DataList.Value(I);
    if (LeNoNullValues in LeOptions) and (LFieldValue = '') then
      continue;                                      {keine null-Werte kopieren}
    if (LeNoOverride in LeOptions) and not MField.IsNull then
      continue;                                      {keine Werte überschreiben}
    if SysParam.ProtBeforeOpen then
    begin
      Prot0('PutValue(%s.%s) "%.80s"',[MDataset.Name, MField.FieldName, LFieldValue]);
    end;
    if pfAddValues in PutOptions then                   //kommt hier nicht vor
      AddFieldText(MField, LFieldValue) else            {Wert nach ; anhängen}
    if (pfCompValues in PutOptions) then
      SetFieldComp(MField, LFieldValue) else               {mit Compare und RO und Memos}
      SetFieldValueRO(MField, LFieldValue);
  except on E:Exception do
    EMess(self, E, 'PutValue(%s)', [DataList[I]]);
  end;
  if SysParam.ProtBeforeOpen then
    Prot0('EndPutValues(%s)',[OwnerDotName(self)]);
  if LuPostMessage in Options then
  begin
    DsGetNavLink(MasterSource).pmDataChange := OldpmDataChange;
  end;
  PutStatus := OldPutStatus;
end;

procedure TLookUpDef.PutSOFields;
(* Kopiert Feldwerte in DataPos nach MasterSource bzgl. SOList.
   Schreibt nicht wenn Feldwerte identisch.
   für NavLink.NewDataChange *)
begin
  PutFields(SOList, [pfCompValues]);
end;

procedure TLookUpDef.PutFields(RefList: TValueList; PutOptions: TPutFields;
  ToSource: TDataSource = nil);
(* Kopiert Feldwerte von Lookup nach Master Dataset.
   RefList hat den Aufbau: <LookUpFieldName>=:<MasterFieldName> entspr.
   der Eigenschaften 'References' bzw. 'SOList'.
   für GNav.Return, NavLink.DataChange *)
var
  I, IMax: integer;
  MField, LField: TField;
  LeObject: TLeObject;
  LeOptions: TLeOptions;
  MDataSet: TDataSet;
  OldpmDataChange: boolean;
  SM: string;
var
  OldPutStatus: TPutFields;
  function LFieldValue: string;
  begin
    if IsBlobField(MField) or not IsBlobField(LField) then
      result := GetFieldValue(LField) else
      result := RemoveCrlf(GetFieldValue(LField));  {falls von Memo}
  end;
begin
  if SysParam.ProtBeforeOpen then
  begin
    Prot0('PutFields(%s)',[Name]);
    ProtStrings(RefList);
  end;
  OldPutStatus := PutStatus;
  if not (pfActive in OldPutStatus) then
    KeyIndex := -1;                 {241098}
  PutStatus := PutOptions;
  if ToSource = nil then
    ToSource := MasterSource;
  if (ToSource = nil) or (ToSource.DataSet = nil) or (DataSet = nil) or
     (RefList.Count = 0) then
    Exit;
  MDataSet := ToSource.DataSet;
  for IMax := RefList.Count-1 downto 0 do       {letzte echte Referenz}
    if CharInSet(Char1(RefList.Value(IMax)), [':']) then
      break;
  Include(PutStatus, pfActive);
  OldpmDataChange := false;  //wg Compilerwarnung
  if LuPostMessage in Options then
  begin
    OldpmDataChange := DsGetNavLink(ToSource).pmDataChange;
    DsGetNavLink(ToSource).pmDataChange := true;
  end;
  for I:= 0 to RefList.Count-1 do
  try
    if not CharInSet(Char1(RefList.Value(I)), [':']) then
      continue;                               {nur echte Referenzen, keine Fltr}
    if I = IMax then
      Include(PutStatus, pfLastField);
    LeObject := TLeObject(RefList.Objects[I]);
    if LeObject <> nil then
      LeOptions := LeObject.Options else
      LeOptions := DfltLeOptions; //[]; 11.08.02 swe.VoImpFront
    LField := DataSet.FieldByName(RefList.Param(I));
    SM := Trim(copy(RefList.Value(I), 2, 200)); {MD11.12.03 qupe.vers.VSTOsingle}
    MField := MDataSet.FindField(SM);           {für LFieldValue}
    if MField = nil then
      EError('PutFields:Feld %s.%s fehlt', [OwnerDotName(MDataSet), SM]);
    if (LeNoNullValues in LeOptions) and (LFieldValue = '') then
      continue;                                      {keine null-Werte kopieren}
    if (LeNoOverride in LeOptions) and not FieldIsNull(MField) then
      continue;                                      {keine null-Werte kopieren}
    if SysParam.ProtBeforeOpen then
    begin
      Prot0('PutField(%s.%s) "%.80s"',[MDataset.Name, MField.FieldName, MField.AsString]);
      //GNavigator.ProcessMessages; beware 26.11.03 SDBL
    end;
    if pfAddValues in PutOptions then
      AddFieldText(MField, LFieldValue) else            {Wert nach ; anhängen}
    //MemoField werden auch verglichen. Damit keine unnötigen modified mehr - GEN 28.01.04
    if (pfCompValues in PutOptions) then
      SetFieldComp(MField, LFieldValue) else               {mit Compare}
      AssignFieldRO(MField, LField);
  except on E:Exception do
    EMess(self, E, 'PutFields(%s)', [RefList[I]]);    //18.10.02 EProt QSBT.grso
  end;
  if SysParam.ProtBeforeOpen then
    Prot0('EndPutFields(%s)',[Name]);
  if LuPostMessage in Options then
  begin
    DsGetNavLink(ToSource).pmDataChange := OldpmDataChange;
  end;
  PutStatus := OldPutStatus;
end;

procedure TLookUpDef.GetFields(RefList: TValueList);
(* Kopiert Feldwerte von Mastersource nach LookupDef
   die Umsetzung der Feldnahmen steht in RefList.
   RefList hat den Aufbau: <LookUpFieldName>=:<MasterFieldName> entspr.
   der Eigenschaften 'References' und 'SOList'.
   für NavLink.Take  03.04.00 *)
var
  I: integer;
  MField, LField: TField;
  OldReadOnly: boolean;
  MDataSet: TDataSet;
  //OldPutStatus: TPutFields;
  
  function MFieldValue: string;
  begin
    if IsBlobField(LField) or not IsBlobField(MField) then
      result := GetFieldValue(MField) else
      result := RemoveCrlf(GetFieldValue(MField));  {falls von Memo}
  end;
begin
  if SysParam.ProtBeforeOpen then Prot0('GetFields(%s)',[Name]);
  if (MasterSource = nil) or (MasterSource.DataSet = nil) or (DataSet = nil) or
     (RefList.Count = 0) then
    Exit;
  MDataSet := MasterSource.DataSet;
  for I:= 0 to RefList.Count-1 do
  try
    if not CharInSet(Char1(RefList.Value(I)), [':']) then
      continue;                               {nur echte Referenzen, keine Fltr}
    LField := DataSet.FieldByName(RefList.Param(I));
    MField := MDataSet.FieldByName(copy(RefList.Value(I), 2, 200)); {für LFieldValue}
    OldReadOnly := LField.ReadOnly;
    LField.ReadOnly := false;
    if not IsBlobField(MField) then
      SetFieldComp(LField, MFieldValue) else               {mit Compare}
      AssignField(LField.FieldName, MField);
    if OldReadOnly then
      LField.ReadOnly := OldReadOnly;
  except on E:Exception do
      EMess(self, E, 'GetFields(%s)', [RefList[I]]);
  end;
  if SysParam.ProtBeforeOpen then Prot0('EndGetFields(%s)',[Name]);
end;

procedure TLookUpDef.DoAfterReturn(LookUpModus: TLookUpModus);
begin
  try
    NavLink.InAfterReturn := true;  {für MuGri.BCStateChange}
    if assigned(FAfterReturn) then
      FAfterReturn(self, LookUpModus);
  finally
    NavLink.InAfterReturn := false;
  end;
end;

(*** TLookUpData ************************************************************)

constructor TLookUpUserData.Create(ALookUpDef: TLookUpDef);
(* für lnav.set return *)
var
  ALNav: TLNavigator;
  //ALuEdit: TLookUpEdit;
  AField: TField;
  AFieldName, AFieldValue: string;
  I, P, P1: integer;
  S1, NextS, NextS1: string;
  LeLookUpSource: TLookUpDef;
  LeLookUpField: string;
  LeDataSource: TDataSource;
  LeReferences: TFltrList;
  LeText: string;
  LeField: TField;
  HasLuEdit, NoFltrChar: boolean;
begin
  inherited create;
  FltrList := TFltrList.Create;
  DataPos := TDataPos.Create;
  HasFltr := false;
  HasData := false;
  HasKey := false;
  if ALookUpDef <> nil then
  try
    ALNav := FormGetLNav(ALookUpDef.Owner);    {(Owner as TqForm).LNavigator;}
    if ALNav <> nil then
    begin
      HasLuEdit := false;
      LeLookUpSource := nil;
      LeLookUpField := '';
      LeDataSource := nil;
      LeReferences := nil;
      LeText := '';
      LeField := nil;
      NoFltrChar := false;  // * % bewirkt Filter
      if ALNav.ActiveLookUpEdit <> nil then with TLookUpEdit(ALNav.ActiveLookUpEdit) do
      begin
        HasLuEdit := true;
        NoFltrChar := LeNoFltrChar in Options;
        LeLookUpSource := LookUpSource;
        LeLookUpField := LookUpField;
        LeDataSource := DataSource;
        LeReferences := References;
        LeText := Text;
        LeField := Field;
      end else
      if ALNav.ActiveLookUpMemo <> nil then with TLookUpMemo(ALNav.ActiveLookUpMemo) do
      begin
        HasLuEdit := true;
        NoFltrChar := LeNoFltrChar in Options;
        LeLookUpSource := LookUpSource;
        LeLookUpField := LookUpField;
        LeDataSource := DataSource;
        LeReferences := nil;
        LeText := Lines.Text;
        LeField := Field;
      end;

      if ALookUpDef.mdTyp = mdDetail then
      begin
        HasData := true;
        DataPos.AddFieldsValue(ALookUpDef.DataSet, ALookUpDef.PrimaryKeyFields);
      end else
      if HasLuEdit and (LeField <> nil) and
         (LeLookUpSource <> nil) and (LeLookUpField <> '') and
         (LeLookUpSource = ALookUpDef) and
         (LeDataSource <> nil) and (LeDataSource.DataSet <> nil) then
      begin
        if LeReferences <> nil then
        begin
          for I := 0 to LeReferences.Count - 1 do
          begin
            if Char1(LeReferences.Value(I)) <> ':' then    {kein FieldName}
              continue;
            AFieldName := copy(LeReferences.Value(I), 2, 200); {:FieldName}
            AField := LeDataSource.DataSet.FieldByName(AFieldName);
            AFieldValue := GetFieldValue(AField);
            if AFieldValue <> '' then
              FltrList.AddFmt('%s=%s',[LeReferences.Param(I), AFieldValue]);
          end;
        end;
        AFieldName := LeLookUpField;
        AFieldValue := LeText;
        if not NoFltrChar and HasFltrChr(StrCgeChar(AFieldValue, '_', '-')) then
        begin
          HasFltr := true;
          FltrList.AddFmt('%s=%s',[AFieldName, AFieldValue]);
        end else
        if length(AFieldValue) > 0 then
        begin
          HasData := true;
          DataPos.AddFmt('%s=%s',[AFieldName, AFieldValue]);
        end;
        P := 0;  //Position des Feldes innerhalb Keyfelder
        for I:= 0 to ALookUpDef.KeyList.Count-1 do
        begin
          P1 := Posi(AFieldName, ALookUpDef.KeyList.Value(I));
          { TODO -omd : TokenIndex(AFieldName, KeyList, ';') }
          if ((P = 0) or (P > P1)) and (P1 > 0) then
          begin
            P := P1;
            KeyFields := ALookUpDef.KeyList.Value(I);
          end;
          if P = 1 then
            break;              {first Keysegment matches best}
        end;
        if P > 0 then
          HasKey := true;
        if P <> 1 then
          HasData := false;     {damit kein Goto Nearest}
                                {darf nur true sein wenn DataPos mit 1.KeySeg}

        if (P > 0) and    {Nearest wenn mit 1.Keysegment }
           (LeLookupSource <> nil) and (LeLookUpSource.DataSet <> nil) and
           LeLookUpSource.DataSet.Active then
        begin
          DataPos.Clear;
          S1 := KeyFields;
          AFieldName := OnlyFieldName(PStrTok(S1, ';', NextS));  //F1 desc;F2 -> F1 desc
          AFieldName := PStrTok(AFieldName, ' ', NextS1);        //F1 desc -> F1
          while AFieldName <> '' do
          begin
            AFieldValue := GetFieldValue(
              LeLookUpSource.DataSet.FieldByName(AFieldName));
            if length(AFieldValue) > 0 then
            begin
              DataPos.AddFmt('%s=%s', [AFieldName, AFieldValue]);
              if S1 <> '' then             {nur bei 1.KeySeg}
                HasData := true;
            end;
            S1 := '';
            AFieldName := OnlyFieldName(PStrTok(S1, ';', NextS));
          end;
        end;
      end;
    end;
  except on E:Exception do
    begin
      (*if ALookUpDef <> nil then
        AFieldName := ALookUpDef.Name else
        AFieldName := 'nil';*)
      EProt(self, E, 'TLookUpUserData.Create(%s)',[OwnerDotName(ALookUpDef)]);
    end;
  end;
end;

destructor TLookUpUserData.Destroy;
begin
  FltrList.Free;
  DataPos.Free;
  inherited Destroy;
end;

function TLookUpDef.GetLuEnabled: boolean;
begin
  Result := Enabled;
end;

procedure TLookUpDef.SetLuEnabled(const Value: boolean);
var
  AForm: TqForm;
begin
  if Enabled <> Value then
  begin
    Enabled := Value;
    AForm := TqForm(Owner);
    PostMessage(AForm.Handle, BC_LNAVIGATOR, lnavSetTabs, 0);  //22.10.04
  end;
end;

end.
