object FrmSPED: TFrmSPED
  Left = 1047
  Top = 516
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Speditionen'
  ClientHeight = 313
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
    Height = 288
    ActivePage = tsMulti
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    ExplicitHeight = 246
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
        Height = 255
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
          'Spedition:25=SPED_NAME'
          'Werk:4=WERK_NR')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 19
        Drag0Value = '0'
      end
      object Panel2: TPanel
        Left = 0
        Top = 255
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
        Height = 231
        ActivePage = TabSheet4
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 189
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object GroupBox1: TGroupBox
            Left = 0
            Top = 0
            Width = 564
            Height = 159
            Align = alClient
            Caption = 'Bemerkung'
            TabOrder = 0
            object EdBEM: TDBMemo
              Tag = 64
              Left = 2
              Top = 17
              Width = 560
              Height = 140
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
              WordWrap = False
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Kunden'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 159
          inline FrZSPKU: TFrMuSi
            Left = 0
            Top = 0
            Width = 564
            Height = 201
            Align = alClient
            TabOrder = 0
            ExplicitWidth = 564
            ExplicitHeight = 159
            inherited Panel12: TPanel [0]
              Left = 536
              Height = 201
              ExplicitLeft = 536
              ExplicitHeight = 159
              inherited btnSingle: TqBtnMuSi
                Visible = False
              end
              inherited btnFTab: TqBtnMuSi
                Visible = False
              end
            end
            inherited Mu: TMultiGrid [1]
              Width = 536
              Height = 201
              DataSource = LuZSPKU
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              ColumnList.Strings = (
                'Kunde:6=KUNW_NR'
                'Name1:20=SO_KUNW_NAME1'
                'Land:4=SO_KUNW_LAND'
                'Ort:15=SO_KUNW_ORT'
                'Bemerkung:20=BEMERKUNG')
              DefaultRowHeight = 19
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Fahrzeuge'
          ImageIndex = 3
          inline FrFRZG: TFrMuSi
            Left = 0
            Top = 0
            Width = 564
            Height = 201
            Align = alClient
            TabOrder = 0
            ExplicitWidth = 564
            ExplicitHeight = 201
            inherited Panel12: TPanel [0]
              Left = 536
              Height = 201
              ExplicitLeft = 536
              ExplicitHeight = 201
              inherited btnInsert: TqBtnMuSi
                Visible = False
              end
              inherited btnEdit: TqBtnMuSi
                Visible = False
              end
              inherited btnDelete: TqBtnMuSi
                Visible = False
              end
            end
            inherited Mu: TMultiGrid [1]
              Width = 536
              Height = 201
              DataSource = LuFRZG
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              ColumnList.Strings = (
                'Transportmittel:14=TRANSPORTMITTEL'
                'Tara:7=TARA_GEWICHT'
                'Tara vom:10=TARA_DATUM'
                'Bemerkung:22=BEMERKUNG')
              DefaultRowHeight = 19
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
              Left = 122
              Top = 8
              Width = 52
              Height = 15
              Alignment = taRightJustify
              Caption = 'SPED_ID'
              FocusControl = edSPED_ID
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
            object edSPED_ID: TDBEdit
              Left = 183
              Top = 1
              Width = 88
              Height = 23
              Ctl3D = True
              DataField = 'SPED_ID'
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
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 52
          Height = 15
          Caption = 'Spedition'
        end
        object Label3: TLabel
          Left = 352
          Top = 8
          Width = 28
          Height = 15
          Alignment = taRightJustify
          Caption = 'Werk'
        end
        object edSPED_NAME: TDBEdit
          Left = 72
          Top = 6
          Width = 240
          Height = 23
          DataField = 'SPED_NAME'
          DataSource = LDataSource1
          TabOrder = 0
        end
        object edWERK_NR: TDBEdit
          Left = 388
          Top = 6
          Width = 47
          Height = 23
          DataField = 'WERK_NR'
          DataSource = LDataSource1
          TabOrder = 1
        end
      end
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 288
    Width = 600
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 1
    Tabs.Strings = (
      'Tab1'
      'Tab2')
    TabIndex = 0
    ExplicitTop = 246
  end
  object Nav: TLNavigator
    TabSet = TabControl1
    PageBook = PageBook
    DetailBook = Detailbook
    FormKurz = 'SPED'
    FirstControl = edSPED_NAME
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
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    KeyList.Strings = (
      'Standard=SPED_NAME')
    PrimaryKeyFields = 'SPED_ID'
    TableName = 'SPEDITIONEN'
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
  object LuZSPKU: TLookUpDef
    DataSet = TblZSPKU
    LuKurz = 'ZSPKU'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FltrList.Strings = (
      'WERK_NR=:WERK_NR')
    FormatList.Strings = (
      'KUNW_NR=INT,TL0,')
    KeyList.Strings = (
      'Standard=KUNW_NR')
    PrimaryKeyFields = 'ZSPKU_ID'
    References.Strings = (
      'SPED_NAME=:SPED_NAME'
      'WERK_NR=:WERK_NR')
    TableName = 'ZUORD_SPEDITION_KUNDE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 230
    Top = 48
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SPEDITIONEN')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 573
    Top = 185
  end
  object TblZSPKU: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from ZUORD_SPEDITION_KUNDE'
      'where (SPED_NAME = :SPED_NAME)'
      '  and (WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 262
    Top = 48
    ParamData = <
      item
        DataType = ftString
        Name = 'SPED_NAME'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object LuFRZG: TLookUpDef
    DataSet = TblFRZG
    LuKurz = 'FRZG'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FormatList.Strings = (
      'TARA_GEWICHT=#0.00 ')
    KeyList.Strings = (
      'Standard=TRANSPORTMITTEL')
    PrimaryKeyFields = 'FRZG_ID'
    References.Strings = (
      'SPEDITION=:SPED_NAME'
      'WERK_NR=:WERK_NR')
    TableName = 'FAHRZEUGE'
    MasterSource = LDataSource1
    DisabledButtons = [qnbInsert, qnbDelete, qnbEdit]
    EnabledButtons = []
    Left = 308
    Top = 44
  end
  object TblFRZG: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from FAHRZEUGE'
      'where (SPEDITION = :SPED_NAME)'
      '  and (WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 340
    Top = 44
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SPED_NAME'
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'WERK_NR'
        Value = Null
      end>
  end
end
