unit UDB__Kmp;
(* TUniConnection modifiziert:
  1. TUniConnection
  2. Kompatibilität TDatabase (Readonly, Aliasname, Databasename, Params, OnLogin,..)
  3. Kompatibilität TqDatabase (ConnectSql, StartConnect)
  4. Session (SQLHourGlass)

  Autor: Martin Dambach
  Letzte Änderung:
  21.09.99     Dummy-property SessionName für D2 Kompatibilität
  15.12.03     Designer: DB1.Params <-- Bemerkung
  25.11.06     TblPrefix (statt in Sysparams jetzt pro Database)
  22.05.09     MSSQL: READ UNCOMMITTED
  05.06.11 md  UniDAC
  startconnect -> not Options.KeepDesignConnected
  todo: klären wie geänderte Metadaten im Design aktualisiert werden
  12.06.11 md  todo: Logon Params
  09.10.11 md  IsSqlBased immere true (fehlt in unidac)
  02.11.11 md  Passwort in Params verschlüsselt ablegen
  22.12.11 md  CloseDatasets?
  21.06.12 md  IsMSSQL,...

  ---
  - Ist immer noch von VCL TCustomConnection abgeleitet
  - OnLogin: Original wird überschrieben. Params-Parameter von TDatabase
  - TransIsolation: nicht benutzt
  ---
  - Die BDE-Params werden verwendet und übertragen nach SpecificParams, Server, User, Passw, ..
  ---
  - siehe auch: TDatabase.CheckDatabaseAlias(var Password: string);

*)

{ TODO : ReadOnly per Notification Event an DataSets weitergeben }

{ TODO :
  Prüfen ob Params auch in Uni.SpecificParams verwaltet werden können.
  Bzw. ob SpecificP auch zusätzliche ParamNames erlaubt. }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB, Uni, DBAccess, MemDS,
  DBTables;

type
  TuDataBase = class;

  TuDatabaseLoginEvent = procedure(Database: TuDataBase;
    LoginParams: TStrings) of object;

  TuDataBase = class(TUniConnection)
  private
    { Private-Deklarationen }
    FSessionName: string;
    FTblPrefix: string;
    FAliasName: string;
    FDatabaseName: string;
    FReadOnly: Boolean;
    FConnectSql: TStrings;
    FParams: TStrings;
    FOnLogin: TuDatabaseLoginEvent;
    FTransIsolation: TTransIsolation;
    FSQLHourGlass: Boolean;
    FInGetParams: Boolean;
    FAliasParams: TStrings;
    FConnectionParams: TStrings;
    procedure SetAliasName(const Value: string);
    procedure SetConnectSql(const Value: TStrings);
    procedure SetDatabaseName(const Value: string);
    procedure SetReadOnly(const Value: Boolean);
    function GetParams: TStrings;
    procedure SetParams(const Value: TStrings);
    procedure ParamsChange(Sender: TObject);
    procedure SetSQLHourGlass(const Value: Boolean);
    function GetStartConnect: Boolean;
    procedure SetStartConnect(const Value: Boolean);
    procedure AliasToConnection(AAliasName: string);
    procedure MergeConnectionParams(AParams: TStrings);
    procedure SetConnectionParams(AParams: TStrings);
    function GetAliasParams: TStrings;
    function GetConnectionParams: TStrings;
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure DoConnect; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AssignAliasParams(AliasParams: TStrings);
    procedure ExecConnectSql;
    function IsMSSQL: Boolean;
    // BDE Kompatibel
    function IsSqlBased: Boolean;
    procedure CloseDataSets;
    // Ersetzt in Uni mit anderer Syntax procedure GetTableNames(const Pattern: string; Extensions, SystemTables: Boolean; List: TStrings);
    function UDecryptFromHex(const Value: string): string;
    property AliasParams: TStrings read GetAliasParams;
    property ConnectionParams: TStrings read GetConnectionParams;
  published
    { Published-Deklarationen }
    property AliasName: string read FAliasName write SetAliasName;
    // '' wenn nicht persistent
    property DatabaseName: string read FDatabaseName write SetDatabaseName;
    // '' wenn nicht zugeordnet
    property SessionName: string read FSessionName write FSessionName;
    // 'SESSION'
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property SQLHourGlass
      : Boolean read FSQLHourGlass write SetSQLHourGlass default
      False;
    property TblPrefix: string read FTblPrefix write FTblPrefix; // dbo.
    property ConnectSql: TStrings read FConnectSql write SetConnectSql;
    property OnLogin: TuDatabaseLoginEvent read FOnLogin write FOnLogin;
    // BDE Kompatibel
    property Params: TStrings read GetParams write SetParams;
    // 16.10.11 nach published
    property TransIsolation: TTransIsolation read FTransIsolation write FTransIsolation default tiReadCommitted; // 16.10.11 nach published
    property StartConnect: Boolean read GetStartConnect write SetStartConnect;
  end;

function UniServer(BdeServer: string): string;
function UniDatabase(BdeServer: string): string;

implementation

uses
  Prots, DPos_Kmp, Err__Kmp, GNav_Kmp, FldDsKmp,
  USes_Kmp;

function UniServer(BdeServer: string): string;
//extrahiert Server Name aus dem BDE-Format
//wenn 'd:' dann localhost
var
  S1, NextS: string;
begin
  S1 := PStrTok(BdeServer, ':', NextS);
  if Length(S1) > 1 then
    Result := S1 else        //  franki:d:\db\ldynxxx.fdb -> franki
    Result := 'localhost';   //  c:\db\ldynxxx.fdb -> localhost
end;

function UniDatabase(BdeServer: string): string;
//extrahiert Database Name aus dem BDE-Format
var
  S1, NextS: string;
begin
  S1 := PStrTok(BdeServer, ':', NextS);
  if Length(S1) > 1 then
    Result := NextS else        //  franki:d:\db\ldynxxx.fdb -> d:\db\ldynxxx.fdb
    Result := BdeServer;        //  c:\db\ldynxxx.fdb -> c:\db\ldynxxx.fdb
end;

procedure TuDataBase.AssignAliasParams(AliasParams: TStrings);
begin
  { TODO : vom UniDialog übernehmen }
end;

procedure TuDataBase.ExecConnectSql;
var
  I: integer;
begin
  // von KMP
  for I := 0 to ConnectSql.Count - 1 do
  try
    ExecSQL(ConnectSql[I], [0]);
  except
    on E: Exception do
      EProt(self, E, 'ConnectSql(%s)', [ConnectSql[I]]);
  end;
end;


// TUni

procedure TuDataBase.CloseDataSets;
var
  I: integer;
begin
  for I := 0 to DataSetCount - 1 do
    if DataSets[I] is TCustomDADataSet then
      TCustomDADataSet(DataSets[I]).Close;
end;

constructor TuDataBase.Create(AOwner: TComponent);
begin
  inherited;
  FSessionName := 'Default'; // es gibt momentan nur eine Session
  FParams := TValueList.Create;
  TValueList(FParams).OnChange := ParamsChange;
  FAliasParams := TValueList.Create;
  FConnectionParams := TValueList.Create;
  FConnectSql := TStringList.Create;
  TUSession.AddDataBase(FSessionName, self); // Session verwaltet Liste mit allen Databases
end;

destructor TuDataBase.Destroy;
begin
  FreeAndNil(FParams);
  FreeAndNil(FAliasParams);
  FreeAndNil(FConnectionParams);
  FreeAndNil(FConnectSql);  //27.09.13
  TUSession.RemoveDataBase(FSessionName, self);
  inherited;
end;

procedure TuDataBase.Loaded;
var
  S1, S2: string;
  Par, Val: string;
  I: integer;
begin
  inherited;
  // falls LogonDlg von mehreren Anwendungsschemas verwendet wird,
  // können im Designmodus bei GNavigator.Bemerkung User Name und andere
  // Database.Params vorbelegt werden. Syntax: <DatabaseName>.USER NAME=MyUserName
  // Für Runtime keine Bedeutung
  // 02.11.11 weg - Params.Values['SERVER NAME'] := ''; // in LoginFrm zugewiesen. qugl mindy - 13.05.08
  if csDesigning in ComponentState then
  begin
    if GNavigator <> nil then
    begin // vergl. TGNavigator.Loaded/DbInit;
      for I := 0 to GNavigator.Bemerkung.Count - 1 do
      begin
        S1 := GNavigator.Bemerkung[I]; // DB1.SERVER NAME=myserver
        if BeginsWith(S1, DatabaseName + '.', true) then
        begin // SERVER NAME, ALIAS, ...
          S2 := Copy(S1, Length(DatabaseName) + 2, MaxInt);
          Par := StrParam(S2);
          Val := StrValue(S2);
          if Pos('=', S2) > 0 then  // SERVER NAME=myserver
          begin
            if SameText(Par, 'Alias') then
            begin
              FAliasname := Val;  //kein Set da Connection hier befüllt wird.
            end else
            if Params.Values[Par] <> Val then
              Params.Values[Par] := Val;
          end;
        end;
      end;
    end;
  end;

  if AliasName <> '' then
  begin
    AliasToConnection(AliasName);
    MergeConnectionParams(FParams);
  end;
end;

procedure TuDataBase.SetAliasName(const Value: string);
begin
  //nein 03.11.11 - if FAliasName <> Value then
  begin
    FAliasName := Value;
    if not (csLoading in ComponentState) and (FAliasName <> '') then
    begin
      AliasToConnection(FAliasName);
      MergeConnectionParams(FParams);  //Username usw. bleiben
    end;
    { Params und damit Connection-Konfig zuordnen wenn Value<>'' }
  end;
end;

procedure TuDataBase.SetDatabaseName(const Value: string);
begin
{ TODO : sesssion.databaselist: alten Namen ersetzen durch neuen Namen. }
  //wieso? TUSession.SetDataBase(FSessionName, self); // Session verwaltet Liste mit allen Databases
  FDatabaseName := Value;
end;

function TuDataBase.GetAliasParams: TStrings;
//ergibt die (nicht-Modifizierten) Parameter direkt vom Alias.
begin
  USession.GetAliasParams(AliasName, FAliasParams);
  Result := FAliasParams;
end;

function TuDataBase.GetConnectionParams: TStrings;
//ergibt die Parameter von der UniConnection. Mit Port, Passwort, User
begin
  FConnectionParams.Clear;
  with FConnectionParams do
  begin
    FConnectionParams.Assign(SpecificOptions);

    Values['ProviderName'] := ProviderName;
    if Port <> 0 then
      Values['Port'] := IntToStr(Port);
    Values['PASSWORD'] := String(EncryptPassw(AnsiString(PassWord)));
    Values['USER NAME'] := Username;
    Values['SERVER NAME'] := Server;
    Values['DATABASE NAME'] := Database; // MSSQL
  end;
  Result := FConnectionParams;
end;

function TuDataBase.GetParams: TStrings;
//ergibt die (User/Login-) Parameter
begin
  Result := FParams;
end;

function TuDataBase.GetStartConnect: Boolean;
begin
  Result := Options.KeepDesignConnected;
end;

procedure TuDataBase.SetStartConnect(const Value: Boolean);
begin
  Options.KeepDesignConnected := Value;
end;

function TuDataBase.UDecryptFromHex(const Value: string): string;
begin
//13.08.14  Result := DecryptFromHex(Value);
Result := Value;
end;

function TuDataBase.IsMSSQL: Boolean;
begin
  Result := CompareText(Providername, 'SQL Server') = 0;

end;

function TuDataBase.IsSqlBased: Boolean;
begin
  Result := true;
end;

procedure TuDataBase.SetParams(const Value: TStrings);
// Params to UniConnection
// 02.11.11 Params können unvollständig sein (wie BDE)
{ Password gecrypted in Params verwalten }
begin
  FParams.Assign(Value);
end;

procedure TuDataBase.ParamsChange(Sender: TObject);
//kopiert vorhandene Params nach Connection
begin
  if not(csLoading in ComponentState) and not FInGetParams then
  begin
    MergeConnectionParams(FParams);
  end;
end;

procedure TuDataBase.AliasToConnection(AAliasName: string);
// kopiert die Params von Aliasname nach Connection.
// Nur wenn AAliasName auch Parameter hat (bzw. existiert)
var
  AParams: TStringList;
begin
  AParams := TStringList.Create;
  try
    USession.GetAliasParams(AAliasName, AParams);
    if AParams.Count > 0 then
      SetConnectionParams(AParams);
  finally
    AParams.Free;
  end;
end;

procedure TuDataBase.SetConnectionParams(AParams: TStrings);
// füllt die darunterliegende UniConnection vollständig mit den Params Werten
// Achtung: wenn AParams leer dann werden auch die Connection-Einträge entfernt.
  procedure SetConnectionParamsInternal;
  var
    L: TStringList;
    I: Integer;
  begin
    L := nil;
    // Uni:
    ProviderName := AParams.Values['ProviderName'];
    Port := StrToIntTol(AParams.Values['Port']); // 0 wenn fehlt
    // BDE
    PassWord := String(DecryptPassw(AnsiString(AParams.Values['PASSWORD'])));
    Username := AParams.Values['USER NAME'];
    Server := AParams.Values['SERVER NAME'];
    Database := AParams.Values['DATABASE NAME']; // MSSQL
    { SpecificOptions der Connection setzen (und nicht die Info-Felder) }
    try
      L := TStringList.Create;
      L.Assign(AParams);
      L.Values['PASSWORD'] := '';
      L.Values['USER NAME'] := '';
      L.Values['DATABASE NAME'] := '';
      // Uni:
      L.Values['Port'] := '';
      L.Values['ProviderName'] := '';
      for I := L.Count - 1 downto 0 do
        if BeginsWith(L[I], ';') then  // ; ist Kommentar
          L.Delete(I);
      SpecificOptions.Assign(L);
    finally
      L.Free;
    end;
  end;
begin { SetConnectionParams }
  Disconnect;
  try
    SetConnectionParamsInternal;
  except
    if Connected then
    begin
      Disconnect;
      SetConnectionParamsInternal;
    end;
  end;
end;

procedure TuDataBase.MergeConnectionParams(AParams: TStrings);
//ergänzt Connection mit AParams
//fehlende AParams-Parameter haben keinen Einfluss.
  procedure MergeConnectionParamsInternal;
  var
    L: TStringList;
    I: integer;
  begin
    L := nil;
    // Uni:
    if AParams.Values['ProviderName'] <> ''  then ProviderName := AParams.Values['ProviderName'];
    if AParams.Values['Port'] <> ''          then Port := StrToIntTol(AParams.Values['Port']); // 0 wenn fehlt
    // BDE
    if AParams.Values['PASSWORD'] <> ''      then PassWord := String(DecryptPassw(AnsiString(AParams.Values['PASSWORD'])));
    if AParams.Values['USER NAME'] <> ''     then Username := AParams.Values['USER NAME'];
    if AParams.Values['SERVER NAME'] <> ''   then Server := AParams.Values['SERVER NAME'];
    if AParams.Values['DATABASE NAME'] <> '' then Database := AParams.Values['DATABASE NAME']; // MSSQL
    { SpecificOptions der Connection setzen (und nicht die Info-Felder) }
    try
      L := TStringList.Create;
      L.Assign(AParams);
      L.Values['PASSWORD'] := '';
      L.Values['USER NAME'] := '';
      L.Values['DATABASE NAME'] := '';
      // Uni:
      L.Values['Port'] := '';
      L.Values['ProviderName'] := '';
      //Merge:
      for I := 0 to L.Count - 1 do
        if not BeginsWith(L[I], ';') then  // ; ist Kommentar
          if SpecificOptions.Values[StrParam(L[I])] <> StrValue(L[I]) then
            SpecificOptions.Values[StrParam(L[I])] := StrValue(L[I]);
    finally
      L.Free;
    end;
  end;
begin { MergeConnectionParams }
  Disconnect;
  try
    MergeConnectionParamsInternal;
  except
    if Connected then
    begin
      Disconnect;
      MergeConnectionParamsInternal;
    end;
  end;
end;

procedure TuDataBase.DoConnect;
var
  S1: string;
begin
  if SysParam.NoDB then
    Exit;
  if not(csDesigning in ComponentState) then
  begin
    if LoginPrompt then
    begin
      if Assigned(FOnLogin) then
      begin
        FOnLogin(self, FParams); // kann Params ändern - 10.06.11
        { TODO : Params nach SpecificOptions und Username/Servername usw }
      end;
    end;
  end;

  {Idee: kein Reconnect bei Fehler:
  if ConnectError then EError(ConnectErrorStr)
  try
    inherited;
  except on E:Exception do begin
      ConnectError := true;
      ConnectErrorStr := E.Message;
      Raise;
    end;
  end;
  }

  inherited;

  if not(csDesigning in ComponentState) then
  begin
    if Connected then
    begin
      ExecConnectSql;
    end;
  end;
  //von GNav - 24.03.12
  if CompareText(ProviderName, 'Oracle') = 0 then
  try
    SysParam.DbSqlDatum := '''DD.MM.YYYY''';  // Y2000 Format in Session bekanntgeben:
    S1 := Format('ALTER SESSION SET NLS_DATE_FORMAT = %s', [SysParam.DbSqlDatum]);
    ExecSQL(S1, [0]);
    //Test Multibyte:
    //AQuery.Sql.Text := Format('ALTER SESSION SET NLS_CHARACTERSET = %s', ['UTF8']); AQuery.//ExecSql;
    //AQuery.Sql.Text := Format('ALTER SESSION SET NLS_LENGTH_SEMANTICS = %s', ['BYTE']); AQuery.//ExecSql;
    // Test Berechtigungen für Metadaten: weg wg UniDAC
  except on E:Exception do
    ErrWarn('Fehler bei "%s"'+CRLF+'%s',[S1, E.Message]);
  end;
end;

procedure TuDataBase.SetConnectSql(const Value: TStrings);
begin
  if (Value <> nil) and (Value <> FConnectSql) then
    FConnectSql.Assign(Value);
end;

procedure TuDataBase.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

procedure TuDataBase.SetSQLHourGlass(const Value: Boolean);
begin
  FSQLHourGlass := Value;
end;

end.
