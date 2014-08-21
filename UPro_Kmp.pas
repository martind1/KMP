unit UPro_Kmp;
(* TUniProc modifiziert:

Letzte Änderung:
13.06.11 md  Erstellen
             DataBaseName
16.10.11 md  Beispiel für Verstecken von Connection
12.08.14 md  ParamByName weil UniDAV V5.3.10 KEINEN Parameter mehr findet
12.08.14     AssignFloat/Int/Date/Str (in Prots entfernt)
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  UDatasetIF, UDB__Kmp;

type
  TuStoredProc = class(TUniStoredProc, IUDataset)
  private
    { Private-Deklarationen }
    FDatabaseName: string;
    FSessionName: string;
    procedure SetDatabaseName(const Value: string);
    function GetDatabaseName: string;
    function GetDataBase: TuDataBase;
    procedure SetDataBase(const Value: TuDataBase);
    function GetSessionName: string;
    procedure SetSessionName(const Value: string);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    procedure DoBeforeExecute; override;
    function GetTag: Integer;
    function GetComponent: TObject;
    property Connection;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Prepare; override;
    function ParamByName(const Value: string): TUniParam;
    procedure AssignFloat(const AParamName, Value: string);
    procedure AssignInt(const AParamName, Value: string);
    procedure AssignDate(const AParamName, Value: string);
    procedure AssignStr(const AParamName, Value: string);

    property DataBase: TuDataBase read GetDataBase write SetDataBase;  //entspricht Connection as TuDatabase
  published
    { Published-Deklarationen }
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SessionName: string read GetSessionName write SetSessionName;
  end;

implementation

uses
  Data.DBConsts {SParamNotFound},
  USes_Kmp,
  Prots, Err__Kmp, GNav_Kmp, FldDsKmp;


{ TuStoredProc }

constructor TuStoredProc.Create(AOwner: TComponent);
begin
  inherited;
  //nein FSessionName := 'Default';
  FDatabaseName := 'DB1';  //wird vom Wizard entfernt 16.10.11
  if AOwner is TUniConnection then
    Connection := TUniConnection(AOwner);
end;

procedure TuStoredProc.DoBeforeExecute;
begin
  if (Connection = nil) and (DatabaseName <> '') then
    Connection := USession.FindDatabase(DatabaseName);
  inherited;
end;

procedure TuStoredProc.Loaded;
begin
  inherited;
  { Databasename, Database }
  if (DatabaseName <> '') and (Connection = nil) then
    Connection := USession.FindDatabase(DatabaseName);
end;

procedure TuStoredProc.Prepare;
begin
  if (Connection = nil) and (DatabaseName <> '') then
  begin
    Connection := USession.FindDatabase(DatabaseName);
  end;
  if Connection = nil then
    Debug0;
  inherited;
end;

function TuStoredProc.GetDatabaseName: string;
begin
  Result := FDatabaseName;
end;

procedure TuStoredProc.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
  if not (csLoading in ComponentState) then
    Connection := USession.FindDatabase(Value);
end;

function TuStoredProc.GetDataBase: TuDataBase;
begin
  //UniConnection anhand DatabaseName setzen
  if (Connection = nil) and (DatabaseName <> '') then
    Connection := USession.FindDatabase(DatabaseName);  //kein else!
  if Connection is TuDataBase then
    Result := TuDataBase(Connection) else
    Result := nil;
end;

procedure TuStoredProc.SetDataBase(const Value: TuDataBase);
begin
  Connection := Value;
end;

function TuStoredProc.GetSessionName: string;
begin
  Result := FSessionName;
end;

procedure TuStoredProc.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

function TuStoredProc.GetComponent: TObject;
begin
  Result := self;
end;

function TuStoredProc.GetTag: Integer;
begin
  Result := self.Tag;
end;

{ UniDAC Parameter Fehler }

function TuStoredProc.ParamByName(const Value: string): TUniParam;
  function StripAt(S: string): string;
  begin
    Result := StrCgeChar(S, '@', #0);
  end;
var
  I: integer;
begin
  Result := FindParam(Value);
  if Result = nil then
  begin
    Prot0('WARN proc:%s Param:%s nicht gefunden (%s)', [StoredProcName, Value, OwnerDotName(Self)]);
    for I := 0 to ParamCount - 1 do
    begin
      if SameText(StripAt(Params[I].Name), StripAt(Value)) then
      begin
        Result := Params[I];
        Break;
      end;
    end;
  end;
  if Result = nil then
    DatabaseErrorFmt(SParameterNotFound, [Value], Self);
end;

procedure TuStoredProc.AssignDate(const AParamName, Value: string);
begin
  try
    if Value = '' then
      ParamByName(AParamName).Clear else
      ParamByName(AParamName).AsDateTime := StrToDate(Value);
  except on E:Exception do
    EError('%s.AssignDate(%s=%s):%s', [OwnerDotName(Self), AParamName, Value, E.Message]);
  end;
end;

procedure TuStoredProc.AssignFloat(const AParamName, Value: string);
begin
  try
    if Value = '' then
      ParamByName(AParamName).Clear else
      ParamByName(AParamName).AsFloat := StrToFloat(Value);
  except on E:Exception do
    EError('%s.AssignFloat(%s=%s):%s', [OwnerDotName(Self), AParamName, Value, E.Message]);
  end;
end;

procedure TuStoredProc.AssignInt(const AParamName, Value: string);
begin
  try
    if Value = '' then
      ParamByName(AParamName).Clear else
      ParamByName(AParamName).AsInteger := StrToInt(Value);
  except on E:Exception do
    EError('%s.AssignInt(%s=%s):%s', [OwnerDotName(Self), AParamName, Value, E.Message]);
  end;
end;

procedure TuStoredProc.AssignStr(const AParamName, Value: string);
begin
  try
    if Value = '' then
      ParamByName(AParamName).Clear else
      ParamByName(AParamName).AsString := Value;
  except on E:Exception do
    EError('%s.AssignStr(%s=%s):%s', [OwnerDotName(Self), AParamName, Value, E.Message]);
  end;
end;

end.
