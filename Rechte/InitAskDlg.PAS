unit InitAskDlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, Dialogs, ExtCtrls;

type
  TDlgInitAsk = class(TForm)
    gbSection: TGroupBox;
    lbEntries: TListBox;
    rgTyp: TRadioGroup;
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    btnIgnore: TBitBtn;
    procedure EditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(Section: string; Entries: TStrings; var ResultTyp: char): boolean;
  end;

var
  DlgInitAsk: TDlgInitAsk;

implementation
{$R *.DFM}
uses
  SysUtils,
  Prots;

class function TDlgInitAsk.Execute(Section: string; Entries: TStrings; var ResultTyp: char): boolean;
var
  Btn: word;
  I: integer;
const
  Types: array[0..3] of char = ('A', 'M', 'U', 'V');
begin
  DlgInitAsk := Create(Application);
  DlgInitAsk.gbSection.Caption := Format(DlgInitAsk.gbSection.Caption, [Section]);
  DlgInitAsk.lbEntries.Items.Assign(Entries);
  for I := low(Types) to high(Types) do
    if Types[I] = ResultTyp then
    begin
      DlgInitAsk.rgTyp.ItemIndex := I;
      break;
    end;
  DlgInitAsk.EditChange(DlgInitAsk);
  Btn := DlgInitAsk.ShowModal;
  result := false;
  if Btn = mrOK then
  begin
    result := true;
    ResultTyp := Types[DlgInitAsk.rgTyp.ItemIndex];
  end else
  if Btn = mrIgnore then
  begin
    result := true;
    ResultTyp := #0;  //ignorieren
  end;
  DlgInitAsk.Release;
  DlgInitAsk := nil;
end;

procedure TDlgInitAsk.EditChange(Sender: TObject);
begin
  btnOK.Enabled := rgTyp.ItemIndex >= 0;
end;

end.

