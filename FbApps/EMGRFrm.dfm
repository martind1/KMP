object FrmEMGR: TFrmEMGR
  Left = 328
  Top = 439
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'E-Mail Gruppen'
  ClientHeight = 472
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -15
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
  TextHeight = 17
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 610
    Height = 447
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
        Top = 403
        Width = 579
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 401
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
        Width = 579
        Height = 403
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -15
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        ColumnList.Strings = (
          'Gruppenname:11=EMGR_NAME'
          'Modus:5=SR_FLAG'
          'Adressen:28=EMGR_ADR'
          'Bemerkung:33=BEMERKUNG')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 21
        Drag0Value = '0'
        DragFieldName = 'ENCH_POS'
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
        Top = 70
        Width = 579
        Height = 369
        ActivePage = tsAllgemein
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 367
        object tsAllgemein: TTabSheet
          Caption = 'Allgemein'
          object qSplitter1: TqSplitter
            Left = 0
            Top = 240
            Width = 571
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
            ExplicitTop = 238
          end
          object sbAllgemein: TScrollBox
            Left = 0
            Top = 0
            Width = 571
            Height = 240
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object pcAdressen: TPageControl
              Left = 0
              Top = 0
              Width = 571
              Height = 240
              ActivePage = tsReceiver
              Align = alClient
              Style = tsButtons
              TabOrder = 0
              object tsSender: TTabSheet
                Caption = 'tsSender'
                ImageIndex = 1
                TabVisible = False
                ExplicitLeft = 0
                ExplicitTop = 0
                ExplicitWidth = 0
                ExplicitHeight = 0
                object Label6: TLabel
                  Left = 8
                  Top = 12
                  Width = 28
                  Height = 17
                  Caption = 'Von:'
                end
                object EdEMGR_ADR_Sender: TDBEdit
                  Left = 64
                  Top = 10
                  Width = 292
                  Height = 25
                  DataField = 'EMGR_ADR'
                  DataSource = LDataSource1
                  TabOrder = 0
                end
              end
              object tsReceiver: TTabSheet
                Caption = 'tsReceiver'
                TabVisible = False
                object qSplitter2: TqSplitter
                  Left = 0
                  Top = 105
                  Width = 563
                  Height = 4
                  Cursor = crVSplit
                  Align = alTop
                  Color = clGray
                  ParentColor = False
                end
                object Panel1: TPanel
                  Left = 0
                  Top = 0
                  Width = 563
                  Height = 105
                  Align = alTop
                  BevelOuter = bvNone
                  TabOrder = 0
                  object Label5: TLabel
                    Left = 8
                    Top = 12
                    Width = 40
                    Height = 17
                    Caption = 'E-Mail'
                  end
                  object Label3: TLabel
                    Left = 8
                    Top = 38
                    Width = 21
                    Height = 17
                    Caption = 'An:'
                  end
                  object edEMGR_ADR: TDBMemo
                    Tag = 64
                    Left = 64
                    Top = 36
                    Width = 292
                    Height = 63
                    Color = clWhite
                    DataField = 'EMGR_ADR'
                    DataSource = LDataSource1
                    ScrollBars = ssVertical
                    TabOrder = 0
                    WordWrap = False
                  end
                  object EdAdr: TEdit
                    Left = 64
                    Top = 10
                    Width = 292
                    Height = 25
                    TabOrder = 1
                  end
                  object BtnAdrAdd: TBitBtn
                    Left = 358
                    Top = 11
                    Width = 50
                    Height = 21
                    Hint = 'hinzuf'#252'gen'
                    Caption = '>> &An'
                    TabOrder = 2
                    OnClick = BtnAdrAddClick
                  end
                  object BtnAdrCC: TBitBtn
                    Left = 414
                    Top = 11
                    Width = 50
                    Height = 21
                    Hint = 'hinzuf'#252'gen'
                    Caption = '>> &CC'
                    TabOrder = 3
                    OnClick = BtnAdrCCClick
                  end
                end
                object Panel5: TPanel
                  Left = 0
                  Top = 109
                  Width = 563
                  Height = 121
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 1
                  object Label4: TLabel
                    Left = 8
                    Top = 6
                    Width = 26
                    Height = 17
                    Caption = 'CC:'
                  end
                  object edEMGR_CC: TDBMemo
                    Tag = 64
                    Left = 64
                    Top = 4
                    Width = 292
                    Height = 63
                    Color = clWhite
                    DataField = 'EMGR_CC'
                    DataSource = LDataSource1
                    ScrollBars = ssVertical
                    TabOrder = 0
                    WordWrap = False
                  end
                end
              end
            end
          end
          object GroupBox2: TGroupBox
            Left = 0
            Top = 244
            Width = 571
            Height = 93
            Align = alBottom
            Caption = 'Bemerkung'
            Constraints.MinHeight = 46
            TabOrder = 1
            object edBEMERKUNG: TDBMemo
              Left = 2
              Top = 19
              Width = 567
              Height = 72
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
        object tsEMAI: TTabSheet
          Caption = 'E-Mails'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
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
            Top = 315
            Width = 571
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
          end
          object GbStatisitk: TGroupBox
            Left = 0
            Top = 99
            Width = 571
            Height = 216
            Align = alClient
            Caption = 'Ref.Integr.'
            Constraints.MinHeight = 24
            TabOrder = 0
            object ScrollBox3: TScrollBox
              Left = 2
              Top = 19
              Width = 567
              Height = 195
              HorzScrollBar.Tracking = True
              VertScrollBar.Tracking = True
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 0
            end
          end
          object gbIntern: TGroupBox
            Left = 0
            Top = 319
            Width = 571
            Height = 16
            Align = alBottom
            Caption = 'Intern'
            Constraints.MinHeight = 2
            TabOrder = 1
            object ScrollBox4: TScrollBox
              Left = 2
              Top = 19
              Width = 567
              Height = 235
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
            Width = 571
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
              Left = 234
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
              Left = 253
              Top = 66
              Width = 142
              Height = 25
              Hint = 'Prim'#228'rschl'#252'ssel'
              DataField = 'EMGR_NAME'
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
        Width = 579
        Height = 70
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 12
          Width = 48
          Height = 17
          Caption = 'Gruppe'
          FocusControl = edEMGR_NAME
        end
        object Label1: TLabel
          Left = 8
          Top = 37
          Width = 43
          Height = 17
          Caption = 'Modus'
          FocusControl = edEMGR_NAME
        end
        object edEMGR_NAME: TLookUpEdit
          Left = 74
          Top = 10
          Width = 244
          Height = 25
          DataField = 'EMGR_NAME'
          DataSource = LDataSource1
          TabOrder = 0
          Options = []
          KeyField = True
        end
        object Panel4: TPanel
          Left = 74
          Top = 35
          Width = 247
          Height = 25
          BevelOuter = bvNone
          TabOrder = 1
          object rgSR_FLAG: TAswRadioGroup
            Left = -8
            Top = -13
            Width = 145
            Height = 37
            Columns = 2
            DataField = 'SR_FLAG'
            DataSource = LDataSource1
            Items.Strings = (
              'Von:'
              'An:')
            ParentBackground = True
            TabOrder = 0
            Values.Strings = (
              'Von:'
              'An:')
            AswName = 'EmgrSrFlag'
            Frame = frNone
          end
        end
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 447
    Width = 610
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
    FormKurz = 'EMGR'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    PollInterval = 500
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
      'SR_FLAG=Asw,EmgrSrFlag')
    KeyList.Strings = (
      'Standard=EMGR_NAME')
    PrimaryKeyFields = 'EMGR_NAME;SR_FLAG'
    TableName = 'dbo.EMGR'
    TabTitel = 'E-Mails'
    OnErfass = NavErfass
    Left = 279
    Top = 72
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnDataChange = LDataSource1DataChange
    Left = 223
    Top = 72
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.EMGR')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 251
    Top = 72
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
    Left = 331
    Top = 70
  end
  object PopupMenu1: TPopupMenu
    Left = 296
    Top = 192
    object MiAdrDel: TMenuItem
      Caption = 'Zeile l'#246'schen'
      ShortCut = 46
    end
  end
end
