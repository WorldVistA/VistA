inherited frmOMHTML: TfrmOMHTML
  Left = 390
  Top = 242
  Caption = 'HTML Ordering'
  ClientHeight = 293
  ClientWidth = 512
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 520
  ExplicitHeight = 320
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton [0]
    Left = 352
    Top = 268
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton [1]
    Left = 433
    Top = 268
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnBack: TButton [2]
    Left = 6
    Top = 268
    Width = 43
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '< Back'
    Enabled = False
    TabOrder = 2
    OnClick = btnBackClick
  end
  object pnlWeb: TPanel [3]
    Left = 6
    Top = 6
    Width = 499
    Height = 253
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 3
    object webView: TWebBrowser
      Left = 0
      Top = 0
      Width = 499
      Height = 253
      Align = alClient
      TabOrder = 0
      SelectedEngine = EdgeIfAvailable
      OnBeforeNavigate2 = webViewBeforeNavigate2
      OnDocumentComplete = webViewDocumentComplete
      ControlData = {
        4C00000093330000261A00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object btnShow: TButton [4]
    Left = 55
    Top = 268
    Width = 103
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Show Selections....'
    TabOrder = 4
    OnClick = btnShowClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnBack'
        'Status = stsDefault')
      (
        'Component = pnlWeb'
        'Status = stsDefault')
      (
        'Component = webView'
        'Status = stsDefault')
      (
        'Component = btnShow'
        'Status = stsDefault')
      (
        'Component = frmOMHTML'
        'Status = stsDefault'))
  end
end
