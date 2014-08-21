object Form1: TForm1
  Left = 296
  Top = 521
  Caption = 'Form1'
  ClientHeight = 377
  ClientWidth = 564
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
    Left = 32
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object Memo1: TMemo
    Left = 32
    Top = 64
    Width = 489
    Height = 297
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ComboBox1: TComboBox
    Left = 232
    Top = 16
    Width = 145
    Height = 22
    Style = csOwnerDrawFixed
    TabOrder = 2
    OnDrawItem = ComboBox1DrawItem
    OnSelect = ComboBox1Select
    Items.Strings = (
      'Item 1'
      'Item 2'
      'Item 3'
      'Item 4')
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 480
    Top = 24
  end
end
