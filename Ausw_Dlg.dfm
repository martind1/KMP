object DlgAusw: TDlgAusw
  Left = 372
  Top = 219
  ActiveControl = EdDtmVon
  Anchors = [akTop]
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Auswertung Dialog'
  ClientHeight = 205
  ClientWidth = 477
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 493
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object PanBottom: TPanel
    Left = 0
    Top = 171
    Width = 477
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel1: TPanel
      Left = 118
      Top = 0
      Width = 359
      Height = 34
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object BtnScr: TBitBtn
        Left = 8
        Top = 6
        Width = 80
        Height = 25
        Hint = 'Seitenvorschau'
        Caption = '&Bildschirm'
        Default = True
        TabOrder = 0
        OnClick = BtnScrClick
      end
      object BtnPrn: TBitBtn
        Left = 96
        Top = 6
        Width = 80
        Height = 25
        Hint = 'Ausgabe auf Drucker'
        Caption = '&Drucker'
        TabOrder = 1
        OnClick = BtnPrnClick
      end
      object BtnSetup: TBitBtn
        Left = 184
        Top = 6
        Width = 80
        Height = 25
        Hint = 'Drucker ausw'#228'hlen'
        Caption = '&Einrichten'
        TabOrder = 2
        OnClick = BtnSetupClick
      end
      object BtnClose: TBitBtn
        Left = 272
        Top = 6
        Width = 80
        Height = 25
        Cancel = True
        Caption = 'Schlie&'#223'en'
        TabOrder = 3
        OnClick = BtnCloseClick
      end
    end
  end
  object PanTop: TScrollBox
    Left = 0
    Top = 0
    Width = 477
    Height = 126
    Align = alTop
    TabOrder = 1
    object LaDtmVon: TLabel
      Left = 8
      Top = 16
      Width = 63
      Height = 16
      Caption = '&Zeitspanne'
      FocusControl = EdDtmVon
    end
    object LaDtmBis: TLabel
      Left = 8
      Top = 42
      Width = 17
      Height = 16
      Caption = '&bis'
      FocusControl = EdDtmBis
    end
    object LaBemerkung: TLabel
      Left = 8
      Top = 84
      Width = 66
      Height = 16
      Caption = 'Bemer&kung'
      FocusControl = EdCaption
    end
    object BtnDtmVon: TDatumBtn
      Left = 176
      Top = 15
      Width = 22
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000BFBFBFBFBFBF
        BFBFBF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000
        000000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBF000000000000000000000000000000000000000000BF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF0000000000000000007F7F7F7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FBFBFBFBFBFBF
        000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF00000000000000000000007F00007F00
        007F00007FFFFFFF00007F00007F00007F00007FFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFF00007F00007F00007F00007FFFFFFF00007F00007F0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFFFFFFFF00007F00
        007FFFFFFFFFFFFFFFFFFF00007F00007FFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFFFFFFFF00007F00007FFFFFFFFFFFFFFFFFFFFFFFFF0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFF00007F00007F00
        007FFFFFFF00007F00007FFFFFFF00007F00007FFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFF00007F00007F00007FFFFFFF00007F00007F00007F0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFFFFFFFF00007F00
        007FFFFFFFFFFFFF00007F00007F00007FFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7F7F7F7F7F7F7F7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F}
      ParentFont = False
      TabOrder = 0
      OnClick = BtnDtmClick
      OnEnter = BtnDtmEnter
      Day = 0
      Month = 0
      Year = 0
    end
    object EdDtmVon: TEdit
      Left = 96
      Top = 14
      Width = 80
      Height = 24
      Color = clWhite
      TabOrder = 1
      Text = '2001-19-04'
      OnExit = EdDtmExit
    end
    object EdDtmBis: TEdit
      Left = 96
      Top = 40
      Width = 80
      Height = 24
      Color = clWhite
      TabOrder = 2
      Text = '2001-19-04'
      OnExit = EdDtmExit
    end
    object chbEinzel: TCheckBox
      Left = 336
      Top = 16
      Width = 128
      Height = 17
      Hint = 'Auflistung der einzelnen Datens'#228'tze'
      Alignment = taLeftJustify
      Caption = 'Einzel&nachweis'
      Enabled = False
      TabOrder = 3
      OnClick = chbClick
    end
    object BtnDtmBis: TDatumBtn
      Left = 176
      Top = 41
      Width = 22
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000BFBFBFBFBFBF
        BFBFBF000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000000000000000BFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF000000
        000000000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBF000000000000000000000000000000000000000000BF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        000000000000000000BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
        BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF0000000000000000007F7F7F7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FBFBFBFBFBFBF
        000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF00000000000000000000007F00007F00
        007F00007FFFFFFF00007F00007F00007F00007FFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFF00007F00007F00007F00007FFFFFFF00007F00007F0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFFFFFFFF00007F00
        007FFFFFFFFFFFFFFFFFFF00007F00007FFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFFFFFFFF00007F00007FFFFFFFFFFFFFFFFFFFFFFFFF0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFF00007F00007F00
        007FFFFFFF00007F00007FFFFFFF00007F00007FFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFF00007F00007F00007FFFFFFF00007F00007F00007F0000
        7F00007FFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7FFFFFFFFFFFFF00007F00
        007FFFFFFFFFFFFF00007F00007F00007FFFFFFFFFFFFF7F7F7FBFBFBFBFBFBF
        BFBFBF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBFBFBFBF7F7F7F7F7F7F7F7F7F7F7F7F7F
        7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F}
      ParentFont = False
      TabOrder = 4
      OnClick = BtnDtmClick
      OnEnter = BtnDtmEnter
      Day = 0
      Month = 0
      Year = 0
    end
    object rgDtm: TRadioGroup
      Left = 212
      Top = 1
      Width = 111
      Height = 77
      Caption = 'Datumsformat'
      Items.Strings = (
        '&Tagesliste'
        '&Monatsliste'
        '&Jahresliste')
      TabOrder = 5
      OnClick = rgDtmClick
    end
    object chbZwSum: TCheckBox
      Tag = 1
      Left = 336
      Top = 37
      Width = 128
      Height = 17
      Hint = 'Ausgabe der Zwischensummen'
      Alignment = taLeftJustify
      Caption = 'Zwischen&summen'
      TabOrder = 6
      OnClick = chbClick
    end
    object chbGrpSum: TCheckBox
      Tag = 2
      Left = 336
      Top = 58
      Width = 128
      Height = 17
      Hint = 'Ausgabe der Gruppensummen'
      Alignment = taLeftJustify
      Caption = '&Gruppensummen'
      TabOrder = 7
      OnClick = chbClick
    end
    object EdCaption: TEdit
      Left = 96
      Top = 82
      Width = 361
      Height = 24
      Hint = 'Untertitel des Berichts'
      Color = clWhite
      TabOrder = 8
      Text = 'EdCaption'
      OnChange = EdCaptionChange
    end
  end
  object PanClient: TPanel
    Left = 0
    Top = 126
    Width = 477
    Height = 45
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 2
    object ScrollBoxUser: TScrollBox
      Left = 1
      Top = 1
      Width = 475
      Height = 43
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alClient
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      object BtnScr1: TBitBtn
        Left = 141
        Top = 6
        Width = 75
        Height = 25
        Hint = 'Seitenvorschau'
        Caption = 'BtnScr1'
        Default = True
        TabOrder = 0
        Visible = False
        OnClick = BtnScr1Click
      end
    end
  end
  object Nav: TLNavigator
    FormKurz = 'AUSW1'
    AutoEditStart = True
    PageBookStart = 'Multi'
    DetailBookStart = 'etc.'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    PollInterval = 0
    AutoCommit = True
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 18
    Top = 162
  end
  object PopupMenu1: TPopupMenu
    Left = 47
    Top = 161
    object MiLookUp: TMenuItem
      Caption = 'LookUp'
      ShortCut = 113
      OnClick = MiLookUpClick
    end
  end
end
