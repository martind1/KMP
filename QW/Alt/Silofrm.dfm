object FrmSilo: TFrmSilo
  Left = 375
  Top = 400
  Caption = 'Bunkerliste'
  ClientHeight = 520
  ClientWidth = 931
  Color = clBtnFace
  Constraints.MinHeight = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
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
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 931
    Height = 495
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    ExplicitWidth = 760
    ExplicitHeight = 429
    object Multi: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 454
        Width = 903
        Height = 33
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object Label30: TLabel
          Left = 136
          Top = 6
          Width = 48
          Height = 16
          Caption = 'Abfrage'
        end
        object chbWerk: TCheckBox
          Left = 8
          Top = 8
          Width = 92
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
        object cobFltr: TComboBox
          Left = 192
          Top = 4
          Width = 345
          Height = 24
          Color = clWhite
          TabOrder = 1
          OnChange = cobFltrChange
        end
      end
      object Mu1: TMultiGrid
        Left = 0
        Top = 0
        Width = 903
        Height = 454
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
          'Werk:4=SO_WERK_NR'
          'Bunker:6=SILO_NR'
          'Kombi:5=KOMBI_KNZ'
          'Name:31=SILO_NAME'
          'Bels.:4=BEIN_NR'
          'Prio:3=PRIO'
          'Sp.LKW:6=AKT_SPERRE_LKW'
          'Sp.Bahn:7=AKT_SPERRE_BAHN'
          'Sp.BB:5=AKT_SPERRE_BIGBAG'
          'Sp.Lab:6=SPERRE_LABOR'
          'Sp.Sens:7=SPERRE_SENSIBLER_KUNDE'
          'SPS Sorte:8=AKT_SORTE'
          'Grunds.:9=GRUNDSORTE'
          '2.Grunds:10=GRUNDSORTE2'
          'TF:2,S=TROCKEN_FEUCHT'
          'Grundsorte:15=cfMARA_NAME'
          '2.Grundsorte:15=cfMARA_NAME2'
          'Verp.:6=VERPACKART')
        ReturnSingle = True
        NoColumnSave = False
        MuOptions = [muNoAskLayout]
        DefaultRowHeight = 20
        Drag0Value = '0'
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Formular'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DetailControl: TPageControl
        Left = 0
        Top = 89
        Width = 903
        Height = 398
        ActivePage = TabSheet5
        Align = alClient
        TabOrder = 1
        OnChange = DetailControlChange
        ExplicitWidth = 732
        ExplicitHeight = 332
        object TabSheet1: TTabSheet
          Caption = '&etc.'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ScrollBox5: TScrollBox
            Left = 0
            Top = 0
            Width = 895
            Height = 367
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            ExplicitWidth = 724
            ExplicitHeight = 301
            object Panel2: TPanel
              Left = 0
              Top = 0
              Width = 895
              Height = 200
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 724
              object Label6: TLabel
                Left = 8
                Top = 58
                Width = 64
                Height = 16
                Caption = '&SPS-Code'
                FocusControl = EdSPS_CODE
              end
              object Label5: TLabel
                Left = 240
                Top = 7
                Width = 32
                Height = 16
                Caption = '&Werk'
                FocusControl = leSO_WERK_NR
              end
              object Label11: TLabel
                Left = 8
                Top = 6
                Width = 70
                Height = 16
                Caption = 'Verpack.Art'
                FocusControl = cobVERPACKART
              end
              object Label10: TLabel
                Left = 8
                Top = 32
                Width = 76
                Height = 16
                Caption = 'Beladestelle'
                FocusControl = edBEIN_NR
              end
              object Label4: TLabel
                Left = 8
                Top = 84
                Width = 79
                Height = 16
                Caption = 'AK&Z Nummer'
                FocusControl = AKZ_NR
              end
              object EdSPS_CODE: TDBEdit
                Left = 94
                Top = 56
                Width = 71
                Height = 24
                Hint = 'Bunkerzielung, leerlassen bei Mischsilo'
                DataField = 'SPS_CODE'
                DataSource = LDataSource1
                TabOrder = 8
              end
              object chbKOMBI_KNZ: TAswCheckBox
                Left = 6
                Top = 135
                Width = 126
                Height = 17
                Hint = 'Mischsilo'
                Alignment = taLeftJustify
                Caption = 'Silo-K&ombination'
                DataField = 'KOMBI_KNZ'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 11
                ValueChecked = 'Ja'
                ValueUnchecked = 'Nein'
                AswName = 'JaNein'
              end
              object GroupBox1: TGroupBox
                Left = 191
                Top = 57
                Width = 362
                Height = 113
                Caption = '&Kombinationen (SPS)'
                TabOrder = 13
                object Label7: TLabel
                  Left = 8
                  Top = 16
                  Width = 24
                  Height = 16
                  Caption = 'Pos'
                end
                object Label8: TLabel
                  Left = 38
                  Top = 16
                  Width = 42
                  Height = 16
                  Caption = 'Bunker'
                end
                object LaAnteil: TLabel
                  Left = 300
                  Top = 16
                  Width = 33
                  Height = 16
                  Alignment = taRightJustify
                  Caption = 'Anteil'
                end
                object LeSILO1_NR: TLookUpEdit
                  Left = 33
                  Top = 32
                  Width = 38
                  Height = 24
                  DataField = 'SILO1_NR'
                  DataSource = LDataSource1
                  TabOrder = 1
                  Options = []
                  LookupSource = LuSilo1
                  LookupField = 'SILO_NR'
                  References.Strings = (
                    'SO_WERK_NR=:SO_WERK_NR')
                  KeyField = True
                end
                object EdPos1: TEdit
                  Left = 8
                  Top = 32
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
                  Top = 58
                  Width = 25
                  Height = 24
                  TabStop = False
                  Color = clSilver
                  ReadOnly = True
                  TabOrder = 6
                  Text = '  2'
                end
                object LeSILO2_NR: TLookUpEdit
                  Left = 33
                  Top = 58
                  Width = 38
                  Height = 24
                  DataField = 'SILO2_NR'
                  DataSource = LDataSource1
                  TabOrder = 7
                  Options = []
                  LookupSource = LuSilo2
                  LookupField = 'SILO_NR'
                  References.Strings = (
                    'SO_WERK_NR=:SO_WERK_NR')
                  KeyField = True
                end
                object EdSilo1_NAME: TDBEdit
                  Left = 71
                  Top = 32
                  Width = 192
                  Height = 24
                  DataField = 'SILO_NAME'
                  DataSource = LuSilo1
                  TabOrder = 2
                end
                object BtnLuSilo1: TLookUpBtn
                  Left = 263
                  Top = 32
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
                  LookUpDef = LuSilo1
                  Modus = lubMulti
                end
                object EdSILO2_NAME: TDBEdit
                  Left = 71
                  Top = 58
                  Width = 192
                  Height = 24
                  DataField = 'SILO_NAME'
                  DataSource = LuSilo2
                  TabOrder = 8
                end
                object BtnLuSilo2: TLookUpBtn
                  Left = 263
                  Top = 58
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
                  TabOrder = 9
                  LookUpDef = LuSilo2
                  Modus = lubMulti
                end
                object cobSILO1_ANTEIL: TDBComboBox
                  Tag = 1
                  Left = 286
                  Top = 32
                  Width = 73
                  Height = 24
                  AutoComplete = False
                  DataField = 'SILO1_ANTEIL'
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
                  TabOrder = 5
                  OnChange = cobSILOx_ANTEILChange
                  OnDropDown = cobSILOx_ANTEILDropDown
                end
                object cobSILO2_ANTEIL: TDBComboBox
                  Tag = 2
                  Left = 286
                  Top = 58
                  Width = 73
                  Height = 24
                  AutoComplete = False
                  DataField = 'SILO2_ANTEIL'
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
                  TabOrder = 11
                  OnChange = cobSILOx_ANTEILChange
                  OnDropDown = cobSILOx_ANTEILDropDown
                end
                object PanSilo3: TPanel
                  Left = 2
                  Top = 84
                  Width = 358
                  Height = 27
                  Align = alBottom
                  BevelOuter = bvNone
                  TabOrder = 12
                  ExplicitWidth = 350
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
                  object LeSILO3_NR: TLookUpEdit
                    Left = 31
                    Top = 0
                    Width = 38
                    Height = 24
                    DataField = 'SILO3_NR'
                    DataSource = LDataSource1
                    TabOrder = 1
                    Options = []
                    LookupSource = LuSilo3
                    LookupField = 'SILO_NR'
                    References.Strings = (
                      'SO_WERK_NR=:SO_WERK_NR')
                    KeyField = True
                  end
                  object EdSILO3_NAME: TDBEdit
                    Left = 69
                    Top = 0
                    Width = 192
                    Height = 24
                    DataField = 'SILO_NAME'
                    DataSource = LuSilo3
                    TabOrder = 2
                  end
                  object BtnLuSilo3: TLookUpBtn
                    Left = 261
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
                    TabOrder = 3
                    LookUpDef = LuSilo3
                    Modus = lubMulti
                  end
                  object cobSILO3_ANTEIL: TDBComboBox
                    Tag = 3
                    Left = 284
                    Top = 0
                    Width = 73
                    Height = 24
                    AutoComplete = False
                    DataField = 'SILO3_ANTEIL'
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
                    TabOrder = 5
                    OnChange = cobSILOx_ANTEILChange
                    OnDropDown = cobSILOx_ANTEILDropDown
                  end
                  object edSILO3_ANTEIL: TDBEdit
                    Left = 284
                    Top = 0
                    Width = 56
                    Height = 24
                    DataField = 'SILO3_ANTEIL'
                    DataSource = LDataSource1
                    TabOrder = 4
                  end
                end
                object edSILO1_ANTEIL: TDBEdit
                  Left = 286
                  Top = 32
                  Width = 56
                  Height = 24
                  DataField = 'SILO1_ANTEIL'
                  DataSource = LDataSource1
                  TabOrder = 4
                end
                object edSILO2_ANTEIL: TDBEdit
                  Left = 286
                  Top = 58
                  Width = 56
                  Height = 24
                  DataField = 'SILO2_ANTEIL'
                  DataSource = LDataSource1
                  TabOrder = 10
                end
              end
              object BtnLuWerk: TLookUpBtn
                Left = 319
                Top = 4
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
                TabOrder = 2
                LookUpDef = LuWerk
                Modus = lubMulti
              end
              object leSO_WERK_NR: TLookUpEdit
                Left = 278
                Top = 4
                Width = 41
                Height = 24
                DataField = 'SO_WERK_NR'
                DataSource = LDataSource1
                TabOrder = 1
                Options = []
                LookupSource = LuWerk
                LookupField = 'WERK_NR'
                KeyField = True
              end
              object edWERK_NAME: TDBEdit
                Left = 344
                Top = 4
                Width = 156
                Height = 24
                DataField = 'WERK_NAME'
                DataSource = LuWerk
                TabOrder = 3
              end
              object panTROCKEN_FEUCHT: TPanel
                Left = 8
                Top = 110
                Width = 177
                Height = 24
                BevelOuter = bvNone
                TabOrder = 10
                object rgTROCKEN_FEUCHT: TAswRadioGroup
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
              object cobVERPACKART: TAswComboBox
                Left = 94
                Top = 4
                Width = 113
                Height = 24
                AutoComplete = False
                DataField = 'VERPACKART'
                DataSource = LDataSource1
                Items.Strings = (
                  'Lose'
                  'Verpackt')
                TabOrder = 0
                AswName = 'Verpack'
                LookupSource = LuBEIN
                LookupField = 'VERPACKART'
              end
              object edBEIN_NR: TLookUpEdit
                Left = 94
                Top = 30
                Width = 51
                Height = 24
                DataField = 'BEIN_NR'
                DataSource = LDataSource1
                TabOrder = 4
                Options = []
                LookupSource = LuBEIN
                LookupField = 'BEIN_NR'
                KeyField = True
              end
              object btnBEIN_NR: TLookUpBtn
                Left = 145
                Top = 30
                Width = 21
                Height = 21
                Hint = 'Grunsorte nachschlagen'
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
                TabOrder = 5
                LookUpEdit = edBEIN_NR
                LookUpDef = LuBEIN
                Modus = lubMulti
              end
              object edBEIN_NAME: TDBEdit
                Left = 191
                Top = 30
                Width = 263
                Height = 24
                DataField = 'BEIN_NAME'
                DataSource = LuBEIN
                TabOrder = 6
              end
              object chbMANUELL: TAswCheckBox
                Left = 475
                Top = 34
                Width = 70
                Height = 17
                Alignment = taLeftJustify
                BiDiMode = bdLeftToRight
                Caption = 'Manuell'
                DataField = 'MANUELL'
                DataSource = LuBEIN
                ParentBiDiMode = False
                TabOrder = 7
                ValueChecked = 'X'
                ValueUnchecked = '-'
                AswName = 'JNX'
              end
              object chbStruktur: TCheckBox
                Left = 6
                Top = 155
                Width = 126
                Height = 17
                Hint = 
                  'X = virtuelle Silokombination f'#252'r Mischsorten der gleichen Struk' +
                  'tur'
                Alignment = taLeftJustify
                Caption = 'Silo-Struktur'
                TabOrder = 12
                OnClick = chbStrukturClick
              end
              object AKZ_NR: TDBEdit
                Left = 94
                Top = 82
                Width = 71
                Height = 24
                Hint = 'Parameter f'#252'r Haltern Siebanlage'
                DataField = 'AKZ_NR'
                DataSource = LDataSource1
                TabOrder = 9
              end
              object chbSiebanteil: TCheckBox
                Left = 6
                Top = 175
                Width = 126
                Height = 17
                Hint = 'X = Siebanteil Siebanlage'
                Alignment = taLeftJustify
                Caption = 'Siebanteil'
                TabOrder = 14
                OnClick = chbSiebanteilClick
              end
            end
            object GroupBox4: TGroupBox
              Left = 0
              Top = 200
              Width = 895
              Height = 167
              Align = alClient
              Caption = 'Bermerkung'
              TabOrder = 1
              ExplicitWidth = 724
              ExplicitHeight = 101
              object EdBEMERKUNG: TDBMemo
                Left = 2
                Top = 18
                Width = 720
                Height = 81
                Align = alClient
                DataField = 'BEMERKUNG'
                DataSource = LDataSource1
                ScrollBars = ssVertical
                TabOrder = 0
              end
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'Labor'
          ImageIndex = 4
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 895
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object Label47: TLabel
              Left = 408
              Top = 12
              Width = 193
              Height = 13
              Caption = '(die Sperren gelten nicht f'#252'r Kontingente)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object LaCheckWidth: TLabel
              Left = 712
              Top = 0
              Width = 66
              Height = 16
              Caption = 'Siloproben'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              Visible = False
            end
            object chbSPERRE_LABOR: TAswCheckBox
              Left = 6
              Top = 10
              Width = 173
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Sperre Labor/Produktion'
              DataField = 'SPERRE_LABOR'
              DataSource = LDataSource1
              TabOrder = 0
              ValueChecked = 'Ja'
              ValueUnchecked = 'Nein'
              AswName = 'JaNein'
            end
            object chbSPERRE_SENSIBLER_KUNDE: TAswCheckBox
              Left = 208
              Top = 10
              Width = 169
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Sperre Sensible Kunden'
              DataField = 'SPERRE_SENSIBLER_KUNDE'
              DataSource = LDataSource1
              TabOrder = 1
              ValueChecked = 'X'
              ValueUnchecked = '-'
              AswName = 'JNX'
            end
          end
          object pcLabor: TPageControl
            Left = 0
            Top = 41
            Width = 895
            Height = 326
            ActivePage = tsLaborSMH
            Align = alClient
            TabOrder = 1
            OnChange = pcLaborChange
            ExplicitTop = 57
            ExplicitWidth = 724
            ExplicitHeight = 244
            object tsLaborSMW: TTabSheet
              Caption = 'SMW Mischsilos und MK Werte'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 152
              object MuV_LABI_MK: TMultiGrid
                Left = 0
                Top = 0
                Width = 887
                Height = 295
                Align = alClient
                DataSource = LuV_LABI_MK
                Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clBlack
                TitleFont.Height = -13
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
                ColumnList.Strings = (
                  'SILO_NR2=SILO_NR2'
                  'MARA_NR1=MARA_NR1'
                  'MARA_NR2=MARA_NR2'
                  'ANTEIL1=ANTEIL1'
                  'ANTEIL2=ANTEIL2'
                  'MK:6=MK')
                ReturnSingle = False
                NoColumnSave = False
                MuOptions = [muNoAskLayout, muPostOnExit]
                DefaultRowHeight = 20
                Drag0Value = '0'
              end
            end
            object tsLaborSMH: TTabSheet
              Caption = 'SMH Sieblinie'
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object MuLAER: TMultiGrid
                Left = 0
                Top = 0
                Width = 887
                Height = 81
                Align = alTop
                DataSource = LuLAER
                Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = clBlack
                TitleFont.Height = -13
                TitleFont.Name = 'MS Sans Serif'
                TitleFont.Style = []
                ColumnList.Strings = (
                  'Probe Nr.:53=PROBE_NR'
                  '0,71:6=P1'
                  '0,5:6=P2'
                  '0,355:6=P3'
                  '0,25:6=P4'
                  '0,18:6=P5'
                  '<0,18:6=P6'
                  'Probedatum zuletzt:17=PROBE_DTM1')
                ReturnSingle = False
                NoColumnSave = False
                MuOptions = [muNoAskLayout, muPostOnExit]
                DefaultRowHeight = 20
                Drag0Value = '0'
              end
              object Panel9: TPanel
                Left = 0
                Top = 81
                Width = 887
                Height = 41
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 1
                ExplicitWidth = 716
                object BtnLabiUpdate: TBitBtn
                  Left = 8
                  Top = 8
                  Width = 193
                  Height = 25
                  Caption = 'LIMS Werte '#252'bernehmen'
                  Glyph.Data = {
                    DE000000424DDE0000000000000076000000280000000D0000000D0000000100
                    0400000000006800000000000000000000001000000010000000000000000000
                    BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
                    FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
                    7000777777777777700077770000077770007777066607777000777706660777
                    7000777706660777700070000666000070007706666666077000777066666077
                    7000777706660777700077777060777770007777770777777000777777777777
                    7000}
                  TabOrder = 0
                  OnClick = BtnLabiUpdateClick
                end
                object cobLimsProbe: TComboBox
                  Left = 224
                  Top = 8
                  Width = 145
                  Height = 24
                  ItemIndex = 0
                  TabOrder = 1
                  Text = 'letzte 5 Proben'
                  Items.Strings = (
                    'letzte 5 Proben'
                    'letzte Probe'
                    'markierte Probe(n)'
                    'TEST1')
                end
                object BtnLAER: TBitBtn
                  Left = 392
                  Top = 9
                  Width = 193
                  Height = 25
                  Caption = 'Werte erfassen'
                  Glyph.Data = {
                    9E050000424D9E05000000000000360400002800000012000000120000000100
                    0800000000006801000000000000000000000001000000000000000000000000
                    BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
                    A400000000000000000000000000000000000000000000000000000000000000
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
                    0707070707070707070707074D6F070707070700000000000000000000000007
                    2E4207070007F8FFFFFFF8FFFFFFF8FFFFFF0007702007070000F8FFFFFFF8FF
                    FFFFF8FFFFFF0007626907070007F8FFFFFFF8FFFFFFF8FFFFFF000774200707
                    0707F8F8F8F8F8F8F8F8F8F8F8F8070700000707070707070707070707070707
                    0707070700000707070707F8F8F80707070707070707070700000707070707FA
                    02F80707070707070707070700000707070707FA02F807070707070707070707
                    00000707F8F8F8FA02F8F8F8F80707070707070700000707FA02020202020202
                    F80707070707070700000707FAFAFAFA02FAFAFAF807070707070707D8010707
                    070707FA02F80707070707070707070708000707070707FA02F8070707070707
                    0707070700000707070707FAFAF8070707070707070707070000070707070707
                    0707070707070707070707070707070707070707070707070707070707070707
                    0473}
                  TabOrder = 2
                  OnClick = BtnLAERClick
                end
                object BtnMarkLims: TBitBtn
                  Left = 608
                  Top = 9
                  Width = 153
                  Height = 25
                  Caption = 'Siloproben markieren'
                  TabOrder = 3
                  OnClick = BtnMarkLimsClick
                end
              end
              object GroupBox3: TGroupBox
                Left = 0
                Top = 122
                Width = 887
                Height = 173
                Align = alClient
                Caption = 'LIMS Werte'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -13
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 2
                ExplicitTop = 118
                ExplicitWidth = 716
                ExplicitHeight = 95
                object ScrollBox1: TScrollBox
                  Left = 2
                  Top = 18
                  Width = 883
                  Height = 153
                  Align = alClient
                  BevelOuter = bvNone
                  BorderStyle = bsNone
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 0
                  ExplicitWidth = 712
                  ExplicitHeight = 75
                  object MuV_LABI_ERGEBNISSE: TMultiGrid
                    Left = 0
                    Top = 0
                    Width = 883
                    Height = 153
                    Align = alClient
                    DataSource = LuV_LABI_ERGEBNISSE
                    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
                    TabOrder = 0
                    TitleFont.Charset = DEFAULT_CHARSET
                    TitleFont.Color = clBlack
                    TitleFont.Height = -13
                    TitleFont.Name = 'MS Sans Serif'
                    TitleFont.Style = []
                    ColumnList.Strings = (
                      'Probe Nr.:12=PROBE_NR'
                      '0,71:7=P1'
                      '0,5:7=P2'
                      '0,355:7=P3'
                      '0,25:7=P4'
                      '0,18:7=P5'
                      '<0,18:10=P6'
                      'PQ Nummer:12=SILO_NR'
                      'Probe Datum Zeit:18=PROBE_DATUM')
                    ReturnSingle = False
                    NoColumnSave = False
                    MuOptions = [muNoAskLayout, muPostOnExit]
                    DefaultRowHeight = 20
                    Drag0Value = '0'
                  end
                end
                object chbLabi0: TCheckBox
                  Left = 384
                  Top = 0
                  Width = 118
                  Height = 17
                  Caption = 'Sieban.Auslass'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 1
                  OnClick = chbLabiClick
                end
                object chbLabi1: TCheckBox
                  Tag = 1
                  Left = 504
                  Top = 0
                  Width = 118
                  Height = 17
                  Caption = 'Sieban.Auslass'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 2
                  OnClick = chbLabiClick
                end
                object chbLabi2: TCheckBox
                  Tag = 2
                  Left = 624
                  Top = 0
                  Width = 118
                  Height = 17
                  Caption = 'Sieban.Auslass'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 3
                  OnClick = chbLabiClick
                end
                object chbLabi3: TCheckBox
                  Tag = 3
                  Left = 744
                  Top = 0
                  Width = 118
                  Height = 17
                  Caption = 'Sieban.Auslass'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 4
                  OnClick = chbLabiClick
                end
                object chbLabiHand: TCheckBox
                  Left = 240
                  Top = 0
                  Width = 107
                  Height = 17
                  Caption = 'Handeingaben'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 5
                  OnClick = chbLabiClick
                end
                object chbLabiSiloproben: TCheckBox
                  Left = 144
                  Top = 0
                  Width = 88
                  Height = 17
                  Caption = 'Siloproben'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -13
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  TabOrder = 6
                  OnClick = chbLabiClick
                end
              end
            end
            object tsSMHEinstellungen: TTabSheet
              Caption = 'SMH Einstellungen'
              ImageIndex = 2
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object ScrollBox2: TScrollBox
                Left = 0
                Top = 0
                Width = 887
                Height = 295
                Align = alClient
                BorderStyle = bsNone
                TabOrder = 0
                ExplicitWidth = 716
                ExplicitHeight = 229
                object Label52: TLabel
                  Left = 8
                  Top = 58
                  Width = 79
                  Height = 16
                  Caption = 'Filter f'#252'r LIMS'
                end
                object Label53: TLabel
                  Left = 392
                  Top = 58
                  Width = 256
                  Height = 13
                  Caption = 'Haltern: PRODUKT_NR - Mehrere Werte mit ; trennen'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label54: TLabel
                  Left = 8
                  Top = 10
                  Width = 90
                  Height = 16
                  Caption = 'LIMS Probe Nr.'
                end
                object Label55: TLabel
                  Left = 8
                  Top = 84
                  Width = 101
                  Height = 16
                  Caption = 'max. Probenalter'
                end
                object Label56: TLabel
                  Left = 176
                  Top = 84
                  Width = 33
                  Height = 16
                  Caption = 'Tage'
                end
                object Label57: TLabel
                  Left = 8
                  Top = 34
                  Width = 87
                  Height = 16
                  Caption = 'Auto Probe Nr.'
                end
                object Label58: TLabel
                  Left = 8
                  Top = 132
                  Width = 73
                  Height = 16
                  Caption = 'Anzeigefilter'
                end
                object Label59: TLabel
                  Left = 384
                  Top = 132
                  Width = 131
                  Height = 13
                  Caption = '% = Platzhalter f'#252'r Silo (0..9)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label60: TLabel
                  Left = 384
                  Top = 148
                  Width = 167
                  Height = 13
                  Caption = 'Nach '#196'nderung Fenster neu '#246'ffnen'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                end
                object Label61: TLabel
                  Left = 8
                  Top = 108
                  Width = 55
                  Height = 16
                  Caption = 'min. Wert'
                end
                object Label62: TLabel
                  Left = 184
                  Top = 108
                  Width = 59
                  Height = 16
                  Alignment = taRightJustify
                  Caption = 'max. Wert'
                end
                object Label63: TLabel
                  Left = 308
                  Top = 108
                  Width = 311
                  Height = 16
                  Caption = '[in mm]   f'#252'r Grafische Darstellung  der Kornverteilung'
                end
                object edLABI_SILO_FILTER: TLookUpEdit
                  Left = 104
                  Top = 56
                  Width = 281
                  Height = 24
                  DataField = 'LABI_SILO_FILTER'
                  DataSource = LDataSource1
                  TabOrder = 0
                  Options = []
                  KeyField = True
                end
                object edLABI_PROBE_NR: TLookUpEdit
                  Tag = 128
                  Left = 104
                  Top = 8
                  Width = 369
                  Height = 24
                  DataField = 'LABI_PROBE_NR'
                  DataSource = LDataSource1
                  TabOrder = 1
                  Options = []
                  KeyField = True
                end
                object EdLimsTage: TEdit
                  Left = 120
                  Top = 80
                  Width = 49
                  Height = 24
                  TabOrder = 2
                  Text = '30'
                end
                object edAUTO_PROBE_NR: TLookUpEdit
                  Tag = 128
                  Left = 104
                  Top = 32
                  Width = 369
                  Height = 24
                  DataField = 'AUTO_PROBE_NR'
                  DataSource = LDataSource1
                  TabOrder = 3
                  Options = []
                  KeyField = True
                end
                object MeLabiFilter: TMemo
                  Left = 104
                  Top = 134
                  Width = 265
                  Height = 89
                  Lines.Strings = (
                    'PQ035%=Camsizer'
                    'PQ045%=Siebanalyse Einlass'
                    'PQ047%=Siebanalyse Auslass')
                  TabOrder = 4
                end
                object EdChartMinX: TEdit
                  Left = 120
                  Top = 104
                  Width = 49
                  Height = 24
                  TabOrder = 5
                  Text = '0,063'
                end
                object EdChartMaxX: TEdit
                  Left = 256
                  Top = 104
                  Width = 49
                  Height = 24
                  TabOrder = 6
                  Text = '1,000'
                end
              end
            end
          end
        end
        object tsStellungen: TTabSheet
          Caption = 'Stellungen'
          ImageIndex = 5
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          inline FrSIST: TFrMuSi
            Left = 0
            Top = 49
            Width = 895
            Height = 318
            Align = alClient
            TabOrder = 1
            ExplicitTop = 49
            ExplicitWidth = 724
            ExplicitHeight = 252
            inherited Mu: TMultiGrid
              Width = 696
              Height = 252
              Hint = ''
              DataSource = LuSIST
              TitleFont.Color = clBlack
              TitleFont.Height = -13
              TitleFont.Name = 'MS Sans Serif'
              ColumnList.Strings = (
                'A:2=cfA1'
                'St.:3=cfS1'
                'A2:2=cfA2'
                'St2:3=cfS2'
                'Anteil:6=SIST_KEY'
                'Silocode:11=SPS_CODE'
                'Stillstand:6=STILLSTAND')
              MuOptions = [muNoAskLayout, muPostOnExit]
              DefaultRowHeight = 20
            end
            inherited Panel12: TPanel
              Left = 696
              Height = 252
              ExplicitLeft = 696
              ExplicitHeight = 252
            end
          end
          object lbSistSmw: TListBox
            Left = 408
            Top = 104
            Width = 121
            Height = 97
            Items.Strings = (
              'Anteil [%]:6=SIST_KEY'
              #214'ffnungszeit [1/10s]:11=SPS_CODE'
              'Nachlauf:9=NACHLAUF'
              'Stillstand:9=STILLSTAND')
            TabOrder = 2
            Visible = False
          end
          object Panel6: TPanel
            Left = 0
            Top = 0
            Width = 895
            Height = 49
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 724
            object Label44: TLabel
              Left = 8
              Top = 8
              Width = 71
              Height = 16
              Caption = 'Multiplikator'
            end
            object Label45: TLabel
              Left = 156
              Top = 8
              Width = 15
              Height = 16
              Caption = '% '
            end
            object Label46: TLabel
              Left = 184
              Top = 8
              Width = 312
              Height = 26
              Caption = 
                'Mit diesem Prozentwert wird der Anteil f'#252'r die SPS/Visu multipli' +
                'ziert'#13#10'Beispiel: 60% entspricht dem Faktor 0,6'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object edMULTIPLIKATOR: TDBEdit
              Left = 96
              Top = 6
              Width = 57
              Height = 24
              DataField = 'MULTIPLIKATOR'
              DataSource = LDataSource1
              TabOrder = 0
            end
          end
        end
        object TabSheet6: TTabSheet
          Caption = 'Leistungen'
          ImageIndex = 8
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          inline FrSILE: TFrMuSi
            Left = 0
            Top = 65
            Width = 895
            Height = 302
            Align = alClient
            TabOrder = 0
            ExplicitTop = 65
            ExplicitWidth = 724
            ExplicitHeight = 236
            inherited Mu: TMultiGrid
              Width = 696
              Height = 236
              Hint = ''
              DataSource = LuSILE
              TitleFont.Color = clBlack
              TitleFont.Height = -13
              TitleFont.Name = 'MS Sans Serif'
              ColumnList.Strings = (
                'Anteil (SMH):10=SIST_KEY'
                'Leistung (t/h):8=LEISTUNG')
              MuOptions = [muNoAskLayout, muPostOnExit]
              DefaultRowHeight = 20
            end
            inherited Panel12: TPanel
              Left = 696
              Height = 236
              ExplicitLeft = 696
              ExplicitHeight = 236
              inherited btnSingle: TqBtnMuSi
                Visible = False
              end
              inherited btnFTab: TqBtnMuSi
                Visible = False
              end
            end
          end
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 895
            Height = 65
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitWidth = 724
            object Label14: TLabel
              Left = 8
              Top = 8
              Width = 72
              Height = 16
              Caption = 'Leistungsart'
              FocusControl = cobLEIST_KNZ
            end
            object Label48: TLabel
              Left = 8
              Top = 34
              Width = 77
              Height = 16
              Caption = 'Min. Leistung'
              FocusControl = edLEIST_MIN
            end
            object Label49: TLabel
              Left = 153
              Top = 34
              Width = 20
              Height = 16
              Caption = 't / h'
            end
            object Label50: TLabel
              Left = 196
              Top = 34
              Width = 78
              Height = 16
              Alignment = taRightJustify
              Caption = 'Max.Leistung'
              FocusControl = edLEIST_MAX
            end
            object Label51: TLabel
              Left = 341
              Top = 34
              Width = 20
              Height = 16
              Caption = 't / h'
            end
            object cobLEIST_KNZ: TAswComboBox
              Left = 92
              Top = 6
              Width = 145
              Height = 24
              AutoComplete = False
              DataField = 'LEIST_KNZ'
              DataSource = LDataSource1
              Items.Strings = (
                'kontinuierlich'
                'diskontinuierlich')
              TabOrder = 0
              AswName = 'LeistKnz'
            end
            object edLEIST_MIN: TLookUpEdit
              Left = 92
              Top = 32
              Width = 57
              Height = 24
              Hint = 'wenn kontinuierlich'
              DataField = 'LEIST_MIN'
              DataSource = LDataSource1
              TabOrder = 1
              Options = []
              KeyField = True
            end
            object edLEIST_MAX: TLookUpEdit
              Left = 280
              Top = 32
              Width = 57
              Height = 24
              Hint = 'wenn kontinuierlich'
              DataField = 'LEIST_MAX'
              DataSource = LDataSource1
              TabOrder = 2
              Options = []
              KeyField = True
            end
          end
        end
        object tsAnlage: TTabSheet
          Caption = 'Anlage'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 301
          object Label25: TLabel
            Left = 8
            Top = 8
            Width = 86
            Height = 16
            Caption = 'Charge / Sorte'
            FocusControl = edAKT_SORTE
          end
          object Label26: TLabel
            Left = 283
            Top = 180
            Width = 43
            Height = 16
            Alignment = taRightJustify
            Caption = 'F'#252'llung'
            FocusControl = edAKT_FUELLUNG
          end
          object Label27: TLabel
            Left = 8
            Top = 180
            Width = 56
            Height = 16
            Caption = 'Silostand'
            FocusControl = edAKT_TO
          end
          object Label22: TLabel
            Left = 8
            Top = 156
            Width = 47
            Height = 16
            Caption = 'Gesamt'
            FocusControl = edGESAMT_TO
          end
          object Label23: TLabel
            Left = 222
            Top = 156
            Width = 3
            Height = 16
            Caption = 't'
            FocusControl = edGESAMT_TO
          end
          object Label24: TLabel
            Left = 8
            Top = 132
            Width = 111
            Height = 16
            Caption = 'Entw'#228'sserungszeit'
            FocusControl = edAKT_ENTW_ZEIT
          end
          object Label1: TLabel
            Left = 242
            Top = 62
            Width = 45
            Height = 16
            Alignment = taRightJustify
            Caption = 'Priorit'#228't'
            FocusControl = edPRIO
          end
          object Label9: TLabel
            Left = 370
            Top = 62
            Width = 81
            Height = 16
            Caption = '(1 ist h'#246'chste)'
            FocusControl = edPRIO
          end
          object Label12: TLabel
            Left = 8
            Top = 228
            Width = 46
            Height = 16
            Caption = 'St'#246'rung'
            FocusControl = edAKT_STOERUNG
          end
          object Label13: TLabel
            Left = 222
            Top = 180
            Width = 3
            Height = 16
            Caption = 't'
            FocusControl = edGESAMT_TO
          end
          object Label28: TLabel
            Left = 8
            Top = 32
            Width = 42
            Height = 16
            Caption = 'Sorte 2'
            FocusControl = edAKT_SORTE
          end
          object Label32: TLabel
            Left = 430
            Top = 132
            Width = 3
            Height = 16
            Caption = 't'
            FocusControl = edNACHLAUF
          end
          object Label35: TLabel
            Left = 273
            Top = 132
            Width = 53
            Height = 16
            Alignment = taRightJustify
            Caption = 'Nachlauf'
            FocusControl = edAKT_FUELLUNG
          end
          object Label36: TLabel
            Left = 430
            Top = 180
            Width = 12
            Height = 16
            Caption = '%'
            FocusControl = edNACHLAUF
          end
          object Label37: TLabel
            Left = 272
            Top = 156
            Width = 54
            Height = 16
            Alignment = taRightJustify
            Caption = 'Stillstand'
            FocusControl = edAKT_FUELLUNG
          end
          object Label38: TLabel
            Left = 430
            Top = 156
            Width = 3
            Height = 16
            Caption = 't'
            FocusControl = edSTILLSTAND
          end
          object Label42: TLabel
            Left = 259
            Top = 204
            Width = 67
            Height = 16
            Alignment = taRightJustify
            Caption = 'Min.F'#252'llung'
            FocusControl = edAKT_MINFUELLUNG
          end
          object Label43: TLabel
            Left = 430
            Top = 204
            Width = 12
            Height = 16
            Caption = '%'
            FocusControl = edNACHLAUF
          end
          object edAKT_SORTE: TLookUpEdit
            Left = 128
            Top = 3
            Width = 129
            Height = 24
            DataField = 'AKT_SORTE'
            DataSource = LDataSource1
            TabOrder = 0
            Options = []
            LookupSource = LuGRSO
            LookupField = 'SPS_SORTE'
            References.Strings = (
              'WERK_NR=:SO_WERK_NR'
              'TROCKEN_FEUCHT=:TROCKEN_FEUCHT')
            KeyField = True
          end
          object edAKT_FUELLUNG: TDBEdit
            Left = 336
            Top = 178
            Width = 89
            Height = 24
            DataField = 'AKT_FUELLUNG'
            DataSource = LDataSource1
            TabOrder = 14
          end
          object edAKT_TO: TDBEdit
            Left = 128
            Top = 178
            Width = 89
            Height = 24
            DataField = 'AKT_TO'
            DataSource = LDataSource1
            TabOrder = 13
          end
          object edGESAMT_TO: TDBEdit
            Left = 128
            Top = 154
            Width = 89
            Height = 24
            DataField = 'GESAMT_TO'
            DataSource = LDataSource1
            TabOrder = 11
          end
          object edAKT_ENTW_ZEIT: TDBEdit
            Left = 128
            Top = 130
            Width = 89
            Height = 24
            DataField = 'AKT_ENTW_ZEIT'
            DataSource = LDataSource1
            TabOrder = 9
          end
          object chbAKT_SPERRE_BAHN: TAswCheckBox
            Left = 8
            Top = 58
            Width = 132
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Sperre Bahn'
            DataField = 'AKT_SPERRE_BAHN'
            DataSource = LDataSource1
            TabOrder = 2
            ValueChecked = 'Ja'
            ValueUnchecked = 'Nein'
            AswName = 'JaNein'
          end
          object chbAKT_SPERRE_LKW: TAswCheckBox
            Left = 8
            Top = 74
            Width = 132
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Sperre LKW'
            DataField = 'AKT_SPERRE_LKW'
            DataSource = LDataSource1
            TabOrder = 3
            ValueChecked = 'Ja'
            ValueUnchecked = 'Nein'
            AswName = 'JaNein'
          end
          object edPRIO: TDBEdit
            Left = 296
            Top = 60
            Width = 41
            Height = 24
            DataField = 'PRIO'
            DataSource = LDataSource1
            TabOrder = 6
          end
          object btnPRIO: TqSpin
            Left = 337
            Top = 60
            Width = 15
            Height = 24
            DownGlyph.Data = {
              BA000000424DBA00000000000000420000002800000009000000060000000100
              1000030000007800000000000000000000000000000000000000007C0000E003
              00001F0000000042004200420042004200420042004200420000004200420042
              0042000000420042004200420000004200420042000000000000004200420042
              0000004200420000000000000000000000420042000000420000000000000000
              000000000000004200000042004200420042004200420042004200420000}
            TabOrder = 7
            UpGlyph.Data = {
              BA000000424DBA00000000000000420000002800000009000000060000000100
              1000030000007800000000000000000000000000000000000000007C0000E003
              00001F0000000042004200420042004200420042004200420000004200000000
              0000000000000000000000420000004200420000000000000000000000420042
              0000004200420042000000000000004200420042000000420042004200420000
              004200420042004200000042004200420042004200420042004200420000}
            DBEdit = edPRIO
            MaxValue = 9
            MinValue = 1
            StartValue = 1
            StepValue = 1
            Mask = '0'
          end
          object chbAKT_RESERVIERT_TR: TAswCheckBox
            Left = 8
            Top = 107
            Width = 132
            Height = 17
            Hint = 'reserviert'
            Alignment = taLeftJustify
            Caption = 'Trocknung'
            DataField = 'AKT_RESERVIERT_TR'
            DataSource = LDataSource1
            TabOrder = 5
            ValueChecked = 'X'
            ValueUnchecked = '-'
            AswName = 'JNX'
          end
          object edAKT_STOERUNG: TDBEdit
            Left = 128
            Top = 226
            Width = 393
            Height = 24
            DataField = 'AKT_STOERUNG'
            DataSource = LDataSource1
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 16
          end
          object chbAKT_RESERVIERT_BAHN: TAswCheckBox
            Left = 189
            Top = 106
            Width = 120
            Height = 17
            Hint = 'reserviert'
            Alignment = taLeftJustify
            Caption = 'Reserviert Bahn'
            DataField = 'AKT_RESERVIERT_BAHN'
            DataSource = LDataSource1
            TabOrder = 8
            ValueChecked = 'X'
            ValueUnchecked = '-'
            AswName = 'JNX'
          end
          object edAKT_SORTE2: TLookUpEdit
            Left = 128
            Top = 30
            Width = 129
            Height = 24
            DataField = 'AKT_SORTE2'
            DataSource = LDataSource1
            TabOrder = 1
            Options = []
            LookupSource = LuGRSO2
            LookupField = 'SPS_SORTE'
            References.Strings = (
              'WERK_NR=:SO_WERK_NR'
              'TROCKEN_FEUCHT=:TROCKEN_FEUCHT')
            KeyField = False
          end
          object edNACHLAUF: TDBEdit
            Left = 336
            Top = 130
            Width = 89
            Height = 24
            DataField = 'NACHLAUF'
            DataSource = LDataSource1
            TabOrder = 10
          end
          object edSTILLSTAND: TDBEdit
            Left = 336
            Top = 154
            Width = 89
            Height = 24
            DataField = 'STILLSTAND'
            DataSource = LDataSource1
            TabOrder = 12
          end
          object edAKT_MINFUELLUNG: TDBEdit
            Left = 336
            Top = 202
            Width = 89
            Height = 24
            Hint = 
              'SMF:wenn unterschritten wird Silo gesperrt. Sonst: Priorit'#228't wir' +
              'd um 10 herabgesetzt.'
            DataField = 'AKT_MINFUELLUNG'
            DataSource = LDataSource1
            TabOrder = 15
          end
          object chbAKT_SPERRE_BIGBAG: TAswCheckBox
            Left = 8
            Top = 90
            Width = 132
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Sperre Big Bag'
            DataField = 'AKT_SPERRE_BIGBAG'
            DataSource = LDataSource1
            TabOrder = 4
            ValueChecked = 'Ja'
            ValueUnchecked = 'Nein'
            AswName = 'JaNein'
          end
        end
        object tsBeladungen: TTabSheet
          Caption = 'Beladungen'
          ImageIndex = 6
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuBELA: TMultiGrid
            Left = 0
            Top = 0
            Width = 895
            Height = 367
            Align = alClient
            DataSource = LuBELA
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -13
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Datum:8=DATUM'
              'Zeit:5=ZEIT'
              'Silo1:4=SILP1_NR'
              '%1:3=ANTEIL1'
              'Silo2:4=SILP2_NR'
              '%2:2=ANTEIL2'
              'Silo3:4=SILP3_NR'
              '%3:2=ANTEIL3'
              'Brutto:7=BRUTTO_GEWICHT'
              'Schenk:6=cfSchenkDiff'
              'gesamt:6=cfGesamtDiff'
              'Kfz:11=TRANSPORTMITTEL'
              'Material:14=MARA_NAME'
              'Status:7=STATUS'
              'Istmenge:7=ISTMENGE'
              'Netto:7=NETTO_GEWICHT')
            ReturnSingle = True
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit, muCustColor]
            DefaultRowHeight = 20
            Drag0Value = '0'
          end
        end
        object tsSchenk: TTabSheet
          Caption = 'Korrektur'
          ImageIndex = 7
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object qSplitter1: TqSplitter
            Left = 0
            Top = 199
            Width = 895
            Height = 4
            Cursor = crVSplit
            Align = alBottom
            Color = clGray
            ParentColor = False
            SavePosition = True
            ExplicitTop = 111
            ExplicitWidth = 619
          end
          object GridSchenk: TTitleGrid
            Left = 0
            Top = 203
            Width = 895
            Height = 134
            Align = alBottom
            DefaultRowHeight = 17
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs, goThumbTracking]
            TabOrder = 0
            AdjustWidths = True
            Titles.Strings = (
              'Silo1'
              'Silo2'
              'Silo3'
              'Korrekturwert [to]')
            TitleOptions = []
            ExplicitTop = 137
            ExplicitWidth = 724
            ColWidths = (
              4
              34
              34
              34
              103)
          end
          object Panel1: TPanel
            Left = 0
            Top = 337
            Width = 895
            Height = 30
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitTop = 271
            ExplicitWidth = 724
            object Label40: TLabel
              Left = 128
              Top = 8
              Width = 352
              Height = 13
              Caption = 
                'Wenn zuviel beladen wurde, tragen Sie einen kleineren Wert (ggf.' +
                ' < 0) ein.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object BtnSchenkSave: TBitBtn
              Left = 16
              Top = 4
              Width = 75
              Height = 25
              Caption = 'Speichern'
              TabOrder = 0
              OnClick = BtnSchenkSaveClick
            end
          end
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 895
            Height = 199
            Align = alClient
            Caption = 'Durchschnittswerte der letzten'
            TabOrder = 2
            ExplicitWidth = 619
            ExplicitHeight = 113
            object MuSCHENK: TMultiGrid
              Left = 2
              Top = 18
              Width = 891
              Height = 179
              Align = alClient
              DataSource = LuSCHENK
              Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clBlack
              TitleFont.Height = -13
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
              ColumnList.Strings = (
                'SILO1=SILO1'
                'SILO2=SILO2'
                'SILO3=SILO3'
                'ANZAHL=ANZAHL'
                'SCHENKDIFF=SCHENKDIFF')
              ReturnSingle = False
              NoColumnSave = False
              MuOptions = [muNoAskLayout, muPostOnExit, muNoSlideBar]
              DefaultRowHeight = 20
              Drag0Value = '0'
            end
            object Panel4: TPanel
              Left = 188
              Top = 0
              Width = 72
              Height = 16
              BevelOuter = bvNone
              TabOrder = 1
              object Label39: TLabel
                Left = 36
                Top = 0
                Width = 33
                Height = 16
                Caption = 'Tage'
              end
              object EdSchenkTage: TEdit
                Left = 0
                Top = 0
                Width = 32
                Height = 22
                Ctl3D = False
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentCtl3D = False
                ParentFont = False
                TabOrder = 0
                Text = '3'
                OnChange = EdSchenkTageChange
              end
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #196'nderungen'
          ImageIndex = 3
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object MuDiPr: TMultiGrid
            Left = 0
            Top = 0
            Width = 895
            Height = 367
            Align = alClient
            DataSource = LuDiPr
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -13
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Zeitpunkt:15=LIEGTAN_AM'
              'von:10=ERFASST_VON'
              'Text:60=STME_TEXT')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muCustColor]
            DefaultRowHeight = 20
            Drag0Value = '0'
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object ScrollBox4: TScrollBox
            Left = 0
            Top = 0
            Width = 895
            Height = 367
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object Label3: TLabel
              Left = 8
              Top = 109
              Width = 96
              Height = 16
              Caption = 'SILO_WERK_ID'
            end
            object Label15: TLabel
              Left = 360
              Top = 112
              Width = 56
              Height = 16
              Caption = 'SILO1_ID'
            end
            object Label16: TLabel
              Left = 360
              Top = 138
              Width = 56
              Height = 16
              Caption = 'SILO2_ID'
            end
            object Label21: TLabel
              Left = 8
              Top = 133
              Width = 95
              Height = 16
              Caption = 'SILO_GRSO_ID'
            end
            object Label17: TLabel
              Left = 360
              Top = 164
              Width = 56
              Height = 16
              Caption = 'SILO3_ID'
            end
            object Label19: TLabel
              Left = 8
              Top = 157
              Width = 102
              Height = 16
              Caption = 'SILO_GRSO2_ID'
            end
            object Label41: TLabel
              Left = 8
              Top = 181
              Width = 101
              Height = 16
              Caption = 'BEIN.WERK_NR'
            end
            object GbStatisitk: TGroupBox
              Left = 0
              Top = 0
              Width = 895
              Height = 97
              Align = alTop
              TabOrder = 0
              object Label29: TLabel
                Left = 8
                Top = 18
                Width = 116
                Height = 16
                Caption = 'Erfasst von, am, DB'
              end
              object Label31: TLabel
                Left = 8
                Top = 42
                Width = 131
                Height = 16
                Caption = 'Ge'#228'ndert von, am, DB'
              end
              object Label33: TLabel
                Left = 8
                Top = 66
                Width = 116
                Height = 16
                Caption = 'Anzahl '#196'nderungen'
              end
              object Label34: TLabel
                Left = 245
                Top = 66
                Width = 13
                Height = 16
                Caption = 'ID'
              end
              object EdERFASST_VON: TDBEdit
                Left = 141
                Top = 16
                Width = 122
                Height = 24
                Hint = 'ERFASST_VON'
                DataField = 'ERFASST_VON'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 0
              end
              object EdERFASST_AM: TDBEdit
                Left = 264
                Top = 16
                Width = 140
                Height = 24
                Hint = 'ERFASST_AM'
                DataField = 'ERFASST_AM'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 1
              end
              object EdGEAENDERT_VON: TDBEdit
                Left = 141
                Top = 40
                Width = 122
                Height = 24
                Hint = 'GEAENDERT_VON'
                DataField = 'GEAENDERT_VON'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 2
              end
              object EdGEAENDERT_AM: TDBEdit
                Left = 264
                Top = 40
                Width = 140
                Height = 24
                Hint = 'GEAENDERT_AM'
                DataField = 'GEAENDERT_AM'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 3
              end
              object EdANZAHL_AENDERUNGEN: TDBEdit
                Left = 141
                Top = 64
                Width = 84
                Height = 24
                Hint = 'ANZAHL_AENDERUNGEN'
                DataField = 'ANZAHL_AENDERUNGEN'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 4
              end
              object edID: TDBEdit
                Left = 264
                Top = 64
                Width = 84
                Height = 24
                Hint = 'Ident'
                DataField = 'SILO_ID'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 5
              end
              object edERFASST_DATENBANK: TDBEdit
                Left = 405
                Top = 16
                Width = 122
                Height = 24
                Hint = 'ERFASST_DATENBANK'
                DataField = 'ERFASST_DATENBANK'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 6
              end
              object edGEAENDERT_DATENBANK: TDBEdit
                Left = 405
                Top = 40
                Width = 122
                Height = 24
                Hint = 'GEAENDERT_DATENBANK'
                DataField = 'GEAENDERT_DATENBANK'
                DataSource = LDataSource1
                ReadOnly = True
                TabOrder = 7
              end
            end
            object LeWERK_ID: TLookUpEdit
              Left = 120
              Top = 107
              Width = 84
              Height = 24
              Ctl3D = True
              DataField = 'SILO_WERK_ID'
              DataSource = LDataSource1
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 1
              Options = []
              LookupSource = LuWerk
              LookupField = 'WERK_ID'
              KeyField = True
            end
            object LeSILO1_ID: TLookUpEdit
              Left = 424
              Top = 110
              Width = 83
              Height = 24
              DataField = 'SILO1_ID'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 2
              Options = []
              LookupSource = LuSilo1
              LookupField = 'SILO_ID'
              KeyField = True
            end
            object LeSILO2_ID: TLookUpEdit
              Left = 424
              Top = 136
              Width = 83
              Height = 24
              DataField = 'SILO2_ID'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 3
              Options = []
              LookupSource = LuSilo2
              LookupField = 'SILO_ID'
              KeyField = True
            end
            object leSILO_GRSO_ID: TLookUpEdit
              Left = 120
              Top = 131
              Width = 84
              Height = 24
              Ctl3D = True
              DataField = 'SILO_GRSO_ID'
              DataSource = LDataSource1
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 4
              Options = []
              LookupSource = LuGRSO
              LookupField = 'GRSO_ID'
              KeyField = True
            end
            object LeSILO3_ID: TLookUpEdit
              Left = 424
              Top = 162
              Width = 83
              Height = 24
              DataField = 'SILO3_ID'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 5
              Options = []
              LookupSource = LuSilo3
              LookupField = 'SILO_ID'
              KeyField = True
            end
            object edSILO_GRSO2_ID: TLookUpEdit
              Left = 120
              Top = 155
              Width = 84
              Height = 24
              Ctl3D = True
              DataField = 'SILO_GRSO2_ID'
              DataSource = LDataSource1
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 6
              Options = []
              LookupSource = LuGRSO2
              LookupField = 'GRSO_ID'
              KeyField = True
            end
            object edSO_WERK_NR1: TLookUpEdit
              Left = 512
              Top = 110
              Width = 57
              Height = 24
              DataField = 'SO_WERK_NR'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 7
              Options = [LeNoNullValues]
              LookupSource = LuSilo1
              LookupField = 'SO_WERK_NR'
              KeyField = True
            end
            object edSO_WERK_NR2: TLookUpEdit
              Left = 512
              Top = 136
              Width = 57
              Height = 24
              DataField = 'SO_WERK_NR'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 8
              Options = [LeNoNullValues]
              LookupSource = LuSilo2
              LookupField = 'SO_WERK_NR'
              KeyField = True
            end
            object edSO_WERK_NR3: TLookUpEdit
              Left = 512
              Top = 162
              Width = 57
              Height = 24
              DataField = 'SO_WERK_NR'
              DataSource = LDataSource1
              ReadOnly = True
              TabOrder = 9
              Options = [LeNoNullValues]
              LookupSource = LuSilo3
              LookupField = 'SO_WERK_NR'
              KeyField = True
            end
            object EdBeinSO_WERK_NR: TLookUpEdit
              Left = 120
              Top = 179
              Width = 84
              Height = 24
              Hint = 'BEIN.SO_WERK_NR'
              Ctl3D = True
              DataField = 'SO_WERK_NR'
              DataSource = LDataSource1
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 10
              Options = [LeNoOverride]
              LookupSource = LuBEIN
              LookupField = 'SO_WERK_NR'
              KeyField = True
            end
            object chbGrsoKOMBI_KNZ: TAswCheckBox
              Left = 214
              Top = 133
              Width = 93
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Mischsorte'
              DataField = 'KOMBI_KNZ'
              DataSource = LuGRSO
              ReadOnly = True
              TabOrder = 11
              ValueChecked = 'Ja'
              ValueUnchecked = 'Nein'
              AswName = 'JaNein'
            end
            object chbGrso2KOMBI_KNZ: TAswCheckBox
              Left = 214
              Top = 157
              Width = 93
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Mischsorte2'
              DataField = 'KOMBI_KNZ'
              DataSource = LuGRSO2
              ReadOnly = True
              TabOrder = 12
              ValueChecked = 'Ja'
              ValueUnchecked = 'Nein'
              AswName = 'JaNein'
            end
            object BtnInstallSILE: TBitBtn
              Left = 256
              Top = 184
              Width = 153
              Height = 25
              Caption = 'Install Siloleistung SMH'
              TabOrder = 13
              OnClick = BtnInstallSILEClick
            end
            object BtnUpdLabi: TBitBtn
              Left = 256
              Top = 216
              Width = 75
              Height = 25
              Hint = 'Probennummer auf alle Silos dieses SPS_Codes '#252'bertragen'
              Caption = 'UpdateLabi'
              TabOrder = 14
              OnClick = BtnUpdLabiClick
            end
          end
        end
      end
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 903
        Height = 89
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alTop
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 8
          Width = 42
          Height = 16
          Caption = 'B&unker'
          FocusControl = EditSILO_NR
        end
        object Label20: TLabel
          Left = 8
          Top = 32
          Width = 66
          Height = 16
          Caption = 'Grundsorte'
          FocusControl = edGRUNDSORTE
        end
        object Label18: TLabel
          Left = 8
          Top = 56
          Width = 73
          Height = 16
          Caption = 'Grundsorte2'
          FocusControl = edGRUNDSORTE2
        end
        object EditSILO_NR: TDBEdit
          Left = 96
          Top = 6
          Width = 41
          Height = 24
          DataField = 'SILO_NR'
          DataSource = LDataSource1
          TabOrder = 0
        end
        object EditSILO_NAME: TDBEdit
          Left = 179
          Top = 6
          Width = 240
          Height = 24
          DataField = 'SILO_NAME'
          DataSource = LDataSource1
          TabOrder = 1
        end
        object edGRUNDSORTE: TLookUpEdit
          Left = 96
          Top = 30
          Width = 107
          Height = 24
          DataField = 'GRUNDSORTE'
          DataSource = LDataSource1
          TabOrder = 2
          Options = []
          LookupSource = LuGRSO
          LookupField = 'BEZEICHNUNG'
          KeyField = True
        end
        object BtnLuGsort: TLookUpBtn
          Left = 203
          Top = 30
          Width = 21
          Height = 21
          Hint = 'Grunsorte nachschlagen'
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
          LookUpDef = LuGRSO
          Modus = lubMulti
        end
        object edGRUNDSORTE2: TLookUpEdit
          Left = 96
          Top = 54
          Width = 107
          Height = 24
          Hint = 'alternative Grundsorte'
          DataField = 'GRUNDSORTE2'
          DataSource = LDataSource1
          TabOrder = 4
          Options = []
          LookupSource = LuGRSO2
          LookupField = 'BEZEICHNUNG'
          KeyField = True
        end
        object btnGRUNDSORTE2: TLookUpBtn
          Left = 203
          Top = 54
          Width = 21
          Height = 21
          Hint = 'Grunsorte nachschlagen'
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
          TabOrder = 5
          LookUpEdit = edGRUNDSORTE2
          LookUpDef = LuGRSO2
          Modus = lubMulti
        end
        object edMARA_NAME: TDBEdit
          Left = 243
          Top = 30
          Width = 225
          Height = 24
          DataField = 'MARA_NAME'
          DataSource = LuMARA
          TabOrder = 6
        end
        object edMARA_NAME_2: TDBEdit
          Left = 243
          Top = 54
          Width = 225
          Height = 24
          DataField = 'MARA_NAME'
          DataSource = LuMARA2
          TabOrder = 7
        end
      end
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 495
    Width = 931
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 429
    ExplicitWidth = 760
    object LaSiloleistungaktiv: TLabel
      Left = 522
      Top = 4
      Width = 100
      Height = 16
      Caption = 'Siloleistung aktiv'
      Visible = False
    end
    object TabControl: TTabControl
      Left = 0
      Top = 0
      Width = 521
      Height = 25
      Align = alLeft
      Style = tsButtons
      TabOrder = 0
      Tabs.Strings = (
        'Tab1')
      TabIndex = 0
    end
  end
  object Nav: TLNavigator
    TabSet = TabControl
    PageBook = PageControl
    DetailBook = DetailControl
    FormKurz = 'SILO'
    FirstControl = EditSILO_NR
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    AfterReturn = NavAfterReturn
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
      'cfMARA_NAME=Lookup:LuMARA;MARA_NAME'
      'cfMARA_NAME2=Lookup:LuMARA2;MARA_NAME'
      'LEIST_KNZ=string:100'
      'LEIST_MIN=float:2'
      'LEIST_MAX=float:2'
      'cfLABI_SILO_FILTER1=string:80'
      'cfLABI_SILO_FILTER2=string:80'
      'cfLABI_SILO_FILTER3=string:80'
      'cfLABI_SILO_FILTER4=string:80'
      'cfLABI_SILO_INDEX=string:10'
      'cfLABI_PROBE_NR1=string:80'
      'cfLABI_PROBE_NR2=string:80'
      'cfLABI_PROBE_NR3=string:80'
      'cfLABI_PROBE_NR4=string:80'
      'cfLABI_PROBE_NR5=string:80'
      'cfLABI_PROBE_NR6=string:80'
      'cfLABI_PROBE_NR7=string:80'
      'cfLABI_PROBE_NR8=string:80'
      'cfLABI_PROBE_NR9=string:80'
      'cfLABI_PROBE_NR10=string:80')
    FormatList.Strings = (
      'SILO_NAME=N,'
      'BEIN_NR=N,'
      'KOMBI_KNZ=Asw,JaNein'
      'SILO1_ANTEIL=##0"%"'
      'SILO2_ANTEIL=##0"%"'
      'SILO3_ANTEIL=##0"%"'
      'AKT_SPERRE_BAHN=Asw,JNX'
      'AKT_SPERRE_LKW=Asw,JNX'
      'AKT_SPERRE_BIGBAG=Asw,JNX'
      'VERPACKART=Asw,Verpack'
      'AKT_RESERVIERT_TR=Asw,JNX'
      'AKT_RESERVIERT_BAHN=Asw,JNX'
      'TROCKEN_FEUCHT=Asw,TrockenFeucht'
      'SPERRE_LABOR=Asw,JNX'
      'SPERRE_SENSIBLER_KUNDE=Asw,JNX'
      'SILO_NR=N,#,###'
      'NACHLAUF=#,##0.00'
      'LEIST_KNZ=Asw,LeistKnz')
    KeyFields = 'SILO_NR'
    KeyList.Strings = (
      'PK_SILO=SILO_ID')
    PrimaryKeyFields = 'SILO_ID'
    TableName = 'SILOLISTE'
    TabTitel = 'Siloliste'
    OnRech = NavRech
    OnErfass = NavErfass
    BeforePost = NavBeforePost
    Left = 10
    Top = 425
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
    PrimaryKeyFields = 'WERK_ID'
    References.Strings = (
      'WERK_NR=:SO_WERK_NR')
    SOList.Strings = (
      'WERK_NR=:SO_WERK_NR'
      'WERK_ID=:SILO_WERK_ID')
    TableName = 'WERKE'
    TabTitel = ';Werke'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 70
    Top = 394
  end
  object LDataSource1: TLDataSource
    AutoEdit = False
    DataSet = Query1
    OnStateChange = LDataSource1StateChange
    OnDataChange = LDataSource1DataChange
    Left = 38
    Top = 425
  end
  object PsDflt: TPrnSource
    MuSelect = Mu1
    QRepKurz = 'DFLT'
    Preview = False
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
    Left = 321
    Top = 425
  end
  object LuSilo1: TLookUpDef
    DataSet = TblSilo1
    LuKurz = 'SILO1'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luNoForceNull]
    ColumnList.Strings = (
      'Nummer=SILO_NR'
      'Bezeichnung=SILO_NAME')
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
      'SILO_WERK_ID=:SILO_WERK_ID'
      'KOMBI_KNZ=<>J'
      'BEIN_NR=:BEIN_NR')
    KeyList.Strings = (
      'Standard=SILO_NR;SO_WERK_NR'
      'Name=SILO_NAME')
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_ID=:SILO1_ID')
    SOList.Strings = (
      'SILO_NR=:SILO1_NR'
      'SILO_ID=:SILO1_ID'
      'SO_WERK_NR=:SO_WERK_NR')
    TableName = 'SILOLISTE'
    TabTitel = ';Silo1'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 132
    Top = 425
  end
  object LuSilo2: TLookUpDef
    DataSet = TblSilo2
    LuKurz = 'SILO2'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luNoForceNull]
    ColumnList.Strings = (
      'Nummer=SILO_NR'
      'Bezeichnung=SILO_NAME')
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
      'SILO_WERK_ID=:SILO_WERK_ID'
      'KOMBI_KNZ=<>J'
      'BEIN_NR=:BEIN_NR')
    KeyList.Strings = (
      'Standard=SILO_NR;SO_WERK_NR'
      'Name=SILO_NAME')
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_ID=:SILO2_ID')
    SOList.Strings = (
      'SILO_NR=:SILO2_NR'
      'SILO_ID=:SILO2_ID')
    TableName = 'SILOLISTE'
    TabTitel = ';Silo2'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 196
    Top = 425
  end
  object LuSilo3: TLookUpDef
    DataSet = TblSilo3
    LuKurz = 'SILO3'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle, luNoForceNull]
    ColumnList.Strings = (
      'Nummer=SILO_NR'
      'Bezeichnung=SILO_NAME')
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
      'SILO_WERK_ID=:SILO_WERK_ID'
      'KOMBI_KNZ=<>J'
      'BEIN_NR=:BEIN_NR')
    KeyList.Strings = (
      'Standard=SILO_NR;SO_WERK_NR'
      'Name=SILO_NAME')
    PrimaryKeyFields = 'SILO_ID'
    References.Strings = (
      'SILO_ID=:SILO3_ID')
    SOList.Strings = (
      'SILO_NR=:SILO3_NR'
      'SILO_ID=:SILO3_ID')
    TableName = 'SILOLISTE'
    TabTitel = ';Silo3'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 260
    Top = 425
  end
  object LuGRSO: TLookUpDef
    DataSet = TblGRSO
    LuKurz = 'GRSO1'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Werk=WERK_NR'
      'Name=BEZEICHNUNG'
      'SPS Sorte=SPS_SORTE'
      'Mischsorte=KOMBI_KNZ')
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
      'WERK_NR=:SO_WERK_NR'
      'TROCKEN_FEUCHT=:TROCKEN_FEUCHT'
      'KOMBI_KNZ=N;=')
    FormatList.Strings = (
      'KOMBI_KNZ=Asw,JNX'
      'OFFENE_BEL=Asw,JNX'
      'TROCKEN_FEUCHT=Asw,TrockenFeucht')
    KeyFields = 'BEZEICHNUNG'
    KeyList.Strings = (
      'Standard=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    References.Strings = (
      'GRSO_ID=:SILO_GRSO_ID')
    SOList.Strings = (
      'SPS_SORTE=:AKT_SORTE'
      'GRSO_ID=:SILO_GRSO_ID'
      'BEZEICHNUNG=:GRUNDSORTE')
    TableName = 'GRUNDSORTEN'
    TabTitel = 'Grundsorte'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 438
    Top = 425
  end
  object LuMARA: TLookUpDef
    DataSet = TblMARA
    LuKurz = 'MARA'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Sorte Nr:12=MARA_NR'
      'Bezeichnung:30=MARA_NAME')
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
      'WERK_NR=:SO_WERK_NR')
    KeyFields = 'MARA_NR'
    PrimaryKeyFields = 'MARA_ID'
    References.Strings = (
      'MARA_NR=:GRUNDSORTE'
      'WERK_NR=:SO_WERK_NR')
    TableName = 'MATERIALSTAMM'
    TabTitel = 'Material'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 366
    Top = 425
  end
  object LuBEIN: TLookUpDef
    DataSet = TblBEIN
    LuKurz = 'BEIN'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Manuell=MANUELL')
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
      'SO_WERK_NR=:SO_WERK_NR')
    FormatList.Strings = (
      'TRANSPORTART=Asw,Transportart'
      'MANUELL=Asw,JNX')
    KeyFields = 'SO_WERK_NR;BEIN_NR'
    KeyList.Strings = (
      'Standard=SO_WERK_NR;BEIN_NR')
    PrimaryKeyFields = 'BEIN_ID'
    References.Strings = (
      'SO_WERK_NR=:SO_WERK_NR'
      'BEIN_NR=:BEIN_NR')
    SOList.Strings = (
      'VERPACKART=:VERPACKART'
      'BEIN_NR=:BEIN_NR'
      'SO_WERK_NR=:SO_WERK_NR')
    TableName = 'BELADEEINRICHTUNGEN'
    TabTitel = 'Beladeeinrichtung'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 505
    Top = 425
  end
  object LuDiPr: TLookUpDef
    DataSet = TblDiPr
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
    KeyList.Strings = (
      'Standard=STME_ID desc')
    PrimaryKeyFields = 'STME_ID'
    References.Strings = (
      'BEIN_NR=SILO_ID'
      'STME_NR=111202')
    TableName = 'STOERMELDUNGEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 615
    Top = 93
  end
  object LuGRSO2: TLookUpDef
    DataSet = TblGRSO2
    LuKurz = 'GRSO2'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Werk=WERK_NR'
      'Name=BEZEICHNUNG'
      'SPS Sorte=SPS_SORTE'
      'Mischsorte2=KOMBI_KNZ')
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
      'WERK_NR=:SO_WERK_NR'
      'TROCKEN_FEUCHT=:TROCKEN_FEUCHT'
      'KOMBI_KNZ=N;=')
    FormatList.Strings = (
      'KOMBI_KNZ=Asw,JNX'
      'OFFENE_BEL=Asw,JNX'
      'TROCKEN_FEUCHT=Asw,TrockenFeucht')
    KeyList.Strings = (
      'Standard=BEZEICHNUNG')
    PrimaryKeyFields = 'GRSO_ID'
    References.Strings = (
      'GRSO_ID=:SILO_GRSO2_ID')
    SOList.Strings = (
      'SPS_SORTE=:AKT_SORTE2'
      'GRSO_ID=:SILO_GRSO2_ID'
      'BEZEICHNUNG=:GRUNDSORTE2')
    TableName = 'GRUNDSORTEN'
    TabTitel = 'Grundsorte2'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 438
    Top = 393
  end
  object LuMARA2: TLookUpDef
    DataSet = TblMARA2
    LuKurz = 'MARA'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = []
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
    PrimaryKeyFields = 'MARA_ID'
    References.Strings = (
      'MARA_NR=:GRUNDSORTE2'
      'WERK_NR=:SO_WERK_NR')
    TableName = 'MATERIALSTAMM'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 367
    Top = 392
  end
  object LuSIST: TLookUpDef
    DataSet = TblSIST
    LuKurz = 'SIST'
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
    CalcList.Strings = (
      'cfA1=string:5'
      'cfS1=string:5'
      'cfA2=string:5'
      'cfS2=string:5')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.000'
      'STILLSTAND=#0.00')
    KeyList.Strings = (
      'Standard=SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    References.Strings = (
      'SILO_ID=:SILO_ID')
    TableName = 'SILOSTELLUNGEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuSISTGet
    Left = 507
    Top = 394
  end
  object LuSIST1: TLookUpDef
    DataSet = TblSIST1
    LuKurz = 'SIST'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Bunker:4=SILO_NR'
      'Schl'#252'ssel:7=SIST_KEY')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FltrList.Strings = (
      'SO_WERK_NR=:SO_WERK_NR'
      'BEIN_NR=:BEIN_NR')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.000')
    KeyList.Strings = (
      'Standard=SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    References.Strings = (
      'SILO_ID=0')
    TableName = 'SILOSTELLUNGEN'
    DisabledButtons = []
    EnabledButtons = []
    Left = 132
    Top = 394
  end
  object LuSIST2: TLookUpDef
    DataSet = TblSIST2
    LuKurz = 'SIST'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Bunker:4=SILO_NR'
      'Schl'#252'ssel:7=SIST_KEY')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FltrList.Strings = (
      'SO_WERK_NR=:SO_WERK_NR'
      'BEIN_NR=:BEIN_NR')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.000')
    KeyList.Strings = (
      'Standard=SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    References.Strings = (
      'SILO_ID=0')
    TableName = 'SILOSTELLUNGEN'
    DisabledButtons = []
    EnabledButtons = []
    Left = 196
    Top = 394
  end
  object LuSIST3: TLookUpDef
    DataSet = TblSIST3
    LuKurz = 'SIST'
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    ColumnList.Strings = (
      'Bunker:4=SILO_NR'
      'Schl'#252'ssel:7=SIST_KEY')
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FltrList.Strings = (
      'SO_WERK_NR=:SO_WERK_NR'
      'BEIN_NR=:BEIN_NR')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.000')
    KeyList.Strings = (
      'Standard=SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    References.Strings = (
      'SILO_ID=0')
    TableName = 'SILOSTELLUNGEN'
    DisabledButtons = []
    EnabledButtons = []
    Left = 260
    Top = 394
  end
  object LuBELA: TLookUpDef
    DataSet = TblBELA
    LuKurz = 'SHBELA'
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
    MDTyp = mdDetail
    CalcList.Strings = (
      'cfBelaDiff=float:3'
      'cfNettoDiff=float:3'
      'cfSchenkDiff=float:3'
      'cfGesamtDiff=float:3')
    FormatList.Strings = (
      'STATUS=Asw,BelaStatus'
      'MANUELL=Asw,X10'
      'OFFENE_BEL=Asw,X10'
      'QUITTIEREN=Asw,X10'
      'PROBENAHME=Asw,X10'
      'MUSTER=Asw,X10'
      'KOMBI_KNZ=Asw,JNX'
      'VERPACKART=Asw,Verpack'
      'NOTBETRIEB=Asw,JNX'
      'LFS_DRUCK=Asw,JNX'
      'SOLLMENGE=#0.000'
      'ISTMENGE=#0.000'
      'TEILMENGE1=##0.00'
      'TEILMENGE2=##0.00'
      'TEILMENGE3=##0.00'
      'TEILMENGE4=##0.00'
      'TEILMENGE5=##0.00'
      'TARA_GEWICHT=#0.00'
      'BRUTTO_GEWICHT=#0.00'
      'NETTO_GEWICHT=#0.00'
      'MAXBRUTTO=#0.00'
      'ANTEIL1=#0'
      'ANTEIL2=#0'
      'ANTEIL3=#0'
      'SW1_ANTEIL1=#0'
      'SW1_ANTEIL2=#0'
      'SW1_ANTEIL3=#0'
      'SW2_ANTEIL1=#0'
      'SW2_ANTEIL2=#0'
      'SW2_ANTEIL3=#0'
      'AUFK_NR=INT,TL0,'
      'cfBelaDiff=#0.00'
      'cfNettoDiff=#0.00'
      'cfSchenkDiff=#0.00'
      'cfGesamtDiff=#0.00')
    Bemerkung.Strings = (
      '[References]'
      'SILP1_NR=:SPS_CODE%'
      'SILP2_NR=;:SPS_CODE%'
      'SILP3_NR=;:SPS_CODE%'
      'BEIN_NR=:BEIN_NR')
    KeyList.Strings = (
      'Standard=BELA_ID desc')
    PrimaryKeyFields = 'BELA_ID'
    References.Strings = (
      'SILP1_NR=:SPS_CODE'
      'BEIN_NR=:BEIN_NR')
    TableName = 'BELADUNGEN'
    TabTitel = ';Beladungen'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuBELAGet
    OnBuildSql = LuBELABuildSql
    Left = 572
    Top = 422
  end
  object LuSCHENK: TLookUpDef
    DataSet = TblSCHENK
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
    FormatList.Strings = (
      'SchenkDiff=#0.00')
    Bemerkung.Strings = (
      'select SILP1_NR as Silo1,'
      '       SILP2_NR as Silo2,'
      '       SILP3_NR as Silo3,'
      '       count(*) as Anzahl,'
      
        '       to_char(sum(ISTMENGE-NETTO_GEWICHT-STILLSTAND)/count(*),'#39 +
        '0.00'#39') as SchenkDiff'
      'from BELADUNGEN'
      'where ISTMENGE-NETTO_GEWICHT between -1.5 and 1.5'
      'and DATUM >= sysdate-:TAGE'
      'group by SILP1_NR,SILP2_NR,SILP3_NR')
    TabTitel = ';Korrekturwerte'
    DisabledButtons = []
    EnabledButtons = []
    Left = 573
    Top = 392
  end
  object LuV_LABI_MK: TLookUpDef
    DataSet = TblV_LABI_MK
    LuMultiName = 'Multi'
    LookUpTyp = lupGrid
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FormatList.Strings = (
      'MK=#0.000')
    PrimaryKeyFields = 'SILO_NR1'
    References.Strings = (
      'SILO_NR1=:SILO_NR'
      'WERK_NR=:SO_WERK_NR')
    TableName = 'V_LABI_MK'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 636
    Top = 422
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'order by SILO_NR')
    RefreshOptions = [roBeforeEdit]
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = Query1BeforeOpen
    AfterPost = Query1AfterPost
    OnCalcFields = Query1CalcFields
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 66
    Top = 425
  end
  object TblWerk: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from WERKE'
      'where (WERK_NR = :SO_WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 98
    Top = 394
    ParamData = <
      item
        DataType = ftString
        Name = 'SO_WERK_NR'
      end>
  end
  object TblSilo1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_ID = :SILO1_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 160
    Top = 425
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO1_ID'
      end>
  end
  object TblSilo2: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_ID = :SILO2_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 224
    Top = 425
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO2_ID'
      end>
  end
  object TblSilo3: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOLISTE'
      'where (SILO_ID = :SILO3_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 288
    Top = 425
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO3_ID'
      end>
  end
  object TblGRSO: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from GRUNDSORTEN'
      'where (GRSO_ID = :SILO_GRSO_ID)'
      'order by BEZEICHNUNG')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 466
    Top = 425
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO_GRSO_ID'
      end>
  end
  object TblMARA: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from MATERIALSTAMM'
      'where (MARA_NR = :GRUNDSORTE)'
      '  and (WERK_NR = :SO_WERK_NR)'
      'order by MARA_NR')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 394
    Top = 425
    ParamData = <
      item
        DataType = ftString
        Name = 'GRUNDSORTE'
      end
      item
        DataType = ftString
        Name = 'SO_WERK_NR'
      end>
  end
  object TblBEIN: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from BELADEEINRICHTUNGEN'
      'where (SO_WERK_NR = :SO_WERK_NR)'
      '  and (BEIN_NR = :BEIN_NR)'
      'order by SO_WERK_NR,'
      '         BEIN_NR')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 534
    Top = 425
    ParamData = <
      item
        DataType = ftString
        Name = 'SO_WERK_NR'
      end
      item
        DataType = ftString
        Name = 'BEIN_NR'
      end>
  end
  object TblDiPr: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from STOERMELDUNGEN'
      'where (BEIN_NR = '#39'SILO_ID'#39')'
      '  and (STME_NR = 111202)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblDiPrBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 643
    Top = 93
  end
  object TblGRSO2: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from GRUNDSORTEN'
      'where (GRSO_ID = :SILO_GRSO2_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 466
    Top = 393
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO_GRSO2_ID'
      end>
  end
  object TblMARA2: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from MATERIALSTAMM'
      'where (MARA_NR = :GRUNDSORTE2)'
      '  and (WERK_NR = :SO_WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 395
    Top = 392
    ParamData = <
      item
        DataType = ftString
        Name = 'GRUNDSORTE2'
      end
      item
        DataType = ftString
        Name = 'SO_WERK_NR'
      end>
  end
  object TblSIST: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where (SILO_ID = :SILO_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 535
    Top = 394
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO_ID'
      end>
  end
  object TblSIST1: TuQuery
    Tag = 1
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where (SILO_ID = 0)')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblSISTxBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 160
    Top = 394
  end
  object TblSIST2: TuQuery
    Tag = 2
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where (SILO_ID = 0)')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblSISTxBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 224
    Top = 394
  end
  object TblSIST3: TuQuery
    Tag = 3
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where (SILO_ID = 0)')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblSISTxBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 288
    Top = 394
  end
  object TblBELA: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from BELADUNGEN'
      'where (SILP1_NR = :SPS_CODE)'
      '  and (BEIN_NR = :BEIN_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblBELABeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 600
    Top = 422
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SPS_CODE'
      end
      item
        DataType = ftString
        Name = 'BEIN_NR'
      end>
  end
  object TblSCHENK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select SILP1_NR as Silo1,'
      '       SILP2_NR as Silo2,'
      '       SILP3_NR as Silo3,'
      '       count(*) as Anzahl,'
      
        '       sum(ISTMENGE-NETTO_GEWICHT-STILLSTAND)/count(*) as Schenk' +
        'Diff'
      'from BELADUNGEN'
      'where ISTMENGE-NETTO_GEWICHT between :MINDIFF and :MAXDIFF'
      'and DATUM >= sysdate-:TAGE'
      'and WERK_NR=:WERK_NR'
      'and BEIN_NR=:BEIN_NR'
      'group by SILP1_NR,SILP2_NR,SILP3_NR')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblSCHENKBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 601
    Top = 392
    ParamData = <
      item
        DataType = ftFloat
        Name = 'MINDIFF'
      end
      item
        DataType = ftFloat
        Name = 'MAXDIFF'
      end
      item
        DataType = ftInteger
        Name = 'TAGE'
      end
      item
        DataType = ftString
        Name = 'WERK_NR'
      end
      item
        DataType = ftString
        Name = 'BEIN_NR'
      end>
  end
  object TblV_LABI_MK: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from V_LABI_MK'
      'where (SILO_NR1 = :SILO_NR)'
      '  and (WERK_NR = :SO_WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 664
    Top = 422
    ParamData = <
      item
        DataType = ftFloat
        Name = 'SILO_NR'
      end
      item
        DataType = ftString
        Name = 'SO_WERK_NR'
      end>
  end
  object LuSILE: TLookUpDef
    AutoEdit = True
    DataSet = TblSILE
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    CalcList.Strings = (
      'cfA1=string:5'
      'cfS1=string:5'
      'cfA2=string:5'
      'cfS2=string:5')
    FormatList.Strings = (
      'SILO_SPS_CODE=000'
      'SPS_CODE=000000000'
      'SIST_KEY=#0.000'
      'STILLSTAND=#0.00')
    KeyList.Strings = (
      'Standard=SIST_KEY')
    PrimaryKeyFields = 'SIST_ID'
    References.Strings = (
      'SILO_ID=:SILO_ID')
    TableName = 'SILOSTELLUNGEN'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    OnGet = LuSISTGet
    Left = 475
    Top = 362
  end
  object TblSILE: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where (SILO_ID = :SILO_ID)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 503
    Top = 362
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SILO_ID'
      end>
  end
  object QueSIST: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from SILOSTELLUNGEN'
      'where SILO_ID=:SILO_ID')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 532
    Top = 362
    ParamData = <
      item
        DataType = ftInteger
        Name = 'SILO_ID'
        Value = Null
      end>
  end
  object LuLAER: TLookUpDef
    DataSet = TblLAER
    LuKurz = 'LAER'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    FormatList.Strings = (
      'P1=0.###'
      'P2=0.###'
      'P3=0.###'
      'P4=0.###'
      'P5=0.###'
      'P6=0.###')
    PrimaryKeyFields = 'LAER_ID'
    References.Strings = (
      'WERK_NR=:SO_WERK_NR'
      'SILO_NR=:SPS_CODE'
      'PROBE_NR=:LABI_PROBE_NR')
    TableName = 'LABI_ERGEBNISSE'
    MasterSource = LDataSource1
    DisabledButtons = [qnbDelete, qnbEdit]
    EnabledButtons = []
    AfterReturn = LuLAERAfterReturn
    Left = 636
    Top = 392
  end
  object TblLAER: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from LABI_ERGEBNISSE'
      'where (WERK_NR = :SO_WERK_NR)'
      '  and (SILO_NR = :SPS_CODE)'
      '  and (PROBE_NR = :LABI_PROBE_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 664
    Top = 392
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SO_WERK_NR'
      end
      item
        DataType = ftUnknown
        Name = 'SPS_CODE'
      end
      item
        DataType = ftUnknown
        Name = 'LABI_PROBE_NR'
      end>
  end
  object LuV_LABI_ERGEBNISSE: TLookUpDef
    DataSet = TblV_LABI_ERGEBNISSE
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
    MDTyp = mdDetail
    FormatList.Strings = (
      'P1=0.###'
      'P2=0.###'
      'P3=0.###'
      'P4=0.###'
      'P5=0.###'
      'P6=0.###')
    KeyList.Strings = (
      'Standard=PROBE_DATUM desc;PROBE_NR desc')
    PrimaryKeyFields = 'WERK_NR;SILO_NR'
    References.Strings = (
      
        'SILO_NR=:cfLABI_SILO_FILTER1;:cfLABI_SILO_FILTER2;:cfLABI_SILO_F' +
        'ILTER3;:cfLABI_SILO_FILTER4'
      'WERK_NR=:SO_WERK_NR')
    TableName = 'V_LAER_HAND'
    MasterSource = LDataSource1
    DisabledButtons = [qnbDelete, qnbEdit]
    EnabledButtons = []
    OnBuildSql = LuV_LABI_ERGEBNISSEBuildSql
    Left = 604
    Top = 364
  end
  object TblV_LABI_ERGEBNISSE: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from V_LAER_HAND'
      
        'where ((SILO_NR = :cfLABI_SILO_FILTER1) or (SILO_NR = :cfLABI_SI' +
        'LO_FILTER2) or (SILO_NR = :cfLABI_SILO_FILTER3)'
      ' or (SILO_NR = :cfLABI_SILO_FILTER4))'
      '  and (WERK_NR = :SO_WERK_NR)')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    BeforeOpen = TblV_LABI_ERGEBNISSEBeforeOpen
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 632
    Top = 364
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'cfLABI_SILO_FILTER1'
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'cfLABI_SILO_FILTER2'
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'cfLABI_SILO_FILTER3'
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'cfLABI_SILO_FILTER4'
        Value = Null
      end
      item
        DataType = ftUnknown
        Name = 'SO_WERK_NR'
        Value = Null
      end>
  end
  object QueSiloSync: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'update SILOLISTE'
      'set LABI_SILO_FILTER=:LABI_SILO_FILTER'
      'where SO_WERK_NR=:SO_WERK_NR'
      'and SPS_CODE=:SPS_CODE')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 326
    Top = 392
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LABI_SILO_FILTER'
      end
      item
        DataType = ftUnknown
        Name = 'SO_WERK_NR'
      end
      item
        DataType = ftUnknown
        Name = 'SPS_CODE'
      end>
  end
  object ProcLABI_TO_SILO: TuStoredProc
    StoredProcName = 'P_SIEBANLAGE.LABI_TO_SILO'
    Connection = DlgLogon.Database1
    DatabaseName = 'DB1'
    Left = 564
    Top = 362
    ParamData = <
      item
        DataType = ftFloat
        Name = 'P_SILO_ID'
        ParamType = ptInput
      end>
    CommandStoredProcName = 'P_SIEBANLAGE.LABI_TO_SILO'
  end
  object QueSILOUpd: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'update SILOLISTE'
      '  set LABI_PROBE_NR=:LABI_PROBE_NR'
      '  where SPS_CODE=:SPS_CODE'
      '  and SILO_NR<>:SILO_NR')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 96
    Top = 424
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LABI_PROBE_NR'
      end
      item
        DataType = ftUnknown
        Name = 'SPS_CODE'
      end
      item
        DataType = ftUnknown
        Name = 'SILO_NR'
      end>
  end
  object QueUpdLabi: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'update SILOLISTE'
      'set LABI_PROBE_NR=:LABI_PROBE_NR'
      'where SPS_CODE=:SPS_CODE'
      'and SO_WERK_NR=:SO_WERK_NR'
      'and SILO_ID <> :SILO_ID')
    MasterSource = LDataSource1
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 352
    Top = 336
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LABI_PROBE_NR'
      end
      item
        DataType = ftUnknown
        Name = 'SPS_CODE'
      end
      item
        DataType = ftUnknown
        Name = 'SO_WERK_NR'
      end
      item
        DataType = ftUnknown
        Name = 'SILO_ID'
      end>
  end
end
