unit AswEdDlg;
(* Dialog für Tabellenlayout
   05.01.00 MD Erstellt
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, TgridKmp, ExtCtrls,
  DPos_Kmp, Asws_Kmp;

type
  TDlgAswEd = class(TForm)
    Grid: TTitleGrid;
    Panel1: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    BtnStandard: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    AAsw: TAsw;
    procedure CheckKey;
  public
    { Public declarations }
    class function Execute(AswName: string): boolean;
    {Editieren. Ergibt true bei OK und false bei Abbruch}
  end;

var
  DlgAswEd: TDlgAswEd;

implementation
{$R *.DFM}
uses
  Prots, GNav_Kmp;

class function TDlgAswEd.Execute(AswName: string): boolean;
{Editieren. Ergibt true bei OK und false bei Abbruch}
var
  ModResult: TModalResult;
  I: integer;
begin
  result := false;
  with TDlgAswEd.Create(Application) do
  try
    AAsw := Asws.AswByName(AswName);
    Caption := LongCaption(Caption, AswName);
    for I := 0 to AAsw.Items.Count - 1 do with Grid do
    begin
      RowCount := I + 2;
      Cells[0, I + 1] := AAsw.Items.Param(I);
      Cells[1, I + 1] := AAsw.Items.Value(I);
    end;
    ModResult := ShowModal;
    if ModResult = mrOK then
    begin
      CheckKey;
      result := true;
      AAsw.Items.Clear;
      with Grid do
        for I := 1 to RowCount - 1 do
          if Cells[0, I] <> '' then
            AAsw.Items.AddFmt('%s=%s', [Cells[0, I], Cells[1, I]]);
      AAsw.SaveToIni;
    end else
    if ModResult = mrYes then
    begin                {Standard}
      AAsw.Items.Assign(AAsw.LoadedItems);
      AAsw.DeleteInIni;
      result := true;
    end;
  finally
  end;
end;

procedure TDlgAswEd.FormCreate(Sender: TObject);
begin
  DlgAswEd := self;
  GNavigator.TranslateForm(self);
end;

procedure TDlgAswEd.FormDestroy(Sender: TObject);
begin
  DlgAswEd := nil;
end;

procedure TDlgAswEd.FormResize(Sender: TObject);
begin
  with Grid do
    ColWidths[1] := DlgAswEd.Width - ColWidths[0] - 32;
end;

procedure TDlgAswEd.CheckKey;
var
  I: integer;
begin
  with Grid do
    for I := 0 to AAsw.Items.Count - 1 do      {Schlüssel immer wieder korriegieren}
    begin
      Cells[0, I + 1] := AAsw.Items.Param(I);
    end;
end;

procedure TDlgAswEd.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  with Grid do
    if Cells[0, ARow] = '' then
      Cells[1, ARow] := '';
  CheckKey;
end;

end.
