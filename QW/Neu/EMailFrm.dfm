object FrmEMail: TFrmEMail
  Left = 864
  Top = 489
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  Caption = 'EMails'
  ClientHeight = 457
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poDefault
  ShowHint = True
  Visible = True
  WindowState = wsMinimized
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnAutomatik: TSpeedButton
      Left = 8
      Top = 8
      Width = 89
      Height = 22
      Hint = 'EMail automatisch senden'
      AllowAllUp = True
      GroupIndex = 1903
      Down = True
      Caption = 'Automatik'
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 41
    Width = 434
    Height = 375
    ActivePage = TabSheet6
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Aktion'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox4: TScrollBox
        Left = 0
        Top = 0
        Width = 426
        Height = 347
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 426
          Height = 345
          Align = alTop
          Caption = 'EMail'
          TabOrder = 0
          object Label6: TLabel
            Left = 8
            Top = 24
            Width = 16
            Height = 13
            Caption = 'An:'
          end
          object Label7: TLabel
            Left = 8
            Top = 136
            Width = 34
            Height = 13
            Caption = 'Betreff:'
          end
          object Label8: TLabel
            Left = 8
            Top = 168
            Width = 42
            Height = 13
            Caption = 'Anlagen:'
          end
          object Label10: TLabel
            Left = 8
            Top = 202
            Width = 24
            Height = 13
            Caption = 'Text:'
          end
          object LaRestTime: TLabel
            Left = 208
            Top = 314
            Width = 38
            Height = 13
            Caption = 'noch 0s'
            Visible = False
          end
          object LbEMailTo: TListBox
            Left = 56
            Top = 24
            Width = 337
            Height = 97
            ItemHeight = 13
            TabOrder = 0
          end
          object edEMailSubject: TEdit
            Left = 56
            Top = 134
            Width = 337
            Height = 21
            TabOrder = 1
          end
          object edEMailAttach: TEdit
            Left = 56
            Top = 166
            Width = 337
            Height = 21
            TabOrder = 2
          end
          object btnSend: TBitBtn
            Left = 8
            Top = 312
            Width = 81
            Height = 25
            Caption = 'Senden'
            Glyph.Data = {
              42010000424D4201000000000000760000002800000011000000110000000100
              040000000000CC00000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
              DDDDD0000000DDDDDDDDDDDDDDDDD0000000DDDDDDDDDDDDDDDDD0000000D000
              000000000000D0000000D0FFFFFFFFFFFFF0D0000000D0FFFF44444FFFF0D000
              0000D0FFFFFFFFFFFFF0D0000000D0FFFF444444FFF0D0000000D0FFFFFFFFFF
              FFF0D0000000D0FFFFFFFFFF11F0D0000000D0F0000FFFFF11F0D0000000D0FF
              FFFFFFFFFFF0D0000000D000000000000000D0000000DDDDDDDDDDDDDDDDD000
              0000DDDDDDDDDDDDDDDDD0000000DDDDDDDDDDDDDDDDD0000000DDDDDDDDDDDD
              DDDDD0000000}
            TabOrder = 5
            OnClick = btnSendClick
          end
          object btnEMailAttach: TBitBtn
            Left = 395
            Top = 166
            Width = 21
            Height = 21
            Caption = '...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            Layout = blGlyphBottom
            Margin = 1
            ParentFont = False
            Spacing = 0
            TabOrder = 3
            OnClick = btnEMailAttachClick
          end
          object MeEmailText: TMemo
            Left = 56
            Top = 200
            Width = 337
            Height = 89
            ScrollBars = ssVertical
            TabOrder = 4
            WordWrap = False
          end
          object chbTerminate: TCheckBox
            Left = 120
            Top = 312
            Width = 70
            Height = 17
            Hint = 'Anwendung beenden'
            Alignment = taLeftJustify
            Caption = 'Terminate'
            TabOrder = 6
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'EMail'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbProt: TGroupBox
        Left = 0
        Top = 0
        Width = 426
        Height = 205
        Align = alTop
        Caption = 'Nachrichtenversand'
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 106
          Width = 34
          Height = 13
          Caption = 'Betreff:'
        end
        object Label5: TLabel
          Left = 8
          Top = 132
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object btnCopyProtTo: TSpeedButton
          Left = 8
          Top = 18
          Width = 23
          Height = 22
          Caption = 'An:'
          Flat = True
          OnClick = btnCopyProtToClick
        end
        object LbProtTo: TListBox
          Left = 104
          Top = 40
          Width = 265
          Height = 59
          ItemHeight = 13
          TabOrder = 0
          OnKeyDown = LbDeleteDown
        end
        object edProtSubject: TEdit
          Left = 104
          Top = 104
          Width = 265
          Height = 21
          TabOrder = 1
          Text = '#'
        end
        object MeProtText: TMemo
          Left = 104
          Top = 130
          Width = 265
          Height = 59
          ScrollBars = ssBoth
          TabOrder = 2
          WordWrap = False
        end
        object edProtTo: TEdit
          Left = 104
          Top = 18
          Width = 244
          Height = 21
          TabOrder = 3
        end
        object btnProtTo: TBitBtn
          Left = 348
          Top = 18
          Width = 21
          Height = 21
          Hint = 'Hinzuf'#252'gen'
          Glyph.Data = {
            8A050000424D8A05000000000000360400002800000011000000110000000100
            0800000000005401000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
            A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000A4C8F0000080
            FF00A0A0A40000408000FF008000400080008040000000000000000000000000
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
            0000000000000000000000000000000000000000000000000000000000000000
            0000FFFBF0008080400000FF800000404000F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
            0707070707070707070707000000070707070707070707070707070707070700
            0000070707070707070707070707070707070700000007070707070707070707
            0707070707070700000007070707070707070707070707070707070014000707
            0000070707000007070707070707070000000707070000000707000000070707
            0707070000000707070707000000070700000007070707000000070707070707
            0700000007070000000707000000070707070700000007070000000707070700
            0000070707000000070700000007070707070700000007070000070707000007
            0707070707070700000007070707070707070707070707070707070000000707
            0707070707070707070707070707070000000707070707070707070707070707
            070707646F73070707070707070707070707070707070720006A070707070707
            07070707070707070707075F755F}
          TabOrder = 4
          OnClick = btnProtToClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'SMS'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 16
        Top = 280
        Width = 294
        Height = 52
        AutoSize = False
        Caption = 
          'T-Mobile:<Rufnummer>@t-mobile-sms.de (OPEN an 8000)'#13#10'Vodafone:<R' +
          'ufnummer>@vodafone-sms.de (OPEN an 3400)'#13#10'O2:<Rufnummer>@o2onlin' +
          'e.de (+OPEN an 6245)'#13#10'E-Plus:<Rufnummer>@smsmail.eplus.de (START' +
          ' an 7676245)'
        WordWrap = True
      end
      object pcSMS: TPageControl
        Left = 0
        Top = 0
        Width = 426
        Height = 187
        ActivePage = TsSmsGlobal
        Align = alTop
        TabOrder = 0
        object TsSmsGlobal: TTabSheet
          Caption = 'Global'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object gbStoer: TGroupBox
            Left = 0
            Top = 0
            Width = 418
            Height = 159
            Align = alClient
            Caption = 'Benachrichtigungen per SMS'
            TabOrder = 0
            object btnCopyStoerTo: TSpeedButton
              Left = 8
              Top = 18
              Width = 23
              Height = 22
              Caption = 'An:'
              Flat = True
              OnClick = btnCopyStoerToClick
            end
            object LbStoerTo: TListBox
              Left = 104
              Top = 42
              Width = 265
              Height = 87
              ItemHeight = 13
              TabOrder = 0
              OnDblClick = LbStoerToDblClick
              OnKeyDown = LbDeleteDown
            end
            object edStoerTo: TEdit
              Left = 104
              Top = 18
              Width = 244
              Height = 21
              TabOrder = 1
            end
            object BtnStoerTo: TBitBtn
              Left = 348
              Top = 18
              Width = 21
              Height = 21
              Hint = 'Hinzuf'#252'gen'
              Glyph.Data = {
                8A050000424D8A05000000000000360400002800000011000000110000000100
                0800000000005401000000000000000000000001000000000000000000000000
                80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
                A4000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000A4C8F0000080
                FF00A0A0A40000408000FF008000400080008040000000000000000000000000
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
                0000000000000000000000000000000000000000000000000000000000000000
                0000FFFBF0008080400000FF800000404000F0FBFF00A4A0A000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
                0707070707070707070707000000070707070707070707070707070707070700
                0000070707070707070707070707070707070700000007070707070707070707
                0707070707070700000007070707070707070707070707070707070014000707
                0000070707000007070707070707070000000707070000000707000000070707
                0707070000000707070707000000070700000007070707000000070707070707
                0700000007070000000707000000070707070700000007070000000707070700
                0000070707000000070700000007070707070700000007070000070707000007
                0707070707070700000007070707070707070707070707070707070000000707
                0707070707070707070707070707070000000707070707070707070707070707
                070707646F73070707070707070707070707070707070720006A070707070707
                07070707070707070707075F755F}
              TabOrder = 2
              OnClick = BtnStoerToClick
            end
            object chbStartSMS: TCheckBox
              Left = 6
              Top = 144
              Width = 201
              Height = 17
              Alignment = taLeftJustify
              Caption = 'Beim Programmstart benachrichtigen'
              TabOrder = 3
            end
            object BtnStoerEntf: TBitBtn
              Left = 369
              Top = 48
              Width = 40
              Height = 25
              Hint = 'markierte Zeile entfernen'
              Caption = 'entf'
              TabOrder = 4
              OnClick = BtnStoerEntfClick
            end
          end
        end
        object TsSmsGruppen: TTabSheet
          Caption = 'Gruppen'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 418
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object Label12: TLabel
              Left = 8
              Top = 8
              Width = 206
              Height = 13
              Caption = 'Aufbau: Handyname=Adresse1,Adresse2;...'
            end
            object BtnEMGR: TBitBtn
              Left = 232
              Top = 0
              Width = 25
              Height = 25
              Hint = 'E-Mail Gruppen editieren'
              Glyph.Data = {
                E6010000424DE60100000000000036000000280000000C0000000C0000000100
                180000000000B0010000CE0E0000C40E00000000000000000000C0C0C0C0C0C0
                C0C0C0000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C0C0C0000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C0C0C0C0C0C0C0000000808080000000C0C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000000000FFFF000000000000C0C0C0C0C0
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000000000FFFF000000000000C0
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000000000FFFF
                000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000
                0000FFFF000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C000000000FFFF000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C0C0C0C0C000000000FFFF000000000000C0C0C0C0C0C0C0C0C0C0C0
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000000000C0C0C0C0
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000000000FF000000000000
                C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000000000
                00C0C0C0C0C0C0C0C0C0}
              TabOrder = 0
              OnClick = BtnEMGRClick
            end
          end
          object LbSmsHandy: TListBox
            Left = 0
            Top = 25
            Width = 418
            Height = 134
            Align = alClient
            ItemHeight = 13
            TabOrder = 1
          end
        end
      end
      object BtnRefreshSmsHandy: TBitBtn
        Left = 24
        Top = 208
        Width = 75
        Height = 25
        Caption = 'einlesen'
        TabOrder = 1
        OnClick = BtnRefreshSmsHandyClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Einstellungen'
      ImageIndex = 5
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 426
        Height = 347
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object GroupBox6: TGroupBox
          Left = 0
          Top = 0
          Width = 426
          Height = 53
          Align = alTop
          Caption = 'Verzeichnisse'
          TabOrder = 0
          object LaOutBox: TLabel
            Left = 8
            Top = 24
            Width = 62
            Height = 13
            Caption = 'Postausgang'
          end
          object EdOutBox: TEdit
            Left = 80
            Top = 22
            Width = 265
            Height = 21
            Hint = 'leerlassen f'#252'r Vorgabe im Sendmail Server'
            TabOrder = 0
          end
          object BtnOutBox: TBitBtn
            Left = 345
            Top = 22
            Width = 21
            Height = 21
            Caption = '...'
            Layout = blGlyphBottom
            Margin = 5
            TabOrder = 1
            OnClick = BtnOutBoxClick
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 53
          Width = 426
          Height = 45
          Align = alTop
          TabOrder = 1
          object Label16: TLabel
            Left = 8
            Top = 16
            Width = 61
            Height = 13
            Caption = 'eigene EMail'
          end
          object EdUserEmail: TEdit
            Left = 80
            Top = 14
            Width = 265
            Height = 21
            Hint = 'leerlassen f'#252'r Vorgabe im Sendmail Server'
            TabOrder = 0
          end
        end
        object GroupBox2: TGroupBox
          Left = 0
          Top = 188
          Width = 426
          Height = 45
          Align = alTop
          TabOrder = 3
          object Label1: TLabel
            Left = 8
            Top = 16
            Width = 57
            Height = 13
            Caption = 'Poll Intervall'
          end
          object Label4: TLabel
            Left = 148
            Top = 16
            Width = 13
            Height = 13
            Caption = 'ms'
          end
          object edPollInterval: TEdit
            Left = 80
            Top = 14
            Width = 65
            Height = 21
            Hint = 'Intervall f'#252'r Abfrage in [ms]'
            TabOrder = 0
            Text = '5000'
            OnChange = edPollIntervalChange
          end
        end
        object GroupBox7: TGroupBox
          Left = 0
          Top = 233
          Width = 426
          Height = 77
          Align = alTop
          Caption = 'Optionen'
          TabOrder = 4
          object Label9: TLabel
            Left = 104
            Top = 24
            Width = 115
            Height = 13
            Caption = 'DataSet nicht zuordnen!'
            Visible = False
          end
          object Label13: TLabel
            Left = 104
            Top = 48
            Width = 129
            Height = 13
            Caption = 'ohne SendMailSvr (QuvaE)'
          end
          object chbEMAI: TCheckBox
            Left = 6
            Top = 23
            Width = 87
            Height = 17
            Hint = 'die Mail-Auftr'#228'ge liegen in der Datenbank'
            Alignment = taLeftJustify
            Caption = 'Auftr'#228'ge'
            TabOrder = 0
            OnClick = chbEMAIClick
          end
          object chbSMTP: TCheckBox
            Left = 6
            Top = 47
            Width = 87
            Height = 17
            Hint = 'die Mail-Auftr'#228'ge liegen in der Datenbank'
            Alignment = taLeftJustify
            Caption = 'SMTP direkt'
            TabOrder = 1
            OnClick = chbEMAIClick
          end
        end
        object GroupBox8: TGroupBox
          Left = 0
          Top = 98
          Width = 426
          Height = 90
          Align = alTop
          Caption = 'SMTP'
          TabOrder = 2
          object Label11: TLabel
            Left = 8
            Top = 24
            Width = 56
            Height = 13
            Caption = 'Server, Port'
          end
          object lbAccount: TLabel
            Left = 8
            Top = 45
            Width = 54
            Height = 13
            Caption = 'Kontoname'
            FocusControl = edSMTPAccount
          end
          object lbPassword: TLabel
            Left = 8
            Top = 66
            Width = 45
            Height = 13
            Caption = 'Kennwort'
            FocusControl = edSMTPPassword
          end
          object EdSMTPServer: TEdit
            Left = 80
            Top = 20
            Width = 155
            Height = 21
            TabOrder = 0
          end
          object EdSMTPPort: TEdit
            Left = 248
            Top = 20
            Width = 41
            Height = 21
            TabOrder = 1
            Text = '25'
          end
          object edSMTPAccount: TEdit
            Left = 80
            Top = 41
            Width = 155
            Height = 21
            TabOrder = 2
          end
          object edSMTPPassword: TEdit
            Left = 80
            Top = 62
            Width = 155
            Height = 21
            PasswordChar = '*'
            TabOrder = 3
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Auftr'#228'ge'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object qSplitter1: TqSplitter
        Left = 0
        Top = 218
        Width = 426
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clGray
        ParentColor = False
        ExplicitTop = 169
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 222
        Width = 426
        Height = 125
        Align = alClient
        Caption = 'Protokoll'
        TabOrder = 0
        ExplicitTop = 262
        ExplicitHeight = 85
        object MuEMAI: TMultiGrid
          Left = 2
          Top = 15
          Width = 422
          Height = 108
          Align = alClient
          DataSource = LuEMAIProt
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawDataCell = MuEMAIDrawDataCell
          ColumnList.Strings = (
            'Status:3=STATUS'
            'von:12=EMAI_FROM'
            'an:12=EMAI_TO'
            'Betreff:20=EMAI_SUBJECT'
            'ge'#228'ndert am:15=GEAENDERT_AM'
            'ID:9=EMAI_ID')
          ReturnSingle = False
          NoColumnSave = False
          MuOptions = [muNoAskLayout, muPostOnExit]
          DefaultRowHeight = 17
          Drag0Value = '0'
        end
      end
      object PanEmaiTop: TPanel
        Left = 0
        Top = 0
        Width = 426
        Height = 218
        Align = alTop
        BevelOuter = bvNone
        Caption = 'PanEmaiTop'
        ShowCaption = False
        TabOrder = 1
        object qSplitter2: TqSplitter
          Left = 0
          Top = 134
          Width = 426
          Height = 4
          Cursor = crVSplit
          Align = alTop
          Color = clSilver
          ParentColor = False
          ExplicitTop = 105
          ExplicitWidth = 31
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 138
          Width = 426
          Height = 80
          Align = alClient
          Caption = 'zu senden'
          TabOrder = 0
          ExplicitTop = 136
          ExplicitHeight = 122
          object Mu1: TMultiGrid
            Left = 2
            Top = 15
            Width = 422
            Height = 63
            Align = alClient
            DataSource = LDataSource1
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDrawDataCell = Mu1DrawDataCell
            ColumnList.Strings = (
              'Status:3=STATUS'
              'von:12=EMAI_FROM'
              'an:12=EMAI_TO'
              'Betreff:20=EMAI_SUBJECT'
              'erfasst am:15=ERFASST_AM'
              'ID:9=EMAI_ID')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit]
            DefaultRowHeight = 17
            Drag0Value = '0'
          end
        end
        object GroupBox9: TGroupBox
          Left = 0
          Top = 0
          Width = 426
          Height = 134
          Align = alTop
          Caption = 'zu verarbeiten'
          TabOrder = 1
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'System'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object BtnTerminate: TBitBtn
        Left = 8
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Terminate'
        TabOrder = 0
        OnClick = BtnTerminateClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 416
    Width = 434
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinHeight = 41
    TabOrder = 2
    object BtnOK: TBitBtn
      Left = 248
      Top = 8
      Width = 177
      Height = 25
      Hint = 'Einstellungen speichern'
      Caption = 'Einstellungen speichern'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnOKClick
    end
  end
  object Nav: TLNavigator
    DetailBook = PageControl1
    FormKurz = 'EMAIL'
    AutoEditStart = False
    PageBookStart = '1'
    DetailBookStart = '3'
    StaticFields = False
    Options = [lnSavePosition]
    OnPostStart = NavPostStart
    PollInterval = 3000
    OnPoll = NavPoll
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = False
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    FormatList.Strings = (
      'STATUS=Asw,EmailStatus')
    Bemerkung.Strings = (
      '! notwendig:'
      'ZLV_DATE desc;ZLV_TIME desc')
    KeyFields = 'EMAI_ID'
    PrimaryKeyFields = 'EMAI_ID'
    References.Strings = (
      'STATUS=N')
    TableName = 'EMAILS'
    OnBuildSql = NavBuildSql
    Left = 208
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 8
  end
  object LuEMAIProt: TLookUpDef
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    FormatList.Strings = (
      'STATUS=Asw,EmailStatus')
    KeyList.Strings = (
      'Standard=EMAI_ID desc')
    PrimaryKeyFields = 'EMAI_ID'
    References.Strings = (
      'STATUS=<>N;=')
    TableName = 'EMAILS'
    DisabledButtons = []
    EnabledButtons = []
    Left = 312
    Top = 8
  end
  object EmailSendKmp: TEmailSendKmp
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Smtp = False
    SmtpPort = 25
    SmtpAuth = False
    SmtpAfterPop = False
    Left = 28
    Top = 142
  end
  object JvBrowseForFolderDialog: TJvBrowseForFolderDialog
    Left = 376
    Top = 8
  end
  object Query1: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMAILS'
      'where (STATUS = '#39'N'#39')'
      'order by EMAI_ID')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 272
    Top = 8
  end
  object TblEMAIProt: TuQuery
    Connection = DlgLogon.Database1
    SQL.Strings = (
      'select *'
      'from EMAILS'
      'where ((STATUS <> '#39'N'#39') or (STATUS is null ))')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'Oracle.FetchAll=False')
    DatabaseName = 'DB1'
    RequestLive = True
    UpdateMode = upWhereAll
    Left = 344
    Top = 8
  end
  object LDataSource1: TuDataSource
    Left = 240
    Top = 8
  end
end
