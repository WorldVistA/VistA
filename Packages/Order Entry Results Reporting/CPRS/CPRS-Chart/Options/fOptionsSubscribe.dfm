inherited frmOptionsSubscribe: TfrmOptionsSubscribe
  Left = 309
  Top = 103
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Subscribe to a Team'
  ClientHeight = 216
  ClientWidth = 302
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ExplicitWidth = 308
  ExplicitHeight = 244
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 184
    Width = 302
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 302
      Height = 2
      Align = alTop
    end
    object btnOK: TButton
      Left = 109
      Top = 2
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 205
      Top = 2
      Width = 75
      Height = 22
      HelpContext = 9997
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmOptionsSubscribe'
        'Status = stsDefault'))
  end
end
