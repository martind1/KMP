object FrmStMe: TFrmStMe
  Left = 1103
  Top = 382
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
          PageIndex = 3
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
                'Herkunft:8=BEIN_NR'
                'Datum Zeit:17=LIEGTAN_AM'
                'ERFASST_VON:26=ERFASST_VON'
                'Meldungstext:43=STME_TEXT')
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
              ExplicitTop = 376
              object Panel2: TPanel
                Left = 449
                Top = 0
                Width = 269
                Height = 27
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 0
                object BtnQuitt: TBitBtn
                  Left = 198
                  Top = 2
                  Width = 69
                  Height = 25
                  Caption = 'Quittieren'
                  TabOrder = 0
                  OnClick = BtnQuittClick
                end
                object BtnIgnore: TBitBtn
                  Left = 128
                  Top = 2
                  Width = 70
                  Height = 25
                  Caption = 'Ignorieren'
                  TabOrder = 1
                  OnClick = BtnIgnoreClick
                end
                object BtnSenden: TBitBtn
                  Left = 68
                  Top = 2
                  Width = 60
                  Height = 25
                  Hint = 'Meldung an Systemverwalter senden'
                  Caption = 'Senden'
                  TabOrder = 2
                  OnClick = BtnSendenClick
                end
                object BtnDetails: TBitBtn
                  Left = 8
                  Top = 2
                  Width = 60
                  Height = 25
                  Hint = 'Zus'#228'tzliche Informationen zu dieser Meldung'
                  Caption = 'Details'
                  TabOrder = 3
                  OnClick = BtnDetailsClick
                end
              end
              object nbAuto: TNotebook
                Left = 0
                Top = 0
                Width = 449
                Height = 27
                Align = alClient
                PageIndex = 1
                TabOrder = 1
                object TPage
                  Left = 0
                  Top = 0
                  Caption = 'Auto'
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object LaStatus: TLabel
                    Left = 72
                    Top = 7
                    Width = 35
                    Height = 15
                    Caption = 'Status'
                  end
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
                end
                object TPage
                  Left = 0
                  Top = 0
                  Caption = 'Manuell'
                  object Label23: TLabel
                    Left = 217
                    Top = 5
                    Width = 17
                    Height = 15
                    Alignment = taRightJustify
                    Caption = 'bis'
                  end
                  object Label24: TLabel
                    Left = 354
                    Top = 5
                    Width = 40
                    Height = 15
                    Alignment = taRightJustify
                    Caption = 'Zeit bis'
                  end
                  object BtnAktuellRefresh: TSpeedButton
                    Left = 0
                    Top = 3
                    Width = 68
                    Height = 23
                    Hint = 'Aktualisieren'
                    AllowAllUp = True
                    GroupIndex = 1202
                    Caption = 'Filter'
                    Flat = True
                    Glyph.Data = {
                      96090000424D9609000000000000360000002800000028000000140000000100
                      18000000000060090000C40E0000C40E00000000000000000000CCCCCCD7D7D7
                      CCCCCCCCCCCCD7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7
                      D7D7D7D7CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7CCCCCCCC
                      CCCCD7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7
                      CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7D7D7D7D7D7D7DDDD
                      DDD7D7D7CCCCCCD7D7D7B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D7D7D7DDDDDDD7
                      D7D7D7D7D7D7D7D7D7D7D7D7D7D7CCCCCCD7D7D7D7D7D7D7D7D7DDDDDDD7D7D7
                      CCCCCCD7D7D7B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2D7D7D7DDDDDDD7D7D7D7D7
                      D7D7D7D7D7D7D7D7D7D7CCCCCCCCCCCCD7D7D7B2B2B2969696D7D7D7D6E7E786
                      86860C0C0C1616161616163300000C0C0C868686969696E3E3E3CCCCCCD7D7D7
                      D7D7D7DDDDDDCCCCCCCCCCCCD7D7D7B2B2B2969696D7D7D7D6E7E78686860C0C
                      0C1616161616163300000C0C0C868686969696E3E3E3CCCCCCD7D7D7D7D7D7DD
                      DDDDCCCCCCD7D7D7DDDDDD669966003300996666996666003300008000006600
                      006600006600006600333300161616996699D6E7E7CCCCCCD7D7D7D7D7D7CCCC
                      CCD7D7D7DDDDDD66996600330099666699666600330000800000660000660000
                      6600006600333300161616996699D6E7E7CCCCCCD7D7D7D7D7D7CCCCCCCCCCCC
                      DDDDDD66996600660000330000330000660000800000CC0000CC0000CC0000CC
                      00006600006600333300996699D6E7E7D7D7D7D7D7D7CCCCCCCCCCCCDDDDDD66
                      9966808080003300003300808080008000C0C0C0C0C0C0C0C0C0C0C0C0006600
                      006600333300996699D6E7E7D7D7D7D7D7D7CCCCCCD7D7D7DDDDDD6699660066
                      0000660000660000660033FF33C0DCC0C0DCC0C0DCC0C0DCC000FF0000660000
                      6600333300996666DDDDDDDDDDDDCCCCCCD7D7D7DDDDDD669966808080808080
                      808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00066000066003333
                      00996666DDDDDDDDDDDDCCCCCCD7D7D7E3E3E366996600660000660000660033
                      6633F1F1F1D7D7D7D7D7D7D7D7D7DDDDDDE3E3E300FF00006600003300996666
                      E3E3E3D7D7D7CCCCCCD7D7D7E3E3E3669966808080808080808080336633F1F1
                      F1D7D7D7D7D7D7D7D7D7DDDDDDE3E3E3C0C0C0006600003300996666E3E3E3D7
                      D7D7CCCCCCD7D7D7DDDDDD669966006600008000006600006600339933D7D7D7
                      D7D7D7D7D7D7CCCCCCE3E3E300FF00660000660000996666DDDDDDDDDDDDCCCC
                      CCD7D7D7DDDDDD669966808080008000808080808080339933D7D7D7D7D7D7D7
                      D7D7CCCCCCE3E3E3C0C0C0660000660000996666DDDDDDDDDDDDCCCCCCCCCCCC
                      D7D7D766FF6633FF3333FF3333FF3333FF3333FF3366FF66D7D7D7CCCCCCD7D7
                      D7D7D7D7EAEAEAF1F1F1F1F1F1D6E7E7D7D7D7DDDDDDCCCCCCCCCCCCD7D7D7C0
                      C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D7D7D7CCCCCCD7D7D7D7D7D7
                      EAEAEAF1F1F1F1F1F1D6E7E7D7D7D7DDDDDDCCCCCCCCCCCCD7D7D7DDDDDDFFCC
                      FFEAEAEAEAEAEADDDDDDDDDDDDD7D7D7CCCCCCCCCCCCE3E3E3A4A0A096969696
                      9696999999969696C0C0C0DDDDDDCCCCCCCCCCCCD7D7D7DDDDDDFFCCFFEAEAEA
                      EAEAEADDDDDDDDDDDDD7D7D7CCCCCCCCCCCCE3E3E3A4A0A09696969696969999
                      99969696C0C0C0DDDDDDCCCCCCD7D7D7D7D7D799FF99808080996666996666DD
                      DDDDD7D7D7CCCCCCD7D7D7D7D7D799FF99333300161616333300333300330000
                      996666D6E7E7CCCCCCD7D7D7D7D7D799FF99808080996666996666DDDDDDD7D7
                      D7CCCCCCD7D7D7D7D7D7C0C0C0333300161616333300333300330000996666D6
                      E7E7CCCCCCD7D7D7D7D7D733FF33006600003300330000F0FBFFD7D7D7D7D7D7
                      D7D7D7D7D7D7C0DCC000FF00006600008000008000003300808080D6E7E7CCCC
                      CCD7D7D7D7D7D7C0C0C0006600003300330000F0FBFFD7D7D7D7D7D7D7D7D7D7
                      D7D7C0DCC0C0C0C0808080808080808080003300808080D6E7E7CCCCCCD7D7D7
                      D7D7D7CCCCCC33FF33008000006600663333F1F1F1D6E7E7D6E7E7F0FBFF9966
                      66333300006600006600008000333300808080EAEAEACCCCCCD7D7D7D7D7D7CC
                      CCCCC0C0C0008000808080663333F1F1F1D6E7E7D6E7E7F0FBFF996666333300
                      808080808080808080333300808080EAEAEACCCCCCCCCCCCD7D7D7DDDDDD33FF
                      3300660000660000660066000066000066000066000000330000660000660000
                      6600006600003300996666D6E7E7CCCCCCCCCCCCD7D7D7DDDDDDC0C0C0808080
                      8080808080806600006600006600006600000033008080808080808080808080
                      80003300996666D6E7E7CCCCCCD7D7D7CCCCCCD7D7D7FFCCFF33FF3300800000
                      800000660000660000660000660000660000800000800000FF0000FF00333300
                      868686E3E3E3CCCCCCD7D7D7CCCCCCD7D7D7FFCCFFC0C0C00080000080008080
                      80808080808080808080808080008000008000C0C0C0C0C0C0333300868686E3
                      E3E3CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7FFCCFF33FF3333FF33008000008000
                      00800000800000800033FF3333FF33FFCCFFC0DCC066FF66E3E3E3D7D7D7CCCC
                      CCD7D7D7D7D7D7CCCCCCD7D7D7FFCCFFC0C0C0C0C0C000800000800000800000
                      8000008000C0C0C0C0C0C0FFCCFFC0DCC0C0C0C0E3E3E3D7D7D7CCCCCCD7D7D7
                      CCCCCCD7D7D7D7D7D7D7D7D7DDDDDDD7D7D733FF3333FF6633FF6666FF6633FF
                      33D7D7D7DDDDDDD7D7D7D7D7D7D7D7D7D7D7D7DDDDDDCCCCCCD7D7D7CCCCCCD7
                      D7D7D7D7D7D7D7D7DDDDDDD7D7D7C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D7D7D7
                      DDDDDDD7D7D7D7D7D7D7D7D7D7D7D7DDDDDDCCCCCCD7D7D7D7D7D7D7D7D7D7D7
                      D7CCCCCCD7D7D7D7D7D7DDDDDDD7D7D7DDDDDDD7D7D7DDDDDDD7D7D7D7D7D7CC
                      CCCCD7D7D7D7D7D7D7D7D7D7D7D7CCCCCCD7D7D7D7D7D7D7D7D7D7D7D7CCCCCC
                      D7D7D7D7D7D7DDDDDDD7D7D7DDDDDDD7D7D7DDDDDDD7D7D7D7D7D7CCCCCCD7D7
                      D7D7D7D7D7D7D7D7D7D7CCCCCCD7D7D7CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7D7
                      D7D7CCCCCCD7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7CCCCCC
                      D7D7D7D7D7D7CCCCCCD7D7D7CCCCCCD7D7D7D7D7D7CCCCCCD7D7D7D7D7D7CCCC
                      CCD7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7CCCCCCD7D7D7D7
                      D7D7CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
                      CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCD7D7D7CCCC
                      CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
                      CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCD7D7D7}
                    NumGlyphs = 2
                    OnClick = BtnAktuellRefreshClick
                  end
                  object EdAktuellDtm1: TEdit
                    Left = 70
                    Top = 3
                    Width = 84
                    Height = 23
                    Hint = 'Datum der Meldung'
                    ReadOnly = True
                    TabOrder = 0
                    OnChange = EdAktuellChange
                  end
                  object BtnAktuellDtm1: TDatumBtn
                    Left = 154
                    Top = 3
                    Width = 23
                    Height = 23
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
                    TabOrder = 1
                    DBEdit = EdAktuellDtm1
                    Day = 0
                    Month = 0
                    Year = 0
                  end
                  object UpDownAktuell: TUpDown
                    Left = 177
                    Top = 3
                    Width = 28
                    Height = 23
                    Max = 1000
                    Orientation = udHorizontal
                    Position = 500
                    TabOrder = 2
                    OnClick = UpDownAktuellClick
                  end
                  object EdAktuellDtm2: TEdit
                    Left = 237
                    Top = 3
                    Width = 84
                    Height = 23
                    Hint = 'Datum der Meldung'
                    ReadOnly = True
                    TabOrder = 3
                    OnChange = EdAktuellChange
                  end
                  object BtnAktuellDtm2: TDatumBtn
                    Left = 321
                    Top = 3
                    Width = 23
                    Height = 23
                    Hint = 'Datum der Meldung'
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
                    TabOrder = 4
                    DBEdit = EdAktuellDtm2
                    Day = 0
                    Month = 0
                    Year = 0
                  end
                  object BtnAktuellTime: TTimeBtn
                    Left = 411
                    Top = 3
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
                    TabOrder = 5
                    DBEdit = EdAktuellTime
                    StartTime = '07:00'
                  end
                  object EdAktuellTime: TEdit
                    Left = 353
                    Top = 3
                    Width = 58
                    Height = 23
                    Hint = 'Datum der Meldung'
                    ReadOnly = True
                    TabOrder = 6
                    OnChange = EdAktuellChange
                  end
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
              ExplicitTop = 376
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
              ExplicitTop = 376
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
              Font.Charset = ANSI_CHARSET
              Font.Color = clTeal
              Font.Height = -19
              Font.Name = 'Arial'
              Font.Style = [fsBold]
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
                Width = 54
                Height = 15
                Caption = 'Betrieb(e)'
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
              object cobBEIN_NR: TComboBox
                Left = 96
                Top = 134
                Width = 281
                Height = 23
                Style = csDropDownList
                DropDownCount = 30
                TabOrder = 8
                OnChange = cobBEIN_NRChange
                OnDropDown = cobBEIN_NRDropDown
                Items.Strings = (
                  'Gruppe1'
                  'Gruppe2')
              end
              object cobSTME_NR: TComboBox
                Left = 96
                Top = 206
                Width = 281
                Height = 23
                Style = csDropDownList
                DropDownCount = 30
                TabOrder = 10
                OnChange = cobSTME_NRChange
                OnDropDown = cobSTME_NRDropDown
                Items.Strings = (
                  'Meldungsnummern AKW Dispo:'
                  '230100..230199 = Disposition'
                  '230200..230299 = Produktion'
                  '230300..230399 = Labor'
                  '230900..230999 = System')
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
                Glyph.Data = {
                  E6000000424DE60000000000000076000000280000000E0000000E0000000100
                  0400000000007000000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                  33003333333333333300300000000333330000B7B7B7B03333000B0B7B7B7B03
                  33000BB0B7B7B7B033000FBB0000000033000BFB0B0B0B0333000FBFBFBFB003
                  33000BFBFBF00033330030BFBF03333333003800008333333300333333333333
                  33003333333333333300}
                TabOrder = 1
                OnClick = BtnWavOpenClick
              end
              object BtnWavTest: TBitBtn
                Left = 192
                Top = 38
                Width = 75
                Height = 25
                Caption = 'Test Klang'
                TabOrder = 3
                OnClick = BtnWavTestClick
              end
              object edFltrSTME_NR: TEdit
                Left = 96
                Top = 206
                Width = 263
                Height = 23
                Hint = 'Filter f'#252'r eingehende Meldungen'
                TabOrder = 9
                OnChange = edFltrSTME_NRChange
              end
              object EdFltrBETR_NR: TEdit
                Left = 96
                Top = 102
                Width = 97
                Height = 23
                Hint = 'Filter f'#252'r eingehende Meldungen'
                TabOrder = 6
                OnExit = EdFltrBETR_NRExit
              end
              object BtnTestStMe: TBitBtn
                Left = 272
                Top = 38
                Width = 105
                Height = 25
                Caption = 'Test St'#246'rmeldung'
                TabOrder = 4
                OnClick = BtnTestStMeClick
              end
              object edFltrBEIN_NR: TEdit
                Left = 96
                Top = 134
                Width = 263
                Height = 23
                Hint = 'Filter f'#252'r Produktgruppen'
                TabOrder = 7
                OnExit = EdFltrBETR_NRExit
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
                TabOrder = 13
                OnClick = BtnEinstellungEntfernenClick
              end
              object chbAddSTME_NR: TCheckBox
                Left = 277
                Top = 232
                Width = 97
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Hinzuf'#252'gen'
                TabOrder = 14
              end
              object chbAddBEIN_NR: TCheckBox
                Left = 277
                Top = 160
                Width = 97
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Hinzuf'#252'gen'
                Checked = True
                State = cbChecked
                TabOrder = 15
              end
              object chbSortNr: TCheckBox
                Left = 98
                Top = 232
                Width = 97
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Sortiert'
                Checked = True
                State = cbChecked
                TabOrder = 16
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
              object pcStmeNr: TPageControl
                Left = 2
                Top = 17
                Width = 321
                Height = 364
                ActivePage = tsWebab
                Align = alClient
                MultiLine = True
                RaggedRight = True
                TabOrder = 0
                object tsSQVA: TTabSheet
                  Caption = 'SQVA'
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
                      '10001=Changelog VORF'
                      '10002=Changelog VPOS'
                      ''
                      '800001=Datenabgleich Fehler'
                      ''
                      '900001=Triggerfehler')
                    TabOrder = 0
                  end
                end
                object tsSBT: TTabSheet
                  Caption = 'SBT'
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
                      '135008=Devicestatus'
                      ''
                      '135009=Systemfehler (Logfile)')
                    TabOrder = 0
                  end
                end
                object tsKJU: TTabSheet
                  Caption = 'KJU'
                  ImageIndex = 2
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object lbKJU: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '10001=Changelog VORF'
                      '10002=Changelog ENTS'
                      '10003=Changelog KASS'
                      '10004=Changelog RECH'
                      '10005=Changelog KUND'
                      '10006=Changelog PRVE'
                      '10007=Changelog FAHR'
                      '10008=Changelog SRTE'
                      '10009=Changelog PRCO'
                      '10010=Changelog ABFA'
                      '10011=Changelog MEAB'
                      '10012=Changelog SREN'
                      '10013=Changelog MAND'
                      '10014=Changelog DEPO'
                      '10015=Changelog FKGROUP'
                      '10016=Changelog DEVI'
                      '10017=Changelog AUVO'
                      '10018=Changelog KSTE'
                      '10019=Changelog KOSSATZ'
                      '10020=Changelog MEKO'
                      '10021=Changelog SART'
                      '10023=Changelog FTXT'
                      '10024=Changelog KONT'
                      '10025=Changelog BHAE'
                      '10026=Changelog AANL'
                      '10027=Changelog BTYP'
                      '10028=Changelog DISP'
                      '10029=Changelog ZSOD'
                      '10030=Changelog ZSOA'
                      '10031=Changelog ZVAA'
                      '10032=Changelog ZSOK'
                      '10033=Changelog ENCH'
                      '10034=Changelog AYEN'
                      '10035=Changelog PARA'
                      '10036=Changelog LORT'
                      '10037=Changelog BEZI'
                      '10038=Changelog VBEZ'
                      '10039=Changelog KATA'
                      '10040=Changelog EXCF'
                      '10041=Changelog EMGR'
                      '10042=Changelog EMAI'
                      '10043=Changelog DOKU'
                      '10044=Changelog EREC'
                      '10045=Changelog USSE'
                      '10046=Changelog VERT'
                      '10047=Changelog VESR'
                      '10048=Changelog VEZA'
                      '10049=Changelog VEBP'
                      '10050=Changelog VETS '
                      '10051=Changelog VEVG'
                      '10052=Changelog ANNE'
                      '10053=Changelog ZANSR'
                      '10054=Changelog KSFR'
                      '10055=Changelog AYSP'
                      '10056=Changelog ENAV'
                      '10057=Changelog ENAY'
                      '10058=Changelog AYPA'
                      '10059=Changelog PRVJ (eaeing bis 3.9.12)'
                      '10060=Changelog ENCH'
                      '10061=Changelog FKGR'
                      '10062=Changelog FKVE'
                      '10063=Changelog FAKT'
                      '10064=Changelog KTAG'
                      '10065=Changelog EAADRE'
                      '10066=Changelog FNOP'
                      '10067=Changelog EAEING'
                      '10068=Changelog CHME'
                      '10069=Changelog ABHI'
                      '10070=Changelog MKEN'
                      '10071=Changelog ERLK'
                      '10072=Kontrolle BHAE')
                    TabOrder = 0
                  end
                end
                object tsWebab: TTabSheet
                  Caption = 'WeBAB'
                  ImageIndex = 3
                  ExplicitLeft = 0
                  ExplicitTop = 0
                  ExplicitWidth = 0
                  ExplicitHeight = 0
                  object lbWebab: TListBox
                    Left = 0
                    Top = 0
                    Width = 313
                    Height = 334
                    Align = alClient
                    ItemHeight = 15
                    Items.Strings = (
                      '11011=Changelog ARTI'
                      '11012=Changelog ABWV'
                      '11013=Changelog ADRE'
                      '11014=Changelog ARTI_LFRT'
                      '11015=Changelog ARGR'
                      '11016=Changelog ARTI_LPLA'
                      '11021=Changelog BVOR'
                      '11022=Changelog BVPS'
                      '11023=Changelog BUDG'
                      '11024=Changelog BVDO'
                      '11025=Changelog BVED'
                      '11026=Changelog BVEI'
                      '11027=Changelog BVLF'
                      '11041=Changelog DOVO'
                      '11051=Changelog EDTY'
                      '11052=Changelog EIGE'
                      '11053=Changelog EREC'
                      '11054=Changelog EREC_BVOR'
                      '11111=Changelog KBER'
                      '11112=Changelog KSTE'
                      '11113=Changelog KSAR'
                      '11121=Changelog LBUC'
                      '11122=Changelog LBEL'
                      '11123=Changelog LBPS'
                      '11124=Changelog LPER'
                      '11125=Changelog LPAB'
                      '11126=Changelog LFSK'
                      '11127=Changelog LFRT'
                      '11128=Changelog LPFA'
                      '11129=Changelog LPLA'
                      '11131=Changelog MAND'
                      '11151=Changelog OEIN'
                      '11161=Changelog PZUO'
                      '11162=Changelog PZSV'
                      '11163=Changelog PZRO'
                      '11164=Changelog PROJ'
                      '11165=Changelog PERS'
                      '11181=Changelog RAHM'
                      '11182=Changelog RTPL'
                      '11191=Changelog SKTO'
                      '11192=Changelog SKGR'
                      '11221=Changelog VMAT'
                      '11231=Changelog WFAUSL'
                      '11232=Changelog WFDEF'
                      '11233=Changelog WFDO'
                      '11234=Changelog WFOBJ'
                      '11235=Changelog WFER'
                      '11236=Changelog WFRO'
                      '11261=Changelog ZRTKM'
                      '11262=Changelog ZARSK'
                      '11321=Changelog LINV'
                      '11322=Changelog LIPS'
                      '11323=Changelog LBTY'
                      '11381=Changelog R_USRS'
                      '90009=Debug SQL Routine')
                    TabOrder = 0
                    ExplicitLeft = -16
                    ExplicitTop = 64
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
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'Benutzername:30=USERNAME'
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
            ExplicitTop = 6
            ExplicitHeight = 403
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
              Left = 74
              Top = 92
              Width = 76
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
              Left = 65
              Top = 66
              Width = 85
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
              Width = 29
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
              ExplicitHeight = 403
              object lbIgnore: TListBox
                Left = 2
                Top = 17
                Width = 82
                Height = 364
                Hint = 'lbIgnore'
                Align = alClient
                ItemHeight = 15
                TabOrder = 0
                ExplicitHeight = 384
              end
            end
            object BtnEnabled: TBitBtn
              Left = 352
              Top = 16
              Width = 75
              Height = 25
              Hint = 'Wecker bzgl. '#39'aktuell'#39' aktivieren'
              Caption = 'BtnEnabled'
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
            object EdQuittiertSTME_ID: TDBEdit
              Left = 265
              Top = 24
              Width = 75
              Height = 23
              DataField = 'STME_ID'
              DataSource = LuQuittiert
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
    AfterPageChange = NavAfterPageChange
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    CalcList.Strings = (
      'cfTest=string:250')
    FormatList.Strings = (
      'QUITTIERT=Asw,JNX'
      'LIEGTAN=Asw,JNX')
    KeyFields = 'STME_ID desc'
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'QUITTIERT=N')
    SqlFieldList.Strings = (
      'STME_NR'
      'BETR_NR'
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
    TableName = 'STME'
    TabTitel = 'St'#246'rmeldungen'
    OnBuildSql = NavBuildSql
    Left = 65
    Top = 349
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnDataChange = LDataSource1DataChange
    Left = 7
    Top = 349
  end
  object Query1: TuQuery
    Tag = 3
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select STME_NR,'
      '       BETR_NR,'
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
      'from STME'
      'where (QUITTIERT = '#39'N'#39')'
      'order by STME_ID desc')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    AfterOpen = Query1AfterOpen
    BeforeScroll = Query1BeforeScroll
    OnCalcFields = Query1CalcFields
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 35
    Top = 349
  end
  object QueQuittieren: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'update STME'
      'set QUITTIERT='#39'J'#39','
      '   QUITTIERT_AM=:QUITTIERT_AM,'
      '   QUITTIERT_VON=:QUITTIERT_VON'
      'where (STME_ID=:STME_ID)'
      '  and (QUITTIERT='#39'N'#39')')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 138
    Top = 349
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'QUITTIERT_AM'
      end
      item
        DataType = ftString
        Name = 'QUITTIERT_VON'
      end
      item
        DataType = ftUnknown
        Name = 'STME_ID'
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
    TableName = 'dbo.STME'
    DisabledButtons = []
    EnabledButtons = []
    OnBuildSql = LuQuittiertBuildSql
    BeforeQuery = LuQuittiertBeforeQuery
    Left = 176
    Top = 349
  end
  object TblQuittiert: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.STME STME'
      'where (QUITTIERT = '#39'J'#39')')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    BeforeOpen = TblQuittiertBeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 204
    Top = 349
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
    TableName = 'dbo.STME'
    DisabledButtons = []
    EnabledButtons = []
    BeforeQuery = LuIgnoreBeforeQuery
    Left = 240
    Top = 349
  end
  object TblIgnore: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.STME STME'
      'where (STME_ID is null )'
      '  and (QUITTIERT = '#39'N'#39')'
      'order by LIEGTAN_AM desc')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    BeforeOpen = TblIgnoreBeforeOpen
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 268
    Top = 349
  end
  object QueAktivieren: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'update STME'
      'set QUITTIERT='#39'N'#39
      'where (STME_ID=:STME_ID)')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 138
    Top = 321
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'STME_ID'
      end>
  end
  object PsAktuell: TPrnSource
    MuSelect = MuAktuell
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
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = PsAktuellBeforePrn
    Left = 103
    Top = 349
  end
  object psIgnore: TPrnSource
    MuSelect = MuIgnore
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
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = psIgnoreBeforePrn
    Left = 75
    Top = 321
  end
  object psQuittiert: TPrnSource
    MuSelect = MuQuittiert
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
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = psQuittiertBeforePrn
    Left = 103
    Top = 321
  end
  object NSTimer: TNonSystemTimer
    Enabled = False
    Interval = 10000
    SyncVcl = False
    OnTimer = NSTimerTimer
    Left = 492
  end
  object TblUsSe: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from dbo.USSE USSE')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'Default'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 332
    Top = 349
  end
  object LuUsSe: TLookUpDef
    DataSet = TblUsSe
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
    MDTyp = mdMaster
    PrimaryKeyFields = 'SESSION_NR'
    TableName = 'dbo.USSE'
    DisabledButtons = []
    EnabledButtons = []
    Left = 304
    Top = 349
  end
  object LuBEIN_NR: TLookUpDef
    DataSet = TblBEIN_NR
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
    KeyFields = 'DI_BEIN_NR'
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'STME_ID=0')
    SqlFieldList.Strings = (
      'DI_BEIN_NR=distinct(BEIN_NR)')
    TableName = 'STME'
    DisabledButtons = []
    EnabledButtons = []
    Left = 177
    Top = 320
  end
  object TblBEIN_NR: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select distinct(BEIN_NR) as DI_BEIN_NR'
      'from STME'
      'where (STME_ID = '#39'0'#39')'
      'order by DI_BEIN_NR')
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 206
    Top = 320
  end
  object DbStme: TuDataBase
    ProviderName = 'Oracle'
    SpecificOptions.Strings = (
      'Oracle.SERVER NAME=BLACKI:1521:blacki'
      'Oracle.Direct=True')
    Options.KeepDesignConnected = False
    Username = 'quva'
    Server = 'BLACKI:1521:blacki'
    LoginPrompt = False
    AliasName = 'QwLokal'
    DatabaseName = 'DB_STME'
    SessionName = 'Default'
    Params.Strings = (
      'USER NAME=quva'
      'Port=0')
    TransIsolation = tiDirtyRead
    StartConnect = False
    Left = 560
  end
  object QueSTME: TuQuery
    Connection = DbStme
    SQL.Strings = (
      'select /*+RULE */'
      'count(*)'
      'from STOERMELDUNGEN')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB_STME'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 592
  end
end
