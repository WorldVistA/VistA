inherited frmARTAllergy: TfrmARTAllergy
  Tag = 1105
  Left = 465
  Top = 191
  Caption = 'Enter Allergy or Adverse Reaction'
  ClientHeight = 540
  ClientWidth = 597
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 613
  ExplicitHeight = 579
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 597
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pgAllergy: TPageControl
      Left = 0
      Top = 0
      Width = 597
      Height = 506
      ActivePage = tabGeneral
      Align = alClient
      DoubleBuffered = False
      MultiLine = True
      ParentDoubleBuffered = False
      TabOrder = 0
      object tabGeneral: TTabSheet
        Caption = 'General'
        object gpMain: TGridPanel
          Left = 0
          Top = 0
          Width = 589
          Height = 478
          Align = alClient
          ColumnCollection = <
            item
              Value = 22.000000000000000000
            end
            item
              Value = 11.000000000000000000
            end
            item
              Value = 22.000000000000000000
            end
            item
              Value = 12.000000000000000000
            end
            item
              Value = 16.500000000000000000
            end
            item
              Value = 16.500000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              ColumnSpan = 2
              Control = pnlActiveAllergies
              Row = 0
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = pnlOriginator
              Row = 0
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = grpObsHist
              Row = 0
              RowSpan = 2
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = btnCurrent
              Row = 1
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = cboOriginator
              Row = 1
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = lblAgent
              Row = 2
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = pnlOriginationDate
              Row = 2
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = lblObservedDate
              Row = 2
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = pnlAgentButtons
              Row = 3
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = calOriginated
              Row = 3
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = calObservedDate
              Row = 3
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = lblNatureOfReaction
              Row = 4
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = Label1
              Row = 4
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = lblSeverity
              Row = 4
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = cboNatureOfReaction
              Row = 5
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = cmdPrevObs
              Row = 5
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = pnlSeverity
              Row = 5
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = lblSymptoms
              Row = 6
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = lblSelectedSymptoms
              Row = 6
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = lblComments
              Row = 6
            end
            item
              Column = 0
              ColumnSpan = 2
              Control = cboSymptoms
              Row = 7
              RowSpan = 3
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = lstSelectedSymptoms
              Row = 7
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = memComments
              Row = 7
              RowSpan = 2
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = SymptomDateBox
              Row = 8
            end
            item
              Column = 2
              ColumnSpan = 2
              Control = btnRemove
              Row = 9
            end
            item
              Column = 4
              ColumnSpan = 2
              Control = cmdPrevCmts
              Row = 9
            end
            item
              Column = 1
              ColumnSpan = 2
              Control = ckIDBand
              Row = 10
            end
            item
              Column = 3
              ColumnSpan = 2
              Control = ckChartMarked
              Row = 10
            end>
          ParentBackground = False
          RowCollection = <
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 30.000000000000000000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end
            item
              Value = 7.000000000000001000
            end>
          TabOrder = 0
          object pnlActiveAllergies: TPanel
            Left = 1
            Top = 1
            Width = 193
            Height = 33
            Align = alClient
            BevelOuter = bvNone
            Ctl3D = False
            ParentCtl3D = False
            TabOrder = 0
            object ckNoKnownAllergies: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 187
              Height = 27
              Align = alClient
              Caption = '&No Known Allergies'
              TabOrder = 1
              OnClick = ckNoKnownAllergiesClick
            end
            object NoAllergylbl508: TVA508StaticText
              Name = 'NoAllergylbl508'
              Left = 10
              Top = 8
              Width = 5
              Height = 15
              Alignment = taLeftJustify
              Caption = ''
              Enabled = False
              TabOrder = 0
              TabStop = True
              Visible = False
              ShowAccelChar = True
            end
          end
          object pnlOriginator: TPanel
            Left = 194
            Top = 1
            Width = 199
            Height = 33
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 4
            DesignSize = (
              199
              33)
            object lblOriginator: TOROffsetLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 193
              Height = 27
              Align = alClient
              Caption = 'Originator:'
              HorzOffset = 2
              Transparent = False
              VertOffset = 2
              WordWrap = False
              ExplicitWidth = 186
              ExplicitHeight = 17
            end
            object origlbl508: TVA508StaticText
              Name = 'origlbl508'
              Left = 138
              Top = 3
              Width = 47
              Height = 15
              Alignment = taLeftJustify
              Anchors = [akTop, akRight]
              Caption = 'Originator'
              Enabled = False
              TabOrder = 0
              ShowAccelChar = True
            end
          end
          object grpObsHist: TRadioGroup
            AlignWithMargins = True
            Left = 396
            Top = 4
            Width = 189
            Height = 60
            Align = alClient
            Columns = 2
            Ctl3D = True
            Items.Strings = (
              'O&bserved'
              '&Historical')
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
            TabStop = True
            OnClick = grpObsHistClick
            OnEnter = grpObsHistEnter
          end
          object btnCurrent: TButton
            AlignWithMargins = True
            Left = 4
            Top = 37
            Width = 187
            Height = 27
            Align = alClient
            Caption = '&Active Allergies'
            TabOrder = 1
            OnClick = btnCurrentClick
          end
          object cboOriginator: TORComboBox
            AlignWithMargins = True
            Left = 197
            Top = 37
            Width = 193
            Height = 21
            Style = orcsDropDown
            Align = alClient
            AutoSelect = True
            Caption = ''
            Color = clBtnFace
            DropDownCount = 8
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clInactiveCaption
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = False
            LookupPiece = 2
            MaxLength = 0
            ParentFont = False
            ParentShowHint = False
            Pieces = '2,3'
            ShowHint = False
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 5
            TabStop = True
            Text = ''
            OnChange = ControlChange
            CharsNeedMatch = 1
          end
          object lblAgent: TOROffsetLabel
            AlignWithMargins = True
            Left = 4
            Top = 70
            Width = 187
            Height = 27
            Align = alClient
            Caption = 'Causative agent:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 7
            ExplicitTop = 27
            ExplicitWidth = 82
            ExplicitHeight = 15
          end
          object pnlOriginationDate: TPanel
            Left = 194
            Top = 67
            Width = 199
            Height = 33
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 6
            DesignSize = (
              199
              33)
            object lblOriginateDate: TOROffsetLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 193
              Height = 27
              Align = alClient
              Caption = 'Origination Date:'
              HorzOffset = 2
              Transparent = False
              VertOffset = 2
              WordWrap = False
              ExplicitLeft = 75
              ExplicitTop = 27
              ExplicitWidth = 81
              ExplicitHeight = 15
            end
            object origdtlbl508: TVA508StaticText
              Name = 'origdtlbl508'
              AlignWithMargins = True
              Left = 142
              Top = 0
              Width = 28
              Height = 15
              Alignment = taLeftJustify
              Anchors = [akTop, akRight]
              Caption = 'origdt'
              Enabled = False
              TabOrder = 0
              ShowAccelChar = True
            end
          end
          object lblObservedDate: TOROffsetLabel
            AlignWithMargins = True
            Left = 396
            Top = 70
            Width = 189
            Height = 27
            Align = alClient
            Caption = 'Reaction Date/Time:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 62
            ExplicitTop = 27
            ExplicitWidth = 102
            ExplicitHeight = 15
          end
          object pnlAgentButtons: TPanel
            Left = 1
            Top = 100
            Width = 193
            Height = 33
            Align = alClient
            Anchors = []
            BevelOuter = bvNone
            TabOrder = 2
            object btnAgent: TButton
              AlignWithMargins = True
              Left = 162
              Top = 3
              Width = 28
              Height = 27
              Align = alRight
              Caption = '...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 1
              OnClick = btnAgent1Click
            end
            object lstAllergy: TORListBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 153
              Height = 27
              Align = alClient
              Color = clBtnFace
              Ctl3D = True
              ExtendedSelect = False
              ItemHeight = 13
              ParentCtl3D = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = lstAllergyClick
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = ControlChange
            end
          end
          object calOriginated: TORDateBox
            AlignWithMargins = True
            Left = 197
            Top = 103
            Width = 193
            Height = 27
            Align = alClient
            Color = clBtnFace
            Enabled = False
            TabOrder = 7
            OnChange = ControlChange
            DateOnly = False
            RequireTime = False
            Caption = ''
            ExplicitHeight = 21
          end
          object calObservedDate: TORDateBox
            AlignWithMargins = True
            Left = 396
            Top = 103
            Width = 189
            Height = 27
            Align = alClient
            TabOrder = 10
            OnChange = ControlChange
            OnExit = calObservedDateExit
            DateOnly = False
            RequireTime = False
            Caption = ''
            ExplicitHeight = 21
          end
          object lblNatureOfReaction: TOROffsetLabel
            AlignWithMargins = True
            Left = 4
            Top = 136
            Width = 187
            Height = 30
            Margins.Bottom = 0
            Align = alClient
            Caption = 'Nature of Reaction:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 7
            ExplicitTop = 42
            ExplicitWidth = 95
            ExplicitHeight = 15
          end
          object Label1: TLabel
            Left = 194
            Top = 133
            Width = 199
            Height = 33
            Align = alClient
            Alignment = taCenter
            Caption = 'EMPTY SPACE'
            Layout = tlCenter
            Visible = False
            ExplicitWidth = 75
            ExplicitHeight = 13
          end
          object lblSeverity: TOROffsetLabel
            AlignWithMargins = True
            Left = 396
            Top = 136
            Width = 189
            Height = 27
            Align = alClient
            Caption = 'Severity:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 123
            ExplicitTop = 42
            ExplicitWidth = 43
            ExplicitHeight = 15
          end
          object cboNatureOfReaction: TORComboBox
            AlignWithMargins = True
            Left = 4
            Top = 169
            Width = 187
            Height = 21
            Style = orcsDropDown
            Align = alClient
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
            TabOrder = 3
            Text = ''
            OnChange = ControlChange
            CharsNeedMatch = 1
          end
          object cmdPrevObs: TButton
            AlignWithMargins = True
            Left = 197
            Top = 169
            Width = 193
            Height = 27
            Align = alClient
            Caption = 'View &Previous Observations'
            TabOrder = 8
            OnClick = cmdPrevObsClick
          end
          object pnlSeverity: TPanel
            Left = 393
            Top = 166
            Width = 195
            Height = 33
            Align = alClient
            Anchors = []
            BevelOuter = bvNone
            TabOrder = 11
            object cboSeverity: TORComboBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 158
              Height = 21
              Style = orcsDropDown
              Align = alClient
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
              TabOrder = 0
              Text = ''
              OnChange = ControlChange
              OnExit = ControlChange
              CharsNeedMatch = 1
            end
            object btnSevHelp: TORAlignButton
              AlignWithMargins = True
              Left = 167
              Top = 3
              Width = 25
              Height = 27
              Hint = 'Severity Help'
              Align = alRight
              Caption = '&?'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnSevHelpClick
            end
          end
          object lblSymptoms: TOROffsetLabel
            AlignWithMargins = True
            Left = 4
            Top = 202
            Width = 187
            Height = 30
            Margins.Bottom = 0
            Align = alClient
            Caption = 'Signs/Symptoms:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 7
            ExplicitTop = 127
            ExplicitWidth = 84
            ExplicitHeight = 15
          end
          object lblSelectedSymptoms: TOROffsetLabel
            AlignWithMargins = True
            Left = 197
            Top = 202
            Width = 193
            Height = 30
            Margins.Bottom = 0
            Align = alClient
            Caption = 'Selected Symptoms:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 3
            ExplicitTop = 0
            ExplicitWidth = 124
            ExplicitHeight = 15
          end
          object lblComments: TOROffsetLabel
            AlignWithMargins = True
            Left = 396
            Top = 202
            Width = 189
            Height = 30
            Margins.Bottom = 0
            Align = alClient
            Caption = 'Comments:'
            HorzOffset = 2
            Transparent = False
            VertOffset = 2
            WordWrap = False
            ExplicitLeft = 182
            ExplicitTop = 127
            ExplicitWidth = 54
            ExplicitHeight = 15
          end
          object cboSymptoms: TORComboBox
            AlignWithMargins = True
            Left = 4
            Top = 232
            Width = 187
            Height = 205
            Margins.Top = 0
            Style = orcsSimple
            Align = alClient
            AutoSelect = True
            Caption = 'Signs and Symptoms'
            Color = clWindow
            Ctl3D = True
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = True
            LookupPiece = 0
            MaxLength = 0
            ParentCtl3D = False
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 12
            Text = ''
            OnKeyDown = cboSymptomsKeyDown
            OnMouseClick = cboSymptomsMouseClick
            OnNeedData = cboSymptomsNeedData
            CharsNeedMatch = 1
          end
          object lstSelectedSymptoms: TORListBox
            AlignWithMargins = True
            Left = 197
            Top = 232
            Width = 193
            Height = 139
            Margins.Top = 0
            Align = alClient
            Anchors = []
            ExtendedSelect = False
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = True
            TabOrder = 13
            Caption = 'Selected Symptoms'
            ItemTipColor = clWindow
            LongList = False
            Pieces = '2,4'
            OnChange = lstSelectedSymptomsChange
          end
          object memComments: TRichEdit
            AlignWithMargins = True
            Left = 396
            Top = 232
            Width = 189
            Height = 172
            Hint = 'Comments'
            Margins.Top = 0
            Align = alClient
            Anchors = []
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 16
            Zoom = 100
            OnExit = memCommentsExit
          end
          object SymptomDateBox: TORDateBox
            AlignWithMargins = True
            Left = 197
            Top = 377
            Width = 193
            Height = 27
            Hint = 'Enter date/time for selected symptom '
            Align = alClient
            Enabled = False
            TabOrder = 14
            Text = 'NOW'
            OnExit = SymptomDateBoxExit
            DateOnly = False
            RequireTime = False
            Caption = ''
            ExplicitHeight = 21
          end
          object btnRemove: TButton
            AlignWithMargins = True
            Left = 197
            Top = 410
            Width = 193
            Height = 27
            Align = alClient
            Caption = '&Remove'
            Enabled = False
            TabOrder = 15
            TabStop = False
            OnClick = btnRemoveClick
          end
          object cmdPrevCmts: TButton
            AlignWithMargins = True
            Left = 396
            Top = 410
            Width = 189
            Height = 27
            Align = alClient
            Caption = '&View Previous Comments'
            TabOrder = 17
            OnClick = cmdPrevCmtsClick
          end
          object ckIDBand: TCheckBox
            Left = 130
            Top = 440
            Width = 193
            Height = 37
            Align = alClient
            Caption = '&ID Band Marked'
            TabOrder = 22
            OnClick = ControlChange
          end
          object ckChartMarked: TCheckBox
            Left = 323
            Top = 440
            Width = 166
            Height = 37
            Align = alClient
            Caption = '&Marked On Chart'
            Checked = True
            State = cbChecked
            TabOrder = 23
            Visible = False
            OnClick = ControlChange
          end
        end
      end
      object tabVerify: TTabSheet
        Caption = 'Verify'
        ImageIndex = 3
        object pnlVerify: TPanel
          Left = 0
          Top = 0
          Width = 589
          Height = 478
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlVerify'
          ParentBackground = False
          TabOrder = 0
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
      end
      object tabEnteredInError: TTabSheet
        Caption = 'Entered In Error'
        ImageIndex = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 589
          Height = 478
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          ParentBackground = False
          TabOrder = 0
          object lblEnteredInError: TLabel
            Left = 0
            Top = 465
            Width = 589
            Height = 13
            Align = alBottom
            Alignment = taCenter
            Caption = 'EnteredInError'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitWidth = 83
          end
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 589
            Height = 21
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object lblErrCmts: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 98
              Height = 15
              Align = alLeft
              Caption = 'Comments (optional):'
              ExplicitHeight = 13
            end
            object ckEnteredInError: TCheckBox
              AlignWithMargins = True
              Left = 383
              Top = 3
              Width = 203
              Height = 15
              Align = alRight
              Caption = '&Mark this allergy as "Entered In Error"'
              TabOrder = 0
              Visible = False
              OnClick = ControlChange
            end
          end
          object memErrCmts: TRichEdit
            AlignWithMargins = True
            Left = 3
            Top = 24
            Width = 583
            Height = 438
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 1
            Zoom = 100
            OnExit = memErrCmtsExit
          end
        end
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 506
      Width = 597
      Height = 34
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblAllergyType: TOROffsetLabel
        AlignWithMargins = True
        Left = 3
        Top = 6
        Width = 94
        Height = 25
        Margins.Top = 6
        Align = alLeft
        Caption = 'Allergy Type:'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        Visible = False
        WordWrap = False
      end
      object pnlButtons: TPanel
        Left = 428
        Top = 0
        Width = 169
        Height = 34
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object cmdOK: TButton
          AlignWithMargins = True
          Left = 16
          Top = 3
          Width = 72
          Height = 28
          Align = alRight
          Caption = '&OK'
          TabOrder = 0
          OnClick = cmdOKClick
        end
        object cmdCancel: TButton
          AlignWithMargins = True
          Left = 94
          Top = 3
          Width = 72
          Height = 28
          Align = alRight
          Cancel = True
          Caption = '&Cancel'
          TabOrder = 1
          OnClick = cmdCancelClick
        end
      end
      object cboAllergyType: TORComboBox
        AlignWithMargins = True
        Left = 103
        Top = 6
        Width = 190
        Height = 21
        Margins.Top = 6
        Style = orcsDropDown
        Align = alLeft
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
        TabOrder = 0
        Text = ''
        Visible = False
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 472
    Top = 200
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
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlSeverity'
        'Status = stsDefault')
      (
        'Component = pnlOriginationDate'
        'Status = stsDefault')
      (
        'Component = pnlAgentButtons'
        'Status = stsDefault')
      (
        'Component = pnlActiveAllergies'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = pnlVerify'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = pnlOriginator'
        'Status = stsDefault'))
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = memComments
    OnStateQuery = VA508ComponentAccessibility1StateQuery
    Left = 472
    Top = 280
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
    Left = 472
    Top = 328
  end
  object VA508ComponentAccessibility3: TVA508ComponentAccessibility
    Component = memErrCmts
    OnStateQuery = VA508ComponentAccessibility3StateQuery
    Left = 472
    Top = 240
  end
end
