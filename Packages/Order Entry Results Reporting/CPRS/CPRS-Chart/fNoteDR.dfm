inherited frmNoteDelReason: TfrmNoteDelReason
  Left = 354
  Top = 218
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Reason for Deletion'
  ClientHeight = 122
  ClientWidth = 246
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object lblInstruction: TStaticText [0]
    Left = 12
    Top = 12
    Width = 226
    Height = 17
    Caption = 'Select the reason for deletion of this document.'
    TabOrder = 4
  end
  object cmdOK: TButton [1]
    Left = 42
    Top = 89
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [2]
    Left = 132
    Top = 89
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = cmdCancelClick
  end
  object radPrivacy: TRadioButton [3]
    Left = 20
    Top = 37
    Width = 77
    Height = 17
    Caption = '&Privacy Act'
    TabOrder = 1
    TabStop = True
  end
  object radAdmin: TRadioButton [4]
    Left = 20
    Top = 60
    Width = 129
    Height = 17
    Caption = '&Administrative Action'
    TabOrder = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblInstruction'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = radPrivacy'
        'Status = stsDefault')
      (
        'Component = radAdmin'
        'Status = stsDefault')
      (
        'Component = frmNoteDelReason'
        'Status = stsDefault'))
  end
end
