inherited frmODRTC: TfrmODRTC
  Left = 203
  Top = 183
  Width = 660
  Height = 465
  Caption = 'Return To Clinic'
  Constraints.MinHeight = 465
  Constraints.MinWidth = 660
  ExplicitWidth = 660
  ExplicitHeight = 465
  TextHeight = 13
  object lblOrderSig: TLabel [0]
    Left = 8
    Top = 332
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  inherited memOrder: TCaptionMemo
    Left = 9
    Top = 350
    Width = 555
    Height = 69
    Constraints.MinWidth = 25
    TabOrder = 2
    Caption = 'Order Sig'
    ExplicitLeft = 9
    ExplicitTop = 350
    ExplicitWidth = 555
    ExplicitHeight = 69
  end
  object pnlRequired: TPanel [2]
    Left = 2
    Top = 1
    Width = 614
    Height = 329
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    object lblClinic: TLabel
      Left = 10
      Top = 50
      Width = 32
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Clinic *'
    end
    object lblQO: TLabel
      Left = 10
      Top = 5
      Width = 79
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'My Quick Orders'
    end
    object lblMoreInfo: TLabel
      Left = 10
      Top = 246
      Width = 79
      Height = 13
      Caption = 'More Information'
      Visible = False
    end
    object stQuickOrdersDisabled: TStaticText
      Left = 10
      Top = 22
      Width = 163
      Height = 17
      Caption = 'Quick Orders combo box disabled'
      TabOrder = 0
    end
    object stIntervalInDays: TStaticText
      Left = 152
      Top = 168
      Width = 165
      Height = 17
      Caption = 'Interval in day(s) spin edit disabled'
      TabOrder = 8
    end
    object cboRTCClinic: TORComboBox
      Left = 10
      Top = 70
      Width = 595
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Clinic'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      OnChange = cboRTCClinicChange
      OnKeyUp = cboRTCClinicKeyUp
      OnMouseClick = cboRTCClinicMouseClick
      OnNeedData = cboRTCClinicNeedData
      CharsNeedMatch = 1
    end
    object lblClinicallyIndicated: TStaticText
      Left = 10
      Top = 100
      Width = 106
      Height = 17
      Caption = 'Return to clinic date*:'
      TabOrder = 16
    end
    object dateCIDC: TORDateBox
      Left = 10
      Top = 120
      Width = 98
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 3
      OnChange = dateCIDCChange
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object lblNumberAppts: TStaticText
      Left = 10
      Top = 148
      Width = 124
      Height = 17
      Caption = 'Number of Appointments*'
      TabOrder = 5
    end
    object txtNumAppts: TCaptionEdit
      Left = 10
      Top = 168
      Width = 60
      Height = 19
      AutoSize = False
      TabOrder = 7
      Text = '1'
      OnChange = txtNumApptsChange
      OnClick = txtNumApptsClick
      Caption = 'Nums of Appointments*'
    end
    object SpinNumAppt: TUpDown
      Left = 70
      Top = 168
      Width = 16
      Height = 19
      Associate = txtNumAppts
      Min = 1
      Max = 60
      Position = 1
      TabOrder = 6
    end
    object lblFrequency: TStaticText
      Left = 147
      Top = 148
      Width = 81
      Height = 17
      Caption = 'Interval in day(s)'
      TabOrder = 18
    end
    object lblPReReq: TStaticText
      Left = 342
      Top = 100
      Width = 169
      Height = 17
      Caption = 'Prerequisites: (Check all that apply)'
      TabOrder = 19
    end
    object lblComments: TStaticText
      Left = 10
      Top = 195
      Width = 53
      Height = 17
      Caption = 'Comments'
      TabOrder = 12
    end
    object txtInterval: TCaptionEdit
      Left = 147
      Top = 168
      Width = 66
      Height = 21
      TabOrder = 9
      Text = '0'
      OnChange = txtIntervalChange
      OnClick = txtIntervalClick
      Caption = 'Interval in day(s)'
    end
    object spnInterval: TUpDown
      Left = 213
      Top = 168
      Width = 16
      Height = 21
      Associate = txtInterval
      Max = 30
      TabOrder = 10
    end
    object chkTimeSensitve: TCheckBox
      Left = 147
      Top = 120
      Width = 97
      Height = 17
      Caption = 'Time Sensitive'
      TabOrder = 4
      OnClick = chkTimeSensitveClick
    end
    object memInfo: TMemo
      Left = 10
      Top = 266
      Width = 594
      Height = 57
      Color = clInfoBk
      Lines.Strings = (
        '')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 14
    end
    object edtComment: TEdit
      Left = 10
      Top = 215
      Width = 595
      Height = 21
      TabOrder = 13
      OnChange = edtCommentChange
    end
    object cboPerQO: TORComboBox
      Left = 10
      Top = 25
      Width = 595
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Quick Orders'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnDropDownClose = cboPerQODropDownClose
      OnKeyUp = cboPerQOKeyUp
      OnMouseClick = cboPerQOMouseClick
      CharsNeedMatch = 1
    end
    object lstPreReq: TCheckListBox
      Left = 342
      Top = 120
      Width = 261
      Height = 74
      ItemHeight = 17
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClickCheck = lstPreReqClickCheck
    end
  end
  inherited cmdAccept: TButton
    Left = 572
    Top = 350
    Width = 69
    TabOrder = 3
    ExplicitLeft = 572
    ExplicitTop = 350
    ExplicitWidth = 69
  end
  inherited cmdQuit: TButton
    Left = 572
    Top = 389
    Width = 67
    TabOrder = 5
    ExplicitLeft = 572
    ExplicitTop = 389
    ExplicitWidth = 67
  end
  inherited pnlMessage: TPanel
    Left = 152
    Top = 366
    Enabled = False
    TabOrder = 0
    ExplicitLeft = 152
    ExplicitTop = 366
    inherited imgMessage: TImage
      Left = 7
      Top = 7
      ExplicitLeft = 7
      ExplicitTop = 7
    end
    inherited memMessage: TRichEdit
      Left = 47
      Top = 7
      ExplicitLeft = 47
      ExplicitTop = 7
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 592
    Top = 8
    Data = (
      (
        'Component = memOrder'
        'Text = Order Sig'
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
        'Component = frmODRTC'
        'Status = stsDefault')
      (
        'Component = pnlRequired'
        'Status = stsDefault')
      (
        'Component = cboRTCClinic'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = dateCIDC'
        'Status = stsDefault')
      (
        'Component = lblNumberAppts'
        'Status = stsDefault')
      (
        'Component = txtNumAppts'
        'Status = stsDefault')
      (
        'Component = SpinNumAppt'
        'Status = stsDefault')
      (
        'Component = lblFrequency'
        'Status = stsDefault')
      (
        'Component = lblPReReq'
        'Status = stsDefault')
      (
        'Component = lblComments'
        'Status = stsDefault')
      (
        'Component = cboPerQO'
        'Status = stsDefault')
      (
        'Component = txtInterval'
        'Status = stsDefault')
      (
        'Component = spnInterval'
        'Status = stsDefault')
      (
        'Component = chkTimeSensitve'
        'Status = stsDefault')
      (
        'Component = memInfo'
        'Text = More Information'
        'Status = stsOK')
      (
        'Component = edtComment'
        'Status = stsDefault')
      (
        'Component = stQuickOrdersDisabled'
        'Status = stsDefault')
      (
        'Component = stIntervalInDays'
        'Status = stsDefault')
      (
        'Component = lstPreReq'
        'Status = stsDefault'))
  end
  object vacaPrerequisites: TVA508ComponentAccessibility
    Component = lstPreReq
    Caption = 'Prerequisites: (Check all that apply)'
    Left = 600
    Top = 64
  end
  object vacaMoreInformation: TVA508ComponentAccessibility
    Component = memInfo
    Caption = 'More Information'
    Left = 600
    Top = 288
  end
end
