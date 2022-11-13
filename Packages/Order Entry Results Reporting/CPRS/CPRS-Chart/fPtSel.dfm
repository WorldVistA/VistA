inherited frmPtSel: TfrmPtSel
  Left = 290
  Top = 232
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Selection'
  ClientHeight = 573
  ClientWidth = 868
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  ExplicitWidth = 884
  ExplicitHeight = 612
  PixelsPerInch = 96
  TextHeight = 13
  object sptVert: TSplitter [0]
    Left = 0
    Top = 290
    Width = 868
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 785
  end
  object pnlPtSel: TORAutoPanel [1]
    Left = 0
    Top = 0
    Width = 868
    Height = 290
    Align = alTop
    BevelWidth = 2
    Constraints.MinHeight = 150
    TabOrder = 0
    OnResize = pnlPtSelResize
    DesignSize = (
      868
      290)
    object lblPatient: TLabel
      Left = 208
      Top = 4
      Width = 33
      Height = 13
      Caption = 'Patient'
      ShowAccelChar = False
    end
    object lblPtDemo: TLabel
      Left = 494
      Top = 4
      Width = 104
      Height = 13
      Caption = 'Patient Demographics'
    end
    object cboPatient: TORComboBox
      Left = 208
      Top = 21
      Width = 280
      Height = 263
      Hint = 'Enter name or use "Last 4" (x1234) format'
      Style = orcsSimple
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
    object cmdOK: TButton
      Left = 762
      Top = 1
      Width = 99
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 1
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 762
      Top = 25
      Width = 99
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = cmdCancelClick
    end
    object cmdSaveList: TButton
      Left = 762
      Top = 263
      Width = 99
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Save Settings'
      TabOrder = 3
      OnClick = cmdSaveListClick
    end
  end
  object pcProcNoti: TPageControl [2]
    Left = 0
    Top = 294
    Width = 868
    Height = 279
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
        Height = 195
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
        ExplicitTop = 23
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
        Top = 216
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
        Height = 251
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
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlDivide'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlPtSel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cboPatient'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlNotifications'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdProcessInfo'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdProcessAll'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdProcess'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdForward'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lstvAlerts'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = frmPtSel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdComments'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = txtCmdComments'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = txtCmdRemove'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = txtCmdForward'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = txtCmdProcess'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdDefer'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pcProcNoti'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = tsPendNoti'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = txtCmdDefer'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cmdSaveList'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = tsProcessedAlertsForm'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlPaCanvas'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnCancelProcessing'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pbarNotifications'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault'))
  end
  object popNotifications: TPopupMenu
    Left = 44
    Top = 123
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
    Left = 40
    Top = 68
  end
end
