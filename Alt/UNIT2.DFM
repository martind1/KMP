object Form2: TForm2
  Left = 406
  Top = 358
  Width = 330
  Height = 135
  Caption = 'Uhrzeit auswählen'
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 77
    Width = 41
    Height = 16
    Caption = 'Uhrzeit'
  end
  object TitleGrid1: TTitleGrid
    Left = 8
    Top = 8
    Width = 304
    Height = 37
    ColCount = 13
    DefaultColWidth = 20
    DefaultRowHeight = 17
    FixedRows = 0
    RowCount = 2
    ScrollBars = ssNone
    TabOrder = 0
    RowTitles.Strings = (
      'Stunden=0:;1:;2:;3:;4:;5:;6:;7:;8:;9:;10:;11:'
      ' =12:;13:;14:;15:;16:;17:;18:;19:;20:;21:;22:;23:')
    TitleOptions = [toNoExpand]
    ColWidths = (
      53
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20)
  end
  object TitleGrid2: TTitleGrid
    Left = 8
    Top = 48
    Width = 304
    Height = 21
    ColCount = 13
    DefaultColWidth = 20
    DefaultRowHeight = 17
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    RowCount = 1
    ScrollBars = ssNone
    TabOrder = 1
    RowTitles.Strings = (
      'Minuten=:00;:05;:10;:15;:20;:25;:30;:35;:40;:45;:50;:55')
    TitleOptions = [toNoExpand]
    ColWidths = (
      50
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20)
  end
  object Edit1: TEdit
    Left = 66
    Top = 75
    Width = 41
    Height = 24
    Color = clSilver
    ReadOnly = True
    TabOrder = 2
    Text = '00:00'
  end
  object BtnOK: TBitBtn
    Left = 120
    Top = 75
    Width = 49
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    Layout = blGlyphTop
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
  object BtnHeute: TBitBtn
    Left = 174
    Top = 75
    Width = 66
    Height = 25
    Caption = '&Jetzt'
    TabOrder = 4
    Layout = blGlyphTop
  end
  object BtnCancel: TBitBtn
    Left = 245
    Top = 75
    Width = 68
    Height = 25
    Cancel = True
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 5
    Layout = blGlyphTop
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
end
