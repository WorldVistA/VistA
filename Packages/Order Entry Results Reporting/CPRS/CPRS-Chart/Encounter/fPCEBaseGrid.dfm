inherited frmPCEBaseGrid: TfrmPCEBaseGrid
  Left = 128
  Top = 192
  Caption = 'frmPCEBaseGrid'
  ClientWidth = 620
  ExplicitHeight = 436
  TextHeight = 13
  inherited pnlBottomAncestor: TPanel
    Width = 620
    ExplicitTop = 370
    ExplicitWidth = 616
    inherited btnOK: TBitBtn
      ExplicitTop = 3
    end
    inherited btnCancel: TBitBtn
      ExplicitLeft = 538
      ExplicitTop = 3
    end
  end
  inherited pnlMainAncestor: TPanel
    Width = 620
    ExplicitHeight = 370
    object pnlGrid: TPanel
      Left = 0
      Top = 0
      Width = 620
      Height = 371
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 238
      ExplicitWidth = 451
      ExplicitHeight = 87
      object lstCaptionList: TCaptionListView
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 614
        Height = 365
        Align = alClient
        Color = clCream
        Columns = <
          item
            Width = 30
          end
          item
            Tag = 1
            Width = 120
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChanging = lstCaptionListChanging
        AutoSize = False
        ExplicitLeft = 0
        ExplicitWidth = 435
        ExplicitHeight = 81
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPCEBaseGrid'
        'Status = stsDefault')
      (
        'Component = lstCaptionList'
        'Status = stsDefault'
        'Columns'
        ()))
  end
end
