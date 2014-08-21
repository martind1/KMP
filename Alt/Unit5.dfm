object Form5: TForm5
  Left = 460
  Top = 515
  Caption = 'Form5'
  ClientHeight = 259
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOpen: TBitBtn
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Open'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BtnOpenClick
  end
  object Edit1: TEdit
    Left = 96
    Top = 8
    Width = 393
    Height = 21
    TabOrder = 1
    Text = 
      'd:\Mailbox\QwFrech\Logs Polen\Waagen\Osiecznica\WAGAOS_brutto426' +
      '.LOG'
  end
  object Edit2: TEdit
    Left = 96
    Top = 40
    Width = 393
    Height = 21
    TabOrder = 2
    Text = 
      'd:\Mailbox\QwFrech\Logs Polen\Waagen\Osiecznica\WAGAOS_brutto426' +
      '.LOG.asc'
  end
  object BtnSave: TBitBtn
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Save'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BtnSaveClick
  end
  object BtnStrToIntTol: TBitBtn
    Left = 16
    Top = 88
    Width = 113
    Height = 25
    Caption = 'BtnStrToIntTol'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BtnStrToIntTolClick
  end
  object EdSrc: TEdit
    Left = 152
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'A-1B'
  end
  object EdDest: TEdit
    Left = 288
    Top = 88
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 6
    Text = 'EdDest'
  end
end
