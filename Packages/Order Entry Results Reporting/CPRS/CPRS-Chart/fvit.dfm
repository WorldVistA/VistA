inherited frmVit: TfrmVit
  Left = 451
  Top = 208
  Caption = 'frmVit'
  ClientHeight = 334
  ClientWidth = 491
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  ExplicitWidth = 507
  ExplicitHeight = 372
  PixelsPerInch = 96
  TextHeight = 13
  object cmdOK: TButton [0]
    Left = 319
    Top = 276
    Width = 75
    Height = 22
    Caption = 'OK'
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [1]
    Left = 406
    Top = 276
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  object pnlmain: TPanel [2]
    Left = 8
    Top = 24
    Width = 473
    Height = 241
    TabOrder = 0
    object lblVitPointer: TOROffsetLabel
      Left = 418
      Top = 48
      Width = 17
      Height = 15
      Caption = '<--'
      Color = clBtnFace
      HorzOffset = 5
      ParentColor = False
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblDate: TStaticText
      Left = 32
      Top = 23
      Width = 31
      Height = 17
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
    end
    object lblDateBP: TStaticText
      Tag = 3
      Left = 26
      Top = 122
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 12
      OnDblClick = lbllastClick
    end
    object lblDateTemp: TStaticText
      Left = 26
      Top = 52
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 13
      OnDblClick = lbllastClick
    end
    object lblDateResp: TStaticText
      Tag = 2
      Left = 26
      Top = 98
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 14
      OnDblClick = lbllastClick
    end
    object lblDatePulse: TStaticText
      Tag = 1
      Left = 26
      Top = 75
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 15
      OnDblClick = lbllastClick
    end
    object lblDateHeight: TStaticText
      Tag = 4
      Left = 26
      Top = 145
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 16
      OnDblClick = lbllastClick
    end
    object lblDateWeight: TStaticText
      Tag = 5
      Left = 26
      Top = 169
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 17
      OnDblClick = lbllastClick
    end
    object lblLstMeas: TStaticText
      Left = 116
      Top = 23
      Width = 80
      Height = 17
      Caption = 'Last Measure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 18
    end
    object lbllastBP: TStaticText
      Tag = 3
      Left = 124
      Top = 122
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 19
      OnClick = lbllastClick
      OnDblClick = lbllastClick
    end
    object lblLastTemp: TStaticText
      Left = 124
      Top = 52
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 20
      OnDblClick = lbllastClick
    end
    object lblLastResp: TStaticText
      Tag = 2
      Left = 124
      Top = 98
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 21
      OnDblClick = lbllastClick
    end
    object lblLastPulse: TStaticText
      Tag = 1
      Left = 124
      Top = 75
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 22
      OnDblClick = lbllastClick
    end
    object lblLastHeight: TStaticText
      Tag = 4
      Left = 124
      Top = 145
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 23
      OnDblClick = lbllastClick
    end
    object lblLastWeight: TStaticText
      Tag = 5
      Left = 124
      Top = 169
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 24
      OnDblClick = lbllastClick
    end
    object lblVital: TStaticText
      Left = 256
      Top = 23
      Width = 29
      Height = 17
      Caption = 'Vital'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 25
    end
    object lblVitBP: TStaticText
      Left = 256
      Top = 122
      Width = 23
      Height = 17
      Caption = 'B/P'
      TabOrder = 26
    end
    object lnlVitTemp: TStaticText
      Left = 256
      Top = 52
      Width = 31
      Height = 17
      Caption = 'Temp'
      TabOrder = 27
    end
    object lblVitResp: TStaticText
      Left = 256
      Top = 98
      Width = 29
      Height = 17
      Caption = 'Resp'
      TabOrder = 28
    end
    object lblVitPulse: TStaticText
      Left = 256
      Top = 75
      Width = 30
      Height = 17
      Caption = 'Pulse'
      TabOrder = 29
    end
    object lblVitHeight: TStaticText
      Left = 256
      Top = 145
      Width = 35
      Height = 17
      Caption = 'Height'
      TabOrder = 30
    end
    object lblVitWeight: TStaticText
      Left = 256
      Top = 169
      Width = 38
      Height = 17
      Caption = 'Weight'
      TabOrder = 31
    end
    object lblDatePain: TStaticText
      Tag = 5
      Left = 26
      Top = 193
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 32
      OnDblClick = lbllastClick
    end
    object lblLastPain: TStaticText
      Tag = 5
      Left = 124
      Top = 193
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 33
      OnDblClick = lbllastClick
    end
    object lblVitPain: TStaticText
      Left = 256
      Top = 193
      Width = 55
      Height = 17
      Caption = 'Pain Scale'
      TabOrder = 34
    end
    object txtMeasBP: TCaptionEdit
      Tag = 1
      Left = 318
      Top = 119
      Width = 100
      Height = 21
      TabOrder = 5
      OnEnter = SetVitPointer
      OnExit = txtMeasBPExit
      OnKeyPress = FormKeyPress
      Caption = 'Blood Pressure'
    end
    object cboTemp: TCaptionComboBox
      Tag = 7
      Left = 360
      Top = 48
      Width = 59
      Height = 21
      DropDownCount = 2
      ItemHeight = 13
      TabOrder = 2
      OnChange = cboTempChange
      OnEnter = SetVitPointer
      OnExit = cboTempExit
      OnKeyPress = FormKeyPress
      Items.Strings = (
        'F'
        'C')
      Caption = 'Temperature'
    end
    object txtMeasTemp: TCaptionEdit
      Tag = 2
      Left = 318
      Top = 48
      Width = 43
      Height = 21
      TabOrder = 1
      OnEnter = SetVitPointer
      OnExit = txtMeasTempExit
      OnKeyPress = FormKeyPress
      Caption = 'Temperature'
    end
    object txtMeasResp: TCaptionEdit
      Tag = 3
      Left = 318
      Top = 95
      Width = 100
      Height = 21
      TabOrder = 4
      OnEnter = SetVitPointer
      OnExit = txtMeasRespExit
      OnKeyPress = FormKeyPress
      Caption = 'Resp'
    end
    object txtMeasPulse: TCaptionEdit
      Tag = 4
      Left = 318
      Top = 72
      Width = 100
      Height = 21
      TabOrder = 3
      OnEnter = SetVitPointer
      OnExit = txtMeasPulseExit
      OnKeyPress = FormKeyPress
      Caption = 'Pulse'
    end
    object txtMeasHt: TCaptionEdit
      Tag = 5
      Left = 318
      Top = 142
      Width = 43
      Height = 21
      TabOrder = 6
      OnEnter = SetVitPointer
      OnExit = txtMeasHtExit
      OnKeyPress = FormKeyPress
      Caption = 'Height'
    end
    object cboHeight: TCaptionComboBox
      Tag = 8
      Left = 361
      Top = 142
      Width = 58
      Height = 21
      ItemHeight = 13
      TabOrder = 7
      OnChange = cboHeightChange
      OnEnter = SetVitPointer
      OnExit = cboHeightExit
      OnKeyPress = FormKeyPress
      Items.Strings = (
        'IN'
        'CM')
      Caption = 'Height'
    end
    object txtMeasWt: TCaptionEdit
      Tag = 6
      Left = 318
      Top = 166
      Width = 43
      Height = 21
      TabOrder = 8
      OnEnter = SetVitPointer
      OnExit = txtMeasWtExit
      OnKeyPress = FormKeyPress
      Caption = 'Weight'
    end
    object cboWeight: TCaptionComboBox
      Tag = 9
      Left = 361
      Top = 166
      Width = 58
      Height = 21
      ItemHeight = 13
      TabOrder = 9
      OnChange = cboWeightChange
      OnEnter = SetVitPointer
      OnExit = cboWeightExit
      OnKeyPress = FormKeyPress
      Items.Strings = (
        'LB'
        'KG')
      Caption = 'Weight'
    end
    object txtMeasDate: TORDateBox
      Tag = 11
      Left = 312
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'txtMeasDate'
      OnEnter = SetVitPointer
      OnKeyPress = FormKeyPress
      DateOnly = False
      RequireTime = False
      Caption = 'Vital Measured Date'
    end
    object cboPain: TORComboBox
      Tag = 10
      Left = 318
      Top = 190
      Width = 102
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Pain Scale'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '1,2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 10
      Text = ''
      OnEnter = SetVitPointer
      OnKeyPress = FormKeyPress
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlmain'
        'Status = stsDefault')
      (
        'Component = lblDate'
        'Status = stsDefault')
      (
        'Component = lblDateBP'
        'Status = stsDefault')
      (
        'Component = lblDateTemp'
        'Status = stsDefault')
      (
        'Component = lblDateResp'
        'Status = stsDefault')
      (
        'Component = lblDatePulse'
        'Status = stsDefault')
      (
        'Component = lblDateHeight'
        'Status = stsDefault')
      (
        'Component = lblDateWeight'
        'Status = stsDefault')
      (
        'Component = lblLstMeas'
        'Status = stsDefault')
      (
        'Component = lbllastBP'
        'Status = stsDefault')
      (
        'Component = lblLastTemp'
        'Status = stsDefault')
      (
        'Component = lblLastResp'
        'Status = stsDefault')
      (
        'Component = lblLastPulse'
        'Status = stsDefault')
      (
        'Component = lblLastHeight'
        'Status = stsDefault')
      (
        'Component = lblLastWeight'
        'Status = stsDefault')
      (
        'Component = lblVital'
        'Status = stsDefault')
      (
        'Component = lblVitBP'
        'Status = stsDefault')
      (
        'Component = lnlVitTemp'
        'Status = stsDefault')
      (
        'Component = lblVitResp'
        'Status = stsDefault')
      (
        'Component = lblVitPulse'
        'Status = stsDefault')
      (
        'Component = lblVitHeight'
        'Status = stsDefault')
      (
        'Component = lblVitWeight'
        'Status = stsDefault')
      (
        'Component = lblDatePain'
        'Status = stsDefault')
      (
        'Component = lblLastPain'
        'Status = stsDefault')
      (
        'Component = lblVitPain'
        'Status = stsDefault')
      (
        'Component = txtMeasBP'
        'Status = stsDefault')
      (
        'Component = cboTemp'
        'Status = stsDefault')
      (
        'Component = txtMeasTemp'
        'Status = stsDefault')
      (
        'Component = txtMeasResp'
        'Status = stsDefault')
      (
        'Component = txtMeasPulse'
        'Status = stsDefault')
      (
        'Component = txtMeasHt'
        'Status = stsDefault')
      (
        'Component = cboHeight'
        'Status = stsDefault')
      (
        'Component = txtMeasWt'
        'Status = stsDefault')
      (
        'Component = cboWeight'
        'Status = stsDefault')
      (
        'Component = txtMeasDate'
        'Text = Vital Measured Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboPain'
        'Status = stsDefault')
      (
        'Component = frmVit'
        'Status = stsDefault'))
  end
end
