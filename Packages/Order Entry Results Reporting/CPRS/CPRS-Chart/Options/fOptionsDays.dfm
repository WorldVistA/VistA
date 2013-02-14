inherited frmOptionsDays: TfrmOptionsDays
  Left = 516
  Top = 90
  HelpContext = 9010
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Date Range Defaults on Cover Sheet'
  ClientHeight = 337
  ClientWidth = 328
  HelpFile = 'CPRSWT.HLP'
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvlTop: TBevel [0]
    Left = 11
    Top = 9
    Width = 310
    Height = 2
  end
  object bvlMiddle: TBevel [1]
    Left = 11
    Top = 155
    Width = 310
    Height = 2
  end
  object lblVisitStop: TLabel [2]
    Left = 15
    Top = 251
    Width = 25
    Height = 13
    Caption = 'Stop:'
  end
  object lblVisitStart: TLabel [3]
    Left = 15
    Top = 197
    Width = 25
    Height = 13
    Caption = 'Start:'
  end
  object lblLabOutpatient: TLabel [4]
    Left = 15
    Top = 103
    Width = 77
    Height = 13
    Caption = 'Outpatient days:'
  end
  object lblLabInpatient: TLabel [5]
    Left = 15
    Top = 47
    Width = 69
    Height = 13
    Caption = 'Inpatient days:'
  end
  object lblVisitValue: TMemo [6]
    Left = 136
    Top = 219
    Width = 169
    Height = 73
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'lblVisitValue')
    ReadOnly = True
    TabOrder = 13
  end
  object lblLabValue: TMemo [7]
    Left = 136
    Top = 71
    Width = 169
    Height = 74
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'lblLabValue')
    ReadOnly = True
    TabOrder = 14
  end
  object lblVisit: TStaticText [8]
    Left = 15
    Top = 164
    Width = 115
    Height = 17
    Caption = 'Appointments and visits'
    TabOrder = 11
  end
  object lblLab: TStaticText [9]
    Left = 15
    Top = 16
    Width = 55
    Height = 17
    Caption = 'Lab results'
    TabOrder = 12
  end
  object pnlBottom: TPanel [10]
    Left = 0
    Top = 304
    Width = 328
    Height = 33
    HelpContext = 9010
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 10
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 328
      Height = 2
      Align = alTop
    end
    object btnOK: TButton
      Left = 167
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 247
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9997
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object txtLabInpatient: TCaptionEdit [11]
    Left = 15
    Top = 66
    Width = 42
    Height = 21
    HelpContext = 9013
    TabOrder = 0
    Text = '1'
    OnChange = txtLabInpatientChange
    OnExit = txtLabInpatientExit
    OnKeyPress = txtLabInpatientKeyPress
    Caption = 'Inpatient days'
  end
  object spnLabInpatient: TUpDown [12]
    Left = 57
    Top = 66
    Width = 16
    Height = 21
    HelpContext = 9013
    Associate = txtLabInpatient
    Max = 999
    Position = 1
    TabOrder = 1
    Thousands = False
    OnClick = spnLabInpatientClick
  end
  object txtLabOutpatient: TCaptionEdit [13]
    Left = 15
    Top = 121
    Width = 42
    Height = 21
    HelpContext = 9014
    TabOrder = 2
    Text = '1'
    OnChange = txtLabOutpatientChange
    OnExit = txtLabOutpatientExit
    OnKeyPress = txtLabInpatientKeyPress
    Caption = 'Outpatient days'
  end
  object spnLabOutpatient: TUpDown [14]
    Left = 57
    Top = 121
    Width = 16
    Height = 21
    HelpContext = 9014
    Associate = txtLabOutpatient
    Max = 999
    Position = 1
    TabOrder = 3
    Thousands = False
    OnClick = spnLabOutpatientClick
  end
  object txtVisitStart: TCaptionEdit [15]
    Tag = -180
    Left = 15
    Top = 214
    Width = 79
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 5
    Text = '0'
    OnExit = txtVisitStartExit
    OnKeyPress = txtVisitStartKeyPress
    OnKeyUp = txtVisitStartKeyUp
    Caption = 'Start'
  end
  object spnVisitStart: TUpDown [16]
    Tag = -180
    Left = 94
    Top = 214
    Width = 15
    Height = 21
    HelpContext = 9015
    Associate = txtVisitStart
    Min = -999
    Max = 999
    TabOrder = 6
    Thousands = False
    OnClick = spnVisitStartClick
  end
  object txtVisitStop: TCaptionEdit [17]
    Tag = 30
    Left = 15
    Top = 269
    Width = 79
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 7
    Text = '0'
    OnExit = txtVisitStopExit
    OnKeyPress = txtVisitStopKeyPress
    OnKeyUp = txtVisitStopKeyUp
    Caption = 'Stop'
  end
  object spnVisitStop: TUpDown [18]
    Tag = 30
    Left = 94
    Top = 269
    Width = 16
    Height = 21
    HelpContext = 9015
    Associate = txtVisitStop
    Min = -999
    Max = 999
    TabOrder = 8
    Thousands = False
    OnClick = spnVisitStopClick
  end
  object btnLabDefaults: TButton [19]
    Left = 245
    Top = 32
    Width = 75
    Height = 22
    HelpContext = 9011
    Caption = 'Use Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnLabDefaultsClick
  end
  object btnVisitDefaults: TButton [20]
    Left = 245
    Top = 184
    Width = 75
    Height = 22
    HelpContext = 9012
    Caption = 'Use Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btnVisitDefaultsClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblVisitValue'
        'Status = stsDefault')
      (
        'Component = lblLabValue'
        'Status = stsDefault')
      (
        'Component = lblVisit'
        'Status = stsDefault')
      (
        'Component = lblLab'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = txtLabInpatient'
        'Status = stsDefault')
      (
        'Component = spnLabInpatient'
        'Status = stsDefault')
      (
        'Component = txtLabOutpatient'
        'Status = stsDefault')
      (
        'Component = spnLabOutpatient'
        'Status = stsDefault')
      (
        'Component = txtVisitStart'
        'Status = stsDefault')
      (
        'Component = spnVisitStart'
        'Status = stsDefault')
      (
        'Component = txtVisitStop'
        'Status = stsDefault')
      (
        'Component = spnVisitStop'
        'Status = stsDefault')
      (
        'Component = btnLabDefaults'
        'Status = stsDefault')
      (
        'Component = btnVisitDefaults'
        'Status = stsDefault')
      (
        'Component = frmOptionsDays'
        'Status = stsDefault'))
  end
end
