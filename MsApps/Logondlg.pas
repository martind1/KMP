unit Logondlg;
(* Logon-Dialog für Webab, dpe
   10.09.08 MD  erstellt (qw)
   26.03.09 MD  normal: Connect-Passwort nur von ANWE laden (verschlüsselt)
                direkt: DbConnect aus pre_login/INITIALISIERUNGEN[Umgebung] entfernt
                        wird auch von ANWE geladen (und entschlüsselt)
   16.02.12 md  Bug wenn mit [X] geschlossen
   22.12.13 md  WinPassword

   -------------------
   Admin User öffnet ohne Rechteverwaltung
*)
interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, DB,  Gauges,
  Err__kmp, Prots, Ini__kmp, UDB__KMP, IniDbkmp, DPos_Kmp,
  Datn_Kmp, DBAccess, Uni, MemDS, UQue_Kmp, UniProvider,
  SQLServerUniProvider, OracleUniProvider, DASQLMonitor, UniSQLMonitor,
  OnlyOpenOnce;

type
  TDlgLogon = class(TForm)
    Label1: TLabel;
    EdPassword: TEdit;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Label2: TLabel;
    EdUser: TEdit;
    BtnPasswChange: TBitBtn;
    TblAnwe: TuQuery;
    Database1: TuDatabase;
    TblUser: TuQuery;
    Panel2: TPanel;
    StatusLine: TPanel;
    Panel3: TPanel;
    Gauge1: TGauge;
    Error1: TError;
    TblErrM: TuQuery;
    LaAlias: TLabel;
    cobAlias: TComboBox;
    BtnDirekt: TBitBtn;
    Image1: TImage;
    Prot1: TProt;
    IniDb1: TIniDbKmp;
    DatnKmp1: TDatnKmp;
    lbConnect: TListBox;
    QueUserUpd: TuQuery;
    SQLServerUniProvider1: TSQLServerUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
    OnlyOpenOnce1: TOnlyOpenOnce;
    BtnPostFormActivate: TBitBtn;
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
    procedure FormHide(Sender: TObject);
    procedure BtnPostFormActivateClick(Sender: TObject);
  private
    { Private declarations }
    UserChanged: boolean;
    //CapitalState: byte;
    AliasParamsList: TStringList;
    FErr: integer;
    PasswordString: string;
    LogonDirekt: boolean;  //für IDEEN Aufruf Rechteverwaltung QURE
    Activated: boolean;
    WinUser: boolean;
    WinPassword: boolean;  //22.12.13
    IUserParam: boolean;
    function DbLogon: boolean;
    procedure DbLogonDirekt;
    procedure SetErr(const Value: integer);
    procedure DisableControls;
    function ChangePassw: boolean;
    property Err: integer read FErr write SetErr;
    function ConnectAnwe(Direkt: boolean): boolean;
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
  PassDlg,
  ParaFrm; {Ini Konstanten}

function TDlgLogon.DbLogon: boolean;
var
  aReason: string;
  //ConnectString: string;
  //P: integer;
begin
  Screen.Cursor := crHourGlass;
  Prot0('DbLogon(%s) Alias(%s) User(%s@%s)',   // vor 030401: SysParam.UserName]);
    [ShortCaption(Application.Title), Sysparam.Alias, EdUser.Text, IniDb1.Maschine]);
  // DataBase1 is Connected per pre_login
  try
    (* Passwort und Benutzer verifizieren *)
    SMess('Öffne Anwendung',[0]);

    ConnectAnwe(false);
    //begin ConnectAnwe
//    S := ShortCaption(Application.Title);  //nicht Exename
//    TblAnwe.ParamByName('ANWE_KENNUNG').AsString := AnsiUppercase(S);
//    TblAnwe.Open;
//    if TblAnwe.EOF then
//      EError('Anwendung (%s) nicht gefunden',
//        [TblAnwe.ParamByName('ANWE_KENNUNG').AsString]);
//    SysParam.ApplicationId := TblAnwe.FieldByName('ANWE_ID').AsInteger;
//
//    SMess('Passwort',[0]);
//    PasswordString := EdPassword.Text;
//
//    ConnectString := TblAnwe.FieldByName('ANWE_CONNECT_STRING').AsString;
//    P := Pos('/',ConnectString);
//    if P <= 0 then
//      EError('Falscher Connect String (%s)',[ConnectString]);
//    DataBase1.Close;
//    SysParam.UserName := copy(ConnectString, 1, P-1);
//    SysParam.PassWord := copy(ConnectString, P+1, length(ConnectString)-P);
//    SMess('Öffne Datenbank %s',[AliasParamsList.Values['SERVER NAME']]);
//    DataBase1.Open;
    //End

    SysParam.UserName := EdUser.Text;
    SysParam.PassWord := EdPassword.Text;

    SMess('Lade Anmeldung',[0]);
    TblUser.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
    if WinUser and AnsiSameText(EdUser.Text, CompUserName) then
    begin
      {select * from #R_USRS
       where (USER_KENNUNG = :USER_KENNUNG)
       and (USER_PASSWORT = :USER_PASSWORT) }
      Prot0('WinUser %s', [CompUserName]);
      TblUser.Sql.Text := StringReplace(TblUser.Sql.Text, '= :USER_PASSWORT',
                          'is not null', [rfReplaceAll, rfIgnoreCase]);
      TblUser.Open;
      //Start immer blocken:
      EdPassword.Text := String(DeCryptPassw(AnsiString(TblUser.FieldByName('USER_PASSWORT').AsString)));
    end else
    if WinPassword then
    begin
      if not CheckUserAccount(EdUser.Text, EdPassword.Text, '', aReason) then
        raise Exception.CreateFmt('%s', [aReason]);

      Prot0('WinLogon %s', [EdUser.Text]);
      TblUser.Sql.Text := StringReplace(TblUser.Sql.Text, '= :USER_PASSWORT',
                          'is not null', [rfReplaceAll, rfIgnoreCase]);
      TblUser.Open;
    end else
    begin

      TblUser.ParamByName('USER_PASSWORT').AsString := EdPassword.Text;
      TblUser.Open;
      if TblUser.EOF then
      begin   //neue Rechte.exe 03.03.04
        TblUser.Close;
        TblUser.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
        TblUser.ParamByName('USER_PASSWORT').AsString := String(EnCryptPassw(AnsiString(EdPassword.Text), 100));
        TblUser.Open;
      end;
    end;
    if TblUser.EOF then
    begin
      raise Exception.Create('Benutzer oder Passwort falsch.');
    end;

    if not WinPassword and SameText(EdPassword.Text, 'Start') then
    begin
      WMess('Ihr Passwort wurde auf "start" zurückgesetzt. '+CRLF+
            'Geben Sie im folgenden Dialog ihr neues Passwort ein.', [0]);
      if not ChangePassw then
      begin
        Prot0('Passwort Ändern wurde abgebrochen', [0]);
        Result := false;
        Exit;
      end;
    end;

    (* für SQL Trigger damit dieser Protokollieren kann - schlecht wg requestlive und dpeur.dbo.r_usrs
    DataBase1.StartTransaction;
    try
      QueUserUpd.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
      QueUserUpd.ParamByName('USER_PASSWORT').AsString := EnCryptPassw(EdPassword.Text, 100);
      QueUserUpd.ParamByName('FLAG_PASSWORT').AsString := DateTimeToStr(now); //EdPassword.Text;
      QueUserUpd.ExecSql;
      DataBase1.Commit;
    except
      DataBase1.RollBack;
      raise;
    end;
    *)

    (* Datenbank über Connect-String öffnen *)
    //jetzt oben

    { INIT DB }
    //21.10.10 vor Rechte Init!
    if not IUserParam or (IniDb1.User = '') then
      IniDb1.User := AnsiUppercase(SysParam.UserName);

    { Rechteverwaltung }
    SMess('Lade Rechteverwaltung',[0]);
    //bereits KmpRechte:= TRechte.Create(Application);
    //if CompareText(SysParam.UserName, 'Admin') = 0 then
    if BeginsWith(SysParam.UserName, 'Admin', true) then
      KmpRechte.InitDirekt(DlgLogon.DataBase1, SysParam.ApplicationId)
    else
      KmpRechte.Init(DlgLogon.DataBase1, SysParam.ApplicationId);

    Result := true;
  except
    on E:Exception do
    begin
      //MessageFmt('%s'+CRLF+'Logon',[E.Message], mtError, [mbOK], 0);
      ProtM('%s' + CRLF + 'Logon', [E.Message]);
      ProtSql(TblUser);
      Database1.Close;
      Result := false;
    end;
  end;
end;

function TDlgLogon.ConnectAnwe(Direkt: boolean): boolean;
// Öffnete DB anhand Anwe.Anwe_Kennung. Pre_Login muss geöffnet sein.
// LogonDirekt: muss auch ohne ANWE-Record einloggen könne (Conectstring per Editfelder)
// ergibt false wenn Anwendung nicht gefunden
var
  ConnectString: string;
  S: string;
  P: integer;
begin
  Result := true;
  S := ShortCaption(Application.Title);  //nicht Exename. hier: DEPONIE oder WEBAB
  TblAnwe.ParamByName('ANWE_KENNUNG').AsString := AnsiUppercase(S);
  TblAnwe.Open;
  ConnectString := TblAnwe.FieldByName('ANWE_CONNECT_STRING').AsString;
  if TblAnwe.EOF then
  begin
    ErrWarn('Anwendung (%s) nicht gefunden', [TblAnwe.ParamByName('ANWE_KENNUNG').AsString]);
    ConnectString := Format('%s/%s', [SysParam.UserName, SysParam.PassWord]);
    Result := false;
  end;
  SysParam.ApplicationId := TblAnwe.FieldByName('ANWE_ID').AsInteger;
  DataBase1.Close;

  P := Pos('/',ConnectString);
  if P <= 0 then
    EError('Falscher Connect String (%s)',[ConnectString]);
  if Direkt then
  begin
    if not SameText(SysParam.UserName, copy(ConnectString, 1, P-1)) or
       not SameText(SysParam.PassWord, copy(ConnectString, P+1, length(ConnectString)-P)) then
      EError('Anmeldung falsch', [0]);
  end else
  begin
    SysParam.UserName := copy(ConnectString, 1, P-1);
    SysParam.PassWord := copy(ConnectString, P+1, length(ConnectString)-P);
  end;
  SMess('Öffne Datenbank %s',[AliasParamsList.Values['SERVER NAME']]);
  DataBase1.Open;
end;

procedure TDlgLogon.DbLogonDirekt;
begin
  if UserChanged then
  begin
    SysParam.UserName := EdUser.Text;
    SysParam.PassWord := EdPassword.Text;
  end;
  try
    Screen.Cursor := crHourGlass;

    ConnectAnwe(true);
    (*
    DataBase1.Close;
    DataBase1.LoginPrompt := true;  {mit logon Ereignis}
    Prot0('DbLogonDirekt(%s) Alias(%s) User(%s@%s)',
      [ShortCaption(Application.Title), SysParam.Alias, SysParam.UserName, IniDb1.Maschine]);
    DataBase1.Open;

    SMess('Öffne Anwendungen',[0]);
    S := ShortCaption(Application.Title);
    TblAnwe.ParamByName('ANWE_KENNUNG').AsString := AnsiUppercase(S);
    try
      TblAnwe.Open;
      if TblAnwe.EOF then  //08.05.04 keine Exc mehr wen Anwe fehlt (QURE)
        Prot0('Anwendung (%s) nicht gefunden', [TblAnwe.ParamByName('ANWE_KENNUNG').AsString]);
      SysParam.ApplicationId := TblAnwe.FieldByName('ANWE_ID').AsInteger;
    except on E:Exception do
      EProt(TblAnwe, E, 'Fehler bei Tabelle', [0]);
    end;
    *)

    //bereits KmpRechte:= TRechte.Create(Application);
    //KmpRechte.AllowAll := true;
    KmpRechte.InitDirekt(DlgLogon.DataBase1, SysParam.ApplicationId);

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

procedure TDlgLogon.Database1Login(Database: TuDataBase; LoginParams: TStrings);
var
  I: integer;
begin
  LoginParams.Values['USER NAME'] := SysParam.UserName;
  LoginParams.Values['PASSWORD'] := SysParam.Password;
  //Servername: LoginParams hat Vorrang vor Bde-Parameter in AliasParamsList
  SysParam.ServerName := StrDflt(SysParam.ServerName, LoginParams.Values['SERVER NAME']);
  SysParam.ServerName := StrDflt(SysParam.ServerName, AliasParamsList.Values['SERVER NAME']);
  LoginParams.Values['SERVER NAME'] := SysParam.ServerName;
  ProtL('Connect %s@%s',[SysParam.UserName, SysParam.ServerName]);
  LoginParams.Values['DATABASE NAME'] := SysParam.DatabaseName;  //von BDE Alias
  ProtL('use %s',[SysParam.DatabaseName]);

  LoginParams.Values['SQLPASSTHRU MODE'] := AliasParamsList.Values['SQLPASSTHRU MODE']; //wichtig für ProcExecCommitted

  for I := 0 to LoginParams.Count - 1 do          //für STMEFrm mit Thread
    Database.Params.Values[StrParam(LoginParams[I])] := StrValue(LoginParams[I]);

  SysParam.DbUserName := SysParam.UserName;

  IniDb1.UpLoginParams := LoginParams;       //schließt UpDatabase
  SysParam.Db1Params.Assign(LoginParams);         //für DuplDb1
end;

procedure TDlgLogon.FormActivate(Sender: TObject);
begin
  PostMessage(self.Handle, WM_COMMAND, 0, BtnPostFormActivate.Handle);
end;

procedure TDlgLogon.BtnPostFormActivateClick(Sender: TObject);
var
  I: integer;
  ConnectStr, NextS: string;
  ALine: string;
  //AKeyState: TKeyboardState;
//  CenterX, CenterY, AWidth, AHeight: integer;
//  MaxWidth, MaxHeight: integer;
//  MaxRatio, Ratio, Zoom: double;
  UserConnect: string; //User=
  P1: integer;
  //IUSER, IANWE, IMACH: string;
begin
  if not Activated then
  try
    Activated := true;                                                          Err := 10;
    IniDb1.User := AnsiUppercase(CompUserName);   //wg. Logondirekt. BMP als Vorgabe.
    IniDb1.Anwendung := AnsiUppercase(OnlyFileName(Application.ExeName)); //'QUVA32';
    IniDb1.Maschine := AnsiUppercase(CompName);                                 Err := 30;
    ConnectStr := 'pre_login/pre_login';
    Sysparam.ServerName := '';
    //'webab' oder 'dpeeur'; //Database1.AliasName;
    Sysparam.Alias := OnlyFileName(Application.ExeName);                        Err := 40;

    //25.03.09 ConnectStr := lbConnect.Items.Values[Sysparam.Alias];  //
    for I:= 1 to ParamCount do      {Aufrufparameter i.d.Form Alias=<Aliasname>}
    begin
      ALine := ParamStr(I);
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
        LogonDirekt := StrValue(ALine) = '1';     {ohne Bedienereingaben - Aufruf Rechte32.exe}
      end;
      if CompareText(StrParam(ALine), 'IUSER') = 0 then
      begin
        IniDb1.User := AnsiUppercase(StrValue(ALine));
        IUserParam := true;
      end;
      if CompareText(StrParam(ALine), 'IANWE') = 0 then
        IniDb1.Anwendung := AnsiUppercase(StrValue(ALine));
      if CompareText(StrParam(ALine), 'IMACH') = 0 then
        IniDb1.Maschine := AnsiUppercase(StrValue(ALine));
      if CompareText(StrParam(ALine), 'Alias') = 0 then
      begin
        Sysparam.Alias := StrValue(ALine);
        //25.03.09 ConnectStr := lbConnect.Items.Values[Sysparam.Alias];
      end;
      if CompareText(StrParam(ALine), 'User') = 0 then
        UserConnect := StrValue(ALine);
      (*if CompareText(ALine, 'WinUser=1') = 0 then
      begin
        UserConnect := CompUserName;
        WinUser := true;
      end; später *)
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
    end;                                                                        Err := 501;
    USession.GetAliasNames(cobAlias.Items);                                      Err := 502;
    I := cobAlias.Items.IndexOf(Sysparam.Alias);                                Err := 503;
    if I < 0 then
    begin
      EError('Unbekannter Alias (%s)', [Sysparam.Alias]);
    end;                                                                        Err := 504;
    cobAlias.ItemIndex := I;                                                    Err := 505;
    cobAliasChange(self);        {AliasName nach Database}                      Err := 506;
    Sysparam.UserName := PStrTok(ConnectStr, '/', NextS);
    Sysparam.PassWord := PStrTok('', '@', NextS);
    Sysparam.ServerName := PStrTok('', '@', NextS);                             Err := 507;

    try  //INIT DB
      IniKmp := IniDb1;
      DataBase1.LoginPrompt := true;      {mit logon Ereignis}                  Err := 508;
      Database1.Open;                     {mit pre_login  }                     Err := 509;
      Sysparam.ServerName := '';
    except on E:Exception do
      EError('Fehler bei Connect %s@%s' + CRLF + CRLF + '%s',
        [SysParam.UserName, AliasParamsList.Values['SERVER NAME'], E.Message]);
    end;                                                                        Err := 510;

    //Prot.Filename so früh wie möglich zuweisen
    if Prot <> nil then
    begin
      Prot.Filename := IniKmp.ReadString(SPre_Login, 'Logfile', Prot.FileName);
      for I:= 1 to ParamCount do      {Aufrufparameter i.d.Form Alias=<Aliasname>}
      begin
        ALine := ParamStr(I);
        if CompareText(StrParam(ALine), 'PROT') = 0 then
          Prot.Filename := AnsiUppercase(StrValue(ALine));
      end;
    end;                                                                        Err := 100;

    // Rechterverw. mit pre_login anlegen damit Tablenames bekannt sind
    // Vorauss: IniKmp ist definiert
    // Schutz: ohne Passworteingabe wird nicht auf den Anwendungsconnect verbunden !
    KmpRechte:= TRechte.Create(Application);
    TblAnwe.Sql.Text := StringReplace(TblAnwe.Sql.Text, '#R_ANWE',
                        KmpRechte.TblNameANWE, [rfReplaceAll, rfIgnoreCase]);
    TblUser.Sql.Text := StringReplace(TblUser.Sql.Text, '#R_USRS',
                        KmpRechte.TblNameUSERS, [rfReplaceAll, rfIgnoreCase]);
    QueUserUpd.Sql.Text := StringReplace(QueUserUpd.Sql.Text, '#R_USRS',
                           KmpRechte.TblNameUSERS, [rfReplaceAll, rfIgnoreCase]);

    //WerkNr wird in Para bestimmt

    //Neu: Dateien in Datenbank: (\LOGON\LOGO.BMP)
    Datn.BaseDir := IniKmp.ReadString(SSystem, 'BaseDir', Datn.BaseDir);
    try
      LogoBmp := Datn.GetLokal(DatnLogon, IniKmp.ReadString(SUmgebung, 'LogoBmp', 'LOGO.BMP'));
    except on E:Exception do
      //noch nicht in DB
    end;
    if FileExists(LogoBmp) then
    try
      ImageLoadOutZoomed(Image1, LogoBmp);
    except on E:Exception do
      ErrWarn('%s', [E.Message]);
    end;                                                                        Err := 120;

    SysParam.UserName := IniKmp.ReadString(SUmgebung,'Username', SysParam.UserName);
    SysParam.PassWord := IniKmp.ReadString(SUmgebung,'Password', SysParam.PassWord);
    EdUser.Text := '';
    EdPassword.Text := '';                                                      Err := 130;

    BtnPasswChange.Visible := IniKmp.ReadBool(SSystem, 'PasswChange',false);    Err := 131;
    //Init Db
    BtnDirekt.Visible := IniKmp.ReadBool(SSystem, 'LogonDirekt', false) or LogonDirekt;
                                                                                Err := 132;
    cobAlias.Visible := IniKmp.ReadBool(SSystem, 'LogonAlias', false);
    LaAlias.Visible := cobAlias.Visible;

    if not BtnDirekt.Visible then
    begin
      WinPassword := IniKmp.ReadBool(SSystem, 'WinPassword', false);
      if WinPassword then
        BtnPasswChange.Visible := false;  //22.12.13 von Windows
      WinUser := IniKmp.ReadBool(SSystem, 'WinUser', false);
      if WinUser and (UserConnect = '') then
        UserConnect := AnsiUppercase(CompUserName);
    end;

    UserChanged := false;
    if UserConnect <> '' then
    begin                                                                       Err := 133;
      P1 := Pos('/', UserConnect);
      if P1 > 0 then
      begin
        // User=username/passw in Commandline -> automatisch anmelden
        EdUser.Text := copy(UserConnect, 1, P1 - 1);
        EdPassword.Text := copy(UserConnect, P1 + 1, 100);
        if LogonDirekt then
        begin
          //direkt mit Databaseuser ohne Rechteverwaltung -> Aufruf rechte32.exe
          Err := 134;
          BtnDirekt.Visible := true;
          PostMessage(self.Handle, WM_COMMAND, 0, BtnDirekt.Handle);
        end else
        if BtnOK.Enabled then
        begin
          //mit Rechteverwaltung und Applicationuser
          Err := 135;
          PostMessage(self.Handle, WM_COMMAND, 0, BtnOK.Handle);
          Err := 1351;
        end;
      end else
      begin
        // User=username ohne passw -> Editfeld ausfüllen
        EdUser.Text := UserConnect;
        EdPassword.Text := '';
        EdPassword.SetFocus;
      end;
    end else
    if {Sysparam.BatchMode or} IniKmp.ReadBool(SSystem, 'LogonSkip', false) then
    begin  //automatisch direkt anmelden
      Err := 136;
//      if Sysparam.BatchMode then
//        BtnDirekt.Visible := true;
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
end;

procedure TDlgLogon.FormCreate(Sender: TObject);
begin
  DlgLogon := self;
  AliasParamsList := TStringList.Create;
  StdPanelSMess := StatusLine;
  FormatSettings.ShortDateFormat := 'dd.mm.yyyy';
  Caption := LongCaption(Application.Title, 'Logon');
end;

procedure TDlgLogon.FormDestroy(Sender: TObject);
begin
  AliasParamsList.Free;
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
    Result := DlgLogon.ModalResult <> mrCancel;
  except on E:Exception do
    ErrWarn('%s' + CRLF + 'Logon', [E.Message]);
  end;

//  Button := DlgLogon.ShowModal;
//  if Button <> mrCancel then
//  begin
//    result := true;
//    // stehen lassen bis Main sichtbar
//    DlgLogon.BtnOK.Enabled := false;
//    DlgLogon.BtnDirekt.Enabled := false;
//    DlgLogon.BtnPasswChange.Enabled := false;
//    DlgLogon.BtnCancel.Enabled := false;
//    DlgLogon.Show;
//    SMess('Öffne Hauptmenü',[0]);
//    Application.ProcessMessages;
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
  EdUser.Text := Trim(EdUser.Text);
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
begin
  DisableControls;
  if DbLogon then
  begin
    if ChangePassw then
    begin
      ModalResult := mrOK;
    end else
      ModalResult := mrCancel;

//    PasswordString := TDlgPass.Execute(self);
//    if PasswordString <> '' then
//    begin
//      try
//        QueUserUpd.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
//        QueUserUpd.ParamByName('USER_PASSWORT').AsString := String(EnCryptPassw(AnsiString(PasswordString), 100));
//        QueUserUpd.ParamByName('FLAG_PASSWORT').AsString := DateTimeToStr(now); //EdPassword.Text;
//        QueryExecCommitted(QueUserUpd);  //.ExecSql;
//        ModalResult := mrOK;
//      except
//        ModalResult := mrCancel;
//        raise;
//      end;
//    end else
//      ModalResult := mrCancel;
  end else
    ModalResult := mrCancel;
end;

function TDlgLogon.ChangePassw: boolean;
begin
  Result := false;
  PasswordString := TDlgPass.Execute(self);
  if PasswordString <> '' then
  begin
    try
      QueUserUpd.ParamByName('USER_KENNUNG').AsString := EdUser.Text;
      QueUserUpd.ParamByName('USER_PASSWORT').AsString := String(EnCryptPassw(AnsiString(PasswordString), 100));
      QueUserUpd.ParamByName('FLAG_PASSWORT').AsString := DateTimeToStr(now); //EdPassword.Text;
      QueryExecCommitted(QueUserUpd);  //.ExecSql;
      Result := true;
    except
      raise;
    end;
  end;
end;

procedure TDlgLogon.EdUserChange(Sender: TObject);
begin
  BtnPasswChange.Enabled := (EdUser.Text <> '') and
                            (EdPassword.Text <> ''); {and not Sysparam.Standard;}
  BtnOK.Enabled := (EdUser.Text <> '') and
                   (EdPassword.Text <> '') or Sysparam.Standard;
  BtnDirekt.Enabled := BtnOK.Enabled;
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
  SysParam.Standard := AliasParamsList.IndexOf('USER NAME') < 0;
  SysParam.DatabaseName := AliasParamsList.Values['DATABASE NAME'];  //MSSQL spezifisch
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

procedure TDlgLogon.FormHide(Sender: TObject);
begin
  StdPanelSMess := nil;
end;

end.


