unit FltrDlg;
(* Abfrage speichern
06.08.08 md  öffentlich/ privat/ Benutzergruppe statt IsPublic
             PublicState: 0/1/2
             var Users: string (falls PublicState=2) -> ERFASST_VON
*)

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TDlgFltr = class(TForm)
    Label1: TLabel;
    EdName: TEdit;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    chbIsPublic: TCheckBox;
    chbColumnList: TCheckBox;
    LaUsers: TLabel;
    EdUSERS: TEdit;
    LaUsersHelp: TLabel;
    cobUsers: TComboBox;
    procedure EdNameChange(Sender: TObject);
    procedure chbIsPublicClick(Sender: TObject);
    procedure cobUsersChange(Sender: TObject);
    procedure cobUsersDropDown(Sender: TObject);
    procedure EdUSERSChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(var FltrName: string; var IsPublic: boolean;
      HasColumnList: boolean; var IsColumnList: boolean; var Users: string): boolean;
  end;

var
  DlgFltr: TDlgFltr;

implementation
{$R *.DFM}
uses
  Prots, RechtKmp;

class function TDlgFltr.Execute(var FltrName: string; var IsPublic: boolean;
  HasColumnList: boolean; var IsColumnList: boolean; var Users: string): boolean;
var
  Btn: word;
begin
  DlgFltr := Create(Application);
  DlgFltr.EdName.Text := FltrName;
  DlgFltr.chbIsPublic.Checked := IsPublic;
  DlgFltr.chbColumnList.Visible := HasColumnList;
  DlgFltr.chbColumnList.Checked := IsColumnList;
  DlgFltr.EdUsers.Text := Users;
  CheckBoxChange(DlgFltr.chbIsPublic);
  Btn := DlgFltr.ShowModal;
  result := false;
  if (Btn = mrOK) and (DlgFltr.EdName.Text <> '') then
  begin
    result := true;
    FltrName := DlgFltr.EdName.Text;
    IsPublic := DlgFltr.chbIsPublic.Checked;
    IsColumnList := DlgFltr.chbColumnList.Checked;
    Users := DlgFltr.EdUsers.Text;
  end;
  DlgFltr.Release;
  DlgFltr := nil;
end;

procedure TDlgFltr.EdNameChange(Sender: TObject);
begin
  chbIsPublic.Checked := false;
  EdUsers.Text := Sysparam.Username;
end;

procedure TDlgFltr.chbIsPublicClick(Sender: TObject);
begin
  EdUsers.Visible := not chbIsPublic.Checked;
  LaUsers.Visible := EdUsers.Visible;
  LaUsersHelp.Visible := EdUsers.Visible;
  CobUsers.Visible := EdUsers.Visible;
end;

procedure TDlgFltr.cobUsersChange(Sender: TObject);
begin
  if Pos(cobUsers.Text, EdUsers.Text) = 0 then
    EdUsers.Text := GetAppendTok(EdUsers.Text, cobUsers.Text, ';');
end;

procedure TDlgFltr.cobUsersDropDown(Sender: TObject);
begin
  cobUsers.Items.Assign(KmpRechte.UserList);
end;

procedure TDlgFltr.EdUSERSChange(Sender: TObject);
begin
  if Length(EdUSERS.Text) > 25 then
    EdUSERS.Hint := EdUSERS.Text else
    EdUSERS.Hint := '';
end;

end.

