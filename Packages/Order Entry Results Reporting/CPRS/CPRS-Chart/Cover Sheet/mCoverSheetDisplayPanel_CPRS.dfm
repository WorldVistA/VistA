inherited fraCoverSheetDisplayPanel_CPRS: TfraCoverSheetDisplayPanel_CPRS
  inherited pnlMain: TPanel
    inherited pnlWorkspace: TPanel
      object lvData: TListView
        AlignWithMargins = True
        Left = 2
        Top = 2
        Width = 469
        Height = 350
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        BorderStyle = bsNone
        Columns = <>
        ColumnClick = False
        HotTrack = True
        HotTrackStyles = [htHandPoint, htUnderlineHot]
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnEnter = lvDataEnter
        OnExit = lvDataExit
        OnKeyDown = lvDataKeyDown
        OnMouseDown = lvDataMouseDown
        OnSelectItem = lvDataSelectItem
      end
    end
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 144
    Top = 8
  end
end
