unit TgridKmp;
(* Grid Komponente (ohne DB)
   mit Spalten- und Zeilenüberschriften
   mit Zeilenorientierten Methoden
   02.08.98  MD  RowTitle mit Zelleninhalten eine Zeile durch ';' getrennt
                 (Titel=C1;C2;C3;...)
   04.04.01      Sortierung.     Durch Klick auch Title
   09.04.02      CopyToHtml
   28.06.02      CopyToHtml: Txt mit TAB getrennt, Csv hinzugefügt
   03.06.03      SaveToIni, LoadFromIni
   21.07.03      AddCell, Strip, ClearCol, ColIsEmpty, NewRow
   08.05.09      ColTitle, TitleCol
   30.11.09      Idee: ImportExcel()
   27.07.10      toAlignCenter, alCenter
   25.11.13  md  ColSpace:Dflt=4 ist zu klein für Win7 nehme 12.
*)
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, Prots;

type
  TTitleOption = (toNoExpand,     //´Bediener kann keine Zeile anfügen
                  toAlignRight,   // Rechtsbündige Ausgabe
                  toAlignCenter,  // zentrierte Ausgabe
                  toTitleCol0);   // Titles ab Spalte 0 (trotz FixedCols=1)
  TTitleOptions = set of TTitleOption;

  TTitleGrid = class(TStringGrid)
  private
    { Private-Deklarationen }
    FTitles: TStrings;
    FRowTitles: TStrings;
    FTitleOptions: TTitleOptions;
    FAdjustWidths: boolean;
    FColSpace: integer;
    procedure SetAdjustWidths(Value: boolean);
    procedure SetTitles(Value: TStrings);
    procedure TitlesChange(Sender: TObject);
    procedure SetRowTitles(Value: TStrings);
    procedure RowTitlesChange(Sender: TObject);
    procedure SetTitleOptions(const Value: TTitleOptions);
  protected
    { Protected-Deklarationen }
    MouseDownX, MouseDownY: integer;  {Sortieren bei Doubleclick}
    MouseDownShift: TShiftState;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure DblClick; override;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearAll(Shrink: boolean = false);
    procedure ClearRow(ARow: integer);
    procedure ClearCol(ACol: integer);
    function RowIsEmpty(ARow: integer): boolean;
    function ColIsEmpty(ACol: integer): boolean;
    procedure InsertRow(ARow: integer);
    function NewRow: integer;  //ergibt 1. leere Zeile. Fügt Zeile an wenn notwendig.
    function TitleCol(aTitle: string): integer;
    function ColTitle(aCol: integer): string;
    procedure DeleteRow(ARow: integer); reintroduce;
    procedure DeleteCol(ACol: integer);
    procedure AdjustColWidths(UpOnly: boolean = false); {Spaltenbreiten anpassen}
    procedure Sort(const Cols: array of Integer; Descending: boolean = false);
    procedure CopyToHtml;
    procedure Transpond; {vertauscht Zeilen mit Spalten}
    procedure SaveToIni(aSection: string);
    procedure LoadFromIni(aSection: string);
    procedure Strip;   //löscht alle leeren Zeilen/Spalten am Ende
    procedure AddCell(aCol, aRow: integer; aValue: string); //Zuweisung auch hinter RowCount/ColCount
    procedure ImportExcel(Filename, TabSheet: string; Y0, YMax: integer;
      XKeyStr: string; Columns: TStrings);

    property ColSpace: integer read FColSpace write FColSpace default 4;

    property InplaceEditor; {Sichtbarkeit verschieben von TStringGrid protected auf public}
    property ColWidths;
    property RowHeights;
    property Col;
    property Row;
  published
    { Published-Deklarationen }
    property AdjustWidths: boolean read FAdjustWidths write SetAdjustWidths;
    property Titles: TStrings read FTitles write SetTitles;
    property RowTitles: TStrings read FRowTitles write SetRowTitles;
    property TitleOptions: TTitleOptions read FTitleOptions write SetTitleOptions;
  end;

implementation

uses
  DPos_Kmp, GNav_Kmp, Ini__Kmp, Err__Kmp, HtmlClp, XLS;

type
  TTitleParam = record
                   Width: integer;
                   AlRight: boolean;  //rechtsbündig (;R)
                   AlCenter: boolean;  //rechtsbündig (;C)
                 end;

function TitleParam(S: string): TTitleParam;
var
  S1, NextS: string;
begin
  Result.Width := 0;
  Result.AlRight := false;
  Result.AlCenter := false;
  S1 := PStrTok(StrValue(S), ';', NextS);
  while S <> '' do
  begin
    if IsNum(Char1(S1)) then
      Result.Width := StrToInt(S1) else
    if SameText(S1, 'R') then
      Result.AlRight := true;
    if SameText(S1, 'C') then
      Result.AlCenter := true;
    //wird fortgeführt ...
    S := PStrTok('', ';', NextS);
  end;
end;

constructor TTitleGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTitles := TValueList.Create;
  TStringList(FTitles).OnChange := TitlesChange;
  FRowTitles := TValueList.Create;
  TStringList(FRowTitles).OnChange := RowTitlesChange;
  //Leider nicht kompatibel zu bestehenden dfm's:
  // FSaveCellExtents := false;  //ColWidths nicht in .dfm speichern
  FColSpace := 4;  //Leerabstand bei Adjust
end;

destructor TTitleGrid.Destroy;
begin
  FreeAndNil(FTitles);
  FreeAndNil(FRowTitles);
  inherited Destroy;
end;

procedure TTitleGrid.SetTitles(Value: TStrings);
begin
  if (Value <> nil) and (Value <> FTitles) then
    FTitles.Assign(Value);
end;

procedure TTitleGrid.SetTitleOptions(const Value: TTitleOptions);
begin
  if FTitleOptions <> Value then
  begin
    if (toTitleCol0 in FTitleOptions) <> (toTitleCol0 in Value) then
    begin
      FTitleOptions := Value;
      TitlesChange(self);
    end else
      FTitleOptions := Value;
  end;
end;

procedure TTitleGrid.SetAdjustWidths(Value: boolean);
begin
  if FAdjustWidths <> Value then
  begin
    FAdjustWidths := Value;
    if FAdjustWidths and not (csLoading in ComponentState) then
      AdjustColWidths;
  end;
end;

procedure TTitleGrid.AdjustColWidths(UpOnly: boolean = false);
{ Spaltenbreiten anpassen. UpOnly: nur vergrößern }
var
  X, Y, ATextWidth: integer;
begin
  Canvas.Font.Assign(self.Font);
  for X := 0 to ColCount - 1 do  //FixedCols
  begin
    ATextWidth := 0;
    for Y := 0 to RowCount - 1 do                {beware FixedRows}
      ATextWidth := IMin(self.Width - 20,
                         IMax(ATextWidth, Canvas.TextWidth(Cells[X,Y])));
    if UpOnly then
      ColWidths[X] := IMax(ColWidths[X], ATextWidth + ColSpace) else
      ColWidths[X] := ATextWidth + ColSpace;            {4 für Linie+Space}
  end;
end;

procedure TTitleGrid.TitlesChange(Sender: TObject);
var
  I, AWidth: integer;
  //ATextWidth: integer;
  ATitle: string;
  X0: integer;
  ATitleParam: TTitleParam;
begin
  if //not (csLoading in ComponentSTate) and
     (FixedRows > 0) and (FTitles.Count > 0) then  {Anzahl der nicht lauffähigen Zeilen}
  begin
    //ATextWidth := Canvas.TextWidth('8'); {Breite von '8' bestimmen in Pixel }
    if not (toTitleCol0 in TitleOptions) then
    begin
      ColCount := FTitles.Count + FixedCols;
      for I:= 0 to FixedCols-1 do
        Cells[I, 0] := '';
      X0 := FixedCols;
    end else
    begin
      ColCount := FTitles.Count;
      X0 := 0;
    end;
    for I:= 0 to FTitles.Count-1 do
    begin
      ATitle := StrParam(FTitles[I]);   {Titel=<Breite>;<Flags>  (Flags ab 08.05.09)}
      ATitleParam := TitleParam(FTitles[I]);
      AWidth := IntDflt(ATitleParam.Width, Canvas.TextWidth(ATitle));
      Cells[X0 + I, 0] := ATitle;
      {ColWidths[FixedCols + I] := AWidth * ATextWidth + 4;  {4 für Linie+Space}
      ColWidths[X0 + I] := AWidth + 4;  {4 für Linie+Space}
    end;
  end;
end;

procedure TTitleGrid.SetRowTitles(Value: TStrings);
begin
  if Value <> FRowTitles then
    FRowTitles.Assign(Value);
end;

procedure TTitleGrid.RowTitlesChange(Sender: TObject);
var
  I, X, AWidth: integer;
  ATitle, ACellList, NextS: string;
begin
  if (FRowTitles.Count > 0) then  {Anzahl der nicht lauffähigen Zeilen}
  begin
    //ATextWidth := (Owner as TForm).Canvas.TextWidth('9'); {Breite von '8' bestimmen in Pixel }
    RowCount := FRowTitles.Count + FixedRows;
    for I:= 0 to FixedRows-1 do
      if not (toTitleCol0 in TitleOptions) or (I > 0) then
        Cells[0, I] := '';
    AWidth := 1;
    X := 0;
    for I:= 0 to FRowTitles.Count-1 do
    begin
      ATitle := (FRowTitles as TValueList).Param(I);  {Titel=C1;C2;C3;...}
      AWidth := IMax(AWidth, (Owner as TForm).Canvas.TextWidth(ATitle));
      if FixedCols > 0 then
        Cells[0, FixedRows + I] := ATitle;
      ACellList := PStrTok((FRowTitles as TValueList).Value(I), ';', NextS);
      X := FixedCols;
      while ACellList <> '' do
      begin
        if ColCount <= X then
          ColCount := X + 1;
        Cells[X, FixedRows + I] := ACellList;
        ACellList := PStrTok('', ';', NextS);
        Inc(X);
      end;
    end;
    if (X > FixedCols) and FAdjustWidths then
      AdjustColWidths;
    if FixedCols > 0 then
      ColWidths[0] := AWidth + 4;
  end;
end;

procedure TTitleGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState); //override;
{rechtsbündig anzeigen}
var
  S: string;
  X: integer;
begin
  inherited DrawCell(ACol, ARow, ARect, AState);
  //if (ACol > FixedCols) and (ARow > FioxedRows) then
  if (toAlignRight in TitleOptions) or
     TitleParam(ColTitle(ACol)).alRight then
  begin
    S := Cells[ACol, ARow];
    //X := IMax(ARect.Left+2, ARect.Right-2 - Canvas.TextWidth(S));
    X := ARect.Right-2 - Canvas.TextWidth(S);
    Canvas.TextRect(ARect, X, ARect.Top+2, S);
  end else
  if (toAlignCenter in TitleOptions) or
     TitleParam(ColTitle(ACol)).alCenter then
  begin
    S := Cells[ACol, ARow];
    X := (ARect.Right - ARect.Left) - Canvas.TextWidth(S) div 2;
    Canvas.TextRect(ARect, X, ARect.Top+2, S);
  end;
end;

procedure TTitleGrid.KeyDown(var Key: Word; Shift: TShiftState);
{bei Tab wird nächste Zeile generiert}
begin
  if csDesigning in ComponentState then
    exit;
  if (Shift = []) and
     not RowIsEmpty(Row) and
     (((Key = VK_TAB) and (Col >= ColCount-1)) or (Key = VK_DOWN)) and
     (Row >= RowCount-1) and
     not (toNoExpand in TitleOptions) then
  begin
    //InsertRow(RowCount);                   {mit ClearRow! QDispo.DiAu}
    Col := FixedCols; {aktuelle Spalte}
    if Row >= RowCount - 1 then
      RowCount := RowCount + 1;
    Col := FixedCols; {aktuelle Spalte}
    Row := RowCount - 1; {aktuelle Zeile}
  end else
    inherited KeyDown(Key, Shift);
end;

procedure TTitleGrid.ClearRow(ARow: integer);
var
  X: integer;
begin
  if ARow < FixedRows then
    exit;
  for X:= FixedCols to ColCount-1 do
    Cells[X, ARow] := '';
end;

procedure TTitleGrid.ClearCol(ACol: integer);
var
  Y: integer;
begin
  if ACol < FixedCols then
    exit;
  for Y:= FixedRows to RowCount-1 do
    Cells[ACol, Y] := '';
end;

procedure TTitleGrid.ClearAll(Shrink: boolean = false);
var
  X, Y: integer;
  IsEmpty: boolean;
begin
  for Y:= FixedRows to RowCount-1 do
    ClearRow(Y);
  if Shrink then
  begin
    if FixedCols > 0 then
    begin  //reduzieren auf belegte Spalten-/Zeilenüberschriften
      for Y := RowCount-1 downto FixedRows do
      begin
        IsEmpty := true;
        for X := 0 to FixedCols - 1 do
          if Cells[X, Y] <> '' then
          begin
            IsEmpty := false;
            break;
          end;
        if IsEmpty then
          RowCount := IMax(Y, FixedRows + 1);
      end;
    end else
      RowCount := FixedRows + 1;  //darf nicht bis auf FixedRows gehen da die sonst nicht mehr fix sind
  end;
end;

function TTitleGrid.RowIsEmpty(ARow: integer): boolean;
var
  X: integer;
begin
  result := true;
  for X:= FixedCols to ColCount-1 do
    if Cells[X,ARow] <> '' then
    begin
      result := false;
      exit;
    end;
end;

function TTitleGrid.ColIsEmpty(ACol: integer): boolean;
var
  Y: integer;
begin
  result := true;
  for Y := 0 to RowCount-1 do    //0! wg Titles
    if Cells[ACol, Y] <> '' then
    begin
      result := false;
      exit;
    end;
end;

procedure TTitleGrid.InsertRow(ARow: integer);
var
  Y: integer;
begin
  if ARow < FixedRows then
    EError('ERROR %s.InsertRow Parameter ARow(%d) < FixedRows(%d)', [OwnerDotName(self), ARow, FixedRows]);
  if ARow < RowCount then
  begin
    RowCount := RowCount + 1;
    for Y := RowCount-1 downto ARow+1 do
      Rows[Y].Assign(Rows[Y-1]);
    Row := IMin(RowCount - 1, ARow);
    ClearRow(Row);
  end else
  begin
    //RowCount := ARow - 1;   ???
    RowCount := ARow + 1;     //04.01.04
  end;
end;

function TTitleGrid.NewRow: integer;
var
  Y: integer;
begin
  for Y := FixedRows to RowCount - 1 do
    if RowIsEmpty(Y) then
    begin
      result := Y;
      exit;
    end;
  result := RowCount;
  RowCount := RowCount + 1;
end;

function TTitleGrid.TitleCol(aTitle: string): integer;
//ergibt X-Wert der Spalte mit dem Titel oder -1 bei Fehler
var
  X: integer;
begin
  Result := -1;  //vor 12.03.10: 0 
  for X := 0 to ColCount - 1 do
    if AnsiSameText(Cells[X, 0], aTitle) then
    begin
      Result := X;
      Break;
    end;
end;

function TTitleGrid.ColTitle(aCol: integer): string;
// ergibt Titles-Zeile an Spalte ( Titel=<Width>;<Options> )
// für TitleParam
var
  I: integer;
begin
  if toTitleCol0 in TitleOptions then
    I := aCol else
    I := aCol - FixedRows;
  if (I < 0) or (I >= Titles.Count) then
    Result := '' else
    Result := Titles[I];
end;

procedure TTitleGrid.DeleteRow(ARow: integer);
var
  Y: integer;
begin
  if ARow < FixedRows then
    exit;
  for Y := ARow to RowCount - 2 do
    Rows[Y].Assign(Rows[Y + 1]);
  if RowCount > FixedRows + 1 then
  begin
    if Row = RowCount - 1 then
      Row := RowCount - 2;
    RowCount := RowCount - 1;
  end else
  begin    //letzte Zeile: leermachen
    ClearRow(RowCount - 1);
  end;
end;

procedure TTitleGrid.DeleteCol(ACol: integer);
var
  X: integer;
begin
  if ACol < FixedCols then
    exit;
  for X := ACol to ColCount - 2 do
    Cols[X].Assign(Cols[X + 1]);
  if ColCount > FixedCols + 1 then
  begin
    if Col = ColCount - 1 then
      Col := ColCount - 2;
    ColCount := ColCount - 1;
  end else
  begin    //letzte Zeile: leermachen
    ClearCol(ColCount - 1);
  end;
end;

procedure TTitleGrid.Sort(const Cols: array of Integer; Descending: boolean = false);
{Sortieren nach Spalte <Col>
 1. export nach StringList, Col(s) zuerst. idF Inhalt=x,  x=1..n
 2. sortierte Stringlist nach Grid
}
var
  I, Y, IL, X: integer;
  L: TValueList;
  Par, Val, Tok, NextS: string;
begin
  L := TValueList.Create;
  try
    for Y := FixedRows to RowCount - 1 do
    begin
      Par := '';
      for I := Low(Cols) to High(Cols) do
      begin
        if Cells[Cols[I], Y] = '' then
          AppendTok(Par, ' ', '|') else
          AppendTok(Par, Cells[Cols[I], Y], '|');
      end;
      Val := '';
      for I := FixedCols to ColCount - 1 do
      begin
        if Cells[I, Y] = '' then
          AppendTok(Val, ' ', '|') else
          AppendTok(Val, Cells[I, Y], '|');
      end;
      L.AddFmt('%s=%s', [Par, Val]);
    end;
    //L.Sort;
    SortStrings(L, Descending);
    for IL := 0 to L.Count - 1 do
    begin
      Y := IL + FixedRows;
      Val := L.Value(IL);
      X := FixedCols;
      Tok := PStrTok(Val, '|', NextS);
      while X < ColCount do
      begin
        Cells[X, Y] := Tok;
        Tok := PStrTok('', '|', NextS);
        Inc(X);
      end;
    end;
  finally
    L.Free;
  end;
end;

procedure TTitleGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  MouseDownX := X;
  MouseDownY := Y;
  MouseDownShift := Shift;
end;

procedure TTitleGrid.DblClick;
// Doppelklick auf Spaltenüberschrift sortiert
// wenn Strg gedrückt dann absteigend
var
  aCol, aRow: integer;
begin
  if csDesigning in ComponentState then
  begin
    inherited DblClick;
    Exit;
  end;
  ARow := MouseCoord(MouseDownX, MouseDownY).Y;
  if ARow < FixedRows then
  begin  //nur Ueberschrift
    aCol := MouseCoord(MouseDownX, MouseDownY).X;
    Sort([aCol], ssCtrl in MouseDownShift);
  end else
    inherited DblClick;
end;

(*** Copy to Clipboard *******************************************************)

procedure TTitleGrid.CopyToHtml; {Copy to Clipboard Html Format}
var
  L, Html, Rtf, Txt, Csv: TStringList;
  iCol, iRow, I1, N: integer;
  T, C, S1, ContextStart, ContextEnd: string;
begin
  L := TStringList.Create;
  Html := TStringList.Create;
  Rtf := TStringList.Create;
  Txt := TStringList.Create;
  Csv := TStringList.Create;

  // {\rtf1 {1 \tab 2das ist länger als tab \tab 3 \par 4 \tab {\b\i 5} \tab 6}}

  try
    Screen.Cursor := crHourGlass;
    GetStringsStrings(GNavigator.HtmlTable, 'ContextStart', L);
    ContextStart := L.Text;
    GetStringsStrings(GNavigator.HtmlTable, 'ContextEnd', L);
    ContextEnd := L.Text;

    GetStringsStrings(GNavigator.HtmlTable, 'HdrTable', L);
    Html.AddStrings(L);
    GetStringsStrings(GNavigator.HtmlTable, 'HdrCaptions', L);
    Html.AddStrings(L);

    Rtf.Add('{\rtf1 {'); {Rtf}
    N := 0;              {Rtf}
    T := '';             {Txt}
    C := '';             {Csv}
    GetStringsStrings(GNavigator.HtmlTable, 'Captions', L);
    for iCol := 0 to ColCount-1 do
    begin
      {AField := Fields[iCol];
      if AField.Visible then}
      begin
        for I1 := 0 to L.Count - 1 do
        begin
          S1 := L.Strings[I1];
          S1 := Format(S1, [StrToHtml(Cells[iCol, 0])]);
          Html.Add(S1);
        end;
        if N > 0 then                                     {Rtf}
          Rtf.Add('\tab');                                {Rtf}
        S1 := Format('{\b\i %S}', [Cells[iCol, 0]]);      {Rtf}
        Rtf.Add(S1);                                      {Rtf}
        Inc(N);                                           {Rtf}
        AppendTok(T, Format('"%S"', [Cells[iCol, 0]]), TAB); {Txt}
        AppendTok(C, Format('"%S"', [Cells[iCol, 0]]), ';'); {Csv}
      end;
    end;
    GetStringsStrings(GNavigator.HtmlTable, 'FtrCaptions', L);
    Html.AddStrings(L);
    Txt.Add(T);                                           {Txt}
    Csv.Add(C);                                           {Csv}

    Rtf.Add('\par');                                      {Rtf}
    for iRow := 1 to RowCount - 1 do
    begin
      GetStringsStrings(GNavigator.HtmlTable, 'HdrLine', L);
      Html.AddStrings(L);

      GetStringsStrings(GNavigator.HtmlTable, 'Line', L);
      N := 0;                                             {Rtf}
      T := '';                                            {Txt}
      C := '';                                            {Csv}
      for iCol := 0 to ColCount-1 do
      begin
        {AField := Fields[iCol];
        if AField.Visible then}
        begin
          for I1 := 0 to L.Count - 1 do
          begin
            S1 := L.Strings[I1];
            S1 := Format(S1, [StrToHtml(Cells[iCol, iRow])]);
            Html.Add(S1);
          end;
          if N > 0 then                                   {Rtf}
            Rtf.Add('\tab');                              {Rtf}
          Rtf.Add(Cells[iCol, iRow]);                     {Rtf}
          Inc(N);                                         {Rtf}
          AppendTok(T, Format('"%S"', [Cells[iCol, iRow]]), TAB);        {Txt}
          AppendTok(C, Format('"%S"', [Cells[iCol, iRow]]), ';');        {Csv}
        end;
      end;
      Rtf.Add('\par');                                    {Rtf}
      Txt.Add(T);                                         {Txt}
      Csv.Add(C);                                         {Csv}
      GetStringsStrings(GNavigator.HtmlTable, 'FtrLine', L);
      Html.AddStrings(L);
    end;
    GetStringsStrings(GNavigator.HtmlTable, 'FtrTable', L);
    Html.AddStrings(L);
    CopyHtml(Html.Text, '', '');
    Rtf.Add('}}');                                        {Rtf}
    CopyRtf(Rtf.Text);                                    {Rtf}
    CopyTxt(Txt.Text);                                    {Txt}
    CopyCsv(Csv.Text);                                    {Csv}
  finally
    L.Free;
    Html.Free;
    Rtf.Free;
    Txt.Free;
    Csv.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TTitleGrid.Transpond;
{vertauscht Zeilen mit Spalten}
var
  TmpGrid: TStringGrid;
  I: integer;
begin
  TmpGrid := TStringGrid.Create(Application);
  try
    TmpGrid.RowCount := ColCount;
    TmpGrid.ColCount := RowCount;
    TmpGrid.FixedCols := FixedCols;
    TmpGrid.FixedRows := FixedRows;
    for I := 0 to RowCount - 1 do
    begin
      TmpGrid.Cols[I].Assign(Rows[I]);
      //Prot0('R%d:%s', [I, StrToValidIdent(Rows[I].Text)]);
    end;
    RowCount := TmpGrid.RowCount;
    ColCount := TmpGrid.ColCount;
    for I := 0 to ColCount - 1 do
    begin
      Cols[I].Assign(TmpGrid.Cols[I]);
      //Prot0('C%d:%s', [I, StrToValidIdent(Cols[I].Text)]);
    end;
  finally
    TmpGrid.Free;
  end;
end;

procedure TTitleGrid.LoadFromIni(aSection: string);
var
  L: TStringList;
begin    //Inhalt aus INI-Datei. Überschriften nur wenn Titles leer
  ClearAll;
  Strip;
  L := TStringList.Create;
  try
    IniKmp.ReadSectionValues(aSection, L);
    StringsToGrid(L, self, Titles.Text = '');
  finally
    L.Free;
  end;
end;

procedure TTitleGrid.SaveToIni(aSection: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    GridToStrings(self, L, true);
    IniKmp.EraseSection(aSection);
    IniKmp.WriteSection(aSection, L);
  finally
    L.Free;
  end;
end;

procedure TTitleGrid.AddCell(aCol, aRow: integer; aValue: string);
// Zellen hinzufügen. Keine negativen Koordinaten ab 18.04.10
// Fixed-Koordinaten erlaubt (ImportXls)
begin
  if (aCol < 0) or (aRow < 0) then
    Exit;  //spart Abfrage beim Aufrufer
  if ColCount <= aCol then
    ColCount := aCol + 1;
  if RowCount <= aRow then
    RowCount := aRow + 1;
  if (aCol < 0) or (aRow < 0) then
  begin
    if Sysparam.ProtBeforeOpen then
      Prot0('%s:AddCell(%d,%d,%.50s)', [OwnerDotName(self), aCol, aRow, aValue]);
    aCol := IMax(0, aCol);
    aRow := IMax(0, aRow);
  end;
  Cells[aCol, aRow] := aValue;
end;

procedure TTitleGrid.Strip;
var
  X, Y: integer;
begin
  for Y := RowCount - 1 downto FixedRows do
  begin
    if RowIsEmpty(Y) then
      DeleteRow(Y) else
      break;
  end;
  for X := ColCount - 1 downto FixedCols do
  begin
    if ColIsEmpty(X) then
      DeleteCol(X) else
      break;
  end;
end;

{ Import Excel }

procedure TTitleGrid.ImportExcel(Filename, TabSheet: string; Y0, YMax: integer; XKeyStr: string;
  Columns: TStrings);
// Columns: <GridCol=XlsCol>, VORNAME=AP, Vorname=13
// für WeBAB#TFrmPERS.BtnXlsReadClick
var
  Xls: TXls;

  procedure ImportXls;
  //aktuelles Sheet nach ImpGrid einlesen
  var
    Y, X, X_Key, YWithKey: integer;
    C: string;
    S1, S2: string;
    XG, YGrid: integer;
    I, NG: integer;
  begin
    with XLS do
    begin
      X_Key := ToX(XKeyStr);

      { Loop bis Spalte <XKey> <YMax> mal leer ist }

      Y := Y0;
      YWithKey := Y0;
      YGrid := IMax(self.Row, self.FixedRows);
      while true do
      begin
        NG := 0;
        C := Excel.Cells[Y, X_Key];
        if C <> '' then
          YWithKey := Y;
        if Y - YWithKey > YMax then
          Break;  //fertig

        for I := 0 to Columns.Count - 1 do
        begin
          S1 := StrParam(Columns[I]);  //*VORNAME*=AP
          S2 := StrValue(Columns[I]);  //VORNAME=*AP*
          if (S2 = '') or BeginsWith(S2, '-') then  //leer, -1 nicht importieren
            Continue;

          XG := self.Titles.IndexOf(S1);
          if XG < 0 then
            XG := self.Titles.Add(S1);

          X := ToX(S2);
          C := Excel.Cells[Y, X];
          self.AddCell(XG, YGrid, C);
          if C <> '' then
            Inc(NG);
        end;
        if NG > 0 then
          Inc(YGrid);
        Inc(Y);

        GNavigator.ProcessMessages;
      end;
    end;
  end; { ImportXls }

var
  L: TStringList;
  I: integer;
begin { ImportExcel }
  if not FileExists(Filename) then
    EError('%s Datei "%s" nicht gefunden', [OwnerDotName(self), Filename]);
  Prot0('%s Import Excel %s', [OwnerDotName(self), Filename]);
  Screen.Cursor := crHourGlass;
  L := TStringList.Create;
  Xls := TXls.Create;
  try
    Xls.Open(Filename, '', false, false);
    for I := 1 to Xls.Excel.Sheets.Count do
      L.Add(Xls.Excel.Sheets[I].Name);

    if L.IndexOf(Tabsheet) >= 0 then
    begin
      Prot0('%s Import Sheet %s', [OwnerDotName(self), Tabsheet]);
      Xls.SetSheet(Tabsheet);
      ImportXls;
    end else
    if Tabsheet = '' then
    begin
      Prot0('%s Import ActiveSheet', [OwnerDotName(self)]);
      ImportXls;
    end else
    //if Tabsheet <> '' then
      Prot0('%s WARN Sheet %s fehlt in Excel', [OwnerDotName(self), Tabsheet]);
    Xls.Close;
  finally
    self.AdjustColWidths;
    Screen.Cursor := crDefault;
    L.Free;
    Xls.Free;
  end;
end;


end.
