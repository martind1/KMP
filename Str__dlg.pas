unit Str__dlg;
(* Dialog zur Auswahl aus eine Stringliste
   Siehe auch Asw__dlg
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls, Menus;

type
  (* TDlgErr Dialogbox *)
  TDlgStrings = class(TForm)
    ListBox: TListBox;
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    PopupMenu1: TPopupMenu;
    MiSave: TMenuItem;
    procedure ListBoxDblClick(Sender: TObject);
    procedure MiSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ExecStr(AString: string; ATitle: string): longint;
    class function ExecStrStr(AString: string; ATitle: string): string;
    class function Execute(AList: TStrings; ATitle: string): longint;
    class procedure SetFont(AFont: TFont);
    class procedure CheckOnTop;
  end;

  (* Kompatibilität: *)
  function StringsDlg(AList: TStrings; ATitle: string): longint;

var
  DlgStrings: TDlgStrings;

implementation
{$R *.DFM}
uses
  Dialogs,
  Asws_Kmp, Prots, DPos_Kmp, GNav_Kmp;
const
  MaxCount = 30;
  MaxWidth = 742;
  MinCount = 2;
  MinWidth = 182;
  ScrollWidth = 26;
var
  TheFont: TFont;

function StringsDlg(AList: TStrings; ATitle: string): longint;
begin
  result := TDlgStrings.Execute(AList, ATitle);
end;

class function TDlgStrings.ExecStr(AString: string; ATitle: string): longint;
//Die Auswahl wird aus mit ';' getrennten Strings gebildet
//Für Lawa.TFrmWWaage.GetMestNr
var
  L: TValueList;
begin
  L := TValueList.Create;
  try
    L.AddTokens(AString, ';');
    result := TDlgStrings.Execute(L, ATitle);
  finally
    L.Free;
  end;
end;

class function TDlgStrings.ExecStrStr(AString, ATitle: string): string;
// ergibt Text des ausgewählten Items oder '' bei Abbruch. Für dpe.EREC.ErsrM
var
  L: TValueList;
  I: integer;
begin
  Result := '';
  L := TValueList.Create;
  try
    L.AddTokens(AString, ';');
    I := TDlgStrings.Execute(L, ATitle);
    if I >= 0 then
      Result := L[I];
  finally
    L.Free;
  end;
end;

class function TDlgStrings.Execute(AList: TStrings; ATitle: string): longint;
//Zeigt Auswahl an. Ergibt Auswahl-Index oder -1 bei Abbruch
var
  Btn: word;
  DX, DY, I, AWidth, AHeight, ACount: integer;
begin
  result := -1;
  with TDlgStrings.Create(Application) do
  try
    DX := Width - Listbox.Width;
    DY := Height - Listbox.Height;
    if TheFont <> nil then
    begin
      Font := TheFont;
      TheFont := nil;
    end;
    if ATitle <> '' then
      Caption := ATitle;
    AWidth := Canvas.Textwidth(Caption) + 80;
    ListBox.Items.Clear;
    for I:= 0 to AList.Count-1 do
    begin
      ListBox.Items.Add(AList.Strings[I]);
      AWidth := IMax(AWidth, Canvas.Textwidth(AList.Strings[I]) + ScrollWidth);
    end;
    Width := IMax(MinWidth, IMin(MaxWidth, AWidth)) + DX;
    ACount := IMax(MinCount, IMin(MaxCount, AList.Count));
    AHeight := ACount * Canvas.TextHeight('Üg') + 4;
    Height := AHeight + DY;
    ListBox.ItemIndex := 0;
    ListBox.Width := Width - DX;  {AWidth;}
    ListBox.Height := AHeight;
    Btn := ShowModal;
    if Btn = mrOk then
      result := ListBox.ItemIndex;
  finally
    Free;
  end;
end;

class procedure TDlgStrings.SetFont(AFont: TFont);
begin
  TheFont := AFont;
end;

class procedure TDlgStrings.CheckOnTop;
begin
  if DlgStrings <> nil then
    DlgStrings.BringToFront;
end;

procedure TDlgStrings.FormCreate(Sender: TObject);
begin
  DlgStrings := self;
  GNavigator.TranslateForm(self);
end;

procedure TDlgStrings.FormDestroy(Sender: TObject);
begin
  DlgStrings := nil;
end;

procedure TDlgStrings.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TDlgStrings.MiSaveClick(Sender: TObject);
var
  S: string;
  APath: array[0..255] of char;
begin
{$ifdef WIN32}
  GetTempPath(sizeof(APath), APath);
  S := APath + copy(StrToValidIdent(Caption), 1, 8) + '.TXT';
{$else}
  {StrCopy(APath, 'c:\temp\');}
  S := 'c:\temp\' + copy(StrToValidIdent(Caption), 1, 8) + '.TXT';
{$endif}
  if InputQuery(Caption, 'DateiName', S) then
    ListBox.Items.SaveToFile(S);
end;

end.
