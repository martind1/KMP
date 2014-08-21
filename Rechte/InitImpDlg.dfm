object DlgInitImp: TDlgInitImp
  Left = 599
  Top = 318
  BorderStyle = bsDialog
  Caption = '.INI File importieren'
  ClientHeight = 236
  ClientWidth = 521
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object LaStatus: TLabel
    Left = 8
    Top = 208
    Width = 136
    Height = 15
    Caption = 'Filename nicht gefunden'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object BtnOK: TBitBtn
    Left = 356
    Top = 203
    Width = 77
    Height = 27
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    Enabled = False
    ModalResult = 1
    NumGlyphs = 2
    ParentDoubleBuffered = False
    Spacing = -1
    TabOrder = 0
  end
  object BtnCancel: TBitBtn
    Left = 442
    Top = 203
    Width = 77
    Height = 27
    Cancel = True
    Caption = 'Abbrechen'
    DoubleBuffered = True
    ModalResult = 2
    NumGlyphs = 2
    ParentDoubleBuffered = False
    Spacing = -1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 521
    Height = 65
    Align = alTop
    Caption = 'von'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 52
      Height = 15
      Caption = 'Filename'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edFilename: TEdit
      Left = 72
      Top = 22
      Width = 393
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = edFilenameChange
    end
    object btnFilenameDialog: TBitBtn
      Left = 464
      Top = 22
      Width = 24
      Height = 23
      Hint = 'Ausw'#228'hlen'
      Caption = '...'
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Layout = blGlyphBottom
      Margin = 5
      NumGlyphs = 2
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      OnClick = btnFilenameDialogClick
    end
    object btnFilenameOpen: TBitBtn
      Left = 489
      Top = 22
      Width = 24
      Height = 23
      Hint = #214'ffnen'
      DoubleBuffered = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = btnFilenameOpenClick
    end
  end
  object gbNach: TGroupBox
    Left = 0
    Top = 65
    Width = 521
    Height = 128
    Align = alTop
    Caption = 'nach'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 65
      Height = 15
      Caption = 'Anwendung'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 53
      Height = 15
      Caption = 'Maschine'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 8
      Top = 72
      Width = 27
      Height = 15
      Caption = 'User'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object edAnwendung: TEdit
      Left = 95
      Top = 22
      Width = 240
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
    end
    object edMaschine: TEdit
      Left = 95
      Top = 46
      Width = 240
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
    end
    object EdUser: TEdit
      Left = 95
      Top = 70
      Width = 240
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
    end
    object chbOverwrite: TCheckBox
      Left = 7
      Top = 96
      Width = 101
      Height = 17
      Hint = 'bestehende Eintr'#228'ge '#252'berschreiben'
      Alignment = taLeftJustify
      Caption = #252'berschreiben'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object lbSectionTypes: TListBox
      Left = 352
      Top = 17
      Width = 167
      Height = 109
      Align = alRight
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      Items.Strings = (
        '[Sectiontypen Vorgaben]'
        'Spalten.*=U'
        'Sortierung*=U'
        'Hints.*=A'
        'Ger'#228'te=M'
        'Drucker=M'
        'Programm=A'
        'Umgebung=M'
        'Parameter=M'
        'System=U'
        '[QURE]'
        'DlgInitImp=M'
        '[QUVA]'
        'Beladeeinrichtungen=M'
        'Anschrift=M'
        'HQ-Beladung=M'
        'Bahnbeladung=M'
        'ARBBLATT=M'
        'TDlgDispo=M'
        'Hirschau Autowaage Ost=M'
        'PRER=M'
        'ICBELA=M'
        'BELA=M'
        'DlgInitImp=M'
        '[QSBT]'
        'FREMDWGS=M'
        'XAUFK=M'
        'CAM=M'
        'KKWAA=M'
        'WAGO=M'
        'DSTA=M'
        'FREMDWGS=M'
        'EMAIL=M'
        'TRAN=M'
        'SMFTOUCH=M'
        'BELA=M'
        'WATT=M'
        'TOUCH=M'
        '[QDISPO]'
        '[SDBL]'
        'EMAIL=M'
        'UEBL=M'
        'WEBUPLOAD=M'
        'FAXSEND=M'
        'ARCAUTO=M'
        'FAXSTATUS=M'
        '[QUPE]'
        'Ger'#228'te=M'
        'ZLIMP=M')
      ParentFont = False
      TabOrder = 4
      Visible = False
    end
    object chbAsk: TCheckBox
      Left = 262
      Top = 96
      Width = 73
      Height = 17
      Hint = 'bei unbekannten Sektionen nachfragen.'#13#10'Vorgabe: User'
      Alignment = taLeftJustify
      Caption = 'Abfrage'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
  end
  object dlgFilename: TOpenDialog
    DefaultExt = 'INI'
    FileName = 'Report'
    Filter = 'INI (*.ini)|*.ini|alle (*.*)|*.*'
    Left = 410
    Top = 19
  end
  object IniDb1: TIniDbKmp
    FileName = 'R_INIT'
    UsePrnName = False
    IgnoreFileError = False
    AswsFromIni = False
    DatabaseName = 'DB1'
    DelayTime = 2000
    SyncVcl = True
    Left = 406
    Top = 56
  end
end
