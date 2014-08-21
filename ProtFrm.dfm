object FrmProt: TFrmProt
  Left = 515
  Top = 316
  ActiveControl = LaStatus
  Caption = 'Protokollfenster'
  ClientHeight = 449
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbProt: TListBox
    Left = 0
    Top = 0
    Width = 344
    Height = 424
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnClick = BtnWeiterClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 424
    Width = 344
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnDrucken: TBitBtn
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Hint = 'Inhalt des Protokollfensters drucken'
      Caption = 'Drucken'
      Glyph.Data = {
        9E050000424D9E05000000000000360400002800000012000000120000000100
        0800000000006801000000000000000000000001000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
        A40000008000008080000080000080800000800000000000000080008000FFFB
        F0008080400000FF800000404000A4C8F0000080FF00A0A0A40000408000FF00
        8000400080008040000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        070707070707070707070707000007070707F8F8F8F8F8F8F8F8F8F8F8070707
        00000707000000000000000000000000F8F80707000007070007F8F8F8F8F8F8
        F8F8F80000F8F807000007000000000000000000000000000000F80700000700
        07FCFCFC07070707070707000000070707070700070707070707070707070700
        F800070707070700070707070707070707070700F8F800070707070000000000
        000000000000000000F80007000707070007F8F8F8F8F8F8F8F8F80700000007
        00000707070000FFFFFFFFFFFFFF00070700000707070707070700FF00000000
        00FF000000000007FFFF0707070700FFFFFFFFFFFFFF000707070707FFFF0707
        07070700FF00000000FFFF00070707070700070707070700FFFF00000000FF00
        07070707000707070707070700FFFFFFFFFFFFFF000707070000070707070707
        0700000000000000000007070700070707070707070707070707070707070707
        0707}
      TabOrder = 0
      OnClick = BtnDruckenClick
    end
    object LaStatus: TStaticText
      Left = 103
      Top = 0
      Width = 241
      Height = 25
      Align = alRight
      Alignment = taCenter
      Caption = 'Protokoll l'#228'uft. Zum Stoppen auf den Text klicken.'
      TabOrder = 1
      ExplicitHeight = 17
    end
    object PanWeiter: TPanel
      Left = 26
      Top = 0
      Width = 77
      Height = 25
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object BtnWeiter: TBitBtn
        Left = 0
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Weiter'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333333333FFFFFFFFF333333000000000033333377777777773333330FFFFF
          FFF03333337F333333373333330FFFFFFFF03333337F3FF3FFF73333330F00F0
          00F03333F37F773777373330330FFFFFFFF03337FF7F3F3FF3F73339030F0800
          F0F033377F7F737737373339900FFFFFFFF03FF7777F3FF3FFF70999990F00F0
          00007777777F7737777709999990FFF0FF0377777777FF37F3730999999908F0
          F033777777777337F73309999990FFF0033377777777FFF77333099999000000
          3333777777777777333333399033333333333337773333333333333903333333
          3333333773333333333333303333333333333337333333333333}
        NumGlyphs = 2
        TabOrder = 0
        OnClick = BtnWeiterClick
      end
    end
  end
  object Nav: TLNavigator
    FormKurz = 'PROT'
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = 'Allgemein'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnSetTitel = NavSetTitel
    PollInterval = 1000
    OnPoll = NavPoll
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = False
    NoGotoPos = False
    Left = 71
    Top = 250
  end
  object PopupMenu1: TPopupMenu
    Left = 112
    Top = 256
    object miAlwaysOnTop: TMenuItem
      Caption = 'Immer im Vordergrund'
      OnClick = miAlwaysOnTopClick
    end
    object MiDelete: TMenuItem
      Caption = 'Protokoll l'#246'schen'
      OnClick = MiDeleteClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MiPrint: TMenuItem
      Caption = 'Drucken'
      OnClick = BtnDruckenClick
    end
    object MiSaveAs: TMenuItem
      Caption = 'Speichern unter ...'
      OnClick = MiSaveAsClick
    end
  end
  object UCLinePrinter1: TUCLinePrinter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    WordWrap = True
    Margins.Top = 15.000000000000000000
    Margins.Left = 15.000000000000000000
    Margins.Bottom = 15.000000000000000000
    Margins.Right = 15.000000000000000000
    Margins.MarginUnit = mm
    PrintPageNumbers = True
    PrintTitle = 'Protokoll'
    TitleOnPrintout = TopOfPage
    Left = 160
    Top = 272
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Textdatei (*.txt)|*.txt|Alle Dateien (*.*)|*.*'
    Left = 200
    Top = 272
  end
  object PrnSource1: TPrnSource
    QRepKurz = 'DFLT'
    Preview = False
    NoPreview = False
    Visible = True
    Display = 'Protokollfenster (Standarddrucker)'
    CopyFltr = False
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage]
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = PrnSource1BeforePrn
    Left = 160
    Top = 232
  end
  object PrintDialog: TPrintDialog
    Left = 208
    Top = 232
  end
end