unit UAli_Kmp;
(* Alias - Parameter einer Connection.
   Liste der Aliase für UniAdmin.

Letzte Änderung:
08.06.11 md  Erstellen
             todo UniAdmin
15.10.11 md  Skeleton für LoadFrom*

---
- Params: mit Provider TYP

- für Admin sind noch Save-Funktionen vorzusehen
  saveToRegistry(); saveToFile();

*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS;

type
  TuAlias = class(TObject)
  private
    FAliasName: string;
    FParams: TStrings;
    procedure SetAliasName(const Value: string);
    procedure SetParams(const Value: TStrings);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create;
    destructor Destroy; override;

    property AliasName: string read FAliasName write SetAliasName;
    property Params: TStrings read FParams write SetParams;
  end;

  TuAliasList = class(TObject)
  private
    FAliasList: TThreadList;
    function GetCount: Integer;
    function GetAlias(Index: Integer): TuAlias;
    function GetAliasByName(const AliasName: string): TuAlias;
  public
    constructor Create;
    destructor Destroy; override;

    // Alias Management:
    procedure AddAlias(AAlias: TuAlias);
    procedure ClearList;
    procedure LoadFromFile(Filename: string);
    procedure LoadFromRegistry(RegKey: string);
    procedure LoadFromTnsNames(Filename: string);

    function FindAlias(const AliasName: string): TuAlias;
    procedure GetAliasNames(List: TStrings);
    property Count: Integer read GetCount;
    property AliasList[Index: Integer]: TuAlias read GetAlias; default;
    property List[const AliasName: string]: TuAlias read GetAliasByName;
  end;

implementation

uses
  bdeconst {SInvalidSessionName},
  IniFiles,
  Prots, Err__Kmp, GNav_Kmp, DPos_Kmp;

{ TuAlias }

constructor TuAlias.Create;
begin
  FParams := TValueList.Create;
end;

destructor TuAlias.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

procedure TuAlias.SetAliasName(const Value: string);
begin
  FAliasName := Value;
end;

procedure TuAlias.SetParams(const Value: TStrings);
begin
  FParams.Assign(Value);
end;

{ TuAliasList }

constructor TuAliasList.Create;
begin
  inherited Create;
  FAliasList := TThreadList.Create;
  FAliasList.Duplicates := dupIgnore;
end;

destructor TuAliasList.Destroy;
var
  I: integer;
  List: TList;
begin
  try
    List := FAliasList.LockList;
    try
      for I := 0 to List.Count - 1 do
      try
        TuAlias(List[I]).Free;
      except
      end;
    finally
      FAliasList.UnlockList;
    end;
  except  //immer weiter
  end;
  FAliasList.Free;
  inherited Destroy;
end;

procedure TuAliasList.AddAlias(AAlias: TuAlias);
var
  List: TList;
begin
  List := FAliasList.LockList;
  try
    List.Add(AAlias);
  finally
    FAliasList.UnlockList;
  end;
end;

function TuAliasList.GetCount: Integer;
var
  List: TList;
begin
  List := FAliasList.LockList;
  try
    Result := List.Count;
  finally
    FAliasList.UnlockList;
  end;
end;

procedure TuAliasList.ClearList;
// Entfernt alle Aliase. Gibt Speicherplatz frei.
var
  List: TList;
  I: integer;
begin
  List := FAliasList.LockList;
  try
    for I := 0 to List.Count - 1 do
      TuAlias(List[I]).Free;
    List.Clear;
  finally
    FAliasList.UnlockList;
  end;
end;

procedure TuAliasList.LoadFromFile(Filename: string);
{ von .ini Datei übernehmen. Löscht Vorher AliasListe }
var
  MemIniFile: TMemIniFile;
  Alias: TuAlias;
  AliasNames: TStrings;
  I: integer;
begin
  // vergl UniAdmin
  ClearList;
  AliasNames := TStringList.Create;
  MemIniFile := TMemIniFile.Create(Filename);
  try
    MemIniFile.ReadSections(AliasNames);
    for I := 0 to AliasNames.Count - 1 do
    begin
      Alias := TuAlias.Create;
      Alias.AliasName := AliasNames[I];
      MemIniFile.ReadSectionValues(AliasNames[I], Alias.FParams);
      AddAlias(Alias);
    end;
  finally
    MemIniFile.Free;
    AliasNames.Free;
  end;
end;

procedure TuAliasList.LoadFromRegistry(RegKey: string);
begin
{ TODO : vom UniDialog übernehmen }
end;

procedure TuAliasList.LoadFromTnsNames(Filename: string);
begin
{ TODO : von tnsnames.ora übernehmen }
end;

function TuAliasList.GetAlias(Index: Integer): TuAlias;
var
  List: TList;
begin
  List := FAliasList.LockList;
  try
    Result := TuAlias(List[Index]);
  finally
    FAliasList.UnlockList;
  end;
end;

function TuAliasList.GetAliasByName(const AliasName: string): TuAlias;
begin
  Result := FindAlias(AliasName);
  if Result = nil then
    DatabaseErrorFmt(SInvalidSessionName, [AliasName]);
end;

function TuAliasList.FindAlias(const AliasName: string): TuAlias;
var
  I: Integer;
  List: TList;
  A: TuAlias;
begin
  Result := nil;
  List := FAliasList.LockList;
  try
    for I := 0 to List.Count - 1 do
    begin
      A := TuAlias(List[I]);
      if AnsiCompareText(A.AliasName, AliasName) = 0 then
      begin
        Result := A;
        Break;
      end;
    end;
  finally
    FAliasList.UnlockList;
  end;
end;

procedure TuAliasList.GetAliasNames(List: TStrings);
var
  I: Integer;
  SList: TList;
begin
  List.BeginUpdate;
  try
    List.Clear;
    SList := FAliasList.LockList;
    try
      for I := 0 to SList.Count - 1 do
        with TuAlias(SList[I]) do
          List.Add(AliasName);
    finally
      FAliasList.UnlockList;
    end;
  finally
    List.EndUpdate;
  end;
end;

end.
