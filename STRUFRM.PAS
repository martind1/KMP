unit StruFrm;

interface

uses
{$ifdef WIN32}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, ComCtrls,
  Lubtnkmp, PSrc_Kmp;
{$else}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,  Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, LuBtnKmp,
  PSrc_Kmp;
{$endif}

type
  TFrmStru = class(TqForm)
    Query1: TuQuery;
    Panel2: TPanel;
    PageBook: TqNoteBook;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Label2: TLabel;
    DetailBook: TTabbedNotebook;
    ScrollBox2: TScrollBox;
    Mu1: TMultiGrid;
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    BtnMulti: TBtnPage;
    BtnSingle: TBtnPage;
    EdFeldname: TDBEdit;
    EdTyp: TDBEdit;
    EdGroesse: TDBEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EdSchluessel: TDBEdit;
    Label6: TLabel;
    Ed_ErforderlicherWert: TDBEdit;
    Label7: TLabel;
    Ed_InvarianteFeldkennung: TDBEdit;
    PrnSource1: TPrnSource;
    CoAlias: TComboBox;
    CoTable: TComboBox;
    Label8: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CoAliasChange(Sender: TObject);
    procedure CoTableChange(Sender: TObject);
  protected
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmStru: TFrmStru;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots,
  MainFrm;

procedure TFrmStru.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmStru.FormCreate(Sender: TObject);
begin
  coAlias.Text := SysParam.Alias;
  Session.GetAliasNames( coAlias.Items);
end;

procedure TFrmStru.CoAliasChange(Sender: TObject);
begin
  Session.GetTableNames( coAlias.Text, 'stru*.db', False, True, coTable.Items);
end;

procedure TFrmStru.CoTableChange(Sender: TObject);
begin
  Query1.Close;
  Nav.TableName := coTable.Text;
  Query1.Open;
end;

end.
