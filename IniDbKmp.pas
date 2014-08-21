unit IniDbkmp;
(* Komponente zur Verwaltung von .INI Datei
  in Datenbank

  Autor: Martin Dambach
  Letzte Änderung:
  06.10.03     Erstellen (von IniKmp)
  29.10.03     DbLoadSection
  15.12.03     HintIni integriert
  16.12.03     IniKmp.SectionTyp[SHQSection] := stMaschine;
  lädt vorher Section Daten
  17.12.03     Hints fest in stAnwendung
  26.03.04     Neu Einlesen erzwingen (nach Delete): SectionTypChar[Sect] := #0
  17.01.06     ReadSectionValues
  22.03.08     'INITED' mit Vollrechten jetzt Standard
  26.03.09     'ProtIniDb' - true = volle Protokollierung  [Pre_Login] ProtIniDb=1
  23.12.09 MD  WriteStrings/ReadStrings mit Commatext, wird von Master erledigt
  06.06.11 md  UniDAC Session
  31.01.14 md  ProtAktiv

  erledigt     - Laden nur benötigte Sections (und nur bei Bedarf)
  - Speichern in eigenem Thread: Session
  - Beim Ändern von User/Machine/Anwendung entspr. Sections zurücksetzen
  - Vorgaben/Gruppen definieren

  -------------------------------------
  Section-Typ in Anwendung festlegen:
  IniKmp.SectionTyp[Kurz] := stMaschine;  (oder stAnwendung, dflt=stUser)
  -------------------------------------
  TIniFile
  KmpRechte: Objekt: OBJE_FORM_ID    Formular 'InitEd' ist anzulegen
  OBJE_FORM_NAME  'INITED'
  OBJE_NAME       'INITDB' (fest)
  OBJE_TYP        U,M,A    (User, Maschine, Anwendung)

  Objektrechte: RECH_ENABLED_KNZ     J = erlaubt
  RECH_DISPLAYED_KNZ   J = Meldung wenn nicht erlaubt (optional)
  Cache:     Op: Del, Ins, Upd
  Typ: V,U,M,A

  ......................................
  IniDbDlg: Dialog zum Editieren der DB Tabelle
  Import bestehender INI-Files
  Anwendung: QURE
*)

interface

uses
  WinTypes, Classes, Menus, Controls, SysUtils,
  Uni, DBAccess, MemDS,
  DPos_Kmp, NLnk_Kmp, Ini__Kmp, IniFiles,
  UDB__KMP, UQue_Kmp, USes_Kmp,
  nstimer, Prots;

const // Sections
  sINIDB = 'IniDb';
  SPre_Login = 'Pre_Login'; // für Logfile und ProtDbIni

type
  TIniDbKmp = class(TIniKmp)
  private
    FAnwendung: string;
    FMaschine: string;
    FUser: string;
    FGruppen: string;
    FQuery: TuQuery;
    FMemIniFile: TMemIniFile;
    FSectionTypes: TValueList;
    FCacheList: TThreadList;
    FDelayTime: integer;
    FSyncVcl: boolean; // false = Thread nicht mit VCL synchronisieren
    CacheTime: integer;
    ProtList: TStringList;
    nstimer: TNonSystemTimer; { Threading }
    UpDatabase: TuDatabase; // Database für Update
    UpQuery: TuQuery;
    FUpLoginParams: TStrings;
    fINITED: string; // Kurz für Edit. INITED=volle Rechte. INIDB=nur eigene Änderungsrechte
    InSetSectionTypChar, InIniDb: boolean;
    InCacheAdd: boolean;
    Dbe: integer; // Debug
    FAswsFromIni: boolean;
    FProtIniDb: boolean;
    ProtAktiv: boolean;

    procedure OnNSTimer(Sender: TComponent);
    function GetDataBaseName: string;
    procedure SetDataBaseName(const Value: string);
    function NameFromTyp(IniTyp: TSecTyp; VorgabeName: string): string;
    function TypFromChar(TypChar: Char): TSecTyp;
    function GetSectionTypChar(const Section: string): Char;
    procedure SetSectionTypChar(const Section: string; const Value: Char);
    function DbSectionTypChar(const Section: string): Char;
    function GetGruppe: string;
    procedure CheckSection(const Section: string);
    procedure DbLoadSection(const Section: string; UniqueTyp: boolean = false);
    procedure SetAnwendung(const Value: string);
    procedure SetGruppen(const Value: string);
    procedure SetMaschine(const Value: string);
    procedure SetUser(const Value: string);
    procedure SetUpLoginParams(const Value: TStrings);
    procedure UpDatabaseLogin(Database: TuDataBase; LoginParams: TStrings);
    procedure XProt(Modus: Char; const Fmt: string;
      const Args: array of const );
    procedure SetProtIniDb(const Value: boolean);
  protected
    UniqueTypFlag: boolean;
    function GetSectionTyp(const Section: string): TSecTyp; override;
    procedure SetSectionTyp(const Section: string; const Value: TSecTyp);
      override;
    function GetFilePath: string; override; // berücksichtigt GNav.TableSynonyms
    property ProtIniDb: boolean read FProtIniDb write SetProtIniDb;
  public
    AutoUpdate: boolean; // Automatisches DbUpdate. Default=true.
    Updating: boolean; // Zustandsflag
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    destructor Destroy; override;
    procedure Refresh(SectonTypeValues: TSysCharSet);
    // lädt Werte nochmals von DB.
    procedure RefreshSection(const Section: string); override;

    function ReadStr(const Section, Ident: string; Default: PChar;
      Buffer: PChar; BuffSize: Cardinal): Cardinal; override;
    procedure WriteStr(const Section, Ident: string; Value: PChar); override;
    function ReadString(const Section, Ident, Default: string): string;
      override;
    procedure WriteString(const Section, Ident, Value: String); override;
    function ReadBinary(const Section, Ident: string): Pointer; override;
    (* liest Hexcodierte Binärinformation in dynamisch angelegten Buffer
      nicht implementiert ! *)
    procedure WriteBinary(const Section, Ident: string; Buffer: PChar;
      BuffSize: integer); override;
    (* Schreibt Binärinformation in Buffer als Hexcodierung n.t. *)
    function ReadSection(const Section: string; Strings: TStrings): boolean;
      override;
    { Liest die linke Seite vor '=' }
    function ReadSectionValuesUniqueTyp(const Section: string;
      Strings: TStrings): boolean; override;
    { für MuGri Spalten }
    procedure EraseSection(const Section: string); override;
    { Löschen einer Sektion }
    procedure EraseIdent(const Section, Ident: string); override;
    { Löschen einer Zeile einer Sektion }
    procedure ReadSections(Strings: TStrings); override;
    { Liest alle Sections }
    procedure DeleteKey(const Section, Ident: String); override;
    { Löscht eine Zeile }

    { HintIni }
    procedure ReadHints(AKurz: string; AForm: TComponent);
    procedure WriteHints(AKurz: string; AForm: TComponent);
    procedure WriteHint(AKurz, AName, AHint: string);
    procedure WriteCaption(AKurz, AName, ACaption: string);
    function ReadHint(AKurz, AName: string): string;
    procedure EditHints(AKurz: string);
    procedure EditHint(ANavLink: TNavLink; Sender: TWinControl);

    function INITED: string; override; // ergibt Kürzel für Edit-Aufruf
    procedure Edit; override; // startet Editor mit INI-File
    procedure CacheAdd(const Section, Ident, Value: String); overload;
    procedure CacheAdd(const Section, Ident, Value: String; TypChar: Char);
      overload;
    procedure DbLoad;
    procedure ProtThreadSafe;
    procedure DbUpdate(ThreadSafe: boolean);
    property UpLoginParams: TStrings read FUpLoginParams write
      SetUpLoginParams;
    property SectionTypChar[const Section: string]
      : Char read GetSectionTypChar write SetSectionTypChar;
    property Gruppe: string read GetGruppe;
    property Query: TuQuery read FQuery;
  published
    property AswsFromIni: boolean read FAswsFromIni write FAswsFromIni;
    property DatabaseName: string read GetDataBaseName write SetDataBaseName;
    property Anwendung: string read FAnwendung write SetAnwendung;
    property Maschine: string read FMaschine write SetMaschine;
    property User: string read FUser write SetUser;
    property Gruppen: string read FGruppen write SetGruppen;
    property DelayTime: integer read FDelayTime write FDelayTime;
    property SyncVcl: boolean read FSyncVcl write FSyncVcl;
  end;

const
  HintSect = 'Hints.';

var
  IniDb: TIniDbKmp;

implementation

uses
  WinProcs, Consts, Forms, Dialogs, ShellApi, Buttons, ActiveX,
  StdCtrls, Db, DbCtrls, ExtCtrls,
  Printers,
  Err__Kmp, Ini__Dlg, Hint_Dlg, AbortDlg,
  GNav_Kmp, Qwf_Form;

var
  Counter: integer;

constructor TIniDbKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProtIniDb := true;
  if (IniKmp = nil) and (self.ClassType = TIniDbKmp) then
    IniKmp := self;
  if (IniDb = nil) and (self.ClassType = TIniDbKmp) then
    IniDb := self;
  FQuery := TuQuery.Create(nil);
  FQuery.Name := 'IniDb' + IntToStr(Counter);
  Inc(Counter);
  FMemIniFile := TMemIniFile.Create('');
  FSectionTypes := TValueList.Create;
  FCacheList := TThreadList.Create;
  FUpLoginParams := TStringList.Create;
  ProtList := TStringList.Create;
  if not(csDesigning in ComponentState) then
  begin
    UpDatabase := TuDatabase.Create(Owner);
    UpQuery := TuQuery.Create(UpDatabase); // Owner);
    UpDatabase.LoginPrompt := true; { mit login Ereignis }
    UpDatabase.OnLogin := UpDatabaseLogin;
    //10.04.14 Test:
    //UpDatabase.SpecificOptions.Values['UseUnicode'] := 'True';
  end;
  DatabaseName := 'DB1';
  FileName := 'R_INIT';
  FDelayTime := 2000; // alle 2s updaten
  AutoUpdate := true;
  FSyncVcl := true;
  UniqueTypFlag := false;
end;

destructor TIniDbKmp.Destroy;
begin
  if SysParam.MSSQL then
    CoUnInitialize;
  if IniKmp = self then
    IniKmp := nil;
  if IniDb = self then
    IniDb := nil;
  FreeAndNil(nstimer);
  // inherited;
  FreeAndNil(FMemIniFile);
  FreeAndNil(FSectionTypes);
  FreeAndNil(FCacheList);
  FreeAndNil(FQuery);
  FreeAndNil(FUpLoginParams);
  FreeAndNil(ProtList);
  inherited; // hier ab 03.07.07 (deadlock)
end;

function TIniDbKmp.INITED: string;
begin
  // if fINITED = '' then       //beware wg.Online Change in InitEd
  begin
    fINITED := IniKmp.ReadString(sINIDB, 'FrmInitEd', 'INITED');
    // mit INIDBLOKAL beschränkte Rechte
    IniKmp.WriteString(sINIDB, 'FrmInitEd', fINITED);
  end;
  result := fINITED;
end;

procedure TIniDbKmp.Edit;
var
  S: string;
begin
  S := Format('ANWE=%s;MACH=%s;USER=%s', [FAnwendung, FMaschine, FUser]);
  { if GNavigator.GetForm(INITED) = nil then
    GNavigator.AddForm(INITED, TFrmInitEd); }
  GNavigator.StartFormData(Application, INITED, PChar(S));
  // Vorgabe 'INIDB' hat beschränkte Rechte
end;

procedure TIniDbKmp.Loaded;
begin
  inherited Loaded;
  if not(csDesigning in ComponentState) then
  begin
    UpDatabase.DatabaseName := 'DB_' + Owner.Name + '_' + Name;
    // + UpSession.SessionName
    UpQuery.DatabaseName := UpDatabase.DatabaseName;

    nstimer := TNonSystemTimer.Create(self);
    nstimer.Interval := 200;
    nstimer.SyncVcl := FSyncVcl;
    { false =echter Thread-Gleichlauf. Nur mit eigener Session! }
    nstimer.Enabled := true;
    nstimer.OnTimer := OnNSTimer;
  end;
end;

procedure TIniDbKmp.XProt(Modus: Char; const Fmt: string;
  const Args: array of const );
begin
  if not ProtAktiv then
    try
      ProtAktiv := true;
      if ProtIniDb then
      // if true then
      begin
        case Modus of
          'A':
            ProtA(Fmt, Args);
          'L':
            ProtL(Fmt, Args);
        else
          Prot0(Fmt, Args);
        end;
      end
      else
      begin
        case Modus of
          'L':
            SMess(Fmt, Args);
        end;
      end;
    finally
      ProtAktiv := false;
    end;
end;

function TIniDbKmp.ReadString(const Section, Ident, Default: string): string;
var
  S: string;
begin
  S := Default;
  if S = SDefaultDialog then
    S := '';
  CheckSection(Section);
  result := FMemIniFile.ReadString(Section, Ident, S);
  if Default = SDefaultDialog then
    if result = '' then { SDefaultDialog }
      result := TDlgIni.Execute(self, Section, Ident);
end;

procedure TIniDbKmp.WriteString(const Section, Ident, Value: string);
begin
  if ReadString(Section, Ident, '') <> Value then
  begin
    FMemIniFile.WriteString(Section, Ident, Value);
    CacheAdd(Section, Ident, Value);
  end;
end;

function TIniDbKmp.ReadStr(const Section, Ident: string; Default: PChar;
  Buffer: PChar; BuffSize: Cardinal): Cardinal;
var
  S: string;
begin
  S := ReadString(Section, Ident, Default);
  StrPLCopy(Buffer, S, BuffSize);
  result := StrLen(Buffer);
end;

procedure TIniDbKmp.WriteStr(const Section, Ident: string; Value: PChar);
begin
  WriteString(Section, Ident, StrPas(Value));
end;

procedure TIniDbKmp.DeleteKey(const Section, Ident: String);
begin
  CacheAdd(Section, Ident, '');
  FMemIniFile.DeleteKey(Section, Ident);
end;

procedure TIniDbKmp.EraseIdent(const Section, Ident: string);
begin
  DeleteKey(Section, Ident);
end;

function TIniDbKmp.ReadBinary(const Section, Ident: string): Pointer;
(* liest Hexcodierte Binärinformation in dynamisch angelegten Buffer
  nicht implementiert ! *)
var
  S: string;
begin
  S := ReadString(Section, Ident, '');
  result := StrNew(PChar(S));
end;

procedure TIniDbKmp.WriteBinary(const Section, Ident: string; Buffer: PChar;
  BuffSize: integer);
(* Schreibt Binärinformation in Buffer als Hexcodierung *)
var
  // CSection: array[0..127] of Char;
  Value: PChar;
  S: array [0 .. 2] of Char;
  I: integer;
begin
  Value := StrAlloc(BuffSize * 2 + 1);
  for I := 0 to BuffSize - 1 do
  begin
    StrFmt(S, '%02.2X', [Byte(Buffer[I])]);
    StrMove(Value + 2 * I, S, 2);
  end;
  Value[BuffSize * 2] := #0;
  WriteString(Section, Ident, Value);
end;

function TIniDbKmp.ReadSection(const Section: string;
  Strings: TStrings): boolean;
// liest linke seite der Section
// ergibt false wenn Buffer oder eine Zeile nicht vollst. gelesen wurden
begin
  { kein strings.clear !   QUERY 270897 }
  { mit strings.clear ! 08.10.03 }
  CheckSection(Section);
  FMemIniFile.ReadSection(Section, Strings);
  result := true;
end;

function TIniDbKmp.ReadSectionValuesUniqueTyp(const Section: string;
  Strings: TStrings): boolean;
begin // für MuGri Spalten
  try
    UniqueTypFlag := true;
    result := ReadSectionValues(Section, Strings);
  finally
    UniqueTypFlag := false;
  end;
end;

procedure TIniDbKmp.EraseSection(const Section: string);
var
  L: TStringList;
  I: integer;
begin
  L := TStringList.Create;
  try
    ReadSection(Section, L);
    for I := 0 to L.Count - 1 do
      CacheAdd(Section, L[I], '');
  finally
    L.Free;
  end;
  FMemIniFile.EraseSection(Section);
end;

procedure TIniDbKmp.ReadSections(Strings: TStrings);
{ Liest alle Sections (entfernt [] in Bezeichnungen) }
begin
  FMemIniFile.ReadSections(Strings);
end;

{ *** Interne Funktionen *** }

function TIniDbKmp.GetFilePath: string;
begin
  if GNavigator <> nil then
    result := StrDflt(GNavigator.TableSynonyms.Values[FileName], FileName)
  else
    result := FileName;
end;

function TIniDbKmp.GetGruppe: string;
begin
  result := 'VORGABE'; // FAnwendung;
end;

function TIniDbKmp.NameFromTyp(IniTyp: TSecTyp; VorgabeName: string): string;
begin
  result := '';
  case IniTyp of
    stVorgabe:
      result := StrDflt(VorgabeName, '%'); // Vorgabe     niedrigste Priorität
    stUser:
      result := FUser; // User
    stMaschine:
      result := FMaschine; // Maschine
    stAnwendung:
      result := FAnwendung; // Application    höchste Priorität
  end;
end;

function TIniDbKmp.TypFromChar(TypChar: Char): TSecTyp;
begin
  for result := low(TSecTyp) to high(TSecTyp) do
    if SecTypChar[result] = TypChar then
      Exit;
  result := high(TSecTyp); // wg Compilerwarnung
  EError('TIniDbKmp.TypFromChar(%s) falscher TypChar', [TypChar]);
end;

function TIniDbKmp.GetDataBaseName: string;
begin
  result := FQuery.DatabaseName;
end;

procedure TIniDbKmp.SetDataBaseName(const Value: string);
begin
  if FQuery.DatabaseName <> Value then
  begin
    if FQuery.Active then
      FQuery.Close;
    FQuery.DatabaseName := Value;
  end;
end;

procedure TIniDbKmp.SetUpLoginParams(const Value: TStrings);
begin
  if FUpLoginParams <> Value then
    FUpLoginParams.Assign(Value);
  if not(csDesigning in ComponentState) then
  begin
    UpDatabase.Close;
    UpDatabase.Connect;  //damit nicht im Thread
  end;
end;

procedure TIniDbKmp.UpDatabaseLogin(Database: TuDataBase; LoginParams: TStrings);
var
  aDatabase: TuDataBase;
begin
  // uni Params müssen vor connect definiert sein ?
  aDatabase := QueryDatabase(DatabaseName);
  if aDatabase <> nil then
    LoginParams.Assign(aDatabase.AliasParams);
  MergeStringsValues(LoginParams, Database.Params);
  MergeStringsValues(LoginParams, FUpLoginParams);
end;

function TIniDbKmp.GetSectionTypChar(const Section: string): Char;
begin
  result := Char1(FSectionTypes.Values[Section]); // #0 wenn fehlt
  // if not (result in ['U', 'M', 'A']) then
  if result = #0 then
    result := DbSectionTypChar(Section);
end;

procedure TIniDbKmp.SetSectionTypChar(const Section: string; const Value: Char);
begin
  if not InSetSectionTypChar and not InIniDb then
    try
      InSetSectionTypChar := true;
      if Value = #0 then
      begin
        FSectionTypes.Values[Section] := ''; // neu Einlesen erzwingen
        FMemIniFile.EraseSection(Section);
      end
      else
      begin // ganz wichtig hier bevor Value zugeordnet wird!
        CheckSection(Section); // ansonsten wird Section nie geladen!
      end; // lädt Section nur wenn noch nicht geladen.
    finally
      InSetSectionTypChar := false;
      if Value <> #0 then
        FSectionTypes.Values[Section] := Value;
    end;
end;

function TIniDbKmp.GetSectionTyp(const Section: string): TSecTyp;
begin
  result := TypFromChar(GetSectionTypChar(Section));
end;

procedure TIniDbKmp.SetSectionTyp(const Section: string; const Value: TSecTyp);
begin
  SetSectionTypChar(Section, SecTypChar[Value]);
end;

function TIniDbKmp.DbSectionTypChar(const Section: string): Char;
// liefert 'niedrigsten' bekannten Typ (V, U, M, A) bzw. #0 wenn nicht vorhanden
const
  SqlFmt: string = 'select TYP from %s' + CRLF + 'where (SECTION=:SE)' + CRLF +
    'order by TYP desc';

  procedure FillParams;
  var
    I: integer;
  begin
    for I := 0 to FQuery.ParamCount - 1 do
    begin
      FQuery.Params[I].Datatype := ftString;
      if FQuery.Params[I].Name = 'SE' then
        FQuery.Params[I].AsString := Section
      else
        EError('TIniDbKmp.DbSectionTypChar:unbekannter Parameter %s',
          [FQuery.Params[I].Name]);
    end;
  end;

begin
  result := #0;
  if csDesigning in ComponentState then
    Exit;
  try
    FQuery.RequestLive := false;
    FQuery.Close;
    FQuery.SQL.Text := Format(SqlFmt, [FilePath]);
    FillParams;
    if GNavigator <> nil then
      GNavigator.SetDuplDB(FQuery, QueryDatabase(FQuery), 4);
    FQuery.Open;
    result := Char1(FQuery.FieldByName('TYP').AsString); // #0 wenn EOF
  except
    on E: Exception do
      EProt(FQuery, E, 'DbSectionTypChar', [0]);
  end;
end;

procedure TIniDbKmp.CheckSection(const Section: string);
begin
  if FSectionTypes.Values[SPre_Login] = '' then
  begin
    DbLoadSection(SPre_Login, UniqueTypFlag);
    if FSectionTypes.Values[SPre_Login] = '' then
      FSectionTypes.Values[SPre_Login] := SecTypChar[DefaultSectionTyp];

    ProtIniDb := ReadBool(SPre_Login, 'ProtIniDb', false);
  end;
  if FSectionTypes.Values[Section] = '' then
  begin
    if AnsiSameText(Section, 'pre_login') then
      Debug0;

    DbLoadSection(Section, UniqueTypFlag);
    if FSectionTypes.Values[Section] = '' then // fehlt in DB: User annehmen
      FSectionTypes.Values[Section] := // damit nicht nochmal geladen
        SecTypChar[DefaultSectionTyp]; { property dfltSection statt 'U' }

    // if Section = SPre_Login then
    // ProtIniDb := ReadBool(SPre_Login, 'ProtIniDb', ProtIniDb);
  end;
end;

procedure TIniDbKmp.DbLoadSection(const Section: string;
  UniqueTyp: boolean = false);
const
  SqlFmt: string = 'select TYP,NAME,SECTION,PARAM,WERT from %s' + CRLF +
    'where (ANWENDUNG=:P_ANWE)' + CRLF +
    'and (((TYP=''A'') and (NAME = :P_ANWE))' + CRLF +
    '  or ((TYP=''M'') and (NAME = :P_MACH))' + CRLF +
    '  or ((TYP=''U'') and (NAME = :P_USER))' + CRLF +
    '  or ((TYP=''V'') and (NAME like :P_VORG)))' + CRLF +
    'and (UPPER(SECTION) = :P_SECT)' + CRLF + 'order by TYP%s, INIT_ID'; // desc

  procedure FillParams;
  var
    I: integer;
  begin
    for I := 0 to FQuery.ParamCount - 1 do
    begin
      FQuery.Params[I].Datatype := ftString;
      if FQuery.Params[I].Name = 'P_ANWE' then
        FQuery.Params[I].AsString := FAnwendung
      else if FQuery.Params[I].Name = 'P_MACH' then
        FQuery.Params[I].AsString := FMaschine
      else if FQuery.Params[I].Name = 'P_USER' then
        FQuery.Params[I].AsString := FUser
      else if FQuery.Params[I].Name = 'P_VORG' then
        FQuery.Params[I].AsString := '%'
      else if FQuery.Params[I].Name = 'P_SECT' then
        FQuery.Params[I].AsString := AnsiUppercase(Section)
      else
        EError('TIniDbKmp.DbLoadSection:unbekannter Parameter %s',
          [FQuery.Params[I].Name]);
    end;
  end;

var
  SECT, PARAM, Value, TypName: string;
  S1, S2: string;
  TypChar: Char;
  SortAsc: string;
  UniqueTypChar: Char;
begin
  // FMemIniFile.Clear;  beware!
  // FCacheList.Clear;
  if csDesigning in ComponentState then
    Exit;
  FQuery.RequestLive := false;
  XProt('L', 'INITDB LoadSection %s %s %s [%s]', [FAnwendung, FMaschine, FUser,
    Section]);
  FQuery.Close;
  if UniqueTyp then
    SortAsc := ''
  else
    SortAsc := ' DESC';
  FQuery.SQL.Text := Format(SqlFmt, [FilePath, SortAsc]);
  FillParams;
  if GNavigator <> nil then
    GNavigator.SetDuplDB(FQuery, QueryDatabase(FQuery), 4); //todo: nur einmal aufrufen
  FQuery.Open;
  if not FQuery.EOF then
    try // Reihenfolge ändern (Mu.Spalten
      UniqueTypChar := #0; // eindeutiger Typ
      while not FQuery.EOF do
      begin
        InIniDb := true;
        SECT := FQuery.FieldByName('SECTION').AsString;
        PARAM := FQuery.FieldByName('PARAM').AsString;
        Value := FQuery.FieldByName('WERT').AsString;
        TypChar := FieldAsChar(FQuery.FieldByName('TYP'));
        TypName := FQuery.FieldByName('NAME').AsString;
        if UniqueTypChar = #0 then
          UniqueTypChar := TypChar;
        if not UniqueTyp or (UniqueTypChar = TypChar) then
        begin
          S1 := FMemIniFile.ReadString(SECT, PARAM, '');
          if S1 <> '' then
          begin
            { Prot0('INITDB Warnung: [%s]%s=%s wird überschrieben mit =%s von %s.%s',
              [SECTION, PARAM, S1, Value, TypChar, TypNAME]); }
            S2 := 'overwrite  ';
          end
          else
            S2 := 'loadsection';
          XProt('A', 'INITDB %s %s(%s) [%s]%s=%.20s',
            [S2, TypChar, TypName, SECT, PARAM, Value]);
          FMemIniFile.WriteString(SECT, PARAM, Value); // ohne Cache!
          FSectionTypes.Values[SECT] := TypChar;
          FQuery.Next;
        end
        else
          break;
      end;
    finally
      InIniDb := false;
    end; // Exceptionbehandlung in Login o.a.
  SMess0;
end;

procedure TIniDbKmp.DbLoad;
// alle Sections komplett laden. n.b.
var
  Section, PARAM, Value, TypName: string;
  S1: string;
  IniTyp: TSecTyp;
const
  SqlFmt: string = 'select SECTION,PARAM,WERT,NAME from %s' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME like :NA)' + CRLF +
    'order by SECTION, INIT_ID';

  procedure FillParams;
  var
    I: integer;
  begin
    for I := 0 to FQuery.ParamCount - 1 do
    begin
      FQuery.Params[I].Datatype := ftString;
      if FQuery.Params[I].Name = 'AN' then
        FQuery.Params[I].AsString := FAnwendung
      else if FQuery.Params[I].Name = 'TY' then
        FQuery.Params[I].AsString := SecTypChar[IniTyp]
      else if FQuery.Params[I].Name = 'NA' then
        FQuery.Params[I].AsString := NameFromTyp(IniTyp, '%')
      else
        EError('TIniDbKmp.DbLoad:unbekannter Parameter %s',
          [FQuery.Params[I].Name]);
    end;
  end;

begin
  if csDesigning in ComponentState then
    Exit;
  FMemIniFile.Clear;
  FSectionTypes.Clear;
  FCacheList.Clear;
  FQuery.RequestLive := false;
  XProt('L', 'INITDB load %s %s %s', [FAnwendung, FMaschine, FUser]);
  for IniTyp := low(IniTyp) to High(IniTyp) do
  begin
    SMess('INITDB %s %s %s', [FAnwendung, SecTypChar[IniTyp],
      NameFromTyp(IniTyp, '%')]);
    FQuery.Close;
    FQuery.SQL.Text := Format(SqlFmt, [FilePath]);
    FillParams;
    if GNavigator <> nil then
      GNavigator.SetDuplDB(FQuery, QueryDatabase(FQuery), 4);
    FQuery.Open;
    while not FQuery.EOF do
      try
        InIniDb := true;
        Section := FQuery.FieldByName('SECTION').AsString;
        PARAM := FQuery.FieldByName('PARAM').AsString;
        Value := FQuery.FieldByName('WERT').AsString;
        TypName := FQuery.FieldByName('NAME').AsString;
        // ProtLA('INITDB read %s(%s) [%s]%s=%s', [SecTypChar[IniTyp], TypNAME, SECTION, PARAM, VALUE]);
        S1 := FMemIniFile.ReadString(Section, PARAM, '');
        if (S1 <> '') and (S1 <> Value) then
        begin
          Prot0(
            'INITDB Warnung: %s.[%s]%s=%s wird überschrieben mit =%s von %s.%s'
              , [FSectionTypes.Values[Section], Section, PARAM, S1, Value,
            SecTypChar[IniTyp], TypName]);
        end;
        FMemIniFile.WriteString(Section, PARAM, Value); // ohne Cache!
        // SectionTypChar[SECTION] := SecTypChar[IniTyp];
        FSectionTypes.Values[Section] := SecTypChar[IniTyp];
        FQuery.Next;
      finally
        InIniDb := false;
      end;
  end; // Exceptionbehandlung in Login o.a.
  SMess0;
end;

type
  TCacheRec = class(TObject)
    Op: string;
    TypChar: Char;
    Typ: TSecTyp;
    Section: string;
    Ident: string;
    Value: string;
  end;

procedure TIniDbKmp.CacheAdd(const Section, Ident, Value: String);
var
  TypChar: Char;
begin
  TypChar := SectionTypChar[Section];
  if not CharInSet(TypChar, ['U', 'M', 'A']) then
    TypChar := 'U'; // User ist default
  CacheAdd(Section, Ident, Value, TypChar);
end;

procedure TIniDbKmp.CacheAdd(const Section, Ident, Value: String;
  TypChar: Char);
var
  P, P1, P2: TCacheRec;
  S: string;
  L: TList;
  Done: boolean;
  I, I2: integer;
begin
  P := TCacheRec.Create;
  P.Section := Section;
  if Ident = '' then
    P.Ident := '*'
  else
    P.Ident := Ident; // Section komplett löschen. Optional
  if Value = '' then
    P.Op := 'D'
  else // Delete
    P.Op := 'U'; // Update
  P.Value := Value;
  P.TypChar := TypChar;
  P.Typ := TypFromChar(P.TypChar);
  S := Format('%s|%s|%s|%s|%s', [P.Op, P.TypChar, P.Section, P.Ident, P.Value]);
  // FCacheList.AddObject(S, P);
  Done := false;
  try
    // kritischer Abschnitt:
    InCacheAdd := true; // unterbricht DB Update um L schneller freizugeben
    L := FCacheList.LockList;
    TicksReset(CacheTime);
    for I := L.Count - 1 downto 0 do
    begin
      P1 := TCacheRec(L.Items[I]);
      if (P1 <> nil) and (P1.TypChar = P.TypChar) and (P1.Section = P.Section)
        and (P1.Ident = P.Ident) and ((P1.Op = P.Op) or (P.Op = 'D')) then
      // 'D' überschreibt 'U'
      begin
        L.Items[I] := P; // ersetzt alten Cache-Eintrag mit neuem
        FreeAndNil(P1);
        Done := true;
        if P.Op = 'D' then
        begin
          for I2 := I - 1 downto 0 do
          begin
            P2 := TCacheRec(L.Items[I2]);
            if (P2 <> nil) and (P2.TypChar = P.TypChar) and
              (P2.Section = P.Section) and (P2.Ident = P.Ident) and
              (P2.Op = 'D') then // alte 'D's löschen
            begin
              L.Items[I2] := nil;
              FreeAndNil(P2);
            end;
          end;
        end;
        break;
      end;
    end;
    if not Done then
      L.Add(P);
  finally
    FCacheList.UnLockList;
    InCacheAdd := false;
  end;
  // if Done then
  // ProtA('INITDB replace %s:%s.[%s]%s=%s', [P1.Op, P1.TypChar, P1.Section, P1.Ident, P1.Value]);
  try
    InIniDb := true;
    // SectionTypChar[Section] := TypChar;
    FSectionTypes.Values[Section] := TypChar;
  finally
    InIniDb := false;
  end;
end;

procedure TIniDbKmp.OnNSTimer(Sender: TComponent);
begin
  if csDestroying in ComponentState then
    Exit;  //18.04.13
  if AutoUpdate and not Updating and (CacheTime <> 0) and
    (TicksDelayed(CacheTime) > FDelayTime) then

  begin
    DbUpdate(not FSyncVcl); // not NSTimer.SyncVcl);
  end;
end;

procedure TIniDbKmp.ProtThreadSafe;
// Aufruf von TDBQBENav.BCIniDb (Message BC_INIDB)
begin
  // CriticalSection, auch für ProtList
  FCacheList.LockList;
  try
    if ProtList.Count > 0 then
      try
        ProtL('Fehler bei IniDb.DbUpdate: %s', [ProtList.Text]);
      finally
        ProtList.Clear;
      end;
  finally
    FCacheList.UnLockList;
  end;
  { ersetzt durch Threadlist - 04.01.07
    if not Updating then
    try
    Updating := true;
    ProtL('Fehler bei IniDb.DbUpdate: %s', [ProtList.Text]);
    ProtList.Clear;
    finally
    Updating := false;
    end else
    PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0); }
end;

procedure TIniDbKmp.DbUpdate(ThreadSafe: boolean);
// CacheList in Datenbank speichern. Mit Rechteverwaltung. evtl. in eigenem Thread
var
  P: TCacheRec;
  L: TList;
  I, N: integer;
  aQuery: TuQuery;
  Done: boolean;
  N1: integer;
  LProtList: TStringList; // lokale ProtList
const
  SqlGetFmt: string = 'select count(*) from %s' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME like :NA)' + CRLF +
    '  and (SECTION=:SE) and (PARAM=:PA)';
  SqlInsFmt: string =
    'insert into %s (ERFASST_VON,ANWENDUNG,TYP,NAME,SECTION,PARAM,WERT)' +
    CRLF + 'values (:ER,:AN,:TY,:NA,:SE,:PA,:VA)';
  SqlUpdFmt: string = 'update %s' + CRLF + 'set GEAENDERT_VON=:GE,' + CRLF +
    '    WERT=:VA' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME like :NA)' + CRLF +
    '  and (SECTION=:SE) and (PARAM=:PA)';
  SqlDelFmt: string = 'delete from %s' + CRLF +
    'where (ANWENDUNG=:AN) and (TYP=:TY) and (NAME like :NA)' + CRLF +
    '  and (SECTION=:SE) and (PARAM=:PA)';

  procedure FillParams;
  var
    I: integer;
    von: string;
  begin
    von := copy(Sysparam.Username + '/' + ExtractFileName
        (Application.ExeName + '@' + CompName), 1, 29);
    for I := 0 to aQuery.ParamCount - 1 do
    begin
      aQuery.Params[I].Datatype := ftString;
      if aQuery.Params[I].Name = 'AN' then
        aQuery.Params[I].AsString := FAnwendung
      else if aQuery.Params[I].Name = 'TY' then
        aQuery.Params[I].AsString := SecTypChar[P.Typ]
      else if aQuery.Params[I].Name = 'NA' then
        aQuery.Params[I].AsString := NameFromTyp(P.Typ, Gruppe)
      else if aQuery.Params[I].Name = 'SE' then
        aQuery.Params[I].AsString := P.Section
      else if aQuery.Params[I].Name = 'PA' then
        aQuery.Params[I].AsString := P.Ident
      else if aQuery.Params[I].Name = 'VA' then
        aQuery.Params[I].AsString := copy(P.Value, 1, 255)
      else if aQuery.Params[I].Name = 'ER' then
        aQuery.Params[I].AsString := von
      else if aQuery.Params[I].Name = 'GE' then
        aQuery.Params[I].AsString := von
      else
        EError('TIniDbKmp.DbUpdate:unbekannter Parameter %s',
          [aQuery.Params[I].Name]);
    end;
  end;

begin
  if csDestroying in ComponentState then
    Exit;
  if Updating then
    Exit;
  N := 0;
  LProtList := TStringList.Create;
  try
    Updating := true;
    Dbe := 1;
    // kritischer Bereich:
    L := FCacheList.LockList;
    CacheTime := 0;
    Dbe := 2;
    N := L.Count;
    I := 0;
    if N > 0 then
      try
        if not ThreadSafe then // muss mich nicht um Threads kümmern und kann IO machen.
          SMess('INIT Chache schreiben (%d)', [N]);
        if ThreadSafe then
        begin
          if not UpDatabase.Connected then
          begin
            { UniDAC - siehe OnLogin
            with QueryDatabase(FQuery) do
            begin
              UpDatabase.AliasName := AliasName;
              Dbe := 3;
              UpDatabase.SpecificOptions.Assign(SpecificOptions);
              Dbe := 4;
              UpDatabase.Open;
              Dbe := 5;
            end;
            }
//besser nicht 29.12.11. Siehe SetUpLoginParams.
//            if SysParam.MSSQL then
//            begin
//              CoInitializeEx(NIL,COINIT_MULTITHREADED);
//            end;
            UpDatabase.Open;
          end;
          aQuery := UpQuery;
          Dbe := 60;
        end
        else
          aQuery := FQuery;
      except
        on E: Exception do
        begin
          ProtList.Add(Format('Connect: %s', [E.Message]));
          if GNavigator <> nil then
            PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0);
          raise;
        end;
      end;
    if not ThreadSafe and (N > 20) then
    begin
      TDlgAbort.CreateDlg('INITDB update');
    end;
    while (L.Count > 0) and not InCacheAdd do
      try
        P := TCacheRec(L.Items[0]);
        Dbe := 70;
        L.Delete(0);
        Dbe := 71;
        Inc(I);
        Dbe := 72;
        if P = nil then
        begin
          continue;
          Dbe := 73;
        end;
        if not ThreadSafe then
        begin
          Dbe := 74;
          if N > 20 then
          begin
            Dbe := 75;
            TDlgAbort.GMessA(I, N);
            TDlgAbort.SetText(Format('INITDB update  %s:%s.[%s]%s=%s',
                [P.Op, P.TypChar, P.Section, P.Ident, P.Value]));
            if GNavigator <> nil then
              if GNavigator.Canceled then
                break;
          end
          else
          begin
            Dbe := 76;
            GMessA(I, N);
            XProt('A', 'INITDB update  %s:%s.[%s]%s=%s',
              [P.Op, P.TypChar, P.Section, P.Ident, P.Value]);
            if GNavigator <> nil then
              GNavigator.ProcessMessages;
          end;
        end;
        // Rechteverwaltung:

        aQuery.RequestLive := false;
        Dbe := 77;
        if P.Op = 'D' then
          try // Delete
            aQuery.Close;
            Dbe := 80;
            aQuery.SQL.Text := Format(SqlDelFmt, [FilePath]);
            FillParams;
            QueryExecCommitted(aQuery);
          except
            on E: Exception do
            begin
              ProtList.Add(QueryText(aQuery));
              ProtList.Add(E.Message);
              if GNavigator <> nil then
                PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0);
            end;
          end
        else if P.Op = 'U' then
          try
            { Select } Dbe := 90;
            aQuery.Close;
            aQuery.SQL.Text := Format(SqlGetFmt, [FilePath]);
            FillParams;
            Dbe := 100;
            aQuery.Open;
            Dbe := 110;
            LProtList.Add(QueryText(aQuery));
            if aQuery.Fields[0].AsInteger = 0 then
            begin // count=0 -> insert
              aQuery.Close;
              Dbe := 120;
              aQuery.SQL.Text := Format(SqlInsFmt, [FilePath]);
              FillParams;
              N1 := 0;
              Done := false;
              repeat
                try
                  AQuery.ExecSql; //Unidac unnötig: QueryExecCommitted(aQuery); //Indexfehler möglich
                  Dbe := 130;
                  Done := true;
                except
                  on E: Exception do
                  begin
                    if not EIsIndexFehler(E) then
                      raise ;
                    ProtList.Clear;
                    ProtList.AddStrings(LProtList);
                    ProtList.Add(QueryText(aQuery));
                    Dbe := 135;
                    ProtList.Add(E.Message);
                  end;
                end;
                Inc(N1);
              until Done or (N1 > 10000); // belegte Sequence Values überspringen
              if not Done then
                if GNavigator <> nil then
                  PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0);
              // 30.03.08
            end
            else
            begin // vorhandenes updaten
              aQuery.Close;
              Dbe := 140;
              aQuery.SQL.Text := Format(SqlUpdFmt, [FilePath]);
              FillParams;
              Dbe := 150;
              QueryExecCommitted(aQuery);
              Dbe := 160;
            end;
          except
            on E: Exception do
            begin
              ProtList.AddStrings(LProtList);
              ProtList.Add(QueryText(aQuery));
              Dbe := 170;
              ProtList.Add(E.Message);
              if not ThreadSafe then
              begin
                EMess(self, E, 'TIniDbKmp.DbUpdate' + CRLF + '%s',
                  [ProtList.Text]);
              end
              else
              begin
                // ProtText := Format('%s' + CRLF + '%s', [E.Message, aQuery.Text]);
                if GNavigator <> nil then
                  PostMessage(GNavigator.X.Handle, BC_INIDB, WPARAM(idProt), 0);
              end;
              L.Clear;
              raise ;
            end;
          end;
      finally
        FreeAndNil(P);
      end;
  finally
    Dbe := 180;
    FCacheList.UnLockList;
    LProtList.Free;
    Updating := false;
    if not ThreadSafe and (N > 0) then
    begin
      TDlgAbort.FreeDlg;
      GMess0;
      SMess0;
    end;
  end;
end;

procedure TIniDbKmp.SetAnwendung(const Value: string);
begin
  if FAnwendung <> Value then
  begin
    if not(csDesigning in ComponentState) then
      DbUpdate(true);
    FAnwendung := Value;
    Refresh([]); // alle Typen neu einlesen
    (* if not (csDesigning in ComponentState) then
      for I := FSectionTypes.Count - 1 downto 0 do
      //if Char1(FSectionTypes.Value(I)) in ['A', 'V'] then  //alles entfernen 16.12.03
      begin
      FMemIniFile.EraseSection(FSectionTypes.Param(I));
      FSectionTypes.Delete(I);
      end; *)
  end;
end;

procedure TIniDbKmp.SetGruppen(const Value: string);
begin
  if FGruppen <> Value then
  begin
    if not(csDesigning in ComponentState) then
      DbUpdate(true);
    FGruppen := Value;
    Refresh([]); // alle Typen neu einlesen
    (* if not (csDesigning in ComponentState) then
      for I := FSectionTypes.Count - 1 downto 0 do
      //if FSectionTypes.Value(I) = 'V' then  //alles entfernen 16.12.03
      begin
      FMemIniFile.EraseSection(FSectionTypes.Param(I));
      FSectionTypes.Delete(I);
      end; *)
  end;
end;

procedure TIniDbKmp.SetMaschine(const Value: string);
begin
  if FMaschine <> Value then
  begin
    if not(csDesigning in ComponentState) then
      DbUpdate(true);
    FMaschine := Value;
    Refresh(['M', 'V']);
    (* if not (csDesigning in ComponentState) then
      begin
      for I := FSectionTypes.Count - 1 downto 0 do
      if Char1(FSectionTypes.Value(I)) in ['M', 'V'] then
      begin
      FMemIniFile.EraseSection(FSectionTypes.Param(I));
      FSectionTypes.Delete(I);
      end;
      end; *)
    if (self = IniKmp) and not(csLoading in ComponentState) and not
      (csDesigning in ComponentState) then
      Sysparam.ClearDrucker; // 26.03.09 Read Drucker;
  end;
end;

procedure TIniDbKmp.SetUser(const Value: string);
begin
  if FUser <> Value then
  begin
    if not(csDesigning in ComponentState) then
      DbUpdate(true);
    FUser := Value;
    Refresh(['U', 'V']);
    (* if not (csDesigning in ComponentState) then
      for I := FSectionTypes.Count - 1 downto 0 do
      if Char1(FSectionTypes.Value(I)) in ['U', 'V'] then
      begin
      FMemIniFile.EraseSection(FSectionTypes.Param(I));
      FSectionTypes.Delete(I);
      end; *)
  end;
end;

procedure TIniDbKmp.Refresh(SectonTypeValues: TSysCharSet);
// lädt Werte nochmals von DB.
var
  I: integer;
begin
  if not(csDesigning in ComponentState) then
  begin
    DbUpdate(true);
    for I := FSectionTypes.Count - 1 downto 0 do
    begin
      // if (SectonTypeValues = []) or   //leer = alle ['V','U','M','A']
      // (Char1(FSectionTypes.Value(I)) in SectonTypeValues) then
      begin
        // im Hauptspeicher entfernen
        FMemIniFile.EraseSection(FSectionTypes.PARAM(I));
        // Typ entfernen, so das neu geladen wird
        FSectionTypes.Delete(I);
      end;
    end;
  end;
end;

procedure TIniDbKmp.RefreshSection(const Section: string);
// lädt Werte nochmals von DB. Ändert SectionTyp nicht
var
  OldSectionType: string;
begin
  OldSectionType := FSectionTypes.Values[Section];
  try
    SetSectionTypChar(Section, #0); // neu Einlesen erzwingen
  finally
    if Char1(OldSectionType) <> #0 then
      SetSectionTypChar(Section, Char1(OldSectionType));
  end;
end;

function IniDbTerminate: boolean;
begin
  result := true;
  if IniDb <> nil then
  try
    IniDb.DbUpdate(false);
  except
    on E: Exception do
      // ende
  end;
end;

{ HintIni }

type
  TDummyControl = class(TControl);
  TDummyCustomCheckBox = class(TCustomCheckBox);

procedure TIniDbKmp.EditHint(ANavLink: TNavLink; Sender: TWinControl);
var
  I, P: integer;
  S: string;
  ALabel: TControl;
  ADataField, AKurz, ACaption, AAswName: string;
begin
  ALabel := nil;
  ACaption := '';
  ADataField := '';
  AAswName := '';
  if (Sender is TCustomCheckBox) or (Sender is TButton) then
  begin
    ALabel := Sender;
    ACaption := TDummyControl(ALabel).Caption;
  end
  else
    for I := 0 to ANavLink.Form.ComponentCount - 1 do
    begin
      if ANavLink.Form.Components[I] is TLabel then
        with ANavLink.Form.Components[I] as TLabel do
          if FocusControl = Sender then
          begin
            ALabel := ANavLink.Form.Components[I] as TControl;
            ACaption := TDummyControl(ALabel).Caption;
            break;
          end;
    end;
  if Sender is TDBEdit then
    ADataField := TDBEdit(Sender).DataField
  else if Sender is TDBCheckBox then
    ADataField := TDBCheckBox(Sender).DataField
  else if Sender is TDBComboBox then
    ADataField := TDBComboBox(Sender).DataField
  else if Sender is TDBListBox then
    ADataField := TDBListBox(Sender).DataField
  else if Sender is TDBRadioGroup then
    ADataField := TDBRadioGroup(Sender).DataField
  else if (Sender is TRadioButton) and (Sender.Parent is TDBRadioGroup) then
    ADataField := TDBRadioGroup(Sender.Parent).DataField
  else if Sender is TDBMemo then
    ADataField := TDBMemo(Sender).DataField;
  if (ADataField <> '') then
  begin
    S := ANavLink.FormatList.Values[ADataField];
    P := PosI('Asw,', S);
    if P > 0 then
      AAswName := copy(S, P + 4, 200);
  end;
  if ALabel = nil then
    ACaption := sNil; { '__nil'; }
  if TDlgHint.Execute(Sender, ACaption, AAswName) then
  begin
    AKurz := TqForm(ANavLink.Form).Kurz;
    WriteHint(AKurz, Sender.Name, Sender.Hint);
    if ALabel <> nil then
    begin
      TDummyControl(ALabel).Caption := ACaption;
      WriteCaption(AKurz, ALabel.Name, ACaption);
    end;
    if AAswName <> '' then { gespeichert über AswEdDlg }
      FormCheckAsw(ANavLink.Form);
  end;
end;

procedure TIniDbKmp.EditHints(AKurz: string);
begin
  // k.A.
end;

function TIniDbKmp.ReadHint(AKurz, AName: string): string;
begin
  result := StrToHint(ReadString(HintSect + AKurz, AName + '.Hint', ''));
end;

procedure TIniDbKmp.ReadHints(AKurz: string; AForm: TComponent);
// INI -> Form.Hints

  function GetComponent(S: string): string;
  var { S:Componente.Property }
    P: integer;
  begin
    P := Pos('.', S);
    if P > 0 then
      result := copy(S, 1, P - 1)
    else
      result := S; { kompatibel zur reinen Hint-Version }
  end;

  function GetProperty(S: string): Char;
  var { S:Componente.Property; H=Hint; C=Caption }
    P: integer;
  begin
    P := Pos('.', S);
    if P > 0 then
      result := S[P + 1]
    else
      result := 'H'; { kompatibel zur reinen Hint-Version }
  end;

var
  I: integer;
  Hints: TValueList;
  AComponent: TComponent;
begin  { ReadHints }
  Hints := TValueList.Create;
  ReadSectionValues(HintSect + AKurz, Hints);
  try
    for I := 0 to Hints.Count - 1 do
    try
      AComponent := AForm.FindComponent(GetComponent(Hints.PARAM(I)));
      if AComponent = nil then
      begin
        EError('AComponent=nil', [0]);
      end else
      if Hints.Value(I) <> '' then { 160800 }
      begin
        if GetProperty(Hints.PARAM(I)) = 'H' then
          TControl(AComponent).Hint := StrToHint(Hints.Value(I))
        else
          TDummyControl(AComponent).Caption := StrToHint(Hints.Value(I));
      end;
    except
      on E: Exception do
        EProt(self, E, '%s.%s (ReadHints)', [OwnerDotName(AForm), Hints[I]]);
    end;
  finally
    Hints.Free;
  end;
end;

procedure TIniDbKmp.WriteCaption(AKurz, AName, ACaption: string);
begin
  // SectionTyp[HintSect + AKurz] := stAnwendung;
  FSectionTypes.Values[HintSect + AKurz] := SecTypChar[stAnwendung];
  if ACaption = '' then
    DeleteKey(HintSect + AKurz, AName + '.Caption')
  else
    WriteString(HintSect + AKurz, AName + '.Caption', ACaption);
end;

procedure TIniDbKmp.WriteHint(AKurz, AName, AHint: string);
begin
  // SectionTyp[HintSect + AKurz] := stAnwendung;
  FSectionTypes.Values[HintSect + AKurz] := SecTypChar[stAnwendung];
  if AHint = '' then
    DeleteKey(HintSect + AKurz, AName + '.Hint')
  else
    WriteString(HintSect + AKurz, AName + '.Hint', HintToStr(AHint));
end;

procedure TIniDbKmp.WriteHints(AKurz: string; AForm: TComponent);

// Form.Hints -> INI
var
  I: integer;
  Hints: TValueList;
  AComponent: TComponent;
begin
  Hints := TValueList.Create;
  try
    for I := 0 to AForm.ComponentCount - 1 do
      try
        AComponent := AForm.Components[I];
        if AComponent is TControl then
          Hints.Values[AComponent.Name] := HintToStr
            (TControl(AComponent).Hint); { nix bei '' }
      except
        on E: Exception do
          EMess(self, E, '%s (WriteHints)', [Hints[I]]);
      end;
    // SectionTyp[HintSect + AKurz] := stAnwendung;
    FSectionTypes.Values[HintSect + AKurz] := SecTypChar[stAnwendung];
    ReplaceSection(HintSect + AKurz, Hints);
  finally
    Hints.Free;
  end;
end;

procedure TIniDbKmp.SetProtIniDb(const Value: boolean);
begin
  if FProtIniDb <> Value then
    FProtIniDb := Value;
end;

initialization

Counter := 0;
AddTerminateProc(IniDbTerminate);

end.
