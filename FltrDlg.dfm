object DlgFltr: TDlgFltr
  Left = 1104
  Top = 482
  ActiveControl = EdName
  BorderStyle = bsDialog
  Caption = 'Abfrage speichern'
  ClientHeight = 182
  ClientWidth = 302
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
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 103
    Height = 15
    Caption = '&Name der Abfrage:'
    FocusControl = EdName
  end
  object LaUsers: TLabel
    Left = 8
    Top = 88
    Width = 48
    Height = 15
    Caption = 'Benutzer'
  end
  object LaUsersHelp: TLabel
    Left = 112
    Top = 73
    Width = 127
    Height = 12
    Caption = 'mehrere Namen mit '#39';'#39' trennen'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object cobUsers: TComboBox
    Left = 66
    Top = 86
    Width = 223
    Height = 23
    TabOrder = 6
    Text = 'cobUsers'
    OnChange = cobUsersChange
    OnDropDown = cobUsersDropDown
  end
  object EdName: TEdit
    Left = 8
    Top = 27
    Width = 281
    Height = 23
    TabOrder = 0
    OnChange = EdNameChange
  end
  object BtnOK: TBitBtn
    Left = 130
    Top = 147
    Width = 77
    Height = 27
    Caption = '&OK'
    Default = True
    ModalResult = 1
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
  end
  object BtnCancel: TBitBtn
    Left = 216
    Top = 147
    Width = 77
    Height = 27
    Cancel = True
    Caption = '&Abbrechen'
    ModalResult = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 3
  end
  object chbIsPublic: TCheckBox
    Left = 8
    Top = 64
    Width = 72
    Height = 17
    Hint = 'f'#252'r alle sichtbar'
    Alignment = taLeftJustify
    Caption = '&'#214'ffentlich'
    TabOrder = 1
    OnClick = chbIsPublicClick
  end
  object chbColumnList: TCheckBox
    Left = 8
    Top = 120
    Width = 130
    Height = 17
    Hint = 'f'#252'r alle sichtbar'
    Alignment = taLeftJustify
    Caption = 'mit &Tabellenlayout'
    TabOrder = 4
    Visible = False
  end
  object EdUSERS: TEdit
    Left = 66
    Top = 86
    Width = 206
    Height = 23
    TabOrder = 5
    Text = 'EdUSERS'
    OnChange = EdUSERSChange
  end
end
