unit Ro8_3964Simul;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Ro8_3964Kmp, StdCtrls, Spin;

type
  TDlgRo8Simul = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label4: TLabel;
    SpinEdit3: TSpinEdit;
    Label5: TLabel;
    SpinEdit4: TSpinEdit;
    Label6: TLabel;
    SpinEdit5: TSpinEdit;
    Label7: TLabel;
    SpinEdit6: TSpinEdit;
    Label8: TLabel;
    procedure SpinEditChange(Sender: TObject);
  public
    { Public-Deklarationen }
    SimGewichte: array[1..Ro8MaxWaagen] of double;
    constructor Create(Sender: TComponent); override;
    destructor Destroy; override;
    class function Execute(Sender: TComponent): TDlgRo8Simul;
  end;

var
  DlgRo8Simul: TDlgRo8Simul;

implementation

{$R *.DFM}

class function TDlgRo8Simul.Execute(Sender: TComponent): TDlgRo8Simul;
begin
  {DlgRo8Simul := Create(Sender);
  DlgRo8Simul.Show;}
  with TDlgRo8Simul.Create(Sender) do
    Show;
  Result := DlgRo8Simul;
end;

constructor TDlgRo8Simul.Create(Sender: TComponent);
var i: Integer;
begin
  inherited;
  DlgRo8Simul := self;
  for i := 1 to Ro8MaxWaagen do
    SimGewichte[i] := 0;
end;

destructor TDlgRo8Simul.Destroy;
begin
  DlgRo8Simul := nil;
  inherited;
end;

procedure TDlgRo8Simul.SpinEditChange(Sender: TObject);
var sped : TSpinEdit;
begin
  sped := (Sender as TSpinEdit);
  SimGewichte[sped.Tag] := sped.Value / 1000;
end;

initialization
  DlgRo8Simul := nil;

end.
