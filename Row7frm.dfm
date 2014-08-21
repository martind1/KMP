object FrmRow7: TFrmRow7
  Left = 481
  Top = 229
  BorderIcons = []
  Caption = 'Rowa7'
  ClientHeight = 27
  ClientWidth = 115
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object LaGewicht: TLabel
    Left = 0
    Top = 0
    Width = 115
    Height = 27
    Align = alClient
    Caption = '----- kg'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -24
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 112
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
