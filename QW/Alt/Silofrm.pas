unit Silofrm;
(* QSBT - Bunkerliste
26.10.05 MD  SMH:SIST
07.11.05     Nachlauf
07.07.12 md  Siloleistungen
             CalcField: LEIST_KNZ;LEIST_MIN;LEIST_MAX
             Datafield: cobSILO1_ANTEIL -> SILO1_LEIST
13.10.12 md  SMW: V_LABI_MK direkt anzeigen
             SMH Siebanlage: MV_LABI_ERGEBNISSE in eigener Notebook Page
26.10.12 md  Labi_ToSilo
29.11.12 md  SMH Siebsilos, Min/Maxleistung prüfen
02.12.12 md  SMH: Einstellungen, letzte 5, letzte LIMS-Probe, Test1-Probe
17.12.12 md  cob Anteile enthalten manchmal keinen Text -> edSILOx_ANTEIL
16.03.13 md  Labor SMH: Eigener manueller Filter. LABI_SILO_FILTER nur für SQL/Automat/Job.
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form,
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Spin, QSpin_kmp,
  MuSiFr, TgridKmp, qSplitter, UQue_Kmp, UPro_Kmp;

const
  SStruktur = 'Struktur';
  SSiebanteil = 'Siebanteil';
  SSectSiloAnwe = 'SILO.ANW';
const
  MaxLabiCount = 4;  //Anzahl Labi Filter/Produktkürzel

type
  TFrmSilo = class(TqForm)
    LuWerk: TLookUpDef;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    LuSilo1: TLookUpDef;
    LuSilo2: TLookUpDef;
    LuSilo3: TLookUpDef;
    LuGRSO: TLookUpDef;
    LuMARA: TLookUpDef;
    PageControl: TPageControl;
    Multi: TTabSheet;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    TabSheet1: TTabSheet;
    ScrollBox5: TScrollBox;
    Panel2: TPanel;
    TabSheet2: TTabSheet;
    ScrollBox4: TScrollBox;
    GbStatisitk: TGroupBox;
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
    edERFASST_DATENBANK: TDBEdit;
    edGEAENDERT_DATENBANK: TDBEdit;
    ScrollBox3: TScrollBox;
    Label6: TLabel;
    EdSPS_CODE: TDBEdit;
    chbKOMBI_KNZ: TAswCheckBox;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    LaAnteil: TLabel;
    LeSILO1_NR: TLookUpEdit;
    EdPos1: TEdit;
    EdPos2: TEdit;
    LeSILO2_NR: TLookUpEdit;
    EdSilo1_NAME: TDBEdit;
    BtnLuSilo1: TLookUpBtn;
    EdSILO2_NAME: TDBEdit;
    BtnLuSilo2: TLookUpBtn;
    tsAnlage: TTabSheet;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    edAKT_SORTE: TLookUpEdit;
    edAKT_FUELLUNG: TDBEdit;
    edAKT_TO: TDBEdit;
    Label3: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label21: TLabel;
    LeWERK_ID: TLookUpEdit;
    LeSILO1_ID: TLookUpEdit;
    LeSILO2_ID: TLookUpEdit;
    leSILO_GRSO_ID: TLookUpEdit;
    LeSILO3_ID: TLookUpEdit;
    Label17: TLabel;
    Label2: TLabel;
    EditSILO_NR: TDBEdit;
    EditSILO_NAME: TDBEdit;
    Panel3: TPanel;
    chbWerk: TCheckBox;
    Mu1: TMultiGrid;
    Label20: TLabel;
    edGRUNDSORTE: TLookUpEdit;
    BtnLuGsort: TLookUpBtn;
    Label22: TLabel;
    Label23: TLabel;
    edGESAMT_TO: TDBEdit;
    Label24: TLabel;
    edAKT_ENTW_ZEIT: TDBEdit;
    chbAKT_SPERRE_BAHN: TAswCheckBox;
    chbAKT_SPERRE_LKW: TAswCheckBox;
    edPRIO: TDBEdit;
    Label1: TLabel;
    Label9: TLabel;
    btnPRIO: TqSpin;
    Label5: TLabel;
    BtnLuWerk: TLookUpBtn;
    leSO_WERK_NR: TLookUpEdit;
    edWERK_NAME: TDBEdit;
    LuBEIN: TLookUpDef;
    panTROCKEN_FEUCHT: TPanel;
    rgTROCKEN_FEUCHT: TAswRadioGroup;
    chbAKT_RESERVIERT_TR: TAswCheckBox;
    Label12: TLabel;
    edAKT_STOERUNG: TDBEdit;
    Label13: TLabel;
    LuDiPr: TLookUpDef;
    TabSheet4: TTabSheet;
    MuDiPr: TMultiGrid;
    LuGRSO2: TLookUpDef;
    Label18: TLabel;
    edGRUNDSORTE2: TLookUpEdit;
    btnGRUNDSORTE2: TLookUpBtn;
    edSILO_GRSO2_ID: TLookUpEdit;
    Label19: TLabel;
    chbAKT_RESERVIERT_BAHN: TAswCheckBox;
    TabSheet5: TTabSheet;
    LuMARA2: TLookUpDef;
    edAKT_SORTE2: TLookUpEdit;
    Label28: TLabel;
    Label11: TLabel;
    cobVERPACKART: TAswComboBox;
    edMARA_NAME: TDBEdit;
    edMARA_NAME_2: TDBEdit;
    Label10: TLabel;
    edBEIN_NR: TLookUpEdit;
    btnBEIN_NR: TLookUpBtn;
    edBEIN_NAME: TDBEdit;
    chbMANUELL: TAswCheckBox;
    tsStellungen: TTabSheet;
    LuSIST: TLookUpDef;
    LuSIST1: TLookUpDef;
    LuSIST2: TLookUpDef;
    LuSIST3: TLookUpDef;
    cobFltr: TComboBox;
    Label30: TLabel;
    FrSIST: TFrMuSi;
    cobSILO1_ANTEIL: TDBComboBox;
    cobSILO2_ANTEIL: TDBComboBox;
    edSO_WERK_NR1: TLookUpEdit;
    edSO_WERK_NR2: TLookUpEdit;
    edSO_WERK_NR3: TLookUpEdit;
    edNACHLAUF: TDBEdit;
    Label32: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    edSTILLSTAND: TDBEdit;
    Label38: TLabel;
    LuBELA: TLookUpDef;
    tsBeladungen: TTabSheet;
    MuBELA: TMultiGrid;
    tsSchenk: TTabSheet;
    GridSchenk: TTitleGrid;
    Panel1: TPanel;
    BtnSchenkSave: TBitBtn;
    GroupBox2: TGroupBox;
    LuSCHENK: TLookUpDef;
    MuSCHENK: TMultiGrid;
    qSplitter1: TqSplitter;
    Panel4: TPanel;
    EdSchenkTage: TEdit;
    Label39: TLabel;
    Label40: TLabel;
    lbSistSmw: TListBox;
    Panel5: TPanel;
    chbSPERRE_LABOR: TAswCheckBox;
    chbSPERRE_SENSIBLER_KUNDE: TAswCheckBox;
    LuV_LABI_MK: TLookUpDef;
    Label41: TLabel;
    EdBeinSO_WERK_NR: TLookUpEdit;
    chbStruktur: TCheckBox;
    PanSilo3: TPanel;
    EdPos3: TEdit;
    LeSILO3_NR: TLookUpEdit;
    EdSILO3_NAME: TDBEdit;
    BtnLuSilo3: TLookUpBtn;
    cobSILO3_ANTEIL: TDBComboBox;
    Label42: TLabel;
    edAKT_MINFUELLUNG: TDBEdit;
    Label43: TLabel;
    Panel6: TPanel;
    Label44: TLabel;
    edMULTIPLIKATOR: TDBEdit;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    chbGrsoKOMBI_KNZ: TAswCheckBox;
    chbGrso2KOMBI_KNZ: TAswCheckBox;
    Query1: TuQuery;
    TblWerk: TuQuery;
    TblSilo1: TuQuery;
    TblSilo2: TuQuery;
    TblSilo3: TuQuery;
    TblGRSO: TuQuery;
    TblMARA: TuQuery;
    TblBEIN: TuQuery;
    TblDiPr: TuQuery;
    TblGRSO2: TuQuery;
    TblMARA2: TuQuery;
    TblSIST: TuQuery;
    TblSIST1: TuQuery;
    TblSIST2: TuQuery;
    TblSIST3: TuQuery;
    TblBELA: TuQuery;
    TblSCHENK: TuQuery;
    TblV_LABI_MK: TuQuery;
    TabSheet6: TTabSheet;
    FrSILE: TFrMuSi;
    Panel7: TPanel;
    Label14: TLabel;
    cobLEIST_KNZ: TAswComboBox;
    Label48: TLabel;
    edLEIST_MIN: TLookUpEdit;
    Label49: TLabel;
    Label50: TLabel;
    edLEIST_MAX: TLookUpEdit;
    Label51: TLabel;
    LuSILE: TLookUpDef;
    TblSILE: TuQuery;
    BtnInstallSILE: TBitBtn;
    Panel8: TPanel;
    TabControl: TTabControl;
    LaSiloleistungaktiv: TLabel;
    QueSIST: TuQuery;
    AKZ_NR: TDBEdit;
    Label4: TLabel;
    GroupBox4: TGroupBox;
    EdBEMERKUNG: TDBMemo;
    pcLabor: TPageControl;
    tsLaborSMW: TTabSheet;
    MuV_LABI_MK: TMultiGrid;
    tsLaborSMH: TTabSheet;
    LuLAER: TLookUpDef;
    TblLAER: TuQuery;
    MuLAER: TMultiGrid;
    chbSiebanteil: TCheckBox;
    Panel9: TPanel;
    LuV_LABI_ERGEBNISSE: TLookUpDef;
    TblV_LABI_ERGEBNISSE: TuQuery;
    GroupBox3: TGroupBox;
    ScrollBox1: TScrollBox;
    MuV_LABI_ERGEBNISSE: TMultiGrid;
    BtnLabiUpdate: TBitBtn;
    QueSiloSync: TuQuery;
    ProcLABI_TO_SILO: TuStoredProc;
    chbAKT_SPERRE_BIGBAG: TAswCheckBox;
    tsSMHEinstellungen: TTabSheet;
    cobLimsProbe: TComboBox;
    QueSILOUpd: TuQuery;
    BtnLAER: TBitBtn;
    BtnUpdLabi: TBitBtn;
    QueUpdLabi: TuQuery;
    edSILO1_ANTEIL: TDBEdit;
    edSILO2_ANTEIL: TDBEdit;
    edSILO3_ANTEIL: TDBEdit;
    chbLabi0: TCheckBox;
    chbLabi1: TCheckBox;
    chbLabi2: TCheckBox;
    chbLabi3: TCheckBox;
    ScrollBox2: TScrollBox;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    edLABI_SILO_FILTER: TLookUpEdit;
    edLABI_PROBE_NR: TLookUpEdit;
    EdLimsTage: TEdit;
    edAUTO_PROBE_NR: TLookUpEdit;
    MeLabiFilter: TMemo;
    Label61: TLabel;
    Label62: TLabel;
    EdChartMinX: TEdit;
    EdChartMaxX: TEdit;
    Label63: TLabel;
    chbLabiHand: TCheckBox;
    LaCheckWidth: TLabel;
    chbLabiSiloproben: TCheckBox;
    BtnMarkLims: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NavErfass(Sender: TObject);
    procedure NavRech(ADataSet: TDataset; Field: TField;
      OnlyCalcFields: Boolean);
    procedure chbWerkClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure TblDiPrBeforeOpen(DataSet: TDataSet);
    procedure LuSISTGet(DataSet: TDataSet);
    procedure cobFltrChange(Sender: TObject);
    procedure NavBeforePost(ADataSet: TDataSet; var Done: Boolean);
    procedure TblSISTxBeforeOpen(DataSet: TDataSet);
    procedure cobSILOx_ANTEILDropDown(Sender: TObject);
    procedure NavAfterReturn(Sender: TObject; LookUpModus: TLookUpModus;
      LookUpDef: TLookUpDef);
    procedure LuBELAGet(DataSet: TDataSet);
    procedure EdSchenkTageChange(Sender: TObject);
    procedure TblSCHENKBeforeOpen(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BtnSchenkSaveClick(Sender: TObject);
    procedure DetailControlChange(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
    procedure LuBELABuildSql(DataSet: TDataSet; var OK, fertig: Boolean);
    procedure NavPageChange(PageIndex: Integer);
    procedure BtnMuV_LABI_MKClick(Sender: TObject);
    procedure chbStrukturClick(Sender: TObject);
    procedure LDataSource1StateChange(Sender: TObject);
    procedure Query1BeforeOpen(DataSet: TDataSet);
    procedure TblBELABeforeOpen(DataSet: TDataSet);
    procedure BtnInstallSILEClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pcLaborChange(Sender: TObject);
    procedure chbSiebanteilClick(Sender: TObject);
    procedure BtnLabiUpdateClick(Sender: TObject);
    procedure Query1CalcFields(DataSet: TDataSet);
    procedure Query1AfterPost(DataSet: TDataSet);
    procedure TblV_LABI_ERGEBNISSEBeforeOpen(DataSet: TDataSet);
    procedure BtnLAERClick(Sender: TObject);
    procedure LuLAERAfterReturn(Sender: TLookUpDef; LookUpModus: TLookUpModus);
    procedure BtnUpdLabiClick(Sender: TObject);
    procedure cobSILOx_ANTEILChange(Sender: TObject);
    procedure chbLabiClick(Sender: TObject);
    procedure LuV_LABI_ERGEBNISSEBuildSql(DataSet: TDataSet; var OK,
      fertig: Boolean);
    procedure BtnMarkLimsClick(Sender: TObject);
  private
    { Private-Deklarationen }
    MsgFlag: boolean;
    SchenkList: TStringList;
    SchenkBeinNr: string;
    LabiChbs: array[0..MaxLabiCount-1] of TCheckBox;
    procedure SchenkGrid;
    procedure LoadFromIni;
    procedure SaveToIni;
    function FrmNr: integer;
    procedure ProcessInstallSILE(Sender: TObject);
    procedure LabiToSilo(Modus: integer);
  public
    { Public-Deklarationen }
  end;

var
  FrmSilo: TFrmSilo;
  FrmSilo1: TFrmSilo;
  FrmSilo2: TFrmSilo;
  FrmSilo3: TFrmSilo;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, NLnk_Kmp, Err__Kmp, Ini__Kmp,
  FltrFrm, MainFrm, WerkFrm, ParaFrm, QuvaStr, DataTFrm;

const
  piLabor = 1;

function TFrmSilo.FrmNr: integer;
begin
  Result := StrToIntDef(CharN(Kurz), 0);
end;

procedure TFrmSilo.FormCreate(Sender: TObject);
var
  I, X0: integer;
begin
  case FrmNr of
    1: FrmSILO1 := self;
    2: FrmSILO2 := self;
    3: FrmSILO3 := self;
  else
    FrmSILO := self;
  end;
  if FrmNr >= 1 then
    self.Caption := 'Mischsilo' + IntToStr(FrmNr);
  FrmPara.OnFormResize(self);

  Nav.AutoCommit := true;
  SchenkList := TStringList.Create;
  chbWerk.Caption := Format(chbWerk.Caption, [SysParam.WerkNr]);
  PanSilo3.Visible := PrgParam.SiloMix >= 3;

  LaAnteil.Caption := 'Anteil';
  if PrgParam.QsbtSMH then
  begin
    Nav.FormatList.Values['SILO1_ANTEIL'] := '#0.000';
    Nav.FormatList.Values['SILO2_ANTEIL'] := '#0.000';
    Nav.FormatList.Values['SILO3_ANTEIL'] := '#0.000';
  end;  //kein else
  if PrgParam.QsbtSMW then
  begin
    pcLabor.ActivePage := tsLaborSMW;
  end else
    pcLabor.ActivePage := tsLaborSMH;  //Sieblinie

  if PrgParam.SiloLeistung then
  begin
    LaSiloleistungaktiv.Visible := true;
    LaAnteil.Caption := 'Leistung t/h';
    LuSIST.AutoEdit := true;  //direkt in Tabelle ändern
    cobSILO1_ANTEIL.Datafield := 'SILO1_LEIST';
    cobSILO2_ANTEIL.Datafield := 'SILO2_LEIST';
    cobSILO3_ANTEIL.Datafield := 'SILO3_LEIST';
    EdSILO1_ANTEIL.Datafield := 'SILO1_LEIST';
    EdSILO2_ANTEIL.Datafield := 'SILO2_LEIST';
    EdSILO3_ANTEIL.Datafield := 'SILO3_LEIST';
  end else
  begin
    if PrgParam.QsbtSMH then
    begin
      //oben
    end else
    //if PrgParam.QsbtSMW then
    begin  //SMW: SIST enthält Laufzeit in s
      LaAnteil.Caption := 'Anteil %';
      LuSIST.FormatList.Values['SIST_KEY'] := '#0';
      LuSIST.FormatList.Values['SPS_CODE'] := '#0';
      FrSIST.Mu.LoadedColumnList.Assign(lbSistSmw.Items);
      FrSIST.Mu.IniSection := Sysparam.WerkNr;  //Spalten.TFrmSilo.FrSIST.0165
    end;
  end;
  LoadFromIni;

  X0 := chbLabiSiloproben.Left;
  LaCheckWidth.Caption := chbLabiSiloproben.Caption;
  chbLabiSiloproben.Width := LaCheckWidth.Width + 24;
  Inc(X0, chbLabiSiloproben.Width + 8);

  chbLabiHand.Left := X0;
  LaCheckWidth.Caption := chbLabiHand.Caption;
  chbLabiHand.Width := LaCheckWidth.Width + 24;
  Inc(X0, chbLabiHand.Width + 8);

  for I := 0 to MaxLabiCount - 1 do
  begin
    LabiChbs[I] := TCheckBox(self.FindComponent(Format('chbLabi%d', [I])));
    //Oberfläche:
    LabiChbs[I].Visible := false;
    LabiChbs[I].Visible := false;
    if MeLabiFilter.Lines.Count > I then
    begin
      LabiChbs[I].Left := X0;
      LabiChbs[I].Caption := StrValue(MeLabiFilter.Lines[I]);
      LaCheckWidth.Caption := LabiChbs[I].Caption;
      LabiChbs[I].Width := LaCheckWidth.Width + 24;
      Inc(X0, LabiChbs[I].Width + 8);
      LabiChbs[I].Visible := true;
    end;
  end;
end;

procedure TFrmSilo.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmSilo.LoadFromIni;
begin
  IniKmp.SectionTyp[SSectSiloAnwe] := stAnwendung;
  IniKmp.SectionTyp[SSectSiloAnwe + '.LabiFilter'] := stAnwendung;

  EdSchenkTage.Text := IniKmp.ReadString(Kurz, EdSchenkTage.Name, '3');
  cobLimsProbe.ItemIndex := IniKmp.ReadInteger(Kurz, cobLimsProbe.Name, 0);

  EdChartMinX.Text := IniKmp.ReadString(SSectSiloAnwe, EdChartMinX.Name, EdChartMinX.Text);
  EdChartMaxX.Text := IniKmp.ReadString(SSectSiloAnwe, EdChartMaxX.Name, EdChartMaxX.Text);
  EdLimsTage.Text := IniKmp.ReadString(SSectSiloAnwe, EdLimsTage.Name, EdLimsTage.Text);
  IniKmp.ReadSectionValuesDflt(SSectSiloAnwe + '.LabiFilter', MeLabiFilter.Lines);
end;

procedure TFrmSilo.SaveToIni;
begin
  IniKmp.WriteString(Kurz, EdSchenkTage.Name, EdSchenkTage.Text);
  IniKmp.WriteInteger(Kurz, cobLimsProbe.Name, cobLimsProbe.ItemIndex);

  IniKmp.WriteString(SSectSiloAnwe, EdChartMinX.Name, EdChartMinX.Text);
  IniKmp.WriteString(SSectSiloAnwe, EdChartMaxX.Name, EdChartMaxX.Text);
  IniKmp.WriteString(SSectSiloAnwe, EdLimsTage.Name, EdLimsTage.Text);
  IniKmp.ReplaceSection(SSectSiloAnwe + '.LabiFilter', MeLabiFilter.Lines);
end;

procedure TFrmSilo.FormDestroy(Sender: TObject);
begin
  SchenkList.Free;
  case FrmNr of
    1: FrmSILO1 := nil;
    2: FrmSILO2 := nil;
    3: FrmSILO3 := nil;
  else
    FrmSILO := nil;
  end;
end;

procedure TFrmSilo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveToIni;
end;

procedure TFrmSilo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSilo.NavStart(Sender: TObject);
var
  S: string;
begin
  if not Nav.ReturnAktiv then
  begin
    chbWerk.Checked := true;
  end else
  begin
    chbWerk.Checked := false;
  end;
  if Nav.ReturnAktiv and (Pos('BELA', Nav.ReturnKurz) > 0) then  //von BELA
    Nav.PageIndex := piLabor;
  TFrmFltr.cobFltrInit(cobFltr);
  if InitData <> nil then
  begin
    S := PChar(InitData);
    Nav.ReturnAktiv := true;   //FltrInit: kein Filter setzen
    Nav.FltrList.Values[StrParam(S)] := StrValue(S);
    Nav.PageIndex := tsAnlage.PageIndex; //Silostand, Störung
    MsgFlag := true;
  end;
end;

procedure TFrmSilo.pcLaborChange(Sender: TObject);
begin
  PostMessage(self.Handle, BC_PAGECHANGE, Nav.PageIndex, 0);  //CheckAutoOpen
end;

procedure TFrmSilo.NavPostStart(Sender: TObject);
begin
  if MsgFlag then
    WMess(SILOFrm_001, [0]);  //'Bunkerstörung (wird angezeigt)'
  MsgFlag := false;
  Debug('%d', [ord(Query1.FieldByName('GRUNDSORTE').Required)]);
end;

procedure TFrmSilo.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    Nav.AssignValueIfNull('KOMBI_KNZ', 'N');
    Nav.AssignValueIfNull('AKT_SPERRE_BAHN', 'N');
    Nav.AssignValueIfNull('AKT_SPERRE_LKW', 'N');
    Nav.AssignValueIfNull('AKT_RESERVIERT_TR', 'N');
    Nav.AssignValueIfNull('PRIO', '1');
    Nav.AssignValueIfNull('SO_WERK_NR', SysParam.WerkNr);
    Nav.AssignValueIfNull('SPERRE_LABOR', 'N');
    Nav.AssignValueIfNull('SPERRE_SENSIBLER_KUNDE', 'N');
    Nav.AssignValueIfNull('VERPACKART', 'L');

  end;
end;

procedure TFrmSilo.NavRech(ADataSet: TDataset; Field: TField;
  OnlyCalcFields: Boolean);
var
  I: integer;
begin
  with ADataSet do
  begin
    if OnlyCalcFields then
    begin
    end else
    begin
      FieldByName('KOMBI_KNZ').AsString := JaNein[not FieldByName('SILO2_NR').IsNull];
//        JaNein[not FieldByName('SILO1_NR').IsNull] and
//        JaNein[not FieldByName('SILO1_ANTEIL').IsNull] and
//        JaNein[not FieldByName('SILO2_NR').IsNull] and
//        JaNein[not FieldByName('SILO2_ANTEIL').IsNull];

      { KKW: }
      if FieldIsName(Field, 'KOMBI_KNZ') then
      begin
        if FieldByName('KOMBI_KNZ').AsString = 'N' then
        begin
          FieldByName('SILO1_ID').Clear;
          FieldByName('SILO1_NR').Clear;   {Assign( FieldByName('SILO_NR'));}
          FieldByName('SILO1_ANTEIL').Clear;  {AsFloat := 100;}
          FieldByName('SILO2_ID').Clear;
          FieldByName('SILO2_NR').Clear;
          FieldByName('SILO2_ANTEIL').Clear;
          FieldByName('SILO3_ID').Clear;
          FieldByName('SILO3_NR').Clear;
          FieldByName('SILO3_ANTEIL').Clear;
        end;
      end;
      {KKW?
      if FieldIsName(Field, 'AKT_SORTE') then
        Nav.AssignField('GRUNDSORTE', FieldByName('AKT_SORTE'));
      if FieldIsName(Field, 'GRUNDSORTE') then
        Nav.AssignField('AKT_SORTE', FieldByName('GRUNDSORTE'));}
      //statt LookupEdit Controls:
      if FieldIsName(Field, 'GRUNDSORTE') then
        LuMARA.Navlink.Refresh;
      if FieldIsName(Field, 'GRUNDSORTE2') then
        LuMARA2.Navlink.Refresh;

      if PrgParam.QsbtSMH then  //Haltern
      begin
        if FieldIsName(Field, 'SILO1_ANTEIL;SILO2_ANTEIL;SILO3_ANTEIL') then
        begin
          //Leistung setzen:
          I := StrToInt(CharI(Field.FieldName, 5));
          QueSIST.Close;
          QueSIST.ParamByName('SILO_ID').AsInteger :=
            Query1.FieldByName(Format('SILO%d_ID', [I])).AsInteger;
          QueSIST.Open;
          QueSIST.First;
          while not QueSIST.EOF do
          begin
            //if compEqal in CompFields(QueSIST.FieldByName('
            if Field.AsFloat = QueSIST.FieldByName('SIST_KEY').AsFloat then
            begin
              Nav.AssignField(Format('SILO%d_LEIST', [I]),
                QueSIST.FieldByName('LEISTUNG'));
              Break;
            end;
            QueSIST.Next;
          end;
        end;
        if FieldIsName(Field, 'SILO1_LEIST;SILO2_LEIST;SILO3_LEIST') then
        begin
          //Leistung setzen:
          I := StrToInt(CharI(Field.FieldName, 5));
          QueSIST.Close;
          QueSIST.ParamByName('SILO_ID').AsInteger :=
            Query1.FieldByName(Format('SILO%d_ID', [I])).AsInteger;
          QueSIST.Open;
          QueSIST.First;
          if QueSIST.EOF then
          begin  //kontinuierlich
            Nav.AssignField(Format('SILO%d_ANTEIL', [I]), Field);
          end else
          begin  //diskontinuierlich
            Nav.AssignValue(Format('SILO%d_ANTEIL', [I]), '');
            while not QueSIST.EOF do
            begin
              //if compEqal in CompFields(QueSIST.FieldByName('
              if Field.AsFloat = QueSIST.FieldByName('LEISTUNG').AsFloat then
              begin
                Nav.AssignField(Format('SILO%d_ANTEIL', [I]),
                  QueSIST.FieldByName('SIST_KEY'));
                Break;
              end;
              QueSIST.Next;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrmSilo.cobSILOx_ANTEILChange(Sender: TObject);
begin
  //an edSILOx weitergeben:
  PostMessage(self.Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure TFrmSilo.cobSILOx_ANTEILDropDown(Sender: TObject);
  procedure Fill(I: integer);
  var
    aLuDef: TLookupDef;
    aCob: TDBComboBox;
    aTbl: TUniQuery;
    SILOx_ID: string;
    S1: string;
  begin
    case I of
   1: begin
        aLuDef := LuSIST1; SILOx_ID := 'SILO1_ID'; aTbl := TblSIST1; aCob := cobSILO1_ANTEIL;
      end;
   2: begin
        aLuDef := LuSIST2; SILOx_ID := 'SILO2_ID'; aTbl := TblSIST2; aCob := cobSILO2_ANTEIL;
      end;
   3: begin
        aLuDef := LuSIST3; SILOx_ID := 'SILO3_ID'; aTbl := TblSIST3; aCob := cobSILO3_ANTEIL;
      end;
    else
      aLuDef := nil; aTbl := nil; aCob := nil;
      EError('%s.cobSILOx_ANTEILDropDown: Fehler I=%d', [Kurz, I]);
    end;
    if aLuDef.References.Values['SILO_ID'] <> Query1.FieldByName(SILOx_ID).AsString then
    begin
      aLuDef.References.Values['SILO_ID'] := StrDflt(Query1.FieldByName(SILOx_ID).AsString, '=');
      aTbl.Open;
      aCob.Items.Clear;
      while not aTbl.EOF do
      begin
        if PrgParam.SiloLeistung then
          S1 := Format('%.0f', [aTbl.FieldByName('LEISTUNG').AsFloat]) else
          S1 := Format('%.3f', [aTbl.FieldByName('SIST_KEY').AsFloat]);
        aCob.Items.Add(S1);
        aTbl.Next;
      end;
    end;
  end;
begin
  { SMH: }
  if PrgParam.QsbtSMH or PrgParam.SiloLeistung then
  begin
    Fill(TComponent(Sender).Tag);
  end;
end;

procedure TFrmSilo.Query1AfterPost(DataSet: TDataSet);
begin
  //LABI_FILTER auf alle Silos mit der gleichen AKZ
  QueSiloSync.ExecSQL;
end;

procedure TFrmSilo.Query1BeforeOpen(DataSet: TDataSet);
begin
  with Dataset do
  begin
    if not chbWerk.Checked then
      Nav.References.Values['SO_WERK_NR'] := '' else
      Nav.References.Values['SO_WERK_NR'] := Sysparam.WerkNr + ';=';  //oder leer!
  end;
end;

procedure TFrmSilo.Query1CalcFields(DataSet: TDataSet);
var
  S: string;
  I: integer;
begin
  with DataSet do
  begin
    S := FieldByName('LABI_SILO_FILTER').AsString;
    FieldByName('cfLABI_SILO_FILTER1').AsString := TokenAt(S, ';', 1);
    FieldByName('cfLABI_SILO_FILTER2').AsString := TokenAt(S, ';', 2);
    FieldByName('cfLABI_SILO_FILTER3').AsString := TokenAt(S, ';', 3);
    FieldByName('cfLABI_SILO_FILTER4').AsString := TokenAt(S, ';', 4);
    //16.03.13:
    I := FieldByName('SPS_CODE').AsInteger;
    if (I >= 401) and (I <= 409) then
      FieldByName('cfLABI_SILO_INDEX').AsString := IntToStr(I - 401);  //0..8

    //18.04.13
    S := FieldByName('LABI_PROBE_NR').AsString;
    FieldByName('cfLABI_PROBE_NR1').AsString := TokenAt(S, ';', 1);
    FieldByName('cfLABI_PROBE_NR2').AsString := TokenAt(S, ';', 2);
    FieldByName('cfLABI_PROBE_NR3').AsString := TokenAt(S, ';', 3);
    FieldByName('cfLABI_PROBE_NR4').AsString := TokenAt(S, ';', 4);
    FieldByName('cfLABI_PROBE_NR5').AsString := TokenAt(S, ';', 5);
    FieldByName('cfLABI_PROBE_NR6').AsString := TokenAt(S, ';', 6);
    FieldByName('cfLABI_PROBE_NR7').AsString := TokenAt(S, ';', 7);
    FieldByName('cfLABI_PROBE_NR8').AsString := TokenAt(S, ';', 8);
    FieldByName('cfLABI_PROBE_NR9').AsString := TokenAt(S, ';', 9);
    FieldByName('cfLABI_PROBE_NR10').AsString := TokenAt(S, ';', 10);

  end;
end;

procedure TFrmSilo.chbWerkClick(Sender: TObject);
begin
  if Nav.nlState = nlBrowse then
  begin
    Nav.Refresh;
  end;
end;

procedure TFrmSilo.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
var
  S: string;
begin
  S := Nav.FltrList.Values['SO_WERK_NR'];
  if S <> '' then
  begin
    TblWerk.Open;
    PsDflt.Caption := 'Werk ' + TblWerk.FieldByName('WERK_NAME').AsString;
  end else
    PsDflt.Caption := '';
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmSilo.TblDiPrBeforeOpen(DataSet: TDataSet);
begin  //muss sein weil bein_nr nicht numerisch ist
  LuDiPr.References.Values['BEIN_NR'] := Query1.FieldByName('SILO_ID').AsString;
end;

procedure TFrmSilo.LuSISTGet(DataSet: TDataSet);
var
  S1: string;
  function NoNulls(S: string): string;
  begin
    if StrToIntTol(S) = 0 then
      result := '' else
      result := S;
  end;
begin
  with DataSet do
  begin
    S1 := Format('%d000000000', [FieldByName('SPS_CODE').AsInteger]);
    FieldByName('cfA1').AsString := NoNulls(copy(S1, 4, 1));
    FieldByName('cfS1').AsString := NoNulls(copy(S1, 5, 2));
    FieldByName('cfA2').AsString := NoNulls(copy(S1, 7, 1));
    FieldByName('cfS2').AsString := NoNulls(copy(S1, 8, 2));
  end;
end;

procedure TFrmSilo.cobFltrChange(Sender: TObject);
begin
  TFrmFltr.cobFltrChange(Sender);
end;

procedure TFrmSilo.NavBeforePost(ADataSet: TDataSet; var Done: Boolean);

  procedure CheckKontinuierlich(SiloIndex: integer);
  var
    SiloTbl: TDataSet;
    AnteilFld: TField;
  begin
    SiloTbl := nil;  //Compiler
    case SiloIndex of
      1: SiloTbl := TblSilo1;
      2: SiloTbl := TblSilo2;
      3: SiloTbl := TblSilo3;
    else
      EError('Falscher Siloindex %d', [SiloIndex]);
    end;
    AnteilFld := Query1.FieldByName(Format('SILO%d_ANTEIL', [SiloIndex]));

    if not Query1.FieldByName(Format('SILO%d_NR', [SiloIndex])).IsNull then
    begin
      SiloTbl.Open;
      if SiloTbl.FieldByName('LEIST_KNZ').AsString = Leist_kontinuierlich then
      begin
        if AnteilFld.AsFloat < SiloTbl.FieldByName('LEIST_MIN').AsFloat then
        begin
          Done := true;
          ErrWarn(SILOFrm_006, [SiloTbl.FieldByName('LEIST_MIN').AsFloat]);  //Siebanteil: Min.Leistung (%.2f) unterschritten
          FocusField(self, AnteilFld);
        end;
        if AnteilFld.AsFloat > SiloTbl.FieldByName('LEIST_MAX').AsFloat then
        begin
          Done := true;
          ErrWarn(SILOFrm_007, [SiloTbl.FieldByName('LEIST_MAX').AsFloat]);  //Siebanteil: Max.Leistung (%.2f) überschritten
          FocusField(self, AnteilFld);
        end;
      end;
    end;
  end;  //CheckKontinuierlich

  function CheckSiloBein(SiloIndex: integer): boolean;
  //Überprüft Beladeeinrichtung der Kombi-Silos. Ergibt false wenn ungleich.
  var
    SiloTbl: TDataSet;
    S1, S2: string;
  begin
    Result := true;
    SiloTbl := nil;
    case SiloIndex of
      1: SiloTbl := TblSilo1;
      2: SiloTbl := TblSilo2;
      3: SiloTbl := TblSilo3;
    else
      EError('Falscher Siloindex %d', [SiloIndex]);
    end;
    if not Query1.FieldByName(Format('SILO%d_NR', [SiloIndex])).IsNull then
    begin
      SiloTbl.Open;
      S1 := SiloTbl.FieldByName('BEIN_NR').AsString;
      S2 := Query1.FieldByName('BEIN_NR').AsString;
      if S1 <> S2 then
      begin
        Result := false;
        ErrWarn(SILOFrm_008, [SiloIndex, S1, S2]);  //Kombination Pos %d: Beladestelle (%s) falsch. Muss (%s) sein.
      end;
    end;
  end;

var
  LK, LD: boolean;
begin
  with ADataSet do
  begin
    Debug('%d', [ord(FieldByName('GRUNDSORTE').Required)]);
    FieldByName('GRUNDSORTE').Required := not FieldIsNull(FieldByName('SILO_GRSO_ID'));

    if PrgParam.SiloMix < 3 then
    begin
      FieldByName('SILO3_NR').Clear;
      FieldByName('SILO3_ANTEIL').Clear;
    end;
    if PrgParam.QsbtSMH then
    begin
      FieldByName('BEIN_NR').Required := true;
      //FieldByName('SPS_CODE').Required := true;  nein wg. Kombi
      FieldByName('TROCKEN_FEUCHT').Required := true;
    end;
    FieldByName('SILO1_ANTEIL').Required := not FieldByName('SILO1_NR').IsNull;
    FieldByName('SILO2_ANTEIL').Required := not FieldByName('SILO2_NR').IsNull;
    FieldByName('SILO3_ANTEIL').Required := not FieldByName('SILO3_NR').IsNull;

    FieldByName('SILO1_NR').Required := not FieldByName('SILO2_NR').IsNull;
    FieldByName('SILO2_NR').Required := not FieldByName('SILO3_NR').IsNull;

    if (FieldByName('GRUNDSORTE').AsString = SStruktur) and
       (FieldByName('KOMBI_KNZ').AsString <> 'J') then
    begin
      Done := true;
      ErrWarn(SILOFrm_002, [0]);  //'Silo-Struktur: Kombination fehlt'
      FocusField(self, FieldByName('SILO1_NR'));
      Exit;
    end;
    if (FieldByName('GRUNDSORTE').AsString = SSiebanteil) and
       (FieldByName('KOMBI_KNZ').AsString = 'J') then
    begin
      Done := true;
      ErrWarn(SILOFrm_002, [0]);  //'Siebanteil: Kombination nicht erlaubt'
      FocusField(self, FieldByName('SILO1_NR'));
      Exit;
    end;

    //Nein. Wenn nur Srte1 dann ist Kombi=N - if FieldByName('KOMBI_KNZ').AsString = 'J' then
    begin
      CheckKontinuierlich(1);
      if Done then
        Exit;
      CheckKontinuierlich(2);
      if Done then
        Exit;
      CheckKontinuierlich(3);
      if Done then
        Exit;
    end;

    if not CheckSiloBein(1) or not CheckSiloBein(2) or not CheckSiloBein(3) then
    begin
      Done := true;
      Exit;
    end;

    TblGRSO.Open;
    if TblGRSO.FieldByName('KOMBI_KNZ').AsString = JN_Ja then
    begin
      Done := true;
      ErrWarn(SILOFrm_003, [0]);  //'Grundsorte darf keine Mischsorte sein. Bitte in Tabelle übernehmen.'
      FocusField(self, FieldByName('GRUNDSORTE'));
      Exit;
    end;
    TblGRSO2.Open;
    if TblGRSO2.FieldByName('KOMBI_KNZ').AsString = JN_Ja then
    begin
      Done := true;
      ErrWarn(SILOFrm_004, [0]); //'Grundsorte2 darf keine Mischsorte sein. Bitte in Tabelle übernehmen.'
      FocusField(self, FieldByName('GRUNDSORTE2'));
      Exit;
    end;

    //Leistung: kont: Min/Max NN. disk: LuSILE.count=0
    LK := FieldByName('LEIST_KNZ').AsString = 'K';  //kontinuierlich
    LD := FieldByName('LEIST_KNZ').AsString = 'D';  //diskontinuierlich
    if LD then ;  //Compiler
    FieldByName('LEIST_MIN').Required := LK;
    FieldByName('LEIST_MAX').Required := LK;
    if LK and (LuSILE.Navlink.RecordCount > 0) then
      EError('bei kontinuierlicher Leistung dürfen keine diskreten Werte angegeben werden', [0]);
  end;
end;

procedure TFrmSilo.TblSISTxBeforeOpen(DataSet: TDataSet);
var
  aLuDef: TLookupDef;
begin
  aLuDef := nil;
  case DataSet.Tag of
    1: aLuDef := LuSIST1;
    2: aLuDef := LuSIST2;
    3: aLuDef := LuSIST3;
    else EError('Dataset.tag=%d', [0]);
  end;
  aLuDef.FltrList.Values['SO_WERK_NR'] := Query1.FieldByName('SO_WERK_NR').AsString;
  aLuDef.FltrList.Values['BEIN_NR'] := Query1.FieldByName('BEIN_NR').AsString;
end;

procedure TFrmSilo.BtnMarkLimsClick(Sender: TObject);
var
  S1: string;
  Bookmark1, Bookmark2: TBookmark;
begin
  TblV_LABI_ERGEBNISSE.Open;
  TblV_LABI_ERGEBNISSE.First;
  MuV_LABI_ERGEBNISSE.SelectedRows.Clear;
  Bookmark1 := nil;
  Bookmark2 := nil;
  while not TblV_LABI_ERGEBNISSE.EOF do
  begin
    S1 := TblV_LABI_ERGEBNISSE.FieldByName('PROBE_NR').AsString;
    if (S1 = Query1.FieldByName('cfLABI_PROBE_NR1').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR2').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR3').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR4').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR5').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR6').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR7').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR8').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR9').AsString) or
       (S1 = Query1.FieldByName('cfLABI_PROBE_NR10').AsString) then
    begin
      MuV_LABI_ERGEBNISSE.SelectedRows.CurrentRowSelected := true;
      if Bookmark1 = nil then
        Bookmark1 := TblV_LABI_ERGEBNISSE.GetBookmark;
      Bookmark2 := TblV_LABI_ERGEBNISSE.GetBookmark;
    end;
    TblV_LABI_ERGEBNISSE.Next;
  end;
  TblV_LABI_ERGEBNISSE.First;
//  if BookMark1 <> nil then
//    TblV_LABI_ERGEBNISSE.GotoBookmark(Bookmark1);
  if BookMark2 <> nil then
  begin
    TblV_LABI_ERGEBNISSE.GotoBookmark(Bookmark2);
    PostMessage(MuV_LABI_ERGEBNISSE.Handle, BC_MULTIGRID, mgSelectedRowsChanged, 0); //SMess Count
  end;
end;

procedure TFrmSilo.TblV_LABI_ERGEBNISSEBeforeOpen(DataSet: TDataSet);
  //so nicht: Chbs: array[0..MaxCount-1] of TCheckBox = (chbLabi0, chbLabi1, chbLabi2, chbLabi3);
var
  I: integer;
  S1: string;
  ChbChecked: boolean;
begin
  if chbLabiSiloproben.Checked and TblLAER.Active then
  begin
    LuV_LABI_ERGEBNISSE.References.Values['SILO_NR'] := '';
    LuV_LABI_ERGEBNISSE.References.Values['PROBE_DATUM'] := '';
    LuV_LABI_ERGEBNISSE.References.Values['PROBE_NR'] := ':cfLABI_PROBE_NR1;'+
      ':cfLABI_PROBE_NR2;:cfLABI_PROBE_NR3;:cfLABI_PROBE_NR4;:cfLABI_PROBE_NR5;'+
      ':cfLABI_PROBE_NR6;:cfLABI_PROBE_NR7;:cfLABI_PROBE_NR8;:cfLABI_PROBE_NR9;'+
      ':cfLABI_PROBE_NR10;';
  end else
  begin
    LuV_LABI_ERGEBNISSE.References.Values['PROBE_NR'] := '';
    LuV_LABI_ERGEBNISSE.References.Values['PROBE_DATUM'] := Format('>=sysdate-%d', [
      StrToIntDef(EdLimsTage.Text, 30)]);
    //16.03.13: Filter über Oberfläche: Muss wg UniDAC über :Params gehen.
    S1 := '';
    for I := 0 to IMin(MeLabiFilter.Lines.Count, MaxLabiCount) - 1 do
    begin
      if LabiChbs[I].Checked then
      begin
        AppendTok(S1, Format('[concat(''%s'',:cfLABI_SILO_INDEX)]', [
          StrCgeStr(StrParam(MeLabiFilter.Lines[I]), '%', '')]), '||');
      end;
    end;
    if ChbLabiHand.Checked then
    begin
      AppendTok(S1, '[concat(''HAND'',:cfLABI_SILO_INDEX)]', '||');
    end;
    if S1 = '' then
    begin  //bisher:
      S1 := ':cfLABI_SILO_FILTER1;:cfLABI_SILO_FILTER2;:cfLABI_SILO_FILTER3;:cfLABI_SILO_FILTER4';
    end;

    LuV_LABI_ERGEBNISSE.References.Values['SILO_NR'] := S1;
  end;
end;

procedure TFrmSilo.LuV_LABI_ERGEBNISSEBuildSql(DataSet: TDataSet; var OK,
  fertig: Boolean);
begin
  //like
//  TblV_LABI_ERGEBNISSE.SQL.Text := StrCgeStrStr(TblV_LABI_ERGEBNISSE.SQL.Text,
//    'PROBE_NR = :LABI_PROBE_NR', 'PROBE_NR like :LABI_PROBE_NR', true);
end;

procedure TFrmSilo.NavAfterReturn(Sender: TObject;
  LookUpModus: TLookUpModus; LookUpDef: TLookUpDef);
begin
  if LookUpDef = LuSilo1 then Nav.AssignValue('SILO1_ANTEIL', '');
  if LookUpDef = LuSilo2 then Nav.AssignValue('SILO2_ANTEIL', '');
  if LookUpDef = LuSilo3 then Nav.AssignValue('SILO3_ANTEIL', '');
end;

procedure TFrmSilo.LuBELAGet(DataSet: TDataSet);
var
  BelaDiff, NettoDiff, SchenkDiff, GesamtDiff: double;
begin
  with DataSet do
  begin
    if FieldByName('ISTMENGE').AsFloat > 22 then
    begin
      BelaDiff := FieldByName('ISTMENGE').AsFloat - FieldByName('SOLLMENGE').AsFloat;
      FieldByName('cfBelaDiff').AsFloat := BelaDiff;
      if FieldByName('BRUTTO_GEWICHT').AsFloat <> 0 then
      begin
        NettoDiff := FieldByName('NETTO_GEWICHT').AsFloat -
                     FieldByName('ISTMENGE').AsFloat;
        SchenkDiff := FieldByName('NETTO_GEWICHT').AsFloat -
                      FieldByName('ISTMENGE').AsFloat -
                     FieldByName('STILLSTAND').AsFloat;
        GesamtDiff := FieldByName('NETTO_GEWICHT').AsFloat -
                      FieldByName('SOLLMENGE').AsFloat;
        FieldByName('cfNettoDiff').AsFloat := NettoDiff;
        FieldByName('cfSchenkDiff').AsFloat := SchenkDiff;
        FieldByName('cfGesamtDiff').AsFloat := GesamtDiff;
      end;
    end;
  end;
end;

procedure TFrmSilo.LuLAERAfterReturn(Sender: TLookUpDef;
  LookUpModus: TLookUpModus);
begin
  with Sender.DataPos do
  begin
    Nav.AssignValue('LABI_PROBE_NR', Values['PROBE_NR']);
    Nav.DoPost;
  end;
  BtnUpdLabi.Click;
end;

procedure TFrmSilo.BtnUpdLabiClick(Sender: TObject);
begin
  QueUpdLabi.ExecSQL;
end;



{ Schenk Korrektur }

procedure TFrmSilo.DetailControlChange(Sender: TObject);
begin
  if DetailControl.ActivePage = tsSchenk then
    SchenkGrid;
end;

procedure TFrmSilo.LDataSource1DataChange(Sender: TObject; Field: TField);
begin
  if DetailControl.ActivePage = tsSchenk then
    SchenkGrid;
  chbStruktur.Checked := Query1.FieldByName('GRUNDSORTE').AsString = SStruktur;
  chbSiebanteil.Checked := Query1.FieldByName('GRUNDSORTE').AsString = SSiebanteil;
end;

procedure TFrmSilo.LDataSource1StateChange(Sender: TObject);
begin
  chbStruktur.Enabled := Nav.nlState in nlEditStates;
  chbSiebanteil.Enabled := Nav.nlState in nlEditStates;
end;

procedure TFrmSilo.BtnSchenkSaveClick(Sender: TObject);
var
  BeinBemList: TStringList;
  I, Y: integer;
  S1: string;
begin
  //Korr.<Silo1>.<Silo2>.<Silo3>=Korrekturemenge
  SaveToIni;
  TblBEIN.Open;
  BeinBemList := TStringList.Create;
  try
    GetFieldStrings(TblBEIN.FieldByName('BEMERKUNG'), BeinBemList);
    for I := BeinBemList.Count - 1 downto 0 do
    begin
      S1 := BeinBemList[I];
      if BeginsWith(S1, 'Korr.', true) then
      begin
        BeinBemList.Delete(I);
      end;
    end;
    for Y := 1 to GridSchenk.RowCount - 1 do
    begin
      if GridSchenk.Cells[1, Y] = '' then
        continue;
      S1 := Format('Korr.%d.%d.%d', [StrToIntTol(GridSchenk.Cells[1, Y]),
        StrToIntTol(GridSchenk.Cells[2, Y]), StrToIntTol(GridSchenk.Cells[3, Y])]);
      BeinBemList.Values[S1] := GridSchenk.Cells[4, Y];
    end;
    LuBEIN.DoEdit;
    SetFieldStrings(TblBEIN.FieldByName('BEMERKUNG'), BeinBemList);
    LuBEIN.Commit;
  finally
    BeinBemList.Free;
  end;
end;

procedure TFrmSilo.SchenkGrid;
// Lädt aktuelle Korrekturwerte der aktuellen Silo-Bein:
// 1. von TblSchenk: Silo1, Silo2, Silo3 = Werte
// 2. von BEIN.BEMERKUNG (überschreibt 1.)
// 3. Speichern in B.B dto.
// Korr.<Silo1>.<Silo2>.<Silo3>=Korrekturemenge
  procedure SchenkListToGrid(L: TStringList);
  var
    I, Y: integer;
    S1, NextS: string;
  begin
    GridSchenk.ClearAll;
    Y := 1;
    for I := 0 to L.Count - 1 do
    begin
      S1 := PStrTok(StrParam(L[I]), '.', NextS);  //Korr.
      S1 := PStrTok('', '.', NextS);
      if S1 <> '0' then
        GridSchenk.AddCell(1, Y, S1);
      S1 := PStrTok('', '.', NextS);
      if S1 <> '0' then
        GridSchenk.AddCell(2, Y, S1);
      S1 := PStrTok('', '.', NextS);
      if S1 <> '0' then
        GridSchenk.AddCell(3, Y, S1);

      S1 := StrValue(L[I]);
      GridSchenk.AddCell(4, Y, S1);

      Y := Y + 1;
    end;
  end;
var
  BeinBemList, SchenkList: TStringList;
  S1, S2: string;
  I: integer;
begin
  TblBEIN.Open;
  if SchenkBeinNr <> Query1.FieldByName('BEIN_NR').AsString then
  begin
    SchenkBeinNr := Query1.FieldByName('BEIN_NR').AsString;
    TblBEIN.Open;
    BeinBemList := TStringList.Create;
    SchenkList := TStringList.Create;
    try
      TblSCHENK.Close;
      TblSCHENK.Open;
      TblSCHENK.First;
      while not TblSCHENK.EOF do with TblSCHENK do
      begin
        S1 := Format('Korr.%d.%d.%d=%f', [FieldByName('SILO1').AsInteger,
          FieldByName('SILO2').AsInteger, FieldByName('SILO3').AsInteger,  0.0]);
          //FieldByName('SCHENKDIFF').AsFloat]);
        SchenkList.Add(S1);
        TblSCHENK.Next;
      end;

      GetFieldStrings(TblBEIN.FieldByName('BEMERKUNG'), BeinBemList);
      for I := 0 to BeinBemList.Count - 1 do
      begin
        S2 := BeinBemList[I];
        if BeginsWith(S2, 'Korr.', true) then
        begin
          SchenkList.Values[StrParam(S2)] := StrValue(S2);
        end;
      end;
      SchenkListToGrid(SchenkList);
    finally
      BeinBemList.Free;
      SchenkList.Free;
    end;
  end;
end;

procedure TFrmSilo.EdSchenkTageChange(Sender: TObject);
begin
  SchenkBeinNr := '';
  if TblSCHENK.Active then
    LuSCHENK.Refresh;
end;

procedure TFrmSilo.TblSCHENKBeforeOpen(DataSet: TDataSet);
begin
  TblSCHENK.ParamByName('WERK_NR').AsString := Query1.FieldByName('SO_WERK_NR').AsString;
  TblSCHENK.ParamByName('TAGE').AsInteger := StrToIntTol(EdSchenkTage.Text);
  TblSCHENK.ParamByName('BEIN_NR').AsString := Query1.FieldByName('BEIN_NR').AsString;
  TblSCHENK.ParamByName('MINDIFF').AsFloat := -1.5;
  TblSCHENK.ParamByName('MAXDIFF').AsFloat := 1.5;
//   if DelphiRunning then
//   begin
//     TblSCHENK.ParamByName('MINDIFF').AsFloat := -50;
//     TblSCHENK.ParamByName('MAXDIFF').AsFloat := 50;
//   end;
end;

procedure TFrmSilo.LuBELABuildSql(DataSet: TDataSet; var OK,
  fertig: Boolean);
begin
  (* 16.01.09 weg
  TblBELA.SQL.Text := StringReplace(TblBELA.SQL.Text,
    ':SPS_CODE%', 'concat(:SPS_CODE,''%'')', [rfReplaceAll, rfIgnoreCase]);
  *)
end;

procedure TFrmSilo.TblBELABeforeOpen(DataSet: TDataSet);
begin
  if Query1.FieldByName('KOMBI_KNZ').AsString = JaNein_Ja then
  begin
    TblSilo1.Open;
    TblSilo2.Open;
    TblSilo3.Open;
    LuBELA.References.Values['SILP1_NR'] := StrDflt(TblSilo1.FieldByName('SPS_CODE').AsString, '=');
    LuBELA.References.Values['SILP2_NR'] := StrDflt(TblSilo2.FieldByName('SPS_CODE').AsString, '=');
    LuBELA.References.Values['SILP3_NR'] := StrDflt(TblSilo3.FieldByName('SPS_CODE').AsString, '=');
  end else
  begin
    LuBELA.References.Values['SILP1_NR'] := ':SPS_CODE';
    LuBELA.References.Values['SILP2_NR'] := '=';
    LuBELA.References.Values['SILP3_NR'] := '=';
  end;
end;

procedure TFrmSilo.NavPageChange(PageIndex: Integer);
begin
  TblV_LABI_MK.Close;
end;

procedure TFrmSilo.ProcessInstallSILE(Sender: TObject);
// SIST_KEY -> SIST.LEISTUNG
var
  S1: string;
  N: integer;
begin
  with Query1 do
  begin
    LuSILE.Refresh;
    TblSILE.First;
    N := 0;
    while not TblSILE.EOF do
    begin    // 4,580 -> 580
      //PStrTok(TblSILE.FieldByName('SIST_KEY').DisplayText, ',', NextS);  //mit 3 Nk!
      //S1 := PStrTok('', ',', NextS);  //2.ter Token nach ','
      // Displaytext wg mit 3 Nk!
      S1 := TokenAt(TblSILE.FieldByName('SIST_KEY').DisplayText, ',', 2);  //2.ter Token nach ','
      if S1 <> '' then
      begin
        LuSILE.AssignValue('LEISTUNG', S1);
        LuSILE.DoPost;
        Inc(N);
      end;
      TblSILE.Next;
    end;
    if N > 0 then
    begin
      Nav.AssignValue('LEIST_KNZ', 'D');  //diskontinuierlich
    end;
    //2.ter Token, hinter ','
    S1 := TokenAt(Query1.FieldByName('SILO1_ANTEIL').DisplayText, ',', 2);
    if S1 <> '' then Nav.AssignValue('SILO1_LEIST', S1);
    S1 := TokenAt(Query1.FieldByName('SILO2_ANTEIL').DisplayText, ',', 2);
    if S1 <> '' then Nav.AssignValue('SILO2_LEIST', S1);
    S1 := TokenAt(Query1.FieldByName('SILO3_ANTEIL').DisplayText, ',', 2);
    if S1 <> '' then Nav.AssignValue('SILO3_LEIST', S1);
    Nav.Commit;
  end;
end;


procedure TFrmSilo.BtnLAERClick(Sender: TObject);
begin
  //Laborwerte erfassen
  LuLAER.LookUp(lumErfassMsk);
end;

procedure TFrmSilo.BtnLabiUpdateClick(Sender: TObject);
//var
//  I: integer;
//  S: string;
begin
  Nav.DoCancel;  //mit Abfrage
  if Nav.nlState <> nlBrowse then
    Exit;
  Prot0('%s %s geklickt', [Kurz, BtnLabiUpdate.Caption]);
// so sollte es später sein (Job):
//  //08.11.12 Labi to silo: sortiert auch nach probe_datum desc, probe_nr desc
//  // per Proc. Edit iVm roBeforeEdit zeigt eingesetzte Labi_Probe_Nr
//  FrmDataT.LABI_TO_SILO(Query1.FieldByName('SILO_ID').AsFloat);
//  LuLAER.Refresh;
//  Nav.DoEdit;  //lädt labi_prob_nr iVm roBeforeEdit
//  Nav.Commit;

// erstmal flexibel programmieren:
  LabiToSilo(cobLimsProbe.ItemIndex);
//  TblV_LABI_ERGEBNISSE.Open;
//  TblV_LABI_ERGEBNISSE.First;
//  if TblV_LABI_ERGEBNISSE.EOF then
//    EError('Keine LIMS Werte vorhanden (%s)', [Query1.FieldByName('LABI_SILO_FILTER').AsString]);
//  TblLAER.Open;
//  TblLAER.First;
//  if TblLAER.EOF then
//  begin
//    LuLAER.DoInsert;
//    LuLAER.AssignField('SILO_NR', Query1.FieldByName('SPS_CODE'));
//    LuLAER.AssignField('WERK_NR', Query1.FieldByName('SO_WERK_NR'));
//  end else
//    LuLAER.DoEdit;
//  for I := 1 to 9 do
//  begin  //es gibt aktuell nur 6 Parameter
//    S := Format('P%d', [I]);
//    if (TblLAER.FindField(S) <> nil) and (TblV_LABI_ERGEBNISSE.FindField(S) <> nil) then
//      LuLAER.AssignField(S, TblV_LABI_ERGEBNISSE.FieldByName(S));
//  end;
//  LuLAER.DoPost;
//  Nav.AssignField('LABI_PROBE_NR', TblV_LABI_ERGEBNISSE.FieldByName('PROBE_NR'));
//  Nav.DoPost;
  LuLAER.Refresh;
end;

procedure TFrmSilo.LabiToSilo(Modus: integer);
//Kopiert QULI Proben nach QUVA.LABI_ERGEBNISSE
//Modus: 0=letzte 5 Proben, 1=letzte Probe, 2=markierte Probe(n), 3=TEST1
//vergl. p_siebanlage.LABI_TO_SILO
//28.03.13 Probedatum
  procedure DoIt;
  //addiert Probe_Nr und Parameter 1-6
  var
    S1: string;
    I: integer;
    P: double;
    fldPROBE_DATUM: TField;
  begin
    with TblLAER do
    begin
      S1 := FieldByName('PROBE_NR').AsString;
      AppendTok(S1, TblV_LABI_ERGEBNISSE.FieldByName('PROBE_NR').AsString, ';');
      FieldByName('PROBE_NR').AsString := S1;
      for I := 1 to 6 do
      begin
        S1 := 'P' + IntToStr(I);
        P := FieldByName(S1).AsFloat + TblV_LABI_ERGEBNISSE.FieldByName(S1).AsFloat;
        FieldByName(S1).AsFloat := P;
      end;
      fldPROBE_DATUM := TblV_LABI_ERGEBNISSE.FieldByName('PROBE_DATUM');
      if not fldPROBE_DATUM.IsNull then
      begin
        if FieldByName('PROBE_DTM1').IsNull or
           (FieldByName('PROBE_DTM1').AsDateTime < fldPROBE_DATUM.AsDateTime) then
        begin  //neueste Probe
          LuLAER.AssignField('PROBE_DTM1', fldPROBE_DATUM);
        end;
        if FieldByName('PROBE_DTM2').IsNull or
           (FieldByName('PROBE_DTM2').AsDateTime > fldPROBE_DATUM.AsDateTime) then
        begin  //älteste Probe
          LuLAER.AssignField('PROBE_DTM2', fldPROBE_DATUM);
        end;
      end;
    end;
  end;

var
  I, N: integer;
  S1, ProbeNr: string;
  P: double;
begin
  Screen.Cursor := crHourGlass;
  try
    Prot0('%s LabiToSilo(%d)', [Kurz, Modus]);
    if Modus = 3 then
    begin
      ProbeNr := 'TEST1';
    end else
    begin
      //beware modus 1 - TblV_LABI_ERGEBNISSE.Open;
      //  TblV_LABI_ERGEBNISSE.First;
      if TblV_LABI_ERGEBNISSE.EOF then
        EError('Keine LIMS Werte vorhanden (%s)', [Query1.FieldByName('LABI_SILO_FILTER').AsString]);

      LuLAER.Navlink.Insert;
      LuLAER.AssignField('SILO_NR', Query1.FieldByName('SPS_CODE'));
      LuLAER.AssignField('WERK_NR', Query1.FieldByName('SO_WERK_NR'));

      N := 0;
      if Modus in [0, 1] then
      begin
        TblV_LABI_ERGEBNISSE.First;
        MuV_LABI_ERGEBNISSE.SelectedRows.Clear;
        while (N < 5) and not TblV_LABI_ERGEBNISSE.EOF do
        begin
          MuV_LABI_ERGEBNISSE.SelectedRows.CurrentRowSelected := true;
          Inc(N);
          if Modus = 1 then
            Break;
          TblV_LABI_ERGEBNISSE.Next;
        end;
      end else
      if Modus = 2 then
      begin
        if MuV_LABI_ERGEBNISSE.SelectedRows.Count = 0 then
          MuV_LABI_ERGEBNISSE.SelectedRows.CurrentRowSelected := true;
      end;
      N := 0;
      begin //jetzt ist markiert. if Modus = 0,1,2 then
        for I := 0 to MuV_LABI_ERGEBNISSE.SelectedRows.Count - 1 do
        begin
          MuV_LABI_ERGEBNISSE.DataSet.Bookmark := MuV_LABI_ERGEBNISSE.SelectedRows[I];
          DoIt;
          Inc(N);
        end;
      end;
      if N > 1 then with TblLAER do
      begin  //Avg bilden
        for I := 1 to 6 do
        begin
          S1 := 'P' + IntToStr(I);
          P := FieldByName(S1).AsFloat / N;
          FieldByName(S1).AsFloat := P;
        end;
      end;
      ProbeNr := TblLAER.FieldByName('PROBE_NR').AsString;
      try
        LuLAER.DoPost;
      except on E:Exception do begin
          Prot0('LAER %s bereits vorhanden', [ProbeNr]);
          //Idee bei test1: QueLAERDel.ExecSQL;
          //LuLAER.DoPost;
          TblLAER.Cancel;
        end;
      end;
    end;  //Modus
    Nav.AssignValue('LABI_PROBE_NR', ProbeNr);
    QueSILOUpd.ExecSQL;  //ProbeNr an andere Silos weitergeben mit gleichem SPS_Code
    Nav.DoPost;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmSilo.BtnInstallSILEClick(Sender: TObject);
// SIST_KEY -> SIST.LEISTUNG
begin
  Mu1.Loop(BtnInstallSILE.Caption, [mloConfirmation], ProcessInstallSILE);
end;

procedure TFrmSilo.BtnMuV_LABI_MKClick(Sender: TObject);
begin
  TblV_LABI_MK.Open;
end;

procedure TFrmSilo.chbLabiClick(Sender: TObject);
begin
  if Sender <> chbLabiSiloproben then
    chbLabiSiloproben.Checked := false;
  if TblV_LABI_ERGEBNISSE.Active then  //nicht bei Create
    LuV_LABI_ERGEBNISSE.Refresh;
end;

procedure TFrmSilo.chbSiebanteilClick(Sender: TObject);
begin
  if chbSiebanteil.Checked then
  try
    LuGRSO.Options := LuGRSO.Options + [luTolerant];
    Nav.AssignValue('GRUNDSORTE', SSiebanteil);
  finally
    LuGRSO.Options := LuGRSO.Options - [luTolerant];
  end else
  if Query1.FieldByName('GRUNDSORTE').AsString = SSiebanteil then
    Query1.FieldByName('GRUNDSORTE').Clear;
end;

procedure TFrmSilo.chbStrukturClick(Sender: TObject);
begin
  if chbStruktur.Checked then
  try
    LuGRSO.Options := LuGRSO.Options + [luTolerant];
    Nav.AssignValue('GRUNDSORTE', SStruktur);
  finally
    LuGRSO.Options := LuGRSO.Options - [luTolerant];
  end else
  if Query1.FieldByName('GRUNDSORTE').AsString = SStruktur then
    Query1.FieldByName('GRUNDSORTE').Clear;
end;

end.
