unit Makrodlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, TgridKmp, ExtCtrls, UCLinePrinter;

type
  TDlgMakro = class(TForm)
    Grid: TTitleGrid;
    Panel1: TPanel;
    Label1: TLabel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    UCLinePrinter1: TUCLinePrinter;
    BtnDrucken: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnDruckenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DlgMakro: TDlgMakro;

implementation
{$R *.DFM}
uses
  SysUtils, Printers,
  Prots, GNav_Kmp;

procedure TDlgMakro.FormCreate(Sender: TObject);
begin
  {Grid.ColWidths[1] := Grid.Width - 4 - Grid.ColWidths[0];}
  GNavigator.TranslateForm(self);
  BtnDrucken.Hint := Printer.Title;
end;

procedure TDlgMakro.FormResize(Sender: TObject);
begin
  Grid.ColWidths[1] := Grid.Width - 4 - Grid.ColWidths[0];
end;

procedure TDlgMakro.BtnDruckenClick(Sender: TObject);
var
  Y: integer;
begin
  UCLinePrinter1.PrintTitle := LongCaption(Application.MainForm.Caption, self.Caption);
  UCLinePrinter1.Lines.Clear;
  for Y := 0 to Grid.RowCount - 1 do
  begin
    UCLinePrinter1.Lines.Add(Format('%-15.15s%s', [Grid.Cells[0, Y], Grid.Cells[1, Y]]));
  end;
  UCLinePrinter1.Print;
end;

end.
