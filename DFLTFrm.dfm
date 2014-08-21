object FrmGEBI: TFrmGEBI
  Left = 586
  Top = 441
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeable
  Caption = 'Default'
  ClientHeight = 433
  ClientWidth = 591
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = True
  Position = poDefaultPosOnly
  Scaled = False
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 591
    Height = 408
    ActivePage = tsSingle
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
    end
    object tsSingle: TTabSheet
      Caption = 'Details'
      object DetailControl: TPageControl
        Left = 0
        Top = 49
        Width = 563
        Height = 349
        ActivePage = tsEtc
        Align = alClient
        TabOrder = 1
        object tsEtc: TTabSheet
          Caption = '&etc.'
          object ScrollBox5: TScrollBox
            Left = 0
            Top = 0
            Width = 555
            Height = 319
            HorzScrollBar.Tracking = True
            VertScrollBar.Tracking = True
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
          end
        end
        object tsSystem: TTabSheet
          Caption = 'S&ystem'
          ImageIndex = 1
          object ScrollBox4: TScrollBox
            Left = 0
            Top = 0
            Width = 555
            Height = 319
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
            object GbStatisitk: TGroupBox
              Left = 0
              Top = 0
              Width = 555
              Height = 97
              Align = alTop
              TabOrder = 0
              object Label29: TLabel
                Left = 8
                Top = 18
                Width = 108
                Height = 15
                Caption = 'Erfasst von, am, DB'
              end
              object Label31: TLabel
                Left = 8
                Top = 42
                Width = 120
                Height = 15
                Caption = 'Geändert von, am, DB'
              end
              object Label33: TLabel
                Left = 8
                Top = 66
                Width = 106
                Height = 15
                Caption = 'Anzahl Änderungen'
              end
              object Label34: TLabel
                Left = 245
                Top = 66
                Width = 12
                Height = 15
                Caption = 'ID'
              end
              object EdERFASST_VON: TDBEdit
                Left = 141
                Top = 16
                Width = 122
                Height = 23
                Hint = 'ERFASST_VON'
                DataField = 'ERFASST_VON'
                ReadOnly = True
                TabOrder = 0
              end
              object EdERFASST_AM: TDBEdit
                Left = 264
                Top = 16
                Width = 140
                Height = 23
                Hint = 'ERFASST_AM'
                DataField = 'ERFASST_AM'
                ReadOnly = True
                TabOrder = 1
              end
              object EdGEAENDERT_VON: TDBEdit
                Left = 141
                Top = 40
                Width = 122
                Height = 23
                Hint = 'GEAENDERT_VON'
                DataField = 'GEAENDERT_VON'
                ReadOnly = True
                TabOrder = 2
              end
              object EdGEAENDERT_AM: TDBEdit
                Left = 264
                Top = 40
                Width = 140
                Height = 23
                Hint = 'GEAENDERT_AM'
                DataField = 'GEAENDERT_AM'
                ReadOnly = True
                TabOrder = 3
              end
              object EdANZAHL_AENDERUNGEN: TDBEdit
                Left = 141
                Top = 64
                Width = 84
                Height = 23
                Hint = 'ANZAHL_AENDERUNGEN'
                DataField = 'ANZAHL_AENDERUNGEN'
                ReadOnly = True
                TabOrder = 4
              end
              object edID: TDBEdit
                Left = 264
                Top = 64
                Width = 84
                Height = 23
                Hint = 'Ident'
                DataField = 'GEBI_ID'
                ReadOnly = True
                TabOrder = 5
              end
              object edERFASST_DATENBANK: TDBEdit
                Left = 405
                Top = 16
                Width = 122
                Height = 23
                Hint = 'ERFASST_DATENBANK'
                DataField = 'ERFASST_DATENBANK'
                ReadOnly = True
                TabOrder = 6
              end
              object edGEAENDERT_DATENBANK: TDBEdit
                Left = 405
                Top = 40
                Width = 122
                Height = 23
                Hint = 'GEAENDERT_DATENBANK'
                DataField = 'GEAENDERT_DATENBANK'
                ReadOnly = True
                TabOrder = 7
              end
            end
          end
        end
      end
      object Panel1: TScrollBox
        Left = 0
        Top = 0
        Width = 563
        Height = 49
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alTop
        TabOrder = 0
      end
    end
  end
  object TabControl: TTabControl
    Left = 0
    Top = 408
    Width = 591
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 1
    Tabs.Strings = (
      'Tab1')
    TabIndex = 0
  end
end
