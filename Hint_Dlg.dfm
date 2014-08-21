object DlgHint: TDlgHint
  Left = 359
  Top = 312
  Width = 308
  Height = 246
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Hinweis bearbeiten'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 283
    Height = 167
    Style = bsRaised
  end
  object laCaption: TLabel
    Left = 16
    Top = 20
    Width = 64
    Height = 16
    Caption = 'Überschrift'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 47
    Height = 16
    Caption = 'Hinweis'
  end
  object Label1: TLabel
    Left = 16
    Top = 144
    Width = 243
    Height = 26
    AutoSize = False
    Caption = 
      'Um beim nächsten Öffnen die Standardwerte zu verwenden löschen S' +
      'ie die Texte'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 300
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnOK: TBitBtn
      Left = 131
      Top = 4
      Width = 77
      Height = 27
      Hint = 'Layout übernehmen'
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 215
      Top = 4
      Width = 77
      Height = 27
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Abbruch'
      ModalResult = 2
      TabOrder = 2
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object BtnAuswahl: TBitBtn
      Left = 8
      Top = 4
      Width = 105
      Height = 27
      Hint = 'Auswahl bearbeiten'
      Caption = 'Tabellenlayo&ut'
      Enabled = False
      TabOrder = 0
      OnClick = BtnAuswahlClick
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
  end
  object EdCaption: TEdit
    Left = 96
    Top = 18
    Width = 185
    Height = 24
    TabOrder = 1
    Text = 'EdCaption'
  end
  object MeHint: TMemo
    Left = 96
    Top = 50
    Width = 185
    Height = 89
    Lines.Strings = (
      'MeHint')
    TabOrder = 2
  end
end
