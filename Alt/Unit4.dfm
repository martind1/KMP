object Form1: TForm1
  Left = 563
  Top = 453
  Caption = 'Form1'
  ClientHeight = 380
  ClientWidth = 1161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object Edit1: TEdit
    Left = 128
    Top = 16
    Width = 417
    Height = 21
    TabOrder = 1
    Text = 'd:\Mailbox\QwFrech\Sap_Oracle\Polen 2011\O_002_0000000010745721'
  end
  object Edit2: TEdit
    Left = 128
    Top = 56
    Width = 417
    Height = 21
    TabOrder = 2
    Text = 
      'd:\Mailbox\QwFrech\Sap_Oracle\Polen 2011\O_002_0000000010745721.' +
      '1250.txt'
  end
  object BitBtn2: TBitBtn
    Left = 24
    Top = 56
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 87
    Width = 1161
    Height = 293
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 4
  end
end
