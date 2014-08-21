unit Ini__Dlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  CPor_Kmp, ExtCtrls, Buttons, Ini__Kmp;

type
  TDlgIni = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    LaSection: TLabel;
    Label3: TLabel;
    LaIdent: TLabel;
    Label4: TLabel;
    LaFileName: TLabel;
    Label5: TLabel;
    EdValue: TEdit;
    OpenDialog1: TOpenDialog;
    BtnValue: TBitBtn;
    Bevel1: TBevel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    procedure BtnValueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(Ini: TIniKmp; Section, Ident: string): string;
  end;

implementation
{$R *.DFM}

class function TDlgIni.Execute(Ini: TIniKmp; Section, Ident: string): string;
begin
  result := '';
  with TDlgIni.Create(Application.MainForm) do
  begin
    LaFileName.Caption := Ini.FileName;
    LaSection.Caption := Format('[%s]', [Section]);
    LaIdent.Caption := Format('%s=', [Ident]);
    if ShowModal = mrOK then
    try
      Ini.WriteString(Section, Ident, EdValue.Text);
      result := EdValue.Text;
    finally
    end;
  end;
end;

procedure TDlgIni.BtnValueClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EdValue.Text := OpenDialog1.FileName;
end;

end.
