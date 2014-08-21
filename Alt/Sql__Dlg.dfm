object DlgSql: TDlgSql
  Left = 1175
  Top = 302
  Caption = 'SQL ausf'#252'hren'
  ClientHeight = 338
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 298
    Width = 441
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 8
      Top = 4
      Width = 110
      Height = 33
      Style = bsRaised
    end
    object BtnOpen: TBitBtn
      Left = 129
      Top = 3
      Width = 96
      Height = 34
      Caption = '&Open'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      OnClick = BtnOpenClick
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 338
      Top = 3
      Width = 96
      Height = 34
      Cancel = True
      Caption = 'S&chlie'#223'en'
      ModalResult = 2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 3
      OnClick = BtnCancelClick
      IsControl = True
    end
    object BtnExecSQL: TBitBtn
      Left = 233
      Top = 3
      Width = 96
      Height = 34
      Caption = 'E&xecSQL'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 2
      OnClick = BtnExecSQLClick
      IsControl = True
    end
    object RbLive: TCheckBox
      Left = 15
      Top = 12
      Width = 99
      Height = 17
      Caption = '&Request Live'
      TabOrder = 0
    end
  end
  object Detailbook: TPageControl
    Left = 0
    Top = 0
    Width = 441
    Height = 298
    ActivePage = tsHistorie
    Align = alClient
    TabOrder = 1
    OnChange = DetailbookChange
    OnChanging = DetailbookChanging
    object tsSQL: TTabSheet
      Caption = '&SQL Statement'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 340
      object SqlMemo: TMemo
        Left = 0
        Top = 0
        Width = 433
        Height = 267
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = []
        Lines.Strings = (
          'select * from T'
          'where F=V'
          'order by K')
        ParentFont = False
        PopupMenu = PopupMenu1
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TsErgebnis: TTabSheet
      Caption = '&Ergebnis'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 340
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 0
        Width = 433
        Height = 25
        DataSource = DataSource1
        Align = alTop
        Kind = dbnHorizontal
        TabOrder = 0
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 25
        Width = 433
        Height = 242
        Align = alClient
        Color = clWhite
        DataSource = DataSource1
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        PopupMenu = PopupMenu2
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        ReturnSingle = False
        NoColumnSave = False
        MuOptions = [muNoSaveLayout, muNoAskLayout, muNoSlideBar, muAddPopUp]
        DefaultRowHeight = 20
        Drag0Value = '0'
      end
    end
    object tsParameter: TTabSheet
      Caption = '&Parameter'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 340
      object GridParams: TTitleGrid
        Left = 0
        Top = 0
        Width = 433
        Height = 267
        Align = alClient
        ColCount = 2
        DefaultColWidth = 160
        DefaultRowHeight = 17
        FixedCols = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        AdjustWidths = False
        Titles.Strings = (
          'Parameter'
          'Wert')
        TitleOptions = [toNoExpand]
        ColWidths = (
          204
          194)
      end
    end
    object tsSkripte: TTabSheet
      Caption = '&Skripte'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 340
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 433
        Height = 267
        ActivePage = TabSheet3
        Align = alClient
        MultiLine = True
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = 'AlterColumn'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LbAlterColumn: TListBox
            Left = 0
            Top = 0
            Width = 425
            Height = 215
            Align = alClient
            Items.Strings = (
              'ALTER TABLE #Table#'
              '  ADD TMP_#Col# #Format#;'
              'update #Table#'
              '  set TMP_#Col# = #Col#;'
              'ALTER TABLE #Table#'
              '  DROP #Col#;'
              'ALTER TABLE #Table#'
              '  ADD #Neu# #Format#;'
              'update #Table#'
              '  set #Neu# = TMP_#Col#;'
              'ALTER TABLE #Table#'
              '  DROP TMP_#Col#;')
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'AlterColumnMSSQL'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LbAlterColumnMsSql: TListBox
            Left = 0
            Top = 0
            Width = 425
            Height = 215
            Align = alClient
            Items.Strings = (
              'ALTER TABLE #Table#'
              '  ADD TMP_#Col# #Format#;'
              'update #Table#'
              '  set TMP_#Col# = #Col#;'
              'update #Table#'
              '  set #Neu# = null;'
              'ALTER TABLE #Table#'
              '  ALTER COLUMN #Neu# #Format#;'
              'update #Table#'
              '  set #Neu# = TMP_#Col#;'
              'ALTER TABLE #Table#'
              '  DROP COLUMN TMP_#Col#;')
            TabOrder = 0
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'AlterColumnOra'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LbAlterColumnOra: TListBox
            Left = 0
            Top = 0
            Width = 425
            Height = 215
            Align = alClient
            Items.Strings = (
              'ALTER TABLE #Table#'
              '  ADD TMP_#Col# #Format#;'
              'update #Table#'
              '  set TMP_#Col# = #Col#;'
              'update #Table#'
              '  set #Neu# = null;'
              'ALTER TABLE #Table#'
              '  MODIFY(#Neu# #Format#);'
              'update #Table#'
              '  set #Neu# = TMP_#Col#;'
              'ALTER TABLE #Table#'
              '  DROP COLUMN TMP_#Col#;')
            TabOrder = 0
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Duplicates'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object LbDuplicates: TListBox
            Left = 0
            Top = 0
            Width = 425
            Height = 215
            Align = alClient
            Items.Strings = (
              'select #Col#, count(*) as ANZ'
              'from #Table#'
              'group by #Col#'
              'having count(*) > 1')
            TabOrder = 0
          end
        end
        object tsOraObjects: TTabSheet
          Caption = 'OraObjects'
          ImageIndex = 4
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lbOraObjects: TListBox
            Left = 0
            Top = 0
            Width = 425
            Height = 215
            Align = alClient
            Items.Strings = (
              'Select object_name, object_type, status '
              'from sys.DBA_OBJECTS'
              'WHERE  owner = '#39'#owner'#39
              '  and object_type = '#39'#type'#39
              '  and status = '#39'INVALID'#39)
            TabOrder = 0
          end
        end
      end
    end
    object tsHistorie: TTabSheet
      Caption = '&Historie'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 340
      object qSplitter1: TqSplitter
        Left = 0
        Top = 220
        Width = 433
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        Color = clGray
        ParentColor = False
        ExplicitTop = 33
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 433
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object LaHistPos: TLabel
          Left = 88
          Top = 8
          Width = 62
          Height = 16
          Caption = 'LaHistPos'
        end
        object BtnHistPrior: TBitBtn
          Left = 24
          Top = 4
          Width = 25
          Height = 25
          Glyph.Data = {
            66010000424D6601000000000000760000002800000014000000140000000100
            040000000000F000000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777700007777777777777777777700007777777777777777777700007777
            77777C7777777777000077777777CC777777777700007777777CCC7777777777
            0000777777CCCC7777777777000077777CCCCCCCCCCCC77700007777CCCCCCCC
            CCCCC7770000777CCCCCCCCCCCCCC7770000777FCCCCCCCCCCCCC77700007777
            FCCCCCCCCCCCC777000077777FCCCCFFFFFFF7770000777777FCCC7777777777
            00007777777FCC7777777777000077777777FC77777777770000777777777F77
            7777777700007777777777777777777700007777777777777777777700007777
            77777777777777770000}
          TabOrder = 0
          OnClick = BtnHistPriorClick
        end
        object BtnHistNext: TBitBtn
          Left = 49
          Top = 4
          Width = 24
          Height = 25
          Glyph.Data = {
            66010000424D6601000000000000760000002800000014000000140000000100
            040000000000F000000000000000000000001000000010000000000000000000
            BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777700007777777777777777777700007777777777777777777700007777
            777777C77777777700007777777777CC7777777700007777777777CCC7777777
            00007777777777CCCC7777770000777CCCCCCCCCCCC777770000777CCCCCCCCC
            CCCC77770000777CCCCCCCCCCCCCC7770000777CCCCCCCCCCCCCF7770000777C
            CCCCCCCCCCCF77770000777FFFFFFFCCCCF7777700007777777777CCCF777777
            00007777777777CCF777777700007777777777CF7777777700007777777777F7
            7777777700007777777777777777777700007777777777777777777700007777
            77777777777777770000}
          TabOrder = 1
          OnClick = BtnHistNextClick
        end
      end
      object MeHistResult: TMemo
        Left = 0
        Top = 224
        Width = 433
        Height = 43
        Align = alBottom
        Lines.Strings = (
          'MeHistResult')
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object MeHistSql: TMemo
        Left = 0
        Top = 33
        Width = 433
        Height = 187
        Align = alClient
        Lines.Strings = (
          'MeHistSql')
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 304
    Top = 240
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 336
    Top = 240
    object MiSqlDelete: TMenuItem
      Caption = 'SQL L'#246'schen'
      ShortCut = 16430
      OnClick = MiSqlDeleteClick
    end
    object MiFileOpen: TMenuItem
      Caption = 'Datei '#214'ffnen'
      ShortCut = 16463
      OnClick = MiFileOpenClick
    end
    object MiFileSave: TMenuItem
      Caption = 'Datei Speichern'
      ShortCut = 16467
      OnClick = MiFileSaveClick
    end
    object MiAlterColumn: TMenuItem
      Caption = 'Feldformat '#228'ndern'
      OnClick = MiAlterColumnClick
    end
    object MiDuplicates: TMenuItem
      Caption = 'Duplikate listen'
      OnClick = MiDuplicatesClick
    end
    object MiExplainPlan: TMenuItem
      Caption = 'Explain Plan'
      Hint = 'nur f'#252'r Oracle implementiert'
      OnClick = MiExplainPlanClick
    end
    object Oracle1: TMenuItem
      Caption = 'Oracle'
      object MiOraCompileInvalidObjects: TMenuItem
        Caption = 'Compile invalid objects'
        OnClick = MiOraCompileInvalidObjectsClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MiRequestLive: TMenuItem
      Caption = 'Lebendige Ergebnismenge'
      OnClick = MiRequestLiveClick
    end
    object MiPassthroughSQL: TMenuItem
      Caption = 'Passthrough SQL'
      Hint = 'Versoppelung von '#39':'#39
      OnClick = MiPassthroughSQLClick
    end
    object MiDisconnect: TMenuItem
      Caption = 'Disconnect'
      OnClick = MiDisconnectClick
    end
    object MiDataSet: TMenuItem
      Caption = 'DataSet ...'
      Hint = 'Aktive Datasets (X = ge'#246'ffnet)'
      OnClick = MiDataSetClick
    end
    object Transaktion1: TMenuItem
      Caption = 'Transaktion'
      Visible = False
      object MiTransactionStart: TMenuItem
        Caption = 'Start'
        OnClick = MiTransactionStartClick
      end
      object MiTransactionCommit: TMenuItem
        Caption = 'Commit'
        OnClick = MiTransactionCommitClick
      end
      object MiTransactionRollBack: TMenuItem
        Caption = 'RollBack'
        OnClick = MiTransactionRollBackClick
      end
    end
    object MiProc: TMenuItem
      Caption = 'Stored procedure'
      OnClick = MiProcClick
    end
    object MiUnidirectional: TMenuItem
      Caption = 'Unidirectional'
      OnClick = MiUnidirectionalClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MiProtBeforeOpen: TMenuItem
      Caption = 'Interne Protokollierung'
      OnClick = MiProtBeforeOpenClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'sql'
    Filter = 'SQL-Text (*.sql)|*.sql|Text (*.txt)|*.txt|Alle (*.*)|*.*'
    Options = [ofFileMustExist]
    Title = 'Datei '#214'ffnen'
    Left = 368
    Top = 240
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'slq'
    Filter = 'SQL-Text (*.sql)|*.sql|Text (*.txt)|*.txt|Alle (*.*)|*.*'
    Title = 'Datei Speichern'
    Left = 400
    Top = 240
  end
  object PopupMenu2: TPopupMenu
    Left = 336
    Top = 272
    object MiMarkAll: TMenuItem
      Caption = 'Alles markieren'
      ShortCut = 16461
      OnClick = MiMarkAllClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MiLoopSql: TMenuItem
      Caption = 'Loop Sql'
      Hint = 
        'Sql-Befehl f'#252'r jede Zeile der Ergebnistabelle ausf'#252'hren.'#13#10'Der Bu' +
        'zug auf die Ergebnistabelle erfolgt '#252'ber Parameter (:Feld)'
      OnClick = MiLoopSqlClick
    end
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False'
      'SQL Server.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    AfterOpen = Query1AfterOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 272
    Top = 240
  end
  object QueLoop: TuQuery
    Connection = DlgLogon.Database1
    MasterSource = DataSource1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False'
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 284
    Top = 195
  end
  object StoredProc1: TuStoredProc
    StoredProcName = 'AUFP_DISP'
    Connection = DlgLogon.Database1
    DatabaseName = 'DB1'
    Left = 276
    Top = 267
  end
end
