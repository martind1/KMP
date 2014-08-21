object Form1: TForm1
  Left = 398
  Top = 167
  Caption = 'Form1'
  ClientHeight = 164
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 16
    Caption = 'Filename'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 38
    Height = 16
    Caption = 'Daten'
  end
  object LaStatus: TLabel
    Left = 8
    Top = 104
    Width = 19
    Height = 16
    Caption = 'OK'
  end
  object BtnHost: TButton
    Left = 8
    Top = 128
    Width = 89
    Height = 33
    Caption = 'Host'
    TabOrder = 0
    OnClick = BtnHostClick
  end
  object BtnClient: TButton
    Left = 104
    Top = 128
    Width = 89
    Height = 33
    Caption = 'Client'
    TabOrder = 1
    OnClick = BtnClientClick
  end
  object EdFilename: TEdit
    Left = 80
    Top = 8
    Width = 185
    Height = 24
    TabOrder = 2
    Text = 'k:\dpe.zak\client1\'
  end
  object MeDaten: TMemo
    Left = 80
    Top = 48
    Width = 185
    Height = 49
    TabOrder = 3
  end
  object BtnWaage: TButton
    Left = 200
    Top = 128
    Width = 89
    Height = 33
    Caption = 'Waage'
    TabOrder = 4
    OnClick = BtnWaageClick
  end
end
