inherited frmODText: TfrmODText
  Caption = 'Text Only Order'
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel [0]
    Left = 6
    Top = 4
    Width = 126
    Height = 13
    Caption = 'Enter the text of the order -'
  end
  object lblStart: TLabel [1]
    Left = 226
    Top = 150
    Width = 76
    Height = 13
    Caption = 'Start Date/Time'
  end
  object lblStop: TLabel [2]
    Left = 374
    Top = 150
    Width = 76
    Height = 13
    Caption = 'Stop Date/Time'
  end
  inherited memOrder: TCaptionMemo
    TabOrder = 6
  end
  inherited cmdAccept: TButton
    TabOrder = 3
  end
  object memText: TMemo [5]
    Left = 6
    Top = 18
    Width = 508
    Height = 124
    TabOrder = 0
    OnChange = ControlChange
  end
  object txtStart: TORDateBox [6]
    Left = 226
    Top = 164
    Width = 140
    Height = 21
    TabOrder = 1
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Start Date/Time'
  end
  object txtStop: TORDateBox [7]
    Left = 374
    Top = 164
    Width = 140
    Height = 21
    TabOrder = 2
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Stop Date/Time'
  end
  inherited cmdQuit: TButton
    TabOrder = 4
  end
  inherited pnlMessage: TPanel
    TabOrder = 5
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = txtStart'
        'Status = stsDefault')
      (
        'Component = txtStop'
        'Status = stsDefault')
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
        'Component = frmODText'
        'Status = stsDefault'))
  end
end
