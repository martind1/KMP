unit Vartfrm;
(* Versandarten
   11.12.05 MD  Max_Brutto
*)
interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls,
  LNav_Kmp, Grids, DBGrids, TabNotBk, Tabs, Buttons, Qwf_Form, Kmp__reg,
  Btnp_kmp, Mugrikmp, PSrc_Kmp, Asws_Kmp;

type
  TFrmVart = class(TqForm)
    Query1: TuQuery;
    PageBook: TqNoteBook;
    Panel2: TPanel;
    BtnMulti: TqBtnMuSi;
    BtnSingle: TqBtnMuSi;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    EdVERSANDBEZEICHNUNG: TDBEdit;
    EdVERSANDWEG: TDBEdit;
    EdVERSANDART_TYP: TDBEdit;
    DetailBook: TTabbedNotebook;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    EditVART_ID: TDBEdit;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    PSrcVart: TPrnSource;
    RgVERSANDART_TYP: TDBRadioGroup;
    chbMASTER: TDBCheckBox;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    edTARA_GEWICHT: TDBEdit;
    Label11: TLabel;
    Label12: TLabel;
    edLADE_GEWICHT: TDBEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edMAX_BRUTTO: TDBEdit;
    GroupBox2: TGroupBox;
    MemoBEMERKUNG: TDBMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PSrcVartBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NavStart(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmVart: TFrmVart;

implementation

uses
  MainFrm, ParaFrm;

{$R *.DFM}

procedure TFrmVart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmVart.PSrcVartBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmVart.FormCreate(Sender: TObject);
begin
  FrmVART := self;
  FrmPara.OnFormCreate(self);
end;

procedure TFrmVart.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmVart.NavStart(Sender: TObject);
begin
  if Query1.FindField('MAX_BRUTTO') <> nil then
    edMAX_BRUTTO.DataField := 'MAX_BRUTTO';
end;

end.
