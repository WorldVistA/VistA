inherited frmRemVisitInfo: TfrmRemVisitInfo
  Left = 192
  Top = 195
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Other Visit Information'
  ClientHeight = 221
  ClientWidth = 316
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    316
    221)
  PixelsPerInch = 96
  TextHeight = 13
  object lblVital: TLabel [0]
    Left = 3
    Top = 6
    Width = 111
    Height = 13
    Caption = 'Vital Entry Date && Time:'
  end
  inline fraVisitRelated: TfraVisitRelated [1]
    Left = 106
    Top = 27
    Width = 207
    Height = 174
    Anchors = [akTop, akRight]
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 106
    ExplicitTop = 27
    ExplicitWidth = 207
    ExplicitHeight = 174
    inherited gbVisitRelatedTo: TGroupBox
      Width = 207
      Height = 174
    end
  end
  object btnOK: TButton
    Left = 158
    Top = 198
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 238
    Top = 198
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object dteVitals: TORDateBox
    Tag = 11
    Left = 119
    Top = 2
    Width = 133
    Height = 21
    TabOrder = 0
    DateOnly = False
    RequireTime = True
    Caption = 'Vital Entry Date && Time:'
  end
  object btnNow: TButton
    Left = 269
    Top = 2
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
        'Component = fraVisitRelated'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAOYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkMSTNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkECNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkIRNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkAONo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkHNCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkCVNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDYes'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.chkSHDNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.lblSCNo'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.lblSCYes'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = dteVitals'
        'Status = stsDefault')
      (
        'Component = btnNow'
        'Status = stsDefault')
      (
        'Component = frmRemVisitInfo'
        'Status = stsDefault'))
  end
end
