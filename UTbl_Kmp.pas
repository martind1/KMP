unit UTbl_Kmp;
(* TUniTable modifiziert:
   CreateTable, EmtyTable  (von IBTable)

   DatabaseName: von TuQuery

   Letzte Änderung:
   08.06.11 md  Erstellen
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  UDB__Kmp, UDatasetIF;

type
  TuTable = class;

  TuTable = class(TUniTable, IUDataset)
  private
    SQLDialect: integer;
    FDatabaseName: string;
    FSessionName: string;
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    function GetDataBase: TuDataBase;
    procedure SetDataBase(const Value: TuDataBase);
    function GetSessionName: string;  //für CreateTable. muss 1 sein. <>1 = Namen werden mit " " umgeben.
    procedure SetSessionName(const Value: string);
    function GetTag: Integer;
    function GetComponent: TObject;
    function QuoteIdentifier(AIdentifier: String): String;
    function QuoteIdentifierIfNeeded(AProviderName,
      AIdentifier: String): String;
    function FormatIndexList(AIndexList: String): String;
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    procedure DoBeforeOpen; override;
    property Connection;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure CreateTable;
    procedure DeleteTable;
    procedure EmptyTable;
    property DataBase: TuDataBase read GetDataBase write SetDataBase;  //entspricht Connection as TuDatabase
  published
    { Published-Deklarationen }
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SessionName: string read GetSessionName write SetSessionName;
  end;

implementation

uses
  Prots, Err__Kmp, GNav_Kmp, FldDsKmp,
  USes_Kmp, UQue_Kmp;

{ TuTable }

function TuTable.QuoteIdentifierIfNeeded(AProviderName, AIdentifier: String): String;
begin
  if AProviderName = 'ProviderQuoted' then
    Result := '"' + StringReplace(TrimRight(AIdentifier), '"', '""', [rfReplaceAll]) + '"'
  else  //SQLDialect = 1:
    Result := AnsiUpperCase(Trim(AIdentifier));

end;

function TuTable.QuoteIdentifier(AIdentifier: String): String;
begin
  // von unit DBXMigrator;
  //Result := FProvider.QuoteIdentifierIfNeeded(AIdentifier);
  if Connection is TUniConnection then
    Result := QuoteIdentifierIfNeeded(TUniConnection(Connection).Providername, AIdentifier);
    Result := QuoteIdentifierIfNeeded('nil', AIdentifier);
end;

function TuTable.FormatIndexList(AIndexList: String): String;
// Indexlist idF Feld1 ASC;Feld2
// ergibt Feld1 asc, Feld2
begin
  Result := StringReplace(AIndexList, ';', ',', [rfReplaceAll, rfIgnoreCase]);
end;

constructor TuTable.Create(AOwner: TComponent);
begin
  inherited;
  SQLDialect := 1;
  FDatabaseName := 'DB1';  //wird vom Wizard entfernt 16.10.11
end;

procedure TuTable.CreateTable;
// von IBTable
var
  FieldList: string;

  procedure InitFieldsList;
  var
    I: Integer;
  begin
    InitFieldDefsFromFields;
    for I := 0 to FieldDefs.Count - 1 do begin
      if ( I > 0) then
        FieldList := FieldList + ', ';   {do not localize}
      with FieldDefs[I] do
      begin
        case DataType of
          { TODO : WideString: by MSSQL: NVARCHAR }
          ftString, ftWideString:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' VARCHAR(' + IntToStr(Size) + ')'; {do not localize}
          ftFixedChar:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' CHAR(' + IntToStr(Size) + ')'; {do not localize}
          ftBoolean, ftSmallint, ftWord:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' SMALLINT'; {do not localize}
          ftInteger:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' INTEGER'; {do not localize}
          ftFloat, ftCurrency:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' DOUBLE PRECISION'; {do not localize}
          ftBCD: begin
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' Numeric(' + IntToStr(Precision) + ', 4)'; {do not localize}
          end;
          ftDate:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' DATE'; {do not localize}
          ftTime:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' TIME'; {do not localize}
          ftDateTime:
            FieldList := FieldList +
            QuoteIdentifier(Name) +
            ' DATE'; {do not localize}
          ftLargeInt:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' Numeric(18, 0)'; {do not localize}
          ftBlob, ftMemo:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' BLOB SUB_TYPE 1'; {do not localize}
          ftBytes, ftVarBytes, ftGraphic..ftTypedBinary:
            FieldList := FieldList +
              QuoteIdentifier(Name) +
              ' BLOB SUB_TYPE 0'; {do not localize}
          ftUnknown, ftADT, ftArray, ftReference, ftDataSet,
          ftCursor, ftAutoInc:
            raise Exception.CreateFmt('TuTable.InitFieldsList: Feldtyp %d wird nicht unterstützt',
              [ord(DataType)]);
               //IBError(ibxeFieldUnsupportedType,[nil]);
        end;  //case
        if faRequired in Attributes then
          FieldList := FieldList + ' NOT NULL'; {do not localize}
      end;
    end;
  end;

  procedure InternalCreateTable;
  var
    Query: TuQuery;
  begin
    if (FieldList = '') then
      raise Exception.CreateFmt('InternalCreateTable: FieldList ist leer', [0]);
      //IBError(ibxeFieldUnsupportedType,[nil]);
    Query := TuQuery.Create(self);
    try
      Query.Database := Database;
      Query.transaction := Transaction;
      Query.SQL.Text := 'Create Table ' +    {do not localize}
        QuoteIdentifier(TableName) +
        ' (' + FieldList; {do not localize}

      if IndexFieldNames <> '' then
      begin
        //Standard=F1 asc; F2
        //Key1=F2;F3 desc
        Query.SQL.Text := Query.SQL.Text + ', CONSTRAINT PK_' +    {do not localize}
          QuoteIdentifier(TableName) +
          ' Primary Key (' +   {do not localize}
          FormatIndexList(IndexFieldNames) +
          ')';         {do not localize}
      end;
      // keine IndexDefs mehr
      Query.SQL.Text := Query.SQL.Text + ')';    {do not localize}
      Query.Prepare;
      Query.ExecSql;
    finally
      Query.Free;
    end;
  end;

begin  { CreateTable }
  CheckInactive;
  InitFieldsList;
  InternalCreateTable;
  //InternalCreateIndex; keine Indexdefs mehr hier
end;

procedure TuTable.DeleteTable;
var
  Query: TuQuery;
begin
  CheckInactive;
  Query := TuQuery.Create(self);
  try
    Query.Database := DataBase;
    Query.Transaction := Transaction;
    Query.SQL.Text := 'drop table ' +  {do not localize}
      QuoteIdentifier(TableName);
    Query.Prepare;
    Query.ExecSql;
  finally
    Query.Free;
  end;
end;

procedure TuTable.DoBeforeOpen;
begin
  if (Connection = nil) and (DatabaseName <> '') then
    Connection := USession.FindDatabase(DatabaseName);
  inherited;
end;

procedure TuTable.EmptyTable;
var
  Query: TuQuery;
begin
  if Active then
    CheckBrowseMode;
  Query := TuQuery.Create(self);
  try
    Query.Database := DataBase;
    Query.Transaction := Transaction;
    Query.SQL.Text := 'delete from ' + {do not localize}
      QuoteIdentifier(TableName);
    Query.Prepare;
    Query.ExecSql;
    if Active then
    begin
      ClearBuffers;
      DataEvent(deDataSetChange, 0);
    end;
  finally
    Query.Free;
  end;
end;

function TuTable.GetComponent: TObject;
begin
  Result := self;
end;

function TuTable.GetDataBase: TuDataBase;
begin
  if Connection is TuDataBase then
    Result := TuDataBase(Connection) else
    Result := nil;
end;

function TuTable.GetDatabaseName: string;
begin
  Result := FDatabaseName;
end;

function TuTable.GetSessionName: string;
begin
  Result := FSessionName;
end;

function TuTable.GetTag: Integer;
begin
  Result := self.Tag;
end;

procedure TuTable.SetDataBase(const Value: TuDataBase);
begin
  Connection := Value;
end;

procedure TuTable.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
  Connection := USession.FindDatabase(Value);
end;

procedure TuTable.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

end.
