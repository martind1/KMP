unit Xls__Kmp;
(* Excel Ole Komponente für komfortablen Zugriff
17.06.10 md erstellt (von native)

------------------------------
// Setting a row of data with one call
  ExcelApp.Range['A2', 'D2'].Value := VarArrayOf([1, 10, 100, 1000]);

VarArray := OleApp.Workbooks('WorkBookName').Sheets('SheetName').Range['A1', 'B3'].Value;

CellFrom, CellTo: string; var VarArray: variant);
VarArray := ExcelWorksheet1.Range[CellFrom, CellTo].Value;


*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Xls;

type
  TXlsKmp = class(TComponent)
  private
    FVisible: boolean;
    FWorkSheet: string;
    FWorkFile: string;
    FWorkSheets: TStringList;  //Liste der Blätter
    FXls: TXls;
    FActive: boolean;
    FCacheVarArray: OleVariant;  //variant
    ActiveSheetCached: boolean;
    function GetCells(Y, X: Integer): String;
    function GetWorkSheets: TStrings;
    function GetCellsVariant(Y, X: Integer): Variant;
    procedure SetActive(const Value: boolean);
    procedure SetCells(Y, X: Integer; const Value: String);
    procedure SetCellsVariant(Y, X: Integer; const Value: Variant);
    procedure SetWorkFile(const Value: string);
    procedure SetWorkSheet(const Value: string);
    function Kurz: string;
    function EStr(S: string): string;
    function GetActive: boolean;
    function GetBook: OleVariant;
    function GetSheet: OleVariant;
    procedure InternalSaveAs(aFilename: string);
    function GetCell(Y, X: Integer): OleVariant;
  protected
    Changed: boolean;  //für Show, Print von ???Cells
  public
    LoadedWorkSheet: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open(CreateNew: boolean);
    procedure Close;
    procedure Save;
    procedure SaveAs(Filename: string);
    procedure Show;
    procedure Print;
    property Active: boolean read GetActive write SetActive;
    property Cells[Y, X: Integer]: String read GetCells write SetCells;
    property CellsVariant[Y, X: Integer]: Variant read GetCellsVariant write SetCellsVariant;
    property WorkSheets: TStrings read GetWorkSheets;
    property Book: OleVariant read GetBook;
    property Sheet: OleVariant read GetSheet;
    property Cell[Y, X: Integer]: OleVariant read GetCell;
    function CellIsEmpty(Y, X: integer): boolean;
    function RangeIsEmpty(Y0, X0, Y1, X1: integer): boolean;
    procedure DeleteConnections(aName: string);
    procedure CacheSheet;
  published
    property WorkFile: string read FWorkFile write SetWorkFile;
    property WorkSheet: string read FWorkSheet write SetWorkSheet;
    property Visible: boolean read FVisible write FVisible;  //Excel starten nach Close
  end;

implementation

uses
  Variants,
  Prots, Err__Kmp, Qwf_Form;

{ TXlsKmp }

function TXlsKmp.Kurz: string;
begin
  {if (Owner <> nil) and (Owner is TqForm) then
    Result := TqForm(Owner).Kurz else }
    Result := OwnerDotName(self);
end;

function TXlsKmp.EStr(S: string): string;
begin {echte Leerzellen in Excel. Multilines mit $0A trennen}
  if S = '' then
    result := '''' else            {damit leer in Excel}
    result := S;
  result := StringReplace(result, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
end;

constructor TXlsKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FXls := TXls.Create;
end;

destructor TXlsKmp.Destroy;
begin
  FreeAndNil(FWorkSheets);
  try
    FXls.Excel.Quit;
  except on E:Exception do
    Prot0('Fehler bei TXlsKmp.Destroy'+CRLF+'%s', [E.Message]);
  end;  
  Application.ProcessMessages;  {!!!}
  FXls.Free;  { TODO : KillExcel }
  inherited;
end;

function TXlsKmp.GetBook: OleVariant;
begin
  if not Active then
    EError('%s not Active (GetBook)', [Kurz]);
  Result := FXls.Excel.ActiveWorkBook;
end;

function TXlsKmp.GetSheet: OleVariant;
begin
  if not Active then
    EError('%s not Active (GetSheet)', [Kurz]);
  Result := Book.ActiveSheet;
end;

function TXlsKmp.GetCell(Y, X: Integer): OleVariant;
//ergibt die Cell als Objekt und nicht den Inhalt. Deshalb kein Cache. Inhalt über Cells
begin
  try
    if not Active then
      EError('%s not Active', [Kurz]);
    Result := Book.ActiveSheet.Cells[Y, X];
  except on E:Exception do
    EError('Error at GetCell(Y=%d,X=%d)'+CRLF+'%s', [Y, X, E.Message]);
  end;
end;

procedure TXlsKmp.CacheSheet;
//ActiveSheet komplett einlesen
//var
//  CellFrom, CellTo: string;
//  I, IDim, ICol: integer;
begin
//  //FCacheVarArray := Book.ActiveSheet.Range[CellFrom, CellTo].Value;
//  FCacheVarArray := Book.ActiveSheet.UsedRange.Value;
//  ActiveSheetCached := true;
//  //Dim1: Rows  Dim2: Cols
//  iDim := VarArrayDimCount(FCacheVarArray);
//  for i := 1 to iDim do
//  begin
//    iCol := VarArrayLowBound(FCacheVarArray, i);
//    iCol := VarArrayHighBound(FCacheVarArray, i);
//  end;
//
end;

function TXlsKmp.GetCells(Y, X: Integer): String;
// var
//   V: Variant;
begin
  try
    if ActiveSheetCached then
    begin
      if (Y <= VarArrayHighBound(FCacheVarArray, 1)) and
         (X <= VarArrayHighBound(FCacheVarArray, 2)) then
        Result := VarToStr(FCacheVarArray[Y, X]) else
        Result := '';
    end else
    begin
      if not Active then
        EError('%s not Active', [Kurz]);
      Result := VarToStr(Book.ActiveSheet.Cells[Y, X].Value);  //'' bei null
    end;
  except on E:Exception do
    EError('Error at GetCells(Y=%d,X=%d)'+CRLF+'%s', [Y, X, E.Message]);
  end;
//   V := Book.ActiveSheet.Cells[Y, X].Value;
//   if V = null then
//     Result := '' else
//     Result := V;
end;

function TXlsKmp.GetCellsVariant(Y, X: Integer): Variant;
begin
  try
    if ActiveSheetCached then
    begin
      if (Y <= VarArrayHighBound(FCacheVarArray, 1)) and
         (X <= VarArrayHighBound(FCacheVarArray, 2)) then
        Result := FCacheVarArray[Y, X] else
        Result := Unassigned;
    end else
    begin
      if not Active then
        EError('%s not Active', [Kurz]);
      Result := Book.ActiveSheet.Cells[Y, X].Value;
    end;
  except on E:Exception do
    EError('Error at GetCellsVariant(Y=%d,X=%d)'+CRLF+'%s', [Y, X, E.Message]);
  end;
end;

procedure TXlsKmp.SetCells(Y, X: Integer; const Value: String);
begin
  if not Active then
    EError('%s not Active (SetCells(%d,%d,%s)', [Kurz, Y, X, Value]);
  Book.ActiveSheet.Cells[Y, X].Value := EStr(Value);
end;

procedure TXlsKmp.SetCellsVariant(Y, X: Integer; const Value: Variant);
begin
  if not Active then
    EError('%s not Active (SetCells(%d,%d,%s)', [Kurz, Y, X, string(Value)]);
//   if (Value = Null) or (Value = '') then
//     Book.ActiveSheet.Cells[Y, X].Value := '''''' else
    Book.ActiveSheet.Cells[Y, X].Value := Value;
end;

function TXlsKmp.CellIsEmpty(Y, X: integer): boolean;
begin
  Result := Cells[Y, X] = '';  //property, GetCells
end;

function TXlsKmp.RangeIsEmpty(Y0, X0, Y1, X1: integer): boolean;
var
  Y, X: integer;
begin
  Result := true;
  for X := X0 to X1 do
    for Y := Y0 to Y1 do
      if not CellIsEmpty(Y, X) then
      begin
        Result := false;
        Exit;
      end;
end;



function TXlsKmp.GetWorkSheets: TStrings;
var
  I: integer;
begin
  if not Active then
    EError('%s not Active (GetWorkSheets)', [Kurz]);
  if FWorkSheets = nil then
  begin
    FWorkSheets := TStringList.Create;
    for I := 1 to Book.Sheets.Count do
      FWorkSheets.Add(Book.Sheets[I].Name);
  end;
  Result := FWorkSheets;
end;

procedure TXlsKmp.Open(CreateNew: boolean);
var
  XlsFilename: String;
begin
  if Active then
  begin
    // Prot0('%s is Active (%s)', [Kurz, 'Open']);
  end else
  begin
  end;
  FreeAndNil(FWorkSheets);
  if ExtractFileExt(WorkFile) <> '' then
    XlsFileName := WorkFile else
    XlsFileName := WorkFile + '.xls';
  //warum? XlsFileName := ExpandFileName(XlsFileName);  //bzgl. aktuellem Verzeichnis absolut machen
  if FileExists(XlsFileName) then
  begin
    ProtL('%s Open %s', [Kurz, XlsFileName]);
    FXls.Open(XlsFileName, '', false, false);  //Sheet, aVisible, CreateNew. Exc bei fehler
    FActive := true;
    LoadedWorkSheet := Book.ActiveSheet.Name;
    SetWorkSheet(WorkSheet);
  end else
  if not CreateNew then
  begin
    EError('%s Open failed because file unknown (%s)', [Kurz, WorkFile]);
  end else
  begin  //not FileExists and CreateNew
    ProtL('%s Create %s', [Kurz, XlsFilename]);
    if WorkSheet <> '' then
    begin
      LoadedWorkSheet := WorkSheet;
      SetWorkSheet(WorkSheet);
      Active := true;
    end;
  end;
end;

procedure TXlsKmp.Close;
begin
  if not Active then
  begin
    // Prot0('%s not Active (%s)', [Kurz, 'Close']);
  end else
  begin
    FActive := false;
    FXls.Excel.ActiveWorkBook.Saved := True;
    FXls.Excel.Workbooks.Close;
    Application.ProcessMessages;
  end;
end;

procedure TXlsKmp.Show;
begin
  //ShellExecAndWait(WorkFile);
  FXls.Excel.Visible := true;
end;

procedure TXlsKmp.Print;
begin
  { Excel öffnen zum drucken }
  //ShellExecOp(WorkFile, 0, 'Print', false);
  FXls.Excel.PrintOut();
end;

function TXlsKmp.GetActive: boolean;
begin
  Result := FActive;
end;

procedure TXlsKmp.SetActive(const Value: boolean);
begin
  if Active <> Value then
  begin
    if Value then
      Open(false) else
      Close;
  end;
end;

procedure TXlsKmp.SetWorkSheet(const Value: string);
// wenn geschlossen dann nur Wert setzen
// wenn geöffnet dann sofort wechseln
//   wenn fehlt dann anlegen
var
  I: integer;
  Done: boolean;
begin
  ActiveSheetCached := false;
  if not Active then
  begin
    FWorkSheet := Value;
  end else
  if (Value <> '') and (Book.ActiveSheet.Name <> Value) then
  begin
    if FWorkSheet <> Value then
      ProtL('%s SetWorkSheet(%s)', [Kurz, Value]);
    Done := false;
    for I := 1 to Book.Sheets.Count do  //ab 1!
    begin
      if Book.Sheets[I].Name = Value then
      begin
        Done := true;
        Book.Sheets[I].Activate;
        break;
      end;
    end;
    if not Done then
    begin
      SMess('Adding Worksheet %s', [Value]);
      Book.Sheets.Add.Activate;
      Book.ActiveSheet.Name := Value;
    end;
    FWorkSheet := Value;
  end;
  FreeAndNil(FWorkSheets);
end;

procedure TXlsKmp.InternalSaveAs(aFilename: string);
begin
  if FWorkFile = aFilename then
  begin
    FXls.Excel.ActiveWorkBook.Save;
  end else
    FXls.Excel.ActiveWorkBook.SaveAs(FileName := aFilename,
      ReadOnlyRecommended := False, CreateBackup := False,
      ConflictResolution := xlLocalSessionChanges);
  //http://msdn.microsoft.com/en-us/library/bb214129%28office.12%29.aspx
  Application.ProcessMessages;
end;

procedure TXlsKmp.Save;
begin
  ProtL('%s Save %s', [Kurz, WorkFile]);
  InternalSaveAs(WorkFile);
end;

procedure TXlsKmp.SaveAs(Filename: string);
begin
  ProtL('%s SaveAs(%s)', [Kurz, Filename]);
  InternalSaveAs(Filename);
end;

procedure TXlsKmp.SetWorkFile(const Value: string);
begin
  if FWorkFile <> Value then
  begin
    ActiveSheetCached := false;
    if Active then
      ProtL('%s SetWorkFile(%s)', [Kurz, Value]);
    FWorkFile := Value;
    Close;
    FreeAndNil(FWorkSheets);
  end;
end;

procedure TXlsKmp.DeleteConnections(aName: string);
//löscht Connection mit Name. * oder '' = löscht alle Connections
var
  N: integer;
begin
  N := FXls.Excel.ActiveWorkBook.Connections.Count;
  if N = 0 then
    Exit;
  if (aName = '') or (aName = '*') then
  begin
    while N > 0 do
    begin
      FXls.Excel.ActiveWorkbook.Connections.Item(1).Delete;
      N := FXls.Excel.ActiveWorkBook.Connections.Count;
    end;
  end else
  begin
    FXls.Excel.ActiveWorkBook.Connections(aName).Delete;
  end;
end;

end.
