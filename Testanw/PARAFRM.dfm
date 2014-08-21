object FrmPara: TFrmPara
  Left = 321
  Top = 148
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Systemparameter'
  ClientHeight = 329
  ClientWidth = 482
  Color = clBtnFace
  Enabled = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  ShowHint = True
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DetailBook: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 482
    Height = 329
    Align = alClient
    PageIndex = 2
    TabsPerRow = 4
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -13
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Umgebung'
      ExplicitHeight = 280
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 474
        Height = 73
        Align = alTop
        TabOrder = 0
        object Label4: TLabel
          Left = 242
          Top = 34
          Width = 66
          Height = 13
          Caption = 'PC-Nummer'
        end
        object Label1: TLabel
          Left = 10
          Top = 34
          Width = 51
          Height = 13
          Caption = 'Benutzer'
        end
        object EdPcNr: TEdit
          Left = 323
          Top = 31
          Width = 115
          Height = 21
          TabOrder = 1
          Text = 'EdPcNr'
        end
        object EdBenutzer: TEdit
          Left = 91
          Top = 31
          Width = 115
          Height = 21
          TabOrder = 0
          Text = 'EdBenutzer'
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 145
        Width = 474
        Height = 156
        Align = alBottom
        TabOrder = 2
        ExplicitTop = 124
      end
      object Panel3: TPanel
        Left = 0
        Top = 73
        Width = 474
        Height = 72
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 51
        object Label2: TLabel
          Left = 10
          Top = 18
          Width = 28
          Height = 13
          Caption = 'Alias'
        end
        object EdAlias: TEdit
          Left = 91
          Top = 16
          Width = 115
          Height = 21
          TabOrder = 0
          Text = 'EdAlias'
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Drucker'
      ExplicitHeight = 280
      object SgDrucker: TStringGrid
        Left = 0
        Top = 0
        Width = 474
        Height = 225
        Align = alTop
        ColCount = 3
        FixedCols = 0
        RowCount = 99
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        ColWidths = (
          161
          26
          447)
      end
      object BtnDruckerEinrichten: TBitBtn
        Left = 16
        Top = 232
        Width = 89
        Height = 33
        Caption = 'Einrichten'
        DoubleBuffered = True
        Glyph.Data = {
          9E050000424D9E05000000000000360400002800000012000000120000000100
          0800000000006801000000000000000000000001000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
          A40000008000008080000080000080800000800000000000000080008000FFFB
          F0008080400000FF800000404000A4C8F0000080FF00A0A0A40000408000FF00
          8000400080008040000000000000000000000000000000000000000000000000
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
          000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
          070707070707070707070707000007070707F8F8F8F8F8F8F8F8F8F8F8070707
          00000707000000000000000000000000F8F80707000007070007F8F8F8F8F8F8
          F8F8F80000F8F807000007000000000000000000000000000000F80700000700
          07FCFCFC07070707070707000000070707070700070707070707070707070700
          F800070707070700070707070707070707070700F8F800070707070000000000
          000000000000000000F80007000707070007F8F8F8F8F8F8F8F8F80700000007
          00000707070000FFFFFFFFFFFFFF00070700000707070707070700FF00000000
          00FF000000000007FFFF0707070700FFFFFFFFFFFFFF000707070707FFFF0707
          07070700FF00000000FFFF00070707070700070707070700FFFF00000000FF00
          07070707000707070707070700FFFFFFFFFFFFFF000707070000070707070707
          0700000000000000000007070700070707070707070707070707070707070707
          0707}
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = BtnDruckerEinrichtenClick
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'System'
      ExplicitHeight = 280
      object Label9: TLabel
        Left = 8
        Top = 8
        Width = 100
        Height = 13
        Caption = 'SQL Datumformat'
        FocusControl = EdSQLDATUM
      end
      object Label3: TLabel
        Left = 8
        Top = 33
        Width = 86
        Height = 13
        Caption = 'FAX Dial Prefix'
      end
      object EdSQLDATUM: TDBEdit
        Left = 200
        Top = 7
        Width = 80
        Height = 21
        Hint = 'Y=Jahr M=Monat D=Tag'
        DataField = 'SQLDATUM'
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 64
        Width = 449
        Height = 75
        Caption = 'Intern'
        TabOrder = 1
        object cbProtBeforeOpen: TCheckBox
          Left = 16
          Top = 16
          Width = 200
          Height = 17
          Alignment = taLeftJustify
          Caption = 'ProtBeforeOpen'
          TabOrder = 0
        end
        object cbFormsInFrame: TCheckBox
          Left = 16
          Top = 32
          Width = 200
          Height = 17
          Alignment = taLeftJustify
          Caption = 'FormsInFrams'
          TabOrder = 1
        end
        object cbFormsSizeable: TCheckBox
          Left = 16
          Top = 48
          Width = 200
          Height = 17
          Alignment = taLeftJustify
          Caption = 'FormsSizeable'
          TabOrder = 2
        end
      end
      object EdFaxPrefix: TEdit
        Left = 200
        Top = 31
        Width = 74
        Height = 21
        TabOrder = 2
        Text = 'EdFaxPrefix'
      end
    end
  end
end
