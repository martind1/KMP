object FrmProtToHex: TFrmProtToHex
  Left = 469
  Top = 572
  Width = 489
  Height = 130
  Caption = 'Prot To Hex'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 49
    Height = 13
    Caption = '&Prot String'
  end
  object Label2: TLabel
    Left = 8
    Top = 66
    Width = 49
    Height = 13
    Caption = '&Hex String'
  end
  object EdProt: TEdit
    Left = 72
    Top = 8
    Width = 401
    Height = 21
    TabOrder = 0
    Text = 'EdProt'
  end
  object EdHex: TEdit
    Left = 72
    Top = 64
    Width = 401
    Height = 21
    TabOrder = 2
    Text = 'EdHex'
  end
  object BtnStart: TBitBtn
    Left = 8
    Top = 32
    Width = 75
    Height = 25
    Caption = '&Start'
    TabOrder = 1
    OnClick = BtnStartClick
  end
end
