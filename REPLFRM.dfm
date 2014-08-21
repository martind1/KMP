object FrmRepl: TFrmRepl
  Left = 260
  Top = 146
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Replikation'
  ClientHeight = 329
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object BtnReplDB: TBitBtn
    Left = 450
    Top = 307
    Width = 116
    Height = 20
    Caption = 'DB Replizieren'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = BtnReplDBClick
  end
end
