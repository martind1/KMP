object SocketForm: TSocketForm
  Left = 340
  Top = 366
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Borland Socket Server'
  ClientHeight = 432
  ClientWidth = 429
  Color = clBtnFace
  Constraints.MinHeight = 386
  Constraints.MinWidth = 359
  ParentFont = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pages: TPageControl
    Left = 89
    Top = 0
    Width = 340
    Height = 432
    ActivePage = StatPage
    Align = alClient
    TabOrder = 0
    object PropPage: TTabSheet
      Caption = 'Eigenschaften'
      object PortGroup: TGroupBox
        Left = 8
        Top = 8
        Width = 322
        Height = 97
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Port'
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 20
          Width = 84
          Height = 13
          Alignment = taRightJustify
          Caption = 'Port ü&berwachen:'
          FocusControl = PortNo
        end
        object PortDesc: TLabel
          Left = 8
          Top = 40
          Width = 272
          Height = 53
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Per Konvention sind mit bestimmten Diensten wie FTP oder HTTP ei' +
            'nige Werte für Port festgelegt. Port ist die ID der Verbindung, ' +
            'die der Server nach Client-Anforderungen überwacht.'
          WordWrap = True
        end
        object PortNo: TEdit
          Left = 120
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '1'
          OnExit = IntegerExit
        end
        object PortUpDown: TUpDown
          Left = 193
          Top = 16
          Width = 12
          Height = 21
          Associate = PortNo
          Min = 1
          Max = 32767
          Position = 1
          TabOrder = 1
          Thousands = False
          Wrap = False
          OnClick = UpDownClick
        end
      end
      object ThreadGroup: TGroupBox
        Left = 8
        Top = 112
        Width = 322
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Thread-Puffer'
        TabOrder = 1
        object Label4: TLabel
          Left = 19
          Top = 16
          Width = 125
          Height = 13
          Alignment = taRightJustify
          Caption = '&Größe des Thread-Puffers:'
          FocusControl = ThreadSize
        end
        object ThreadDesc: TLabel
          Left = 8
          Top = 39
          Width = 306
          Height = 39
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Die Größe des Thread-Puffers ist die max. Anzahl von Threads, di' +
            'e für neue Client-Verbindungen wiederverwendet werden können.'
          WordWrap = True
        end
        object ThreadSize: TEdit
          Left = 154
          Top = 12
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '0'
          OnExit = IntegerExit
        end
        object ThreadUpDown: TUpDown
          Left = 227
          Top = 12
          Width = 12
          Height = 21
          Associate = ThreadSize
          Min = 0
          Max = 1000
          Position = 0
          TabOrder = 1
          Thousands = False
          Wrap = False
          OnClick = UpDownClick
        end
      end
      object InterceptGroup: TGroupBox
        Left = 8
        Top = 288
        Width = 322
        Height = 184
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Auffang-GUID'
        TabOrder = 3
        object Label5: TLabel
          Left = 16
          Top = 20
          Width = 30
          Height = 13
          Caption = 'G&UID:'
        end
        object GUIDDesc: TLabel
          Left = 16
          Top = 40
          Width = 298
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Auffang-GUID ist die GUID für ein COM-Objekt, das Daten auffängt' +
            '. Weitere Informationen finden Sie in der Hilfe unter TSocketCon' +
            'nection.'
          WordWrap = True
        end
        object InterceptGUID: TEdit
          Left = 56
          Top = 16
          Width = 257
          Height = 21
          TabOrder = 0
        end
      end
      object TimeoutGroup: TGroupBox
        Left = 8
        Top = 200
        Width = 322
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Timeout'
        TabOrder = 2
        object Label7: TLabel
          Left = 23
          Top = 16
          Width = 95
          Height = 13
          Alignment = taRightJustify
          Caption = '&Inaktivitäts-Timeout:'
          FocusControl = Timeout
        end
        object TimeoutDesc: TLabel
          Left = 16
          Top = 36
          Width = 298
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Der Inaktivitäts-Timeout gibt die Minuten an, die ein Client vor' +
            ' Trennung der Verbindung inaktiv bleiben kann. (0 = unbegrenzt)'
          WordWrap = True
        end
        object Timeout: TEdit
          Left = 132
          Top = 12
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '0'
          OnExit = IntegerExit
        end
        object TimeoutUpDown: TUpDown
          Left = 205
          Top = 12
          Width = 12
          Height = 21
          Associate = Timeout
          Min = 0
          Max = 32767
          Increment = 30
          Position = 0
          TabOrder = 1
          Wrap = False
          OnClick = UpDownClick
        end
      end
      object ApplyButton: TButton
        Tag = -1
        Left = 125
        Top = 376
        Width = 75
        Height = 25
        Action = ApplyAction
        Anchors = [akTop, akRight]
        TabOrder = 4
      end
    end
    object StatPage: TTabSheet
      Caption = 'Benutzer'
      object ConnectionList: TListView
        Left = 0
        Top = 0
        Width = 332
        Height = 385
        Align = alClient
        Columns = <
          item
            Caption = 'IP-Adresse'
          end
          item
            AutoSize = True
            Caption = 'Host'
          end
          item
            AutoSize = True
            Caption = 'Letzte Aktivität'
          end
          item
            AutoSize = True
            Caption = 'Last Activity'
          end>
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ConnectionListColumnClick
        OnCompare = ConnectionListCompare
      end
      object UserStatus: TStatusBar
        Left = 0
        Top = 385
        Width = 332
        Height = 19
        Panels = <>
        SimplePanel = True
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 89
    Height = 432
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object PortList: TListBox
      Left = 0
      Top = 17
      Width = 89
      Height = 415
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 0
      OnClick = PortListClick
    end
    object HeaderControl1: THeaderControl
      Left = 0
      Top = 0
      Width = 89
      Height = 17
      DragReorder = False
      Sections = <
        item
          AllowClick = False
          AutoSize = True
          ImageIndex = -1
          Text = 'Port'
          Width = 89
        end>
    end
  end
  object PopupMenu: TPopupMenu
    Left = 192
    Top = 8
    object miClose: TMenuItem
      Caption = 'S&chließen'
      OnClick = miCloseClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miProperties: TMenuItem
      Caption = '&Eigenschaften'
      Default = True
      OnClick = miPropertiesClick
    end
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = UpdateTimerTimer
    Left = 224
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 136
    object miPorts: TMenuItem
      Caption = '&Ports'
      object miAdd: TMenuItem
        Caption = 'Hin&zufügen'
        OnClick = miAddClick
      end
      object miRemove: TMenuItem
        Action = RemovePortAction
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = '&Beenden'
        OnClick = miExitClick
      end
    end
    object Connections1: TMenuItem
      Caption = '&Verbindungen'
      object miShowHostName: TMenuItem
        Action = ShowHostAction
      end
      object ExportedObjectOnly1: TMenuItem
        Action = RegisteredAction
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miDisconnect: TMenuItem
        Action = DisconnectAction
      end
    end
  end
  object ActionList1: TActionList
    Left = 8
    Top = 168
    object ApplyAction: TAction
      Caption = 'Ü&bernehmen'
      OnExecute = ApplyActionExecute
      OnUpdate = ApplyActionUpdate
    end
    object DisconnectAction: TAction
      Caption = '&Verbindung trennen'
      OnExecute = miDisconnectClick
      OnUpdate = DisconnectActionUpdate
    end
    object ShowHostAction: TAction
      Caption = 'Host-Name an&zeigen'
      Checked = True
      OnExecute = ShowHostActionExecute
    end
    object RemovePortAction: TAction
      Caption = 'E&ntfernen'
      OnExecute = RemovePortActionExecute
      OnUpdate = RemovePortActionUpdate
    end
    object RegisteredAction: TAction
      Caption = '&Nur registrierte Objekte'
      Checked = True
      OnExecute = RegisteredActionExecute
    end
  end
end
