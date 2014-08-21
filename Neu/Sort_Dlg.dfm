object DlgSort: TDlgSort
  Left = 450
  Top = 125
  ActiveControl = lbKeys
  BorderStyle = bsDialog
  Caption = 'Sortierung'
  ClientHeight = 349
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClick = lbKeysClick
  OnCreate = FormCreate
  OnDblClick = lbKeysDblClick
  OnDestroy = FormDestroy
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 16
  object KeyLabel: TLabel
    Left = 10
    Top = 10
    Width = 181
    Height = 20
    AutoSize = False
    Caption = 'Sortierschl'#252'ssel'
    IsControl = True
  end
  object OKBtn: TBitBtn
    Left = 3
    Top = 311
    Width = 96
    Height = 34
    Kind = bkOK
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
    IsControl = True
  end
  object CancelBtn: TBitBtn
    Left = 108
    Top = 311
    Width = 96
    Height = 34
    Kind = bkCancel
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
    IsControl = True
  end
  object lbKeys: TCheckListBox
    Left = 10
    Top = 30
    Width = 184
    Height = 231
    Items.Strings = (
      'Eintrag1'
      'Eintrag2'
      'Eintrag3'
      'Eintrag4'
      'Eintrag5')
    TabOrder = 2
    OnClick = lbKeysClick
    OnDblClick = lbKeysDblClick
    IsControl = True
  end
  object chbAbsteigend: TCheckBox
    Left = 10
    Top = 265
    Width = 97
    Height = 17
    Caption = 'Absteigend'
    Enabled = False
    TabOrder = 3
    OnClick = chbAbsteigendClick
  end
  object chbPermanent: TCheckBox
    Left = 114
    Top = 265
    Width = 83
    Height = 17
    Hint = 'diese Sortierung zuk'#252'nftig beibehalten'
    Caption = 'Permanent'
    Enabled = False
    TabOrder = 4
    OnClick = chbAbsteigendClick
  end
  object chbGotoPos: TCheckBox
    Left = 10
    Top = 285
    Width = 97
    Height = 17
    Hint = 'Positionierung beibehalten'
    Caption = 'Positionieren'
    TabOrder = 5
  end
end
