inherited frmOptionsDays: TfrmOptionsDays
  Left = 516
  Top = 90
  HelpContext = 9010
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Date Range Defaults on Cover Sheet'
  ClientHeight = 415
  ClientWidth = 404
  HelpFile = 'CPRSWT.HLP'
  Position = poDefault
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 120
  TextHeight = 16
  object bvlTop: TBevel [0]
    Left = 14
    Top = 11
    Width = 381
    Height = 3
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object bvlMiddle: TBevel [1]
    Left = 14
    Top = 191
    Width = 381
    Height = 2
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object lblVisitStop: TLabel [2]
    Left = 18
    Top = 309
    Width = 31
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Stop:'
  end
  object lblVisitStart: TLabel [3]
    Left = 18
    Top = 242
    Width = 30
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Start:'
  end
  object lblLabOutpatient: TLabel [4]
    Left = 18
    Top = 127
    Width = 96
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Outpatient days:'
  end
  object lblLabInpatient: TLabel [5]
    Left = 18
    Top = 58
    Width = 86
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Inpatient days:'
  end
  object lblVisitValue: TMemo [6]
    Left = 167
    Top = 270
    Width = 208
    Height = 89
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'lblVisitValue')
    ReadOnly = True
    TabOrder = 13
  end
  object lblLabValue: TMemo [7]
    Left = 167
    Top = 87
    Width = 208
    Height = 91
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'lblLabValue')
    ReadOnly = True
    TabOrder = 14
  end
  object lblVisit: TStaticText [8]
    Left = 18
    Top = 202
    Width = 145
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Appointments and visits'
    TabOrder = 11
  end
  object lblLab: TStaticText [9]
    Left = 18
    Top = 20
    Width = 69
    Height = 20
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Lab results'
    TabOrder = 12
  end
  object pnlBottom: TPanel [10]
    Left = 0
    Top = 374
    Width = 404
    Height = 41
    HelpContext = 9010
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 10
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 404
      Height = 2
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
    end
    object btnOK: TButton
      Left = 206
      Top = 10
      Width = 92
      Height = 27
      HelpContext = 9996
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 304
      Top = 10
      Width = 92
      Height = 27
      HelpContext = 9997
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object txtLabInpatient: TCaptionEdit [11]
    Left = 18
    Top = 81
    Width = 52
    Height = 21
    HelpContext = 9013
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    Text = '1'
    OnChange = txtLabInpatientChange
    OnExit = txtLabInpatientExit
    OnKeyPress = txtLabInpatientKeyPress
    Caption = 'Inpatient days'
  end
  object spnLabInpatient: TUpDown [12]
    Left = 70
    Top = 81
    Width = 20
    Height = 26
    HelpContext = 9013
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtLabInpatient
    Max = 999
    Position = 1
    TabOrder = 1
    Thousands = False
    OnClick = spnLabInpatientClick
  end
  object txtLabOutpatient: TCaptionEdit [13]
    Left = 18
    Top = 149
    Width = 52
    Height = 21
    HelpContext = 9014
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    Text = '1'
    OnChange = txtLabOutpatientChange
    OnExit = txtLabOutpatientExit
    OnKeyPress = txtLabInpatientKeyPress
    Caption = 'Outpatient days'
  end
  object spnLabOutpatient: TUpDown [14]
    Left = 70
    Top = 149
    Width = 20
    Height = 26
    HelpContext = 9014
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtLabOutpatient
    Max = 999
    Position = 1
    TabOrder = 3
    Thousands = False
    OnClick = spnLabOutpatientClick
  end
  object txtVisitStart: TCaptionEdit [15]
    Tag = -180
    Left = 18
    Top = 263
    Width = 98
    Height = 21
    HelpContext = 9015
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    Left = 116
    Top = 263
    Width = 18
    Height = 26
    HelpContext = 9015
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtVisitStart
    Min = -999
    Max = 999
    TabOrder = 6
    Thousands = False
    OnClick = spnVisitStartClick
  end
  object txtVisitStop: TCaptionEdit [17]
    Tag = 30
    Left = 18
    Top = 331
    Width = 98
    Height = 21
    HelpContext = 9015
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
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
    Left = 116
    Top = 331
    Width = 19
    Height = 26
    HelpContext = 9015
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtVisitStop
    Min = -999
    Max = 999
    TabOrder = 8
    Thousands = False
    OnClick = spnVisitStopClick
  end
  object btnLabDefaults: TButton [19]
    Left = 302
    Top = 39
    Width = 92
    Height = 27
    HelpContext = 9011
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnLabDefaultsClick
  end
  object btnVisitDefaults: TButton [20]
    Left = 302
    Top = 226
    Width = 92
    Height = 28
    HelpContext = 9012
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Use Defaults'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
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
