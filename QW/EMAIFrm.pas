unit EMAIFrm;
(* Nachrichten (EMAILS Sendeaufträge)
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form, 
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Tools,
  MuSiFr, UQue_Kmp, qSplitter;

type
  TFrmEMAI = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    PageBook: TPageControl;
    tsSingle: TTabSheet;
    tsMulti: TTabSheet;
    Detailbook: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScrollBox3: TScrollBox;
    Label2: TLabel;
    edEMAI_SUBJECT: TDBEdit;
    ScrollBox4: TScrollBox;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edEMAI_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    Mu1: TMultiGrid;
    TabControl1: TTabControl;
    GroupBox1: TGroupBox;
    EdBEM: TDBMemo;
    Label3: TLabel;
    edWERK_NR: TLookUpEdit;
    Panel2: TPanel;
    chbWerk: TCheckBox;
    Query1: TuQuery;
    Label4: TLabel;
    Panel1: TPanel;
    cobSTATUS: TAswComboBox;
    edSENDEN_AM: TDBEdit;
    Label5: TLabel;
    edLFSK_NR: TLookUpEdit;
    Label6: TLabel;
    edEMAI_FROM: TLookUpEdit;
    Label7: TLabel;
    Label8: TLabel;
    edEMAI_TO: TLookUpEdit;
    Label14: TLabel;
    edEMVE_ID: TLookUpEdit;
    edEMAI_ATTACHMENTS: TLookUpEdit;
    Label15: TLabel;
    Label16: TLabel;
    edEMAI_TEXT: TLookUpMemo;
    qSplitter1: TqSplitter;
    cobFltr: TComboBox;
    Label18: TLabel;
    LuDiPr: TLookUpDef;
    TblDiPr: TuQuery;
    tsDiPr: TTabSheet;
    MuDiPr: TMultiGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbWerkClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavErfass(Sender: TObject);
    procedure qSplitter1Moved(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure NavGet(DataSet: TDataSet);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmEMAI: TFrmEMAI;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp, FLTRFrm,
  MainFrm, PARAFRM;

procedure TFrmEMAI.FormCreate(Sender: TObject);
begin
  FrmEMAI := self;
  FrmPARA.OnFormCreate(self);
  //nboptions.pages.savetofile('c:\i1.txt');
end;

procedure TFrmEMAI.FormResize(Sender: TObject);
begin
  FrmPARA.OnFormResize(self);
end;

procedure TFrmEMAI.qSplitter1Moved(Sender: TObject);
begin
  FrmPARA.OnFormResize(self);
end;

procedure TFrmEMAI.FormDestroy(Sender: TObject);
begin
  FrmEMAI := nil;
end;

procedure TFrmEMAI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmEMAI.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    chbWerk.Checked := true;
  TFrmFltr.cobFltrInit(cobFltr);  //mit open
end;

procedure TFrmEMAI.cobFltrChange(Sender: TObject);
begin
  TFrmFltr.cobFltrChange(Sender);
end;

procedure TFrmEMAI.chbWerkClick(Sender: TObject);
begin
  {if Nav.nlState in [nlQuery,nlBrowse] then}
  begin
    chbWerk.Caption := 'Werk ' + SysParam.WerkNr;
    Query1.Close;
    try
      if chbWerk.Checked then
        Nav.FltrList.Values['WERK_NR'] := SysParam.WerkNr else
        Nav.FltrList.Values['WERK_NR'] := '';
    finally
      Query1.Open;
    end;
  end;
end;

procedure TFrmEMAI.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
var
  S: string;
begin
  S := Nav.FltrList.Values['WERK_NR'];
  if S <> '' then
  begin
    PsDflt.Caption := 'Werk ' + S;
  end else
    PsDflt.Caption := '';
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmEMAI.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    Nav.AssignValue('WERK_NR', SysParam.WerkNr);
  end;
end;

procedure TFrmEMAI.NavGet(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('cfBEIN_NR').AsString := FieldByName('EMAI_ID').AsString;
  end;
end;

end.
