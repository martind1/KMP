unit AswClDlg;
(* Dialog zur Mehrfachauswahl per CheckListBox aus einer TAsw
      Siehe auch Str__dlg
17.10.13 md  erstellt (asw__dlg)
*)
interface

uses
  ComCtrls,
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, TabNotBk, SysUtils, Mask, DBCtrls, DB,  Uni, DBAccess, MemDS, ExtCtrls,
  Vcl.CheckLst;

type
  TDlgAswCl = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    PanRight: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    CheckListBox: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(AswName, Titel, Fltr: string; Fontsize: integer = 0): string;
    class function ExecVal(AswName, Titel: string; var Fltr: string; Fontsize: integer = 0): boolean;
  end;

var
  DlgAswCl: TDlgAswCl;

implementation
{$R *.DFM}
uses
  Asws_Kmp, Prots, nstr_Kmp;

class function TDlgAswCl.Execute(AswName, Titel, Fltr: string; Fontsize: integer = 0): string;
var
  MyFltr: string;
begin
  MyFltr := Fltr;
  Result := '';
  if ExecVal(AswName, Titel, MyFltr, Fontsize) then
    Result := MyFltr;
end;

class function TDlgAswCl.ExecVal(AswName, Titel: string; var Fltr: string;
  Fontsize: integer): boolean;
// Ankreuzen in CheckListbox zur Übernahme
// Fltr: enthält Suchkriterien mit Speicherwerten, z.B. A;B;C
// ergibt ausgewählte Param-Werte mit ';' getrennt oder '' bei Abbruch
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
  SL: TStringList;
begin
  AAsw := Asws.FindAsw(AswName);
  SL := nil;
  with TDlgAswCl.Create(Application) do
  try
    SL := TStringList.Create;
    StrTokenize(Fltr, BlockTrenner + BetweenTrenner, SL, false, true);  //nstr_kmp, IncludeTrenner=false, DoTrim=true
    Caption := StrDflt(Titel, AswName); //copy(AAsw.Name, 4, Maxint);
    CheckListBox.Items.Clear;
    DX := 0;
    OldFontSize := Font.Size;
    if Fontsize <> 0 then
    begin
      Font.Size := Fontsize;
    end;
    for I := 0 to AAsw.NiceItems.Count - 1 do   {kein Kommentar }
    begin
      S := AAsw.Items.Value(I);
      DX := IMax(DX, Canvas.TextWidth(S + 'W'));
      CheckListBox.Items.Add(S);
      CheckListBox.Checked[I] := SL.IndexOf(AAsw.Items.Param(I)) >= 0;
    end;
    Width := NICE_DX + IMax(PanRight.Width, DX + 16 + 32);  //32 für Checkbox
    CheckListBox.ItemIndex := 0;
    DY := CheckListBox.Items.Count * Canvas.TextHeight('Wg') + 4 + NICE_DY;
    Height := DY + 52;
    if Fontsize <> 0 then
    begin
      Font.Size := OldFontSize;
      CheckListBox.Font.Size := Fontsize;
    end;
    Result := false;
    Btn := ShowModal;
    if Btn = mrOk then
    begin
      result := True;
      //Fltr := AAsw.Items.Param(CheckListBox.ItemIndex);
      Fltr := '';
      { angekreuzet Werte nach Fltr: }
      for I := 0 to AAsw.NiceItems.Count - 1 do   {kein Kommentar }
      begin
        if CheckListBox.Checked[I] then
          AppendTok(Fltr, AAsw.Items.Param(I), ';');
      end;
    end;
  finally
    SL.Free;
    Free;
  end;
end;

procedure TDlgAswCl.FormCreate(Sender: TObject);
begin
  Font.Assign(Application.MainForm.Font);
  DlgAswCl := self;
end;

procedure TDlgAswCl.FormDestroy(Sender: TObject);
begin
  DlgAswCl := nil;
end;

end.
