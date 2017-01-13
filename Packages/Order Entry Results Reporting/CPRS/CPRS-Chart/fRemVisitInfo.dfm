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
  ExplicitWidth = 322
  ExplicitHeight = 249
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
    inherited ScrollBox1: TScrollBox
      Width = 207
      Height = 174
      ExplicitWidth = 207
      ExplicitHeight = 174
      inherited Panel1: TPanel
        Width = 190
        ExplicitWidth = 190
        inherited gbVisitRelatedTo: TGroupBox
          Width = 190
          ExplicitWidth = 190
        end
      end
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
        'Text = Service Connected Condition     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSCNo'
        'Text = Service Connected Condition    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkCVYes'
        'Text = Combat Vet (Combat Related)     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkCVNo'
        'Text = Combat Vet (Combat Related)    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkAOYes'
        'Text = Agent Orange Exposure     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkAONo'
        'Text = Agent Orange Exposure    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkIRYes'
        'Text = Ionizing Radiation Exposure     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkIRNo'
        'Text = Ionizing Radiation Exposure    No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkECYes'
        'Text = Southwest Asia Conditions     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkECNo'
        'Text = Southwest Asia Conditions     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSHDYes'
        'Text = Shipboard Hazard and Defense     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkSHDNo'
        'Text = Shipboard Hazard and Defense     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkMSTYes'
        'Text = MST     Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkMSTNo'
        'Text = MST     No'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkHNCYes'
        'Text = Head and/or Neck Cancer    Yes'
        'Status = stsOK')
      (
        'Component = fraVisitRelated.chkHNCNo'
        'Text = Head and/or Neck Cancer    No'
        'Status = stsOK')
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
        'Text = Vital entry Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = btnNow'
        'Status = stsDefault')
      (
        'Component = frmRemVisitInfo'
        'Status = stsDefault'))
  end
end
