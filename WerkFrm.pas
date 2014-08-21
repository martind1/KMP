unit werkfrm;

interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp,
  Lubtnkmp, Gen__Kmp, Psrc_kmp, UQue_Kmp;

type
  TFrmWerk = class(TqForm)
    TblBein: TuQuery;
    Query1: TuQuery;
    Panel2: TPanel;
    qNoteBook1: TqNoteBook;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    EditWERK_NR: TDBEdit;
    EditWERK_NAME: TDBEdit;
    DetailBook: TTabbedNotebook;
    Label3: TLabel;
    MemoBEMERKUNG: TDBMemo;
    MuBein: TMultiGrid;
    Panel3: TPanel;
    BtnBeinMulti: TqBtnMuSi;
    BtnBeinSingle: TqBtnMuSi;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EditWERK_ID: TDBEdit;
    EditERFASST_VON: TDBEdit;
    EditERFASST_AM: TDBEdit;
    EditGEAENDERT_VON: TDBEdit;
    EditGEAENDERT_AM: TDBEdit;
    EditANZAHL_AENDERUNGEN: TDBEdit;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    LuBein: TLookUpDef;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    ComboERFASST_VON: TDBComboBox;
    Label1: TLabel;
    Button1: TButton;
    BtnMulti: TBtnPage;
    BtnSingle: TBtnPage;
    LookUpBtn1: TLookUpBtn;
    PrnSource1: TPrnSource;
    DBRadioGroup1: TDBRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnBeinSingleClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmWerk: TFrmWerk;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots,
  MainFrm;

procedure TFrmWerk.FormCreate(Sender: TObject);
begin
  {TblBEIN.Open;         {Detail !}
end;

procedure TFrmWerk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
(*
  for i := componentCount-1 downto 0 do
  begin
    with Components[i] do
    begin
      try
        smess('%d.Name(%s)',[i,name]);
        prota('%d.Name(%s)',[i,name]);
        free;
      except
        smess('Fehler',[0]);
        prota('Fehler',[0]);
      end;
    end;
  end;
  smess('Ende',[0]);
  prota('Ende',[0]);
  free();
  *)
end;

procedure TFrmWerk.BtnBeinSingleClick(Sender: TObject);
begin
  LuBein.LookUp(lumZeigMsk);
  BtnBeinMulti.Down := true;
end;

procedure TFrmWerk.Button1Click(Sender: TObject);
begin
  if Nav <> nil then
  begin
  end;
end;

end.
