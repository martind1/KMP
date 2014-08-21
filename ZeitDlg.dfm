object DlgZeit: TDlgZeit
  Left = 406
  Top = 358
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Uhrzeit ausw'#228'hlen'
  ClientHeight = 122
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 90
    Width = 41
    Height = 16
    Caption = '&Uhrzeit'
    FocusControl = EdUhrzeit
  end
  object Label2: TLabel
    Left = 8
    Top = 10
    Width = 49
    Height = 16
    Caption = '&Stunden'
    FocusControl = GridStunden
  end
  object Label3: TLabel
    Left = 8
    Top = 54
    Width = 46
    Height = 16
    Caption = '&Minuten'
    FocusControl = GridMinuten
  end
  object GridStunden: TTitleGrid
    Left = 72
    Top = 8
    Width = 289
    Height = 40
    ColCount = 13
    DefaultColWidth = 20
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ScrollBars = ssNone
    TabOrder = 0
    OnClick = GridStundenClick
    AdjustWidths = True
    RowTitles.Strings = (
      'Stunden=0:;1:;2:;3:;4:;5:;6:;7:;8:;9:;10:;11:'
      ' =12:;13:;14:;15:;16:;17:;18:;19:;20:;21:;22:;23:')
    TitleOptions = [toNoExpand]
    ColWidths = (
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21)
  end
  object GridMinuten: TTitleGrid
    Left = 72
    Top = 52
    Width = 289
    Height = 20
    ColCount = 13
    DefaultColWidth = 20
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ScrollBars = ssNone
    TabOrder = 1
    OnClick = GridStundenClick
    AdjustWidths = True
    RowTitles.Strings = (
      'Minuten=:00;:05;:10;:15;:20;:25;:30;:35;:40;:45;:50;:55')
    TitleOptions = [toNoExpand]
    ColWidths = (
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21
      21)
  end
  object EdUhrzeit: TEdit
    Left = 64
    Top = 88
    Width = 41
    Height = 24
    MaxLength = 5
    TabOrder = 2
    Text = '00:00'
    OnChange = EdUhrzeitChange
  end
  object BtnOK: TBitBtn
    Left = 144
    Top = 88
    Width = 68
    Height = 25
    Caption = '&OK'
    Default = True
    DoubleBuffered = True
    Layout = blGlyphTop
    Margin = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    Spacing = -1
    TabOrder = 3
    OnClick = BtnOKClick
    IsControl = True
  end
  object BtnJetzt: TBitBtn
    Left = 219
    Top = 88
    Width = 68
    Height = 25
    Caption = '&Jetzt'
    DoubleBuffered = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333000003333333333F77777FFF333333009999900
      3333333777777777FF33330998FFF899033333777333F3777FF33099FFFCFFF9
      903337773337333777F3309FFFFFFFCF9033377333F3337377FF098FF0FFFFFF
      890377F3373F3333377F09FFFF0FFFFFF90377F3F373FFFFF77F09FCFFF90000
      F90377F733377777377F09FFFFFFFFFFF90377F333333333377F098FFFFFFFFF
      890377FF3F33333F3773309FCFFFFFCF9033377F7333F37377F33099FFFCFFF9
      90333777FF37F3377733330998FCF899033333777FF7FF777333333009999900
      3333333777777777333333333000003333333333377777333333}
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BtnJetztClick
  end
  object BtnCancel: TBitBtn
    Left = 294
    Top = 88
    Width = 68
    Height = 25
    Cancel = True
    Caption = '&Abbruch'
    DoubleBuffered = True
    Layout = blGlyphTop
    Margin = 2
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    Spacing = -1
    TabOrder = 5
    IsControl = True
  end
  object TimeSpin1: TTimeSpin
    Left = 105
    Top = 88
    Width = 21
    Height = 24
    DownGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F00
      7F7F000000007F7F007F7F007F7F007F7F00007F7F007F7F007F7F0000000000
      00000000007F7F007F7F007F7F00007F7F007F7F000000000000000000000000
      000000007F7F007F7F00007F7F00000000000000000000000000000000000000
      0000007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F00}
    TabOrder = 6
    TabStop = True
    UpGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F00007F7F00000000000000
      0000000000000000000000000000007F7F00007F7F007F7F0000000000000000
      00000000000000007F7F007F7F00007F7F007F7F007F7F000000000000000000
      007F7F007F7F007F7F00007F7F007F7F007F7F007F7F000000007F7F007F7F00
      7F7F007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F00}
    DBEdit = EdUhrzeit
    StartTime = '12:00'
    StepTime = '00:01'
  end
end
