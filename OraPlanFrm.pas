unit OraPlanFrm;
(* Oracle PLAN_TABLE wird bei 'EXPLAIN PLAN FOR' gefüllt.
   11.08.02 MD  erstellt
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls,
  Grids, DBGrids, TabNotBk, Tabs, DBLookup, Dialogs,
  LNav_Kmp, GNav_Kmp, LuDefKmp, LuEdiKmp, Buttons, Qwf_Form, 
  Btnp_kmp, Mugrikmp, Lubtnkmp, PSrc_Kmp, Asws_Kmp, Tools, Zeitdlg,
  DatumDlg, Menus;

type
  TFrmOraPlan = class(TqForm)
    Query1: TuQuery;
    PageBook: TqNoteBook;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    DetailBook: TTabbedNotebook;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    PsDflt: TPrnSource;
    panBot: TPanel;
    LTabSet1: TLTabSet;
    Panel2: TPanel;
    Panel4: TPanel;
    PanMuTop: TPanel;
    PanRight: TPanel;
    BtnSingle: TqBtnMuSi;
    Panel5: TPanel;
    BtnMulti: TqBtnMuSi;
    Mu1: TMultiGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NavRech(ADataSet: TDataSet; Field: TField;
      OnlyCalcFields: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmOraPlan: TFrmOraPlan;

implementation
{$R *.DFM}
uses
  DPos_Kmp, Prots, CPro_Kmp, Err__Kmp, NLnk_Kmp, AbortDlg,
  MainFrm;

procedure TFrmOraPlan.FormCreate(Sender: TObject);
begin
  FrmOraPlan := self;
  //FrmPara.OnFormCreate(self);
end;

procedure TFrmOraPlan.FormDestroy(Sender: TObject);
begin
  FrmOraPlan := nil;
end;

procedure TFrmOraPlan.FormResize(Sender: TObject);
begin
  //FrmPara.OnFormResize(self);
end;

procedure TFrmOraPlan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmOraPlan.PsDfltBeforePrn(Sender: TObject; var fertig: Boolean);
begin
  FrmMain.DfltMultiGrid := Mu1;
end;

procedure TFrmOraPlan.NavRech(ADataSet: TDataSet; Field: TField;
  OnlyCalcFields: Boolean);
begin
  with ADataSet do
  begin
    if OnlyCalcFields then
    begin
    end else
    begin
    end;
  end;
end;

end.


