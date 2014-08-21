object DlgPrn: TDlgPrn
  Left = 388
  Top = 419
  ActiveControl = PrnList
  Caption = 'Drucken Dialog'
  ClientHeight = 343
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 530
    Height = 258
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object qSplitter1: TqSplitter
      Left = 297
      Top = 0
      Width = 4
      Height = 258
      Color = clGray
      ParentColor = False
      SavePosition = True
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 297
      Height = 258
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 297
        Height = 27
        Align = alTop
        TabOrder = 0
        object PrnLabel: TLabel
          Left = 6
          Top = 5
          Width = 55
          Height = 16
          Caption = 'Ausdruck'
          FocusControl = PrnList
          IsControl = True
        end
      end
      object PrnList: TListBox
        Left = 0
        Top = 27
        Width = 297
        Height = 231
        Hint = 'mehrere Ausdrucke mit Strg-Taste markieren'
        Align = alClient
        Items.Strings = (
          'Eintrag1'
          'Eintrag2'
          'Eintrag3'
          'Eintrag4'
          'Eintrag5')
        MultiSelect = True
        TabOrder = 1
        OnClick = PrnListClick
        OnDblClick = PrnListDblClick
        IsControl = True
      end
    end
    object Panel4: TPanel
      Left = 301
      Top = 0
      Width = 229
      Height = 258
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 229
        Height = 27
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 6
          Top = 5
          Width = 45
          Height = 16
          Caption = 'Drucker'
          FocusControl = PrnList
          IsControl = True
        end
      end
      object DevList: TListBox
        Left = 0
        Top = 27
        Width = 229
        Height = 231
        Hint = 'Drucker '#252'ber [Einrichten] '#228'ndern'
        Align = alClient
        ExtendedSelect = False
        Items.Strings = (
          'Drucker1'
          'Drucker2'
          'Drucker3'
          'Drucker4'
          'Drucker5')
        TabOrder = 1
        OnClick = DevListClick
        OnDblClick = DevListDblClick
        IsControl = True
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 299
    Width = 530
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object BtnScr: TBitBtn
      Left = 9
      Top = 6
      Width = 96
      Height = 34
      Hint = 'Seitenansicht'
      Caption = '&Bildschirm'
      Default = True
      ModalResult = -1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      OnClick = BtnScrClick
      IsControl = True
    end
    object BtnCancel: TBitBtn
      Left = 346
      Top = 6
      Width = 96
      Height = 34
      Hint = 'Nicht drucken'
      Cancel = True
      Caption = '&Schlie'#223'en'
      Glyph.Data = {
        9E050000424D9E05000000000000360400002800000012000000120000000100
        0800000000006801000000000000000000000001000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
        A400000080000080000000808000800000008000800080800000FFFBF0008080
        400000FF800000404000A4C8F0000080FF00A0A0A40000408000FF0080004000
        8000804000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
        0707070707070707070707070000070707070707070707070707070707070707
        000007070707070000000000000000070707070700000707070700F9F9F9F9F9
        F9F9F90007070707000007070700F9F9F9F9F9F9F9F9F9F90007070700000707
        00F9F9F9F9F9F9F9F9F9F9F9F90007070000070700F9F9F9F9F9F9F9F9F9F9F9
        F90007070000070700FFFFFFF9FFF9FFF9FFF9FFF90007070000070700FFF9F9
        F9FFF9FFF9FFF9FFF9000707FFFF070700FFFFF9F9F9FFF9F9FFF9FFF9000707
        FFFF070700FFF9F9F9FFF9FFF9FFF9FFF9000707FFFF070700FFFFFFF9FFF9FF
        F9FFFFFFFF0007074800070700F9F9F9F9F9F9F9F9F9F9F9F900070712000707
        0700F9F9F9F9F9F9F9F9F9F90007070700000707070700F9F9F9F9F9F9F9F900
        0707070707070707070707000000000000000007070707070707070707070707
        0707070707070707070707070707070707070707070707070707070707070707
        0707}
      Margin = 2
      ModalResult = 2
      Spacing = -1
      TabOrder = 3
      OnClick = BtnCancelClick
      IsControl = True
    end
    object BtnPrn: TBitBtn
      Left = 121
      Top = 6
      Width = 96
      Height = 34
      Hint = 'Ausgabe auf Drucker'
      Caption = '&Drucker'
      ModalResult = -2
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 1
      OnClick = BtnPrnClick
      IsControl = True
    end
    object BtnSetUp: TBitBtn
      Left = 233
      Top = 6
      Width = 96
      Height = 34
      Hint = 'Drucker ausw'#228'hlen / Layout bearbeiten'
      Caption = '&Einrichten'
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 2
      OnClick = BtnSetUpClick
      IsControl = True
    end
  end
  object BtnRun: TBitBtn
    Left = 385
    Top = 203
    Width = 96
    Height = 34
    Hint = 'Seitenansicht'
    Caption = 'Run invisible'
    Default = True
    ModalResult = -1
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
    Visible = False
    OnClick = BtnRunClick
    IsControl = True
  end
  object Panel7: TPanel
    Left = 0
    Top = 258
    Width = 530
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 183
      Height = 41
      Align = alLeft
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 10
        Width = 106
        Height = 16
        Caption = 'Anzahl Exemplare'
        IsControl = True
      end
      object BtnKopien: TqSpin
        Left = 156
        Top = 9
        Width = 15
        Height = 22
        DownGlyph.Data = {
          0E010000424D0E01000000000000360000002800000009000000060000000100
          200000000000D800000000000000000000000000000000000000008080000080
          8000008080000080800000808000008080000080800000808000008080000080
          8000008080000080800000808000000000000080800000808000008080000080
          8000008080000080800000808000000000000000000000000000008080000080
          8000008080000080800000808000000000000000000000000000000000000000
          0000008080000080800000808000000000000000000000000000000000000000
          0000000000000000000000808000008080000080800000808000008080000080
          800000808000008080000080800000808000}
        TabOrder = 0
        UpGlyph.Data = {
          0E010000424D0E01000000000000360000002800000009000000060000000100
          200000000000D800000000000000000000000000000000000000008080000080
          8000008080000080800000808000008080000080800000808000008080000080
          8000000000000000000000000000000000000000000000000000000000000080
          8000008080000080800000000000000000000000000000000000000000000080
          8000008080000080800000808000008080000000000000000000000000000080
          8000008080000080800000808000008080000080800000808000000000000080
          8000008080000080800000808000008080000080800000808000008080000080
          800000808000008080000080800000808000}
        DBEdit = EdKopien
        MaxValue = 99
        MinValue = 1
        StartValue = 1
        StepValue = 1
        Mask = '0'
      end
      object EdKopien: TEdit
        Left = 122
        Top = 8
        Width = 34
        Height = 24
        TabOrder = 1
        Text = '1'
        OnKeyDown = EdKopienKeyDown
      end
    end
    object Panel9: TPanel
      Left = 183
      Top = 0
      Width = 125
      Height = 41
      Align = alLeft
      TabOrder = 1
      object PanOrientation: TPanel
        Left = 1
        Top = 1
        Width = 123
        Height = 39
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object rgOrientation: TRadios
          Left = 0
          Top = -4
          Width = 130
          Height = 34
          Hint = 'Hochformat oder Querformat'
          Caption = 'rgAktuell'
          Columns = 2
          Items.Strings = (
            'hoch'
            'quer')
          TabOrder = 0
          OnClick = rgOrientationClick
          Frame = frNone
        end
      end
    end
    object Panel11: TPanel
      Left = 308
      Top = 0
      Width = 222
      Height = 41
      Align = alClient
      TabOrder = 2
      object Panel12: TPanel
        Left = 1
        Top = 1
        Width = 220
        Height = 39
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object rgAktuell: TRadios
          Left = 0
          Top = -4
          Width = 264
          Height = 34
          Hint = 'welche Datens'#228'tze drucken'
          Caption = 'rgAktuell'
          Columns = 3
          ItemIndex = 2
          Items.Strings = (
            'aktueller'
            'markierte'
            'alle')
          TabOrder = 0
          OnClick = rgAktuellClick
          Frame = frNone
        end
      end
    end
  end
  object Nav: TLNavigator
    FormKurz = 'PRN__DLG'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    PollInterval = 0
    AutoCommit = False
    AutoOpen = False
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = False
    NoGotoPos = False
    Left = 421
    Top = 8
  end
end
