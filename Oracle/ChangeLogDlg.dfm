object DlgChangeLog: TDlgChangeLog
  Left = 275
  Top = 363
  Caption = 'ChangeLog Trigger erstellen'
  ClientHeight = 384
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 343
    Width = 539
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnRun: TBitBtn
      Left = 272
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Erstellen'
      TabOrder = 0
      OnClick = BtnRunClick
    end
    object BtnClose: TBitBtn
      Left = 352
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Schlie'#223'en'
      TabOrder = 1
      OnClick = BtnCloseClick
    end
  end
  object DetailBook: TPageControl
    Left = 0
    Top = 0
    Width = 539
    Height = 343
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Vorgaben'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 531
        Height = 57
        Caption = 'XML Template'
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 42
          Height = 13
          Caption = 'Filename'
        end
        object EdXmlFilename: TEdit
          Left = 80
          Top = 22
          Width = 377
          Height = 21
          TabOrder = 0
        end
        object btnXmlSelect: TBitBtn
          Left = 457
          Top = 22
          Width = 24
          Height = 24
          Hint = 'Ausw'#228'hlen'
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Layout = blGlyphBottom
          Margin = 5
          NumGlyphs = 2
          ParentFont = False
          TabOrder = 1
          OnClick = btnXmlSelectClick
        end
        object btnXmlOpen: TBitBtn
          Left = 481
          Top = 22
          Width = 24
          Height = 24
          Hint = #214'ffnen'
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
          NumGlyphs = 2
          TabOrder = 2
          OnClick = btnXmlOpenClick
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 57
        Width = 531
        Height = 128
        Caption = 'Tabelle'
        TabOrder = 1
        object Label2: TLabel
          Left = 16
          Top = 24
          Width = 28
          Height = 13
          Caption = 'Name'
        end
        object Label3: TLabel
          Left = 16
          Top = 48
          Width = 29
          Height = 13
          Caption = 'K'#252'rzel'
        end
        object Label6: TLabel
          Left = 16
          Top = 72
          Width = 51
          Height = 13
          Caption = 'PKEY Feld'
        end
        object Label8: TLabel
          Left = 16
          Top = 96
          Width = 50
          Height = 13
          Caption = 'Info Felder'
        end
        object cobTableName: TComboBox
          Left = 80
          Top = 22
          Width = 251
          Height = 21
          TabOrder = 4
          Text = 'cobTableName'
          OnChange = cobTableNameChange
          OnDropDown = cobTableNameDropDown
        end
        object EdTableName: TEdit
          Left = 80
          Top = 22
          Width = 233
          Height = 21
          TabOrder = 0
        end
        object EdShort: TEdit
          Left = 80
          Top = 46
          Width = 81
          Height = 21
          TabOrder = 1
        end
        object edPKEY_FIELD: TEdit
          Left = 80
          Top = 70
          Width = 233
          Height = 21
          Hint = 'mehrer Feldnamen mit Komma trennen'
          TabOrder = 2
        end
        object EdINFO_FIELD: TEdit
          Left = 80
          Top = 94
          Width = 441
          Height = 21
          Hint = 
            'F'#252'r Ausgabe bei Insert und Delete.'#13#10'mehrer Feldnamen mit Komma t' +
            'rennen.'
          TabOrder = 3
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 185
        Width = 531
        Height = 80
        Caption = 'STME'
        TabOrder = 2
        object Label4: TLabel
          Left = 16
          Top = 24
          Width = 49
          Height = 13
          Caption = 'STME NR'
        end
        object Label5: TLabel
          Left = 16
          Top = 48
          Width = 55
          Height = 13
          Caption = 'WERK_NR'
        end
        object edSTME_NR: TEdit
          Left = 80
          Top = 22
          Width = 73
          Height = 21
          TabOrder = 0
        end
        object EdWERK_NR: TEdit
          Left = 80
          Top = 46
          Width = 73
          Height = 21
          Hint = ':WERK -> :new/old.werk. BDE -> '#39'BDE'#39
          TabOrder = 1
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 266
        Width = 529
        Height = 41
        Caption = 'Ignorierte Felder'
        TabOrder = 3
        object EdIgnoredFields: TEdit
          Left = 8
          Top = 16
          Width = 513
          Height = 21
          Hint = 'mehrere Felder mit '#39';'#39' trennen'
          TabOrder = 0
          Text = 
            'ANZAHL_AENDERUNGEN;GEAENDERT_AM;ERFASST_VON;ERFASST_AM;ERFASST_D' +
            'ATENBANK;GEAENDERT_VON;GEAENDERT_DATENBANK'
        end
      end
    end
    object tsErgebnis: TTabSheet
      Caption = 'Ergebnis'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MeSQL: TMemo
        Left = 0
        Top = 0
        Width = 531
        Height = 259
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 259
        Width = 531
        Height = 56
        Align = alBottom
        Caption = 'SQL Ergebnis'
        TabOrder = 1
        object BtnSqlSave: TBitBtn
          Left = 9
          Top = 22
          Width = 96
          Height = 25
          Hint = 'Ausw'#228'hlen'
          Caption = 'Speichern'
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
            7700333333337777777733333333008088003333333377F73377333333330088
            88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
            000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
            FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
            99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
            99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
            99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
            93337FFFF7737777733300000033333333337777773333333333}
          NumGlyphs = 2
          TabOrder = 0
          OnClick = BtnSqlSaveClick
        end
        object BtnSqlCopy: TBitBtn
          Left = 112
          Top = 22
          Width = 97
          Height = 25
          Caption = 'Kopieren'
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333330B7FFF
            FFB0333333777F3333773333330B7FFFFFB0333333777F3333773333330B7FFF
            FFB0333333777F3333773333330B7FFFFFB03FFFFF777FFFFF77000000000077
            007077777777777777770FFFFFFFF00077B07F33333337FFFF770FFFFFFFF000
            7BB07F3FF3FFF77FF7770F00F000F00090077F77377737777F770FFFFFFFF039
            99337F3FFFF3F7F777FF0F0000F0F09999937F7777373777777F0FFFFFFFF999
            99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
            99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
            93337FFFF7737777733300000033333333337777773333333333}
          NumGlyphs = 2
          TabOrder = 1
          OnClick = BtnSqlCopyClick
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'System'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 8
        Top = 8
        Width = 42
        Height = 13
        Caption = 'Filename'
      end
      object lbParse: TListBox
        Left = 0
        Top = 32
        Width = 225
        Height = 145
        Hint = 'Zuordnungen'
        ItemHeight = 13
        TabOrder = 0
      end
      object EdSqlFileName: TEdit
        Left = 72
        Top = 6
        Width = 377
        Height = 21
        TabOrder = 1
      end
    end
  end
  object dlgXml: TOpenDialog
    DefaultExt = 'XLS'
    FileName = 'Report'
    Filter = 'XML (*.xml)|*.xml|*.*|*.*'
    Options = [ofEnableSizing]
    Left = 426
    Top = 35
  end
  object Nav: TLNavigator
    DetailBook = DetailBook
    FormKurz = 'ChangeLogDlg'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = []
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 256
    Top = 8
  end
  object LDataSource1: TLDataSource
    DataSet = Query1
    Left = 288
    Top = 8
  end
  object DlgSql: TOpenDialog
    DefaultExt = 'XLS'
    FileName = 'Report'
    Filter = 'SQL (*.sql)|*.sql|*.*|*.*'
    Options = [ofEnableSizing]
    Left = 426
    Top = 283
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    ReadOnly = True
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False'
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = False
    UpdateMode = upWhereAll
    Left = 320
    Top = 8
  end
end
