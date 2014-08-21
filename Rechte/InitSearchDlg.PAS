unit InitSearchDlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
     Qwf_Form, Menus;

type
  TDlgIniSearch = class(TqForm)
    EdValue: TEdit;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    chbSection: TCheckBox;
    chbParameter: TCheckBox;
    chbWert: TCheckBox;
    chbExact: TCheckBox;
    PopupMenu1: TPopupMenu;
    MiFindNext: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    Found: boolean;
    UseSection: boolean;
    IsFirst: boolean;
    PositionI, PositionN: integer;
    function CompareStr(S: string): boolean;
    function SearchCompare: boolean;
    procedure SearchNext;
    procedure Search(First: boolean);
  public
    { Public declarations }
    class procedure FindFirst;
    class procedure FindNext;
  end;

var
  DlgIniSearch: TDlgIniSearch;

implementation
{$R *.DFM}
uses
  SysUtils, Db,
  Prots, INITEDFrm;

class procedure TDlgIniSearch.FindFirst;
begin
  if DlgIniSearch = nil then
    DlgIniSearch := Create(Application) else
  begin
    DlgIniSearch.ActiveControl := DlgIniSearch.EdValue;
    DlgIniSearch.EdValue.SelectAll;
  end;
  DlgIniSearch.UseSection := false;
  DlgIniSearch.IsFirst := true;
  DlgIniSearch.ShowModal;
end;

class procedure TDlgIniSearch.FindNext;
begin
  if DlgIniSearch = nil then
    FindFirst else
  begin
    //DlgIniSearch.SearchNext;
    DlgIniSearch.Search(false);  //F3:Weiersuchen
  end;
end;

procedure TDlgIniSearch.FormCreate(Sender: TObject);
begin
  DlgIniSearch := self;
end;

procedure TDlgIniSearch.FormDestroy(Sender: TObject);
begin
  DlgIniSearch := nil;
end;

procedure TDlgIniSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
    Action := caNone else
    Action := caHide;
end;

function TDlgIniSearch.CompareStr(S: string): boolean;
// vergleicht anhand Options
begin
  if chbExact.Checked then
    Result := AnsiSameText(EdValue.Text, S) else
    Result := Posi(EdValue.Text, S) > 0;
  if SysParam.ProtBeforeOpen then
    Prot0('TDlgIniSearch.CompareStr(%s,%s)=%d', [
    EdValue.Text, S, Ord(Result)]);
  if Result then
    Debug0;
end;

function TDlgIniSearch.SearchCompare: boolean;
// setzt Found wenn gefunden
begin
  Found := EdValue.Text = '';
  if not Found and chbSection.Checked and UseSection then
    Found := CompareStr(FrmINITED.Query1.FieldByName('SECTION').AsString);
  if not Found and chbParameter.Checked then
    Found := CompareStr(FrmINITED.TblEntry.FieldByName('PARAM').AsString);
  if not Found and chbWert.Checked then
    Found := CompareStr(FrmINITED.TblEntry.FieldByName('WERT').AsString);
  Result := Found;
end;

procedure TDlgIniSearch.SearchNext;
// geht auf nächsten Eintrag von FrmINITED.Query1.
begin
  GMessA(PositionI, PositionN);
  FrmINITED.TblEntry.Next;
  UseSection := false;
  if FrmINITED.TblEntry.EOF then
  begin
    FrmINITED.Query1.Next;
    Inc(PositionI);
    FrmINITED.LuEntry.Refresh;
    UseSection := true;
  end;
end;

procedure TDlgIniSearch.Search(First: boolean);
var
  BookMark1, Bookmark2: TBookMark;
begin
  if FrmINITED = nil then
  begin
    Close;
    Exit;
  end;
  FrmINITED.Query1.Open;
  PositionN := FrmINITED.Nav.Navlink.RecordCount;
  FrmINITED.TblEntry.Open;
  FrmINITED.Query1.DisableControls;
  FrmINITED.TblEntry.DisableControls;
  BookMark1 := FrmINITED.Query1.GetBookMark;
  BookMark2 := nil;
  //nein. wir suchen ab aktueller Position. FrmINITED.Query1.First;
  //FrmINITED.LuEntry.Refresh;
  if First then
    PositionI := 1 else
    SearchNext;
  Found := false;
  try
    while not SearchCompare and not FrmINITED.Query1.EOF do
      SearchNext;
  finally
    if not Found then
    begin
      FrmINITED.Query1.GotoBookmark(BookMark1);
    end else
      Bookmark2 := FrmINITED.TblEntry.GetBookmark;
    FrmINITED.Query1.FreeBookmark(BookMark1);
    FrmINITED.Query1.EnableControls;
    FrmINITED.TblEntry.EnableControls;
    if Bookmark2 <> nil then
    begin
      FrmINITED.TblEntry.GotoBookmark(BookMark2);
      FrmINITED.TblEntry.FreeBookmark(BookMark2);
    end;
    if not Found then
      WMess('%s nicht gefunden', [EdValue.Text]);
  end;
end;

procedure TDlgIniSearch.BtnOKClick(Sender: TObject);
begin
  Search(IsFirst);
  IsFirst := false;
end;

end.
