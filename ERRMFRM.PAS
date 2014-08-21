unit Errmfrm;
(*

---------------------
select error,description
from master.dbo.sysmessages
where msglangid=1031

*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, UQue_Kmp, DBAccess, MemDS, Mask, ExtCtrls,
  LNav_Kmp, Grids, DBGrids, TabNotBk, Tabs, Buttons, Qwf_Form,
   Btnp_kmp, ComCtrls, Mugrikmp, qSplitter, Psrc_kmp;

type
  TFrmErrM = class(TqForm)
    Query1: TuQuery;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
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
    tsSystem: TTabSheet;
    SplitterIntern: TqSplitter;
    GbStatisitk: TGroupBox;
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
    EditERRM_NR: TDBEdit;
    MemoBEMERKUNG: TDBMemo;
    MemoBESCHR: TDBMemo;
    Mu1: TMultiGrid;
    psDFLT: TPrnSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NavGet(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure btnFltrClick(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmErrM: TFrmErrM;

implementation
{$R *.DFM}
uses
  Prots, MAINFRM, PARAFRM, FltrFrm;

procedure TFrmErrM.FormCreate(Sender: TObject);
begin
  FrmErrM := self;
  FrmPara.OnFormCreate(self);
end;

procedure TFrmErrM.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmErrM.FormDestroy(Sender: TObject);
begin
  FrmErrM := nil;
end;

procedure TFrmErrM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmErrM.NavGet(DataSet: TDataSet);
var
  S: string;
  AField: TField;
begin
  with Query1 do
  begin
    AField := FieldByName('ERRM_BESCHR');
    {S := GetFieldText( AField);}
    S := AField.Text;
    FieldByName('cfTEXT').AsString := S;
  end;
end;

procedure TFrmErrM.NavStart(Sender: TObject);
begin
  TFrmFltr.cobFltrInit(cobFltr);
end;

procedure TFrmErrM.btnFltrClick(Sender: TObject);
begin
  TSpeedButton(Sender).Down := false;
  TFrmFltr.LookUp(Kurz, Nav.NavLink, cobFltr.Text);
end;

procedure TFrmErrM.cobFltrChange(Sender: TObject);
begin
  if FrmFltr = nil then Debug0;  //für Compiler
  TFrmFltr.cobFltrChange(Sender);
end;

end.
