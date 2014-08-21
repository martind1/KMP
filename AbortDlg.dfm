object DlgAbort: TDlgAbort
  Left = 263
  Top = 115
  BorderStyle = bsDialog
  Caption = 'DlgAbort'
  ClientHeight = 114
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 300
    Height = 63
    Style = bsRaised
    IsControl = True
  end
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 273
    Height = 27
    AutoSize = False
    Caption = 
      'sdsdsdsd sd sdsdds sddssd dsds dsdsds sdsdds sddsds dsadssd sdds' +
      'sdsdsd sdsddsds dssdsdds sdsddssdsd dssdsdsdds dsdssdsd sddssdds' +
      'ds 2323 32322323 '
    WordWrap = True
  end
  object LaStatus: TLabel
    Left = 104
    Top = 88
    Width = 201
    Height = 13
    AutoSize = False
    Caption = 'Zeitdauer %s / %s'
  end
  object Gauge1: TGauge
    Left = 24
    Top = 45
    Width = 273
    Height = 21
    ForeColor = clBlue
    Progress = 50
    Visible = False
  end
  object CancelBtn: TBitBtn
    Left = 8
    Top = 80
    Width = 85
    Height = 27
    Cancel = True
    Caption = '&Abbruch'
    ModalResult = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
    OnClick = CancelBtnClick
    IsControl = True
  end
end
