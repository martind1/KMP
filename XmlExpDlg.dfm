object DlgXMLEXP: TDlgXMLEXP
  Left = 450
  Top = 414
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'XML Export/Import'
  ClientHeight = 295
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object DetailControl: TPageControl
    Left = 0
    Top = 0
    Width = 594
    Height = 254
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Allgemeines'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox5: TGroupBox
        Left = 0
        Top = 113
        Width = 586
        Height = 110
        Align = alClient
        Caption = 'SQL'
        TabOrder = 1
        object MeSQL: TMemo
          Left = 2
          Top = 18
          Width = 582
          Height = 90
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = MeSQLChange
        end
      end
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 586
        Height = 113
        Align = alTop
        BorderStyle = bsNone
        TabOrder = 0
        object Label18: TLabel
          Left = 8
          Top = 24
          Width = 56
          Height = 16
          Caption = 'Filename'
        end
        object Label1: TLabel
          Left = 8
          Top = 88
          Width = 47
          Height = 16
          Caption = 'Tabelle'
        end
        object EdFileName: TEdit
          Left = 80
          Top = 22
          Width = 433
          Height = 24
          TabOrder = 0
          Text = 'EXPORT.XML'
        end
        object btnFilename: TBitBtn
          Left = 513
          Top = 22
          Width = 24
          Height = 24
          Hint = 'Ausw'#228'hlen'
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Layout = blGlyphBottom
          Margin = 5
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
          OnClick = btnFilenameClick
        end
        object btnOpen: TBitBtn
          Left = 537
          Top = 22
          Width = 24
          Height = 24
          Hint = #214'ffnen'
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555555555555555555555555555555555555555555555555555555555555
            555555555555555555555555555555555555555FFFFFFFFFF555550000000000
            55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
            B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
            000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
            555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
            55555575FFF75555555555700007555555555557777555555555555555555555
            5555555555555555555555555555555555555555555555555555}
          NumGlyphs = 2
          TabOrder = 2
          OnClick = btnOpenClick
        end
        object EdTableName: TEdit
          Left = 80
          Top = 86
          Width = 225
          Height = 24
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'System'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object qSplitter1: TqSplitter
        Left = 0
        Top = 129
        Width = 586
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
        ExplicitWidth = 94
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 586
        Height = 129
        Align = alTop
        Caption = 'Tabellen'
        TabOrder = 0
        object lbTables: TListBox
          Left = 2
          Top = 18
          Width = 582
          Height = 109
          Align = alClient
          TabOrder = 0
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 133
        Width = 586
        Height = 90
        Align = alClient
        Caption = 'SQL Parameter'
        TabOrder = 1
        ExplicitLeft = 64
        ExplicitTop = 152
        ExplicitWidth = 185
        ExplicitHeight = 105
        object MeSqlParam: TMemo
          Left = 2
          Top = 18
          Width = 582
          Height = 70
          Align = alClient
          Lines.Strings = (
            'MeSqlParam')
          ScrollBars = ssVertical
          TabOrder = 0
          WordWrap = False
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 254
    Width = 594
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      594
      41)
    object BtnExport: TBitBtn
      Left = 280
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Export'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnExportClick
    end
    object BtnClose: TBitBtn
      Left = 512
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'S&chlie'#223'en'
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BtnCloseClick
    end
    object BtnImport: TBitBtn
      Left = 368
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Import'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BtnImportClick
    end
  end
  object Nav: TLNavigator
    DetailBook = DetailControl
    FormKurz = 'XMLEXP'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    ColumnList.Strings = (
      'Zug Nummer:10=ZUG_NR'
      'Datum:10=ZMES_DATE'
      'Zeit:5=ZMES_TIME'
      'Messstelle:3=MEST_NR'
      'Messfile:30=DATAFILE')
    FormatList.Strings = (
      'ZMES_DATE=dd.mm.yyyy'
      'Z_AMPEL=Asw,Ampel'
      'Z_DS=#0.00'
      'Z_DA=#0.00'
      'Z_GEWICHT=#0')
    Left = 569
    Top = 59
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 569
    Top = 31
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'XLS'
    FileName = 'Report'
    Filter = 'XML (*.xml)|*.xml|*.*|*.*'
    Left = 538
    Top = 67
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 569
    Top = 2
  end
  object QueImp: TuQuery
    Connection = DlgLogon.Database1
    ReadOnly = True
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = False
    UpdateMode = upWhereAll
    Left = 468
    Top = 179
  end
end
