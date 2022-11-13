inherited frmDCSummProperties: TfrmDCSummProperties
  Left = 298
  Top = 186
  BorderIcons = []
  Caption = 'Discharge Summary Properties'
  ClientHeight = 450
  ClientWidth = 505
  Constraints.MinWidth = 480
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 521
  ExplicitHeight = 489
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCanvas: TPanel [0]
    Left = 0
    Top = 0
    Width = 505
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlSummaryTitle: TPanel
      Left = 0
      Top = 0
      Width = 505
      Height = 126
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bvlConsult: TBevel
        Tag = 1
        AlignWithMargins = True
        Left = 8
        Top = 121
        Width = 489
        Height = 2
        Margins.Left = 8
        Margins.Right = 8
        Align = alBottom
        ExplicitTop = 122
        ExplicitWidth = 492
      end
      object cboNewTitle: TORComboBox
        AlignWithMargins = True
        Left = 145
        Top = 3
        Width = 352
        Height = 112
        Margins.Right = 8
        Style = orcsSimple
        Align = alClient
        AutoSelect = True
        Caption = 'Discharge Summary Title:'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnChange = cboNewTitleChange
        OnDblClick = cboNewTitleDblClick
        OnDropDownClose = cboNewTitleDropDownClose
        OnEnter = cboNewTitleEnter
        OnExit = cboNewTitleExit
        OnMouseClick = cboNewTitleMouseClick
        OnNeedData = cboNewTitleNeedData
        CharsNeedMatch = 1
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 142
        Height = 118
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object lblNewTitle: TLabel
          AlignWithMargins = True
          Left = 19
          Top = 3
          Width = 120
          Height = 13
          Align = alTop
          Alignment = taRightJustify
          Caption = 'Discharge Summary Title:'
        end
      end
    end
    object pnlAdmission: TPanel
      Left = 0
      Top = 212
      Width = 505
      Height = 173
      Margins.Top = 6
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinWidth = 480
      ParentBackground = False
      TabOrder = 1
      Visible = False
      object Bevel1: TBevel
        Tag = 1
        AlignWithMargins = True
        Left = 8
        Top = 3
        Width = 489
        Height = 2
        Margins.Left = 8
        Margins.Right = 8
        Align = alTop
        ExplicitTop = 122
        ExplicitWidth = 492
      end
      object lstAdmissions: TCaptionListView
        AlignWithMargins = True
        Left = 8
        Top = 45
        Width = 489
        Height = 122
        Margins.Left = 8
        Margins.Right = 8
        Margins.Bottom = 6
        Align = alClient
        Columns = <
          item
            Caption = 'Location'
            Width = 64
          end
          item
            Caption = 'Admission Date '
            Tag = 1
            Width = 120
          end
          item
            Caption = 'Type '
            Tag = 2
            Width = 60
          end
          item
            Caption = 'Discharge Summary Status '
            Tag = 3
            Width = 120
          end>
        HideSelection = False
        HoverTime = 0
        IconOptions.WrapText = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowWorkAreas = True
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnSelectItem = lstAdmissionsSelectItem
        AutoSize = True
        Caption = 'Associated Admission'
        Pieces = '3,5,4,9'
      end
      object lblDCSumm1: TStaticText
        Tag = 1
        Left = 0
        Top = 8
        Width = 300
        Height = 17
        Margins.Left = 103
        Margins.Top = 6
        Margins.Bottom = 0
        Align = alTop
        Alignment = taCenter
        Caption = 'This discharge summary must be associated with an admission.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object lblDCSumm2: TStaticText
        Tag = 1
        Left = 0
        Top = 25
        Width = 207
        Height = 17
        Margins.Left = 150
        Margins.Top = 0
        Align = alTop
        Alignment = taCenter
        Caption = 'Select one of the following or press cancel.'
        TabOrder = 2
      end
    end
    object pnlMain: TPanel
      Left = 0
      Top = 126
      Width = 505
      Height = 86
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        505
        86)
      object lblDateTime: TLabel
        Left = 28
        Top = 6
        Width = 99
        Height = 13
        Alignment = taRightJustify
        Caption = 'Dictation Date/Time:'
      end
      object lblAuthor: TLabel
        Left = 51
        Top = 33
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Author/Dictator:'
      end
      object lblCosigner: TLabel
        Left = 31
        Top = 60
        Width = 96
        Height = 13
        Alignment = taRightJustify
        Caption = 'Attending Physician:'
      end
      object calSumm: TORDateBox
        Left = 148
        Top = 4
        Width = 140
        Height = 21
        TabOrder = 0
        DateOnly = False
        RequireTime = False
        Caption = 'Dictation Date/Time:'
      end
      object cboAuthor: TORComboBox
        Left = 148
        Top = 30
        Width = 264
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Author/Dictator:'
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
        TabOrder = 2
        Text = ''
        OnEnter = cboAuthorEnter
        OnMouseClick = cboAuthorMouseClick
        OnNeedData = cboAuthorNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object cboAttending: TORComboBox
        Left = 148
        Top = 57
        Width = 264
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Attending Physician:'
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
        TabOrder = 3
        Text = ''
        OnNeedData = cboAttendingNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object pnlButtons: TPanel
        Left = 416
        Top = 0
        Width = 89
        Height = 86
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 4
        object cmdOK: TButton
          AlignWithMargins = True
          Left = 8
          Top = 3
          Width = 73
          Height = 21
          Margins.Left = 8
          Margins.Right = 8
          Align = alTop
          Caption = 'OK'
          Default = True
          ModalResult = 1
          TabOrder = 0
        end
        object cmdCancel: TButton
          AlignWithMargins = True
          Left = 8
          Top = 30
          Width = 73
          Height = 21
          Margins.Left = 8
          Margins.Right = 8
          Align = alTop
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 1
          OnMouseDown = cmdCancelMouseDown
        end
      end
    end
    object pnlTranscription: TPanel
      Left = 0
      Top = 385
      Width = 505
      Height = 65
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 3
      Visible = False
      object lblTranscriptionist: TLabel
        Left = 53
        Top = 13
        Width = 71
        Height = 13
        Alignment = taRightJustify
        Caption = 'Transcriptionist'
      end
      object lblUrgency: TLabel
        Left = 84
        Top = 38
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Urgency'
      end
      object cboTranscriptionist: TORComboBox
        Left = 148
        Top = 7
        Width = 239
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Transcriptionist'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2,3'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnNeedData = cboAuthorNeedData
        CharsNeedMatch = 1
      end
      object cboUrgency: TORComboBox
        Left = 148
        Top = 37
        Width = 140
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Urgency'
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 40
    Top = 312
    Data = (
      (
        'Component = frmDCSummProperties'
        'Status = stsDefault')
      (
        'Component = pnlTranscription'
        'Status = stsDefault')
      (
        'Component = cboTranscriptionist'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = pnlAdmission'
        'Status = stsDefault')
      (
        'Component = lstAdmissions'
        'Status = stsDefault')
      (
        'Component = lblDCSumm1'
        'Status = stsDefault')
      (
        'Component = lblDCSumm2'
        'Status = stsDefault')
      (
        'Component = pnlSummaryTitle'
        'Status = stsDefault')
      (
        'Component = cboNewTitle'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = calSumm'
        'Status = stsDefault')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = cboAttending'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlCanvas'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault'))
  end
end
