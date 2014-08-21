object FrmKart: TFrmKart
  Left = 321
  Top = 302
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Identkarten Zuordnung'
  ClientHeight = 429
  ClientWidth = 707
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
  object PageBook: TqNoteBook
    Left = 0
    Top = 0
    Width = 678
    Height = 408
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
        Width = 678
        Height = 408
        Align = alClient
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 674
          Height = 73
          Align = alTop
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 10
            Width = 46
            Height = 15
            Caption = 'Karte-Nr'
            FocusControl = edKART_NR
          end
          object Label1: TLabel
            Left = 307
            Top = 10
            Width = 53
            Height = 15
            Alignment = taRightJustify
            Caption = 'Kunde-Nr'
            FocusControl = edKUNW_NR
          end
          object Label8: TLabel
            Left = 176
            Top = 10
            Width = 45
            Height = 15
            Caption = 'Werk-Nr'
            FocusControl = leWERK_NR
          end
          object edKART_NR: TDBEdit
            Left = 62
            Top = 8
            Width = 88
            Height = 23
            CharCase = ecUpperCase
            DataField = 'KART_NR'
            DataSource = LDataSource1
            TabOrder = 0
          end
          object edKUNW_NR: TLookUpEdit
            Left = 368
            Top = 8
            Width = 88
            Height = 23
            DataField = 'KUNW_NR'
            DataSource = LDataSource1
            TabOrder = 3
            Options = []
            LookupSource = LuKUNW
            LookupField = 'KUNW_NR'
            KeyField = True
          end
          object BtnKUNW_NR: TLookUpBtn
            Left = 456
            Top = 8
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
            LookUpEdit = edKUNW_NR
            LookUpDef = LuKUNW
            Modus = lubMulti
          end
          object chbSPERR_KNZ: TAswCheckBox
            Left = 7
            Top = 40
            Width = 73
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Gesperrt'
            DataField = 'SPERR_KNZ'
            DataSource = LDataSource1
            TabOrder = 6
            ValueChecked = 'X'
            ValueUnchecked = '-'
            AswName = 'JNX'
          end
          object edSPENDER_KNZ: TAswCheckBox
            Left = 108
            Top = 40
            Width = 142
            Height = 17
            Alignment = taLeftJustify
            Caption = 'f'#252'r Spender reserviert'
            DataField = 'SPENDER_KNZ'
            DataSource = LDataSource1
            ReadOnly = True
            TabOrder = 7
            ValueChecked = 'X'
            ValueUnchecked = '-'
            AswName = 'JNX'
          end
          object PanRg: TPanel
            Left = 278
            Top = 40
            Width = 200
            Height = 17
            BevelOuter = bvNone
            TabOrder = 8
            object rgKUND_KNZ: TAswRadioGroup
              Left = -8
              Top = -50
              Width = 208
              Height = 105
              Columns = 2
              DataField = 'KUND_KNZ'
              DataSource = LDataSource1
              Items.Strings = (
                'Kundenkarte'
                'Personenkarte')
              ParentBackground = True
              ReadOnly = True
              TabOrder = 0
              Values.Strings = (
                'Kundenkarte'
                'Personenkarte')
              AswName = 'KundPers'
              Frame = frNone
            end
          end
          object leWERK_NR: TLookUpEdit
            Left = 224
            Top = 8
            Width = 44
            Height = 23
            DataField = 'WERK_NR'
            DataSource = LDataSource1
            TabOrder = 1
            Options = []
            LookupSource = LuWERK
            LookupField = 'WERK_NR'
            KeyField = True
          end
          object BtnWERK_NR: TLookUpBtn
            Left = 268
            Top = 8
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
            TabOrder = 2
            LookUpEdit = leWERK_NR
            LookUpDef = LuWERK
            Modus = lubMulti
          end
          object edcfKUNDE_1: TLookUpEdit
            Tag = 128
            Left = 496
            Top = 8
            Width = 88
            Height = 23
            DataField = 'cfKUNDE'
            DataSource = LDataSource1
            TabOrder = 5
            Options = []
            KeyField = True
          end
        end
        object DetailBook: TTabbedNotebook
          Left = 0
          Top = 73
          Width = 674
          Height = 331
          Align = alClient
          TabsPerRow = 4
          TabFont.Charset = DEFAULT_CHARSET
          TabFont.Color = clBtnText
          TabFont.Height = -13
          TabFont.Name = 'MS Sans Serif'
          TabFont.Style = []
          TabOrder = 1
          object TTabPage
            Left = 4
            Top = 26
            Caption = '&etc.'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object ScrollBox3: TScrollBox
              Left = 0
              Top = 0
              Width = 666
              Height = 301
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 0
              object Label3: TLabel
                Left = 3
                Top = 256
                Width = 64
                Height = 15
                Caption = 'Bemer&kung'
                FocusControl = EdBEMERKUNG
              end
              object Label10: TLabel
                Left = 8
                Top = 8
                Width = 81
                Height = 15
                Caption = 'Personenkreis'
                FocusControl = edPEKR_NR
              end
              object Bevel1: TBevel
                Left = 0
                Top = 34
                Width = 481
                Height = 3
                Shape = bsTopLine
              end
              object Label14: TLabel
                Left = 8
                Top = 64
                Width = 38
                Height = 15
                Caption = 'Auftrag'
                FocusControl = leAUFK_NR
              end
              object Label16: TLabel
                Left = 8
                Top = 88
                Width = 43
                Height = 15
                Caption = 'Material'
                FocusControl = LeMARA_NR
              end
              object Bevel2: TBevel
                Left = 0
                Top = 138
                Width = 481
                Height = 3
                Shape = bsTopLine
              end
              object Label18: TLabel
                Left = 8
                Top = 148
                Width = 49
                Height = 15
                Caption = 'KFZ-Knz.'
                FocusControl = edTRANSPORTMITTEL
              end
              object Label20: TLabel
                Left = 227
                Top = 148
                Width = 60
                Height = 15
                Alignment = taRightJustify
                Caption = 'Sollmenge'
                FocusControl = edSOLLMENGE
              end
              object Label21: TLabel
                Left = 341
                Top = 148
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Bevel3: TBevel
                Left = 0
                Top = 246
                Width = 481
                Height = 3
                Shape = bsTopLine
              end
              object Label24: TLabel
                Left = 8
                Top = 112
                Width = 21
                Height = 15
                Caption = 'Silo'
                FocusControl = edSILO_NR
              end
              object Label17: TLabel
                Left = 8
                Top = 172
                Width = 52
                Height = 15
                Caption = 'Spedition'
                FocusControl = edSPEDITION
              end
              object Label28: TLabel
                Left = 373
                Top = 196
                Width = 23
                Height = 15
                Alignment = taRightJustify
                Caption = 'vom'
              end
              object Label26: TLabel
                Left = 8
                Top = 196
                Width = 14
                Height = 15
                Caption = 'Art'
                FocusControl = cobTROCKEN_FEUCHT
              end
              object Label29: TLabel
                Left = 231
                Top = 172
                Width = 56
                Height = 15
                Alignment = taRightJustify
                Caption = 'Max.Brutto'
                FocusControl = edMAX_BRUTTO
              end
              object Label30: TLabel
                Left = 341
                Top = 172
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label31: TLabel
                Left = 8
                Top = 220
                Width = 65
                Height = 15
                Caption = 'Teilmengen'
              end
              object Label32: TLabel
                Left = 90
                Top = 220
                Width = 10
                Height = 15
                Alignment = taRightJustify
                Caption = '1.'
              end
              object Label33: TLabel
                Left = 154
                Top = 220
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label34: TLabel
                Left = 174
                Top = 220
                Width = 10
                Height = 15
                Alignment = taRightJustify
                Caption = '2.'
              end
              object Label35: TLabel
                Left = 238
                Top = 220
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label36: TLabel
                Left = 258
                Top = 220
                Width = 10
                Height = 15
                Alignment = taRightJustify
                Caption = '3.'
              end
              object Label37: TLabel
                Left = 322
                Top = 220
                Width = 3
                Height = 15
                Caption = 't'
              end
              object laTEILMENGE4: TLabel
                Left = 342
                Top = 220
                Width = 10
                Height = 15
                Alignment = taRightJustify
                Caption = '4.'
              end
              object latTEILMENGE4: TLabel
                Left = 406
                Top = 220
                Width = 3
                Height = 15
                Caption = 't'
              end
              object laTEILMENGE5: TLabel
                Left = 426
                Top = 220
                Width = 10
                Height = 15
                Alignment = taRightJustify
                Caption = '5.'
              end
              object latTEILMENGE5: TLabel
                Left = 490
                Top = 220
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label7: TLabel
                Left = 357
                Top = 148
                Width = 38
                Height = 15
                Caption = 'Aufbau'
                FocusControl = cobAUFBAU
              end
              object Label27: TLabel
                Left = 502
                Top = 196
                Width = 30
                Height = 15
                Alignment = taRightJustify
                Caption = 'g'#252'ltig'
              end
              object Label40: TLabel
                Left = 572
                Top = 196
                Width = 27
                Height = 15
                Caption = 'Tage'
              end
              object EdBEMERKUNG: TDBMemo
                Left = 96
                Top = 253
                Width = 449
                Height = 43
                DataField = 'BEMERKUNG'
                DataSource = LDataSource1
                ScrollBars = ssVertical
                TabOrder = 32
              end
              object edPEKR_NR: TLookUpEdit
                Left = 96
                Top = 6
                Width = 88
                Height = 23
                DataField = 'PEKR_NR'
                DataSource = LDataSource1
                TabOrder = 0
                Options = []
                LookupSource = LuPEKR
                LookupField = 'PEKR_NR'
                KeyField = True
              end
              object BtnPEKR_NR: TLookUpBtn
                Left = 184
                Top = 6
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
                LookUpEdit = edPEKR_NR
                LookUpDef = LuPEKR
                Modus = lubMulti
              end
              object edPEKR_BEZ: TLookUpEdit
                Left = 224
                Top = 6
                Width = 264
                Height = 23
                DataField = 'PEKR_BEZ'
                DataSource = LDataSource1
                TabOrder = 2
                Options = []
                LookupSource = LuPEKR
                LookupField = 'PEKR_BEZ'
                KeyField = False
              end
              object leAUFK_NR: TLookUpEdit
                Left = 88
                Top = 62
                Width = 88
                Height = 23
                DataField = 'AUFK_NR'
                DataSource = LDataSource1
                TabOrder = 5
                Options = []
                LookupSource = LuAUFK
                LookupField = 'AUFK_NR'
                KeyField = True
              end
              object BtnAUFK_NR: TLookUpBtn
                Left = 176
                Top = 62
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
                TabOrder = 6
                LookUpEdit = leAUFK_NR
                LookUpDef = LuAUFK
                Modus = lubMulti
              end
              object LeMARA_NR: TLookUpEdit
                Left = 88
                Top = 86
                Width = 88
                Height = 23
                DataField = 'MARA_NR'
                DataSource = LDataSource1
                TabOrder = 8
                Options = []
                KeyField = True
              end
              object BtnMARA_NR: TLookUpBtn
                Left = 176
                Top = 86
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
                TabOrder = 9
                LookUpEdit = LeMARA_NR
                LookUpDef = LuMARA
                Modus = lubMulti
              end
              object edMARA_NAME: TLookUpEdit
                Left = 224
                Top = 86
                Width = 264
                Height = 23
                DataField = 'MARA_NAME'
                DataSource = LuMARA
                TabOrder = 10
                Visible = False
                Options = []
                KeyField = False
              end
              object edTRANSPORTMITTEL: TLookUpEdit
                Left = 88
                Top = 146
                Width = 88
                Height = 23
                CharCase = ecUpperCase
                DataField = 'TRANSPORTMITTEL'
                DataSource = LDataSource1
                TabOrder = 14
                OnKeyPress = edTRANSPORTMITTELKeyPress
                Options = []
                KeyField = False
              end
              object edSOLLMENGE: TLookUpEdit
                Left = 291
                Top = 146
                Width = 48
                Height = 23
                DataField = 'SOLLMENGE'
                DataSource = LDataSource1
                TabOrder = 15
                Options = []
                KeyField = False
              end
              object chbSORTE_KNZ: TAswCheckBox
                Left = 224
                Top = 64
                Width = 185
                Height = 17
                Hint = '[X]=Auswahl Auftrag,Bestellnummer  [  ]=Auswahl Sorte'
                Alignment = taLeftJustify
                Caption = 'mehrere Auftr'#228'ge pro Sorte'
                DataField = 'SORTE_KNZ'
                DataSource = LDataSource1
                TabOrder = 7
                ValueChecked = 'X'
                ValueUnchecked = '-'
                AswName = 'JNX'
              end
              object edSILO_NR: TLookUpEdit
                Left = 88
                Top = 110
                Width = 57
                Height = 23
                Hint = 'Feste Zuordnung eines Silos'
                DataField = 'SILO_NR'
                DataSource = LDataSource1
                TabOrder = 11
                Options = []
                LookupSource = LuSILO
                LookupField = 'SILO_NR'
                KeyField = True
              end
              object BtnSILO_NR: TLookUpBtn
                Left = 145
                Top = 110
                Width = 21
                Height = 21
                Glyph.Data = {
                  42020000424D4202000000000000420000002800000010000000100000000100
                  1000030000000002000000000000000000000000000000000000007C0000E003
                  00001F0000001863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863000000000000000000000000000018631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863186318631863000018631863186318631863
                  1863186318631863186318631863186318630000000000001863186318631863
                  1863186318631863186318631863186300000000000000000000186318631863
                  1863186318631863186318631863000000000000000000000000000018631863
                  1863186318631863186318631863186318630000000000001863186318631863
                  1863186318631863186318631863186318630000000000001863186318631863
                  1863186318631863186318631863186318630000000000001863186318631863
                  1863186318631863186318631863186318630000000000001863186318631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  1863186318631863186318631863186318631863186318631863186318631863
                  186318631863}
                TabOrder = 12
                LookUpEdit = edSILO_NR
                LookUpDef = LuSILO
                Modus = lubMulti
              end
              object edSILO_NAME: TLookUpEdit
                Left = 224
                Top = 110
                Width = 264
                Height = 23
                DataField = 'SILO_NAME'
                DataSource = LuSILO
                TabOrder = 13
                Options = []
                KeyField = False
              end
              object chbFREMDWAEGUNG: TAswCheckBox
                Left = 6
                Top = 40
                Width = 103
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Fremdw'#228'gung'
                DataField = 'FREMDWAEGUNG'
                DataSource = LDataSource1
                TabOrder = 3
                ValueChecked = 'X'
                ValueUnchecked = '-'
                AswName = 'JNX'
              end
              object edSPEDITION: TLookUpEdit
                Left = 88
                Top = 170
                Width = 88
                Height = 23
                DataField = 'SPEDITION'
                DataSource = LDataSource1
                TabOrder = 17
                Options = [LeNoNullValues]
                LookupSource = LuSped
                LookupField = 'SPED_NAME'
                KeyField = True
              end
              object LovSPEDITION: TLovBtn
                Left = 197
                Top = 170
                Width = 21
                Height = 21
                Hint = 'Werteliste'
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
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
                  C000C0C0C0000000000000000000000000000000000000000000000000000000
                  00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
                  C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
                TabOrder = 19
                Visible = False
                DataSource = LDataSource1
                DataField = 'SPEDITION'
                Fields = 'SPEDITION'
                LovFlags = []
              end
              object edTARA_GEWICHT: TLookUpEdit
                Left = 291
                Top = 194
                Width = 48
                Height = 23
                Hint = 
                  'Ein Eintrag (auch '#39'0'#39') kennzeichnet die Karte als '#39'Kombikarte'#39' b' +
                  'zw. '#39'Festtara Karte'#39
                DataField = 'TARA_GEWICHT'
                DataSource = LDataSource1
                TabOrder = 23
                Options = []
                KeyField = False
              end
              object edTARA_DATUM: TLookUpEdit
                Left = 400
                Top = 194
                Width = 88
                Height = 23
                DataField = 'TARA_DATUM'
                DataSource = LDataSource1
                TabOrder = 25
                Options = []
                KeyField = False
              end
              object BtnLFSK: TLookUpBtn
                Left = 339
                Top = 194
                Width = 21
                Height = 21
                Hint = 'eichf'#228'hig verwogene Taragewichte dieses Fahrzeugs'
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
                TabOrder = 24
                LookUpDef = LuLFSK
                Modus = lubMulti
              end
              object cobTROCKEN_FEUCHT: TAswComboBox
                Left = 88
                Top = 194
                Width = 89
                Height = 23
                AutoComplete = False
                DataField = 'TROCKEN_FEUCHT'
                DataSource = LDataSource1
                Items.Strings = (
                  'Trocken'
                  'Feucht')
                TabOrder = 21
                AswName = 'TrockenFeucht'
              end
              object edMAX_BRUTTO: TLookUpEdit
                Left = 291
                Top = 170
                Width = 48
                Height = 23
                Hint = 'Leerlassen f'#252'r StVO zul.Gesamtgewicht'
                DataField = 'MAX_BRUTTO'
                DataSource = LDataSource1
                TabOrder = 20
                Options = []
                KeyField = False
              end
              object edTEILMENGE1: TLookUpEdit
                Left = 104
                Top = 218
                Width = 48
                Height = 23
                DataField = 'TEILMENGE1'
                DataSource = LDataSource1
                TabOrder = 27
                Options = []
                KeyField = False
              end
              object edTEILMENGE2: TLookUpEdit
                Left = 188
                Top = 218
                Width = 48
                Height = 23
                DataField = 'TEILMENGE2'
                DataSource = LDataSource1
                TabOrder = 28
                Options = []
                KeyField = False
              end
              object edTEILMENGE3: TLookUpEdit
                Left = 272
                Top = 218
                Width = 48
                Height = 23
                DataField = 'TEILMENGE3'
                DataSource = LDataSource1
                TabOrder = 29
                Options = []
                KeyField = False
              end
              object edTEILMENGE4: TLookUpEdit
                Left = 356
                Top = 218
                Width = 48
                Height = 23
                DataField = 'TEILMENGE4'
                DataSource = LDataSource1
                TabOrder = 30
                Options = []
                KeyField = False
              end
              object edTEILMENGE5: TLookUpEdit
                Left = 440
                Top = 218
                Width = 48
                Height = 23
                DataField = 'TEILMENGE5'
                DataSource = LDataSource1
                TabOrder = 31
                Options = []
                KeyField = False
              end
              object chbPROBENPFLICHT: TAswCheckBox
                Left = 208
                Top = 40
                Width = 201
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Probe muss abgegeben werden'
                DataField = 'PROBENPFLICHT'
                DataSource = LDataSource1
                TabOrder = 4
                ValueChecked = 'X'
                ValueUnchecked = '-'
                AswName = 'JNX'
              end
              object cobAUFBAU: TAswComboBox
                Left = 399
                Top = 146
                Width = 106
                Height = 23
                AutoComplete = False
                DataField = 'AUFBAU'
                DataSource = LDataSource1
                Items.Strings = (
                  'Offen'
                  'Geschlossen')
                TabOrder = 16
                AswName = 'FrzgAufbau'
              end
              object btnSPEDITION: TLookUpBtn
                Left = 176
                Top = 170
                Width = 21
                Height = 21
                Hint = 'Nachschlagen'
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
                TabOrder = 18
                LookUpEdit = edSPEDITION
                LookUpDef = LuSped
                Modus = lubMulti
              end
              object chbFestTara: TCheckBox
                Left = 222
                Top = 196
                Width = 64
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Festtara'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 22
                OnClick = chbFestTaraClick
              end
              object edTARA_TAGE: TLookUpEdit
                Left = 536
                Top = 194
                Width = 33
                Height = 23
                Hint = 
                  'leer = Systemeinstellung. 0 = gesperrt f'#252'r Festtara Registrierun' +
                  'g.'
                DataField = 'TARA_TAGE'
                DataSource = LDataSource1
                TabOrder = 26
                Options = []
                KeyField = False
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Auftragssorten'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object MuAufp: TMultiGrid
              Left = 0
              Top = 0
              Width = 666
              Height = 260
              Align = alClient
              DataSource = LuAufp
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
              TabOrder = 0
              TitleFont.Charset = ANSI_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -12
              TitleFont.Name = 'Arial'
              TitleFont.Style = []
              ColumnList.Strings = (
                'Auftrag:10=AUFK_NR'
                'Pos:3=AUFP_NR'
                'Sperre:3=GESPERRT'
                'Bestellnr.:9=BESTELLNUMMER'
                'Materialname:23=MARA_NAME'
                'Material:12=MARA_KURZ')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout]
              DefaultRowHeight = 19
              Drag0Value = '0'
            end
            object Panel4: TPanel
              Left = 0
              Top = 260
              Width = 666
              Height = 41
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitTop = 280
              object Label6: TLabel
                Left = 8
                Top = 10
                Width = 36
                Height = 15
                Caption = 'Kunde'
              end
              object edcfKUNDE: TDBEdit
                Tag = 32
                Left = 56
                Top = 8
                Width = 457
                Height = 23
                DataField = 'cfKUNDE'
                DataSource = LuAufp
                TabOrder = 0
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'Kunden'
            ExplicitTop = 6
            ExplicitHeight = 321
            inline FrZSPKU: TFrMuSi
              Left = 0
              Top = 0
              Width = 666
              Height = 277
              Align = alClient
              TabOrder = 0
              ExplicitWidth = 666
              ExplicitHeight = 297
              inherited Panel12: TPanel [0]
                Left = 638
                Height = 277
                ExplicitLeft = 638
                ExplicitHeight = 297
                inherited btnFTab: TqBtnMuSi
                  Visible = False
                end
              end
              inherited Mu: TMultiGrid [1]
                Width = 638
                Height = 277
                Hint = ''
                DataSource = LuZSPKU
                TitleFont.Charset = ANSI_CHARSET
                TitleFont.Color = clBlack
                TitleFont.Height = -12
                TitleFont.Name = 'Arial'
                ColumnList.Strings = (
                  'Nummer:6=KUNW_NR'
                  'Name:25=SO_KUNW_NAME1'
                  'Land:2=SO_KUNW_LAND'
                  'Ort:20=SO_KUNW_ORT')
                MuOptions = [muNoAskLayout, muPostOnExit]
                DefaultRowHeight = 19
              end
            end
            object Panel5: TPanel
              Left = 0
              Top = 277
              Width = 666
              Height = 24
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitTop = 297
              object Label39: TLabel
                Left = 8
                Top = 4
                Width = 52
                Height = 15
                Caption = 'Spedition'
              end
              object edSPEDITION_1: TLookUpEdit
                Left = 96
                Top = 2
                Width = 441
                Height = 23
                DataField = 'SPEDITION'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 0
                Options = [LeNoNullValues]
                LookupSource = LuSped
                LookupField = 'SPED_NAME'
                KeyField = True
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'S&ystem'
            ExplicitTop = 6
            ExplicitHeight = 321
            object Label4: TLabel
              Left = 8
              Top = 8
              Width = 85
              Height = 15
              Caption = 'ERFASST_VON'
              FocusControl = EditERFASST_VON
            end
            object Label11: TLabel
              Left = 149
              Top = 8
              Width = 76
              Height = 15
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_AM
            end
            object Label12: TLabel
              Left = 8
              Top = 56
              Width = 106
              Height = 15
              Caption = 'GEAENDERT_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label13: TLabel
              Left = 149
              Top = 56
              Width = 97
              Height = 15
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label9: TLabel
              Left = 8
              Top = 104
              Width = 147
              Height = 15
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object Label22: TLabel
              Left = 290
              Top = 8
              Width = 85
              Height = 15
              Caption = 'ERFASST_ORT'
              FocusControl = EditERFASST_AM
            end
            object Label23: TLabel
              Left = 290
              Top = 56
              Width = 106
              Height = 15
              Caption = 'GEAENDERT_ORT'
              FocusControl = EditERFASST_AM
            end
            object Label19: TLabel
              Left = 240
              Top = 104
              Width = 12
              Height = 15
              Caption = 'ID'
            end
            object Label5: TLabel
              Left = 149
              Top = 104
              Width = 77
              Height = 15
              Caption = 'REPLIKATION'
            end
            object Label15: TLabel
              Left = 0
              Top = 152
              Width = 52
              Height = 15
              Caption = 'PEKR_ID'
            end
            object Label25: TLabel
              Left = 161
              Top = 152
              Width = 91
              Height = 15
              Alignment = taRightJustify
              Caption = 'SILO WERK_NR'
            end
            object Label42: TLabel
              Left = 3
              Top = 178
              Width = 47
              Height = 15
              Caption = 'Aufdruck'
              FocusControl = edORI_KART_NR
            end
            object Label43: TLabel
              Left = 155
              Top = 176
              Width = 97
              Height = 15
              Alignment = taRightJustify
              Caption = 'SPED WERK_NR'
            end
            object Label38: TLabel
              Left = 3
              Top = 202
              Width = 36
              Height = 15
              Caption = 'Kunde'
              FocusControl = edKUNW_NAME1
            end
            object EdMARA_ID: TDBEdit
              Left = 240
              Top = 118
              Width = 70
              Height = 23
              DataField = 'KART_ID'
              DataSource = LDataSource1
              TabOrder = 0
            end
            object EditERFASST_VON: TDBEdit
              Left = 8
              Top = 24
              Width = 139
              Height = 23
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              TabOrder = 1
            end
            object EditERFASST_AM: TDBEdit
              Left = 149
              Top = 24
              Width = 139
              Height = 23
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              TabOrder = 2
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 8
              Top = 72
              Width = 139
              Height = 23
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              TabOrder = 3
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 149
              Top = 72
              Width = 139
              Height = 23
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              TabOrder = 4
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 16
              Top = 118
              Width = 70
              Height = 23
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              TabOrder = 5
            end
            object EditERFASST_DATENBANK: TDBEdit
              Left = 290
              Top = 24
              Width = 139
              Height = 23
              DataField = 'ERFASST_DATENBANK'
              DataSource = LDataSource1
              TabOrder = 6
            end
            object EditGEAENDERT_DATENBANK: TDBEdit
              Left = 290
              Top = 72
              Width = 139
              Height = 23
              DataField = 'GEAENDERT_DATENBANK'
              DataSource = LDataSource1
              TabOrder = 7
            end
            object EditREPLIKATION: TDBEdit
              Left = 149
              Top = 118
              Width = 70
              Height = 23
              DataField = 'REPLIKATION'
              DataSource = LDataSource1
              TabOrder = 8
            end
            object LePEKR_ID: TLookUpEdit
              Left = 56
              Top = 150
              Width = 70
              Height = 23
              DataField = 'PEKR_ID'
              DataSource = LDataSource1
              TabOrder = 9
              Options = []
              LookupSource = LuPEKR
              LookupField = 'PEKR_ID'
              KeyField = True
            end
            object edSO_WERK_NR: TLookUpEdit
              Left = 264
              Top = 150
              Width = 44
              Height = 23
              DataField = 'WERK_NR'
              DataSource = LDataSource1
              TabOrder = 10
              Options = [LeNoNullValues, LeNoOverride]
              LookupSource = LuSILO
              LookupField = 'SO_WERK_NR'
              KeyField = False
            end
            object edORI_KART_NR: TDBEdit
              Left = 56
              Top = 176
              Width = 88
              Height = 23
              Hint = 'Originalkarte (Aufdruck)'
              DataField = 'ORI_KART_NR'
              DataSource = LDataSource1
              TabOrder = 11
            end
            object LeSpedWERK_NR: TLookUpEdit
              Left = 264
              Top = 174
              Width = 44
              Height = 23
              DataField = 'WERK_NR'
              DataSource = LDataSource1
              TabOrder = 12
              Options = [LeNoNullValues, LeNoOverride]
              LookupSource = LuSped
              LookupField = 'WERK_NR'
              KeyField = False
            end
            object edKUNW_NAME1: TDBEdit
              Left = 56
              Top = 200
              Width = 249
              Height = 23
              Hint = 'Originalkarte (Aufdruck)'
              DataField = 'KUNW_NAME1'
              TabOrder = 13
            end
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Multi'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 678
        Height = 408
        Align = alClient
        TabOrder = 0
        object Mu1: TMultiGrid
          Left = 0
          Top = 0
          Width = 674
          Height = 363
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
            'Werk:4=WERK_NR'
            'Karte:11=KART_NR'
            'Spender:6=SPENDER_KNZ'
            'Kfz:11=TRANSPORTMITTEL'
            'Kd.Nr.:6=KUNW_NR'
            'Kunde:44=cfKUNDE')
          ReturnSingle = True
          NoColumnSave = False
          MuOptions = [muNoAskLayout]
          DefaultRowHeight = 19
          Drag0Value = '0'
        end
        object Panel3: TPanel
          Left = 0
          Top = 363
          Width = 674
          Height = 41
          Align = alBottom
          TabOrder = 1
          object chbWerk: TCheckBox
            Left = 15
            Top = 14
            Width = 210
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Werk %s'
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
        end
      end
    end
  end
  object LTabSet1: TLTabSet
    Left = 0
    Top = 408
    Width = 707
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object Panel2: TPanel
    Left = 678
    Top = 0
    Width = 29
    Height = 408
    Align = alRight
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 2
    object BtnSingle: TqBtnMuSi
      Left = -1
      Top = 62
      Width = 25
      Height = 40
      Hint = 'Datenmaske'
      GroupIndex = 901
      Glyph.Data = {
        62070000424D620700000000000036040000280000001C0000001D0000000100
        0800000000002C03000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000A4C8F0000080
        FF00A0A0A40000408000FF008000400080008040000000000000000000000000
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
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000FFFBF0008080400000FF800000404000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000
        0000000000000000000000000000000000FFFFF8FFF8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F800FFFFF8FF070707070707070707070707070707
        07070707070707F800FFFFF8FF07070707070707070707070707070707070707
        070707F800FFFFF8FF07070707070707070707070707070707070707070707F8
        00FFFFF8FF07070707070707FFFFFFFFFFFFFFFFFFFFFFFFFF0707F800FFFFF8
        FF07070707070707FFFFFFFFFFFFFFFFFFFFFFFFFF0707F800FFFFF8FF070707
        07070707FFFFFFFFFFFFFFFFFFFFFFFFFF0707F800FFFFF8FF07000000070707
        FFFFFFFFFFFFFFFFFFFFFFFFFF0707F800FFFFF8FF07000000070707FFFFFFFF
        FFFFFFFFFFFFFFFFFF0707F800FFFFF8FF070707070707070707070707070707
        07070707070707F800FFFFF8FF07070707070707070707070707070707070707
        070707F800FFFFF8FF07070707070707070707070707070707070707070707F8
        00FFFFF8FF07070707070707070707070707070707070707070707F800FFFFF8
        FF07000000070707FFFFFFFFFFFFFFFFFFFFFF07070707F800FFFFF8FF070000
        00070707FFFFFFFFFFFFFFFFFFFFFF07070707F800FFFFF8FF07070707070707
        070707070707070707070707070707F800FFFFF8FF0707070707070707070707
        0707070707070707070707F800FFFFF8FF070707070707070707070707070707
        07070707070707F800FFFFF8FF07000000070707FFFFFFFFFFFFFFFFFF070707
        070707F800FFFFF8FF07000000070707FFFFFFFFFFFFFFFFFF070707070707F8
        00FFFFF8FF07070707070707070707070707070707070707070707F800FFFFF8
        FF07070707070707070707070707070707070707070707F800FFFFF8FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFF8FCFCFCFCFCFCFCFC
        FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC00FFFFF80D0D0D0D0D0D0D0D0D0D0D0D
        0D0D0D0D0D0D0D0D0D0D0D0D00FFFFF8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF}
      Layout = blGlyphTop
      NoteBook = PageBook
      Page = 'Single'
      LookUpModus = lumZeigMsk
    end
    object BtnMulti: TqBtnMuSi
      Left = -1
      Top = 13
      Width = 25
      Height = 40
      Hint = 'Tabelle'
      GroupIndex = 901
      Glyph.Data = {
        62070000424D620700000000000036040000280000001C0000001D0000000100
        0800000000002C03000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000A4C8F0000080
        FF00A0A0A40000408000FF008000400080008040000000000000000000000000
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
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000FFFBF0008080400000FF800000404000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80000000000000000
        0000000000000000000000000000000000FFFFF8FFF8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F800FFFFF8FF070707070707070707070707070707
        07070707070707F800FFFFF8FF07000000000000000000000000000000000000
        000007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007F80007F8
        00FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8
        FF07000000000000000000000000000000000000000007F800FFFFF8FF0700FF
        FFFFF8FFFFFFF8FFFFFFF8FFFFFF0007FF0007F800FFFFF8FF0700FFFFFFF8FF
        FFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8FF0700000000000000000000
        0000000000000007FF0007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FF
        FFFF00FF070007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007
        FF0007F800FFFFF8FF070000000000000000000000000000000000FF070007F8
        00FFFFF8FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF0007FF0007F800FFFFF8
        FF0700FFFFFFF8FFFFFFF8FFFFFFF8FFFFFF00FF070007F800FFFFF8FF070000
        00000000000000000000000000000000000007F800FFFFF8FF0700FFFFFFF8FF
        FFFFF8FFFFFFF8FFFFFF0007070007F800FFFFF8FF0700FFFFFFF8FFFFFFF8FF
        FFFFF8FFFFFF00FF070007F800FFFFF8FF070000000000000000000000000000
        00000000000007F800FFFFF8FF07000707070707070707070707070707070007
        F80007F800FFFFF8FF070007070707070707070707070707070700FF070007F8
        00FFFFF8FF07000000000000000000000000000000000000000007F800FFFFF8
        FF07070707070707070707070707070707070707070707F800FFFFF8FFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFF8FCFCFCFCFCFCFCFC
        FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC00FFFFF8040404040404040404040404
        04040404040404040404040400FFFFF8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      NoteBook = PageBook
      Page = 'Multi'
      LookUpModus = lumZeigMsk
    end
  end
  object Nav: TLNavigator
    TabSet = LTabSet1
    PageBook = PageBook
    DetailBook = DetailBook
    FormKurz = 'KART'
    BtnSingle = BtnSingle
    BtnMulti = BtnMulti
    FirstControl = edKART_NR
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
    NoOpen = True
    NoGotoPos = False
    CalcList.Strings = (
      'cfKUNDE=lookup:LuKUNW;NAME1')
    FltrList.Strings = (
      'SPENDER_KNZ=N;=')
    FormatList.Strings = (
      'KUND_KNZ=Asw,KundPers'
      'SPERR_KNZ=Asw,JNX'
      'SPENDER_KNZ=Asw,JNX'
      'SORTE_KNZ=Asw,JNX'
      'FREMDWAEGUNG=Asw,JNX'
      'TROCKEN_FEUCHT=Asw,TrockenFeucht'
      'PROBENPFLICHT=Asw,JNX'
      'AUFBAU=Asw,FrzgAufbau'
      'WERK_NR=N,'
      'KUNW_NR=INT,TL0,'
      'AUFK_NR=INT,TL0,'
      'PEKR_NR=N,'
      'TARA_GEWICHT=#0.00'
      'MAX_BRUTTO=#0.00')
    Bemerkung.Strings = (
      'Das ist die erste Bemerkung'
      'zu diesem LNavigator')
    KeyList.Strings = (
      'Standard=KART_NR'
      'Kunde=KUNW_NR')
    PrimaryKeyFields = 'KART_ID'
    TableName = 'KARTEN'
    TabTitel = 'Karten'
    OnRech = NavRech
    OnErfass = NavErfass
    BeforePost = NavBeforePost
    Left = 583
    Top = 166
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnStateChange = LDataSource1StateChange
    OnDataChange = LDataSource1DataChange
    Left = 583
    Top = 138
  end
  object PsDflt: TPrnSource
    QRepKurz = 'DFLT'
    Preview = True
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
    Left = 584
    Top = 267
  end
  object LuAufp: TLookUpDef
    DataSet = TblAufP
    LuKurz = 'AUFP'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    CalcList.Strings = (
      'cfKUNDE=string:250')
    FltrList.Strings = (
      'POSITIONSART=J')
    FormatList.Strings = (
      'AUFK_NR=INT,TL0,')
    Bemerkung.Strings = (
      'VERSANDART_TYP=LL;LV'
      'Feld ist nicht definiert')
    KeyList.Strings = (
      'Standard=MARA_KURZ;SO_AUFK_NR')
    PrimaryKeyFields = 'AUFK_ID'
    References.Strings = (
      'P.AUFP_AUFK_ID=K.AUFK_ID'
      'KUNW_NR=:KUNW_NR'
      'WERK_NR=:WERK_NR'
      'K.STATUS=J'
      'P.STATUS=J'
      'POSITIONSART=J')
    SqlFieldList.Strings = (
      'AUFK_NR'
      'AUFP_NR'
      'GESPERRT'
      'BESTELLNUMMER'
      'AUFK_ID'
      'WERK_NAME'
      'SPRACHE'
      'POS_INFO'
      'BESTELLDATUM'
      'BESTELLZEICHEN'
      'BAHNSTATION'
      'VERSANDWEG'
      'VERSANDBEZEICHNUNG'
      'VERSANDART_TYP'
      'LIEFERTEXT'
      'LIEFERANT_NAME_1'
      'ANZAHL_LIEFERSCHEINE'
      'BELADESCHEIN_NR'
      'KUNW_NR'
      'KUNW_MATCH'
      'KUNW_NAME1'
      'KUNW_NAME2'
      'KUNW_NAME3'
      'KUNW_STRASSE'
      'KUNW_LAND'
      'KUNW_PLZ'
      'KUNW_ORT'
      'KUNR_NR'
      'KUNR_MATCH'
      'KUNR_NAME1'
      'KUNR_NAME2'
      'KUNR_NAME3'
      'KUNR_STRASSE'
      'KUNR_LAND'
      'KUNR_PLZ'
      'KUNR_ORT'
      'INFO_1'
      'SPEDITION'
      'K.STATUS'
      'P.STATUS'
      'ABRUFCODE'
      'NEUER_AUFTRAG'
      'LUFTAUFTRAG'
      'VORLAGE'
      'RESTMENGE'
      'VERKAUFSBUERO'
      'SACHBEARBEITER'
      'ABLADESTELLE'
      'BAHNCODE'
      'ART'
      'VKORG'
      'AUFP_ID'
      'AUFP_AUFK_ID'
      'SO_AUFK_NR'
      'KUNW_MARA_KURZ'
      'MARA_KURZ'
      'MARA_NAME'
      'MARA_LANG'
      'PRD_HIERARCH_TEXT'
      'PRD_HIERARCH_KEY'
      'GEWICHT_EINHEIT'
      'BESTELLMENGE'
      'VERSANDMENGE'
      'CHARGENNUMMER'
      'POSITIONSART'
      'DRUCK_KNZ'
      'LIEFERRELEVANT'
      'UEBERPOSITION'
      'FUEHERENDE_POS'
      'WERK_NR'
      'LAGERORT'
      'LAGER_FACH'
      'VERSANDSTELLE'
      'CHARGENPFLICHTIG'
      'CHARGEN_TEXT'
      'DISPOMENGE'
      'DISPORESTMENGE'
      'WERKSATTEST'
      'KLASSE'
      'FAKTOR')
    TableName = 'K=AUFTRAGS_KOEPFE;P=AUFTRAGS_POSITIONEN'
    TabTitel = 'Auftragsposition'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuAufpGet
    Left = 585
    Top = 201
  end
  object LuWERK: TLookUpDef
    DataSet = TblWERK
    LuKurz = 'WERK'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Werk Nr:4=WERK_NR'
      'Name:25=WERK_NAME')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    KeyList.Strings = (
      'Standard=WERK_NR')
    PrimaryKeyFields = 'WERK_ID'
    References.Strings = (
      'WERK_NR=:WERK_NR')
    SOList.Strings = (
      'WERK_NR=:WERK_NR')
    TableName = 'WERKE'
    TabTitel = ';Werke'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 502
    Top = 146
  end
  object LuPEKR: TLookUpDef
    DataSet = TblPEKR
    LuKurz = 'PEKR'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    KeyList.Strings = (
      'Standard=PEKR_BEZ')
    PrimaryKeyFields = 'PEKR_ID'
    References.Strings = (
      'PEKR_ID=:PEKR_ID')
    SOList.Strings = (
      'PEKR_NR=:PEKR_NR'
      'PEKR_BEZ=:PEKR_BEZ'
      'PEKR_ID=:PEKR_ID')
    TableName = 'SBT_PERSONENKREIS'
    TabTitel = ';Personenkreise'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 310
    Top = 74
  end
  object LuAUFK: TLookUpDef
    DataSet = TblAUFK
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luGridFltr]
    ColumnList.Strings = (
      'Nummer:9=AUFK_NR'
      'KundeNr:7=KUNW_NR'
      'Name:20=KUNW_NAME1'
      'Ort:12=KUNW_ORT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'KUNW_NR=:KUNW_NR'
      'WERK_NR=:WERK_NR'
      'STATUS=J')
    FormatList.Strings = (
      'KUNW_NR=INT,TL0,'
      'AUFK_NR=INT,TL0,')
    KeyList.Strings = (
      'Standard=AUFK_NR')
    PrimaryKeyFields = 'AUFK_NR'
    References.Strings = (
      'AUFK_NR=:AUFK_NR')
    SOList.Strings = (
      'AUFK_NR=:AUFK_NR')
    TableName = 'AUFTRAGS_KOEPFE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 374
    Top = 74
  end
  object LuMARA: TLookUpDef
    DataSet = TblMARA
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luGridFltr]
    ColumnList.Strings = (
      'Material:11=MARA_NR'
      'Name:45=MARA_NAME')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'WERK_NR=:WERK_NR')
    FormatList.Strings = (
      'MARA_NR=TL0,')
    KeyList.Strings = (
      'Standard=MARA_NR')
    PrimaryKeyFields = 'MARA_NR'
    TableName = 'MATERIALSTAMM'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    AfterReturn = LuMARAAfterReturn
    Left = 446
    Top = 74
  end
  object LuSILO: TLookUpDef
    DataSet = TblSILO
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Nummer=SILO_NR'
      'Siloname=SILO_NAME')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'SO_WERK_NR=:WERK_NR')
    KeyList.Strings = (
      'Standard=SO_WERK_NR;SILO_NR')
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_NR=:SILO_NR'
      'SO_WERK_NR=:WERK_NR')
    SOList.Strings = (
      'SILO_NR=:SILO_NR'
      'SO_WERK_NR=:WERK_NR')
    TableName = 'SILOLISTE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 518
    Top = 74
  end
  object LuLFSK: TLookUpDef
    DataSet = TblLFSK
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Datum:10=BELADEDATUM'
      'Zeit:6=AUSFAHRT_ZEIT'
      'Tara Gewicht=TARA_GEWICHT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FltrList.Strings = (
      'BELADEDATUM=>=01.01.2003'
      'TRANSPORTMITTEL=:TRANSPORTMITTEL&{TARA_ART='#39'*'#39'}'
      'TARA_GEWICHT=>0')
    FormatList.Strings = (
      'TARA_GEWICHT=#0.00')
    KeyFields = 'BELADEDATUM desc;AUSFAHRT_ZEIT desc'
    PrimaryKeyFields = 'LFSK_ID'
    References.Strings = (
      'BELADEDATUM=>=01.01.2003'
      'TRANSPORTMITTEL=:TRANSPORTMITTEL&{TARA_ART='#39'*'#39'}'
      'TARA_GEWICHT=>0')
    SqlFieldList.Strings = (
      'BELADEDATUM'
      'AUSFAHRT_ZEIT'
      'TARA_GEWICHT'
      'TRANSPORTMITTEL')
    TableName = 'LIEFERSCHEIN_KOEPFE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    AfterReturn = LuLFSKAfterReturn
    Left = 502
    Top = 110
  end
  object LuSped: TLookUpDef
    DataSet = TblSPED
    LuKurz = 'SPED'
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
      'WERK_NR=:WERK_NR')
    KeyList.Strings = (
      'Standard=WERK_NR;SPED_NAME')
    PrimaryKeyFields = 'SPED_ID'
    References.Strings = (
      'SPED_NAME=:SPEDITION'
      'WERK_NR=:WERK_NR')
    SOList.Strings = (
      'SPED_NAME=:SPEDITION'
      'WERK_NR=:WERK_NR')
    TableName = 'SPEDITIONEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 502
    Top = 182
  end
  object LuZSPKU: TLookUpDef
    DataSet = TblZSPKU
    LuKurz = 'ZSPKU'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FormatList.Strings = (
      'KUNW_NR=TL0,')
    KeyList.Strings = (
      'Standard=KUNW_NR')
    PrimaryKeyFields = 'ZSPKU_ID'
    References.Strings = (
      'SPED_NAME=:SPED_NAME'
      'WERK_NR=:WERK_NR')
    TableName = 'ZUORD_SPEDITION_KUNDE'
    MasterSource = LuSped
    DisabledButtons = []
    EnabledButtons = []
    Left = 502
    Top = 216
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from KARTEN'
      'where ((SPENDER_KNZ = '#39'N'#39') or (SPENDER_KNZ is null ))')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 581
    Top = 109
  end
  object TblAufP: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select K.AUFK_NR,'
      '       P.AUFP_NR,'
      '       K.GESPERRT,'
      '       K.BESTELLNUMMER,'
      '       K.AUFK_ID,'
      '       K.WERK_NAME,'
      '       K.SPRACHE,'
      '       K.POS_INFO,'
      '       K.BESTELLDATUM,'
      '       K.BESTELLZEICHEN,'
      '       K.BAHNSTATION,'
      '       K.VERSANDWEG,'
      '       K.VERSANDBEZEICHNUNG,'
      '       K.VERSANDART_TYP,'
      '       K.LIEFERTEXT,'
      '       K.LIEFERANT_NAME_1,'
      '       K.ANZAHL_LIEFERSCHEINE,'
      '       K.BELADESCHEIN_NR,'
      '       K.KUNW_NR,'
      '       K.KUNW_MATCH,'
      '       K.KUNW_NAME1,'
      '       K.KUNW_NAME2,'
      '       K.KUNW_NAME3,'
      '       K.KUNW_STRASSE,'
      '       K.KUNW_LAND,'
      '       K.KUNW_PLZ,'
      '       K.KUNW_ORT,'
      '       K.KUNR_NR,'
      '       K.KUNR_MATCH,'
      '       K.KUNR_NAME1,'
      '       K.KUNR_NAME2,'
      '       K.KUNR_NAME3,'
      '       K.KUNR_STRASSE,'
      '       K.KUNR_LAND,'
      '       K.KUNR_PLZ,'
      '       K.KUNR_ORT,'
      '       K.INFO_1,'
      '       K.SPEDITION,'
      '       K.STATUS,'
      '       P.STATUS,'
      '       K.ABRUFCODE,'
      '       K.NEUER_AUFTRAG,'
      '       K.LUFTAUFTRAG,'
      '       K.VORLAGE,'
      '       K.RESTMENGE,'
      '       K.VERKAUFSBUERO,'
      '       K.SACHBEARBEITER,'
      '       K.ABLADESTELLE,'
      '       K.BAHNCODE,'
      '       K.ART,'
      '       K.VKORG,'
      '       P.AUFP_ID,'
      '       P.AUFP_AUFK_ID,'
      '       P.SO_AUFK_NR,'
      '       P.KUNW_MARA_KURZ,'
      '       P.MARA_KURZ,'
      '       K.MARA_NAME,'
      '       P.MARA_LANG,'
      '       P.PRD_HIERARCH_TEXT,'
      '       P.PRD_HIERARCH_KEY,'
      '       P.GEWICHT_EINHEIT,'
      '       K.BESTELLMENGE,'
      '       P.VERSANDMENGE,'
      '       P.CHARGENNUMMER,'
      '       P.POSITIONSART,'
      '       P.DRUCK_KNZ,'
      '       P.LIEFERRELEVANT,'
      '       P.UEBERPOSITION,'
      '       P.FUEHERENDE_POS,'
      '       K.WERK_NR,'
      '       P.LAGERORT,'
      '       P.LAGER_FACH,'
      '       P.VERSANDSTELLE,'
      '       P.CHARGENPFLICHTIG,'
      '       P.CHARGEN_TEXT,'
      '       P.DISPOMENGE,'
      '       P.DISPORESTMENGE,'
      '       K.WERKSATTEST,'
      '       P.KLASSE,'
      '       P.FAKTOR'
      'from AUFTRAGS_KOEPFE K,'
      '     AUFTRAGS_POSITIONEN P'
      'where (K.KUNW_NR = :KUNW_NR)'
      '  and (K.WERK_NR = :WERK_NR)'
      '  and (K.STATUS = '#39'J'#39')'
      '  and (P.STATUS = '#39'J'#39')'
      '  and (P.POSITIONSART = '#39'J'#39')'
      '  and (P.AUFP_AUFK_ID=K.AUFK_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 585
    Top = 233
    ParamData = <
      item
        DataType = ftString
        Name = 'KUNW_NR'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object TblWERK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from WERKE'
      'where (WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 530
    Top = 146
    ParamData = <
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object TblKUNW: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select ADRE_ID,'
      '       KUNW_NR,'
      '       MATCH,'
      '       NAME1,'
      '       NAME2,'
      '       NAME3,'
      '       STRASSE,'
      '       LAND,'
      '       PLZ,'
      '       ORT,'
      '       TELEFON,'
      '       TELEFAX,'
      '       SPRACHE'
      'from ADRESSEN'
      'where (KUNW_NR = :KUNW_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 274
    Top = 74
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'KUNW_NR'
        Value = Null
      end>
  end
  object TblPEKR: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SBT_PERSONENKREIS'
      'where (PEKR_ID = :PEKR_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeFetch = TblPEKRBeforeFetch
    BeforeOpen = TblPEKRBeforeOpen
    BeforeClose = TblPEKRBeforeClose
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 338
    Top = 74
    ParamData = <
      item
        DataType = ftFloat
        Name = 'PEKR_ID'
      end>
  end
  object TblAUFK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from AUFTRAGS_KOEPFE'
      'where (AUFK_NR = :AUFK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 406
    Top = 74
    ParamData = <
      item
        DataType = ftString
        Name = 'AUFK_NR'
      end>
  end
  object TblMARA: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from MATERIALSTAMM')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 478
    Top = 74
  end
  object TblSILO: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_NR = :SILO_NR)'
      '  and (SO_WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 550
    Top = 74
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO_NR'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object TblLFSK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select BELADEDATUM,'
      '       AUSFAHRT_ZEIT,'
      '       TARA_GEWICHT,'
      '       TRANSPORTMITTEL'
      'from LIEFERSCHEIN_KOEPFE'
      'where (BELADEDATUM >= '#39'01.01.2003'#39')'
      '  and ((TRANSPORTMITTEL = :TRANSPORTMITTEL) and (TARA_ART='#39'*'#39'))'
      '  and (TARA_GEWICHT > 0)'
      'order by BELADEDATUM desc,'
      '         AUSFAHRT_ZEIT desc')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblLFSKBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 534
    Top = 110
    ParamData = <
      item
        DataType = ftString
        Name = 'TRANSPORTMITTEL'
      end>
  end
  object TblSPED: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SPEDITIONEN'
      'where (SPED_NAME = :SPEDITION)'
      '  and (WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 534
    Top = 182
    ParamData = <
      item
        DataType = ftString
        Name = 'SPEDITION'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object TblZSPKU: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from ZUORD_SPEDITION_KUNDE'
      'where (SPED_NAME = :SPED_NAME)'
      '  and (WERK_NR = :WERK_NR)')
    MasterSource = LuSped
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 534
    Top = 216
    ParamData = <
      item
        DataType = ftString
        Name = 'SPED_NAME'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object LuKUNW: TLookUpDef
    DataSet = TblKUNW
    LuKurz = 'ADRE'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luTolerant, luMessage, LuTabelle, luGridFltr]
    ColumnList.Strings = (
      'Nummer:10=KUNW_NR'
      'Name1:14=NAME1'
      'Name2:20=NAME2'
      'Land:2=LAND'
      'PLZ:6=PLZ'
      'Ort:21=ORT'
      'Strasse:20=STRASSE')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = True
    MDTyp = mdMaster
    FormatList.Strings = (
      'KUNW_NR=INT,TL0,')
    KeyList.Strings = (
      'Standard=KUNW_NR')
    PrimaryKeyFields = 'ADRE_ID'
    References.Strings = (
      'KUNW_NR=:KUNW_NR')
    SOList.Strings = (
      'KUNW_NR=:KUNW_NR'
      'NAME1=:KUNW_NAME1'
      'ORT=:KUNW_ORT'
      'LAND=:KUNW_LAND'
      'NAME2=:KUNW_NAME2'
      'PLZ=:KUNW_PLZ'
      'STRASSE=:KUNW_STRASSE')
    SqlFieldList.Strings = (
      'ADRE_ID'
      'KUNW_NR'
      'MATCH'
      'NAME1'
      'NAME2'
      'NAME3'
      'STRASSE'
      'LAND'
      'PLZ'
      'ORT'
      'TELEFON'
      'TELEFAX'
      'SPRACHE')
    TableName = 'ADRESSEN'
    TabTitel = ';Warenempf'#228'nger'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 246
    Top = 73
  end
end
