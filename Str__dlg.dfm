object DlgStrings: TDlgStrings
  Left = 1168
  Top = 223
  ActiveControl = ListBox
  BorderStyle = bsDialog
  Caption = 'Auswahl'
  ClientHeight = 198
  ClientWidth = 200
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -21
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 24
  object ListBox: TListBox
    Left = 8
    Top = 8
    Width = 182
    Height = 152
    ExtendedSelect = False
    ItemHeight = 24
    Items.Strings = (
      'Zwischenbescheid an Mitarbeiter '#252'ber Terminverz'#246'gerung'
      'wqreqwr'
      '2sdfsdf'
      '3sfdsfd'
      '4'
      '5'
      '6'
      '7'
      '8'
      '10'
      '9'
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      ''
      ''
      '20'
      ''
      ''
      ''
      ''
      '25'
      ''
      ''
      ''
      ''
      '30'
      ''
      ''
      '33'
      '34'
      '35'
      ''
      ''
      ''
      ''
      '40'
      ''
      ''
      ''
      ''
      '45'
      ''
      ''
      ''
      ''
      '50')
    TabOrder = 0
    OnDblClick = ListBoxDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 162
    Width = 200
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnOK: TBitBtn
      Left = 8
      Top = 7
      Width = 80
      Height = 24
      Caption = '&OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 1
      NumGlyphs = 2
      ParentFont = False
      Spacing = -1
      TabOrder = 0
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 96
      Top = 7
      Width = 77
      Height = 24
      Cancel = True
      Caption = '&Abbruch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ModalResult = 2
      NumGlyphs = 2
      ParentFont = False
      Spacing = -1
      TabOrder = 1
      IsControl = True
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 170
    object MiSave: TMenuItem
      Caption = 'In Datei speichern'
      OnClick = MiSaveClick
    end
  end
end
