inherited frmODText: TfrmODText
  Width = 525
  Height = 279
  Anchors = [akLeft, akTop, akBottom]
  Caption = 'Text Only Order'
  ExplicitWidth = 525
  ExplicitHeight = 279
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
  object lblOrderSig: TLabel [3]
    Left = 8
    Top = 178
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  inherited memOrder: TCaptionMemo
    TabOrder = 4
  end
  object memText: TMemo [5]
    Left = 6
    Top = 18
    Width = 508
    Height = 124
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 1
    OnChange = ControlChange
  end
  object txtStart: TORDateBox [6]
    Left = 226
    Top = 164
    Width = 140
    Height = 21
    TabOrder = 2
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
    TabOrder = 3
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = 'Stop Date/Time'
  end
  inherited cmdAccept: TButton
    TabOrder = 5
  end
  inherited cmdQuit: TButton
    TabOrder = 6
  end
  inherited pnlMessage: TPanel
    TabOrder = 0
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
        'Label = lblOrderSig'
        'Status = stsOK')
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
  object VA508CompMemOrder: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompMemOrderStateQuery
    Left = 152
    Top = 216
  end
end
