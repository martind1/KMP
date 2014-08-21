object FrmBACKUP: TFrmBACKUP
  Left = 602
  Top = 423
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Datensicherung'
  ClientHeight = 442
  ClientWidth = 970
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
    Width = 970
    Height = 442
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsSingle: TTabSheet
      Caption = 'Detail'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DetailControl: TPageControl
        Left = 0
        Top = 201
        Width = 942
        Height = 233
        ActivePage = tsEinstellungen
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 231
        object tsAllgemein: TTabSheet
          Caption = 'Protokoll'
          object sbAllgemein: TScrollBox
            Left = 0
            Top = 0
            Width = 934
            Height = 203
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object lbProt: TListBox
              Left = 0
              Top = 0
              Width = 934
              Height = 203
              Align = alClient
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Courier New'
              Font.Style = []
              ItemHeight = 14
              ParentFont = False
              TabOrder = 0
            end
          end
        end
        object tsEinstellungen: TTabSheet
          Caption = 'Einstellungen'
          ImageIndex = 1
          object Label6: TLabel
            Left = 8
            Top = 72
            Width = 181
            Height = 15
            Caption = 'Sql: (#D=Database #F=Filename'
          end
          object Label5: TLabel
            Left = 8
            Top = 10
            Width = 125
            Height = 15
            Caption = 'Dateimaske auf Server'
          end
          object Label3: TLabel
            Left = 504
            Top = 12
            Width = 168
            Height = 14
            Caption = '#T=Wochentag #D=Datum, #Z=Zeit'
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 8
            Top = 42
            Width = 24
            Height = 15
            Caption = 'SQL'
          end
          object LaSQL: TStaticText
            Left = 8
            Top = 88
            Width = 827
            Height = 19
            Caption = 
              'BACKUP DATABASE [#D] TO  DISK = N'#39'#F'#39' WITH NOFORMAT, INIT,  NAME' +
              ' = N'#39'#D-Full Database Backup'#39', SKIP, NOREWIND, NOUNLOAD,  STATS ' +
              '= 10'
            TabOrder = 0
          end
          object EdMask: TEdit
            Left = 160
            Top = 8
            Width = 337
            Height = 23
            TabOrder = 1
            Text = 'c:\mssql\backup\dpeeur#T.bak'
            OnChange = FileChange
          end
          object EdSQL: TEdit
            Tag = 128
            Left = 48
            Top = 40
            Width = 337
            Height = 23
            ReadOnly = True
            TabOrder = 2
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 942
        Height = 201
        Align = alTop
        Caption = 'Vorgaben'
        TabOrder = 0
        object Label76: TLabel
          Left = 16
          Top = 26
          Width = 42
          Height = 15
          Caption = 'Sichern'
        end
        object Label1: TLabel
          Left = 203
          Top = 26
          Width = 18
          Height = 15
          Alignment = taRightJustify
          Caption = 'um'
          FocusControl = EdZeit
        end
        object Label4: TLabel
          Left = 16
          Top = 138
          Width = 61
          Height = 15
          Caption = 'Dateiname'
        end
        object Label2: TLabel
          Left = 16
          Top = 106
          Width = 105
          Height = 15
          Caption = 'N'#228'chste Sicherung'
        end
        object BtnAuto: TSpeedButton
          Left = 136
          Top = 168
          Width = 75
          Height = 25
          AllowAllUp = True
          GroupIndex = 1658
          Caption = 'Automatik'
          OnClick = BtnAutoClick
        end
        object EdZeit: TEdit
          Left = 234
          Top = 24
          Width = 69
          Height = 23
          Hint = 'leerlassen f'#252'r 1 Tag'
          TabOrder = 1
          OnChange = FileChange
        end
        object EdFilename: TEdit
          Left = 96
          Top = 136
          Width = 337
          Height = 23
          ReadOnly = True
          TabOrder = 4
          Text = 'EdFilename'
          OnChange = EdFilenameChange
        end
        object BtnStart: TBitBtn
          Left = 16
          Top = 168
          Width = 75
          Height = 25
          Hint = 'Manuell starten'
          Caption = 'Start'
          TabOrder = 5
          OnClick = BtnStartClick
        end
        object cobIntervall: TComboBox
          Left = 80
          Top = 24
          Width = 97
          Height = 23
          TabOrder = 0
          Text = 't'#228'glich'
          Items.Strings = (
            't'#228'glich')
        end
        object BtnZeit: TTimeBtn
          Left = 304
          Top = 24
          Width = 21
          Height = 21
          Glyph.Data = {
            36080000424D3608000000000000360000002800000020000000100000000100
            2000000000000008000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000FFFFFF00000000000000000000000000000000000000
            0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
            00000000000000000000000000000000FF000000FF000000FF000000FF000000
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
            0000000000000000FF000000FF0000404000FFFFFF00FFFFFF00FFFFFF000040
            40000000FF000000FF0000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000FFFFFF000000
            0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
            00000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF000000FFFFFF00FFFF
            FF00FFFFFF000000FF000000FF00000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FFFFFF0000000000000000000000
            00000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FF000000FFFFFF000000FF00000000000000000000000000000000000000
            000000000000000000000000000000000000FFFFFF0000000000000000000000
            000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
            FF0000404000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00004040000000FF000000000000000000000000000000
            0000FFFFFF0000000000000000000000000000000000FFFFFF00000000000000
            00000000000000000000000000000000000000000000FFFFFF00000000000000
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000FF000000000000000000000000000000
            0000FFFFFF0000000000FFFFFF00000000000000000000000000FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
            FF00FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF000000FF00000000000000
            00000000000000000000FFFFFF000000FF000000000000000000000000000000
            0000FFFFFF000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FFFFFF00000000000000
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF000000FF000000000000000000000000000000
            0000FFFFFF000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000FFFFFF00000000000000
            FF0000404000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00004040000000FF000000000000000000000000000000
            0000FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
            000000000000FFFFFF0000000000000000000000000000000000000000000000
            00000000FF00FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FF000000FFFFFF000000FF00000000000000000000000000000000000000
            000000000000FFFFFF0000000000000000000000000000000000FFFFFF000000
            000000000000000000000000000000000000FFFFFF0000000000000000000000
            00000000FF000000FF00FFFFFF00FFFFFF00FFFFFF00FF000000FFFFFF00FFFF
            FF00FFFFFF000000FF000000FF00000000000000000000000000000000000000
            00000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FF000000FF0000404000FFFFFF00FF000000FFFFFF000040
            40000000FF000000FF0000000000000000000000000000000000000000000000
            0000000000000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
            FF00000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000FF000000FF000000FF000000FF000000
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000}
          NumGlyphs = 2
          TabOrder = 2
          DBEdit = EdZeit
          StartTime = '07:00'
        end
        object EdStartDT: TEdit
          Left = 138
          Top = 104
          Width = 167
          Height = 23
          Hint = 'leerlassen f'#252'r 1 Tag'
          ReadOnly = True
          TabOrder = 3
        end
      end
    end
  end
  object Nav: TLNavigator
    PageBook = PageControl
    DetailBook = DetailControl
    FormKurz = 'VEXP'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnPostStart = NavPostStart
    OnSetTitel = NavSetTitel
    PollInterval = 10000
    OnPoll = NavPoll
    AutoCommit = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    CalcList.Strings = (
      'cfPKEY=string:250'
      'cfVollKg=float:3'
      'cfLeerKg=float:3')
    Bemerkung.Strings = (
      '[References]'
      'ANZ_VOLL=<>[ANZ_LEER]'
      '->'#252'ber Abfrage regeln')
    KeyFields = 'VORF_NR'
    KeyList.Strings = (
      'Standard=VORF_NR;POS')
    PrimaryKeyFields = 'VORF_NR'
    Left = 386
    Top = 21
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 356
    Top = 21
  end
end
