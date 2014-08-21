object DlgAbout: TDlgAbout
  Left = 192
  Top = 32
  ActiveControl = BitBtn1
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Info'
  ClientHeight = 467
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 5
    Top = 5
    Width = 549
    Height = 143
    BevelInner = bvLowered
    BevelWidth = 2
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 12
      Top = 12
      Width = 136
      Height = 121
      Picture.Data = {
        07544269746D617036050000424D360500000000000036040000280000001000
        0000100000000100080000000000000100000000000000000000000100000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000C0DCC000F0C8A40000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000F0FBFF00A4A0
        A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        070707070707070000000000000707070707070707000000FFFFFFFF00000007
        070707070000FFFFFFFCFCFFFFFF00000707070000FFFFFFFCFCFCFCFFFFFF00
        0007070000FFFFFFFCFCFCFCFFFFFF00000707070000FFFFFFFCFCFFFFFF0000
        0707070707000000FFFFFFFF0000000707070707070707000000000000070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707}
      Stretch = True
      IsControl = True
    end
  end
  object Panel2: TPanel
    Left = 5
    Top = 148
    Width = 549
    Height = 63
    BevelInner = bvLowered
    BevelWidth = 2
    TabOrder = 1
    object Label8: TLabel
      Left = 56
      Top = 12
      Width = 65
      Height = 16
      Caption = 'Benutzer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label10: TLabel
      Left = 56
      Top = 33
      Width = 44
      Height = 16
      Caption = 'Firma:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object UserName: TLabel
      Left = 239
      Top = 12
      Width = 66
      Height = 16
      Caption = 'UserName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object CompanyName: TLabel
      Left = 239
      Top = 33
      Width = 95
      Height = 16
      Caption = 'CompanyName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
  end
  object Panel3: TPanel
    Left = 5
    Top = 207
    Width = 549
    Height = 107
    BevelInner = bvLowered
    BevelWidth = 2
    TabOrder = 2
    object Label1: TLabel
      Left = 56
      Top = 55
      Width = 124
      Height = 16
      Caption = 'Windows Version:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label2: TLabel
      Left = 56
      Top = 76
      Width = 94
      Height = 16
      Caption = 'DOS Version:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label3: TLabel
      Left = 56
      Top = 33
      Width = 92
      Height = 16
      Caption = 'Koprozessor:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label4: TLabel
      Left = 56
      Top = 12
      Width = 36
      Height = 16
      Caption = 'CPU:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object WinVersion: TLabel
      Left = 239
      Top = 55
      Width = 67
      Height = 16
      Caption = 'Winversion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object DosVersion: TLabel
      Left = 239
      Top = 76
      Width = 71
      Height = 16
      Caption = 'DosVersion'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object Coprocessor: TLabel
      Left = 239
      Top = 33
      Width = 77
      Height = 16
      Caption = 'Coprozessor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object CPU: TLabel
      Left = 239
      Top = 12
      Width = 28
      Height = 16
      Caption = 'CPU'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
  end
  object Panel4: TPanel
    Left = 5
    Top = 310
    Width = 549
    Height = 86
    BevelInner = bvLowered
    BevelWidth = 2
    TabOrder = 3
    object Label5: TLabel
      Left = 56
      Top = 12
      Width = 146
      Height = 16
      Caption = 'Freier Hauptsteicher:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label6: TLabel
      Left = 56
      Top = 34
      Width = 120
      Height = 16
      Caption = 'Freie Resourcen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object Label9: TLabel
      Left = 56
      Top = 56
      Width = 158
      Height = 16
      Caption = 'Freier Plattenspeicher:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      IsControl = True
    end
    object FreeMemory: TLabel
      Left = 239
      Top = 12
      Width = 77
      Height = 16
      Caption = 'FreeMemory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object FreeResources: TLabel
      Left = 239
      Top = 34
      Width = 94
      Height = 16
      Caption = 'FreeResources'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
    object FreeDisk: TLabel
      Left = 239
      Top = 56
      Width = 48
      Height = 16
      Caption = 'FreeHD'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IsControl = True
    end
  end
  object Panel5: TPanel
    Left = 5
    Top = 396
    Width = 549
    Height = 62
    BevelInner = bvRaised
    TabOrder = 4
    object Panel6: TPanel
      Left = 214
      Top = 5
      Width = 109
      Height = 52
      BevelInner = bvLowered
      BevelOuter = bvLowered
      BevelWidth = 2
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 5
        Top = 5
        Width = 100
        Height = 40
        DoubleBuffered = True
        Kind = bkOK
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = Button1Click
      end
    end
  end
end
