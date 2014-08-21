unit MuGriDlg;
(* Dialog für Tabellenlayout
   05.01.00 MD  Erstellt
   01.08.08 MD  Standard für TempLayout
   14.07.10 md  nur sichtbare Spalten kopieren
   04.12.13 md  Übernehmen: auf aktuelles Feld nach Umsortierung positionieren
*)
interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, TgridKmp, ExtCtrls,
  DPos_Kmp, Menus, Lnav_kmp, Qwf_Form;

type
  TDlgMuGri = class(TqForm)
    Grid: TTitleGrid;
    Panel1: TPanel;
    Label1: TLabel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    BtnStandard: TBitBtn;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    MiCopy: TMenuItem;
    Memo1: TMemo;
    MiColOffsetPlus: TMenuItem;
    MiColOffsetMinus: TMenuItem;
    MiColOffset: TMenuItem;
    N1: TMenuItem;
    Nav: TLNavigator;
    chbSlideBar: TCheckBox;
    MiPaste: TMenuItem;
    MiSpaltenbreiten: TMenuItem;
    BtnApply: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MiCopyClick(Sender: TObject);
    procedure MiColOffsetPlusClick(Sender: TObject);
    procedure MiColOffsetMinusClick(Sender: TObject);
    procedure MiColOffsetClick(Sender: TObject);
    procedure NavSetTitel(Sender: TObject; var Titel, Titel2: TCaption);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MiPasteClick(Sender: TObject);
    procedure MiSpaltenbreitenClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
  private
    { Private declarations }
    Caption2: string;
    CtrlList: TValueList;
    procedure SortList(AColumnList, CtrlList: TStrings);
  public
    { Public declarations }
    class function Execute(AColumnList: TStrings; ACaption: string;
      var SlideBar, Standard: boolean): boolean;
    {Editieren. Ergibt true bei OK und false bei Abbruch}
  end;

var
  DlgMuGri: TDlgMuGri;

implementation
{$R *.DFM}
uses
  SysUtils,
  Prots, MuGriKmp, GNav_Kmp;

const
  X_FIELDNAME = 0;
  X_DISPLAY = 1;
  X_WIDTH = 2;
  X_OPTIONS = 3;

procedure TDlgMuGri.SortList(AColumnList, CtrlList: TStrings);
var
  I: integer;
  S, S1, S2, S3, NextS: string;
  L, ColList, ColSortList: TValueList;
begin
  L := TValueList.Create;
  ColList := TValueList.Create;
  ColSortList := TValueList.Create;
  with Grid do
  try
        for I := 0 to AColumnList.Count - 1 do {visible Fields}
        begin
          S := AColumnList[I];
          if Char1(S) = ':' then
          begin
            CtrlList.Add(S);     {Steuerzeile}
          end else
          begin                  //Überschrift:Länge,Optionen=FIELD_NAME
            S1 := PStrTok(StrParam(S, true), ':', NextS);
            S2 := PStrTok('', ',', NextS); {Länge}
            S3 := PStrTok('', ',', NextS); {Optionen}
            if StrToIntTol(S2) > 0 then {visible Fields}
              ColList.Add(S);
          end;
        end;
        for I := 0 to AColumnList.Count - 1 do   {invisible Fields}
        begin
          S := AColumnList[I];
          if (S = '') or (StrValue(S, true) = '') or (StrParam(S, true) = '') or
             (Char1(S) = ':') then {Steuerzeile}
            continue;
          S1 := PStrTok(StrParam(S, true), ':', NextS);
          S2 := PStrTok('', ',', NextS); {Länge}
          S3 := PStrTok('', ',', NextS); {Optionen}
          {if StrToIntTol(S2) <= 0 then
            ColList.Add(S);           }
          if StrToIntTol(S2) <= 0 then                {sortieren: Feldname zuerst}
            ColSortList.Add(Format('%s=%s', [StrValue(S, true), StrParam(S, true)]));
        end;
        ColSortList.Sort;
        for I := 0 to ColSortList.Count - 1 do          {sortierte Liste kopieren}
          ColList.Add(Format('%s=%s', [ColSortList.Value(I), ColSortList.Param(I)]));

        for I := 0 to ColList.Count - 1 do
          L.Add(StrValue(ColList[I], true));
        RowTitles.Assign(L); {RowCount, Cells[X_FIELDNAME,X]}
        for I := 0 to ColList.Count - 1 do
        begin
          S := ColList[I];
          Cells[X_DISPLAY, I+1] := PStrTok(StrParam(S, true), ':', NextS);
          Cells[X_WIDTH, I+1] := PStrTok('', ',', NextS); {Länge}
          Cells[X_OPTIONS, I+1] := PStrTok('', ',', NextS); {Optionen}
        end;
  finally
    L.Free;
    ColList.Free;
    ColSortList.Free;
  end;
end;

procedure TDlgMuGri.BtnApplyClick(Sender: TObject);
//aktive nach oben ziehen. Zum Tabellenanfang gehen.
var
  AColumnList: TStrings;
  I: integer;
  S: string;
  AktFieldname: string;
begin
  AColumnList := TStringList.Create;
  try
    AColumnList.Assign(CtrlList); {mit Steuerzeilen}
    with Grid do
    begin
      AktFieldname := Cells[X_FIELDNAME, Row];
      for I := 1 to RowCount - 1 do
      begin
        S := Cells[X_DISPLAY, I];
        AppendTok(S, Cells[X_WIDTH, I], ':');
        AppendTok(S, Cells[X_OPTIONS, I], ',');
        AColumnList.Add(Format('%s=%s', [S, Cells[X_FIELDNAME, I]]));
      end;
    end;
    SortList(AColumnList, CtrlList);
    Grid.Row := 1;  //nach oben gehen
    for I := 1 to Grid.RowCount - 1 do
    begin
      S := Grid.Cells[X_FIELDNAME, I];
      if S = AktFieldname then
      begin
        Grid.Row := I;  //auf zuletzt markiertes Feld gehen
        break;
      end;
    end;

    self.ActiveControl := Grid;
  finally
    FreeAndNil(AColumnList);
  end;
end;

class function TDlgMuGri.Execute(AColumnList: TStrings; ACaption: string;
  var SlideBar, Standard: boolean): boolean;
{Editieren. Ergibt true bei OK und false bei Abbruch}
var
  S: string;
  I: integer;
  // L, ColList, ColSortList, CtrlList: TValueList;
  ModResult: TModalResult;
begin
  result := false;
  Standard := false;
  with TDlgMuGri.Create(Application) do
  begin
//    L := TValueList.Create;
//    ColList := TValueList.Create;
//    ColSortList := TValueList.Create;
    CtrlList := TValueList.Create;
    try
      Caption2 := ACaption;
      chbSlideBar.Checked := SlideBar;
      with Grid do
      begin
        SortList(AColumnList, CtrlList);
        (*
        for I := 0 to AColumnList.Count - 1 do {visible Fields}
        begin
          S := AColumnList[I];
          if Char1(S) = ':' then
          begin
            CtrlList.Add(S);     {Steuerzeile}
          end else
          begin                  //Überschrift:Länge,Optionen=FIELD_NAME
            S1 := PStrTok(StrParam(S, true), ':', NextS);
            S2 := PStrTok('', ',', NextS); {Länge}
            S3 := PStrTok('', ',', NextS); {Optionen}
            if StrToIntTol(S2) > 0 then {visible Fields}
              ColList.Add(S);
          end;
        end;
        for I := 0 to AColumnList.Count - 1 do   {invisible Fields}
        begin
          S := AColumnList[I];
          if (S = '') or (StrValue(S, true) = '') or (StrParam(S, true) = '') or
             (Char1(S) = ':') then {Steuerzeile}
            continue;
          S1 := PStrTok(StrParam(S, true), ':', NextS);
          S2 := PStrTok('', ',', NextS); {Länge}
          S3 := PStrTok('', ',', NextS); {Optionen}
          {if StrToIntTol(S2) <= 0 then
            ColList.Add(S);           }
          if StrToIntTol(S2) <= 0 then                {sortieren: Feldname zuerst}
            ColSortList.Add(Format('%s=%s', [StrValue(S, true), StrParam(S, true)]));
        end;
        ColSortList.Sort;
        for I := 0 to ColSortList.Count - 1 do          {sortierte Liste kopieren}
          ColList.Add(Format('%s=%s', [ColSortList.Value(I), ColSortList.Param(I)]));

        for I := 0 to ColList.Count - 1 do
          L.Add(StrValue(ColList[I], true));
        RowTitles.Assign(L); {RowCount, Cells[X_FIELDNAME,X]}
        for I := 0 to ColList.Count - 1 do
        begin
          S := ColList[I];
          Cells[X_DISPLAY, I+1] := PStrTok(StrParam(S, true), ':', NextS);
          Cells[X_WIDTH, I+1] := PStrTok('', ',', NextS); {Länge}
          Cells[X_OPTIONS, I+1] := PStrTok('', ',', NextS); {Optionen}
        end;
        *)
        Cells[X_FIELDNAME, 0] := 'Feld';
        DlgMuGri.InitWidth := ColWidths[0] + ColWidths[X_DISPLAY] + ColWidths[X_WIDTH] +
                              ColWidths[X_OPTIONS] + 32;
        DlgMuGri.Width := DlgMuGri.InitWidth;
      end;  //with Grid
      ModResult := ShowModal;
      if ModResult = mrOK then
      begin
        result := true;
        SlideBar := chbSlideBar.Checked;
        AColumnList.Assign(CtrlList); {mit Steuerzeilen}
        with Grid do
        begin
          for I := 1 to RowCount - 1 do
          begin
            S := Cells[X_DISPLAY, I];
            AppendTok(S, Cells[X_WIDTH, I], ':');
            AppendTok(S, Cells[X_OPTIONS, I], ',');
            AColumnList.Add(Format('%s=%s', [S, Cells[X_FIELDNAME, I]]));
          end;
        end;
      end else
      if ModResult = mrYes then
      begin                {Standard}
        result := true;
        Standard := true;
        AColumnList.Assign(CtrlList); {mit Steuerzeilen}
        AColumnList.Values[SRowHeight] := '';   //Standard RowHeight
      end;
    finally
      CtrlList.Free;
//      L.Free;
//      ColList.Free;
//      ColSortList.Free;
    end;
  end;
end;

procedure TDlgMuGri.FormCreate(Sender: TObject);
begin
  DlgMuGri := self;
  MiColOffset.Checked := ColOffs <> 0;
  GNavigator.DoNavLinkInit(Nav.NavLink);  //auch Übersetzen
end;

procedure TDlgMuGri.FormDestroy(Sender: TObject);
begin
  DlgMuGri := nil;
end;

procedure TDlgMuGri.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TDlgMuGri.FormResize(Sender: TObject);
begin
  if DlgMuGri <> nil then with Grid do
    ColWidths[X_DISPLAY] := {DlgMuGri.}Width - ColWidths[X_FIELDNAME] - ColWidths[X_WIDTH] -
                    ColWidths[X_OPTIONS] - 32;
end;

procedure TDlgMuGri.NavSetTitel(Sender: TObject; var Titel,
  Titel2: TCaption);
begin
  Titel2 := Caption2;
end;

procedure TDlgMuGri.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  cl: TColor;
begin
  if not (gdFocused in State) then
    with TTitleGrid(Sender), TTitleGrid(Sender).Canvas do
    begin
      cl := clBlack;
      if ARow > 0 then
      begin
        if StrToIntTol(Cells[X_WIDTH, ARow]) = 0 then {Länge}
          cl := clGray;
      end;
      if Font.Color <> cl then
        Font.Color := cl;
      TextRect(Rect, Rect.Left+2, Rect.Top+2, Cells[ACol, ARow]);
    end;
end;

procedure TDlgMuGri.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  Grid.Invalidate;
end;

procedure TDlgMuGri.MiCopyClick(Sender: TObject);
var
  I: integer;
  S: string;
begin
  {Text Kopieren für Entw.Umgebung einzufügen:}
  Memo1.Lines.Clear;
  with Grid do
  begin
    for I := 1 to RowCount - 1 do
    begin
      //14.07.10 nur sichtbare Spalten
      if Cells[X_WIDTH, I] <> '0' then
      begin
        S := Cells[X_DISPLAY, I];
        AppendTok(S, Cells[X_WIDTH, I], ':');
        AppendTok(S, Cells[X_OPTIONS, I], ',');
        Memo1.Lines.Add(Format('%s=%s', [S, Cells[X_FIELDNAME, I]]));
      end;
    end;
  end;
  Memo1.SelectAll;
  Memo1.CopyToClipBoard;
end;

procedure TDlgMuGri.MiPasteClick(Sender: TObject);
var
  I: integer;
  S, S1, S2, S3, NextS: string;
  PasteList, OldList: TValueList;
  Y: integer;
begin
  {Text Einfügen von anderer:}
  Memo1.Lines.Clear;
  Memo1.PasteFromClipboard;  //Display:Width[,Options]=Fieldname
  PasteList := TValueList.Create;
  OldList := TValueList.Create;
  try
    PasteList.Assign(Memo1.Lines);
    //Hallo:16=PKVALUE
    //du da:11,S=WFER_ID
    //Bez:0=ABWV_BEZ
    with Grid do
    begin
      for I := 1 to RowCount - 1 do
        OldList.Add(Cells[X_FIELDNAME, I]);
      for I := PasteList.Count - 1 downto 0 do  //ungültige Felder entfernen
        if OldList.IndexOf(PasteList.Value(I)) < 0 then
          PasteList.Delete(I);
      for I := 0 to OldList.Count - 1 do  //bisherige Felder übernehmen mit 0
        if PasteList.ValueIndex(OldList[I], nil) < 0 then
          PasteList.AddFmt('%s:0=%s', [OldList[I], OldList[I]]);

      Y := 1;
      for I := 0 to PasteList.Count - 1 do
      begin
        S := StrParam(PasteList[I], true);  //Display:Width[,Options]=Fieldname
        Cells[X_FIELDNAME, Y] := StrValue(PasteList[I], true);
        S1 := PStrTok(S, ':,', NextS);
        S2 := PStrTok('', ':,', NextS);
        S3 := PStrTok('', ':,', NextS);
        Cells[X_DISPLAY, Y] := S1;
        Cells[X_WIDTH, Y] := S2;
        Cells[X_OPTIONS, Y] := S3;
        Inc(Y);
      end;

      //for I := Y to RowCount - 1 do
      //  ClearRow(I);
      //Strip;  unnötig da beide listen gleichlang
    end;
  finally
    PasteList.Free;
    OldList.Free;
  end;
end;

procedure TDlgMuGri.MiSpaltenbreitenClick(Sender: TObject);
begin
  Grid.AdjustColWidths;
end;

procedure TDlgMuGri.MiColOffsetPlusClick(Sender: TObject);
var
  Y: integer;
begin
  with Grid do
  begin
    for Y := Grid.RowCount - 1 downto 2 do
      Cells[X_WIDTH, Y] := Cells[X_WIDTH, Y - 1];
    Cells[X_WIDTH,1] := IntToStr(length(Cells[X_DISPLAY,1]));
  end;
end;

procedure TDlgMuGri.MiColOffsetMinusClick(Sender: TObject);
var
  Y: integer;
begin
  with Grid do
  begin
    for Y := 1 to Grid.RowCount - 2 do
      Cells[X_WIDTH, Y] := Cells[X_WIDTH, Y + 1];
    Cells[X_WIDTH,Grid.RowCount - 1] := IntToStr(length(Cells[X_DISPLAY,Grid.RowCount - 1]));
  end;
end;

procedure TDlgMuGri.MiColOffsetClick(Sender: TObject);
begin
  MiColOffset.Checked := not MiColOffset.Checked;
  SetColOffs(ord(MiColOffset.Checked));          {1=Checked}
  ModalResult := mrCancel;
end;

end.
