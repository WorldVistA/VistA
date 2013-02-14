inherited frmPCEBaseGrid: TfrmPCEBaseGrid
  Left = 128
  Top = 192
  Caption = 'frmPCEBaseGrid'
  PixelsPerInch = 96
  TextHeight = 13
  object pnlGrid: TPanel [2]
    Left = 6
    Top = 238
    Width = 451
    Height = 87
    BevelOuter = bvNone
    TabOrder = 2
    OnResize = pnlGridResize
    object lbGrid: TORListBox
      Left = 0
      Top = 17
      Width = 451
      Height = 70
      Align = alClient
      Color = clCream
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ItemTipColor = clCream
      LongList = False
      TabPosInPixels = True
    end
    object hcGrid: THeaderControl
      Left = 0
      Top = 0
      Width = 451
      Height = 17
      Sections = <
        item
          ImageIndex = -1
          Width = 50
        end
        item
          ImageIndex = -1
          Width = 50
        end>
      OnSectionResize = hcGridSectionResize
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = lbGrid'
        'Status = stsDefault')
      (
        'Component = hcGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPCEBaseGrid'
        'Status = stsDefault'))
  end
end
