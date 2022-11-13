inherited frmPCEEdit: TfrmPCEEdit
  Left = 214
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Edit Encounter'
  ClientHeight = 128
  ClientWidth = 543
  Position = poScreenCenter
  ExplicitWidth = 549
  ExplicitHeight = 161
  DesignSize = (
    543
    128)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TStaticText [0]
    Left = 0
    Top = 0
    Width = 543
    Height = 24
    Align = alTop
    Alignment = taCenter
    Caption = 'Select Encounter to Edit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object lblNew: TMemo [1]
    Left = 136
    Top = 32
    Width = 401
    Height = 26
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'New')
    TabOrder = 3
  end
  object lblNote: TMemo [2]
    Left = 136
    Top = 73
    Width = 401
    Height = 26
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'Note')
    TabOrder = 4
  end
  object btnNew: TButton [3]
    Left = 8
    Top = 28
    Width = 121
    Height = 21
    Caption = 'Edit Current Encounter'
    ModalResult = 6
    TabOrder = 0
  end
  object btnNote: TButton [4]
    Left = 8
    Top = 69
    Width = 121
    Height = 21
    Caption = 'Edit Note Encounter'
    ModalResult = 7
    TabOrder = 1
  end
  object btnCancel: TButton [5]
    Left = 465
    Top = 104
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = lblNew'
        'Status = stsDefault')
      (
        'Component = lblNote'
        'Status = stsDefault')
      (
        'Component = btnNew'
        'Status = stsDefault')
      (
        'Component = btnNote'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPCEEdit'
        'Status = stsDefault'))
  end
end
