unit QrPreDlg;
(*  Quickreport Preview Dialog
    19.07.98 MD  Modifiziert von QRPREV.PAS - QUICKREPORT STANDARD PREVIEW FORM
                 Startsize = 100%
                 Up Down Keys
                 Deutsche Beschriftung
    20.05.99 MD  Cursorsteuerung vollständig implementiert, Zoom, PopupMenu
    25.08.99 MD  Minimieren nicht mehr möglich
    10.01.00 MD  Zoomvorgabe über INI
    12.09.02 MD  QR 3.6.2 Erweiterungen (QRexports 2.0)
*)

// {$I QRDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, QRPrntr, QR5const, ComCtrls, ToolWin, Menus,
  ImgList,
  Prots, PSrc_Kmp, QRExport;

type
  TDlgQRPreview = class(TForm)
    StatusBar: TStatusBar;
    ToolBar1: TToolBar;
    ZoomFit: TToolButton;
    Zoom100: TToolButton;
    ZoomToWidth: TToolButton;
    Separator1: TToolButton;
    FirstPage: TToolButton;
    PreviousPage: TToolButton;
    ToolButton2: TToolButton;
    LastPage: TToolButton;
    Separator2: TToolButton;
    PrintSetup: TToolButton;
    Print: TToolButton;
    Separator3: TToolButton;
    SaveReport: TToolButton;
    LoadReport: TToolButton;
    Separator4: TToolButton;
    Images: TImageList;
    ToolButton1: TToolButton;
    ExitButton: TSpeedButton;
    QRPreview: TQRPreview;
    PopupMenu1: TPopupMenu;
    MiScrollUp: TMenuItem;
    MiScrollDown: TMenuItem;
    MiScrollLeft: TMenuItem;
    MiScrollRight: TMenuItem;
    N2: TMenuItem;
    MiScrollPgUp: TMenuItem;
    MiScrollPgDn: TMenuItem;
    MiScrollColLeft: TMenuItem;
    MiScrollColRight: TMenuItem;
    N3: TMenuItem;
    MiFirstPage: TMenuItem;
    MiPrevPage: TMenuItem;
    MiNextPage: TMenuItem;
    MiLastPage: TMenuItem;
    N1: TMenuItem;
    MiZoomToFit: TMenuItem;
    MiZoomTo100: TMenuItem;
    MiZoomToWidth: TMenuItem;
    MiZoomPlus: TMenuItem;
    MiZoomMinus: TMenuItem;
    SqlDialog: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ZoomToFitClick(Sender: TObject);
    procedure ZoomTo100Click(Sender: TObject);
    procedure ZoomToWidthClick(Sender: TObject);
    procedure FirstPageClick(Sender: TObject);
    procedure PrevPageClick(Sender: TObject);
    procedure NextPageClick(Sender: TObject);
    procedure LastPageClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure PrintSetupClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure QRPreviewPageAvailable(Sender: TObject; PageNum: Integer);
    procedure QRPreviewProgressUpdate(Sender: TObject; Progress: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MiScrollUpClick(Sender: TObject);
    procedure MiScrollDownClick(Sender: TObject);
    procedure MiScrollLeftClick(Sender: TObject);
    procedure MiScrollRightClick(Sender: TObject);
    procedure MiScrollPgUpClick(Sender: TObject);
    procedure MiScrollPgDnClick(Sender: TObject);
    procedure MiScrollColLeftClick(Sender: TObject);
    procedure MiScrollColRightClick(Sender: TObject);
    procedure MiZoomPlusClick(Sender: TObject);
    procedure MiZoomMinusClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SqlDialogClick(Sender: TObject);
    procedure QRPreviewMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure QRPreviewMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure QRPreviewMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    FQRPrinter : TQRPrinter;
    MinusZoom: boolean;
    Gauge : TProgressBar;
    LastProgress : integer;
  protected
    procedure BCZoomTo100(var Message: TMessage); message BC_ZOOMTO100;
  public
    PrnSource: TPrnSource;
    ZoomStep: integer;
    constructor CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter); virtual;
    procedure Show;
    procedure UpdateInfo;
    property QRPrinter : TQRPrinter read FQRPrinter write FQRPrinter;
  end;

var
  DlgQRPreview: TDlgQRPreview;

implementation
{$R *.DFM}
uses
  //benötigen dll: QrWebFilt, QrPDFFilt,    //im Pfad $(DELPHI)\QRexports
  Ini__Kmp, GNav_Kmp, Err__Kmp, KmpResString;

procedure TDlgQRPreview.BCZoomTo100(var Message: TMessage); {message BC_ZOOMTO100;}
begin
  if Message.wParam = zoZoomTo100 then
    Zoom100.Click else
  if Message.wParam = zoZoomToFit then
    ZoomFit.Click else
  if Message.wParam = zoZoomToWidth then
    ZoomToWidth.Click else
  if QrPreview.PreviewImage.ImageOK then
    QrPreview.Visible := true;
end;

constructor TDlgQRPreview.CreatePreview(AOwner : TComponent; aQRPrinter : TQRPrinter);
begin
  inherited Create(AOwner);
  QRPrinter := aQRPrinter;
  WindowState := wsMaximized;
  QRPreview.QRPrinter := aQRPrinter;
  if (QRPrinter <> nil) and (QRPrinter.Title <> '') then
    Caption := QRPrinter.Title;
  Gauge := TProgressBar.Create(Self);
//  Gauge.Parent := self;//
  Gauge.Top := 2;
  Gauge.Left := 2;
  Gauge.Height := 10;//
  Gauge.Width := 100;
  LastProgress := 0;
  if qrprinter.status = mpFinished then
    Print.Enabled := true;

  Zoom100.Down := IniKmp.ReadBool('Preview', 'ZoomTo100', true);    {ori=false}
  ZoomToWidth.Down := not Zoom100.Down and
                   IniKmp.ReadBool('Preview', 'ZoomToWidth', false);    {ori=true}
  ZoomFit.Down := not Zoom100.Down and not ZoomToWidth.Down and
                  IniKmp.ReadBool('Preview', 'ZoomToFit', false);    {ori=false}
  ZoomStep := IniKmp.ReadInteger('Preview', 'ZoomStep', 20);
  MiScrollUp.ShortCut := ShortCut(VK_Up, []);
  MiScrollDown.ShortCut := ShortCut(VK_Down, []);
  MiScrollLeft.ShortCut := ShortCut(VK_Left, []);
  MiScrollRight.ShortCut := ShortCut(VK_Right, []);
  MiZoomPlus.Caption := MiZoomPlus.Caption + IntToStr(ZoomStep) + '%';
  MiZoomMinus.Caption := MiZoomMinus.Caption + IntToStr(ZoomStep) + '%';

end;

procedure TDlgQRPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    QRPrinter.ClosePreview(Self);
  except on E:Exception do
    begin
      Screen.Cursor := crDefault;
      {if DelphiRunning then
        EMess(self, E, 'TDlgQRPreview.FormClose', [0]) else}
        EProt(self, E, 'TDlgQRPreview.FormClose', [0]);
    end;
  end;
  Action := caFree;
end;

procedure TDlgQRPreview.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  IniKmp.WriteBool('Preview', 'ZoomToWidth', ZoomToWidth.Down);
  IniKmp.WriteInteger('Preview', 'ZoomStep', ZoomStep);
  IniKmp.WriteBool('Preview', 'ZoomTo100', Zoom100.Down);
  IniKmp.WriteBool('Preview', 'ZoomToFit', ZoomFit.Down);
end;

procedure TDlgQRPreview.UpdateInfo;
begin
  //  'Seite '  ..  ' von '
  StatusBar.Panels[1].Text := SQrPreDlg_001 + IntToStr(QRPreview.PageNumber) +
    SQrPreDlg_002 + IntToStr(QRPreview.QRPrinter.PageCount);

  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
  if Zoom100.Down and (QrPreview.Zoom <> 100) then
    PostMessage(Handle, BC_ZOOMTO100, zoZoomTo100, 0) else
  if ZoomFit.Down and (QrPreview.ZoomState <> qrZoomToFit) then
    PostMessage(Handle, BC_ZOOMTO100, zoZoomToFit, 0) else
  if ZoomToWidth.Down and (QrPreview.ZoomState <> qrZoomToWidth) then
    PostMessage(Handle, BC_ZOOMTO100, zoZoomToWidth, 0);
  if QrPreview.PreviewImage.ImageOK then
    QrPreview.Visible := true;
end;

procedure TDlgQRPreview.ZoomToFitClick(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.ZoomToFit;
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
end;

procedure TDlgQRPreview.ZoomTo100Click(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.Zoom := 100;
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
end;

procedure TDlgQRPreview.ZoomToWidthClick(Sender: TObject);
begin
  Application.ProcessMessages;
  QRPreview.ZoomToWidth;
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
end;

procedure TDlgQRPreview.FirstPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := 1;
  UpdateInfo;
end;

procedure TDlgQRPreview.PrevPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPreview.PageNumber - 1;
  UpdateInfo;
end;

procedure TDlgQRPreview.NextPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPreview.PageNumber + 1;
  UpdateInfo;
end;

procedure TDlgQRPreview.LastPageClick(Sender: TObject);
begin
  QRPreview.PageNumber := QRPrinter.PageCount;
  UpdateInfo;
end;

procedure TDlgQRPreview.PrintClick(Sender: TObject);
begin
  QRPrinter.Print;
end;

procedure TDlgQRPreview.ExitClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Close;
end;

procedure TDlgQRPreview.FormResize(Sender: TObject);
begin
  QRPreview.UpdateZoom;
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
end;

procedure TDlgQRPreview.Show;
begin
{  QRPreview.QRPrinter.ShowingPreview:=true;}
  inherited Show;
  UpdateInfo;
end;

procedure TDlgQRPreview.SaveClick(Sender: TObject);
var
  aExportFilter : TQRExportFilter;
{$ifndef win32}
  FileExt : string;
{$endif}
  I : integer;
  aLibraryEntry : TQRExportFilterLibraryEntry;
begin
  // doppelt vorhandene schlechtere Filter nicht anbieten:
  //D2010 nochmal probieren
//  for I := QRExportFilterLibrary.Filters.Count - 1 downto 0 do
//  begin
//    aLibraryEntry := TQRExportFilterLibraryEntry(
//              QRExportFilterLibrary.Filters[I]);
//    if aLibraryEntry.ExportFilterClass.ClassName = 'TQRHtmlExportFilter' then
//      QRExportFilterLibrary.RemoveFilter(aLibraryEntry.ExportFilterClass) else
//    if aLibraryEntry.ExportFilterClass.ClassName = 'TQRCSVExportFilter' then
//      QRExportFilterLibrary.RemoveFilter(aLibraryEntry.ExportFilterClass) else
//  end;
  aExportFilter := nil;
  with TSaveDialog.Create(Application) do
  try
    Title := SqrSaveReport;
    Filter := QRExportFilterLibrary.SaveDialogFilterString;
    DefaultExt := cQRPDefaultExt;
    if Execute then
    begin
    {$ifdef win32}
      if FilterIndex = 1 then
        QRPrinter.Save(Filename)
      else
      begin
        try
          aExportFilter := TQRExportFilterLibraryEntry(
            QRExportFilterLibrary.Filters[FilterIndex - 2]).ExportFilterClass.Create(Filename);
          QRPrinter.ExportToFilter(aExportFilter);
        finally
          aExportFilter.Free
        end;
      end
    {$else}
      FileExt := ExtractFileExt(Filename);
      if copy(FileExt, 1, 1) = '.' then delete(FileExt, 1, 1);
      if (FileExt = '') or (FileExt = cQRPDefaultExt) then
        QRPrinter.Save(Filename)
      else
      begin
        for I := 0 to QRExportFilterLibrary.Filters.Count - 1 do
        begin
          if TQRExportFilterLibraryEntry(QRExportFilterLibrary.Filters[I]).Extension = FileExt then
          try
            aExportFilter := TQRExportFilterLibraryEntry(
            QRExportFilterLibrary.Filters[I]).ExportFilterClass.Create(Filename);
            QRPrinter.ExportToFilter(aExportFilter);
          finally
            aExportFilter.Free;
          end;
        end;
      end;
    {$endif}
    end;
  finally
    Free;
  end;
end;

procedure TDlgQRPreview.PrintSetupClick(Sender: TObject);
begin
  QRPrinter.PrintSetup;
end;

procedure TDlgQRPreview.LoadClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  try
    Title := SqrLoadReport;
    Filter := SqrQRFile + ' (*.' +cQRPDefaultExt + ')|*.' + cqrpDefaultExt;
    if Execute then
      if FileExists(FileName) then
      begin
        QRPrinter.Load(Filename);
        QRPreview.PageNumber := 1;
        QRPreview.PreviewImage.PageNumber := 1;
        UpdateInfo;
        PrintSetup.Enabled := False;
        Print.Enabled := true;
      end
      else
        ShowMessage(SqrFileNotExist);
  finally
    free;
  end;
end;

procedure TDlgQRPreview.QRPreviewPageAvailable(Sender: TObject;
  PageNum: Integer);
begin
  UpdateInfo;
  if qrprinter.status = mpFinished then
  begin
    PrintSetup.Enabled := true;
    Print.Enabled := true;
  end;
end;

procedure TDlgQRPreview.QRPreviewProgressUpdate(Sender: TObject;
  Progress: Integer);
begin
  if Progress >= LastProgress + 5 then
  begin
    StatusBar.Panels[0].Text := IntToStr(Progress)+'%';
    LastProgress := Progress;
  end;
//  Gauge.Position := Progress;
  if (Progress <= 0) or (Progress >= 100) then StatusBar.Panels[0].Text := '';

  BringToFront;
end;

procedure TDlgQRPreview.FormCreate(Sender: TObject);
begin
  DlgQRPreview := self;
  HorzScrollbar.Tracking := true;
  VertScrollbar.Tracking := true;
  GNavigator.TranslateForm(self);
  SqlDialog.Visible := DelphiRunning;
end;

procedure TDlgQRPreview.FormDestroy(Sender: TObject);
begin
  DlgQRPreview := nil;
end;

procedure TDlgQRPreview.MiScrollUpClick(Sender: TObject);
begin
  {QRPreview.ScrollBy(0, QRPreview.VertScrollBar.Increment);}
  with QRPreview.VertScrollBar do
    if Position - Increment < 0 then
      Position := 0 else
      Position := Position - Increment;
end;

procedure TDlgQRPreview.MiScrollDownClick(Sender: TObject);
begin
  {QRPreview.ScrollBy(0, -QRPreview.VertScrollBar.Increment);}
  with QRPreview.VertScrollBar do
    if Position + Increment > Range then
      Position := Range else
      Position := Position + Increment;
end;

procedure TDlgQRPreview.MiScrollLeftClick(Sender: TObject);
begin
  with QRPreview.HorzScrollBar do
    if Position - Increment < 0 then
      Position := 0 else
      Position := Position - Increment;
end;

procedure TDlgQRPreview.MiScrollRightClick(Sender: TObject);
begin
  with QRPreview.HorzScrollBar do
    if Position + Increment > Range then
      Position := Range else
      Position := Position + Increment;
end;

procedure TDlgQRPreview.MiScrollPgUpClick(Sender: TObject);
begin
  with QRPreview.VertScrollBar do
    {Position := IMax(Position - QRPreview.Height, 0);}
    if Position > 0 then
      Position := IMax(Position - QRPreview.Height, 0) else
      PrevPageClick(Sender);
end;

procedure TDlgQRPreview.MiScrollPgDnClick(Sender: TObject);
begin
  with QRPreview.VertScrollBar do
    {Position := IMin(Position + QRPreview.Height, Range);}
    if Position < Range - QRPreview.Height then
      Position := IMin(Position + QRPreview.Height, Range) else
      NextPageClick(Sender);
end;

procedure TDlgQRPreview.MiScrollColLeftClick(Sender: TObject);
begin
  with QRPreview.HorzScrollBar do
    Position := IMax(Position - QRPreview.Width div 2, 0);
end;

procedure TDlgQRPreview.MiScrollColRightClick(Sender: TObject);
begin
  with QRPreview.HorzScrollBar do
    Position := IMin(Position + QRPreview.Width div 2, Range);
end;

procedure TDlgQRPreview.MiZoomPlusClick(Sender: TObject);
begin
  QRPreview.Zoom := NextTab(QRPreview.Zoom, ZoomStep);
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
  MinusZoom := false;
end;

procedure TDlgQRPreview.MiZoomMinusClick(Sender: TObject);
begin
  QRPreview.Zoom := NextTab(QRPreview.Zoom, -ZoomStep);
  Caption := LongCaption(Caption, Format('%d %%', [QRPreview.Zoom]));
  MinusZoom := true;
end;

procedure TDlgQRPreview.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
  begin
    if MinusZoom then
      MiZoomMinus.Click else
      MiZoomPlus.Click;
  end;
end;

procedure TDlgQRPreview.SqlDialogClick(Sender: TObject);
begin
  GNavigator.BtnSqlClick(Sender);
end;

procedure TDlgQRPreview.QRPreviewMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  QRPreview.VertScrollBar.Position := IMax(0,
    QRPreview.VertScrollBar.Position - QRPreview.VertScrollBar.Increment);
end;

procedure TDlgQRPreview.QRPreviewMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  QRPreview.VertScrollBar.Position := IMin(QRPreview.VertScrollBar.Range,
    QRPreview.VertScrollBar.Position + QRPreview.VertScrollBar.Increment);
end;

procedure TDlgQRPreview.QRPreviewMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  QRPreview.VertScrollBar.Position := IMin(QRPreview.VertScrollBar.Range,
    QRPreview.VertScrollBar.Position + QRPreview.VertScrollBar.Increment);
end;

end.
