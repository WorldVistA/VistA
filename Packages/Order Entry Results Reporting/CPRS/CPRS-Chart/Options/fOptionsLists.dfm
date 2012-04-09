inherited frmOptionsLists: TfrmOptionsLists
  Left = 354
  Top = 178
  HelpContext = 9070
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Personal Lists'
  ClientHeight = 442
  ClientWidth = 407
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 413
  ExplicitHeight = 474
  PixelsPerInch = 96
  TextHeight = 13
  object lblAddby: TLabel [0]
    Left = 7
    Top = 97
    Width = 42
    Height = 13
    Caption = 'Provider:'
  end
  object lblPatientsAdd: TLabel [1]
    Left = 7
    Top = 200
    Width = 74
    Height = 13
    Caption = 'Patients to add:'
  end
  object lblPersonalPatientList: TLabel [2]
    Left = 248
    Top = 200
    Width = 114
    Height = 13
    Caption = 'Patients on personal list:'
  end
  object lblPersonalLists: TLabel [3]
    Left = 248
    Top = 97
    Width = 68
    Height = 13
    Caption = 'Personal Lists:'
  end
  object lblInfo: TMemo [4]
    Left = 199
    Top = 24
    Width = 186
    Height = 65
    TabStop = False
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      'You can change your personal lists by '
      'adding or removing patients.')
    ReadOnly = True
    TabOrder = 14
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 409
    Width = 407
    Height = 33
    HelpContext = 9070
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 13
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 407
      Height = 2
      Align = alTop
    end
    object btnOK: TButton
      Left = 245
      Top = 8
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
      Left = 325
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
  object lstAddBy: TORComboBox [6]
    Left = 7
    Top = 112
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
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    OnChange = lstAddByChange
    OnClick = lstAddByClick
    OnNeedData = lstAddByNeedData
    CharsNeedMatch = 1
  end
  object btnPersonalPatientRA: TButton [7]
    Left = 166
    Top = 296
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
    Left = 166
    Top = 271
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
    Left = 7
    Top = 215
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
    Left = 248
    Top = 215
    Width = 153
    Height = 134
    HelpContext = 9075
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
    Left = 166
    Top = 241
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
    Left = 166
    Top = 113
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
    Left = 165
    Top = 171
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
    Left = 248
    Top = 112
    Width = 153
    Height = 81
    HelpContext = 9074
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
    Width = 153
    Height = 86
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
      '&List')
    TabOrder = 0
    OnClick = radAddByTypeClick
  end
  object btnListSaveChanges: TButton [16]
    Left = 166
    Top = 328
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
    Left = 166
    Top = 216
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
    Top = 356
    Width = 391
    Height = 45
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
        'Status = stsDefault')
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
        'Status = stsDefault'))
  end
  object mnuPopPatient: TPopupMenu
    Left = 8
    Top = 408
    object mnuPatientID: TMenuItem
      Caption = 'Patient ID...'
      OnClick = mnuPatientIDClick
    end
  end
end
