inherited frmAllergyCheck: TfrmAllergyCheck
  Left = 0
  Top = 0
  Caption = 'Selected Medication Allergy Check'
  ClientHeight = 415
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBUttons: TPanel
    Left = 0
    Top = 383
    Width = 683
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 525
      Top = 3
      Width = 155
      Height = 26
      Align = alRight
      Caption = 'Cancel Order'
      ModalResult = 2
      TabOrder = 1
    end
    object btnContinue: TButton
      AlignWithMargins = True
      Left = 330
      Top = 3
      Width = 189
      Height = 26
      Align = alRight
      Caption = 'Continue Order'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 282
    Width = 683
    Height = 101
    Align = alBottom
    TabOrder = 2
    object lblOverride: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 675
      Height = 13
      Align = alTop
      Caption = 'Reason for overriding order checks:'
      ExplicitWidth = 169
    end
    object lblComment: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 50
      Width = 675
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
      Width = 675
      Height = 21
      Align = alTop
      TabOrder = 0
      OnChange = cbAllergyReasonChange
    end
    object cbComment: TComboBox
      AlignWithMargins = True
      Left = 4
      Top = 69
      Width = 675
      Height = 21
      Align = alTop
      TabOrder = 1
      Visible = False
      OnChange = cbAllergyReasonChange
    end
  end
  object reInfo: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 677
    Height = 276
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    Zoom = 100
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 16
    Data = (
      (
        'Component = frmAllergyCheck'
        'Status = stsDefault')
      (
        'Component = btnContinue'
        'Text = Continue Order'
        'Status = stsOK')
      (
        'Component = btnCancel'
        'Text = Cancel Order'
        'Status = stsOK')
      (
        'Component = pnlBUttons'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = cbAllergyReason'
        'Status = stsDefault')
      (
        'Component = cbComment'
        'Status = stsDefault')
      (
        'Component = reInfo'
        'Status = stsDefault'))
  end
end
