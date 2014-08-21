unit UQue_Kmp;
(* TUniQuery modifiziert:
   Wrapper für TuQuery


Letzte Änderung:
06.06.11 md  Erstellen
             Databasename
             RequestLive!
10.06.11 md  SessionName (ohne Logik, für Kompatibilität)
14.06.11 md  MasterSource (war BDE DataSource)
03.11.11 md  Connection anhand DatabaseName vor dem Öffnen nachladen wenn fehlt
26.04.13 md  IsSequenced, anhand QueryRecCount (von MuGrid gesetzt)
26.04.13 md  DoFetchAll (für nl.RecordCount u.a.)
29.04.13 md  DoGetRecCount (für count* aus)

Anmerkungen:
- DataSource wird vom Wizard nach Mastersource umgesetzt.

*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, DB,  Uni, DBAccess, MemDS,
  MemUtils, UDB__Kmp, UDatasetIF, CRTypes;

type
  TuQuery = class(TUniQuery, IUDataset)
  private
    { Private-Deklarationen }
    FDatabaseName: string;
    FSessionName: string;
    FUpdateMode: TUpdateMode;
    function GetRequestLive: boolean;
    procedure SetRequestLive(const Value: boolean);
  protected
    { Protected-Deklarationen }
    procedure Loaded; override;
    function GetFinalSQL: string; override;  //für property Text
    procedure DoBeforeOpen; override;
    procedure DoBeforeExecute; override;
    function GetDatabaseName: string;
    procedure SetDatabaseName(const Value: string);
    function GetDataBase: TuDataBase;
    procedure SetDataBase(const Value: TuDataBase);
    function GetSessionName: string;
    procedure SetSessionName(const Value: string);
    function GetTag: Integer;
    function GetComponent: TObject;
    procedure AssignConnection(Value: TUniConnection);
    property Connection;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    procedure Prepare; override;
    function IsSequenced: boolean; override;
    procedure DoFetchAll;
    function DoGetRecCount: integer;
    function SQLGetWhere(SQLText: _string): _string; override;
    property Text: string read GetFinalSQL;
    property ReadOnly;  //Durch (not Requestlive) ersetzt wg Kompat. Sichtbarkeit von published heruntersetzen.
    property DataBase: TuDataBase read GetDataBase write SetDataBase;  //entspricht Connection as TuDatabase
    property FetchAll;  //hier public wg nl.Recordcount
  published
    { Published-Deklarationen }
    property DatabaseName: string read GetDatabaseName write SetDatabaseName;
    property SessionName: string read GetSessionName write SetSessionName;
    property RequestLive: boolean read GetRequestLive write SetRequestLive;  //entspricht not Readonly
    property UpdateMode: TUpdateMode read FUpdateMode write FUpdateMode default upWhereKeyOnly;  //nicht verwendet in UNI. Nur wg Kompat.
  end;

implementation

uses
  Prots, Err__Kmp, GNav_Kmp, FldDsKmp,
  USes_Kmp;

{ TuQuery }

procedure TuQuery.AssignConnection(Value: TUniConnection);
var
  FetchallValue: string;
begin
  Connection := Value;

  //Änderung Default Verhalten:
  if not (csDesigning in ComponentState) and
     (Connection <> nil) and (Connection.ProviderName <> '') then
  begin
    FetchallValue := SpecificOptions.Values['FetchAll'];
    //07.03.13 unten SpecificOptions.Values['FetchAll'] := 'False';
    //bringt nix SpecificOptions.Values['CursorUpdate'] := 'False';  //SQL verwenden
    //08.03.13: wenn '' dann Standard pro DB (MSSQL=True; Oracle=False)
    FetchallValue := Sysparam.FetchAll;

    if (Connection is TuDataBase) and
       (Pos('SET NOCOUNT ON', TuDataBase(Connection).ConnectSql.Text) > 0) then
    begin  //Spezial Webab&DPE
      FetchallValue := 'False';

      Options.StrictUpdate := false;  //Rowcount nach Update kann 0 sein: MSSQL
      //test SysParam.StrictUpdate
    end else
    begin
      Debug0;
    end;
    if SpecificOptions.Values['FetchAll'] <> FetchallValue then;
      SpecificOptions.Values['FetchAll'] := FetchallValue;
  end;
end;

constructor TuQuery.Create(AOwner: TComponent);
begin
  inherited;
  //nein FSessionName := 'Default';
  FDatabaseName := 'DB1';  //wird vom Wizard entfernt 16.10.11

  if AOwner is TUniConnection then
    AssignConnection(TUniConnection(AOwner));

  //Änderung Default Verhalten:
  Options.RequiredFields := false;  //Trigger erzeugen not null ID
end;

procedure TuQuery.DoBeforeExecute;
begin
  if (Connection = nil) and (DatabaseName <> '') then
    AssignConnection(USession.FindDatabase(DatabaseName));
  inherited;
end;

procedure TuQuery.DoBeforeOpen;
// ergänzt fehlende Connection anhand Databasename
begin
  if (Connection = nil) and (DatabaseName <> '') then
    AssignConnection(USession.FindDatabase(DatabaseName));
  inherited;
end;

procedure TuQuery.Prepare;
begin
  if (Connection = nil) and (DatabaseName <> '') then
    AssignConnection(USession.FindDatabase(DatabaseName));
  inherited;
end;

function TuQuery.GetDataBase: TuDataBase;
begin
  //UniConnection anhand DatabaseName setzen
  if (Connection = nil) and (DatabaseName <> '') then
    AssignConnection(USession.FindDatabase(DatabaseName));  //kein else!
  if Connection is TuDataBase then
    Result := TuDataBase(Connection) else
    Result := nil;
end;

procedure TuQuery.SetDataBase(const Value: TuDataBase);
begin
  AssignConnection(Value);
end;

function TuQuery.GetDatabaseName: string;
begin
  Result := FDatabaseName;  //for debug reasons
end;

procedure TuQuery.SetDatabaseName(const Value: string);
begin
  FDatabaseName := Value;
  //weg wg strictupdate - 27.12.11 - if not (csLoading in ComponentState) then
    AssignConnection(USession.FindDatabase(Value));
end;

procedure TuQuery.Loaded;
begin
  inherited;
  { Databasename, Database }
  if (DatabaseName <> '') and (Connection = nil) then
    AssignConnection(USession.FindDatabase(DatabaseName));
end;

function TuQuery.GetFinalSQL: string;
begin
  Result := inherited GetFinalSQL;
end;

function TuQuery.GetRequestLive: boolean;
begin
  Result := not ReadOnly;
end;

function TuQuery.GetComponent: TObject;
begin
  Result := self;
end;

function TuQuery.GetTag: Integer;
begin
  Result := self.Tag;
end;

procedure TuQuery.SetRequestLive(const Value: boolean);
begin
  ReadOnly := not Value;
end;

function TuQuery.GetSessionName: string;
begin
  Result := FSessionName;
end;

procedure TuQuery.SetSessionName(const Value: string);
begin
  FSessionName := Value;
end;

function TuQuery.SQLGetWhere(SQLText: _string): _string;
begin
  Result := inherited SQLGetWhere(SQLText);
end;

procedure TuQuery.DoFetchAll;
//Lädt alle Records unabhängig von anderen Einstellungen
//Verwendung: AfterPost (QUVAE.SiebDispo.Query1)
begin
  if not FetchAll then
  try
    FetchAll := true;
    //lädt jetzt alle Records
  finally
    FetchAll := false;
  end;
end;

type
  TDummyDADataSetService = class(TDADataSetService);

function TuQuery.DoGetRecCount: integer;
//SQL manuell erzeugen. Obwohl QueryRecCount nicht gesetzt ist.
//14.03.14 not active
begin
  if not Options.QueryRecCount then
  begin
    Result := TDummyDADataSetService(FDataSetService).GetRecCount;
  end else
    Result := RecordCount;
end;

function TuQuery.IsSequenced: boolean;
begin
  Result := Options.QueryRecCount;
end;

end.
