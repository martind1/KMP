object FrmINITED: TFrmINITED
  Left = 303
  Top = 309
  HorzScrollBar.Tracking = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSizeable
  Caption = 'INIT Editor'
  ClientHeight = 405
  ClientWidth = 783
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
  WindowState = wsMinimized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object TabControl: TTabControl
    Left = 0
    Top = 380
    Width = 783
    Height = 25
    Align = alBottom
    Style = tsButtons
    TabOrder = 0
    Tabs.Strings = (
      'Tab1')
    TabIndex = 0
    object btnImport: TBitBtn
      Left = 168
      Top = 0
      Width = 75
      Height = 25
      Hint = 'Import von .INI Files'
      Caption = 'INI Import'
      TabOrder = 0
      OnClick = btnImportClick
    end
    object btnCopy: TBitBtn
      Left = 243
      Top = 0
      Width = 75
      Height = 25
      Hint = 
        'Kopiert Einträge zu anderer Anwendung, Maschine, User oder Grupp' +
        'e'
      Caption = '&Kopieren'
      TabOrder = 1
      OnClick = btnCopyClick
    end
    object btnEditor: TBitBtn
      Left = 636
      Top = 0
      Width = 125
      Height = 25
      Hint = 'Einträge in Texteditor bearbeiten'
      Anchors = [akTop, akRight]
      Caption = '&Bearbeiten als Text'
      TabOrder = 2
      OnClick = btnEditorClick
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 783
    Height = 380
    ActivePage = tsMulti
    Align = alClient
    MultiLine = True
    TabOrder = 1
    TabPosition = tpRight
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Übersicht'
      ImageIndex = 1
      object panTop: TPanel
        Left = 0
        Top = 0
        Width = 755
        Height = 65
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object sbTop: TScrollBox
          Left = 0
          Top = 0
          Width = 755
          Height = 65
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
          object btnFltrAnwe: TSpeedButton
            Left = 8
            Top = 0
            Width = 81
            Height = 22
            Hint = 'Filter aktivieren'
            AllowAllUp = True
            GroupIndex = 457
            Down = True
            Caption = 'Anwendung'
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            OnClick = btnFltrAnweClick
          end
          object btnFltrMach: TSpeedButton
            Left = 230
            Top = 0
            Width = 69
            Height = 22
            Hint = 'Filter aktivieren'
            AllowAllUp = True
            GroupIndex = 458
            Down = True
            Caption = 'Maschine'
            OnClick = btnFltrClick
          end
          object btnFltrUser: TSpeedButton
            Left = 456
            Top = 0
            Width = 43
            Height = 22
            Hint = 'Filter aktivieren'
            AllowAllUp = True
            GroupIndex = 459
            Down = True
            Caption = 'User'
            OnClick = btnFltrClick
          end
          object btnFltrVorg: TSpeedButton
            Left = 8
            Top = 24
            Width = 62
            Height = 22
            Hint = 'Filter aktivieren'
            AllowAllUp = True
            GroupIndex = 460
            Down = True
            Caption = 'Vorgabe'
            OnClick = btnFltrClick
          end
          object btnFltrSect: TSpeedButton
            Left = 352
            Top = 24
            Width = 57
            Height = 22
            Hint = 'Filter aktivieren'
            AllowAllUp = True
            GroupIndex = 461
            Caption = 'Section'
            OnClick = btnFltrSectClick
          end
          object cobFltrAnwe: TComboBox
            Left = 89
            Top = 0
            Width = 104
            Height = 23
            Color = clWhite
            DropDownCount = 32
            ItemHeight = 15
            TabOrder = 0
            OnChange = btnFltrAnweClick
            OnClick = btnFltrAnweClick
            OnKeyPress = cobFltrKeyPress
          end
          object cobFltrMach: TComboBox
            Left = 299
            Top = 0
            Width = 120
            Height = 23
            Color = clWhite
            DropDownCount = 32
            ItemHeight = 15
            TabOrder = 1
            OnChange = btnFltrAnweClick
            OnClick = btnFltrAnweClick
            OnKeyPress = cobFltrKeyPress
          end
          object cobFltrUser: TComboBox
            Left = 500
            Top = 0
            Width = 119
            Height = 23
            Color = clWhite
            DropDownCount = 32
            ItemHeight = 15
            TabOrder = 2
            OnChange = btnFltrAnweClick
            OnClick = btnFltrAnweClick
            OnKeyPress = cobFltrKeyPress
          end
          object cobFltrVorg: TComboBox
            Left = 70
            Top = 24
            Width = 179
            Height = 23
            Hint = 'Gruppe(n) für Vorgabe. % = alle.'
            Color = clWhite
            DropDownCount = 32
            ItemHeight = 15
            TabOrder = 3
            Text = '%'
            OnChange = btnFltrAnweClick
            OnClick = btnFltrAnweClick
            OnKeyPress = cobFltrKeyPress
          end
          object cobFltrSect: TComboBox
            Tag = 128
            Left = 409
            Top = 24
            Width = 96
            Height = 23
            Color = clWhite
            DropDownCount = 32
            ItemHeight = 15
            TabOrder = 4
            OnChange = btnFltrAnweClick
            OnClick = btnFltrAnweClick
            OnDblClick = cobFltrSectDblClick
          end
          object lovFltrAnwe: TLovBtn
            Left = 193
            Top = 0
            Width = 21
            Height = 21
            Hint = 'Werteliste aus Datenbank'
            TabOrder = 5
            OnClick = lovFltrAnweClick
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
              0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
              000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C0000000000000000000000000000000000000000000000000000000
              00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
            DataField = 'ANWENDUNG'
            Fields = 'ANWENDUNG'
            LovFlags = []
          end
          object lovFltrMach: TLovBtn
            Left = 419
            Top = 0
            Width = 21
            Height = 21
            Hint = 'Werteliste aus Datenbank'
            TabOrder = 6
            OnClick = lovFltrMachClick
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
              0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
              000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C0000000000000000000000000000000000000000000000000000000
              00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
            DataField = 'NAME'
            Fields = 'NAME'
            LovFlags = []
          end
          object lovFltrUser: TLovBtn
            Left = 619
            Top = 0
            Width = 21
            Height = 21
            Hint = 'Werteliste aus Datenbank'
            TabOrder = 7
            OnClick = lovFltrUserClick
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000000000000000000000000000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
              0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
              000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C0000000000000000000000000000000000000000000000000000000
              00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
              C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000}
            DataField = 'NAME'
            Fields = 'NAME'
            LovFlags = []
          end
        end
      end
      object panCenter: TPanel
        Left = 0
        Top = 65
        Width = 755
        Height = 305
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object qSplitter1: TqSplitter
          Left = 313
          Top = 0
          Width = 4
          Height = 305
          Cursor = crHSplit
          Color = clGray
          ParentColor = False
          SavePosition = True
          ResizeStyle = rsPattern
        end
        object MuEntry: TMultiGrid
          Left = 317
          Top = 0
          Width = 438
          Height = 305
          Align = alClient
          DataSource = LuEntry
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clBlack
          TitleFont.Height = -12
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          ColumnList.Strings = (
            'Parameter:12=PARAM'
            'Wert:30=WERT')
          ReturnSingle = False
          NoColumnSave = False
          MuOptions = [muNoAskLayout, muAutoExpand, muPostOnExit, muCustColor, muNoSlideBar]
          DefaultRowHeight = 19
          Drag0Value = '0'
        end
        object lbMu1ColsLokal: TListBox
          Left = 40
          Top = 112
          Width = 121
          Height = 97
          ItemHeight = 15
          Items.Strings = (
            'T:9=TYP'
            'Section:25=SECTION')
          TabOrder = 2
          Visible = False
        end
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 313
          Height = 305
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 3
          object Mu1: TMultiGrid
            Left = 0
            Top = 0
            Width = 313
            Height = 305
            Align = alClient
            Constraints.MinWidth = 32
            DataSource = LDataSource1
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
            TabOrder = 0
            TitleFont.Charset = ANSI_CHARSET
            TitleFont.Color = clBlack
            TitleFont.Height = -12
            TitleFont.Name = 'Arial'
            TitleFont.Style = []
            ColumnList.Strings = (
              'Anw.:7=ANWENDUNG'
              'T:2=TYP'
              'Name:12=NAME'
              'Section:25=SECTION')
            ReturnSingle = False
            NoColumnSave = False
            MuOptions = [muNoAskLayout, muPostOnExit]
            DefaultRowHeight = 19
            Drag0Value = '0'
          end
        end
        object btnMu1: TBitBtn
          Left = 48
          Top = 56
          Width = 129
          Height = 41
          Caption = '&Anzeigen'
          Default = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clGreen
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnMu1Click
        end
      end
    end
  end
  object Nav: TLNavigator
    TabSet = TabControl
    PageBook = PageControl
    FormKurz = 'INITED'
    AutoEditStart = True
    PageBookStart = '1'
    DetailBookStart = '0'
    StaticFields = False
    Options = [lnSavePosition]
    OnStart = NavStart
    OnPostStart = NavPostStart
    PollInterval = 0
    DataSource = LDataSource1
    EditSource = LDataSource1
    AutoCommit = True
    AutoOpen = True
    ConfirmDelete = True
    EditSingle = True
    ErfassSingle = True
    NoOpen = True
    NoGotoPos = False
    FormatList.Strings = (
      'TYP=Asw,InitTyp')
    Bemerkung.Strings = (
      'VERB_PRIO=000.#####')
    KeyList.Strings = (
      'Standard=SECTION'
      'Typ=ANWENDUNG;TYP;NAME;SECTION')
    PrimaryKeyFields = 'ANWENDUNG;TYP;NAME;SECTION'
    SqlFieldList.Strings = (
      'distinct ANWENDUNG'
      'TYP'
      'NAME'
      'SECTION')
    TableName = 'R_INIT'
    BeforeDelete = NavBeforeDelete
    BeforeEdit = NavBeforeEdit
    BeforeInsert = NavBeforeInsert
    Left = 394
    Top = 129
  end
  object LDataSource1: TLDataSource
    DataSet = Query1
    OnStateChange = LDataSource1StateChange
    Left = 336
    Top = 129
  end
  object Query1: TuQuery
    BeforeOpen = Query1BeforeOpen
    AfterOpen = Query1AfterOpen
    AfterClose = Query1AfterClose
    DatabaseName = 'DB1'
    SQL.Strings = (
      'select distinct ANWENDUNG,'
      '       TYP,'
      '       NAME,'
      '       SECTION'
      'from R_INIT')
    UpdateMode = upWhereKeyOnly
    Left = 364
    Top = 129
  end
  object PsDflt: TPrnSource
    QRepKurz = 'DFLT'
    Preview = True
    NoPreview = False
    Visible = True
    Display = 'Standard Liste'
    DruckerTyp = 'Liste'
    CopyFltr = True
    OneRecord = False
    Kopien = 1
    FaxApi = NoFax
    Options = [psMessage]
    ExportFile = False
    BeforePrn = PsDfltBeforePrn
    Left = 424
    Top = 129
  end
  object LuEntry: TLookUpDef
    DataSet = TblEntry
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle, nlNoOpenSMess]
    DeleteDetails = True
    LinkToGNav = True
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    KeyFields = 'INIT_ID'
    PrimaryKeyFields = 'INIT_ID'
    References.Strings = (
      'ANWENDUNG=:ANWENDUNG'
      'TYP=:TYP'
      'NAME=:NAME'
      'SECTION=:SECTION')
    SOList.Strings = (
      'ANWENDUNG=:ANWENDUNG'
      'TYP=:TYP'
      'NAME=:NAME'
      'SECTION=:SECTION')
    SqlFieldList.Strings = (
      'PARAM'
      'WERT'
      'INIT_ID'
      'ANWENDUNG'
      'TYP'
      'NAME'
      'SECTION')
    TableName = 'R_INIT'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 468
    Top = 135
  end
  object TblEntry: TuQuery
    AfterInsert = TblEntryAfterInsert
    AfterPost = TblEntryAfterPost
    DatabaseName = 'DB1'
    DataSource = LDataSource1
    RequestLive = True
    SQL.Strings = (
      'select PARAM,'
      '       WERT,'
      '       INIT_ID,'
      '       ANWENDUNG,'
      '       TYP,'
      '       NAME,'
      '       SECTION'
      'from R_INIT'
      'where (ANWENDUNG = :ANWENDUNG)'
      '  and (TYP = :TYP)'
      '  and (NAME = :NAME)'
      '  and (SECTION = :SECTION)'
      'order by INIT_ID')
    UpdateMode = upWhereKeyOnly
    Left = 500
    Top = 135
    ParamData = <
      item
        DataType = ftFixedChar
        Name = 'ANWENDUNG'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'TYP'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'NAME'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'SECTION'
        ParamType = ptUnknown
      end>
  end
  object LuLOV: TLookUpDef
    DataSet = TblLOV
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = False
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdMaster
    PrimaryKeyFields = 'INIT_ID'
    TableName = 'R_INIT'
    DisabledButtons = []
    EnabledButtons = []
    Left = 340
    Top = 175
  end
  object TblLOV: TuQuery
    DatabaseName = 'DB1'
    SQL.Strings = (
      'select *'
      'from R_INIT')
    Left = 372
    Top = 175
  end
  object LuINIT: TLookUpDef
    DataSet = TblINIT
    LuKurz = 'INIT'
    LuMultiName = 'Multi'
    LookUpTyp = lupFMask
    Options = [luMessage, LuTabelle]
    DeleteDetails = False
    LinkToGNav = False
    AutoOpen = True
    ConfirmDelete = False
    EditSingle = False
    ErfassSingle = False
    NoOpen = True
    NoGotoPos = False
    MDTyp = mdDetail
    PrimaryKeyFields = 'ANWENDUNG;TYP;NAME;SECTION'
    References.Strings = (
      'ANWENDUNG=:ANWENDUNG'
      'TYP=:TYP'
      'NAME=:NAME'
      'SECTION=:SECTION')
    SqlFieldList.Strings = (
      'ANWENDUNG'
      'TYP'
      'NAME'
      'SECTION')
    TableName = 'R_INIT'
    TabTitel = 'Initialisierungen'
    MasterSource = LDataSource1
    DisabledButtons = []
    EnabledButtons = []
    Left = 348
    Top = 223
  end
  object TblINIT: TuQuery
    DatabaseName = 'DB1'
    DataSource = LDataSource1
    SQL.Strings = (
      'select ANWENDUNG,'
      '       TYP,'
      '       NAME,'
      '       SECTION'
      'from R_INIT'
      'where (ANWENDUNG = :ANWENDUNG)'
      '  and (TYP = :TYP)'
      '  and (NAME = :NAME)'
      '  and (SECTION = :SECTION)')
    Left = 380
    Top = 223
    ParamData = <
      item
        DataType = ftFixedChar
        Name = 'ANWENDUNG'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'TYP'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'NAME'
        ParamType = ptUnknown
      end
      item
        DataType = ftFixedChar
        Name = 'SECTION'
        ParamType = ptUnknown
      end>
  end
end
