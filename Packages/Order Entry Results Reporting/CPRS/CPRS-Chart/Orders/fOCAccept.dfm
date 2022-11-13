inherited frmOCAccept: TfrmOCAccept
  Left = 0
  Top = 249
  BorderIcons = [biSystemMenu]
  Caption = 'Order Checking'
  ClientHeight = 300
  ClientWidth = 598
  Constraints.MinHeight = 200
  Constraints.MinWidth = 604
  FormStyle = fsStayOnTop
  KeyPreview = False
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ExplicitWidth = 604
  ExplicitHeight = 329
  PixelsPerInch = 96
  TextHeight = 13
  object memChecks: TRichEdit [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 592
    Height = 160
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WantReturns = False
    Zoom = 100
    ExplicitWidth = 655
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 267
    Width = 598
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 661
    DesignSize = (
      598
      33)
    object cmdAccept: TButton
      Left = 395
      Top = 6
      Width = 96
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Accept Order'
      Default = True
      ModalResult = 6
      TabOrder = 1
      OnClick = cmdAcceptClick
      ExplicitLeft = 458
    end
    object cmdCancel: TButton
      Left = 497
      Top = 6
      Width = 97
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Cancel = True
      Caption = 'Cancel Order'
      ModalResult = 7
      TabOrder = 2
      OnClick = cmdCancelClick
      ExplicitLeft = 560
    end
    object btnDrugMono: TButton
      Left = 196
      Top = 6
      Width = 193
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Drug Interaction Monograph'
      Enabled = False
      TabOrder = 3
      OnClick = btnDrugMonoClick
    end
    object AllergyAssessmentBtn: TButton
      Left = 4
      Top = 6
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Perform Allergy Assessment'
      Default = True
      TabOrder = 0
      OnClick = AllergyAssessmentBtnClick
    end
  end
  object pnlOverrideReason: TPanel [2]
    Left = 0
    Top = 166
    Width = 598
    Height = 101
    Align = alBottom
    TabOrder = 1
    Visible = False
    ExplicitWidth = 661
    object lblOverride: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 590
      Height = 13
      Align = alTop
      Caption = 'Reason for overriding order checks:'
      ExplicitWidth = 169
    end
    object lblComment: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 50
      Width = 590
      Height = 13
      Align = alTop
      Caption = 'Local Comment on Remote-Facility Allergy:'
      Visible = False
      ExplicitWidth = 200
    end
    object cbAllergyReason: TComboBox
      AlignWithMargins = True
      Left = 4
      Top = 23
      Width = 590
      Height = 21
      Align = alTop
      TabOrder = 0
      OnChange = cbAllergyReasonChange
      ExplicitWidth = 653
    end
    object cbComment: TComboBox
      AlignWithMargins = True
      Left = 4
      Top = 69
      Width = 590
      Height = 21
      Align = alTop
      TabOrder = 1
      Visible = False
      OnChange = cbAllergyReasonChange
      ExplicitLeft = 3
      ExplicitWidth = 593
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memChecks'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmOCAccept'
        'Status = stsDefault')
      (
        'Component = btnDrugMono'
        'Status = stsDefault')
      (
        'Component = AllergyAssessmentBtn'
        'Status = stsDefault')
      (
        'Component = pnlOverrideReason'
        'Status = stsDefault')
      (
        'Component = cbAllergyReason'
        'Status = stsDefault')
      (
        'Component = cbComment'
        'Status = stsDefault'))
  end
end
