object RepWGZ: TRepWGZ
  Left = 283
  Top = 171
  Width = 805
  Height = 584
  HorzScrollBar.Range = 1200
  VertScrollBar.Position = 152
  VertScrollBar.Range = 2000
  AutoScroll = False
  Caption = 'Waggonzettel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object QuickReport: TQuickRep
    Left = 0
    Top = -152
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
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
    Page.Values = (
      100
      2970
      100
      2100
      300
      100
      0)
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
    PrintIfEmpty = False
    ReportTitle = 'Ladeschein'
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object HdrCol: TQRBand
      Left = 113
      Top = 38
      Width = 643
      Height = 41
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = HdrColBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        108.479166666667
        1701.27083333333)
      BandType = rbColumnHeader
      object QRSysData1: TQRSysData
        Left = 1
        Top = 0
        Width = 94
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          2.64583333333333
          0
          248.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsReportTitle
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        FontSize = 12
      end
      object QRDateTime: TQRSysData
        Left = 446
        Top = 0
        Width = 197
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1180.04166666667
          0
          521.229166666667)
        Alignment = taRightJustify
        AlignToBand = True
        AutoSize = True
        Color = clWhite
        Data = qrsDateTime
        OnPrint = QRDateTimePrint
        Text = 'Gedruckt von %s am  '
        Transparent = False
        FontSize = 10
      end
      object PageNumber: TQRSysData
        Left = 563
        Top = 20
        Width = 80
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1489.60416666667
          52.9166666666667
          211.666666666667)
        Alignment = taRightJustify
        AlignToBand = True
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Text = 'Seite '
        Transparent = False
        FontSize = 10
      end
      object LaCaption: TQRLabel
        Left = 269
        Top = 20
        Width = 74
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          711.729166666667
          52.9166666666667
          195.791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
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
        WordWrap = True
        FontSize = 12
      end
      object QRLabel19: TQRLabel
        Left = 0
        Top = 20
        Width = 38
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          0
          52.9166666666667
          100.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Werk'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 12
      end
      object QRDBText28: TQRDBText
        Left = 46
        Top = 20
        Width = 104
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          121.708333333333
          52.9166666666667
          275.166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'WERK_NAME'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 12
      end
    end
    object SummaryBand1: TQRBand
      Left = 113
      Top = 528
      Width = 643
      Height = 113
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = SummaryBand1BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        298.979166666667
        1701.27083333333)
      BandType = rbSummary
      object QRLabel23: TQRLabel
        Left = 0
        Top = 72
        Width = 135
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          190.5
          357.1875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Absackdatum / Name'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel24: TQRLabel
        Left = 176
        Top = 72
        Width = 126
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          465.666666666667
          190.5
          333.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'geladen am / Name'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel25: TQRLabel
        Left = 344
        Top = 72
        Width = 109
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          910.166666666667
          190.5
          288.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'gewogen / Name'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel26: TQRLabel
        Left = 520
        Top = 72
        Width = 110
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1375.83333333333
          190.5
          291.041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'zul. Ladegewicht'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel34: TQRLabel
        Left = 0
        Top = 4
        Width = 135
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          0
          10.5833333333333
          357.1875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Gewichtswert'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 16
      end
      object QRDBText9: TQRDBText
        Left = 152
        Top = 8
        Width = 92
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          402.166666666667
          21.1666666666667
          243.416666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'VERS_MENGE'
        Mask = '0.00 t Netto'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel35: TQRLabel
        Left = 280
        Top = 8
        Width = 81
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          740.833333333333
          21.1666666666667
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Eichnummer'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object laEichNr: TQRLabel
        Left = 376
        Top = 10
        Width = 43
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          994.833333333333
          26.4583333333333
          113.770833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '000000'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
    end
    object ChildBand1: TQRChildBand
      Left = 113
      Top = 79
      Width = 643
      Height = 296
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = ChildBand1BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        783.166666666667
        1701.27083333333)
      ParentBand = HdrCol
      object QRLabel6: TQRLabel
        Left = 0
        Top = 16
        Width = 107
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          42.3333333333333
          283.104166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Versandanschrift'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText21: TQRDBText
        Left = 0
        Top = 32
        Width = 93
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          84.6666666666667
          246.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNW_NAME1'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText22: TQRDBText
        Left = 0
        Top = 48
        Width = 93
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          127
          246.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNW_NAME2'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText23: TQRDBText
        Left = 0
        Top = 64
        Width = 93
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          169.333333333333
          246.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNW_NAME3'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText24: TQRDBText
        Left = 0
        Top = 80
        Width = 109
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          211.666666666667
          288.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNW_STRASSE'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRExpr1: TQRExpr
        Left = 0
        Top = 96
        Width = 265
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          254
          701.145833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        WordWrap = False
        Expression = 
          'TblAufk.KUNW_LAND + '#39' '#39' + TblAufk.KUNW_PLZ + '#39' '#39' + TblAufk.KUNW_' +
          'ORT'
        FontSize = 10
      end
      object QRLabel3: TQRLabel
        Left = 0
        Top = 128
        Width = 80
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          338.666666666667
          211.666666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Abladestelle'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText5: TQRDBText
        Left = 129
        Top = 128
        Width = 101
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          341.3125
          338.666666666667
          267.229166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'ABLADESTELLE'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel7: TQRLabel
        Left = 0
        Top = 160
        Width = 112
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          423.333333333333
          296.333333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Station/Spediteur'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel8: TQRLabel
        Left = 0
        Top = 192
        Width = 84
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          508
          222.25)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Auftraggeber'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText10: TQRDBText
        Left = 0
        Top = 208
        Width = 89
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          550.333333333333
          235.479166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNR_NAME1'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText11: TQRDBText
        Left = 0
        Top = 224
        Width = 89
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          592.666666666667
          235.479166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNR_NAME2'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText12: TQRDBText
        Left = 0
        Top = 240
        Width = 89
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          635
          235.479166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNR_NAME3'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText13: TQRDBText
        Left = 0
        Top = 256
        Width = 105
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          677.333333333333
          277.8125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNR_STRASSE'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRExpr2: TQRExpr
        Left = 0
        Top = 272
        Width = 265
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          719.666666666667
          701.145833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = True
        WordWrap = False
        Expression = 
          'TblAufk.KUNR_LAND + '#39' '#39' + TblAufk.KUNR_PLZ + '#39' '#39' + TblAufk.KUNR_' +
          'ORT'
        FontSize = 10
      end
      object QRLabel9: TQRLabel
        Left = 336
        Top = 40
        Width = 62
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          105.833333333333
          164.041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Auftrag-Nr.:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText14: TQRDBText
        Left = 456
        Top = 40
        Width = 61
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          105.833333333333
          161.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'AUFK_NR'
        OnPrint = TrimL0Print
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText15: TQRDBText
        Left = 456
        Top = 56
        Width = 66
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          148.166666666667
          174.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'KUNW_NR'
        OnPrint = TrimL0Print
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel10: TQRLabel
        Left = 336
        Top = 56
        Width = 67
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          148.166666666667
          177.270833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Kunden-Nr.:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText16: TQRDBText
        Left = 456
        Top = 72
        Width = 119
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          190.5
          314.854166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'SACHBEARBEITER'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel11: TQRLabel
        Left = 336
        Top = 72
        Width = 61
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          190.5
          161.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Bearbeiter:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel12: TQRLabel
        Left = 336
        Top = 100
        Width = 77
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          264.583333333333
          203.729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Bestelldatum:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText17: TQRDBText
        Left = 456
        Top = 100
        Width = 103
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          264.583333333333
          272.520833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'BESTELLDATUM'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText18: TQRDBText
        Left = 456
        Top = 116
        Width = 116
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          306.916666666667
          306.916666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'BESTELLNUMMER'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel13: TQRLabel
        Left = 336
        Top = 116
        Width = 62
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          306.916666666667
          164.041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Bestell-Nr.:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel27: TQRLabel
        Left = 336
        Top = 16
        Width = 100
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          42.3333333333333
          264.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Ladeschein-Nr.:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText29: TQRDBText
        Left = 456
        Top = 16
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          42.3333333333333
          185.208333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'LASCH_NR'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText19: TQRDBText
        Left = 456
        Top = 144
        Width = 128
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          381
          338.666666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'TRANSPORTMITTEL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel14: TQRLabel
        Left = 336
        Top = 144
        Width = 103
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          381
          272.520833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'LKW-/Waggon-Nr.:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel4: TQRLabel
        Left = 336
        Top = 160
        Width = 106
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          423.333333333333
          280.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'LKW-/Waggon-Typ:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText7: TQRDBText
        Left = 456
        Top = 160
        Width = 87
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          423.333333333333
          230.1875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'WAGGONTYP'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText20: TQRDBText
        Left = 456
        Top = 200
        Width = 133
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          529.166666666667
          351.895833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'LIEFERKONDITIONEN'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel15: TQRLabel
        Left = 336
        Top = 200
        Width = 94
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          529.166666666667
          248.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Lieferbedingung:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel16: TQRLabel
        Left = 336
        Top = 216
        Width = 93
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          571.5
          246.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Route/Spediteur:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel17: TQRLabel
        Left = 336
        Top = 240
        Width = 80
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          635
          211.666666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Versandstelle:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText25: TQRDBText
        Left = 456
        Top = 240
        Width = 90
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          635
          238.125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'cfBELS_NAME'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel18: TQRLabel
        Left = 336
        Top = 272
        Width = 78
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          719.666666666667
          206.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Auslieferwerk:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText26: TQRDBText
        Left = 456
        Top = 272
        Width = 86
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          719.666666666667
          227.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufk
        DataField = 'WERK_NAME'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText6: TQRDBText
        Left = 456
        Top = 216
        Width = 74
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          571.5
          195.791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'BAHNCODE'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel31: TQRLabel
        Left = 336
        Top = 256
        Width = 73
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          677.333333333333
          193.145833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Lager / Bütte:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRLabel32: TQRLabel
        Left = 336
        Top = 176
        Width = 71
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          889
          465.666666666667
          187.854166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Leergewicht:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object QRDBText32: TQRDBText
        Left = 456
        Top = 176
        Width = 112
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          465.666666666667
          296.333333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = Query1
        DataField = 'cfLEER_GEWICHT'
        Mask = '#,##0.000;;#'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRExpr3: TQRExpr
        Left = 129
        Top = 160
        Width = 200
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          92.6041666666667
          341.3125
          423.333333333333
          529.166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'Query1.BAHNSTATION + '#39' '#39' + Query1.SPEDITION'
        FontSize = 10
      end
      object laABHOLLAGER: TQRLabel
        Left = 456
        Top = 256
        Width = 99
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1206.5
          677.333333333333
          261.9375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'laABHOLLAGER'
        Color = clWhite
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object ChildBand2: TQRChildBand
      Left = 113
      Top = 375
      Width = 643
      Height = 42
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        111.125
        1701.27083333333)
      ParentBand = ChildBand1
      object QRLabel1: TQRLabel
        Left = 0
        Top = 4
        Width = 24
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          10.5833333333333
          63.5)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Pos'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel2: TQRLabel
        Left = 522
        Top = 4
        Width = 40
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1381.125
          10.5833333333333
          105.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Menge'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel5: TQRLabel
        Left = 600
        Top = 4
        Width = 21
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1587.5
          10.5833333333333
          55.5625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ME'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel20: TQRLabel
        Left = 43
        Top = 4
        Width = 38
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          10.5833333333333
          100.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Artikel'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel21: TQRLabel
        Left = 181
        Top = 4
        Width = 119
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          478.895833333333
          10.5833333333333
          314.854166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Produktbezeichnung'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel22: TQRLabel
        Left = 43
        Top = 20
        Width = 65
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          52.9166666666667
          171.979166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Ladetermin'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRSubDetail1: TQRSubDetail
      Left = 113
      Top = 417
      Width = 643
      Height = 44
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AfterPrint = QRSubDetail1AfterPrint
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      LinkBand = ProdHinweis
      Size.Values = (
        116.416666666667
        1701.27083333333)
      Master = QuickReport
      DataSet = TblAufp
      PrintBefore = False
      PrintIfEmpty = True
      object QRDBText1: TQRDBText
        Left = 0
        Top = 4
        Width = 29
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          0
          10.5833333333333
          76.7291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'AUFP_NR'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText2: TQRDBText
        Left = 43
        Top = 4
        Width = 80
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          10.5833333333333
          211.666666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'MARA_KURZ'
        OnPrint = TrimL0Print
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText3: TQRDBText
        Left = 181
        Top = 4
        Width = 340
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          89.9583333333333
          478.895833333333
          10.5833333333333
          899.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'MARA_NAME'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText4: TQRDBText
        Left = 43
        Top = 20
        Width = 83
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          52.9166666666667
          219.604166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'DISP_DATUM'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText8: TQRDBText
        Left = 536
        Top = 4
        Width = 50
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1418.16666666667
          10.5833333333333
          132.291666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'cfMenge'
        Mask = '#,##0.000'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRDBText27: TQRDBText
        Left = 600
        Top = 4
        Width = 117
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1587.5
          10.5833333333333
          309.5625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = TblAufp
        DataField = 'GEWICHT_EINHEIT'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object ProdHinweis: TQRChildBand
      Left = 113
      Top = 461
      Width = 643
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = ProdHinweisBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      LinkBand = VersHinweis
      Size.Values = (
        44.9791666666667
        1701.27083333333)
      ParentBand = QRSubDetail1
      object QRLabel28: TQRLabel
        Left = 43
        Top = 0
        Width = 78
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          0
          206.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Prod.Hinweis:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object edProdHinweis: TQRDBText
        Left = 141
        Top = 0
        Width = 83
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          373.0625
          0
          219.604166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = True
        Color = clWhite
        DataSet = TblAufp
        DataField = 'cfProdHinweis'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object VersHinweis: TQRChildBand
      Left = 113
      Top = 478
      Width = 643
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = VersHinweisBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      LinkBand = Werksattest
      Size.Values = (
        44.9791666666667
        1701.27083333333)
      ParentBand = ProdHinweis
      object QRLabel29: TQRLabel
        Left = 43
        Top = 0
        Width = 77
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          0
          203.729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Vers.Hinweis:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object edVersHinweis: TQRDBText
        Left = 141
        Top = 0
        Width = 83
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          373.0625
          0
          219.604166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = True
        Color = clWhite
        DataSet = TblAufp
        DataField = 'cfVersHinweis'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object Werksattest: TQRChildBand
      Left = 113
      Top = 495
      Width = 643
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = WerksattestBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        1701.27083333333)
      ParentBand = VersHinweis
      object QRLabel33: TQRLabel
        Left = 43
        Top = 0
        Width = 69
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          113.770833333333
          0
          182.5625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Werksattest:'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object edWerksattest: TQRDBText
        Left = 141
        Top = 0
        Width = 82
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          373.0625
          0
          216.958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = True
        Color = clWhite
        DataSet = TblAufp
        DataField = 'cfWerksattest'
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object PageFooterBand1: TQRBand
      Left = 113
      Top = 641
      Width = 643
      Height = 40
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = True
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        105.833333333333
        1701.27083333333)
      BandType = rbPageFooter
      object QRLabel30: TQRLabel
        Left = 630
        Top = 8
        Width = 13
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1666.875
          21.1666666666667
          34.3958333333333)
        Alignment = taRightJustify
        AlignToBand = True
        AutoSize = True
        AutoStretch = False
        Caption = '...'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
    object ChildSub: TQRChildBand
      Left = 113
      Top = 512
      Width = 643
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        42.3333333333333
        1701.27083333333)
      ParentBand = Werksattest
    end
  end
  object Nav: TLNavigator
    FormKurz = 'LASCH'
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = '&etc.'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDatasource1
    EditSource = LDatasource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    CalcList.Strings = (
      'cfRESTMENGE=float:2'
      'cfBELS_NAME=lookup:LuBels;BELS_NAME'
      'cfLEER_GEWICHT=float:2')
    FormatList.Strings = (
      'DISP_DATUM=r,DDD, DD.MM.YY'
      'AUFK_NR=INT,TL0,'
      'MARA_NR=TL0,'
      'AKTIV=Asw,JNX'
      'GANZZUG=Asw,JNX'
      'VORLADEN=Asw,JNX'
      'PR_GESEHEN=Asw,JNX'
      'PR_QUITTIERT=Asw,JNX'
      'PR_GESPERRT=Asw,JNX'
      'LAB_GESPERRT=Asw,JNX'
      'LAB_QUITTIERT=Asw,JNX'
      'LAB_FREIG_ERF=Asw,JNX'
      'LAB_VERSANDT=Asw,JNX'
      'LADE_GEWICHT=#,##0.000;;#'
      'DISP_MENGE=#,##0.000'
      'REST_MENGE=#,##0.000'
      'BUCH_MENGE=#,##0.000'
      'VERS_MENGE=#,##0.000')
    KeyList.Strings = (
      'Nummer=WERK_NR'
      'Name=WERK_NAME')
    PrimaryKeyFields = 'DISP_ID'
    SqlFieldList.Strings = (
      'WERK_NR'
      'DISP_DATUM'
      'AKTIV'
      'PR_QUITTIERT'
      'ZUTY_NR'
      'DISP_ZEIT'
      'DISP_POS'
      'VERSANDART_TYP'
      'BELS_NR'
      'BELS_GRUPPE'
      'VERKAUFSBUERO'
      'SACHBEARBEITER'
      'BAHNSTATION'
      'MARA_NR'
      'MARA_NAME'
      'WAGGONTYP'
      'LADE_GEWICHT'
      'DISP_MENGE'
      'DISP_ANZAHL'
      'VORLADEN'
      'GANZZUG'
      'LAGERORT'
      'LAGER_FACH'
      'GEWICHT_EINHEIT'
      'AUFK_NR'
      'AUFP_NR'
      'VERS_MENGE'
      'VERS_ANZAHL'
      'BUCH_MENGE'
      'REST_MENGE'
      'REST_ANZAHL'
      'PRST_NR'
      'PRST_ID'
      'AUFK_ID'
      'AUFP_ID'
      'ZUST_ID'
      'DISP_ID'
      'ABHOLLAGER'
      'BUETTE'
      'PROD_DATUM'
      'LASCH_NR'
      'PR_GESPERRT'
      'LAB_GESPERRT'
      'TRANSPORTMITTEL'
      'LEER_GEWICHT'
      'TARA_GEWICHT'
      'BRUTTO_GEWICHT'
      'GATTUNG'
      'LFSK_ID'
      'LFSP_ID'
      'LFSK_NR'
      'LAB_QUITTIERT'
      'LAB_QUITT_VON'
      'LABSCH_NR'
      'PR_GESEHEN'
      'LAB_VERSANDT'
      'LAB_FREIG_ERF'
      'PRD_HIERARCH_KEY'
      'ABLADESTELLE'
      'BAHNCODE'
      'WERKSATTEST'
      'PRD_HIERARCH_TEXT'
      'AE_NR'
      'BESTELLNUMMER'
      'SPEDITION')
    TableName = 'DISPOSITIONEN'
    TabTitel = 'Dispositionen'
    OnGet = NavGet
    Top = 44
  end
  object LDatasource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Top = 76
  end
    object Query1: TuQuery
    BeforeScroll = Query1BeforeScroll
    SQL.Strings = (
            'select WERK_NR,'
            '       DISP_DATUM,'
            '       AKTIV,'
            '       PR_QUITTIERT,'
            '       ZUTY_NR,'
            '       DISP_ZEIT,'
            '       DISP_POS,'
            '       VERSANDART_TYP,'
            '       BELS_NR,'
            '       BELS_GRUPPE,'
            '       VERKAUFSBUERO,'
            '       SACHBEARBEITER,'
            '       BAHNSTATION,'
            '       MARA_NR,'
            '       MARA_NAME,'
            '       WAGGONTYP,'
            '       LADE_GEWICHT,'
            '       DISP_MENGE,'
            '       DISP_ANZAHL,'
            '       VORLADEN,'
            '       GANZZUG,'
            '       LAGERORT,'
            '       LAGER_FACH,'
            '       GEWICHT_EINHEIT,'
            '       AUFK_NR,'
            '       AUFP_NR,'
            '       VERS_MENGE,'
            '       VERS_ANZAHL,'
            '       BUCH_MENGE,'
            '       REST_MENGE,'
            '       REST_ANZAHL,'
            '       PRST_NR,'
            '       PRST_ID,'
            '       AUFK_ID,'
            '       AUFP_ID,'
            '       ZUST_ID,'
            '       DISP_ID,'
            '       ABHOLLAGER,'
            '       BUETTE,'
            '       PROD_DATUM,'
            '       LASCH_NR,'
            '       PR_GESPERRT,'
            '       LAB_GESPERRT,'
            '       TRANSPORTMITTEL,'
            '       LEER_GEWICHT,'
            '       TARA_GEWICHT,'
            '       BRUTTO_GEWICHT,'
            '       GATTUNG,'
            '       LFSK_ID,'
            '       LFSP_ID,'
            '       LFSK_NR,'
            '       LAB_QUITTIERT,'
            '       LAB_QUITT_VON,'
            '       LABSCH_NR,'
            '       PR_GESEHEN,'
            '       LAB_VERSANDT,'
            '       LAB_FREIG_ERF,'
            '       PRD_HIERARCH_KEY,'
            '       ABLADESTELLE,'
            '       BAHNCODE,'
            '       WERKSATTEST,'
            '       PRD_HIERARCH_TEXT,'
            '       AE_NR,'
            '       BESTELLNUMMER,'
            '       SPEDITION'
            'from DISP')
    Top = 108
  end
object LuAufk: TLookUpDef
    DataSet = TblAufk
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FormatList.Strings = (
      'KUNR_NR=INT,TL0,'
      'KUNW_NR=INT,TL0,')
    PrimaryKeyFields = 'AUFK_ID'
    References.Strings = (
      'AUFK_ID=:AUFK_ID')
    SqlFieldList.Strings = (
      'AUFK_ID'
      'AUFK_NR'
      'WERK_NR'
      'WERK_NAME'
      'SPRACHE'
      'BESTELLDATUM'
      'LIEFERKONDITIONEN'
      'BESTELLZEICHEN'
      'BESTELLNUMMER'
      'BAHNSTATION'
      'VERSANDWEG'
      'VERSANDBEZEICHNUNG'
      'VERSANDART_TYP'
      'LIEFERTEXT'
      'LIEFERANT_NAME_1'
      'ANZAHL_LIEFERSCHEINE'
      'BELADESCHEIN_NR'
      'KUNW_NR'
      'KUNW_MATCH'
      'KUNW_NAME1'
      'KUNW_NAME2'
      'KUNW_NAME3'
      'KUNW_STRASSE'
      'KUNW_LAND'
      'KUNW_PLZ'
      'KUNW_ORT'
      'KUNR_NR'
      'KUNR_MATCH'
      'KUNR_NAME1'
      'KUNR_NAME2'
      'KUNR_NAME3'
      'KUNR_STRASSE'
      'KUNR_LAND'
      'KUNR_PLZ'
      'KUNR_ORT'
      'INFO_1'
      'SPEDITION'
      'STATUS'
      'ABRUFCODE'
      'NEUER_AUFTRAG'
      'LUFTAUFTRAG'
      'VORLAGE'
      'GEAENDERTER_AUFTRAG'
      'GESPERRT'
      'BESTELLMENGE'
      'RESTMENGE'
      'VERKAUFSBUERO'
      'SACHBEARBEITER'
      'ABLADESTELLE'
      'BAHNCODE'
      'WERKSATTEST')
    TableName = 'AUFTRAGS_KOEPFE'
    MasterSource = LDatasource1
    DisabledButtons = []
    EnabledButtons = []
    Top = 168
  end
    object TblAufk: TuQuery
    MasterSource = LDatasource1
    SQL.Strings = (
            'select AUFK_ID,'
            '       AUFK_NR,'
            '       WERK_NR,'
            '       WERK_NAME,'
            '       SPRACHE,'
            '       BESTELLDATUM,'
            '       LIEFERKONDITIONEN,'
            '       BESTELLZEICHEN,'
            '       BESTELLNUMMER,'
            '       BAHNSTATION,'
            '       VERSANDWEG,'
            '       VERSANDBEZEICHNUNG,'
            '       VERSANDART_TYP,'
            '       LIEFERTEXT,'
            '       LIEFERANT_NAME_1,'
            '       ANZAHL_LIEFERSCHEINE,'
            '       BELADESCHEIN_NR,'
            '       KUNW_NR,'
            '       KUNW_MATCH,'
            '       KUNW_NAME1,'
            '       KUNW_NAME2,'
            '       KUNW_NAME3,'
            '       KUNW_STRASSE,'
            '       KUNW_LAND,'
            '       KUNW_PLZ,'
            '       KUNW_ORT,'
            '       KUNR_NR,'
            '       KUNR_MATCH,'
            '       KUNR_NAME1,'
            '       KUNR_NAME2,'
            '       KUNR_NAME3,'
            '       KUNR_STRASSE,'
            '       KUNR_LAND,'
            '       KUNR_PLZ,'
            '       KUNR_ORT,'
            '       INFO_1,'
            '       SPEDITION,'
            '       STATUS,'
            '       ABRUFCODE,'
            '       NEUER_AUFTRAG,'
            '       LUFTAUFTRAG,'
            '       VORLAGE,'
            '       GEAENDERTER_AUFTRAG,'
            '       GESPERRT,'
            '       BESTELLMENGE,'
            '       RESTMENGE,'
            '       VERKAUFSBUERO,'
            '       SACHBEARBEITER,'
            '       ABLADESTELLE,'
            '       BAHNCODE,'
            '       WERKSATTEST'
            'from AUFTRAGS_KOEPFE'
            'where (AUFK_ID = :AUFK_ID)')
    Top = 196
    ParamData = <
            item
              DataType = ftFloat
              Name = 'AUFK_ID'
              ParamType = ptUnknown
            end>
  end
object LuAufp: TLookUpDef
    DataSet = TblAufp
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    CalcList.Strings = (
      'cfMenge=float:2'
      'cfProdHinweis=string:250'
      'cfVersHinweis=string:250'
      'cfWerksattest=string:250')
    KeyFields = 'AUFP_NR'
    PrimaryKeyFields = 'AUFP_ID'
    References.Strings = (
      'AUFP_AUFK_ID=:AUFK_ID'
      'DISPOSITIONEN.LASCH_NR=:LASCH_NR'
      'DISPOSITIONEN.AUFP_NR=AUFTRAGS_POSITIONEN.UEBERPOSITION'
      'DISPOSITIONEN.AKTIV=J;{DISPOSITIONEN.VERS_MENGE > 0}')
    SqlFieldList.Strings = (
      'DISPOSITIONEN.WERK_NR'
      'DISPOSITIONEN.DISP_DATUM'
      'DISPOSITIONEN.AKTIV'
      'DISPOSITIONEN.PR_QUITTIERT'
      'DISPOSITIONEN.ZUTY_NR'
      'DISPOSITIONEN.DISP_ZEIT'
      'DISPOSITIONEN.DISP_POS'
      'DISPOSITIONEN.VERSANDART_TYP'
      'DISPOSITIONEN.BELS_NR'
      'DISPOSITIONEN.BELS_GRUPPE'
      'DISPOSITIONEN.VERKAUFSBUERO'
      'DISPOSITIONEN.SACHBEARBEITER'
      'DISPOSITIONEN.MARA_NR'
      'DISPOSITIONEN.WAGGONTYP'
      'DISPOSITIONEN.LADE_GEWICHT'
      'DISPOSITIONEN.DISP_MENGE'
      'DISPOSITIONEN.DISP_ANZAHL'
      'DISPOSITIONEN.VORLADEN'
      'DISPOSITIONEN.GANZZUG'
      'DISPOSITIONEN.AUFK_NR'
      'DISPOSITIONEN.VERS_MENGE'
      'DISPOSITIONEN.VERS_ANZAHL'
      'DISPOSITIONEN.BUCH_MENGE'
      'DISPOSITIONEN.REST_MENGE'
      'DISPOSITIONEN.REST_ANZAHL'
      'DISPOSITIONEN.PRST_NR'
      'DISPOSITIONEN.PRST_ID'
      'DISPOSITIONEN.AUFK_ID'
      'DISPOSITIONEN.AUFP_ID'
      'DISPOSITIONEN.ZUST_ID'
      'DISPOSITIONEN.DISP_ID'
      'DISPOSITIONEN.ABHOLLAGER'
      'DISPOSITIONEN.PROD_DATUM'
      'DISPOSITIONEN.LASCH_NR'
      'DISPOSITIONEN.PRODHINWEIS'
      'DISPOSITIONEN.VERSHINWEIS'
      'DISPOSITIONEN.INTERNHINWEIS'
      'DISPWERKSATTEST=DISPOSITIONEN.WERKSATTEST'
      'DISPOSITIONEN.PR_GESPERRT'
      'DISPOSITIONEN.LAB_GESPERRT'
      'DISPOSITIONEN.TRANSPORTMITTEL'
      'DISPOSITIONEN.LEER_GEWICHT'
      'DISPOSITIONEN.BRUTTO_GEWICHT'
      'DISPOSITIONEN.GATTUNG'
      'DISPOSITIONEN.LFSK_ID'
      'DISPOSITIONEN.LFSP_ID'
      'DISPOSITIONEN.LFSK_NR'
      'AUFTRAGS_POSITIONEN.AUFP_ID'
      'AUFTRAGS_POSITIONEN.AUFP_AUFK_ID'
      'AUFTRAGS_POSITIONEN.SO_AUFK_NR'
      'AUFTRAGS_POSITIONEN.AUFP_NR'
      'AUFTRAGS_POSITIONEN.MARA_KURZ'
      'AUFTRAGS_POSITIONEN.KUNW_MARA_KURZ'
      'AUFTRAGS_POSITIONEN.MARA_NAME'
      'AUFTRAGS_POSITIONEN.MARA_LANG'
      'AUFTRAGS_POSITIONEN.PRD_HIERARCH_TEXT'
      'AUFTRAGS_POSITIONEN.PRD_HIERARCH_KEY'
      'AUFTRAGS_POSITIONEN.GEWICHT_EINHEIT'
      'AUFTRAGS_POSITIONEN.BESTELLMENGE'
      'AUFTRAGS_POSITIONEN.CHARGENNUMMER'
      'AUFTRAGS_POSITIONEN.POSITIONSART'
      'AUFTRAGS_POSITIONEN.DRUCK_KNZ'
      'AUFTRAGS_POSITIONEN.LIEFERRELEVANT'
      'AUFTRAGS_POSITIONEN.UEBERPOSITION'
      'AUFTRAGS_POSITIONEN.FUEHERENDE_POS'
      'AUFTRAGS_POSITIONEN.LAGERORT'
      'AUFTRAGS_POSITIONEN.TEXT_KONSERVE_3'
      'AUFTRAGS_POSITIONEN.TEXT_KONSERVE_4'
      'AUFPWERKSATTEST=AUFTRAGS_POSITIONEN.WERKSATTEST'
      'AUFTRAGS_POSITIONEN.LAGER_FACH'
      'AUFTRAGS_POSITIONEN.VERSANDSTELLE'
      'AUFTRAGS_POSITIONEN.CHARGENPFLICHTIG'
      'AUFTRAGS_POSITIONEN.CHARGEN_TEXT'
      'AUFTRAGS_POSITIONEN.ABRUFCODE'
      'AUFTRAGS_POSITIONEN.STATUS'
      'AUFTRAGS_POSITIONEN.NEUER_AUFTRAG'
      'AUFTRAGS_POSITIONEN.LUFTAUFTRAG'
      'AUFTRAGS_POSITIONEN.GEAENDERTER_AUFTRAG'
      'AUFTRAGS_POSITIONEN.RESTMENGE'
      'AUFTRAGS_POSITIONEN.DISPOMENGE'
      'AUFTRAGS_POSITIONEN.DISPORESTMENGE')
    TableName = 'AUFTRAGS_POSITIONEN;DISPOSITIONEN'
    MasterSource = LDatasource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuAufpGet
    Left = 8
    Top = 240
  end
    object TblAufp: TuQuery
    MasterSource = LDatasource1
    SQL.Strings = (
            'select DISPOSITIONEN.WERK_NR,'
            '       DISPOSITIONEN.DISP_DATUM,'
            '       DISPOSITIONEN.AKTIV,'
            '       DISPOSITIONEN.PR_QUITTIERT,'
            '       DISPOSITIONEN.ZUTY_NR,'
            '       DISPOSITIONEN.DISP_ZEIT,'
            '       DISPOSITIONEN.DISP_POS,'
            '       DISPOSITIONEN.VERSANDART_TYP,'
            '       DISPOSITIONEN.BELS_NR,'
            '       DISPOSITIONEN.BELS_GRUPPE,'
            '       DISPOSITIONEN.VERKAUFSBUERO,'
            '       DISPOSITIONEN.SACHBEARBEITER,'
            '       DISPOSITIONEN.MARA_NR,'
            '       DISPOSITIONEN.WAGGONTYP,'
            '       DISPOSITIONEN.LADE_GEWICHT,'
            '       DISPOSITIONEN.DISP_MENGE,'
            '       DISPOSITIONEN.DISP_ANZAHL,'
            '       DISPOSITIONEN.VORLADEN,'
            '       DISPOSITIONEN.GANZZUG,'
            '       DISPOSITIONEN.AUFK_NR,'
            '       DISPOSITIONEN.VERS_MENGE,'
            '       DISPOSITIONEN.VERS_ANZAHL,'
            '       DISPOSITIONEN.BUCH_MENGE,'
            '       DISPOSITIONEN.REST_MENGE,'
            '       DISPOSITIONEN.REST_ANZAHL,'
            '       DISPOSITIONEN.PRST_NR,'
            '       DISPOSITIONEN.PRST_ID,'
            '       DISPOSITIONEN.AUFK_ID,'
            '       DISPOSITIONEN.AUFP_ID,'
            '       DISPOSITIONEN.ZUST_ID,'
            '       DISPOSITIONEN.DISP_ID,'
            '       DISPOSITIONEN.ABHOLLAGER,'
            '       DISPOSITIONEN.PROD_DATUM,'
            '       DISPOSITIONEN.LASCH_NR,'
            '       DISPOSITIONEN.PRODHINWEIS,'
            '       DISPOSITIONEN.VERSHINWEIS,'
            '       DISPOSITIONEN.INTERNHINWEIS,'
            '       (DISPOSITIONEN.WERKSATTEST) as DISPWERKSATTEST,'
            '       DISPOSITIONEN.PR_GESPERRT,'
            '       DISPOSITIONEN.LAB_GESPERRT,'
            '       DISPOSITIONEN.TRANSPORTMITTEL,'
            '       DISPOSITIONEN.LEER_GEWICHT,'
            '       DISPOSITIONEN.BRUTTO_GEWICHT,'
            '       DISPOSITIONEN.GATTUNG,'
            '       DISPOSITIONEN.LFSK_ID,'
            '       DISPOSITIONEN.LFSP_ID,'
            '       DISPOSITIONEN.LFSK_NR,'
            '       AUFTRAGS_POSITIONEN.AUFP_ID,'
            '       AUFTRAGS_POSITIONEN.AUFP_AUFK_ID,'
            '       AUFTRAGS_POSITIONEN.SO_AUFK_NR,'
            '       AUFTRAGS_POSITIONEN.AUFP_NR,'
            '       AUFTRAGS_POSITIONEN.MARA_KURZ,'
            '       AUFTRAGS_POSITIONEN.KUNW_MARA_KURZ,'
            '       AUFTRAGS_POSITIONEN.MARA_NAME,'
            '       AUFTRAGS_POSITIONEN.MARA_LANG,'
            '       AUFTRAGS_POSITIONEN.PRD_HIERARCH_TEXT,'
            '       AUFTRAGS_POSITIONEN.PRD_HIERARCH_KEY,'
            '       AUFTRAGS_POSITIONEN.GEWICHT_EINHEIT,'
            '       AUFTRAGS_POSITIONEN.BESTELLMENGE,'
            '       AUFTRAGS_POSITIONEN.CHARGENNUMMER,'
            '       AUFTRAGS_POSITIONEN.POSITIONSART,'
            '       AUFTRAGS_POSITIONEN.DRUCK_KNZ,'
            '       AUFTRAGS_POSITIONEN.LIEFERRELEVANT,'
            '       AUFTRAGS_POSITIONEN.UEBERPOSITION,'
            '       AUFTRAGS_POSITIONEN.FUEHERENDE_POS,'
            '       AUFTRAGS_POSITIONEN.LAGERORT,'
            '       AUFTRAGS_POSITIONEN.TEXT_KONSERVE_3,'
            '       AUFTRAGS_POSITIONEN.TEXT_KONSERVE_4,'
            '       (AUFTRAGS_POSITIONEN.WERKSATTEST) as AUFPWERKSATTEST,'
            '       AUFTRAGS_POSITIONEN.LAGER_FACH,'
            '       AUFTRAGS_POSITIONEN.VERSANDSTELLE,'
            '       AUFTRAGS_POSITIONEN.CHARGENPFLICHTIG,'
            '       AUFTRAGS_POSITIONEN.CHARGEN_TEXT,'
            '       AUFTRAGS_POSITIONEN.ABRUFCODE,'
            '       AUFTRAGS_POSITIONEN.STATUS,'
            '       AUFTRAGS_POSITIONEN.NEUER_AUFTRAG,'
            '       AUFTRAGS_POSITIONEN.LUFTAUFTRAG,'
            '       AUFTRAGS_POSITIONEN.GEAENDERTER_AUFTRAG,'
            '       AUFTRAGS_POSITIONEN.RESTMENGE,'
            '       AUFTRAGS_POSITIONEN.DISPOMENGE,'
            '       AUFTRAGS_POSITIONEN.DISPORESTMENGE'
            'from AUFTRAGS_POSITIONEN,'
            '     DISPOSITIONEN'
            'where (AUFTRAGS_POSITIONEN.AUFP_AUFK_ID = :AUFK_ID)'
            '  and (DISPOSITIONEN.LASCH_NR = :LASCH_NR)'
            
              '  and ((DISPOSITIONEN.AKTIV = '#39'J'#39') or (DISPOSITIONEN.VERS_MENGE ' +
              '> 0))'
            '  and (DISPOSITIONEN.AUFP_NR=AUFTRAGS_POSITIONEN.UEBERPOSITION)'
            'order by AUFTRAGS_POSITIONEN.AUFP_NR')
    Left = 8
    Top = 268
    ParamData = <
            item
              DataType = ftFloat
              Name = 'AUFK_ID'
              ParamType = ptUnknown
            end
            item
              DataType = ftFloat
              Name = 'LASCH_NR'
              ParamType = ptUnknown
            end>
  end
object LuBels: TLookUpDef
    DataSet = TblBels
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'BELS_ID'
    References.Strings = (
      'BELS_NR=:BELS_NR')
    SqlFieldList.Strings = (
      'WERK_NR'
      'BELS_NR'
      'BELS_NAME'
      'BELS_ID'
      'BELS_GRUPPE'
      'BELS_POS')
    TableName = 'BELADESTELLEN'
    MasterSource = LDatasource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 6
    Top = 309
  end
    object TblBels: TuQuery
    MasterSource = LDatasource1
    SQL.Strings = (
            'select WERK_NR,'
            '       BELS_NR,'
            '       BELS_NAME,'
            '       BELS_ID,'
            '       BELS_GRUPPE,'
            '       BELS_POS'
            'from BELADESTELLEN'
            'where (BELS_NR = :BELS_NR)')
    Left = 6
    Top = 337
    ParamData = <
            item
              DataType = ftString
              Name = 'BELS_NR'
              ParamType = ptUnknown
            end>
  end
object LuLfsp: TLookUpDef
    DataSet = TblLfsp
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'LFSP_ID'
    References.Strings = (
      'LFSP_LFSK_ID=:LFSK_ID'
      'SO_AUFP_NR=:AUFP_NR')
    SqlFieldList.Strings = (
      'LFSP_LFSK_ID'
      'SO_AUFP_NR'
      'MENGE')
    TableName = 'LIEFERSCHEIN_POSITIONEN'
    MasterSource = LuAufp
    DisabledButtons = []
    EnabledButtons = []
    Left = 16
    Top = 384
  end
    object TblLfsp: TuQuery
    MasterSource = LuAufp
    SQL.Strings = (
            'select LFSP_LFSK_ID,'
            '       SO_AUFP_NR,'
            '       MENGE'
            'from LIEFERSCHEIN_POSITIONEN'
            'where (LFSP_LFSK_ID = :LFSK_ID)'
            '  and (SO_AUFP_NR = :AUFP_NR)')
    Left = 16
    Top = 416
    ParamData = <
            item
              DataType = ftFloat
              Name = 'LFSK_ID'
              ParamType = ptUnknown
            end
            item
              DataType = ftFloat
              Name = 'AUFP_NR'
              ParamType = ptUnknown
            end>
  end
end
