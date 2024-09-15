inherited frmOptionsTeams: TfrmOptionsTeams
  Left = 730
  Top = 96
  HelpContext = 9090
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Team Information'
  ClientHeight = 445
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 480
  ExplicitHeight = 470
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel [0]
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 468
    Height = 11
    Align = alTop
    Shape = bsTopLine
    ExplicitLeft = 0
    ExplicitTop = 126
    ExplicitWidth = 474
  end
  object lblInfo: TMemo [1]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 468
    Height = 35
    TabStop = False
    Align = alTop
    Alignment = taCenter
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      
        'View team information by selecting teams. You can subscribe or r' +
        'emove '
      'yourself from all teams except PCMM teams here:')
    ReadOnly = True
    TabOrder = 4
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 413
    Width = 474
    Height = 32
    HelpContext = 9090
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    ExplicitTop = 378
    ExplicitWidth = 395
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 474
      Height = 2
      Align = alTop
      ExplicitWidth = 384
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 396
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9998
      Align = alRight
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 301
      ExplicitTop = 8
      ExplicitHeight = 22
    end
  end
  object chkPersonal: TCheckBox [3]
    AlignWithMargins = True
    Left = 3
    Top = 84
    Width = 468
    Height = 17
    HelpContext = 9096
    Align = alTop
    Caption = 'Include personal lists'
    TabOrder = 0
    OnClick = chkPersonalClick
    ExplicitLeft = 10
    ExplicitTop = 40
    ExplicitWidth = 175
  end
  object chkRestrict: TCheckBox [4]
    AlignWithMargins = True
    Left = 3
    Top = 61
    Width = 468
    Height = 17
    HelpContext = 9097
    Align = alTop
    Caption = 'View only common members'
    Enabled = False
    TabOrder = 2
    Visible = False
    OnClick = chkRestrictClick
    ExplicitLeft = 200
    ExplicitTop = 40
    ExplicitWidth = 185
  end
  object chkPcmm: TCheckBox [5]
    AlignWithMargins = True
    Left = 3
    Top = 107
    Width = 468
    Height = 17
    HelpContext = 9096
    Align = alTop
    Caption = 'Include PCMM teams (View Only)'
    TabOrder = 1
    OnClick = chkPcmmClick
    ExplicitLeft = 10
    ExplicitTop = 63
    ExplicitWidth = 175
  end
  object Panel1: TPanel [6]
    Left = 0
    Top = 127
    Width = 474
    Height = 286
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 8
    ExplicitTop = 392
    ExplicitHeight = 191
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 209
      Height = 286
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      ExplicitHeight = 191
      object lblTeams: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 203
        Height = 16
        Align = alTop
        Caption = 'You are on these teams:'
        ExplicitLeft = 8
        ExplicitTop = 125
        ExplicitWidth = 144
      end
      object lblSubscribe: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 237
        Width = 203
        Height = 16
        Align = alBottom
        Caption = 'Subscribe to a team:'
        ExplicitLeft = 8
        ExplicitTop = 322
        ExplicitWidth = 122
      end
      object cboSubscribe: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 259
        Width = 203
        Height = 24
        HelpContext = 9095
        Style = orcsDropDown
        Align = alBottom
        AutoSelect = True
        Caption = 'Subscribe to a team'
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
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnClick = cboSubscribeClick
        OnKeyDown = cboSubscribeKeyDown
        OnMouseClick = cboSubscribeMouseClick
        CharsNeedMatch = 1
        ExplicitTop = 608
        ExplicitWidth = 468
      end
      object btnRemove: TButton
        AlignWithMargins = True
        Left = 3
        Top = 209
        Width = 203
        Height = 22
        HelpContext = 9094
        Align = alBottom
        Caption = 'Remove yourself from this team'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnRemoveClick
        ExplicitLeft = 8
        ExplicitTop = 169
        ExplicitWidth = 175
      end
      object lstTeams: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 203
        Height = 178
        HelpContext = 9092
        Align = alClient
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 2
        OnClick = lstTeamsClick
        Caption = 'You are on these teams'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        ExplicitLeft = 8
        ExplicitTop = 46
        ExplicitWidth = 175
        ExplicitHeight = 145
      end
    end
    object Panel3: TPanel
      Left = 209
      Top = 0
      Width = 265
      Height = 286
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      ExplicitLeft = 144
      ExplicitTop = 72
      ExplicitWidth = 185
      ExplicitHeight = 41
      object lblPatients: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 259
        Height = 16
        Align = alTop
        Caption = 'Patients on selected teams:'
        ExplicitLeft = 101
        ExplicitTop = 141
        ExplicitWidth = 164
      end
      object lblTeamMembers: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 108
        Width = 259
        Height = 16
        Align = alTop
        Caption = 'Team members:'
        ExplicitLeft = 166
        ExplicitTop = 175
        ExplicitWidth = 99
      end
      object lstUsers: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 130
        Width = 259
        Height = 153
        HelpContext = 9093
        Align = alClient
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 0
        Caption = 'Team members'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        ExplicitTop = 72
        ExplicitHeight = 50
      end
      object lstPatients: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 259
        Height = 77
        HelpContext = 9091
        Align = alTop
        ParentShowHint = False
        PopupMenu = mnuPopPatient
        ShowHint = True
        Sorted = True
        TabOrder = 1
        OnMouseDown = lstPatientsMouseDown
        Caption = 'Patients on selected teams'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        ExplicitLeft = 90
        ExplicitTop = 114
        ExplicitWidth = 175
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 176
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
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault'))
  end
  object mnuPopPatient: TPopupMenu
    Left = 96
    Top = 176
    object mnuPatientID: TMenuItem
      Caption = 'Patient ID...'
      OnClick = mnuPatientIDClick
    end
  end
end
