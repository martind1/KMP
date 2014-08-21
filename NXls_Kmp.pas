unit NXls_Kmp;
(* Native Excel Komponente für komfortablen Zugriff
19.08.08 md  erstellt
20.08.08 md  [Y, X] Parameterfolge durchgehend
16.02.12 md  ToX, XToA (von xls)
*)
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  nExcel;

type
  TNXlsKmp = class(TComponent)
  private
    FVisible: boolean;
    FWorkSheet: string;
    FWorkFile: string;
    FWorkSheets: TStringList;  //Liste der Blätter
    FBook: IXLSWorkbook;
    FNowait: boolean;
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
    function GetBook: IXLSWorkbook;
    function GetSheet: IXLSWorksheet;
    procedure InternalSaveAs(aFilename: string);
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
    property Book: IXLSWorkbook read GetBook;
    property Sheet: IXLSWorksheet read GetSheet;
    function CellIsEmpty(Y, X: integer): boolean;
    function RangeIsEmpty(Y0, X0, Y1, X1: integer): boolean;
    function ToX(S: string): integer;
    function XToA(X: integer): string;
  published
    property WorkFile: string read FWorkFile write SetWorkFile;
    property WorkSheet: string read FWorkSheet write SetWorkSheet;
    property Visible: boolean read FVisible write FVisible;  //Excel starten nach Close
    property Nowait: boolean read FNowait write FNowait;  //nicht warten auf Excel
  end;

implementation

uses
  Prots, Err__Kmp, Qwf_Form, Variants;

{ TNXlsKmp }

function TNXlsKmp.Kurz: string;
begin
  {if (Owner <> nil) and (Owner is TqForm) then
    Result := TqForm(Owner).Kurz else }
    Result := OwnerDotName(self);
end;

function TNXlsKmp.EStr(S: string): string;
begin {echte Leerzellen in Excel. Multilines mit $0A trennen}
  if S = '' then
    result := '''' else            {damit leer in Excel}
    result := S;
  result := StringReplace(result, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
end;

constructor TNXlsKmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TNXlsKmp.Destroy;
begin
  FreeAndNil(FWorkSheets);
  FBook := nil;  //Interface (IXLSWorkbook) wird automatisch freigegeben
  inherited;
end;

function TNXlsKmp.GetBook: IXLSWorkbook;
begin
  if not Active then
    EError('%s not Active (GetBook)', [Kurz]);
  Result := FBook;
end;

function TNXlsKmp.GetSheet: IXLSWorksheet;
begin
  if not Active then
    EError('%s not Active (GetSheet)', [Kurz]);
  Result := FBook.ActiveSheet;
end;

function TNXlsKmp.GetCells(Y, X: Integer): String;
// var
//   V: Variant;
begin
  if not Active then
    EError('%s not Active (GetCells(%d,%d)', [Kurz, Y, X]);
  Result := VarToStr(FBook.ActiveSheet.Cells[Y, X].Value);  //'' bei null
//   V := FBook.ActiveSheet.Cells[Y, X].Value;
//   if V = null then
//     Result := '' else
//     Result := V;
end;

function TNXlsKmp.GetCellsVariant(Y, X: Integer): Variant;
begin
  if not Active then
    EError('%s not Active (GetCells(%d,%d)', [Kurz, Y, X]);
  Result := FBook.ActiveSheet.Cells[Y, X].Value;
end;

procedure TNXlsKmp.SetCells(Y, X: Integer; const Value: String);
begin
  if not Active then
    EError('%s not Active (SetCells(%d,%d,%s)', [Kurz, Y, X, Value]);
  FBook.ActiveSheet.Cells[Y, X].Value := EStr(Value);
end;

procedure TNXlsKmp.SetCellsVariant(Y, X: Integer; const Value: Variant);
begin
  if not Active then
    EError('%s not Active (SetCells(%d,%d,%s)', [Kurz, Y, X, string(Value)]);
//   if (Value = Null) or (Value = '') then
//     FBook.ActiveSheet.Cells[Y, X].Value := '''''' else
    FBook.ActiveSheet.Cells[Y, X].Value := Value;
end;

function TNXlsKmp.CellIsEmpty(Y, X: integer): boolean;
begin
  Result := Cells[Y, X] = '';
end;

function TNXlsKmp.RangeIsEmpty(Y0, X0, Y1, X1: integer): boolean;
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

function TNXlsKmp.XToA(X: integer): string;
// Spalte nach Buchstabe. X kann alle positiven Werte bis über 65000 annehmen.
  function X1toC(X1: integer): Char;
  begin
    result := Chr(Ord('A') + X1);  // - 1
  end;
var
  X1: integer;
begin
  Result := '';
  while X > 0 do
  begin
    X := X - 1;
    X1 := X mod 26;
    Result := X1toC(X1) + Result;
    X := X div 26;
  end;
end;

function TNXlsKmp.ToX(S: string): integer;
//ergibt Spaltennummer anhand Nummer oder Buchstaben A..ZZZ oder a..zzz.
  function CtoX(C: Char): integer;
  var
    InnerResult: 1..26;
  begin
    Result := 0;
    try
      //if UpperCase(C) in ['A'..'Z'] then
      InnerResult := Ord(UpCase(C)) - ord('A') + 1;  //mit Bereichsüberprüfung
      Result := InnerResult;
    except on E:Exception do
      EError('TXls.ToX(%s): %s', [S, E.Message]);
    end;
  end;
var
  I: integer;
begin
  Result := 0;
  if Length(S) = 0 then
    Exit;
  if CharInSet(S[1], ['0'..'9']) then
    Result := StrToInt(S)
  else
    for I := 1 to length(S) do
      Result := Result + IPower(26, I-1) * CtoX(S[Length(S) - I + 1]);
end;

function TNXlsKmp.GetWorkSheets: TStrings;
var
  I: integer;
begin
  if not Active then
    EError('%s not Active (GetWorkSheets)', [Kurz]);
  if FWorkSheets = nil then
  begin
    FWorkSheets := TStringList.Create;
    for I := 1 to FBook.Sheets.Count do
      FWorkSheets.Add(FBook.Sheets[I].Name);
  end;
  Result := FWorkSheets;
end;

procedure TNXlsKmp.Open(CreateNew: boolean);
var
  XlsFilename: String;
  Ret, Err: integer;
begin
  if Active then
  begin
    // Prot0('%s is Active (%s)', [Kurz, 'Open']);
  end else
  begin
    FBook := TXLSWorkbook.Create;
  end;
  FreeAndNil(FWorkSheets);
  if ExtractFileExt(WorkFile) <> '' then
    XlsFileName := WorkFile else
    XlsFileName := WorkFile + '.xls';
  //warum? XlsFileName := ExpandFileName(XlsFileName);  //bzgl. aktuellem Verzeichnis absolut machen
  if FileExists(XlsFileName) then
  begin
    ProtL('%s Open %s', [Kurz, XlsFileName]);
    Ret := FBook.Open(XlsFilename);
    if Ret <> 1 then
    begin
      Err := GetLastError;
      EError('Fehler %d beim Öffnen von %s' + CRLF + '%d(%s)', [
             Ret, XlsFilename, Err, SysErrorMessage(Err)]);
    end;
    LoadedWorkSheet := FBook.ActiveSheet.Name;
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
    end;
  end;
end;

procedure TNXlsKmp.Close;
begin
  if not Active then
  begin
    // Prot0('%s not Active (%s)', [Kurz, 'Close']);
  end else
  begin
    FBook := nil;  //Interface (IXLSWorkbook) wird dann automatisch freigegeben
    Application.ProcessMessages;
  end;
  if Visible then
    Show;  //in MSExcel oder ExcelViewer
end;

procedure TNXlsKmp.Show;
begin
  if Nowait then
    ShellExecNoWait(WorkFile) else
    ShellExecAndWait(WorkFile);
end;

procedure TNXlsKmp.Print;
begin
  { Excel öffnen zum drucken }
  ShellExecOp(WorkFile, 0, 'Print', false);
end;

function TNXlsKmp.GetActive: boolean;
begin
  Result := Assigned(FBook);
end;

procedure TNXlsKmp.SetActive(const Value: boolean);
begin
  if Active <> Value then
  begin
    if Value then
      Open(false) else
      Close;
  end;
end;

procedure TNXlsKmp.SetWorkSheet(const Value: string);
// wenn geschlossen dann nur Wert setzen
// wenn geöffnet dann sofort wechseln
//   wenn fehlt dann anlegen
var
  I: integer;
  Done: boolean;
begin
  if not Active then
  begin
    FWorkSheet := Value;
  end else
  if (Value <> '') and
     ((FBook.Sheets.Count = 0) or (FBook.ActiveSheet.Name <> Value)) then
  begin
    if FWorkSheet <> Value then
      ProtL('%s SetWorkSheet(%s)', [Kurz, Value]);
    Done := false;
    for I := 1 to FBook.Sheets.Count do  //ab 1!
    begin
      if FBook.Sheets[I].Name = Value then
      begin
        Done := true;
        FBook.Sheets[I].Activate;
        break;
      end;
    end;
    if not Done then
    begin
      SMess('Adding Worksheet %s', [Value]);
      FBook.Sheets.Add.Activate;
      FBook.ActiveSheet.Name := Value;
    end;
    FWorkSheet := Value;
  end;
  FreeAndNil(FWorkSheets);
end;

procedure TNXlsKmp.InternalSaveAs(aFilename: string);
var
  aRet, Err: integer;
  Ext: string;
  FF: TXLSFileFormat;
begin
  Ext := ExtractFileExt(aFilename);
  FF := xlExcel97;
  if PosI('HTM', Ext) > 0 then
    FF := xlHTML
  else if PosI('RTF', Ext) > 0 then
    FF := xlRTF
  else if PosI('CSV', Ext) > 0 then
    FF := xlCSV
  else if PosI('TXT', Ext) > 0 then
    FF := xlText
  else if Length(Ext) > 4 then   //.xlsx
    FF := xlOpenXMLWorkbook;

  aRet := FBook.SaveAs(aFilename, FF);
  if aRet <> 1 then
  begin
    Err := GetLastError;
    EError('Fehler %d beim Speichern von %s' + CRLF + '%d(%s)', [
           aRet, aFilename, Err, SysErrorMessage(Err)]);
  end;
end;

procedure TNXlsKmp.Save;
begin
  ProtL('%s Save %s', [Kurz, WorkFile]);
  InternalSaveAs(WorkFile);
end;

procedure TNXlsKmp.SaveAs(Filename: string);
begin
  ProtL('%s SaveAs(%s)', [Kurz, Filename]);
  InternalSaveAs(Filename);
end;

procedure TNXlsKmp.SetWorkFile(const Value: string);
begin
  if FWorkFile <> Value then
  begin
    if Active then
      ProtL('%s SetWorkFile(%s)', [Kurz, Value]);
    FWorkFile := Value;
    Close;
    FreeAndNil(FWorkSheets);
  end;
end;

//d:\DelphiXE2\Kmp\DOC\resourcen\Farben.xls:
//  for I1 := 0 to 255 do
//  begin
//    //8 Spalten à 32
//    Xls.Cells[I1 mod 32 + 1, I1 div 32 + 1] := Format('Farbe %d', [I1]);
//    Xls.Sheet.Cells.Item[I1 mod 32 + 1, I1 div 32 + 1].Interior.ColorIndex := I1;
//  end;

end.
