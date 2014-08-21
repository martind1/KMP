object DlgReplace: TDlgReplace
  Left = 1040
  Top = 203
  ActiveControl = cobSearch
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Suchen und ersetzen'
  ClientHeight = 301
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 301
    Align = alClient
    TabOrder = 0
    object Panel3: TPanel
      Left = 1
      Top = 27
      Width = 506
      Height = 164
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 82
        Height = 15
        Caption = 'Suchen &in Feld'
        FocusControl = cobField
      end
      object Label2: TLabel
        Left = 16
        Top = 56
        Width = 72
        Height = 15
        Caption = 'Suchen &nach'
        FocusControl = cobSearch
      end
      object laReplace: TLabel
        Tag = 2
        Left = 16
        Top = 96
        Width = 82
        Height = 15
        Caption = 'Ersetzen &durch'
        FocusControl = cobReplace
        Visible = False
      end
      object cobField: TComboBox
        Left = 112
        Top = 14
        Width = 366
        Height = 23
        Hint = 'Feldnamen mit '#39';'#39' trennen'#13#10'* = Suche in allen Tabellenspalten.'
        Color = clWhite
        TabOrder = 0
        OnChange = cobFieldChange
      end
      object cobSearch: TComboBox
        Left = 112
        Top = 54
        Width = 366
        Height = 23
        Hint = 'beliebiger Inhalt: *    Feld mu'#223' leer sein: ='
        Color = clWhite
        TabOrder = 1
        OnChange = EditChange
      end
      object chbMark: TCheckBox
        Tag = 1
        Left = 16
        Top = 113
        Width = 197
        Height = 17
        Caption = 'Gefundene Elemente &markieren'
        Color = 13160660
        ParentColor = False
        TabOrder = 3
        OnClick = EditChange
      end
      object cobReplace: TComboBox
        Tag = 2
        Left = 112
        Top = 94
        Width = 366
        Height = 23
        Color = clWhite
        TabOrder = 2
        Visible = False
        OnChange = EditChange
      end
      object BtnSearch: TBitBtn
        Left = 302
        Top = 136
        Width = 89
        Height = 25
        Caption = '&Weitersuchen'
        TabOrder = 6
        OnClick = BtnSearchClick
      end
      object BtnCancel: TBitBtn
        Left = 401
        Top = 136
        Width = 77
        Height = 25
        Cancel = True
        Caption = '&Abbrechen'
        ModalResult = 2
        NumGlyphs = 2
        Spacing = -1
        TabOrder = 7
        OnClick = BtnCancelClick
        OnMouseDown = BtnCancelMouseDown
      end
      object btnReplaceAll: TBitBtn
        Tag = 2
        Left = 199
        Top = 136
        Width = 93
        Height = 25
        Cancel = True
        Caption = '&Alle ersetzen'
        ModalResult = 2
        NumGlyphs = 2
        Spacing = -1
        TabOrder = 5
        Visible = False
        OnClick = btnReplaceAllClick
      end
      object btnReplace: TBitBtn
        Tag = 2
        Left = 112
        Top = 136
        Width = 77
        Height = 25
        Cancel = True
        Caption = '&Ersetzen'
        ModalResult = 2
        NumGlyphs = 2
        Spacing = -1
        TabOrder = 4
        Visible = False
        OnClick = btnReplaceClick
      end
    end
    object DetailControl: TTabControl
      Left = 1
      Top = 5
      Width = 506
      Height = 22
      Align = alTop
      TabOrder = 0
      Tabs.Strings = (
        'Suchen'
        'Ersetzen')
      TabIndex = 0
      OnChange = DetailControlChange
      OnChanging = DetailControlChanging
    end
    object PanTop: TPanel
      Left = 1
      Top = 1
      Width = 506
      Height = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 191
      Width = 506
      Height = 109
      Align = alClient
      Caption = 'Suchoptionen'
      TabOrder = 3
      object Label3: TLabel
        Left = 16
        Top = 24
        Width = 72
        Height = 15
        Caption = 'Such&richtung'
        FocusControl = cobDirection
      end
      object cobDirection: TComboBox
        Left = 112
        Top = 22
        Width = 105
        Height = 23
        Style = csDropDownList
        Color = clWhite
        TabOrder = 0
        OnChange = EditChange
        Items.Strings = (
          'Nach unten'
          'Nach oben'
          'Gesamt')
      end
      object chbCase: TCheckBox
        Left = 16
        Top = 56
        Width = 225
        Height = 17
        Caption = 'Gro&'#223'-/Kleinschreibung'
        Color = 13160660
        ParentColor = False
        TabOrder = 1
        OnClick = EditChange
      end
      object chbFieldMatch: TCheckBox
        Left = 16
        Top = 73
        Width = 225
        Height = 17
        Caption = '&Ganzes Feld vergleichen'
        Color = 13160660
        ParentColor = False
        TabOrder = 2
        OnClick = EditChange
      end
      object chbWildcards: TCheckBox
        Left = 16
        Top = 90
        Width = 225
        Height = 17
        Hint = 'wenn nicht angekreuzt wird ganzes Feld verglichen'
        Caption = '&Platzhalter verwenden ( * , ? )'
        Color = 13160660
        Enabled = False
        ParentColor = False
        TabOrder = 3
        Visible = False
        OnClick = EditChange
      end
      object btnSearchAll: TBitBtn
        Left = 200
        Top = 48
        Width = 113
        Height = 24
        Caption = 'Alle &suchen'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        TabOrder = 4
        Visible = False
      end
      object BtnClose: TBitBtn
        Left = 240
        Top = 24
        Width = 113
        Height = 24
        Caption = 'S&chlie'#223'en'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        TabOrder = 5
        Visible = False
      end
      object BtnSetFormFocus: TBitBtn
        Left = 313
        Top = 48
        Width = 129
        Height = 24
        Caption = 'BtnSetFormFocus'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        TabOrder = 6
        Visible = False
        OnClick = BtnSetFormFocusClick
      end
      object edAllFields: TEdit
        Left = 240
        Top = 72
        Width = 145
        Height = 23
        TabOrder = 7
        Text = '* (alle Tabellenspalten)'
        Visible = False
      end
    end
  end
  object Nav: TLNavigator
    FormKurz = 'REPLACEDLG'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnPostStart = NavPostStart
    OnSetTitel = NavSetTitel
    PollInterval = 1000
    OnPoll = NavPoll
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 417
    Top = 216
  end
  object PopupMenu1: TPopupMenu
    Left = 457
    Top = 215
    object MiCancel: TMenuItem
      Caption = 'Abbrechen'
      ShortCut = 27
      OnClick = BtnCancelClick
    end
  end
end
