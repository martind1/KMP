unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  LfskNr: int64;
  I1, I2: integer;
begin
  LfskNr := StrToInt64(Edit1.Text);
  I1 := Int64Rec(LfskNr).Lo;
  I2 := Int64Rec(LfskNr).Hi;
  Edit2.Text := IntToStr(I1);
  Edit3.Text := IntToStr(I2);

  LfskNr := 0;
  Int64Rec(LfskNr).Lo := I1;
  Int64Rec(LfskNr).Hi := I2;
  Edit4.Text := IntToStr(LfskNr);

end;

end.
