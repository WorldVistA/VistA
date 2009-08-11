inherited frmARTAllergy: TfrmARTAllergy
  Tag = 1105
  Left = 339
  Top = 266
  Caption = 'Enter Allergy or Adverse Reaction'
  ClientHeight = 438
  ClientWidth = 553
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  ExplicitWidth = 561
  ExplicitHeight = 472
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
        object btnAgent: TSpeedButton
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
          OnClick = btnAgentClick
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
          Left = 7
          Top = 299
          Width = 502
          Height = 36
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
          TabOrder = 0
          OnClick = ckNoKnownAllergiesClick
        end
        object btnCurrent: TButton
          Left = 7
          Top = 24
          Width = 114
          Height = 21
          Caption = '&Active Allergies'
          TabOrder = 1
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
          TabOrder = 2
          OnClick = lstAllergyClick
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
          TabOrder = 4
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
          TabOrder = 5
          OnChange = ControlChange
          DateOnly = False
          RequireTime = False
        end
        object ckChartMarked: TCheckBox
          Left = 294
          Top = 307
          Width = 113
          Height = 17
          Caption = '&Marked On Chart'
          Checked = True
          State = cbChecked
          TabOrder = 18
          Visible = False
          OnClick = ControlChange
        end
        object ckIDBand: TCheckBox
          Left = 122
          Top = 307
          Width = 97
          Height = 17
          Caption = '&ID Band Marked'
          TabOrder = 17
          OnClick = ControlChange
        end
        object cboSymptoms: TORComboBox
          Left = 7
          Top = 141
          Width = 135
          Height = 152
          Style = orcsSimple
          AutoSelect = True
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
          TabOrder = 11
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
          TabOrder = 12
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,4'
          OnChange = lstSelectedSymptomsChange
        end
        object btnDateTime: TButton
          Left = 154
          Top = 270
          Width = 62
          Height = 21
          Caption = '&Date/Time'
          TabOrder = 13
          OnClick = btnDateTimeClick
        end
        object btnRemove: TButton
          Left = 223
          Top = 270
          Width = 57
          Height = 21
          Caption = '&Remove'
          TabOrder = 14
          OnClick = btnRemoveClick
        end
        object grpObsHist: TRadioGroup
          Left = 362
          Top = 2
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
          TabOrder = 7
          OnClick = grpObsHistClick
        end
        object cboSeverity: TORComboBox
          Left = 362
          Top = 96
          Width = 127
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
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
          TabOrder = 9
          OnChange = ControlChange
          OnExit = ControlChange
          CharsNeedMatch = 1
        end
        object calObservedDate: TORDateBox
          Left = 362
          Top = 61
          Width = 145
          Height = 21
          TabOrder = 8
          OnChange = ControlChange
          DateOnly = False
          RequireTime = False
        end
        object cmdPrevObs: TButton
          Left = 202
          Top = 96
          Width = 140
          Height = 21
          Caption = 'View &Previous Observations'
          TabOrder = 6
          OnClick = cmdPrevObsClick
        end
        object memComments: TRichEdit
          Left = 294
          Top = 141
          Width = 213
          Height = 112
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 15
          OnExit = memCommentsExit
        end
        object cmdPrevCmts: TButton
          Left = 322
          Top = 270
          Width = 157
          Height = 21
          Caption = '&View Previous Comments'
          TabOrder = 16
          OnClick = cmdPrevCmtsClick
        end
        object cboNatureOfReaction: TORComboBox
          Left = 7
          Top = 96
          Width = 190
          Height = 21
          Style = orcsDropDown
          AutoSelect = True
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
          TabOrder = 3
          OnChange = ControlChange
          CharsNeedMatch = 1
        end
        object btnSevHelp: TORAlignButton
          Left = 489
          Top = 96
          Width = 21
          Height = 21
          Caption = '&?'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
          OnClick = btnSevHelpClick
        end
      end
      object tabVerify: TTabSheet
        Caption = 'Verify'
        ImageIndex = 3
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
        end
      end
      object tabEnteredInError: TTabSheet
        Caption = 'Entered In Error'
        ImageIndex = 2
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
          Width = 521
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
          ExplicitWidth = 83
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnExit = memCommentsExit
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
      Visible = False
      OnChange = ControlChange
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
        'Status = stsDefault')
      (
        'Component = cboOriginator'
        'Status = stsDefault')
      (
        'Component = calOriginated'
        'Status = stsDefault')
      (
        'Component = ckChartMarked'
        'Status = stsDefault')
      (
        'Component = ckIDBand'
        'Status = stsDefault')
      (
        'Component = cboSymptoms'
        'Status = stsDefault')
      (
        'Component = lstSelectedSymptoms'
        'Status = stsDefault')
      (
        'Component = btnDateTime'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = grpObsHist'
        'Status = stsDefault')
      (
        'Component = cboSeverity'
        'Status = stsDefault')
      (
        'Component = calObservedDate'
        'Status = stsDefault')
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
        'Status = stsDefault')
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
        'Status = stsDefault')
      (
        'Component = tabEnteredInError'
        'Status = stsDefault')
      (
        'Component = ckEnteredInError'
        'Status = stsDefault')
      (
        'Component = memErrCmts'
        'Status = stsDefault')
      (
        'Component = cboAllergyType'
        'Status = stsDefault')
      (
        'Component = frmARTAllergy'
        'Status = stsDefault'))
  end
  object dlgReactionDateTime: TORDateTimeDlg
    FMDateTime = 2981202.000000000000000000
    DateOnly = False
    RequireTime = False
    Left = 5
    Top = 400
  end
end
