inherited frmPCEBaseGrid: TfrmPCEBaseGrid
  Left = 128
  Top = 192
  Caption = 'frmPCEBaseGrid'
  PixelsPerInch = 96
  TextHeight = 16
  inherited btnCancel: TBitBtn
    TabOrder = 2
  end
  object pnlGrid: TPanel [2]
    Left = 6
    Top = 238
    Width = 451
    Height = 87
    BevelOuter = bvNone
    TabOrder = 1
    object lstCaptionList: TCaptionListView
      Left = 0
      Top = 0
      Width = 451
      Height = 87
      Margins.Left = 8
      Margins.Right = 8
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
        'Status = stsDefault'))
  end
end
