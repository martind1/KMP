unit EMailFrm;
(* EMails erzeugen (QW)
   SMS per EMail erzeugen
   23.10.02 MD
   24.01.03 MD QDocs: Indy: SMPT, POP
   03.03.03 MD SDBL
   14.05.03 MD ohne SMTP: nur i.V.m. SendMailSvr
   07.01.04 MD QUPE:Senden anhand EMAILS-Tabelle
   07.01.04 MD verallgemeinert in kmp\qw. Konfig:mit/ohne Table EMAILS
               SendMessage(PrgParam.EMail.Form.Handle, BC_EMAI_TABLE, 1, 0);  //EMAI Table einschalten
               Verwendung: QDocs    (07.01.04)
                           QUPE     (19.01.04)
                           SDBL
                           QUPP
                           Dispatch (10.06.05)
               Encoding=enUU <- um Attachments korrekt zu übertragen
   19.04.08 MD  QSBT: mehrfaches SMS Senden vermeiden
   09.06.08 MD  QSBT: Standardisierung - Unabhängigkeit von Outlook/OE. mit SendMailSvr.
                User-Routinen als class-Functions
   19.07.08 MD  Verwendung EmailSendKmp: Übernimmt Outbox von SendMailSvr (Registry)
   30.07.09 MD  SaveToIni nur noch per Button. Um extern Verwaltung via .INI zu ermöglichen
   20.04.10 MD  semail Gruppen per define zugeordnet
   19.07.10 md  QuvaE (SendAvis)
                chbSMTP: ohne Sendmail (= ohne .EML schreiben)
   13.02.14 md  table EMAILS: QUVA von QUPE übernehmen. Hier keine Änderung
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qwf_Form, Lnav_kmp, ExtCtrls, OleCtrls,
  StdCtrls, Buttons, ComCtrls, Tabnotbk, TabNbKmp, Grids,
  TgridKmp, Radios, Cpor_kmp, Menus, DBGrids, Mugrikmp, Db, 
  LuDefKmp, Mask, DBCtrls, Lubtnkmp, nstimer, qSplitter,
  IdBaseComponent, IdMessage, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdSMTP, IdPOP3, Prots, EmailSendKmp,
  Uni, DBAccess, MemDS, JvBaseDlg, JvBrowseFolder, UDS__Kmp, UQue_Kmp;

const
  sEMAIL_GRUPPEN = 'EMAIL_GRUPPEN';

type
  TFrmEMail = class(TqForm)
    Nav: TLNavigator;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    btnAutomatik: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    gbProt: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    btnCopyProtTo: TSpeedButton;
    LbProtTo: TListBox;
    edProtSubject: TEdit;
    MeProtText: TMemo;
    edProtTo: TEdit;
    btnProtTo: TBitBtn;
    Label3: TLabel;
    TabSheet5: TTabSheet;
    BtnTerminate: TBitBtn;
    TabSheet6: TTabSheet;
    ScrollBox4: TScrollBox;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    LaRestTime: TLabel;
    LbEMailTo: TListBox;
    edEMailSubject: TEdit;
    edEMailAttach: TEdit;
    btnSend: TBitBtn;
    btnEMailAttach: TBitBtn;
    MeEmailText: TMemo;
    chbTerminate: TCheckBox;
    TabSheet4: TTabSheet;
    qSplitter1: TqSplitter;
    LuEMAIProt: TLookUpDef;
    GroupBox5: TGroupBox;
    MuEMAI: TMultiGrid;
    EmailSendKmp: TEmailSendKmp;
    ScrollBox1: TScrollBox;
    GroupBox6: TGroupBox;
    LaOutBox: TLabel;
    EdOutBox: TEdit;
    BtnOutBox: TBitBtn;
    GroupBox4: TGroupBox;
    Label16: TLabel;
    EdUserEmail: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    edPollInterval: TEdit;
    GroupBox7: TGroupBox;
    Label9: TLabel;
    chbEMAI: TCheckBox;
    GroupBox8: TGroupBox;
    Label11: TLabel;
    lbAccount: TLabel;
    lbPassword: TLabel;
    EdSMTPServer: TEdit;
    EdSMTPPort: TEdit;
    edSMTPAccount: TEdit;
    edSMTPPassword: TEdit;
    Panel2: TPanel;
    BtnOK: TBitBtn;
    pcSMS: TPageControl;
    TsSmsGlobal: TTabSheet;
    gbStoer: TGroupBox;
    btnCopyStoerTo: TSpeedButton;
    LbStoerTo: TListBox;
    edStoerTo: TEdit;
    BtnStoerTo: TBitBtn;
    chbStartSMS: TCheckBox;
    TsSmsGruppen: TTabSheet;
    Panel3: TPanel;
    Label12: TLabel;
    LbSmsHandy: TListBox;
    BtnEMGR: TBitBtn;
    BtnRefreshSmsHandy: TBitBtn;
    chbSMTP: TCheckBox;
    Label13: TLabel;
    JvBrowseForFolderDialog: TJvBrowseForFolderDialog;
    Query1: TuQuery;
    TblEMAIProt: TuQuery;
    LDataSource1: TuDataSource;
    BtnStoerEntf: TBitBtn;
    PanEmaiTop: TPanel;
    GroupBox3: TGroupBox;
    Mu1: TMultiGrid;
    GroupBox9: TGroupBox;
    qSplitter2: TqSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NavPoll(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnEMailAttachClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnProtToClick(Sender: TObject);
    procedure LbDeleteDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCopyProtToClick(Sender: TObject);
    procedure BtnStoerToClick(Sender: TObject);
    procedure btnCopyStoerToClick(Sender: TObject);
    procedure BtnTerminateClick(Sender: TObject);
    procedure BtnOutBoxClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure edPollIntervalChange(Sender: TObject);
    procedure Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure MuEMAIDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure chbEMAIClick(Sender: TObject);
    procedure NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
    procedure LbStoerToDblClick(Sender: TObject);
    procedure BtnEMGRClick(Sender: TObject);
    procedure BtnRefreshSmsHandyClick(Sender: TObject);
    procedure BtnStoerEntfClick(Sender: TObject);
  private
    { Private-Deklarationen }
    StartTime: integer;
    EMGRFlag: boolean;
    procedure SaveToIni;
    procedure LoadFromIni;
    procedure SaveConfigFile;
    procedure LbEntf(aListbox: TListbox);
  protected
    procedure BCEMaiTable(var Message: TMessage); message BC_EMAI_TABLE;
  public
    { Public-Deklarationen }
    class procedure AppTerminate;
    class function SendEMail(aSubject, aText, aAttach: string): boolean;
    class procedure EMailProtokoll(XlsAttach: string);
    class procedure SmsHandy(WerkNr, Handynr, StoerText: string; aText: string = '');
    class procedure SmsStoerung(StoerText: string);
    class function SendEMailTo(aSubject, aAttachFn: string; aText, aTo: TStrings): boolean;
  end;

var
  FrmEMail: TFrmEMail;

implementation
{$R *.DFM}
uses
  GNav_Kmp, Err__Kmp, Ini__Kmp, Tools, Poll_Kmp, DPos_Kmp,
  MainFrm,
{$IFDEF QSBT}
  DataTFrm,
{$ELSE}
  {$IFDEF QUVAE}
    DataTFrm,
  {$ENDIF}
{$ENDIF}
  ParaFrm;

var
  OldStoerText: string;
  OldStoerDT: TDateTime;

class procedure TFrmEMail.AppTerminate;
//beendet Application wenn EMail versandt
begin
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    chbTerminate.Checked := true;
    TicksReset(StartTime);
  end else
  begin
    Prot0('EMAIL nicht aktiv - AppTerminate', [0]);
    Application.Terminate;  //Qupe
  end;
end;

class function TFrmEMail.SendEMail(aSubject, aText, aAttach: string): boolean;
//QDocs
begin
  Result := false;
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    if btnAutomatik.Down and (LbProtTo.Items.Count > 0) then
    begin
      LbEmailTo.Items.Assign(LbProtTo.Items);
      edEMailSubject.Text := aSubject;
      MeProtText.HandleNeeded;
      MeEmailText.Lines.Text := aText;
      edEMailAttach.Text := '';
      btnSend.Click;
      Result := EmailSendKmp.SendOK;
    end else
    if not btnAutomatik.Down then
    begin
      Prot0('EMAIL keine Automatik - SendEMail(%s)', [aSubject]);
    end else
    if LbProtTo.Items.Count = 0 then
    begin
      Prot0('EMAIL keine SMS-Empfänger - SendEMail(%s)', [aSubject]);
    end;
  end else
    Prot0('EMAIL nicht aktiv - SendEMail(%s,%s)', [aSubject, aText]);
end;

class procedure TFrmEMail.EMailProtokoll(XlsAttach: string);
//Lawa
begin
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    if btnAutomatik.Down and (LbProtTo.Items.Count > 0) then
    begin
      LbEmailTo.Items.Assign(LbProtTo.Items);
      edEMailSubject.Text := StrCgeStr(edProtSubject.Text, '#', ExtractFileName(XlsAttach));
      MeProtText.HandleNeeded;
      MeEmailText.Lines.Assign(MeProtText.Lines);
      edEMailAttach.Text := XlsAttach;
      btnSend.Click;
    end else
    if not btnAutomatik.Down then
    begin
      Prot0('EMAIL keine Automatik - EMailProtokoll(%s)', [XlsAttach]);
    end else
    if LbStoerTo.Items.Count = 0 then
    begin
      Prot0('EMAIL keine SMS-Empfänger - EMailProtokoll(%s)', [XlsAttach]);
    end;
  end else
    Prot0('EMAIL nicht aktiv - EMailProtokoll(%s)', [XlsAttach]);
end;

procedure TFrmEMail.BtnRefreshSmsHandyClick(Sender: TObject);
begin
  IniKmp.RefreshSection(sEMAIL_GRUPPEN + SysParam.WerkNr); //neu einlesen
  IniKmp.ReadSectionValues(sEMAIL_GRUPPEN + SysParam.WerkNr, LbSmsHandy.Items);
end;

class procedure TFrmEMail.SmsHandy(WerkNr, Handynr, StoerText: string; aText: string = '');
//QSBT HR
var
  S: string;
  OldWerk: string;
begin
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    OldWerk := Sysparam.WerkNr;
    try
      if WerkNr <> '' then
        Sysparam.WerkNr := WerkNr;  //0220 sendet für 0230 uU.
      BtnRefreshSmsHandy.Click;
    finally
      Sysparam.WerkNr := OldWerk;
    end;
    S := LbSmsHandy.Items.Values[HandyNr];
    //wenn letzte SMS gleichen Betreff hat dann nicht senden
    if btnAutomatik.Down and (StoerText <> '') then
    begin
      if (OldStoerText = HandyNr + StoerText) and
         (now - OldStoerDT >= 10 * 1440 / SECSPERDAY) then
        OldStoerText := '';  //wieder senden auch wenn text gleich
      if OldStoerText = HandyNr + StoerText then
      begin
        Prot0('SMS bereits versendet (%s)', [StoerText]);
      end else
      begin
        OldStoerText := HandyNr + StoerText;
        OldStoerDT := now;
        Prot0('SMS an %s,%s: %s', [WerkNr, Handynr, StoerText]);
        { TODO : Handy-Zuordnung in eigenem (Ini-)Bereich }
        if S = '' then
        begin
          Prot0('EMAIL Handynr(%s,%s) fehlt - SmsHandy(%s)', [WerkNr, Handynr, StoerText]);
        end else
        begin
          LbEmailTo.Items.CommaText := S;
          edEMailSubject.Text := StoerText;
          MeEmailText.Lines.Text := aText;
          edEMailAttach.Text := '';
          btnSend.Click;
        end;
      end;
    end else
    if not btnAutomatik.Down then
    begin
      Prot0('EMAIL keine Automatik - SmsHandy(%s)', [StoerText]);
    end else
    if S = '' then
    begin
      Prot0('EMAIL keine SMS-Empfänger - SmsHandy(%s,%s,%s)', [WerkNr, Handynr, StoerText]);
    end;
  end else
    Prot0('EMAIL nicht aktiv - SmsHandy(%s)', [StoerText]);
end;

class procedure TFrmEMail.SmsStoerung(StoerText: string);
//QSBT
begin
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    //wenn letzte SMS gleichen Betreff hat dann nicht senden
    if btnAutomatik.Down and (StoerText <> '') and
       (LbStoerTo.Items.Count > 0) then
    begin
      if OldStoerText = StoerText then
      begin
        Prot0('SMS bereits versendet (%s)', [StoerText]);
      end else
      begin
        OldStoerText := StoerText;
        Prot0('SMS: %s', [StoerText]);
        LbEmailTo.Items.Assign(LbStoerTo.Items);
        edEMailSubject.Text := StoerText;
        MeEmailText.Clear;
        edEMailAttach.Text := '';
        btnSend.Click;
      end;
    end else
    if not btnAutomatik.Down then
    begin
      Prot0('EMAIL keine Automatik - SmsStoerung(%s)', [StoerText]);
    end else
    if LbStoerTo.Items.Count = 0 then
    begin
      Prot0('EMAIL keine SMS-Empfänger - SmsStoerung(%s)', [StoerText]);
    end;
  end else
    Prot0('EMAIL nicht aktiv - SmsStoerung(%s)', [StoerText]);
end;

class function TFrmEMail.SendEMailTo(aSubject, aAttachFn: string; aText, aTo: TStrings): boolean;
//QSBT Avis
begin
  Result := false;
  if FrmEMAIL <> nil then with FrmEMAIL do
  begin
    if btnAutomatik.Down then  //and (LbProtTo.Items.Count > 0) then
    begin
      if aTo.Count > 0 then
        LbEmailTo.Items.Assign(aTo) else
        LbEmailTo.Items.Assign(LbProtTo.Items);
      if LbEmailTo.Items.Count > 0 then
      begin
        edEMailSubject.Text := aSubject;
        MeProtText.HandleNeeded;
        MeEmailText.Lines.Assign(aText);
        edEMailAttach.Text := aAttachFn;
        btnSend.Click;
        Result := EmailSendKmp.SendOK;
      end;
    end;
  end else
    Prot0('EMAIL nicht aktiv - SendEMailTo(%s|%s|%s)', [aSubject, aText.CommaText, aTo.CommaText]);
end;

procedure TFrmEMail.FormCreate(Sender: TObject);
var
  ADevice: TDevice;
begin
  FrmEMail := self;
  LoadFromIni;
  ADevice := TDevice(InitData);
  if ADevice <> nil then
  begin                 {Datenbankeinstellungen überschreiben INI-Einstellungen}
    Nav.PollInterval := GetStringsInteger(ADevice.Text, 'PollInterval', Nav.PollInterval); {10000}
    btnAutomatik.Down := GetStringsBool(ADevice.Text, 'Auto', true);
    ChbStartSMS.Checked := GetStringsBool(ADevice.Text, 'StartSMS', chbStartSMS.Checked);

    //13.02.14
    CheckBoxSetChecked(chbEMAI, GetStringsBool(ADevice.Text, 'EMAI', false));

    SetEdText(EdPollInterval, IntToStr(Nav.PollInterval));  //immer mit Change-Event
  end;
  if ChbStartSms.Checked then
    SmsStoerung(Format('%s V%s wurde gestartet', [FrmMain.Caption, MainFrm.Version]));
  chbEMAIClick(Sender);
end;

procedure TFrmEMail.chbEMAIClick(Sender: TObject);
begin
  if chbEMAI.Checked then
  try
    LDataSource1.DataSet := Query1;
    LuEMAIProt.DataSet := TblEMAIProt;
    Nav.TableName := Nav.TableName;          //SQL usw. booten
    LuEMAIProt.TableName := LuEMAIProt.TableName;
    Nav.NavLink.LoadedRequestLive := true;
    Query1.RequestLive := true;
  except on E:Exception do
    EProt(self, E, 'Fehler bei EMAI Table zuweisen', [0]);
  end else
  begin
    LDataSource1.DataSet := nil;
    LuEMAIProt.DataSet := nil;
  end;
end;

procedure TFrmEMail.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //nein, wir wollen von außerhalb zur Laufzeit die .INI ändern
  //  SaveToIni;
end;

procedure TFrmEMail.LoadFromIni;
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Clear;
    IniKmp.ReadSectionStrings(Kurz + '.' + LbProtTo.Name, L);
    if L.Text <> '' then
      LbProtTo.Items.Assign(L);
    edProtSubject.Text := IniKmp.ReadString(Kurz, edProtSubject.Name, edProtSubject.Text);

    L.Clear;
    IniKmp.ReadSectionStrings(Kurz + '.' + LbStoerTo.Name, L);
    if L.Text <> '' then
      LbStoerTo.Items.Assign(L);

    //SMS Gruppen (AKW) -> sEMAIL_GRUPPEN<WerkNr>
    L.Clear;
    IniKmp.ReadSectionValues(sEMAIL_GRUPPEN + SysParam.WerkNr, L);
    if L.Text <> '' then
      LbSmsHandy.Items.Assign(L);

    L.Clear;
    MeProtText.HandleNeeded;
    IniKmp.ReadSectionStrings(Kurz + '.' + MeProtText.Name, L);
    if L.Text <> '' then
      MeProtText.Lines.Assign(L);

    LbEmailTo.Items.Assign(LbProtTo.Items);

    btnAutomatik.Down := IniKmp.ReadBool(Kurz, 'Auto', true);
    ChbStartSMS.Checked := IniKmp.ReadBool(Kurz, 'StartSMS', ChbStartSMS.Checked);
    EdPollInterval.Text := IniKmp.ReadString(Kurz, EdPollInterval.Name, IntToStr(Nav.PollInterval));

    EdOutBox.Text := IniKmp.ReadString(Kurz, EdOutBox.Name, EdOutBox.Text);
    EdUserEmail.Text := IniKmp.ReadString(Kurz, EdUserEmail.Name, EdUserEmail.Text);

    EdSMTPServer.Text := IniKmp.ReadString(Kurz, EdSMTPServer.Name, EdSMTPServer.Text);
    EdSMTPPort.Text := IniKmp.ReadString(Kurz, EdSMTPPort.Name, EdSMTPPort.Text);
    edSMTPAccount.Text := IniKmp.ReadString(Kurz, edSMTPAccount.Name, edSMTPAccount.Text);
    edSMTPPassword.Text := String(DecryptPassw(AnsiString(IniKmp.ReadString(Kurz, edSMTPPassword.Name, edSMTPPassword.Text))));

    ChbSMTP.Checked := IniKmp.ReadBool(Kurz, ChbSMTP.Name, ChbSMTP.Checked);  //ab 19.07.10

    SaveConfigFile;  //INI nach OutBox für SendMailServer
  finally
    L.Free;
  end;
end;

procedure TFrmEMail.SaveToIni;
begin
  IniKmp.SectionTyp[Kurz] := stMaschine;  //erst hier, um auch ANWENDUNG zu laden
  IniKmp.SectionTyp[Kurz + '.' + MeProtText.Name] := stMaschine;
  IniKmp.SectionTyp[Kurz + '.' + LbStoerTo.Name] := stMaschine;
  IniKmp.SectionTyp[Kurz + '.' + MeProtText.Name] := stMaschine;
  //SMS Gruppen (AKW)
  IniKmp.SectionTyp[sEMAIL_GRUPPEN + SysParam.WerkNr] := stAnwendung;

  IniKmp.WriteString(Kurz, edProtSubject.Name, edProtSubject.Text);
  IniKmp.WriteBool(Kurz, 'Auto', btnAutomatik.Down);
  IniKmp.WriteBool(Kurz, 'StartSMS', ChbStartSMS.Checked);
  IniKmp.WriteString(Kurz, EdPollInterval.Name, EdPollInterval.Text);

  IniKmp.EraseSection(Kurz + '.' + LbProtTo.Name);
  IniKmp.EraseSection(Kurz + '.' + LbStoerTo.Name);
  IniKmp.EraseSection(Kurz + '.' + MeProtText.Name);
  IniKmp.WriteSectionStrings(Kurz + '.' + LbProtTo.Name, LbProtTo.Items);
  IniKmp.WriteSectionStrings(Kurz + '.' + LbStoerTo.Name, LbStoerTo.Items);
  IniKmp.WriteSectionStrings(Kurz + '.' + MeProtText.Name, MeProtText.Lines);

  if not PrgParam.QsbtAKW then  //Akw: Emailgruppen (EMGR)
    IniKmp.WriteSection(sEMAIL_GRUPPEN + SysParam.WerkNr, LbSmsHandy.Items);

  IniKmp.WriteString(Kurz, EdOutBox.Name, EdOutBox.Text);
  IniKmp.WriteString(Kurz, EdUserEmail.Name, EdUserEmail.Text);

  IniKmp.WriteString(Kurz, EdSMTPServer.Name, EdSMTPServer.Text);
  IniKmp.WriteString(Kurz, EdSMTPPort.Name, EdSMTPPort.Text);
  IniKmp.WriteString(Kurz, edSMTPAccount.Name, edSMTPAccount.Text);
  IniKmp.WriteString(Kurz, edSMTPPassword.Name, String(EncryptPassw(AnsiString(edSMTPPassword.Text), 20)));

  IniKmp.WriteBool(Kurz, ChbSMTP.Name, ChbSMTP.Checked);  //ab 19.07.10

  SaveConfigFile;
end;

procedure TFrmEMail.SaveConfigFile;
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    if EdOutBox.Text <> '' then
    begin
      L.Values[EdOutBox.Name] := EdOutBox.Text;
      L.Values[EdSMTPServer.Name] := EdSMTPServer.Text;
      if EdSMTPServer.Text <> '' then
        L.Values[EdSMTPPort.Name] := EdSMTPPort.Text;
      L.Values[edSMTPAccount.Name] := edSMTPAccount.Text;
      L.Values[edSMTPPassword.Name] := edSMTPPassword.Text;
      L.Values[EdUserEmail.Name] := EdUserEmail.Text;
      L.SaveToFile(ValidDir(EdOutBox.Text) + 'EMAIL.INI');
      // Das File wird jetzt vom SendMailSvr gelesen und verwendet
    end;
  finally
    L.Free;
  end;
end;

procedure TFrmEMail.edPollIntervalChange(Sender: TObject);
begin
  Nav.PollInterval := StrToIntDef(EdPollInterval.Text, 5000);
end;

procedure TFrmEMail.FormResize(Sender: TObject);
begin
  MeProtText.Width := MeProtText.Parent.Width - MeProtText.Left - 8;
  MeProtText.Height := MeProtText.Parent.Height - MeProtText.Top - 8;
end;

procedure TFrmEMail.FormDestroy(Sender: TObject);
begin
  FrmEMail := nil;
end;

procedure TFrmEMail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caMinimize;
end;

procedure TFrmEMail.NavPostStart(Sender: TObject);
begin
  self.Minimize;
end;

procedure TFrmEMail.btnSendClick(Sender: TObject);
//var
//  FN: string;
//  Attach, NextS: string;
begin
  if EmailSendKmp.EmailOutbox = '' then
    EmailSendKmp.EmailOutbox := EdOutBox.Text;
  EmailSendKmp.EmailFrom := EdUserEmail.Text;
  EmailSendKmp.EmailTo := LbEmailTo.Items.CommaText;

  EmailSendKmp.SMTP := ChbSMTP.Checked;  //true = direkt per SMTP senden
  if ChbSMTP.Checked then
  begin
    EmailSendKmp.SmtpServer := EdSMTPServer.Text;
    EmailSendKmp.SmtpPort := StrToIntDef(EdSMTPPort.Text, 25);
    EmailSendKmp.SMTPAccount := edSMTPAccount.Text;
    EmailSendKmp.SMTPPassword := edSMTPPassword.Text;
    EmailSendKmp.SmtpAuth := Trim(edSMTPPassword.Text) <> '';
  end;

  //Subjekt ohne Umlaute. Würde sonst zu 'Abbruch wg. =?ISO-8859-1?Q?St=F6rung*BM-HU421?='
  EmailSendKmp.SendEMail(StrToIntl(RemoveCRLF(edEMailSubject.Text)),
    MeEmailText.Lines.Text, edEMailAttach.Text);
  if not EmailSendKmp.SendOK then
    Prot0('EMAIL Fehler bei Senden (%s)', [edEMailSubject.Text]);
end;

procedure TFrmEMail.NavPoll(Sender: TObject);
var
  L: TValueList;
  ErrNr: integer;
begin
  ErrNr := 1;
  L := nil;
  try
    if chbTerminate.Checked then
    begin
      ErrNr := 10;
      //PostMessage(self.Handle, WM_COMMAND, 0, BtnTerminate.Handle);
      Application.Terminate;
      ErrNr := 20;
      Exit;
    end;
    if EMGRFlag and (GNavigator.GetForm('EMGR') = nil) then
    try
      L := TValueList.Create;
      //SMS Gruppen (AKW) -> sEMAIL_GRUPPEN<WerkNr>
      L.Clear;
      IniKmp.ReadSectionValues(sEMAIL_GRUPPEN + SysParam.WerkNr, L);
      if L.Text <> '' then
        LbSmsHandy.Items.Assign(L);
    finally
      L.Free;
    end;
    ErrNr := 30;
    if btnAutomatik.Down and (LDataSource1.DataSet <> nil) and
       (Query1.State in [dsInactive, dsBrowse]) then
    begin
      ErrNr := 40;
      L := TValueList.Create;
      Query1.Close;
      Query1.Open;
      ErrNr := 50;
      if not Query1.EOF then
      try
        while not Query1.EOF do with Query1 do
        begin
          try
            ProtL('Sende EMail #%s', [FieldByName('EMAI_ID').AsString]);
            L.Clear;
            L.AddTokens(FieldByName('EMAI_TO').AsString, ',; ');
            if L.Count > 0 then
              LbEmailTo.Items.Assign(L) else
              LbEmailTo.Items.Assign(LbProtTo.Items);
            edEMailSubject.Text := FieldByName('EMAI_SUBJECT').AsString;
            MeEmailText.HandleNeeded;
            GetFieldStrings(FieldByName('EMAI_TEXT'), MeEmailText.Lines); //ist blob
            edEMailAttach.Text := FieldByName('EMAI_ATTACHMENTS').AsString;
            Nav.AssignValue('STATUS', 'J');
            Nav.DoEdit;
            InsertFieldLine(FieldByName('BEMERKUNG'), 0, Format('Postausgang - %s',
              [DateTimeToStr(now)]));
            ErrNr := 60;
            Nav.DoPost;
            btnSend.Click;
            SMess0;
          except on E:Exception do
            begin
              Query1.Cancel;
              EProt(self, E, 'Auftrag senden', [0]);
            end;
          end;
          Query1.Next;
        end;
        //Query1.Close;
        ErrNr := 70;
      finally
        L.Free;
        LuEMAIProt.NavLink.Refresh;
      end;
    end;
  except on E:Exception do  //Es tritt Bereichsfehler auf - 26.11.04
    begin
      EProt(self, E, 'EmailPoll:%d', [ErrNr]);
      chbTerminate.Checked := false;
      Application.Terminate;
    end;
  end;
end;

procedure TFrmEMail.btnEMailAttachClick(Sender: TObject);
begin
  with TOpenDialog.Create(self) do
  try
    FileName := edEMailAttach.Text;
    if Execute then
      edEMailAttach.Text := FileName;
  finally
    Free;
  end;
end;

procedure TFrmEMail.btnProtToClick(Sender: TObject);
begin
  if (LbProtTo.Items.IndexOf(EdProtTo.Text) < 0) and (EdProtTo.Text <> '') then
  begin
    LbProtTo.Items.Add(EdProtTo.Text);
  end;
  EdProtTo.Text := '';
end;

procedure TFrmEMail.BtnStoerEntfClick(Sender: TObject);
begin
  LbEntf(LbStoerTo);
end;

procedure TFrmEMail.LbEntf(aListbox: TListbox);
var
  iIndex: integer;
begin
  with aListbox do
  begin
    iIndex := ItemIndex;
    if iIndex <> -1 then
    begin
      Items.Delete(iIndex);
      if Items.Count > 0 then
        ItemIndex := iIndex;
    end else
    begin
      MessageBeep($FFFFFFFF);
      ItemIndex := 0;
      SetFocus;
    end;
  end;
end;

procedure TFrmEMail.LbDeleteDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (Sender is TListbox) then
  begin
    LbEntf(TListbox(Sender));
  end;
end;

procedure TFrmEMail.LbStoerToDblClick(Sender: TObject);
var
  iIndex: integer;
begin
  with TListbox(Sender) do
  begin
    iIndex := ItemIndex;
    if iIndex <> -1 then
    begin
      edStoerTo.Text := Items[iIndex];
    end else
    begin
      MessageBeep($FFFFFFFF);
      ItemIndex := 0;
      SetFocus;
    end;
  end;
end;

procedure TFrmEMail.btnCopyProtToClick(Sender: TObject);
begin
  lbEmailTo.Items.Assign(lbProtTo.Items);
end;

procedure TFrmEMail.BtnStoerToClick(Sender: TObject);
begin
  if (LbStoerTo.Items.IndexOf(EdStoerTo.Text) < 0) and (EdStoerTo.Text <> '') then
  begin
    LbStoerTo.Items.Add(EdStoerTo.Text);
  end;
  EdStoerTo.Text := '';
end;

procedure TFrmEMail.btnCopyStoerToClick(Sender: TObject);
begin
  if EdStoerTo.Text <> '' then
  begin  //nur eine Adresse testen
    lbEmailTo.Items.Clear;
    lbEmailTo.Items.Add(EdStoerTo.Text);
  end else
    lbEmailTo.Items.Assign(lbStoerTo.Items);
end;

procedure TFrmEMail.BtnTerminateClick(Sender: TObject);
begin
  chbTerminate.Checked := false;
  Application.Terminate;
end;

procedure TFrmEMail.BtnOutBoxClick(Sender: TObject);
begin
  with JvBrowseForFolderDialog do
  begin
    Title := LaOutBox.Caption;
    Directory := EdOutBox.Text;
    if Execute then
      EdOutBox.Text := Directory;
  end;
end;

procedure TFrmEMail.BtnOKClick(Sender: TObject);
begin
  SaveToIni;
end;

procedure TFrmEMail.BCEMaiTable(var Message: TMessage);
begin  //QUPE
  chbEMAI.Checked := Message.WParam <> 0;
  chbEMAIClick(self);
end;

procedure TFrmEMail.BitBtn1Click(Sender: TObject);
var
  I: integer;
begin
  for I := 1 to 200 do
  begin
    SMess('%d', [I]);
    //CreateUniqueFileName('c:\temp\Hallo#Y#M#D#H#N#S_#C.tmp');
    CreateUniqueFileName('c:\temp\Hallo_#C.tmp');
  end;
end;

procedure TFrmEMail.Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  clFont, clBrush: TColor;
begin       {für Mu1 und MuAbruf, MuStorno, MuZust2}
  if not (gdFocused in State) and
     not TMultiGrid(Sender).SelectedRows.CurrentRowSelected then
  begin
    with TMultiGrid(Sender).DataSource.DataSet, TMultiGrid(Sender).Canvas do
    begin
      clBrush := clWindow; //clBlack;
      clFont := clBlack;

      if EOF and BOF then
      begin
        {keine Daten}
      end else
      begin
        if FieldByName('STATUS').AsString = 'J' then
        begin
          clFont := clGreen;   //Postausgang
        end else
        if FieldByName('STATUS').AsString = 'F' then
        begin
          clFont := clRed;   //Fehler
        end;
      end;

      if Font.Color <> clFont then
        Font.Color := clFont;
      if Brush.Color <> clBrush then
        Brush.Color := clBrush;
    end;
  end;
end;

procedure TFrmEMail.MuEMAIDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  clFont, clBrush: TColor;
begin       {für Mu1 und MuAbruf, MuStorno, MuZust2}
  if not (gdFocused in State) and
     not TMultiGrid(Sender).SelectedRows.CurrentRowSelected then
  begin
    with TMultiGrid(Sender).DataSource.DataSet, TMultiGrid(Sender).Canvas do
    begin
      clBrush := clWindow; //clBlack;
      clFont := clBlack;

      if EOF and BOF then
      begin
        {keine Daten}
      end else
      begin
        if FieldByName('STATUS').AsString = 'F' then
        begin
          clFont := clRed;   //Fehler
        end;
      end;

      if Font.Color <> clFont then
        Font.Color := clFont;
      if Brush.Color <> clBrush then
        Brush.Color := clBrush;
    end;
  end;
end;

procedure TFrmEMail.NavBuildSql(DataSet: TDataSet; var OK,
  fertig: Boolean);
begin
debug0;
end;

procedure TFrmEMail.BtnEMGRClick(Sender: TObject);
begin
  if GNavigator.GetFormObj('EMGR', false, false) <> nil then
  begin
    GNavigator.StartFormShow(Application, 'EMGR');
    if GNavigator.GetForm('EMGR') <> nil then
      EMGRFlag := true;
  end;
end;

end.
