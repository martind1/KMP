object FrmBein: TFrmBein
  Left = 278
  Top = 128
  ActiveControl = EdBEIN_NR
  Caption = 'Beladeeinrichtungen'
  ClientHeight = 361
  ClientWidth = 507
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefault
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageBook: TNotebook
    Left = 0
    Top = 0
    Width = 463
    Height = 340
    Align = alClient
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Single'
      object Label1: TLabel
        Left = 24
        Top = 0
        Width = 55
        Height = 16
        Caption = 'Nummer'
      end
      object Label2: TLabel
        Left = 184
        Top = 1
        Width = 38
        Height = 16
        Caption = 'Name'
      end
      object Label3: TLabel
        Left = 82
        Top = 50
        Width = 34
        Height = 16
        Caption = 'Werk'
      end
      object Label4: TLabel
        Left = 8
        Top = 232
        Width = 74
        Height = 16
        Caption = '&Bemerkung'
        FocusControl = EdBEMERKUNG
      end
      object Label5: TLabel
        Left = 122
        Top = 110
        Width = 53
        Height = 16
        Caption = 'MyRech'
      end
      object Label6: TLabel
        Left = 56
        Top = 170
        Width = 55
        Height = 16
        Caption = 'BEIN_ID'
      end
      object Label7: TLabel
        Left = 8
        Top = 202
        Width = 105
        Height = 16
        Caption = 'BEIN_WERK_ID'
      end
      object Label8: TLabel
        Left = 112
        Top = 234
        Width = 105
        Height = 16
        Caption = 'Letzte '#196'nderung'
      end
      object EdBEIN_NR: TDBEdit
        Left = 16
        Top = 24
        Width = 121
        Height = 24
        DataField = 'BEIN_NR'
        DataSource = DSBein
        TabOrder = 0
      end
      object EdBEIN_NAME: TDBEdit
        Left = 184
        Top = 24
        Width = 121
        Height = 24
        DataField = 'BEIN_NAME'
        DataSource = DSBein
        TabOrder = 1
      end
      object BtnWerk: TButton
        Left = 336
        Top = 16
        Width = 89
        Height = 33
        Caption = 'Edit'
        TabOrder = 6
        OnClick = BtnWerkClick
      end
      object EdBEMERKUNG: TDBMemo
        Left = 0
        Top = 259
        Width = 463
        Height = 81
        DataField = 'BEMERKUNG'
        DataSource = DSBein
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object EdMYRECH: TDBEdit
        Left = 195
        Top = 110
        Width = 121
        Height = 24
        DataField = 'MYRECH'
        DataSource = DSBein
        TabOrder = 3
      end
      object EdWERK_NAMR: TDBEdit
        Left = 176
        Top = 72
        Width = 137
        Height = 24
        DataField = 'WERK_NAME'
        TabOrder = 2
      end
      object BtnDisable: TButton
        Left = 304
        Top = 160
        Width = 89
        Height = 33
        Caption = 'Disable'
        TabOrder = 8
        OnClick = BtnDisableClick
      end
      object EdBEIN_ID: TDBEdit
        Left = 120
        Top = 168
        Width = 121
        Height = 24
        DataField = 'BEIN_ID'
        DataSource = DSBein
        TabOrder = 4
      end
      object EdGEAENDERT_AM: TDBEdit
        Left = 232
        Top = 232
        Width = 121
        Height = 24
        DataField = 'GEAENDERT_AM'
        DataSource = DSBein
        TabOrder = 7
      end
      object EdERFASST_AM: TDBEdit
        Left = 256
        Top = 200
        Width = 121
        Height = 24
        DataField = 'ERFASST_AM'
        DataSource = DSBein
        TabOrder = 9
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Multi'
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object Panel1: TPanel
    Left = 463
    Top = 0
    Width = 44
    Height = 340
    Align = alRight
    TabOrder = 1
  end
  object LTabSet: TTabSet
    Left = 0
    Top = 340
    Width = 507
    Height = 21
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Tabs.Strings = (
      'Test')
  end
  object DSBein: TDataSource
    Left = 447
    Top = 28
  end
end
