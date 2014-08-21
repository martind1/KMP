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
    14.12.11 md  D2010 QR5 Anpassungen
                 todo: von qrprev übernehmen. EventHandled
    04.04.12 md  PrintSetup übernehmen
    25.04.12 md  mit TQRPreviewInterface statt onPreview Event
    11.11.12 md  Blacki: Interface reaktiviert
*)

// {$I QRDEFS.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, QRPrntr, QR5const, ComCtrls, ToolWin, Menus,
  ImgList,
  Prots, PSrc_Kmp, QRExport;

type
  TDlgQRPreviewInterface = class(TQRPreviewInterface)
  public
    function Show(AQRPrinter : TQRPrinter) : TWinControl; override;
    function ShowModal(AQRPrinter : TQRPrinter): TWinControl; override;
  end;

  //in GNav:
  //RegisterPreviewClass(TDlgQRPreviewInterface);




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
    LaSaveError: TLabel;
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
    OpenAfterGenerate: boolean;
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
  ShellAPI {findexe},
  quickrpt, Poll_Kmp, QRepForm {für PrnSource},
  Ini__Kmp, GNav_Kmp, Err__Kmp, KmpResString;

var
  FParentReport: TCustomQuickrep;
//  eventHandled: boolean;

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
  QRPreview.QRPrinter := aQRPrinter;
  //D2010
  OpenAfterGenerate := true;
  //QR5:
  if qrprinter.parentreport is TCustomquickrep then
  begin
    FParentReport := TCustomquickrep(qrprinter.ParentReport);
  end;

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
  begin
    Print.Enabled := true;
    SaveReport.Enabled := true;
  end;

  Zoom100.Down := IniKmp.ReadBool('Preview', 'ZoomTo100', true);    {ori=false}
  ZoomToWidth.Down := not Zoom100.Down and
                   IniKmp.ReadBool('Preview', 'ZoomToWidth', false);    {ori=true}
  ZoomFit.Down := not Zoom100.Down and not ZoomToWidth.Down and
                  IniKmp.ReadBool('Preview', 'ZoomToFit', false);    {ori=false}
  ZoomStep := IniKmp.ReadInteger('Preview', 'ZoomStep', 20);

  self.SetBounds(IniKmp.ReadInteger('Preview', 'Left', self.Left),
                 IniKmp.ReadInteger('Preview', 'Top', self.Top),
                 IniKmp.ReadInteger('Preview', 'Width', self.Width),
                 IniKmp.ReadInteger('Preview', 'Height', self.Height));
  WindowState := wsMaximized;

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
  if WindowState = wsNormal then
  begin
    IniKmp.WriteInteger('Preview', 'Left', self.Left);
    IniKmp.WriteInteger('Preview', 'Top', self.Top);
    IniKmp.WriteInteger('Preview', 'Width', self.Width);
    IniKmp.WriteInteger('Preview', 'Height', self.Height);
  end;
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
  filtLibEntry : TQRExportFilterLibraryEntry;
  sdialog : TSaveDialog;
  sext, savefile : string;
  findx : integer;
  I: integer;
  OldThousandSeparator: char;
begin
//QR5:
//  eventHandled := false;
//  if assigned(FParentReport.OnStandPrevEvent) then
//                 FParentReport.OnStandPrevEvent( self, spSave, 'Save',eventHandled);
//  if eventHandled then exit;

  // doppelt vorhandene schlechtere Filter nicht anbieten:
  for I := QRExportFilterLibrary.Filters.Count - 1 downto 0 do
  begin
    filtLibEntry := TQRExportFilterLibraryEntry(
              QRExportFilterLibrary.Filters[I]);
    if filtLibEntry.ExportFilterClass.ClassName = 'TQRHtmlExportFilter' then
      QRExportFilterLibrary.RemoveFilter(filtLibEntry.ExportFilterClass) else
    if filtLibEntry.ExportFilterClass.ClassName = 'TQRCSVExportFilter' then
      QRExportFilterLibrary.RemoveFilter(filtLibEntry.ExportFilterClass) else
  end;

  aExportFilter := nil;
  sdialog := TSaveDialog.Create(Application);
  try
//    try
      sdialog.Title := SaveReport.Hint;  //'Report speichern' SqrSaveReport;
      sdialog.Filter := QRExportFilterLibrary.SaveDialogFilterString;
      //sdialog.DefaultExt := QRSaveExtensions[FParentreport.PreviewDefaultSaveType];
      //schlecht sdialog.Filename := '*'+ QRSaveExtensions[FParentreport.PreviewDefaultSaveType];
      if not sdialog.Execute then exit;
      sext := ExtractFileExt( sdialog.FileName);
      savefile := sdialog.FileName;
      sext := upperCase( sext);
      // enforce an extension
      if sext = '' then
      begin
          findx := sdialog.FilterIndex-1;
          if findx = 0 then
             sext := 'QRP'
          else
          begin
           try
             sext := TQRExportFilterLibraryEntry( QRExportFilterLibrary.Filters[findx - 1]).Extension;
           except
             sext := QRSaveExtensions[FParentreport.PreviewDefaultSaveType]
           end;
          end;
          if sext[1] = '.' then sext := copy( sext, 2, 3 );
          savefile := savefile + '.' + sext;
      end;
      if sext[1] = '.' then sext := copy( sext, 2, 3 );
      if SameText(sext, 'QRP') then
      begin
        QRPrinter.Save(savefile);
        exit;
      end;
      filtLibEntry := QRExportFilterLibrary.GetFilterByExtension(sext);
      if filtLibEntry=nil then exit;
      try
        aExportFilter := filtLibEntry.ExportFilterClass.Create(savefile);
        OldThousandSeparator := FormatSettings.ThousandSeparator;
        try
          FormatSettings.ThousandSeparator := #0;  //Trick um Datum zu belassen
          if FParentreport.ParentComposite <> nil then
             TQRCompositeReport( FParentreport.ParentComposite).ExportToFilter(aExportFilter)
          else
             FParentreport.ExportToFilter(aExportFilter);
        finally
          FormatSettings.ThousandSeparator := OldThousandSeparator;
        end;

        if OpenAfterGenerate then
        begin
          SysParam.DisplayWinExecError := false;
          SysParam.ThrowWinExecError := true;
          if SameText(sext, 'XML') then
          begin
            //XML: Öffnen explizit mit Excel
            savefile := '"' + GetAppFromExtension('.xls') + '" "' + savefile + '"';
            WinExecNoWait(savefile, SW_SHOWNORMAL);
          end else
          begin
            if sext = 'WMF' then
            begin
              //WMF: hängt 001.. an Filenamen
              savefile := copy(savefile, 1, length(savefile) - 4) + '001.' + sext;
            end;
            ShellExecNoWait(savefile, SW_SHOWNORMAL);
          end;
        end;

      finally
        aExportFilter.Free
      end;
//    except on E:Exception do
//      EMess(self, E, LaSaveError.Caption, [savefile]);  //'Fehler beim Erstellen des Reports %s'
//    end;
  finally
    sdialog.Free;
  end;
end;

procedure TDlgQRPreview.PrintSetupClick(Sender: TObject);
var
   prep : TCustomquickrep;
   tagval : integer;
begin
//  tagval := 1; // default to cancel
//  prep := nil;
//MD todo:
//  eventHandled := false;
//  if assigned(FParentReport.OnStandPrevEvent) then
//                 FParentReport.OnStandPrevEvent( self, spPrintSetup, 'PrintSetup',eventHandled);
//  if eventHandled then exit;
 try
  //MD weg printer.Refresh;
  if TCustomquickrep( qrprinter.ParentReport).ParentComposite <> nil then
  begin
       prep := TCustomquickrep( qrprinter.ParentReport);
       TCustomQuickrep(QRPrinter.ParentReport).PrinterSetup;
       tagval := TCustomQuickrep(QRPrinter.ParentReport).tag;
       if tagval <> 0 then exit;
       qrprinter.PrinterIndex := prep.PrinterSettings.printerindex;
       // 8/02/05
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.PrinterIndex := prep.UserPrinterSettings.PrinterIndex;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.FirstPage :=
                                                    prep.UserPrinterSettings.FirstPage;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.LastPage :=
                                                    prep.UserPrinterSettings.LastPage;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.OutputBin := TQRBin(prep.UserPrinterSettings.CustomBinCode);
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.Collate := prep.UserPrinterSettings.Collate;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.ColorOption := prep.UserPrinterSettings.ColorOption;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.PrintQuality := prep.UserPrinterSettings.PrintQuality;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.Copies := prep.UserPrinterSettings.Copies;
       TQRCompositeReport( prep.ParentComposite).printerSettings.Duplex := prep.UserPrinterSettings.ExtendedDuplex = 1;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.CustomBinCode := prep.UserPrinterSettings.CustomBinCode;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.UseCustomBinCode := prep.PrinterSettings.UseCustomBinCode;
       TQRCompositeReport( prep.ParentComposite).PrinterSettings.Duplex := prep.UserPrinterSettings.Duplex;
       QRPrinter.aPrinterSettings.OutputBin := TQRBin(prep.UserPrinterSettings.CustomBinCode);
       QRPrinter.aPrinterSettings.Collate := prep.UserPrinterSettings.Collate;
       QRPrinter.aPrinterSettings.ColorOption := prep.UserPrinterSettings.ColorOption;
       QRPrinter.aPrinterSettings.PrintQuality := prep.UserPrinterSettings.PrintQuality;
       QRPrinter.aPrinterSettings.Copies := prep.UserPrinterSettings.Copies;
       QRPrinter.aPrinterSettings.Duplex := prep.UserPrinterSettings.ExtendedDuplex = 1;
       QRPrinter.aPrinterSettings.CustomBinCode := prep.UserPrinterSettings.CustomBinCode;
       QRPrinter.aPrinterSettings.UseCustomBinCode := prep.PrinterSettings.UseCustomBinCode;
       QRPrinter.LastPage := prep.UserPrinterSettings.LastPage;
       QRPrinter.FirstPage := prep.UserPrinterSettings.FirstPage;
       QRPrinter.aPrinterSettings.Duplex := prep.UserPrinterSettings.Duplex;
       QRPrinter.aPrinterSettings.ExtendedDuplex := prep.UserPrinterSettings.ExtendedDuplex;
       prep.UserPrinterSettings.UseExtendedDuplex :=  prep.UserPrinterSettings.ExtendedDuplex > 1;
       QRPrinter.aPrinterSettings.UseExtendedDuplex := prep.UserPrinterSettings.UseExtendedDuplex;
       exit;
  end;
  if qrprinter.ParentReport is TCustomquickrep then
  Begin
       TCustomQuickrep(QRPrinter.ParentReport).PrinterSetup;
       tagval := TCustomQuickrep(QRPrinter.ParentReport).tag;
       if tagval <> 0 then exit;
       prep := TCustomquickrep( qrprinter.ParentReport);
       qrprinter.PrinterIndex := prep.PrinterSettings.printerindex;
       if prep.UserPrinterSettings.CustomBinCode >= integer(Last) then
       begin
            QRPrinter.aPrinterSettings.UseCustomBinCode := true;
            QRPrinter.aPrinterSettings.CustomBinCode := prep.UserPrinterSettings.CustomBinCode;
       end
       else
       begin
            QRPrinter.aPrinterSettings.UseCustomBinCode := false;
            QRPrinter.aPrinterSettings.OutputBin := TQRBin(prep.UserPrinterSettings.CustomBinCode);
       end;
       QRPrinter.aPrinterSettings.Collate := prep.UserPrinterSettings.Collate;
       QRPrinter.aPrinterSettings.ColorOption := prep.UserPrinterSettings.ColorOption;
       QRPrinter.aPrinterSettings.PrintQuality := prep.UserPrinterSettings.PrintQuality;
       QRPrinter.aPrinterSettings.Copies := prep.UserPrinterSettings.Copies;
       QRPrinter.aPrinterSettings.Duplex := prep.UserPrinterSettings.ExtendedDuplex = 1;
       QRPrinter.LastPage := prep.UserPrinterSettings.LastPage;
       QRPrinter.FirstPage := prep.UserPrinterSettings.FirstPage;
       QRPrinter.aPrinterSettings.Duplex := prep.UserPrinterSettings.Duplex;
       prep.UserPrinterSettings.UseExtendedDuplex :=  prep.UserPrinterSettings.ExtendedDuplex > 1;
       QRPrinter.aPrinterSettings.ExtendedDuplex := prep.UserPrinterSettings.ExtendedDuplex;
       QRPrinter.aPrinterSettings.UseExtendedDuplex := prep.UserPrinterSettings.UseExtendedDuplex;
       if not PrintMetafileFromPreview then
       begin
           // set the quickrep settings
           if prep.UserPrinterSettings.CustomBinCode >= integer(Last) then
           begin
               prep.PrinterSettings.UseCustomBinCode := true;
               prep.PrinterSettings.CustomBinCode := prep.UserPrinterSettings.CustomBinCode;
           end
           else
           begin
               prep.PrinterSettings.UseCustomBinCode := false;
               prep.PrinterSettings.OutputBin := TQRBin(prep.UserPrinterSettings.CustomBinCode);
           end;
           prep.PrinterSettings.PrinterIndex := prep.UserPrinterSettings.PrinterIndex;
           prep.PrinterSettings.Copies := prep.UserPrinterSettings.Copies;
           prep.PrinterSettings.Duplex := prep.UserPrinterSettings.Duplex;
           prep.PrinterSettings.FirstPage := prep.UserPrinterSettings.FirstPage;
           prep.PrinterSettings.LastPage := prep.UserPrinterSettings.LastPage;
           prep.PrinterSettings.UseStandardprinter := prep.UserPrinterSettings.UseStandardprinter;
           prep.PrinterSettings.ExtendedDuplex := prep.UserPrinterSettings.ExtendedDuplex;
           prep.PrinterSettings.UseExtendedDuplex := prep.UserPrinterSettings.UseExtendedDuplex;
           prep.PrinterSettings.UseCustomPaperCode := prep.UserPrinterSettings.UseCustomPaperCode;
           prep.PrinterSettings.CustomPaperCode := prep.UserPrinterSettings.CustomPaperCode;
           prep.PrinterSettings.MemoryLimit := prep.UserPrinterSettings.MemoryLimit;
           prep.PrinterSettings.PrintQuality := prep.UserPrinterSettings.PrintQuality;
           prep.PrinterSettings.Collate := prep.UserPrinterSettings.Collate;
           prep.PrinterSettings.ColorOption := prep.UserPrinterSettings.ColorOption;
           prep.PrinterSettings.Orientation := prep.UserPrinterSettings.Orientation;
           prep.PrinterSettings.PaperSize := prep.UserPrinterSettings.PaperSize;
       end;
  end;
 if FParentReport is TCustomquickrep then
         if TCustomquickrep(FParentReport).PrintAfterSetup then
                              printClick(self);
 finally
 end;
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
        SaveReport.Enabled := true;
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
    SaveReport.Enabled := true;
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

{ TDlgQRPreviewInterface }

function TDlgQRPreviewInterface.Show(AQRPrinter: TQRPrinter): TWinControl;
begin
  if DlgQRPreview = nil then
  begin
    PollWait;                         {damit Polling nicht blockiert 210200 HDO}
    TDlgQRPreview.CreatePreview(Application, AQRPrinter);
    //DlgQRPreview.PrnSource := self;           {Verweis auf Aufrufer aufbauen}
    if GNavigator.PreviewForm is TQRepForm then
      DlgQRPreview.PrnSource := TQRepForm(GNavigator.PreviewForm).PrnSource;
  end;
  DlgQRPreview.Show;
  Result := DlgQRPreview;
end;

function TDlgQRPreviewInterface.ShowModal(AQRPrinter: TQRPrinter): TWinControl;
begin
  if DlgQRPreview = nil then
  begin
    PollWait;                         {damit Polling nicht blockiert 210200 HDO}
    TDlgQRPreview.CreatePreview(Application, AQRPrinter);
    //DlgQRPreview.PrnSource := self;           {Verweis auf Aufrufer aufbauen}
    if GNavigator.PreviewForm is TQRepForm then
      DlgQRPreview.PrnSource := TQRepForm(GNavigator.PreviewForm).PrnSource;
  end;
  DlgQRPreview.ShowModal;
  Result := DlgQRPreview;
end;

end.
