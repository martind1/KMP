object DlgInitAsk: TDlgInitAsk
  Left = 599
  Top = 318
  Width = 352
  Height = 495
  Caption = 'Abfrage Section Typ'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 15
  object gbSection: TGroupBox
    Left = 0
    Top = 0
    Width = 344
    Height = 320
    Align = alClient
    Caption = 'Section [%s]'
    TabOrder = 0
    object lbEntries: TListBox
      Left = 2
      Top = 17
      Width = 340
      Height = 301
      Align = alClient
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object rgTyp: TRadioGroup
    Left = 0
    Top = 320
    Width = 344
    Height = 117
    Align = alBottom
    Caption = 'Typ'
    ItemIndex = 2
    Items.Strings = (
      'Anwendung'
      'Maschine'
      'User'
      'Vorgabe')
    TabOrder = 1
    OnClick = EditChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 437
    Width = 344
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object BtnOK: TBitBtn
      Left = 83
      Top = 3
      Width = 77
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      NumGlyphs = 2
      Spacing = -1
    end
    object BtnCancel: TBitBtn
      Left = 265
      Top = 3
      Width = 77
      Height = 27
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Abbrechen'
      ModalResult = 2
      TabOrder = 2
      NumGlyphs = 2
      Spacing = -1
    end
    object btnIgnore: TBitBtn
      Left = 175
      Top = 3
      Width = 77
      Height = 27
      Hint = 'nicht speichern'
      Anchors = [akTop, akRight]
      Caption = 'Ignorieren'
      ModalResult = 5
      TabOrder = 1
    end
  end
end
