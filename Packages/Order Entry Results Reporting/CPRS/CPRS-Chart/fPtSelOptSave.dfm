inherited frmPtSelOptSave: TfrmPtSelOptSave
  Left = 452
  Top = 229
  BorderStyle = bsDialog
  ClientHeight = 204
  ClientWidth = 272
  Position = poScreenCenter
  ExplicitWidth = 278
  ExplicitHeight = 233
  PixelsPerInch = 96
  TextHeight = 13
  object pnlClinSave: TPanel [0]
    Left = 0
    Top = 0
    Width = 272
    Height = 204
    Align = alClient
    BevelWidth = 2
    TabOrder = 0
    object lblClinSettings: TMemo
      Left = 16
      Top = 10
      Width = 245
      Height = 75
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object rGrpClinSave: TKeyClickRadioGroup
      Left = 48
      Top = 98
      Width = 177
      Height = 59
      Caption = 'Select Desired Clinic Save Option:'
      Items.Strings = (
        'Save For All Days of Week'
        'Save For Current Day Only')
      TabOrder = 0
      TabStop = True
      OnClick = rGrpClinSaveClick
    end
    object btnOK: TButton
      Left = 50
      Top = 168
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 150
      Top = 168
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlClinSave'
        'Status = stsDefault')
      (
        'Component = lblClinSettings'
        'Status = stsDefault')
      (
        'Component = rGrpClinSave'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmPtSelOptSave'
        'Status = stsDefault'))
  end
end
