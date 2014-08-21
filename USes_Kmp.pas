unit USes_Kmp;
(* Session: Verwaltung der Connections
   Globale Variable: USession
   Letzte Änderung:
   06.06.11 md  Erstellen
                DatabaseList/AliasList
   13.06.11 md  DatabaseList in Session integriert
                Session als Component
   15.10.11 md  Aliase sind keine Databases. Sie haben nur AliasParams.
                Sie werden extern verwaltet (INI, Registry)
                oder dynamisch erzeugt: TNSNAMES: Aliasname=Ora-Aliasname
                und über einen Aliasmanager erfasst
                Die AliasParams werden in die Params der UDatabase kopiert

---
- Ein Aliase enthält Konfigurationsdaten für eine Database (nur TStrings)
- Eine Database kann anhand eines Alias konfiguriert werden (siehe dort)
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  MemUtils, UDB__Kmp, UAli_Kmp, CRTypes;

type
  TuSession = class(TComponent)
  private
    { Private-Deklarationen }
    FDatabaseList: TThreadList;
    FAliasList: TuAliasList;  //15.10.11
    FSessionName: string;
    FAliasFilename: string;
    procedure SetSessionName(const Value: string);
    function GetDatabaseCount: integer;
    function GetDatabases(Index: Integer): TuDatabase;
    function GetDatabaseByName(const DatabaseName: string): TuDatabase;
    //15.10.11 function GetDatabaseByAlias(const AliasName: string): TuDatabase;
    procedure InternalAddDataBase(DataBase: TuDataBase);  //10.06.11
    procedure InternalRemoveDataBase(DataBase: TuDataBase);
    function GetAliasList: TuAliasList;
    procedure SetAliasList(const Value: TuAliasList);
    procedure SetAliasFilename(const Value: string);
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GetDatabaseNames(List: TStrings);
    procedure CheckAlias(const AliasName: String);
    procedure GetAliasParams(const AliasName: String; List: TStrings);
    function FindDataBase(DatabaseName: string): TuDataBase;
    //15.10.11function FindAlias(AliasName: string): TuDataBase;
    procedure GetTableNames(DatabaseName: string; List: TStrings;
      AllTables: boolean = False);
    procedure GetAliasNames(List: TStrings);  //10.06.11

    class procedure AddDataBase(SessionName: string; DataBase: TuDataBase);
    class procedure RemoveDataBase(SessionName: string; DataBase: TuDataBase);

    property DatabaseCount: integer read GetDatabaseCount;
    property Databases[Index: Integer]: TuDatabase read GetDatabases; default;
    property List[const DatabaseName: string]: TuDatabase read GetDatabaseByName;
    //15.10.11 property AlasList[const AliasName: string]: TuDatabase read GetDatabaseByAlias;
    property AliasList: TuAliasList read GetAliasList write SetAliasList;
    property AliasFilename: string read FAliasFilename write SetAliasFilename;
  published
    { Published-Deklarationen - nicht bei TObject }
    property SessionName: string read FSessionName write SetSessionName;
  end;

function USession: TuSession;

implementation

uses
  bdeconst,
  Prots, Err__Kmp, GNav_Kmp, KmpResString;

var
  FUSession: TuSession;
  SessionCounter: integer;

function USession: TuSession;
begin
  if FUSession = nil then
  begin
    FUSession := TuSession.Create(nil);  //es gibt momentan nur eine Session
    FUSession.SessionName := 'Default';
  end;
  Result := FUSession;
end;

{ TuSession }

constructor TuSession.Create(AOwner: TComponent);
begin
  inherited;
  FSessionName := 'SESSION' + IntToStr(SessionCounter);
  Inc(SessionCounter);  //falls es doch mal mehrer Sessions gibt
  FDatabaseList := TThreadList.Create;
  FDatabaseList.Duplicates := dupIgnore;
  //immer  if {(csDesigning in Componentstate) and test} (FAliasFilename = '') then
  //beware FAliasFilename := AllUsersDir + 'UniDAC\Unidac.ini';
end;

destructor TuSession.Destroy;
begin
  FreeAndNil(FDatabaseList);
  FreeAndNil(FAliasList);
  inherited;
end;

procedure TuSession.InternalAddDataBase(DataBase: TuDataBase);
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    List.Add(Database);  //dupIgnore
  finally
    FDatabaseList.UnlockList;
  end;
end;

procedure TuSession.InternalRemoveDataBase(DataBase: TuDataBase);
var
  List: TList;
begin
  List := FDatabaseList.LockList;
  try
    if List.IndexOf(DataBase) >= 0 then
      List.Remove(Database);
  finally
    FDatabaseList.UnlockList;
  end;
end;

function TuSession.GetAliasList: TuAliasList;
var
  L: TStringList;
  I: Integer;
  ALine: string;
begin
  L := nil;
  if FAliasList = nil then
  begin
    FAliasList := TuAliasList.Create;

    if FAliasFilename = '' then
    begin
      if csDesigning in ComponentState then
      begin
        FAliasFilename := AllUsersDir + 'UniDAC\Unidac.ini';
      end else
      try
        L := TStringList.Create;
        for I:= 1 to ParamCount do      {Aufrufparameter i.d.Form Uni=<Pfad+Name der INI>}
        begin
          ALine := ParamStr(I);
          if CompareText(StrParam(ALine), 'Uni') = 0 then
          begin
            if StrValue(ALine) <> '' then
              L.Add(StrValue(ALine));
            Break;
          end;
        end;
        if GetEnvStr('Uni') <> '' then
          L.Add(GetEnvStr('Uni'));
        L.Add(AppDir + 'Unidac.ini');
        L.Add(AllUsersDir + 'UniDAC\Unidac.ini');

        for I := 0 to L.Count - 1 do
          if FileExists(L[I]) then
          begin
            FAliasFilename := L[I];
            Break;
          end;
        if FAliasFilename <> '' then
        begin
          FAliasList.LoadFromFile(FAliasFilename);
        end else
        begin
          EError('Aliasdatei fehlt'+CRLF+'%s', [L.Text]);
        end;
      finally
        L.Free;
      end;
    end;
  end;
  Result := FAliasList;
end;

procedure TuSession.SetAliasFilename(const Value: string);
begin
  if FAliasFilename <> Value then
  begin
    FAliasFilename := Value;
    if FAliasList <> nil then  //ansonsten siehe GetAliasList
      AliasList.LoadFromFile(FAliasFilename);
  end;
end;

procedure TuSession.SetAliasList(const Value: TuAliasList);
begin
  FAliasList := Value;
end;

procedure TuSession.GetAliasNames(List: TStrings);
begin
  if List = nil then
    Exit;
  List.Clear;
  AliasList.GetAliasNames(List);
end;

procedure TuSession.GetAliasParams(const AliasName: String; List: TStrings);
var
  Alias: TuAlias;
begin
  Alias := AliasList.FindAlias(AliasName);
  if Alias <> nil then
    List.Assign(Alias.Params);
end;

procedure TuSession.CheckAlias(const AliasName: String);
begin
  if AliasList.FindAlias(AliasName) = nil then
    EError(SUSes_001, [AliasName]);  //'unbekannter Alias "%s"'
end;

function TuSession.GetDatabaseCount: integer;
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

function TuSession.GetDatabases(Index: Integer): TuDatabase;
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

procedure TuSession.GetTableNames(DatabaseName: string; List: TStrings;
  AllTables: boolean = False);
var
  Database: TuDatabase;
begin
  List.Clear;
  Database := FindDatabase(DatabaseName);
  if Database <> nil then
  begin
    //BDE: Database.GetTableNames(Pattern, Extensions, SystemTables, List);
    Database.GetTableNames(List, AllTables);
  end;
end;

function TuSession.GetDatabaseByName(const DatabaseName: string): TuDatabase;
begin
  Result := FindDatabase(DatabaseName);
  if Result = nil then  //DatabaseErrorFmt(SInvalidSessionName, [DatabaseName]);
    Prot0('WARN InvalidDatabasename TuSession.GetDatabaseByName(%s)', [DatabaseName]);
end;

function TuSession.FindDataBase(DatabaseName: string): TuDataBase;
// Ergibt UniConnection anhand DatabaseName. Nil wenn fehlt / nicht geladen.
var
  I: Integer;
  List: TList;
begin
  Result := nil;
  List := FDatabaseList.LockList;
  try
    for I := 0 to List.Count - 1 do
    begin
      if AnsiCompareText(TuDataBase(List[I]).DatabaseName, DatabaseName) = 0 then
      begin
        Result := List[I];
        Break;
      end;
    end;
  finally
    FDatabaseList.UnlockList;
  end;
end;

procedure TuSession.GetDatabaseNames(List: TStrings);
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
        List.Add(TuDatabase(SList[I]).DatabaseName);
    finally
      FDatabaseList.UnlockList;
    end;
  finally
    List.EndUpdate;
  end;
end;

class procedure TuSession.AddDataBase(SessionName: string;
  DataBase: TuDataBase);
begin
{ TODO : SessionList }
  if (FUSession = nil) or not (csDestroying in FUSession.ComponentState) then
    USession.InternalAddDataBase(DataBase);
end;

class procedure TuSession.RemoveDataBase(SessionName: string;
  DataBase: TuDataBase);
begin
{ TODO : SessionList }
  if (FUSession = nil) or not (csDestroying in FUSession.ComponentState) then
    USession.InternalRemoveDataBase(DataBase);
end;

procedure TuSession.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

initialization

finalization
  FreeAndNil(FUSession);
end.
