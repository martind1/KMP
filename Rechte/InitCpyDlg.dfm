object DlgInitCpy: TDlgInitCpy
  Left = 341
  Top = 530
  BorderStyle = bsDialog
  Caption = 'Eintr'#228'ge kopieren'
  ClientHeight = 198
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 162
    Width = 564
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnOK: TBitBtn
      Left = 340
      Top = 6
      Width = 77
      Height = 27
      Caption = 'Kopieren'
      Default = True
      Enabled = False
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
    end
    object BtnCancel: TBitBtn
      Left = 426
      Top = 6
      Width = 77
      Height = 27
      Cancel = True
      Caption = 'Abbrechen'
      ModalResult = 2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
    end
    object chbDelete: TCheckBox
      Left = 8
      Top = 8
      Width = 129
      Height = 17
      Caption = 'Ziel vorher l'#246'schen'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 564
    Height = 162
    Align = alClient
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 105
      Top = 1
      Width = 228
      Height = 160
      Align = alLeft
      Caption = 'von'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label10: TLabel
        Left = 96
        Top = 0
        Width = 52
        Height = 15
        Caption = '(% = alle)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edANWEvon: TEdit
        Left = 10
        Top = 20
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = EditChange
        OnExit = EditChange
      end
      object edMACHvon: TEdit
        Left = 10
        Top = 48
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = EditChange
        OnExit = EditChange
      end
      object edUSERvon: TEdit
        Left = 10
        Top = 76
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = EditChange
        OnExit = EditChange
      end
      object edSECTvon: TEdit
        Left = 10
        Top = 132
        Width = 200
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnChange = EditChange
        OnExit = EditChange
      end
      object EdVorgVon: TEdit
        Left = 10
        Top = 104
        Width = 200
        Height = 23
        Hint = 'Gruppe'
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnChange = EditChange
        OnExit = EditChange
      end
    end
    object GroupBox2: TGroupBox
      Left = 333
      Top = 1
      Width = 228
      Height = 160
      Align = alLeft
      Caption = 'nach'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label9: TLabel
        Left = 96
        Top = 0
        Width = 52
        Height = 15
        Caption = '(% = dito)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object edANWEnach: TEdit
        Left = 10
        Top = 20
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = EditChange
        OnExit = EditChange
      end
      object edMACHnach: TEdit
        Left = 10
        Top = 48
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = EditChange
        OnExit = EditChange
      end
      object edUSERnach: TEdit
        Left = 10
        Top = 76
        Width = 200
        Height = 23
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = EditChange
        OnExit = EditChange
      end
      object edSECTnach: TEdit
        Left = 10
        Top = 132
        Width = 200
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnChange = EditChange
        OnExit = EditChange
      end
      object EdVorgNach: TEdit
        Left = 10
        Top = 104
        Width = 200
        Height = 23
        Hint = 'Gruppe'
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnChange = EditChange
        OnExit = EditChange
      end
    end
    object rgKopiere: TRadioGroup
      Left = 1
      Top = 1
      Width = 104
      Height = 160
      Align = alLeft
      Caption = 'kopiere'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 4
      Items.Strings = (
        'Anwendung'
        'Maschine'
        'User'
        'Vorgabe'
        'Section')
      ParentFont = False
      TabOrder = 2
      OnClick = EditChange
    end
    object StaticText1: TStaticText
      Left = 10
      Top = 1
      Width = 47
      Height = 19
      Caption = 'kopiere'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    Options.RequiredFields = False
    Options.StrictUpdate = False
    SpecificOptions.Strings = (
      'SQL Server.FetchAll=False')
    DatabaseName = 'DB1'
    SessionName = 'SESSION'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 200
    Top = 81
  end
end
