object DlgLuGrid: TDlgLuGrid
  Left = 541
  Top = 298
  ActiveControl = Mu1
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Lookup'
  ClientHeight = 345
  ClientWidth = 291
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object LuTabSet: TLTabSet
    Left = 0
    Top = 321
    Width = 291
    Height = 24
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object panCenter: TPanel
    Left = 0
    Top = 107
    Width = 291
    Height = 214
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PageBook: TNotebook
      Left = 0
      Top = 0
      Width = 256
      Height = 214
      Align = alClient
      PageIndex = 1
      TabOrder = 0
      IsControl = True
      object TPage
        Left = 0
        Top = 0
        Caption = 'Single'
        IsControl = True
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label1: TLabel
          Left = 93
          Top = 130
          Width = 153
          Height = 16
          Caption = 'Einzelsicht nicht verf'#252'gbar'
        end
        object BtnTabelle: TBitBtn
          Left = 101
          Top = 154
          Width = 137
          Height = 41
          Caption = 'Tabelle'
          Glyph.Data = {
            62070000424D620700000000000036040000280000001C0000001D0000000100
            0800000000002C03000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A600F0C8A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000FFFB
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
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000
            0000000000000000000000000000000000FFFFF8FFF8F8F8F8F8F8F8F8F8F8F8
            F8F8F8F8F8F8F8F8F8F8F8F800FFFFF8FF070707070707070707070707070707
            07070707070707F800FFFFF8FF07000000000000000000000000000000000000
            000007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007F80007F8
            00FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8
            FF07000000000000000000000000000000000000000007F800FFFFF8FF0700FF
            FFFFF8FFFFFFF8FFFFFFF8FFFFFF0007FF0007F800FFFFF8FF0700FFFFFFF8FF
            FFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8FF0700000000000000000000
            0000000000000007FF0007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FF
            FFFF00FF070007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007
            FF0007F800FFFFF8FF070000000000000000000000000000000000FF070007F8
            00FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007FF0007F800FFFFF8
            FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8FF070000
            00000000000000000000000000000000000007F800FFFFF8FF0700FFFFFFF8FF
            FFFFF8FFFFFFF8FFFFFF0007070007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FF
            FFFFF8FFFFFF00FF070007F800FFFFF8FF070000000000000000000000000000
            00000000000007F800FFFFF8FF07000707070707070707070707070707070007
            F80007F800FFFFF8FF070007070707070707070707070707070700FF070007F8
            00FFFFF8FF07000000000000000000000000000000000000000007F800FFFFF8
            FF07070707070707070707070707070707070707070707F800FFFFF8FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFF8FCFCFCFCFCFCFCFC
            FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC00FFFFF8040404040404040404040404
            04040404040404040404040400FFFFF8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
            F8F8F8F8F8F8F8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          TabOrder = 0
          OnClick = BtnTabelleClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Multi'
        IsControl = True
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Mu1: TMultiGrid
          Left = 0
          Top = 0
          Width = 256
          Height = 214
          Align = alClient
          BorderStyle = bsNone
          DataSource = LDataSource1
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgMultiSelect]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -13
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnKeyDown = Mu1KeyDown
          ReturnSingle = False
          NoColumnSave = False
          MuOptions = [muNoAskLayout]
          DefaultRowHeight = 20
          Drag0Value = '0'
          OnLayoutChanged = Mu1LayoutChanged
        end
      end
    end
    object PanelMuSi: TPanel
      Left = 256
      Top = 0
      Width = 35
      Height = 214
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object BtnMulti: TqBtnMuSi
        Left = -1
        Top = 8
        Width = 32
        Height = 40
        Hint = 'Tabelle'
        GroupIndex = 901
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333FFFFFFFFFFFFFFF000000000000000077777777777777770FFFFFFFFFFF
          FFF07F3FF3FF3FFF3FF70F00F00F000F00F07F773773777377370FFFFFFFFFFF
          FFF07F3FF3FF33FFFFF70F00F00FF00000F07F773773377777F70FEEEEEFF0F9
          FCF07F33333337F7F7F70FFFFFFFF0F9FCF07F3FFFF337F737F70F0000FFF0FF
          FCF07F7777F337F337370F0000FFF0FFFFF07F777733373333370FFFFFFFFFFF
          FFF07FFFFFFFFFFFFFF70CCCCCCCCCCCCCC07777777777777777088CCCCCCCCC
          C880733777777777733700000000000000007777777777777777333333333333
          3333333333333333333333333333333333333333333333333333}
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        NoteBook = PageBook
        Page = 'Multi'
        LookUpModus = lumZeigMsk
      end
      object BtnSingle: TqBtnMuSi
        Left = -1
        Top = 56
        Width = 32
        Height = 40
        Hint = 'Datenmaske'
        GroupIndex = 901
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          33333FFFFFFFFFFFFFFF000000000000000077777777777777770FFFFFFFFFFF
          FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
          FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
          FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
          FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
          FFF07FFFFFFFFFFFFFF70CCCCCCCCCCCCCC07777777777777777088CCCCCCCCC
          C8807FF7777777777FF700000000000000007777777777777777333333333333
          3333333333333333333333333333333333333333333333333333}
        Layout = blGlyphTop
        NumGlyphs = 2
        NoteBook = PageBook
        Page = 'Single'
        LookUpModus = lumZeigMsk
      end
    end
  end
  object panFltr: TPanel
    Left = 0
    Top = 0
    Width = 291
    Height = 73
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 58
      Height = 16
      Caption = 'Suchen in'
    end
    object cobFltr: TComboBox
      Tag = 512
      Left = 71
      Top = 6
      Width = 177
      Height = 24
      Style = csDropDownList
      Constraints.MaxWidth = 177
      Constraints.MinWidth = 32
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      OnChange = cobFltrChange
    end
    object EdFltr: TEdit
      Tag = 512
      Left = 8
      Top = 32
      Width = 240
      Height = 24
      Hint = 'Suchbegriff'
      Constraints.MaxWidth = 240
      TabOrder = 1
    end
    object btnFltr: TBitBtn
      Left = 248
      Top = 32
      Width = 24
      Height = 24
      Hint = 'Suche starten'
      Default = True
      Glyph.Data = {
        CE070000424DCE07000000000000360000002800000024000000120000000100
        18000000000098070000C40E0000C40E00000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000204000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000FFFF00000000000000000000FFFF00000000000000000000FFFF00
        000000000000000000FFFF00000000000000000000000000000000FFFF000000
        000000000000FFFFFF000000000000000000FFFFFF00000000000000000000FF
        FF00000000000000000000000000000000FFFF00000000000000000000FFFF00
        000000000000000000FFFF00000000000000000000FFFF000000000000000000
        00000000000000FFFF000000000000000000FFFFFF000000000000000000FFFF
        FF00000000000000000000FFFF00000000000000000000000000000000000000
        FFFF00FFFF00FFFF00FFFF00000000FFFF00000000FFFF00FFFF00FFFF00FFFF
        000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFF
        FF00000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
        000000000000000000000000FFFF00FFFF00FFFF00FFFF000000FFFFFF000000
        00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000000000000000
        00FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFF
        FFFF00000000000000000000000000000000000000FFFF00FFFF00FFFF00FFFF
        000000FFFFFF000000FFFFFF00000000FFFF00FFFF00FFFF00FFFF0000000000
        00000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FF
        FFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000
        00FFFF00FFFF00FFFF000000FFFFFF00FFFF00000000FFFFFFFFFF00000000FF
        FF00FFFF00FFFF000000000000000000000000000000FFFFFFFFFFFFFFFFFF00
        0000FFFFFF00FFFF00000000FFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000
        00000000000000FFFF00FFFF00FFFF00FFFF00FFFF00000000FFFFFFFFFF0000
        00FFFFFF00FFFF00000000FFFF00FFFF00FFFF00FFFF00FFFF000000FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFF000000FFFFFF00FFFF000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000FFFF00FFFF00FF
        FF000000FFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000FFFF00FFFF00FFFF00
        0000000000000000000000000000FFFFFFFFFFFFFFFFFF000000FFFFFF00FFFF
        FFFFFF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFF0000000000000000000000
        0000000000FFFF00FFFF00FFFF00FFFF000000FFFFFF00FFFFFFFFFF00000000
        FFFF00FFFF00FFFF00FFFF000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFF000000FFFFFF00FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFF
        FF00000000000000000000000000000000000000FFFF00FFFF00FFFF00FFFF00
        000000000000000000FFFF00FFFF00FFFF00FFFF000000000000000000000000
        000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFF
        FFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000000000000000
        FFFF00FFFF00FFFF00FFFF00000000000000000000FFFF00FFFF00FFFF00FFFF
        000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFF
        FF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
        000000000000000000000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000000000000000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF00000000000000000000000000000000000000FFFF000000000000000000
        00FFFF00FFFF00FFFF00FFFF00FFFF00000000000000000000FFFF0000000000
        0000000000000000000000FFFF000000000000000000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF00000000000000000000FFFF000000000000000000000000000000
        00000000000000000000000000000000000000FFFF0000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000FFFFFF000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000000000000000000000FF
        FF00000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000FFFFFF000000000000000000
        000000000000000000000000000000000000}
      NumGlyphs = 2
      TabOrder = 2
      TabStop = False
      OnClick = btnFltrClick
    end
  end
  object PanSchnellsuche: TPanel
    Left = 0
    Top = 73
    Width = 291
    Height = 34
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Schnellsuche:'
    TabOrder = 3
    object LaSchnellsuche: TLabel
      Left = 97
      Top = 9
      Width = 95
      Height = 16
      Caption = 'LaSchnellsuche'
    end
  end
  object Nav: TLNavigator
    TabSet = LuTabSet
    PageBook = PageBook
    FormKurz = 'LOOKUP'
    BtnSingle = BtnSingle
    BtnMulti = BtnMulti
    FirstControl = Mu1
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = 'etc.'
    StaticFields = False
    Options = []
    OnStart = NavStart
    OnPostStart = NavPostStart
    OnStartReturn = NavStartReturn
    PollInterval = 1000
    OnPoll = NavPoll
    OnPageChange = NavPageChange
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    BeforeEdit = NavBeforeEdit
    BeforeInsert = NavBeforeInsert
    Left = 78
    Top = 320
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    AfterOpen = Query1AfterOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 24
    Top = 320
  end
  object LDataSource1: TuDataSource
    DataSet = Query1
    OnStateChange = LDataSource1StateChange
    OnDataChange = LDataSource1DataChange
    Left = 51
    Top = 320
  end
  object PsDflt: TPrnSource
    MuSelect = Mu1
    QRepKurz = 'DFLT'
    Preview = True
    NoPreview = False
    Visible = True
    Display = 'Standard Liste'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage]
    OpenAfterGenerate = False
    ExportFile = False
    Left = 131
    Top = 158
  end
end
