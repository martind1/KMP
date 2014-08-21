object FrmASWS: TFrmASWS
  Left = 230
  Top = 581
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Auswahlfelder'
  ClientHeight = 326
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object TabControl: TTabControl
    Left = 0
    Top = 301
    Width = 539
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 0
    Tabs.Strings = (
      'Tab1')
    TabIndex = 0
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 539
    Height = 297
    ActivePage = tsMulti
    Align = alTop
    MultiLine = True
    TabOrder = 1
    TabPosition = tpRight
    OnChanging = PageControlChanging
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 511
        Height = 253
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        ColumnList.Strings = (
          'Auswahl Name:60=ASW_NAME')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 19
        Drag0Value = '0'
      end
      object Panel2: TPanel
        Left = 0
        Top = 253
        Width = 511
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
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
          Left = 81
          Top = 7
          Width = 345
          Height = 23
          Color = clWhite
          TabOrder = 0
          OnChange = cobFltrChange
        end
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
        Top = 41
        Width = 511
        Height = 248
        ActivePage = tsAllgemein
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 246
        object tsAllgemein: TTabSheet
          Caption = 'Allgemein'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuASWS: TMultiGrid
            Left = 0
            Top = 0
            Width = 503
            Height = 218
            Hint = 'Reihenfolge mit der Maus ziehen'
            Align = alClient
            DataSource = LuASWS
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -12
            TitleFont.Name = 'Arial'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Pos:3=ITEM_POS'
              'Wert:10=ITEM_VALUE'
              'Anzeige:23=ITEM_DISPLAY'
              'Bemerkung:33=BEMERKUNG')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit, muDrag]
            DefaultRowHeight = 19
            Drag0Value = '0'
            DragFieldName = 'ITEM_POS'
          end
        end
        object tsSystem: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object qSplitter1: TqSplitter
            Left = 0
            Top = 162
            Width = 503
            Height = 4
            Cursor = crVSplit
            Align = alTop
            Color = clGray
            ParentColor = False
          end
          object GbStatisitk: TGroupBox
            Left = 0
            Top = 93
            Width = 503
            Height = 69
            Align = alTop
            Caption = 'Ref.Integr.'
            TabOrder = 0
          end
          object gbIntern: TGroupBox
            Tag = 4096
            Left = 0
            Top = 166
            Width = 503
            Height = 52
            Align = alClient
            Caption = 'Intern'
            Constraints.MinHeight = 16
            TabOrder = 1
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 0
            Width = 503
            Height = 93
            Align = alTop
            TabOrder = 2
            object Label29: TLabel
              Left = 8
              Top = 18
              Width = 85
              Height = 15
              Caption = 'Erfasst von, am'
              FocusControl = EdERFASST_VON
            end
            object Label31: TLabel
              Left = 8
              Top = 42
              Width = 97
              Height = 15
              Caption = 'Ge'#228'ndert von, am'
              FocusControl = EdGEAENDERT_VON
            end
            object Label33: TLabel
              Left = 8
              Top = 65
              Width = 106
              Height = 15
              Caption = 'Anzahl '#196'nderungen'
              FocusControl = EdANZAHL_AENDERUNGEN
            end
            object Label34: TLabel
              Left = 228
              Top = 65
              Width = 12
              Height = 15
              Caption = 'ID'
              FocusControl = edID
            end
            object EdERFASST_VON: TDBEdit
              Left = 125
              Top = 16
              Width = 121
              Height = 23
              Hint = 'ERFASST_VON'
              DataField = 'ERFASST_VON'
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 0
            end
            object EdERFASST_AM: TDBEdit
              Left = 247
              Top = 16
              Width = 121
              Height = 23
              Hint = 'ERFASST_AM'
              DataField = 'ERFASST_AM'
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 1
            end
            object EdGEAENDERT_VON: TDBEdit
              Left = 125
              Top = 40
              Width = 121
              Height = 23
              Hint = 'GEAENDERT_VON'
              DataField = 'GEAENDERT_VON'
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 2
            end
            object EdGEAENDERT_AM: TDBEdit
              Left = 247
              Top = 40
              Width = 121
              Height = 23
              Hint = 'GEAENDERT_AM'
              DataField = 'GEAENDERT_AM'
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 3
            end
            object EdANZAHL_AENDERUNGEN: TDBEdit
              Left = 125
              Top = 63
              Width = 84
              Height = 23
              Hint = 'ANZAHL_AENDERUNGEN'
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 4
            end
            object edID: TDBEdit
              Left = 247
              Top = 63
              Width = 84
              Height = 23
              DataSource = LuASWS
              ReadOnly = True
              TabOrder = 5
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 511
        Height = 41
        Align = alTop
        TabOrder = 0
        object Label20: TLabel
          Left = 8
          Top = 10
          Width = 47
          Height = 15
          Caption = 'Auswahl'
        end
        object edASW_NAME: TLookUpEdit
          Tag = 128
          Left = 72
          Top = 8
          Width = 345
          Height = 23
          DataField = 'ASW_NAME'
          DataSource = LDataSource1
          TabOrder = 0
          Options = []
          KeyField = True
        end
      end
    end
  end
  object Nav: TLNavigator
    TabSet = TabControl
    PageBook = PageControl
    DetailBook = DetailControl
    FormKurz = 'ASWS'
    FirstControl = MuASWS
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    PollInterval = 500
    OnPoll = NavPoll
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = True
    ErfassSingle = True
    NoOpen = False
    NoGotoPos = False
    FormatList.Strings = (
      'SysFields=IGN,')
    Bemerkung.Strings = (
      'VERB_PRIO=000.#####')
    KeyList.Strings = (
      'Standard=ASW_NAME')
    PrimaryKeyFields = 'ASW_NAME'
    SqlFieldList.Strings = (
      'distinct ASW_NAME')
    TableName = 'ASWS'
    BeforeDelete = NavBeforeDelete
    Left = 138
    Top = 297
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 80
    Top = 297
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select distinct ASW_NAME'
      'from ASWS')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 108
    Top = 297
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
    Left = 168
    Top = 297
  end
  object LuASWS: TLookUpDef
    DataSet = TblASWS
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Erfasst von am=ERFASST_VON'
      'Ge'#228'ndert von am=GEAENDERT_VON'
      'Anzahl '#196'nderungen=ANZAHL_AENDERUNGEN')
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FormatList.Strings = (
      'SysFields=IGN,')
    KeyFields = 'ITEM_POS'
    PrimaryKeyFields = 'ASW_NAME;ITEM_POS'
    References.Strings = (
      'ASW_NAME=:ASW_NAME')
    TableName = 'ASWS'
    TabTitel = ';Detali'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 216
    Top = 296
  end
  object TblASWS: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from ASWS'
      'where (ASW_NAME = :ASW_NAME)'
      'order by ITEM_POS')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    BeforePost = TblASWSBeforePost
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 248
    Top = 296
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ASW_NAME'
      end>
  end
  object genITEM_POS: TGenerator
    DataSource = LuASWS
    DataField = 'ITEM_POS'
    KeyFields = 'ASW_NAME'
    ValueMin = '1'
    ValueMax = '999'
    ValueAkt = '0'
    UseIni = False
    ForceEmpty = False
    Left = 280
    Top = 296
  end
end
