object DlgIniSearch: TDlgIniSearch
  Left = 719
  Top = 476
  BorderStyle = bsDialog
  Caption = 'Suchen'
  ClientHeight = 154
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object Label2: TLabel
    Left = 8
    Top = 10
    Width = 72
    Height = 15
    Caption = 'Suchen nach'
  end
  object EdValue: TEdit
    Left = 96
    Top = 8
    Width = 257
    Height = 23
    TabOrder = 0
  end
  object BtnOK: TBitBtn
    Left = 366
    Top = 8
    Width = 95
    Height = 27
    Caption = 'Weitersuchen'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = BtnOKClick
    NumGlyphs = 2
    Spacing = -1
  end
  object BtnCancel: TBitBtn
    Left = 366
    Top = 43
    Width = 95
    Height = 27
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 4
    NumGlyphs = 2
    Spacing = -1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 40
    Width = 345
    Height = 84
    Caption = 'Suchoptionen'
    TabOrder = 1
    object chbSection: TCheckBox
      Left = 8
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Section'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chbParameter: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Parameter'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chbWert: TCheckBox
      Left = 8
      Top = 60
      Width = 97
      Height = 17
      Caption = 'Wert'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object chbExact: TCheckBox
    Left = 8
    Top = 132
    Width = 206
    Height = 17
    Caption = 'Ganze Zeichenfolge vergleichen'
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 384
    Top = 88
    object MiFindNext: TMenuItem
      Caption = 'Weitersuchen'
      ShortCut = 114
      OnClick = BtnOKClick
    end
  end
end
