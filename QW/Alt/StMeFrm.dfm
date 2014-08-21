object FrmStMe: TFrmStMe
  Left = 255
  Top = 503
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'St'#246'rmeldungen'
  ClientHeight = 413
  ClientWidth = 726
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
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object PageBook: TqNoteBook
    Left = 0
    Top = 0
    Width = 726
    Height = 413
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Single'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 726
        Height = 413
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object DetailBook: TTabbedNotebook
          Left = 0
          Top = 0
          Width = 726
          Height = 413
          Align = alClient
          TabFont.Charset = ANSI_CHARSET
          TabFont.Color = clBlack
          TabFont.Height = -12
          TabFont.Name = 'Arial'
          TabFont.Style = []
          TabOrder = 0
          OnChange = DetailBookChange
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Aktuell'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuAktuell: TMultiGrid
              Left = 0
              Top = 0
              Width = 718
              Height = 356
              Align = alClient
              DataSource = LDataSource1
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              OnDblClick = BtnDetailsClick
              ColumnList.Strings = (
                'Herkunft:4=BEIN_NR'
                'Datum Zeit:17=LIEGTAN_AM'
                'L:1=LIEGTAN'
                'Meldungstext:40=STME_TEXT')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout, muNoSlideBar]
              DefaultRowHeight = 19
              Drag0Value = '0'
            end
            object Panel1: TPanel
              Left = 0
              Top = 356
              Width = 718
              Height = 27
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              object BtnStop: TSpeedButton
                Left = 0
                Top = 2
                Width = 41
                Height = 25
                Hint = 'Aktualisierung wird gestoppt'
                AllowAllUp = True
                GroupIndex = 1226
                Caption = 'Stop'
              end
              object LaStatus: TLabel
                Left = 72
                Top = 7
                Width = 35
                Height = 15
                Caption = 'Status'
              end
              object Panel2: TPanel
                Left = 414
                Top = 0
                Width = 304
                Height = 27
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 0
                object BtnQuitt: TBitBtn
                  Left = 235
                  Top = 2
                  Width = 69
                  Height = 25
                  Caption = 'Quittieren'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 0
                  OnClick = BtnQuittClick
                end
                object BtnIgnore: TBitBtn
                  Left = 155
                  Top = 2
                  Width = 72
                  Height = 25
                  Caption = 'Ignorieren'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 1
                  OnClick = BtnIgnoreClick
                end
                object BtnSenden: TBitBtn
                  Left = 78
                  Top = 2
                  Width = 59
                  Height = 25
                  Hint = 'Meldung an Systemverwalter senden'
                  Caption = 'Senden'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 2
                  OnClick = BtnSendenClick
                end
                object BtnDetails: TBitBtn
                  Left = 6
                  Top = 2
                  Width = 59
                  Height = 25
                  Hint = 'Zus'#228'tzliche Informationen zu dieser Meldung'
                  Caption = 'Details'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 3
                  OnClick = BtnDetailsClick
                end
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Ignoriert'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuIgnore: TMultiGrid
              Left = 0
              Top = 0
              Width = 718
              Height = 356
              Align = alClient
              DataSource = LuIgnore
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'Herkunft:4=BEIN_NR'
                'Datum Zeit:17=LIEGTAN_AM'
                'L:1=LIEGTAN'
                'Meldungstext:40=STME_TEXT'
                'ID:5=STME_ID')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout]
              DefaultRowHeight = 19
              Drag0Value = '0'
            end
            object Panel3: TPanel
              Left = 0
              Top = 356
              Width = 718
              Height = 27
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              object Panel4: TPanel
                Left = 445
                Top = 0
                Width = 273
                Height = 27
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 0
                object BtnIgnQuitt: TBitBtn
                  Left = 205
                  Top = 2
                  Width = 68
                  Height = 25
                  Hint = 'nach Aktuell verschieben'
                  Caption = 'Beachten'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 0
                  OnClick = BtnIgnQuittClick
                end
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Quittiert'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuQuittiert: TMultiGrid
              Left = 0
              Top = 0
              Width = 718
              Height = 356
              Align = alClient
              DataSource = LuQuittiert
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'Herkunft:4=BEIN_NR'
                'Datum Zeit:17=LIEGTAN_AM'
                'L:1=LIEGTAN'
                'Meldungstext:40=STME_TEXT'
                'Quitt.am:10=QUITTIERT_AM')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout]
              DefaultRowHeight = 19
              Drag0Value = '0'
            end
            object Panel5: TPanel
              Left = 0
              Top = 356
              Width = 718
              Height = 27
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              object Label7: TLabel
                Left = 8
                Top = 5
                Width = 37
                Height = 15
                Caption = 'Datum'
              end
              object Label17: TLabel
                Left = 212
                Top = 5
                Width = 17
                Height = 15
                Alignment = taRightJustify
                Caption = 'bis'
              end
              object Label18: TLabel
                Left = 365
                Top = 5
                Width = 40
                Height = 15
                Alignment = taRightJustify
                Caption = 'Zeit bis'
              end
              object Panel6: TPanel
                Left = 650
                Top = 0
                Width = 68
                Height = 27
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 0
                object BtnQuittAktivieren: TBitBtn
                  Left = 0
                  Top = 2
                  Width = 68
                  Height = 25
                  Caption = 'Aktivieren'
                  DoubleBuffered = True
                  ParentDoubleBuffered = False
                  TabOrder = 0
                  OnClick = BtnQuittAktivierenClick
                end
              end
              object edFltrDtm: TEdit
                Left = 48
                Top = 3
                Width = 84
                Height = 23
                Hint = 'Datum der Meldung'
                ReadOnly = True
                TabOrder = 1
                Text = 'edFltrDtm'
              end
              object BtnFltrDtm: TDatumBtn
                Left = 134
                Top = 3
                Width = 23
                Height = 23
                Hint = 'Datum der Meldung'
                DoubleBuffered = True
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000C0C0C0C0C0C0
                  C000C0C0C00000000000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C0000000000000000000000000C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0000000
                  000000000000000000000000000000000000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000000000000000
                  000000000000000000000000000000000000000000C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C0000000000000000000000000C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000000000000000000000000080808080008080808080808000808080808080
                  8000808080808080800080808080808080008080808080808000C0C0C0C0C0C0
                  C0000000000000000000000000FFFFFFFF00FFFFFFFFFFFFFF00FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000000000000000000000000000000080000000800000008000000080FFFFFF
                  FF0000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000000080FFFFFF
                  FF0000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF00FFFFFF0000008000000080FFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000FFFFFF000000
                  8000000080FFFFFFFF000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000FFFFFF000000
                  800000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF000000800000008000000080FFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C0808080800080808080808080008080808080808000808080808080
                  8000808080808080800080808080808080008080808080808000}
                ParentDoubleBuffered = False
                TabOrder = 2
                OnClick = BtnFltrDtmClick
                DBEdit = edFltrDtm
                Day = 0
                Month = 0
                Year = 0
              end
              object UpDownDtm: TUpDown
                Left = 157
                Top = 3
                Width = 28
                Height = 23
                Max = 1000
                Orientation = udHorizontal
                Position = 500
                TabOrder = 3
                OnClick = UpDownDtmClick
              end
              object edFltrDtmBis: TEdit
                Left = 232
                Top = 3
                Width = 84
                Height = 23
                Hint = 'Datum der Meldung'
                ReadOnly = True
                TabOrder = 4
              end
              object btnFltrDtmBis: TDatumBtn
                Left = 318
                Top = 3
                Width = 23
                Height = 23
                Hint = 'Datum der Meldung'
                DoubleBuffered = True
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000C0C0C0C0C0C0
                  C000C0C0C00000000000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C0000000000000000000000000C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0000000
                  000000000000000000000000000000000000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000000000000000
                  000000000000000000000000000000000000000000C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C0000000000000000000000000C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0C000C0C0C0C0C0C0
                  C000000000000000000000000080808080008080808080808000808080808080
                  8000808080808080800080808080808080008080808080808000C0C0C0C0C0C0
                  C0000000000000000000000000FFFFFFFF00FFFFFFFFFFFFFF00FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000000000000000000000000000000080000000800000008000000080FFFFFF
                  FF0000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000000080FFFFFF
                  FF0000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF00FFFFFF0000008000000080FFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000FFFFFF000000
                  8000000080FFFFFFFF000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFF00000080000000800000008000FFFFFF000000
                  800000008000000080000000800000008000FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF000000800000008000FFFFFFFFFFFF
                  FF000000800000008000000080FFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C08080808000FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFFFFFFFF
                  FF00FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00FFFFFF8080808000C0C0C0C0C0C0
                  C000C0C0C0808080800080808080808080008080808080808000808080808080
                  8000808080808080800080808080808080008080808080808000}
                ParentDoubleBuffered = False
                TabOrder = 5
                OnClick = btnFltrDtmBisClick
                DBEdit = edFltrDtmBis
                Day = 0
                Month = 0
                Year = 0
              end
              object edFltrTime: TEdit
                Left = 408
                Top = 3
                Width = 84
                Height = 23
                Hint = 'Datum der Meldung'
                TabOrder = 6
                OnChange = edFltrTimeChange
              end
            end
            object BtnMuQuittiert: TBitBtn
              Left = 2
              Top = 2
              Width = 209
              Height = 73
              Caption = 'Daten anzeigen'
              Default = True
              DoubleBuffered = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clTeal
              Font.Height = -19
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentDoubleBuffered = False
              ParentFont = False
              TabOrder = 2
              OnClick = BtnMuQuittiertClick
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Einstellungen'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Panel7: TPanel
              Left = 0
              Top = 0
              Width = 393
              Height = 383
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 0
              object Label12: TLabel
                Left = 8
                Top = 16
                Width = 125
                Height = 15
                Caption = 'Klangdatei bei St'#246'rung'
              end
              object Label13: TLabel
                Left = 8
                Top = 40
                Width = 65
                Height = 15
                Caption = 'Intervall alle'
              end
              object Label14: TLabel
                Left = 112
                Top = 40
                Width = 7
                Height = 15
                Caption = 's'
              end
              object Label5: TLabel
                Left = 8
                Top = 208
                Width = 79
                Height = 15
                Caption = 'Nummernfilter'
              end
              object Label8: TLabel
                Left = 8
                Top = 104
                Width = 43
                Height = 15
                Caption = 'Werk(e)'
              end
              object Label20: TLabel
                Left = 8
                Top = 136
                Width = 46
                Height = 15
                Caption = 'Herkunft'
              end
              object Label9: TLabel
                Left = 26
                Top = 275
                Width = 96
                Height = 15
                Caption = 'Einstellung laden'
              end
              object EdWAV: TEdit
                Left = 136
                Top = 14
                Width = 217
                Height = 23
                TabOrder = 0
              end
              object EdWavSec: TEdit
                Left = 76
                Top = 38
                Width = 33
                Height = 23
                TabOrder = 2
                Text = '10'
                OnChange = EdWavSecChange
              end
              object BtnWavOpen: TBitBtn
                Left = 354
                Top = 14
                Width = 21
                Height = 21
                DoubleBuffered = True
                Glyph.Data = {
                  E6000000424DE60000000000000076000000280000000E0000000E0000000100
                  0400000000007000000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                  33003333333333333300300000000333330000B7B7B7B03333000B0B7B7B7B03
                  33000BB0B7B7B7B033000FBB0000000033000BFB0B0B0B0333000FBFBFBFB003
                  33000BFBFBF00033330030BFBF03333333003800008333333300333333333333
                  33003333333333333300}
                ParentDoubleBuffered = False
                TabOrder = 1
                OnClick = BtnWavOpenClick
              end
              object BtnWavTest: TBitBtn
                Left = 192
                Top = 38
                Width = 75
                Height = 25
                Caption = 'Test Klang'
                DoubleBuffered = True
                ParentDoubleBuffered = False
                TabOrder = 3
                OnClick = BtnWavTestClick
              end
              object cobSTME_NR: TComboBox
                Left = 96
                Top = 230
                Width = 281
                Height = 23
                Style = csDropDownList
                TabOrder = 10
                OnChange = cobSTME_NRChange
                Items.Strings = (
                  'Meldungsnummern AKW Dispo:'
                  '230100..230199 = Disposition'
                  '230200..230299 = Produktion'
                  '230300..230399 = Labor'
                  '230900..230999 = System')
              end
              object edFltrSTME_NR: TEdit
                Left = 96
                Top = 206
                Width = 281
                Height = 23
                Hint = 'Filter f'#252'r eingehende Meldungen'
                TabOrder = 9
              end
              object EdFltrWERK_NR: TEdit
                Left = 96
                Top = 102
                Width = 97
                Height = 23
                Hint = 'Filter f'#252'r eingehende Meldungen'
                TabOrder = 6
                OnExit = EdFltrWERK_NRExit
              end
              object BtnTestStMe: TBitBtn
                Left = 272
                Top = 38
                Width = 105
                Height = 25
                Caption = 'Test St'#246'rmeldung'
                DoubleBuffered = True
                ParentDoubleBuffered = False
                TabOrder = 4
                OnClick = BtnTestStMeClick
              end
              object edFltrBEIN_NR: TEdit
                Left = 96
                Top = 134
                Width = 281
                Height = 23
                Hint = 'Filter f'#252'r Produktgruppen'
                TabOrder = 7
                OnExit = EdFltrWERK_NRExit
              end
              object cobFltrPrdg: TComboBox
                Left = 96
                Top = 158
                Width = 281
                Height = 23
                Style = csDropDownList
                TabOrder = 8
                OnChange = cobFltrPrdgChange
                Items.Strings = (
                  'Gruppe1'
                  'Gruppe2')
              end
              object PanPopup: TPanel
                Left = 8
                Top = 62
                Width = 189
                Height = 24
                BevelOuter = bvNone
                TabOrder = 5
                object chbPopup: TCheckBox
                  Left = -2
                  Top = 2
                  Width = 148
                  Height = 17
                  Hint = 'Neue Meldungen werden in einem Fenster aufgeblendet.'
                  Alignment = taLeftJustify
                  Caption = 'Meldungen aufblenden'
                  TabOrder = 0
                end
              end
              object BtnEinstellungSpeichern: TBitBtn
                Left = 8
                Top = 298
                Width = 153
                Height = 25
                Caption = 'Einstellung speichern'
                DoubleBuffered = True
                ParentDoubleBuffered = False
                TabOrder = 11
                OnClick = BtnEinstellungSpeichernClick
              end
              object cobEinstellungen: TComboBox
                Left = 176
                Top = 273
                Width = 201
                Height = 23
                Hint = 'Name der Einstellung'
                TabOrder = 12
                OnChange = cobEinstellungenChange
              end
              object BtnEinstellungEntfernen: TBitBtn
                Left = 176
                Top = 298
                Width = 153
                Height = 25
                Caption = 'Einstellung entfernen'
                DoubleBuffered = True
                ParentDoubleBuffered = False
                TabOrder = 13
                OnClick = BtnEinstellungEntfernenClick
              end
            end
            object GroupBox1: TGroupBox
              Left = 393
              Top = 0
              Width = 325
              Height = 383
              Align = alClient
              Caption = 'Nummernfilter'
              TabOrder = 1
              object pageStmeNr: TPageControl
                Left = 2
                Top = 17
                Width = 321
                Height = 364
                ActivePage = TabSheet2
                Align = alClient
                MultiLine = True
                RaggedRight = True
                TabOrder = 0
                object TabSheet1: TTabSheet
                  Caption = 'QUVA'
                  ImageIndex = 1
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object ListBox1: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '120100=Auftrag wurde abgeschlossen'
                      '120101=Neuer Auftrag'
                      '120102=Auftrag wurde ge'#228'ndert'
                      '120103=Auftrag wurde neu aktiviert'
                      '120104=Auftrag wurde abgesagt'
                      '120105=Arbeitsanweisung bei Neuauftrag'
                      '12090?=Systemfehler'
                      '120909=Fehler bei Lfs. anlegen'
                      ''
                      '120201=SPS meldet Beladung'
                      ''
                      '111201 Changelog BELADUNGEN'
                      '111202 Changelog SILOLISTE'
                      '111203 Changelog AUFTRAGS_POSITIONEN'
                      '111204 Changelog QUVA.CHARGEN')
                    TabOrder = 0
                  end
                end
                object TabSheet3: TTabSheet
                  Caption = 'QSBT'
                  ImageIndex = 3
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object ListBox3: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '135001=Karte eingelesen'
                      '135008=Statusmeldungen'
                      '135009=Fehlermeldungen'
                      '135010=Labormeldungen'
                      '135011=Kundenvereinbarungen'
                      ''
                      '175102=Terminal Meldung (SH)'
                      ''
                      '[Intern]'
                      '135901 bis 135909=Trigger/Procedure-Fehler'
                      '111201 Changelog BELADUNGEN'
                      '111202 Changelog SILOLISTE'
                      '111203 Changelog AUFTRAGS_POSITIONEN'
                      '111204 Changelog PINFO.KUNDENVEREINBARUNGEN'
                      '111205 Changelog PINFO.KV_SHVERSAND'
                      '111206 Changelog PINFO.KONTINGENTE'
                      '111207 Changelog ???SPS.PROC'
                      '111208 Changelog BELADEEINRICHTUNGEN'
                      '111209 Changelog KARTEN')
                    TabOrder = 0
                  end
                end
                object TabSheet2: TTabSheet
                  Caption = 'QDISPO'
                  ImageIndex = 2
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object ListBox2: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '230101=Dispo:Daten ge'#228'ndert'
                      '230905=Dispo:Dauerauftrag abgelaufen'
                      ''
                      '230201=Produktion:gesperrt'
                      '230202=Freigabe erforderlich'
                      ''
                      '230301=Labor:gesperrt und freigegeben'
                      '230302=Labor:freigegeben'
                      ''
                      '230401=Versand ohne Disposition'
                      '230402=Versand: Bestellmenge erreicht'
                      '230201=Neuen Auftrag anlegen'
                      ''
                      '230901=System:intern'
                      '230902=System:Datenfehler (INFO_1,P.Gruppe)'
                      '230903=Meldung an Systemverwalter'
                      ''
                      '230904=Protokollierung '#196'nderungen DISP'
                      '111203=Changelog AUFTRAGS_POSITIONEN'
                      '230906=Changelog WAGGONINFO')
                    TabOrder = 0
                  end
                end
                object tsSDBL: TTabSheet
                  Caption = 'SDBL'
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object lbStMeNr: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '1001??=SDBL Anwendung'
                      '100101=Sprachkombination fehlt'
                      ''
                      '100105=Freigabe gel'#246'scht'
                      '100106=Klasse 001 fehlt'
                      '100107=(QUVA) Adresse fehlt'
                      '100108=SDBL Revision gel'#246'scht'
                      '100109=Virt.Sprache ge'#228'ndert'
                      ''
                      '100110=Protokollierung '#196'nderungen KUSR'
                      '100111=Protokollierung '#196'nderungen KUPK'
                      ''
                      '10090?=SDBL Triggerfehler'
                      '')
                    TabOrder = 0
                  end
                end
                object TabSheet4: TTabSheet
                  Caption = 'QUPE'
                  ImageIndex = 4
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object ListBox4: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '115101=Vertrieb:neues Lastenheft'
                      '115201=Arbeitsplan freigegeben'
                      '115301=Proben-Ergebnisse vorhanden Benutzer#'
                      '115302=Probe# Ergebnisse vollst'#228'ndig '#252'bernommen'
                      '115303=Probe# Ergebnisse teilweise '#252'bernommen'
                      ''
                      '115900=Triggerfehler'
                      '115901=Ergebnisse ge'#228'ndert'
                      '115902=Proben ge'#228'ndert'
                      '115903=Lastenheft ge'#228'ndert'
                      '115904=VE ge'#228'ndert'
                      '115905=WE ge'#228'ndert'
                      '115906=Rezepturzeile ge'#228'ndert (VSTO)'
                      ''
                      '[Werke]'
                      '0115=allgemein'
                      'S115=strategisch'
                      'K115=kundenorientiert'
                      ''
                      '[Herkunft]'
                      '<Benutzername>=Proben Bearbeiter'
                      'LSTH=Lastenheft'
                      'ARBP=Arbeitsplan'
                      'TRIGGER=von Triggerfehler')
                    TabOrder = 0
                  end
                end
                object TabSheet5: TTabSheet
                  Caption = 'QuPP'
                  ImageIndex = 5
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object ListBox5: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Hint = 'Liste g'#252'ltiger Nummern'
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '115301=Laborergebnisse vorhanden'
                      ''
                      '125900=Triggerfehler'
                      '125901=Gebinde ge'#228'ndert'
                      '125902=Chargenbuch ge'#228'ndert'
                      '125903=Lagermaterial ge'#228'ndert'
                      '125904=Lagersorte ge'#228'ndert'
                      '125905=Verpackung ge'#228'ndert'
                      '125906=Auslagerungsposition ge'#228'ndert'
                      '125907=Auslagerung ge'#228'ndert'
                      '125908=Auslagerung_Gebinde ge'#228'ndert'
                      ''
                      '[Herkunft]'
                      'TRIGGER=von Triggerfehler'
                      'sonst=ID ')
                    TabOrder = 0
                  end
                end
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Benutzer'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuUsSe: TMultiGrid
              Left = 0
              Top = 0
              Width = 718
              Height = 383
              Align = alClient
              DataSource = LuUsSe
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
              PopupMenu = PopupMenuUsSe
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'Benutzername:18=USER_NAME'
                'Session:7=SESSION_NR'
                'ab:18=ERFASST_AM'
                'IP:15=IP_ADR')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout, muCustColor, muAddPopUp]
              DefaultRowHeight = 19
              Drag0Value = '0'
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'S&ystem'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Label1: TLabel
              Left = 160
              Top = 8
              Width = 49
              Height = 15
              Caption = 'Nummer'
            end
            object Label4: TLabel
              Left = 217
              Top = 8
              Width = 42
              Height = 15
              Caption = 'Quittiert'
            end
            object Label2: TLabel
              Left = 99
              Top = 195
              Width = 51
              Height = 15
              Alignment = taRightJustify
              Caption = 'STME_ID'
              FocusControl = edSTME_ID
            end
            object Label6: TLabel
              Left = 73
              Top = 92
              Width = 77
              Height = 15
              Alignment = taRightJustify
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_VON
            end
            object Label10: TLabel
              Left = 44
              Top = 118
              Width = 106
              Height = 15
              Alignment = taRightJustify
              Caption = 'GEAENDERT_VON'
              FocusControl = EditERFASST_AM
            end
            object Label11: TLabel
              Left = 64
              Top = 66
              Width = 86
              Height = 15
              Alignment = taRightJustify
              Caption = 'ERFASST_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label15: TLabel
              Left = 53
              Top = 144
              Width = 97
              Height = 15
              Alignment = taRightJustify
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label16: TLabel
              Left = 3
              Top = 169
              Width = 147
              Height = 15
              Alignment = taRightJustify
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object Label3: TLabel
              Left = 17
              Top = 26
              Width = 133
              Height = 15
              Alignment = taRightJustify
              Caption = 'QUITTIERTE MELDUNG'
              FocusControl = EditGEAENDERT_VON
            end
            object Label19: TLabel
              Left = 275
              Top = 8
              Width = 12
              Height = 15
              Caption = 'ID'
            end
            object Label21: TLabel
              Left = 360
              Top = 56
              Width = 63
              Height = 15
              Caption = 'OpenCount'
            end
            object edSTME_NR: TDBEdit
              Left = 160
              Top = 24
              Width = 52
              Height = 23
              DataField = 'STME_NR'
              DataSource = LuQuittiert
              TabOrder = 0
            end
            object edQUITTIERT: TDBEdit
              Left = 228
              Top = 24
              Width = 21
              Height = 23
              DataField = 'QUITTIERT'
              DataSource = LuQuittiert
              TabOrder = 1
            end
            object gbIntern: TGroupBox
              Left = 632
              Top = 0
              Width = 86
              Height = 383
              Align = alRight
              Caption = 'Intern'
              TabOrder = 2
              object lbIgnore: TListBox
                Left = 2
                Top = 17
                Width = 82
                Height = 364
                Hint = 'lbIgnore'
                Align = alClient
                ItemHeight = 15
                TabOrder = 0
              end
            end
            object BtnEnabled: TBitBtn
              Left = 352
              Top = 16
              Width = 75
              Height = 25
              Hint = 'Wecker bzgl. '#39'aktuell'#39' aktivieren'
              Caption = 'BtnEnabled'
              DoubleBuffered = True
              ParentDoubleBuffered = False
              TabOrder = 3
              OnClick = BtnEnabledClick
            end
            object edSTME_ID: TDBEdit
              Left = 159
              Top = 193
              Width = 84
              Height = 23
              Ctl3D = True
              DataField = 'STME_ID'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 4
            end
            object EditERFASST_VON: TDBEdit
              Left = 159
              Top = 62
              Width = 179
              Height = 23
              Ctl3D = True
              DataField = 'ERFASST_VON'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 5
            end
            object EditERFASST_AM: TDBEdit
              Left = 159
              Top = 88
              Width = 162
              Height = 23
              Ctl3D = True
              DataField = 'ERFASST_AM'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 6
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 159
              Top = 114
              Width = 179
              Height = 23
              Ctl3D = True
              DataField = 'GEAENDERT_VON'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 7
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 159
              Top = 141
              Width = 162
              Height = 23
              Ctl3D = True
              DataField = 'GEAENDERT_AM'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 8
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 159
              Top = 167
              Width = 84
              Height = 23
              Ctl3D = True
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LuQuittiert
              ParentCtl3D = False
              TabOrder = 9
            end
            object DBEdit1: TDBEdit
              Left = 265
              Top = 24
              Width = 75
              Height = 23
              DataField = 'STME_ID'
              DataSource = LDataSource1
              TabOrder = 10
            end
            object edOpenCount: TEdit
              Left = 440
              Top = 54
              Width = 82
              Height = 23
              ReadOnly = True
              TabOrder = 11
            end
          end
        end
      end
    end
  end
  object Nav: TLNavigator
    PageBook = PageBook
    DetailBook = DetailBook
    FormKurz = 'STOE'
    AutoEditStart = False
    PageBookStart = '0'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition, lnDetailClose]
    OnStart = NavStart
    OnPostStart = NavPostStart
    OnSetTitel = NavSetTitel
    PollInterval = 1000
    OnPoll = NavPoll
    OnPageChange = NavPageChange
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    FormatList.Strings = (
      'QUITTIERT=Asw,JNX'
      'LIEGTAN=Asw,JNX')
    KeyFields = 'STME_ID desc'
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'QUITTIERT=N'
      'STME_ID=0')
    SqlFieldList.Strings = (
      '/*+ALL_ROWS */  '
      'STME_NR'
      'WERK_NR'
      'BEIN_NR'
      'STME_TEXT'
      'LIEGTAN'
      'LIEGTAN_AM'
      'QUITTIERT'
      'QUITTIERT_VON'
      'STME_ID'
      'ERFASST_VON'
      'ERFASST_AM'
      'GEAENDERT_VON'
      'GEAENDERT_AM'
      'ANZAHL_AENDERUNGEN')
    TableName = 'STOERMELDUNGEN'
    TabTitel = 'St'#246'rmeldungen'
    OnBuildSql = NavBuildSql
    Left = 65
    Top = 381
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnDataChange = LDataSource1DataChange
    Left = 7
    Top = 381
  end
  object Query1: TuQuery
    BeforeOpen = Query1BeforeOpen
    AfterOpen = Query1AfterOpen
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'select /*+ALL_ROWS */'
      '       STME_NR,'
      '       WERK_NR,'
      '       BEIN_NR,'
      '       STME_TEXT,'
      '       LIEGTAN,'
      '       LIEGTAN_AM,'
      '       QUITTIERT,'
      '       QUITTIERT_VON,'
      '       STME_ID,'
      '       ERFASST_VON,'
      '       ERFASST_AM,'
      '       GEAENDERT_VON,'
      '       GEAENDERT_AM,'
      '       ANZAHL_AENDERUNGEN'
      'from STOERMELDUNGEN'
      'where (QUITTIERT = '#39'N'#39')'
      '  and (STME_ID = '#39'0'#39')'
      'order by STME_ID desc')
    UpdateMode = upWhereKeyOnly
    Left = 35
    Top = 381
  end
  object QueQuittieren: TuQuery
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'update STOERMELDUNGEN'
      'set QUITTIERT='#39'J'#39','
      '   QUITTIERT_AM=:QUITTIERT_AM,'
      '   QUITTIERT_VON=:QUITTIERT_VON'
      'where (STME_ID=:STME_ID)'
      '  and (QUITTIERT='#39'N'#39')')
    Left = 138
    Top = 381
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'QUITTIERT_AM'
        ParamType = ptUnknown
      end
      item
        DataType = ftString
        Name = 'QUITTIERT_VON'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'STME_ID'
        ParamType = ptUnknown
      end>
  end
  object WavOpen: TOpenDialog
    DefaultExt = 'WAV'
    Filter = 'WAVE|*.WAV'
    Left = 324
    Top = 30
  end
  object LuQuittiert: TLookUpDef
    DataSet = TblQuittiert
    OnStateChange = LuQuittiertStateChange
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'STME_ID=STME_ID'
      'ERFASST_AM=ERFASST_VON'
      'GEAENDERT_VON=ERFASST_AM'
      'ERFASST_VON=GEAENDERT_VON'
      'GEAENDERT_AM=GEAENDERT_AM'
      'ANZAHL_AENDERUNGEN=ANZAHL_AENDERUNGEN')
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = False
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'QUITTIERT=J')
    FormatList.Strings = (
      'QUITTIERT=Asw,JNX'
      'LIEGTAN=Asw,JNX')
    KeyList.Strings = (
      'Standard=STME_ID desc')
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'QUITTIERT=J')
    TableName = 'STOERMELDUNGEN'
    DisabledButtons = []
    EnabledButtons = []
    OnBuildSql = LuQuittiertBuildSql
    BeforeQuery = LuQuittiertBeforeQuery
    Left = 188
    Top = 381
  end
  object TblQuittiert: TuQuery
    BeforeOpen = TblQuittiertBeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'select *'
      'from STOERMELDUNGEN'
      'where (QUITTIERT = '#39'J'#39')')
    Left = 216
    Top = 381
  end
  object LuIgnore: TLookUpDef
    DataSet = TblIgnore
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
    FltrList.Strings = (
      'STME_ID==')
    FormatList.Strings = (
      'QUITTIERT=Asw,JNX'
      'LIEGTAN=Asw,JNX')
    KeyFields = 'LIEGTAN_AM desc'
    KeyList.Strings = (
      'Standard=STME_ID desc')
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'STME_ID=='
      'QUITTIERT=N')
    TableName = 'STOERMELDUNGEN'
    DisabledButtons = []
    EnabledButtons = []
    BeforeQuery = LuIgnoreBeforeQuery
    Left = 268
    Top = 381
  end
  object TblIgnore: TuQuery
    BeforeOpen = TblIgnoreBeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'select *'
      'from STOERMELDUNGEN'
      'where (STME_ID is null )'
      '  and (QUITTIERT = '#39'N'#39')'
      'order by LIEGTAN_AM desc')
    Left = 296
    Top = 381
  end
  object QueAktivieren: TuQuery
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'update STOERMELDUNGEN'
      'set QUITTIERT='#39'N'#39
      'where (STME_ID=:STME_ID)')
    Left = 138
    Top = 353
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'STME_ID'
        ParamType = ptUnknown
      end>
  end
  object PsAktuell: TPrnSource
    QRepKurz = 'DFLT'
    Preview = True
    NoPreview = False
    Visible = True
    Display = 'Aktuelle St'#246'rmeldungen'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage, psSetDisplay]
    ExportFile = False
    BeforePrn = PsAktuellBeforePrn
    Left = 103
    Top = 381
  end
  object psIgnore: TPrnSource
    QRepKurz = 'DFLT'
    Preview = True
    NoPreview = False
    Visible = True
    Display = 'Ignorierte St'#246'rmeldungen'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage, psSetDisplay]
    ExportFile = False
    BeforePrn = psIgnoreBeforePrn
    Left = 75
    Top = 353
  end
  object psQuittiert: TPrnSource
    QRepKurz = 'DFLT'
    Preview = True
    NoPreview = False
    Visible = True
    Display = 'Quittierte St'#246'rmeldungen'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage, psSetDisplay]
    ExportFile = False
    BeforePrn = psQuittiertBeforePrn
    Left = 103
    Top = 353
  end
  object PopupMenuUsSe: TPopupMenu
    Left = 348
    Top = 338
    object MiLogin: TMenuItem
      Caption = 'Login'
      Hint = 'Benutzername'
      OnClick = MiLoginClick
    end
    object MiLogout: TMenuItem
      Caption = 'Logout'
      Hint = 'Benutzername'
      OnClick = MiLogoutClick
    end
  end
  object LuUsSe: TLookUpDef
    DataSet = TblUsSe
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
    PrimaryKeyFields = 'USSE_ID'
    TableName = 'USER_SESSIONS'
    DisabledButtons = []
    EnabledButtons = []
    Left = 292
    Top = 338
  end
  object TblUsSe: TuQuery
    DatabaseName = 'DB1'
    SessionName = 'Default'
    SQL.Strings = (
      'select *'
      'from USER_SESSIONS')
    Left = 320
    Top = 338
  end
  object NSTimer: TNonSystemTimer
    Enabled = False
    Interval = 10000
    SyncVcl = False
    OnTimer = NSTimerTimer
    Left = 492
  end
end
