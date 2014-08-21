unit Logondlg;
(* Allgemeiner Logon-Dialog für alle QW-Anwendungen
   19.10.03 MD IniDb Komponente
   30.04.04 MD zur Designzeit User/Passw umschalten: GNavigator.Bemerkung: [DB1] USER NAME=; PASSWORD=
   13.10.04 MD OnlyOpenOnce: UniqueString leerlassen! wird mit komplettem Aufruf ersetzt.
   19.04.05 MD Blobsize=500 für Quva.Lieferschein.Bitmap
   17.06.08 MD Bitmap laden per Datn
   21.07.08 MD Ini=0: SDBL, QUPP, QURE
   04.09.08 MD UsePrnName=true
   07.05.09 MD SysParam.Db1Params füllen
   07.12.11 md  d2010. Übersetzungen per IniDB.
                Muss in FrmMAIN gesetzt werden: DlgLogon.Visible := false;
   30.12.11 md  kein Modaldlg mehr. Maske stehen lassen bis hide in frmmain.
   23.04.12 md  neue App: Ideen.exe
   21.01.13 md  Sprache=0 -> keine Sprache (originaltexte)
   15.11.13 md  * exe in datn * Neuer QUSY.Connect: <user>/<passw>/1
                (/2 ergibt Fehler)
   10.03.14 md  Param QusyDbLink [=XDB03.INTRANET] für SDBL auf apexutf8
   16.04.14 md  connect: /<Version> überprüft ob eigene Version >= <Version> ist

   - Alias aus .INI-Datei:
         [Umgebung]
         Alias=<Aliasname>
   - Alias als Aufrufparameter:
         Alias=<Aliasname>

   - Combobox für Alias einstellen. Sichtbar nur bei folgender
     Einstellung in der .INI-Datei:
         [System]
         LogonAlias=1

   - Name der .INI-Datei als Aufrufparameter: INI=<Name>
     Standardverzeichnis ist Windows

   - Anwendungsname (für Rechteverwaltung (ANWENDUNGEN) und Überschrift)
     Festlegung in Delphi: Optionen/Projekt/Anwendung/Titel
     Der Kurzname kann - durch einen Bindestrich getrennt - weitere
     Ergänzungen haben (z.B. QUERY - Datenkonsolidierung)

   - Der Passwort-Ändern Button (BtnPasswChange) ist nur bei folgender
     Einstellung in der .INI-Datei sichtbar:
         [System]
         PasswChange=1

   - Direktes Anmelden in der Datenbank ohne Rechteverwaltung (Gleiche
     Funktion wie Supervisor-Hotkey): Button 'Direkt verbinden'
     Der Button ist nur bei folgender Einstellung in der .INI-Datei sichtbar:
         [System]
         LogonDirekt=1

   25.06.98
   - Protokollierung: Logon(<Anwendung>) Username(<Username>)

   - Logo - Bitmap konfigurieren:
     1. Bitmap als BMP erstellen   (max. 377 x 166)
     2. Einstellung in .INI:
        [Umgebung]
        LogoBmp = <FILENAME.BMP>
        Es wird im Pfad der .EXE-Datei gesucht
        Wenn kein Eintrag in .INI und LOGO.BMP existiert, wird dies genommen


   07.03.98
   - BatchMode (QSH Beladung):
     Login ohne Bedienereingabe.
     Als LETZTEN Aufrufparameter: 'BATCHMODE=1'
   29.01.97
   - Pre-Connect auf QUI3/QUI3 eingestellt (wg. Haltern)
   - Rechteverwaltung nicht mehr auf eigener Datenbank

   27.02.98
   - IB Button entgültig gelöscht

   - LogonDirekt über BtnDirekt realisiert

   - DataBase.Connected kann true sein. Neuer Typ 'qDataBase' regelt das
     (siehe KMP\HISTORY.TXT)

   - Benutzername und Passwort können in .INI eingetragen werden:
         [Umgebung]
         UserName=<Benutzername>
         Password=<Passwort>
     Sie werden bei LogonDirekt verwendet, wenn der Bediener in den
     Eingabefeldern keine Eingaben macht.
     Sie werden bei Logon über Rechteverwaltung für das Primärlogon verwendet,
     d.h. Leserechte für QUSY.ANWENDUNGEN, Schreibrechte für QUSY.USERS und
     Aufrufrechte für  QUSY.GETPASS
*)
interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, DB,  Gauges,
  Err__kmp, Prots, Ini__kmp, UDB__KMP, IniDbkmp, DPos_Kmp,
  Datn_Kmp, Uni, DBAccess, MemDS, UQue_Kmp, UPro_Kmp, DASQLMonitor,
  UniSQLMonitor, UniProvider, OracleUniProvider, OnlyOpenOnce;

type
  TDlgLogon = class(TForm)
    LaPasswort: TLabel;
    EdPassword: TEdit;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    LaBenutzer: TLabel;
    EdUser: TEdit;
    BtnPasswChange: TBitBtn;
    TblAnwe: TuQuery;
    Database1: TuDatabase;
    TblUser: TuQuery;
    Proc1: TuStoredProc;
    Panel2: TPanel;
    StatusLine: TPanel;
    Panel3: TPanel;
    Gauge1: TGauge;
    Error1: TError;
    TblErrM: TuQuery;
    IniKmp1: TIniKmp;
    LaAlias: TLabel;
    cobAlias: TComboBox;
    BtnDirekt: TBitBtn;
    Image1: TImage;
    Prot1: TProt;
    IniDb1: TIniDbKmp;
    lbAppOpt: TListBox;
    procSET_USER_PASSWORT: TuStoredProc;
    DatnKmp1: TDatnKmp;
    UniSQLMonitor1: TUniSQLMonitor;
    OracleUniProvider1: TOracleUniProvider;
    BtnPostFormActivate: TBitBtn;
    LaFalsch: TLabel;
    OnlyOpenOnce1: TOnlyOpenOnce;
    procedure BtnOKClick(Sender: TObject);
    procedure Database1Login(Database: TuDataBase; LoginParams: TStrings);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnPasswChangeClick(Sender: TObject);
    procedure EdUserChange(Sender: TObject);
    procedure EdPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cobAliasChange(Sender: TObject);
    procedure BtnDirektClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPostFormActivateClick(Sender: TObject);
  private
    { Private declarations }
    UserChanged: boolean;
    //CapitalState: byte;
    AliasParamsList: TStringList;
    FErr: integer;
    AppOptList: TValueList;
    PasswordString: string;
    LogonDirekt: boolean;  //für IDEEN Aufruf Rechteverwaltung QURE
    IUserParam: boolean;
    SpracheSL: TStringList;
    SprachSection: string;
    SprachSectionFehlt, UmgebungSpracheFehlt: boolean;
    Sprache: string;
    FormActivated: boolean;  //doppelconnect vermeiden
    function DbLogon: boolean;
    procedure DbLogonDirekt;
    procedure SetErr(const Value: integer);
    procedure DisableControls;
    property Err: integer read FErr write SetErr;
  public
    { Public declarations }
    LogoBmp: string;  //Filename für Logo Bitmap
  end;

function Logon: boolean;
function NoLogon: boolean;

var
  DlgLogon: TDlgLogon;

implementation
{$R *.DFM}
uses
  SysUtils, Dialogs, Messages,
  USes_Kmp,
  RechtKmp,
  PassDlg;
const
  STitel = 'Titel';

function TDlgLogon.DbLogon: boolean;
var
  ConnectString: string;
  S, S1, S2, S3, NextS: string;
begin
  Screen.Cursor := crHourGlass;
  Prot0('DbLogon(%s) Alias(%s) User(%s@%s)',   // vor 030401: SysParam.UserName]);
    [ShortCaption(Application.Title), Sysparam.Alias, EdUser.Text, IniDb1.Maschine]);
  if not DataBase1.Connected then    //nur bei File IniKmp
  try
    DataBase1.Close;
    DataBase1.LoginPrompt := true;  {mit logon Ereignis}
    DataBase1.Open;
  except on E:Exception do
    EError('Anmeldung User %s fehlgeschlagen', [SysParam.UserName]);
  end;
  try
    (* Passwort und Benutzer verifizieren *)
    SMess('Öffne Anwendungen',[0]);
    S := ShortCaption(Application.Title);  //nicht Exename
    TblAnwe.ParamByName('ANWE_KENNUNG').AsString := AnsiUppercase(S);
    TblAnwe.Open;
    if TblAnwe.EOF then
      EError('Anwendung (%s) nicht gefunden',
        [TblAnwe.ParamByName('ANWE_KENNUNG').AsString]);
    SysParam.ApplicationId := TblAnwe.FieldByName('ANWE_ID').AsInteger;

    SMess('Passwort',[0]);
    {FrmMain.PrepareProc(Proc1);  beware!!! ist QUSY.}
    Proc1.Prepare;
    Proc1.ParamByName('WORT').AsString := EdPassword.Text;
    Proc1.ExecProc;
    PasswordString := Proc1.ParamByName('Ergebnis').AsString;

    SMess('Lade Anmeldung',[0]);
    TblUser.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
    TblUser.ParamByName('USER_PASSWORT').AsString := PasswordString;
    TblUser.Open;
    if TblUser.EOF then
      raise Exception.Create(LaFalsch.Caption);  //'Benutzer oder Passwort falsch.'

    (* für SQL Trigger damit dieser Protokollieren kann *)
    {TblUser.Edit;
    TblUser.FieldByName('FLAG_PASSWORT').AsString := EdPassword.Text;
    TblUser.Post;}

    (* Datenbank über Connect-String öffnen *)
    ConnectString := TblAnwe.FieldByName('ANWE_CONNECT_STRING').AsString;
//    P := Pos('/',ConnectString);
//    if P <= 0 then
//      EError('Falscher Connect String (%s)',[ConnectString]);
//    DataBase1.Close;
//    SysParam.UserName := copy(ConnectString, 1, P-1);
//    SysParam.PassWord := copy(ConnectString, P+1, length(ConnectString)-P);
    //Inhalt: quva/xxxx/1
    //15.11.13 es darf '/1' hinter Connect stehen. Abgrenzung alte Version.
    S1 := PStrTok(ConnectString, '/', NextS);
    S2 := PStrTokNext('/', NextS);
    S3 := PStrTokNext('/', NextS);
    if StrToIntTol(S3) > 1 then  //Abgrenzung zu zukünftigen Sperren ab
    begin
      if CompareVersion(AppVersion, S3) < 0 then
        EError('Falsche Version (/%s)',[S3]);  //beware showing passworrd - ConnectString]);
    end;
    DataBase1.Close;
    SysParam.UserName := S1;
    SysParam.PassWord := S2;
    SMess('Öffne Datenbank %s',[AliasParamsList.Values['SERVER NAME']]);
    DataBase1.Open;
    SysParam.UserName := EdUser.Text;
    SysParam.PassWord := EdPassword.Text;

    { Rechteverwaltung }
    SMess('Lade Rechteverwaltung',[0]);
    KmpRechte:= TRechte.Create(Application);
    KmpRechte.Init(DlgLogon.DataBase1, SysParam.ApplicationId);

    { INIT DB }
    if not IUserParam then
      IniDb1.User := AnsiUppercase(SysParam.UserName);

    if UmgebungSpracheFehlt then
    begin  //erst hier mit Berechtigung zum Schreiben angemeldet
      IniKmp.WriteString('Umgebung', 'Sprache', Sprache);
    end;
    if SprachSectionFehlt then
    begin  //erst hier mit Berechtigung zum Schreiben angemeldet
      SMess('%s wird angelegt', [SprachSection]);
      IniKmp.ReplaceSection(SprachSection, SpracheSL);
    end;

    Result := true;
  except
    on E:Exception do
    begin
      //MessageFmt('%s'+CRLF+'Logon',[E.Message], mtError, [mbOK], 0);
      ProtM('%s' + CRLF + 'Logon', [E.Message]);
      Database1.Close;
      Result := false;
    end;
  end;
end;

procedure TDlgLogon.DbLogonDirekt;
var
  S: string;
begin
  if UserChanged then
  begin
    SysParam.UserName := EdUser.Text;
    SysParam.PassWord := EdPassword.Text;
  end;
  try
    Screen.Cursor := crHourGlass;
    SMess('Öffne Datenbank %s',[AliasParamsList.Values['SERVER NAME']]);
    DataBase1.Close;
    DataBase1.LoginPrompt := true;  {mit logon Ereignis}
    Prot0('DbLogonDirekt(%s) Alias(%s) User(%s@%s)',
      [ShortCaption(Application.Title), SysParam.Alias, SysParam.UserName, IniDb1.Maschine]);
    DataBase1.Open;

    SMess('Öffne Anwendungen',[0]);
    S := ShortCaption(Application.Title);
    TblAnwe.ParamByName('ANWE_KENNUNG').AsString := AnsiUppercase(S);
    TblAnwe.Open;
    if TblAnwe.EOF then  //08.05.04 keine Exc mehr wen Anwe fehlt (QURE)
      Prot0('Anwendung (%s) nicht gefunden'+CRLF+'%s', [
        TblAnwe.ParamByName('ANWE_KENNUNG').AsString, QueryText(TblANWE)]);
    SysParam.ApplicationId := TblAnwe.FieldByName('ANWE_ID').AsInteger;

    KmpRechte:= TRechte.Create(Application);
    //KmpRechte.AllowAll := true;
    KmpRechte.InitDirekt(DlgLogon.DataBase1, SysParam.ApplicationId);

    if UmgebungSpracheFehlt then
    begin  //erst hier mit Berechtigung zum Schreiben angemeldet
      IniKmp.WriteString('Umgebung', 'Sprache', Sprache);
    end;
    if SprachSectionFehlt then
    begin  //erst hier mit Berechtigung zum Schreiben angemeldet
      SMess('%s wird angelegt', [SprachSection]);
      IniKmp.ReplaceSection(SprachSection, SpracheSL);
    end;

    ModalResult := mrOk;
  except
    on E:Exception do
    begin
      MessageFmt('%s',[E.Message], mtError, [mbOK], 0);
      Database1.Close;
      ModalResult := mrCancel;
    end;
  end; {except}
end;

procedure TDlgLogon.Database1Login(Database: TuDataBase;
  LoginParams: TStrings);
begin
  LoginParams.Values['USER NAME'] := SysParam.UserName;
  LoginParams.Values['PASSWORD'] := SysParam.Password;
  if SysParam.ServerName <> '' then
    LoginParams.Values['SERVER NAME'] := SysParam.ServerName;
  SMess('Connect %s@%s',[SysParam.UserName, AliasParamsList.Values['SERVER NAME']]);

  { UniDAC: Database.Params identisch mit LoginParams
  for I := 0 to LoginParams.Count - 1 do          //für STMEFrm mit Thread
    Database.Params.Values[StrParam(LoginParams[I])] := StrValue(LoginParams[I]);
  }

  SysParam.DbUserName := SysParam.UserName;
  SysParam.DbPassword := SysParam.Password;

  IniDb1.UpLoginParams := LoginParams;       //schließt UpDatabase
  SysParam.Db1Params.Assign(LoginParams);         //für GNav.GetDuplDB1
end;



procedure TDlgLogon.FormActivate(Sender: TObject);
begin
  //damit sofort angezeigt
  if not FormActivated then
  begin
    FormActivated := true;
    PostMessage(self.Handle, WM_COMMAND, 0, BtnPostFormActivate.Handle);
  end;
end;

procedure TDlgLogon.BtnPostFormActivateClick(Sender: TObject);
var
  I: integer;
  IniFile: boolean;
  ConnectStr, NextS: string;
  ALine: string;
  S1: string;
  UserConnect: string; //User=
  P1: integer;
  WerkNr: string;
  QusyDbLink: string;
begin
  Sprache := '';
  WerkNr := '';
  QusyDbLink := '';
  try
    Err := 10;
    IniDb1.User := AnsiUppercase(CompUserName);   //wg. Logondirekt. BMP als Vorgabe.
    Err := 30;
    IniDb1.Anwendung := AnsiUppercase(OnlyFileName(Application.ExeName)); //'QUVA32';
    IniDb1.Maschine := AnsiUppercase(CompName);
    ConnectStr := 'pre_login/qk250196z';  //PRE_LOGIN/QK250196Z
    Sysparam.ServerName := '';
    Sysparam.Alias := IniDb1.Anwendung; //'QUVA32';
    IniFile := false;
    Err := 40;
    cobAlias.Visible := DelphiRunning;
    LaAlias.Visible := cobAlias.Visible;
    BtnDirekt.Visible := DelphiRunning;

    if (ParamCount >= 1) and (Pos('=', ParamStr(1)) = 0) then
    begin
      if AppOptList.Values['INI'] <> '0' then
      begin
        IniFile := true;
        IniKmp1.FilePath := ParamStr(1);  {für Query} //FileName vor 28.11.03
      end;
    end;
    Err := 50;
    for I:= 1 to ParamCount do      {Aufrufparameter i.d.Form Alias=<Aliasname>}
    begin
      ALine := ParamStr(I);
      if CompareText(StrParam(ALine), 'INI') = 0 then
      begin
        if AppOptList.Values['INI'] <> '0' then   //nur wenn INI erlaubt (nicht bei QUPE)
        begin
          IniFile := true;
          IniKmp1.FilePath := StrValue(ALine);   //FileName vor 28.11.03
        end;
      end;
      if CompareText(StrParam(ALine), 'Leak') = 0 then
      begin  //am Programmende nicht freigegebene Speicherbereiche anzeigen. Nur Debug.
        System.ReportMemoryLeaksOnShutdown := StrValue(ALine) = '1';
      end;
      if CompareText(StrParam(ALine), 'BATCHMODE') = 0 then
      begin
        SysParam.BatchMode := StrValue(ALine) = '1';     {ohne Bedienereingaben}
      end;
      if CompareText(StrParam(ALine), 'DBMONITOR') = 0 then
      begin
        UniSQLMonitor1.Active := StrValue(ALine) = '1';  //default = false um SocketError zu vermeiden
      end;
      if CompareText(StrParam(ALine), 'LogonDirekt') = 0 then
      begin
        LogonDirekt := StrValue(ALine) = '1';     {ohne Bedienereingaben}
      end;
      if CompareText(StrParam(ALine), 'IUSER') = 0 then
      begin
        IniDb1.User := AnsiUppercase(StrValue(ALine));
        if IniDb1.User <> '' then
          IUserParam := true;
      end;
      if CompareText(StrParam(ALine), 'IANWE') = 0 then
        IniDb1.Anwendung := AnsiUppercase(StrValue(ALine));
      if CompareText(StrParam(ALine), 'IMACH') = 0 then
        IniDb1.Maschine := AnsiUppercase(StrValue(ALine));
      if CompareText(StrParam(ALine), 'Alias') = 0 then
        Sysparam.Alias := StrValue(ALine);
      if CompareText(StrParam(ALine), 'User') = 0 then
        UserConnect := StrValue(ALine);
      if CompareText(StrParam(ALine), 'ICONNECT') = 0 then
        ConnectStr := StrValue(ALine);
      if CompareText(StrParam(ALine), 'ITABLE') = 0 then
        IniDb1.FileName := AnsiUppercase(StrValue(ALine));

      if CompareText(StrParam(ALine), 'ALIVE') = 0 then
      begin
        SysParam.AliveFile := StrValue(ALine);  //für GNav.DoOnIdle
        SysParam.AliveTime := 10000; //alle 10s melden
      end;
      if CompareText(StrParam(ALine), 'OraUnicodeBug') = 0 then
        Sysparam.OraUnicodeBug := StrValue(ALine) = '1';
//siehe TuSession.GetAliasList
//      if CompareText(StrParam(ALine), 'Uni') = 0 then
//        UniFilename := StrValue(ALine);
      if CompareText(StrParam(ALine), 'QusyDbLink') = 0 then
        QusyDbLink := StrValue(ALine);

      if CompareText(StrParam(ALine), 'Sprache') = 0 then
        Sprache := StrValue(ALine);
      if CompareText(StrParam(ALine), 'WerkNr') = 0 then
        WerkNr := StrValue(ALine);
    end;

    if QusyDbLink <> '' then
    begin
      TblAnwe.SQL.Text := StrCgeStrStr(TblAnwe.SQL.Text, 'QUSY.ANWENDUNGEN',
        'QUSY.ANWENDUNGEN@' + QusyDbLink, true);
    end;

    Err := 501;
    // woher kommt UniDAC.ini
    // von TuSession.GetAliasList
//    if UniFilename = '' then
//      UniFilename := GetEnvStr('Uni');
//    if UniFilename = '' then
//      if FileExists(AppDir + 'Unidac.ini') then
//        UniFilename := AppDir + 'Unidac.ini';
//    if UniFilename <> '' then
//    begin  //nicht-Standard Name. Standard = AllUserDir+'UniDAC\unidac.ini.
//      USession.AliasFilename := UniFilename;
//    end;
    if not FileExists(USession.AliasFilename) then
    begin
      EError('Aliasdatei %s fehlt', [USession.AliasFilename]);
    end;
    USession.GetAliasNames(cobAlias.Items);

    Err := 502;
    if IniFile then
    begin
      IniKmp := IniKmp1;
      Sysparam.Alias := IniKmp.ReadString('Umgebung', 'Alias',
                        StrDflt(Sysparam.Alias, Database1.AliasName));  //23.04.12 MD vertauscht wg QuPI
    end;
    Err := 503;
    I := cobAlias.Items.IndexOf(Sysparam.Alias);
    if I < 0 then
      EError('Unbekannter Alias (%s) oder Aufrufparameter "Alias" fehlt.', [Sysparam.Alias]);
    Err := 504;
    cobAlias.ItemIndex := I;
    Err := 505;
    cobAliasChange(self);                              {AliasName nach Database}
    Err := 506;
    Sysparam.UserName := PStrTok(ConnectStr, '/', NextS);
    Sysparam.PassWord := PStrTok('', '@', NextS);
    Sysparam.ServerName := PStrTok('', '@', NextS);
    Err := 507;
    if not IniFile then
    try  //INIT DB
      IniKmp := IniDb1;
      DataBase1.LoginPrompt := true;                        {mit logon Ereignis}
      //IniDb1.DbLoad;   //Test
      Err := 508;
      Database1.Open;
      Err := 509;
      Sysparam.ServerName := '';
    except on E:Exception do begin
        Prot0('ERROR %s/%s/%s', [Database1.Server, Database1.Username, Database1.Password]);
        EError('Fehler bei Connect %s@%s' + CRLF + CRLF + '%s',
          [SysParam.UserName, AliasParamsList.Values['SERVER NAME'], E.Message]);
      end;
    end;

    //WerkNr wird in Para bestimmt

    Err := 510;
    if Prot <> nil then
    begin
      Prot.Filename := IniKmp.ReadString('System', 'Logfile', Prot.FileName);
      for I:= 1 to ParamCount do      {Aufrufparameter i.d.Form Alias=<Aliasname>}
      begin
        ALine := ParamStr(I);
        if CompareText(StrParam(ALine), 'PROT') = 0 then
          Prot.Filename := AnsiUppercase(StrValue(ALine));
      end;
    end;
    Err := 100;

    //Alt: Filesystem (für quvad 14.06.08)
//    LogoBmp := IniKmp.ReadString('Umgebung', 'LogoBmp', 'LOGO.BMP');
//    if not FileExists(LogoBmp) then
//      LogoBmp := AppDir + LogoBmp;
    //Neu: Dateien in Datenbank: (\LOGON\LOGO.BMP)
    Datn.BaseDir := IniKmp.ReadString('System', 'BaseDir', Datn.BaseDir);

    LogoBmp := Datn.GetLokal(DatnLogon, IniKmp.ReadString('Umgebung', 'LogoBmp', 'LOGO.BMP'));
    if FileExists(LogoBmp) then
    begin
      ImageLoadOutZoomed(Image1, LogoBmp);
    end;
    Err := 120;

    if Sprache <> '' then
    begin
      if Sprache = '0' then  //0 = Originalsprache
        Sprache := '';
      //IniKmp.WriteString('Umgebung', 'Sprache', Sprache);  //hier keine Oracle-Berechtigung
      UmgebungSpracheFehlt := true;
    end;
    if Sprache <> '' then
    begin   // Übersetzung: [Logon.pl]  pl=Sprache
      SprachSection := 'Logon.' + Sprache;
      IniKmp.SectionTyp[SprachSection] := stAnwendung;
      IniKmp.ReadSectionValues(SprachSection, SpracheSL);
      if SpracheSL.Count = 0 then
      begin //neu anlegen
        SpracheSL.Values[STitel] := self.Caption;
        for I := 0 to ComponentCount - 1 do
        begin
          if Components[I] is TLabel then
            with Components[I] as TLabel do
              SpracheSL.Values[Name] := Caption;
          if Components[I] is TBitBtn then
            with Components[I] as TBitBtn do
            SpracheSL.Values[Name] := Caption;
        end;
        //darf hier nicht schreiben wg pre_login
        //IniKmp.ReplaceSection(SprachSection, SpracheSL);
        SprachSectionFehlt := true;
      end else
      begin
        self.Caption := GetStringsString(SpracheSL, STitel, self.Caption);
        for I := 0 to ComponentCount - 1 do
        begin
          if Components[I] is TLabel then
            with Components[I] as TLabel do
              Caption := GetStringsString(SpracheSL, Name, Caption);
          if Components[I] is TBitBtn then
            with Components[I] as TBitBtn do
              Caption := GetStringsString(SpracheSL, Name, Caption);
        end;
      end;
    end;
    if WerkNr <> '' then
      self.Caption := self.Caption + ' ' + WerkNr;

    if IniFile and (AppOptList.Values['INIUSER'] <> '1') then
    begin                //.INI: pre_login verwenden (siehe oben)
      SysParam.UserName := IniKmp.ReadString('Umgebung','UsernameX', SysParam.UserName);
      SysParam.PassWord := IniKmp.ReadString('Umgebung','PasswordX', SysParam.PassWord);
    end else
    begin
      SysParam.UserName := IniKmp.ReadString('Umgebung','Username', SysParam.UserName);
      SysParam.PassWord := IniKmp.ReadString('Umgebung','Password', SysParam.PassWord);
    end;
    EdUser.Text := '';
    EdPassword.Text := '';

    Err := 130;
    BtnPasswChange.Visible := IniKmp.ReadBool('System', 'PasswChange',false);
    Err := 131;
    if IniFile then
    begin
      S1 := 'LogonDirekt' + AppOptList.Values['LogonDirekt'];
      BtnDirekt.Visible := IniKmp.ReadBool('System', S1, false) or LogonDirekt;
    end else
    begin //Init Db
      BtnDirekt.Visible := IniKmp.ReadBool('System', 'LogonDirekt', false) or LogonDirekt;
    end;
    Err := 132;
    cobAlias.Visible := IniKmp.ReadBool('System', 'LogonAlias', DelphiRunning);  //false);
    LaAlias.Visible := cobAlias.Visible;

    UserChanged := false;
    if UserConnect <> '' then
    begin
      Err := 133;
      P1 := Pos('/', UserConnect);
      if P1 > 0 then
      begin
        EdUser.Text := copy(UserConnect, 1, P1 - 1);
        EdPassword.Text := copy(UserConnect, P1 + 1, 100);
        if LogonDirekt then
        begin
          Err := 134;
          BtnDirekt.Visible := true;
          PostMessage(self.Handle, WM_COMMAND, 0, BtnDirekt.Handle);
        end else
        if BtnOK.Enabled then
        begin
          Err := 135;
          PostMessage(self.Handle, WM_COMMAND, 0, BtnOK.Handle);
          Err := 1351;
        end;
      end else
      begin
        EdUser.Text := UserConnect;
        EdPassword.Text := '';
      end;
    end else
    if Sysparam.BatchMode or IniKmp.ReadBool('System', 'LogonSkip', false) then
    begin
      Err := 136;
      if Sysparam.BatchMode then
        BtnDirekt.Visible := true;
      if BtnDirekt.Visible then
        PostMessage(self.Handle, WM_COMMAND, 0, BtnDirekt.Handle);
    end;
    Err := 1361;
    SMess(' Alias %s  Ini %s', [Sysparam.Alias, IniKmp.FileName]);
  except on E:Exception do
    if SysParam.BatchMode then
    begin
      Prot0('Fehler %d: %s', [Err, E.Message]);
      Application.Terminate;
    end else
      ErrWarn('Fehler %d: %s', [Err, E.Message]);
  end;
end; { FormActivate }

procedure TDlgLogon.FormCreate(Sender: TObject);
var
  S1: string;
begin
  DlgLogon := self;
  AliasParamsList := TStringList.Create;
  AppOptList := TValueList.Create;
  SpracheSL := TStringList.Create;
  StdPanelSMess := StatusLine;
  FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  Caption := LongCaption(Application.Title, 'Logon');
  S1 := lbAppOpt.Items.Values[OnlyFileName(Application.ExeName)];
  if S1 = '' then
    EError('unbekannte Anwendung %s', [Application.ExeName]);
  AppOptList.AddTokens(S1, ';');
end;

procedure TDlgLogon.FormDestroy(Sender: TObject);
begin
  AliasParamsList.Free;
  AppOptList.Free;
  FreeAndNil(SpracheSL);
  DlgLogon := nil;
end;

procedure TDlgLogon.FormClose(Sender: TObject; var Action: TCloseAction);
{var
  AKeyState: TKeyboardState;}
begin
  {GetKeyboardState(AKeyState);
  AKeyState[VK_CAPITAL] := CapitalState;
  SetKeyboardState(AKeyState);}
  Action := caMinimize;    {damit DB nicht verschwindet}
end;

procedure TDlgLogon.DisableControls;
//Disabled alle Steuerelemente damit sie modalresult nicht mehr ändern können
begin
  DlgLogon.BtnOK.Enabled := false;
  DlgLogon.BtnDirekt.Enabled := false;
  DlgLogon.BtnPasswChange.Enabled := false;
  DlgLogon.BtnCancel.Enabled := false;
end;

function Logon: boolean;
//var
//  Button: Word;
begin
  result := false;
  try
    TDlgLogon.Create(Application);
    if (DlgLogon = nil) or Application.Terminated then  //wg onlyopenonce
      Exit;
  {not IB:}
    //schlecht DlgLogon.FormStyle := fsStayOnTop;
    DlgLogon.ModalResult := mrNone;
    DlgLogon.Show;
    while DlgLogon.ModalResult = mrNone do
    begin
      if DlgLogon.WindowState = wsMinimized then
        DlgLogon.ModalResult := mrCancel;
      Application.ProcessMessages;
      Sleep(70);
    end;
    // stehen lassen bis Main sichtbar
    SMess('Öffne Hauptmenü',[0]);
    result := DlgLogon.ModalResult <> mrCancel;
  except on E:Exception do
    ErrWarn('%s' + CRLF + 'Logon', [E.Message]);
  end;

//
//
//  Button := DlgLogon.ShowModal;
//  if Button <> mrCancel then
//  begin
//    result := true;
//    // stehen lassen bis Main sichtbar
//// Error
////    DlgLogon.BtnOK.Visible := false;
////    DlgLogon.BtnDirekt.Visible := false;
////    DlgLogon.BtnPasswChange.Visible := false;
////    DlgLogon.BtnCancel.Visible := false;
////bringt nix    SMess('Öffne Hauptmenü',[0]);
//      DlgLogon.Show;
//      DlgLogon.Enabled := false;
//    SMess('Öffne Hauptmenü',[0]);
////    Application.ProcessMessages;
//  end else
//  begin
//  end;
end;

function NoLogon: boolean;
begin
  result := true;
  TDlgLogon.Create(Application);
  KmpRechte:= TRechte.Create(Application);
  KmpRechte.AllowAll := true;
end;

procedure TDlgLogon.BtnOKClick(Sender: TObject);
begin
  DisableControls;
  if DbLogon then
    ModalResult := mrOK else
    ModalResult := mrCancel;
end;

procedure TDlgLogon.BtnDirektClick(Sender: TObject);
begin
  DisableControls;
  DbLogonDirekt;
end;

procedure TDlgLogon.BtnPasswChangeClick(Sender: TObject);
var
  S: string;
begin
  DisableControls;
  if DbLogon then
  begin
    S := PasswordString;
    PasswordString := TDlgPass.Execute(self);
    if PasswordString <> '' then
    begin
      try
        {FrmMain.PrepareProc(Proc1);  beware!!! ist QUSY.}
        Proc1.ParamByName('WORT').AsString := PasswordString;
        Proc1.ExecProc;
        PasswordString := Proc1.ParamByName('Ergebnis').AsString;
        {TblUser.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
        TblUser.ParamByName('USER_PASSWORT').AsString := '%';
        TblUser.Open;
        if TblUser.EOF then
          raise Exception.Create('Benutzer oder Passwort falsch.');

        TblUser.Edit;
        TblUser.FieldByName('USER_PASSWORT').AsString := PasswordString;
        TblUser.Post;}

        procSET_USER_PASSWORT.Prepare;
        procSET_USER_PASSWORT.ParamByName('C_USERNAME').AsString := EdUser.Text;
        procSET_USER_PASSWORT.ParamByName('C_OLD_PWD').AsString := S;
        procSET_USER_PASSWORT.ParamByName('C_NEW_PWD').AsString := PasswordString;
        procSET_USER_PASSWORT.ExecProc;

        ModalResult := mrOK;
      except
        ModalResult := mrCancel;
        raise;
      end;
    end else
      ModalResult := mrCancel;
  end else
    ModalResult := mrCancel;
end;

procedure TDlgLogon.EdUserChange(Sender: TObject);
begin
  BtnPasswChange.Enabled := (EdUser.Text <> '') and
                            (EdPassword.Text <> ''); {and not Sysparam.Standard;}
  BtnOK.Enabled := ((EdUser.Text <> '') and (EdPassword.Text <> '')) or
                   Sysparam.Standard;
  BtnDirekt.Enabled := (SysParam.UserName <> '') and (SysParam.PassWord <> '');
  UserChanged := true;
end;

procedure TDlgLogon.cobAliasChange(Sender: TObject);
begin
  //if Sysparam.Alias <> cobAlias.Text then   beware!
  DataBase1.Close;    //neu 19.10.03
  Sysparam.Alias := cobAlias.Text;
  try
    DataBase1.AliasName := SysParam.Alias;
  except on E:Exception do
    ErrWarn('Datenbank bereits verbunden (%s).'+CRLF+'%s',
      [DataBase1.AliasName, E.Message]);
  end;

  Err := 200;
  USession.GetAliasParams(DataBase1.AliasName, AliasParamsList);
  Err := 210;
  //falsch! SysParam.Standard := AliasParamsList.IndexOf('USER NAME') < 0;
  Err := 220;
  EdUserChange(cobAlias);
  Err := 230;
end;

procedure TDlgLogon.EdPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssShift,ssCtrl]) and (Key = ord('S')) then
  begin
    Key := 0;
    DbLogonDirekt;
  end;
end;

procedure TDlgLogon.SetErr(const Value: integer);
begin
  FErr := Value;
  //SMess('Err=%d', [Value]);
end;

end.


