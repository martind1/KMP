object FrmDATNED: TFrmDATNED
  Left = 692
  Top = 486
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Dateien Editor'
  ClientHeight = 405
  ClientWidth = 785
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
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 785
    Height = 405
    ActivePage = tsMulti
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsMulti: TTabSheet
      Tag = 1
      Caption = #220'bersicht'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object panTop: TPanel
        Left = 0
        Top = 0
        Width = 757
        Height = 65
        Align = alTop
        TabOrder = 0
        object LaLocalBase: TLabel
          Left = 8
          Top = 10
          Width = 140
          Height = 15
          Caption = 'Lokales Basisverzeichnis'
        end
        object LaOrdner: TLabel
          Left = 8
          Top = 34
          Width = 38
          Height = 15
          Caption = 'Ordner'
        end
        object EdLocalBase: TEdit
          Left = 168
          Top = 8
          Width = 321
          Height = 23
          TabOrder = 0
          Text = 'c:\temp\dateien'
          OnChange = EdLocalBaseChange
          OnExit = EdLocalBaseExit
        end
        object BtnLocalBase: TBitBtn
          Tag = 11
          Left = 490
          Top = 8
          Width = 21
          Height = 21
          Hint = 'Ausw'#228'hlen'
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Layout = blGlyphBottom
          Margin = 2
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
          OnClick = BtnLocalBaseClick
        end
        object cobOrdner: TComboBox
          Tag = 128
          Left = 64
          Top = 32
          Width = 537
          Height = 23
          DropDownCount = 30
          TabOrder = 2
          Text = '\'
          OnChange = cobOrdnerChange
          OnDropDown = cobOrdnerDropDown
          Items.Strings = (
            '1'
            '2'
            '3')
        end
        object BtnNewOrdner: TBitBtn
          Tag = 11
          Left = 603
          Top = 32
          Width = 21
          Height = 21
          Hint = 'Neuer Ordner'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
            0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
            33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          Layout = blGlyphBottom
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 3
          OnClick = BtnNewOrdnerClick
        end
        object BtnLocalBaseOpen: TBitBtn
          Tag = 11
          Left = 514
          Top = 8
          Width = 21
          Height = 21
          Hint = 'lokalen Ordner im Explorer '#214'ffnen'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555555555555555555555555555555555555555555555555555555555555
            555555555555555555555555555555555555555FFFFFFFFFF555550000000000
            55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
            B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
            000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
            555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
            55555575FFF75555555555700007555555555557777555555555555555555555
            5555555555555555555555555555555555555555555555555555}
          Layout = blGlyphBottom
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 4
          OnClick = BtnLocalBaseOpenClick
        end
      end
      object panCenter: TPanel
        Left = 0
        Top = 65
        Width = 757
        Height = 332
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Splitter1: TqSplitter
          Left = 314
          Top = 0
          Width = 31
          Height = 332
          Beveled = True
          Color = 13160660
          ParentColor = False
          OnMoved = Splitter1Moved
          ExplicitHeight = 330
        end
        object lbMu1ColsLokal: TListBox
          Left = 40
          Top = 112
          Width = 121
          Height = 97
          ItemHeight = 15
          Items.Strings = (
            'T:9=TYP'
            'Section:25=SECTION')
          TabOrder = 0
          Visible = False
        end
        object PanLokal: TPanel
          Left = 0
          Top = 0
          Width = 314
          Height = 332
          Align = alLeft
          BevelOuter = bvNone
          Constraints.MinWidth = 314
          TabOrder = 1
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 314
            Height = 16
            Align = alTop
            Caption = 'Lokal'
            Color = clBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Panel3: TPanel
            Left = 0
            Top = 305
            Width = 314
            Height = 27
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object BtnImport: TBitBtn
              Left = 2
              Top = 2
              Width = 104
              Height = 25
              Caption = 'Import'
              TabOrder = 0
              OnClick = MiImportClick
            end
            object Panel5: TPanel
              Left = 210
              Top = 0
              Width = 104
              Height = 27
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 1
              object BtnCheckOut: TBitBtn
                Left = 0
                Top = 2
                Width = 104
                Height = 25
                Hint = 'Lokal aktualisieren'
                Caption = 'CheckOut'
                TabOrder = 0
                OnClick = BtnCheckOutClick
              end
            end
            object BtnFileOpen: TBitBtn
              Left = 106
              Top = 2
              Width = 104
              Height = 25
              Caption = #214'ffnen'
              TabOrder = 2
              OnClick = MiFileOpenClick
            end
          end
          object MuLokal: TMultiGrid
            Left = 0
            Top = 16
            Width = 314
            Height = 289
            Align = alClient
            DataSource = LuLokal
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            PopupMenu = PopupLokal
            TabOrder = 2
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -12
            TitleFont.Name = 'Arial'
            TitleFont.Style = []
            OnDrawDataCell = MuLokalDrawDataCell
            OnDblClick = MiFileOpenClick
            ColumnList.Strings = (
              'Filename:15=FILENAME'
              'Datum:17=FILETIME')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit, muAddPopUp]
            DefaultRowHeight = 19
            Drag0Value = '0'
          end
        end
        object PanDB: TPanel
          Left = 345
          Top = 0
          Width = 412
          Height = 332
          Align = alClient
          BevelOuter = bvNone
          Constraints.MinWidth = 106
          TabOrder = 2
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 412
            Height = 16
            Align = alTop
            Caption = 'Datenbank'
            Color = clBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Panel4: TPanel
            Left = 0
            Top = 305
            Width = 412
            Height = 27
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object BtnCheckIn: TBitBtn
              Left = 2
              Top = 2
              Width = 104
              Height = 25
              Hint = 'Datenbank aktualisieren'
              Caption = 'CheckIn'
              TabOrder = 0
              OnClick = BtnCheckInClick
            end
            object BtnDatnVer: TBitBtn
              Left = 122
              Top = 2
              Width = 119
              Height = 25
              Hint = 'Programmversion auf Datenbanken verteilen'
              Caption = 'Update verteilen'
              TabOrder = 1
              OnClick = BtnDatnVerClick
            end
          end
          object Mu1: TMultiGrid
            Left = 0
            Top = 16
            Width = 412
            Height = 289
            Align = alClient
            DataSource = LDataSource1
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 2
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -12
            TitleFont.Name = 'Arial'
            TitleFont.Style = []
            OnDrawDataCell = Mu1DrawDataCell
            ColumnList.Strings = (
              'Filename:15=FILENAME'
              'Datum:17=FILETIME')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit]
            DefaultRowHeight = 19
            Drag0Value = '0'
          end
        end
        object BtnToLeftMarked: TBitBtn
          Left = 324
          Top = 38
          Width = 21
          Height = 21
          Hint = 'Markierte nach lokal kopieren'
          Caption = '<'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = BtnToLeftMarkedClick
        end
        object BtnToRightMarked: TBitBtn
          Left = 324
          Top = 68
          Width = 21
          Height = 21
          Hint = 'Markierte nach Datenbank kopieren'
          Caption = '>'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = BtnToRightMarkedClick
        end
        object BtnToLeftAll: TBitBtn
          Left = 324
          Top = 98
          Width = 21
          Height = 21
          Hint = 'Alle nach lokal kopieren'
          Caption = '<<'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          OnClick = BtnToLeftAllClick
        end
        object BtnToRightAll: TBitBtn
          Left = 324
          Top = 128
          Width = 21
          Height = 21
          Hint = 'Alle nach Datenbank kopieren'
          Caption = '>>'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
          OnClick = BtnToRightAllClick
        end
      end
    end
    object tsImplementierung: TTabSheet
      Caption = 'Verwendung'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbOrdner: TListBox
        Left = 0
        Top = 18
        Width = 757
        Height = 338
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Items.Strings = (
          '\LOGON\=Logon Bitmaps (LOGO.BMP)'
          '\SDBL\FAXSEND\=SDBL Vorlagen Fax- und manueller Versand'
          '\SDBL\CUSTOMERPACKAGE\=SDBL New Customer Package Vorlagen'
          '\QUPE\REPORTS\=QUPE List&Label Reports')
        ParentFont = False
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 757
        Height = 18
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'von den Anwendungen verwendete Ordner:'
        TabOrder = 1
      end
      object Panel8: TPanel
        Left = 0
        Top = 356
        Width = 757
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object BtnAddOrdner: TBitBtn
          Left = 8
          Top = 8
          Width = 129
          Height = 25
          Hint = 'legt markierten Anwendungsordner an'
          Caption = 'Ordner anlegen'
          TabOrder = 0
          OnClick = BtnAddOrdnerClick
        end
      end
    end
  end
  object Nav: TLNavigator
    PageBook = PageControl
    FormKurz = 'DATNED'
    AutoEditStart = True
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    Bemerkung.Strings = (
      'VERB_PRIO=000.#####')
    KeyList.Strings = (
      'Standard=ORDNER;FILENAME')
    PrimaryKeyFields = 'DATN_ID'
    SqlFieldList.Strings = (
      'ORDNER'
      'FILENAME'
      'FILETIME'
      'GEAENDERT_AM'
      'DATN_ID')
    TableName = 'R_DATN'
    Left = 418
    Top = 183
  end
  object LDataSource1: TLDataSource
    DataSet = Query1
    Left = 360
    Top = 183
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
    Left = 448
    Top = 183
  end
  object LuLokal: TLookUpDef
    DataSet = TblLokal
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle, nlNoOpenSMess]
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    DisabledButtons = []
    EnabledButtons = [qnbInsert, qnbDelete, qnbEdit]
    BeforeDelete = LuLokalBeforeDelete
    BeforeDeleteMarked = LuLokalBeforeDeleteMarked
    Left = 244
    Top = 183
  end
  object PopupLokal: TPopupMenu
    Left = 204
    Top = 183
    object MiFileOpen: TMenuItem
      Caption = #214'ffnen'
      OnClick = MiFileOpenClick
    end
    object MiImport: TMenuItem
      Caption = 'Importieren'
      OnClick = MiImportClick
    end
    object MiRefresh: TMenuItem
      Caption = 'Aktualisieren'
      OnClick = MiRefreshClick
    end
  end
  object DlgFileOpen: TOpenDialog
    Filter = '*.*'
    Left = 652
    Top = 14
  end
  object DlgFileImport: TOpenDialog
    Filter = '*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 652
    Top = 46
  end
  object TblLokal: TuMemTable
    Left = 272
    Top = 183
    Data = {03000000000000000000}
  end
  object JvBrowseForFolderDialog: TJvBrowseForFolderDialog
    Left = 701
    Top = 13
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select ORDNER,'
      '       FILENAME,'
      '       FILETIME,'
      '       GEAENDERT_AM,'
      '       DATN_ID'
      'from R_DATN')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False'
      'SQL Server.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 388
    Top = 183
  end
end
