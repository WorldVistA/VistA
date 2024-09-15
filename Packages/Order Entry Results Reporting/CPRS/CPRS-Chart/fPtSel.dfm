inherited frmPtSel: TfrmPtSel
  Left = 290
  Top = 232
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Selection'
  ClientHeight = 573
  ClientWidth = 868
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 884
  ExplicitHeight = 612
  TextHeight = 13
  object sptVert: TSplitter [0]
    Left = 0
    Top = 370
    Width = 868
    Height = 4
    Cursor = crVSplit
    Align = alTop
    OnCanResize = sptVertCanResize
    OnMoved = sptVertMoved
    ExplicitTop = 283
  end
  object pcProcNoti: TPageControl [1]
    Left = 0
    Top = 374
    Width = 868
    Height = 199
    ActivePage = tsPendNoti
    Align = alClient
    TabOrder = 1
    OnChange = pcProcNotiChange
    OnChanging = pcProcNotiChanging
    OnResize = pcProcNotiResize
    object tsPendNoti: TTabSheet
      Caption = 'Pending'
      object lstvAlerts: TCaptionListView
        Left = 0
        Top = 21
        Width = 860
        Height = 201
        Align = alClient
        Columns = <
          item
            Caption = 'Info'
            Width = 30
          end
          item
            Caption = 'Patient'
            Tag = 1
            Width = 120
          end
          item
            Caption = 'Location'
            Tag = 2
            Width = 60
          end
          item
            Caption = 'Urgency'
            Tag = 3
            Width = 67
          end
          item
            Caption = 'Alert Date/Time'
            Tag = 4
            Width = 110
          end
          item
            Caption = 'Message'
            Tag = 5
            Width = 280
          end
          item
            Caption = 'Surrogate for'
            Tag = 14
            Width = 120
          end
          item
            Caption = 'Forwarded By/When'
            Tag = 6
            Width = 180
          end
          item
            Caption = 'Ordering Provider'
            Tag = 10
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        MultiSelect = True
        OwnerData = True
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        PopupMenu = popNotifications
        ShowWorkAreas = True
        ShowHint = True
        SmallImages = dmodShared.imgNotes
        TabOrder = 0
        ViewStyle = vsReport
        OnAdvancedCustomDrawItem = lstvAlertsAdvancedCustomDrawItem
        OnColumnClick = lstvAlertsColumnClick
        OnData = lstvAlertsData
        OnDataStateChange = lstvAlertsDataStateChange
        OnDblClick = lstvAlertsDblClick
        OnInfoTip = lstvAlertsInfoTip
        OnKeyDown = lstvAlertsKeyDown
        OnSelectItem = lstvAlertsSelectItem
        AutoSize = False
        Caption = 'Notifications'
        HideTinyColumns = True
        Pieces = '1,2,3,4,5,6,7,11'
      end
      object pnlDivide: TORAutoPanel
        Left = 0
        Top = 0
        Width = 860
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        BevelWidth = 2
        TabOrder = 1
        Visible = False
        object lblNotifications: TLabel
          Left = 4
          Top = 4
          Width = 58
          Height = 13
          Caption = 'Notifications'
        end
        object btnCancelProcessing: TButton
          Left = 335
          Top = 1
          Width = 170
          Height = 19
          Caption = 'Cancel Processing...'
          TabOrder = 0
          Visible = False
          OnClick = btnCancelProcessingClick
        end
        object pbarNotifications: TProgressBar
          Left = 147
          Top = -2
          Width = 161
          Height = 21
          Enabled = False
          MarqueeInterval = 250
          TabOrder = 1
          Visible = False
        end
      end
      object pnlNotifications: TORAutoPanel
        Left = 0
        Top = 222
        Width = 860
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        Visible = False
        object txtCmdComments: TVA508StaticText
          Name = 'txtCmdComments'
          Left = 441
          Top = 0
          Width = 159
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Show Comments Button Disabled'
          TabOrder = 7
          Visible = False
          ShowAccelChar = True
        end
        object txtCmdRemove: TVA508StaticText
          Name = 'txtCmdRemove'
          Left = 577
          Top = 0
          Width = 120
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Remove Button Disabled'
          TabOrder = 9
          Visible = False
          ShowAccelChar = True
        end
        object txtCmdForward: TVA508StaticText
          Name = 'txtCmdForward'
          Left = 344
          Top = 0
          Width = 118
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Forward Button Disabled'
          TabOrder = 5
          Visible = False
          ShowAccelChar = True
        end
        object txtCmdProcess: TVA508StaticText
          Name = 'txtCmdProcess'
          Left = 232
          Top = 0
          Width = 118
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Process Button Disabled'
          TabOrder = 3
          Visible = False
          ShowAccelChar = True
        end
        object cmdRemove: TButton
          Left = 578
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Remove'
          Enabled = False
          TabOrder = 8
          OnClick = cmdRemoveClick
        end
        object cmdComments: TButton
          Left = 441
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Show Comments'
          Enabled = False
          TabOrder = 6
          OnClick = cmdCommentsClick
        end
        object cmdForward: TButton
          Left = 335
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Forward'
          Enabled = False
          TabOrder = 4
          OnClick = cmdForwardClick
        end
        object cmdProcess: TButton
          Left = 234
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Process'
          Enabled = False
          TabOrder = 2
          OnClick = cmdProcessClick
        end
        object cmdProcessAll: TButton
          Left = 120
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Process All'
          TabOrder = 1
          OnClick = cmdProcessAllClick
        end
        object cmdProcessInfo: TButton
          Left = 11
          Top = 10
          Width = 95
          Height = 21
          Caption = 'Process Info'
          TabOrder = 0
          OnClick = cmdProcessInfoClick
        end
        object cmdDefer: TButton
          Left = 678
          Top = 10
          Width = 95
          Height = 21
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Defer'
          Enabled = False
          TabOrder = 10
          OnClick = cmdDeferClick
        end
        object txtCmdDefer: TVA508StaticText
          Name = 'txtCmdDefer'
          Left = 679
          Top = 0
          Width = 106
          Height = 15
          Alignment = taLeftJustify
          Caption = 'Defer Button Disabled'
          TabOrder = 11
          Visible = False
          ShowAccelChar = True
        end
      end
    end
    object tsProcessedAlertsForm: TTabSheet
      Caption = 'Processed'
      ImageIndex = 2
      object pnlPaCanvas: TPanel
        Left = 0
        Top = 0
        Width = 860
        Height = 257
        Align = alClient
        BevelOuter = bvNone
        Caption = 
          'This area will be used as the container for frmAlertsProcessed f' +
          'orm'
        Color = clGradientActiveCaption
        ParentBackground = False
        TabOrder = 0
      end
    end
  end
  object gpTop: TGridPanel [2]
    Left = 0
    Top = 0
    Width = 868
    Height = 370
    Margins.Left = 6
    Align = alTop
    ColumnCollection = <
      item
        Value = 35.000000000000000000
      end
      item
        Value = 35.000000000000000000
      end
      item
        Value = 30.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 80.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 3
        Control = cmdOK
        Row = 0
      end
      item
        Column = 1
        Control = lblPatient
        Row = 0
      end
      item
        Column = 2
        Control = lblPtDemo
        Row = 1
      end
      item
        Column = 3
        Control = cmdCancel
        Row = 1
      end
      item
        Column = 3
        Control = cmdSaveList
        Row = 3
      end
      item
        Column = 1
        Control = cboPatient
        Row = 1
        RowSpan = 3
      end
      item
        Column = 0
        Control = fraPtSelOptns
        Row = 0
        RowSpan = 4
      end
      item
        Column = 2
        Control = lblGap
        Row = 0
      end
      item
        Column = 2
        ColumnSpan = 2
        Control = fraPtSelDemog
        Row = 2
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end>
    TabOrder = 0
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 790
      Top = 3
      Width = 74
      Height = 17
      Margins.Top = 2
      Margins.Bottom = 2
      Align = alClient
      Caption = 'OK'
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object lblPatient: TLabel
      AlignWithMargins = True
      Left = 203
      Top = 1
      Width = 267
      Height = 21
      Margins.Left = 6
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = 'Patient'
      ShowAccelChar = False
      Layout = tlCenter
      ExplicitWidth = 33
      ExplicitHeight = 13
    end
    object lblPtDemo: TLabel
      AlignWithMargins = True
      Left = 476
      Top = 22
      Width = 308
      Height = 21
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = 'Patient Demographics'
      Layout = tlCenter
      ExplicitWidth = 104
      ExplicitHeight = 13
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 790
      Top = 24
      Width = 74
      Height = 17
      Margins.Top = 2
      Margins.Bottom = 2
      Align = alClient
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cmdSaveList: TButton
      AlignWithMargins = True
      Left = 790
      Top = 264
      Width = 74
      Height = 17
      Margins.Top = 2
      Margins.Bottom = 2
      Align = alClient
      Caption = 'Save Settings'
      TabOrder = 5
      OnClick = cmdSaveListClick
    end
    object cboPatient: TORComboBox
      AlignWithMargins = True
      Left = 200
      Top = 25
      Width = 270
      Height = 255
      Hint = 'Enter name or use "Last 4" (x1234) format'
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Patient'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20,25,30'
      TabOrder = 0
      Text = ''
      OnChange = cboPatientChange
      OnDblClick = cboPatientDblClick
      OnEnter = cboPatientEnter
      OnExit = cboPatientExit
      OnKeyDown = cboPatientKeyDown
      OnKeyUp = cboPatientKeyUp
      OnKeyPause = cboPatientKeyPause
      OnMouseClick = cboPatientMouseClick
      OnNeedData = cboPatientNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    inline fraPtSelOptns: TfraPtSelOptns
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 190
      Height = 276
      Align = alClient
      TabOrder = 4
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 190
      ExplicitHeight = 276
      inherited gpMain: TGridPanel
        Width = 269
        Height = 362
        ControlCollection = <
          item
            Column = 0
            Control = fraPtSelOptns.lblPtList
            Row = 0
          end
          item
            Column = 0
            Control = fraPtSelOptns.pnlRad
            Row = 1
          end
          item
            Column = 0
            Control = fraPtSelOptns.cboList
            Row = 2
          end
          item
            Column = 0
            Control = fraPtSelOptns.lblDateRange
            Row = 3
          end
          item
            Column = 0
            Control = fraPtSelOptns.cboDateRange
            Row = 4
          end
          item
            Column = 0
            Control = fraPtSelOptns.lbHistory
            Row = 5
          end>
        ExplicitWidth = 190
        ExplicitHeight = 276
        inherited lblPtList: TLabel
          Width = 184
          Layout = tlBottom
          ExplicitWidth = 52
        end
        inherited pnlRad: TPanel
          Width = 190
          ExplicitWidth = 190
          inherited gpRad: TGridPanel
            Width = 188
            ControlCollection = <
              item
                Column = 0
                ColumnSpan = 2
                Control = fraPtSelOptns.radDflt
                Row = 0
              end
              item
                Column = 0
                Control = fraPtSelOptns.radProviders
                Row = 1
              end
              item
                Column = 1
                Control = fraPtSelOptns.radClinics
                Row = 1
              end
              item
                Column = 0
                Control = fraPtSelOptns.radTeams
                Row = 2
              end
              item
                Column = 1
                Control = fraPtSelOptns.radWards
                Row = 2
              end
              item
                Column = 0
                Control = fraPtSelOptns.radSpecialties
                Row = 3
              end
              item
                Column = 1
                Control = fraPtSelOptns.radPcmmTeams
                Row = 3
              end
              item
                Column = 0
                Control = fraPtSelOptns.radHistory
                Row = 4
              end
              item
                Column = 1
                Control = fraPtSelOptns.radAll
                Row = 4
              end>
            ExplicitWidth = 188
            inherited radDflt: TRadioButton
              Width = 180
              ExplicitWidth = 180
            end
            inherited radProviders: TRadioButton
              Width = 87
              ExplicitWidth = 87
            end
            inherited radClinics: TRadioButton
              Left = 97
              Width = 87
              ExplicitLeft = 97
              ExplicitWidth = 87
            end
            inherited radTeams: TRadioButton
              Width = 87
              ExplicitWidth = 87
            end
            inherited radWards: TRadioButton
              Left = 97
              Width = 87
              ExplicitLeft = 97
              ExplicitWidth = 87
            end
            inherited radSpecialties: TRadioButton
              Width = 87
              ExplicitWidth = 87
            end
            inherited radPcmmTeams: TRadioButton
              Left = 97
              Width = 87
              ExplicitLeft = 97
              ExplicitWidth = 87
            end
            inherited radHistory: TRadioButton
              Width = 87
              ExplicitWidth = 87
            end
            inherited radAll: TRadioButton
              Left = 97
              Width = 87
              ExplicitLeft = 97
              ExplicitWidth = 87
            end
          end
        end
        inherited cboList: TORComboBox
          Width = 184
          Height = 43
          ExplicitWidth = 184
          ExplicitHeight = 43
        end
        inherited lblDateRange: TLabel
          Top = 178
          Width = 184
          ExplicitTop = 178
          ExplicitWidth = 98
        end
        inherited cboDateRange: TORComboBox
          Top = 209
          Width = 184
          ExplicitTop = 209
          ExplicitWidth = 184
        end
        inherited lbHistory: TListBox
          Top = 230
          Width = 184
          Height = 43
          ExplicitTop = 230
          ExplicitWidth = 184
          ExplicitHeight = 43
        end
      end
      inherited calApptRng: TORDateRangeDlg
        Left = 160
        Top = 136
      end
    end
    object lblGap: TLabel
      Left = 473
      Top = 1
      Width = 314
      Height = 21
      Align = alClient
      Alignment = taCenter
      Caption = 'Gap'
      Layout = tlCenter
      Visible = False
      ExplicitWidth = 20
      ExplicitHeight = 13
    end
    inline fraPtSelDemog: TfraPtSelDemog
      AlignWithMargins = True
      Left = 554
      Top = 46
      Width = 310
      Height = 299
      Align = alClient
      Constraints.MinHeight = 200
      TabOrder = 3
      ExplicitLeft = 545
      ExplicitTop = -59
      inherited gPanel: TGridPanel
        Width = 304
        Height = 276
        ControlCollection = <
          item
            Column = 0
            Control = fraPtSelDemog.stxSSN
            Row = 0
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtSSN
            Row = 0
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxDOB
            Row = 1
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtDOB
            Row = 1
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxSexAge
            Row = 2
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtSex
            Row = 2
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxSIGI
            Row = 3
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtSigi
            Row = 3
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxVeteran
            Row = 4
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtVet
            Row = 4
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxSC
            Row = 5
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtSC
            Row = 5
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxLocation
            Row = 6
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtLocation
            Row = 6
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxRoomBed
            Row = 7
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblPtRoomBed
            Row = 7
          end
          item
            Column = 1
            Control = fraPtSelDemog.lblCombatVet
            Row = 8
          end
          item
            Column = 0
            Control = fraPtSelDemog.lblVeteran
            Row = 8
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxPrimaryProvider
            Row = 9
          end
          item
            Column = 1
            Control = fraPtSelDemog.stxPtPrimaryProvider
            Row = 9
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxInpatientProvider
            Row = 10
          end
          item
            Column = 1
            Control = fraPtSelDemog.stxPtInpatientProvider
            Row = 10
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxAttending
            Row = 11
          end
          item
            Column = 1
            Control = fraPtSelDemog.stxPtAttending
            Row = 11
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxLastVisitLocation
            Row = 12
          end
          item
            Column = 1
            Control = fraPtSelDemog.stxPtLastVisitLocation
            Row = 12
          end
          item
            Column = 0
            Control = fraPtSelDemog.stxLastVisitDate
            Row = 13
          end
          item
            Column = 1
            Control = fraPtSelDemog.stxPtLastVisitDate
            Row = 13
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = fraPtSelDemog.Memo
            Row = 14
          end>
        inherited lblPtSSN: TStaticText
          Width = 178
        end
        inherited lblPtDOB: TStaticText
          Width = 178
        end
        inherited lblPtSex: TStaticText
          Width = 178
        end
        inherited lblPtSigi: TStaticText
          Width = 178
        end
        inherited lblPtVet: TStaticText
          Width = 178
        end
        inherited lblPtSC: TStaticText
          Width = 178
        end
        inherited lblPtLocation: TStaticText
          Width = 178
        end
        inherited lblPtRoomBed: TStaticText
          Width = 178
        end
        inherited lblCombatVet: TStaticText
          Width = 178
        end
        inherited stxPtPrimaryProvider: TStaticText
          Width = 178
        end
        inherited stxPtInpatientProvider: TStaticText
          Width = 178
        end
        inherited stxPtAttending: TStaticText
          Width = 178
        end
        inherited stxPtLastVisitLocation: TStaticText
          Width = 178
        end
        inherited stxPtLastVisitDate: TStaticText
          Width = 178
        end
        inherited Memo: TCaptionMemo
          Width = 298
          Height = 0
        end
      end
      inherited lblPtName: TStaticText
        Width = 304
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 376
    Data = (
      (
        'Component = pnlDivide'
        'Status = stsDefault')
      (
        'Component = cboPatient'
        'Status = stsDefault')
      (
        'Component = pnlNotifications'
        'Status = stsDefault')
      (
        'Component = cmdProcessInfo'
        'Status = stsDefault')
      (
        'Component = cmdProcessAll'
        'Status = stsDefault')
      (
        'Component = cmdProcess'
        'Status = stsDefault')
      (
        'Component = cmdForward'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = lstvAlerts'
        'Status = stsDefault')
      (
        'Component = frmPtSel'
        'Status = stsDefault')
      (
        'Component = cmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdRemove'
        'Status = stsDefault')
      (
        'Component = txtCmdForward'
        'Status = stsDefault')
      (
        'Component = txtCmdProcess'
        'Status = stsDefault')
      (
        'Component = cmdDefer'
        'Status = stsDefault')
      (
        'Component = pcProcNoti'
        'Status = stsDefault')
      (
        'Component = tsPendNoti'
        'Status = stsDefault')
      (
        'Component = txtCmdDefer'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdSaveList'
        'Status = stsDefault')
      (
        'Component = tsProcessedAlertsForm'
        'Status = stsDefault')
      (
        'Component = pnlPaCanvas'
        'Status = stsDefault')
      (
        'Component = btnCancelProcessing'
        'Status = stsDefault')
      (
        'Component = pbarNotifications'
        'Status = stsDefault')
      (
        'Component = gpTop'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.lbHistory'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radAll'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radWards'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radClinics'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radSpecialties'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radTeams'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radProviders'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radDflt'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radPcmmTeams'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.radHistory'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.cboList'
        'Status = stsDefault')
      (
        'Component = fraPtSelOptns.cboDateRange'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.Memo'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtName'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblSSN'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtSSN'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblDOB'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtDOB'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtSex'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtVet'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtSC'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblLocation'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtRoomBed'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblPtLocation'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblRoomBed'
        'Status = stsDefault')
      (
        'Component = fraPtSelDemog.lblCombatVet'
        'Status = stsDefault'))
  end
  object popNotifications: TPopupMenu
    Left = 140
    Top = 371
    object mnuProcess: TMenuItem
      Caption = 'Process'
      OnClick = cmdProcessClick
    end
    object mnuForward: TMenuItem
      Caption = 'Forward'
      OnClick = cmdForwardClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuRemove: TMenuItem
      Caption = 'Remove'
      OnClick = cmdRemoveClick
    end
  end
  object dlgDateRange: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Show notification alerts in the date range:'
    LabelStart = 'From'
    LabelStop = 'Through'
    RequireTime = False
    Format = 'mmm d,yyyy'
    Left = 232
    Top = 372
  end
end
