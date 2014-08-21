object FrmGrso: TFrmGrso
  Left = 647
  Top = 255
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Grund-/Mischsorten'
  ClientHeight = 387
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Label16: TLabel
    Left = 185
    Top = 61
    Width = 148
    Height = 16
    Caption = 'PRD_HIERARCH_TEXT'
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 634
    Height = 362
    ActivePage = Single
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object Multi: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object PanMu: TPanel
        Left = 0
        Top = 320
        Width = 606
        Height = 34
        Align = alBottom
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object chbWerk: TCheckBox
          Left = 15
          Top = 11
          Width = 210
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Werk '
          Color = 13160660
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          State = cbGrayed
          TabOrder = 0
          OnClick = chbFltrClick
        end
        object chbGrundsorte: TCheckBox
          Left = 303
          Top = 11
          Width = 94
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Grundsorten'
          Color = 13160660
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          OnClick = chbFltrClick
        end
        object chbMischsorte: TCheckBox
          Left = 431
          Top = 11
          Width = 94
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Mischsorten'
          Color = 13160660
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          OnClick = chbFltrClick
        end
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 606
        Height = 320
        Align = alClient
        DataSource = LDataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        ColumnList.Strings = (
          'Werk:10=WERK_NR'
          'Name:10=BEZEICHNUNG'
          'Mix:3=KOMBI_KNZ'
          'Offen:5=OFFENE_BEL'
          'Materialname:37=cfMARA_NAME'
          'SPS_SORTE:6=SPS_SORTE')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 20
        Drag0Value = '0'
      end
    end
    object Single: TTabSheet
      Caption = 'Formular'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DetailControl: TPageControl
        Left = 0
        Top = 81
        Width = 606
        Height = 273
        ActivePage = TabSheet1
        Align = alClient
        TabOrder = 1
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ScrollBox5: TScrollBox
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Panel1: TPanel
              Left = 0
              Top = 0
              Width = 598
              Height = 155
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object Label18: TLabel
                Left = 8
                Top = 139
                Width = 69
                Height = 16
                Caption = 'Bemerkung'
              end
              object Label5: TLabel
                Left = 8
                Top = 10
                Width = 62
                Height = 16
                Caption = 'SPS Sorte'
                FocusControl = edSPS_SORTE
              end
              object chbKOMBI_KNZ: TAswCheckBox
                Left = 6
                Top = 70
                Width = 132
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Mischsorte'
                DataField = 'KOMBI_KNZ'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 3
                ValueChecked = 'Ja'
                ValueUnchecked = 'Nein'
                AswName = 'JaNein'
              end
              object gbMisch: TGroupBox
                Tag = 128
                Left = 168
                Top = 40
                Width = 377
                Height = 113
                Caption = '&Zusammensetzung (Mischsorte)'
                TabOrder = 4
                object Label7: TLabel
                  Left = 8
                  Top = 19
                  Width = 24
                  Height = 16
                  Caption = 'Pos'
                end
                object Label8: TLabel
                  Left = 35
                  Top = 19
                  Width = 66
                  Height = 16
                  Caption = 'Grundsorte'
                end
                object LaAnteil: TLabel
                  Left = 301
                  Top = 19
                  Width = 33
                  Height = 16
                  Caption = 'Anteil'
                end
                object Label14: TLabel
                  Left = 109
                  Top = 19
                  Width = 77
                  Height = 16
                  Caption = 'Bezeichnung'
                end
                object LeBEZEICHNUNG1: TLookUpEdit
                  Left = 33
                  Top = 35
                  Width = 66
                  Height = 24
                  DataField = 'GRSO1_BEZEICHNUNG'
                  DataSource = LDataSource1
                  TabOrder = 1
                  Options = []
                  LookupSource = LuGrso1
                  LookupField = 'BEZEICHNUNG'
                  References.Strings = (
                    'WERK_NR=:WERK_NR')
                  KeyField = True
                end
                object EdPos1: TEdit
                  Left = 8
                  Top = 35
                  Width = 25
                  Height = 24
                  TabStop = False
                  Color = clSilver
                  ReadOnly = True
                  TabOrder = 0
                  Text = '  1'
                end
                object EdPos2: TEdit
                  Left = 8
                  Top = 59
                  Width = 25
                  Height = 24
                  TabStop = False
                  Color = clSilver
                  ReadOnly = True
                  TabOrder = 5
                  Text = '  2'
                end
                object LeBEZEICHNUNG2: TLookUpEdit
                  Left = 33
                  Top = 59
                  Width = 66
                  Height = 24
                  DataField = 'GRSO2_BEZEICHNUNG'
                  DataSource = LDataSource1
                  TabOrder = 6
                  Options = []
                  LookupSource = LuGrso2
                  LookupField = 'BEZEICHNUNG'
                  References.Strings = (
                    'WERK_NR=:WERK_NR')
                  KeyField = True
                end
                object BtnLuSilo1: TLookUpBtn
                  Left = 277
                  Top = 35
                  Width = 21
                  Height = 21
                  Glyph.Data = {
                    36030000424D3603000000000000360000002800000010000000100000000100
                    1800000000000003000000000000000000000000000000000000BFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000000000
                    0000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00
                    0000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000
                    0000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBF000000000000000000000000000000000000000000BFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                    0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                    0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF}
                  TabOrder = 3
                  LookUpDef = LuGrso1
                  Modus = lubMulti
                end
                object BtnLuSilo2: TLookUpBtn
                  Left = 277
                  Top = 59
                  Width = 21
                  Height = 21
                  Glyph.Data = {
                    36030000424D3603000000000000360000002800000010000000100000000100
                    1800000000000003000000000000000000000000000000000000BFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000000000
                    0000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00
                    0000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000
                    0000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBF000000000000000000000000000000000000000000BFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                    0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                    0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                    BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF}
                  TabOrder = 8
                  LookUpDef = LuGrso2
                  Modus = lubMulti
                end
                object edGrso1MARA_NAME: TLookUpEdit
                  Left = 99
                  Top = 35
                  Width = 178
                  Height = 24
                  DataField = 'MARA_NAME'
                  DataSource = LuGrso1
                  TabOrder = 2
                  Options = []
                  References.Strings = (
                    'WERK_NR=:WERK_NR')
                  KeyField = True
                end
                object edGrso2MARA_NAME: TLookUpEdit
                  Left = 99
                  Top = 59
                  Width = 178
                  Height = 24
                  DataField = 'MARA_NAME'
                  DataSource = LuGrso2
                  TabOrder = 7
                  Options = []
                  References.Strings = (
                    'WERK_NR=:WERK_NR')
                  KeyField = True
                end
                object cobGRSO1_ANTEIL: TDBComboBox
                  Tag = 1
                  Left = 301
                  Top = 35
                  Width = 65
                  Height = 24
                  DataField = 'GRSO1_ANTEIL'
                  DataSource = LDataSource1
                  DropDownCount = 30
                  Items.Strings = (
                    '10'
                    '20'
                    '25'
                    '30'
                    '33'
                    '40'
                    '50'
                    '60'
                    '67'
                    '70'
                    '75'
                    '80'
                    '90'
                    '100')
                  TabOrder = 4
                end
                object cobGRSO2_ANTEIL: TDBComboBox
                  Tag = 1
                  Left = 301
                  Top = 59
                  Width = 65
                  Height = 24
                  DataField = 'GRSO2_ANTEIL'
                  DataSource = LDataSource1
                  DropDownCount = 30
                  Items.Strings = (
                    '10'
                    '20'
                    '25'
                    '30'
                    '33'
                    '40'
                    '50'
                    '60'
                    '67'
                    '70'
                    '75'
                    '80'
                    '90'
                    '100')
                  TabOrder = 9
                end
                object PanSilo3: TPanel
                  Left = 2
                  Top = 83
                  Width = 373
                  Height = 28
                  Align = alBottom
                  BevelOuter = bvNone
                  TabOrder = 10
                  object EdPos3: TEdit
                    Left = 6
                    Top = 0
                    Width = 25
                    Height = 24
                    TabStop = False
                    Color = clSilver
                    ReadOnly = True
                    TabOrder = 0
                    Text = '  3'
                  end
                  object LeBEZEICHNUNG3: TLookUpEdit
                    Left = 31
                    Top = 0
                    Width = 66
                    Height = 24
                    DataField = 'GRSO3_BEZEICHNUNG'
                    DataSource = LDataSource1
                    TabOrder = 1
                    Options = []
                    LookupSource = LuGrso3
                    LookupField = 'BEZEICHNUNG'
                    References.Strings = (
                      'WERK_NR=:WERK_NR')
                    KeyField = True
                  end
                  object BtnLuSilo3: TLookUpBtn
                    Left = 275
                    Top = 0
                    Width = 21
                    Height = 21
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      1800000000000003000000000000000000000000000000000000BFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000000000
                      0000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00
                      0000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000000000
                      0000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBF000000000000000000000000000000000000000000BFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                      0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF00000000
                      0000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
                      BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF}
                    TabOrder = 2
                    LookUpDef = LuGrso3
                    Modus = lubMulti
                  end
                  object edGrso3MARA_NAME: TLookUpEdit
                    Left = 97
                    Top = 0
                    Width = 178
                    Height = 24
                    DataField = 'MARA_NAME'
                    DataSource = LuGrso3
                    TabOrder = 3
                    Options = []
                    References.Strings = (
                      'WERK_NR=:WERK_NR')
                    KeyField = True
                  end
                  object cobGRSO3_ANTEIL: TDBComboBox
                    Tag = 1
                    Left = 299
                    Top = 0
                    Width = 65
                    Height = 24
                    DataField = 'GRSO3_ANTEIL'
                    DataSource = LDataSource1
                    DropDownCount = 30
                    Items.Strings = (
                      '10'
                      '20'
                      '25'
                      '30'
                      '33'
                      '40'
                      '50'
                      '60'
                      '67'
                      '70'
                      '75'
                      '80'
                      '90'
                      '100')
                    TabOrder = 4
                  end
                end
              end
              object chbOFFENE_BEL: TAswCheckBox
                Left = 6
                Top = 45
                Width = 132
                Height = 17
                Alignment = taLeftJustify
                Caption = 'Offene Beladung'
                DataField = 'OFFENE_BEL'
                DataSource = LDataSource1
                TabOrder = 2
                ValueChecked = 'Ja'
                ValueUnchecked = 'Nein'
                AswName = 'JaNein'
              end
              object edSPS_SORTE: TLookUpEdit
                Left = 112
                Top = 8
                Width = 121
                Height = 24
                DataField = 'SPS_SORTE'
                DataSource = LDataSource1
                TabOrder = 0
                Options = []
                KeyField = True
              end
              object panTROCKEN_FEUCHT: TPanel
                Left = 248
                Top = 8
                Width = 177
                Height = 24
                BevelOuter = bvNone
                TabOrder = 1
                object AswRadioGroup1: TAswRadioGroup
                  Left = -8
                  Top = -11
                  Width = 177
                  Height = 34
                  Columns = 2
                  DataField = 'TROCKEN_FEUCHT'
                  DataSource = LDataSource1
                  Items.Strings = (
                    'Trocken'
                    'Feucht')
                  ParentBackground = True
                  TabOrder = 0
                  Values.Strings = (
                    'Trocken'
                    'Feucht')
                  AswName = 'TrockenFeucht'
                  Frame = frNone
                end
              end
            end
            object Panel2: TPanel
              Left = 0
              Top = 155
              Width = 598
              Height = 87
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object EdBEMERKUNG: TDBMemo
                Tag = 384
                Left = 0
                Top = 0
                Width = 598
                Height = 87
                Align = alClient
                DataField = 'BEMERKUNG'
                DataSource = LDataSource1
                ScrollBars = ssVertical
                TabOrder = 0
              end
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Silos'
          ImageIndex = 2
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Align = alClient
            Caption = 'Silos '#252'ber SPS Zuordnung'
            TabOrder = 0
            inline FrSILO: TFrMuSi
              Left = 2
              Top = 18
              Width = 594
              Height = 222
              Align = alClient
              TabOrder = 0
              ExplicitLeft = 2
              ExplicitTop = 18
              ExplicitWidth = 594
              ExplicitHeight = 222
              inherited Panel12: TPanel [0]
                Left = 566
                Height = 222
                ExplicitLeft = 566
                ExplicitHeight = 222
                inherited btnInsert: TqBtnMuSi
                  Visible = False
                end
                inherited btnEdit: TqBtnMuSi
                  Visible = False
                end
              end
              inherited Mu: TMultiGrid [1]
                Width = 566
                Height = 222
                DataSource = LuSILO
                TitleFont.Color = clBlack
                TitleFont.Height = -13
                TitleFont.Name = 'MS Sans Serif'
                ColumnList.Strings = (
                  'Werk:4=SO_WERK_NR'
                  'Bunker:6=SILO_NR'
                  'Bezeichnung:11=SILO_NAME'
                  'Belad.Einr.:9=BEIN_NR'
                  'Verp.:6=VERPACKART'
                  'Sperre:5=AKT_SPERRE_LKW'
                  'Prio:3=PRIO'
                  'SPS Sorte:8=AKT_SORTE')
                DefaultRowHeight = 20
              end
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Labor'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuV_LABI_GRSO_MK: TMultiGrid
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Align = alClient
            DataSource = LuV_LABI_GRSO_MK
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -13
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Silo1:4=SILO_NR1'
              'Silo2:4=SILO_NR2'
              'Prio1:1=PRIO1'
              'Prio2:1=PRIO2'
              'Mara1:8=MARA_NR1'
              'Mara2:8=MARA_NR2'
              'Anteil1:4=ANTEIL1'
              'Anteil2:4=ANTEIL2'
              'MK:6=MK')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit, muNoSlideBar]
            DefaultRowHeight = 20
            Drag0Value = '0'
          end
          object BtnMuV_LABI_MK: TBitBtn
            Left = 8
            Top = 8
            Width = 137
            Height = 57
            Caption = 'Daten anzeigen'
            TabOrder = 1
            OnClick = BtnMuV_LABI_MKClick
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          object ScrollBox4: TScrollBox
            Left = 0
            Top = 0
            Width = 598
            Height = 242
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Label10: TLabel
              Left = 8
              Top = 8
              Width = 99
              Height = 16
              Caption = 'ERFASST_VON'
              FocusControl = EditERFASST_VON
            end
            object Label11: TLabel
              Left = 149
              Top = 8
              Width = 90
              Height = 16
              Caption = 'ERFASST_AM'
              FocusControl = EditERFASST_AM
            end
            object Label12: TLabel
              Left = 8
              Top = 56
              Width = 121
              Height = 16
              Caption = 'GEAENDERT_VON'
              FocusControl = EditGEAENDERT_VON
            end
            object Label13: TLabel
              Left = 149
              Top = 56
              Width = 112
              Height = 16
              Caption = 'GEAENDERT_AM'
              FocusControl = EditGEAENDERT_AM
            end
            object Label9: TLabel
              Left = 8
              Top = 104
              Width = 166
              Height = 16
              Caption = 'ANZAHL_AENDERUNGEN'
              FocusControl = EditANZAHL_AENDERUNGEN
            end
            object Label22: TLabel
              Left = 290
              Top = 8
              Width = 99
              Height = 16
              Caption = 'ERFASST_ORT'
              FocusControl = EditERFASST_AM
            end
            object Label23: TLabel
              Left = 290
              Top = 56
              Width = 121
              Height = 16
              Caption = 'GEAENDERT_ORT'
              FocusControl = EditERFASST_AM
            end
            object Label19: TLabel
              Left = 8
              Top = 130
              Width = 59
              Height = 16
              Caption = 'GRSO_ID'
            end
            object Label1: TLabel
              Left = 267
              Top = 104
              Width = 87
              Height = 16
              Alignment = taRightJustify
              Caption = 'REPLIKATION'
            end
            object Label15: TLabel
              Left = 274
              Top = 144
              Width = 66
              Height = 16
              Caption = 'GRSO1_ID'
            end
            object Label2: TLabel
              Left = 274
              Top = 170
              Width = 66
              Height = 16
              Caption = 'GRSO2_ID'
            end
            object Label3: TLabel
              Left = 274
              Top = 196
              Width = 66
              Height = 16
              Caption = 'GRSO3_ID'
            end
            object Label4: TLabel
              Left = 10
              Top = 192
              Width = 101
              Height = 16
              Caption = 'Mara.WERK_NR'
            end
            object edGRSO_ID: TDBEdit
              Left = 8
              Top = 146
              Width = 70
              Height = 24
              DataField = 'GRSO_ID'
              DataSource = LDataSource1
              TabOrder = 0
            end
            object EditERFASST_VON: TDBEdit
              Left = 8
              Top = 24
              Width = 139
              Height = 24
              DataField = 'ERFASST_VON'
              DataSource = LDataSource1
              TabOrder = 1
            end
            object EditERFASST_AM: TDBEdit
              Left = 149
              Top = 24
              Width = 139
              Height = 24
              DataField = 'ERFASST_AM'
              DataSource = LDataSource1
              TabOrder = 2
            end
            object EditGEAENDERT_VON: TDBEdit
              Left = 8
              Top = 72
              Width = 139
              Height = 24
              DataField = 'GEAENDERT_VON'
              DataSource = LDataSource1
              TabOrder = 3
            end
            object EditGEAENDERT_AM: TDBEdit
              Left = 149
              Top = 72
              Width = 139
              Height = 24
              DataField = 'GEAENDERT_AM'
              DataSource = LDataSource1
              TabOrder = 4
            end
            object EditANZAHL_AENDERUNGEN: TDBEdit
              Left = 178
              Top = 102
              Width = 70
              Height = 24
              DataField = 'ANZAHL_AENDERUNGEN'
              DataSource = LDataSource1
              TabOrder = 5
            end
            object EditERFASST_DATENBANK: TDBEdit
              Left = 290
              Top = 24
              Width = 139
              Height = 24
              DataField = 'ERFASST_DATENBANK'
              DataSource = LDataSource1
              TabOrder = 6
            end
            object EditREPLIKATION: TDBEdit
              Left = 359
              Top = 102
              Width = 70
              Height = 24
              DataField = 'REPLIKATION'
              DataSource = LDataSource1
              TabOrder = 7
            end
            object EditGEAENDERT_DATENBANK: TDBEdit
              Left = 290
              Top = 72
              Width = 139
              Height = 24
              DataField = 'GEAENDERT_DATENBANK'
              DataSource = LDataSource1
              TabOrder = 8
            end
            object edGRSO1_ID: TLookUpEdit
              Left = 346
              Top = 142
              Width = 83
              Height = 24
              DataField = 'GRSO1_ID'
              DataSource = LDataSource1
              TabOrder = 9
              Options = []
              LookupSource = LuGrso1
              LookupField = 'GRSO_ID'
              KeyField = True
            end
            object edGRSO2_ID: TLookUpEdit
              Left = 346
              Top = 168
              Width = 83
              Height = 24
              DataField = 'GRSO2_ID'
              DataSource = LDataSource1
              TabOrder = 10
              Options = []
              LookupSource = LuGrso2
              LookupField = 'GRSO_ID'
              KeyField = True
            end
            object edGRSO3_ID: TLookUpEdit
              Left = 346
              Top = 194
              Width = 83
              Height = 24
              DataField = 'GRSO3_ID'
              DataSource = LDataSource1
              TabOrder = 11
              Options = []
              LookupSource = LuGrso3
              LookupField = 'GRSO_ID'
              KeyField = True
            end
            object EdMaraWERK_NR: TLookUpEdit
              Left = 122
              Top = 190
              Width = 46
              Height = 24
              DataField = 'WERK_NR'
              DataSource = LDataSource1
              TabOrder = 12
              Options = [LeNoNullValues]
              LookupSource = LuMARA
              LookupField = 'WERK_NR'
              KeyField = False
            end
          end
        end
      end
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 606
        Height = 81
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alTop
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 10
          Width = 37
          Height = 16
          Caption = 'Name'
          FocusControl = edBEZEICHNUNG
        end
        object Label17: TLabel
          Left = 8
          Top = 42
          Width = 32
          Height = 16
          Caption = 'Werk'
          FocusControl = edBEZEICHNUNG
        end
        object edBEZEICHNUNG: TLookUpEdit
          Left = 75
          Top = 8
          Width = 88
          Height = 24
          DataField = 'BEZEICHNUNG'
          DataSource = LDataSource1
          TabOrder = 0
          Options = []
          LookupSource = LuMARA
          LookupField = 'MARA_NR'
          KeyField = True
        end
        object EdWERK_NAME: TDBEdit
          Left = 140
          Top = 40
          Width = 240
          Height = 24
          DataField = 'WERK_NAME'
          DataSource = LuWerk
          TabOrder = 1
        end
        object LeWERK_NR: TLookUpEdit
          Left = 75
          Top = 40
          Width = 38
          Height = 24
          DataField = 'WERK_NR'
          DataSource = LDataSource1
          TabOrder = 2
          Options = []
          LookupSource = LuWerk
          LookupField = 'WERK_NR'
          KeyField = True
        end
        object BtnLuWerk: TLookUpBtn
          Left = 113
          Top = 40
          Width = 20
          Height = 24
          Hint = 'WERK nachschlagen'
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            0800000000000001000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
            A600000000000000000000000000000000000000000000000000F0C8A4000000
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
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
            0707070707070707070707070707070707070707070707070707070707070707
            0707070707070707070707070707000000000000000707070707070707070707
            0707070707070707070707070707070707000707070707070707070707070707
            0000000707070707070707070707070000000000070707070707070707070000
            0000000000070707070707070707070700000007070707070707070707070707
            0000000707070707070707070707070700000007070707070707070707070707
            0000000707070707070707070707070707070707070707070707070707070707
            0707070707070707070707070707070707070707070707070707}
          TabOrder = 3
          LookUpEdit = LeWERK_NR
          LookUpDef = LuWerk
          Modus = lubMulti
        end
        object BtnLuMARA: TLookUpBtn
          Left = 163
          Top = 8
          Width = 21
          Height = 23
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
          TabOrder = 4
          LookUpEdit = edBEZEICHNUNG
          LookUpDef = LuMARA
          Modus = lubMulti
        end
        object edMARA_NAME: TDBEdit
          Left = 204
          Top = 8
          Width = 240
          Height = 24
          DataField = 'MARA_NAME'
          DataSource = LuMARA
          TabOrder = 5
        end
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 362
    Width = 634
    Height = 25
    Align = alBottom
    TabOrder = 1
    TabPosition = tpBottom
    Tabs.Strings = (
      'tab1')
    TabIndex = 0
  end
  object Nav: TLNavigator
    TabSet = TabControl
    PageBook = PageControl
    DetailBook = DetailControl
    FormKurz = 'GRSO'
    FirstControl = edBEZEICHNUNG
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = []
    OnPrn = NavPrn
    OnStart = NavStart
    PollInterval = 0
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
    CalcList.Strings = (
      'cfMARA_NAME=Lookup:LuMARA;MARA_NAME')
    FormatList.Strings = (
      'KOMBI_KNZ=Asw,JNX'
      'OFFENE_BEL=Asw,JNX'
      'TROCKEN_FEUCHT=Asw,TrockenFeucht')
    KeyList.Strings = (
      'Standard=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    TableName = 'GRUNDSORTEN'
    TabTitel = 'Grundsorten'
    OnRech = NavRech
    OnErfass = NavErfass
    BeforePost = NavBeforePost
    Left = 200
    Top = 360
  end
  object LuWerk: TLookUpDef
    DataSet = TblWerk
    LuKurz = 'WERK'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Nummer=WERK_NR'
      'Name=WERK_NAME')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    KeyFields = 'WERK_NR'
    PrimaryKeyFields = 'WERK_ID'
    References.Strings = (
      'WERK_NR=:WERK_NR')
    SOList.Strings = (
      'WERK_NR=:WERK_NR')
    TableName = 'WERKE'
    TabTitel = ';Werk'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 291
    Top = 360
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    Left = 228
    Top = 360
  end
  object PsDflt: TPrnSource
    QRepKurz = 'DFLTX'
    Preview = False
    NoPreview = False
    Visible = True
    Display = 'Standard Liste'
    DruckerTyp = 'Listendrucker'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage]
    OpenAfterGenerate = False
    ExportFile = False
    BeforePrn = PsDfltBeforePrn
    Left = 355
    Top = 360
  end
  object LuGrso2: TLookUpDef
    DataSet = TblGrso2
    LuKurz = 'GRSO2'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Name:10=BEZEICHNUNG'
      'Materialname:17=cfMARA_NAME'
      'Sps:8=SPS_SORTE'
      'TF:3=TROCKEN_FEUCHT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    CalcList.Strings = (
      'cfMARA_NAME=string:200')
    FltrList.Strings = (
      'WERK_NR=:WERK_NR'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG'
      'KOMBI_KNZ=<>J;=')
    KeyList.Strings = (
      'Name=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    References.Strings = (
      'GRSO_ID=:GRSO2_ID'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG')
    SOList.Strings = (
      'GRSO_ID=:GRSO2_ID'
      'BEZEICHNUNG=:GRSO2_BEZEICHNUNG')
    SqlFieldList.Strings = (
      'GRSO_ID'
      'G.WERK_NR'
      'G.WERK_NAME'
      'G.BEZEICHNUNG'
      'G.REPLIKATION'
      'G.ERFASST_VON'
      'G.ERFASST_AM'
      'G.ERFASST_DATENBANK'
      'G.GEAENDERT_VON'
      'G.GEAENDERT_AM'
      'G.GEAENDERT_DATENBANK'
      'G.ANZAHL_AENDERUNGEN'
      'G.BEMERKUNG'
      'G.GRSO1_ID'
      'G.GRSO1_BEZEICHNUNG'
      'G.GRSO1_ANTEIL'
      'G.GRSO2_ID'
      'G.GRSO2_BEZEICHNUNG'
      'G.GRSO2_ANTEIL'
      'G.GRSO3_ID'
      'G.GRSO3_BEZEICHNUNG'
      'G.GRSO3_ANTEIL'
      'G.KOMBI_KNZ'
      'G.OFFENE_BEL'
      'G.SPS_SORTE'
      'G.TROCKEN_FEUCHT'
      'M.MARA_ID'
      'M.MARA_NR'
      'M.MARA_NAME'
      'M.GEWICHT_EINHEIT'
      'M.MATERIAL_ART'
      'M.CHARGENPFLICHTIG'
      'M.LAGERORT'
      'M.BESTAND'
      'M.PRD_HIERARCH_TEXT'
      'M.PRD_HIERARCH_KEY'
      'M.MARA_PROD_ID'
      'M.MARA_PROD_NR'
      'M.MARA_NR_ALT'
      'M.VERPACK'
      'M.VERPMENGE'
      'M.VERPEINHEIT'
      'M.VERLADESORTE'
      'M.HANDELSBEZEICHNUNG'
      'M.KLASSE')
    TableName = 'G=GRUNDSORTEN;M=MATERIALSTAMM'
    TabTitel = ';Grundsorte2'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuGrsoGet
    Left = 100
    Top = 360
  end
  object LuGrso3: TLookUpDef
    DataSet = TblGrso3
    LuKurz = 'GRSO3'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Name:10=BEZEICHNUNG'
      'Materialname:17=cfMARA_NAME'
      'Sps:8=SPS_SORTE'
      'TF:3=TROCKEN_FEUCHT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    CalcList.Strings = (
      'cfMARA_NAME=string:200')
    FltrList.Strings = (
      'WERK_NR=:WERK_NR'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG'
      'KOMBI_KNZ=<>J;=')
    KeyList.Strings = (
      'Name=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    References.Strings = (
      'GRSO_ID=:GRSO3_ID'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG')
    SOList.Strings = (
      'GRSO_ID=:GRSO3_ID'
      'BEZEICHNUNG=:GRSO3_BEZEICHNUNG')
    SqlFieldList.Strings = (
      'GRSO_ID'
      'G.WERK_NR'
      'G.WERK_NAME'
      'G.BEZEICHNUNG'
      'G.REPLIKATION'
      'G.ERFASST_VON'
      'G.ERFASST_AM'
      'G.ERFASST_DATENBANK'
      'G.GEAENDERT_VON'
      'G.GEAENDERT_AM'
      'G.GEAENDERT_DATENBANK'
      'G.ANZAHL_AENDERUNGEN'
      'G.BEMERKUNG'
      'G.GRSO1_ID'
      'G.GRSO1_BEZEICHNUNG'
      'G.GRSO1_ANTEIL'
      'G.GRSO2_ID'
      'G.GRSO2_BEZEICHNUNG'
      'G.GRSO2_ANTEIL'
      'G.GRSO3_ID'
      'G.GRSO3_BEZEICHNUNG'
      'G.GRSO3_ANTEIL'
      'G.KOMBI_KNZ'
      'G.OFFENE_BEL'
      'G.SPS_SORTE'
      'G.TROCKEN_FEUCHT'
      'M.MARA_ID'
      'M.MARA_NR'
      'M.MARA_NAME'
      'M.GEWICHT_EINHEIT'
      'M.MATERIAL_ART'
      'M.CHARGENPFLICHTIG'
      'M.LAGERORT'
      'M.BESTAND'
      'M.PRD_HIERARCH_TEXT'
      'M.PRD_HIERARCH_KEY'
      'M.MARA_PROD_ID'
      'M.MARA_PROD_NR'
      'M.MARA_NR_ALT'
      'M.VERPACK'
      'M.VERPMENGE'
      'M.VERPEINHEIT'
      'M.VERLADESORTE'
      'M.HANDELSBEZEICHNUNG'
      'M.KLASSE')
    TableName = 'G=GRUNDSORTEN;M=MATERIALSTAMM'
    TabTitel = ';Grundsorte3'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuGrsoGet
    Left = 164
    Top = 360
  end
  object LuGrso1: TLookUpDef
    DataSet = TblGrso1
    LuKurz = 'GRSO1'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Name:10=BEZEICHNUNG'
      'Materialname:17=cfMARA_NAME'
      'Sps:8=SPS_SORTE'
      'TF:3=TROCKEN_FEUCHT')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    CalcList.Strings = (
      'cfMARA_NAME=string:200')
    FltrList.Strings = (
      'WERK_NR=:WERK_NR'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG'
      'KOMBI_KNZ=<>J;=')
    KeyList.Strings = (
      'Name=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    References.Strings = (
      'GRSO_ID=:GRSO1_ID'
      'M.WERK_NR=G.WERK_NR'
      'M.MARA_NR=G.BEZEICHNUNG')
    SOList.Strings = (
      'GRSO_ID=:GRSO1_ID'
      'BEZEICHNUNG=:GRSO1_BEZEICHNUNG')
    SqlFieldList.Strings = (
      'GRSO_ID'
      'G.WERK_NR'
      'G.WERK_NAME'
      'G.BEZEICHNUNG'
      'G.REPLIKATION'
      'G.ERFASST_VON'
      'G.ERFASST_AM'
      'G.ERFASST_DATENBANK'
      'G.GEAENDERT_VON'
      'G.GEAENDERT_AM'
      'G.GEAENDERT_DATENBANK'
      'G.ANZAHL_AENDERUNGEN'
      'G.BEMERKUNG'
      'G.GRSO1_ID'
      'G.GRSO1_BEZEICHNUNG'
      'G.GRSO1_ANTEIL'
      'G.GRSO2_ID'
      'G.GRSO2_BEZEICHNUNG'
      'G.GRSO2_ANTEIL'
      'G.GRSO3_ID'
      'G.GRSO3_BEZEICHNUNG'
      'G.GRSO3_ANTEIL'
      'G.KOMBI_KNZ'
      'G.OFFENE_BEL'
      'G.SPS_SORTE'
      'G.TROCKEN_FEUCHT'
      'M.MARA_ID'
      'M.MARA_NR'
      'M.MARA_NAME'
      'M.GEWICHT_EINHEIT'
      'M.MATERIAL_ART'
      'M.CHARGENPFLICHTIG'
      'M.LAGERORT'
      'M.BESTAND'
      'M.PRD_HIERARCH_TEXT'
      'M.PRD_HIERARCH_KEY'
      'M.MARA_PROD_ID'
      'M.MARA_PROD_NR'
      'M.MARA_NR_ALT'
      'M.VERPACK'
      'M.VERPMENGE'
      'M.VERPEINHEIT'
      'M.VERLADESORTE'
      'M.HANDELSBEZEICHNUNG'
      'M.KLASSE')
    TableName = 'G=GRUNDSORTEN;M=MATERIALSTAMM'
    TabTitel = ';Grundsorte1'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuGrsoGet
    Left = 36
    Top = 360
  end
  object LuMARA: TLookUpDef
    DataSet = TblMARA
    LuKurz = 'MARA'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Werk:4=WERK_NR'
      'Nummer:8=MARA_NR'
      'Materialname=MARA_NAME')
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
    KeyList.Strings = (
      'Lookup=WERK_NR;MARA_NR')
    PrimaryKeyFields = 'MARA_ID'
    References.Strings = (
      'WERK_NR=:WERK_NR'
      'MARA_NR=:BEZEICHNUNG')
    SOList.Strings = (
      'MARA_NR=:BEZEICHNUNG'
      'WERK_NR=:WERK_NR')
    TableName = 'MATERIALSTAMM'
    TabTitel = 'Material'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 411
    Top = 360
  end
  object LuSILO: TLookUpDef
    DataSet = TblSILO
    LuKurz = 'SILO'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FltrList.Strings = (
      'SO_WERK_NR=:WERK_NR')
    FormatList.Strings = (
      'KOMBI_KNZ=Asw,JaNein'
      'SILO1_ANTEIL=##0%'
      'SILO2_ANTEIL=##0%'
      'SILO3_ANTEIL=##0%'
      'AKT_SPERRE_BAHN=Asw,JNX'
      'AKT_SPERRE_LKW=Asw,JNX'
      'VERPACKART=Asw,Verpack')
    KeyList.Strings = (
      'Standard=SILO_NR')
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_GRSO_ID=:GRSO_ID')
    TableName = 'SILOLISTE'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 520
    Top = 362
  end
  object LuV_LABI_GRSO_MK: TLookUpDef
    DataSet = TblV_LABI_GRSO_MK
    OnStateChange = LuV_LABI_GRSO_MKStateChange
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FormatList.Strings = (
      'MK=#0.000')
    KeyList.Strings = (
      'Standard=MK')
    PrimaryKeyFields = 'GRSO_MARA_NR'
    References.Strings = (
      'GRSO_MARA_NR=:BEZEICHNUNG'
      'WERK_NR=:WERK_NR')
    TableName = 'V_LABI_GRSO_MK'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 544
    Top = 274
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from GRUNDSORTEN')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforePost = Query1BeforePost
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 256
    Top = 360
  end
  object TblWerk: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from WERKE'
      'where (WERK_NR = :WERK_NR)'
      'order by WERK_NR')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 319
    Top = 360
    ParamData = <
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
  object TblGrso1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select GRSO_ID,'
      '       G.WERK_NR,'
      '       G.WERK_NAME,'
      '       G.BEZEICHNUNG,'
      '       G.REPLIKATION,'
      '       G.ERFASST_VON,'
      '       G.ERFASST_AM,'
      '       G.ERFASST_DATENBANK,'
      '       G.GEAENDERT_VON,'
      '       G.GEAENDERT_AM,'
      '       G.GEAENDERT_DATENBANK,'
      '       G.ANZAHL_AENDERUNGEN,'
      '       G.BEMERKUNG,'
      '       G.GRSO1_ID,'
      '       G.GRSO1_BEZEICHNUNG,'
      '       G.GRSO1_ANTEIL,'
      '       G.GRSO2_ID,'
      '       G.GRSO2_BEZEICHNUNG,'
      '       G.GRSO2_ANTEIL,'
      '       G.GRSO3_ID,'
      '       G.GRSO3_BEZEICHNUNG,'
      '       G.GRSO3_ANTEIL,'
      '       G.KOMBI_KNZ,'
      '       G.OFFENE_BEL,'
      '       G.SPS_SORTE,'
      '       G.TROCKEN_FEUCHT,'
      '       M.MARA_ID,'
      '       M.MARA_NR,'
      '       M.MARA_NAME,'
      '       M.GEWICHT_EINHEIT,'
      '       M.MATERIAL_ART,'
      '       M.CHARGENPFLICHTIG,'
      '       M.LAGERORT,'
      '       M.BESTAND,'
      '       M.PRD_HIERARCH_TEXT,'
      '       M.PRD_HIERARCH_KEY,'
      '       M.MARA_PROD_ID,'
      '       M.MARA_PROD_NR,'
      '       M.MARA_NR_ALT,'
      '       M.VERPACK,'
      '       M.VERPMENGE,'
      '       M.VERPEINHEIT,'
      '       M.VERLADESORTE,'
      '       M.HANDELSBEZEICHNUNG,'
      '       M.KLASSE'
      'from GRUNDSORTEN G,'
      '     MATERIALSTAMM M'
      'where (GRSO_ID = :GRSO1_ID)'
      '  and (M.WERK_NR=G.WERK_NR)'
      '  and (M.MARA_NR=G.BEZEICHNUNG)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeFetch = TblGrso1BeforeFetch
    BeforeOpen = TblGrso1BeforeOpen
    BeforeClose = TblGrso1BeforeClose
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 8
    Top = 360
    ParamData = <
      item
        DataType = ftFloat
        Name = 'GRSO1_ID'
      end>
  end
  object TblGrso2: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select GRSO_ID,'
      '       G.WERK_NR,'
      '       G.WERK_NAME,'
      '       G.BEZEICHNUNG,'
      '       G.REPLIKATION,'
      '       G.ERFASST_VON,'
      '       G.ERFASST_AM,'
      '       G.ERFASST_DATENBANK,'
      '       G.GEAENDERT_VON,'
      '       G.GEAENDERT_AM,'
      '       G.GEAENDERT_DATENBANK,'
      '       G.ANZAHL_AENDERUNGEN,'
      '       G.BEMERKUNG,'
      '       G.GRSO1_ID,'
      '       G.GRSO1_BEZEICHNUNG,'
      '       G.GRSO1_ANTEIL,'
      '       G.GRSO2_ID,'
      '       G.GRSO2_BEZEICHNUNG,'
      '       G.GRSO2_ANTEIL,'
      '       G.GRSO3_ID,'
      '       G.GRSO3_BEZEICHNUNG,'
      '       G.GRSO3_ANTEIL,'
      '       G.KOMBI_KNZ,'
      '       G.OFFENE_BEL,'
      '       G.SPS_SORTE,'
      '       G.TROCKEN_FEUCHT,'
      '       M.MARA_ID,'
      '       M.MARA_NR,'
      '       M.MARA_NAME,'
      '       M.GEWICHT_EINHEIT,'
      '       M.MATERIAL_ART,'
      '       M.CHARGENPFLICHTIG,'
      '       M.LAGERORT,'
      '       M.BESTAND,'
      '       M.PRD_HIERARCH_TEXT,'
      '       M.PRD_HIERARCH_KEY,'
      '       M.MARA_PROD_ID,'
      '       M.MARA_PROD_NR,'
      '       M.MARA_NR_ALT,'
      '       M.VERPACK,'
      '       M.VERPMENGE,'
      '       M.VERPEINHEIT,'
      '       M.VERLADESORTE,'
      '       M.HANDELSBEZEICHNUNG,'
      '       M.KLASSE'
      'from GRUNDSORTEN G,'
      '     MATERIALSTAMM M'
      'where (GRSO_ID = :GRSO2_ID)'
      '  and (M.WERK_NR=G.WERK_NR)'
      '  and (M.MARA_NR=G.BEZEICHNUNG)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 72
    Top = 360
    ParamData = <
      item
        DataType = ftFloat
        Name = 'GRSO2_ID'
      end>
  end
  object TblGrso3: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select GRSO_ID,'
      '       G.WERK_NR,'
      '       G.WERK_NAME,'
      '       G.BEZEICHNUNG,'
      '       G.REPLIKATION,'
      '       G.ERFASST_VON,'
      '       G.ERFASST_AM,'
      '       G.ERFASST_DATENBANK,'
      '       G.GEAENDERT_VON,'
      '       G.GEAENDERT_AM,'
      '       G.GEAENDERT_DATENBANK,'
      '       G.ANZAHL_AENDERUNGEN,'
      '       G.BEMERKUNG,'
      '       G.GRSO1_ID,'
      '       G.GRSO1_BEZEICHNUNG,'
      '       G.GRSO1_ANTEIL,'
      '       G.GRSO2_ID,'
      '       G.GRSO2_BEZEICHNUNG,'
      '       G.GRSO2_ANTEIL,'
      '       G.GRSO3_ID,'
      '       G.GRSO3_BEZEICHNUNG,'
      '       G.GRSO3_ANTEIL,'
      '       G.KOMBI_KNZ,'
      '       G.OFFENE_BEL,'
      '       G.SPS_SORTE,'
      '       G.TROCKEN_FEUCHT,'
      '       M.MARA_ID,'
      '       M.MARA_NR,'
      '       M.MARA_NAME,'
      '       M.GEWICHT_EINHEIT,'
      '       M.MATERIAL_ART,'
      '       M.CHARGENPFLICHTIG,'
      '       M.LAGERORT,'
      '       M.BESTAND,'
      '       M.PRD_HIERARCH_TEXT,'
      '       M.PRD_HIERARCH_KEY,'
      '       M.MARA_PROD_ID,'
      '       M.MARA_PROD_NR,'
      '       M.MARA_NR_ALT,'
      '       M.VERPACK,'
      '       M.VERPMENGE,'
      '       M.VERPEINHEIT,'
      '       M.VERLADESORTE,'
      '       M.HANDELSBEZEICHNUNG,'
      '       M.KLASSE'
      'from GRUNDSORTEN G,'
      '     MATERIALSTAMM M'
      'where (GRSO_ID = :GRSO3_ID)'
      '  and (M.WERK_NR=G.WERK_NR)'
      '  and (M.MARA_NR=G.BEZEICHNUNG)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 136
    Top = 360
    ParamData = <
      item
        DataType = ftFloat
        Name = 'GRSO3_ID'
      end>
  end
  object TblMARA: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from MATERIALSTAMM'
      'where (WERK_NR = :WERK_NR)'
      '  and (MARA_NR = :BEZEICHNUNG)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 439
    Top = 360
    ParamData = <
      item
        DataType = ftString
        Name = 'WERK_NR'
      end
      item
        DataType = ftString
        Name = 'BEZEICHNUNG'
      end>
  end
  object QueMARA: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select MARA_NAME'
      'from MATERIALSTAMM'
      'where (WERK_NR=:WERK_NR)'
      '  and (MARA_NR=:MARA_NR)')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 478
    Top = 360
    ParamData = <
      item
        DataType = ftString
        Name = 'WERK_NR'
      end
      item
        DataType = ftString
        Name = 'MARA_NR'
      end>
  end
  object TblSILO: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_GRSO_ID = :GRSO_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 548
    Top = 362
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'GRSO_ID'
      end>
  end
  object TblV_LABI_GRSO_MK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from V_LABI_GRSO_MK'
      'where (GRSO_MARA_NR = :BEZEICHNUNG)'
      '  and (WERK_NR = :WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 576
    Top = 274
    ParamData = <
      item
        DataType = ftString
        Name = 'BEZEICHNUNG'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end>
  end
end
