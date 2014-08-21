object DlgKonvert: TDlgKonvert
  Left = 204
  Top = 199
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Zeichenkonvertierung'
  ClientHeight = 241
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BtnTable: TBitBtn
    Left = 112
    Top = 32
    Width = 89
    Height = 33
    Caption = 'Ganze Tabelle'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BtnTableClick
  end
  object BtnRecord: TBitBtn
    Left = 112
    Top = 72
    Width = 89
    Height = 33
    Caption = 'Akt.Datensatz'
    Default = True
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BtnRecordClick
  end
  object ListBox1: TListBox
    Left = 112
    Top = 144
    Width = 97
    Height = 86
    ItemHeight = 13
    Items.Strings = (
      '[Konvertierung]'
      'Dst1=SRC1')
    TabOrder = 2
    Visible = False
  end
  object BtnClose: TBitBtn
    Left = 112
    Top = 112
    Width = 89
    Height = 33
    Cancel = True
    Caption = 'Schlie&'#223'en'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BtnCloseClick
  end
  object chbNum: TCheckBox
    Left = 112
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Numerisch'
    TabOrder = 3
    OnClick = chbNumClick
  end
end
