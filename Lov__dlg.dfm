object DlgLov: TDlgLov
  Left = 314
  Top = 237
  ActiveControl = Edit1
  Caption = 'Werteliste'
  ClientHeight = 305
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PanButtons: TPanel
    Left = 0
    Top = 269
    Width = 327
    Height = 36
    Align = alBottom
    TabOrder = 2
    object BtnOK: TBitBtn
      Left = 8
      Top = 7
      Width = 80
      Height = 24
      Caption = '&OK'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 96
      Top = 7
      Width = 77
      Height = 24
      Cancel = True
      Caption = '&Abbruch'
      ModalResult = 2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
    object BtnSql: TBitBtn
      Left = 176
      Top = 7
      Width = 24
      Height = 24
      Cancel = True
      Glyph.Data = {
        0E070000424D0E0700000000000036040000280000001A0000001A0000000100
        080000000000D802000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0C8A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000A4C8
        F0000080FF00A0A0A40000408000FF0080004000800080400000FFFBF0008080
        400000FF8000004040004080800040400000FF800000FF00400080FFFF0080FF
        0000FFFF8000FF8080008000FF004080FF003F7FDF003F7FFF003F9F3F003F9F
        5F003F9F7F003F9F9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF
        7F003FBF9F003FBFBF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF
        9F003FDFBF003FDFDF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFF
        BF003FFFDF003FFFFF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3F
        DF005F3FFF005F5F3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5F
        FF005F7F3F005F7F5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F
        3F005F9F5F005F9F7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF
        5F005FBF7F005FBF9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF
        7F005FDF9F005FDFBF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF
        9F005FFFBF005FFFDF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3F
        BF007F3FDF007F3FFF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5F
        DF007F5FFF007F7F3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7F
        FF007F9F3F007F9F5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF
        3F007FBF5F007FBF7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF
        5F007FDF7F007FDF9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF
        7F007FFF9F007FFFBF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F
        9F009F3FBF009F3FDF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5F
        BF009F5FDF009F5FFF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7F
        DF009F7FFF009F9F3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9F
        FF009FBF3F009FBF5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF
        3F009FDF5F009FDF7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF
        5F009FFF7F009FFF9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F
        7F00BF3F9F00BF3FBF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F
        9F00BF5FBF00BF5FDF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7F
        BF00BF7FDF00BF7FFF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9F
        DF00BF9FFF00BFBF3F00BFBF5F00BFBF7F00F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F80000FF070707070707070707
        070707070707070704070707070707F80000FF07070707070707070704040707
        0704040407070404040707F80000FF0707070707070707040707040704070404
        07070407070707F80000FF070707070707070707070407070407070407070407
        070707F80000FF070707070707070707040707070407070407070407070707F8
        0000FF070707070707070704070704070407070407070407070707F80000FF07
        0707070707070707040407070704040707070407070707F80000FF0707070707
        07070707070707070707070707070707070707F80000FF070000000000000000
        000000000704040700000000070707F80000FF07000700FFFFFFFFFFFF07FFFF
        FF0404FFFFFFFF00070707F80000FF0700FF00FFFFFFFFFFFF07FFFFFFFFFFFF
        FFFFFF00070707F80000FF07000700FF04040404FF07FFFFFF0404FFFFFFFF00
        070707F80000FF0700FF00FFFFFFFFFFFF07FFFFFF0404FFFFFFFF00070707F8
        0000FF07000700FF04040404FF07FFFFFF040404FFFFFF00070707F80000FF07
        00FF00FFFFFFFFFFFF07FFFFFFFF040404FFFF00070707F80000FF07000700FF
        04040404FF07FFFFFFFFFF040404FF00070707F80000FF0700FF00FFFFFFFFFF
        FF07FF0404FFFFFF0404FF00070707F80000FF07000700FF04040404FF07FF04
        040404040404FF00070707F80000FF0700FF00FFFFFFFFFFFF07FFFF04040404
        04FFFF00070707F80000FF07000700FFFFFFFFFFFF07FFFFFFFFFFFFFFFFFF00
        070707F80000FF070000000000000000000000000000000000000000070707F8
        0000FF070007000707070707070707070707070707070700070707F80000FF07
        0000000000000000000000000000000000000000070707F80000FF0707070707
        07070707070707070707070707070707070707F80000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF070000}
      Spacing = -1
      TabOrder = 2
      OnClick = BtnSqlClick
      IsControl = True
    end
  end
  object PanEdit: TPanel
    Left = 0
    Top = 0
    Width = 327
    Height = 60
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 8
      Width = 67
      Height = 16
      Caption = 'Suchbegriff'
    end
    object Edit1: TEdit
      Tag = 128
      Left = 11
      Top = 27
      Width = 297
      Height = 24
      Hint = 'Wert suchen'
      Color = clWhite
      TabOrder = 0
      OnChange = Edit1Change
    end
  end
  object MultiGrid1: TMultiGrid
    Left = 0
    Top = 60
    Width = 327
    Height = 209
    Align = alClient
    DataSource = LDataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgMultiSelect]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = MultiGrid1DblClick
    ReturnSingle = False
    NoColumnSave = False
    MuOptions = [muNoSaveLayout]
    DefaultRowHeight = 20
    Drag0Value = '0'
  end
  object DataSource1: TDataSource
    AutoEdit = False
    Left = 437
    Top = 69
  end
  object Nav: TLNavigator
    AutoEditStart = True
    PageBookStart = 'Multi'
    DetailBookStart = 'etc.'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = True
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    TabTitel = 'Werteliste'
    Left = 272
    Top = 269
  end
  object Query1: TuQuery
    Options.RequiredFields = False
    AfterOpen = Query1AfterOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 208
    Top = 269
  end
  object LDataSource1: TuDataSource
    DataSet = Query1
    Left = 240
    Top = 269
  end
end