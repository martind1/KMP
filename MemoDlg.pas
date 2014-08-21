unit MemoDlg;
(* Memo Dialog
07.06.09 MD  erstellt
*)

interface

uses WinProcs, WinTypes, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,
  Prots, Grids, Calendar;

type
  TDlgMemo = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(const ACaption, APrompt: string; var Value: string): Boolean;
  end;

implementation
{$R *.DFM}
uses
  Err__Kmp, GNav_Kmp, KmpResString;

class function TDlgMemo.Execute(const ACaption, APrompt: string; var Value: string): Boolean;
begin
  Result := false;
  with TDlgMemo.Create(Application.MainForm) do
  try
    Caption := ACaption;
    Panel1.Caption := APrompt;
    Memo1.Lines.Text := Value;
    if ShowModal = mrOK then
    begin
      Value := Memo1.Lines.Text;
      Result := Value <> '';
    end;
  finally
    Release;
  end;
end;

procedure TDlgMemo.FormCreate(Sender: TObject);
begin
  GNavigator.TranslateForm(self);
end;

end.
