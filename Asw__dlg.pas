unit Asw__dlg;
(* Dialog zur Auswahl aus einer TAsw
      Siehe auch Str__dlg
*)
interface

uses
{$ifdef WIN32}
  ComCtrls,
{$else}
{$endif}
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls;

type
  (* TDlgErr Dialogbox *)
  TDlgAsw = class(TForm)
    DataSource1: TDataSource;
    ListBox: TListBox;
    Panel1: TPanel;
    PanRight: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    procedure ListBoxDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(AswName, Titel: string; Fontsize: integer = 0): string;
  end;

var
  DlgAsw: TDlgAsw;

implementation
{$R *.DFM}
uses
  Asws_Kmp, Prots;

class function TDlgAsw.Execute(AswName, Titel: string; Fontsize: integer = 0): string;
(* Auswahl in Listbox zur Übernahme
   ergibt Linke Seite (Speicher-Wert) oder '' bei Abbruch *)
const
  NICE_DX = 32;   //Nur zur schöneren Darstellung
  NICE_DY = 20;
var
  Btn: word;
  I: integer;
  AAsw: TAsw;
  DX, DY: integer;
  S: string;
  OldFontSize: integer;
begin
  AAsw := Asws.FindAsw(AswName);
  with TDlgAsw.Create(Application) do
  try
    if Titel <> '' then
      Caption := Titel else
      Caption := AswName; //copy(AAsw.Name, 4, length(AAsw.Name)-3);
    ListBox.Items.Clear;
    DX := 0;
    OldFontSize := Font.Size;
    if Fontsize <> 0 then
    begin
      Font.Size := Fontsize;
    end;
    for I := 0 to AAsw.Items.Count - 1 do
    begin
      S := AAsw.Items.Value(I);
      DX := IMax(DX, Canvas.TextWidth(S + 'W'));
      if Char1(AAsw.Items[I]) = ';' then           {Kommentar -> ---}
        ListBox.Items.Add('----------------------------------------------------------------------------------')
      else
        ListBox.Items.Add(S);
    end;
    Width := NICE_DX + IMax(PanRight.Width, DX + 16);
    ListBox.ItemIndex := 0;
    DY := ListBox.Items.Count * Canvas.TextHeight('Wg') + 4 + NICE_DY;
    Height := DY + 52;
    if Fontsize <> 0 then
    begin
      Font.Size := OldFontSize;
      Listbox.Font.Size := Fontsize;
    end;
    repeat
      Btn := ShowModal;
      if Btn = mrOk then
        result := AAsw.Items.Param(ListBox.ItemIndex) else
        result := '';
    until (Btn <> mrOK) or (Char1(AAsw.Items[ListBox.ItemIndex]) <> '-');
    Prot0('DlgAsw(%s,%s):%s', [AswName, Titel, Result]);
  finally
    Free;
  end;
end;

procedure TDlgAsw.FormCreate(Sender: TObject);
begin
  Font.Assign(Application.MainForm.Font);
  DlgAsw := self;
end;

procedure TDlgAsw.FormDestroy(Sender: TObject);
begin
  DlgAsw := nil;
end;

procedure TDlgAsw.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
