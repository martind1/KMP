unit Konv_dlg;
(* Manuelles Konvertierung von alten DB-Zeichensätzen
xx.xx.99 MD  erstellt
23.03.08 MD  Umschaltung Nmerisch/Zeichen
23.03.08     Problem: 'ß' und 'Ü' habe gleichen Ursprungscode
             Lsg.: 'ß' kann nur mitten im Wort stehen. Zu Beginn:Ü
*)

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Gauges, ExtCtrls, Grids, TgridKmp,
  NLnk_Kmp, Lnav_kmp;

type
  TDlgKonvert = class(TForm)
    TitleGrid1: TTitleGrid;
    BtnTable: TBitBtn;
    BtnRecord: TBitBtn;
    ListBox1: TListBox;
    BtnClose: TBitBtn;
    chbNum: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnTableClick(Sender: TObject);
    procedure BtnRecordClick(Sender: TObject);
    procedure chbNumClick(Sender: TObject);
    procedure TitleGrid1Exit(Sender: TObject);
  private
    { Private declarations }
    NavLink: TNavLink;
    Count, Index: longint;
    function KonvertRecord: longint;
    procedure GridToListBox;
    procedure ListBoxToGrid;
  public
    { Public declarations }
    class procedure Execute( ANavLink: TNavLink);
  end;

var
  DlgKonvert: TDlgKonvert;


implementation
{$R *.DFM}
uses
  DB,  Uni, DBAccess, MemDS, SysUtils,
  Prots, Ini__Kmp, GNav_Kmp;
const
  SSection = 'Konvertierung';
  SKonv = 'Konv';

class procedure TDlgKonvert.Execute( ANavLink: TNavLink);
begin
  if DlgKonvert = nil then
    TDlgKonvert.Create( Application);
  DlgKonvert.NavLink := ANavLink;
  DlgKonvert.Caption := LongCaption(DlgKonvert.Caption, ANavLink.Display);
  DlgKonvert.Show;
end;

procedure TDlgKonvert.FormCreate(Sender: TObject);
begin
  DlgKonvert := self;
  IniKmp.SectionTyp[SSection] := stAnwendung;
  ListBox1.Items.Clear;
  IniKmp.ReadSectionValues(SSection, ListBox1.Items);
  chbNum.Checked := IniKmp.ReadBool(SKonv, chbNum.Name, chbNum.Checked);
  ListBoxToGrid;
end;

procedure TDlgKonvert.ListBoxToGrid;
var
  I: integer;
begin
  for I := 0 to ListBox1.Items.Count - 1 do
  begin
    TitleGrid1.RowCount := I + 2;
    if chbNum.Checked then
    begin
      TitleGrid1.Cells[0, I+1] := StrValue(ListBox1.Items[I]);
      TitleGrid1.Cells[1, I+1] := StrParam(ListBox1.Items[I]);
    end else
    begin
      TitleGrid1.Cells[0, I+1] := Chr(StrToInt(StrValue(ListBox1.Items[I])));
      TitleGrid1.Cells[1, I+1] := Chr(StrToInt(StrParam(ListBox1.Items[I])));
    end;
  end;
end;

procedure TDlgKonvert.GridToListBox;
var
  I: integer;
  von, nach: Byte;
begin  //nach=von
  ListBox1.Items.Clear;
  for I := 1 to TitleGrid1.RowCount - 1 do
  begin
    if chbNum.Checked then
    begin
      ListBox1.Items.Add(Format('%s=%s', [TitleGrid1.Cells[1, I],
        TitleGrid1.Cells[0, I]]));
    end else
    begin
      von := ord(Char1(TitleGrid1.Cells[0, I]));
      nach := ord(Char1(TitleGrid1.Cells[1, I]));
      ListBox1.Items.Add(Format('%s=%s', [IntToStr(nach), IntToStr(von)]));
    end;
  end;
end;

procedure TDlgKonvert.chbNumClick(Sender: TObject);
begin
  ListBoxToGrid;
end;

procedure TDlgKonvert.TitleGrid1Exit(Sender: TObject);
begin
  GridToListBox;
end;

procedure TDlgKonvert.BtnCloseClick(Sender: TObject);
begin
  GridToListbox;
  IniKmp.WriteBool(SKonv, chbNum.Name, chbNum.Checked);
  IniKmp.ReplaceSection(SSection, Listbox1.Items);
  Close;
end;

procedure TDlgKonvert.FormDestroy(Sender: TObject);
begin
  DlgKonvert := nil;
end;

procedure TDlgKonvert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TDlgKonvert.KonvertRecord: longint;
var
  I, J, N: integer;
  S, S1: string;
  von, nach: Byte;
  P, P1: integer;
begin
  GMessA(Index, Count);
  N := 0;
  with NavLink do
  begin
    for I := 0 to DataSet.FieldCount - 1 do
      if (DataSet.Fields[I] is TStringField) or
         (DataSet.Fields[I] is TMemoField) then
      begin
        S := DataSet.Fields[I].AsString;
        S1 := S;
        for J := 0 to Listbox1.Items.Count - 1 do
        begin
          nach := StrToInt(StrParam(Listbox1.Items[J]));
          von := StrToInt(StrValue(Listbox1.Items[J]));
          //Wortanfänge beginnen nicht mit nach=ß; Rest enthält kein 'Ü' (von bei beiden gleich)
          if (Listbox1.Items.Values['ß'] = Listbox1.Items.Values['Ü']) and
             ((nach = ord('ß')) or (nach = ord('Ü'))) then
          begin
            P := Pos(Chr(von), S1);
            while P > 0 do
            begin
              if (P = 1) or (S1[P - 1] = ' ') then
                S1 := StrCgeChar(S1, Chr(von), 'Ü') else
                S1 := StrCgeChar(S1, Chr(von), 'ß');
              P1 := P;
              P := Pos(Chr(von), copy(S1, P+1, Maxint));
              if P > 0 then
                P := P + P1;
            end;
          end else
            S1 := StrCgeChar(S1, Chr(von), chr(nach));
        end;
        if S <> S1 then
        begin
          DataSet.Edit;  //Checked dsEditModes
          DataSet.Fields[I].AsString := S1;
          SMess('%d/%d %s', [Index, Count, S1]);
          Inc(N);
        end;
      end;
  end;
  if N = 0 then
    SMess('%d/%d', [Index, Count]);
  GMessA(Index, Count);
  result := N;
end;

procedure TDlgKonvert.BtnTableClick(Sender: TObject);
begin
  GridToListbox;
  with NavLink do
  begin
    Count := RecordCount;
    Index := 0;
    DataSet.First;
    DataSet.DisableControls;
    try
      while not DataSet.EOF do
      begin
        if KonvertRecord > 0 then
          Commit;
        DataSet.Next;
        Inc(Index);
        GNavigator.ProcessMessages;
        try
          if NavLink = nil then SysUtils.Abort;
        except
          SysUtils.Abort;
        end;
      end;
      GMess0;
    finally
      DataSet.EnableControls;
    end;
  end;
end;

procedure TDlgKonvert.BtnRecordClick(Sender: TObject);
begin
  GridToListbox;
  Count := 0; Index := 0;
  with NavLink do
  begin
    KonvertRecord;
  end;
  GMess0;
end;

end.
