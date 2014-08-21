unit Hint_Dlg;
(* Dialog für Tabellenlayout
   05.01.00 MD Erstellt
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, TgridKmp, ExtCtrls,
  DPos_Kmp;

type
  TDlgHint = class(TForm)
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    BtnAuswahl: TBitBtn;
    laCaption: TLabel;
    Label2: TLabel;
    EdCaption: TEdit;
    MeHint: TMemo;
    Label1: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnAuswahlClick(Sender: TObject);
  private
    { Private declarations }
    FAswName: string;
    FSender: TWinControl;
  public
    { Public declarations }
    class function Execute(Sender: TWinControl;
      var ACaption: string; const AAswName: string): boolean;
    {Editieren. Ergibt true bei OK und false bei Abbruch}
  end;

function StrToHint(S: string): string;
function HintToStr(S: string): string;

var
  DlgHint: TDlgHint;
const
  sNil = '(ohne)';

implementation
{$R *.DFM}
uses
  Prots, Asws_Kmp, AswEdDlg, MuGriKmp;
const
  STabellenlayout = 'Tabellenlayo&ut';
  SAuswahl = 'A&uswahl';

(*** Hilfsroutinen ***)

function StrToHint(S: string): string;
begin
  result := StrCgeStrStr(S, '\r', CRLF, false);
end;

function HintToStr(S: string): string;
begin
  result := StrCgeStrStr(S, CRLF, '\r', false);
end;

(*** Execute ***)

class function TDlgHint.Execute(Sender: TWinControl;
      var ACaption: string; const AAswName: string): boolean;
{Editieren. Ergibt true bei OK und false bei Abbruch}
var
  ModResult: TModalResult;
begin
  result := false;
  with TDlgHint.Create(Application) do
  try
    Caption := LongCaption(Caption, Sender.Name);
    FAswName := AAswName;
    FSender := Sender;
    if Sender is TMultiGrid then
    begin
      BtnAuswahl.Caption := STabellenlayout;
      BtnAuswahl.Enabled := true;
    end else
    begin
      BtnAuswahl.Caption := SAuswahl;
      BtnAuswahl.Enabled := AAswName <> '';
    end;
    MeHint.Text := Sender.Hint;
    EdCaption.Text := ACaption;
    EdCaption.Enabled := ACaption <> sNil;
    LaCaption.Enabled := EdCaption.Enabled;
    ModResult := ShowModal;
    if ModResult = mrOK then
    begin
      Sender.Hint := MeHint.Text;
      if EdCaption.Enabled then
        ACaption := EdCaption.Text else
        ACaption := '';
      result := true;
    end;
  finally
  end;
end;

procedure TDlgHint.FormCreate(Sender: TObject);
begin
  DlgHint := self;
end;

procedure TDlgHint.FormDestroy(Sender: TObject);
begin
  DlgHint := nil;
end;

procedure TDlgHint.BtnAuswahlClick(Sender: TObject);
begin
  if BtnAuswahl.Caption = SAuswahl then
    TDlgAswEd.Execute(FAswName) else
    TMultiGrid(FSender).EditLayout;
end;

end.
