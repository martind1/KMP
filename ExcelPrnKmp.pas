unit ExcelPrnKmp;
(* Excel Druck Komponente (statt PrnSource zu verwenden)
   Autor: Martin Dambach
   Letzte Änderung:
   03.12.09 MD     Erstellen
   20.12.09 MD  Mehrere Terme mit '|' trennen in ExcelFields
   ---------------------------------------------------------
   In Excel gibt es keine Formularfelder
   Es wird nur die Umsetzungsliste (ExcelFields) durchlaufen
   ExcelFields hat den Aufbauf Cell=Field (zB AB12=KundNr)

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db,
  Psrc_kmp, WordPrnKmp {Event}, Xls;

type
  TExcelOption = (eoPrintPreview,      //Preview: gleich auf Seitenansicht. Dflt=true
                 eoSaveChanges,      //Änderungen speichern
                 eoUseDefault,       //Wenn Ersetzung fehlt dann Standardwert von Vorlage nehmen
                 eoPdfExport);       //Export nach PDF (ab Office 2007)
  TExcelOptions = set of TExcelOption;

type
  TExcelPrn = class(TPrnSource)
  private
    FOnDefineField: TDefineFieldEvent;
    FExcelFields: TStrings;
    FDataSource: TDataSource;
    FExcelOptions: TExcelOptions;
    FXls: TXls;
    FSheet: string;
    procedure SetExcelFields(const Value: TStrings);
    procedure PrintExcel(Designer, OnlyExport: boolean; ExpFilename: string);
    function DoOnDefineField(var FieldName, FieldValue: string): boolean;
    procedure SetSheet(const Value: string);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    PrinterIndex: integer;
    procedure ExportTo(Filename: string);
  public
    { Public-Deklarationen }
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoRun; override;     {Startet Dlg. Falls von LNav.DoPrn}
    procedure PrintDesign;  // Formular mit Feldnamen statt Werten drucken
    function Xls: TXls;
    class procedure ForceQuit;
    class function ExcelIsRunning: boolean; static;
    class function CloseExcelDlg: boolean; static;
  published
    { Published-Deklarationen }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property ExcelFields: TStrings read FExcelFields write SetExcelFields;
    property ExcelOptions: TExcelOptions read FExcelOptions write FExcelOptions;
    property Sheet: string read FSheet write SetSheet;
    property OnDefineField: TDefineFieldEvent read FOnDefineField write FOnDefineField;
  end;

implementation

uses
  ComObj, {Excel_TLB,} OleServer, Printers, WinTools {ProcessId},
  Err__Kmp, Prots, KmpResString, StopWatch;

{ TExcelPrn }

constructor TExcelPrn.Create(AOwner: TComponent);
begin
  inherited;
  FExcelFields := TStringList.create;
  FExcelOptions := [eoPrintPreview];
end;

destructor TExcelPrn.Destroy;
begin
  FreeAndNil(FExcelFields);
  FreeAndNil(fXls);
  inherited;
end;

function TExcelPrn.Xls: TXls;
begin
  if fXls = nil then
    fXls := TXls.Create;
  Result := fXls;
end;

procedure TExcelPrn.SetSheet(const Value: string);
begin
  if FSheet <> Value then
  begin
    FSheet := Value;
    if fXls <> nil then
      fXls.SetSheet(Value);
  end;
end;

procedure TExcelPrn.SetExcelFields(const Value: TStrings);
begin
  FExcelFields.Assign(Value);
end;

procedure TExcelPrn.DoRun;
var
  Fertig: boolean;
  PrinterFont: string;
begin
  Fertig := false;
  if assigned(FBeforePrn) then
  try
    FBeforePrn(self, Fertig);
  except on E:Exception do
    begin
      Fertig := true;
      EProt(self, E, 'Error at BeforePrn', [0]); //Fehlermaske nicht 2mal anzeigen 09.06.03 SDBL
      if psRaiseError in Options then
        raise;                                      {wichtig!  HLW.AuFa.PSGrosset}
    end;
  end;
  if not Fertig then
  try
    Screen.Cursor := crHourglass;
    IncPrintCount(1);
    Printing := true;
    if (QRepKurz <> '') then
    begin
      if ExportFile then
      begin
        ExportTo(ExportFilename);
      end else
      begin
        if not Preview then
        begin
          PrinterIndex := SysParam.GetPrinterIndex(DruckerTyp, PrinterFont);    {N}
        end;
        PrintExcel(false, false, '');  //kein Designer
      end;
    end else
    begin
      ErrWarn(SPsrc_Kmp_010, [0]);	// 'PrnSource:Quickreport ist nicht angegeben'
    end;


    Printing := false;  //für Ereignis
    if assigned(FAfterPrn) then
      FAfterPrn(self);            {Aufruf hier nur wenn erfolgreich gedruckt}
  finally
    Screen.Cursor := crDefault;
    IncPrintCount(-1);
    Printing := false;
    if assigned(FOnFinished) then
      FOnFinished(self);            {Aufruf hier immer wenn not Fertig (von FBeforePrn) }
  end;
end;

procedure TExcelPrn.PrintDesign;
// Formular mit Feldnamen statt Werten drucken
begin
  PrintExcel(true, false, '');  //Designer
end;

procedure TExcelPrn.ExportTo(Filename: string);
begin
  PrintExcel(false, true, Filename);  //kein Designer, OnlyExport
end;

function TExcelPrn.DoOnDefineField(var FieldName, FieldValue: string): boolean;
// Ereignis aufrufen.
// Ergibt true wenn bereits verarbeitet in FieldValue der auszufgebende Text steht.
begin
  Result := false;
  if Assigned(FOnDefineField) then
    FOnDefineField(self, FieldName, FieldValue, Result);
end;

procedure TExcelPrn.PrintExcel(Designer, OnlyExport: boolean; ExpFilename: string);
// Druckroutine mit Export, Designer=Feldnamen ausgeben

  function GetValue(FieldName: string; Default: OleVariant; ForceString: boolean): OleVariant;
  //unser Feldname wird entweder über die Umsetzungsliste <ExcelFields> oder
  //  direkt im Exceldokument angegeben
  var
    P, N: integer;
    AField: TField;
    AList: TStringList;
    StrResult: string;  //wg Word
  begin
    if Designer then
    begin
      Result := FieldName;
      Exit;
    end;
    StrResult := Default;  //war ''
    try
      { Konstanten idF 'mytext' verarbeiten: Apostrophe weg }
      if BeginsWith(FieldName, '''') then
      begin
        if EndsWith(FieldName, '''') then
          Result := copy(FieldName, 2, Length(FieldName) - 2) else
          Result := copy(FieldName, 2, MaxInt);
      end else
      if DoOnDefineField(FieldName, StrResult) then
      begin
        if ForceString then
          Result := StrResult else
          Result := Xls.VariantOf(StrResult);
      end else
      begin
        if (DataSource = nil) or (DataSource.DataSet = nil) then
          EError('%s.DataSource=nil', [OwnerDotName(self)]);
        // <Feldname>.<n> druckt nur Zeile n eines mehrzeiligen Feldes.
        P := Pos('.', FieldName);
        if P > 0 then
        begin
          AList := TStringList.Create;
          try
            N := StrToInt(copy(FieldName, P + 1, MaxInt));    //ab 1
            FieldName := copy(FieldName, 1, P - 1);
            AField := DataSource.DataSet.FieldByName(FieldName);
            GetFieldStrings(AField, AList);
            if AList.Count >= N then
              result := Xls.EStr(AList[N - 1]) else     //ab 0
              result := Xls.EStr('');
          finally
            AList.Free;
          end;
        end else
        begin
          //result := DataSource.DataSet.FieldByName(FieldName).AsString;
          if FieldName <> '' then
          begin
            AField := DataSource.DataSet.FieldByName(FieldName);
            Result := Xls.VariantOf(AField);
          end;
        end;
      end;
    except on E:Exception do begin
        EProt(self, E, 'PrintExcel(%s)', [FieldName]);
        result := '?';  // Excel nicht verunstalten
      end;
    end;
  end;

var
  AValue, DefaultValue: OleVariant;
  X: Variant;
  FN: string;
  I: integer;
  S, FFName: string;
  S1, S2, S3, NextS1: string;
  P1: integer;
  XlsCol, XlsRow, I1: integer;
begin { PrintExcel }
  I := 0;
  FFName := '';
  SW[0].Reset;
  try
    FN := QRepKurz;
    if Pos('\', FN) = 0 then
    begin
      S := FN;
      FN := AppDir + 'Excel\' + S;
      if not FileExists(FN) then
        FN := AppDir + S;
    end;
    if not FileExists(FN) then
      EError('Excel-Vorlage (%s) nicht gefunden', [FN]);
    ProtL('%s Lade Excel mit %s', [OwnerDotName(self), FN]);
    Xls.Open(FN, Sheet, false, false);
    X := Xls.Excel;

    Application.ProcessMessages;
    try
      //muss rückwärts laufen wg .delete - for I := 1 to X.ActiveWorkBook.FormFields.Count do
      for I := 0 to ExcelFields.Count - 1 do
      begin
        S1 := StrParam(ExcelFields[I]);  //AB12
        if (Trim(S1) = '') or BeginsWith(S1, ';') then  //';' ist Kommentar
          Continue;
        S2 := '';
        S3 := '';
        I1 := 1;
        try
          while (I1 <= Length(S1)) do
          begin
            if IsAlpha(S1[I1]) then
              S2 := S2 + S1[I1] else     //<AB>12
              S3 := S3 + S1[I1];         //AB<12>
            Inc(I1);
          end;
          XlsCol := Xls.ToX(S2);
          XlsRow := StrToInt(S3);
        except on E:Exception do
          XlsCol := 0;  //Warnung generieren. Kein Abbruch
        end;
        if (XlsCol <= 0) or (XlsRow <= 0) then
        begin
          Prot0('%s WARN Syntax Line(%s)', [OwnerDotName(self), ExcelFields[I]]);
          Continue; 
        end;

        FFName := Trim(StrValue(ExcelFields[I]));  //Leerzeichen hinten entfernen
        DefaultValue := X.Cells[XlsRow, XlsCol];
        if Pos('|', FFName) > 0 then
        begin
          S2 := '';
          S1 := PStrTok(FFName, '|', NextS1);
          while S1 <> '' do
          begin
            P1 := Pos('/', S1);  // wird zu StrDflt aufgelöst
            if not BeginsWith(S1, '''') and (P1 > 1) then
            begin
              S3 := GetValue(Copy(S1, 1, P1 - 1), DefaultValue, true);
              if S3 = '' then
                S3 := GetValue(Copy(S1, P1 + 1, Maxint), DefaultValue, true);
            end else
              S3 := GetValue(S1, DefaultValue, true);
            S2 := S2 + StrCgeChar(S3, '''', #0);  // '' von EStr eliminieren
            S1 := PStrTok('', '|', NextS1);
          end;
          AValue := Xls.EStr(S2);
        end else
          AValue := GetValue(FFName, DefaultValue, false);
        if SysParam.ProtBeforeOpen then
          ProtLA('%s=%s', [FFName, AValue]) else
          SMess('%s=%s', [FFName, AValue]);

        S1 := StrDflt(AValue, '''');
        S2 := StrDflt(DefaultValue, '''');
        if S1 = S2 then  //gibt OLE-Fehler wenn Default=nil - AValue = DefaultValue then
        begin
          //Optimierung: wenn keine Änderung dann nichts zurückschreiben
        end else
        begin
          if (S1 = '') and (eoUseDefault in ExcelOptions) then
          begin
            // Vorgabe setzen
            AValue := DefaultValue;  //X.ActiveWorkBook.FormFields.Item(I).TextInput.Default;
          end;
          SW[0].Start;
          X.Cells[XlsRow, XlsCol] := aValue;
          if SysParam.ProtBeforeOpen then
            ProtLA('X.Cells[%d,%d] := %s', [XlsRow, XlsCol, AValue]);
          SW[0].Stop;
        end;
        Application.ProcessMessages;
      end;
    finally
    end;
    SW.Prot;
    I := 0;
    ProtL('Drucke %s', [FN]);
    Application.ProcessMessages;  //13.07.09
    if OnlyExport and (eoPdfExport in ExcelOptions) then
    begin
      { ActiveSheet.ExportAsFixedFormat Type:=xlTypePDF, Filename:= _
            "D:\temp\Test_Allonge.pdf", Quality:=xlQualityStandard, IncludeDocProperties _
            :=True, IgnorePrintAreas:=False, OpenAfterPublish:=False }
      X.ActiveSheet.ExportAsFixedFormat(Type := xlTypePDF,
        Filename := ExpFilename, Quality := xlQualityStandard,
        IncludeDocProperties := True, IgnorePrintAreas := False,
        OpenAfterPublish := False);
    end else
    if OnlyExport then
    begin
      //only Export
      ProtL('%s Speichern nach %s', [OwnerDotName(self), ExpFilename]);
      X.ActiveWorkBook.SaveAs(FileName := ExpFilename,
        ReadOnlyRecommended := False, CreateBackup := False);
      Application.ProcessMessages;

      //X.ActiveWorkBook.Saved := True;
      ProtL('Schließe Excel', [0]);
      X.ActiveWorkBook.Close(False);
    end else
    begin
      if eoSaveChanges in ExcelOptions then
      begin
        ProtL('Speichere %s', [FN]);
        X.ActiveWorkBook.Save;
      end;

      if Preview then
      begin
        X.Visible := true;
        if X.WindowState = xlMinimized then
          X.WindowState := xlNormal;
        // In Excel auf die Seitenansicht gehen und warten bis beendet. Nein! webab
        if eoPrintPreview in ExcelOptions then
        begin
         X.ActiveWorkBook.PrintPreview(false);
        end;
      end else
      begin
        if PrinterIndex >= 0 then  //nicht bei Standarddrucker
        begin
//          ProtL('Aktiviere Drucker %s', [Printer.Printers[PrinterIndex]]);
//          X.ActivePrinter := Printer.Printers[PrinterIndex];  //09.08.08
//          Application.ProcessMessages;  //13.07.09
          ProtL('Ausdruck auf %s', [Printer.Printers[PrinterIndex]]);
          X.ActiveWorkBook.PrintOut(ActivePrinter := Printer.Printers[PrinterIndex]);
        end else
        begin
          ProtL('Ausdruck', [0]);
          X.ActiveWorkBook.PrintOut;
        end;
        Application.ProcessMessages;

        X.ActiveWorkBook.Saved := True;
        ProtL('Schließe Excel', [0]);
        X.ActiveWorkBook.Close(false);
        X.Visible := false;
        //Application.ProcessMessages;
        //X.Quit(SaveChanges);    //?(bricht Druck ab falls PrintBackgrounf)
      end;
    end;
    SMess0;
  except on E:Exception do
    begin
      //X.Visible := true;   //nicht vor Ort
      EMess(self, E, 'Excel%d(%s):', [I, FFName]);
    end;
  end;
end;

class procedure TExcelPrn.ForceQuit;
begin
  KillProcessName('EXCEL.EXE');
end;

class function TExcelPrn.ExcelIsRunning: boolean;
begin
  Result := GetProcessID('EXCEL.EXE') > 0;
end;

class function TExcelPrn.CloseExcelDlg: boolean;
begin
  if ExcelIsRunning then
  begin
    if mrYes = WMessYesNo(ExcelPrn_001, [0]) then  //'Excel beenden?'
      ForceQuit;
  end;
  Result := ExcelIsRunning;
end;

end.
