unit Gen__Kmp;
(* Komponente zum Generieren neuer Nummern
   Autor      M.Dambach
   07.07.97   Erstellt
   28.02.97   Sequence: Unterstützung Oracle-Sequence und Interbase Generator/GEN_ID
   22.02.99   ParaTable als Property für Zugriff von außerhalb
   06.11.05   UseIni für Verwendung der Ini. IniSection[Owner.Name], IniType[Machine]
   20.10.08   OnBeforeNewNumber belegt ValueAkt. Field wird hier zugewiesen.
   16.12.13   ParaTable<>nil and FieldAkt='': Min/Max von Paratable; Akt von Max(Datasource)
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  DBCtrls, DB,  Uni, DBAccess, MemDS, UQue_Kmp,
  DPos_Kmp, Ini__Kmp;

type
  TBeforeNewNumberEvent = procedure(Sender: TComponent; DoUpdate: boolean; var Done: boolean) of Object;
  TAfterNewNumberEvent = procedure(Sender: TComponent; DoUpdate: boolean) of Object;
  TCheckNewNumberEvent = procedure(Sender: TComponent; DoUpdate: boolean; var CheckOK: boolean) of Object;

type
  TGenerator = class(TComponent)
  private
    { Private-Deklarationen }
    FDataSource: TDataSource;
    FDataField: string;
    FKeyFields: string;
    FParaTableName: string;
    FFieldMin: string;
    FValueMin: string;
    FFieldMax: string;
    FValueMax: string;
    FFieldAkt: string;
    FValueAkt: string;
    FParaFltrList: TFltrList;
    FForceEmpty: boolean;                     {true = leere Felder als is null}
    FSequence: string;
    FParaTable: TuQuery;
    FUseIni: boolean;
    ErrStr: string;                        {für BuildSql}
    FBeforeNewNumber: TBeforeNewNumberEvent;
    FAfterNewNumber: TAfterNewNumberEvent;
    FCheckNewNumber: TCheckNewNumberEvent;
    procedure SetFieldMin(Value: string);
    procedure SetValueMin(Value: string);
    procedure SetFieldMax(Value: string);
    procedure SetValueMax(Value: string);
    procedure SetFieldAkt(Value: string);
    procedure SetValueAkt(Value: string);
    procedure SetParaFltrList(Value: TFltrList);
    function GeTuQuery: TuQuery;
    function GetField: TField;
    function GetParaTable: TuQuery;
  protected
    { Protected-Deklarationen }
    GenTable: TuQuery;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure GetParaValues(DoUpdate: boolean);
    property DBDataSet: TuQuery read GeTuQuery;
    function GenTableName: string;
    procedure GenTableCreate;
    procedure GetOracleSequence;
    procedure FreeParaTable;
  public
    { Public-Deklarationen }
    IniSection: string;
    IniSectionTyp: TSecTyp;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NewNumber(DoUpdate: boolean);
    procedure PutNumber;
    procedure ReleaseNumber(Value: string); {Nummer freigeben wenn kleiner Aktuell}
    procedure UpdateParaTable;
    property Field: TField read GetField;
    property ParaTable: TuQuery read GetParaTable;
  published
    { Published-Deklarationen }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property DataField: string read FDataField write FDataField;
    property KeyFields: string read FKeyFields write FKeyFields;
    property ParaTableName: string read FParaTableName write FParaTableName;
    property FieldMin: string read FFieldMin write SetFieldMin;
    property ValueMin: string read FValueMin write SetValueMin;
    property FieldMax: string read FFieldMax write SetFieldMax;
    property ValueMax: string read FValueMax write SetValueMax;
    property FieldAkt: string read FFieldAkt write SetFieldAkt;
    property ValueAkt: string read FValueAkt write SetValueAkt;
    property UseIni: boolean read FUseIni write FUseIni;
    property ParaFltrList: TFltrList read FParaFltrList write SetParaFltrList;
    property ForceEmpty: boolean read FForceEmpty write FForceEmpty;
    property Sequence: string read FSequence write FSequence;
    property BeforeNewNumber: TBeforeNewNumberEvent read FBeforeNewNumber write FBeforeNewNumber;
    property AfterNewNumber: TAfterNewNumberEvent read FAfterNewNumber write FAfterNewNumber;
    property CheckNewNumber: TCheckNewNumberEvent read FCheckNewNumber write FCheckNewNumber;
  end;

implementation

uses
  Forms,
  UTbl_Kmp,
  Err__Kmp, LuDefKmp, Qwf_Form, Prots, GNav_Kmp, AbortDlg;

const
  SMaxValue = 'MAXVALUE';

function TGenerator.GetField: TField;
begin
  result := nil;
  if (DBDataSet <> nil) and (DataField <> '') then
  begin
    DBDataSet.Open;
    result := DBDataSet.FieldByName(DataField);
  end;
end;

function TGenerator.GetParaTable: TuQuery;
begin
  if FParaTable = nil then
  try
    if (DBDataSet <> nil) and (QueryDatabase(DBDataSet) <> nil) then
      FParaTable := TuQuery.Create(QueryDatabase(DBDataSet)) else
      FParaTable := TuQuery.Create(GNavigator.DB1);
    //create FParaTable.DataBaseName := DBDataSet.DatabaseName;
    FParaTable.MasterSource := FDataSource;
    FParaTable.RequestLive := true;
    FParaFltrList.BuildSql(FParaTable, FParaTableName, '', nil, ErrStr);
    FParaTable.Open;
  except on E:Exception do
    EProt(FParaTable, E, 'Fehler bei ParaTable (%s):%s', [OwnerDotName(self), ErrStr]);
  end;
  result := FParaTable;
end;

procedure TGenerator.UpdateParaTable;
begin
  with ParaTable do
  try
    FParaTable.Close;
    FParaTable.RequestLive := false;
    //Original SQL where Klausel bleibt erhalten bzgl. ParaFltrList. ->wirklich? 02.08.05
    // "select *|from *|where ...
    SQL[0] := 'update ' + FParaTableName;
    SQL[1] := Format('set %s=%s', [FFieldAkt, FValueAkt]);
    QueryExecCommitted(ParaTable);
  except on E:Exception do
    EProt(FParaTable, E, 'Fehler bei UpdateParaTable (%s)', [self.Name]);
  end;
end;

procedure TGenerator.FreeParaTable;
begin
  if FParaTable <> nil then
  begin
    FParaTable.Free;
    FParaTable := nil;
  end;
end;

function TGenerator.GeTuQuery: TuQuery;
begin
  if (DataSource <> nil) and (DataSource.DataSet <> nil) and
     (DataSource.DataSet is TuQuery) then
  begin
    result := DataSource.DataSet as TuQuery;
  end else
    result := nil;
end;

function TGenerator.GenTableName: string;
begin
  result := '';
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
  begin
    if DataSource is TLookUpDef then
      result := (DataSource as TLookUpDef).TableName else
    if FormGetLNav((DataSource.Owner as TForm)) <> nil then
      result := FormGetLNav((DataSource.Owner as TForm)).TableName;
    if result = '' then
    begin
      if DataSource.DataSet is TuTable then
        result := TuTable(DataSource.DataSet).TableName else
      if DataSource.DataSet is TuQuery then
        result := QueryTableName(TuQuery(DataSource.DataSet));
    end;
  end;
end;

procedure TGenerator.GenTableCreate;
var
  AFltrList: TFltrList;
  AFieldList: TValueList;
  AFieldName, AText, Err: string;
  I: integer;
begin
  if GenTable = nil then
    GenTable := TuQuery.Create(QueryDatabase(DBDataSet)) else    //self
    GenTable.Cancel;                      {war evtl. insert}
  //create GenTable.DataBaseName := DBDataSet.DatabaseName;
  AFltrList := TFltrList.Create;
  AFieldList := TValueList.Create;
  try
    (* FldDsc
    AFieldList.AddTokens(KeyFields,';');        {150598 qwf.pdox}
    AFltrList.BuildSql(GenTable, GenTableName, '', AFieldList, Err);
    UpdateFieldDefs(GenTable);                   {150598 qwf.pdox. Nur für Fielddefs.Update}
    *)
    AFieldList.Clear;
    AFieldList.Add(Format('max(%s) as %s',[DataField, SMaxValue]));
    AFltrList.AddTokens(KeyFields,';');
    for I:= AFltrList.Count-1 downto 0 do
    begin
      AFieldName := AFltrList.Strings[i];
      if CompareText(AFieldName, DataField) <> 0 then
      begin
        AText := DBDataSet.FieldByName(AFieldName).AsString;
        if (AText = '') then
          if FForceEmpty then
            AText := '=' else          {is null}
            AFltrList.Delete(I);
        if AText <> '' then
          AFltrList.Strings[i] := Format('%s=%s', [AFieldName, AText]);
      end else
        AFltrList.Delete(I);
    end;
    if (ValueMin <> '') and (ValueMax <> '') then
      AFltrList.AddFmt('%s=#%s~#%s', [Datafield, ValueMin, ValueMax]) else
      if (ValueMin <> '') then
        AFltrList.AddFmt('%s=>=#%s', [Datafield, ValueMin]) else
        if (ValueMax <> '') then
          AFltrList.AddFmt('%s=<=#%s', [Datafield, ValueMax]);
    AFltrList.BuildSql(GenTable, GenTableName, '', AFieldList, Err);
    {Group by notwendig, da Felder und Max-Funktion in select }
  finally
    AFieldList.Free;
    AFltrList.Free;
  end;
end;

procedure TGenerator.GetOracleSequence;
(* lädt NextValue von Sequence. Vor.: Oracle Datenbank *)
var
  AQuery: TuQuery;
  AktVal: longint;
begin
  AQuery := TuQuery.Create(QueryDatabase(DBDataSet));
  try
    //create AQuery.DataBaseName := DBDataSet.DatabaseName;
    AQuery.SQL.Add(Format('SELECT %s.NEXTVAL FROM DUAL', [FSequence]));
    AQuery.Open;
    if AQuery.EOF then
      EError('Oracle.Nextval(%s) ergibt keinen Wert', [FSequence]);
    AktVal := AQuery.Fields[0].AsInteger;
    FValueAkt := IntToStr(AktVal);
  finally
    AQuery.Free;
  end;
end;

procedure TGenerator.NewNumber(DoUpdate: boolean);
(* Neue Nummer generieren. DoUpdate: true = mit zurückspeichern *)
var
  AktVal: longint;
  N, Cntr: integer;
  Done, CheckOK: boolean;
begin
  Cntr := 0;
  repeat  //Wiederholen bis CheckNewNumber erfolgreich ist
    Done := false;
    AktVal := StrToIntTol(FValueMin);  //für Compiler
    if Assigned(FBeforeNewNumber) then
    begin
      //Ereignis belegt Property ValueAkt. Field wird hier weiter unten zugewiesen
      FBeforeNewNumber(self, DoUpdate, Done);
      if Done then
        AktVal := StrToInt(FValueAkt);  
    end;
    if not Done then
    begin
      if fUseIni then
      begin
        AktVal := 1 + IniKmp.ReadInteger(IniSection, 'ValueAkt', StrToIntTol(FValueMin));
        if AktVal < StrToIntTol(FValueMin) then
          AktVal := StrToIntTol(FValueMin);
        if (FValueMax <> '') and (AktVal > StrToIntTol(FValueMax)) then
          AktVal := StrToIntTol(FValueMin);    {zurückspringen}
        FValueAkt := IntToStr(AktVal);
        if DoUpdate then
        begin
          IniKmp.SectionTyp[IniSection] := IniSectionTyp;
          IniKmp.WriteInteger(IniSection, 'ValueAkt', AktVal);
        end;
      end else
      if (FSequence <> '') and SysParam.Oracle then
      begin                                        {Sequence von Oracle}
        GetOracleSequence;
        AktVal := StrToIntTol(FValueAkt);
      end else
      (*if (FSequence <> '') and SysParam.Interbase then
      begin                                        {Generator von Intebase}
        GetInterbaseGen_ID;
      end else*)
      if (ParaTableName <> '') and                 {Zähler in Fremdtabelle}
         (FFieldAkt <> '') then         //wenn '' dann max() verwenden - 16.12.13
      begin
        GetParaValues(DoUpdate);
        AktVal := StrToIntTol(FValueAkt);
      end else
      try                                          {select max() from ...}
        Screen.Cursor := crHourGlass;
        GetParaValues(false);      //setzt ValueMin,ValueMax anhand NUMM Table
        GenTableCreate;
        if Sysparam.ProtBeforeOpen then
          Prot0('GEN(%s):%s', [OwnerDotName(self), GenTable.Text]);
        if SysParam.Standard then
        begin
          GenTable.Open;
          GenTable.Refresh;          {BDE Force Reread}
          GenTable.Close;
        end;
        GenTable.Open;
        if GenTable.EOF or
           GenTable.FieldByName(SMaxValue).IsNull then      {040700 ISA.Kund.Adre}
        begin
          AktVal := StrToIntTol(FValueMin);          {auf 1.Wert}
          {AktVal := 1 + StrToIntTol(FValueAkt);      nein 040700 ISA.Kund.Adre}
        end else
          AktVal := 1 + StrToIntTol(GenTable.FieldByName(SMaxValue).AsString);
        if AktVal < StrToIntTol(FValueMin) then
          AktVal := StrToIntTol(FValueMin);
        if (FValueMax <> '') and (AktVal > StrToIntTol(FValueMax)) then
          AktVal := StrToIntTol(FValueMin);    {zurückspringen}
        if DoUpdate or not GenTable.EOF or    {warum diese Abfrage ? Damit er bei}
           Assigned(FCheckNewNumber) then
          FValueAkt := IntToStr(AktVal);       {  EOF nicht weiterzählt}
      finally
        GenTable.Free;                  {Fields u. Fielddefs müssen gelöscht werden}
        GenTable := nil;
        Screen.Cursor := crDefault;
      end;
    end; {not Done}
    if FValueMax <> '' then
      N := length(FValueMax) else
      N := length(IntToStr(AktVal));
    if (Field <> nil) and                                    {IntToStr(AktVal));}
       (Field.DataSet.State in dsEditModes) then
    try
      SetFieldValueRO(Field, FormatFloat(copy('000000000000', 1, N), AktVal));
    except on E:Exception do
      EProt(self, E, 'NewNumber', [0]);
    end;

    CheckOK := true;
    if Assigned(FCheckNewNumber) then
    begin
      if Cntr = 0 then
        GNavigator.ProcessMessages;
      FCheckNewNumber(self, DoUpdate, CheckOK);
      if not CheckOK then
      begin
        if Cntr = 0 then
        begin
          TDlgAbort.CreateDlg('');
          TDlgAbort.SetCaption('Generiere neue Nummer');
        end;
        if TDlgAbort.Canceled then {canceled erst hier initialisiert}
          SysUtils.Abort;
        TDlgAbort.SetText('belegt: ' + FValueAkt);
        DoUpdate := true;  //Vermeidung endless loop - 16.12.13
      end else
      if Cntr > 0 then
        TDlgAbort.FreeDlg;
    end;
    Inc(Cntr);
  until CheckOK;
  if Assigned(FAfterNewNumber) then
    FAfterNewNumber(self, DoUpdate); {Done: Ergebnis von BeforeNewNumber}
end;

procedure TGenerator.GetParaValues(DoUpdate: boolean);
var
  AktVal: longint;
begin
  if csLoading in ComponentState then
    Exit;
  if ((FFieldMin <> '') or (FFieldMax <> '') or (FFieldAkt <> '')) and
     (FParaTableName <> '') then  //DBDataSet hier nicht relevant - md19.05.08
  begin
    try
      FreeParaTable;
      if ParaTable.EOF and not (csDesigning in ComponentState) then
        ErrWarn('Generator:Parametersatz in (%s) nicht gefunden' + CRLF + '(%s)',
          [FParaTableName, ParaTable.Sql.GetText]);
      if (FFieldMin <> '') then
        FValueMin := ParaTable.FieldByName(FFieldMin).AsString;
      if (FFieldMax <> '') then
        FValueMax := ParaTable.FieldByName(FFieldMax).AsString;
      if (FFieldAkt <> '') then
      begin
        AktVal := 1 + StrToIntTol(ParaTable.FieldByName(FFieldAkt).AsString);
        if AktVal < StrToIntTol(FValueMin) then
          AktVal := StrToIntTol(FValueMin);
        if (FValueMax <> '') and (AktVal > StrToIntTol(FValueMax)) then
          AktVal := StrToIntTol(FValueMin);     {zurückspringen}
        FValueAkt := IntToStr(AktVal);           {hier 180399}
        if not ParaTable.EOF and DoUpdate then
        begin
          UpdateParaTable;                       {180399}
          {ParaTable.Edit;
          SetFieldValueRO(ParaTable.FieldByName(FFieldAkt), IntToStr(AktVal));
          ParaTable.Post;}
        end;
      end;
    finally
      FreeParaTable;
    end;
  end;
end;

procedure TGenerator.PutNumber;
(* Aktuelle Nummer zurückschreiben *)
begin
  if ParaTableName <> '' then                  {Zähler in Fremdtabelle}
  begin
    if (FFieldAkt <> '') and (FParaTableName <> '') and (DBDataSet <> nil) then
    begin
      FValueAkt := Field.AsString;
      try
        FreeParaTable;
        if not ParaTable.EOF then
        begin
          ParaTable.Edit;
          SetFieldValueRO(ParaTable.FieldByName(FFieldAkt), FValueAkt);
          ParaTable.Post;
        end;
      finally
        FreeParaTable;
      end;
    end;
  end;
end;

procedure TGenerator.ReleaseNumber(Value: string);
(* Aktuelle oder kleinere Nummer (in Value) wieder freigeben *)
var
  ReleaseVal: longint;
begin
  if ParaTableName <> '' then                  {Zähler in Fremdtabelle}
  begin
    ReleaseVal := StrToInt(Value);
    GetParaValues(false);           {holt die nächste Nummer + 1 nach FValueAkt}
    if StrToIntTol(FValueAkt) - 1 >= ReleaseVal then
    begin                          {ReleaseVal ist die zuletzt vergebene Nummer}
      FValueAkt := IntToStr(ReleaseVal - 1);
      UpdateParaTable;
    end;
  end;
end;

procedure TGenerator.SetFieldMin(Value: string);
begin
  FFieldMin := Value;
  if Value <> '' then
    GetParaValues(false);
end;

procedure TGenerator.SetValueMin(Value: string);
begin
  if Value <> '' then
  begin
    FValueMin := IntToStr(StrToInt(Value));
    {if not (csLoading in ComponentState) then
      FFieldMin := '';                       warum ? 090900}
  end else
    FValueMin := '';
end;

procedure TGenerator.SetFieldMax(Value: string);
begin
  FFieldMax := Value;
  if Value <> '' then
    GetParaValues(false);
end;

procedure TGenerator.SetValueMax(Value: string);
begin
  if Value <> '' then
  begin
    FValueMax := IntToStr(StrToInt(Value));
    {if not (csLoading in ComponentState) then
      FFieldMax := '';                       warum ? 090900}
  end else
    FValueMax := '';
end;

procedure TGenerator.SetFieldAkt(Value: string);
begin
  FFieldAkt := Value;
  if Value <> '' then
    GetParaValues(false);
end;

procedure TGenerator.SetValueAkt(Value: string);
begin
  if Value <> '' then
  begin
    FValueAkt := IntToStr(StrToInt(Value));   {Test auf korrekten Integerwert}
    {if not (csLoading in ComponentState) then
      FFieldAkt := '';                        warum ? 090900}
  end else
    FValueAkt := '';
end;

procedure TGenerator.SetParaFltrList(Value: TFltrList);
begin
  if Value <> nil then
    FParaFltrList.Assign(Value) else
    FParaFltrList.Clear;
end;

constructor TGenerator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParaFltrList := TFltrList.Create;
end;

destructor TGenerator.Destroy;
begin
  ParaFltrList.Free;
  GenTable.Free;
  inherited Destroy;
end;

procedure TGenerator.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
    if AComponent = DataSource then
      DataSource := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TGenerator.Loaded;
begin
  inherited;
  IniSection := OwnerClassDotName(self);
  IniSectionTyp := stMaschine;
end;

end.
