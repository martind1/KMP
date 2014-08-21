unit Qrext;
(* Quickrep 2.0 Erweiterung
   DBMemo Printable, da in QrWin16 Bug
   QRCheckBox
   QRDBFltr:  Feld einer bestimmten Zeile einer Ergebnismenge ausgeben
   QRRawData: string    Daten direkt an Drucker senden.
                        Syntax: \xx = Hex ansonsten werden die Zeichen übergeben
   30.09.99    QRExprFloat
               QRExprInt
   05.12.00    QRPaintBox
   06.11.01    TQRDBMemo neu angelegt
   07.02.03    Probleme mit DBMemo
   16.05.08    Druckbild und Anzahl Zeilen bei mehrzeiligen Feldern: QRFormatLines(
   25.07.08    ImageLoadOutZoomedQr
   28.07.10    QRStringGrid (SDBL): nicht für Gnostice geeignet! nicht getestet. nicht verwendet.
   17.04.11    QRPutBitmap(QR: TCustomQuickRep; Bitmap: TBitmap; Left, Top,
                 MaxWidth, MaxHeight: integer;
   26.03.12    PaintboxLoadOutZoomedQr
   25.04.12    Idee (nicht realisiert): QR5 Export als Ablösung von Gnostice (SDBL):
               QRPDFSettings, ExportToPDF
               QRHTMLSettings, ExportToHTML
*)

interface

uses
  windows, ComCtrls, RichEdit, olectnrs,
  messages, classes, controls, stdctrls,sysutils, graphics, buttons,
  forms, extctrls, dialogs, printers, DB,
  QRPrntr, QuickRpt, Qr5Const, QRCtrls, DPos_Kmp;

type
  TOnPrintMemoEvent = procedure (sender: TObject; Value : TStrings) of object;
  TOnPrintCheckBoxEvent = procedure (sender: TObject; var Value : Boolean) of object;
  TOnPrintPaintBoxEvent =  procedure (sender: TObject; ACanvas: TCanvas; ARect: TRect) of object;
  TOnPrintCellEvent = procedure (Sender: TObject; X, Y: integer; var Value: string) of object;

  TQRPDFSettings = class(TObject)
  public
    ShowSetupDialog: boolean;
    OpenAfterGenerate: boolean;

  end;


  { TQRDBFltr }
  TQRDBFltr = class(TQRDBText)
  private
    FFltrList: TFltrList;
    FPosition: string;
    procedure SetFltrList(Value: TFltrList);
    procedure SetPosition(Value: string);
  protected
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property FltrList: TFltrList read FFltrList write SetFltrList;
    property Position: string read FPosition write SetPosition;
  end;

  { TQRDBMemo }
  TQRDBMemo = class(TQRDBText)
  private
    FOnPrintMemo: TOnPrintMemoEvent;
    procedure NewOnPrint(sender: TObject; var Value: String);
  protected
    OldOnPrint : TQRLabelOnPrintevent;
    function GetCaptionBased : boolean; override;
    procedure Loaded; override;
    procedure Print(OfsX, OfsY: integer); override;
  public
  published
    property OnPrintMemo: TOnPrintMemoEvent read FOnPrintMemo write FOnPrintMemo;
  end;

  { TQRCheckBox }
  TQRCustomCheckBox = class(TQRPrintable)
  private
    FNoFrame : boolean;
    FOnPrint : TOnPrintCheckBoxEvent;
  protected
    FChecked : boolean;  //muss protected sein damit Nachfolger auch in C++ zugreifen können
    procedure ReadVisible(Reader: TReader); virtual;
    procedure WriteDummy(Writer: TWriter); virtual;
  public
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property NoFrame : boolean read FNoFrame write FNoFrame;
    property OnPrint : TOnPrintCheckBoxEvent read FOnPrint write FOnPrint;
  end;

  TQRCheckBox = class(TQRCustomCheckBox)
  public
    constructor Create(AOwner : TComponent); override;
    procedure SetChecked(Value : boolean);
  published
    property Checked : boolean read FChecked write SetChecked;
  end;

  TQRDBCheckBox = class(TQRCustomCheckBox)
  private
    Field : TField;
    FieldNo : integer;
    FieldOK : boolean;
    DataSourceName: string;
    FDataSet : TDataSet;
    FDataField : string;
    FValueChecked: string;
    FValueUnChecked: string;
    FAswName: string;
    procedure SetAswName( Value: string);

    procedure SetDataSet(Value : TDataSet);
    procedure SetDataField(Value : string);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Prepare; override;
    procedure ReadValues(Reader: TReader); virtual;
    procedure UnPrepare; override;
    procedure WriteValues(Writer : TWriter); virtual;
  public
    constructor Create(AOwner : TComponent); override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property ValueChecked: string read FValueChecked write FValueChecked;
    property ValueUnChecked: string read FValueUnChecked write FValueUnChecked;
    property AswName: string read FAswName write SetAswName;
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property DataField : string read FDataField write SetDataField;
  end;

  { TQRRawData}
  TQRRawData = class(TQRCustomLabel)
  private
    FRawData: string;
    procedure SetRawData(Value: string);          {setzt auch Caption}
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property RawData: string read FRawData write SetRawData;
    property OnPrint;
  end;

  { TQRPaintBox }
  TQRPaintBox = class(TQRPrintable)
  private
    FOnPrint : TOnPrintPaintBoxEvent;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property OnPrint: TOnPrintPaintBoxEvent read FOnPrint write FOnPrint;
  end;

  { TQRStringGrid }
  TQRCustomStringGrid = class(TQRPrintable)
  private
    FNoFrame : boolean;
    FOnPrint : TOnPrintCellEvent;
    UpdatingBounds: boolean;
    procedure FormatLines;
//    procedure PrintToCanvas(aCanvas: TCanvas; aLeft, aTop, aWidth, aHeight, LineHeight: extended);
  protected
    FColCount: integer;
    FRowCount: integer;
    fData: TStrings;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  published
    property NoFrame : boolean read FNoFrame write FNoFrame;
    property OnPrint : TOnPrintCellEvent read FOnPrint write FOnPrint;
    property Font;
    property ParentFont;
  end;

  TQRStringGrid = class(TQRCustomStringGrid)
  private
    procedure SetColCount(const Value: integer);
    procedure SetRowCount(const Value: integer);
    procedure SetData(const Value: TStrings);
  public
    constructor Create(AOwner : TComponent); override;
  published
    property ColCount: integer read FColCount write SetColCount;
    property RowCount: integer read FRowCount write SetRowCount;
    property Data: TStrings read fData write SetData;
  end;

  { ohne Klasse }
  function QRExprFloat(const AQRExpr: TQRExpr): double;
  function QRExprInt(const AQRExpr: TQRExpr): longint;
  procedure QRFormatLines(AQRCustomLabel: TQRCustomLabel; FormattedLines: TStrings);
  //Lädt Bitmap so dass verkleinert wird aber das Seitenverhältnis bleibt.
  procedure ImageLoadOutZoomedQr(aImage: TQRImage; aFilename: string); overload;  //für Quickrep
  procedure ImageLoadOutZoomedQr(aImage: TQRImage; aStream: TStream); overload;  //für Quickrep
  procedure ImageLoadOutZoomedQr(aImage: TQRImage; ABitmap: TBitmap); overload;
  //Gibt Bitmap auf Printer-Canvas aus
  procedure PaintboxZoomedPrintQr(aPaintBox: TQRPaintbox; ACanvas: TCanvas;
    ARect: TRect; aFilename: string);
  procedure QRPutBitmapStream(QR: TCustomQuickRep; AStream: TStream; Left, Top,
    MaxWidth, MaxHeight: integer);
  procedure QRPutBitmap(QR: TCustomQuickRep; ABitmap: TBitmap; Left, Top,
    MaxWidth, MaxHeight: integer);

implementation

uses
  QrExpr, JPeg,
  Prots, GNav_Kmp, Asws_Kmp, Tools, QRepForm, QrPreDlg, Err__Kmp;

(*** Hilfsroutinen ohne Klasse ***********************************************)

function QRExprFloat(const AQRExpr: TQRExpr): double;
begin
  result := 0;
  case AQRExpr.Value.Kind of
    resInt: result := AQRExpr.Value.intResult;
    resDouble: result := AQRExpr.Value.dblResult;
    resString: result := StrToFloatTol(AQRExpr.Value.StringVal);
    resBool: result := ord(AQRExpr.Value.booResult);
  end;
end;

function QRExprInt(const AQRExpr: TQRExpr): longint;
begin
  result := 0;
  case AQRExpr.Value.Kind of
    resInt: result := AQRExpr.Value.intResult;
    resDouble: result := round(AQRExpr.Value.dblResult);
    resString: result := StrToIntTol(AQRExpr.Value.StringVal);
    resBool: result := ord(AQRExpr.Value.booResult);
  end;
end;

{ TQRDBFltr }
constructor TQRDBFltr.Create(AOwner: TComponent); 
begin
  inherited Create(AOwner);
  FFltrList := TFltrList.Create;
end;

destructor TQRDBFltr.Destroy;
begin
  FFltrList.Free;
  FFltrList := nil;
  inherited Destroy;
end;

procedure TQRDBFltr.Print(OfsX, OfsY : integer);
var
  Done: boolean;
  I: integer;
begin
  Done := false;
  if (DataSet <> nil) and DataSet.Active then
  begin
    if (FFltrList.Count > 0) and (GNavigator <> nil) then
    begin
      {GNavigator.NoProcessMessages := true;
      if not FFltrList.GotoPos(DataSet) then       140800}
      if not FFltrList.GotoPosEx(DataSet, [dpoNoProcessMessages]) then
      begin
        Done := true;
        Caption := '';
      end;
      {GNavigator.NoProcessMessages := false;     140800}
    end else
    if StrToIntTol(FPosition) > 0 then
    begin                               {Vorsicht bei Optimierung z.B. Bookmarks:}
      DataSet.First;                    { DataSet kann jederzeit neu geöffnet werden}
      I := 1;
      while I < StrToIntTol(FPosition) do
      begin
        Inc(I);
        DataSet.Next;
        if DataSet.EOF then
        begin
          Done := true;
          Caption := '';
          break;
        end;
      end;
    end;
  end;
  if not Done then
    inherited Print(OfsX, OfsY);
end;

procedure TQRDBFltr.Prepare;
begin
  inherited Prepare;
end;

procedure TQRDBFltr.SetFltrList(Value: TFltrList);
begin
  if Value <> FFltrList then
    FFltrList.Assign(Value);
  if FFltrList.Count > 0 then
    FPosition := '';
end;

procedure TQRDBFltr.SetPosition(Value: string);
begin
  if Value <> '' then
    FPosition := IntToStr(StrToInt(Value)) else
    FPosition := '';
  if FPosition <> '' then
    FFltrList.Clear;
end;

{ TQRDBMemo }

function TQRDBMemo.GetCaptionBased: boolean;
begin
  Result := false;  //ändert Lines
end;

procedure TQRDBMemo.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    if not assigned(OldOnPrint) then
    begin
      OldOnPrint := OnPrint;
      OnPrint := NewOnPrint;
    end;
  end;
end;

procedure TQRDBMemo.NewOnPrint(sender: TObject; var Value: String);
begin
  if not (csDesigning in ComponentState) then
  begin
    //Caption := '';
    if assigned(OldOnPrint) then
      OldOnPrint(sender, Value);
    Lines.Text := Value;  //07.05.12
    if assigned( FOnPrintMemo) then
    begin
      FOnPrintMemo( self, Lines);
    end;
  end;
end;

procedure TQRDBMemo.Print(OfsX, OfsY : integer);
begin
  if not (csDesigning in ComponentState) then
  begin
    Caption := 'TQRDBMemo';   //damit wird immer OnPrint Ereignis aufgerufen
  end;
  try
    //if DataSet.FieldByName(DataField).DataSize > 0 then
      inherited;
  except on E:Exception do
    EMess(self, E, 'Datafield:%s', [DataField]);
  end;
end;

{ TQRCustomStringGrid }

(*
  Label.Height := -Font.Heigth + 4
  Label.Top := Frame.Top + 1    (nur wenn mit Frame)
  Frame.Height := Label.Height + 1
  Frame.BringToFront
*)


procedure TQRCustomStringGrid.CMFontChanged(var Message: TMessage);
begin
  FormatLines;
end;

constructor TQRCustomStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fData := TStringList.Create;
end;

destructor TQRCustomStringGrid.Destroy;
begin
  FreeAndNil(fData);
  inherited;
end;

procedure TQRCustomStringGrid.FormatLines;
var
  DY: integer;
begin
  if (Parent <> nil) and (ParentReport <> nil) and not UpdatingBounds then
  begin
    UpdatingBounds := true;
    //Height := ParentReport.TextHeight(Font, 'W') * Zoom div 100 + 1;
    DY := ParentReport.TextHeight(Font, 'W') * Zoom div 100 + 1;
    Height := DY * fRowCount;
    UpdatingBounds := false;
  end
end;

procedure TQRCustomStringGrid.Paint;
var
  X, Y, DX, DY: integer;
  I, J: integer;
  S: string;
  aRect: TRect;
begin
  Canvas.Font.Assign(Font);  //von TQRCustomLabel.Paint
  if Canvas.Font.Size <> round(Font.Size * Zoom / 100) then
    Canvas.Font.Size := round(Font.Size * Zoom / 100);
  FormatLines;

  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 1;
    Brush.Style := bsClear;

    DX := Width div fColCount;
    //DY := -Font.Height + 4;
    DY := ParentReport.TextHeight(Font, 'W') * Zoom div 100 + 1;
    //Height := DY * fRowCount;
    for I := 0 to fColCount - 1 do
      for J := 0 to fRowCount - 1 do
      begin
        X := I * DX;
        Y := J * DY;
        Rectangle(X, Y, X + DX, Y + DY);

        //Test: erst jetzt  S := 'Übg';
        try
          S := StrDflt(fData.Values[Format('%d,%d', [I, J])], ' ');
        except on E:Exception do
          S := E.Message;
        end;
        aRect := Rect(X + 2, Y + 1, X + DX - 4, Y + DY - 1);
        DrawText(Handle, pchar(S), Length(S), aRect, DT_SINGLELINE or DT_NOPREFIX);
      end;
  end;
end;

procedure TQRCustomStringGrid.Print(OfsX, OfsY: integer);
var
  X, Y, DX, DY: integer;
  I, J: integer;
  S: string;
  aRect: TRect;
  CalcLeft, CalcTop: Longint;
  ColWidths: array of integer;
begin
  if IsEnabled then
  begin
//    aCanvas := QRPrinter.Canvas;
//    aCanvas.Font := Font;
//    with QRPrinter do
//      PrintToCanvas(QRPrinter.Canvas,
//                    OfsX + Size.Left, OfsY + Size.Top,
//                    Size.Width, Size.Height,
//                    aCanvas.TextHeight('W') / QRPrinter.YFactor);

    if parentreport.Exporting then
    begin
           TQRExportFilter(ParentReport.ExportFilter).acceptgraphic(
                                qrprinter.XPos(OfsX + self.Size.Left),
                                qrprinter.YPos(OfsY+ self.size.top ), self );
    end;

    with ParentReport.QRPrinter do
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      Canvas.Brush.Style := bsClear;

      CalcLeft := XPos(OfsX + Size.Left);
      CalcTop := YPos(OfsY + Size.Top);
      //if not FNoFrame then

      SetLength(ColWidths, fColCount);
      for I := 0 to fColCount - 1 do
      begin
        ColWidths[I] := 10;  //nicht auf 0 setzen
        for J := 0 to fRowCount - 1 do
        begin
          S := StrDflt(fData.Values[Format('%d,%d', [I, J])], ' ');
          if Assigned(FOnPrint) then
          begin
            FOnPrint(self, I, J, S);
            fData.Values[Format('%d,%d', [I, J])] := S;
          end;
          ColWidths[I] := IMax(ColWidths[I], Round(Canvas.TextWidth(S) / QRPrinter.XFactor));
        end;
      end;

      Canvas.Font := self.Font;       //Font.size=8; Font.Height=-11  self.height=15
      DY := Round(Canvas.TextHeight('W') / QRPrinter.YFactor); //TextHeight=14; YFactor=0,37; DY=37

      X := CalcLeft;
      for I := 0 to fColCount - 1 do
      begin
        DX := ColWidths[I];
        Y := CalcTop;
        for J := 0 to fRowCount - 1 do
        begin
          Canvas.Rectangle(X, Y, X + DX, Y + DY);

          //Test: erst jetzt  S := 'Übg';
          S := StrDflt(fData.Values[Format('%d,%d', [I, J])], ' ');
          aRect := Rect(X + 2, Y + 1, X + DX - 4, Y + DY - 1);
          DrawText(Canvas.Handle, pchar(S), Length(S), aRect, DT_SINGLELINE or DT_NOPREFIX);

          Y := Y + DY;
        end;
        X := X + DX;
      end;

    end;
  end;
end;

//procedure TQRCustomStringGrid.PrintToCanvas(aCanvas : TCanvas;
//                                       aLeft, aTop, aWidth, aHeight,
//                                       LineHeight : extended);
//begin
//  FormatLines;  //erst nach Event. Height ändern
//end;


{ TQRStringGrid }

constructor TQRStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount := 2;
  FRowCount := 2;
end;

procedure TQRStringGrid.SetColCount(const Value: integer);
begin
  if FColCount <> Value then
  begin
    FColCount := Value;
    FormatLines;
    Invalidate;
  end;
end;

procedure TQRStringGrid.SetData(const Value: TStrings);
begin
  if Value <> fData then
    fData.Assign(Value);
  Invalidate;
end;

procedure TQRStringGrid.SetRowCount(const Value: integer);
begin
  if FRowCount <> Value then
  begin
    FRowCount := Value;
    FormatLines;
    Invalidate;
  end;
end;

(*** TQRCheckBox *************************************************************)

procedure TQRCustomCheckBox.Paint;
begin
  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 1;
    { The original code had Width -1, Height -1.
      Which makes sense, if the box is 'n' pixels wide,
      then it should go from 0 to 'n-1'.  And the lines
      for the 'X' when checked also went to 'n-1'.  Yet,
      for some reason, it looks off a pixel.  It ain't
      too big of a deal, but it seems to look better like
      I've got it here.  But if on your system, it looks
      off a pixel, try it the other way. }
    Rectangle(0, 0, Width {-1}, Height {-1} );
    if FChecked then
    begin
      MoveTo(0, 0);
      LineTo(Width, Height - 1);
      MoveTo(0, Height - 1);
      LineTo(Width - 1, 0);
    end;
  end;
end;

procedure TQRCustomCheckBox.Print(OfsX, OfsY : integer);
var
  CalcLeft, CalcTop, CalcRight, CalcBottom : Longint;
begin
  if Assigned(FOnPrint) then
    FOnPrint(self, FChecked);
  with ParentReport.QRPrinter do
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Pen.Width := 1;
    Canvas.Brush.Style := bsClear;
    CalcLeft := XPos(OfsX + Size.Left);
    CalcTop := YPos(OfsY + Size.Top);
    CalcRight := XPos(OfsX + Size.Left + Size.Width);
    CalcBottom := YPos(OfsY + Size.Top + Size.Height);
    if not FNoFrame then
      Canvas.Rectangle(CalcLeft, CalcTop, CalcRight, CalcBottom);
    if FChecked then
    begin
      Canvas.Pen.Width := 2;  //23.08.07
      Canvas.MoveTo(CalcLeft, CalcTop);
      Canvas.LineTo(CalcRight, CalcBottom);
      Canvas.MoveTo(CalcRight, CalcTop);
      Canvas.LineTo(CalcLeft, CalcBottom);
    end;
  end;
end;

procedure TQRCustomCheckBox.ReadVisible(Reader: TReader);
begin
  Enabled := Reader.ReadBoolean;
end;

procedure TQRCustomCheckBox.WriteDummy(Writer: TWriter);
begin
end;

constructor TQRCheckBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FChecked := False;
end;

procedure TQRCheckBox.SetChecked(Value : boolean);
begin
  if Value <> FChecked then
  begin
    FChecked := Value;
    Invalidate;
  end;
end;

constructor TQRDBCheckBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FChecked := FALSE;
  DataSourceName := '';
end;

procedure TQRDBCheckBox.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('DataSource',ReadValues,WriteValues,false);
  Filer.DefineProperty('Visible', ReadVisible, WriteDummy, false);
  inherited DefineProperties(Filer);
end;

procedure TQRDBCheckBox.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
{$ifdef win32}
  if Value <> nil then
    Value.FreeNotification(self);
{$endif}
end;

procedure TQRDBCheckBox.SetDataField(Value : string);
var
  AField: TField;
  AAsw: TAsw;
begin
  FDataField := Value;

  if FDataSet <> nil then
  try
    AField := FDataSet.FindField(FDataField);
    if (AField <> nil) and (AField.Tag > 0) then
    begin
      AAsw := Asws.Asw( AField.Tag);
      if AAsw <> nil then
        FAswName := AAsw.AswName;
    end;
  except
  end;
end;

procedure TQRDBCheckBox.SetAswName( Value: string);
var
  AAsw: TAsw;
begin
  FAswName := Value;
  if FAswName <> '' then
  try
    AAsw := Asws.FindAsw( FAswName);
    if (AAsw <> nil) and (AAsw.Items.Count >= 2) then
    begin
      ValueChecked := AAsw.Items.Value(0);
      ValueUnChecked := AAsw.Items.Value(1);
    end;
  except
  end;
end;

procedure TQRDBCheckBox.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    Field := FDataSet.FindField(FDataField);
    if (Field <> nil) and (Field is TBooleanField) then
    begin
      FieldNo := Field.Index;
      FieldOK := true;
    end else
    if (Field <> nil) then                {über ValueChecked}
    begin
      FieldNo := Field.Index;
      FieldOK := true;
    end else
    begin
      Field := nil;
      FieldOK := false;
    end;
  end else
  begin
    Field := nil;
    FieldOK := false;
  end;
end;

procedure TQRDBCheckBox.Unprepare;
begin
  Field := nil;
  inherited Unprepare;
  if DataField <> '' then
    SetDataField(DataField) { Reset component caption }
  else
    SetDataField(Name);
end;

procedure TQRDBCheckBox.ReadValues(Reader: TReader);
begin
  DataSourceName := Reader.ReadIdent;
end;

procedure TQRDBCheckBox.WriteValues(Writer: TWriter);
begin
end;

procedure TQRDBCheckBox.Print(OfsX, OfsY : integer);
begin
  if (FDataSet <> nil) and FieldOK then
  try
    if FDataSet.DefaultFields then
      Field := FDataSet.Fields[FieldNo];
  except
  end else
    Field := nil;

  FChecked := FALSE;
  if assigned(Field) then
  try
    if (Field is TBooleanField) then
      FChecked := TBooleanField(Field).value else
      FChecked := (IndexOfToken(Field.Text, FValueChecked, ';') >= 0) or
                  ((FValueUnchecked <> '') and
                   (IndexOfToken(Field.Text, FValueUnChecked, ';') < 0));
                  (* ist in Checked oder nicht in der Unchecked, z.B. null *)
  except
  end;
  inherited Print(OfsX,OfsY);
end;

{ TQRRawData}
constructor TQRRawData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := false;
end;

procedure TQRRawData.SetRawData(Value: string);
var
  N: integer;
begin
  N := 0;
  CheckRawData(Value, nil, N);        {Exc bei Fehler}
  FRawData := Value;
  Caption := Value;          {von TQrLabel. für Paint/Designtime}
end;

procedure TQRRawData.Print(OfsX, OfsY : integer);
var
  NewData: string;
  TmpOnPrint: TQRLabelOnPrintevent;
begin
  if Enabled and (DlgQRPreview = nil) then
  try
    NewData := RawData;
    TmpOnPrint := OnPrint;
    if Assigned(TmpOnPrint) then
      OnPrint(self, NewData);
    if NewData <> '' then           {Hex umwandeln und direkt an Druckertreiber}
      PrintRawData(TQRepForm(Owner).QuickReport, NewData);
  except on E:Exception do
    EProt(self, E, 'Print(%s)', [NewData]);
  end;
end;


constructor TQRPaintBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 100;
  Height := 100;
end;

procedure TQRPaintBox.Print(OfsX, OfsY : integer);
var
  R: TRect;
begin
  //02.03.14:
(* beware
03.03.2014 13:08:22 PaintBox.Print
EAccessViolation
Zugriffsverletzung bei Adresse 00483E73 in Modul 'QuvaE.exe'. Lesen von Adresse C9155555
von: LFSQW_ST.TQRPaintBox
007f58d0 QuvaE.exe    QRPDFFilt       522 TQRPDFDocumentFilter.GRWriteBlob
007f7800 QuvaE.exe    QRPDFFilt       832 TQRPDFDocumentFilter.ProcessItem
007f7dd4 QuvaE.exe    QRPDFFilt       845 TQRPDFDocumentFilter.AddImageItem
007fe07b QuvaE.exe    QRPDFFilt      2395 TQRPDFDocumentFilter.AcceptGraphic
0087ecb2 QuvaE.exe    Qrext           833 TQRPaintBox.Print
0083fcdc QuvaE.exe    QuickRpt       3316 TQRCustomBand.Print
00841bf5 QuvaE.exe    QuickRpt       4511 TCustomQuickRep.PrintBand
0083c0b3 QuvaE.exe    QuickRpt       1872 TQRGroup.PrintGroupHeader
0083b331 QuvaE.exe    QuickRpt       1452 TQRCustomController.PrintGroupHeaders
0083bda7 QuvaE.exe    QuickRpt       1776 TQRController.Execute
00844cf3 QuvaE.exe    QuickRpt       5720 TQuickRep.Execute
00842252 QuvaE.exe    QuickRpt       4669 TCustomQuickRep.CreateReport
00843325 QuvaE.exe    QuickRpt       5200 TCustomQuickRep.ExportToFilter
00cae19a QuvaE.exe    DataTFrm       1284 TFrmDataT.psLfsPdfExportFile
0087cbf9 QuvaE.exe    Psrc_kmp        746 TPrnSource.DoRun
  if parentreport.Exporting then
  try
         TQRExportFilter(ParentReport.ExportFilter).acceptgraphic(
                              qrprinter.XPos(OfsX + self.Size.Left),
                              qrprinter.YPos(OfsY+ self.size.top ), self );
  except on E:Exception do
    EProt(self, E, 'PaintBox.Print', [0]);
  end;
*)
  if Assigned(FOnPrint) then
  begin
    with ParentReport.QRPrinter do
      R := Rect(XPos(OfsX + Size.Left),
                YPos(OfsY + Size.Top),
                XPos(OfsX + Size.Left + Size.Width),
                YPos(OfsY + Size.Top + Size.Height));
    FOnPrint(self, ParentReport.QRPrinter.Canvas, R);
  end;
  inherited Print(OfsX, OfsY);
end;

{ Formatter }

const
  BreakChars: set of AnsiChar = [' ', #13, '-'];

type
  TQRCustomLabelHack = class(TQRCustomLabel);

procedure QRFormatLines(AQRCustomLabel: TQRCustomLabel; FormattedLines: TStrings);
var
  J : integer;
  NewLine : string;
  LineFinished : boolean;
  FHasParent : boolean;

  function aLineWidth(Line : string) : integer;
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      if FHasParent then
        result := Muldiv(Longint(ParentReport.TextWidth(Font, Line)),Zoom,100)
      else
        Result := Canvas.TextWidth(Line);
    end;
  end;

  procedure FlushLine;
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      FormattedLines.Add(NewLine);
      NewLine := '';
    end;
  end;

  procedure AddWord(aWord : string);
{$ifdef ver100}
  var
    S: string;
{$endif}
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      if aLineWidth(NewLine + aWord) > Width then
      begin
        if NewLine = '' then
        begin
  {$ifdef ver100}
          if SysLocale.FarEast then
          begin
            while true do
            begin
              if (aWord[1] in LeadBytes) and (Length(aWord) > 1) then
                S := copy(aWord, 1, 2)
              else
                S := copy(aWord, 1, 1);

              if aLineWidth(NewLine + S) < Width then
              begin
                NewLine := NewLine + S;
                Delete(aWord, 1, Length(S));
              end
              else
                Break;
            end;
          end
          else
            while aLineWidth(NewLine + copy(aWord, 1, 1)) < Width do
            begin
              NewLine := NewLine + copy(aWord, 1, 1);
              Delete(aWord, 1, 1);
            end;
  {$else}
          while aLineWidth(NewLine + copy(aWord, 1, 1)) < Width do
          begin
            NewLine := NewLine + copy(aWord, 1, 1);
            Delete(aWord, 1, 1);
          end;
  {$endif}
          aWord := '';
        end;
        FlushLine;
        if aLineWidth(aWord) > Width then
        begin
          if NewLine = '' then
          begin
            if Width = 0 then
              aWord := ''
            else
              while aLineWidth(aWord) > Width do
  {$ifdef ver100}
                if ByteType(aWord, Length(aWord)) = mbTrailByte then
                  Delete(aWord, Length(aWord)-1, 2)
                else
  {$endif}
                  Delete(aWord, Length(aWord), 1);
          end;
          NewLine := aWord;
          FlushLine;
          aWord := '';
        end;
        if not WordWrap then
        begin
          aWord := '';
          LineFinished := true;
        end;
      end;
      NewLine := NewLine + aWord;
    end;
  end;

  procedure AddLine(Line : string);
  var
    aPos : integer;
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      while pos(#10, Line) > 0 do
        Delete(Line, Pos(#10, Line), 1);
      aPos := pos(#13, Line);
      if aPos > 0 then
      begin
        repeat
          AddLine(copy(Line, 1, aPos - 1));
          Delete(Line, 1 , aPos);
          aPos := pos(#13, Line);
        until aPos = 0;
        AddLine(Line);
      end else
      begin
        J := 0;
        NewLine := '';
        LineFinished := false;
        if AutoSize then
        begin
          NewLine := Line;
          FlushLine;
          LineFinished := True;
        end else
        begin
          while (J < Length(Line)) and (Length(Line) > 0) do
          begin
            repeat
  {$ifdef ver100}
              begin
                inc(J);
                if Line[J] in LeadBytes then
                begin
                  inc(J);
                  break;
                end;
              end;
  {$else}
              inc(J)
  {$endif}
            until CharInSet(Line[J], BreakChars) or (J >= Length(Line));
            AddWord(copy(Line, 1, J));
            Delete(Line, 1, J);
            J := 0;
          end;
          if not LineFinished then
            FlushLine;
        end;
      end;
    end;
  end;

  procedure FormatFromCaption;
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      AddLine(Caption);  //FPrintCaption);
//      if not UpdatingBounds and FHasParent then
//      begin
//        UpdatingBounds := true;
//        if Height < (longint(ParentReport.TextHeight(Font, 'W') * Zoom div 100) + 1) then
//           Height := (longint(ParentReport.TextHeight(Font, 'W')) * Zoom div 100) + 1;
//        UpdatingBounds := false;
//      end;
    end;
  end;

  procedure FormatFromStringList;
  var
    J : integer;
  begin
    with TQRCustomLabelHack(AQRCustomLabel) do
    begin
      if (Lines.Count <> 0) then
      begin
        if AutoSize then
          FormattedLines.Assign(Lines)
        else
          for J := 0 to Lines.Count - 1 do
            AddLine(Lines[J]);
      end;
    end;
  end;

begin { QRFormatLines }
  with TQRCustomLabelHack(AQRCustomLabel) do
  if Parent <> nil then
  begin
    if assigned(FormattedLines) then
      FormattedLines.Clear
    else
      FormattedLines := TStringList.Create;
    FHasParent := ParentReport <> nil;
    LineFinished := false;
    if CaptionBased then
      FormatFromCaption
    else
      FormatFromStringList;
  end;
end;

{ ohne Klasse }

procedure ImageLoadOutZoomedQr(aImage: TQRImage; aFilename: string);
var
  APicture: TPicture;
  ABitmap: TBitmap;
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyNone);
  try
    ImageLoadOutZoomedQr(aImage, AStream);
  finally
    AStream.Free;
  end;
//  APicture := TPicture.Create;
//  ABitmap := TBitmap.Create;
//  try
//    APicture.LoadFromFile(aFilename);
//    //beware ABitmap.Assign(APicture);  //wandelt um
//    ABitmap.Width := APicture.Width;
//    ABitmap.Height := APicture.Height;
//    ABitmap.Canvas.Draw(0, 0, APicture.Graphic);
//
//    ImageLoadOutZoomedQr(aImage, ABitmap);
//  finally
//    APicture.Free;
//    ABitmap.Free;
//  end;
end;

procedure ImageLoadOutZoomedQr(aImage: TQRImage; AStream: TStream);
var
  ABitmap: TBitmap;
begin
  //AStream := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyNone);
  ABitmap := TBitmap.Create;
  try
    Prots.LoadBitmapFromGraphicStream(AStream, ABitmap);
    ImageLoadOutZoomedQr(aImage, ABitmap);
  finally
    ABitmap.Free;
  end;
end;

procedure ImageLoadOutZoomedQr(aImage: TQRImage; ABitmap: TBitmap);
//procedure ImageLoadOutZoomedQr(aImage: TQRImage; APicture: TPicture);
//Siehe Prots.ImageLoadOutZoomed
//für Quickrep und Gnostice
var
  CenterX, CenterY: integer;
  MaxWidth, MaxHeight: integer;
  MaxRatio, Ratio, Zoom: double;
begin
  CenterX := aImage.Left + (aImage.Width div 2);
  CenterY := aImage.Top + (aImage.Height div 2);
  //Pic mit Autosize laden. Höhen/Breitenverhältnis auf aImage kopieren. Autosize=false;Stretch=true
  MaxWidth := aImage.Width;
  MaxHeight := aImage.Height;
  MaxRatio := aImage.Width / aImage.Height;
  aImage.Autosize := true;
  //beware! aImage.Picture.LoadFromStream(AStream);  //LoadFromFile(aFilename);
  //aImage.Picture := aPicture;
  aImage.Picture.Bitmap := aBitmap;

  Ratio := aImage.Width / aImage.Height;
  Zoom := 1;
  Zoom := FloatMin(Zoom, MaxWidth / aImage.Width);
  Zoom := FloatMin(Zoom, MaxHeight / aImage.Height);
  if Zoom < 1 then  //verkleinern
  begin
    aImage.Autosize := false;
    aImage.Stretch := true;
    if Ratio >= MaxRatio then  //Bild sehr breit. Höhe verkleinern
    begin
      aImage.Width := MaxWidth;
      aImage.Height := MulDiv(aImage.Width, 1000, Round(Ratio * 1000));
    end else
    begin
      aImage.Height := MaxHeight;
      aImage.Width := MulDiv(aImage.Height, Round(Ratio * 1000), 1000);
    end;
  end;
  if aImage.Center then
  begin
    aImage.Left := CenterX - (aImage.Width div 2);
    aImage.Top := CenterY - (aImage.Height div 2);
  end;
end;

//procedure ImageLoadReduceQr(aImage: TQRImage; aFilename: string);
////Ladet und verkleinert Bitmap. Passt Image Größe an.
////für Quickrep
////26.03.12 erstellt
//var
//  CenterX, CenterY: integer;
//  MaxWidth, MaxHeight: integer;
//  MaxRatio, Ratio, Zoom: double;
//  AFileStream: TFileStream;
//  ABitmap: Graphics.TBitmap;
//begin
//  CenterX := aImage.Left + (aImage.Width div 2);
//  CenterY := aImage.Top + (aImage.Height div 2);
//  //Pic mit Autosize laden. Höhen/Breitenverhältnis auf aImage kopieren. Autosize=false;Stretch=true
//  MaxWidth := aImage.Width;
//  MaxHeight := aImage.Height;
//  MaxRatio := aImage.Width / aImage.Height;
//
//  LoadBitmapFromGraphicStream(aStream: TStream; aBitmap: TBitmap);
//
//  aImage.Autosize := true;
//  aImage.Picture.LoadFromFile(aFilename);
//  Ratio := aImage.Width / aImage.Height;
//  Zoom := 1;
//  Zoom := FloatMin(Zoom, MaxWidth / aImage.Width);
//  Zoom := FloatMin(Zoom, MaxHeight / aImage.Height);
//  if Zoom < 1 then  //verkleinern
//  begin
//    aImage.Autosize := false;
//    aImage.Stretch := true;
//    if Ratio >= MaxRatio then  //Bild sehr breit. Höhe verkleinern
//    begin
//      aImage.Width := MaxWidth;
//      aImage.Height := MulDiv(aImage.Width, 1000, Round(Ratio * 1000));
//    end else
//    begin
//      aImage.Height := MaxHeight;
//      aImage.Width := MulDiv(aImage.Height, Round(Ratio * 1000), 1000);
//    end;
//  end;
//  if aImage.Center then
//  begin
//    aImage.Left := CenterX - (aImage.Width div 2);
//    aImage.Top := CenterY - (aImage.Height div 2);
//  end;
//end;



procedure PaintboxZoomedPrintQr(aPaintBox: TQRPaintbox; ACanvas: TCanvas;
  ARect: TRect; aFilename: string);
//Ersetzt Image~. Löst Problem mit zu großen Bitmaps und QRImage.
//26.03.12 erstellt
//Center hier nicht möglich da kein Parameter vorhanden
var
  MaxWidth, MaxHeight: integer;
  MaxRatio, Ratio, Zoom: double;
  AFileStream: TFileStream;
  ABitmap: Graphics.TBitmap;
  OldCopyMode: TCopyMode;
  Err, StartTime: integer;
  PrnRect: TRect;
  aHeight, aWidth: integer;
  ErrStr: string;
begin
  MaxWidth := RectWidth(ARect);
  MaxHeight := RectHeight(ARect);
  MaxRatio := RectWidth(ARect) / RectHeight(ARect);

  //Pic laden. Höhen/Breitenverhältnis auf aPaintBox kopieren.
  AFileStream := TFileStream.Create(AFilename, fmOpenRead + fmShareDenyNone);
  ABitmap := Graphics.TBitmap.Create;
  OldCopyMode := ACanvas.CopyMode;
  ACanvas.CopyMode := cmSrcAnd;
  PrnRect := ARect;
  try
    Prots.LoadBitmapFromGraphicStream(AFileStream, ABitmap);

    Ratio := ABitmap.Width / ABitmap.Height;
    Zoom := 1;
    Zoom := FloatMin(Zoom, MaxWidth / ABitmap.Width);
    Zoom := FloatMin(Zoom, MaxHeight / ABitmap.Height);
    if Zoom < 1 then  //verkleinern
    begin
      if Ratio >= MaxRatio then  //Bild sehr breit. Höhe verkleinern
      begin
        aHeight := MulDiv(MaxWidth, 1000, Round(Ratio * 1000));
        PrnRect.Bottom := PrnRect.Top + aHeight;
      end else
      begin
        aWidth := MulDiv(MaxHeight, Round(Ratio * 1000), 1000);
        PrnRect.Right := PrnRect.Left + aWidth;
      end;
    end else
    begin
//      PrnRect.Bottom := PrnRect.Top + ABitmap.Height;
//      PrnRect.Right := PrnRect.Left + ABitmap.Width;
      aHeight := MulDiv(MaxWidth, 1000, Round(Ratio * 1000));
      PrnRect.Bottom := PrnRect.Top + aHeight;
    end;

    TicksReset(StartTime);
    ErrStr := '';
    repeat
      SetLastError(0);
      ACanvas.StretchDraw(PrnRect, ABitmap);
      Err := GetLastError;
      if Err <> 0 then
      begin
        ErrStr := Format('PaintboxZoomedPrintQr.Stretchdraw(%s):%d(%s)', [
                         AFilename, Err, SysErrorMessage(Err)]);
        //Prot0('PaintboxZoomedPrintQr.Stretchdraw(%s):%d(%s)', [AFilename, Err, SysErrorMessage(Err)]);
        Delay(100);
      end;      //ERROR_INVALID_HANDLE = 6 - passiert wenn Focus gewechselt: wiederholen
    until (Err <> ERROR_INVALID_HANDLE) or (TicksDelayed(StartTime) > 3000);
    if (Err <> 0) then
      Prot0('%s', [ErrStr]);
  finally
    ABitmap.Free;
    AFileStream.Free;
    ACanvas.CopyMode := OldCopyMode;
  end;
end;

    //QR.QRPrinter.Canvas.Draw(1, 1, ABitmap);
    //aHDC := Printer.Handle;
    //BitBlt(Qr.QrPrinter.Canvas.Handle, 0, 0, ABitmap.Width, ABitmap.Height,ABitmap.Handle, 0, 0, SRCAND);

procedure QRPutBitmapStream(QR: TCustomQuickRep; AStream: TStream; Left, Top,
    MaxWidth, MaxHeight: integer);
//schreibt Bitmap direkt auf QR Canvas.
// ersetzt Block in QuvaE.MainFrm
var
  ABitmap: TBitmap;
begin
  ABitmap := TBitmap.Create;
  try
    Prots.LoadBitmapFromGraphicStream(AStream, ABitmap);
    if ABitMap.Height <= 0 then
      EError('Fehler bei QRPutBitmapStream. Bitmap fehlt.', [0]);

    QRPutBitmap(QR, ABitmap, Left, Top, MaxWidth, MaxHeight);
  finally
    ABitmap.Free;
  end;
end;

procedure QRPutBitmap(QR: TCustomQuickRep; ABitmap: TBitmap; Left, Top,
    MaxWidth, MaxHeight: integer);
// Gibt Bitmap auf Printer-Canvas aus. Für QuvaE PrintVorlage Bitmaps auf Lfs
// MaxWidth: wenn null dann gesamte Breite
var
  Err, StartTime: integer;
  PrnRect: TRect;
  Verh: double;   //Breite:Höhe
  PreviewPixels, PreviewVerh: double;
begin
  Verh := ABitmap.Width / ABitMap.Height;
  try
    PrnRect := QR.QRPrinter.Canvas.ClipRect;
    if PrnRect.Right > PrnRect.Bottom then
    begin
      Prot0('Querformat(%d,%d)', [PrnRect.Right, PrnRect.Bottom]);
      // Wenn Papier Querformat
      //   dann Hochkant-Bitmap rechtsbündig auf Hochkant-Breite skalieren
      PrnRect.Left := PrnRect.Right - PrnRect.Bottom;
      //PrnRect.Right := PrnRect.Bottom;  // (linksbündig)
      { TODO : rechtsbündig steuern über Left=9999 }
    end;

    if QR.QRPrinter.ShowingPreview then
    begin
      PreviewPixels := Screen.PixelsPerInch * 8.268;  //Breite DinA4 in Screen Pixel
      PreviewVerh := PrnRect.Right / PreviewPixels;
      PrnRect.Right := round(PreviewPixels);
      if PreviewVerh <> 0 then
        PrnRect.Left := Round(PrnRect.Left / PreviewVerh);  //Querformat und preview
    end else
    begin
    end;

    PrnRect.Bottom := round((PrnRect.Right - PrnRect.Left) / Verh);

    if Left + Top + MaxWidth + MaxHeight > 0 then
    begin
      //*** dieser Block ist noch nicht getestet. Er wird nicht benutzt.
      // mm nach Pixel, getrennt nach horiz und verti
      if Left > 0 then
      begin
        PrnRect.Left := PrnRect.Left + Round(Left * QR.QRPrinter.XFactor);
        PrnRect.Right := PrnRect.Right + Round(Left * QR.QRPrinter.XFactor);
      end;
      if Top > 0 then
      begin
        PrnRect.Top := PrnRect.Top + Round(Top * QR.QRPrinter.YFactor);
        PrnRect.Bottom := PrnRect.Bottom + Round(Top * QR.QRPrinter.YFactor);
      end;
      if MaxWidth > 0 then
      begin
        PrnRect.Right := PrnRect.Left + Round(MaxWidth * QR.QRPrinter.XFactor);
        //PrnRect.Bottom := round((PrnRect.Right - PrnRect.Left) / Verh);
      end;
      if MaxHeight > 0 then
      begin  // Verh=dx/dy; Höhe=MaxHeight; Breite=MaxHeight * Verh
        PrnRect.Bottom := PrnRect.Top + Round(MaxHeight * QR.QRPrinter.YFactor);
        PrnRect.Right := PrnRect.Left + Round(MaxHeight * QR.QRPrinter.XFactor * Verh);
        //PrnRect.Right := round((PrnRect.Top - PrnRect.Bottom) / Verh);
      end;
    end;
    
    QR.QRPrinter.Canvas.CopyMode := cmSrcAnd;
    TicksReset(StartTime);
    repeat
      SetLastError(0);
      QR.QRPrinter.Canvas.StretchDraw(PrnRect, ABitmap);
      Err := GetLastError;
      if Err <> 0 then
      begin
        Prot0('Stretchdraw(Preview=%d):%d(%s)', [ord(QR.QRPrinter.ShowingPreview),
          Err, SysErrorMessage(Err)]);
        Delay(100);
      end;        //ERROR_INVALID_HANDLE = 6 - passiert wenn Focus gewechselt
    until (Err <> ERROR_INVALID_HANDLE) or (TicksDelayed(StartTime) > 3000);
  finally
    QR.QRPrinter.Canvas.CopyMode := cmSrcCopy;  //restaurieren
  end;
end;


end.
