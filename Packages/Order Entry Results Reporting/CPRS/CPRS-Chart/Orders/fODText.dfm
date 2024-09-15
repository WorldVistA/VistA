inherited frmODText: TfrmODText
  Width = 704
  Height = 645
  Caption = 'Text Only Order'
  ExplicitWidth = 704
  ExplicitHeight = 645
  PixelsPerInch = 96
  TextHeight = 13
  object gpMain: TGridPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 682
    Height = 527
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 160.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 96.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 3
        Control = lblText
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = memText
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblStart
        Row = 2
      end
      item
        Column = 0
        Control = txtStart
        Row = 3
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblStop
        Row = 4
      end
      item
        Column = 0
        Control = txtStop
        Row = 5
      end
      item
        Column = 0
        ColumnSpan = 3
        Control = lblOrderSig
        Row = 6
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 64.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 5
    object lblText: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 676
      Height = 16
      Align = alClient
      Caption = 'Enter the text of the order -'
      ExplicitWidth = 126
      ExplicitHeight = 13
    end
    object memText: TMemo
      AlignWithMargins = True
      Left = 3
      Top = 25
      Width = 676
      Height = 325
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      OnChange = ControlChange
    end
    object lblStart: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 356
      Width = 676
      Height = 16
      Align = alClient
      Caption = 'Start Date/Time'
      ExplicitWidth = 76
      ExplicitHeight = 13
    end
    object txtStart: TORDateBox
      AlignWithMargins = True
      Left = 3
      Top = 378
      Width = 154
      Height = 16
      Align = alClient
      TabOrder = 1
      OnChange = ControlChange
      DateOnly = False
      RequireTime = False
      Caption = 'Start Date/Time'
      ExplicitHeight = 21
    end
    object lblStop: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 400
      Width = 676
      Height = 16
      Align = alClient
      Caption = 'Stop Date/Time'
      ExplicitWidth = 76
      ExplicitHeight = 13
    end
    object txtStop: TORDateBox
      AlignWithMargins = True
      Left = 3
      Top = 422
      Width = 154
      Height = 16
      Align = alClient
      TabOrder = 2
      OnChange = ControlChange
      DateOnly = False
      RequireTime = False
      Caption = 'Stop Date/Time'
      ExplicitHeight = 21
    end
    object lblOrderSig: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 444
      Width = 676
      Height = 16
      Align = alClient
      Caption = 'Order Sig'
      OnClick = lblOrderSigClick
      ExplicitWidth = 44
      ExplicitHeight = 13
    end
  end
  inherited memOrder: TCaptionMemo
    TabOrder = 1
  end
  object pnlGridMessage: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 530
    Width = 682
    Height = 73
    Margins.Top = 0
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentBackground = False
    ParentColor = True
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 6
  end
  object pnlButtons: TPanel [3]
    Left = 543
    Top = 443
    Width = 96
    Height = 64
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    ShowCaption = False
    TabOrder = 7
  end
  inherited pnlMessage: TPanel [4]
    Left = 9
    Top = 192
    Width = 536
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Visible = True
    ExplicitLeft = 9
    ExplicitTop = 192
    ExplicitWidth = 536
    inherited imgMessage: TImage
      AlignWithMargins = True
      Height = 34
      Align = alLeft
      ExplicitHeight = 34
    end
    inherited memMessage: TRichEdit
      AlignWithMargins = True
      Left = 44
      Width = 486
      Height = 34
      Align = alClient
      ExplicitLeft = 44
      ExplicitWidth = 486
      ExplicitHeight = 34
    end
  end
  inherited cmdAccept: TButton [5]
    Left = 553
    Top = 243
    TabOrder = 2
    ExplicitLeft = 553
    ExplicitTop = 243
  end
  inherited cmdQuit: TButton [6]
    Left = 553
    Top = 282
    TabOrder = 3
    ExplicitLeft = 553
    ExplicitTop = 282
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 568
    Top = 48
    Data = (
      (
        'Component = memText'
        'Status = stsDefault')
      (
        'Component = txtStart'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = txtStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
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
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = pnlGridMessage'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault'))
  end
  object VA508CompMemOrder: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompMemOrderStateQuery
    Left = 152
    Top = 216
  end
end
