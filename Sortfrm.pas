unit Sortfrm;

interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, Uni, DBAccess, MemDS, Mask, ExtCtrls, TabNotBk,
  Tabs, Grids, DBGrids, Buttons,
  LNav_Kmp, LuDefKmp, Qwf_Form, Btnp_kmp, Mugrikmp, PSrc_Kmp,
  Luedikmp, Lubtnkmp, Gen__Kmp, UQue_Kmp;

type
  TFrmSort = class(TqForm)
    LDataSource1: TLDataSource;
    Nav: TLNavigator;
    LTabSet1: TLTabSet;
    PsDflt: TPrnSource;
    Mu1: TMultiGrid;
    Query1: TuQuery;
    QueDelete: TuQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NavBeforeInsert(ADataSet: TDataSet; var Done: Boolean);
  protected
  private
    { Private-Deklarationen }
    Active: boolean;
  public
    { Public-Deklarationen }
    class procedure CreateData;
  end;

var
  FrmSORT: TFrmSORT;

implementation

{$R *.DFM}

uses
  Dialogs,
  GNav_Kmp, Prots,
  MainFrm, ParaFrm;

class procedure TFrmSort.CreateData;
begin
  GNavigator.StartForm(Application.MainForm, 'SORT');
  FrmSort.Nav.DoInsert(true);
  FrmSort.Close;
end;

procedure TFrmSort.FormCreate(Sender: TObject);
begin
  FrmSORT := self;
end;

procedure TFrmSort.FormDestroy(Sender: TObject);
begin
  FrmSORT := nil;
end;

procedure TFrmSort.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSort.NavBeforeInsert(ADataSet: TDataSet; var Done: Boolean);
var
  I: integer;
begin
  if Active then
    Exit;
  Active := true;
  Done := true;
  QueryExecCommitted(QueDelete);
  try
    Query1.DisableControls;
    for I := 0 to 255 do
    try
      Nav.DoInsert(true);
      Query1.FieldByName('SORT_CODE').AsString := chr(I);
      Query1.FieldByName('SORT_NR').AsInteger := I;  //<-- sollte PKey sein
      Nav.DoPost;
      GMessA(I+1, 255);
      GNavigator.ProcessMessages;
    except           // Zeichen nicht speicherbar: Blank
      Query1.Cancel;
    end;
  finally
    Active := false;
    Query1.EnableControls;
    GMess0;
  end;
end;

end.
