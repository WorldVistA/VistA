inherited frmODDietLT: TfrmODDietLT
  Left = 398
  Top = 254
  Caption = 'Late Tray?'
  ClientHeight = 161
  ClientWidth = 296
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 304
  ExplicitHeight = 188
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 0
    Top = 66
    Width = 296
    Height = 2
  end
  object lblMealCutoff: TStaticText [1]
    Left = 8
    Top = 16
    Width = 186
    Height = 17
    Caption = 'You have missed the breakfast cut-off.'
    TabOrder = 4
  end
  object Label2: TStaticText [2]
    Left = 8
    Top = 34
    Width = 156
    Height = 17
    Caption = 'Do you wish to order a late tray?'
    TabOrder = 5
  end
  object GroupBox1: TGroupBox [3]
    Left = 109
    Top = 76
    Width = 77
    Height = 78
    Caption = 'Meal Time'
    TabOrder = 0
    object radLT1: TRadioButton
      Left = 9
      Top = 16
      Width = 56
      Height = 17
      TabOrder = 0
    end
    object radLT2: TRadioButton
      Left = 9
      Top = 36
      Width = 56
      Height = 17
      TabOrder = 1
    end
    object radLT3: TRadioButton
      Left = 9
      Top = 56
      Width = 56
      Height = 17
      TabOrder = 2
    end
  end
  object cmdYes: TButton [4]
    Left = 216
    Top = 8
    Width = 72
    Height = 21
    Caption = 'Yes'
    Default = True
    TabOrder = 1
    OnClick = cmdYesClick
  end
  object cmdNo: TButton [5]
    Left = 216
    Top = 37
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'No'
    TabOrder = 2
    OnClick = cmdNoClick
  end
  object chkBagged: TCheckBox [6]
    Left = 8
    Top = 76
    Width = 85
    Height = 17
    Caption = 'Bagged Meal'
    TabOrder = 3
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblMealCutoff'
        'Status = stsDefault')
      (
        'Component = Label2'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = radLT1'
        'Status = stsDefault')
      (
        'Component = radLT2'
        'Status = stsDefault')
      (
        'Component = radLT3'
        'Status = stsDefault')
      (
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = chkBagged'
        'Status = stsDefault')
      (
        'Component = frmODDietLT'
        'Status = stsDefault'))
  end
end
