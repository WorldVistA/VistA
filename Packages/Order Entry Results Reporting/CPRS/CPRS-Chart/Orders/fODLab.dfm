inherited frmODLab: TfrmODLab
  Tag = 120
  Left = 245
  Top = 263
  Width = 564
  Height = 321
  Caption = 'Order a Lab Test'
  ExplicitWidth = 564
  ExplicitHeight = 321
  PixelsPerInch = 120
  TextHeight = 16
  object lblAvailTests: TLabel [0]
    Left = 8
    Top = 5
    Width = 120
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Available Lab Tests'
  end
  object lblCollTime: TLabel [1]
    Left = 185
    Top = 190
    Width = 126
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Collection Date/Time'
  end
  object lblTestName: TLabel [2]
    Left = 225
    Top = 5
    Width = 3
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ShowAccelChar = False
  end
  object lblCollSamp: TLabel [3]
    Left = 234
    Top = 39
    Width = 91
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Collect Sample'
  end
  object lblSpecimen: TLabel [4]
    Left = 263
    Top = 73
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Specimen'
  end
  object lblUrgency: TLabel [5]
    Left = 271
    Top = 106
    Width = 51
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Urgency'
  end
  object lblAddlComment: TLabel [6]
    Left = 234
    Top = 134
    Width = 120
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Additional Comment'
    Visible = False
  end
  object bvlTestName: TBevel [7]
    Left = 225
    Top = 23
    Width = 423
    Height = 162
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = bsRaised
  end
  object lblFrequency: TLabel [8]
    Left = 408
    Top = 190
    Width = 68
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'How Often?'
  end
  object lblReqComment: TOROffsetLabel [9]
    Left = 483
    Top = 0
    Width = 120
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    HorzOffset = 2
    Transparent = False
    VertOffset = 2
    WordWrap = False
  end
  object lblHowManyDays: TLabel [10]
    Left = 539
    Top = 190
    Width = 67
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'How Long?'
  end
  object lblCollType: TLabel [11]
    Left = 9
    Top = 190
    Width = 94
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Collection Type'
  end
  inherited memOrder: TCaptionMemo
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 22
  end
  object txtImmedColl: TCaptionEdit [13]
    Left = 186
    Top = 208
    Width = 177
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 16
    Text = 'txtImmedColl'
    Caption = ''
  end
  object calCollTime: TORDateBox [14]
    Left = 186
    Top = 208
    Width = 207
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 15
    OnChange = ControlChange
    DateOnly = False
    RequireTime = False
    Caption = ''
  end
  object pnlUrineVolume: TORAutoPanel [15]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 10
    object lblUrineVolume: TOROffsetLabel
      Left = 8
      Top = 36
      Width = 138
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter the urine volume:'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object txtUrineVolume: TCaptionEdit
      Left = 6
      Top = 70
      Width = 152
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      OnExit = txtUrineVolumeExit
      Caption = ''
    end
  end
  object pnlAntiCoagulation: TORAutoPanel [16]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 9
    object lblAntiCoagulant: TOROffsetLabel
      Left = 8
      Top = 10
      Width = 121
      Height = 51
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'What kind of anticoagulant is the patient on?'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = True
    end
    object txtAntiCoagulant: TCaptionEdit
      Left = 8
      Top = 70
      Width = 151
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      OnExit = txtAntiCoagulantExit
      Caption = ''
    end
  end
  object pnlOrderComment: TORAutoPanel [17]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 8
    Visible = False
    object lblOrderComment: TOROffsetLabel
      Left = 8
      Top = 46
      Width = 128
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter order comment:'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = True
    end
    object txtOrderComment: TCaptionEdit
      Left = 8
      Top = 71
      Width = 151
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      OnExit = txtOrderCommentExit
      Caption = ''
    end
  end
  object pnlHide: TORAutoPanel [18]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    TabOrder = 7
  end
  object pnlDoseDraw: TORAutoPanel [19]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 12
    object lblDose: TOROffsetLabel
      Left = 13
      Top = 19
      Width = 143
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter the last dose time:'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblDraw: TOROffsetLabel
      Left = 13
      Top = 85
      Width = 97
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter draw time:'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object txtDoseTime: TCaptionEdit
      Left = 13
      Top = 39
      Width = 140
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      OnExit = txtDoseTimeExit
      Caption = ''
    end
    object txtDrawTime: TCaptionEdit
      Left = 13
      Top = 106
      Width = 140
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 1
      OnExit = txtDrawTimeExit
      Caption = ''
    end
  end
  object pnlPeakTrough: TORAutoPanel [20]
    Left = 473
    Top = 31
    Width = 166
    Height = 148
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 11
    object lblPeakTrough: TOROffsetLabel
      Left = 8
      Top = 9
      Width = 102
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Sample drawn at:'
      HorzOffset = 0
      Transparent = False
      VertOffset = 0
      WordWrap = True
    end
    object grpPeakTrough: TRadioGroup
      Left = 8
      Top = 25
      Width = 150
      Height = 111
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Items.Strings = (
        '&Peak'
        '&Trough'
        '&Mid'
        '&Unknown')
      TabOrder = 0
      OnClick = grpPeakTroughClick
    end
  end
  object pnlCollTimeButton: TKeyClickPanel [21]
    Left = 360
    Top = 209
    Width = 25
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    Caption = 'Select collection time'
    TabOrder = 17
    TabStop = True
    OnClick = cmdImmedCollClick
    OnEnter = pnlCollTimeButtonEnter
    OnExit = pnlCollTimeButtonExit
    object cmdImmedColl: TSpeedButton
      Left = 1
      Top = 1
      Width = 23
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Glyph.Data = {
        D6000000424DD60000000000000076000000280000000C0000000C0000000100
        0400000000006000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        0000333333333333000033333333333300003333333333330000300330033003
        0000300330033003000033333333333300003333333333330000333333333333
        0000333333333333000033333333333300003333333333330000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      OnClick = cmdImmedCollClick
    end
  end
  object cboAvailTest: TORComboBox [22]
    Left = 8
    Top = 23
    Width = 210
    Height = 162
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Available Lab Tests'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    Text = ''
    OnClick = cboAvailTestSelect
    OnExit = cboAvailTestExit
    OnNeedData = cboAvailTestNeedData
    CharsNeedMatch = 1
  end
  object cboFrequency: TORComboBox [23]
    Left = 408
    Top = 208
    Width = 121
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'How Often?'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 18
    Text = ''
    OnChange = cboFrequencyChange
    CharsNeedMatch = 1
  end
  object cboCollSamp: TORComboBox [24]
    Left = 336
    Top = 35
    Width = 125
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Collect Sample'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    OnChange = cboCollSampChange
    OnEnter = cboCollSampMouseClick
    OnKeyPause = cboCollSampKeyPause
    OnMouseClick = cboCollSampMouseClick
    CharsNeedMatch = 1
  end
  object cboSpecimen: TORComboBox [25]
    Left = 336
    Top = 69
    Width = 125
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Specimen'
    Color = clWindow
    DropDownCount = 10
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    ParentShowHint = False
    Pieces = '2'
    ShowHint = True
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 3
    Text = ''
    OnChange = cboSpecimenChange
    OnEnter = cboSpecimenMouseClick
    OnKeyPause = cboSpecimenKeyPause
    OnMouseClick = cboSpecimenMouseClick
    CharsNeedMatch = 1
  end
  object cboUrgency: TORComboBox [26]
    Left = 336
    Top = 103
    Width = 125
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Urgency'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 5
    Text = ''
    OnChange = cboUrgencyChange
    CharsNeedMatch = 1
  end
  object txtAddlComment: TCaptionEdit [27]
    Left = 234
    Top = 153
    Width = 225
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 6
    Visible = False
    OnExit = txtAddlCommentExit
    Caption = 'Additional Comment'
  end
  object txtDays: TCaptionEdit [28]
    Left = 538
    Top = 208
    Width = 105
    Height = 24
    Hint = 'Enter a number of days, or an "X" followed by a number of times.'
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Enabled = False
    TabOrder = 20
    OnChange = ControlChange
    Caption = 'How Long?'
  end
  object FLabCommonCombo: TORListBox [29]
    Left = 550
    Top = 309
    Width = 151
    Height = 121
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabStop = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    Visible = False
    Caption = ''
    ItemTipColor = clWindow
    LongList = False
  end
  object cboCollTime: TORComboBox [30]
    Left = 186
    Top = 208
    Width = 210
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Collection Date/Time'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 14
    Text = ''
    OnChange = cboCollTimeChange
    OnExit = cboCollTimeExit
    CharsNeedMatch = 1
  end
  object cboCollType: TORComboBox [31]
    Left = 8
    Top = 208
    Width = 170
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Collection Type'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 13
    Text = ''
    OnChange = cboCollTypeChange
    CharsNeedMatch = 1
  end
  object Frequencylbl508: TVA508StaticText [32]
    Name = 'Frequencylbl508'
    Left = 407
    Top = 189
    Width = 87
    Height = 18
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'How Often?'
    Enabled = False
    TabOrder = 19
    Visible = False
    ShowAccelChar = True
  end
  object HowManyDayslbl508: TVA508StaticText [33]
    Name = 'HowManyDayslbl508'
    Left = 538
    Top = 189
    Width = 86
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'How Long?'
    Enabled = False
    TabOrder = 21
    Visible = False
    ShowAccelChar = True
  end
  object specimenlbl508: TVA508StaticText [34]
    Name = 'specimenlbl508'
    Left = 262
    Top = 72
    Width = 70
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'Specimen'
    Enabled = False
    TabOrder = 4
    Visible = False
    ShowAccelChar = True
  end
  object CollSamplbl508: TVA508StaticText [35]
    Name = 'CollSamplbl508'
    Left = 233
    Top = 38
    Width = 100
    Height = 22
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Alignment = taLeftJustify
    Caption = 'Collect Sample'
    Enabled = False
    TabOrder = 2
    Visible = False
    ShowAccelChar = True
  end
  inherited cmdAccept: TButton
    Left = 554
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 23
    ExplicitLeft = 554
  end
  inherited cmdQuit: TButton
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 24
  end
  inherited pnlMessage: TPanel
    Left = 23
    Top = 240
    Height = 70
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 25
    ExplicitLeft = 23
    ExplicitTop = 240
    ExplicitHeight = 70
    inherited imgMessage: TImage
      Top = 14
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitTop = 14
    end
    inherited memMessage: TRichEdit
      Left = 51
      Top = 6
      Height = 54
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      PopupMenu = MessagePopup
      ExplicitLeft = 51
      ExplicitTop = 6
      ExplicitHeight = 54
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtImmedColl'
        'Status = stsDefault')
      (
        'Component = calCollTime'
        'Text = Collection Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = pnlUrineVolume'
        'Status = stsDefault')
      (
        'Component = txtUrineVolume'
        'Status = stsDefault')
      (
        'Component = pnlAntiCoagulation'
        'Status = stsDefault')
      (
        'Component = txtAntiCoagulant'
        'Status = stsDefault')
      (
        'Component = pnlOrderComment'
        'Status = stsDefault')
      (
        'Component = txtOrderComment'
        'Status = stsDefault')
      (
        'Component = pnlHide'
        'Status = stsDefault')
      (
        'Component = pnlDoseDraw'
        'Status = stsDefault')
      (
        'Component = txtDoseTime'
        'Status = stsDefault')
      (
        'Component = txtDrawTime'
        'Status = stsDefault')
      (
        'Component = pnlPeakTrough'
        'Status = stsDefault')
      (
        'Component = grpPeakTrough'
        'Status = stsDefault')
      (
        'Component = pnlCollTimeButton'
        'Status = stsDefault')
      (
        'Component = cboAvailTest'
        'Status = stsDefault')
      (
        'Component = cboFrequency'
        'Status = stsDefault')
      (
        'Component = cboCollSamp'
        'Status = stsDefault')
      (
        'Component = cboSpecimen'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = txtAddlComment'
        'Status = stsDefault')
      (
        'Component = txtDays'
        'Status = stsDefault')
      (
        'Component = FLabCommonCombo'
        'Status = stsDefault')
      (
        'Component = cboCollTime'
        'Status = stsDefault')
      (
        'Component = cboCollType'
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
        'Component = frmODLab'
        'Status = stsDefault')
      (
        'Component = Frequencylbl508'
        'Status = stsDefault')
      (
        'Component = HowManyDayslbl508'
        'Status = stsDefault')
      (
        'Component = specimenlbl508'
        'Status = stsDefault')
      (
        'Component = CollSamplbl508'
        'Status = stsDefault'))
  end
  object dlgLabCollTime: TORDateTimeDlg
    FMDateTime = 2980923.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 139
    Top = 4
  end
  object MessagePopup: TPopupMenu
    Left = 340
    Top = 218
    object ViewinReportWindow1: TMenuItem
      Caption = '&View in Report Window'
      OnClick = ViewinReportWindow1Click
    end
  end
end
