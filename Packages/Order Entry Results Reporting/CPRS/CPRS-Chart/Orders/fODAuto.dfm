inherited frmODAuto: TfrmODAuto
  Caption = 'Auto-Accept Order'
  FormStyle = fsNormal
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 108
    Top = 72
    Width = 287
    Height = 26
    Caption = 
      'This form is never made visible.  It exists to allow auto-accept' +
      ' orders to be treated as any other order dialog.'
    WordWrap = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODAuto'
        'Status = stsDefault'))
  end
end
