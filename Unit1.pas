unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, DASQLMonitor,
  UniSQLMonitor;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    UniSQLMonitor1: TUniSQLMonitor;
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox1Select(Sender: TObject);
  private
    Selected: array of Boolean;
    procedure GenerateSQL(var S: string);
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
uses
  Prots;

procedure AddStr(var Dest: string; const S: string);
begin        {wie AppendStr aber ohne Leak}
  Dest := Format('%s%s', [Dest, S]);    //hört bei 4107 auf - 06.06.12
end;

procedure TForm1.GenerateSQL(var S: string);
var
  I: integer;
begin
  S := '';
  for I := 1 to 10000 do
    AddStr(S, ',' + IntToStr(I));
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  S1: string;
begin
//  GenerateSQL(S1);
//  Memo1.Lines.Text := S1;
//  Memo1.Lines.Text := '(' + FormatFloat('', 0.5) + ')';
Memo1.Lines.Text := IntToStr( StrToIntTol('0010393'));
end;

//http://www.swissdelphicenter.ch/torry/showcode.php?id=2155

procedure TForm1.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  SetLength(Selected, TComboBox(Control).Items.Count);
  with TComboBox(Control).Canvas do
  begin
    FillRect(rect);

    Rect.Left := Rect.Left + 1;
    Rect.Right := Rect.Left + 13;
    Rect.Bottom := Rect.Bottom;
    Rect.Top := Rect.Top;

    if not (odSelected in State) and (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (odFocused in State) and (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if not (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);

    TextOut(Rect.Left + 15, Rect.Top, TComboBox(Control).Items[Index]);
  end;
end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var
  i: Integer;
  Sel: string;
begin
  Sel := EmptyStr;
  Selected[TComboBox(Sender).ItemIndex] := not Selected[TComboBox(Sender).ItemIndex];
  for i := 0 to TComboBox(Sender).Items.Count - 1 do
    if Selected[i] then
      Sel := Sel + TComboBox(Sender).Items[i] + ' ';
  ShowMessage(Sel);  //Just for test...
end;

end.
