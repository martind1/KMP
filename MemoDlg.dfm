object DlgMemo: TDlgMemo
  Left = 287
  Top = 322
  BorderIcons = []
  Caption = 'Eingabe'
  ClientHeight = 226
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Panel1'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 191
    Width = 550
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnOK: TBitBtn
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      Layout = blGlyphTop
      Margin = 2
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 181
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Abbruch'
      Layout = blGlyphTop
      Margin = 2
      ModalResult = 2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 25
    Width = 550
    Height = 166
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
