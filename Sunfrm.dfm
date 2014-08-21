object FrmSPS: TFrmSPS
  Left = 496
  Top = 229
  Caption = 'Steuerung'
  ClientHeight = 300
  ClientWidth = 406
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 16
    Top = 0
    Width = 377
    Height = 121
    Caption = 'Eingangswaage'
    TabOrder = 0
    object rgConnectEin: TRadioGroup
      Left = 16
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Verbindung'
      Items.Strings = (
        'PC 1'
        'PC 2')
      TabOrder = 0
      Visible = False
    end
    object rgWaEinAmEin: TRadioGroup
      Tag = 1
      Left = 136
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Einfahrtampel'
      ItemIndex = 0
      Items.Strings = (
        '&Rot'
        '&Gr'#252'n')
      TabOrder = 1
      OnClick = rgAmpelClick
    end
    object rgWaEinAmAus: TRadioGroup
      Tag = 2
      Left = 256
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Ausfahrtampel'
      ItemIndex = 0
      Items.Strings = (
        '&Rot'
        '&Gr'#252'n')
      TabOrder = 2
      OnClick = rgAmpelClick
    end
  end
  object GroupBox2: TGroupBox
    Tag = 1
    Left = 16
    Top = 128
    Width = 377
    Height = 121
    Caption = 'Ausgangswaage'
    TabOrder = 1
    object rgConnectAus: TRadioGroup
      Left = 16
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Verbindung'
      Items.Strings = (
        'PC 1'
        'PC 2')
      TabOrder = 0
      Visible = False
    end
    object rgWaAusAmEin: TRadioGroup
      Tag = 1
      Left = 136
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Einfahrtampel'
      ItemIndex = 0
      Items.Strings = (
        '&Rot'
        '&Gr'#252'n')
      TabOrder = 1
      OnClick = rgAmpelClick
    end
    object rgWaAusAmAus: TRadioGroup
      Tag = 2
      Left = 256
      Top = 24
      Width = 105
      Height = 81
      Caption = 'Ausfahrtampel'
      ItemIndex = 0
      Items.Strings = (
        '&Rot'
        '&Gr'#252'n')
      TabOrder = 2
      OnClick = rgAmpelClick
    end
  end
  object BtnClose: TBitBtn
    Tag = 2
    Left = 304
    Top = 257
    Width = 89
    Height = 33
    Caption = '&Schlie'#223'en'
    DoubleBuffered = True
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BtnCloseClick
  end
end
