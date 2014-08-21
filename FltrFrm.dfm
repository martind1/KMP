object FrmFltr: TFrmFltr
  Left = 971
  Top = 575
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Abfragen'
  ClientHeight = 333
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object PageBook: TqNoteBook
    Left = 0
    Top = 0
    Width = 461
    Height = 308
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Single'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 461
        Height = 65
        Align = alTop
        TabOrder = 0
        object qLabel2: TqLabel
          Left = 8
          Top = 10
          Width = 88
          Height = 16
          Caption = 'Formulark'#252'rzel'
          FocusControl = cobFORM
          FocusTop = -2
          FocusRight = 96
        end
        object qLabel1: TqLabel
          Left = 8
          Top = 34
          Width = 77
          Height = 16
          Caption = 'Bezeichnung'
          FocusControl = EdNAME
          FocusTop = -2
          FocusRight = 96
        end
        object EdNAME: TDBEdit
          Left = 104
          Top = 32
          Width = 348
          Height = 24
          DataField = 'NAME'
          DataSource = LDataSource1
          TabOrder = 1
        end
        object cobFORM: TDBComboBox
          Left = 104
          Top = 8
          Width = 145
          Height = 24
          DataField = 'FORM'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 0
        end
        object chbISPUBLIC: TAswCheckBox
          Left = 280
          Top = 10
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = #214'ffentlich'
          DataField = 'ISPUBLIC'
          DataSource = LDataSource1
          TabOrder = 2
          ValueChecked = 'X'
          ValueUnchecked = '-'
          AswName = 'JNX'
        end
      end
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 65
        Width = 461
        Height = 243
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 1
        object DetailBook: TTabbedNotebook
          Left = 0
          Top = 0
          Width = 461
          Height = 243
          Align = alClient
          PageIndex = 2
          TabFont.Charset = DEFAULT_CHARSET
          TabFont.Color = clBlack
          TabFont.Height = -13
          TabFont.Name = 'MS Sans Serif'
          TabFont.Style = []
          TabOrder = 0
          object TTabPage
            Left = 4
            Top = 27
            Caption = 'Allgemein'
            object qLabel3: TqLabel
              Left = 8
              Top = 162
              Width = 69
              Height = 16
              Caption = 'Bemer&kung'
              FocusControl = EdBEMERKUNG
              FocusTop = -2
              FocusRight = 77
            end
            object qLabel4: TqLabel
              Left = 8
              Top = 8
              Width = 29
              Height = 16
              Caption = 'Filter'
              FocusControl = EdFLTRLIST
              FocusTop = -2
              FocusRight = 77
            end
            object qLabel5: TqLabel
              Left = 8
              Top = 136
              Width = 61
              Height = 16
              Caption = 'Sortierung'
              FocusControl = EdKEYFIELDS
              FocusTop = -2
              FocusRight = 77
            end
            object EdBEMERKUNG: TDBMemo
              Left = 85
              Top = 160
              Width = 197
              Height = 49
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 2
            end
            object EdFLTRLIST: TDBMemo
              Left = 85
              Top = 6
              Width = 348
              Height = 121
              DataField = 'FLTRLIST'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object EdKEYFIELDS: TDBEdit
              Left = 85
              Top = 134
              Width = 348
              Height = 24
              DataField = 'KEYFIELDS'
              DataSource = LDataSource1
              TabOrder = 1
            end
          end
          object TTabPage
            Left = 4
            Top = 27
            Caption = 'Tabellenlayout'
            object edCOLUMNLIST: TDBMemo
              Left = 0
              Top = 29
              Width = 453
              Height = 183
              Align = alClient
              DataField = 'COLUMNLIST'
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Panel2: TPanel
              Left = 0
              Top = 0
              Width = 453
              Height = 29
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 1
              object chbColumnList: TCheckBox
                Left = 8
                Top = 6
                Width = 145
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Hat Tabellenlayout'
                TabOrder = 0
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 27
            Caption = 'S&ystem'
            object Label5: TLabel
              Left = 5
              Top = 8
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_VON'
              FocusControl = EditERFASST_VON
            end
            object Label6: TLabel
              Left = 5
              Top = 29
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_AM
            end
            object Label7: TLabel
              Left = 5
              Top = 50
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label8: TLabel
              Left = 5
              Top = 71
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label9: TLabel
              Left = 5
              Top = 95
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object Bevel4: TBevel
              Left = 0
              Top = 172
              Width = 537
              Height = 3
              Shape = bsTopLine
            end
            object Label1: TLabel
              Left = 5
              Top = 116
              Width = 137
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'FLTR_ID'
              FocusControl = edFLTR_ID
            end
            object EditERFASST_VON: TDBEdit
              Tag = 128
              Left = 151
              Top = 6
              Width = 171
              Height = 24
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              TabOrder = 0
            end
            object EditERFASST_AM: TDBEdit
              Left = 151
              Top = 27
              Width = 171
              Height = 24
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 1
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 151
              Top = 48
              Width = 171
              Height = 24
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 2
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 151
              Top = 69
              Width = 171
              Height = 24
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 3
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 151
              Top = 93
              Width = 57
              Height = 24
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 4
            end
            object gbIntern: TGroupBox
              Left = 144
              Top = 168
              Width = 161
              Height = 41
              Caption = 'Intern'
              TabOrder = 5
              object BtnTestError: TBitBtn
                Left = 24
                Top = 16
                Width = 75
                Height = 25
                Caption = 'TestError'
                TabOrder = 0
                OnClick = BtnTestErrorClick
              end
            end
            object edFLTR_ID: TDBEdit
              Left = 151
              Top = 117
              Width = 122
              Height = 24
              DataField = 'FLTR_ID'
              ReadOnly = True
              TabOrder = 6
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
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 461
        Height = 308
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = LTabSet1Click
        OnKeyDown = Mu1KeyDown
        ColumnList.Strings = (
          'Formular:20=FORM'
          #214':2=ISPUBLIC'
          'Bezeichnung:35=NAME')
        ReturnSingle = False
        NoColumnSave = False
        MuOptions = []
        DefaultRowHeight = 20
        Drag0Value = '0'
      end
    end
  end
  object PanBottom: TPanel
    Left = 0
    Top = 308
    Width = 461
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object LTabSet1: TLTabSet
      Left = 0
      Top = 0
      Width = 177
      Height = 25
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Tabs.Strings = (
        #220'bernehmen'
        '(Alle)')
      OnClick = LTabSet1Click
    end
    object PanRight: TPanel
      Left = 368
      Top = 0
      Width = 93
      Height = 25
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object BtnSpeichern: TBitBtn
        Left = 0
        Top = 0
        Width = 93
        Height = 25
        Hint = 'Speichert aktuelle Abfrage unter neuem Namen'
        Caption = 'Speichern'
        Default = True
        TabOrder = 0
        OnClick = BtnSpeichernClick
      end
    end
    object chbAlle: TCheckBox
      Left = 216
      Top = 5
      Width = 101
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Alle Abfragen'
      Color = 14215660
      ParentColor = False
      TabOrder = 2
      OnClick = chbAlleClick
    end
  end
  object Nav: TLNavigator
    PageBook = PageBook
    DetailBook = DetailBook
    FormKurz = 'FLTR'
    FirstControl = EdNAME
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    OnSetTitel = NavSetTitel
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = True
    FltrList.Strings = (
      'ERFASST_VON=:ERFASST_VON;{ISPUBLIC='#39'J'#39' or ISPUBLIC is null}')
    FormatList.Strings = (
      'NAME=N,'
      'FORM=N,'
      'ISPUBLIC=Asw,JNX')
    Bemerkung.Strings = (
      'VERB_PRIO=000.#####')
    KeyFields = 'FORM;NAME'
    PrimaryKeyFields = 'FLTR_ID'
    TableName = 'FLTR'
    OnRech = NavRech
    OnBuildSql = NavBuildSql
    Left = 58
    Top = 279
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnUpdateData = LDataSource1UpdateData
    Top = 279
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
    Left = 88
    Top = 279
  end
  object Query1: TuQuery
    Tag = 4
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from FLTR'
      
        'where ((ERFASST_VON = :ERFASST_VON) or (ISPUBLIC='#39'J'#39' or ISPUBLIC' +
        ' is null))'
      'order by FORM,'
      '         NAME')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False'
      'Oracle.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    AfterOpen = Query1AfterOpen
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 28
    Top = 279
    ParamData = <
      item
        DataType = ftString
        Name = 'ERFASST_VON'
      end>
  end
end
