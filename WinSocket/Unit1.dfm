object Form1: TForm1
  Left = 884
  Top = 503
  Width = 368
  Height = 442
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 360
    Height = 201
    ActivePage = Client
    Align = alTop
    TabOrder = 0
    object Server: TTabSheet
      Caption = 'Server'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 19
        Height = 13
        Caption = 'Port'
      end
      object BtnSvrActive: TSpeedButton
        Left = 112
        Top = 8
        Width = 65
        Height = 22
        AllowAllUp = True
        GroupIndex = 1815
        Caption = 'Active'
        OnClick = BtnSvrActiveClick
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 30
        Height = 13
        Caption = 'Befehl'
      end
      object Label3: TLabel
        Left = 256
        Top = 64
        Width = 15
        Height = 13
        Caption = '  :  '
      end
      object BtnAntwort: TSpeedButton
        Left = 4
        Top = 62
        Width = 46
        Height = 21
        Caption = 'Antwort'
        Flat = True
        OnClick = BtnAntwortClick
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
      object EdClientRead: TEdit
        Left = 72
        Top = 38
        Width = 177
        Height = 21
        TabOrder = 1
        Text = 'Befehl'
        OnChange = EdPortChange
      end
      object EdSendText: TEdit
        Left = 276
        Top = 62
        Width = 43
        Height = 21
        TabOrder = 2
        OnChange = EdPortChange
      end
      object EdClientWrite: TEdit
        Left = 72
        Top = 62
        Width = 177
        Height = 21
        TabOrder = 3
        Text = 'Antwort'
        OnChange = EdPortChange
      end
    end
    object Client: TTabSheet
      Caption = 'Client'
      ImageIndex = 1
      object BtnCliActive: TSpeedButton
        Left = 112
        Top = 8
        Width = 65
        Height = 22
        AllowAllUp = True
        GroupIndex = 1815
        Caption = 'Active'
        OnClick = BtnCliActiveClick
      end
      object Label5: TLabel
        Left = 8
        Top = 40
        Width = 38
        Height = 13
        Caption = 'Address'
      end
      object Label6: TLabel
        Left = 8
        Top = 64
        Width = 22
        Height = 13
        Caption = 'Host'
      end
      object Label7: TLabel
        Left = 8
        Top = 88
        Width = 42
        Height = 13
        Caption = 'Empfang'
      end
      object Label8: TLabel
        Left = 248
        Top = 112
        Width = 15
        Height = 13
        Caption = '  :  '
      end
      object BtnWrite: TSpeedButton
        Left = 2
        Top = 110
        Width = 47
        Height = 21
        AllowAllUp = True
        GroupIndex = 45
        Caption = 'Senden'
        Flat = True
        OnClick = BtnWriteClick
      end
      object BtnCliCheckActive: TSpeedButton
        Left = 184
        Top = 8
        Width = 65
        Height = 22
        AllowAllUp = True
        GroupIndex = 1815
        Caption = 'Check'
        OnClick = BtnCliCheckActiveClick
      end
      object EdAddress: TEdit
        Left = 72
        Top = 38
        Width = 177
        Height = 21
        TabOrder = 0
        Text = '127.0.0.1'
        OnChange = EdAddressChange
      end
      object EdHost: TEdit
        Left = 72
        Top = 62
        Width = 177
        Height = 21
        TabOrder = 1
        OnChange = EdHostChange
      end
      object EdRead: TEdit
        Left = 72
        Top = 86
        Width = 177
        Height = 21
        TabOrder = 2
        Text = 'Empfang'
        OnChange = EdPortChange
      end
      object EdWriSendText: TEdit
        Left = 268
        Top = 110
        Width = 43
        Height = 21
        TabOrder = 3
        OnChange = EdPortChange
      end
      object EdWrite: TEdit
        Left = 72
        Top = 110
        Width = 177
        Height = 21
        TabOrder = 4
        Text = 'Senden'
        OnChange = EdPortChange
      end
    end
  end
  object lbProt: TListBox
    Left = 0
    Top = 201
    Width = 360
    Height = 214
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 7
    ServerType = stNonBlocking
    OnListen = ServerSocket1Listen
    OnAccept = ServerSocket1Accept
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientWrite = ServerSocket1ClientWrite
    OnClientError = ServerSocket1ClientError
    Left = 104
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnLookup = ClientSocket1Lookup
    OnConnecting = ClientSocket1Connecting
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnWrite = ClientSocket1Write
    OnError = ClientSocket1Error
    Left = 136
  end
end
