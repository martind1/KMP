unit NXls;
(* Modul zur einfachen Handhabung von NativeExcel Komponente
   support@nika-soft.com
   - gleiche Schnittstelle wie xls.pas
   23.08.04 MD  WideString
   24.05.05 MD  erstellt (NativeExcel)
*)
interface

uses
  Classes, Grids, Graphics,
  nExcel;

type
  TNXls = class(TObject)
  private
    function GetCells(aRow, aCol: integer): IXLSRange;
    function GetActiveSheet: IXLSWorksheet;
  public
    XlsFileName, XlsSheet: string;
    Visible: boolean;   //Flag ob nach Close der Excelviewer starten soll
    NoWait: boolean;    //Flag ob auf Excelviewer gewartet werden soll (false = warten)
    Book: IXLSWorkbook;

    constructor Create;
    destructor Destroy; override;
    procedure Sheets(XlsName: string; L: TStrings);
    procedure SetSheet(aSheet: string);
    procedure Open(aFileName, aSheet: string; aVisible, CreateNew: boolean);
    procedure Close(Save: boolean = false);

    function EStr(S: string): string;
    function WideEStr(S: WideString): WideString;
    function VariantOf(S: string): variant;  //Numerische Werte als solche exportieren
    procedure AutoFit(aRange: IXLSRange);
    procedure FormulaToValue(aRange: IXLSRange);

    property Sheet: IXLSWorksheet read GetActiveSheet;  //enthält Cells Property
    property Cells[aRow, aCol: integer]: IXLSRange read GetCells;
  end;

implementation

uses
  SysUtils, Forms, Windows, WideStrUtils, Variants,
  WinTools, nstr_Kmp, GNav_Kmp, Prots, Err__Kmp, DPos_Kmp;

constructor TNXls.Create;
begin
  SMess('Lade NExcel', [0]);
  Book := TXLSWorkbook.Create;
  Visible := false;
end;

destructor TNXls.Destroy;
begin
  Book := nil;  //Interface (IXLSWorkbook) wird automatisch freigegeben
  inherited;
end;

function TNXls.EStr(S: string): string;
begin {echte Leerzellen in Excel. Multilines mit $0A trennen}
  if S = '' then
    result := '''' else            {damit leer in Excel}
    result := S;
  result := StringReplace(result, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
end;

function TNXls.VariantOf(S: string): variant;
var
  S1: string;
begin
  S1 := Trim(S);
  if S1 <> '' then
  try
    if IsFloatStr(S1) then
      result := StrToFloat(S1) else
      result := S1;
  except
    result := S1;
  end else
    result := '''';            {bestehenden Wert mit Leerwert überschreiben}
end;

function TNXls.WideEStr(S: WideString): WideString;
begin
  if S = '' then
    result := WideChar('''') else            {damit leer in Excel}
    result := WideStringReplace(S, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TNXls.Sheets(XlsName: string; L: TStrings);
{ergänzt L mit den Arbeitsmappen}
var
  I: integer;
begin
  try
    if FileExists(XlsName) then
    try
      SMess('Open %s', [XLSName]);
      Book.Open(XLSName);
      for I := 1 to Book.Sheets.Count do
        L.Add(Book.Sheets[I].Name);
    finally
      Book.Close;
    end;
  except on E:Exception do
    EMess(self, E, 'NExcel', [0]);
  end;
  SMess0;
end;

procedure TNXls.SetSheet(aSheet: string);
var
  I, I1, N: integer;
  Sheet1: IXLSWorksheet;
  Sheets1: IXLSWorksheets;
begin
  XlsSheet := aSheet;
  I := -1;
  Sheets1 := Book.Sheets;
  N := Sheets1.Count;
  for I1 := 1 to N do
  begin
    Sheet1 := Sheets1.Entries[I1];
    if Sheet1.Name = aSheet then
    begin
      I := I1;
      break;
    end;
  end;
  if I > 0 then
  begin
    SMess('NSheet %s', [aSheet]);
    Book.Sheets[I].Activate;
  end else
  begin
    SMess('Adding NSheet %s', [aSheet]);
    Book.Sheets.Add.Activate;
    Book.ActiveSheet.Name := aSheet;
  end;
end;

function TNXls.GetActiveSheet: IXLSWorksheet;
begin
  result := Book.ActiveSheet;
end;

function TNXls.GetCells(aRow, aCol: integer): IXLSRange;
begin
  result := Book.ActiveSheet.Cells[aRow, aCol];
end;

procedure TNXls.Open(aFileName, aSheet: string; aVisible, CreateNew: boolean);
begin
  try
    if ExtractFileExt(aFileName) <> '' then
      XlsFileName := aFileName else
      XlsFileName := aFileName + '.xls';
    XlsFileName := ExpandFileName(XlsFileName);
    Visible := aVisible;   { für Preview und testphase sinnvoll }
    if FileExists(XlsFileName) or not CreateNew then
    begin
      SMess('Open %s', [XlsFileName]);
      Book.Open(XlsFileName);
      if aSheet <> '' then
        SetSheet(aSheet);
    end else
    begin
      SMess('Create %s', [XlsFileName]);
      if aSheet <> '' then
        SetSheet(aSheet) else
        Book.Sheets.Add;
      //Book.SaveAs(XlsFileName);
    end;
    {hier: Daten exp/imp}
  except on E:Exception do
    EError('NXLS.Open(%s,%s):%s', [aFileName, aSheet, E.Message]);
  end;
end;

procedure TNXls.Close(Save: boolean = false);
begin
  if Save then
  begin
    //Book.Save;
    Book.SaveAs(XlsFileName);
  end;
  if Visible then
  begin
    Application.ProcessMessages;
    if NoWait then
      ShellExecNoWait(XlsFileName) else
      ShellExecAndWait(XlsFileName);
  end;
end;

procedure TNXls.AutoFit(aRange: IXLSRange);
var
  X, Y, NP1, NPixel: integer;
  CW: double;
  SPixel: string;
  aColumn: IXLSRange;
  MyCanvas: TCanvas;
  aCell: IXLSRange;
  AValue: Variant;
begin
  MyCanvas := TCanvas.Create;
  MyCanvas.Handle := GetDC(Application.Handle);
  Y := 0;
  try
    // Use MyCanvas.TextWidth in here to do
    // whatever you need.
    for X := 1 to aRange.Columns.Count do
    try
      aColumn := aRange.Columns[X];
      NPixel := 0;
      for Y := 1 to aColumn.Count do
      try
        aCell := aRange[Y, X];
        if aCell <> nil then
        begin
          AValue := aCell.Value;
          if not VarIsEmpty(AValue) and not VarIsNull(AValue) then
          begin
            MyCanvas.Font.Charset := aCell.Font.Charset;
            MyCanvas.Font.Name := aCell.Font.Name;
            MyCanvas.Font.Size := Round(aCell.Font.Size);
            NP1 := MyCanvas.TextWidth(AValue);
            if NPixel < NP1 then
            begin
              NPixel := NP1;
              SPixel := AValue;
            end;
          end;
        end;
      except on E:Exception do
        EProt(self, E, 'Autofit1 %d %d', [Y, X]);
      end;
      Y := 0;
      if NPixel > 0 then
      begin
        CW := NPixel / MyCanvas.TextWidth('0');
        Prot0('Autofit %d: %f -> %f (%s)',
          [X, double(aColumn.ColumnWidth), CW, SPixel]);
        aColumn.ColumnWidth := CW;
      end;
    except on E:Exception do
      EProt(self, E, 'Autofit2 %d %d', [Y, X]);
    end;
  finally
    ReleaseDC(Application.Handle, MyCanvas.Handle);
    MyCanvas.Free;
  end;
end;

procedure TNXls.FormulaToValue(aRange: IXLSRange);
//Formeln mit Werten ersetzen
var
  X, Y: integer;
  aColumn: IXLSRange;
  aCell: IXLSRange;
begin
  for X := 1 to aRange.Columns.Count do
  begin
    aColumn := aRange.Columns[X];
    for Y := 1 to aColumn.Count do
    begin
      aCell := aRange[Y, X];
      if aCell <> nil then
      begin
        aCell.Value := aCell.Value;
      end;
    end;
  end;
end;


(*
      Cell.Font.Charset := Font.Charset;
//      Cell.Font.Family := Font.Family;
      Cell.Font.Name := Font.Name;
      Cell.Font.Size := Font.Size;
      Cell.NumberFormat := '@';
      if SetColumnsWidth then
         Cell.EntireColumn.ColumnWidth := FDBGrid.Columns[i - 1].Width * 0.1433;
      if (fsBold in Font.Style) then
         Cell.Font.Bold := true ;
      if (fsItalic in Font.Style) then
         Cell.Font.Italic :=  true;
      if (fsUnderline in Font.Style) then
         Cell.Font.Underline :=  xlUnderlineStyleSingle;
      if (fsStrikeOut in Font.Style) then
         Cell.Font.Strikethrough :=  true;
*)

end.
