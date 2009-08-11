inherited frmConsMedRslt: TfrmConsMedRslt
  Left = 468
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Select Medicine Result'
  ClientHeight = 242
  ClientWidth = 505
  Position = poScreenCenter
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 505
    Height = 242
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object SrcLabel: TLabel
      Left = 12
      Top = 6
      Width = 145
      Height = 16
      AutoSize = False
      Caption = 'Select medicine result:'
    end
    object lblDateofAction: TOROffsetLabel
      Left = 133
      Top = 159
      Width = 112
      Height = 19
      Caption = 'Date/time of this action'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblActionBy: TOROffsetLabel
      Left = 266
      Top = 159
      Width = 215
      Height = 19
      Caption = 'Action by'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblResultName: TOROffsetLabel
      Left = 27
      Top = 29
      Width = 90
      Height = 15
      Caption = 'Type of Result'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblResultDate: TOROffsetLabel
      Left = 255
      Top = 29
      Width = 74
      Height = 15
      Caption = 'Date of Result'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblSummary: TOROffsetLabel
      Left = 375
      Top = 29
      Width = 45
      Height = 15
      Caption = 'Summary'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object cmdOK: TButton
      Left = 332
      Top = 211
      Width = 75
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 5
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 412
      Top = 211
      Width = 75
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 6
      OnClick = cmdCancelClick
    end
    object lstMedResults: TORListBox
      Left = 15
      Top = 45
      Width = 476
      Height = 114
      Style = lbOwnerDrawFixed
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      TabOrder = 0
      OnDrawItem = lstMedResultsDrawItem
      Caption = 'Select medicine result'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2,3,4'
      TabPositions = '40,60'
    end
    object cmdDetails: TButton
      Left = 15
      Top = 179
      Width = 75
      Height = 21
      Caption = 'Show Details'
      TabOrder = 1
      OnClick = cmdDetailsClick
    end
    object ckAlert: TCheckBox
      Left = 131
      Top = 211
      Width = 79
      Height = 17
      Caption = 'Send alert'
      TabOrder = 4
      OnClick = ckAlertClick
    end
    object calDateofAction: TORDateBox
      Left = 133
      Top = 179
      Width = 116
      Height = 21
      TabStop = False
      TabOrder = 2
      Text = 'Now'
      DateOnly = False
      RequireTime = False
      Caption = 'Date/time of this action'
    end
    object cboPerson: TORComboBox
      Left = 265
      Top = 179
      Width = 220
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Action by'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 3
      OnNeedData = NewPersonNeedData
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lstMedResults'
        'Status = stsDefault')
      (
        'Component = cmdDetails'
        'Status = stsDefault')
      (
        'Component = ckAlert'
        'Status = stsDefault')
      (
        'Component = calDateofAction'
        'Status = stsDefault')
      (
        'Component = cboPerson'
        'Status = stsDefault')
      (
        'Component = frmConsMedRslt'
        'Status = stsDefault'))
  end
end
