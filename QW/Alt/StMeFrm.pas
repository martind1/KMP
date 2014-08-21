unit StMeFrm;
(* Meldungen definieren
   22.02.01 MD Erstellt
   24.02.01 MD Filter auf Werk Nr
   08.04.01 MD QDispo
   30.06.01 MD Verwendeung von Thread und 2.Session: wieder weg da Thread-Fehler in VCL
   14.08.03 MD Zusammengeführt qdispo\stmefrm
   14.08.03 MD 2 Instanzen erlauben (STME und STME2). 2 Icons. Anfrage in Thread (ohne VCL)
               Nav.PollInterval fest auf 1000. NSTimer.Intervall einstellbar
   15.12.03 MD für alle Qw-Apps in kmp\qw
               Steuerung der Nummernfilter-Seite: StmeFrm.AppPage := appQUVA;
                                             oder StmeFrm.AppPage := appQDISPO;
                                             oder ...
   04.06.08 MD Rückmeldung bei Doppelklick: entweder BC_USER1 oder BC_STME, BC_STMEDATA
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Radios, Dialogs, DatumDlg,
  nstimer, UDB__KMP, Menus, StMeDm;

type
  TAppPage = (appQUVA, appQSBT, appQDISPO, appSDBL, appQUPE, appQPILOT);
var
  AppPage: TAppPage;    //Vorgabe für Nummernfilter Tabs

type
  PStmeData = ^TStmeData;
  TStmeData = record
                Nummer: string;
                Werk: string;
                Herkunft: string;
                Meldung: string;
                LiegtAn: string;
                Quittiert: string;
              end;

type
  TThreadInfo = record
                  Aktiv: boolean;   //true = Thread soll nachschlagen
                  Count: integer;   //(neue) Daten vorhanden
                  Where: string;    //where Clausel
                  Message: string;  //Fehlermeldung
                  OpenCount: integer;
                end;

type
  TFrmStMe = class(TqForm)
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsAktuell: TPrnSource;
    PageBook: TqNoteBook;
    ScrollBox1: TScrollBox;
    DetailBook: TTabbedNotebook;
    MuAktuell: TMultiGrid;
    MuQuittiert: TMultiGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    QueQuittieren: TuQuery;
    Label1: TLabel;
    Label4: TLabel;
    edSTME_NR: TDBEdit;
    edQUITTIERT: TDBEdit;
    BtnQuitt: TBitBtn;
    WavOpen: TOpenDialog;
    psQuittiert: TPrnSource;
    gbIntern: TGroupBox;
    lbIgnore: TListBox;
    BtnIgnore: TBitBtn;
    MuIgnore: TMultiGrid;
    Panel3: TPanel;
    Panel4: TPanel;
    BtnIgnQuitt: TBitBtn;
    LuQuittiert: TLookUpDef;
    TblQuittiert: TuQuery;
    LuIgnore: TLookUpDef;
    TblIgnore: TuQuery;
    BtnStop: TSpeedButton;
    LaStatus: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    BtnQuittAktivieren: TBitBtn;
    QueAktivieren: TuQuery;
    psIgnore: TPrnSource;
    Label7: TLabel;
    edFltrDtm: TEdit;
    BtnFltrDtm: TDatumBtn;
    BtnEnabled: TBitBtn;
    UpDownDtm: TUpDown;
    Label2: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edSTME_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    Label3: TLabel;
    Label17: TLabel;
    edFltrDtmBis: TEdit;
    btnFltrDtmBis: TDatumBtn;
    Label18: TLabel;
    edFltrTime: TEdit;
    BtnMuQuittiert: TBitBtn;
    PopupMenuUsSe: TPopupMenu;
    MiLogin: TMenuItem;
    MiLogout: TMenuItem;
    LuUsSe: TLookUpDef;
    TblUsSe: TuQuery;
    MuUsSe: TMultiGrid;
    Label19: TLabel;
    DBEdit1: TDBEdit;
    BtnSenden: TBitBtn;
    NSTimer: TNonSystemTimer;
    Label21: TLabel;
    edOpenCount: TEdit;
    Panel7: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label20: TLabel;
    EdWAV: TEdit;
    EdWavSec: TEdit;
    BtnWavOpen: TBitBtn;
    BtnWavTest: TBitBtn;
    cobSTME_NR: TComboBox;
    edFltrSTME_NR: TEdit;
    EdFltrWERK_NR: TEdit;
    BtnTestStMe: TBitBtn;
    edFltrBEIN_NR: TEdit;
    cobFltrPrdg: TComboBox;
    GroupBox1: TGroupBox;
    pageStmeNr: TPageControl;
    tsSDBL: TTabSheet;
    lbStMeNr: TListBox;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    TabSheet2: TTabSheet;
    ListBox2: TListBox;
    TabSheet3: TTabSheet;
    ListBox3: TListBox;
    TabSheet4: TTabSheet;
    ListBox4: TListBox;
    BtnDetails: TBitBtn;
    TabSheet5: TTabSheet;
    ListBox5: TListBox;
    PanPopup: TPanel;
    chbPopup: TCheckBox;
    BtnEinstellungSpeichern: TBitBtn;
    cobEinstellungen: TComboBox;
    BtnEinstellungEntfernen: TBitBtn;
    Label9: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PsAktuellBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure BtnQuittClick(Sender: TObject);
    procedure BtnWavOpenClick(Sender: TObject);
    procedure EdWavSecChange(Sender: TObject);
    procedure NavPoll(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnWavTestClick(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure cobSTME_NRChange(Sender: TObject);
    procedure psQuittiertBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure BtnIgnoreClick(Sender: TObject);
    procedure TblQuittiertBeforeOpen(DataSet: TDataSet);
    procedure TblIgnoreBeforeOpen(DataSet: TDataSet);
    procedure BtnIgnQuittClick(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure Query1AfterOpen(DataSet: TDataSet);
    procedure BtnQuittAktivierenClick(Sender: TObject);
    procedure NavPageChange(PageIndex: Integer);
    procedure psIgnoreBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure BtnFltrDtmClick(Sender: TObject);
    procedure BtnEnabledClick(Sender: TObject);
    procedure LuQuittiertBeforeQuery(ADataSet: TDataSet;
      var Done: Boolean);
    procedure LuIgnoreBeforeQuery(ADataSet: TDataSet; var Done: Boolean);
    procedure EdFltrWERK_NRExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure UpDownDtmClick(Sender: TObject; Button: TUDBtnType);
    procedure btnFltrDtmBisClick(Sender: TObject);
    procedure BtnMuQuittiertClick(Sender: TObject);
    procedure edFltrTimeChange(Sender: TObject);
    procedure LuQuittiertStateChange(Sender: TObject);
    procedure LuQuittiertBuildSql(DataSet: TDataSet; var OK,
      fertig: Boolean);
    procedure DetailBookChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure BtnDetailsClick(Sender: TObject);
    procedure MiLoginClick(Sender: TObject);
    procedure MiLogoutClick(Sender: TObject);
    procedure BtnTestStMeClick(Sender: TObject);
    procedure cobFltrPrdgChange(Sender: TObject);
    procedure BtnSendenClick(Sender: TObject);
    procedure NSTimerTimer(Sender: TComponent);
    procedure NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
    procedure BtnEinstellungSpeichernClick(Sender: TObject);
    procedure BtnEinstellungEntfernenClick(Sender: TObject);
    procedure cobEinstellungenChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    NoStop: boolean;
    First: boolean;
    BtnMain: TBitBtn;   //Button auf FrmMain
    IsDevice: boolean;
    TI: TThreadInfo;
    TiOldCount: integer;
    LastID: integer;    //zuletzt geladene/quittierte Stme_Id
    InLoadFromIni: boolean;
    IncobEinstellungenChange: boolean;
    Dm: TDmStme;
    procedure Quittieren;
    procedure SendPopup;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure BtnMainClick(Sender: TObject);
  public
    { Public-Deklarationen }
  end;

var
  FrmStMe: TFrmStMe;

implementation
{$R *.DFM}
uses
  ShellApi, MMSystem,
  GNav_Kmp, Prots, NLnk_Kmp, Ini__Kmp, Err__Kmp, Tools, Poll_Kmp, AbortDlg,
  MainFrm, ParaFrm, DataFrm, MENUFRM;
const
  piAktuell = 0;
  piIgnoriert = 1;
  piQuittiert = 2;
  piEinstellungen = 3;
  piBenutzer = 4;
  piSystem = 5;
const
  SEinstellungen = 'Einstellungen';

procedure TFrmStMe.FormCreate(Sender: TObject);
const
  SReadOnly = '(über Datenbank festgelegt)';
var
  ADevice: TDevice;
  I: integer;
  S: string;
begin
  FrmSTME := self;
  pageStmeNr.ActivePageIndex := ord(AppPage);
  First := true;
  MaxSizeable := true;
  LoadFromIni;

  EdWavSecChange(self);
  for I := 0 to cobSTME_NR.Items.Count - 1 do
    if edFltrSTME_NR.Text = StrParam(cobSTME_NR.Items[I]) then
    begin
      cobSTME_NR.ItemIndex := I;
      break;
    end;
  cobFltrPrdg.Items.Clear;                {Prdg wird nicht mehr geändert}
  cobFltrPrdg.Items.Add(''); {leer immer}
  ADevice := TDevice(InitData);
  IsDevice := ADevice <> nil;
  if not IsDevice then
  begin  //lokaler Aufruf (kein Device): kein Nachladen per Thread

  end else
  begin                 {Datenbankeinstellungen überschreiben INI-Einstellungen}
    Dm := TDmStMe.Create(self);
    Dm.Database1.AliasName := GNavigator.DB1.AliasName;
    Dm.Database1.Params.Assign(GNavigator.DB1.Params);
    Dm.Database1.DatabaseName := 'DB' + Kurz;
    Dm.QueSTME.DatabaseName := 'DB' + Kurz;
    //Nav.PollInterval := GetStringsInteger(ADevice.Text, 'PollInterval', Nav.PollInterval);
    //NSTimer.Interval := GetStringsInteger(ADevice.Text, 'PollInterval', NSTimer.Interval);
    //EdWAVSec.Text := IntToStr(NSTimer.Interval div 1000);
    S := GetStringsString(ADevice.Text, 'PollInterval', '');
    if S <> '' then
    begin
      EdWAVSec.Text := IntToStr(GetStringsInteger(ADevice.Text, 'PollInterval',
                              StrToInt(EdWAVSec.Text) * 1000) div 1000);
      EdWavSecChange(self);
      EdWAVSec.ReadOnly := true;
      EdWAVSec.Hint := GetAppendTok(EdWAVSec.Hint, SReadOnly, ' ');
    end;
    S := GetStringsString(ADevice.Text, 'WAV', '');
    if S <> '' then
    begin
      EdWAV.Text := GetStringsString(ADevice.Text, 'WAV', EdWAV.Text);
      EdWAV.ReadOnly := true;
      EdWAV.Hint := GetAppendTok(EdWAV.Hint, SReadOnly, ' ');
    end;
    S := GetStringsString(ADevice.Text, 'POPUP', '');
    if S <> '' then
    begin
      chbPopup.Checked := GetStringsBool(ADevice.Text, 'POPUP', false);
      panPopup.Enabled := false;
      chbPopup.Hint := GetAppendTok(chbPopup.Hint, SReadOnly, ' ');
    end;
    S := GetStringsString(ADevice.Text, 'STME_NR', '');
    if S <> '' then
    begin
      edFltrSTME_NR.Text := GetStringsString(ADevice.Text, 'STME_NR', edFltrSTME_NR.Text);
      edFltrSTME_NR.ReadOnly := true;
      edFltrSTME_NR.Hint := GetAppendTok(edFltrSTME_NR.Hint, SReadOnly, ' ');
      cobSTME_NR.Enabled := false;
    end;
    S := GetStringsString(ADevice.Text, 'WERK_NR', '');
    if S <> '' then
    begin
      edFltrWERK_NR.Text := GetStringsString(ADevice.Text, 'WERK_NR', edFltrWERK_NR.Text);
      edFltrWERK_NR.ReadOnly := true;
      edFltrWERK_NR.Hint := GetAppendTok(edFltrWERK_NR.Hint, SReadOnly, ' ');
    end;
    S := GetStringsString(ADevice.Text, 'BEIN_NR', '');
    if S <> '' then
    begin
      edFltrBEIN_NR.Text := GetStringsString(ADevice.Text, 'BEIN_NR', edFltrBEIN_NR.Text);
      edFltrBEIN_NR.ReadOnly := true;
      edFltrBEIN_NR.Hint := GetAppendTok(edFltrBEIN_NR.Hint, SReadOnly, ' ');
      cobFltrPrdg.Enabled := false;
    end;
    if Kurz = 'STME3' then
      BtnMain := FrmMain.BtnStMe3 else
    if (Kurz = 'STME2') or (Assigned(FrmMain.BtnStMe.OnClick)) then
      BtnMain := FrmMain.BtnStMe2 else
      BtnMain := FrmMain.BtnStMe;
    BtnMain.Visible := true;
    BtnMain.OnClick := BtnMainClick;
  end;  //IsDevice
  edFltrDtm.Text := DateToStr(Date);
end;

procedure TFrmStMe.BtnMainClick(Sender: TObject);
begin
  GNavigator.StartFormShow(Application, Kurz);
end;

procedure TFrmStMe.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TFrmStMe.FormDestroy(Sender: TObject);
begin
  if IsDevice then
  begin
    TI.Aktiv := false;
    Dm.Free;
    if (BtnMain <> nil) and (FrmMain <> nil) and not (csDestroying in FrmMain.ComponentState) then
    begin
      BtnMain.Visible := false;
      BtnMain.OnClick := nil;
    end;
  end;
  FrmSTME := nil;
end;

procedure TFrmStMe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not IsDevice then
  begin
    Action := caFree;
    Exit;
  end;
  BtnStop.Down := false;
  Closed := false;
  Action := caMinimize;
end;

procedure TFrmStMe.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
  {lbStMeNr.Width := lbStMeNr.Parent.Width -
                    (edFltrBEIN_NR.Left + edFltrBEIN_NR.Width + 16);}
end;

procedure TFrmStMe.LoadFromIni;
var
  Sec: string;
begin
  try
    InLoadFromIni := true;
    if not IncobEinstellungenChange then
    begin
      CobEinstellungen.Items.Clear;
      CobEinstellungen.Items.Add('');  //Leerzeile für alle
      IniKmp.ReadSection(Kurz + '.' + SEinstellungen, CobEinstellungen.Items);
      CobEinstellungen.Text := IniKmp.ReadString(Kurz, CobEinstellungen.Name, CobEinstellungen.Text);
    end;
    if CobEinstellungen.Text = '' then
      Sec := Kurz else
      Sec := Kurz + '.' + CobEinstellungen.Text;
    if not EdWAV.ReadOnly then
      EdWAV.Text := IniKmp.ReadString(Sec, EdWAV.Name, EdWAV.Text);
    if not EdWAVSec.ReadOnly then
      EdWAVSec.Text := IniKmp.ReadString(Sec, EdWAVSec.Name, EdWAVSec.Text);
    if panPopup.Enabled then
      chbPopup.Checked := IniKmp.ReadBool(Sec, chbPopup.Name, chbPopup.Checked);
    if not edFltrWERK_NR.ReadOnly then
      edFltrWERK_NR.Text := IniKmp.ReadString(Sec, edFltrWERK_NR.Name, SysParam.WerkNr); //PrgParam.WerkFltr;
    if not edFltrBEIN_NR.ReadOnly then
      edFltrBEIN_NR.Text := IniKmp.ReadString(Sec, edFltrBEIN_NR.Name, edFltrBEIN_NR.Text);
    if not edFltrSTME_NR.ReadOnly then
      edFltrSTME_NR.Text := IniKmp.ReadString(Sec, edFltrSTME_NR.Name, edFltrSTME_NR.Text);
  finally
    InLoadFromIni := false;
  end;
end;

procedure TFrmStMe.SaveToIni;
var
  Sec: string;
begin
  if CobEinstellungen.Text <> '' then
    IniKmp.WriteString(Kurz + '.' + SEinstellungen, CobEinstellungen.Text, '1');

  IniKmp.WriteString(Kurz, CobEinstellungen.Name, CobEinstellungen.Text);
  if (CobEinstellungen.Text = SEinstellungen) or
     ('X' + CobEinstellungen.Text <> StrToValidIdent('X' + CobEinstellungen.Text)) then
    EError('Name (%s) darf nicht verwendet werden', [CobEinstellungen.Text]);
  if CobEinstellungen.Text = '' then
    Sec := Kurz else
    Sec := Kurz + '.' + CobEinstellungen.Text;
  IniKmp.WriteString(Sec, EdWAV.Name, EdWAV.Text);
  IniKmp.WriteString(Sec, EdWAVSec.Name, EdWAVSec.Text);
  IniKmp.WriteString(Sec, edFltrSTME_NR.Name, edFltrSTME_NR.Text);
  IniKmp.WriteString(Sec, edFltrWERK_NR.Name, edFltrWERK_NR.Text);
  IniKmp.WriteString(Sec, edFltrBEIN_NR.Name, edFltrBEIN_NR.Text);
end;

procedure TFrmStMe.cobEinstellungenChange(Sender: TObject);
begin
  if not IncobEinstellungenChange and not InLoadFromIni then
  try
    IncobEinstellungenChange := true;
    IniKmp.WriteString(Kurz, CobEinstellungen.Name, CobEinstellungen.Text);
    LoadFromIni;
  finally
    IncobEinstellungenChange := false;
  end;
end;

procedure TFrmStMe.BtnEinstellungEntfernenClick(Sender: TObject);
var
  I: integer;
  S: string;
begin
  S := cobEinstellungen.Text;
  if S <> '' then
  begin
    I := cobEinstellungen.Items.IndexOf(S);
    if I >= 0 then
    begin
      //in INI entfernen. In cob entfernen. Einträge entfernen:Nein
      cobEinstellungen.Items.Delete(I);
      IniKmp.DeleteKey(Kurz + '.' + SEinstellungen, S);

      CobEinstellungen.Text := '';
      cobEinstellungenChange(Sender);
    end;
  end;
end;

procedure TFrmStMe.BtnEinstellungSpeichernClick(Sender: TObject);
var
  S: string;
begin
  S := cobEinstellungen.Text;
  if InputQuery(BtnEinstellungSpeichern.Caption, cobEinstellungen.Hint, S) and
     (S <> '') then
  begin
    if cobEinstellungen.Items.IndexOf(S) < 0 then
      cobEinstellungen.Items.Add(S);
    cobEinstellungen.Text := S;
    SaveToIni;
  end;
end;

procedure TFrmStMe.NavStart(Sender: TObject);
begin
  Query1.Open;
end;

procedure TFrmStMe.NavPostStart(Sender: TObject);
begin
  if not IsDevice then
    Exit;
  if BtnMain <> nil then
    BtnMain.Hint := ShortCaption;
  if First then
  begin
    First := false;
    WindowState := wsMinimized;
  end;
  //Database2.Open;
  NSTimer.Enabled := true;
end;

procedure TFrmStMe.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  Titel2 := DetailBook.Pages[DetailBook.PageIndex];
end;

procedure TFrmStMe.PsAktuellBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  Nav.PageIndex := 0;
  FrmMain.DfltMultiGrid := MuAktuell;
end;

procedure TFrmStMe.psQuittiertBeforePrn(Sender: TObject;
  var fertig: Boolean);
begin
  Nav.PageIndex := 2;
  FrmMain.DfltMultiGrid := MuQuittiert;
  TPrnSource(Sender).Caption := EdFltrDtm.Text;
end;

procedure TFrmStMe.psIgnoreBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  Nav.PageIndex := 1;
  FrmMain.DfltMultiGrid := MuIgnore;
end;

procedure TFrmStMe.Quittieren;
begin
  with QueQuittieren do
  try
    ParamByName('STME_ID').AssignField(Query1.FieldByName('STME_ID'));
    ParamByName('QUITTIERT_AM').AsDateTime := now;
    ParamByName('QUITTIERT_VON').AsString := SysParam.UserName;
    ExecSql;
    Dec(TI.Count);
    Dec(TiOldCount);
  except on E:Exception do
    EProt(QueQuittieren, E, 'Stoerung quittieren(ID:%d)',
      [Query1.FieldByName('STME_ID').AsInteger]);
  end;
end;

procedure TFrmStMe.BtnQuittClick(Sender: TObject);
var
  I, N: integer;
begin
  with MuAktuell, Query1, BtnQuitt do
  begin
    N := SelectedRows.Count;
    if N = 0 then
    begin
      Quittieren;
      Close;
      Open;
    end else
    try
      DisableControls;
      Open;
      First;
      I := 0;
      TDlgAbort.CreateDlg(Caption);
      while (I < N) and not TDlgAbort.Canceled do
      begin
        Bookmark := SelectedRows[I];
        Inc(I);
        TDlgAbort.GMessA(I, N);
        Quittieren;
      end;
    finally
      TDlgAbort.FreeDlg;
      SelectedRows.Clear;
      Close;
      EnableControls;
      Open;
    end;
  end;
end;

procedure TFrmStMe.BtnIgnoreClick(Sender: TObject);
var
  I, N: integer;
  procedure DoIt;
  begin
    lbIgnore.Items.Add(Query1.FieldByName('STME_ID').AsString);
    Dec(TI.Count);
    Dec(TiOldCount);
  end;
begin
  with MuAktuell, Query1, BtnIgnore do
  begin
    N := SelectedRows.Count;
    if N = 0 then
    begin
      DoIt;
      Close;
      Open;
    end else
    try
      DisableControls;
      Open;
      First;
      I := 0;
      TDlgAbort.CreateDlg(Caption);
      while (I < N) and not TDlgAbort.Canceled do
      begin
        Bookmark := SelectedRows[I];
        Inc(I);
        TDlgAbort.GMessA(I, N);
        DoIt;
      end;
    finally
      TDlgAbort.FreeDlg;
      SelectedRows.Clear;
      Close;
      EnableControls;
      Open;
    end;
  end;
end;

procedure TFrmStMe.BtnIgnQuittClick(Sender: TObject);
var
  I, N: integer;
  procedure DoIt;
  var
    I: integer;
  begin
    I := lbIgnore.Items.IndexOf(TblIgnore.FieldByName('STME_ID').AsString);
    if I >= 0 then
      lbIgnore.Items.Delete(I);
  end;
begin
  with MuIgnore, TblIgnore, BtnIgnQuitt do
  begin
    N := SelectedRows.Count;
    if N = 0 then
    begin
      DoIt;
      Close;
      Open;
    end else
    try
      DisableControls;
      Open;
      First;
      I := 0;
      TDlgAbort.CreateDlg(Caption);
      while (I < N) and not TDlgAbort.Canceled do
      begin
        Bookmark := SelectedRows[I];
        Inc(I);
        TDlgAbort.GMessA(I, N);
        DoIt;
      end;
    finally
      TDlgAbort.FreeDlg;
      SelectedRows.Clear;
      Close;
      EnableControls;
      Open;
    end;
  end;
end;

procedure TFrmStMe.BtnQuittAktivierenClick(Sender: TObject);
var
  I, N: integer;
  procedure DoIt;
  begin
    QueAktivieren.ParamByName('STME_ID').AssignField(
      TblQuittiert.FieldByName('STME_ID'));
    QueAktivieren.ExecSql;
  end;
begin
  with MuQuittiert, TblQuittiert, BtnQuittAktivieren do
  begin
    N := SelectedRows.Count;
    if N = 0 then
    begin
      DoIt;
      Close;
      Open;
    end else
    try
      DisableControls;
      Open;
      First;
      I := 0;
      TDlgAbort.CreateDlg(Caption);
      while (I < N) and not TDlgAbort.Canceled do
      begin
        Bookmark := SelectedRows[I];
        Inc(I);
        TDlgAbort.GMessA(I, N);
        DoIt;
      end;
    finally
      TDlgAbort.FreeDlg;
      SelectedRows.Clear;
      Close;
      EnableControls;
      Open;
    end;
  end;
end;

procedure TFrmStMe.BtnWavOpenClick(Sender: TObject);
begin
  with WavOpen do
  begin
    FileName := EdWav.Text;
    if Execute then
      EdWav.Text := FileName;
  end;
end;

procedure TFrmStMe.EdWavSecChange(Sender: TObject);
begin
  //Nav.PollInterval := StrToIntTol(EdWavSec.Text) * 1000;
  //NSTimer.Interval := StrToIntTol(EdWavSec.Text) * 1000;
  NSTimer.Interval := 100;
end;

procedure TFrmStMe.NavPageChange(PageIndex: Integer);
begin
{  if PageIndex <= 2 then
    Query1.Active := PageIndex = 0;}
  if PageIndex = piAktuell then
  begin
    if IsDevice then
    begin
      BtnStop.Down := false;
      PollKmp.Sleep(Nav.DoPoll, Nav, 0);  {gleich ausführen}
      TiOldCount := -1;                   {gleich ausführen}
    end else
      Query1.Open;
  end;
  if PageIndex = piEinstellungen then   {quittiert}
  begin
    TblQuittiert.Close;
  end;
  if PageIndex = piBenutzer then   {User}
  begin
    Query1.Close;
  end;
end;

procedure TFrmStMe.DetailBookChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if DetailBook.PageIndex = piEinstellungen then {alte Tab=Einstellungen}
  begin
    Nav.FltrList.Values['STME_NR'] := edFltrSTME_NR.Text;
    Nav.FltrList.Values['WERK_NR'] := edFltrWERK_NR.Text;
    Nav.FltrList.Values['BEIN_NR'] := edFltrBEIN_NR.Text;
  end;
end;

procedure TFrmStMe.NavPoll(Sender: TObject);
var
  OldLock: boolean;
begin
  if not IsDevice then
    Exit;
  if NSTimer.Interval = 0 then
    Debug0;
  if ((Nav.PageIndex = piAktuell) and not BtnStop.Down) or
     (WindowState = wsMinimized) then
  begin
    TI.aktiv := true;
    OldLock := GNavigator.SMessLocked;
    if TiOldCount <> TI.Count then
    try
      GNavigator.SMessLocked := true;   {keine SMess}
      TiOldCount := TI.Count;
      NoStop := true;
      LaStatus.Caption := 'aktualisieren';
      LaStatus.Update;
      BtnMain.Enabled := not BtnMain.Enabled; //false;
      BtnMain.Update;
      //GNavigator.ProcessMessages;
      Nav.Refresh;                      {aktiviert   BtnMain}
      LaStatus.Caption := '';
      if not Query1.EOF then
      begin
        if Nav.PageIndex <> 0 then
          Nav.PageIndex := 0;
        {WindowState := wsNormal;
        BringToFront;
        SetFocus;}
        BtnWavTest.Click;
        if chbPopup.Checked and
           (LastID <> Query1.FieldByName('STME_ID').AsInteger) then
        try
          LastID := Query1.FieldByName('STME_ID').AsInteger;
          SendPopup;
        finally
          TiOldCount := 0;
          Quittieren;  //nur einmal Popup
        end;
      end;
    finally
      NoStop := false;
      GNavigator.SMessLocked := OldLock;
    end;
  end else
  begin
    TI.aktiv := false;
  end;
  //BtnMain.Enabled := TI.Count > 0;
  EdOpenCount.Text := IntToStr(TI.OpenCount);
  if TI.Message <> '' then
  begin
    Prot0('STME Thread:%s', [TI.Message]);
    TI.Message := '';
    ProtA('%s', [TI.Where]);
  end;
end;

procedure TFrmStMe.BtnWavTestClick(Sender: TObject);
begin
  if CompareText(EdWAV.Text, 'BEEP') = 0 then
    MessageBeep($FFFFFFFF) else
  if EdWAV.Text <> '' then
    SndPlaySound(PChar(EdWAV.Text), SND_ASYNC);
    {ShellExecute(Application.Handle, 'Play', PChar(EdWAV.Text), nil, nil,
      sw_Minimize);}
end;

procedure TFrmStMe.EdFltrWERK_NRExit(Sender: TObject);
begin
  Query1.Close;
end;

procedure TFrmStMe.LDataSource1DataChange(Sender: TObject; Field: TField);
begin
  if not NoStop then
    if ActiveControl = MuAktuell then
      BtnStop.Down := true;
end;

procedure TFrmStMe.Query1BeforeOpen(DataSet: TDataSet);
var
  I: integer;
  S: string;
begin
  BtnStop.Down := false;
  Nav.FltrList.Values['STME_NR'] := edFltrSTME_NR.Text;
  Nav.FltrList.Values['WERK_NR'] := edFltrWERK_NR.Text;
  Nav.FltrList.Values['BEIN_NR'] := edFltrBEIN_NR.Text;

  if Nav.FltrList.Values['STME_NR'] = '' then
    Nav.KeyFields := '' else        //wenn alles laden dann keine Sortierung da zu belastend
    Nav.KeyFields := 'STME_ID desc';

  S := '';
  for I := 0 to lbIgnore.Items.Count - 1 do
    AppendTok(S, '<>' + lbIgnore.Items[I], '&');
  Nav.References.Values['STME_ID'] := S;
end;

procedure TFrmStMe.Query1AfterOpen(DataSet: TDataSet);
begin
  if IsDevice then
    PostMessage(self.Handle, WM_COMMAND, 0, BtnEnabled.Handle);
end;

procedure TFrmStMe.BtnEnabledClick(Sender: TObject);
begin
  BtnMain.Enabled := not Query1.EOF;
end;

procedure TFrmStMe.LuQuittiertBeforeQuery(ADataSet: TDataSet;
  var Done: Boolean);
begin
  LuQuittiert.FltrList.Assign(LuQuittiert.References);
end;

procedure TFrmStMe.LuQuittiertStateChange(Sender: TObject);
begin
  BtnMuQuittiert.Visible := LuQuittiert.NavLink.nlState = nlInactive;
end;

procedure TFrmStMe.TblQuittiertBeforeOpen(DataSet: TDataSet);
begin
  LuQuittiert.References.Assign(Nav.FltrList);            {Einstellungen,Filter}
  LuQuittiert.References.MergeStrings(LuQuittiert.FltrList);       {von Suchen}
  LuQuittiert.References.Values['QUITTIERT'] := 'J';
  //LuQuittiert.References.Values['LIEGTAN_AM'] := EdFltrDtm.Text + '*'; {DateTime}
  LuQuittiert.References.Values['LIEGTAN_AM'] := ':DTM1..:DTM2';
end;

procedure TFrmStMe.LuQuittiertBuildSql(DataSet: TDataSet; var OK,
  fertig: Boolean);
var
  Dtm1, Dtm2: TDateTime;
begin
  Dtm1 := StrToDateTol(EdFltrDtm.Text);
  if edFltrTime.Text <> '' then
  begin
    if EdFltrDtmBis.Text = '' then
      Dtm2 := Dtm1 else
      Dtm2 := StrToDateTol(EdFltrDtmBis.Text);
    Dtm2 := Dtm2 + StrToTime(edFltrTime.Text);
  end else
  begin
    Dtm2 := StrToDateTol(EdFltrDtmBis.Text) + 1;
    if (EdFltrDtmBis.Text = '') or (Dtm2 < Dtm1 + 1) then
      Dtm2 := Dtm1 + 1;
  end;
  with TuQuery(DataSet) do
  begin
    if ParamCount >= 1 then
    try
      ParamByName('DTM1').DataType := ftDateTime;
      ParamByName('DTM1').AsDateTime := Dtm1;
    except end;
    if ParamCount >= 2 then
    try
      ParamByName('DTM2').DataType := ftDateTime;
      ParamByName('DTM2').AsDateTime := Dtm2;
    except end;
  end;
end;

procedure TFrmStMe.BtnMuQuittiertClick(Sender: TObject);
begin
  TblQuittiert.Open;
end;

procedure TFrmStMe.edFltrTimeChange(Sender: TObject);
begin
  EdFltrDtmBis.Text := '';
  TblQuittiert.Close;
end;

procedure TFrmStMe.btnFltrDtmBisClick(Sender: TObject);
begin
  if TDatumBtn(Sender).ModalResult <> mrOK then
    EdFltrDtmBis.Text := '';
  TblQuittiert.Close;
end;

procedure TFrmStMe.BtnFltrDtmClick(Sender: TObject);
begin
  if TDatumBtn(Sender).ModalResult <> mrOK then
    EdFltrDtm.Text := '';
  TblQuittiert.Close;
end;

procedure TFrmStMe.UpDownDtmClick(Sender: TObject; Button: TUDBtnType);
begin
  case Button of
    btNext: EdFltrDtm.Text := DateToStr(StrToDateTol(EdFltrDtm.Text) + 1);
    btPrev: EdFltrDtm.Text := DateToStr(StrToDateTol(EdFltrDtm.Text) - 1);
  end;
  if TblQuittiert.Active then
  begin
    TblQuittiert.Close;
    PostMessage(self.Handle, WM_COMMAND, 0, BtnMuQuittiert.Handle);
  end;
end;

procedure TFrmStMe.LuIgnoreBeforeQuery(ADataSet: TDataSet;
  var Done: Boolean);
begin
  LuIgnore.FltrList.Assign(LuIgnore.References);
end;

procedure TFrmStMe.TblIgnoreBeforeOpen(DataSet: TDataSet);
var
  I: integer;
  S: string;
begin
  LuIgnore.References.Assign(LuIgnore.FltrList);       {von Suchen}
  S := '';
  for I := 0 to lbIgnore.Items.Count - 1 do
    AppendTok(S, lbIgnore.Items[I], ';');
  if S = '' then
    S := '=';                           {nix finden}
  LuIgnore.References.Values['STME_ID'] := S;
  LuIgnore.References.Values['QUITTIERT'] := 'N';
end;

procedure TFrmStMe.cobSTME_NRChange(Sender: TObject);
begin
  edFltrSTME_NR.Text := StrParam(cobSTME_NR.Text);
end;

procedure TFrmStMe.cobFltrPrdgChange(Sender: TObject);
var
  S: string;
begin
  S := edFltrBEIN_NR.Text;
  AppendTok(S, copy(cobFltrPrdg.Text, 1, 8), ';');
  edFltrBEIN_NR.Text := S;
end;

procedure TFrmStMe.BtnTestStMeClick(Sender: TObject);
var
  S, S1, S2, S3, NextS: string;
begin
  S1 := '9999';               {von Produktion an Disposition aktuelles Werk}
  if edFltrSTME_NR.Text <> '' then
    S2 := copy(edFltrSTME_NR.Text, 1, 6) else
    S2 := '230100';
  S3 := BtnTestStMe.Caption;
  S := S1 + ';' + S2 + ';' + S3;
  if InputQuery(BtnTestStMe.Caption, 'Herkunft;Ziel;Text', S) then
  begin
    S1 := PStrTok(S, ';', NextS);
    S2 := PStrTok('', ';', NextS);
    S3 := PStrTok('', ';', NextS);
    FrmData.Meldung(StrToInt(S2), SysParam.WerkNr, S1, true, '%s', [S3]);
    self.Close;
  end;
end;

procedure TFrmStMe.BtnSendenClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if InputQuery(BtnSenden.Hint, 'Text', S) then
  begin
    FrmData.Meldung(230903, SysParam.WerkNr, Sysparam.UserName, true, '%s', [S]);
    self.Close;
  end;
end;

procedure TFrmStMe.BtnDetailsClick(Sender: TObject);
var
  Meldung : string;
  Filter : string;
  S1: string;
  P1: integer;
  StmeData: PStmeData;
  Done: boolean;
begin
  Done := false;
  (* QuVA alt
  Meldung := Query1.FieldByName('STME_TEXT').AsString;
  //Auftragsnummer als Filterkriterium
  if Pos('Auft. #', Meldung) > 0 then
  begin
    FrmMain.ListBoxFltr.Items.Clear;
    Filter := 'AUFK_NR = ' + copy(Meldung, Pos('Auft. #', Meldung) + 7, 10);
    FrmMain.ListBoxFltr.Items.Add(Filter);
    FrmMain.AuftTyp := 'F';
    GNavigator.StartForm(self, 'AUFK');
  end;
  if Pos('Kundenauft. = #', Meldung) > 0 then
  begin
    FrmMain.ListBoxFltr.Items.Clear;
    Filter := 'KUNW_NR = ' + copy(Meldung, Pos('Kundenauft. = #', Meldung) + 15, 10);
    FrmMain.ListBoxFltr.Items.Add(Filter);
    Filter := 'STATUS = J';
    FrmMain.ListBoxFltr.Items.Add(Filter);
    FrmMain.AuftTyp := 'F';
    GNavigator.StartForm(self, 'AUFK');
  end;*)
  Meldung := Query1.FieldByName('STME_TEXT').AsString;
  { QUVA }
  //Auftragsnummer als Filterkriterium
  S1 := 'Auft. #';
  P1 := Pos(S1, Meldung);
  if P1 > 0 then
  begin
    Filter := 'AUFK_NR=' + copy(Meldung, P1 + length(S1), 10);
    SendMessage(FrmMain.Handle, BC_USER1, 0, LParam(PChar(Filter)));
    Done := true;
  end else
  begin
    //Kundennummer als Filterkriterium für aktive Aufträge
    S1 := 'Kundenauft. = #';
    P1 := Pos(S1, Meldung);
    if P1 > 0 then
    begin
      Filter := 'KUNW_NR=' + copy(Meldung, P1 + length(S1), 10);
      AppendTok(Filter, 'STATUS = J', ';');
      SendMessage(FrmMain.Handle, BC_USER1, 0, LParam(PChar(Filter)));
      Done := true;
    end;
  end;
  if not Done then
  begin
    new(StmeData);
    try
      with StmeData^ do
      begin
        Nummer := Query1.FieldByName('STME_NR').AsString;
        Werk := Query1.FieldByName('WERK_NR').AsString;
        Herkunft := Query1.FieldByName('BEIN_NR').AsString;
        Meldung := Query1.FieldByName('STME_TEXT').AsString;
        LiegtAn := Query1.FieldByName('LIEGTAN').AsString;
        Quittiert := Query1.FieldByName('QUITTIERT').AsString;
      end;
      { QUPE, ChangeLog }
      SendMessage(FrmMain.Handle, BC_STMEDATA, stmeDetail, LParam(StmeData));
    finally
      Dispose(StmeData);
    end;
    { QUPE }
    SendMessage(FrmMain.Handle, BC_STME, stmeDblClick, LParam(PChar(Meldung)));
  end;
end;

procedure TFrmStMe.SendPopup;
//Aktuelle LastID an Anwendung melden.
var
  StmeData: PStmeData;
begin
  new(StmeData);
  try
    with StmeData^ do
    begin
      Nummer := Query1.FieldByName('STME_NR').AsString;
      Werk := Query1.FieldByName('WERK_NR').AsString;
      Herkunft := Query1.FieldByName('BEIN_NR').AsString;
      Meldung := Query1.FieldByName('STME_TEXT').AsString;
      LiegtAn := Query1.FieldByName('LIEGTAN').AsString;
      Quittiert := Query1.FieldByName('QUITTIERT').AsString;
    end;
    { QUPE, ChangeLog }
    SendMessage(FrmMain.Handle, BC_STMEPOPUP, LastID, LParam(StmeData));
  finally
    Dispose(StmeData);
  end;
end;

procedure TFrmStMe.MiLoginClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if InputQuery(TMenuItem(Sender).Caption, TMenuItem(Sender).Hint, S) then
  begin
    FrmData.Login(S);
    LuUsSe.Refresh;
  end;
end;

procedure TFrmStMe.MiLogoutClick(Sender: TObject);
var
  S: string;
begin
  S := TblUsSe.FieldByName('USER_NAME').AsString;
  if InputQuery(TMenuItem(Sender).Caption, TMenuItem(Sender).Hint, S) then
  begin
    FrmData.Logout(S);
    LuUsSe.Refresh;
  end;
end;

procedure TFrmStMe.NSTimerTimer(Sender: TComponent);
begin
  if TI.Aktiv then
  try
    NSTimer.Interval := StrToIntTol(EdWavSec.Text) * 1000;
    Dm.queSTME.Close;
    Dm.queSTME.SQL.Text := 'select  /*+ALL_ROWS */ count(*) from STOERMELDUNGEN ' + TI.Where;
    Dm.queSTME.Open;
    TI.Count := Dm.queSTME.Fields[0].AsInteger;
    Inc(TI.OpenCount);
  except on E:Exception do
    TI.Message := E.Message;
  end;
end;

procedure TFrmStMe.NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
var
  S, S1: string;
  P1, P2: integer;
begin
  //where Klausel für Timer bereitstellen
  S := Query1.SQL.Text;
  P1 := PosI('where', S);
  P2 := Posi('order by', S);
  S1 := copy(S, P1, P2 - P1);
  TI.Where := S1;
end;

procedure TFrmStMe.FormActivate(Sender: TObject);
begin
debug0;
end;

end.

