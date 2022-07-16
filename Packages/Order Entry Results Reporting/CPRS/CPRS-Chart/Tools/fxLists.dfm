inherited frmDbgList: TfrmDbgList
  Left = 313
  Top = 248
  BorderIcons = [biSystemMenu]
  Caption = 'Show ListBox Data'
  ClientHeight = 253
  ClientWidth = 472
  OldCreateOrder = True
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 16
  object memData: TMemo [0]
    Left = 0
    Top = 0
    Width = 472
    Height = 253
    Align = alClient
    ReadOnly = True
    TabOrder = 0
    WantReturns = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memData'
        'Status = stsDefault')
      (
        'Component = frmDbgList'
        'Status = stsDefault'))
  end
end
