unit DatnApp;
(* neue Version einer Anwendung von Dateiablage herunterladen und entpacken

15.11.13 md  erstellt
23.11.13 md  IsNewVersion für GNav.CheckVersion

Ohne Prots. Muss auch mit Apptype=Console laufen (QLoader).

*)

interface

uses
  Classes,
  UniProvider, SQLiteUniProvider, SQLServerUniProvider,
  PostgreSQLUniProvider, OracleUniProvider, MySQLUniProvider,
  InterBaseUniProvider, DB2UniProvider, ASEUniProvider, AdvantageUniProvider,
  ODBCUniProvider, AccessUniProvider,
  UDB__Kmp, UQue_Kmp;

type
  TProtCallback = procedure(S: string) of object;

type
  TDatnApp = class(TObject)
  private
    FApp: string;
    FExeName: string;
    FAlias: string;
    FUDatabase: TuDatabase;
    FTableName: string;
    FIniTableName: string;
    FPassword: string;
    FUsername: string;
    FBaseDir: string;
    FDatnVersion: string;
    FProtCallback: TProtCallback;
    FNewVersion: boolean;
    FAnwendung: string;
    FNoVersion: boolean;
    FVersionSL: TStringList;  //Inhalt der Version.txt
    procedure SetApp(const Value: string);
    procedure SetAlias(const Value: string);
    procedure SetTableName(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetUsername(const Value: string);
    function GetTableName: string;
    function GetBasedir: string;
    function GetUDatabase: TUDatabase;
    function GetIniTableName: string;
    procedure SetBaseDir(const Value: string);
    procedure CheckExename;
    function GetAliasFilename: string;
    function GetDatnVersion: string;
    function Ordner: string;
    procedure SetAnwendung(const Value: string);
    procedure SetIniTableName(const Value: string);
  protected
    property UDatabase: TUDatabase read GetUDatabase;
    procedure CallbackProt(const Fmt: string; const Args: array of const);
  public
    constructor Create; overload;
    constructor Create(BaseDir, App: string; UDatabase: TUDatabase); overload;
    destructor Destroy; override;
    procedure SyncApp;
    procedure SetAppFromFilename(Filename: string);
    function CheckNewVersion: boolean;
    function GetComment(Sprache: string): string;
    property App: string read FApp write SetApp;
    property Anwendung: string read FAnwendung write SetAnwendung;
    property Alias: string read FAlias write SetAlias;
    property BaseDir: string read GetBasedir write SetBaseDir;
    property ExeName: string read FExeName write FExename;
    property Username: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;
    property TableName: string read GetTableName write SetTableName;
    property IniTableName: string read GetIniTableName write SetIniTableName;
    property DatnVersion: string read GetDatnVersion;
    property AliasFilename: string read GetAliasFilename;
    property ProtCallback: TProtCallback read FProtCallback write FProtCallback;
    property IsNewVersion: boolean read FNewVersion;
    property IsNoVersion: boolean read FNoVersion;
  end;

function FileVersionStr(S: string): string;

implementation

uses
  SysUtils, DB, Zip,
  WinTools, USes_Kmp;

{ Utils }

function StrDflt(Src, Dflt: string): string;
begin
  if (Src = '') or (Src = #0) then
    Result := Dflt else
    Result := Src;
end;

function FileVersionStr(S: string): string;
//ergibt Version als String 0.0.0.0
var
  InternalName, Version: string;
begin
  GetFileInfo(InternalName, Version, S);
  Result := Version;
end;

procedure TDatnApp.CallbackProt(const Fmt: string; const Args: array of const);
begin
  if assigned(FProtCallback) then
    FProtCallback(Format(Fmt, Args));
end;


{ TDatnApp }

function TDatnApp.GetUDatabase: TUDatabase;
begin
  if FUDatabase = nil then
  begin
    FUDatabase := TuDatabase.Create(nil);
    FUDatabase.AliasName := FAlias;  //lädt session, unidac.ini
    FUDatabase.DatabaseName := 'DBDATNAPP';

    FUDatabase.Username := FUsername;
    FUDatabase.Password := FPassword;
  end;
  Result := FUDatabase;
end;

function TDatnApp.GetTableName: string;
begin
  Result := StrDflt(FTablename, 'DATN');
end;

function TDatnApp.GetIniTableName: string;
begin
  Result := StrDflt(FIniTablename, 'INITIALISIERUNGEN');
end;

procedure TDatnApp.SetAlias(const Value: string);
begin
  if Value = '' then
    Exit;
  if FAlias <> Value then
  begin
    if FUDatabase <> nil then
    begin
      FUDatabase.Close;
      FUDatabase.AliasName := Value;  //lädt session, unidac.ini
    end;
  end;
  FAlias := Value;
end;

procedure TDatnApp.SetAnwendung(const Value: string);
begin
  if Value = '' then
    Exit;
  FAnwendung := Value;
  //if SameText(FApp, 'QUVAE') or SameText(FApp, 'QSBT') then
  if SameText(Copy(FAnwendung, 1, 1), 'Q') or SameText(FAnwendung, 'SDBL') then
  begin
    FUsername := StrDflt(FUsername, 'pre_login');
    FPassword := StrDflt(FPassword, 'qk250196z');
    FTablename := 'QUSY.DATN';
    FIniTablename := 'QUSY.INITIALISIERUNGEN';
  end else
  if SameText(FAnwendung, 'WEBAB') or SameText(FAnwendung, 'DPE') then
  begin
    FUsername := StrDflt(FUsername, 'pre_login');
    FPassword := StrDflt(FPassword, 'pre_login');
    FTablename := 'R_DATN';
    FIniTablename := 'R_INIT';
  end;
end;

procedure TDatnApp.SetApp(const Value: string);
begin
  if Value = '' then
    Exit;
  FApp := Value;
  if FAnwendung = '' then
    Anwendung := FApp;
  CheckExename;
end;

procedure TDatnApp.SetAppFromFilename(Filename: string);
var
  S1: string;
  P: integer;
begin
  S1 := ExtractFilename(Filename);
  P := LastDelimiter('.' + PathDelim + DriveDelim, S1);
  if P > 0 then
    App := Copy(S1, 1, P - 1)
  else
    App := Filename;
end;

procedure TDatnApp.SetBaseDir(const Value: string);
begin
  if Value = '' then
    Exit;
  FBaseDir := Value;
  CheckExename;
end;

procedure TDatnApp.CheckExename;
var
  Ordner: string;
begin
  Ordner := Format('\APPS\%s\', [Uppercase(FApp)]);  // alles upper!
  FExeName := Format('%s%s%s.EXE', [BaseDir, Ordner, Uppercase(FApp)]);
end;

procedure TDatnApp.SetPassword(const Value: string);
begin
  if Value = '' then
    Exit;
  FPassword := Value;
end;

procedure TDatnApp.SetTableName(const Value: string);
begin
  if Value = '' then
    Exit;
  FTableName := Value;
end;

procedure TDatnApp.SetIniTableName(const Value: string);
begin
  if Value = '' then
    Exit;
  FIniTableName := Value;
end;

procedure TDatnApp.SetUsername(const Value: string);
begin
  if Value = '' then
    Exit;
  FUsername := Value;
end;

function TDatnApp.Ordner: string;
begin
  Result := Format('\APPS\%s\', [Uppercase(FApp)]);  // alles upper!
end;

constructor TDatnApp.Create;
begin
  inherited Create;
  FVersionSL := TStringList.Create;
end;

constructor TDatnApp.Create(BaseDir, App: string; UDatabase: TUDatabase);
begin
  inherited Create;
  FVersionSL := TStringList.Create;
  FBaseDir := BaseDir;
  if UDatabase <> nil then
  begin
    Alias := UDatabase.AliasName;
    Username := UDatabase.Username;
    Password := UDatabase.Password;
  end;
  Self.App := App;  //setzt Tablenames. Erst hier wg Alias
end;

destructor TDatnApp.Destroy;
begin
  FVersionSL.Free;
  inherited;
end;

function TDatnApp.CheckNewVersion: boolean;
//Ergibt true wenn neue Version in Datn existiert. Für GNav.CheckVersion.
// Setzt FNewVersion (Property NewVersion)
//Lädt Datn von Datenbank (immer)
var
  LokalVersion: string;
  DatnVer: string;
begin
  DatnVer := DatnVersion;  //von Datenbank laden, auch DatnComment
  FNoVersion := DatnVer = '';
  if FNoVersion then
  begin  //Datenbank ist leer
    FNewVersion := false;
  end else
  begin
    //Bestimmen der Version der lokalen .EXE
    if not FileExists(FExeName) then
      LokalVersion := '' else
      LokalVersion := FileVersionStr(FExeName);
    FNewVersion := LokalVersion <> DatnVer;
  end;
  Result := FNewVersion;
end;

function TDatnApp.GetComment(Sprache: string): string;
begin
  Result := '';
  if Sprache <> '' then
    Result := FVersionSL.Values['Comment.' + Sprache];  //Comment.pl=osieszinza
  if Result = '' then
    Result := FVersionSL.Values['Comment'];  //Comment=aha
end;

function TDatnApp.GetDatnVersion: string;
//Lädt Datn.Version von Datenbank (immer)
var
  Que: TuQuery;
  VersionFilename: string;
  DT: TDateTime;
  //SL: TStringList;
begin
  Result := '';
  Que := TuQuery.Create(UDatabase);
  try
    VersionFilename := Format('%s_VERSION.TXT', [Uppercase(FApp)]);
    Que.SQL.Text := Format(
      'select DATN_ID, FILENAME, FILETIME, INHALT' + chr(13)+chr(10)+
      '  from %s' + chr(13)+chr(10)+
      ' where ORDNER = ''%s''' + chr(13)+chr(10)+
      '   and upper(FILENAME) = :FILENAME', [Tablename, Ordner]);
    Que.ParamByName('FILENAME').AsString := VersionFilename;
    // ~version.txt öffnen
    CallbackProt('Download %s', [VersionFilename]);
    Que.Open;
    if Que.EOF then
    begin
      FDatnVersion := '';
      FVersionSL.Clear;
      //raise Exception.CreateFmt('%s%s nicht in Datenbank', [Ordner, VersionFilename]);
      CallbackProt('%s%s nicht in Datenbank', [Ordner, VersionFilename]);
    end else
    begin
      //copy ~version.txt to lokal und lese Version der Dateiablage (DatnVersion):
      ForceDirectories(BaseDir + Ordner);
      TBlobField(Que.FieldByName('INHALT')).SaveToFile(BaseDir + Ordner + VersionFilename);
      DT := Que.FieldByName('FILETIME').AsDateTime;
      FileSetDate(BaseDir + Ordner + VersionFilename, DateTimeToFileDate(DT));
      //SL := TStringList.Create;
      try
        FVersionSL.WriteBOM := false;  //vergl DatnVer 10.04.14
        FVersionSL.LoadFromFile(BaseDir + Ordner + VersionFilename, TEncoding.UTF8);
        //FDatnVersion := FVersionSL[0];  //alt: erste Zeile idF 6.23.1.0
        //                                  neu: Version=6.25.9.4
        FDatnVersion := StrDflt(FVersionSL.Values['Version'], FVersionSL[0]);
        //Comment=Fehler bei Login behoben
      finally
        //SL.Free;
      end;
    end;
  finally
    Que.Free;
  end;
  Result := FDatnVersion;
end;

procedure TDatnApp.SyncApp;
var
  Que: TuQuery;
  ZipFilename: string;
  LokalVersion, DatnVer: string;
  DT: TDateTime;
begin
  Que := TuQuery.Create(UDatabase);
  try
    //Bestimmen der Version der lokalen .EXE
    if not FileExists(FExeName) then
      LokalVersion := '' else
      LokalVersion := FileVersionStr(FExeName);
    DatnVer := DatnVersion;  //von Datenbank laden

    if DatnVer = '' then
    begin
      //bereits protokolliert
    end else
    if LokalVersion = DatnVer then
    begin
      CallbackProt('Version %s ist aktuell', [LokalVersion]);
    end else
    begin
      CallbackProt('Version %s --> %s', [LokalVersion, DatnVer]);
      //ZIP File: überprüfen ob bereits lokal. Wenn nicht dann downloaden:
      ZipFilename := Format('%s_%s.ZIP', [Uppercase(FApp), DatnVer]);
      if not FileExists(BaseDir + Ordner + ZipFilename) then
      begin
        Que.SQL.Text := Format(
          'select DATN_ID, FILENAME, FILETIME, INHALT' + chr(13)+chr(10)+
          '  from %s' + chr(13)+chr(10)+
          ' where ORDNER = ''%s''' + chr(13)+chr(10)+
          '   and upper(FILENAME) = :FILENAME', [Tablename, Ordner]);
        Que.ParamByName('FILENAME').AsString := ZipFilename;
        // <app>_<version>.zip öffnen
        CallbackProt('Download %s', [ZipFilename]);
        Que.Open;
        if Que.EOF then
          raise Exception.CreateFmt('%s%s nicht in Datenbank', [Ordner, ZipFilename]);
        TBlobField(Que.FieldByName('INHALT')).SaveToFile(BaseDir + Ordner + ZipFilename);
        DT := Que.FieldByName('FILETIME').AsDateTime;
        FileSetDate(BaseDir + Ordner + ZipFilename, DateTimeToFileDate(DT));
      end;

      //Alle Files im ZIP nach Directory von ExeName entpacken:
      CallbackProt('Entpacke %s --> %s', [ZipFilename, FExename]);
      TZipFile.ExtractZipFile(BaseDir + Ordner + ZipFilename, ExtractFilepath(FExename));
      //Fehlerkennung falsche/fehlende Version im Zip:
      if not FileExists(FExeName) then
        LokalVersion := '' else
        LokalVersion := FileVersionStr(FExeName);
      if LokalVersion = '' then
        raise Exception.CreateFmt('%s enthält keine %s.exe', [ZipFilename, FApp]);
      if LokalVersion <> DatnVer then
        raise Exception.CreateFmt('%s enthält falsche Version %s', [ZipFilename, LokalVersion]);
    end;
  finally
    Que.Free;
  end;
end;

{ INIDB }

function TDatnApp.GetAliasFilename: string;
begin
  Result := USession.AliasFilename;
end;

function TDatnApp.GetBasedir: string;
// Datn.BaseDir := IniKmp.ReadString('System', 'BaseDir', Datn.BaseDir);
// FBaseDir := 'c:\temp\dateien';
var
  Que: TuQuery;
begin
  if FBaseDir = '' then
  begin
    Que := TuQuery.Create(UDatabase);
    try
      Que.SQL.Text := Format(
        'select WERT' + chr(13)+chr(10)+
        '  from %s' + chr(13)+chr(10)+
        ' where PARAM = ''BaseDir''' + chr(13)+chr(10)+
        '   and ANWENDUNG = ''%s''', [
        IniTablename, Uppercase(FAnwendung)]);  // alles upper!
      Que.Open;
      if Que.Eof then
        raise Exception.CreateFmt('BaseDir=null Anwe:%s Table:%s', [FAnwendung, IniTablename]);
      FBaseDir := Que.FieldByName('WERT').AsString;
    finally
      Que.Free;
    end;
  end;
  Result := FBaseDir;
end;

end.
