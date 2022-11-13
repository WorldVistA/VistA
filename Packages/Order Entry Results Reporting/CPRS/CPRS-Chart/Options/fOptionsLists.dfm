inherited frmOptionsLists: TfrmOptionsLists
  Left = 354
  Top = 178
  HelpContext = 9070
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Personal Lists'
  ClientHeight = 468
  ClientWidth = 474
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ExplicitWidth = 480
  ExplicitHeight = 497
  PixelsPerInch = 96
  TextHeight = 13
  object lblAddBy: TLabel [0]
    Left = 8
    Top = 126
    Width = 42
    Height = 13
    Caption = 'Provider:'
  end
  object lblPatientsAdd: TLabel [1]
    Left = 8
    Top = 229
    Width = 74
    Height = 13
    Caption = 'Patients to add:'
  end
  object lblPersonalPatientList: TLabel [2]
    Left = 249
    Top = 229
    Width = 114
    Height = 13
    Caption = 'Patients on personal list:'
  end
  object lblPersonalLists: TLabel [3]
    Left = 249
    Top = 126
    Width = 68
    Height = 13
    Caption = 'Personal Lists:'
  end
  object lblInfo: TMemo [4]
    Left = 249
    Top = 16
    Width = 221
    Height = 104
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'You can change your personal lists '
      'by adding or removing patients.')
    ReadOnly = True
    TabOrder = 14
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 436
    Width = 474
    Height = 32
    HelpContext = 9070
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 13
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 474
      Height = 2
      Align = alTop
      ExplicitWidth = 407
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 315
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 396
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 118
      Height = 24
      HelpContext = 9080
      Align = alLeft
      Caption = 'Save Changes'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = btnListSaveChangesClick
    end
  end
  object lstAddBy: TORComboBox [6]
    Left = 8
    Top = 141
    Width = 153
    Height = 81
    HelpContext = 9072
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Provider:'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    OnChange = lstAddByChange
    OnEnter = lstAddByEnter
    OnExit = lstAddByExit
    OnKeyDown = lstAddByKeyDown
    OnMouseClick = lstAddByMouseClick
    OnNeedData = lstAddByNeedData
    CharsNeedMatch = 1
    UniqueAutoComplete = True
  end
  object btnPersonalPatientRA: TButton [7]
    Left = 167
    Top = 325
    Width = 75
    Height = 22
    HelpContext = 9079
    Caption = 'Remove All'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btnPersonalPatientRAClick
  end
  object btnPersonalPatientR: TButton [8]
    Left = 167
    Top = 300
    Width = 75
    Height = 22
    HelpContext = 9078
    Caption = 'Remove'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btnPersonalPatientRClick
  end
  object lstListPats: TORListBox [9]
    Left = 8
    Top = 244
    Width = 153
    Height = 134
    HelpContext = 9073
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    PopupMenu = mnuPopPatient
    ShowHint = True
    Sorted = True
    TabOrder = 5
    OnClick = lstListPatsChange
    OnDblClick = btnListAddClick
    OnMouseDown = lstListPatsMouseDown
    Caption = 'Patients to add:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    OnChange = lstListPatsChange
  end
  object lstPersonalPatients: TORListBox [10]
    Left = 249
    Top = 244
    Width = 217
    Height = 134
    HelpContext = 9075
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    MultiSelect = True
    ParentShowHint = False
    PopupMenu = mnuPopPatient
    ShowHint = True
    Sorted = True
    TabOrder = 11
    OnClick = lstPersonalPatientsChange
    OnDblClick = btnPersonalPatientRClick
    OnMouseDown = lstPersonalPatientsMouseDown
    Caption = 'Patients on personal list:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    OnChange = lstPersonalPatientsChange
  end
  object btnListAddAll: TButton [11]
    Left = 167
    Top = 270
    Width = 75
    Height = 22
    HelpContext = 9077
    Caption = 'Add All'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btnListAddAllClick
  end
  object btnNewList: TButton [12]
    Left = 167
    Top = 142
    Width = 75
    Height = 22
    HelpContext = 9081
    Caption = 'New List...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnNewListClick
  end
  object btnDeleteList: TButton [13]
    Left = 166
    Top = 200
    Width = 75
    Height = 22
    HelpContext = 9082
    Caption = 'Delete List'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnDeleteListClick
  end
  object lstPersonalLists: TORListBox [14]
    Left = 249
    Top = 141
    Width = 217
    Height = 81
    HelpContext = 9074
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 4
    Caption = 'Personal Lists:'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2'
    OnChange = lstPersonalListsChange
  end
  object radAddByType: TRadioGroup [15]
    Left = 7
    Top = 8
    Width = 234
    Height = 112
    HelpContext = 9071
    Caption = 'Select patients by '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'P&atient'
      '&Ward'
      '&Clinic'
      '&Provider'
      '&Specialty'
      '&List'
      'PCMM &Team')
    TabOrder = 0
    OnClick = radAddByTypeClick
  end
  object btnListSaveChanges: TButton [16]
    Left = 167
    Top = 357
    Width = 75
    Height = 22
    HelpContext = 9080
    Caption = 'Save Changes'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    OnClick = btnListSaveChangesClick
  end
  object btnListAdd: TButton [17]
    Left = 167
    Top = 245
    Width = 75
    Height = 22
    HelpContext = 9076
    Caption = 'Add'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnListAddClick
  end
  object grpVisibility: TRadioGroup [18]
    Left = 8
    Top = 384
    Width = 458
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Who should be able to see and use the selected  list?'
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      '&Myself only'
      '&All CPRS users')
    TabOrder = 12
    OnClick = grpVisibilityClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 280
    Data = (
      (
        'Component = lblInfo'
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
        'Component = lstAddBy'
        'Text = To select a provider use the arrow keys, then press enter'
        'Status = stsOK')
      (
        'Component = btnPersonalPatientRA'
        'Status = stsDefault')
      (
        'Component = btnPersonalPatientR'
        'Status = stsDefault')
      (
        'Component = lstListPats'
        'Status = stsDefault')
      (
        'Component = lstPersonalPatients'
        'Status = stsDefault')
      (
        'Component = btnListAddAll'
        'Status = stsDefault')
      (
        'Component = btnNewList'
        'Status = stsDefault')
      (
        'Component = btnDeleteList'
        'Status = stsDefault')
      (
        'Component = lstPersonalLists'
        'Status = stsDefault')
      (
        'Component = radAddByType'
        'Status = stsDefault')
      (
        'Component = btnListSaveChanges'
        'Status = stsDefault')
      (
        'Component = btnListAdd'
        'Status = stsDefault')
      (
        'Component = grpVisibility'
        'Status = stsDefault')
      (
        'Component = frmOptionsLists'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault'))
  end
  object mnuPopPatient: TPopupMenu
    Left = 336
    Top = 272
    object mnuPatientID: TMenuItem
      Caption = 'Patient ID...'
      OnClick = mnuPatientIDClick
    end
  end
end
