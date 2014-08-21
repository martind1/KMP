unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  RingKmp;

type
  TForm1 = class(TForm)
    BtnPushFirst: TBitBtn;
    BtnAvg: TBitBtn;
    Label1: TLabel;
    EdValue: TEdit;
    Label2: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPushFirstClick(Sender: TObject);
    procedure BtnAvgClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Ring: TRing;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Ring := TRing.Create(5);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Ring.Free;
end;

procedure TForm1.BtnPushFirstClick(Sender: TObject);
begin
  Ring.PushFirst(StrToInt(EdValue.Text));
end;

procedure TForm1.BtnAvgClick(Sender: TObject);
var
  I: integer;
begin
  EdValue.Text := FloatToStr(Ring.Avg);

  Memo1.Lines.Clear;
  Memo1.Lines.Add('Start:'+IntToStr(Ring.Start));
  Memo1.Lines.Add('Ende:'+IntToStr(Ring.Ende));
  Memo1.Lines.Add('N:'+IntToStr(Ring.N));
  for I := 0 to 4 do
  begin
    Memo1.Lines.Add(IntToStr(I)+':'+IntToStr(Ring.D[I]));
  end;
end;

end.
