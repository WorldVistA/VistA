inherited frmVitalsDate: TfrmVitalsDate
  Left = 193
  Top = 381
  Caption = 'Vitals Date & Time'
  ClientHeight = 60
  ClientWidth = 355
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 371
  ExplicitHeight = 98
  DesignSize = (
    355
    60)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 12
    Width = 151
    Height = 13
    Caption = 'Enter Vital Entry Date and Time:'
  end
  object dteVitals: TORDateBox [1]
    Tag = 11
    Left = 167
    Top = 8
    Width = 133
    Height = 21
    TabOrder = 0
    DateOnly = False
    RequireTime = True
    Caption = 'Enter Vital Entry Date and Time:'
  end
  object btnOK: TButton [2]
    Left = 195
    Top = 36
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton [3]
    Left = 275
    Top = 36
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object btnNow: TButton [4]
    Left = 307
    Top = 8
    Width = 43
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'NOW'
    TabOrder = 1
    OnClick = btnNowClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = dteVitals'
        'Text = Vitals entry Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnNow'
        'Status = stsDefault')
      (
        'Component = frmVitalsDate'
        'Status = stsDefault'))
  end
end
