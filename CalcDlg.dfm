object DlgCalc: TDlgCalc
  Left = 530
  Top = 246
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Rechner'
  ClientHeight = 424
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object Panel1: TPanel
    Left = 0
    Top = 251
    Width = 209
    Height = 173
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Btn7: TSpeedButton
      Tag = 55
      Left = 8
      Top = 44
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn8: TSpeedButton
      Tag = 56
      Left = 48
      Top = 44
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '8'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn4: TSpeedButton
      Tag = 52
      Left = 8
      Top = 76
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn9: TSpeedButton
      Tag = 57
      Left = 88
      Top = 44
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn5: TSpeedButton
      Tag = 53
      Left = 48
      Top = 76
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn6: TSpeedButton
      Tag = 54
      Left = 88
      Top = 76
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn1: TSpeedButton
      Tag = 49
      Left = 8
      Top = 108
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn2: TSpeedButton
      Tag = 50
      Left = 48
      Top = 108
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn3: TSpeedButton
      Tag = 51
      Left = 88
      Top = 108
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object Btn0: TSpeedButton
      Tag = 48
      Left = 8
      Top = 140
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnPlusMinus: TSpeedButton
      Tag = 177
      Left = 48
      Top = 140
      Width = 35
      Height = 27
      Hint = 'F9: Vorzeichen umkehren'
      AllowAllUp = True
      GroupIndex = 311
      Caption = #177
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnKomma: TSpeedButton
      Tag = 11
      Left = 88
      Top = 140
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = ','
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnClear: TSpeedButton
      Tag = 16
      Left = 168
      Top = 44
      Width = 35
      Height = 27
      Hint = 'Entf: Eingabe l'#246'schen'
      AllowAllUp = True
      GroupIndex = 311
      Caption = 'C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentFont = False
      Spacing = -1
      OnClick = BtnClick
      IsControl = True
    end
    object BtnDiv: TSpeedButton
      Tag = 12
      Left = 128
      Top = 44
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '/'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnMul: TSpeedButton
      Tag = 13
      Left = 128
      Top = 76
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Spacing = -1
      OnClick = BtnClick
    end
    object BtnPlus: TSpeedButton
      Tag = 15
      Left = 128
      Top = 140
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnMinus: TSpeedButton
      Tag = 14
      Left = 128
      Top = 108
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnGleich: TSpeedButton
      Tag = 17
      Left = 168
      Top = 140
      Width = 35
      Height = 27
      AllowAllUp = True
      GroupIndex = 311
      Caption = '='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BtnClick
    end
    object BtnOK: TBitBtn
      Left = 168
      Top = 108
      Width = 35
      Height = 27
      Hint = 'Enter: '#220'bernehmen'
      Caption = 'OK'
      Default = True
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphRight
      ModalResult = 1
      ParentDoubleBuffered = False
      ParentFont = False
      Spacing = 1
      TabOrder = 0
      OnClick = BtnOKClick
      IsControl = True
    end
    object BtnEsc: TBitBtn
      Left = 168
      Top = 76
      Width = 35
      Height = 27
      Hint = 'Abbruch'
      Cancel = True
      Caption = 'Esc'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Layout = blGlyphTop
      ModalResult = 2
      NumGlyphs = 2
      ParentDoubleBuffered = False
      ParentFont = False
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
    object EdCalc: TEdit
      Left = 8
      Top = 8
      Width = 193
      Height = 28
      ReadOnly = True
      TabOrder = 2
      Text = '1234567890,1234567890'
    end
  end
  object MemoHist: TMemo
    Left = 0
    Top = 0
    Width = 209
    Height = 251
    Align = alClient
    Alignment = taRightJustify
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
