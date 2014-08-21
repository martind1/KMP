unit WordPrnKmp;
(* Word Druck Komponente (statt PrnSource zu verwenden)
   Autor: Martin Dambach
   Letzte Änderung:
   02.08.08 MD     Erstellen
   09.08.08 MD     Übernimmt in PrnSource eingestellten Drucker
   16.04.09 MD     unabh von Word_TLB, Konstanten hierher kopiert.
   02.12.09 MD     der Vorgabewert wird in OnDefineField im Result übergeben
   02.12.09 MD     der Felder-Loop läuft von hinten nach vorne (wg .delete)
   01.10.10 MD     Wichtig: In Word muss "Felder vor dem Drucken aktualisieren" aus sein !!!
   11.05.11 md     WideString Unterstützung:Ereignis doonWideField

   Done:
   ExportTo(FN)
   BeforePrn, AfterPrn, PrnFinished

   ---------------------------------------------------------
    ActiveDocument.SendMail
    ---
    Sub Makro2() PDF als Email senden
    '
    ActiveDocument.ExportAsFixedFormat OutputFileName:= _
        "C:\DOKUME~1\MDambach\LOKALE~1\Temp\BV1001358_206_Auftragsschreiben.pdf", _
         ExportFormat:=wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
        wdExportOptimizeForPrint, Range:=wdExportAllDocument, From:=1, To:=1, _
        Item:=wdExportDocumentWithMarkup, IncludeDocProps:=False, KeepIRM:=True, _
        CreateBookmarks:=wdExportCreateNoBookmarks, DocStructureTags:=True, _
        BitmapMissingFonts:=True, UseISO19005_1:=False
   End Sub
   ---
   Sub Makro1() PDF erstellen
   '
       ChangeFileOpenDirectory "D:\temp\"
       ActiveDocument.ExportAsFixedFormat OutputFileName:="D:\temp\test.pdf", _
           ExportFormat:=wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
           wdExportOptimizeForPrint, Range:=wdExportAllDocument, From:=1, To:=1, _
           Item:=wdExportDocumentContent, IncludeDocProps:=True, KeepIRM:=True, _
           CreateBookmarks:=wdExportCreateNoBookmarks, DocStructureTags:=True, _
           BitmapMissingFonts:=True, UseISO19005_1:=False
   End Sub

   ------------------------------------
   Versuch mit TWordApplication: ist nicht schneller, aber umständlicher wg EmptyPar
   ------------------------------------

   Todo:
   WordRep Seriendruck


*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db,
  Psrc_kmp {, Word_TLB};
// c:\Program Files (x86)\Embarcadero\RAD Studio\9.0\OCX\Servers\pas2010\Word2010.pas

const  //von Word_TLB:
  wdDoNotSaveChanges = $00000000;
  wdSaveChanges = $FFFFFFFF;
  wdPromptToSaveChanges = $FFFFFFFE;
const
  wdWindowStateNormal = $00000000;
  wdWindowStateMaximize = $00000001;
  wdWindowStateMinimize = $00000002;

  wdFieldFormCheckBox = $00000047;

  wdGoToField = $00000007;
  wdGoToBookmark = $FFFFFFFF;  //für Quvae.HTTP

  //Office 2007 Version 12:
  wdExportFormatPDF = $00000011;
  wdExportOptimizeForPrint = $00000000;
  wdExportAllDocument = $00000000;
  wdExportDocumentContent = $00000000;
  wdExportCreateNoBookmarks = $00000000;

  //Shapes:
  wdStory = $00000006;
  wdLine = $00000005;
// Konstanten für enum MsoTriState
//type
//  MsoTriState = TOleEnum;

// Constants for enum WdFindWrap, QuvaE.HTTP
const
  wdFindContinue = $00000001;

// Constants for enum WdUnits
const
  wdCharacter = $00000001;  //10.02.14 QuvaE.HTTP

// Constants for enum WdRecoveryType
const
  wdChartLinked = $0000000F;  //10.02.14 QuvaE.HTTP



const
  msoTrue = $FFFFFFFF;
  msoFalse = $00000000;
  msoCTrue = $00000001;
  msoTriStateToggle = $FFFFFFFD;
  msoTriStateMixed = $FFFFFFFE;

// Russisch AKW Word Anfahrtskizze
const
  msoEncodingCyrillic = 1251; // (&H4E3)
  msoEncodingCyrillicAutoDetect = 51251;


type
  TDefineFieldEvent = procedure(Sender: TObject; var FieldName, FieldValue: string;
    var Handled: boolean) of Object;
  TDefineWideFieldEvent = procedure(Sender: TObject; var FieldName: string;
    var WideFieldValue: WideString; var Handled: boolean) of Object;
  TWordOption = (woPrintPreview,     //Preview: gleich auf Seitenansicht. Dflt=true
                 woSaveChanges,      //Änderungen speichern
                 woUseDefault,       //Wenn Ersetzung fehlt dann Standardwert von Vorlage nehmen
                 woPdfExport,        //Export nach PDF (ab Office 2007)
                 woCheckWrite,       //überprüft ob Word zum Schreiben öffnen darf
                 woPdfPrint);        //Ausdruck vor Export nach Pdf, nur iVm PdfExport
  TWordOptions = set of TWordOption;

type
  TWordPrn = class(TPrnSource)
  private
    FOnDefineField: TDefineFieldEvent;
    FOnDefineWideField: TDefineWideFieldEvent;
    FWordFields: TStrings;
    FDataSource: TDataSource;
    FWordOptions: TWordOptions;
    procedure SetWordFields(const Value: TStrings);
    procedure PrintWord(Designer, OnlyExport: boolean; ExpFilename: string);
    function DoOnDefineField(var FieldName, FieldValue: string): boolean;
    function DoOnDefineWideField(var FieldName: string; var WideFieldValue: WideString): boolean;
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
    PrinterIndex: integer;
    procedure ExportTo(Filename: string);
  public
    { Public-Deklarationen }
    W: Variant;  //Word OLE Object

    CheckTimeOut: integer;  //Wartezeit in ms wenn File gesperrt

    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
    // procedure SetupPrn(var HasChanged: boolean); override; {Drucker einrichten / Designer}
    procedure DoRun; override;     {Startet Dlg. Falls von LNav.DoPrn}
    procedure PrintDesign;  // Formular mit Feldnamen statt Werten drucken
    class procedure ForceQuit;
    class function WordIsRunning: boolean; static;
    class function CloseWordDlg: boolean; static;
  published
    { Published-Deklarationen }
    property DataSource: TDataSource read FDataSource write FDataSource;
    property WordFields: TStrings read FWordFields write SetWordFields;
    property WordOptions: TWordOptions read FWordOptions write FWordOptions;
    property OnDefineField: TDefineFieldEvent read FOnDefineField write FOnDefineField;
    property OnDefineWideField: TDefineWideFieldEvent read FOnDefineWideField write FOnDefineWideField;
  end;

implementation

uses
  ComObj, {Word_TLB,} OleServer, Printers, WinTools {ProcessId},
  //WideStringConvert, {test 11.05.11}
  AbortDlg,
  Err__Kmp, Prots, KmpResString, StopWatch;

{ TWordPrn }

constructor TWordPrn.Create(AOwner: TComponent);
begin
  inherited;
  FWordFields := TStringList.create;
  FWordOptions := [woPrintPreview];
  CheckTimeOut := 120000;  //2 Minuten warten
end;

destructor TWordPrn.Destroy;
begin
  FreeAndNil(FWordFields);
  inherited;
end;

procedure TWordPrn.SetWordFields(const Value: TStrings);
begin
  FWordFields.Assign(Value);
end;

procedure TWordPrn.DoRun;
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
      EMess(self, E, 'Error at BeforePrn', [0]); //Fehlermaske nicht 2mal anzeigen 09.06.03 SDBL
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
      //14.11.10 immer wg PdfPrint
      PrinterIndex := SysParam.GetPrinterIndex(DruckerTyp, PrinterFont);    {N}
      if ExportFile then
      begin
        ExportTo(ExportFilename);
      end else
      begin
        if not Preview then
        begin
          //14.11.10PrinterIndex := SysParam.GetPrinterIndex(DruckerTyp, PrinterFont);    {N}
        end;
        PrintWord(false, false, '');  //kein Designer
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

// unter Einstellungen belassen wir die Druckerauswahl
//    Idee: In Druckauswahl: Button [Testdruck]
// procedure TWordPrn.SetupPrn(var HasChanged: boolean);
// // Formular mit Feldnamen statt Werten drucken
// begin
//   HasChanged := false;  // PrnSource.Drucker nicht ändern
//   PrintWord(true, false, '');  //Designer
// end;

procedure TWordPrn.PrintDesign;
// Formular mit Feldnamen statt Werten drucken
begin
  PrintWord(true, false, '');  //Designer
end;

procedure TWordPrn.ExportTo(Filename: string);
begin
  PrintWord(false, true, Filename);  //kein Designer, OnlyExport
end;

function TWordPrn.DoOnDefineField(var FieldName, FieldValue: string): boolean;
// Ereignis aufrufen.
// Ergibt true wenn bereits verarbeitet in FieldValue der auszufgebende Text steht.
begin
  Result := false;
  if Assigned(FOnDefineField) then
    FOnDefineField(self, FieldName, FieldValue, Result);
end;

function TWordPrn.DoOnDefineWideField(var FieldName: string;
  var WideFieldValue: WideString): boolean;
begin
  Result := false;
  if Assigned(FOnDefineWideField) then
    FOnDefineWideField(self, FieldName, WideFieldValue, Result);
end;

procedure TWordPrn.PrintWord(Designer, OnlyExport: boolean; ExpFilename: string);

  function GetValue(WordFieldName, Default: string): string;
  var
    P, N: integer;
    AField: TField;
    AList: TStringList;
    FieldName: string;
  begin
    if Designer then
    begin
      Result := WordFieldName;
      Exit;
    end;
    Result := Default;  //war ''
    try
      //unser Feldname wird entweder über die Umsetzungsliste <WordFields> oder
      //  direkt im Worddokument angegeben
      FieldName := StrDflt(WordFields.Values[WordFieldName], WordFieldName);
      if not DoOnDefineField(FieldName, Result) then
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
              result := AList[N - 1] else     //ab 0
              result := '';
          finally
            AList.Free;
          end;
        end else
        begin
          //result := DataSource.DataSet.FieldByName(FieldName).AsString;
          if FieldName <> '' then
          begin
            AField := DataSource.DataSet.FieldByName(FieldName);
            if AField is TBlobField then
              Result := AField.AsString else  //bei Blobs
              Result := AField.Text;  //wg Asw. und Formatierung
          end;
        end;
      end;
    except on E:Exception do begin
        EProt(self, E, 'PrintWord(%s)', [FieldName]);
        result := '?';  // Word nicht verunstalten
      end;
    end;
  end;

  function GetWideValue(WordFieldName: string; Default: WideString): WideString;
  //Unicode Version
  var
    FieldName: string;
  begin
    Result := Default;  //war ''
    try
      //unser Feldname wird entweder über die Umsetzungsliste <WordFields> oder
      //  direkt im Worddokument angegeben
      FieldName := StrDflt(WordFields.Values[WordFieldName], WordFieldName);
      if not DoOnDefineWideField(FieldName, Result) then
      begin
        //keine Standard Behandlung
      end;
    except on E:Exception do begin
        EProt(self, E, 'PrintWordWide(%s)', [FieldName]);
        result := '?';  // Word nicht verunstalten
      end;
    end;
  end;

var
  FN: OleVariant;
  I: integer;
  S, FFName, AValue, DefaultValue: string;
  SaveChanges: OleVariant;
  OleState: OleVariant;
  OldReplaceSelection, wState: WordBool;
  FileHandle: integer;
  T1: integer;
  AWideValue, WideDefaultValue: WideString;
begin { PrintWord }
  I := 0;
  FFName := '';
  SW[0].Reset;
  try
    FN := QRepKurz;
    if Pos('\', FN) = 0 then
    begin
      S := FN;
      FN := AppDir + 'Word\' + S;
      if not FileExists(FN) then
        FN := AppDir + S;
    end;
    if not FileExists(FN) then
      EError('Word-Vorlage (%s) nicht gefunden', [FN]);
    ProtL('%s Lade Word mit %s', [OwnerDotName(self), FN]);

    if woCheckWrite in WordOptions then
    begin
      FileHandle := FileOpen(FN, fmOpenWrite or fmShareDenyNone);
      if FileHandle < 0 then
      try
        TicksReset(T1);
        TDlgAbort.CreateDlg('Warte auf Dateifreigabe');
        repeat
          Delay(500, true);
          TDlgAbort.GMessA(TicksDelayed(T1), CheckTimeOut);
          FileHandle := FileOpen(FN, fmOpenWrite or fmShareDenyNone);
        until (FileHandle >= 0) or (TicksDelayed(T1) > CheckTimeOut);
        if FileHandle < 0 then
          EError('%s ist zur Bearbeitung gesperrt', [OnlyFilename(FN)]);
      finally
        TDlgAbort.FreeDlg;
      end;
      FileClose(FileHandle);
    end;

    try
      W := GetActiveOleObject('Word.Application');
    except
      begin
        W := CreateOleObject('Word.Application');
        //warum? Sleep(5000);
      end;
    end;

    Application.ProcessMessages;
    SMess('Öffne %s', [FN]);
    W.Documents.Open(FileName := FN);
    //W.Documents.Open(FileName := FN, Encoding := msoEncodingCyrillic);  //test RU 11.05.11
    W.Options.PrintBackground := False;
    OldReplaceSelection := W.Options.ReplaceSelection;
    try
      //muss rückwärts laufen wg .delete - for I := 1 to W.ActiveDocument.FormFields.Count do
      for I := W.ActiveDocument.FormFields.Count downto 1 do
      begin
        FFName := W.ActiveDocument.FormFields.Item(I).Name;
        DefaultValue := W.ActiveDocument.FormFields.Item(I).TextInput.Default;
        //muss '' setzen um DefaultValue nicht zu verwenden wenn nicht woUseDefault gesetzt ist
        AValue := GetValue(FFName, DefaultValue);
        if AValue = '.wide' then
        begin
          WideDefaultValue := W.ActiveDocument.FormFields.Item(I).TextInput.Default;
          AWideValue := GetWideValue(FFName, WideDefaultValue);
          //AWideValue := StringToWideString(AValue, 1251);
          //AValue := '.wide';  //test 11.05.11
        end;
        if SysParam.ProtBeforeOpen then
          ProtLA('%s=%s', [FFName, AValue]) else
          SMess('%s=%s', [FFName, AValue]);

        if (AValue = '') and (woUseDefault in WordOptions) then
        begin
          // Vorgabe setzen
          AValue := DefaultValue;  //W.ActiveDocument.FormFields.Item(I).TextInput.Default;
        end;
        (* wir müssen jedes Feld ausgeben, da es evtl. in der Vorlage nicht leer ist.
        if AValue <> '?' then
        begin
          if AValue <> '' then
          begin
            W.ActiveDocument.FormFields.Item(I).Result := AValue;
            Application.ProcessMessages;
          end;
        end else
          Prot0('Vorlage-Feld "%s" nicht definiert', [FFName]); *)
        SW[0].Start;
        { Vorgabe setzen (bleibt):
          W.ActiveDocument.FormFields.Item(Feld).TextInput.Default := 'Name (Vorgabe)';

          Text ausgeben:
          W.Selection.goto(What:=-1, Name:='Test_Textmarke');
          W.Selection.typetext(text :='Dieser Text wird eingefügt');

          Checkbox erkennen:
            W.ActiveDocument.FormFields.Item(I).Type_ = wdFieldFormCheckBox;

        }
        try
          AValue := Copy(AValue, 1, 255);  //22.03.10
          if Designer and (W.ActiveDocument.FormFields.Item(I).Type = wdFieldFormCheckBox) then
          begin
            //W.Selection.Goto(What := wdGoToField, Name := FFName);
            W.ActiveDocument.FormFields.Item(I).Select;
            WState := false;
            W.Options.ReplaceSelection := WState;
            W.Selection.Typetext(Text := '[' + FFName + ']');
          end else
          if (AValue = '.true') or (AValue = '.false') or (AValue = '.delete') then
          begin
            //WordDocument1.FormFields.Item(wName).CheckBox.Value := wState;<br>
            if AValue = '.delete' then
            begin
              W.ActiveDocument.FormFields.Item(I).Delete;
              //W.ActiveDocument.Selection.Delete; falsch
            end else
            begin
              if AValue = '.true' then
                OleState := OleVariant(true) else
                OleState := OleVariant(false);
              W.ActiveDocument.FormFields.Item(I).CheckBox.Value := OleState;
            end;
          end else
          if AValue = '.wide' then
            W.ActiveDocument.FormFields.Item(I).Result := AWideValue
          else
            W.ActiveDocument.FormFields.Item(I).Result := StrDflt(AValue, ' ');
        except on E:Exception do
          EProt(self, E, 'Word FormField%d(%s):', [I, FFName]);
        end;
        SW[0].Stop;
        Application.ProcessMessages;
      end;
    finally
      if Designer then
        W.Options.ReplaceSelection := OldReplaceSelection;
    end;
    SW.Prot;
    I := 0;
    ProtL('Drucke %s', [FN]);
    Application.ProcessMessages;  //13.07.09
    if OnlyExport and (woPdfExport in WordOptions) then
    begin
      if woSaveChanges in WordOptions then
      begin
        ProtL('%s Speichere %s', [OwnerDotName(self), FN]);
        W.ActiveDocument.Save;
      end;

      if woPdfPrint in WordOptions then
      begin
        if PrinterIndex >= 0 then  //nicht bei Standarddrucker
        begin
          ProtL('Aktiviere Drucker %s', [Printer.Printers[PrinterIndex]]);
          W.ActivePrinter := Printer.Printers[PrinterIndex];  //09.08.08
          Application.ProcessMessages;  //13.07.09
        end;
        ProtL('%s Ausdruck', [OwnerDotName(self)]);
        //Copies:=2
        W.ActiveDocument.PrintOut(Copies := Kopien);
        Application.ProcessMessages;
      end;

      ProtL('%s PdfExport nach %s', [OwnerDotName(self), ExpFilename]);
      (*ChangeFileOpenDirectory "D:\temp\"
      ActiveDocument.ExportAsFixedFormat OutputFileName:="D:\temp\test.pdf", _
          ExportFormat:=wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
          wdExportOptimizeForPrint, Range:=wdExportAllDocument, From:=1, To:=1, _
          Item:=wdExportDocumentContent, IncludeDocProps:=True, KeepIRM:=True, _
          CreateBookmarks:=wdExportCreateNoBookmarks, DocStructureTags:=True, _
          BitmapMissingFonts:=True, UseISO19005_1:=False *)

      W.ActiveDocument.ExportAsFixedFormat(OutputFileName := ExpFilename,
        ExportFormat:=wdExportFormatPDF, OpenAfterExport:=False,
        OptimizeFor:= wdExportOptimizeForPrint, Range:=wdExportAllDocument,
        From:=1, To:=1, Item:=wdExportDocumentContent, IncludeDocProps:=True,
        KeepIRM:=True, CreateBookmarks:=wdExportCreateNoBookmarks,
        DocStructureTags:=True, BitmapMissingFonts:=True, UseISO19005_1:=False);

      SaveChanges := wdDoNotSaveChanges;  //False;
      ProtL('Schließe Word', [0]);
      W.ActiveDocument.Close(SaveChanges);
    end else
    if OnlyExport then
    begin
      //only Export
      ProtL('%s Speichern nach %s', [OwnerDotName(self), ExpFilename]);
      //wenn kein Pfad angegeben speichert Word in 'eigene Dateien'
      W.ActiveDocument.SaveAs(FileName := ExpFilename);
      Application.ProcessMessages;

      SaveChanges := wdDoNotSaveChanges;  //False;
      ProtL('Schließe Word', [0]);
      W.ActiveDocument.Close(SaveChanges);
    end else
    begin
      if woSaveChanges in WordOptions then
      begin
        ProtL('Speichere %s', [FN]);
        W.ActiveDocument.Save;
      end;

      if Preview then
      begin
        W.Visible := true;
        if W.WindowState = wdWindowStateMinimize then
          W.WindowState := wdWindowStateNormal;
        W.Activate;
        // In Word auf die Seitenansicht gehen und warten bis beendet. Nein! webab
        if woPrintPreview in WordOptions then
        begin
         W.ActiveDocument.PrintPreview;
         while W.PrintPreview do
           Application.ProcessMessages;
        end;
      end else
      begin
        if PrinterIndex >= 0 then  //nicht bei Standarddrucker
        begin
          ProtL('Aktiviere Drucker %s', [Printer.Printers[PrinterIndex]]);
          W.ActivePrinter := Printer.Printers[PrinterIndex];  //09.08.08
          Application.ProcessMessages;  //13.07.09
        end;
        ProtL('Ausdruck', [0]);
        //Copies:=2
        W.ActiveDocument.PrintOut(Copies := Kopien);
        Application.ProcessMessages;

        SaveChanges := wdDoNotSaveChanges;  //False;
        ProtL('Schließe Word', [0]);
        W.ActiveDocument.Close(SaveChanges);
        W.Visible := false;
        //Application.ProcessMessages;
        //W.Quit(SaveChanges);    //?(bricht Druck ab falls PrintBackgrounf)
      end;
    end;
    SMess0;
  except on E:Exception do
    if psRaiseError in Options then
    begin
      raise;
    end else
    begin
      //W.Visible := true;   //nicht vor Ort
      EMess(self, E, 'Word%d(%s):', [I, FFName]);
    end;
  end;

end;

// Versuch mit TWordApplication: auch nicht schneller
// var
//   W: TWordApplication;
//   D: TWordDocument;
//   FN: OleVariant;
//   I: integer;
//   S, AValue: string;
//   SaveChanges: OleVariant;
//   IOle: OleVariant;
//   ExportFnOle: OleVariant;
// begin { PrintWord }
//   I := 0;
//   SW[0].Reset;
//   try
//     FN := QRepKurz;
//     if Pos('\', FN) = 0 then
//     begin
//       S := FN;
//       FN := AppDir + 'Word\' + S;
//       if not FileExists(FN) then
//         FN := AppDir + S;
//     end;
//     if not FileExists(FN) then
//       EError('Word-Vorlage (%s) nicht gefunden', [FN]);
//     ProtL('%s Lade Word mit %s', [OwnerDotName(self), FN]);
//     W := TWordApplication.Create(self);
// 
//     Application.ProcessMessages;
//     SMess('Öffne %s', [FN]);
//     D := W.Documents.Open(FN, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//                     EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//                     EmptyParam, EmptyParam, EmptyParam, EmptyParam);
//     W.Options.PrintBackground := False;
//     for I := 1 to D.FormFields.Count do
//     begin
//       IOle := I;
//       S := D.FormFields.Item(IOle).Name;
//       AValue := GetValue(S);
//       if SysParam.ProtBeforeOpen then
//         ProtLA('%s=%s', [S, AValue]);
//       (* wir müssen jedes Feld ausgeben, da es evtl. in der Vorlage nicht leer ist.
//       if AValue <> '?' then
//       begin
//         if AValue <> '' then
//         begin
//           D.FormFields.Item(I).Result := AValue;
//           Application.ProcessMessages;
//         end;
//       end else
//         Prot0('Vorlage-Feld "%s" nicht definiert', [S]); *)
//       SW[0].Start;
//       D.FormFields.Item(IOle).Result := StrDflt(AValue, ' ');
//       SW[0].Stop;
//       Application.ProcessMessages;
//     end;
//     SW.Prot;
//     I := 0;
//     //Application.ProcessMessages;
//     SMess('Drucke %s', [FN]);
//     if OnlyExport then
//     begin
//       //only Export
//       ProtL('%s Speichern nach %s', [OwnerDotName(self), ExpFilename]);
//       ExportFnOle := ExpFilename;
//       D.SaveAs(ExportFnOle, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//        EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//        EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
//       Application.ProcessMessages;
// 
//       SaveChanges := wdDoNotSaveChanges;  //False;
//       SMess('Schließe Word', [0]);
//       D.Close(SaveChanges, EmptyParam, EmptyParam);
// 
//     end else
//     if Preview then
//     begin
//       W.Visible := true;
//       if W.WindowState = wdWindowStateMinimize then
//         W.WindowState := wdWindowStateNormal;
//       W.Activate;
//       // In Word auf die Seitenansicht gehen und warten bis beendet
//      (* D.PrintPreview;
//      while W.PrintPreview do
//        Application.ProcessMessages; *)
//     end else
//     begin
//       D.PrintOut(EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//                  EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
//                  EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
//
//       Application.ProcessMessages;
// 
//       SaveChanges := wdDoNotSaveChanges;  //False;
//       SMess('Schließe Word', [0]);
//       D.Close(SaveChanges, EmptyParam, EmptyParam);
//       W.Visible := false;
//       //Application.ProcessMessages;
//       //W.Quit(SaveChanges);    //?(bricht Druck ab falls PrintBackgrounf)
//     end;
//     SMess0;
//   except on E:Exception do
//     begin
//       //W.Visible := true;   //nicht vor Ort
//       EMess(self, E, 'Word%d:', [I]);
//     end;
//   end;

class procedure TWordPrn.ForceQuit;
//Word im Taskmanager beenden
begin
  KillProcessName('WINWORD.EXE');
end;

class function TWordPrn.WordIsRunning: boolean;
//Word im Taskmanager beenden
begin
  Result := GetProcessID('WINWORD.EXE') > 0;
end;

class function TWordPrn.CloseWordDlg: boolean;
begin
  if WordIsRunning then
  begin
    if mrYes = WMessYesNo(WordPrn_001, [0]) then  //'Word beenden?'
      ForceQuit;
  end;
  Result := WordIsRunning;
end;


end.
