inherited fraCoverSheetDisplayPanel_WidgetClock: TfraCoverSheetDisplayPanel_WidgetClock
  inherited pnlMain: TPanel
    inherited img: TImage
      ExplicitHeight = 291
    end
    inherited pnlWorkspace: TPanel
      AlignWithMargins = True
      Left = 34
      Top = 33
      Width = 469
      Height = 350
      PopupMenu = pmn
      ExplicitLeft = 34
      ExplicitTop = 33
      ExplicitWidth = 469
      ExplicitHeight = 350
      object lblTime: TStaticText
        Left = 0
        Top = 0
        Width = 469
        Height = 350
        Align = alClient
        Alignment = taCenter
        Caption = 'lblTime'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        Transparent = False
      end
    end
  end
  object tmrClock: TTimer [2]
    Enabled = False
    OnTimer = tmrClockTimer
    Left = 144
    Top = 8
  end
end
