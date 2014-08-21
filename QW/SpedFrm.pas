unit SpedFrm;
(* Speditionen (ab SMH)
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
  MuSiFr, UQue_Kmp;

type
  TFrmSPED = class(TqForm)
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
    edSPED_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    Mu1: TMultiGrid;
    TabControl1: TTabControl;
    GroupBox1: TGroupBox;
    EdBEM: TDBMemo;
    TabSheet3: TTabSheet;
    LuZSPKU: TLookUpDef;
    FrZSPKU: TFrMuSi;
    Label3: TLabel;
    edWERK_NR: TDBEdit;
    Panel2: TPanel;
    chbWerk: TCheckBox;
    Query1: TuQuery;
    TblZSPKU: TuQuery;
    LuFRZG: TLookUpDef;
    TblFRZG: TuQuery;
    TabSheet4: TTabSheet;
    FrFRZG: TFrMuSi;
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
  FrmSPED: TFrmSPED;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp,
  MainFrm, PARAFRM;

procedure TFrmSPED.FormCreate(Sender: TObject);
begin
  FrmSPED := self;
  FrmPARA.OnFormCreate(self);
  //nboptions.pages.savetofile('c:\i1.txt');
end;

procedure TFrmSPED.FormResize(Sender: TObject);
begin
  FrmPARA.OnFormResize(self);
end;

procedure TFrmSPED.FormDestroy(Sender: TObject);
begin
  FrmSPED := nil;
end;

procedure TFrmSPED.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSPED.NavStart(Sender: TObject);
begin
  if not Nav.ReturnAktiv then
    chbWerk.Checked := true else
    Query1.Open;
end;

procedure TFrmSPED.chbWerkClick(Sender: TObject);
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

procedure TFrmSPED.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
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

procedure TFrmSPED.NavErfass(Sender: TObject);
begin
  with Query1 do
  begin
    Nav.AssignValue('WERK_NR', SysParam.WerkNr);
  end;
end;

end.
