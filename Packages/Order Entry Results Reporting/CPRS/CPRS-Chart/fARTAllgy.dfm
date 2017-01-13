inherited frmARTAllergy: TfrmARTAllergy
  Tag = 1105
  Left = 274
  Top = 150
  Caption = 'Enter Allergy or Adverse Reaction'
  ClientHeight = 438
  ClientWidth = 553
  FormStyle = fsStayOnTop
  Position = poDesigned
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  ExplicitWidth = 569
  ExplicitHeight = 476
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 553
    Height = 438
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblAllergyType: TOROffsetLabel
      Left = 38
      Top = 403
      Width = 63
      Height = 15
      Caption = 'Allergy Type:'
      HorzOffset = 2
      Transparent = False
      VertOffset = 2
      Visible = False
      WordWrap = False
    end
    object cmdOK: TButton
      Left = 380
      Top = 403
      Width = 72
      Height = 21
      Caption = '&OK'
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 459
      Top = 403
      Width = 72
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object pgAllergy: TPageControl
      Left = 4
      Top = 17
      Width = 529
      Height = 371
      ActivePage = tabGeneral
      MultiLine = True
      TabOrder = 0
      object tabGeneral: TTabSheet
        Caption = 'General'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lblAgent: TOROffsetLabel
          Left = 7
          Top = 44
          Width = 82
          Height = 15
          Caption = 'Causative agent:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object btnAgent1: TSpeedButton
          Left = 175
          Top = 62
          Width = 19
          Height = 19
          Caption = '...'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = btnAgent1Click
        end
        object lblOriginator: TOROffsetLabel
          Left = 202
          Top = 1
          Width = 50
          Height = 15
          Caption = 'Originator:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblOriginateDate: TOROffsetLabel
          Left = 202
          Top = 44
          Width = 81
          Height = 15
          Caption = 'Origination Date:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object Bevel1: TBevel
          Left = 3
          Top = 312
          Width = 502
          Height = 26
        end
        object lblSymptoms: TOROffsetLabel
          Left = 7
          Top = 127
          Width = 84
          Height = 15
          Caption = 'Signs/Symptoms:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblSelectedSymptoms: TOROffsetLabel
          Left = 147
          Top = 127
          Width = 98
          Height = 15
          Caption = 'Selected Symptoms:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblSeverity: TOROffsetLabel
          Left = 362
          Top = 81
          Width = 43
          Height = 15
          Caption = 'Severity:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblObservedDate: TOROffsetLabel
          Left = 362
          Top = 44
          Width = 102
          Height = 15
          Caption = 'Reaction Date/Time:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblComments: TOROffsetLabel
          Left = 295
          Top = 127
          Width = 54
          Height = 15
          Caption = 'Comments:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblNatureOfReaction: TOROffsetLabel
          Left = 7
          Top = 82
          Width = 95
          Height = 15
          Caption = 'Nature of Reaction:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object ckNoKnownAllergies: TCheckBox
          Left = 7
          Top = 3
          Width = 119
          Height = 17
          Caption = '&No Known Allergies'
          TabOrder = 1
          OnClick = ckNoKnownAllergiesClick
        end
        object btnCurrent: TButton
          Left = 7
          Top = 24
          Width = 114
          Height = 21
          Caption = '&Active Allergies'
          TabOrder = 2
          OnClick = btnCurrentClick
        end
        object lstAllergy: TORListBox
          Left = 7
          Top = 61
          Width = 166
          Height = 21
          Color = clBtnFace
          ExtendedSelect = False
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = lstAllergyClick
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
          OnChange = ControlChange
        end
        object cboOriginator: TORComboBox
          Left = 202
          Top = 16
          Width = 139
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
          Caption = ''
          Color = clBtnFace
          DropDownCount = 8
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInactiveCaption
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 2
          MaxLength = 0
          ParentFont = False
          ParentShowHint = False
          Pieces = '2,3'
          ShowHint = False
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 8
          TabStop = True
          Text = ''
          OnChange = ControlChange
          OnNeedData = cboOriginatorNeedData
          CharsNeedMatch = 1
        end
        object calOriginated: TORDateBox
          Left = 202
          Top = 61
          Width = 140
          Height = 21
          Color = clBtnFace
          Enabled = False
          TabOrder = 9
          OnChange = ControlChange
          DateOnly = False
          RequireTime = False
          Caption = ''
        end
        object ckChartMarked: TCheckBox
          Left = 294
          Top = 313
          Width = 113
          Height = 22
          Caption = '&Marked On Chart'
          Checked = True
          State = cbChecked
          TabOrder = 22
          Visible = False
          OnClick = ControlChange
        end
        object ckIDBand: TCheckBox
          Left = 122
          Top = 313
          Width = 97
          Height = 22
          Caption = '&ID Band Marked'
          TabOrder = 21
          OnClick = ControlChange
        end
        object cboSymptoms: TORComboBox
          Left = 7
          Top = 141
          Width = 135
          Height = 152
          Style = orcsSimple
          AutoSelect = True
          Caption = 'Signs and Symptoms'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 15
          Text = ''
          OnKeyDown = cboSymptomsKeyDown
          OnMouseClick = cboSymptomsMouseClick
          OnNeedData = cboSymptomsNeedData
          CharsNeedMatch = 1
        end
        object lstSelectedSymptoms: TORListBox
          Left = 147
          Top = 141
          Width = 136
          Height = 122
          ExtendedSelect = False
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 16
          Caption = 'Selected Symptoms'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,4'
          OnChange = lstSelectedSymptomsChange
        end
        object btnRemove: TButton
          Left = 148
          Top = 289
          Width = 132
          Height = 21
          Caption = '&Remove'
          Enabled = False
          TabOrder = 18
          TabStop = False
          OnClick = btnRemoveClick
        end
        object grpObsHist: TRadioGroup
          Left = 362
          Top = 0
          Width = 147
          Height = 38
          Columns = 2
          Ctl3D = True
          Items.Strings = (
            'O&bserved'
            '&Historical')
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          TabStop = True
          OnClick = grpObsHistClick
        end
        object cboSeverity: TORComboBox
          Left = 362
          Top = 96
          Width = 127
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Severity'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
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
          OnChange = ControlChange
          OnExit = ControlChange
          CharsNeedMatch = 1
        end
        object calObservedDate: TORDateBox
          Left = 362
          Top = 61
          Width = 145
          Height = 21
          TabOrder = 12
          OnChange = ControlChange
          OnExit = calObservedDateExit
          DateOnly = False
          RequireTime = False
          Caption = ''
        end
        object cmdPrevObs: TButton
          Left = 202
          Top = 96
          Width = 140
          Height = 21
          Caption = 'View &Previous Observations'
          TabOrder = 10
          OnClick = cmdPrevObsClick
        end
        object memComments: TRichEdit
          Left = 294
          Top = 141
          Width = 213
          Height = 112
          Hint = 'Comments'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 19
          OnExit = memCommentsExit
        end
        object cmdPrevCmts: TButton
          Left = 322
          Top = 270
          Width = 157
          Height = 21
          Caption = '&View Previous Comments'
          TabOrder = 20
          OnClick = cmdPrevCmtsClick
        end
        object cboNatureOfReaction: TORComboBox
          Left = 7
          Top = 96
          Width = 190
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Nature of Reaction'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
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
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
        object btnSevHelp: TORAlignButton
          Left = 488
          Top = 96
          Width = 21
          Height = 21
          Hint = 'Severity Help'
          Caption = '&?'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 14
          OnClick = btnSevHelpClick
        end
        object origlbl508: TVA508StaticText
          Name = 'origlbl508'
          Left = 294
          Top = -5
          Width = 47
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Originator'
          Enabled = False
          TabOrder = 6
          ShowAccelChar = True
        end
        object origdtlbl508: TVA508StaticText
          Name = 'origdtlbl508'
          Left = 295
          Top = 43
          Width = 28
          Height = 15
          Alignment = taLeftJustify
          Caption = 'origdt'
          Enabled = False
          TabOrder = 7
          ShowAccelChar = True
        end
        object SymptomDateBox: TORDateBox
          Left = 148
          Top = 265
          Width = 135
          Height = 21
          Hint = 'Enter date/time for selected symptom '
          Enabled = False
          TabOrder = 17
          Text = 'NOW'
          OnExit = SymptomDateBoxExit
          DateOnly = False
          RequireTime = False
          Caption = ''
        end
        object btnAgent: TButton
          Left = 175
          Top = 62
          Width = 19
          Height = 19
          Caption = '...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = btnAgent1Click
        end
        object NoAllergylbl508: TVA508StaticText
          Name = 'NoAllergylbl508'
          Left = 10
          Top = 8
          Width = 6
          Height = 6
          Alignment = taLeftJustify
          Caption = ''
          Enabled = False
          TabOrder = 0
          TabStop = True
          Visible = False
          ShowAccelChar = True
        end
      end
      object tabVerify: TTabSheet
        Caption = 'Verify'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lblVerifier: TOROffsetLabel
          Left = 99
          Top = 51
          Width = 55
          Height = 15
          Caption = 'Verified By:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object lblVerifyDate: TOROffsetLabel
          Left = 99
          Top = 108
          Width = 66
          Height = 15
          Caption = 'Date Verified:'
          HorzOffset = 2
          Transparent = False
          VertOffset = 2
          WordWrap = False
        end
        object ckVerified: TCheckBox
          Left = 99
          Top = 18
          Width = 69
          Height = 17
          Caption = '&Verified'
          TabOrder = 0
          OnClick = ControlChange
        end
        object cboVerifier: TORComboBox
          Left = 99
          Top = 65
          Width = 138
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Verified By'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = True
          LookupPiece = 2
          MaxLength = 0
          Pieces = '2,3'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          OnChange = ControlChange
          OnNeedData = cboVerifierNeedData
          CharsNeedMatch = 1
        end
        object calVerifyDate: TORDateBox
          Left = 99
          Top = 124
          Width = 137
          Height = 21
          TabOrder = 2
          OnChange = ControlChange
          DateOnly = False
          RequireTime = False
          Caption = 'Date Verified'
        end
      end
      object tabEnteredInError: TTabSheet
        Caption = 'Entered In Error'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lblErrCmts: TLabel
          Left = 7
          Top = 12
          Width = 98
          Height = 13
          Caption = 'Comments (optional):'
        end
        object lblEnteredInError: TLabel
          Left = 0
          Top = 330
          Width = 83
          Height = 13
          Align = alBottom
          Alignment = taCenter
          Caption = 'EnteredInError'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ckEnteredInError: TCheckBox
          Left = 286
          Top = 5
          Width = 203
          Height = 17
          Caption = '&Mark this allergy as "Entered In Error"'
          TabOrder = 0
          Visible = False
          OnClick = ControlChange
        end
        object memErrCmts: TRichEdit
          Left = 6
          Top = 27
          Width = 506
          Height = 263
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnExit = memErrCmtsExit
        end
      end
    end
    object cboAllergyType: TORComboBox
      Left = 38
      Top = 418
      Width = 190
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = ''
      Color = clBtnFace
      DropDownCount = 8
      Enabled = False
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 3
      Text = ''
      Visible = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 168
    Top = 56
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pgAllergy'
        'Status = stsDefault')
      (
        'Component = tabGeneral'
        'Status = stsDefault')
      (
        'Component = ckNoKnownAllergies'
        'Status = stsDefault')
      (
        'Component = btnCurrent'
        'Status = stsDefault')
      (
        'Component = lstAllergy'
        'Text = Causative Agent'
        'Status = stsOK')
      (
        'Component = cboOriginator'
        'Status = stsDefault')
      (
        'Component = calOriginated'
        'Text =  Origination Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = ckChartMarked'
        'Status = stsDefault')
      (
        'Component = ckIDBand'
        'Status = stsDefault')
      (
        'Component = cboSymptoms'
        
          'Text = Signs and Symptoms. Press enter to select the sign/sympto' +
          'm.'
        'Status = stsOK')
      (
        'Component = lstSelectedSymptoms'
        'Text = Selected Symptoms'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = grpObsHist'
        'Text = Observed or Historical Allergy Group Box'
        'Status = stsOK')
      (
        'Component = cboSeverity'
        'Status = stsDefault')
      (
        'Component = calObservedDate'
        'Text = Reaction Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdPrevObs'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = cmdPrevCmts'
        'Status = stsDefault')
      (
        'Component = cboNatureOfReaction'
        'Status = stsDefault')
      (
        'Component = btnSevHelp'
        'Text = Severity Help'
        'Status = stsOK')
      (
        'Component = tabVerify'
        'Status = stsDefault')
      (
        'Component = ckVerified'
        'Status = stsDefault')
      (
        'Component = cboVerifier'
        'Status = stsDefault')
      (
        'Component = calVerifyDate'
        'Text = Verify Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = tabEnteredInError'
        'Status = stsDefault')
      (
        'Component = ckEnteredInError'
        'Status = stsDefault')
      (
        'Component = memErrCmts'
        'Text = Comments (optional)'
        'Status = stsOK')
      (
        'Component = cboAllergyType'
        'Status = stsDefault')
      (
        'Component = frmARTAllergy'
        'Status = stsDefault')
      (
        'Component = origlbl508'
        'Status = stsDefault')
      (
        'Component = origdtlbl508'
        'Status = stsDefault')
      (
        'Component = SymptomDateBox'
        'Text = Symptom Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = btnAgent'
        'Text = Causative Agent Reselect'
        'Status = stsOK')
      (
        'Component = NoAllergylbl508'
        'Text = No Known Allergies checkbox disabled'
        'Status = stsOK'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memComments
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 408
    Top = 216
  end
  object VA508ComponentAccessibility2: TVA508ComponentAccessibility
    Component = lstAllergy
    OnComponentNameQuery = VA508ComponentAccessibility2ComponentNameQuery
    OnCaptionQuery = VA508ComponentAccessibility2CaptionQuery
    OnValueQuery = VA508ComponentAccessibility2ValueQuery
    OnStateQuery = VA508ComponentAccessibility2StateQuery
    OnInstructionsQuery = VA508ComponentAccessibility2InstructionsQuery
    OnItemInstructionsQuery = VA508ComponentAccessibility2ItemInstructionsQuery
    OnItemQuery = VA508ComponentAccessibility2ItemQuery
    Left = 104
    Top = 104
  end
  object VA508ComponentAccessibility3: TVA508ComponentAccessibility
    Component = memErrCmts
    OnStateQuery = VA508ComponentAccessibility3StateQuery
    Left = 264
    Top = 216
  end
end
