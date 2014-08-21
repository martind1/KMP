unit DatnVer;
(* Anwendung Version packen in Dateiablage hochladen

16.11.13 md  erstellt

---
Aufruf in Delphi Anwendung. Deshalb hier keine Provider und kein SQLMonitor.

*)

interface

uses
  UDB__Kmp, UQue_Kmp;

type
  TProtCallback = procedure(S: string) of object;

type
  TDatnVer = class(TObject)
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
    FInputFile: string;
    procedure SetApp(const Value: string);
    function GetExeName: string;
    procedure SetAlias(const Value: string);
    procedure SetTableName(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetUsername(const Value: string);
    function GetTableName: string;
    function GetBasedir: string;
    function GetUDatabase: TUDatabase;
    function GetIniTableName: string;
    procedure CallbackProt(const Fmt: string; const Args: array of const);
    procedure SetInputFile(const Value: string);
    function Ordner: string;
  protected
    property UDatabase: TUDatabase read GetUDatabase;
  public
    procedure MakeApp;
    procedure UploadApp;
    function OnlyFilename(Filename: string): string;
    property BaseDir: string read GetBasedir write FBaseDir;
    property App: string read FApp write SetApp;
    property Alias: string read FAlias write SetAlias;
    property ExeName: string read GetExeName write FExeName;
    property Username: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;
    property TableName: string read GetTableName write SetTableName;
    property IniTableName: string read GetIniTableName write FIniTableName;
    property DatnVersion: string read FDatnVersion write FDatnVersion;
    property ProtCallback: TProtCallback read FProtCallback write FProtCallback;
    property InputFile: string read FInputFile write SetInputFile;
  end;


implementation

uses
  SysUtils, DB, Classes, Zip, IOUtils,
  WinTools;

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


procedure TDatnVer.CallbackProt(const Fmt: string; const Args: array of const);
begin
  if assigned(FProtCallback) then
    FProtCallback(Format(Fmt, Args));
end;

function TDatnVer.Ordner: string;
begin
  Result := Format('\APPS\%s\', [Uppercase(FApp)]);  // alles upper!
end;

{ TDatnVer }

function TDatnVer.GetExeName: string;
begin
  Result := FExeName;
end;

function TDatnVer.GetUDatabase: TUDatabase;
begin
  if FUDatabase = nil then
  begin
    FUDatabase := TuDatabase.Create(nil);
    FUDatabase.AliasName := FAlias;  //lädt session, unidac.ini
    FUDatabase.DatabaseName := 'DB1';

    FUDatabase.Username := FUsername;
    FUDatabase.Password := FPassword;
  end;
  Result := FUDatabase;
end;

function TDatnVer.GetTableName: string;
begin
  Result := StrDflt(FTablename, 'DATN');
end;

function TDatnVer.GetIniTableName: string;
begin
  Result := StrDflt(FIniTablename, 'INITIALISIERUNGEN');
end;

procedure TDatnVer.SetAlias(const Value: string);
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

procedure TDatnVer.SetApp(const Value: string);
begin
  FApp := Value;
  if SameText(FApp, 'QUVAE') or SameText(FApp, 'QSBT') then
  begin
    FUsername := StrDflt(FUsername, 'QUVA');
    FPassword := StrDflt(FPassword, 'quva');
    FTablename := 'QUSY.DATN';
    FIniTablename := 'QUSY.INITIALISIERUNGEN';
  end else
  if SameText(Copy(FApp, 1, 1), 'Q') then
  begin
    FUsername := StrDflt(FUsername, FApp);
    FPassword := StrDflt(FPassword, FApp);
    FTablename := 'QUSY.DATN';
    FIniTablename := 'QUSY.INITIALISIERUNGEN';
  end else
  begin  //MSSQL, Firebird
    FUsername := StrDflt(FUsername, FApp);
    FPassword := StrDflt(FPassword, FApp);
    FTablename := 'R_DATN';
    FIniTablename := 'R_INIT';
  end;
end;

function TDatnVer.OnlyFilename(Filename: string): string;
var
  S1: string;
  P: integer;
begin
  S1 := ExtractFilename(Filename);
  P := LastDelimiter('.' + PathDelim + DriveDelim, S1);
  if P > 0 then
    Result := Copy(S1, 1, P - 1)
  else
    Result := Filename;
end;

procedure TDatnVer.SetPassword(const Value: string);
begin
  if Value = '' then
    Exit;
  FPassword := Value;
end;

procedure TDatnVer.SetTableName(const Value: string);
begin
  if Value = '' then
    Exit;
  FTableName := Value;
end;

procedure TDatnVer.SetUsername(const Value: string);
begin
  if Value = '' then
    Exit;
  FUsername := Value;
end;

procedure TDatnVer.SetInputFile(const Value: string);
var
  S1: string;
  P1: integer;
  ZipVersion: string;
begin
  if FInputFile <> Value then
  begin
    ExeName := '';
    App := '';
    DatnVersion := '';
    //ZIP/Exe unterscheiden
    if SameText(ExtractFileExt(Value), '.ZIP') then
    begin
      S1 := OnlyFilename(ExtractFilename(Value));  //ohne Ext
      P1 := Pos('_', S1);
      App := Copy(S1, 1, P1 - 1);
      DatnVersion := Copy(S1, P1 + 1, MaxInt);
      { extrahieren und mit Filename Version vergleichen }
      TZipFile.ExtractZipFile(Value, BaseDir + Ordner);
      ExeName := BaseDir + Ordner + App + '.exe';
      ZipVersion := FileVersionStr(ExeName);
      if ZipVersion <> DatnVersion then
        raise Exception.CreateFmt('ZIP Version (%s) ungleich Dateiversion (%s)', [
                                  ZipVersion, DatnVersion]);
    end else
    if SameText(ExtractFileExt(Value), '.EXE') then
    begin
      ExeName := Value;
      App := OnlyFilename(Value);
      DatnVersion := FileVersionStr(ExeName);  //0 -> '' !
      { TODO : mit Filename Version vergleichen }
    end else
    begin  //keine erlaubte Erweiterung
      CallbackProt('keine erlaubte Erweiterung "%s"', [Value]);
    end;
  end;
  FInputFile := Value;
end;

procedure TDatnVer.MakeApp;
//erstellt Version und Zip in Lokalen Datn Verzeichnis
//Vorauss.: BaseDir, App, Version, Exename
var
  SL: TStringList;
  VersionFilename, ZipFilename: string;
  ZipFile: TZipFile;
begin
  VersionFilename := Format('%s_VERSION.TXT', [Uppercase(FApp)]);
  ZipFilename := Format('%s_%s.ZIP', [Uppercase(FApp), FDatnVersion]);
  ForceDirectories(BaseDir + Ordner);
  CallbackProt('Erstelle %s', [Ordner + VersionFilename]);
  // Version.txt
  SL := TStringList.Create;
  try
    SL.Add(DatnVersion);
    SL.SaveToFile(BaseDir + Ordner + VersionFilename);
  finally
    SL.Free;
  end;
  // ZIP erstellen:
  CallbackProt('Erstelle %s', [Ordner + ZipFilename]);
  if SameText(ExtractFileExt(Inputfile), '.ZIP') then
  begin
    if SameText(InputFile, BaseDir + Ordner + ZipFilename) then
    begin
      CallbackProt('Verwende bestehende', [0]);
    end else
    begin
      CallbackProt('Kopiere von %s', [Inputfile]);
      TFile.Copy(InputFile, Basedir + Ordner + ZipFilename, true);
    end;
  end else
  begin
    CallbackProt('Erstelle von %s', [Exename]);
    ZipFile := TZipFile.Create;
    try
      DeleteFile(BaseDir + Ordner + ZipFilename);
      ZipFile.Open(BaseDir + Ordner + ZipFilename, zmWrite);
      ZipFile.Add(ExeName, ExtractFilename(Exename));
    finally
      ZipFile.Free;
    end;
  end;
end;

procedure TDatnVer.UploadApp;
// Vorauss.: hochzuladende Dateien liegen Lokal vor
var
  Que: TuQuery;
  VersionFilename, ZipFilename: string;
  DT, DatnDT: TDateTime;
begin
  Que := TuQuery.Create(UDatabase);
  try
    VersionFilename := Format('%s_VERSION.TXT', [Uppercase(FApp)]);
    ZipFilename := Format('%s_%s.ZIP', [Uppercase(FApp), FDatnVersion]);
    CallbackProt('Verteile nach %s', [Alias]);
    //(Forms) Screen.Cursor := crHourGlass;

    Que.Close;
    Que.SQL.Text := Format(
      'select DATN_ID, ORDNER, FILENAME, FILETIME, INHALT' + chr(13)+chr(10)+
      '  from %s' + chr(13)+chr(10)+
      ' where ORDNER = ''%s''' + chr(13)+chr(10)+
      '   and FILENAME = :FILENAME', [Tablename, Ordner]);

    //ZIP hochladen, zuerst!
    DT := FileDateToDateTime(FileAge(BaseDir + Ordner + ZipFilename));
    Que.ParamByName('FILENAME').AsString := ZipFilename;
    Que.Open;
    if Que.EOF then
    begin
      CallbackProt('Insert %s', [ZipFilename]);
      Que.Insert;
    end else
    begin
      DatnDT := Que.FieldByName('FILETIME').AsDateTime;
      if DatnDT = DT then
        CallbackProt('Aktuell %s', [ZipFilename])
      else begin
        CallbackProt('Update %s', [ZipFilename]);
        Que.Edit;
      end;
    end;
    if Que.State in dsEditModes then
    begin
      Que.FieldByName('ORDNER').AsString := Ordner;
      Que.FieldByName('FILENAME').AsString := ZipFilename;
      Que.FieldByName('FILETIME').AsDateTime := DT;
      TBlobField(Que.FieldByName('INHALT')).LoadFromFile(BaseDir + Ordner + ZipFilename);
      Que.Post;
    end;

    //Version.txt hochladen: zuletzt!
    Que.Close;
    Que.ParamByName('FILENAME').AsString := VersionFilename;
    Que.Open;
    if Que.EOF then
    begin
      CallbackProt('Insert %s', [VersionFilename]);
      Que.Insert;
    end else
    begin
      CallbackProt('Update %s', [VersionFilename]);
      Que.Edit;
    end;
    DT := FileDateToDateTime(FileAge(BaseDir + Ordner + VersionFilename));
    Que.FieldByName('ORDNER').AsString := Ordner;
    Que.FieldByName('FILENAME').AsString := VersionFilename;
    Que.FieldByName('FILETIME').AsDateTime := DT;
    TBlobField(Que.FieldByName('INHALT')).LoadFromFile(BaseDir + Ordner + VersionFilename);
    Que.Post;
    CallbackProt('OK %s', [Alias]);

  finally
    Que.Free;
    // (Forms) Screen.Cursor := crDefault;
  end;
end;

{ INIDB }

function TDatnVer.GetBasedir: string;
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
        IniTablename, Uppercase(FApp)]);  // alles upper!
      Que.Open;
      FBaseDir := Que.FieldByName('WERT').AsString;
    finally
      Que.Free;
    end;
  end;
  Result := FBaseDir;
end;

end.
