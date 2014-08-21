object FrmMenu: TFrmMenu
  Left = 333
  Top = 254
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Hauptmen'#252
  ClientHeight = 328
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 628
    Height = 328
    Align = alClient
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 40
      Top = 168
      Width = 120
      Height = 25
      Caption = '&Kunden Auswertung'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BtnDdeSysInfo: TBitBtn
      Left = 176
      Top = 88
      Width = 101
      Height = 21
      Caption = 'DdeSysInfoDlg'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BtnDdeSysInfoClick
    end
    object BtnZeitDlg: TBitBtn
      Left = 256
      Top = 168
      Width = 120
      Height = 25
      Caption = '&Zeit Dialog'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
      OnClick = BtnZeitDlgClick
    end
    object BtnWSDDE: TBitBtn
      Left = 280
      Top = 120
      Width = 120
      Height = 25
      Caption = 'WSDDE'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = BtnWSDDEClick
    end
  end
  object BtnBein: TButton
    Left = 16
    Top = 58
    Width = 45
    Height = 21
    Caption = '&Bein'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BtnBeinClick
  end
  object BtnWerk: TButton
    Left = 61
    Top = 58
    Width = 48
    Height = 21
    Caption = '&Werk'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = BtnWerkClick
  end
  object BtnTest: TButton
    Left = 109
    Top = 58
    Width = 57
    Height = 21
    Caption = 'Com&Tst'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BtnTestClick
  end
  object BtnAbout: TButton
    Left = 176
    Top = 58
    Width = 37
    Height = 21
    Caption = '&Info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = BtnAboutClick
  end
  object Button3: TButton
    Left = 213
    Top = 58
    Width = 66
    Height = 21
    Caption = 'QrEdit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object BtnErrM: TButton
    Left = 280
    Top = 58
    Width = 49
    Height = 21
    Caption = 'ERRM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = BtnErrMClick
  end
  object BtnComTerm: TButton
    Left = 329
    Top = 58
    Width = 73
    Height = 21
    Caption = 'ComTerm'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = BtnComTermClick
  end
  object BtnBdiErr: TBitBtn
    Left = 402
    Top = 58
    Width = 57
    Height = 21
    Caption = 'BdiErr'
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 8
    OnClick = BtnBdiErrClick
  end
  object BtnDbStru: TButton
    Left = 461
    Top = 58
    Width = 64
    Height = 21
    Caption = 'DB-Stru'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = BtnDbStruClick
  end
  object BtnExport: TButton
    Left = 527
    Top = 58
    Width = 64
    Height = 21
    Caption = 'Export'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = BtnExportClick
  end
  object Button1: TButton
    Left = 280
    Top = 82
    Width = 122
    Height = 21
    Caption = 'Com Zwischen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = Button1Click
  end
end
