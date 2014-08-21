object FrmSIST: TFrmSIST
  Left = 401
  Top = 395
  Caption = 'Silostellungen'
  ClientHeight = 407
  ClientWidth = 594
  Color = clBtnFace
  Constraints.MinHeight = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
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
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 594
    Height = 382
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object Multi: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 341
        Width = 566
        Height = 33
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object chbWerk: TCheckBox
          Left = 8
          Top = 10
          Width = 92
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Werk 0000'
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
        end
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 566
        Height = 341
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        ColumnList.Strings = (
          'W:1=cfBEIN_NR'
          'Silo:3=SILO_SPS_CODE'
          'A:2=cfA1'
          'St.:3=cfS1'
          'A2:2=cfA2'
          'St2:3=cfS2'
          'Anteil:6=SIST_KEY'
          'Silocode:11=SPS_CODE'
          'Stillstand:6=STILLSTAND')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 20
        Drag0Value = '0'
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Formular'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DetailControl: TPageControl
        Left = 0
        Top = 65
        Width = 566
        Height = 309
        ActivePage = TabSheet1
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 307
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          object ScrollBox5: TScrollBox
            Left = 0
            Top = 0
            Width = 558
            Height = 278
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Panel2: TPanel
              Left = 0
              Top = 0
              Width = 558
              Height = 278
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object GroupBox2: TGroupBox
                Left = 0
                Top = 170
                Width = 558
                Height = 108
                Align = alClient
                Caption = 'Bemerkung'
                TabOrder = 1
                object EdBEMERKUNG: TDBMemo
                  Left = 2
                  Top = 18
                  Width = 554
                  Height = 88
                  Align = alClient
                  DataField = 'BEMERKUNG'
                  DataSource = LDataSource1
                  ScrollBars = ssVertical
                  TabOrder = 0
                end
              end
              object nbData: TNotebook
                Left = 0
                Top = 0
                Width = 558
                Height = 170
                Align = alTop
                TabOrder = 0
                object TPage
                  Left = 0
                  Top = 0
                  Caption = 'SMH'
                  object GroupBox1: TGroupBox
                    Left = 0
                    Top = 0
                    Width = 558
                    Height = 170
                    Align = alClient
                    Caption = 'SPS Haltern'
                    TabOrder = 0
                    object Label4: TLabel
                      Left = 8
                      Top = 48
                      Width = 68
                      Height = 16
                      Caption = 'Silo Bunker'
                    end
                    object Label5: TLabel
                      Left = 8
                      Top = 24
                      Width = 54
                      Height = 16
                      Caption = 'Silocode'
                    end
                    object Label6: TLabel
                      Left = 88
                      Top = 48
                      Width = 16
                      Height = 16
                      Caption = 'A1'
                    end
                    object Label7: TLabel
                      Left = 120
                      Top = 48
                      Width = 16
                      Height = 16
                      Caption = 'S1'
                    end
                    object Label8: TLabel
                      Left = 176
                      Top = 48
                      Width = 16
                      Height = 16
                      Caption = 'A2'
                    end
                    object Label9: TLabel
                      Left = 208
                      Top = 48
                      Width = 16
                      Height = 16
                      Caption = 'S2'
                    end
                    object Label11: TLabel
                      Left = 8
                      Top = 100
                      Width = 33
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'Anteil'
                    end
                    object Label12: TLabel
                      Left = 8
                      Top = 138
                      Width = 100
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'Stillstand-Menge'
                      Visible = False
                    end
                    object Bevel1: TBevel
                      Left = 3
                      Top = 128
                      Width = 552
                      Height = 3
                      Shape = bsTopLine
                    end
                    object Label13: TLabel
                      Left = 180
                      Top = 138
                      Width = 3
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 't'
                      Visible = False
                    end
                    object Label22: TLabel
                      Left = 167
                      Top = 100
                      Width = 50
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Alignment = taRightJustify
                      Caption = 'Leistung'
                    end
                    object edSILO_SPS_CODE: TLookUpEdit
                      Left = 8
                      Top = 62
                      Width = 59
                      Height = 24
                      DataField = 'SILO_SPS_CODE'
                      DataSource = LDataSource1
                      ReadOnly = True
                      TabOrder = 0
                      Options = []
                      LookupSource = LuSILO
                      LookupField = 'SPS_CODE'
                      KeyField = False
                    end
                    object edSPS_CODE: TLookUpEdit
                      Left = 88
                      Top = 22
                      Width = 107
                      Height = 24
                      DataField = 'SPS_CODE'
                      DataSource = LDataSource1
                      TabOrder = 1
                      Options = []
                      KeyField = False
                    end
                    object EdA1: TEdit
                      Left = 88
                      Top = 62
                      Width = 25
                      Height = 24
                      Hint = 'Abzug1'
                      TabOrder = 2
                      OnExit = EditExit
                    end
                    object EdS1: TEdit
                      Left = 120
                      Top = 62
                      Width = 41
                      Height = 24
                      Hint = 'Stellung1'
                      TabOrder = 3
                      OnExit = EditExitS
                    end
                    object EdA2: TEdit
                      Left = 176
                      Top = 62
                      Width = 25
                      Height = 24
                      Hint = 'Abzug2'
                      TabOrder = 4
                      OnExit = EditExit
                    end
                    object EdS2: TEdit
                      Left = 208
                      Top = 62
                      Width = 41
                      Height = 24
                      Hint = 'Stellung2'
                      TabOrder = 5
                      OnExit = EditExitS
                    end
                    object edSIST_KEY: TLookUpEdit
                      Left = 88
                      Top = 98
                      Width = 49
                      Height = 24
                      Hint = 'Anteil (Auslass,to/h)'
                      DataField = 'SIST_KEY'
                      DataSource = LDataSource1
                      ReadOnly = True
                      TabOrder = 6
                      Options = []
                      KeyField = False
                    end
                    object edSTILLSTAND: TLookUpEdit
                      Left = 115
                      Top = 136
                      Width = 62
                      Height = 24
                      Hint = 'Anteil (Auslass,to/h)'
                      DataSource = LDataSource1
                      TabOrder = 7
                      Visible = False
                      Options = []
                      KeyField = False
                    end
                    object edLEISTUNG: TLookUpEdit
                      Left = 224
                      Top = 98
                      Width = 49
                      Height = 24
                      Hint = 'to/h'
                      DataField = 'LEISTUNG'
                      DataSource = LDataSource1
                      TabOrder = 8
                      Options = []
                      KeyField = False
                    end
                  end
                end
                object TPage
                  Left = 0
                  Top = 0
                  Caption = 'SMW'
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object GroupBox3: TGroupBox
                    Left = 0
                    Top = 0
                    Width = 558
                    Height = 170
                    Align = alClient
                    Caption = 'SMW - '#214'ffnungszeit'
                    TabOrder = 0
                    object Label14: TLabel
                      Left = 8
                      Top = 56
                      Width = 72
                      Height = 16
                      Caption = #214'ffnungszeit'
                    end
                    object Label15: TLabel
                      Left = 8
                      Top = 28
                      Width = 79
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'Bunker-Anteil'
                    end
                    object Label16: TLabel
                      Left = 151
                      Top = 28
                      Width = 12
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = '%'
                    end
                    object Label17: TLabel
                      Left = 151
                      Top = 56
                      Width = 35
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = '1/10 s'
                    end
                    object Label18: TLabel
                      Left = 8
                      Top = 92
                      Width = 53
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'Nachlauf'
                    end
                    object Label19: TLabel
                      Left = 180
                      Top = 92
                      Width = 11
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'to'
                    end
                    object Label20: TLabel
                      Left = 8
                      Top = 116
                      Width = 54
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'Stillstand'
                    end
                    object Label21: TLabel
                      Left = 180
                      Top = 116
                      Width = 11
                      Height = 16
                      Hint = 'Auslass,to/h'
                      Caption = 'to'
                    end
                    object edSPS_CODE_SMW: TLookUpEdit
                      Left = 96
                      Top = 54
                      Width = 49
                      Height = 24
                      Hint = 'SPS-Wert'
                      DataField = 'SPS_CODE'
                      DataSource = LDataSource1
                      TabOrder = 1
                      Options = []
                      KeyField = False
                    end
                    object SIST_KEY_2: TLookUpEdit
                      Left = 96
                      Top = 26
                      Width = 49
                      Height = 24
                      DataField = 'SIST_KEY'
                      DataSource = LDataSource1
                      TabOrder = 0
                      Options = []
                      KeyField = False
                    end
                    object edNACHLAUF: TLookUpEdit
                      Left = 96
                      Top = 90
                      Width = 80
                      Height = 24
                      DataField = 'NACHLAUF'
                      DataSource = LDataSource1
                      TabOrder = 2
                      Options = []
                      KeyField = False
                    end
                    object edSTILLSTAND_SMW: TLookUpEdit
                      Left = 96
                      Top = 114
                      Width = 80
                      Height = 24
                      DataField = 'STILLSTAND'
                      DataSource = LDataSource1
                      TabOrder = 3
                      Options = []
                      KeyField = False
                    end
                  end
                end
              end
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #196'nderungen'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuDiPr: TMultiGrid
            Left = 0
            Top = 0
            Width = 558
            Height = 278
            Align = alClient
            DataSource = LuDiPr
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -13
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Zeitpunkt:15=LIEGTAN_AM'
              'von:10=ERFASST_VON'
              'Text:60=STME_TEXT')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muCustColor]
            DefaultRowHeight = 20
            Drag0Value = '0'
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
            Width = 558
            Height = 278
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 112
              Width = 49
              Height = 16
              Caption = 'SILO_ID'
            end
            object GbStatisitk: TGroupBox
              Left = 0
              Top = 0
              Width = 558
              Height = 97
              Align = alTop
              TabOrder = 0
              object Label29: TLabel
                Left = 8
                Top = 18
                Width = 116
                Height = 16
                Caption = 'Erfasst von, am, DB'
              end
              object Label31: TLabel
                Left = 8
                Top = 42
                Width = 131
                Height = 16
                Caption = 'Ge'#228'ndert von, am, DB'
              end
              object Label33: TLabel
                Left = 8
                Top = 66
                Width = 116
                Height = 16
                Caption = 'Anzahl '#196'nderungen'
              end
              object Label34: TLabel
                Left = 245
                Top = 66
                Width = 13
                Height = 16
                Caption = 'ID'
              end
              object EdERFASST_VON: TDBEdit
                Left = 141
                Top = 16
                Width = 122
                Height = 24
                Hint = 'ERFASST_VON'
                DataField = 'ERFASST_VON'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 0
              end
              object EdERFASST_AM: TDBEdit
                Left = 264
                Top = 16
                Width = 140
                Height = 24
                Hint = 'ERFASST_AM'
                DataField = 'ERFASST_AM'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 1
              end
              object EdGEAENDERT_VON: TDBEdit
                Left = 141
                Top = 40
                Width = 122
                Height = 24
                Hint = 'GEAENDERT_VON'
                DataField = 'GEAENDERT_VON'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 2
              end
              object EdGEAENDERT_AM: TDBEdit
                Left = 264
                Top = 40
                Width = 140
                Height = 24
                Hint = 'GEAENDERT_AM'
                DataField = 'GEAENDERT_AM'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 3
              end
              object EdANZAHL_AENDERUNGEN: TDBEdit
                Left = 141
                Top = 64
                Width = 84
                Height = 24
                Hint = 'ANZAHL_AENDERUNGEN'
                DataField = 'ANZAHL_AENDERUNGEN'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 4
              end
              object edID: TDBEdit
                Left = 264
                Top = 64
                Width = 84
                Height = 24
                Hint = 'Ident'
                DataField = 'SIST_ID'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 5
              end
              object edERFASST_DATENBANK: TDBEdit
                Left = 405
                Top = 16
                Width = 122
                Height = 24
                Hint = 'ERFASST_DATENBANK'
                DataField = 'ERFASST_DATENBANK'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 6
              end
              object edGEAENDERT_DATENBANK: TDBEdit
                Left = 405
                Top = 40
                Width = 122
                Height = 24
                Hint = 'GEAENDERT_DATENBANK'
                DataField = 'GEAENDERT_DATENBANK'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 7
              end
            end
            object LeSILO_ID: TLookUpEdit
              Left = 72
              Top = 110
              Width = 121
              Height = 24
              DataField = 'SILO_ID'
              DataSource = LDataSource1
              TabOrder = 1
              Options = []
              LookupSource = LuSILO
              LookupField = 'SILO_ID'
              KeyField = True
            end
          end
        end
      end
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 566
        Height = 65
        HorzScrollBar.Tracking = True
        HorzScrollBar.Visible = False
        VertScrollBar.Tracking = True
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 42
          Height = 16
          Caption = 'Bunker'
          FocusControl = EdSILO_NR
        end
        object Label10: TLabel
          Left = 8
          Top = 32
          Width = 108
          Height = 16
          Caption = 'Beladeeinrichtung'
        end
        object Label3: TLabel
          Left = 225
          Top = 32
          Width = 32
          Height = 16
          Caption = 'Werk'
        end
        object EdSILO_NR: TLookUpEdit
          Left = 126
          Top = 6
          Width = 59
          Height = 24
          DataField = 'SILO_NR'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 0
          Options = []
          LookupSource = LuSILO
          LookupField = 'SILO_NR'
          KeyField = False
        end
        object EditSILO_NAME: TDBEdit
          Left = 225
          Top = 6
          Width = 240
          Height = 24
          DataField = 'SILO_NAME'
          DataSource = LuSILO
          ReadOnly = True
          TabOrder = 1
        end
        object edBEIN_NR: TLookUpEdit
          Left = 126
          Top = 30
          Width = 75
          Height = 24
          DataField = 'BEIN_NR'
          DataSource = LuSILO
          ReadOnly = True
          TabOrder = 2
          Options = []
          KeyField = False
        end
        object edWERK_NR: TLookUpEdit
          Left = 262
          Top = 30
          Width = 59
          Height = 24
          DataField = 'WERK_NR'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 3
          Options = []
          LookupSource = LuSILO
          LookupField = 'SO_WERK_NR'
          KeyField = False
        end
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 382
    Width = 594
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
    FormKurz = 'SIST'
    AutoEditStart = False
    PageBookStart = '1'
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
    NoOpen = False
    NoGotoPos = False
    CalcList.Strings = (
      'cfBEIN_NR=lookup:LuSILO;BEIN_NR'
      'cfA1=string:5'
      'cfS1=string:5'
      'cfA2=string:5'
      'cfS2=string:5')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.00'
      'STILLSTAND=#0.00'
      'NACHLAUF=#0.00')
    KeyList.Strings = (
      'Standard=SPS_CODE'
      'Silonummer=SILO_NR;SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    TableName = 'SILOSTELLUNGEN'
    OnGet = NavGet
    OnRech = NavRech
    Left = 566
    Top = 179
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnStateChange = LDataSource1StateChange
    OnDataChange = LDataSource1DataChange
    Left = 566
    Top = 151
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
    Left = 565
    Top = 209
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
      'BEIN_NR=SILO_ID'
      'STME_NR=111202')
    TableName = 'STOERMELDUNGEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 567
    Top = 309
  end
  object LuSILO: TLookUpDef
    DataSet = TblSILO
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_ID=:SILO_ID')
    SOList.Strings = (
      'SPS_CODE=:SILO_SPS_CODE'
      'SILO_ID=:SILO_ID'
      'SILO_NR=:SILO_NR'
      'SO_WERK_NR=:WERK_NR')
    TableName = 'SILOLISTE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 568
    Top = 242
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 566
    Top = 125
  end
  object TblDiPr: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from STOERMELDUNGEN'
      'where (BEIN_NR = '#39'SILO_ID'#39')'
      '  and (STME_NR = 111202)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblDiPrBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 567
    Top = 337
  end
  object TblSILO: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_ID = :SILO_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 568
    Top = 270
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SILO_ID'
      end>
  end
end
