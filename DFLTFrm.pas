unit DFLTFrm;

interface

uses
  ComCtrls,
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form,
  Gen__Kmp, Mugrikmp, Psrc_kmp, Btnp_kmp, Lubtnkmp, Asws_Kmp, Spin,
  QSpin_kmp, qSplitter, MuSiControlFr, MuSiFr, DatumDlg, XLS;

type
  TFrmGEBI = class(TqForm)
    PageControl: TPageControl;
    tsMulti: TTabSheet;
    tsSingle: TTabSheet;
    DetailControl: TPageControl;
    tsEtc: TTabSheet;
    tsSystem: TTabSheet;
    ScrollBox4: TScrollBox;
    Panel1: TScrollBox;
    TabControl: TTabControl;
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
    ScrollBox5: TScrollBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cobFltrChange(Sender: TObject);
    procedure NavStart(Sender: TObject);
    procedure cobLSCH_TYPChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmGEBI: TFrmGEBI;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp, Err__Kmp, Ini__Kmp, AbortDlg, NLnk_Kmp,
  PARAFRM, mainfrm, DataFrm, FltrFrm;

procedure TFrmGEBI.FormCreate(Sender: TObject);
begin
  FrmGEBI := self;
  FrmPara.OnFormCreate(self);
end;

procedure TFrmGEBI.FormDestroy(Sender: TObject);
begin
  FrmGEBI := nil;
end;

procedure TFrmGEBI.FormResize(Sender: TObject);
begin
  FrmPara.OnFormResize(self);
end;

procedure TFrmGEBI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmGEBI.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmGEBI.cobFltrChange(Sender: TObject);
begin
  TFrmFltr.cobFltrChange(Sender);
end;

procedure TFrmGEBI.NavStart(Sender: TObject);
begin
  TFrmFltr.cobFltrInit(cobFltr);
end;

procedure TFrmGEBI.cobLSCH_TYPChange(Sender: TObject);
begin
  PostMessage(self.Handle, WM_NEXTDLGCTL, 0, 0);
end;

end.
