object DlgPass: TDlgPass
  Left = 245
  Top = 120
  ActiveControl = EdPassword
  BorderStyle = bsDialog
  Caption = 'Paﬂwort ƒndern'
  ClientHeight = 151
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 147
    Height = 13
    Caption = 'Neues Paﬂwort eingeben:'
  end
  object Label2: TLabel
    Left = 8
    Top = 61
    Width = 154
    Height = 13
    Caption = 'Neues Paﬂwort best‰tigen:'
  end
  object EdPassword: TEdit
    Left = 8
    Top = 27
    Width = 220
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = EdPasswordChange
  end
  object BtnOK: TBitBtn
    Left = 66
    Top = 115
    Width = 77
    Height = 27
    TabOrder = 2
    Kind = bkOK
    Margin = 2
    Spacing = -1
  end
  object BtnCancel: TBitBtn
    Left = 152
    Top = 115
    Width = 77
    Height = 27
    TabOrder = 3
    Kind = bkCancel
    Margin = 2
    Spacing = -1
  end
  object EdPassword2: TEdit
    Left = 8
    Top = 75
    Width = 220
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnChange = EdPasswordChange
  end
end
