object DlgChange: TDlgChange
  Left = 263
  Top = 115
  BorderStyle = bsDialog
  Caption = 'DlgChange'
  ClientHeight = 143
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 300
    Height = 97
    Shape = bsFrame
    IsControl = True
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 47
    Height = 13
    Caption = 'Gesamt:'
  end
  object LaGesamt: TLabel
    Left = 95
    Top = 24
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = '12.345'
  end
  object Label3: TLabel
    Left = 143
    Top = 24
    Width = 65
    Height = 13
    Caption = 'Datensätze'
  end
  object Gauge1: TGauge
    Left = 24
    Top = 40
    Width = 273
    Height = 32
    ForeColor = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Progress = 50
  end
  object Label4: TLabel
    Left = 24
    Top = 76
    Width = 63
    Height = 13
    Caption = 'Bearbeitet:'
  end
  object LaBearbeitet: TLabel
    Left = 95
    Top = 76
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Caption = '12.345'
  end
  object Label6: TLabel
    Left = 143
    Top = 76
    Width = 65
    Height = 13
    Caption = 'Datensätze'
  end
  object LaNoTrans: TLabel
    Left = 207
    Top = 120
    Width = 100
    Height = 13
    Caption = 'ohne Transaktion'
  end
  object CancelBtn: TBitBtn
    Left = 8
    Top = 112
    Width = 77
    Height = 27
    Cancel = True
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 0
    OnClick = CancelBtnClick
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
end
