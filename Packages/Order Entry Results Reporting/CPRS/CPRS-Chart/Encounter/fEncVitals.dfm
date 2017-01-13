inherited frmEncVitals: TfrmEncVitals
  Left = 353
  Top = 210
  Caption = 'Vitals'
  OnActivate = FormActivate
  OnShow = FormShow
  ExplicitWidth = 640
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  object lvVitals: TCaptionListView [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 368
    Align = alClient
    Columns = <>
    Constraints.MinHeight = 50
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
    AutoSize = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 368
    Width = 624
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object btnEnterVitals: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 21
      Caption = 'Enter Vitals'
      TabOrder = 0
      OnClick = btnEnterVitalsClick
    end
    object btnOKkludge: TButton
      Left = 434
      Top = 6
      Width = 75
      Height = 21
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancelkludge: TButton
      Left = 522
      Top = 6
      Width = 75
      Height = 21
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  inherited btnOK: TBitBtn
    Left = 208
    Top = 374
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'OK No Show'
    TabOrder = 2
    Visible = False
    ExplicitLeft = 208
    ExplicitTop = 374
  end
  inherited btnCancel: TBitBtn
    Left = 289
    Top = 374
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Cancel No Show'
    TabOrder = 3
    Visible = False
    ExplicitLeft = 289
    ExplicitTop = 374
  end
  object pnlmain: TPanel [4]
    Left = 28
    Top = 24
    Width = 569
    Height = 217
    TabOrder = 0
    Visible = False
    object lblVitPointer: TOROffsetLabel
      Left = 506
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
      Left = 56
      Top = 23
      Width = 31
      Height = 17
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object lblDateBP: TStaticText
      Tag = 3
      Left = 50
      Top = 122
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 17
    end
    object lblDateTemp: TStaticText
      Left = 50
      Top = 52
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 4
    end
    object lblDateResp: TStaticText
      Tag = 2
      Left = 50
      Top = 98
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 13
    end
    object lblDatePulse: TStaticText
      Tag = 1
      Left = 50
      Top = 75
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 9
    end
    object lblDateHeight: TStaticText
      Tag = 4
      Left = 50
      Top = 145
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 21
    end
    object lblDateWeight: TStaticText
      Tag = 5
      Left = 50
      Top = 169
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 26
    end
    object lblLstMeas: TStaticText
      Left = 180
      Top = 23
      Width = 80
      Height = 17
      Caption = 'Last Measure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object lbllastBP: TStaticText
      Tag = 3
      Left = 188
      Top = 122
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 18
    end
    object lblLastTemp: TStaticText
      Left = 188
      Top = 52
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 5
    end
    object lblLastResp: TStaticText
      Tag = 2
      Left = 188
      Top = 98
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 14
    end
    object lblLastPulse: TStaticText
      Tag = 1
      Left = 188
      Top = 75
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 10
    end
    object lblLastHeight: TStaticText
      Tag = 4
      Left = 188
      Top = 145
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 22
    end
    object lblLastWeight: TStaticText
      Tag = 5
      Left = 188
      Top = 169
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 27
    end
    object lblVital: TStaticText
      Left = 344
      Top = 23
      Width = 29
      Height = 17
      Caption = 'Vital'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object lblVitBP: TStaticText
      Left = 344
      Top = 122
      Width = 23
      Height = 17
      Caption = 'B/P'
      TabOrder = 19
    end
    object lnlVitTemp: TStaticText
      Left = 344
      Top = 52
      Width = 31
      Height = 17
      Caption = 'Temp'
      TabOrder = 6
    end
    object lblVitResp: TStaticText
      Left = 344
      Top = 98
      Width = 29
      Height = 17
      Caption = 'Resp'
      TabOrder = 15
    end
    object lblVitPulse: TStaticText
      Left = 344
      Top = 75
      Width = 30
      Height = 17
      Caption = 'Pulse'
      TabOrder = 11
    end
    object lblVitHeight: TStaticText
      Left = 344
      Top = 145
      Width = 35
      Height = 17
      Caption = 'Height'
      TabOrder = 23
    end
    object lblVitWeight: TStaticText
      Left = 344
      Top = 169
      Width = 38
      Height = 17
      Caption = 'Weight'
      TabOrder = 28
    end
    object lblVitPain: TStaticText
      Left = 344
      Top = 193
      Width = 55
      Height = 17
      Caption = 'Pain Scale'
      TabOrder = 33
    end
    object lblLastPain: TStaticText
      Tag = 5
      Left = 188
      Top = 193
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 32
    end
    object lblDatePain: TStaticText
      Tag = 5
      Left = 50
      Top = 193
      Width = 24
      Height = 17
      Caption = 'N/A'
      TabOrder = 31
    end
    object txtMeasBP: TCaptionEdit
      Tag = 1
      Left = 406
      Top = 119
      Width = 100
      Height = 21
      TabOrder = 20
      OnEnter = SetVitPointer
      OnExit = txtMeasBPExit
      Caption = 'Blood Pressure'
    end
    object cboTemp: TCaptionComboBox
      Tag = 7
      Left = 448
      Top = 48
      Width = 57
      Height = 21
      DropDownCount = 2
      TabOrder = 8
      OnChange = cboTempChange
      OnEnter = SetVitPointer
      OnExit = cboTempExit
      Items.Strings = (
        'F'
        'C')
      Caption = 'Temperature'
    end
    object txtMeasTemp: TCaptionEdit
      Tag = 2
      Left = 406
      Top = 48
      Width = 43
      Height = 21
      TabOrder = 7
      OnEnter = SetVitPointer
      OnExit = txtMeasTempExit
      Caption = 'Temperature'
    end
    object txtMeasResp: TCaptionEdit
      Tag = 3
      Left = 406
      Top = 95
      Width = 100
      Height = 21
      TabOrder = 16
      OnEnter = SetVitPointer
      OnExit = txtMeasRespExit
      Caption = 'Resp'
    end
    object cboHeight: TCaptionComboBox
      Tag = 8
      Left = 449
      Top = 142
      Width = 57
      Height = 21
      TabOrder = 25
      OnChange = cboHeightChange
      OnEnter = SetVitPointer
      OnExit = cboHeightExit
      Items.Strings = (
        'IN'
        'CM')
      Caption = 'Height'
    end
    object txtMeasWt: TCaptionEdit
      Tag = 6
      Left = 406
      Top = 166
      Width = 43
      Height = 21
      TabOrder = 29
      OnEnter = SetVitPointer
      OnExit = txtMeasWtExit
      Caption = 'Weight'
    end
    object cboWeight: TCaptionComboBox
      Tag = 9
      Left = 449
      Top = 166
      Width = 57
      Height = 21
      TabOrder = 30
      OnChange = cboWeightChange
      OnEnter = SetVitPointer
      OnExit = cboWeightExit
      Items.Strings = (
        'LB'
        'KG')
      Caption = 'Weight'
    end
    object txtMeasDate: TORDateBox
      Tag = 11
      Left = 406
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      OnEnter = SetVitPointer
      DateOnly = False
      RequireTime = False
      Caption = 'Current Vital Date '
    end
    object cboPain: TORComboBox
      Tag = 10
      Left = 406
      Top = 190
      Width = 102
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Pain Scale'
      Color = clWindow
      DropDownCount = 12
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
      TabOrder = 34
      TabStop = True
      Text = ''
      OnEnter = SetVitPointer
      CharsNeedMatch = 1
    end
    object txtMeasPulse: TCaptionEdit
      Tag = 4
      Left = 406
      Top = 72
      Width = 100
      Height = 21
      TabOrder = 12
      OnEnter = SetVitPointer
      OnExit = txtMeasPulseExit
      Caption = 'Pulse'
    end
    object txtMeasHt: TCaptionEdit
      Tag = 5
      Left = 406
      Top = 142
      Width = 43
      Height = 21
      TabOrder = 24
      OnEnter = SetVitPointer
      OnExit = txtMeasHtExit
      Caption = 'Height'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lvVitals'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnEnterVitals'
        'Status = stsDefault')
      (
        'Component = btnOKkludge'
        'Status = stsDefault')
      (
        'Component = btnCancelkludge'
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
        'Component = lblVitPain'
        'Status = stsDefault')
      (
        'Component = lblLastPain'
        'Status = stsDefault')
      (
        'Component = lblDatePain'
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
        'Text = Current vital Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboPain'
        'Status = stsDefault')
      (
        'Component = txtMeasPulse'
        'Status = stsDefault')
      (
        'Component = txtMeasHt'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmEncVitals'
        'Status = stsDefault'))
  end
end
