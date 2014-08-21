object FrmRow7S: TFrmRow7S
  Left = 481
  Top = 229
  BorderIcons = []
  Caption = 'Ro Simul'
  ClientHeight = 27
  ClientWidth = 119
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object LaGewicht: TLabel
    Left = 0
    Top = 0
    Width = 98
    Height = 27
    Align = alLeft
    Caption = '--,-- t'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -24
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object SpinButton1: TSpinButton
    Left = 98
    Top = 0
    Width = 21
    Height = 27
    Align = alClient
    DownGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F00007F7F007F7F007F7F00
      7F7F000000007F7F007F7F007F7F007F7F00007F7F007F7F007F7F0000000000
      00000000007F7F007F7F007F7F00007F7F007F7F000000000000000000000000
      000000007F7F007F7F00007F7F00000000000000000000000000000000000000
      0000007F7F00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F00}
    TabOrder = 0
    UpGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000007F7F007F7F
      007F7F007F7F007F7F007F7F007F7F007F7F007F7F00007F7F00000000000000
      0000000000000000000000000000007F7F69007F7F007F7F0000000000000000
      00000000000000007F7F007F7F69007F7F007F7F007F7F000000000000000000
      007F7F007F7F007F7F6E007F7F007F7F007F7F007F7F000000007F7F007F7F00
      7F7F007F7F4E007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
      7F72}
    OnDownClick = SpinButton1DownClick
    OnUpClick = SpinButton1UpClick
  end
  object PopupMenu1: TPopupMenu
    Left = 86
    Top = 16
    object MiReset: TMenuItem
      Caption = 'Zur'#252'cksetzen'
      OnClick = MiResetClick
    end
    object MiNullstellen: TMenuItem
      Caption = 'Nullstellen'
      OnClick = MiNullstellenClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MiAufzeichnung: TMenuItem
      Caption = 'Aufzeichnung'
      OnClick = MiAufzeichnungClick
    end
    object Testausdruck1: TMenuItem
      Caption = 'Testausdruck'
      Hint = 'MiTestDruck'
      OnClick = Testausdruck1Click
    end
    object MiClose: TMenuItem
      Caption = 'Wegblenden'
      OnClick = MiCloseClick
    end
    object MiTestModus: TMenuItem
      Caption = 'TestModus'
      OnClick = MiTestModusClick
    end
    object MiDelSpNr: TMenuItem
      Caption = 'Speichernummern l'#246'schen'
      OnClick = MiDelSpNrClick
    end
  end
end
