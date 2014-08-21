object FrmEMAI: TFrmEMAI
  Left = 353
  Top = 277
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'E-Mails'
  ClientHeight = 592
  ClientWidth = 933
  Color = clBtnFace
  Enabled = False
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
  WindowState = wsMinimized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 17
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 933
    Height = 567
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
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
      object Panel2: TPanel
        Left = 0
        Top = 523
        Width = 902
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
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
        object Label9: TLabel
          Left = 704
          Top = 10
          Width = 62
          Height = 15
          Caption = 'rot = Fehler'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 508
          Top = 9
          Width = 107
          Height = 17
          Alignment = taRightJustify
          Caption = 'aktualisieren alle'
          FocusControl = edEMGR_FROM
        end
        object Label16: TLabel
          Left = 784
          Top = 10
          Width = 95
          Height = 15
          Caption = 'gr'#252'n = zu senden'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGreen
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
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
        object EdWaitTime: TEdit
          Left = 624
          Top = 7
          Width = 57
          Height = 25
          TabOrder = 1
          Text = '60s'
        end
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 64
        Width = 902
        Height = 459
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -15
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        OnDrawDataCell = Mu1DrawDataCell
        ColumnList.Strings = (
          'von:7=EMGR_FROM'
          'an:12=EMGR_TO'
          'Betreff:30=EMAI_SUBJECT'
          'gesendet:4=SENDE_STATUS'
          'am:10=SENDE_DATUM'
          'Fehler:30=SENDE_FEHLER')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 21
        Drag0Value = '0'
        DragFieldName = 'ENCH_POS'
      end
      object gbDevice: TGroupBox
        Left = 0
        Top = 0
        Width = 902
        Height = 64
        Align = alTop
        Caption = 'Steuerung'
        TabOrder = 2
        object BtnAuto: TSpeedButton
          Left = 8
          Top = 25
          Width = 137
          Height = 25
          AllowAllUp = True
          GroupIndex = 808
          Caption = 'Automatik'
          OnClick = BtnAutoClick
        end
        object Label11: TLabel
          Left = 176
          Top = 27
          Width = 42
          Height = 17
          Caption = 'Schritt'
        end
        object LaStatus: TLabel
          Left = 492
          Top = 27
          Width = 58
          Height = 17
          Caption = 'LaStatus'
        end
        object cobStep: TComboBox
          Left = 232
          Top = 25
          Width = 228
          Height = 25
          TabOrder = 1
          Text = 'cobStep'
          Items.Strings = (
            '0=keine Automatik'
            '10=Ersten Lesen'
            '20=N'#228'chste Lesen'
            '30=Warten')
        end
        object EdStep: TEdit
          Left = 232
          Top = 25
          Width = 210
          Height = 25
          ReadOnly = True
          TabOrder = 0
          Text = '..Init'
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
        Top = 124
        Width = 902
        Height = 435
        ActivePage = tsAllgemein
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 433
        object tsAllgemein: TTabSheet
          Caption = 'Allgemein'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object qSplitter1: TqSplitter
            Left = 0
            Top = 270
            Width = 894
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
            ExplicitTop = 268
          end
          object sbAllgemein: TScrollBox
            Left = 0
            Top = 0
            Width = 894
            Height = 270
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            ExplicitHeight = 268
            object Label3: TLabel
              Left = 8
              Top = 12
              Width = 63
              Height = 17
              Caption = 'Gesendet'
              FocusControl = cobSENDE_STATUS
            end
            object Label6: TLabel
              Left = 265
              Top = 12
              Width = 21
              Height = 17
              Alignment = taRightJustify
              Caption = 'am'
              FocusControl = edSENDE_DATUM
            end
            object Label13: TLabel
              Left = 8
              Top = 35
              Width = 64
              Height = 17
              Caption = 'Fehlertext'
              FocusControl = edSENDE_FEHLER
            end
            object Label14: TLabel
              Left = 8
              Top = 160
              Width = 26
              Height = 17
              Caption = 'Text'
              FocusControl = edEMAI_TEXT
            end
            object Label15: TLabel
              Left = 8
              Top = 60
              Width = 57
              Height = 17
              Caption = 'Anh'#228'nge'
            end
            object Label18: TLabel
              Left = 8
              Top = 110
              Width = 69
              Height = 17
              Caption = 'Platzhalter'
            end
            object cobSENDE_STATUS: TAswComboBox
              Left = 90
              Top = 10
              Width = 145
              Height = 25
              AutoComplete = False
              DataField = 'SENDE_STATUS'
              DataSource = LDataSource1
              Items.Strings = (
                'Nein'
                'Ja'
                'Fehler')
              TabOrder = 0
              AswName = 'Gesendet'
            end
            object edSENDE_DATUM: TDBEdit
              Left = 296
              Top = 10
              Width = 142
              Height = 25
              DataField = 'SENDE_DATUM'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 1
            end
            object edSENDE_FEHLER: TDBEdit
              Tag = 128
              Left = 90
              Top = 35
              Width = 687
              Height = 25
              DataField = 'SENDE_FEHLER'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 2
            end
            object edEMAI_TEXT: TDBMemo
              Tag = 384
              Left = 90
              Top = 160
              Width = 185
              Height = 89
              DataField = 'EMAI_TEXT'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 3
            end
            object edRCP_LIST: TDBMemo
              Tag = 128
              Left = 90
              Top = 110
              Width = 655
              Height = 50
              DataField = 'RCP_LIST'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 4
            end
            object EdEMAI_ATTACHMENTS: TDBMemo
              Tag = 128
              Left = 90
              Top = 60
              Width = 655
              Height = 50
              DataField = 'EMAI_ATTACHMENTS'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 5
            end
          end
          object GroupBox2: TGroupBox
            Left = 0
            Top = 274
            Width = 894
            Height = 129
            Align = alBottom
            Caption = 'Bemerkung'
            Constraints.MinHeight = 46
            TabOrder = 1
            object edBEMERKUNG: TDBMemo
              Left = 2
              Top = 19
              Width = 890
              Height = 108
              Align = alClient
              DataField = 'BEMERKUNG'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
        object tsExcelabfragen: TTabSheet
          Caption = 'Zusatzdaten'
          ImageIndex = 3
          object gbQuelltext: TGroupBox
            Left = 0
            Top = 41
            Width = 894
            Height = 362
            Align = alClient
            Caption = 'Quelltext'
            TabOrder = 0
            object edEMAI_SOURCE: TDBMemo
              Left = 2
              Top = 19
              Width = 890
              Height = 341
              Align = alClient
              DataField = 'EMAI_SOURCE'
              DataSource = LDataSource1
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 894
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object BtnShowInOE: TBitBtn
              Left = 8
              Top = 8
              Width = 121
              Height = 25
              Hint = 'Outlook Express'
              Caption = 'Anzeigen in '
              Glyph.Data = {
                9E050000424D9E05000000000000360400002800000014000000120000000100
                08000000000068010000C40E0000C40E00000001000000000000C8D0D400FFFF
                FF0073737300CECECE00AD7B7B00FFF7EF00FF8C0800FF94000084525200BD63
                2900F7A55A00C69C9400FF5A3100DEAD8400F7F7E700FFBD5A00EF6B4200FFC6
                8400F7941800FFAD31007394D600B58C7300AD7B6B0094634A00F7F7F700FFAD
                2900C6734200F7DEAD00FF9C0800D6A58400C6947B00A56B6B0094636300E79C
                5A00EF841000E7522900FFF7E700D6846300EF7B0800AD4A1800FF732100FFDE
                AD00EF943900C68C7B00FF940800AD6B4200FFEFBD00EFB58C00FFA510006B52
                4A00FFE7AD00FFBD6300AD735200DE8C5200BD523900D6D6D600EF523100944A
                1800294A8400F7EFDE00A5634200F7E7D600B57B5A00FFFFF700000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000002020200000000000000
                00000000000000000002092D310200000000000000000000000002020926282C
                131702023E020202000000000008082122251306303316080708080200000000
                00170E0E0E241B120713110F0705040200000000002001010101011B1C1C0F11
                0705040200000000001F01011803030303121907070504020000000000160101
                010101010C1038100C0504020000000000150101180303030303373B3D050402
                000000000015010C10231A2B0101013A1405040200000000001E0106060C2705
                01010114143F040200000000001D01060F191209010101010105040200000000
                000D0D060D0A112A090B0B0B0B0B0400000000000000000600000A292F09361A
                3C00000000000000000000000000000A2E323539000000000000000000000000
                000000000A0A3400000000000000000000000000000000000000000000000000
                0000}
              Layout = blGlyphRight
              Spacing = 0
              TabOrder = 0
              OnClick = BtnShowInOEClick
            end
          end
        end
        object tsEinstellungen: TTabSheet
          Caption = 'Einstellungen'
          ImageIndex = 3
          object ScrollBox1: TScrollBox
            Left = 0
            Top = 0
            Width = 894
            Height = 403
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object gbSMTP: TGroupBox
              Left = 0
              Top = 0
              Width = 894
              Height = 131
              Align = alTop
              Caption = 'SMTP'
              TabOrder = 0
              object lbAccount: TLabel
                Left = 8
                Top = 72
                Width = 75
                Height = 17
                Caption = 'Kontoname'
                FocusControl = edSMTPAccount
              end
              object lbPassword: TLabel
                Left = 8
                Top = 97
                Width = 62
                Height = 17
                Caption = 'Kennwort'
                FocusControl = edSMTPPassword
              end
              object Label4: TLabel
                Left = 8
                Top = 22
                Width = 77
                Height = 17
                Caption = 'Server, Port'
              end
              object edSMTPAccount: TEdit
                Left = 105
                Top = 70
                Width = 145
                Height = 25
                TabOrder = 4
              end
              object edSMTPPassword: TEdit
                Left = 105
                Top = 95
                Width = 145
                Height = 25
                PasswordChar = '*'
                TabOrder = 5
                Text = 'passowrd'
              end
              object EdSMTPServer: TEdit
                Left = 105
                Top = 20
                Width = 255
                Height = 25
                TabOrder = 0
                Text = 'mailto.yourserver.com'
              end
              object EdSMTPPort: TEdit
                Left = 360
                Top = 20
                Width = 41
                Height = 25
                TabOrder = 1
                Text = '25'
              end
              object chbSmtpAuth: TCheckBox
                Left = 7
                Top = 47
                Width = 111
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Anmelden'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
              object chbSmtpAfterPop: TCheckBox
                Left = 179
                Top = 47
                Width = 194
                Height = 17
                Alignment = taLeftJustify
                Caption = 'erfordert POP-Anmeldung'
                TabOrder = 3
                Visible = False
              end
            end
            object gbIgnoreDouble: TGroupBox
              Left = 0
              Top = 131
              Width = 894
              Height = 56
              Align = alTop
              Caption = 'Doppelte Ignorieren'
              TabOrder = 1
              object Label5: TLabel
                Left = 152
                Top = 22
                Width = 186
                Height = 17
                Caption = 'wenn gleiche Mail bereits vor'
              end
              object Label8: TLabel
                Left = 412
                Top = 22
                Width = 76
                Height = 17
                Caption = 's  gesendet'
              end
              object edIgnoreDoublesSecs: TEdit
                Left = 344
                Top = 20
                Width = 65
                Height = 25
                TabOrder = 1
                Text = '3600'
              end
              object chbIgnoreDoubles: TCheckBox
                Left = 7
                Top = 22
                Width = 111
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Ignorieren'
                TabOrder = 0
              end
            end
            object GroupBox3: TGroupBox
              Left = 0
              Top = 187
              Width = 894
              Height = 56
              Align = alTop
              Caption = 'Anwendungsserver Mailversand'
              TabOrder = 2
              object Label12: TLabel
                Left = 8
                Top = 22
                Width = 65
                Height = 17
                Caption = 'Host, Port'
              end
              object EdAppServer: TEdit
                Left = 105
                Top = 20
                Width = 255
                Height = 25
                Hint = #196'nderungen werden erst nach Neustart '#252'bernommen'
                TabOrder = 0
                Text = 'zak2'
              end
              object EdAppPort: TEdit
                Left = 360
                Top = 20
                Width = 65
                Height = 25
                Hint = #196'nderungen werden erst nach Neustart '#252'bernommen'
                TabOrder = 1
                Text = '23451'
              end
            end
            object GroupBox4: TGroupBox
              Left = 0
              Top = 243
              Width = 894
              Height = 81
              Align = alTop
              Caption = 'Oberfl'#228'che'
              TabOrder = 3
              object Label17: TLabel
                Left = 127
                Top = 48
                Width = 21
                Height = 17
                Alignment = taRightJustify
                Caption = 'um'
              end
              object chbTexteLaden: TCheckBox
                Left = 7
                Top = 24
                Width = 118
                Height = 17
                Hint = 'langsam aber notwendig im Servermodus'
                Alignment = taLeftJustify
                Caption = 'Mailtexte laden'
                Checked = True
                State = cbChecked
                TabOrder = 0
              end
              object EdClearStatsTime: TEdit
                Left = 160
                Top = 46
                Width = 73
                Height = 25
                TabOrder = 2
                Text = '03:00'
              end
              object BtnClearStatsTime: TTimeBtn
                Left = 233
                Top = 46
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
                TabOrder = 3
                DBEdit = EdClearStatsTime
                StartTime = '07:00'
              end
              object chbClearStatsStarted: TCheckBox
                Left = 296
                Top = 48
                Width = 176
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Intern: heute ausgef'#252'hrt'
                Checked = True
                State = cbChecked
                TabOrder = 4
              end
              object chbClearStatsAktiv: TCheckBox
                Left = 7
                Top = 48
                Width = 112
                Height = 17
                Alignment = taLeftJustify
                Caption = 'drop statistics'
                TabOrder = 1
              end
            end
            object BtnSaveToIni: TBitBtn
              Left = 16
              Top = 336
              Width = 177
              Height = 25
              Caption = 'Einstellungen speichern'
              TabOrder = 4
              OnClick = BtnSaveToIniClick
            end
          end
        end
        object tsSystem: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          object SplitterIntern: TqSplitter
            Left = 0
            Top = 383
            Width = 894
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
            ExplicitTop = 381
          end
          object GbStatisitk: TGroupBox
            Left = 0
            Top = 99
            Width = 894
            Height = 284
            Align = alClient
            Caption = 'Ref.Integr.'
            Constraints.MinHeight = 24
            TabOrder = 0
            object ScrollBox3: TScrollBox
              Left = 2
              Top = 19
              Width = 890
              Height = 263
              HorzScrollBar.Tracking = True
              VertScrollBar.Tracking = True
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 0
              object lbStatus: TListBox
                Left = 8
                Top = 8
                Width = 193
                Height = 97
                Hint = 'lbStatus'
                ItemHeight = 17
                TabOrder = 0
              end
            end
          end
          object gbIntern: TGroupBox
            Left = 0
            Top = 387
            Width = 894
            Height = 16
            Align = alBottom
            Caption = 'Intern'
            Constraints.MinHeight = 2
            TabOrder = 1
            object ScrollBox4: TScrollBox
              Left = 2
              Top = 19
              Width = 890
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
            Width = 894
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
              Left = 322
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
              Left = 341
              Top = 66
              Width = 142
              Height = 25
              Hint = 'Prim'#228'rschl'#252'ssel'
              DataField = 'EMAI_ID'
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
        Width = 902
        Height = 124
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 12
          Width = 79
          Height = 17
          Caption = 'Gruppe von:'
          FocusControl = edEMGR_FROM
        end
        object Label1: TLabel
          Left = 8
          Top = 37
          Width = 72
          Height = 17
          Caption = 'Gruppe an:'
          FocusControl = edEMGR_TO
        end
        object Label7: TLabel
          Left = 8
          Top = 86
          Width = 43
          Height = 17
          Caption = 'Betreff'
          FocusControl = edEMAI_SUBJECT
        end
        object edEMGR_FROM: TLookUpEdit
          Left = 98
          Top = 10
          Width = 244
          Height = 25
          DataField = 'EMGR_FROM'
          DataSource = LDataSource1
          TabOrder = 0
          Options = []
          LookupSource = LuEMGR_S
          LookupField = 'EMGR_NAME'
          KeyField = True
        end
        object edEMGR_TO: TLookUpEdit
          Left = 98
          Top = 35
          Width = 244
          Height = 25
          DataField = 'EMGR_TO'
          DataSource = LDataSource1
          TabOrder = 3
          Options = []
          LookupSource = LuEMGR_R
          LookupField = 'EMGR_NAME'
          KeyField = True
        end
        object edEMAI_SUBJECT: TDBEdit
          Tag = 128
          Left = 98
          Top = 84
          Width = 503
          Height = 25
          DataField = 'EMAI_SUBJECT'
          DataSource = LDataSource1
          TabOrder = 6
        end
        object edEMAI_FROM: TLookUpEdit
          Left = 374
          Top = 10
          Width = 244
          Height = 25
          DataField = 'EMAI_FROM'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 2
          Options = [LeReadOnly]
          LookupSource = LuEMGR_S
          LookupField = 'EMGR_ADR'
          KeyField = False
        end
        object edEMAI_TO: TLookUpEdit
          Tag = 128
          Left = 374
          Top = 35
          Width = 244
          Height = 25
          DataField = 'EMAI_TO'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 5
          Options = [LeReadOnly]
          LookupSource = LuEMGR_R
          LookupField = 'EMGR_ADR'
          KeyField = False
        end
        object BtnEMGR_FROM: TLookUpBtn
          Left = 343
          Top = 10
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
          TabOrder = 1
          LookUpEdit = edEMGR_FROM
          LookUpDef = LuEMGR_S
          Modus = lubMulti
        end
        object BtnEMGR_TO: TLookUpBtn
          Left = 343
          Top = 35
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
          TabOrder = 4
          LookUpEdit = edEMGR_TO
          LookUpDef = LuEMGR_R
          Modus = lubMulti
        end
        object edEMAI_CC: TLookUpEdit
          Tag = 128
          Left = 374
          Top = 59
          Width = 244
          Height = 25
          DataField = 'EMAI_CC'
          DataSource = LDataSource1
          ReadOnly = True
          TabOrder = 7
          Options = [LeReadOnly]
          LookupSource = LuEMGR_R
          LookupField = 'EMGR_CC'
          KeyField = False
        end
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 567
    Width = 933
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
    FormKurz = 'EMAI'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    PollInterval = 500
    OnPoll = NavPoll
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
      'SENDE_STATUS=Asw,Gesendet')
    KeyList.Strings = (
      'Standard=EMAI_ID desc')
    PrimaryKeyFields = 'EMAI_ID'
    SqlFieldList.Strings = (
      'EMGR_FROM'
      'EMGR_TO'
      'EMAI_FROM'
      'EMAI_TO'
      'EMAI_CC'
      'EMAI_SUBJECT'
      'EMAI_ATTACHMENTS'
      'SENDE_STATUS'
      'SENDE_DATUM'
      'SENDE_FEHLER'
      'EMAI_ID'
      'ERFASST_VON'
      'ERFASST_AM'
      'GEAENDERT_VON'
      'GEAENDERT_AM'
      'ANZAHL_AENDERUNGEN'
      'BEMERKUNG'
      'EMAI_TEXT'
      'EMAI_SOURCE'
      'RCP_LIST')
    TableName = 'EMAI'
    TabTitel = 'E-Mails'
    OnErfass = NavErfass
    BeforePost = NavBeforePost
    Left = 431
    Top = 102
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 375
    Top = 102
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select EMGR_FROM,'
      '       EMGR_TO,'
      '       EMAI_FROM,'
      '       EMAI_TO,'
      '       EMAI_CC,'
      '       EMAI_SUBJECT,'
      '       EMAI_ATTACHMENTS,'
      '       SENDE_STATUS,'
      '       SENDE_DATUM,'
      '       SENDE_FEHLER,'
      '       EMAI_ID,'
      '       ERFASST_VON,'
      '       ERFASST_AM,'
      '       GEAENDERT_VON,'
      '       GEAENDERT_AM,'
      '       ANZAHL_AENDERUNGEN,'
      '       BEMERKUNG,'
      '       EMAI_TEXT,'
      '       EMAI_SOURCE,'
      '       RCP_LIST'
      'from EMAI')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    AfterPost = Query1AfterPost
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 403
    Top = 102
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
    Left = 779
    Top = 102
  end
  object LuEMGR_S: TLookUpDef
    DataSet = TblEMGR_S
    LuKurz = 'EMGR'
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
    FltrList.Strings = (
      'SR_FLAG=S')
    FormatList.Strings = (
      'SR_FLAG=Asw,EmgrSrFlag')
    KeyList.Strings = (
      'Standard=EMGR_NAME')
    PrimaryKeyFields = 'EMGR_NAME;SR_FLAG'
    References.Strings = (
      'EMGR_NAME=:EMGR_FROM'
      'SR_FLAG=S')
    SOList.Strings = (
      'EMGR_NAME=:EMGR_FROM'
      'EMGR_ADR=:EMAI_FROM')
    TableName = 'EMGR'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 468
    Top = 102
  end
  object TblEMGR_S: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMGR'
      'where (EMGR_NAME = :EMGR_FROM)'
      '  and (SR_FLAG = '#39'S'#39')')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 496
    Top = 102
    ParamData = <
      item
        DataType = ftFixedChar
        Name = 'EMGR_FROM'
      end>
  end
  object LuEMGR_R: TLookUpDef
    DataSet = TblEMGR_R
    LuKurz = 'EMGR'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luTolerant, luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'SR_FLAG=R')
    FormatList.Strings = (
      'SR_FLAG=Asw,EmgrSrFlag')
    KeyList.Strings = (
      'Standard=EMGR_NAME')
    PrimaryKeyFields = 'EMGR_NAME;SR_FLAG'
    References.Strings = (
      'EMGR_NAME=:EMGR_TO'
      'SR_FLAG=R')
    SOList.Strings = (
      'EMGR_NAME=:EMGR_TO'
      'EMGR_ADR=:EMAI_TO'
      'EMGR_CC=:EMAI_CC')
    TableName = 'EMGR'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 532
    Top = 102
  end
  object TblEMGR_R: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMGR'
      'where (EMGR_NAME = :EMGR_TO)'
      '  and (SR_FLAG = '#39'R'#39')')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 560
    Top = 102
    ParamData = <
      item
        DataType = ftFixedChar
        Name = 'EMGR_TO'
      end>
  end
  object EmailSendKmp: TEmailSendKmp
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Smtp = False
    SmtpPort = 25
    SmtpAuth = False
    SmtpAfterPop = False
    Left = 812
    Top = 102
  end
  object SMTP: TIdSMTP
    SASLMechanisms = <>
    Left = 840
    Top = 103
  end
  object WsEmai: TWSDDE
    PollIntervall = 5000
    Remote = reHost
    Port = 0
    LineMode = False
    BinaryMode = False
    ProtModus = [wmError, wmWarn, wmConnection, wmData]
    OnChange = WsEmaiChange
    Left = 724
    Top = 102
  end
  object LuKond: TLookUpDef
    DataSet = TblKond
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'EMAI_ID'
    References.Strings = (
      'EMAI_SUBJECT=0'
      'EMAI_ID=0')
    TableName = 'EMAI'
    DisabledButtons = []
    EnabledButtons = []
    Left = 596
    Top = 102
  end
  object TblKond: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMAI'
      'where (EMAI_SUBJECT = '#39'0'#39')'
      '  and (EMAI_ID = '#39'0'#39')')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 624
    Top = 102
  end
  object LuEMAI: TLookUpDef
    DataSet = TblEMAI
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'EMAI_ID'
    References.Strings = (
      'EMAI_ID=0')
    TableName = 'dbo.EMAI'
    DisabledButtons = []
    EnabledButtons = []
    Left = 468
    Top = 142
  end
  object TblEMAI: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.EMAI'
      'where (EMAI_ID = 0)')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 496
    Top = 142
  end
end
