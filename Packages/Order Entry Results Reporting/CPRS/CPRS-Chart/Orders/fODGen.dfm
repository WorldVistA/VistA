inherited frmODGen: TfrmODGen
  Left = 223
  Top = 290
  Width = 689
  Height = 629
  Caption = 'frmODGen'
  ExplicitWidth = 689
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrderSig: TLabel [0]
    AlignWithMargins = True
    Left = 6
    Top = 430
    Width = 661
    Height = 13
    Margins.Left = 6
    Margins.Right = 6
    Align = alBottom
    Caption = 'Order Sig'
    Color = clMoneyGreen
    ParentColor = False
    OnClick = lblOrderSigClick
    ExplicitWidth = 44
  end
  object sbxMain: TScrollBox [1]
    AlignWithMargins = True
    Left = 6
    Top = 3
    Width = 661
    Height = 421
    Margins.Left = 6
    Margins.Right = 6
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    ExplicitLeft = 11
  end
  inherited cmdAccept: TButton [2]
    Top = 257
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 257
  end
  inherited cmdQuit: TButton [3]
    Top = 288
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 288
  end
  object gpMain: TGridPanel [4]
    AlignWithMargins = True
    Left = 3
    Top = 449
    Width = 667
    Height = 59
    Align = alBottom
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 96.000000000000000000
      end>
    ControlCollection = <>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 64.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 6
  end
  inherited memOrder: TCaptionMemo [5]
    Top = 257
    Margins.Left = 3
    Margins.Top = 5
    Margins.Right = 3
    Margins.Bottom = 3
    ExplicitTop = 257
  end
  object pnlButtons: TPanel [6]
    Left = 535
    Top = 449
    Width = 113
    Height = 41
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 7
  end
  object pnlGridMessage: TPanel [7]
    AlignWithMargins = True
    Left = 3
    Top = 514
    Width = 667
    Height = 73
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 8
  end
  inherited pnlMessage: TPanel
    Top = 235
    Margins.Left = 3
    Margins.Top = 3
    Margins.Right = 3
    Margins.Bottom = 3
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ExplicitTop = 235
    inherited imgMessage: TImage
      AlignWithMargins = True
      Left = 5
      Top = 5
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      ExplicitLeft = 5
      ExplicitTop = 5
    end
    inherited memMessage: TRichEdit
      AlignWithMargins = True
      Left = 47
      Top = 5
      Width = 327
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ExplicitLeft = 47
      ExplicitTop = 5
      ExplicitWidth = 327
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = sbxMain'
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
        'Component = frmODGen'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlGridMessage'
        'Status = stsDefault'))
  end
  object VA508CompMemOrder: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompMemOrderStateQuery
    Left = 88
    Top = 232
  end
end
