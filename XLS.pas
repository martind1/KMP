unit Xls;
(* Modul zur einfachen Handhabung von Excel per OLE
   - für Import-Module
   23.08.04 MD  WideString
   23.05.05 MD  KillExcel: wenn true (=Standard) wird beim beenden auch
                der Excelprozess beendet (mit KillProcess)
   26.02.12 md  D2010 string ist jetzt WideString. WideString-Fkts entfernt
*)
interface

uses
  Classes, Grids, db {, Excel_TLB};
// c:\Program Files (x86)\Embarcadero\RAD Studio\9.0\OCX\Servers\pas2010\Excel2010.pas

const
  //von Excel_TLB.pas
  xlTypePDF = $00000000;
  xlQualityStandard = $00000000;
  xlMinimized = $FFFFEFD4;
  xlNormal = $FFFFEFD1;
  xlDoNotSaveChanges = $00000002;
  xlSaveChanges = $00000001;
  // Konstanten für enum XlSaveConflictResolution
  xlLocalSessionChanges = $00000002;
  xlOtherSessionChanges = $00000003;
  xlUserResolution = $00000001;
  //für Selecten zu färben:
  xlSolid = $00000001;
  xlAutomatic = $FFFFEFF7;
  xlThemeColorDark1 = $00000001;

  //für Selection.Borders(xlInsideHorizontal)
  xlInsideHorizontal = $0000000C;
  xlInsideVertical = $0000000B;
  xlDiagonalDown = $00000005;
  xlDiagonalUp = $00000006;
  xlEdgeBottom = $00000009;
  xlEdgeLeft = $00000007;
  xlEdgeRight = $0000000A;
  xlEdgeTop = $00000008;

  //HorizontalAlignment, VerticalAlignment, ReadingOrder
  xlGeneral = $00000001;
  xlTop = $FFFFEFC0;
  xlContext = $FFFFEC76;



type
  TXls = class(TObject)
  private
  public
    Excel: Variant;   {Excel}
    XlsFileName, XlsSheet: string;
    Created: boolean;
    KillExcel: boolean;

    constructor Create;
    destructor Destroy; override;
    procedure Sheets(XlsName: string; L: TStrings);
    function SetSheet(aSheet: string): boolean;
    procedure Open(aFileName, aSheet: string; aVisible, CreateNew: boolean);
    procedure Close(Save: boolean = false);
    function EStr(S: string): string;
    //function WideEStr(S: WideString): WideString;
    function VariantOf(S: string): OleVariant; overload;
    function VariantOf(F: TField): OleVariant; overload;
    function XToA(X: integer): string;
    function ToX(S: string): integer;
    class procedure ForceQuit;
  end;

implementation

uses
  Math, Variants,
  ComObj, SysUtils, StdCtrls, Forms, nstr_Kmp, GNav_Kmp,
  Prots, Err__Kmp, DPos_Kmp, WinTools;

constructor TXls.Create;
begin
  ProtL('Aktiviere Excel', [0]);
  Created := false;
  try
    Excel := GetActiveOleObject('Excel.Application');
  except
    ProtL('Lade Excel', [0]);
    Excel := CreateOleObject('Excel.Application');
    Created := true;
  end;
  KillExcel := true;
end;

destructor TXls.Destroy;
begin
  Excel := Unassigned; //null;
  if KillExcel then
  try
    //KillProcess(GetProcessID('EXCEL.EXE'));
    KillProcessName('EXCEL.EXE');
  except on E:Exception do
    Debug0;
  end;
  inherited;
end;

function TXls.EStr(S: string): string;
begin {echte Leerzellen in Excel. Multilines mit $0A trennen}
  if S = '' then
    result := '''' else            {damit leer in Excel}
  if not BeginsWith(S, '''') then
    result := '''' + S else        //ELP
    result := S;
  result := StringReplace(result, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
end;

//function TXls.WideEStr(S: WideString): WideString;
//begin
//  if S = '' then
//    result := WideChar('''') else            {damit leer in Excel}
//    result := StringReplace(S, CRLF, LF, [rfReplaceAll, rfIgnoreCase]);
//end;

function TXls.VariantOf(S: string): OleVariant;
var
  S1: string;
begin
  S1 := Trim(S);
  if S1 <> '' then
  try
    if IsFloatStr(S1) then
    try
      result := StrToFloat(S1);
    except
      result := EStr(S1);
    end else
    if IsDateStr(S1) then
    try
      result := StrToDate(S1);
    except
      result := EStr(S1);
    end else
      result := EStr(S1);
  except
    result := EStr(S1);
  end else
    result := '''';            {bestehenden Wert mit Leerwert überschreiben}
end;

function TXls.VariantOf(F: TField): OleVariant;
begin
  if F.IsNull then
    result := EStr('') else
  if F is TNumericField then
    result := F.AsFloat else
  if F is TDateTimeField then
    result := F.AsDateTime else
  if F is TBlobField then
    result := EStr(F.AsString) else
    result := EStr(F.Text);
//  weg 07.12.09
//  if F.Tag <> 0 then
//    result := EStr(F.Text) else
//    result := EStr(F.AsString);
end;
(*
  if F is TDateTimeField then
  begin
    result := Floor(F.AsDateTime);                //DateTime gibt ole Fehler
    //result := aDate;                //DateTime gibt ole Fehler
  end else
*)
function TXls.XToA(X: integer): string;
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

function TXls.ToX(S: string): integer;
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

procedure TXls.Sheets(XlsName: string; L: TStrings);
{ergänzt L mit den Arbeitsmappen}
var
  I: integer;
begin
  try
    try
      ProtL('XLS Open %s', [XLSName]);
      Excel.Workbooks.Open(FileName := XLSName);
      for I := 1 to Excel.Sheets.Count do
        L.Add(Excel.Sheets[I].Name);
    finally
      Excel.ActiveWorkBook.Saved := True;   // ... verhindert unliebsame Dialoge
      Excel.Workbooks.Close;
      ProtL('XLS Close Excel', [0]);
    end;
  except on E:Exception do
    EProt(self, E, 'Excel', [0]);
  end;
  SMess0;
end;

function TXls.SetSheet(aSheet: string): boolean;
begin
  XlsSheet := aSheet;
  try
    ProtL('XLS Set Sheet %s', [aSheet]);
    Excel.Sheets.Item[aSheet].Activate;  //10.02.14 Problem. Item dazu. Sheets statt Worksheets.
    Result := true;
  except
    ProtL('XLS Adding sheet %s', [aSheet]);
    Excel.Sheets.Add;
    Excel.ActiveSheet.Name := aSheet;
    Result := true;
  end;
end;

procedure TXls.Open(aFileName, aSheet: string; aVisible, CreateNew: boolean);
begin
  try
    if ExtractFileExt(aFileName) <> '' then
      XlsFileName := aFileName else
      XlsFileName := aFileName + '.xls';
    XlsFileName := ExpandFileName(XlsFileName);

    Excel.Visible := aVisible;   { für Preview und testphase sinnvoll }
    if FileExists(XlsFileName) or not CreateNew then
    begin
      ProtL('XLS Open %s', [XlsFileName]);
      Excel.Workbooks.Open(FileName := XlsFileName);
    end else
    begin
      ProtL('XLS Create %s', [XlsFileName]);
      Excel.Workbooks.Add;
      Excel.ActiveWorkBook.SaveAs(FileName := XlsFileName, //FileFormat := -4143,
        ReadOnlyRecommended := False, CreateBackup := False);
    end;
    if aSheet <> '' then
    begin
      SetSheet(aSheet);
    end;
    {hier: Daten exp/imp}
  except on E:Exception do
    EError('XLS.Open(%s,%s):%s', [aFileName, aSheet, E.Message]);
  end;
end;

procedure TXls.Close(Save: boolean = false);
begin
  if Save then
    Excel.ActiveWorkBook.Save else
    Excel.ActiveWorkBook.Saved := True;
  Excel.Workbooks.Close;
  //Excel.Visible := false;
  Excel.Quit;
  Application.ProcessMessages;  {!!!}
  Excel := Unassigned; //null;
end;

class procedure TXls.ForceQuit;
//Excel im Taskmanager beenden
begin
  KillProcessName('EXCEL.EXE');
end;

end.
