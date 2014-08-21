unit EMGRFrm;
(* E-Mail Gruppen

24.08.08 MD  erstellt
23.12.09 MD  plus CC (EMGR_CC)
             wenn Sender (SR=S) dann andere Notebook Seite

*)
{ ERL : LuEMAI mdDetail, FrEMAI }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  nexcel,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  ComCtrls, Spin, qSplitter, MuSiFr, Gen__Kmp, Asws_Kmp, DPos_Kmp,
  DatumDlg, NXls_Kmp, Luedikmp, Lubtnkmp, Menus;

type
  TFrmEMGR = class(TqForm)
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
    edEMGR_NAME: TLookUpEdit;
    Mu1: TMultiGrid;
    tsEMAI: TTabSheet;
    qSplitter1: TqSplitter;
    Panel4: TPanel;
    rgSR_FLAG: TAswRadioGroup;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    MiAdrDel: TMenuItem;
    pcAdressen: TPageControl;
    tsReceiver: TTabSheet;
    tsSender: TTabSheet;
    Label6: TLabel;
    EdEMGR_ADR_Sender: TDBEdit;
    Panel1: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    edEMGR_ADR: TDBMemo;
    EdAdr: TEdit;
    BtnAdrAdd: TBitBtn;
    BtnAdrCC: TBitBtn;
    qSplitter2: TqSplitter;
    Panel5: TPanel;
    Label4: TLabel;
    edEMGR_CC: TDBMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure NavPostStart(Sender: TObject);
    procedure NavErfass(Sender: TObject);
    procedure BtnAdrAddClick(Sender: TObject);
    procedure BtnAdrCCClick(Sender: TObject);
    procedure LDataSource1DataChange(Sender: TObject; Field: TField);
  private
  protected
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmEMGR: TFrmEMGR;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots, Ini__Kmp, NLnk_Kmp, Err__Kmp, Tools,
  MainFrm, PARAFRM, FltrFrm, DataFrm;

{ Standard }

procedure TFrmEMGR.FormCreate(Sender: TObject);
begin
  FrmEMGR := self;
  FrmPara.OnFormCreate(self);
end;

procedure TFrmEMGR.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmEMGR.FormDestroy(Sender: TObject);
begin
  FrmEMGR := nil;
end;

procedure TFrmEMGR.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmEMGR.NavStart(Sender: TObject);
begin
  TFrmFltr.cobFltrInit(cobFltr);
end;

procedure TFrmEMGR.NavPostStart(Sender: TObject);
begin
  self.BringToFront;
end;

procedure TFrmEMGR.btnFltrClick(Sender: TObject);
begin
  TSpeedButton(Sender).Down := false;
  TFrmFltr.LookUp(Kurz, Nav.NavLink, cobFltr.Text);
end;

procedure TFrmEMGR.cobFltrChange(Sender: TObject);
begin
  if FrmFltr = nil then Debug0;  //für Compiler
  TFrmFltr.cobFltrChange(Sender);
end;

{ Anwendung }

procedure TFrmEMGR.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    FieldByName('SR_FLAG').AsString := Emgr_An
  end;
end;

procedure TFrmEMGR.BtnAdrAddClick(Sender: TObject);
var
  L: TStringList;
begin
  Nav.DoEdit;
  L := TStringList.Create;
  try
    GetFieldStrings(Query1.FieldByName('EMGR_ADR'), L);
    L.Text := AnsiUpperCase(L.Text);
    if L.IndexOf(AnsiUpperCase(EdAdr.Text)) < 0 then
    begin
      L.Add(EdAdr.Text);
      AddFieldLine(Query1.FieldByName('EMGR_ADR'), EdAdr.Text);
    end;
    EdAdr.Text := '';
  finally
    L.Free;
  end;
end;

procedure TFrmEMGR.BtnAdrCCClick(Sender: TObject);
var
  L: TStringList;
begin
  Nav.DoEdit;
  L := TStringList.Create;
  try
    GetFieldStrings(Query1.FieldByName('EMGR_CC'), L);
    L.Text := AnsiUpperCase(L.Text);
    if L.IndexOf(AnsiUpperCase(EdAdr.Text)) < 0 then
      AddFieldLine(Query1.FieldByName('EMGR_CC'), EdAdr.Text);
    EdAdr.Text := '';
  finally
    L.Free;
  end;
end;

procedure TFrmEMGR.LDataSource1DataChange(Sender: TObject; Field: TField);
begin
  pcAdressen.ActivePageIndex := IMax(0, FrmMain.AswEmgrSrFlag.Items.IndexOfName(
    Query1.FieldByName('SR_FLAG').AsString));
end;

end.
