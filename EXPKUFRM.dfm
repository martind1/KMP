object FrmExpKu: TFrmExpKu
  Left = 354
  Top = 110
  Caption = 'SUN Export Kunden'
  ClientHeight = 465
  ClientWidth = 532
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 133
    Height = 16
    Alignment = taRightJustify
    Caption = 'Letzte '#196'nderung von'
  end
  object Label2: TLabel
    Left = 129
    Top = 48
    Width = 20
    Height = 16
    Caption = 'bis'
  end
  object Label3: TLabel
    Left = 16
    Top = 248
    Width = 57
    Height = 16
    Caption = 'Protokoll'
  end
  object Label4: TLabel
    Left = 2
    Top = 112
    Width = 147
    Height = 16
    Alignment = taRightJustify
    Caption = 'Names and Addresses'
  end
  object LaStatus: TLabel
    Left = 16
    Top = 440
    Width = 97
    Height = 16
    Caption = 'Warte auf Start'
  end
  object Label5: TLabel
    Left = 89
    Top = 82
    Width = 60
    Height = 16
    Alignment = taRightJustify
    Caption = 'EDV-Knz.'
  end
  object Label6: TLabel
    Left = 37
    Top = 136
    Width = 112
    Height = 16
    Alignment = taRightJustify
    Caption = 'Chart of Accounts'
  end
  object Label7: TLabel
    Left = 36
    Top = 160
    Width = 113
    Height = 16
    Alignment = taRightJustify
    Caption = 'Address Analysis'
  end
  object Label8: TLabel
    Left = 248
    Top = 83
    Width = 230
    Height = 14
    Caption = 'I=Importiert; G=Ge'#228'ndert; E=Erfa'#223't; X=Exportiert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 60
    Top = 184
    Width = 89
    Height = 16
    Alignment = taRightJustify
    Caption = 'Zahlung Tage'
  end
  object BtnClose: TBitBtn
    Tag = 2
    Left = 440
    Top = 425
    Width = 89
    Height = 33
    Caption = 'Schlie'#223'en'
    DoubleBuffered = True
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BtnCloseClick
  end
  object EdVon: TEdit
    Left = 168
    Top = 14
    Width = 129
    Height = 24
    TabOrder = 0
    Text = '01.01.1980'
  end
  object EdBis: TEdit
    Left = 168
    Top = 46
    Width = 129
    Height = 24
    TabOrder = 2
  end
  object BtnStart: TBitBtn
    Tag = 2
    Left = 342
    Top = 425
    Width = 89
    Height = 33
    Caption = 'Start'
    DoubleBuffered = True
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 9
    OnClick = BtnStartClick
  end
  object lbProt: TListBox
    Left = 96
    Top = 240
    Width = 433
    Height = 169
    Items.Strings = (
      '')
    TabOrder = 7
  end
  object EdFnAddr: TEdit
    Left = 168
    Top = 110
    Width = 209
    Height = 24
    TabOrder = 4
  end
  object EdEdv: TEdit
    Left = 168
    Top = 80
    Width = 65
    Height = 24
    TabOrder = 3
  end
  object EdFnAcc: TEdit
    Left = 168
    Top = 134
    Width = 209
    Height = 24
    TabOrder = 5
  end
  object EdFnAdAc: TEdit
    Left = 168
    Top = 158
    Width = 209
    Height = 24
    TabOrder = 6
  end
  object EdZtTage: TEdit
    Left = 168
    Top = 182
    Width = 41
    Height = 24
    TabOrder = 8
  end
end
