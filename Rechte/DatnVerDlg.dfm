object DlgDatnVer: TDlgDatnVer
  Left = 592
  Top = 568
  Caption = 'Programmversion verteilen'
  ClientHeight = 298
  ClientWidth = 859
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 859
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel4'
    ShowCaption = False
    TabOrder = 0
    object LaZip: TLabel
      Left = 8
      Top = 8
      Width = 79
      Height = 16
      Caption = 'Update Archiv'
    end
    object LaApp: TLabel
      Left = 8
      Top = 34
      Width = 67
      Height = 16
      Caption = 'Anwendung'
      FocusControl = EdApp
    end
    object LaVersion: TLabel
      Left = 8
      Top = 58
      Width = 43
      Height = 16
      Caption = 'Version'
      FocusControl = EdVersion
    end
    object EdZip: TEdit
      Left = 104
      Top = 6
      Width = 497
      Height = 24
      ReadOnly = True
      TabOrder = 0
      Text = 'EdZip'
      OnChange = EditChange
    end
    object BtnZip: TFileBtn
      Left = 601
      Top = 6
      Width = 21
      Height = 21
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
        0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
        FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
        0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
        FF00000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
        0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
      TabOrder = 1
      OnClick = BtnZipClick
      DBEdit = EdZip
      Options = []
    end
    object EdApp: TEdit
      Left = 104
      Top = 32
      Width = 121
      Height = 24
      ReadOnly = True
      TabOrder = 2
      Text = 'EdApp'
      OnChange = EditChange
    end
    object EdVersion: TEdit
      Left = 104
      Top = 56
      Width = 121
      Height = 24
      ReadOnly = True
      TabOrder = 3
      Text = 'EdVersion'
      OnChange = EditChange
    end
    object MeComment: TMemo
      Tag = 128
      Left = 256
      Top = 32
      Width = 593
      Height = 57
      Hint = 
        'Ersetzen Sie <*Kommentar> durch den einzeiligen sprachbezogenen ' +
        'Update-Text f'#252'r das Popup.'
      Lines.Strings = (
        'Comment=<Kommentar>'
        'Comment.pl=<Polnischer Kommentar>')
      ScrollBars = ssVertical
      TabOrder = 4
      WordWrap = False
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 97
    Width = 859
    Height = 201
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel5'
    ShowCaption = False
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 283
      Top = 0
      Width = 576
      Height = 201
      Align = alClient
      Caption = 'Protokoll'
      TabOrder = 0
      object lbProt: TListBox
        Left = 2
        Top = 18
        Width = 572
        Height = 181
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 283
      Height = 201
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 1
      object Panel3: TPanel
        Left = 0
        Top = 160
        Width = 283
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel3'
        ShowCaption = False
        TabOrder = 0
        object BtnStart: TBitBtn
          Left = 16
          Top = 8
          Width = 75
          Height = 25
          Caption = '&Starten'
          Default = True
          NumGlyphs = 2
          TabOrder = 0
          OnClick = BtnStartClick
        end
        object BtnClose: TBitBtn
          Left = 128
          Top = 8
          Width = 97
          Height = 25
          Cancel = True
          Caption = 'Schlie'#223'en'
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
            F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
            000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
            338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
            45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
            3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
            F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
            000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
            338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
            4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
            8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
            333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
            0000}
          ModalResult = 2
          NumGlyphs = 2
          TabOrder = 1
          OnClick = BtnCloseClick
        end
      end
      object gbVerteilen: TGroupBox
        Left = 0
        Top = 0
        Width = 283
        Height = 160
        Align = alClient
        Caption = 'Verteilen'
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 24
          Width = 29
          Height = 16
          Caption = 'Alias'
        end
        object cobAlias: TComboBox
          Left = 72
          Top = 22
          Width = 145
          Height = 24
          AutoComplete = False
          DropDownCount = 30
          TabOrder = 0
          Text = 'cobAlias'
          OnClick = cobAliasClick
        end
        object BtnAdd: TBitBtn
          Left = 217
          Top = 22
          Width = 25
          Height = 25
          Hint = 'Hinzuf'#252'gen'
          Caption = '>>'
          TabOrder = 1
          OnClick = BtnAddClick
        end
        object BtnSub: TBitBtn
          Left = 245
          Top = 22
          Width = 25
          Height = 25
          Hint = 'markierten Alias entfernen'
          Caption = '<<'
          TabOrder = 2
          OnClick = BtnSubClick
        end
        object lbAlias: TListBox
          Left = 16
          Top = 50
          Width = 201
          Height = 113
          TabOrder = 3
        end
      end
    end
  end
end
