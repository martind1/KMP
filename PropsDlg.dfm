object DlgProps: TDlgProps
  Left = 536
  Top = 221
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Eigenschaften f'#252'r %s'
  ClientHeight = 369
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 333
    Width = 498
    Height = 36
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 362
    object PanRight: TPanel
      Left = 412
      Top = 1
      Width = 85
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnClose: TBitBtn
        Left = 1
        Top = 6
        Width = 80
        Height = 24
        Cancel = True
        Caption = '&Schlie'#223'en'
        DoubleBuffered = True
        ModalResult = 1
        NumGlyphs = 2
        ParentDoubleBuffered = False
        Spacing = -1
        TabOrder = 0
        IsControl = True
      end
    end
    object lbS: TListBox
      Left = 16
      Top = 0
      Width = 121
      Height = 35
      Items.Strings = (
        'Anzahl Datens'#228'tze'
        'Datenbankparameter'
        'Felder'
        'Indizes'
        'SQL'
        'Datenbank')
      TabOrder = 1
      Visible = False
    end
  end
  object Outline1: TOutline
    Left = 0
    Top = 0
    Width = 498
    Height = 333
    Lines.Nodes = (
      'Test1'
      #9'Item1'
      #9'Item2'
      'Test2'
      'Test3')
    OutlineStyle = osPlusMinusText
    OnExpand = Outline1Expand
    ItemHeight = 16
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    ItemSeparator = '\'
    ParentFont = False
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 341
    object MiSort: TMenuItem
      Caption = 'Sortiert'
      OnClick = MiSortClick
    end
    object MiCopy: TMenuItem
      Caption = 'Kopieren'
      OnClick = MiCopyClick
    end
  end
end
