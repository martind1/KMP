object RepDflt: TRepDflt
  Left = 963
  Top = 552
  Width = 831
  Height = 558
  HorzScrollBar.Range = 1200
  VertScrollBar.Range = 2000
  Caption = 'Standard Liste'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object QuickReport: TQuickRep
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    BeforePrint = QuickReportBeforePrint
    DataSet = Query1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = []
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Continuous = False
    Page.Values = (
      150.000000000000000000
      2970.000000000000000000
      100.000000000000000000
      2100.000000000000000000
      150.000000000000000000
      100.000000000000000000
      0.000000000000000000)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = First
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrinterSettings.PrintQuality = 0
    PrinterSettings.Collate = 0
    PrinterSettings.ColorOption = 0
    PrintIfEmpty = False
    ReportTitle = 'Standard Liste'
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    PrevInitialZoom = qrZoomToFit
    PreviewDefaultSaveType = stQRP
    PreviewLeft = 0
    PreviewTop = 0
    object HdrText: TQRBand
      Left = 57
      Top = 38
      Width = 700
      Height = 64
      Frame.DrawBottom = True
      AfterPrint = HdrTextAfterPrint
      AlignToBottom = False
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        169.333333333333300000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbTitle
      object QRLaName: TQRLabel
        Left = 282
        Top = 21
        Width = 136
        Height = 23
        Size.Values = (
          60.854166666666670000
          746.125000000000000000
          55.562500000000000000
          359.833333333333300000)
        XLColumn = 0
        Alignment = taCenter
        AlignToBand = True
        Caption = 'Standard Liste'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 14
      end
      object QRImLogo: TQRImage
        Left = 623
        Top = 0
        Width = 62
        Height = 62
        Size.Values = (
          164.041666666667000000
          1648.354166666670000000
          0.000000000000000000
          164.041666666667000000)
        XLColumn = 0
        Stretch = True
      end
    end
    object FtrPage: TQRBand
      Left = 57
      Top = 262
      Width = 700
      Height = 24
      Frame.DrawTop = True
      AlignToBottom = False
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        63.500000000000000000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbPageFooter
      object QRLabel8: TQRLabel
        Left = 687
        Top = 5
        Width = 13
        Height = 17
        Size.Values = (
          44.979166666666670000
          1817.687500000000000000
          13.229166666666670000
          34.395833333333330000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        Caption = '...'
        Color = clWhite
        Transparent = False
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
    end
    object Line: TQRBand
      Left = 57
      Top = 163
      Width = 700
      Height = 17
      AlignToBottom = False
      BeforePrint = LineBeforePrint
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      LinkBand = ChildBand1
      Size.Values = (
        44.979166666666670000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbDetail
      object gtQRDBText1: TQRDBText
        Left = 72
        Top = 0
        Width = 81
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          190.500000000000000000
          0.000000000000000000
          214.312500000000000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        FontSize = 10
      end
    end
    object SumText: TQRBand
      Left = 57
      Top = 214
      Width = 700
      Height = 24
      Frame.DrawTop = True
      AlignToBottom = False
      BeforePrint = SumTextBeforePrint
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        63.500000000000000000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbSummary
      object QRSysData2: TQRSysData
        Left = 2
        Top = 2
        Width = 126
        Height = 17
        Size.Values = (
          44.979166666666670000
          5.291666666666667000
          5.291666666666667000
          333.375000000000000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Color = clWhite
        Data = qrsDetailCount
        OnPrint = QRSysData2Print
        Text = 'Anzahl: '
        Transparent = True
        ExportAs = exptText
        FontSize = 10
      end
      object ExprSum1: TQRExpr
        Left = 126
        Top = 2
        Width = 83
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666700000
          333.375000000000000000
          5.291666666666670000
          219.604166666667000000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        Mask = '#,##0.00'
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object LaSum1: TQRLabel
        Left = 212
        Top = 2
        Width = 49
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          560.916666666666700000
          5.291666666666667000
          129.645833333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'LaSum1'
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object LaSum2: TQRLabel
        Left = 348
        Top = 2
        Width = 49
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          920.750000000000000000
          5.291666666666667000
          129.645833333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'LaSum2'
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object ExprSum2: TQRExpr
        Left = 262
        Top = 2
        Width = 83
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666700000
          693.208333333333000000
          5.291666666666670000
          219.604166666667000000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        Mask = '#,##0.00'
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object LaSum3: TQRLabel
        Left = 484
        Top = 2
        Width = 49
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          1280.583333333333000000
          5.291666666666667000
          129.645833333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'LaSum3'
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object ExprSum3: TQRExpr
        Left = 398
        Top = 2
        Width = 83
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666700000
          1053.041666666670000000
          5.291666666666670000
          219.604166666667000000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        Mask = '#,##0.00'
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object LaSum4: TQRLabel
        Left = 620
        Top = 2
        Width = 49
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          1640.416666666667000000
          5.291666666666667000
          129.645833333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'LaSum4'
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object ExprSum4: TQRExpr
        Left = 534
        Top = 2
        Width = 83
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666700000
          1412.875000000000000000
          5.291666666666670000
          219.604166666667000000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        Mask = '#,##0.00'
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
    end
    object HdrCol: TQRBand
      Left = 57
      Top = 102
      Width = 700
      Height = 40
      AlignToBottom = False
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333300000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbColumnHeader
      object QRDateTime: TQRSysData
        Left = 384
        Top = 2
        Width = 316
        Height = 17
        Size.Values = (
          44.979166666666670000
          1016.000000000000000000
          5.291666666666667000
          836.083333333333300000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        AutoSize = False
        Color = clWhite
        Data = qrsDateTime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        OnPrint = QRDateTimePrint
        ParentFont = False
        Text = 'Erstellt von %s am '
        Transparent = False
        ExportAs = exptText
        FontSize = 10
      end
      object QRSysData1: TQRSysData
        Left = 0
        Top = 2
        Width = 94
        Height = 20
        Size.Values = (
          52.916666666666670000
          0.000000000000000000
          5.291666666666667000
          248.708333333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = True
        Color = clWhite
        Data = qrsReportTitle
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        FontSize = 12
      end
      object LaCaption: TQRLabel
        Left = 0
        Top = 20
        Width = 601
        Height = 19
        Size.Values = (
          50.270833333333300000
          0.000000000000000000
          52.916666666666700000
          1590.145833333330000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'LaCaption'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        OnPrint = LaCaptionPrint
        ParentFont = False
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 12
      end
      object PageNumber: TQRSysData
        Left = 620
        Top = 20
        Width = 80
        Height = 18
        Size.Values = (
          47.625000000000000000
          1640.416666666667000000
          52.916666666666670000
          211.666666666666700000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        Color = clWhite
        Data = qrsPageNumber
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Text = 'Seite '
        Transparent = True
        ExportAs = exptText
        FontSize = 10
      end
    end
    object ChildCol: TQRChildBand
      Left = 57
      Top = 142
      Width = 700
      Height = 21
      Frame.DrawTop = True
      Frame.DrawBottom = True
      Frame.DrawLeft = True
      Frame.DrawRight = True
      AlignToBottom = False
      Color = clSilver
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        55.562500000000000000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      ParentBand = HdrCol
      PrintOrder = cboAfterParent
    end
    object FtrText: TQRChildBand
      Left = 57
      Top = 238
      Width = 700
      Height = 24
      Frame.DrawTop = True
      AlignToBottom = False
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        63.500000000000000000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      ParentBand = SumText
      PrintOrder = cboAfterParent
      object QRLabel3: TQRLabel
        Left = 610
        Top = 5
        Width = 90
        Height = 17
        Size.Values = (
          44.979166666666670000
          1613.958333333333000000
          13.229166666666670000
          238.125000000000000000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        Caption = 'Ausdruck Ende'
        Color = clWhite
        Transparent = False
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
    end
    object ChildBand1: TQRChildBand
      Left = 57
      Top = 180
      Width = 700
      Height = 34
      AlignToBottom = False
      BeforePrint = ChildBand1BeforePrint
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        89.958333333333330000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      ParentBand = Line
      PrintOrder = cboAfterParent
      object LaBemerkung: TQRLabel
        Left = 0
        Top = 0
        Width = 67
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          0.000000000000000000
          0.000000000000000000
          177.270833333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'Bemerkung'
        Color = clWhite
        Transparent = False
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 10
      end
      object EdBemerkung: TQRDBText
        Left = 72
        Top = 0
        Width = 617
        Height = 17
        Enabled = False
        Size.Values = (
          44.979166666666670000
          190.500000000000000000
          0.000000000000000000
          1632.479166666667000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        Transparent = True
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FullJustify = False
        MaxBreakChars = 0
        FontSize = 10
      end
    end
  end
  object Nav: TLNavigator
    FormKurz = 'DFLT'
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = 'etc.'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = DataSource1
    EditSource = DataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 408
    Top = 400
  end
  object DataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 376
    Top = 400
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'InterBase.FetchAll=False'
      'SQL Server.FetchAll=False'
      'Oracle.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 344
    Top = 400
  end
end
