object DlgAswCl: TDlgAswCl
  Left = 444
  Top = 337
  BorderStyle = bsDialog
  Caption = 'Auswahl'
  ClientHeight = 112
  ClientWidth = 392
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 87
    Width = 392
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object PanRight: TPanel
      Left = 260
      Top = 0
      Width = 132
      Height = 25
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnOK: TBitBtn
        Left = 0
        Top = 1
        Width = 53
        Height = 24
        Caption = '&OK'
        Default = True
        ModalResult = 1
        NumGlyphs = 2
        Spacing = -1
        TabOrder = 0
        IsControl = True
      end
      object BtnCancel: TBitBtn
        Left = 55
        Top = 1
        Width = 77
        Height = 24
        Cancel = True
        Caption = '&Abbruch'
        ModalResult = 2
        NumGlyphs = 2
        Spacing = -1
        TabOrder = 1
        IsControl = True
      end
    end
  end
  object CheckListBox: TCheckListBox
    Left = 0
    Top = 0
    Width = 392
    Height = 87
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object DataSource1: TDataSource
    AutoEdit = False
    Left = 437
    Top = 69
  end
end
