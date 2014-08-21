object FrmWsDDe: TFrmWsDDe
  Left = 884
  Top = 503
  Width = 368
  Height = 442
  Caption = 'WSDDE Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 360
    Height = 112
    ActivePage = Client
    Align = alTop
    TabOrder = 0
    OnChange = PageControl1Change
    object Server: TTabSheet
      Caption = 'Server'
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 30
        Height = 13
        Caption = 'Befehl'
      end
      object BtnAntwort: TSpeedButton
        Left = 4
        Top = 30
        Width = 46
        Height = 21
        AllowAllUp = True
        GroupIndex = 2133
        Caption = 'Antwort'
        Flat = True
        OnClick = BtnAntwortClick
      end
      object EdClientRead: TEdit
        Left = 72
        Top = 6
        Width = 177
        Height = 21
        TabOrder = 0
        Text = 'Befehl'
      end
      object EdClientWrite: TEdit
        Left = 72
        Top = 30
        Width = 177
        Height = 21
        TabOrder = 1
        Text = 'Antwort'
        OnChange = EdPortChange
      end
    end
    object Client: TTabSheet
      Caption = 'Client'
      ImageIndex = 1
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 22
        Height = 13
        Caption = 'Host'
      end
      object Label7: TLabel
        Left = 8
        Top = 32
        Width = 42
        Height = 13
        Caption = 'Empfang'
      end
      object BtnWrite: TSpeedButton
        Left = 2
        Top = 54
        Width = 47
        Height = 21
        AllowAllUp = True
        GroupIndex = 45
        Caption = 'Senden'
        Flat = True
        OnClick = BtnWriteClick
      end
      object EdHost: TEdit
        Left = 72
        Top = 6
        Width = 177
        Height = 21
        TabOrder = 0
        OnChange = EdHostChange
      end
      object EdRead: TEdit
        Left = 72
        Top = 30
        Width = 177
        Height = 21
        TabOrder = 1
        Text = 'Empfang'
        OnChange = EdPortChange
      end
      object EdWrite: TEdit
        Left = 72
        Top = 54
        Width = 177
        Height = 21
        TabOrder = 2
        Text = 'Senden'
        OnChange = EdPortChange
      end
    end
  end
  object lbProt: TListBox
    Left = 0
    Top = 153
    Width = 360
    Height = 261
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 41
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 19
      Height = 13
      Caption = 'Port'
    end
    object EdPort: TEdit
      Left = 40
      Top = 6
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '8'
      OnChange = EdPortChange
    end
  end
  object WSDDE1: TWSDDE
    PollIntervall = 5000
    Remote = reHost
    Port = 0
    OnChange = WSDDECliChange
    Left = 240
    Top = 32
  end
end
