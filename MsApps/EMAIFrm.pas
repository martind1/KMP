unit EMAIFrm;
(* E-Mails erstellen und versenden
   Client- und Servermodus

24.08.08 MD  erstellt
02.09.08 MD  Client-Server Comunikation um sofort zu senden
24.10.08 MD  ClearStats täglich
28.10.08 MD  Bug now -> Time
10.12.09 MD  webab

------------------------------------
Einstellung am Client
[Anwendung] [EmailServer] EdAppServer=<Host>

*)
{ TODO : Ignorelist plus Receiver, und in INI speichern (ToString) }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  nexcel,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  ComCtrls, Spin, qSplitter, MuSiFr, Gen__Kmp, Asws_Kmp, DPos_Kmp,
  DatumDlg, NXls_Kmp, Luedikmp, Lubtnkmp, IdBaseComponent,
  IdMessage, EmailSendKmp, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP, WSDDEKmp, Zeitdlg, IdExplicitTLSClientServerBase,
  IdSMTPBase;

const
  SEmailServer = 'EmailServer';  //Section

type
  TFrmEMAI = class(TqForm)
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    psDFLT: TPrnSource;
    PageControl: TPageControl;
    tsMulti: TTabSheet;
    Panel2: TPanel;
    btnFltr: TSpeedButton;
    cobFltr: TComboBox;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    tsAllgemein: TTabSheet;
    sbAllgemein: TScrollBox;
    GroupBox2: TGroupBox;
    edBEMERKUNG: TDBMemo;
    tsSystem: TTabSheet;
    SplitterIntern: TqSplitter;
    GbStatisitk: TGroupBox;
    ScrollBox3: TScrollBox;
    gbIntern: TGroupBox;
    ScrollBox4: TScrollBox;
    GroupBox1: TGroupBox;
    Label29: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    EdERFASST_VON: TDBEdit;
    EdERFASST_AM: TDBEdit;
    EdGEAENDERT_VON: TDBEdit;
    EdGEAENDERT_AM: TDBEdit;
    EdANZAHL_AENDERUNGEN: TDBEdit;
    edID: TDBEdit;
    Panel3: TPanel;
    TabControl: TTabControl;
    Label2: TLabel;
    edEMGR_FROM: TLookUpEdit;
    Mu1: TMultiGrid;
    edEMGR_TO: TLookUpEdit;
    Label1: TLabel;
    Label7: TLabel;
    edEMAI_SUBJECT: TDBEdit;
    Label3: TLabel;
    cobSENDE_STATUS: TAswComboBox;
    Label6: TLabel;
    edSENDE_DATUM: TDBEdit;
    Label9: TLabel;
    gbDevice: TGroupBox;
    BtnAuto: TSpeedButton;
    Label11: TLabel;
    EdStep: TEdit;
    cobStep: TComboBox;
    edSENDE_FEHLER: TDBEdit;
    Label13: TLabel;
    tsExcelabfragen: TTabSheet;
    LaStatus: TLabel;
    Label10: TLabel;
    EdWaitTime: TEdit;
    LuEMGR_S: TLookUpDef;
    TblEMGR_S: TuQuery;
    LuEMGR_R: TLookUpDef;
    TblEMGR_R: TuQuery;
    edEMAI_FROM: TLookUpEdit;
    edEMAI_TO: TLookUpEdit;
    BtnEMGR_FROM: TLookUpBtn;
    BtnEMGR_TO: TLookUpBtn;
    Label14: TLabel;
    edEMAI_TEXT: TDBMemo;
    qSplitter1: TqSplitter;
    Label15: TLabel;
    Label16: TLabel;
    gbQuelltext: TGroupBox;
    edEMAI_SOURCE: TDBMemo;
    Panel1: TPanel;
    BtnShowInOE: TBitBtn;
    lbStatus: TListBox;
    EmailSendKmp: TEmailSendKmp;
    tsEinstellungen: TTabSheet;
    SMTP: TIdSMTP;
    WsEmai: TWSDDE;
    LuKond: TLookUpDef;
    TblKond: TuQuery;
    Label18: TLabel;
    edRCP_LIST: TDBMemo;
    edEMAI_CC: TLookUpEdit;
    ScrollBox1: TScrollBox;
    gbSMTP: TGroupBox;
    lbAccount: TLabel;
    lbPassword: TLabel;
    Label4: TLabel;
    edSMTPAccount: TEdit;
    edSMTPPassword: TEdit;
    EdSMTPServer: TEdit;
    EdSMTPPort: TEdit;
    chbSmtpAuth: TCheckBox;
    chbSmtpAfterPop: TCheckBox;
    gbIgnoreDouble: TGroupBox;
    Label5: TLabel;
    Label8: TLabel;
    edIgnoreDoublesSecs: TEdit;
    chbIgnoreDoubles: TCheckBox;
    GroupBox3: TGroupBox;
    Label12: TLabel;
    EdAppServer: TEdit;
    EdAppPort: TEdit;
    GroupBox4: TGroupBox;
    Label17: TLabel;
    chbTexteLaden: TCheckBox;
    EdClearStatsTime: TEdit;
    BtnClearStatsTime: TTimeBtn;
    chbClearStatsStarted: TCheckBox;
    chbClearStatsAktiv: TCheckBox;
    BtnSaveToIni: TBitBtn;
    EdEMAI_ATTACHMENTS: TDBMemo;
    LuEMAI: TLookUpDef;
    TblEMAI: TuQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure NavPoll(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure BtnAutoClick(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure NavErfass(Sender: TObject);
    procedure NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure WsEmaiChange(Sender: TObject);
    procedure Query1AfterPost(DataSet: TDataSet);
    procedure BtnShowInOEClick(Sender: TObject);
    procedure BtnSaveToIniClick(Sender: TObject);
  private
    fStep: integer;
    fAuto: boolean;
    IgnoreList: TValueList;
    CloseAction: TCloseAction;
    //VEBPDate: TDateTime;  PringOrPay E-Mail senden: - 10.12.09 jetzt in ENAY
    function GetAuto: boolean;
    procedure SetAuto(const Value: boolean);
    function GetStep: integer;
    procedure SetStep(const Value: integer);
    function WaitTime: integer;
    procedure SetStatus(Bereich: integer; AText: string);
    procedure ProcessQuery;
    procedure IgnoreAdd(aName: string; aIdMsg: TIdMessage);
    function IgnoreCheck(aIdMsg: TIdMessage): boolean;
    procedure UpdateEmaiSource(ADataSet: TDataSet; WithBody: boolean);
    class function InternalSendEMail(aSenderGroup, aReceiverGroup, RcpList,
      aSubject, aText, aAttach: string; Cond: boolean): boolean;
    function ClearStatsAktiv: boolean;
    function ClearStatsTime: TDateTime;
    function GetClearStatsStarted: boolean;
    procedure SetClearStatsStarted(const Value: boolean);
    function IsEMAI_USER: boolean;
  protected
  private
    { Private-Deklarationen }
    IsDevice: boolean;
    WaitStart: integer;
    procedure LoadFromIni;
    procedure SaveToIni;

    property Auto: boolean read GetAuto write SetAuto;
    property Step: integer read GetStep write SetStep;
    property ClearStatsStarted: boolean read GetClearStatsStarted write SetClearStatsStarted;
  public
    { Public-Deklarationen }
    LastEmaiID: string;   //zuletzt gespeicherte ID
    class function SendEMail(aSenderGroup, aReceiverGroup, RcpList, aSubject, aText,
      aAttach: string): boolean;
    class function SendEMailCond(aSenderGroup, aReceiverGroup, RcpList, aSubject,
      aText, aAttach: string): boolean;
    class procedure StartClient;
    class procedure StopClient;
    class function ParseAdr(Adr: string; RcpList: TStrings): string;
  end;

var
  FrmEMAI: TFrmEMAI;
  FrmEMAI_USER: TFrmEMAI;

implementation
{$R *.DFM}
uses
  Dialogs,
  GNav_Kmp, Prots, Ini__Kmp, NLnk_Kmp, Err__Kmp, Tools,
  MainFrm, PARAFRM, FltrFrm, DataFrm;
const
  FormKurz = 'EMAI';
var
  InSendMail: boolean;  //Flag für Modus nur zum Senden  

{ ohne Klasse }

class procedure TFrmEMAI.StartClient;
// vorher starten, damit Initialisierung beendet ist, wenn erste Mail zu senden ist.
var
  aForm: TForm;
begin
  InSendMail := true;  //nur für Form Create!
  try
    if (FrmEMAI <> nil) and not FrmEMAI.chbTexteLaden.Checked then
      FrmEMAI.Release;
    if FrmEMAI = nil then
    begin
      aForm := FrmMain.ActiveMDIChild;
      GNavigator.StartFormShow(Application, 'EMAI', wsMinimized);
      FrmEMAI.EdWaitTime.Text := '0s';  //nicht pollen
      FrmEMAI.CloseAction := caMinimize;  //nicht beenden
      if aForm <> nil then
        aForm.SetFocus;
    end;
  finally
    InSendMail := false;
  end;
end;

class procedure TFrmEMAI.StopClient;
begin
  if FrmEMAI <> nil then
    FrmEMAI.Close;
end;

class function TFrmEMAI.SendEMailCond(aSenderGroup, aReceiverGroup, RcpList,
  aSubject, aText, aAttach: string): boolean;
begin
  Result := InternalSendEMail(aSenderGroup, aReceiverGroup, RcpList, aSubject, aText, aAttach, true);
end;

class function TFrmEMAI.SendEMail(aSenderGroup, aReceiverGroup, RcpList,
  aSubject, aText, aAttach: string): boolean;
begin
  Result := InternalSendEMail(aSenderGroup, aReceiverGroup, RcpList,
    aSubject, aText, aAttach, false);
end;

class function TFrmEMAI.InternalSendEMail(aSenderGroup, aReceiverGroup, RcpList,
  aSubject, aText, aAttach: string; Cond: boolean): boolean;
var
  Found: boolean;
begin
  Result := false;
  Prot0('%s SendEMail(%s,%s,%s,%s)', [FormKurz, aSenderGroup, aReceiverGroup, aSubject, aAttach]);
  StartClient;
  with FrmEMAI do
  try
    if Cond then
    begin
      LuKond.References.Clear;
      //beware wg ";" - LuKond.References.Values['EMAI_SUBJECT'] := StrDflt(aSubject, '0');
      LuKond.References.Values['EMAI_SUBJECT'] := ':EMAI_SUBJECT';
      TblKond.ParamByName('EMAI_SUBJECT').AsString := StrDflt(aSubject, '0');
      TblKond.Open;
      Found := not TblKond.EOF;
      TblKond.Close;
      if Found then
      begin
        ProtA('%s bereits vorhanden: %s', [Kurz, StrDflt(aSubject, '0')]);
        Exit;  //bereits vorhanden
      end;
    end;
    Nav.Navlink.Insert;  //kein Single
    Nav.AssignValue('EMGR_FROM', aSenderGroup);
    Nav.AssignValue('EMGR_TO', aReceiverGroup);
    Nav.AssignValue('RCP_LIST', RcpList);  //Platzhalter idF Name=Mailadresse(n) mit ';' getrennt
    Nav.AssignValue('EMAI_SUBJECT', aSubject);
    Nav.AssignValue('EMAI_TEXT', aText);
    Nav.AssignValue('EMAI_ATTACHMENTS', aAttach);  //mehrere mit ',' oder ';' trennen
    Nav.DoPost;
    LastEmaiID := Query1.FieldByName('EMAI_ID').AsString;
    Result := true;
  except
    Query1.Close;
    raise;
  end;
end;

{ Standard }

function TFrmEMAI.IsEMAI_USER: boolean;
begin
  Result := Kurz = 'EMAI_USER';
end;

procedure TFrmEMAI.FormCreate(Sender: TObject);
var
  ADevice: TDevice;
begin
  if IsEMAI_USER then
    FrmEMAI_USER := self else
    FrmEMAI := self;
  FrmPara.OnFormCreate(self);
  IgnoreList := TValueList.Create;
  try
    IsDevice := (InitData <> nil) and (TObject(InitData) is TDevice);
  except
    IsDevice := false;  //ist PChar
  end;
  LoadFromIni;  //liest IsDevice!
  if IsDevice then
  begin
    CloseAction := caMinimize;
    ADevice := TDevice(InitData);
    self.Caption := ADevice.Name;
    Auto := GetStringsBool(ADevice.Text, 'Auto', true);
    WsEmai.Remote := reHost;
    WsEmai.Port := StrToInt(Trim(EdAPPPort.Text));

    chbTexteLaden.Checked := true;  //notwendig bei Server
  end else
  begin
    CloseAction := caFree;
    Auto := false;
    WsEmai.Remote := reClient;
    WsEmai.Host := EdAPPServer.Text;
    WsEmai.Port := StrToInt(Trim(EdAPPPort.Text));
    if InSendMail then
    begin
      Nav.References.Values['EMAI_ID'] := '0';  //nicht alles laden
    end else
    if not chbTexteLaden.Checked then
    begin
      edEMAI_SOURCE.DataField := '';
      edEMAI_SOURCE.Visible := false;
      //edEMAI_TEXT.DataField := '';
      //edEMAI_TEXT.Visible := false;
      try
        Nav.SqlFieldList.Delete(Nav.SqlFieldList.IndexOf('EMAI_SOURCE'));
        //Nav.SqlFieldList.Delete(Nav.SqlFieldList.IndexOf('EMAI_TEXT'));
      except
      end;
    end;
  end;
  gbDevice.Visible := IsDevice;
end;

procedure TFrmEMAI.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TFrmEMAI.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmEMAI.FormDestroy(Sender: TObject);
begin
  IgnoreList.FreeObjects;
  if IsEMAI_USER then
    FrmEMAI_USER := nil else
    FrmEMAI := nil;
end;

procedure TFrmEMAI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := CloseAction;
//  if IsDevice then
//    Action := caMinimize else
//    Action := caFree;
end;

procedure TFrmEMAI.NavStart(Sender: TObject);
begin
  TFrmFltr.cobFltrInit(cobFltr);
end;

procedure TFrmEMAI.NavPostStart(Sender: TObject);
begin
  //10.02.10 entfernt self.BringToFront;
  edSENDE_FEHLER.Font.Color := clRed;
  if IsDevice then
    self.Minimize;
end;

procedure TFrmEMAI.btnFltrClick(Sender: TObject);
begin
  TSpeedButton(Sender).Down := false;
  TFrmFltr.LookUp(Kurz, Nav.NavLink, cobFltr.Text);
end;

procedure TFrmEMAI.cobFltrChange(Sender: TObject);
begin
  if FrmFltr = nil then Debug0;  //für Compiler
  TFrmFltr.cobFltrChange(Sender);
end;

{ Anwendung }

procedure TFrmEMAI.LoadFromIni;
begin
  EdSMTPServer.Text := IniKmp.ReadString(SEmailServer, EdSMTPServer.Name, EdSMTPServer.Text);
  EdSMTPPort.Text := IniKmp.ReadString(SEmailServer, EdSMTPPort.Name, EdSMTPPort.Text);
  chbSmtpAuth.Checked := IniKmp.ReadBool(SEmailServer, chbSmtpAuth.Name, chbSmtpAuth.Checked);
  chbSmtpAfterPop.Checked := IniKmp.ReadBool(SEmailServer, chbSmtpAfterPop.Name, chbSmtpAfterPop.Checked);
  edSMTPAccount.Text := IniKmp.ReadString(SEmailServer, edSMTPAccount.Name, edSMTPAccount.Text);
  edSMTPPassword.Text := String(DecryptPassw(AnsiString(IniKmp.ReadString(SEmailServer, edSMTPPassword.Name, edSMTPPassword.Text))));

  chbIgnoreDoubles.Checked := IniKmp.ReadBool(SEmailServer, chbIgnoreDoubles.Name, chbIgnoreDoubles.Checked);
  edIgnoreDoublesSecs.Text := IniKmp.ReadString(SEmailServer, edIgnoreDoublesSecs.Name, edIgnoreDoublesSecs.Text);

  if IsDevice then
    edWaitTime.Text := IniKmp.ReadString(SEmailServer, edWaitTime.Name, edWaitTime.Text) else
    edWaitTime.Text := IniKmp.ReadString(SEmailServer, edWaitTime.Name, '0s');

  EdAPPServer.Text := IniKmp.ReadString(SEmailServer, EdAPPServer.Name, EdAPPServer.Text);
  EdAPPPort.Text := IniKmp.ReadString(SEmailServer, EdAPPPort.Name, EdAPPPort.Text);

  if IsDevice or InSendMail then
    chbTexteLaden.Checked := true else
    chbTexteLaden.Checked := IniKmp.ReadBool(Kurz, chbTexteLaden.Name, chbTexteLaden.Checked); //false;

  chbClearStatsAktiv.Checked := IniKmp.ReadBool(Kurz, chbClearStatsAktiv.Name, chbClearStatsAktiv.Checked);
  chbClearStatsStarted.Checked := IniKmp.ReadBool(Kurz, chbClearStatsStarted.Name, chbClearStatsStarted.Checked);
  EdClearStatsTime.Text := IniKmp.ReadString(Kurz, EdClearStatsTime.Name, EdClearStatsTime.Text);
end;

procedure TFrmEMAI.SaveToIni;
begin
  IniKmp.WriteBool(Kurz, chbTexteLaden.Name, chbTexteLaden.Checked);

  IniKmp.WriteBool(Kurz, chbClearStatsAktiv.Name, chbClearStatsAktiv.Checked);
  IniKmp.WriteBool(Kurz, chbClearStatsStarted.Name, chbClearStatsStarted.Checked);
  IniKmp.WriteString(Kurz, EdClearStatsTime.Name, EdClearStatsTime.Text);
end;

procedure TFrmEMAI.BtnSaveToIniClick(Sender: TObject);
begin
  //Anwendungsweite Einstellungen
  IniKmp.SectionTyp[SEmailServer] := stAnwendung;

  IniKmp.WriteString(SEmailServer, EdSMTPServer.Name, EdSMTPServer.Text);
  IniKmp.WriteString(SEmailServer, EdSMTPPort.Name, EdSMTPPort.Text);
  IniKmp.WriteBool(SEmailServer, chbSmtpAuth.Name, chbSmtpAuth.Checked);
  IniKmp.WriteBool(SEmailServer, chbSmtpAfterPop.Name, chbSmtpAfterPop.Checked);
  IniKmp.WriteString(SEmailServer, edSMTPAccount.Name, edSMTPAccount.Text);
  IniKmp.WriteString(SEmailServer, edSMTPPassword.Name, String(EncryptPassw(AnsiString(edSMTPPassword.Text), 40)));

  IniKmp.WriteBool(SEmailServer, chbIgnoreDoubles.Name, chbIgnoreDoubles.Checked);
  IniKmp.WriteString(SEmailServer, edIgnoreDoublesSecs.Name, edIgnoreDoublesSecs.Text);

  IniKmp.WriteString(SEmailServer, edWaitTime.Name, edWaitTime.Text);

  IniKmp.WriteString(SEmailServer, EdAPPServer.Name, EdAPPServer.Text);
  IniKmp.WriteString(SEmailServer, EdAPPPort.Name, EdAPPPort.Text);

  //Userspezifisch
  SaveToIni;
end;

procedure TFrmEMAI.Mu1DrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  clFont, clBrush: TColor;
  fsStyle: TFontStyles;
begin
  if not (gdFocused in State) and
     not TMultiGrid(Sender).SelectedRows.CurrentRowSelected and
     (TMultiGrid(Sender).DataSource.DataSet.State = dsBrowse) then
  begin
    //rot=deleted
    with TMultiGrid(Sender).DataSource.DataSet, TMultiGrid(Sender).Canvas do
    begin
      clBrush := clWindow; //clBlack;
      clFont := clBlack;
      fsStyle := [];

      if FieldByName('SENDE_STATUS').AsString = Gesendet_Nein then
      begin
        clFont := clGreen;
      end else
      if FieldByName('SENDE_STATUS').AsString = Gesendet_Fehler then
      begin
        clFont := clRed;
      end;

      if Font.Style <> fsStyle then
        Font.Style := fsStyle;
      if Font.Color <> clFont then
        Font.Color := clFont;
      if Brush.Color <> clBrush then
        Brush.Color := clBrush;
    end;
  end;
end;

function TFrmEMAI.GetAuto: boolean;
begin
  Result := BtnAuto.Down;
  if fAuto <> Result then
  begin
    fAuto := Result;
    if Result then
    begin
    end else
    begin
    end;
  end;
end;

procedure TFrmEMAI.SetAuto(const Value: boolean);
begin
  BtnAuto.Down := Value;
  Nav.EditSingle := not Value;
end;

procedure TFrmEMAI.BtnAutoClick(Sender: TObject);
begin
  Nav.Refresh;
end;

function TFrmEMAI.GetStep: integer;
begin
  Result := fStep;
end;

procedure TFrmEMAI.SetStatus(Bereich: integer; AText: string);
// die Statusausgabe ist ein String mit mehreren Bereichen
var
  S: string;
  I: integer;
begin
  lbStatus.Items.Values[Format('%02.2d', [Bereich])] := AText;
  SortStrings(lbStatus.Items);
  S := '';
  for I := 0 to lbStatus.Items.Count - 1 do
    AppendTok(S, StrValue(lbStatus.Items[I]), '  ');
  if Copy(LaStatus.Caption,1,4) <> Copy(S,1,4) then
  begin
    Prot0('%s', [S]);
  end;
  LaStatus.Caption := S;
end;

function TFrmEMAI.WaitTime: integer;
begin
  try
    Result := StrToMSecs(EdWaitTime.Text);
  except
    Result := 0;
  end;
  if IsDevice and (Result < 3000) then
    Result := 3000;  //3s min
end;

procedure TFrmEMAI.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    FieldByName('SENDE_STATUS').AsString := Gesendet_Nein;
    FieldByName('EMAI_ID').Clear;
  end;
end;

class function TFrmEMAI.ParseAdr(Adr: string; RcpList: TStrings): string;
// ersetzt #Platzhalter durch Werte in RcpList idf #Platzhalter=Wert
// Adr enthält pro Adresse eine Zeile. Platzhalter müssen ALLEIN in einer Zeile stehen.
// auch für webab.SendMailDlg
var
  S1, NextS: string;
begin
  Result := '';
  S1 := PStrTok(Adr, CRLF, NextS);
  while S1 <> '' do
  begin
    if BeginsWith(S1, '#') then
      S1 := RcpList.Values[Trim(copy(S1, 2, MaxInt))];
    if Trim(S1) <> '' then
      AppendTok(Result, S1, ',');
    S1 := PStrTok('', CRLF, NextS);
  end;
  Result := StringReplace(Result, ';', ',', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TFrmEMAI.UpdateEmaiSource(ADataSet: TDataSet; WithBody: boolean);
//aktualisiert Mailsadressen von EMGR-Gruppen. Befüllt EmaiSource.
var
  RcpList: TStringList;

//  function ParseAdr(S: string): string;
//  var
//    S1, NextS: string;
//  begin
//    Result := '';
//    S1 := PStrTok(S, CRLF, NextS);
//    while S1 <> '' do
//    begin
//      if BeginsWith(S1, '#') then
//        S1 := RcpList.Values[Trim(copy(S1, 2, MaxInt))];
//      if Trim(S1) <> '' then
//        AppendTok(Result, S1, ',');
//      S1 := PStrTok('', CRLF, NextS);
//    end;
//    Result := StringReplace(Result, ';', ',', [rfReplaceAll, rfIgnoreCase]);
//  end;

var
  BS: TBlobStream;
begin
  TblEMGR_S.Open;
  if not TblEMGR_S.eof then
    LuEMGR_S.PutSOFields;
  TblEMGR_R.Open;
  if not TblEMGR_R.eof then
    LuEMGR_R.PutSOFields;

  RcpList := TStringList.Create;
  try
    with ADataSet do
    begin
      // RcpList Zeile: ZAHLER=abc@example.com
      // EMAI_TO Eintrag: #ZAHLER
      RcpList.Text := FieldByName('RCP_LIST').AsString;

      //22.09.11 auch Sender parsen (Webab Aufg E-Mail an Mitarbeiter #Sender)
      EmailSendKmp.EmailFrom := ParseAdr(FieldByName('EMAI_FROM').AsString, RcpList);

      EmailSendKmp.EmailTo := ParseAdr(FieldByName('EMAI_TO').AsString, RcpList);
      EmailSendKmp.EmailCC := ParseAdr(FieldByName('EMAI_CC').AsString, RcpList);
      if WithBody then
      begin
        EmailSendKmp.FillEMail(FieldByName('EMAI_SUBJECT').AsString,
                               FieldByName('EMAI_TEXT').AsString,
                               FieldByName('EMAI_ATTACHMENTS').AsString);
        BS := TBlobStream.Create(TBlobField(FieldByName('EMAI_SOURCE')), bmWrite);
        try
          EmailSendKmp.SaveToStream(BS);
        finally
          BS.Free;
        end;
      end;
    end;
  finally
    RcpList.Free;
  end;
end;


procedure TFrmEMAI.NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
begin
  with ADataSet do
  begin
    if FieldByName('SENDE_STATUS').AsString = Gesendet_Nein then
    begin
      if FieldByName('EMAI_ID').IsNull then
        FieldByName('EMAI_ID').AsInteger := FrmData.NEW_ID('EMAI_ID');  //_DEPO
      UpdateEmaiSource(ADataSet, true);

      //beware - EProt(self, E, 'Fehler bei Email ID %d', [FieldByName('EMAI_ID').AsInteger]);
    end;
  end;
end;

procedure TFrmEMAI.Query1AfterPost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if not IsDevice and
       (FieldByName('SENDE_STATUS').AsString = Gesendet_Nein) then
    begin
      WsEmai.Text := 'UPDATE=1';   //Server beanachrichtigen damit zeitnah gesendet wird
    end;
  end;
end;

procedure TFrmEMAI.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := not Auto;
  if not AllowChange then
    SMess('Detail nur bei ausgeschalteter Automatik', [0]);
end;

procedure TFrmEMAI.Query1BeforeOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if Auto then
    begin
      Nav.References.Clear;
      Nav.References.Values['SENDE_STATUS'] := Gesendet_Nein;
      // Valuelist für Anwendung
    end else
    begin
      Nav.References.Values['SENDE_STATUS'] := '';
      //warum? TFrmFltr.cobFltrChange(cobFltr);
    end;
  end;
end;

procedure TFrmEMAI.SetStep(const Value: integer);
begin
  if fStep <> Value then
  begin
    //zu vie log Prot0('%s SetStep %d <- %d', [Kurz, Value, fStep]);
    fStep := Value;
    //nein. Will echte Waitzeit haben! TicksReset(WaitStart);
    edStep.Text := Format('%d %s', [fStep, cobStep.Items.Values[IntToStr(Value)]]);
    Nav.Poll(0);  //sofort weitermachen
  end;
end;

procedure TFrmEMAI.NavPoll(Sender: TObject);
begin
  if not IsDevice then
  begin
    if WaitTime >= 3000 then
      if TicksCheck(WaitStart, WaitTime) then
        if Nav.nlState in [nlBrowse, nlInactive] then
          Nav.Navlink.ReLoad;
    Exit;
  end;
  if not Auto then
  begin
    Step := 0;
    Exit;
  end else
  if Step = 0 then  //mit sync
  begin
    Query1.Close;
    Step := 10;
  end;
  case Step of
  10:
  begin
    Query1.Open;
    Query1.First;
    if not Query1.EOF then
    begin
      Step := 20;
    end else
    begin
      Step := 30;
    end;
  end;
  20:
  begin
    if not Query1.EOF then
    begin
      try
        ProcessQuery;
      except on E:Exception do begin
          EProt(self, E, 'Fehler bei Poll', [0]);
          Query1.Cancel;
        end;
      end;
      Query1.Next;
    end else
    begin
      Step := 30;
    end;
  end;
  30: //wait
  begin
    // MSSQL täglich um 3Uhr bereinigen. Idee: Jede Stunde
    if ClearStatsAktiv then
    begin
      if not ClearStatsStarted and (Time >= ClearStatsTime) then
      begin
        ClearStatsStarted := true;
        SetStatus(1, 'drop statistics');
        FrmData.ClearStats;
      end else
      if Time < ClearStatsTime then
        ClearStatsStarted := false;  //neuer Tag
    end;
    (* PringOrPay E-Mail senden: - 10.12.09 jetzt in ENAY
    if VEBPDate <> Date then
    begin
      SetStatus(1, 'bring-or-pay Check');
      VEBPDate := Date;
      FrmData.CheckMailVEBP;
    end;
    *)
    SetStatus(1, Format('Wait %.1fs', [TicksRestTime(WaitStart, WaitTime) / 1000]));
    SetStatus(2, '');
    SetStatus(3, '');
    SetStatus(4, '');
    if TicksCheck(WaitStart, WaitTime) then
    begin
      Query1.Close;
      Step := 10;
    end;
  end;
  end; //case
end;

function TFrmEMAI.GetClearStatsStarted: boolean;
begin
  Result := chbClearStatsStarted.Checked;
end;

procedure TFrmEMAI.SetClearStatsStarted(const Value: boolean);
begin
  chbClearStatsStarted.Checked := Value;
  SaveToIni;
end;

function TFrmEMAI.ClearStatsAktiv: boolean;
begin
  Result := chbClearStatsAktiv.Checked;
end;

function TFrmEMAI.ClearStatsTime: TDateTime;
begin
  try
    Result := StrToTime(EdClearStatsTime.Text);
  except
    Result := EncodeTime(3, 0, 0, 0);
    EdClearStatsTime.Text := TimeToStr(Result);
  end;
end;

procedure TFrmEMAI.ProcessQuery;
// aktuellen Datensatz verarbeiten: EMail senden. Sendestatus setzen.
var
  BS: TBlobStream;
//  OldEncode: boolean;
begin
  with Query1 do
  begin
    ProtL('%s Process %s', [Kurz, FieldByName('EMAI_SUBJECT').AsString]);
    Nav.DoEdit;  //wichtig hier wg update
    UpdateEmaiSource(Query1, false);  //nur Empfänger aktualisieren
    BS := TBlobStream.Create(TBlobField(FieldByName('EMAI_SOURCE')), bmRead);
    try
      EmailSendKmp.LoadFromStream(BS);
    finally
      BS.Free;
    end;
    //13.05.12 senden über EmailSendKmp:
    EmailSendKmp.Smtp := true;
    EmailSendKmp.SmtpAuth := chbSmtpAuth.Checked;
    EmailSendKmp.SmtpAccount := edSMTPAccount.Text;
    EmailSendKmp.SmtpPassword := edSMTPPassword.Text;
    EmailSendKmp.SmtpServer := EdSMTPServer.Text;
    EmailSendKmp.SmtpPort := StrToIntDef(EdSMTPPort.Text, 25);  //GMail=587

//13.05.12 senden über EmailSendKmp
//    {authentication settings}
//    if chbSmtpAuth.Checked then
//      SMTP.AuthType := satDefault else //Indy10 {9=AuthenticationType=atLogin Simple Login}
//      SMTP.AuthType := satNone;
//    SMTP.Username := edSMTPAccount.Text;
//    SMTP.Password := edSMTPPassword.Text;
//    SMTP.MailAgent := ExtractFileName(Application.ExeName) + '@' + CompName; //X-Mailer
//    {General setup}
//    SMTP.Host := EdSMTPServer.Text;
//    SMTP.Port := StrToIntDef(EdSMTPPort.Text, 25);
//    {now we send the message}
//    ProtL('%s Connect SMTP %s', [Kurz, EdSMTPServer.Text]);
//    try
//      SMTP.Connect;
//    except on E:Exception do
//      EError('Fehler bei Connect SMTP %s:%d - %s', [SMTP.Host, SMTP.Port, E.Message]);
//    end;
    try
      Nav.Navlink.AssignDateTime('SENDE_DATUM', now);
      if IgnoreCheck(EmailSendKmp) then
      begin  //nicht senden da bereits gesendet
        Nav.AssignValue('SENDE_STATUS', Gesendet_Fehler);
        Nav.AssignValue('SENDE_FEHLER', 'ignoriert da bereits gesendet');
        Nav.DoPost;
      end else
      try
//13.05.12 senden über EmailSendKmp
//        Prot0('%s SMTPSend(%s)', [Kurz, EmailSendKmp.Subject]);
//        //Debug: EmailSendKmp.SaveToFile(TempDir + FieldByName('EMAI_ID').AsString + '.txt');
//        //OldEncode := EmailSendKmp.NoEncode;
//        //beware. keine Att. EmailSendKmp.NoEncode := true;  //bereits in SaveToFile
//        try
//          SMTP.Send(EmailSendKmp);
//        finally
//          //EmailSendKmp.NoEncode := OldEncode;
//        end;
        //13.05.12 senden über EmailSendKmp:
        Prot0('%s SMTP(%s:%d) "%s" an %s', [Kurz, EmailSendKmp.SmtpServer,
          EmailSendKmp.SmtpPort, EmailSendKmp.Subject, EmailSendKmp.EmailTo]);
        EmailSendKmp.SendSmtpMail;
        if not EmailSendKmp.SendOK then
          EError('%s', [EmailSendKmp.Filename]);

        Nav.AssignValue('SENDE_STATUS', Gesendet_Ja);
        Nav.AssignValue('SENDE_FEHLER', 'OK');
        Nav.DoPost;
        IgnoreAdd(FieldByName('EMAI_ID').AsString, EmailSendKmp);
      except on E:Exception do begin
          EProt(self, E, 'Fehler bei TFrmEMAI.ProcessQuery', [0]);
          Nav.AssignValue('SENDE_STATUS', Gesendet_Fehler);
          Nav.AssignValue('SENDE_FEHLER', E.Message);
          Nav.DoPost;
        end;
      end;
    finally
      ProtL('%s Disconnect SMTP %s', [Kurz, EdSMTPServer.Text]);
      SMTP.Disconnect;
    end;
  end;
end;

type
  TIgnore = class(TObject)
    Timestamp: TDateTime;
    From: string;
    EmailTo: string;
    Subject: string;
    function Equals(aIgnore: TIgnore): boolean; reintroduce;
    function ToString: string; reintroduce;
    constructor Create(S: string); overload;
  end;

constructor TIgnore.Create(S: string);
var
  S1, NextS: string;
begin
  S1 := PStrTok(S, '|', NextS);
  Timestamp := StrToFloatIntl(S1, true, 0);
  From := PStrTok('', '|', NextS);
  EmailTo := PStrTok('', '|', NextS);
  Subject := PStrTok('', '|', NextS);
end;

function TIgnore.ToString: string;
begin
  Result := Format('%s|%s|%s|%s', [FloatToStrIntl(Timestamp), From, EmailTo, Subject]);
end;

function TIgnore.Equals(aIgnore: TIgnore): boolean;
begin
  result := (self.From = aIgnore.From) and
            (self.EmailTo = aIgnore.EmailTo) and
            (self.Subject = aIgnore.Subject);
end;

function TFrmEMAI.IgnoreCheck(aIdMsg: TIdMessage): boolean;
//ergibt true wenn bereits gesendet. false wenn noch zu senden.
var
  IgnoreSecs: integer;
  NewIgnore, OldIgnore: TIgnore;
  I: integer;
  dt: TDateTime;
begin
  result := false;
  NewIgnore := nil;
  IgnoreSecs := StrToIntDef(edIgnoreDoublesSecs.Text, 0);
  if chbIgnoreDoubles.Checked and (IgnoreSecs > 0) then
  try
    NewIgnore := TIgnore.Create;
    NewIgnore.TimeStamp := aIdMsg.Date;  //Sekunden seit 1900
    NewIgnore.From := aIdMsg.From.Address;
    NewIgnore.EmailTo := aIdMsg.Recipients.EMailAddresses;
    NewIgnore.Subject := aIdMsg.Subject;
    for I := IgnoreList.Count - 1 downto 0 do
    begin
      OldIgnore := TIgnore(IgnoreList.Objects[I]);
      if OldIgnore.Equals(NewIgnore) then
      begin
        dt := NewIgnore.TimeStamp - OldIgnore.TimeStamp;
        if round(dt * SecsPerDay) > IgnoreSecs then
        begin
          IgnoreList.DeleteObjects(I);  //ist zu alt:löschen
        end else
        begin
          Prot0('%s ignore %s', [Kurz, NewIgnore.ToString]);
          result := true;  //ist bereits gesendet und neu genug
          break;
        end;
      end;
    end;
  finally
    NewIgnore.Free;
  end;
end;

procedure TFrmEMAI.IgnoreAdd(aName: string; aIdMsg: TIdMessage);
//merkt sich gesendete Mail. Nur wenn Option aktiviert.
var
  IgnoreSecs: integer;
  NewIgnore: TIgnore;
begin
  IgnoreSecs := StrToIntDef(edIgnoreDoublesSecs.Text, 0);
  if chbIgnoreDoubles.Checked and (IgnoreSecs > 0) then
  begin
    NewIgnore := TIgnore.Create;
    NewIgnore.TimeStamp := aIdMsg.Date;  //Sekunden seit 1900
    NewIgnore.From := aIdMsg.From.Address;
    NewIgnore.EmailTo := aIdMsg.Recipients.EMailAddresses;
    NewIgnore.Subject := aIdMsg.Subject;
    IgnoreList.AddObject(aName, NewIgnore);
  end;
end;

procedure TFrmEMAI.WsEmaiChange(Sender: TObject);
// Befehle: UPDATE=1
begin
  if IsDevice then
  begin
    if CompareText(StrParam(WsEmai.Text), 'UPDATE') = 0 then
    begin
      WaitStart := 0;
      Nav.Poll(0);
      WsEmai.Text := 'UPDATE=OK';
    end;
  end;
end;

procedure TFrmEMAI.BtnShowInOEClick(Sender: TObject);
var
  L: TStringList;
  S: string;
  AField: TField;
begin
  L := TStringList.Create;
  try
    AField := Query1.FindField('EMAI_SOURCE');
    if AField = nil then
    begin
      LuEMAI.References.Clear;
      LuEMAI.References.Values['EMAI_ID'] := IntToStr(Query1.FieldByName('EMAI_ID').AsInteger);
      TblEMAI.Open;
      AField := TblEMAI.FindField('EMAI_SOURCE');
    end;
    L.Assign(AField);
    TblEMAI.Close;
    S := CreateUniqueFileName(ValidDir(TempDir) + 'EMAI_#C.eml');
    L.SaveToFile(S);
    SysParam.DisplayWinExecError := true;
    ShellExecNoWait(S);
  finally
    L.Free;
  end;
end;

end.
