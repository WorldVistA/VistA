inherited frmEncVitals: TfrmEncVitals
  Left = 353
  Top = 210
  Caption = 'Vitals'
  ClientHeight = 400
  ClientWidth = 624
  TextHeight = 13
  object lvVitals: TCaptionListView [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 368
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
    ExplicitWidth = 618
    ExplicitHeight = 359
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 368
    Width = 624
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 359
    ExplicitWidth = 618
    object btnEnterVitals: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 21
      Caption = 'Enter Vitals'
      TabOrder = 0
      OnClick = btnEnterVitalsClick
    end
    object btnOKkludge: TButton
      Left = 434
      Top = 6
      Width = 75
      Height = 21
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancelkludge: TButton
      Left = 522
      Top = 6
      Width = 75
      Height = 21
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  inherited btnOK: TBitBtn
    Left = 196
    Top = 365
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'OK No Show'
    TabOrder = 1
    Visible = False
    ExplicitLeft = 190
    ExplicitTop = 356
  end
  inherited btnCancel: TBitBtn
    Left = 277
    Top = 365
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Cancel No Show'
    TabOrder = 2
    Visible = False
    ExplicitLeft = 271
    ExplicitTop = 356
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lvVitals'
        'Status = stsDefault'
        'Columns'
        ())
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnEnterVitals'
        'Status = stsDefault')
      (
        'Component = btnOKkludge'
        'Status = stsDefault')
      (
        'Component = btnCancelkludge'
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
