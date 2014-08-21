object FrmZSpKu: TFrmZSpKu
  Left = 343
  Top = 289
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Zuordnung Spedition-Kunden'
  ClientHeight = 271
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
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
  TextHeight = 15
  object PageBook: TPageControl
    Left = 0
    Top = 0
    Width = 600
    Height = 246
    ActivePage = tsMulti
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
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 572
        Height = 213
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
          'Spedition:10=SPED_NAME'
          'Kunde Nr.:6=KUNW_NR'
          'Werk:4=WERK_NR'
          'Name1:15=SO_KUNW_NAME1'
          'Land:1=SO_KUNW_LAND'
          'Ort:12=SO_KUNW_ORT')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 19
        Drag0Value = '0'
      end
      object Panel2: TPanel
        Left = 0
        Top = 213
        Width = 572
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object chbWerk: TCheckBox
          Left = 15
          Top = 6
          Width = 210
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Werk '
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          State = cbGrayed
          TabOrder = 0
          OnClick = chbWerkClick
        end
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Formular'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Detailbook: TPageControl
        Left = 0
        Top = 49
        Width = 572
        Height = 189
        ActivePage = TabSheet1
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 187
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 564
            Height = 89
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object Label5: TLabel
              Left = 8
              Top = 56
              Width = 28
              Height = 15
              Caption = 'Werk'
            end
            object Label3: TLabel
              Left = 8
              Top = 8
              Width = 36
              Height = 15
              Caption = 'Kunde'
            end
            object edWERK_NR: TLookUpEdit
              Left = 72
              Top = 54
              Width = 41
              Height = 23
              DataField = 'WERK_NR'
              DataSource = LDataSource1
              TabOrder = 0
              Options = []
              LookupField = 'WERK_NR'
              KeyField = True
            end
            object edKUNW_NR: TLookUpEdit
              Left = 72
              Top = 6
              Width = 88
              Height = 23
              Hint = 'Warenempf'#228'nger'
              DataField = 'KUNW_NR'
              DataSource = LDataSource1
              TabOrder = 1
              Options = []
              LookupSource = LuADRE
              LookupField = 'KUNW_NR'
              KeyField = True
            end
            object BtnKUNW_NR: TLookUpBtn
              Left = 161
              Top = 6
              Width = 21
              Height = 21
              Glyph.Data = {
                36040000424D3604000000000000360000002800000010000000100000000100
                2000000000000004000000000000000000000000000000000000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
                000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
                0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
                000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
              TabOrder = 2
              LookUpEdit = edKUNW_NR
              LookUpDef = LuADRE
              Modus = lubMulti
            end
            object edSO_KUNW_NAME1: TLookUpEdit
              Tag = 128
              Left = 208
              Top = 6
              Width = 88
              Height = 23
              Hint = 'Warenempf'#228'nger'
              DataField = 'SO_KUNW_NAME1'
              DataSource = LDataSource1
              TabOrder = 3
              Options = []
              LookupSource = LuADRE
              LookupField = 'NAME1'
              KeyField = False
            end
            object edSO_KUNW_LAND: TLookUpEdit
              Left = 176
              Top = 30
              Width = 32
              Height = 23
              Hint = 'Warenempf'#228'nger'
              DataField = 'SO_KUNW_LAND'
              DataSource = LDataSource1
              TabOrder = 4
              Options = []
              LookupSource = LuADRE
              LookupField = 'LAND'
              KeyField = False
            end
            object edSO_KUNW_ORT: TLookUpEdit
              Tag = 128
              Left = 208
              Top = 30
              Width = 88
              Height = 23
              Hint = 'Warenempf'#228'nger'
              DataField = 'SO_KUNW_ORT'
              DataSource = LDataSource1
              TabOrder = 5
              Options = []
              LookupSource = LuADRE
              LookupField = 'ORT'
              KeyField = False
            end
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 89
            Width = 564
            Height = 70
            Align = alClient
            Caption = 'Bemerkung'
            TabOrder = 1
            object EdBEM: TDBMemo
              Tag = 64
              Left = 2
              Top = 17
              Width = 560
              Height = 51
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
              WordWrap = False
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ScrollBox4: TScrollBox
            Left = 0
            Top = 0
            Width = 564
            Height = 159
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Label1: TLabel
              Left = 115
              Top = 8
              Width = 59
              Height = 15
              Alignment = taRightJustify
              Caption = 'ZSPKU_ID'
              FocusControl = edZSPKU_ID
            end
            object Label9: TLabel
              Left = 98
              Top = 51
              Width = 76
              Height = 15
              Alignment = taRightJustify
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_VON
            end
            object Label10: TLabel
              Left = 68
              Top = 74
              Width = 106
              Height = 15
              Alignment = taRightJustify
              Caption = 'GEAENDERT_VON'
              FocusControl = EditERFASST_AM
            end
            object Label11: TLabel
              Left = 89
              Top = 28
              Width = 85
              Height = 15
              Alignment = taRightJustify
              Caption = 'ERFASST_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label12: TLabel
              Left = 77
              Top = 97
              Width = 97
              Height = 15
              Alignment = taRightJustify
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label13: TLabel
              Left = 27
              Top = 119
              Width = 147
              Height = 15
              Alignment = taRightJustify
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object edZSPKU_ID: TDBEdit
              Left = 183
              Top = 1
              Width = 88
              Height = 23
              Ctl3D = True
              DataField = 'ZSPKU_ID'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 0
            end
            object EditERFASST_VON: TDBEdit
              Left = 183
              Top = 24
              Width = 179
              Height = 23
              Ctl3D = True
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 1
            end
            object EditERFASST_AM: TDBEdit
              Left = 183
              Top = 47
              Width = 162
              Height = 23
              Ctl3D = True
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 2
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 183
              Top = 70
              Width = 179
              Height = 23
              Ctl3D = True
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 3
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 183
              Top = 94
              Width = 162
              Height = 23
              Ctl3D = True
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 4
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 183
              Top = 117
              Width = 60
              Height = 23
              Ctl3D = True
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              ParentCtl3D = False
              TabOrder = 5
            end
          end
        end
      end
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 572
        Height = 49
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 16
          Top = 8
          Width = 52
          Height = 15
          Caption = 'Spedition'
        end
        object edSPED_NAME: TDBEdit
          Left = 80
          Top = 6
          Width = 240
          Height = 23
          DataField = 'SPED_NAME'
          DataSource = LDataSource1
          TabOrder = 0
        end
      end
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 246
    Width = 600
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 1
    Tabs.Strings = (
      'Tab1'
      'Tab2')
    TabIndex = 0
  end
  object Nav: TLNavigator
    TabSet = TabControl1
    PageBook = PageBook
    DetailBook = Detailbook
    FormKurz = 'ZSPKU'
    FirstControl = edKUNW_NR
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = '&etc.'
    StaticFields = False
    Options = []
    OnStart = NavStart
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    FormatList.Strings = (
      'KUNW_NR=INT,TL0,')
    KeyList.Strings = (
      'Standard=SPED_NAME;KUNW_NR')
    PrimaryKeyFields = 'ZSPKU_ID'
    TableName = 'ZUORD_SPEDITION_KUNDE'
    OnErfass = NavErfass
    Left = 573
    Top = 131
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 573
    Top = 159
  end
  object PsDflt: TPrnSource
    QRepKurz = 'DFLT'
    Preview = False
    NoPreview = False
    Visible = True
    Display = 'Standard Liste'
    DruckerTyp = 'Listen'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage]
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = PsDfltBeforePrn
    Left = 573
    Top = 213
  end
  object LuADRE: TLookUpDef
    DataSet = TblADRE
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luGridFltr]
    ColumnList.Strings = (
      'Nummer:6=KUNW_NR'
      'Name1:20=NAME1'
      'Name2:10=NAME2'
      'Land:2=LAND'
      'Ort:20=ORT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FormatList.Strings = (
      'KUNW_NR=INT,TL0,')
    KeyList.Strings = (
      'Standard=NAME1')
    PrimaryKeyFields = 'ADRE_ID'
    References.Strings = (
      'KUNW_NR=:KUNW_NR')
    SOList.Strings = (
      'KUNW_NR=:KUNW_NR'
      'NAME1=:SO_KUNW_NAME1'
      'LAND=:SO_KUNW_LAND'
      'ORT=:SO_KUNW_ORT')
    TableName = 'ADRESSEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 320
    Top = 46
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from ZUORD_SPEDITION_KUNDE')
    Options.RequiredFields = False
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 573
    Top = 185
  end
  object TblADRE: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from ADRESSEN'
      'where (KUNW_NR = :KUNW_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 352
    Top = 46
    ParamData = <
      item
        DataType = ftString
        Name = 'KUNW_NR'
      end>
  end
end
