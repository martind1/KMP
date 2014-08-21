object FrmWerk: TFrmWerk
  Left = 331
  Top = 316
  Caption = 'Werke'
  ClientHeight = 316
  ClientWidth = 611
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 582
    Top = 0
    Width = 29
    Height = 295
    Align = alRight
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    object BtnMulti: TBtnPage
      Left = -1
      Top = 216
      Width = 25
      Height = 25
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
      NumGlyphs = 2
      NoteBook = qNoteBook1
      Page = 'Multi'
      LookUpModus = lumZeigMsk
    end
    object BtnSingle: TBtnPage
      Left = -1
      Top = 248
      Width = 25
      Height = 25
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
      NumGlyphs = 2
      NoteBook = qNoteBook1
      Page = 'Single'
      LookUpModus = lumZeigMsk
    end
  end
  object qNoteBook1: TqNoteBook
    Left = 0
    Top = 0
    Width = 582
    Height = 295
    Align = alClient
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Single'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 582
        Height = 295
        Align = alClient
        AutoScroll = False
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 578
          Height = 42
          Align = alClient
          TabOrder = 0
          object Label2: TLabel
            Left = 5
            Top = 18
            Width = 25
            Height = 14
            Caption = '&Werk'
            FocusControl = EditWERK_NR
          end
          object EditWERK_NR: TDBEdit
            Left = 50
            Top = 15
            Width = 57
            Height = 22
            DataField = 'WERK_NR'
            DataSource = LDataSource1
            TabOrder = 0
          end
          object EditWERK_NAME: TDBEdit
            Left = 177
            Top = 15
            Width = 228
            Height = 22
            DataField = 'WERK_NAME'
            DataSource = LDataSource1
            TabOrder = 1
          end
          object Button1: TButton
            Left = 440
            Top = 8
            Width = 75
            Height = 25
            Caption = 'test'
            TabOrder = 2
            OnClick = Button1Click
          end
        end
        object DetailBook: TTabbedNotebook
          Left = 0
          Top = 42
          Width = 578
          Height = 249
          Align = alBottom
          TabFont.Charset = DEFAULT_CHARSET
          TabFont.Color = clBtnText
          TabFont.Height = -13
          TabFont.Name = 'MS Sans Serif'
          TabFont.Style = []
          TabOrder = 1
          object TTabPage
            Left = 4
            Top = 25
            Caption = '&etc.'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Label3: TLabel
              Left = 3
              Top = 10
              Width = 54
              Height = 14
              Caption = 'Bemer&kung'
              FocusControl = MemoBEMERKUNG
            end
            object Label1: TLabel
              Left = 352
              Top = 24
              Width = 56
              Height = 14
              Caption = 'Erfasst von'
              FocusControl = ComboERFASST_VON
            end
            object MemoBEMERKUNG: TDBMemo
              Left = 0
              Top = 33
              Width = 305
              Height = 108
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object ComboERFASST_VON: TDBComboBox
              Left = 352
              Top = 48
              Width = 145
              Height = 22
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              Items.Strings = (
                'Name1'
                'Name2'
                'Name3'
                'INSERT_USER')
              TabOrder = 1
            end
            object DBRadioGroup1: TDBRadioGroup
              Left = 344
              Top = 88
              Width = 185
              Height = 105
              Caption = 'DBRadioGroup1'
              DataField = 'WERK_NAME'
              DataSource = LDataSource1
              Items.Strings = (
                'Name1'
                'Name2')
              ParentBackground = True
              TabOrder = 2
              Values.Strings = (
                'Name1'
                'Name2')
            end
          end
          object TTabPage
            Left = 4
            Top = 25
            Caption = 'Be&ladeeinrichtungen'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuBein: TMultiGrid
              Left = 6
              Top = 11
              Width = 507
              Height = 195
              DataSource = LuBein
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -11
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'BEIN_NR=BEIN_NR'
                'WERK_NR=SO_WERK_NR'
                'BEIN_NAME=BEIN_NAME'
                'MODULCODE=MODULCODE'
                'TR:2=TRANSPORTART'
                'PARAM=PARAM')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = []
              DefaultRowHeight = 18
              Drag0Value = '0'
            end
            object Panel3: TPanel
              Left = 541
              Top = 0
              Width = 29
              Height = 220
              Align = alRight
              BevelInner = bvLowered
              BevelOuter = bvNone
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 1
              ExplicitHeight = 239
              object BtnBeinMulti: TqBtnMuSi
                Left = -1
                Top = 135
                Width = 25
                Height = 25
                Hint = 'Tabelle'
                GroupIndex = 12
                Down = True
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
                LookUpModus = lumZeigMsk
              end
              object BtnBeinSingle: TqBtnMuSi
                Left = -1
                Top = 167
                Width = 25
                Height = 26
                Hint = 'Datenmaske'
                GroupIndex = 12
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
                OnClick = BtnBeinSingleClick
                LookUpModus = lumZeigMsk
              end
              object LookUpBtn1: TLookUpBtn
                Left = -1
                Top = 72
                Width = 25
                Height = 25
                DoubleBuffered = True
                Glyph.Data = {
                  36050000424D3605000000000000360400002800000010000000100000000100
                  0800000000000001000000000000000000000001000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
                  A600000000000000000000000000000000000000000000000000000000000000
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
                  0000000000000000000000000000000000000000000000000000000000000000
                  0000000000000000000000000000000000000000000000000000000000000000
                  000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                  0707070707070707070707070707070707070707070707070707070707070707
                  0707070707070707070707070707000000000000000707070707070707070707
                  0707070707070707070707070707070707000707070707070707070707070707
                  0000000707070707070707070707070000000000070707070707070707070000
                  0000000000070707070707070707070700000007070707070707070707070707
                  0000000707070707070707070707070700000007070707070707070707070707
                  0000000707070707070707070707070707070707070707070707070707070707
                  0707070707070707070707070707070707070707070707070707}
                ParentDoubleBuffered = False
                TabOrder = 0
                LookUpDef = LuBein
                Modus = lubMulti
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 25
            Caption = 'S&ystem'
            ExplicitTop = 6
            ExplicitHeight = 239
            object Label4: TLabel
              Left = 5
              Top = 28
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'WERK_ID'
              FocusControl = EditWERK_ID
            end
            object Label5: TLabel
              Left = 5
              Top = 57
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_VON'
              FocusControl = EditERFASST_VON
            end
            object Label6: TLabel
              Left = 5
              Top = 86
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_AM
            end
            object Label7: TLabel
              Left = 5
              Top = 115
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label8: TLabel
              Left = 5
              Top = 145
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label9: TLabel
              Left = 5
              Top = 174
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object EditWERK_ID: TDBEdit
              Left = 167
              Top = 24
              Width = 57
              Height = 22
              DataField = 'WERK_ID'
              DataSource = LDataSource1
              TabOrder = 0
            end
            object EditERFASST_VON: TDBEdit
              Left = 167
              Top = 54
              Width = 171
              Height = 22
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              TabOrder = 1
            end
            object EditERFASST_AM: TDBEdit
              Left = 167
              Top = 84
              Width = 57
              Height = 22
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              TabOrder = 2
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 167
              Top = 113
              Width = 171
              Height = 22
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              TabOrder = 3
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 167
              Top = 143
              Width = 57
              Height = 22
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              TabOrder = 4
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 167
              Top = 172
              Width = 57
              Height = 22
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              TabOrder = 5
            end
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Multi'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 582
        Height = 295
        Align = alClient
        TabOrder = 0
        object Mu1: TMultiGrid
          Left = 0
          Top = 0
          Width = 473
          Height = 291
          Align = alLeft
          DataSource = LDataSource1
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          ColumnList.Strings = (
            'Nummer:6=WERK_NR'
            'Werkname=WERK_NAME')
          ReturnSingle = False
          NoColumnSave = False
          MuOptions = []
          DefaultRowHeight = 18
          Drag0Value = '0'
        end
      end
    end
  end
  object LTabSet1: TLTabSet
    Left = 0
    Top = 295
    Width = 611
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object Nav: TLNavigator
    TabSet = LTabSet1
    PageBook = qNoteBook1
    DetailBook = DetailBook
    FormKurz = 'WERK'
    BtnSingle = BtnSingle
    BtnMulti = BtnMulti
    FirstControl = EditWERK_NR
    AutoEditStart = True
    PageBookStart = 'Single'
    DetailBookStart = '&etc.'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = True
    AutoOpen = False
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    KeyList.Strings = (
      'Nummer=WERK_NR'
      'Name=WERK_NAME')
    PrimaryKeyFields = 'WERK_ID'
    TableName = 'WERK'
    Left = 577
    Top = 65
  end
  object LuBein: TLookUpDef
    DataSet = TblBein
    LuKurz = 'BEIN'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'BEIN_ID=BEIN_ID'
      'BEIN_NR=BEIN_NR'
      'BEIN_WERK_ID=BEIN_WERK_ID'
      'SO_WERK_NR=SO_WERK_NR'
      'BEIN_NAME=BEIN_NAME'
      'MODULCODE=MODULCODE'
      'TRANSPORTART=TRANSPORTART'
      'PARAM=PARAM'
      'ERFASST_VON=ERFASST_VON'
      'ERFASST_AM=ERFASST_AM'
      'GEAENDERT_VON=GEAENDERT_VON'
      'GEAENDERT_AM=GEAENDERT_AM'
      'ANZAHL_AENDERUNGEN=ANZAHL_AENDERUNGEN'
      'BEMERKUNG=BEMERKUNG')
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = False
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    MDTyp = mdDetail
    PrimaryKeyFields = 'BEIN_ID'
    References.Strings = (
      'SO_WERK_NR=:WERK_NR')
    TableName = 'BEIN'
    TabTitel = 'Beladeeinrichtungen'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 578
    Top = 176
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 577
    Top = 37
  end
  object Query1: TuQuery
    SQL.Strings = (
      'select *'
      'from WERK')
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 577
    Top = 9
  end
  object TblBein: TuQuery
    SQL.Strings = (
      'select *'
      'from BEIN'
      'where (SO_WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 578
    Top = 150
    ParamData = <
      item
        DataType = ftFloat
        Name = 'WERK_NR'
      end>
  end
  object PrnSource1: TPrnSource
    QRepKurz = 'WERK'
    Preview = False
    NoPreview = False
    Visible = True
    Display = 'Standard Liste'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = WinFaxDde
    FaxNr = '980004'
    FaxName = 'Hoyer'
    Options = [psMessage]
    ExportFile = False
    Left = 577
    Top = 97
  end
end
