inherited frmOptionsTeams: TfrmOptionsTeams
  Left = 730
  Top = 96
  HelpContext = 9090
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Team Information'
  ClientHeight = 410
  ClientWidth = 384
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 390
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  object lblTeams: TLabel [0]
    Left = 8
    Top = 125
    Width = 115
    Height = 13
    Caption = 'You are on these teams:'
  end
  object lblPatients: TLabel [1]
    Left = 198
    Top = 102
    Width = 130
    Height = 13
    Caption = 'Patients on selected teams:'
  end
  object lblTeamMembers: TLabel [2]
    Left = 198
    Top = 246
    Width = 75
    Height = 13
    Caption = 'Team members:'
  end
  object lblSubscribe: TLabel [3]
    Left = 8
    Top = 322
    Width = 97
    Height = 13
    Caption = 'Subscribe to a team:'
  end
  object lblInfo: TMemo [4]
    Left = 8
    Top = 8
    Width = 369
    Height = 33
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      
        'View team information by selecting teams. You can subscribe or r' +
        'emove '
      'yourself from all teams except PCMM teams here:')
    ReadOnly = True
    TabOrder = 9
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 377
    Width = 384
    Height = 33
    HelpContext = 9090
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 8
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 384
      Height = 2
      Align = alTop
    end
    object btnClose: TButton
      Left = 301
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9998
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 0
    end
  end
  object lstPatients: TORListBox [6]
    Left = 198
    Top = 118
    Width = 175
    Height = 121
    HelpContext = 9091
    ItemHeight = 13
    ParentShowHint = False
    PopupMenu = mnuPopPatient
    ShowHint = True
    Sorted = True
    TabOrder = 6
    OnMouseDown = lstPatientsMouseDown
    Caption = 'Patients on selected teams'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object lstTeams: TORListBox [7]
    Left = 8
    Top = 141
    Width = 175
    Height = 145
    HelpContext = 9092
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 3
    OnClick = lstTeamsClick
    Caption = 'You are on these teams'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object lstUsers: TORListBox [8]
    Left = 198
    Top = 262
    Width = 175
    Height = 97
    HelpContext = 9093
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 7
    Caption = 'Team members'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
  end
  object btnRemove: TButton [9]
    Left = 8
    Top = 292
    Width = 175
    Height = 22
    HelpContext = 9094
    Caption = 'Remove yourself from this team'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnRemoveClick
  end
  object chkPersonal: TCheckBox [10]
    Left = 10
    Top = 40
    Width = 175
    Height = 17
    HelpContext = 9096
    Caption = 'Include personal lists'
    TabOrder = 0
    OnClick = chkPersonalClick
  end
  object chkRestrict: TCheckBox [11]
    Left = 200
    Top = 40
    Width = 185
    Height = 17
    HelpContext = 9097
    Caption = 'View only common members'
    Enabled = False
    TabOrder = 2
    Visible = False
    OnClick = chkRestrictClick
  end
  object cboSubscribe: TORComboBox [12]
    Left = 8
    Top = 338
    Width = 175
    Height = 21
    HelpContext = 9095
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Subscribe to a team'
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
    TabOrder = 5
    Text = ''
    OnClick = cboSubscribeClick
    OnKeyDown = cboSubscribeKeyDown
    OnMouseClick = cboSubscribeMouseClick
    CharsNeedMatch = 1
  end
  object chkPcmm: TCheckBox [13]
    Left = 10
    Top = 63
    Width = 175
    Height = 17
    HelpContext = 9096
    Caption = 'Include PCMM teams (View Only)'
    TabOrder = 1
    OnClick = chkPcmmClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 376
    Data = (
      (
        'Component = lblInfo'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = lstPatients'
        'Status = stsDefault')
      (
        'Component = lstTeams'
        'Status = stsDefault')
      (
        'Component = lstUsers'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = chkPersonal'
        'Status = stsDefault')
      (
        'Component = chkRestrict'
        'Status = stsDefault')
      (
        'Component = cboSubscribe'
        'Status = stsDefault')
      (
        'Component = frmOptionsTeams'
        'Status = stsDefault')
      (
        'Component = chkPcmm'
        'Status = stsDefault'))
  end
  object mnuPopPatient: TPopupMenu
    Left = 56
    Top = 376
    object mnuPatientID: TMenuItem
      Caption = 'Patient ID...'
      OnClick = mnuPatientIDClick
    end
  end
end
