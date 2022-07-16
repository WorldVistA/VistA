inherited frmDSTView: TfrmDSTView
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Consult Toolbox'
  ClientHeight = 497
  ClientWidth = 868
  OnKeyPress = FormKeyPress
  ExplicitWidth = 884
  ExplicitHeight = 536
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 464
    Width = 868
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      AlignWithMargins = True
      Left = 790
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      Visible = False
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 709
      Top = 3
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      Visible = False
    end
    object btnCloseCTB: TButton
      AlignWithMargins = True
      Left = 584
      Top = 3
      Width = 119
      Height = 27
      Align = alRight
      Caption = 'Close Consult Toolbox'
      TabOrder = 2
      OnClick = btnCloseCTBClick
    end
  end
  object wbInternetExplorer: TWebBrowser [1]
    Left = 0
    Top = 0
    Width = 868
    Height = 464
    Align = alClient
    TabOrder = 0
    OnNavigateError = wbInternetExplorerNavigateError
    ExplicitWidth = 694
    ExplicitHeight = 477
    ControlData = {
      4C000000B6590000F52F00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmDSTView'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = wbInternetExplorer'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnCloseCTB'
        'Status = stsDefault'))
  end
end
