unit ProtToHexFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFrmProtToHex = class(TForm)
    Label1: TLabel;
    EdProt: TEdit;
    EdHex: TEdit;
    Label2: TLabel;
    BtnStart: TBitBtn;
    procedure BtnStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function ProtToHex(S: string): string;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FrmProtToHex: TFrmProtToHex;

implementation

{$R *.DFM}

procedure TFrmProtToHex.BtnStartClick(Sender: TObject);
begin
  EdHex.Text := ProtToHex(EdProt.Text);
end;

function TFrmProtToHex.ProtToHex(S: string): string;
var
  I, Step: integer;
begin
  Step := 0;
  result := '';
  for I := 1 to length(S) do
  begin
    //result := result + ProtChToHex(S1) + ' ');
    case Step of
0:    if S[I] = '^' then
        Step := 1 else
        result := result + Format('%02.2X ', [ord(S[I])]);
1:    begin
        result := result + Format('%02.2X ', [ord(S[I]) - 64]);
        Step := 0;
      end;
    end;
  end;
end;

procedure TFrmProtToHex.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
