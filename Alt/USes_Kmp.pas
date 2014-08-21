unit USes_Kmp;
(* Session: Verwaltung der Connections
   Letzte Änderung:
   06.06.11 md  Erstellen
                todo DatabaseList/AliasList


---
- Ein Alias kann mehreren Databases zugeordnet sein
- Ein Alias enthält alle Konfigurationsdaten für eine Database
- Ein Alias hat keinen DatabaseName
- Eine Database kann anhand eines Alias angelegt und connected werden
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  UDB__Kmp;

type
  TuDatabaseList = class(TObject)
  private
    FDatabaseList: TThreadList;
    function GetCount: Integer;
    function GetDatabase(Index: Integer): TuDatabase;
    function GetDatabaseByName(const DatabaseName: string): TuDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    function FindDatabase(const DatabaseName: string): TuDatabase;
    procedure GetDatabaseNames(List: TStrings);
    procedure AddDatabase(ADatabase: TuDatabase);
    procedure RemoveDatabase(ADatabase: TuDatabase);
    property Count: Integer read GetCount;
    property DatabaseList[Index: Integer]: TuDatabase read GetDatabase; default;
    property List[const DatabaseName: string]: TuDatabase read GetDatabaseByName;
  end;

type
  TuSession = class(TObject)
  private
    FSessionName: string;
    FDatabaseList: TuDatabaseList;
    procedure SetSessionName(const Value: string);
    function GetDatabaseList: TuDatabaseList;
    function GetDatabaseCount: integer;
    function GetDatabases(Index: Integer): TuDatabase;
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(aSessionName: string);
    procedure GetAliasParams(const AliasName: String; List: TStrings);
    procedure AddDataBase(aDataBase: TuDataBase);  //10.06.11
    procedure RemoveDataBase(aDataBase: TuDataBase);  //10.06.11
    function FindDataBase(aDatabaseName: string): TuDataBase;
    property SessionName: string read FSessionName write SetSessionName;
    property DatabaseList: TuDatabaseList read GetDatabaseList;
    property DatabaseCount: integer read GetDatabaseCount;
    property Databases[Index: Integer]: TuDatabase read GetDatabases; default;
  published
    { Published-Deklarationen - nicht bei TObject }
  end;

function Session: TuSession;

implementation

uses
  bdeconst,
  Prots, Err__Kmp, GNav_Kmp;

var
  FSession: TuSession;

function Session: TuSession;
begin
  if FSession = nil then
  begin
    FSession := TuSession.Create('SESSION');  //es gibt momentan nur eine Session
    FSession := TuSession.Create('SESSION');  //es gibt momentan nur eine Session
  end;
  Result := FSession;
end;

{ TuSession }

constructor TuSession.Create(aSessionName: string);
begin
  FSessionName := aSessionName;
end;

procedure TuSession.AddDataBase(aDataBase: TuDataBase);
begin
  DatabaseList.AddDatabase(aDataBase);
end;

procedure TuSession.RemoveDataBase(aDataBase: TuDataBase);
begin
  DatabaseList.RemoveDatabase(aDataBase);
end;

function TuSession.FindDataBase(aDatabaseName: string): TuDataBase;
begin
  Result := nil;
  { TODO : Find DataBase }
end;

procedure TuSession.GetAliasParams(const AliasName: String; List: TStrings);
begin
  { TODO :
SpecificOptions der Connection zurückgeben
USERNAME und PASSWORD und SERVER NAME müssen Felder zugeordnet werden }

  { TODO :
von DatabaseList die Params zurückgeben
Wenn Alias unbekannt dann Exception  }

//var
//  SAlias: DBIName;
//  Desc: DBDesc;
//begin
//  List.BeginUpdate;
//  try
//    List.Clear;
//    StrPLCopy(SAlias, AnsiString(AliasName), SizeOf(SAlias) - 1);
//    CharToOEMA(SAlias, SAlias);
//    LockSession;
//    try
//      Check(DbiGetDatabaseDesc(SAlias, @Desc));
//    finally
//      UnlockSession;
//    end;
//    if Desc.szDBType[sizeOf(Desc.szDBType) - 1] <> #0 then
//      Desc.szDBType[sizeOf(Desc.szDBType) - 1] := #0;
//    if StrIComp(Desc.szDbType, szCFGDBSTANDARD) = 0 then
//    begin
//      GetConfigParams('\DATABASES\%s\DB INFO', string(SAlias), List);
//      List.Values[szCFGDBTYPE] := '';
//    end
//    else
//      GetConfigParams('\DATABASES\%s\DB OPEN', string(SAlias), List);
//  finally
//    List.EndUpdate;
//  end;
end;

function TuSession.GetDatabaseCount: integer;
begin
  Result := DatabaseList.Count;
end;

function TuSession.GetDatabaseList: TuDatabaseList;
begin
  if FDatabaseList = nil then
  begin
    FDatabaseList := TuDatabaseList.Create;
  end;
  Result := FDatabaseList;
end;

function TuSession.GetDatabases(Index: Integer): TuDatabase;
begin
  Result := DatabaseList.DatabaseList[Index];
end;

procedure TuSession.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

{ TuDatabaseList }

constructor TuDatabaseList.Create;
begin
  inherited Create;
  FDatabaseList := TThreadList.Create;
end;

destructor TuDatabaseList.Destroy;
begin
  FDatabaseList.Free;
  inherited Destroy;
end;

procedure TuDatabaseList.AddDatabase(ADatabase: TuDatabase);
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    List.Add(ADatabase);
  finally
    FDatabaseList.UnlockList;
  end;
end;

procedure TuDatabaseList.RemoveDatabase(ADatabase: TuDatabase);
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    List.Remove(ADatabase);
  finally
    FDatabaseList.UnlockList;
  end;
end;

function TuDatabaseList.GetCount: Integer;
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    Result := List.Count;
  finally
    FDatabaseList.UnlockList;
  end;
end;

function TuDatabaseList.GetDatabase(Index: Integer): TuDatabase;
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    Result := TuDatabase(List[Index]);
  finally
    FDatabaseList.UnlockList;
  end;
end;

function TuDatabaseList.GetDatabaseByName(const DatabaseName: string): TuDatabase;
begin
  Result := FindDatabase(DatabaseName);
  if Result = nil then
    DatabaseErrorFmt(SInvalidSessionName, [DatabaseName]);
end;

function TuDatabaseList.FindDatabase(const DatabaseName: string): TuDatabase;
var
  I: Integer;
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    for I := 0 to List.Count - 1 do
    begin
      Result := List[I];
      if AnsiCompareText(Result.DatabaseName, DatabaseName) = 0 then Exit;
    end;
    Result := nil;
  finally
    FDatabaseList.UnlockList;
  end;
end;

procedure TuDatabaseList.GetDatabaseNames(List: TStrings);
var
  I: Integer;
  SList: TList;
begin
  List.BeginUpdate;
  try
    List.Clear;
    SList := FDatabaseList.LockList;
    try
      for I := 0 to SList.Count - 1 do
        with TuDatabase(SList[I]) do
          List.Add(DatabaseName);
    finally
      FDatabaseList.UnlockList;
    end;
  finally
    List.EndUpdate;
  end;
end;


end.
