inherited frmLabTestGroups: TfrmLabTestGroups
  Left = 337
  Top = 202
  Caption = 'Select Lab Tests'
  ClientHeight = 434
  ClientWidth = 457
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 473
  ExplicitHeight = 472
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLabTestGroups: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 457
    Height = 434
    Align = alClient
    TabOrder = 0
    object bvlTestGroups: TBevel
      Left = 1
      Top = 1
      Width = 455
      Height = 120
      Align = alTop
    end
    object lblTests: TLabel
      Left = 10
      Top = 124
      Width = 79
      Height = 13
      Caption = 'Laboratory Tests'
    end
    object lblList: TLabel
      Left = 284
      Top = 144
      Width = 100
      Height = 13
      Caption = 'Tests to be displayed'
    end
    object lblSpecimen: TLabel
      Left = 12
      Top = 383
      Width = 47
      Height = 13
      Caption = 'Specimen'
    end
    object lblTestGroups: TLabel
      Left = 10
      Top = 38
      Width = 58
      Height = 13
      Caption = 'Test Groups'
    end
    object lblUsers: TLabel
      Left = 164
      Top = 4
      Width = 159
      Height = 13
      Caption = 'Persons with defined Test Groups'
    end
    object lblOrder: TLabel
      Left = 182
      Top = 304
      Width = 40
      Height = 52
      Caption = 'Arrange order of tests for display.'
      WordWrap = True
    end
    object lblTestGroup: TLabel
      Left = 181
      Top = 198
      Width = 91
      Height = 39
      Caption = 'To create a New Test Group, limit selection to 7 tests.'
      WordWrap = True
    end
    object lblDefine: TVA508StaticText
      Name = 'lblDefine'
      Left = 352
      Top = 8
      Width = 94
      Height = 15
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 'Define Test Groups'
      TabOrder = 12
      ShowAccelChar = True
    end
    object pnlUpButton: TKeyClickPanel
      Left = 235
      Top = 299
      Width = 29
      Height = 29
      BevelOuter = bvNone
      Constraints.MaxHeight = 29
      Constraints.MaxWidth = 29
      TabOrder = 7
      TabStop = True
      OnClick = cmdUpClick
      OnEnter = pnlUpButtonEnter
      OnExit = pnlUpButtonExit
      OnResize = pnlUpButtonResize
      object cmdUp: TSpeedButton
        Left = 1
        Top = 2
        Width = 25
        Height = 25
        Caption = '^'
        Enabled = False
        OnClick = cmdUpClick
      end
    end
    object pnlDownButton: TKeyClickPanel
      Left = 235
      Top = 331
      Width = 29
      Height = 29
      BevelOuter = bvNone
      Constraints.MaxHeight = 29
      Constraints.MaxWidth = 29
      TabOrder = 8
      TabStop = True
      OnClick = cmdDownClick
      OnEnter = pnlDownButtonEnter
      OnExit = pnlDownButtonExit
      OnResize = pnlDownButtonResize
      object cmdDown: TSpeedButton
        Left = 1
        Top = 2
        Width = 25
        Height = 25
        Caption = 'v'
        Enabled = False
        OnClick = cmdDownClick
      end
    end
    object cmdOK: TButton
      Left = 277
      Top = 398
      Width = 72
      Height = 21
      Caption = 'OK'
      TabOrder = 10
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 368
      Top = 398
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 11
    end
    object cmdClear: TButton
      Left = 189
      Top = 244
      Width = 72
      Height = 21
      Caption = 'Remove All'
      Enabled = False
      TabOrder = 4
      OnClick = cmdClearClick
    end
    object cmdRemove: TButton
      Left = 189
      Top = 268
      Width = 72
      Height = 21
      Caption = 'Remove One'
      Enabled = False
      TabOrder = 5
      OnClick = cmdRemoveClick
    end
    object lstList: TORListBox
      Left = 278
      Top = 163
      Width = 160
      Height = 211
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = lstListClick
      Caption = 'Tests to be displayed'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = lstListClick
    end
    object cboTests: TORComboBox
      Left = 10
      Top = 144
      Width = 160
      Height = 233
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Laboratory Tests'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      TabStop = True
      Text = ''
      OnChange = cboTestsChange
      OnDblClick = cmdAddTestClick
      OnEnter = cboTestsEnter
      OnExit = cboTestsExit
      OnNeedData = cboTestsNeedData
      CharsNeedMatch = 1
    end
    object cboUsers: TORComboBox
      Left = 164
      Top = 23
      Width = 165
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Persons with defined Test Groups'
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
      TabOrder = 13
      Text = ''
      OnClick = cboUsersClick
      OnNeedData = cboUsersNeedData
      CharsNeedMatch = 1
    end
    object lstTestGroups: TORListBox
      Left = 10
      Top = 56
      Width = 319
      Height = 57
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Caption = 'Test Groups'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = lstTestGroupsChange
    end
    object cmdReplace: TButton
      Left = 368
      Top = 60
      Width = 72
      Height = 21
      Caption = 'Replace'
      Enabled = False
      TabOrder = 16
      OnClick = cmdReplaceClick
    end
    object cboSpecimen: TORComboBox
      Left = 12
      Top = 402
      Width = 160
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Specimen'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnNeedData = cboSpecimenNeedData
      CharsNeedMatch = 1
    end
    object cmdDelete: TButton
      Left = 368
      Top = 88
      Width = 72
      Height = 21
      Caption = 'Delete'
      Enabled = False
      TabOrder = 17
      OnClick = cmdDeleteClick
    end
    object cmdAdd: TButton
      Left = 368
      Top = 32
      Width = 72
      Height = 21
      Caption = 'New'
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 15
      OnClick = cmdAddClick
    end
    object cmdAddTest: TButton
      Left = 189
      Top = 144
      Width = 72
      Height = 21
      Caption = 'Add'
      Enabled = False
      TabOrder = 2
      OnClick = cmdAddTestClick
    end
    object lbl508TstGrp: TVA508StaticText
      Name = 'lbl508TstGrp'
      Left = 173
      Top = 198
      Width = 8
      Height = 39
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Alignment = taLeftJustify
      Caption = ''
      Enabled = False
      TabOrder = 3
      Visible = False
      ShowAccelChar = True
    end
    object lbl508Order: TVA508StaticText
      Name = 'lbl508Order'
      Left = 173
      Top = 304
      Width = 8
      Height = 52
      Alignment = taLeftJustify
      Caption = ''
      Enabled = False
      TabOrder = 6
      Visible = False
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlLabTestGroups'
        'Status = stsDefault')
      (
        'Component = pnlUpButton'
        'Text = Display selected test earlier'
        'Status = stsOK')
      (
        'Component = pnlDownButton'
        'Text = Display selected test later'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdClear'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = lstList'
        'Status = stsDefault')
      (
        'Component = cboTests'
        'Status = stsDefault')
      (
        'Component = cboUsers'
        'Label = lblUsers'
        'Status = stsOK')
      (
        'Component = lstTestGroups'
        'Label = lblTestGroups'
        'Status = stsOK')
      (
        'Component = cmdReplace'
        'Text = Replace Test Group'
        'Status = stsOK')
      (
        'Component = cboSpecimen'
        'Status = stsDefault')
      (
        'Component = cmdDelete'
        'Text = Delete Test Group'
        'Status = stsOK')
      (
        'Component = cmdAdd'
        'Text = New Test Group'
        'Status = stsOK')
      (
        'Component = cmdAddTest'
        'Status = stsDefault')
      (
        'Component = frmLabTestGroups'
        'Status = stsDefault')
      (
        'Component = lblDefine'
        'Status = stsDefault')
      (
        'Component = lbl508TstGrp'
        'Text = To create a New Test Group, limit selection to 7 tests.'
        'Status = stsOK')
      (
        'Component = lbl508Order'
        'Text = Arrange order of tests for display.'
        'Status = stsOK'))
  end
end
