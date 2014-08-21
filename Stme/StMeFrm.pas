
unit StMeFrm;
(* Meldungen definieren
22.02.06 MD  Erstellt
30.07.08 MD  nach kmp\stme für webab
22.12.11 md  D2010, UniDAC. Datamodule weg.


---------------------
DB1 Database.Params muss Passwort usw. enthalten
LogonDlg:   for I := 0 to LoginParams.Count - 1 do          //für STMEFrm mit Thread
              Database.Params.Values[StrParam(LoginParams[I])] := StrValue(LoginParams[I]);


*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, Asws_Kmp, Radios, Dialogs, DatumDlg,
  nstimer, UDB__KMP, Menus, Zeitdlg, MemDS, DBAccess, Uni, UQue_Kmp;

type
  TAppPage = (apSQVA, apSBT, apKJU, apWEBAB);
var
  AppPage: TAppPage;    //Vorgabe für Nummernfilter Tabs

type
  PStmeData = ^TStmeData;
  TStmeData = record
                Nummer: string;
                Betr: string;
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
    Label19: TLabel;
    EdQuittiertSTME_ID: TDBEdit;
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
    EdFltrBETR_NR: TEdit;
    BtnTestStMe: TBitBtn;
    edFltrBEIN_NR: TEdit;
    cobBEIN_NR: TComboBox;
    GroupBox1: TGroupBox;
    pcStmeNr: TPageControl;
    BtnDetails: TBitBtn;
    tsSQVA: TTabSheet;
    ListBox5: TListBox;
    PanPopup: TPanel;
    chbPopup: TCheckBox;
    BtnEinstellungSpeichern: TBitBtn;
    cobEinstellungen: TComboBox;
    BtnEinstellungEntfernen: TBitBtn;
    Label9: TLabel;
    TblUsSe: TuQuery;
    LuUsSe: TLookUpDef;
    MuUsSe: TMultiGrid;
    tsSBT: TTabSheet;
    ListBox1: TListBox;
    tsKJU: TTabSheet;
    chbAddSTME_NR: TCheckBox;
    chbAddBEIN_NR: TCheckBox;
    LuBEIN_NR: TLookUpDef;
    TblBEIN_NR: TuQuery;
    lbKJU: TListBox;
    chbSortNr: TCheckBox;
    tsWebab: TTabSheet;
    lbWebab: TListBox;
    nbAuto: TNotebook;
    LaStatus: TLabel;
    BtnStop: TSpeedButton;
    Label23: TLabel;
    Label24: TLabel;
    EdAktuellDtm1: TEdit;
    BtnAktuellDtm1: TDatumBtn;
    UpDownAktuell: TUpDown;
    EdAktuellDtm2: TEdit;
    BtnAktuellDtm2: TDatumBtn;
    BtnAktuellTime: TTimeBtn;
    EdAktuellTime: TEdit;
    BtnAktuellRefresh: TSpeedButton;
    DbStme: TuDataBase;
    QueSTME: TuQuery;
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
    procedure EdFltrBETR_NRExit(Sender: TObject);
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
    procedure BtnTestStMeClick(Sender: TObject);
    procedure cobBEIN_NRChange(Sender: TObject);
    procedure BtnSendenClick(Sender: TObject);
    procedure NSTimerTimer(Sender: TComponent);
    procedure NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
    procedure BtnEinstellungSpeichernClick(Sender: TObject);
    procedure BtnEinstellungEntfernenClick(Sender: TObject);
    procedure cobEinstellungenChange(Sender: TObject);
    procedure cobSTME_NRDropDown(Sender: TObject);
    procedure cobBEIN_NRDropDown(Sender: TObject);
    procedure edFltrSTME_NRChange(Sender: TObject);
    procedure Query1BeforeScroll(DataSet: TDataSet);
    procedure Query1CalcFields(DataSet: TDataSet);
    procedure NavAfterPageChange(PageIndex: Integer);
    procedure BtnAktuellRefreshClick(Sender: TObject);
    procedure UpDownAktuellClick(Sender: TObject; Button: TUDBtnType);
    procedure EdAktuellChange(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
    NoStop: boolean;
    First: boolean;
    BtnMain: TBitBtn;   //Button auf FrmMain
    TI: TThreadInfo;
    TiOldCount: integer;
    LastID: integer;    //zuletzt geladene/quittierte Stme_Id
    InLoadFromIni: boolean;
    IncobEinstellungenChange: boolean;
    IsDevice: boolean;
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
  MainFrm, ParaFrm, DataFrm;
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
  FrmPara.OnFormCreate(self);            {Enabled=false, bgIntern.Visible=false}
  pcStmeNr.ActivePageIndex := ord(AppPage);
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
  cobBEIN_NR.Items.Clear;                {Prdg wird nicht mehr geändert}
  //cobFltrPrdg.Items.Add(''); {leer immer}
  ADevice := TDevice(InitData);
  IsDevice := ADevice <> nil;
  if not IsDevice then
  begin  //lokaler Aufruf (kein Device): kein Nachladen per Thread
    nbAuto.PageIndex := 1;
    EdAktuellDtm1.Text := DateToStr(Date);
  end else
  begin                 {Datenbankeinstellungen überschreiben INI-Einstellungen}
    nbAuto.PageIndex := 0;
    DbStme.AliasName := GNavigator.DB1.AliasName;
    DbStme.Params.Assign(GNavigator.DB1.Params);
    DbStme.DatabaseName := 'DB' + Kurz;
    QueSTME.DatabaseName := 'DB' + Kurz;
//    Dm := TDmStMe.Create(self);
//    Dm.Database1.AliasName := GNavigator.DB1.AliasName;
//    Dm.Database1.Params.Assign(GNavigator.DB1.Params);
//    Dm.Database1.DatabaseName := 'DB' + Kurz;
//    Dm.QueSTME.DatabaseName := 'DB' + Kurz;

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
    S := GetStringsString(ADevice.Text, 'BETR_NR', '');
    if S <> '' then
    begin
      edFltrBETR_NR.Text := GetStringsString(ADevice.Text, 'BETR_NR', edFltrBETR_NR.Text);
      edFltrBETR_NR.ReadOnly := true;
      edFltrBETR_NR.Hint := GetAppendTok(edFltrBETR_NR.Hint, SReadOnly, ' ');
    end;
    S := GetStringsString(ADevice.Text, 'BEIN_NR', '');
    if S <> '' then
    begin
      edFltrBEIN_NR.Text := GetStringsString(ADevice.Text, 'BEIN_NR', edFltrBEIN_NR.Text);
      edFltrBEIN_NR.ReadOnly := true;
      edFltrBEIN_NR.Hint := GetAppendTok(edFltrBEIN_NR.Hint, SReadOnly, ' ');
      cobBEIN_NR.Enabled := false;
    end;
    if Kurz = 'STME2' then
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
    if not edFltrBETR_NR.ReadOnly then
      edFltrBETR_NR.Text := IniKmp.ReadString(Sec, edFltrBETR_NR.Name, SysParam.WerkNr); //PrgParam.BetrFltr;
    if not edFltrBEIN_NR.ReadOnly then
      edFltrBEIN_NR.Text := IniKmp.ReadString(Sec, edFltrBEIN_NR.Name, edFltrBEIN_NR.Text);
    if not edFltrSTME_NR.ReadOnly then
      edFltrSTME_NR.Text := IniKmp.ReadString(Sec, edFltrSTME_NR.Name, edFltrSTME_NR.Text);

    chbSortNr.Checked := IniKmp.ReadBool(Sec, chbSortNr.Name, chbSortNr.Checked);
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
  IniKmp.WriteString(Sec, edFltrBETR_NR.Name, edFltrBETR_NR.Text);
  IniKmp.WriteString(Sec, edFltrBEIN_NR.Name, edFltrBEIN_NR.Text);
  IniKmp.WriteBool(Sec, chbSortNr.Name, chbSortNr.Checked);
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
  if WMessInput(BtnEinstellungSpeichern.Caption, cobEinstellungen.Hint, S) and
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
  if IsDevice then
  begin
    DbStme.Connect;  //muss außerhalb Thread passieren
    NSTimer.Enabled := true;
  end;
end;

procedure TFrmStMe.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
var
  S1: string;
begin
  Titel2 := DetailBook.Pages[DetailBook.PageIndex];
  S1 := Nav.FltrList.Values['STME_NR'];
  AppendTok(S1, Nav.FltrList.Values['BEIN_NR'], ' / ');
  AppendTok(S1, Nav.FltrList.Values['BETR_NR'], ' / ');
  Titel := Prots.SubCaption(Titel, S1);
end;

procedure TFrmStMe.PsAktuellBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  Nav.PageIndex := 0;
end;

procedure TFrmStMe.psQuittiertBeforePrn(Sender: TObject;
  var fertig: Boolean);
begin
  Nav.PageIndex := 2;
  TPrnSource(Sender).Caption := EdFltrDtm.Text;
end;

procedure TFrmStMe.psIgnoreBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  Nav.PageIndex := 1;
end;

procedure TFrmStMe.Quittieren;
begin
  with QueQuittieren do
  try
    ParamByName('STME_ID').AssignField(Query1.FieldByName('STME_ID'));
    ParamByName('QUITTIERT_AM').AsDateTime := now;
    ParamByName('QUITTIERT_VON').AsString := SysParam.UserName;
    Prots.QueryExecCommitted(QueQuittieren);
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
    Prots.QueryExecCommitted(QueAktivieren);
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
  if IsDevice then
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

procedure TFrmStMe.NavAfterPageChange(PageIndex: Integer);
begin
  //auch wenn query1.closed
  Nav.CheckAutoOpen(false);  //Benutzertable öffnen
end;

procedure TFrmStMe.DetailBookChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  if DetailBook.PageIndex = piEinstellungen then {alte Tab=Einstellungen}
  begin
    Nav.FltrList.Values['STME_NR'] := edFltrSTME_NR.Text;
    Nav.FltrList.Values['BETR_NR'] := edFltrBETR_NR.Text;
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

procedure TFrmStMe.EdFltrBETR_NRExit(Sender: TObject);
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
  //cobBEIN_NR.Items.Clear;

  BtnStop.Down := false;
  Nav.FltrList.Values['STME_NR'] := edFltrSTME_NR.Text;
  Nav.FltrList.Values['BETR_NR'] := edFltrBETR_NR.Text;
  Nav.FltrList.Values['BEIN_NR'] := edFltrBEIN_NR.Text;

  S := '';
  for I := 0 to lbIgnore.Items.Count - 1 do
    AppendTok(S, '<>' + lbIgnore.Items[I], '&');
  Nav.References.Values['STME_ID'] := S;

  if not IsDevice then
  begin
    if (EdAktuellDtm1.Text <> '') or (EdAktuellDtm2.Text <> '') or (EdAktuellTime.Text <> '') then
    begin
      Nav.References.Values['LIEGTAN_AM'] := ':DTM1..<:DTM2';
    end else
      Nav.References.Values['LIEGTAN_AM'] := '';
  end;
end;

procedure TFrmStMe.Query1AfterOpen(DataSet: TDataSet);
begin
  if IsDevice then
    PostMessage(self.Handle, WM_COMMAND, 0, BtnEnabled.Handle);
end;

procedure TFrmStMe.BtnEnabledClick(Sender: TObject);
begin
  if BtnMain <> nil then
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
      ParamByName('DTM1').AsDateTime := FloatMin(Dtm1, Dtm2);
    except end;
    if ParamCount >= 2 then
    try
      ParamByName('DTM2').DataType := ftDateTime;
      ParamByName('DTM2').AsDateTime := FloatMax(Dtm1, Dtm2);
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
  if chbAddSTME_NR.Checked then
    edFltrSTME_NR.Text := GetAppendUniqueTok(edFltrSTME_NR.Text, StrParam(cobSTME_NR.Text), ';', true)
  else
    edFltrSTME_NR.Text := StrParam(cobSTME_NR.Text);
end;

procedure TFrmStMe.cobSTME_NRDropDown(Sender: TObject);
var
  aLb: TListBox;
  I: integer;
begin
  aLb := pcStmeNr.ActivePage.Controls[0] as TListBox;
  //cobSTME_NR.Items.Assign(aLb.Items);
  cobSTME_NR.Items.Clear;
  cobSTME_NR.Items.BeginUpdate;
  try
    for I := 0 to aLb.Items.Count - 1 do
      if (StrParam(aLb.Items[I]) <> '') and (StrValue(aLb.Items[I]) <> '') then
        cobSTME_NR.Items.Add(aLb.Items[I]);
  finally
    if chbSortNr.Checked then
      SortStrings(cobSTME_NR.Items);
    cobSTME_NR.Items.EndUpdate;
  end;
end;

procedure TFrmStMe.cobBEIN_NRChange(Sender: TObject);
begin
  if chbAddBEIN_NR.Checked then
    edFltrBEIN_NR.Text := GetAppendUniqueTok(edFltrBEIN_NR.Text, StrParam(cobBEIN_NR.Text), ';', true)
  else
    edFltrBEIN_NR.Text := StrParam(cobBEIN_NR.Text);
end;

procedure TFrmStMe.edFltrSTME_NRChange(Sender: TObject);
begin
  cobBEIN_NR.Items.Clear;
end;

procedure TFrmStMe.cobBEIN_NRDropDown(Sender: TObject);
// lädt distinct Values von Datenbank
begin
  if cobBEIN_NR.Items.Count = 0 then
  begin
    cobBEIN_NR.Items.BeginUpdate;
    try
      LuBEIN_NR.References.Clear;
      //LuBEIN_NR.References.Assign(Nav.FltrList);
      LuBEIN_NR.References.Values['BEIN_NR'] := '';
      LuBEIN_NR.References.Values['QUITTIERT'] := 'N';
      LuBEIN_NR.References.Values['STME_NR'] := edFltrSTME_NR.Text;
      tblBEIN_NR.Open;
      while not tblBEIN_NR.EOF do
      begin
        cobBEIN_NR.Items.Add(tblBEIN_NR.Fields[0].AsString);
        tblBEIN_NR.Next;
      end;
    finally
      cobBEIN_NR.Items.EndUpdate;
    end;
  end;
end;

procedure TFrmStMe.BtnTestStMeClick(Sender: TObject);
var
  S, S1, S2, S3, NextS: string;
begin
  S1 := '9999';               {von Produktion an Disposition aktuelles Betr}
  if edFltrSTME_NR.Text <> '' then
    S2 := copy(edFltrSTME_NR.Text, 1, 6) else
    S2 := '230100';
  S3 := BtnTestStMe.Caption;
  S := S1 + ';' + S2 + ';' + S3;
  if WMessInput(BtnTestStMe.Caption, 'Herkunft;Ziel;Text', S) then
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
  if WMessInput(BtnSenden.Hint, 'Text', S) then
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
begin
  new(StmeData);
  try
    with StmeData^ do
    begin
      Nummer := Query1.FieldByName('STME_NR').AsString;
      Betr := Query1.FieldByName('BETR_NR').AsString;
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
  Meldung := Query1.FieldByName('STME_TEXT').AsString;
  { QUPE }
  SendMessage(FrmMain.Handle, BC_STME, stmeDblClick, LParam(PChar(Meldung)));
  { QUVA }
  //Auftragsnummer als Filterkriterium
  S1 := 'Auft. #';
  P1 := Pos(S1, Meldung);
  if P1 > 0 then
  begin
    Filter := 'AUFK_NR=' + copy(Meldung, P1 + length(S1), 10);
    SendMessage(FrmMain.Handle, BC_USER1, 0, LParam(PChar(Filter)));
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
    end;
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
      Betr := Query1.FieldByName('BETR_NR').AsString;
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

procedure TFrmStMe.NSTimerTimer(Sender: TComponent);
begin
  if TI.Aktiv then
  try
    NSTimer.Interval := StrToIntTol(EdWavSec.Text) * 1000;
    queSTME.Close;
    queSTME.SQL.Text := 'select count(*) from STME ' + TI.Where;
    queSTME.Open;
    TI.Count := queSTME.Fields[0].AsInteger;
    Inc(TI.OpenCount);
  except on E:Exception do
    TI.Message := E.Message;
  end;
end;

procedure TFrmStMe.NavBuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
var
  S, S1: string;
  P1, P2: integer;
  Dtm1, Dtm2, Zeit: TDateTime;
begin
  if IsDevice then
  begin
    //where Klausel für Timer bereitstellen
    S := Query1.SQL.Text;
    P1 := PosI('where', S);
    if P1 = 0 then
    begin
      S1 := '';
    end else
    begin
      P2 := Posi('order by', S);
      if P2 = 0 then
        P2 := Maxint;
      S1 := copy(S, P1, P2 - P1);
    end;
    TI.Where := S1;
  end else
  if TuQuery(DataSet).ParamCount = 2 then
  begin
    //Vorgabe: Dtm1..<Dtm2
    //alle blank -> keine Aktion
    //nur Dtm1 -> Dtm2=Dtm1+1
    //nur Dtm2 -> Dtm1=Date, Dtm2=Max(Dtm1+1, Dtm2)
    //nur Zeit -> Dtm1=Date, Dtm2=Date+Zeit
    //Dtm1+Dtm2 -> Max(Dtm1,Dtm2) += 1
    //Dtm1+Time -> Dtm2=Dtm1, Dtm1=Dtm1+Zeit
    //Dtm2+Time -> Dtm1=Date, Dtm2=Dtm2+Zeit

    Dtm1 := 0;
    Dtm2 := 0;
    Zeit := 0;
    if EdAktuellDtm1.Text <> '' then
      Dtm1 := StrToDate(EdAktuellDtm1.Text);
    if EdAktuellDtm2.Text <> '' then
      Dtm2 := StrToDate(EdAktuellDtm2.Text);
    if EdAktuellTime.Text <> '' then
      Zeit := StrToTime(EdAktuellTime.Text);

    if (Dtm1 > 0) and (Dtm2 > 0) and (Zeit > 0) then
    begin
      if Dtm1 > Dtm2 then
      begin                  //4.5. bis 3.5. 20:00 -> 0305T20:00..<0505T00:00
        Dtm1 := Dtm1 + 1;    //0505T00:00
        Dtm2 := Dtm2 + Zeit; //0305T20:00
      end else               //3.5. bis 4.5. 20:00 -> 0305T00:00..<0405T20:00:01
        Dtm2 := Dtm2 + Zeit + 1/SecsPerDay;
    end else
    if (Dtm1 > 0) and (Dtm2 = 0) and (Zeit = 0) then
    begin
      Dtm2 := Dtm1 + 1;
    end else
    if (Dtm1 = 0) and (Dtm2 > 0) and (Zeit = 0) then
    begin
      Dtm1 := Date;
      Dtm2 := FloatMax(Dtm1+1, Dtm2);
    end else
    if (Dtm1 = 0) and (Dtm2 = 0) and (Zeit > 0) then
    begin
      Dtm1 := Date;
      Dtm2 := Date + Zeit;
    end else
    if (Dtm1 > 0) and (Dtm2 > 0) and (Zeit = 0) then
    begin
      if Dtm1 > Dtm2 then
        Dtm1 := Dtm1 + 1 else
        Dtm2 := Dtm2 + 1;
    end else
    if (Dtm1 > 0) and (Dtm2 = 0) and (Zeit > 0) then
    begin
      Dtm2 := Dtm1;
      Dtm1 := Dtm1 + Zeit;
    end else
    if (Dtm1 = 0) and (Dtm2 > 0) and (Zeit > 0) then
    begin
      Dtm1 := Date;
      Dtm2 := Dtm2 + Zeit;
    end;

    with TuQuery(DataSet) do
    try
      ParamByName('DTM1').DataType := ftDateTime;
      ParamByName('DTM1').AsDateTime := FloatMin(Dtm1, Dtm2);
      ParamByName('DTM2').DataType := ftDateTime;
      ParamByName('DTM2').AsDateTime := FloatMax(Dtm1, Dtm2);
    except on E:Exception do
      EProt(self, E, 'STME BuildSql Aktuell', [0]);
    end;
  end;
end;

procedure TFrmStMe.Query1BeforeScroll(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmStMe.Query1CalcFields(DataSet: TDataSet);
begin
debug0;
end;

procedure TFrmStMe.BtnAktuellRefreshClick(Sender: TObject);
begin
  if BtnAktuellRefresh.Down then
  try
    Nav.SafeRefresh;
  finally
    BtnAktuellRefresh.Down := false;
    BtnAktuellRefresh.Flat := true;
  end;
end;

procedure TFrmStMe.UpDownAktuellClick(Sender: TObject; Button: TUDBtnType);
begin
  case Button of
    btNext: EdAktuellDtm1.Text := DateToStr(StrToDateTol(EdAktuellDtm1.Text) + 1);
    btPrev: EdAktuellDtm1.Text := DateToStr(StrToDateTol(EdAktuellDtm1.Text) - 1);
  end;
end;

procedure TFrmStMe.EdAktuellChange(Sender: TObject);
begin
  BtnAktuellRefresh.Flat := false;
end;

end.

