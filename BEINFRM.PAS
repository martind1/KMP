unit Beinfrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Tabs,  Uni, DBAccess, MemDS, DB, Buttons, ExtCtrls,
  StdCtrls, Mask, DBCtrls, Grids, DBGrids, Rzlabel,
  Qwf_Form, LuEdiKmp, LuDefKmp, LNav_Kmp, DBLookup, Btnp_kmp, Lubtnkmp,
  Mugrikmp, PSrc_kmp, DatumDlg, Ausw_Kmp, Zeitdlg;

type
  TFrmBein = class(TqForm)
    PageBook: TNoteBook;
    Label1: TLabel;
    Label2: TLabel;
    EdBEIN_NR: TDBEdit;
    EdBEIN_NAME: TDBEdit;
    Panel1: TPanel;
    QueryBEIN: TuQuery;
    TblWERK: TuQuery;
    Label3: TLabel;
    DSBEIN: TDataSource;
    LTabSet: TTabSet;
    BtnWerk: TButton;
    EdBEMERKUNG: TDBMemo;
    Label4: TLabel;
    EdMYRECH: TDBEdit;
    Label5: TLabel;
    EdWERK_NAMR: TDBEdit;
    BtnDisable: TButton;
    LNav1: TLNavigator;
    BtnSingle: TqBtnMuSi;
    BtnMulti: TqBtnMuSi;
    LuWerk: TLookUpDef;
    LeWERK_NR: TLookUpEdit;
    MuBein: TMultiGrid;
    PsQRep: TPrnSource;
    EdBEIN_ID: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    EdBEIN_WERK_ID: TLookUpEdit;
    Label8: TLabel;
    EdGEAENDERT_AM: TDBEdit;
    LookUpBtn1: TLookUpBtn;
    BtnEdGEAENDERT_AM: TDatumBtn;
    EdERFASST_AM: TDBEdit;
    TimeBtn1: TTimeBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnWerkClick(Sender: TObject);
    procedure BtnDisableClick(Sender: TObject);
    procedure LNav1Get(DataSet: TDataset);
    procedure LNav1Rech(ADataSet: TDataset; Field: TField;
      OnlyCalcFields: Boolean);
    procedure LNav1PageChange(PageIndex: Integer);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmBein: TFrmBein;

implementation
{$R *.DFM}
uses
  Prots;

procedure TFrmBein.FormCreate(Sender: TObject);
begin
  FrmBein := self;
end;

procedure TFrmBein.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FrmBein := nil;
end;

procedure TFrmBein.BtnWerkClick(Sender: TObject);
begin
  begin
    SMess('Werk%d',[0]);
    TblWerk.Edit;
  end;
end;

procedure TFrmBein.BtnDisableClick(Sender: TObject);
begin
  TblWerk.DisableControls;
end;

procedure TFrmBein.LNav1Get(DataSet: TDataset);
begin
  with QueryBEIN do
  begin
    FieldByName('MYRECH').AsString :=
      FieldByName('BEIN_NR').AsString + FieldByName('SO_WERK_NR').AsString;
  end;
end;

procedure TFrmBein.LNav1Rech(ADataSet: TDataset; Field: TField;
  OnlyCalcFields: Boolean);
var
  NextS: string;
begin
  if not OnlyCalcFields then
  begin
    EdBemerkung.Lines.Clear;
    EdBemerkung.Lines.Add( PStrTok(EdBEIN_NAME.Text, ';.', NextS));
  end;
end;

procedure TFrmBein.LNav1PageChange(PageIndex: Integer);
begin
  TblWerk.Active := PageIndex < 10;
end;

end.
