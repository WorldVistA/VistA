inherited fraCoverSheetDisplayPanel_CPRS: TfraCoverSheetDisplayPanel_CPRS
  inherited pnlMain: TPanel
    inherited pnlHeader: TPanel
      inherited lblTitle: TLabel
        Width = 443
        Height = 19
      end
    end
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
        OnDeletion = lvDataDeletion
        OnEnter = lvDataEnter
        OnExit = lvDataExit
        OnKeyDown = lvDataKeyDown
        OnMouseDown = lvDataMouseDown
        OnSelectItem = lvDataSelectItem
      end
    end
  end
  inherited pmn: TPopupMenu
    Left = 120
  end
  object tmr: TTimer
    Enabled = False
    OnTimer = tmrTimer
    Left = 72
    Top = 56
  end
end
