inherited frmOrdersPrint: TfrmOrdersPrint
  Left = 353
  Top = 194
  Caption = 'Print orders'
  ClientHeight = 288
  ClientWidth = 356
  OldCreateOrder = True
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  ExplicitWidth = 372
  ExplicitHeight = 326
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 356
    Height = 288
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblDevice: TLabel
      Left = 127
      Top = 74
      Width = 71
      Height = 13
      Caption = 'Print to device:'
    end
    object lblPartOne: TMemo
      Left = 16
      Top = 7
      Width = 327
      Height = 26
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          'One or more of the following prints are available for this set o' +
          'f orders. '
        ' '
        'Check those you desire and select a device, if necessary.  ')
      ReadOnly = True
      TabOrder = 14
    end
    object lblPart2: TMemo
      Left = 17
      Top = 40
      Width = 323
      Height = 26
      TabStop = False
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          'Highlighted items are configured to print automatically in all c' +
          'ases '
        'for '
        'this location.  Greyed out items are not available.')
      ReadOnly = True
      TabOrder = 15
    end
    object ckChartCopy: TCheckBox
      Left = 17
      Top = 95
      Width = 97
      Height = 17
      Caption = 'Chart Copies'
      TabOrder = 0
      OnClick = ckChartCopyClick
    end
    object ckLabels: TCheckBox
      Left = 17
      Top = 131
      Width = 97
      Height = 17
      Caption = 'Labels'
      TabOrder = 3
      OnClick = ckLabelsClick
    end
    object ckRequisitions: TCheckBox
      Left = 17
      Top = 170
      Width = 97
      Height = 17
      Caption = 'Requisitions'
      TabOrder = 6
      OnClick = ckRequisitionsClick
    end
    object ckWorkCopy: TCheckBox
      Left = 17
      Top = 208
      Width = 97
      Height = 17
      Caption = 'Work Copies'
      TabOrder = 9
      OnClick = ckWorkCopyClick
    end
    object lstChartDevice: TORListBox
      Left = 127
      Top = 95
      Width = 121
      Height = 17
      ExtendedSelect = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = DeviceListClick
      Caption = 'Print to device:'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstLabelDevice: TORListBox
      Left = 127
      Top = 131
      Width = 121
      Height = 17
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = DeviceListClick
      Caption = 'Print to device:'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstReqDevice: TORListBox
      Left = 127
      Top = 170
      Width = 121
      Height = 17
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = DeviceListClick
      Caption = 'Print to device:'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstWorkDevice: TORListBox
      Left = 127
      Top = 208
      Width = 121
      Height = 17
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = DeviceListClick
      Caption = 'Print to device:'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object cmdChart: TORAlignButton
      Left = 266
      Top = 93
      Width = 75
      Height = 21
      Caption = 'Change'
      TabOrder = 2
      OnClick = cmdChartClick
    end
    object cmdLabels: TORAlignButton
      Left = 266
      Top = 129
      Width = 75
      Height = 21
      Caption = 'Change'
      TabOrder = 5
      OnClick = cmdLabelsClick
    end
    object cmdReqs: TORAlignButton
      Left = 266
      Top = 168
      Width = 75
      Height = 21
      Caption = 'Change'
      TabOrder = 8
      OnClick = cmdReqsClick
    end
    object cmdWork: TORAlignButton
      Left = 266
      Top = 206
      Width = 75
      Height = 21
      Caption = 'Change'
      TabOrder = 11
      OnClick = cmdWorkClick
    end
    object cmdOK: TORAlignButton
      Left = 7
      Top = 253
      Width = 160
      Height = 21
      Caption = 'Print All Checked Items'
      TabOrder = 12
      OnClick = cmdOKClick
    end
    object cmdCancel: TORAlignButton
      Left = 188
      Top = 253
      Width = 160
      Height = 21
      Caption = 'Print Highlighted Items Only'
      TabOrder = 13
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = lblPartOne'
        'Status = stsDefault')
      (
        'Component = lblPart2'
        'Status = stsDefault')
      (
        'Component = ckChartCopy'
        'Status = stsDefault')
      (
        'Component = ckLabels'
        'Status = stsDefault')
      (
        'Component = ckRequisitions'
        'Status = stsDefault')
      (
        'Component = ckWorkCopy'
        'Status = stsDefault')
      (
        'Component = lstChartDevice'
        'Status = stsDefault')
      (
        'Component = lstLabelDevice'
        'Status = stsDefault')
      (
        'Component = lstReqDevice'
        'Status = stsDefault')
      (
        'Component = lstWorkDevice'
        'Status = stsDefault')
      (
        'Component = cmdChart'
        'Status = stsDefault')
      (
        'Component = cmdLabels'
        'Status = stsDefault')
      (
        'Component = cmdReqs'
        'Status = stsDefault')
      (
        'Component = cmdWork'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmOrdersPrint'
        'Status = stsDefault'))
  end
end
