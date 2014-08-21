object DlgFldDesc: TDlgFldDesc
  Left = 929
  Top = 365
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Feldbeschreibungen'
  ClientHeight = 369
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 333
    Width = 362
    Height = 36
    Align = alBottom
    TabOrder = 1
    object BtnClose: TBitBtn
      Left = 275
      Top = 6
      Width = 80
      Height = 24
      Cancel = True
      Caption = 'Schlie&'#223'en'
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 3
      IsControl = True
    end
    object BtnLoad: TBitBtn
      Left = 16
      Top = 6
      Width = 77
      Height = 24
      Caption = '&Laden'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      OnClick = BtnLoadClick
      IsControl = True
    end
    object BtnSave: TBitBtn
      Left = 190
      Top = 6
      Width = 77
      Height = 24
      Caption = '&Speichern'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 2
      OnClick = BtnSaveClick
      IsControl = True
    end
    object BtnDelete: TBitBtn
      Left = 104
      Top = 6
      Width = 77
      Height = 24
      Caption = 'L'#246'schen'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      OnClick = BtnDeleteClick
      IsControl = True
    end
  end
  object Outline1: TOutline
    Left = 0
    Top = 41
    Width = 362
    Height = 292
    ItemHeight = 16
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    OnKeyDown = Outline1KeyDown
    ItemSeparator = '\'
    ParentFont = False
  end
  object PanBdeFreeDisk: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 12320767
    TabOrder = 2
    Visible = False
    object LaBdeFreeDisk: TLabel
      Left = 8
      Top = 10
      Width = 177
      Height = 16
      Caption = 'Freier BDE Speicher: %.2f MB'
      Transparent = True
    end
    object BtnBdeFreeDisk: TBitBtn
      Left = 216
      Top = 8
      Width = 77
      Height = 24
      Caption = 'Erh'#246'hen'
      TabOrder = 0
      OnClick = BtnBdeFreeDiskClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 240
    Top = 285
    object MiCopy: TMenuItem
      Caption = 'Kopieren'
      OnClick = MiCopyClick
    end
  end
end
