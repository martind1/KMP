object Form1: TForm1
  Left = 786
  Top = 102
  Caption = 'Zeichencodes'
  ClientHeight = 581
  ClientWidth = 165
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 165
    Height = 42
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object BtnZeichen: TBitBtn
      Left = 0
      Top = 0
      Width = 67
      Height = 21
      Hint = 'Kopieren'
      Caption = '&Zeichen'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      TabStop = False
      OnClick = BtnZeichenClick
    end
    object BtnCode: TBitBtn
      Left = 67
      Top = 0
      Width = 67
      Height = 21
      Hint = 'Kopieren'
      Caption = '&Code'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      TabStop = False
      OnClick = BtnCodeClick
    end
    object EdZeichen: TEdit
      Left = 0
      Top = 20
      Width = 66
      Height = 21
      TabOrder = 2
      OnChange = EdZeichenChange
    end
    object EdCode: TEdit
      Left = 66
      Top = 20
      Width = 67
      Height = 21
      TabOrder = 3
      OnChange = EdCodeChange
    end
    object BtnFont: TBitBtn
      Left = 136
      Top = 0
      Width = 29
      Height = 41
      Hint = 'Font '#228'ndern'
      Caption = '&Font'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = []
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333FF3FFFFFFF3FFFF003000000030
        0000773777777737777703330030033300037FFF77F77FFF7773700007330000
        003377777733777777F3303003330030003337F77F3377F77733303073333030
        033337F77F3337F77F3337007333300003333777733337777333330033333000
        33333377F3333777F33333073333330033333377333333773333333333333333
        33333333FF333333FF33333973333337933333377FF333377F33333999333399
        93333337773333777F333339933333399333333773FF33377F33333939733793
        93333337377FF773733333333399993333333333337777333333}
      Layout = blGlyphBottom
      NumGlyphs = 2
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 4
      TabStop = False
      OnClick = BtnFontClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    OnApply = FontDialog1Apply
    Left = 104
    Top = 72
  end
end
