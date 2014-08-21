object DlgMuGri: TDlgMuGri
  Left = 602
  Top = 216
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Tabellenlayout'
  ClientHeight = 453
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Grid: TTitleGrid
    Left = 0
    Top = 0
    Width = 513
    Height = 392
    Align = alClient
    ColCount = 4
    DefaultColWidth = 80
    DefaultRowHeight = 19
    FixedColor = clMenu
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowMoving, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDrawCell = GridDrawCell
    OnSelectCell = GridSelectCell
    AdjustWidths = True
    Titles.Strings = (
      'Spalten'#252'berschrift=190'
      'Breite=40'
      'Optionen=60')
    TitleOptions = [toNoExpand]
    ColWidths = (
      43
      194
      44
      64)
  end
  object Panel1: TPanel
    Left = 0
    Top = 392
    Width = 513
    Height = 61
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      513
      61)
    object Label1: TLabel
      Left = 8
      Top = 15
      Width = 401
      Height = 13
      Caption = 
        'Optionen: M=Summieren, S=ohne Auswahltext, O=optimale Spaltenbre' +
        'ite, H=Hilfetext'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 8
      Top = 1
      Width = 207
      Height = 13
      Caption = 'Spalten mit Breite=0 werden nicht angezeigt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object chbSlideBar: TCheckBox
      Left = 8
      Top = 36
      Width = 111
      Height = 17
      Caption = 'dyn. Schieberegler'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object BtnOK: TBitBtn
      Left = 354
      Top = 31
      Width = 72
      Height = 27
      Hint = 'Layout '#252'bernehmen'
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 2
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 432
      Top = 31
      Width = 72
      Height = 27
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Abbruch'
      ModalResult = 2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 3
      IsControl = True
    end
    object BtnStandard: TBitBtn
      Left = 276
      Top = 31
      Width = 72
      Height = 27
      Hint = 'Standardlayout wiederherstellen'
      Anchors = [akRight, akBottom]
      Caption = '&Standard'
      ModalResult = 6
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
    object BtnApply: TBitBtn
      Left = 182
      Top = 31
      Width = 88
      Height = 27
      Hint = 'Felder sortieren (aktive nach oben)'
      Anchors = [akRight, akBottom]
      Caption = '&'#220'bernehmen'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      OnClick = BtnApplyClick
      IsControl = True
    end
  end
  object Memo1: TMemo
    Left = 40
    Top = 160
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    Visible = False
    WordWrap = False
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 112
    object MiCopy: TMenuItem
      Caption = 'Kopieren'
      OnClick = MiCopyClick
    end
    object MiPaste: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = MiPasteClick
    end
    object MiColOffset: TMenuItem
      Caption = 'Col.Offset'
      OnClick = MiColOffsetClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MiColOffsetPlus: TMenuItem
      Caption = 'Col.Offset +'
      OnClick = MiColOffsetPlusClick
    end
    object MiColOffsetMinus: TMenuItem
      Caption = 'Col.Offset -'
      OnClick = MiColOffsetMinusClick
    end
    object MiSpaltenbreiten: TMenuItem
      Caption = 'Spaltenbreiten'
      OnClick = MiSpaltenbreitenClick
    end
  end
  object Nav: TLNavigator
    FormKurz = 'MUGRI'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = []
    OnSetTitel = NavSetTitel
    PollInterval = 0
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Bemerkung.Strings = (
      'wird hier plaziert um das Ereignis'
      'GNavigator.OnNavLinkInit auszul'#246'sen')
    Left = 256
    Top = 112
  end
end
