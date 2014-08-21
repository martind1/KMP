object FrmStart: TFrmStart
  Left = 250
  Top = 134
  Width = 492
  Height = 167
  Caption = 'Batchmode Controller'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 48
    Width = 44
    Height = 16
    Caption = 'Handle'
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 16
    Caption = 'Aufruf'
  end
  object EdAufruf: TEdit
    Left = 76
    Top = 14
    Width = 397
    Height = 24
    TabOrder = 0
  end
  object BtnStart: TButton
    Left = 16
    Top = 96
    Width = 89
    Height = 33
    Caption = '&Start'
    Default = True
    TabOrder = 2
    OnClick = BtnStartClick
  end
  object EdHandle: TEdit
    Left = 76
    Top = 46
    Width = 93
    Height = 24
    TabOrder = 1
  end
end
