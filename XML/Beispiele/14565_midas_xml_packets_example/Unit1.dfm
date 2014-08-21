object Form1: TForm1
  Left = 363
  Top = 241
  Width = 662
  Height = 571
  Caption = 'MIDAS XML Sample'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 168
    Width = 60
    Height = 13
    Caption = 'Data Packet'
  end
  object Label2: TLabel
    Left = 568
    Top = 72
    Width = 25
    Height = 13
    Caption = 'Delta'
  end
  object Label4: TLabel
    Left = 360
    Top = 56
    Width = 62
    Height = 13
    Caption = 'Delta Packet'
  end
  object Label5: TLabel
    Left = 360
    Top = 280
    Width = 59
    Height = 13
    Caption = 'Error Packet'
  end
  object Label3: TLabel
    Left = 480
    Top = 280
    Width = 56
    Height = 13
    Caption = 'Error Count:'
  end
  object lblErrorCount: TLabel
    Left = 544
    Top = 280
    Width = 60
    Height = 13
    Caption = 'lblErrorCount'
  end
  object btnGetServerXML: TButton
    Left = 8
    Top = 504
    Width = 89
    Height = 25
    Caption = 'Get Server XML'
    TabOrder = 0
    OnClick = btnGetServerXMLClick
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 72
    Width = 320
    Height = 129
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object memServerXML: TMemo
    Left = 8
    Top = 232
    Width = 321
    Height = 265
    Lines.Strings = (
      'memServerXML')
    TabOrder = 2
  end
  object btnApplyUpdates: TButton
    Left = 360
    Top = 504
    Width = 75
    Height = 25
    Caption = 'Apply Updates'
    TabOrder = 3
    OnClick = btnApplyUpdatesClick
  end
  object memDelta: TMemo
    Left = 360
    Top = 72
    Width = 281
    Height = 137
    Lines.Strings = (
      'memDelta')
    TabOrder = 4
  end
  object memErrors: TMemo
    Left = 360
    Top = 296
    Width = 281
    Height = 201
    Lines.Strings = (
      'memErrors')
    TabOrder = 5
  end
  object btnGetDelta: TButton
    Left = 360
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Get Delta'
    TabOrder = 6
    OnClick = btnGetDeltaClick
  end
  object cbUseProvider: TRadioButton
    Left = 24
    Top = 8
    Width = 145
    Height = 17
    Caption = 'Use MIDAS Server'
    Checked = True
    TabOrder = 7
    TabStop = True
  end
  object cbUseDCOMConnection: TRadioButton
    Left = 24
    Top = 32
    Width = 161
    Height = 17
    Caption = 'Use DCOM Connection'
    TabOrder = 8
  end
  object DCOMConnection1: TDCOMConnection
    ServerGUID = '{930FAEE3-0DC1-11D3-AA8A-00A024C11562}'
    ServerName = 'rdmCustomerData.CustomerData'
    Left = 392
    Top = 24
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 280
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 248
    Top = 8
  end
  object Table1: TTable
    DatabaseName = 'DBDEMOS'
    TableName = 'customer.db'
    Left = 584
    Top = 16
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = Table1
    Constraints = True
    Left = 536
    Top = 16
  end
end
