unit UMetaKmp;
(* TUniMetadata modifiziert:

   mit Interfase IUDataset wegen GNav.SetDuplDB

   Letzte Änderung:
08.06.11 md  Erstellen
14.05.14 md  für Allgemeine Verwendung (von prots.InternalIndexInfo abgeleitet)
             Property UMetaDataKind, SchemaParam, SchemaName
             TableName -> Schema
30.05.14     SynonymName -> lädt Tablename
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  UDB__Kmp, UDatasetIF;

type
  TUMetaDataKind = (umdkTables, umdkColumns, umdkIndexes, umdkIndexColumns,
                    umdkConstraints);

type
  TuMetadata = class(TUniMetadata, IUDataset)
  private
    FDatabaseName: string;
    FSessionName: string;
    FUMetaDataKind: TUMetaDataKind;
    FSchemaName: string;
    FSchemaParam: string;
    FTableName: string;
    FOnlyTableName: string;
    FSynonymName: string;
    //IUDataset:
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    function GetDataBase: TuDataBase;
    procedure SetDataBase(const Value: TuDataBase);
    function GetSessionName: string;  //für CreateTable. muss 1 sein. <>1 = Namen werden mit " " umgeben.
    procedure SetSessionName(const Value: string);
    function GetTag: Integer;
    function GetComponent: TObject;
    procedure SetUMetaDataKind(const Value: TUMetaDataKind);
    procedure SetSchemaName(const Value: string);
    procedure SetSchemaParam(const Value: string);
    procedure SetTableName(const Value: string);
    procedure SetOnlyTableName(const Value: string);
    procedure SetSynonymName(const Value: string);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure BeginConnection; override;
    property Connection;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    property DataBase: TuDataBase read GetDataBase write SetDataBase;  //entspricht Connection as TuDatabase
    property OnlyTableName: string read FOnlyTableName write SetOnlyTableName;
    property SynonymName: string read FSynonymName write SetSynonymName;
  published
    { Published-Deklarationen }
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SessionName: string read GetSessionName write SetSessionName;
    property UMetaDataKind: TUMetaDataKind read FUMetaDataKind write SetUMetaDataKind;
    property SchemaParam: string read FSchemaParam write SetSchemaParam;
    property SchemaName: string read FSchemaName write SetSchemaName;
    property TableName: string read FTableName write SetTableName;
  end;

implementation

uses
  Prots, Err__Kmp, GNav_Kmp, FldDsKmp,
  USes_Kmp, UQue_Kmp;

{ TuMetadata }

{ TuMetadata }

constructor TuMetadata.Create(AOwner: TComponent);
begin
  inherited;
  FDatabaseName := 'DB1';  //wird vom Wizard entfernt 16.10.11
  if AOwner is TUDatabase then
    Database := TUDatabase(AOwner) else
  if AOwner is TUniConnection then
    Connection := TUniConnection(AOwner);
end;

procedure TuMetadata.BeginConnection;
begin
  if (Connection = nil) and (DatabaseName <> '') then
    DataBase := USession.FindDatabase(DatabaseName);
  inherited;
end;

function TuMetadata.GetComponent: TObject;
begin
  Result := self;
end;

function TuMetadata.GetDataBase: TuDataBase;
begin
  //UniConnection anhand DatabaseName setzen
  if (Connection = nil) and (DatabaseName <> '') then
    Connection := USession.FindDatabase(DatabaseName);  //kein else!
  if Connection is TuDataBase then
    Result := TuDataBase(Connection) else
    Result := nil;
end;

procedure TuMetadata.SetDataBase(const Value: TuDataBase);
begin
  if Connection <> Value then
  begin
    Close;
    Connection := Value;
  end;
  if (Value <> nil) and SameText(Value.ProviderName, 'Oracle') then
  begin
    SchemaParam := 'TABLE_SCHEMA';
    if SchemaName = '' then
      SchemaName := Database.Username;  //TRINKMB statt TRINK
  end else
  begin
    SchemaParam := 'SCHEMA_NAME';
  end;
end;

procedure TuMetadata.Loaded;
begin
  inherited;
  if (DatabaseName <> '') and (Connection = nil) then
    Database := USession.FindDatabase(DatabaseName);
end;

function TuMetadata.GetDatabaseName: string;
begin
  Result := FDatabaseName;
end;

function TuMetadata.GetSessionName: string;
begin
  Result := FSessionName;
end;

function TuMetadata.GetTag: Integer;
begin
  Result := self.Tag;
end;

procedure TuMetadata.SetDatabaseName(const Value: string);
begin
  if FDatabaseName <> Value then
  begin
    Close;
    FDatabaseName := Value;
  end;
  if not (csLoading in ComponentState) then
    Database := USession.FindDatabase(Value);
end;

procedure TuMetadata.SetSchemaName(const Value: string);
begin
  if FSchemaName <> Value then
  begin
    Close;
    FSchemaName := Value;
    Restrictions.Values[FSchemaParam] := FSchemaName;
  end;
end;

procedure TuMetadata.SetSchemaParam(const Value: string);
begin
  if FSchemaParam <> Value then
  begin
    Close;
  end;
  if (FSchemaParam <> Value) and (FSchemaParam <> '') then
    Restrictions.Values[FSchemaParam] := '';
  FSchemaParam := Value;
  Restrictions.Values[FSchemaParam] := FSchemaName;
end;

procedure TuMetadata.SetSessionName(const Value: string);
begin
  if FSessionName <> Value then
    Close;
  FSessionName := Value;
end;

procedure TuMetadata.SetSynonymName(const Value: string);
{lädt Tablename anhand synonym
OWNER	SYNONYM_NAME	TABLE_OWNER	TABLE_NAME	DB_LINK
QUVA	ADRE	        QUVA	      ADRESSEN
}
var
  Que: TuQuery;
begin
  Que := nil;
  //beware (sql_dlg) if FSynonymName = Value then Exit;
  FSynonymName := Value;
  if FSynonymName = '' then
    Exit;
  if (Database <> nil) and SameText(Database.ProviderName, 'Oracle') then
  try
    Que := TuQuery.Create(nil);
    Que.DatabaseName := Database.DatabaseName;
    Que.SQL.Text := 'select TABLE_OWNER, TABLE_NAME from ALL_SYNONYMS ' +
      'where SYNONYM_NAME = :SYNONYM_NAME';
    Que.ParamByName('SYNONYM_NAME').AsString := UpperCase(Value);
    Que.Open;
    if not Que.EOF then
    begin
      SchemaName := Que.FieldByName('TABLE_OWNER').AsString;
      TableName := Que.FieldByName('TABLE_NAME').AsString;
    end;
  finally
    Que.Free;
  end;
end;

procedure TuMetadata.SetOnlyTableName(const Value: string);
begin
  if FOnlyTableName <> Value then
  begin
    Close;
    FOnlyTableName := Value;
    Restrictions.Values['TABLE_NAME'] := Value;
  end;
end;

procedure TuMetadata.SetTableName(const Value: string);
var
  NextStr: string;
begin
  FTableName := Value;
  if Pos('.', Value) > 0 then
  begin
    SchemaName := PStrTok(Value, '.', NextStr);
    OnlyTableName := PStrTokNext('.', NextStr);
  end else
    OnlyTableName := Value;
end;

procedure TuMetadata.SetUMetaDataKind(const Value: TUMetaDataKind);
begin
  if FUMetaDataKind <> Value then
    Close;
  FUMetaDataKind := Value;
  case Value of
    umdkTables:  MetaDataKind := 'Tables';
    umdkColumns: MetaDataKind := 'Columns';
    umdkIndexes: MetaDataKind := 'Indexes';
    umdkIndexColumns: MetaDataKind := 'IndexColumns';
    umdkConstraints: MetaDataKind := 'Constraints';
  else
    EError('falscher Wert für TuMetadata.SetUMetaDataKind.Value: %d', [ord(Value)]);
  end;
end;

end.
