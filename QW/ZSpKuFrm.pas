unit ZSpKuFrm;
(* Zuordnung Spedition Kunden
   08.12.05 MD  erstellt
*)

interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS,
  Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form, 
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Tools, UQue_Kmp;

type
  TFrmZSpKu = class(TqForm)
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
    edSPED_NAME: TDBEdit;
    ScrollBox4: TScrollBox;
    Label1: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edZSPKU_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    Mu1: TMultiGrid;
    Panel2: TPanel;
    chbWerk: TCheckBox;
    TabControl1: TTabControl;
    Panel1: TPanel;
    Label5: TLabel;
    edWERK_NR: TLookUpEdit;
    GroupBox1: TGroupBox;
    EdBEM: TDBMemo;
    Label3: TLabel;
    edKUNW_NR: TLookUpEdit;
    LuADRE: TLookUpDef;
    BtnKUNW_NR: TLookUpBtn;
    edSO_KUNW_NAME1: TLookUpEdit;
    edSO_KUNW_LAND: TLookUpEdit;
    edSO_KUNW_ORT: TLookUpEdit;
    Query1: TuQuery;
    TblADRE: TuQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chbWerkClick(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavErfass(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmZSpKu: TFrmZSpKu;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp,
  MainFrm, PARAFRM;

procedure TFrmZSpKu.FormCreate(Sender: TObject);
begin
  FrmZSPKU := self;
  FrmPARA.OnFormCreate(self);
  //nboptions.pages.savetofile('c:\i1.txt');
end;

procedure TFrmZSpKu.FormResize(Sender: TObject);
begin
  FrmPARA.OnFormResize(self);
end;

procedure TFrmZSpKu.FormDestroy(Sender: TObject);
begin
  FrmZSPKU := nil;
end;

procedure TFrmZSpKu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmZSpKu.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    chbWerk.Checked := true else
  begin
    edSPED_NAME.Readonly := true;
    Query1.Open;
  end;
end;

procedure TFrmZSpKu.chbWerkClick(Sender: TObject);
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

procedure TFrmZSpKu.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
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

procedure TFrmZSpKu.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    Nav.AssignValue('WERK_NR', SysParam.WerkNr);
  end;
end;

end.
