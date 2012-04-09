inherited frmClinicWardMeds: TfrmClinicWardMeds
  Left = 523
  Top = 389
  BorderIcons = []
  Caption = 'Patient Location'
  ClientHeight = 95
  ClientWidth = 298
  ExplicitWidth = 306
  ExplicitHeight = 122
  PixelsPerInch = 96
  TextHeight = 13
  object stxtLine3: TStaticText [0]
    Left = 16
    Top = 35
    Width = 29
    Height = 17
    Caption = 'line 3'
    TabOrder = 0
  end
  object stxtLine2: TStaticText [1]
    Left = 16
    Top = 20
    Width = 29
    Height = 17
    Caption = 'line 2'
    TabOrder = 1
  end
  object stxtLine1: TStaticText [2]
    Left = 16
    Top = 5
    Width = 29
    Height = 17
    Caption = 'line 1'
    TabOrder = 2
  end
  object btnClinic: TButton [3]
    Left = 31
    Top = 62
    Width = 58
    Height = 24
    Anchors = [akLeft, akBottom]
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 3
    OnClick = btnClinicClick
  end
  object btnWard: TButton [4]
    Left = 159
    Top = 62
    Width = 58
    Height = 24
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    OnClick = btnWardClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = stxtLine3'
        'Status = stsDefault')
      (
        'Component = stxtLine2'
        'Status = stsDefault')
      (
        'Component = stxtLine1'
        'Status = stsDefault')
      (
        'Component = btnClinic'
        'Status = stsDefault')
      (
        'Component = btnWard'
        'Status = stsDefault')
      (
        'Component = frmClinicWardMeds'
        'Status = stsDefault'))
  end
end
