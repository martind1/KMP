unit Passdlg;
(* neues Passwort eingeben. Unverschlüsselt.
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TDlgPass = class(TForm)
    Label1: TLabel;
    EdPassword: TEdit;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Label2: TLabel;
    EdPassword2: TEdit;
    procedure EdPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(Sender: TComponent): string;
  end;

var
  DlgPass: TDlgPass;

implementation

{$R *.DFM}

class function TDlgPass.Execute(Sender: TComponent): string;
var
  Btn: word;
begin
  DlgPass := Create(Sender);
  Btn := DlgPass.ShowModal;
  if Btn = mrOK then
    result := DlgPass.EdPassword.Text else
    result := '';
  DlgPass.Free;
  DlgPass := nil;
end;

procedure TDlgPass.EdPasswordChange(Sender: TObject);
begin
  BtnOK.Enabled := (EdPassword.Text = EdPassword2.Text) and
                   (length(EdPassword.Text) > 0);
end;

end.

