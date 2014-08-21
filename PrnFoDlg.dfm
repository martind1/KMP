object DlgPrnFont: TDlgPrnFont
  Left = 256
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Druckerauswahl'
  ClientHeight = 173
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 377
    Height = 129
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 16
    Top = 18
    Width = 47
    Height = 16
    Caption = 'Drucker'
  end
  object Label2: TLabel
    Left = 16
    Top = 58
    Width = 96
    Height = 16
    Caption = 'Druckerschriftart'
  end
  object LaFontSize: TLabel
    Left = 16
    Top = 98
    Width = 72
    Height = 16
    Caption = 'Schriftgr'#246#223'e'
  end
  object BtnOK: TBitBtn
    Left = 132
    Top = 145
    Width = 77
    Height = 24
    Caption = '&OK'
    Default = True
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    NumGlyphs = 2
    ParentDoubleBuffered = False
    ParentFont = False
    Spacing = -1
    TabOrder = 0
    IsControl = True
  end
  object BtnCancel: TBitBtn
    Left = 219
    Top = 145
    Width = 77
    Height = 24
    Cancel = True
    Caption = '&Abbruch'
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    ParentFont = False
    Spacing = -1
    TabOrder = 1
    IsControl = True
  end
  object BtnEinrichten: TBitBtn
    Left = 308
    Top = 145
    Width = 77
    Height = 24
    Caption = '&Einrichten'
    DoubleBuffered = True
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    ParentFont = False
    Spacing = -1
    TabOrder = 2
    OnClick = BtnEinrichtenClick
    IsControl = True
  end
  object cobPrinter: TComboBox
    Left = 120
    Top = 16
    Width = 257
    Height = 24
    TabOrder = 3
    OnChange = cobPrinterChange
    OnEnter = cobPrinterEnter
    OnExit = cobPrinterExit
  end
  object cobPrinterFonts: TComboBox
    Left = 120
    Top = 56
    Width = 257
    Height = 24
    Hint = 'Spezielle Schriftart des Druckers'
    TabOrder = 4
  end
  object cobFontSize: TComboBox
    Left = 120
    Top = 96
    Width = 81
    Height = 24
    Hint = 'Spezielle Schriftart des Druckers'
    DropDownCount = 30
    TabOrder = 5
    Items.Strings = (
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24')
  end
end
