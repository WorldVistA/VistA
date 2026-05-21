inherited frmEncVitals: TfrmEncVitals
  Left = 353
  Top = 210
  Caption = 'Vitals'
  Constraints.MinHeight = 320
  Constraints.MinWidth = 400
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  TextHeight = 13
  inherited pnlMainAncestor: TPanel [0]
    StyleElements = [seFont, seClient, seBorder]
    object lvVitals: TCaptionListView
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 614
      Height = 366
      Align = alClient
      Columns = <>
      Constraints.MinHeight = 50
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      AutoSize = False
    end
  end
  inherited pnlBottomAncestor: TPanel [1]
    StyleElements = [seFont, seClient, seBorder]
    inherited btnOK: TBitBtn
      TabOrder = 1
    end
    inherited btnCancel: TBitBtn
      TabOrder = 2
    end
    object btnEnterVitals: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 21
      Align = alLeft
      Caption = 'Enter Vitals'
      TabOrder = 0
      OnClick = btnEnterVitalsClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lvVitals'
        'Status = stsDefault')
      (
        'Component = btnEnterVitals'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmEncVitals'
        'Status = stsDefault'))
  end
end
