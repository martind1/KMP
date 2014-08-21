object FrmErrM: TFrmErrM
  Left = 327
  Top = 478
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Fehlermeldungen'
  ClientHeight = 336
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -15
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 17
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 647
    Height = 311
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel2: TPanel
        Left = 0
        Top = 267
        Width = 616
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 265
        object btnFltr: TSpeedButton
          Left = 0
          Top = 7
          Width = 81
          Height = 22
          Hint = 'Abfrage speichern'
          AllowAllUp = True
          GroupIndex = 1201
          Caption = 'Abfrage'
          Flat = True
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000CE0E0000C40E00000000000000000000BFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000000000000000
            000000000000000000000000000000000000000000000000BFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFFFF000000FFFFFF000000FFFF
            FF000000FFFFFF000000FFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBF000000FFFFFF000000FFFFFF00000000000000000000000000
            0000000000000000000000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBF000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF000000FFFFFFFFFFFFFFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00
            0000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFF000000
            FFFFFF000000FFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFF
            FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF
            FFFFFFFFFF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00007F00007F0000
            7F00000000007F00007F00007F00007F00007F00007F0000FFFFFF000000FFFF
            FF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00007F00007F00007F000000
            00007F00007F00007F00007F00007F00007F0000FFFFFFFFFFFFFFFFFF000000
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFF
            FF000000FFFFFF000000FFFFFF000000FFFFFF000000FFFFFF000000BFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000BFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00007F00007F00007F00007F
            00007F00007F00007F00007F00007F00007F0000BFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBF7F00007F00007F00007F00007F00007F00
            007F00007F00007F00007F00007F0000BFBFBFBFBFBFBFBFBFC0C0C0BFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
            BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFC0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0}
          OnClick = btnFltrClick
        end
        object cobFltr: TComboBox
          Left = 89
          Top = 7
          Width = 400
          Height = 25
          Color = clWhite
          DropDownCount = 30
          TabOrder = 0
          OnChange = cobFltrChange
        end
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 616
        Height = 267
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -15
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        ColumnList.Strings = (
          'Nummer:6=ERRM_NR'
          'Text:58=ERRM_BESCHR')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 21
        Drag0Value = '0'
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Detail'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DetailControl: TPageControl
        Left = 0
        Top = 45
        Width = 616
        Height = 258
        ActivePage = tsAllgemein
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 256
        object tsAllgemein: TTabSheet
          Caption = 'Allgemein'
          object sbAllgemein: TScrollBox
            Left = 0
            Top = 0
            Width = 608
            Height = 17
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alTop
            BorderStyle = bsNone
            TabOrder = 0
          end
          object GroupBox2: TGroupBox
            Left = 0
            Top = 17
            Width = 608
            Height = 209
            Align = alClient
            Caption = 'Beschreibung'
            Constraints.MinHeight = 46
            TabOrder = 1
            object MemoBESCHR: TDBMemo
              Left = 2
              Top = 19
              Width = 604
              Height = 188
              Align = alClient
              DataField = 'ERRM_BESCHR'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
        object tsSystem: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object SplitterIntern: TqSplitter
            Left = 0
            Top = 210
            Width = 608
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
            SavePosition = True
          end
          object GbStatisitk: TGroupBox
            Left = 0
            Top = 99
            Width = 608
            Height = 111
            Align = alClient
            Caption = 'Bemerkung'
            Constraints.MinHeight = 24
            TabOrder = 0
            object MemoBEMERKUNG: TDBMemo
              Left = 2
              Top = 19
              Width = 604
              Height = 90
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object gbIntern: TGroupBox
            Left = 0
            Top = 214
            Width = 608
            Height = 10
            Align = alBottom
            Caption = 'Intern'
            Constraints.MinHeight = 2
            TabOrder = 1
            object ScrollBox4: TScrollBox
              Left = 2
              Top = 19
              Width = 604
              Height = 56
              HorzScrollBar.Tracking = True
              VertScrollBar.Tracking = True
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 0
            end
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 0
            Width = 608
            Height = 99
            Align = alTop
            TabOrder = 2
            object Label29: TLabel
              Left = 8
              Top = 18
              Width = 103
              Height = 17
              Caption = 'Erfasst von, am'
              FocusControl = EdERFASST_VON
            end
            object Label31: TLabel
              Left = 8
              Top = 43
              Width = 116
              Height = 17
              Caption = 'Ge'#228'ndert von, am'
              FocusControl = EdGEAENDERT_VON
            end
            object Label33: TLabel
              Left = 8
              Top = 68
              Width = 126
              Height = 17
              Caption = 'Anzahl '#196'nderungen'
              FocusControl = EdANZAHL_AENDERUNGEN
            end
            object Label34: TLabel
              Left = 322
              Top = 68
              Width = 14
              Height = 17
              Caption = 'ID'
              FocusControl = edID
            end
            object EdERFASST_VON: TDBEdit
              Left = 141
              Top = 16
              Width = 200
              Height = 25
              Hint = 'ERFASST_VON'
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 0
            end
            object EdERFASST_AM: TDBEdit
              Left = 341
              Top = 16
              Width = 142
              Height = 25
              Hint = 'ERFASST_AM'
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 1
            end
            object EdGEAENDERT_VON: TDBEdit
              Left = 141
              Top = 41
              Width = 200
              Height = 25
              Hint = 'GEAENDERT_VON'
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 2
            end
            object EdGEAENDERT_AM: TDBEdit
              Left = 341
              Top = 41
              Width = 142
              Height = 25
              Hint = 'GEAENDERT_AM'
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 3
            end
            object EdANZAHL_AENDERUNGEN: TDBEdit
              Left = 141
              Top = 66
              Width = 84
              Height = 25
              Hint = 'ANZAHL_AENDERUNGEN'
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 4
            end
            object edID: TDBEdit
              Tag = 32
              Left = 341
              Top = 66
              Width = 142
              Height = 25
              Hint = 'Prim'#228'rschl'#252'ssel'
              DataField = 'errm_id'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 5
            end
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 45
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 12
          Width = 96
          Height = 17
          Alignment = taRightJustify
          Caption = 'Fehlernummer'
          FocusControl = EditERRM_NR
        end
        object EditERRM_NR: TDBEdit
          Left = 122
          Top = 10
          Width = 72
          Height = 25
          DataField = 'errm_nr'
          DataSource = LDataSource1
          TabOrder = 0
        end
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 311
    Width = 647
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 1
    Tabs.Strings = (
      'Tab1')
    TabIndex = 0
  end
  object Nav: TLNavigator
    TabSet = TabControl
    PageBook = PageControl
    DetailBook = DetailControl
    FormKurz = 'ERRM'
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    CalcList.Strings = (
      'cfTEXT=string:80')
    KeyFields = 'errm_nr'
    KeyList.Strings = (
      'Nummer=ERRM_NR'
      'ID=ERRM_ID')
    PrimaryKeyFields = 'ERRM_NR'
    TableName = 'dbo.ERRM'
    OnGet = NavGet
    Left = 472
    Top = 61
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 472
    Top = 34
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.ERRM'
      'order by errm_nr')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 472
    Top = 7
  end
  object psDFLT: TPrnSource
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
    Left = 478
    Top = 129
  end
end
