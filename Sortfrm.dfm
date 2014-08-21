object FrmSort: TFrmSort
  Left = 475
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Sortierfolge'
  ClientHeight = 457
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LTabSet1: TLTabSet
    Left = 0
    Top = 436
    Width = 308
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object Mu1: TMultiGrid
    Left = 0
    Top = 0
    Width = 308
    Height = 436
    Align = alClient
    DataSource = LDataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    ColumnList.Strings = (
      'SORT_CODE=SORT_CODE'
      'SORT_NR=SORT_NR')
    ReturnSingle = True
    NoColumnSave = False
    MuOptions = []
    DefaultRowHeight = 17
    Drag0Value = '0'
  end
  object Nav: TLNavigator
    TabSet = LTabSet1
    FormKurz = 'SORT'
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = 'Allgemein'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = False
    NoGotoPos = False
    KeyFields = 'SORT_CODE'
    PrimaryKeyFields = 'SORT_CODE'
    TableName = 'SORTORDER'
    BeforeInsert = NavBeforeInsert
    Left = 71
    Top = 250
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 13
    Top = 250
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
    Left = 109
    Top = 219
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SORTORDER'
      'order by SORT_CODE')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 41
    Top = 249
  end
  object QueDelete: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'delete'
      'from SORTORDER')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 112
    Top = 256
  end
end
