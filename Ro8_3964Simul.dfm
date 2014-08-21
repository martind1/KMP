object DlgRo8Simul: TDlgRo8Simul
  Left = 395
  Top = 135
  BorderStyle = bsDialog
  Caption = 'DlgRo8Simul'
  ClientHeight = 231
  ClientWidth = 183
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 128
    Height = 16
    Caption = 'Simulation Rowa 8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 73
    Width = 47
    Height = 13
    Caption = 'Waage 1:'
  end
  object Label3: TLabel
    Left = 16
    Top = 98
    Width = 47
    Height = 13
    Caption = 'Waage 2:'
  end
  object Label4: TLabel
    Left = 16
    Top = 123
    Width = 47
    Height = 13
    Caption = 'Waage 3:'
  end
  object Label5: TLabel
    Left = 16
    Top = 148
    Width = 47
    Height = 13
    Caption = 'Waage 4:'
  end
  object Label6: TLabel
    Left = 16
    Top = 173
    Width = 47
    Height = 13
    Caption = 'Waage 5:'
  end
  object Label7: TLabel
    Left = 16
    Top = 198
    Width = 47
    Height = 13
    Caption = 'Waage 6:'
  end
  object Label8: TLabel
    Left = 16
    Top = 40
    Width = 87
    Height = 16
    Caption = 'alle Werte in N'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Tag = 1
    Left = 72
    Top = 69
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
    OnChange = SpinEditChange
  end
  object SpinEdit2: TSpinEdit
    Tag = 2
    Left = 72
    Top = 94
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnChange = SpinEditChange
  end
  object SpinEdit3: TSpinEdit
    Tag = 3
    Left = 72
    Top = 119
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = SpinEditChange
  end
  object SpinEdit4: TSpinEdit
    Tag = 4
    Left = 72
    Top = 144
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
    OnChange = SpinEditChange
  end
  object SpinEdit5: TSpinEdit
    Tag = 5
    Left = 72
    Top = 169
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
    OnChange = SpinEditChange
  end
  object SpinEdit6: TSpinEdit
    Tag = 6
    Left = 72
    Top = 194
    Width = 72
    Height = 22
    Increment = 200
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
    OnChange = SpinEditChange
  end
end
