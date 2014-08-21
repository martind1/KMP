object DlgErr: TDlgErr
  Left = 631
  Top = 288
  Caption = 'Fehler'
  ClientHeight = 376
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object TabbedNotebook1: TTabbedNotebook
    Left = 0
    Top = 0
    Width = 546
    Height = 335
    Align = alClient
    PageIndex = 1
    TabFont.Charset = ANSI_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -13
    TabFont.Name = 'Arial'
    TabFont.Style = []
    TabOrder = 0
    OnChange = TabbedNotebook1Change
    object TTabPage
      Left = 4
      Top = 27
      Caption = '&Allgemein'
      ExplicitTop = 24
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EdAllgTxt: TMemo
        Left = 0
        Top = 0
        Width = 538
        Height = 304
        Align = alClient
        Lines.Strings = (
          'EdAllgTxt')
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitHeight = 325
      end
    end
    object TTabPage
      Left = 4
      Top = 27
      Caption = '&Datenbank'
      ExplicitTop = 6
      ExplicitHeight = 325
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 538
        Height = 48
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 12
          Top = 8
          Width = 54
          Height = 16
          Caption = 'Nummer'
        end
        object Label2: TLabel
          Left = 12
          Top = 31
          Width = 87
          Height = 16
          Caption = '&Beschreibung'
        end
        object EdERRM_NR: TDBEdit
          Left = 76
          Top = 6
          Width = 99
          Height = 24
          DataField = 'ERRM_NR'
          DataSource = DataSource1
          ReadOnly = True
          TabOrder = 0
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 48
        Width = 538
        Height = 223
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 244
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 12
          Height = 223
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitHeight = 244
        end
        object MemoERRM_BESCHR: TDBMemo
          Left = 12
          Top = 0
          Width = 514
          Height = 223
          Align = alClient
          DataField = 'ERRM_BESCHR'
          DataSource = DataSource1
          PopupMenu = PopupMenu1
          TabOrder = 1
          ExplicitHeight = 244
        end
        object Panel6: TPanel
          Left = 526
          Top = 0
          Width = 12
          Height = 223
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitHeight = 244
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 271
        Width = 538
        Height = 33
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitTop = 292
        DesignSize = (
          538
          33)
        object BtnChange: TBitBtn
          Left = 376
          Top = 4
          Width = 72
          Height = 27
          Anchors = [akTop, akRight]
          Caption = '&'#196'ndern'
          TabOrder = 0
          OnClick = BtnChangeClick
        end
      end
    end
    object TTabPage
      Left = 4
      Top = 27
      Caption = 'Stack'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object MeErrStack: TMemo
        Left = 0
        Top = 0
        Width = 538
        Height = 304
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'MeErrStack')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 325
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 335
    Width = 546
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      546
      41)
    object OKBtn: TBitBtn
      Left = 457
      Top = 8
      Width = 77
      Height = 26
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        CE070000424DCE07000000000000360000002800000024000000120000000100
        1800000000009807000000000000000000000000000000000000007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7FFFFFFF007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F7F00007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F7F7F7FFFFFFF
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F7F0000007F00007F007F0000007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        7F7F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F7F0000007F00007F00007F0000
        7F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F000000
        7F00007F00007F00007F00007F00007F007F0000007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F007F7F007F7F007F7F007F
        7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F7F0000007F00007F00007F0000FF00007F00007F00007F00007F00
        7F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFF
        FF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F7F7F7FFFFFFF007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F00007F00007F0000FF00007F7F
        00FF00007F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F7F7F7FFFFFFF007F7F7F7F7F007F7F7F7F7FFFFFFF007F7F00
        7F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00
        007F0000FF00007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF7F7F7F007F7F00
        7F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F00FF00007F7F007F7F007F7F007F7F007F7F00FF
        00007F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F7F7F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F
        7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF0000
        7F00007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F
        7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F00FF00007F00007F00007F007F0000007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F7F7F7FFFFFFF007F7F007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00007F00
        007F00007F007F0000007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF007F7F007F7F7F7F7FFF
        FFFF007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F00FF00007F00007F007F0000007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F
        7F7FFFFFFF007F7F7F7F7FFFFFFF007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00FF00007F00007F
        00007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F7F7F7FFFFFFF7F7F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F00FF00007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F7F7F7F
        007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F
        7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F00
        7F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F007F7F
        007F7F007F7F007F7F007F7F007F7F007F7F}
      Margin = 2
      ModalResult = 1
      NumGlyphs = 2
      Spacing = -1
      TabOrder = 0
      OnClick = OKBtnClick
      IsControl = True
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    Left = 437
    Top = 69
  end
  object PopupMenu1: TPopupMenu
    Left = 264
    object MiSQL: TMenuItem
      Caption = 'SQL'
      OnClick = MiSQLClick
    end
    object MiTerminate: TMenuItem
      Caption = 'Terminate'
      OnClick = MiTerminateClick
    end
  end
end
