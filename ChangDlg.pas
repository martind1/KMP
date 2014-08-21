unit ChangDlg;
(* 07.04.00 MD nur Delphi32. MarkList -> DBGrid.SelectedRows
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Gauges, ExtCtrls,
  NLnk_Kmp;

type
  TDlgChange = class(TForm)
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    LaGesamt: TLabel;
    Label3: TLabel;
    Gauge1: TGauge;
    Label4: TLabel;
    LaBearbeitet: TLabel;
    Label6: TLabel;
    LaNoTrans: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    RcGesamt, RcBearbeitet: longint;
    NavLink: TNavLink;
    procedure ShowStatus;
  public
    { Public declarations }
    Cancel: boolean;
    procedure Increment;
  end;

  function CreateChangeDlg( ANavLink: TNavLink; ACaption: string): TDlgChange;

implementation
{$R *.DFM}
uses
  SysUtils,
  GNav_Kmp;

function CreateChangeDlg( ANavLink: TNavLink; ACaption: string): TDlgChange;
var
  RecCount: longint;
begin
  try
    if (ANavLink.DBGrid <> nil) and
       (ANavLink.DBGrid.SelectedRows.Count > 0) then
      RecCount := ANavLink.DBGrid.SelectedRows.Count else
      RecCount := ANavLink.RecordCount;
  except
    RecCount := 0;
  end;
  result := TDlgChange.Create( Application);
  result.Caption := ACaption;
  result.RcGesamt:= RecCount;
  result.RcBearbeitet := 0;
  result.NavLink := ANavLink;
  result.ShowStatus;
  result.Show;
end;

procedure TDlgChange.Increment;
begin
  Inc( RcBearbeitet);
  ShowStatus;
end;

procedure TDlgChange.ShowStatus;
const
  FMT = '##,###';
begin
  LaGesamt.Caption := FormatFloat( FMT, RcGesamt);
  LaBearbeitet.Caption := FormatFloat( FMT, RcBearbeitet);
  if RcGesamt = 0 then
    Gauge1.Progress := 0 else
    Gauge1.Progress := (RcBearbeitet * 100) div RcGesamt;
  if NavLink.NoTransaction then
    LaNoTrans.Caption := 'Ohne Transaktion' else
    LaNoTrans.Caption := '';
  GNavigator.ProcessMessages;
end;

procedure TDlgChange.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
end;

procedure TDlgChange.CancelBtnClick(Sender: TObject);
begin
  Cancel := true;
end;

end.
