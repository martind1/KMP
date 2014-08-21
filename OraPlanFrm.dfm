object FrmOraPlan: TFrmOraPlan
  Left = 355
  Top = 226
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Oracle Plan Table'
  ClientHeight = 453
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object panBot: TPanel
    Left = 0
    Top = 428
    Width = 987
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 391
      Top = 0
      Width = 596
      Height = 25
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Panel4: TPanel
        Left = 411
        Top = 0
        Width = 185
        Height = 25
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
end
