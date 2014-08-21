object RepDfltC: TRepDfltC
  Left = 668
  Top = 250
  Width = 797
  Height = 562
  HorzScrollBar.Position = 24
  HorzScrollBar.Range = 1200
  VertScrollBar.Range = 2000
  Caption = 'Standard Liste (Cols)'
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
    Left = -24
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
      100.000000000000000000
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
      object QRImLogo: TQRImage
        Left = 623
        Top = 0
        Width = 62
        Height = 62
        Size.Values = (
          164.041666666666700000
          1648.354166666667000000
          0.000000000000000000
          164.041666666666700000)
        XLColumn = 0
        Stretch = True
      end
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
    end
    object FtrPage: TQRBand
      Left = 57
      Top = 252
      Width = 700
      Height = 85
      Frame.DrawTop = True
      AlignToBottom = False
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        224.895833333333300000
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
      Color = clWhite
      TransparentBand = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.979166666666670000
        1852.083333333333000000)
      PreCaluculateBandHeight = False
      KeepOnOnePage = False
      BandType = rbDetail
    end
    object SumText: TQRBand
      Left = 57
      Top = 180
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
        Top = 4
        Width = 126
        Height = 17
        Size.Values = (
          44.979166666666670000
          5.291666666666667000
          10.583333333333330000
          333.375000000000000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Color = clWhite
        Data = qrsDetailCount
        Text = 'Anzahl: '
        Transparent = True
        ExportAs = exptText
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
      object PageNumber: TQRSysData
        Left = 620
        Top = 22
        Width = 80
        Height = 17
        Size.Values = (
          44.979166666666670000
          1640.416666666667000000
          58.208333333333330000
          211.666666666666700000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        Color = clWhite
        Data = qrsPageNumber
        Text = 'Seite '
        Transparent = False
        ExportAs = exptText
        FontSize = 10
      end
      object QRDateTime: TQRSysData
        Left = 515
        Top = 2
        Width = 185
        Height = 17
        Size.Values = (
          44.979166666666670000
          1362.604166666667000000
          5.291666666666667000
          489.479166666666700000)
        XLColumn = 0
        Alignment = taRightJustify
        AlignToBand = True
        Color = clWhite
        Data = qrsDateTime
        OnPrint = QRDateTimePrint
        Text = 'Erstellt von %s am  '
        Transparent = False
        ExportAs = exptText
        FontSize = 10
      end
      object QRSysData1: TQRSysData
        Left = 0
        Top = 0
        Width = 94
        Height = 20
        Size.Values = (
          52.916666666666670000
          0.000000000000000000
          0.000000000000000000
          248.708333333333300000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Color = clWhite
        Data = qrsReportTitle
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        ExportAs = exptText
        FontSize = 12
      end
      object LaCaption: TQRLabel
        Left = 0
        Top = 20
        Width = 74
        Height = 19
        Size.Values = (
          50.270833333333330000
          0.000000000000000000
          52.916666666666670000
          195.791666666666700000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        Caption = 'LaCaption'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        OnPrint = LaCaptionPrint
        ParentFont = False
        Transparent = False
        ExportAs = exptText
        WrapStyle = BreakOnSpaces
        FontSize = 12
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
    object Bemerkung: TQRChildBand
      Left = 57
      Top = 204
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
      object QRMemo1: TQRMemo
        Left = 2
        Top = 4
        Width = 687
        Height = 17
        Size.Values = (
          44.979166666666700000
          5.291666666666670000
          10.583333333333300000
          1817.687500000000000000)
        XLColumn = 0
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        Transparent = False
        FullJustify = False
        MaxBreakChars = 0
        FontSize = 10
      end
    end
    object FtrText: TQRChildBand
      Left = 57
      Top = 228
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
      ParentBand = Bemerkung
      PrintOrder = cboAfterParent
      object laAusdruckEnde: TQRLabel
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
  end
  object Nav: TLNavigator
    FormKurz = 'DFLTC'
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
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 344
    Top = 400
  end
  object DataSource1: TuDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 376
    Top = 400
  end
end
