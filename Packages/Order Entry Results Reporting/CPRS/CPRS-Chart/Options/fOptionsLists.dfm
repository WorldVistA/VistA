inherited frmOptionsLists: TfrmOptionsLists
  Left = 354
  Top = 178
  HelpContext = 9070
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = 'Personal Lists'
  ClientHeight = 517
  ClientWidth = 570
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 586
  ExplicitHeight = 556
  TextHeight = 13
  object gpMain: TGridPanel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 564
    Height = 513
    Align = alTop
    BevelOuter = bvNone
    Caption = 'gpMain'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 96.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = radAddByType
        Row = 0
      end
      item
        Column = 1
        Control = Panel1
        Row = 0
      end
      item
        Column = 2
        Control = lblInfo
        Row = 0
      end
      item
        Column = 0
        Control = Panel2
        Row = 1
      end
      item
        Column = 1
        Control = Panel3
        Row = 1
      end
      item
        Column = 2
        Control = Panel4
        Row = 1
      end
      item
        Column = 0
        Control = Panel5
        Row = 2
      end
      item
        Column = 1
        Control = Panel6
        Row = 2
      end
      item
        Column = 2
        Control = Panel7
        Row = 2
      end
      item
        Column = 1
        Control = Panel8
        Row = 3
      end
      item
        Column = 2
        Control = Panel9
        Row = 3
      end
      item
        Column = 0
        Control = Panel10
        Row = 3
      end>
    RowCollection = <
      item
        Value = 20.453161272016620000
      end
      item
        Value = 33.871013694275750000
      end
      item
        Value = 33.871013694275750000
      end
      item
        Value = 11.804811339431860000
      end>
    ShowCaption = False
    TabOrder = 0
    object radAddByType: TRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 228
      Height = 99
      HelpContext = 9071
      Align = alClient
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
    object Panel1: TPanel
      Left = 234
      Top = 0
      Width = 96
      Height = 105
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 1
    end
    object lblInfo: TMemo
      AlignWithMargins = True
      Left = 333
      Top = 3
      Width = 228
      Height = 99
      TabStop = False
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'You can change your personal lists '
        'by adding or removing patients.')
      ReadOnly = True
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 0
      Top = 105
      Width = 234
      Height = 174
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 3
      object lblAddBy: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 228
        Height = 13
        Align = alTop
        Caption = 'Provider:'
        ExplicitWidth = 42
      end
      object lstAddBy: TORCheckComboBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 228
        Height = 149
        HelpContext = 9072
        Style = orcsSimple
        Align = alClient
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
        TabOrder = 0
        Text = ''
        FlatCheckBoxes = False
        OnChange = lstAddByChange
        OnEnter = lstAddByEnter
        OnExit = lstAddByExit
        OnKeyDown = lstAddByKeyDown
        OnMouseClick = lstAddByMouseClick
        OnNeedData = lstAddByNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        MainCheckBoxCaption = 'Include Non-VA Providers'
        MainCheckBoxAlignment = calBottom
        OnMainCheckboxClick = lstAddByMainCheckboxClick
        DropdownStyle = ddsControl
        ExplicitLeft = 0
        ExplicitTop = 41
      end
    end
    object Panel3: TPanel
      Left = 234
      Top = 105
      Width = 96
      Height = 174
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 4
      object btnNewList: TButton
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 90
        Height = 22
        HelpContext = 9081
        Margins.Top = 22
        Align = alTop
        Caption = 'New List...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnNewListClick
      end
      object btnDeleteList: TButton
        AlignWithMargins = True
        Left = 3
        Top = 50
        Width = 90
        Height = 22
        HelpContext = 9082
        Align = alTop
        Caption = 'Delete List'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnDeleteListClick
      end
    end
    object Panel4: TPanel
      Left = 330
      Top = 105
      Width = 234
      Height = 174
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 5
      object lblPersonalLists: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 228
        Height = 13
        Align = alTop
        Caption = 'Personal Lists:'
        ExplicitWidth = 68
      end
      object lstPersonalLists: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 228
        Height = 149
        HelpContext = 9074
        Align = alClient
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 0
        Caption = 'Personal Lists:'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = lstPersonalListsChange
        FlatCheckBoxes = False
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 279
      Width = 234
      Height = 173
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 6
      object lblPatientsAdd: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 228
        Height = 13
        Align = alTop
        Caption = 'Patients to add:'
        ExplicitWidth = 74
      end
      object lstListPats: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 228
        Height = 148
        HelpContext = 9073
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        PopupMenu = mnuPopPatient
        ShowHint = True
        Sorted = True
        TabOrder = 0
        OnClick = lstListPatsChange
        OnDblClick = btnListAddClick
        OnMouseDown = lstListPatsMouseDown
        Caption = 'Patients to add:'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = lstListPatsChange
        FlatCheckBoxes = False
      end
    end
    object Panel6: TPanel
      Left = 234
      Top = 279
      Width = 96
      Height = 173
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 7
      object btnListAdd: TButton
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 90
        Height = 22
        HelpContext = 9076
        Margins.Top = 22
        Align = alTop
        Caption = 'Add'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnListAddClick
      end
      object btnListAddAll: TButton
        AlignWithMargins = True
        Left = 3
        Top = 50
        Width = 90
        Height = 22
        HelpContext = 9077
        Align = alTop
        Caption = 'Add All'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnListAddAllClick
      end
      object btnPersonalPatientR: TButton
        AlignWithMargins = True
        Left = 3
        Top = 78
        Width = 90
        Height = 22
        HelpContext = 9078
        Align = alTop
        Caption = 'Remove'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnPersonalPatientRClick
      end
      object btnPersonalPatientRA: TButton
        AlignWithMargins = True
        Left = 3
        Top = 106
        Width = 90
        Height = 22
        HelpContext = 9079
        Align = alTop
        Caption = 'Remove All'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnPersonalPatientRAClick
      end
      object btnListSaveChanges: TButton
        AlignWithMargins = True
        Left = 3
        Top = 134
        Width = 90
        Height = 22
        HelpContext = 9080
        Align = alTop
        Caption = 'Save Changes'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = btnListSaveChangesClick
      end
    end
    object Panel7: TPanel
      Left = 330
      Top = 279
      Width = 234
      Height = 173
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 8
      object lblPersonalPatientList: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 228
        Height = 13
        Align = alTop
        Caption = 'Patients on personal list:'
        ExplicitWidth = 114
      end
      object lstPersonalPatients: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 228
        Height = 148
        HelpContext = 9075
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        PopupMenu = mnuPopPatient
        ShowHint = True
        Sorted = True
        TabOrder = 0
        OnClick = lstPersonalPatientsChange
        OnDblClick = btnPersonalPatientRClick
        OnMouseDown = lstPersonalPatientsMouseDown
        Caption = 'Patients on personal list:'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = lstPersonalPatientsChange
        FlatCheckBoxes = False
      end
    end
    object Panel8: TPanel
      Left = 234
      Top = 452
      Width = 96
      Height = 61
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 9
      object btnSaveSchanges: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 90
        Height = 55
        HelpContext = 9080
        Align = alClient
        Caption = 'Save Changes'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnClick = btnListSaveChangesClick
      end
    end
    object Panel9: TPanel
      Left = 330
      Top = 452
      Width = 234
      Height = 61
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 10
      object pnlBottom: TPanel
        Left = 0
        Top = 32
        Width = 234
        Height = 29
        HelpContext = 9070
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object btnOK: TButton
          AlignWithMargins = True
          Left = 75
          Top = 3
          Width = 75
          Height = 23
          HelpContext = 9996
          Align = alRight
          Caption = 'OK'
          ModalResult = 1
          TabOrder = 0
          OnClick = btnOKClick
        end
        object btnCancel: TButton
          AlignWithMargins = True
          Left = 156
          Top = 3
          Width = 75
          Height = 23
          HelpContext = 9997
          Align = alRight
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 1
        end
      end
    end
    object Panel10: TPanel
      Left = 0
      Top = 452
      Width = 234
      Height = 61
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 11
      object grpVisibility: TRadioGroup
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 228
        Height = 55
        Align = alClient
        Caption = 'Who should be able to use the selected  list?'
        Columns = 2
        ItemIndex = 1
        Items.Strings = (
          '&Myself only'
          'All CP&RS users')
        TabOrder = 0
        OnClick = grpVisibilityClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 273
    Top = 16
    Data = (
      (
        'Component = frmOptionsLists'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = radAddByType'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lblInfo'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = lstAddBy'
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
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = lstListPats'
        'Status = stsDefault')
      (
        'Component = btnListAdd'
        'Status = stsDefault')
      (
        'Component = btnListAddAll'
        'Status = stsDefault')
      (
        'Component = btnPersonalPatientR'
        'Status = stsDefault')
      (
        'Component = btnPersonalPatientRA'
        'Status = stsDefault')
      (
        'Component = btnListSaveChanges'
        'Status = stsDefault')
      (
        'Component = lstPersonalPatients'
        'Status = stsDefault')
      (
        'Component = grpVisibility'
        'Status = stsDefault')
      (
        'Component = btnSaveSchanges'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault'))
  end
  object mnuPopPatient: TPopupMenu
    Left = 265
    Top = 200
    object mnuPatientID: TMenuItem
      Caption = 'Patient ID...'
      OnClick = mnuPatientIDClick
    end
  end
end
