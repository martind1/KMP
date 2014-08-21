object DlgAswEd: TDlgAswEd
  Left = 316
  Top = 423
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Auswahl bearbeiten'
  ClientHeight = 194
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Grid: TTitleGrid
    Left = 0
    Top = 0
    Width = 303
    Height = 157
    Align = alClient
    ColCount = 2
    DefaultColWidth = 80
    DefaultRowHeight = 19
    FixedColor = clMenu
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
    ParentFont = False
    TabOrder = 0
    OnSelectCell = GridSelectCell
    AdjustWidths = True
    Titles.Strings = (
      'Schl'#252'ssel'
      'Bezeichnung=30')
    TitleOptions = []
    ColWidths = (
      62
      214)
  end
  object Panel1: TPanel
    Left = 0
    Top = 157
    Width = 303
    Height = 37
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      303
      37)
    object BtnOK: TBitBtn
      Left = 50
      Top = 4
      Width = 77
      Height = 27
      Hint = 'Layout '#252'bernehmen'
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      DoubleBuffered = True
      ModalResult = 1
      NumGlyphs = 2
      ParentDoubleBuffered = False
      Spacing = -1
      TabOrder = 0
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 218
      Top = 4
      Width = 77
      Height = 27
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Abbruch'
      DoubleBuffered = True
      ModalResult = 2
      NumGlyphs = 2
      ParentDoubleBuffered = False
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
    object BtnStandard: TBitBtn
      Left = 134
      Top = 4
      Width = 77
      Height = 27
      Hint = 'Standardlayout wiederherstellen'
      Anchors = [akRight, akBottom]
      Caption = '&Standard'
      DoubleBuffered = True
      ModalResult = 6
      NumGlyphs = 2
      ParentDoubleBuffered = False
      Spacing = -1
      TabOrder = 2
      IsControl = True
    end
  end
end
