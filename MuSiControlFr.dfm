object FrMusiControl: TFrMusiControl
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    ActivePage = tsMulti
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    OnChange = PCChange
    object tsMulti: TTabSheet
      Tag = 1
      Caption = 'Tabelle'
      ImageIndex = 1
      object Mu: TMultiGrid
        Left = 0
        Top = 0
        Width = 292
        Height = 232
        Align = alClient
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        ReturnSingle = False
        NoColumnSave = False
        MuOptions = [muNoAskLayout, muPostOnExit]
        DefaultRowHeight = 17
        Drag0Value = '0'
      end
    end
    object tsSingle: TTabSheet
      Caption = 'Detail'
    end
  end
end
