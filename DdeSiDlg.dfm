object DlgDdeSysInfo: TDlgDdeSysInfo
  Left = 355
  Top = 197
  ActiveControl = Edit1
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'DDE Server'
  ClientHeight = 197
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 272
    Height = 69
    Align = alTop
    ExplicitWidth = 239
  end
  object Label3: TLabel
    Left = 32
    Top = 28
    Width = 125
    Height = 16
    Caption = 'Topic Name: SysInfo'
  end
  object Label4: TLabel
    Left = 33
    Top = 46
    Width = 151
    Height = 16
    Caption = 'Item Name: GetFormsInfo'
  end
  object LaServiceName: TLabel
    Left = 34
    Top = 12
    Width = 164
    Height = 16
    Caption = 'Service Name: DDE Server'
  end
  object Edit1: TMemo
    Left = 0
    Top = 69
    Width = 272
    Height = 83
    Align = alClient
    Lines.Strings = (
      'Edit1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 152
    Width = 272
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object LaFoName: TLabel
      Left = 8
      Top = 8
      Width = 68
      Height = 16
      Caption = 'LaFoName'
    end
    object LaKoName: TLabel
      Left = 8
      Top = 24
      Width = 68
      Height = 16
      Caption = 'LaKoName'
    end
    object Panel2: TPanel
      Left = 169
      Top = 0
      Width = 103
      Height = 45
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnClose: TBitBtn
        Left = 8
        Top = 8
        Width = 89
        Height = 33
        Caption = '&Schlie'#223'en'
        ModalResult = 1
        NumGlyphs = 2
        TabOrder = 0
        OnClick = BtnCloseClick
      end
    end
  end
  object SysInfo: TDdeServerConv
    Left = 178
    Top = 35
  end
  object GetFormsInfo: TDdeServerItem
    ServerConv = SysInfo
    Text = 'Hallo'
    Lines.Strings = (
      'Hallo')
    Left = 210
    Top = 35
  end
  object GetObjektInfo: TDdeServerItem
    ServerConv = SysInfo
    Text = 'Hallo du'
    Lines.Strings = (
      'Hallo du')
    OnPokeData = GetObjektInfoPokeData
    Left = 112
    Top = 168
  end
  object LNavigator1: TLNavigator
    FormKurz = 'DDESI'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    PollInterval = 0
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 16
    Top = 128
  end
end
