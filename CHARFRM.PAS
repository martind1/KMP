unit CharFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, TgridKmp, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    Grid: TTitleGrid;
    Panel1: TPanel;
    BtnZeichen: TBitBtn;
    BtnCode: TBitBtn;
    EdZeichen: TEdit;
    EdCode: TEdit;
    BtnFont: TBitBtn;
    FontDialog1: TFontDialog;
    procedure FormShow(Sender: TObject);
    procedure EdZeichenChange(Sender: TObject);
    procedure EdCodeChange(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnZeichenClick(Sender: TObject);
    procedure BtnCodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FontDialog1Apply(Sender: TObject; Wnd: HWND);
  private
    { Private-Deklarationen }
    Busy: boolean;
    procedure AppActivate(Sender: TObject);
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnActivate := AppActivate;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  I: integer;
begin
  if not Busy then
  try
    Busy := true;
    for I := 0 to 255 do
    begin
      Grid.Cells[0,I+1] := '     ' + char(I);
      Grid.Cells[1,I+1] := Format('%03d', [I]);
      Grid.Cells[2,I+1] := Format('%02.2X', [I]);
    end;
  finally
    Busy := false;
  end;
end;

procedure TForm1.GridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
begin
  if not Busy then
  try
    Busy := true;
    EdZeichen.Text := Grid.Cells[0,Row];
    EdCode.Text := Grid.Cells[1,Row];
  finally
    Busy := false;
  end;
end;

procedure TForm1.EdZeichenChange(Sender: TObject);
var
  I: integer;
begin
  if not Busy then
  try
    Busy := true;
    for I := 0 to 255 do
    begin
      if copy(Grid.Cells[0,I+1], 6, 1) = EdZeichen.Text then
      begin
        Grid.Row := I + 1;
        EdCode.Text := IntToStr(I);
      end;
    end;
  finally
    Busy := false;
  end;
end;

procedure TForm1.EdCodeChange(Sender: TObject);
var
  I: integer;
begin
  if not Busy then
  try
    Busy := true;
    for I := 0 to 255 do
    begin
      if StrToIntDef(Grid.Cells[1,I+1],-1) = StrToIntDef(EdCode.Text, -2) then
      begin
        Grid.Row := I + 1;
        EdZeichen.Text := char(I);
      end;
    end;
  finally
    Busy := false;
  end;
end;

procedure TForm1.BtnFontClick(Sender: TObject);
begin
  FontDialog1.Font := Grid.Font;
  if FontDialog1.Execute then
    FontDialog1Apply(sender, 0);
end;

procedure TForm1.FontDialog1Apply(Sender: TObject; Wnd: HWND);
begin
  Grid.Font := FontDialog1.Font;
end;

procedure TForm1.BtnZeichenClick(Sender: TObject);
begin
  EdZeichen.SelectAll;
  EdZeichen.CopyToClipboard;
end;

procedure TForm1.BtnCodeClick(Sender: TObject);
begin
  EdCode.SelectAll;
  EdCode.CopyToClipboard;
end;

procedure TForm1.AppActivate(Sender: TObject);
begin
  EdZeichen.SelectAll;
  EdCode.SelectAll;
end;

procedure TForm1.GridExit(Sender: TObject);
begin
  EdZeichen.SelectAll;
  EdCode.SelectAll;
end;

procedure TForm1.GridKeyPress(Sender: TObject; var Key: Char);
begin
  EdZeichen.Text := Key;
  Key := #0;
end;

end.
