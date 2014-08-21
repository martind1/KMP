object DlgIni: TDlgIni
  Left = 412
  Top = 236
  Width = 412
  Height = 211
  BorderIcons = [biSystemMenu]
  Caption = 'Parametereingabe'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 389
    Height = 137
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 236
    Height = 13
    Caption = 'In der Konfigurationsdatei fehlt ein benötigter Wert'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 44
    Height = 13
    Caption = 'Abschnitt'
    WordWrap = True
  end
  object LaSection: TLabel
    Left = 88
    Top = 64
    Width = 42
    Height = 13
    Caption = '[Section]'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 48
    Height = 13
    Caption = 'Parameter'
    WordWrap = True
  end
  object LaIdent: TLabel
    Left = 88
    Top = 88
    Width = 24
    Height = 13
    Caption = 'Ident'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 16
    Top = 40
    Width = 25
    Height = 13
    Caption = 'Datei'
    WordWrap = True
  end
  object LaFileName: TLabel
    Left = 88
    Top = 40
    Width = 44
    Height = 13
    Caption = 'FileName'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 16
    Top = 112
    Width = 23
    Height = 13
    Caption = 'Wert'
    WordWrap = True
  end
  object EdValue: TEdit
    Left = 88
    Top = 110
    Width = 276
    Height = 21
    TabOrder = 0
  end
  object BtnValue: TBitBtn
    Left = 365
    Top = 110
    Width = 21
    Height = 21
    TabOrder = 1
    OnClick = BtnValueClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
  end
  object BtnOK: TBitBtn
    Left = 220
    Top = 152
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 300
    Top = 152
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object OpenDialog1: TOpenDialog
    Title = 'Wert'
    Left = 308
    Top = 78
  end
end
