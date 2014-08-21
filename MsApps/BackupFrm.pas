unit BackupFrm;
(* MSSQL Datensicherung
   19.11.06 MD Erstellt (SQVA)
   09.12.09 MD ohne kopierfunktion. Mit Email. an Gruppe 'BACKUP'
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Zeitdlg, Qedi_kmp, TgridKmp, Xls,
  Dialogs, DPos_Kmp, DatumDlg, MuSiControlFr, qSplitter,
  qLab_kmp, Prots, Tools, parafrm;

type
  TFrmBACKUP = class(TqForm)
    Query1: TuQuery;
    Nav: TLNavigator;
    PageControl: TPageControl;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    tsAllgemein: TTabSheet;
    GroupBox1: TGroupBox;
    sbAllgemein: TScrollBox;
    Label76: TLabel;
    Label1: TLabel;
    EdZeit: TEdit;
    Label4: TLabel;
    EdFilename: TEdit;
    BtnStart: TBitBtn;
    cobIntervall: TComboBox;
    BtnZeit: TTimeBtn;
    Label2: TLabel;
    EdStartDT: TEdit;
    lbProt: TListBox;
    tsEinstellungen: TTabSheet;
    Label6: TLabel;
    BtnAuto: TSpeedButton;
    LaSQL: TStaticText;
    Label5: TLabel;
    EdMask: TEdit;
    Label3: TLabel;
    EdSQL: TEdit;
    Label7: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FileChange(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure NavPostStart(Sender: TObject);
    procedure NavPoll(Sender: TObject);
    procedure BtnAutoClick(Sender: TObject);
    procedure EdFilenameChange(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    InStart: boolean;
    fStartDT: TDateTime;
    fAuto: boolean;
    ADevice: TDevice;
    IsDevice: boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetStartDT(const Value: TDateTime);
    procedure SetAuto(const Value: boolean);
  public
    { Public-Deklarationen }
    property StartDT: TDateTime read fStartDT write SetStartDT;
    property Auto: boolean read fAuto write SetAuto;
  end;

var
  FrmBACKUP: TFrmBACKUP;

implementation
{$R *.DFM}
uses
  ShellAPI,
  GNav_Kmp, NLnk_Kmp, Ini__Kmp, Err__Kmp, USes_Kmp,
  AbortDlg, ShellTools,
  EMAIFrm;
  //mainfrm, DataFrm;

procedure TFrmBACKUP.FormCreate(Sender: TObject);
begin
  FrmBACKUP := self;
  FrmPara.OnFormCreate(self);            {Enabled=false, bgIntern.Visible=false}
  ADevice := TDevice(InitData);
  IsDevice := ADevice <> nil;
  LoadFromIni;
  if IsDevice then
  begin
    self.Caption := ADevice.Name;
    //Auto immer an in PostStart
    cobIntervall.ItemIndex := GetStringsInteger(ADevice.Text, 'Intervall', cobIntervall.ItemIndex);
    EdZeit.Text := GetStringsString(ADevice.Text, 'Zeit', EdZeit.Text);
    EdMask.Text := GetStringsString(ADevice.Text, 'Maske', EdMask.Text);

    cobIntervall.Enabled := false;
    EdZeit.ReadOnly := true;
    EdMask.ReadOnly := true;
  end;
end;

procedure TFrmBACKUP.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TFrmBACKUP.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);            {Bemerkung Größe}
end;

procedure TFrmBACKUP.FormDestroy(Sender: TObject);
begin
  FrmBACKUP := nil;
end;

procedure TFrmBACKUP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if IsDevice then
    Action := caMinimize else
    Action := caFree;
  if IsDevice then
    TFrmEMAI.StopClient;
end;

{ Anwendung }

procedure TFrmBACKUP.NavPostStart(Sender: TObject);
begin
  if ADevice <> nil then
  begin
    Auto := true;
    self.Minimize;
    TFrmEMAI.StartClient;
  end;
end;

procedure TFrmBACKUP.LoadFromIni;
begin
  cobIntervall.ItemIndex := IniKmp.ReadInteger(Kurz, cobIntervall.Name, 0);
  EdZeit.Text := IniKmp.ReadString(Kurz, EdZeit.Name, '02:15');
  EdMask.Text := IniKmp.ReadString(Kurz, EdMask.Name, EdMask.Text);
end;

procedure TFrmBACKUP.SaveToIni;
begin
  IniKmp.WriteInteger(Kurz, cobIntervall.Name, cobIntervall.ItemIndex);
  IniKmp.WriteString(Kurz, EdZeit.Name, EdZeit.Text);
  IniKmp.WriteString(Kurz, EdMask.Name, EdMask.Text);
end;

procedure TFrmBACKUP.EdFilenameChange(Sender: TObject);
var
  L: TValueList;
  S: string;
begin
  L := TValueList.Create;
  USession.GetAliasParams(GNavigator.DB1.AliasName, L);
  L.MergeStrings(GNavigator.DB1.Params);  {anderer User, Pasw.,..}

  S := L.Values['DATABASE NAME'];
  EdSQL.Text := StringReplace(LaSQL.Caption, '#D', S, [rfReplaceAll, rfIgnoreCase]);

  S := EdFilename.Text;
  EdSQL.Text := StringReplace(EdSQL.Text, '#F', S, [rfReplaceAll, rfIgnoreCase]);

  L.Free;
end;

procedure TFrmBACKUP.FileChange(Sender: TObject);
//EdZeit oder EdMask wurde geändert
var
  TheTime: TDateTime;
begin
  TheTime := StrToTime(EdZeit.Text);
  StartDT := Date + TheTime;
  if StartDT < now then
    StartDT := Date + 1 + TheTime;
end;

procedure TFrmBACKUP.SetStartDT(const Value: TDateTime);
var
  S, Mask: string;
begin
  fStartDT := Value;
  EdStartDT.Text := DateTimeToStr(Value);

  Mask := EdMask.Text;
  S := FormatDateTime('YYMMDD', fStartDT);
  Mask := StringReplace(Mask, '#D', S, [rfReplaceAll, rfIgnoreCase]);
  S := FormatDateTime('HHNN', fStartDT);
  Mask := StringReplace(Mask, '#Z', S, [rfReplaceAll, rfIgnoreCase]);
  //09.12.09:
  S := IntToStr(TagderWoche(fStartDT) + 1);  //1=Mo, 2=Di
  Mask := StringReplace(Mask, '#T', S, [rfReplaceAll, rfIgnoreCase]);
  EdFileName.Text := Mask;
end;

procedure TFrmBACKUP.BtnStartClick(Sender: TObject);
var
  OldLB: TListBox;
  IsError: boolean;
  S1, S2, BodyText: string;
  N1: integer;
begin
  if InStart then
    Exit;
  Nav.SetTitel;
  OldLB := Prot.ListBox;
  Prot.ListBox := lbProt;
  BodyText := '';
  IsError := true;
  InStart := true;
  S2 := EdFileName.Text;
  try
    try
      Query1.SQL.Text := EdSQL.Text;  //Format(LaSQL.Caption, [EdFileName.Text]);
      Prot0('%s', [Query1.SQL.Text]);
      Query1.ExecSQL;  //beware QueryExecCommitted(Query1); kann nicht in Transaktion!
      Prot0('%s OK', [self.ShortCaption]);
      IsError := false;
    except on E:Exception do begin
        BodyText := E.Message;
        EProt(self, E, '%s', [self.ShortCaption]);
      end;
    end;
  finally
    Prot.ListBox := OldLB;
    StartDT := StartDT + 1;
    SaveToIni;
    InStart := false;
    Nav.SetTitel;
    if IsError then
    begin
      self.WindowState := wsNormal;
      self.BringToFront;
      S1 := 'Fehler';
    end else
    begin
      S1 := 'OK';
      N1 := lbProt.Items.Count;
      if N1 >= 2 then
      begin
        BodyText := lbProt.Items[N1 - 2] + CRLF + lbProt.Items[N1 - 1];
      end;
    end;
    TFrmEMAI.SendEMail(MailGroupSender, MailGroupBackup, '',
      Format('%s: %s', [LongCaption(self.Caption, ExtractFilename(S2)), S1]), BodyText, '');
  end;
end;

procedure TFrmBACKUP.SetAuto(const Value: boolean);
begin
  fAuto := Value;
  if BtnAuto.Down <> Value then
    BtnAuto.Down := Value;
  BtnStart.Enabled := not Value;
  Nav.SetTitel;
end;

procedure TFrmBACKUP.BtnAutoClick(Sender: TObject);
begin
  SetAuto(BtnAuto.Down);
end;

procedure TFrmBACKUP.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  if InStart then
    Titel2 := 'läuft ...' else
  if Auto then
    Titel2 := 'Automatik' else
    Titel2 := 'manuell';
end;

procedure TFrmBACKUP.NavPoll(Sender: TObject);
begin
  if Auto and (StartDT <= now) then
    PostMessage(self.Handle, WM_COMMAND, 0, BtnStart.Handle);
end;

end.
