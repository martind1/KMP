object Form1: TForm1
  Left = 245
  Top = 150
  Width = 435
  Height = 300
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object LaFileDatetime1: TLabel
    Left = 72
    Top = 80
    Width = 76
    Height = 13
    Caption = 'LaFileDatetime1'
  end
  object LaFiledate1: TLabel
    Left = 72
    Top = 48
    Width = 55
    Height = 13
    Caption = 'LaFiledate1'
  end
  object LaFiledate2: TLabel
    Left = 72
    Top = 120
    Width = 55
    Height = 13
    Caption = 'LaFiledate2'
  end
  object LaFileDatetime2: TLabel
    Left = 72
    Top = 152
    Width = 76
    Height = 13
    Caption = 'LaFileDatetime2'
  end
  object LaFatDate1: TLabel
    Left = 72
    Top = 64
    Width = 56
    Height = 13
    Caption = 'LaFatDate1'
  end
  object LaFatDate2: TLabel
    Left = 72
    Top = 136
    Width = 56
    Height = 13
    Caption = 'LaFatDate2'
  end
  object LaFiledateb1: TLabel
    Left = 240
    Top = 48
    Width = 61
    Height = 13
    Caption = 'LaFiledateb1'
  end
  object LaFiledateb2: TLabel
    Left = 240
    Top = 120
    Width = 61
    Height = 13
    Caption = 'LaFiledateb2'
  end
  object Edit1: TEdit
    Left = 72
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 
      'c:\Mailbox\Innotec\Pieper\Mark mobol Rohr explodiert\Mark mobol ' +
      'Rohr explodiert.VSD'
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 240
    Width = 75
    Height = 25
    Caption = 'NextTab 5'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Edit2: TEdit
    Left = 72
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 
      'c:\Mailbox\Innotec\Pieper\Winkler\Mark mobol Rohr explodiert\Mar' +
      'k mobol Rohr explodiert.VSD'
  end
  object BitBtn2: TBitBtn
    Left = 160
    Top = 232
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object BtnBeep: TButton
    Left = 296
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Beep'
    TabOrder = 4
    OnClick = BtnBeepClick
  end
  object BtnTimeToStr: TButton
    Left = 224
    Top = 168
    Width = 75
    Height = 25
    Caption = 'BtnTimeToStr'
    TabOrder = 5
    OnClick = BtnTimeToStrClick
  end
end
