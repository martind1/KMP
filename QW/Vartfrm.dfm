object FrmVart: TFrmVart
  Left = 405
  Top = 283
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeable
  Caption = 'Versandarten'
  ClientHeight = 371
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object PageBook: TqNoteBook
    Left = 0
    Top = 0
    Width = 547
    Height = 350
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Single'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 547
        Height = 350
        Align = alClient
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 543
          Height = 82
          Align = alTop
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 18
            Width = 60
            Height = 15
            Caption = 'Versandart'
            FocusControl = EdVERSANDWEG
          end
          object Label3: TLabel
            Left = 8
            Top = 49
            Width = 61
            Height = 15
            Caption = 'Versandtyp'
            FocusControl = EdVERSANDART_TYP
          end
          object EdVERSANDBEZEICHNUNG: TDBEdit
            Left = 130
            Top = 15
            Width = 171
            Height = 23
            DataField = 'VERSANDBEZEICHNUNG'
            DataSource = LDataSource1
            TabOrder = 1
          end
          object EdVERSANDWEG: TDBEdit
            Left = 85
            Top = 15
            Width = 31
            Height = 23
            DataField = 'VERSANDWEG'
            DataSource = LDataSource1
            TabOrder = 0
          end
          object EdVERSANDART_TYP: TDBEdit
            Left = 85
            Top = 46
            Width = 30
            Height = 23
            CharCase = ecUpperCase
            DataField = 'VERSANDART_TYP'
            DataSource = LDataSource1
            TabOrder = 3
          end
          object RgVERSANDART_TYP: TDBRadioGroup
            Left = 131
            Top = 37
            Width = 335
            Height = 35
            Color = clBtnFace
            Columns = 4
            Ctl3D = True
            DataField = 'VERSANDART_TYP'
            DataSource = LDataSource1
            Items.Strings = (
              'LKW lose'
              'LKW verp.'
              'Bahn lose'
              'Bahn verp.')
            ParentColor = False
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 4
            Values.Strings = (
              'LL'
              'LV'
              'BL'
              'BV')
          end
          object chbMASTER: TDBCheckBox
            Left = 336
            Top = 16
            Width = 62
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Master'
            DataField = 'MASTER'
            DataSource = LDataSource1
            TabOrder = 2
            ValueChecked = 'J'
            ValueUnchecked = 'N'
          end
        end
        object DetailBook: TTabbedNotebook
          Left = 0
          Top = 82
          Width = 543
          Height = 264
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
            object GroupBox1: TGroupBox
              Left = 0
              Top = 0
              Width = 535
              Height = 99
              Align = alTop
              Caption = 'Bahnwaggon'
              TabOrder = 0
              object Label10: TLabel
                Left = 16
                Top = 22
                Width = 170
                Height = 15
                Caption = 'durchschnittliches Leergewicht'
              end
              object Label11: TLabel
                Left = 280
                Top = 22
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label12: TLabel
                Left = 16
                Top = 46
                Width = 70
                Height = 15
                Caption = 'Ladegewicht'
              end
              object Label13: TLabel
                Left = 280
                Top = 46
                Width = 3
                Height = 15
                Caption = 't'
              end
              object Label14: TLabel
                Left = 16
                Top = 70
                Width = 56
                Height = 15
                Caption = 'Max.Brutto'
              end
              object Label15: TLabel
                Left = 280
                Top = 70
                Width = 3
                Height = 15
                Caption = 't'
              end
              object edTARA_GEWICHT: TDBEdit
                Left = 208
                Top = 20
                Width = 65
                Height = 23
                Hint = 'Taragewicht (QDispo)'
                DataField = 'TARA_GEWICHT'
                DataSource = LDataSource1
                TabOrder = 0
              end
              object edLADE_GEWICHT: TDBEdit
                Left = 208
                Top = 44
                Width = 65
                Height = 23
                Hint = 'Gewicht der Ladung (QDispo)'
                DataField = 'LADE_GEWICHT'
                DataSource = LDataSource1
                TabOrder = 1
              end
              object edMAX_BRUTTO: TDBEdit
                Left = 208
                Top = 68
                Width = 65
                Height = 23
                Hint = 'Max.Bruttogewicht (SMH)'
                DataSource = LDataSource1
                TabOrder = 2
              end
            end
            object GroupBox2: TGroupBox
              Left = 0
              Top = 99
              Width = 535
              Height = 135
              Align = alClient
              Caption = 'Bemerkung'
              TabOrder = 1
              object MemoBEMERKUNG: TDBMemo
                Left = 2
                Top = 17
                Width = 531
                Height = 116
                Align = alClient
                DataField = 'BEMERKUNG'
                DataSource = LDataSource1
                ScrollBars = ssVertical
                TabOrder = 0
              end
            end
          end
          object TTabPage
            Left = 4
            Top = 26
            Caption = 'S&ystem'
            object Label5: TLabel
              Left = 5
              Top = 44
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_VON'
              FocusControl = EditERFASST_VON
            end
            object Label6: TLabel
              Left = 5
              Top = 69
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_AM
            end
            object Label7: TLabel
              Left = 5
              Top = 95
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label8: TLabel
              Left = 5
              Top = 120
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label9: TLabel
              Left = 5
              Top = 146
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object Label1: TLabel
              Left = 5
              Top = 18
              Width = 145
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'VART_ID'
              FocusControl = EditVART_ID
            end
            object EditERFASST_VON: TDBEdit
              Left = 174
              Top = 41
              Width = 171
              Height = 23
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              TabOrder = 1
            end
            object EditERFASST_AM: TDBEdit
              Left = 174
              Top = 67
              Width = 57
              Height = 23
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              TabOrder = 2
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 174
              Top = 93
              Width = 171
              Height = 23
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              TabOrder = 3
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 174
              Top = 119
              Width = 57
              Height = 23
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              TabOrder = 4
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 174
              Top = 145
              Width = 57
              Height = 23
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              TabOrder = 5
            end
            object EditVART_ID: TDBEdit
              Left = 174
              Top = 15
              Width = 57
              Height = 23
              DataField = 'VART_ID'
              DataSource = LDataSource1
              TabOrder = 0
            end
          end
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Multi'
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 547
        Height = 350
        Align = alClient
        TabOrder = 0
        object Mu1: TMultiGrid
          Left = 0
          Top = 0
          Width = 543
          Height = 346
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
            'Nummer=VERSANDWEG'
            'Typ:3=VERSANDART_TYP'
            'Name=VERSANDBEZEICHNUNG')
          ReturnSingle = False
          NoColumnSave = False
          MuOptions = [muNoAskLayout]
          DefaultRowHeight = 19
          Drag0Value = '0'
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 547
    Top = 0
    Width = 30
    Height = 350
    Align = alRight
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    object BtnMulti: TqBtnMuSi
      Left = -1
      Top = 184
      Width = 25
      Height = 39
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
      Page = 'Multi'
      LookUpModus = lumZeigMsk
    end
    object BtnSingle: TqBtnMuSi
      Left = -1
      Top = 238
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
      Page = 'Single'
      LookUpModus = lumZeigMsk
    end
  end
  object LTabSet1: TLTabSet
    Left = 0
    Top = 350
    Width = 577
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object Query1: TuQuery
    DatabaseName = 'DB1'
    RequestLive = True
    SQL.Strings = (
      'select *'
      'from VART')
    UpdateMode = upWhereKeyOnly
    Left = 504
    Top = 63
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 496
    Top = 90
  end
  object Nav: TLNavigator
    TabSet = LTabSet1
    PageBook = PageBook
    DetailBook = DetailBook
    FormKurz = 'VART'
    BtnSingle = BtnSingle
    BtnMulti = BtnMulti
    FirstControl = EdVERSANDWEG
    AutoEditStart = False
    PageBookStart = 'Multi'
    DetailBookStart = '&etc.'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = False
    NoGotoPos = False
    FormatList.Strings = (
      'TARA_GEWICHT=0.000'
      'LADE_GEWICHT=0.000'
      'MAX_BRUTTO=0.000')
    PrimaryKeyFields = 'VART_ID'
    TableName = 'VART'
    TabTitel = 'Versandarten'
    Left = 496
    Top = 125
  end
  object PSrcVart: TPrnSource
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
    BeforePrn = PSrcVartBeforePrn
    Left = 498
    Top = 11
  end
end
