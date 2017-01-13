inherited frmEffectDate: TfrmEffectDate
  Left = 335
  Top = 133
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Discharge Date'
  ClientHeight = 127
  ClientWidth = 254
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 260
  ExplicitHeight = 155
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 68
    Top = 48
    Width = 68
    Height = 13
    Caption = 'Effective Date'
  end
  object Label3: TStaticText [1]
    Left = 8
    Top = 8
    Width = 244
    Height = 17
    Caption = 'Enter the date this discharge will become effective.'
    TabOrder = 3
  end
  object Label4: TStaticText [2]
    Left = 8
    Top = 22
    Width = 224
    Height = 17
    Caption = '(This aids pharmacy in preparing prescriptions.)'
    TabOrder = 4
  end
  object calEffective: TORDateBox [3]
    Left = 68
    Top = 62
    Width = 120
    Height = 21
    TabOrder = 0
    Text = 'Today'
    DateOnly = True
    RequireTime = False
    Caption = 'Effective Date'
  end
  object cmdOK: TButton [4]
    Left = 51
    Top = 95
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [5]
    Left = 133
    Top = 95
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label3'
        'Status = stsDefault')
      (
        'Component = Label4'
        'Status = stsDefault')
      (
        'Component = calEffective'
        'Text = Effective Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmEffectDate'
        'Status = stsDefault'))
  end
end
