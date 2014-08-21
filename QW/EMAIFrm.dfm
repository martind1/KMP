object FrmEMAI: TFrmEMAI
  Left = 1093
  Top = 228
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'E-Mail Sendeauftr'#228'ge'
  ClientHeight = 419
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
  ShowHint = True
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
    Height = 394
    ActivePage = tsMulti
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 572
        Height = 361
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
          'EMAI_ID:9=EMAI_ID'
          'Status:9=STATUS'
          'senden am:17=SENDEN_AM'
          'Empf'#228'nger:18=EMAI_TO'
          'Betreff:18=EMAI_SUBJECT'
          'Lfsk Nr:10=LFSK_NR'
          'Bemerkung:20=BEMERKUNG')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 19
        Drag0Value = '0'
      end
      object Panel2: TPanel
        Left = 0
        Top = 361
        Width = 572
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Label18: TLabel
          Left = 176
          Top = 6
          Width = 42
          Height = 15
          Caption = 'Abfrage'
        end
        object chbWerk: TCheckBox
          Left = 15
          Top = 6
          Width = 138
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
        object cobFltr: TComboBox
          Left = 224
          Top = 2
          Width = 345
          Height = 23
          Color = clWhite
          TabOrder = 1
          OnChange = cobFltrChange
        end
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Formular'
      object Detailbook: TPageControl
        Left = 0
        Top = 113
        Width = 572
        Height = 273
        ActivePage = TabSheet2
        Align = alClient
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          object qSplitter1: TqSplitter
            Left = 0
            Top = 161
            Width = 564
            Height = 4
            Cursor = crVSplit
            Align = alTop
            Color = clSilver
            ParentColor = False
            OnMoved = qSplitter1Moved
            ExplicitWidth = 63
          end
          object GroupBox1: TGroupBox
            Left = 0
            Top = 165
            Width = 564
            Height = 78
            Align = alClient
            Caption = 'Bemerkung'
            TabOrder = 0
            object EdBEM: TDBMemo
              Tag = 64
              Left = 2
              Top = 17
              Width = 560
              Height = 59
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
              WordWrap = False
            end
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 564
            Height = 161
            Align = alTop
            Caption = 'Panel1'
            ShowCaption = False
            TabOrder = 1
            object Label7: TLabel
              Left = 8
              Top = 8
              Width = 53
              Height = 15
              Caption = 'Absender'
              FocusControl = edEMAI_FROM
            end
            object Label8: TLabel
              Left = 8
              Top = 32
              Width = 61
              Height = 15
              Caption = 'Empf'#228'nger'
              FocusControl = edEMAI_TO
            end
            object Label15: TLabel
              Left = 8
              Top = 56
              Width = 42
              Height = 15
              Caption = 'Anhang'
              FocusControl = edEMAI_ATTACHMENTS
            end
            object Label16: TLabel
              Left = 8
              Top = 80
              Width = 21
              Height = 15
              Caption = 'Text'
            end
            object edEMAI_FROM: TLookUpEdit
              Tag = 128
              Left = 80
              Top = 6
              Width = 241
              Height = 23
              DataField = 'EMAI_FROM'
              DataSource = LDataSource1
              TabOrder = 0
              Options = []
              KeyField = False
            end
            object edEMAI_TO: TLookUpEdit
              Tag = 128
              Left = 80
              Top = 30
              Width = 241
              Height = 23
              DataField = 'EMAI_TO'
              DataSource = LDataSource1
              TabOrder = 1
              Options = []
              KeyField = False
            end
            object edEMAI_ATTACHMENTS: TLookUpEdit
              Tag = 128
              Left = 80
              Top = 54
              Width = 241
              Height = 23
              DataField = 'EMAI_ATTACHMENTS'
              DataSource = LDataSource1
              TabOrder = 2
              Options = []
              KeyField = False
            end
            object edEMAI_TEXT: TLookUpMemo
              Tag = 384
              Left = 80
              Top = 78
              Width = 249
              Height = 74
              DataField = 'EMAI_TEXT'
              DataSource = LDataSource1
              TabOrder = 3
              Options = []
            end
          end
        end
        object tsDiPr: TTabSheet
          Caption = #196'nderungen'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuDiPr: TMultiGrid
            Left = 0
            Top = 0
            Width = 564
            Height = 243
            Align = alClient
            DataSource = LuDiPr
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -12
            TitleFont.Name = 'Arial'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Zeitpunkt:15=LIEGTAN_AM'
              'von:10=ERFASST_VON'
              'Text:60=STME_TEXT')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muCustColor]
            DefaultRowHeight = 19
            Drag0Value = '0'
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          object ScrollBox4: TScrollBox
            Left = 0
            Top = 0
            Width = 564
            Height = 243
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Label1: TLabel
              Left = 128
              Top = 5
              Width = 46
              Height = 15
              Alignment = taRightJustify
              Caption = 'EMAI_ID'
              FocusControl = edEMAI_ID
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
            object edEMAI_ID: TDBEdit
              Left = 183
              Top = 1
              Width = 88
              Height = 23
              Ctl3D = True
              DataField = 'EMAI_ID'
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
        Height = 113
        Align = alTop
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 35
          Height = 15
          Caption = 'Betreff'
          FocusControl = edEMAI_SUBJECT
        end
        object Label3: TLabel
          Left = 287
          Top = 56
          Width = 28
          Height = 15
          Alignment = taRightJustify
          Caption = 'Werk'
          FocusControl = edWERK_NR
        end
        object Label4: TLabel
          Left = 8
          Top = 32
          Width = 35
          Height = 15
          Caption = 'Status'
          FocusControl = cobSTATUS
        end
        object Label5: TLabel
          Left = 251
          Top = 32
          Width = 64
          Height = 15
          Alignment = taRightJustify
          Caption = 'Senden am'
          FocusControl = edSENDEN_AM
        end
        object Label6: TLabel
          Left = 8
          Top = 56
          Width = 68
          Height = 15
          Caption = 'Lieferschein'
          FocusControl = edLFSK_NR
        end
        object Label14: TLabel
          Left = 8
          Top = 80
          Width = 60
          Height = 15
          Caption = 'Versand ID'
          FocusControl = edEMVE_ID
        end
        object edEMAI_SUBJECT: TDBEdit
          Tag = 128
          Left = 80
          Top = 6
          Width = 240
          Height = 23
          DataField = 'EMAI_SUBJECT'
          DataSource = LDataSource1
          TabOrder = 0
        end
        object edWERK_NR: TLookUpEdit
          Left = 320
          Top = 54
          Width = 47
          Height = 23
          DataField = 'WERK_NR'
          DataSource = LDataSource1
          TabOrder = 4
          Options = []
          KeyField = True
        end
        object cobSTATUS: TAswComboBox
          Left = 80
          Top = 30
          Width = 145
          Height = 23
          AutoComplete = False
          DataField = 'STATUS'
          DataSource = LDataSource1
          Items.Strings = (
            'Angelegt'
            'Gesendet'
            'Zu senden'
            'Fehler')
          TabOrder = 1
          AswName = 'EmailStatus'
        end
        object edSENDEN_AM: TDBEdit
          Left = 320
          Top = 30
          Width = 105
          Height = 23
          DataField = 'SENDEN_AM'
          DataSource = LDataSource1
          TabOrder = 2
        end
        object edLFSK_NR: TLookUpEdit
          Left = 80
          Top = 54
          Width = 105
          Height = 23
          DataField = 'LFSK_NR'
          DataSource = LDataSource1
          TabOrder = 3
          Options = []
          KeyField = True
        end
        object edEMVE_ID: TLookUpEdit
          Left = 80
          Top = 78
          Width = 105
          Height = 23
          DataField = 'EMVE_ID'
          DataSource = LDataSource1
          TabOrder = 5
          Options = []
          KeyField = True
        end
      end
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 394
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
    FormKurz = 'EMAI'
    FirstControl = edEMAI_SUBJECT
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
    CalcList.Strings = (
      'cfBEIN_NR=string:255')
    FormatList.Strings = (
      'STATUS=Asw,EmailStatus')
    KeyList.Strings = (
      'Standard=EMAI_ID desc')
    PrimaryKeyFields = 'EMAI_ID'
    TableName = 'EMAILS'
    OnGet = NavGet
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
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMAILS')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 573
    Top = 185
  end
  object LuDiPr: TLookUpDef
    DataSet = TblDiPr
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    KeyList.Strings = (
      'Standard=STME_ID desc')
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'BEIN_NR=:cfBEIN_NR'
      'STME_NR=111212')
    TableName = 'STOERMELDUNGEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 336
    Top = 392
  end
  object TblDiPr: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from STOERMELDUNGEN'
      'where (BEIN_NR = :cfBEIN_NR)'
      '  and (STME_NR = 111212)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 368
    Top = 392
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'cfBEIN_NR'
      end>
  end
end
