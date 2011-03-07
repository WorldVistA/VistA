inherited frmOptionsOther: TfrmOptionsOther
  Left = 341
  Top = 96
  Hint = 'Use system default settings'
  HelpContext = 9110
  Align = alCustom
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Other Parameters'
  ClientHeight = 436
  ClientWidth = 329
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMedsTab: TLabel [0]
    Left = 7
    Top = 121
    Width = 135
    Height = 26
    Hint = 'Set date ranges for displaying medication orders on Meds tab.'
    Caption = 'Set date range for Meds tab display:'
    ParentShowHint = False
    ShowHint = True
    WordWrap = True
  end
  object lblTab: TLabel [1]
    Left = 8
    Top = 27
    Width = 134
    Height = 13
    Caption = 'Initial tab when CPRS starts:'
  end
  object Bevel1: TBevel [2]
    Left = 1
    Top = 110
    Width = 327
    Height = 2
  end
  object lblEncAppts: TLabel [3]
    Left = 8
    Top = 269
    Width = 207
    Height = 13
    Hint = 'Set date range for Encounter Appointments.'
    Caption = 'Set date range for Encounter Appointments:'
    ParentShowHint = False
    ShowHint = True
    WordWrap = True
  end
  object Bevel2: TBevel [4]
    Left = 1
    Top = 256
    Width = 327
    Height = 2
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 403
    Width = 329
    Height = 33
    HelpContext = 9110
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 7
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 329
      Height = 2
      Align = alTop
    end
    object btnOK: TButton
      Left = 167
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9996
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 248
      Top = 7
      Width = 75
      Height = 22
      HelpContext = 9997
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object stStart: TStaticText [6]
    Left = 7
    Top = 151
    Width = 55
    Height = 17
    Caption = 'Start Date:'
    TabOrder = 1
  end
  object stStop: TStaticText [7]
    Left = 7
    Top = 207
    Width = 55
    Height = 17
    Caption = 'Stop Date:'
    TabOrder = 5
  end
  object dtStart: TORDateBox [8]
    Left = 7
    Top = 170
    Width = 187
    Height = 21
    TabOrder = 4
    OnChange = dtStartChange
    OnExit = dtStartExit
    DateOnly = True
    RequireTime = False
    Caption = 'Start Date'
  end
  object dtStop: TORDateBox [9]
    Left = 8
    Top = 225
    Width = 186
    Height = 21
    TabOrder = 6
    OnExit = dtStopExit
    DateOnly = True
    RequireTime = False
    Caption = 'Stop Date'
  end
  object lblTabDefault: TStaticText [10]
    Left = 8
    Top = 6
    Width = 52
    Height = 17
    Caption = 'Chart tabs'
    TabOrder = 0
  end
  object cboTab: TORComboBox [11]
    Left = 8
    Top = 51
    Width = 217
    Height = 21
    HelpContext = 9111
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Initial tab when CPRS starts:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 2
    TabStop = True
    CharsNeedMatch = 1
  end
  object chkLastTab: TCheckBox [12]
    Left = 8
    Top = 82
    Width = 312
    Height = 21
    HelpContext = 9112
    Caption = 'Use last selected tab on patient change'
    TabOrder = 3
  end
  object stStartEncAppts: TStaticText [13]
    Left = 9
    Top = 296
    Width = 55
    Height = 17
    Caption = 'Start Date:'
    TabOrder = 13
  end
  object txtTodayMinus: TStaticText [14]
    Left = 38
    Top = 321
    Width = 64
    Height = 17
    Alignment = taRightJustify
    Caption = 'Today minus'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 14
  end
  object txtEncStart: TCaptionEdit [15]
    Left = 110
    Top = 318
    Width = 50
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 8
    Text = '0'
    OnChange = txtEncStartChange
    OnExit = txtEncStartExit
    Caption = 'Stop'
  end
  object txtDaysMinus: TStaticText [16]
    Left = 178
    Top = 322
    Width = 26
    Height = 17
    Caption = 'days'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 16
  end
  object spnEncStart: TUpDown [17]
    Tag = 30
    Left = 160
    Top = 318
    Width = 15
    Height = 21
    HelpContext = 9015
    Associate = txtEncStart
    Min = -999
    Max = 999
    TabOrder = 17
    Thousands = False
  end
  object txtDaysPlus: TStaticText [18]
    Left = 180
    Top = 374
    Width = 26
    Height = 17
    Caption = 'days'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 18
  end
  object spnEncStop: TUpDown [19]
    Tag = 30
    Left = 162
    Top = 369
    Width = 15
    Height = 21
    HelpContext = 9015
    Associate = txtEncStop
    Min = -999
    Max = 999
    TabOrder = 19
    Thousands = False
  end
  object txtEncStop: TCaptionEdit [20]
    Left = 112
    Top = 369
    Width = 50
    Height = 21
    HelpContext = 9015
    MaxLength = 12
    TabOrder = 10
    Text = '0'
    OnChange = txtEncStopChange
    OnExit = txtEncStopExit
    Caption = 'Stop'
  end
  object txtTodayPlus: TStaticText [21]
    Left = 46
    Top = 372
    Width = 56
    Height = 17
    Alignment = taRightJustify
    Caption = 'Today plus'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 21
  end
  object stStopEncAppts: TStaticText [22]
    Left = 10
    Top = 348
    Width = 55
    Height = 17
    Caption = 'Stop Date:'
    TabOrder = 22
  end
  object btnEncDefaults: TButton [23]
    Left = 248
    Top = 287
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
    TabOrder = 12
    OnClick = btnEncDefaultsClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Component = stStart'
        'Status = stsDefault')
      (
        'Component = stStop'
        'Status = stsDefault')
      (
        'Component = dtStart'
        'Status = stsDefault')
      (
        'Component = dtStop'
        'Status = stsDefault')
      (
        'Component = lblTabDefault'
        'Status = stsDefault')
      (
        'Component = cboTab'
        'Status = stsDefault')
      (
        'Component = chkLastTab'
        'Status = stsDefault')
      (
        'Component = stStartEncAppts'
        'Status = stsDefault')
      (
        'Component = txtTodayMinus'
        'Status = stsDefault')
      (
        'Component = txtEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysMinus'
        'Status = stsDefault')
      (
        'Component = spnEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysPlus'
        'Status = stsDefault')
      (
        'Component = spnEncStop'
        'Status = stsDefault')
      (
        'Component = txtEncStop'
        'Status = stsDefault')
      (
        'Component = txtTodayPlus'
        'Status = stsDefault')
      (
        'Component = stStopEncAppts'
        'Status = stsDefault')
      (
        'Component = btnEncDefaults'
        'Status = stsDefault')
      (
        'Component = frmOptionsOther'
        'Status = stsDefault'))
  end
end
