object Form1: TForm1
  Left = 978
  Top = 464
  Caption = 'Projekt6 Ringbuffer'
  ClientHeight = 280
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 64
    Width = 26
    Height = 13
    Caption = 'Value'
  end
  object Label2: TLabel
    Left = 16
    Top = 96
    Width = 30
    Height = 13
    Caption = 'Buffer'
  end
  object BtnPushFirst: TBitBtn
    Left = 8
    Top = 24
    Width = 75
    Height = 25
    Caption = 'PushFirst'
    TabOrder = 0
    OnClick = BtnPushFirstClick
  end
  object BtnAvg: TBitBtn
    Left = 88
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Avg'
    TabOrder = 1
    OnClick = BtnAvgClick
  end
  object EdValue: TEdit
    Left = 56
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'EdValue'
  end
  object Memo1: TMemo
    Left = 56
    Top = 96
    Width = 121
    Height = 153
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
