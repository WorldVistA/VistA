inherited frmMeds: TfrmMeds
  Left = 333
  Top = 55
  HelpContext = 3000
  VertScrollBar.Visible = False
  Caption = 'Medications Page'
  ClientHeight = 668
  ClientWidth = 701
  HelpFile = 'qnoback'
  Menu = mnuMeds
  Visible = True
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  ExplicitWidth = 717
  ExplicitHeight = 727
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 524
    Width = 1028
    Height = -4
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alCustom
    ExplicitTop = 524
    ExplicitWidth = 1028
    ExplicitHeight = -4
  end
  object splitTop: TSplitter [1]
    Left = 0
    Top = 227
    Width = 701
    Height = 4
    Cursor = crVSplit
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    AutoSnap = False
    Color = clBtnFace
    Constraints.MaxHeight = 5
    Constraints.MinHeight = 4
    MinSize = 100
    ParentColor = False
    ResizeStyle = rsUpdate
    OnMoved = splitTopMoved
    ExplicitTop = 460
  end
  object splitBottom: TSplitter [2]
    Left = 0
    Top = 363
    Width = 701
    Height = 4
    Cursor = crVSplit
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    AutoSnap = False
    Color = clBtnFace
    Constraints.MaxHeight = 5
    Constraints.MinHeight = 4
    MinSize = 100
    ParentColor = False
    ResizeStyle = rsUpdate
    OnMoved = splitBottomMoved
    ExplicitLeft = -2
    ExplicitTop = 414
  end
  object gdpSort: TGridPanel [3]
    Left = 0
    Top = 0
    Width = 701
    Height = 23
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 2
        Control = txtView
        Row = 0
        RowSpan = 2
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object txtView: TVA508StaticText
      Name = 'txtView'
      Left = 1
      Top = 1
      Width = 699
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Alignment = taLeftJustify
      Caption = 'txtView'
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object gdpOut: TGridPanel [4]
    Left = 0
    Top = 23
    Width = 701
    Height = 204
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BiDiMode = bdLeftToRight
    BorderStyle = bsSingle
    ColumnCollection = <
      item
        Value = 26.002793129303330000
      end
      item
        Value = 26.002793129303330000
      end
      item
        Value = 24.909029174263870000
      end
      item
        Value = 23.085384567129470000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 4
        Control = txtDateRangeOp
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = hdrMedsOut
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = lstMedsOut
        Row = 2
      end
      item
        Column = 0
        Row = 3
      end>
    DoubleBuffered = False
    ExpandStyle = emFixedSize
    ParentBiDiMode = False
    ParentDoubleBuffered = False
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    object txtDateRangeOp: TVA508StaticText
      Name = 'txtDateRangeOp'
      Left = 1
      Top = 1
      Width = 695
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Alignment = taLeftJustify
      BorderWidth = 1
      Caption = '            txtDateRangeOp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      ShowAccelChar = True
    end
    object hdrMedsOut: THeaderControl
      Left = 1
      Top = 21
      Width = 695
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = []
      BiDiMode = bdLeftToRight
      Constraints.MinHeight = 16
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 42
          Text = 'Action'
          Width = 42
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Outpatient Medications'
          Width = 100
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Expires'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Status'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Last Filled'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Refills Remaining'
          Width = 78
        end>
      OnSectionClick = hdrMedsOutSectionClick
      OnSectionResize = hdrMedsOutSectionResize
      ParentBiDiMode = False
      OnMouseDown = hdrMedsOutMouseDown
      OnMouseUp = hdrMedsOutMouseUp
      OnResize = hdrMedsOutResize
    end
    object lstMedsOut: TCaptionListBox
      Tag = 1
      Left = 1
      Top = 41
      Width = 695
      Height = 158
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      BorderStyle = bsNone
      Color = clCream
      Constraints.MinHeight = 40
      Ctl3D = False
      DoubleBuffered = True
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentShowHint = False
      PopupMenu = popMed
      ShowHint = True
      TabOrder = 2
      OnClick = lstMedsOutClick
      OnDblClick = lstMedsDblClick
      OnDrawItem = lstMedsDrawItem
      OnExit = lstMedsExit
      OnMeasureItem = lstMedsMeasureItem
      Caption = 'Outpatient Medications'
      OnHintShow = lstMedsOutHintShow
    end
  end
  object gdpNon: TGridPanel [5]
    Left = 0
    Top = 231
    Width = 701
    Height = 132
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BorderWidth = 1
    BorderStyle = bsSingle
    ColumnCollection = <
      item
        Value = 25.104233731616910000
      end
      item
        Value = 25.104233731616910000
      end
      item
        Value = 24.791542078059250000
      end
      item
        Value = 24.999990458706920000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 4
        Control = txtDateRangeNon
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = hdrMedsNonVA
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = lstMedsNonVA
        Row = 2
      end
      item
        Column = 0
        Row = 3
      end>
    ExpandStyle = emFixedSize
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 2
    object txtDateRangeNon: TVA508StaticText
      Name = 'txtDateRangeNon'
      Left = 2
      Top = 2
      Width = 693
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'txtDateRangeNon'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ShowAccelChar = True
    end
    object hdrMedsNonVA: THeaderControl
      Left = 2
      Top = 22
      Width = 693
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = []
      BiDiMode = bdLeftToRight
      Constraints.MinHeight = 16
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 42
          Text = 'Action'
          Width = 42
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Non-VA Medications (Documentation)'
          Width = 100
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Start Date'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Status'
          Width = 62
        end>
      OnSectionClick = hdrMedsNonVASectionClick
      OnSectionResize = hdrMedsNonVASectionResize
      ParentBiDiMode = False
      OnMouseDown = hdrMedsNonVAMouseDown
      OnMouseUp = hdrMedsNonVAMouseUp
      OnResize = hdrMedsNonVAResize
    end
    object lstMedsNonVA: TCaptionListBox
      Tag = 3
      Left = 2
      Top = 42
      Width = 693
      Height = 84
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      BorderStyle = bsNone
      Color = clCream
      Constraints.MinHeight = 40
      Ctl3D = False
      DoubleBuffered = True
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentShowHint = False
      PopupMenu = popMed
      ShowHint = True
      TabOrder = 2
      OnClick = lstMedsNonVAClick
      OnDblClick = lstMedsDblClick
      OnDrawItem = lstMedsDrawItem
      OnExit = lstMedsExit
      OnMeasureItem = lstMedsMeasureItem
      Caption = 'Inpatient Medications'
    end
  end
  object gdpIn: TGridPanel [6]
    Left = 0
    Top = 367
    Width = 701
    Height = 301
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BorderStyle = bsSingle
    ColumnCollection = <
      item
        Value = 23.861971871927500000
      end
      item
        Value = 24.996669996734980000
      end
      item
        Value = 25.570679065668760000
      end
      item
        Value = 25.570679065668760000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 4
        Control = txtDateRangeIp
        Row = 0
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = hdrMedsIn
        Row = 1
      end
      item
        Column = 0
        ColumnSpan = 4
        Control = lstMedsIn
        Row = 2
      end
      item
        Column = 0
        Row = 3
      end>
    ExpandStyle = emFixedSize
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 20.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 3
    object txtDateRangeIp: TVA508StaticText
      Name = 'txtDateRangeIp'
      Left = 1
      Top = 1
      Width = 695
      Height = 15
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'txtDateRangeIp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ShowAccelChar = True
    end
    object hdrMedsIn: THeaderControl
      Left = 1
      Top = 21
      Width = 695
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = []
      BiDiMode = bdLeftToRight
      Constraints.MinHeight = 16
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 42
          Text = 'Action'
          Width = 42
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Inpatient Medications'
          Width = 100
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Stop Date'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Status'
          Width = 62
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Location'
          Width = 20
        end>
      OnSectionClick = hdrMedsInSectionClick
      OnSectionResize = hdrMedsInSectionResize
      ParentBiDiMode = False
      OnMouseDown = hdrMedsInMouseDown
      OnMouseUp = hdrMedsInMouseUp
      OnResize = hdrMedsInResize
    end
    object lstMedsIn: TCaptionListBox
      Tag = 2
      Left = 1
      Top = 41
      Width = 695
      Height = 255
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      BorderStyle = bsNone
      Color = clCream
      Constraints.MinHeight = 59
      Ctl3D = False
      DoubleBuffered = True
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      ParentDoubleBuffered = False
      ParentShowHint = False
      PopupMenu = popMed
      ShowHint = True
      TabOrder = 2
      OnClick = lstMedsInClick
      OnDblClick = lstMedsDblClick
      OnDrawItem = lstMedsDrawItem
      OnExit = lstMedsExit
      OnMeasureItem = lstMedsMeasureItem
      Caption = 'Inpatient Medications'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 152
    Data = (
      (
        'Component = frmMeds'
        'Status = stsDefault')
      (
        'Component = gdpSort'
        'Status = stsDefault')
      (
        'Component = txtView'
        'Status = stsDefault')
      (
        'Component = gdpOut'
        'Status = stsDefault')
      (
        'Component = txtDateRangeOp'
        'Status = stsDefault')
      (
        'Component = hdrMedsOut'
        'Status = stsDefault')
      (
        'Component = lstMedsOut'
        'Status = stsDefault')
      (
        'Component = gdpNon'
        'Status = stsDefault')
      (
        'Component = txtDateRangeNon'
        'Status = stsDefault')
      (
        'Component = hdrMedsNonVA'
        'Status = stsDefault')
      (
        'Component = lstMedsNonVA'
        'Status = stsDefault')
      (
        'Component = gdpIn'
        'Status = stsDefault')
      (
        'Component = txtDateRangeIp'
        'Status = stsDefault')
      (
        'Component = hdrMedsIn'
        'Status = stsDefault')
      (
        'Component = lstMedsIn'
        'Status = stsDefault'))
  end
  object mnuMeds: TMainMenu
    Left = 64
    Top = 122
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
      OnClick = mnuViewClick
      object mnuViewChart: TMenuItem
        Caption = 'Chart &Tab'
        object mnuChartCover: TMenuItem
          Tag = 1
          Caption = 'Cover &Sheet'
          ShortCut = 16467
          OnClick = mnuChartTabClick
        end
        object mnuChartProbs: TMenuItem
          Tag = 2
          Caption = '&Problem List'
          ShortCut = 16464
          OnClick = mnuChartTabClick
        end
        object mnuChartMeds: TMenuItem
          Tag = 3
          Caption = '&Medications'
          ShortCut = 16461
          OnClick = mnuChartTabClick
        end
        object mnuChartOrders: TMenuItem
          Tag = 4
          Caption = '&Orders'
          ShortCut = 16463
          OnClick = mnuChartTabClick
        end
        object mnuChartNotes: TMenuItem
          Tag = 6
          Caption = 'Progress &Notes'
          ShortCut = 16462
          OnClick = mnuChartTabClick
        end
        object mnuChartCslts: TMenuItem
          Tag = 7
          Caption = 'Consul&ts'
          ShortCut = 16468
          OnClick = mnuChartTabClick
        end
        object mnuChartSurgery: TMenuItem
          Tag = 11
          Caption = 'S&urgery'
          ShortCut = 16469
          OnClick = mnuChartTabClick
        end
        object mnuChartDCSumm: TMenuItem
          Tag = 8
          Caption = '&Discharge Summaries'
          ShortCut = 16452
          OnClick = mnuChartTabClick
        end
        object mnuChartLabs: TMenuItem
          Tag = 9
          Caption = '&Laboratory'
          ShortCut = 16460
          OnClick = mnuChartTabClick
        end
        object mnuChartReports: TMenuItem
          Tag = 10
          Caption = '&Reports'
          ShortCut = 16466
          OnClick = mnuChartTabClick
        end
      end
      object mnuViewInformation: TMenuItem
        Caption = 'Information'
        OnClick = mnuViewInformationClick
        object mnuViewDemo: TMenuItem
          Tag = 1
          Caption = 'De&mographics...'
          OnClick = ViewInfo
        end
        object mnuViewVisits: TMenuItem
          Tag = 2
          Caption = 'Visits/Pr&ovider...'
          OnClick = ViewInfo
        end
        object mnuViewPrimaryCare: TMenuItem
          Tag = 3
          Caption = 'Primary &Care...'
          OnClick = ViewInfo
        end
        object mnuViewMyHealtheVet: TMenuItem
          Tag = 4
          Caption = 'MyHealthe&Vet...'
          OnClick = ViewInfo
        end
        object mnuInsurance: TMenuItem
          Tag = 5
          Caption = '&Insurance...'
          OnClick = ViewInfo
        end
        object mnuViewFlags: TMenuItem
          Tag = 6
          Caption = '&Flags...'
          OnClick = ViewInfo
        end
        object mnuViewRemoteData: TMenuItem
          Tag = 7
          Caption = 'Remote &Data...'
          OnClick = ViewInfo
        end
        object mnuViewReminders: TMenuItem
          Tag = 8
          Caption = '&Reminders...'
          Enabled = False
          OnClick = ViewInfo
        end
        object mnuViewPostings: TMenuItem
          Tag = 9
          Caption = '&Postings...'
          OnClick = ViewInfo
        end
      end
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuViewActive: TMenuItem
        Caption = '&Active Medications'
        Visible = False
      end
      object mnuViewExpiring: TMenuItem
        Caption = '&Expiring Medications'
        Visible = False
      end
      object Z3: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuViewSortClass: TMenuItem
        Caption = 'Sort by &VA Drug Class'
        Visible = False
      end
      object Z4: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuViewDetail: TMenuItem
        Caption = '&Details...'
        OnClick = mnuViewDetailClick
      end
      object mnuViewSortName: TMenuItem
        Caption = 'Sort by Drug &Name'
        Visible = False
      end
      object mnuViewHistory: TMenuItem
        Caption = 'Administration &History...'
        OnClick = mnuViewHistoryClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object SortbyStatusthenLocation1: TMenuItem
        Caption = 'Sort by Status/Exp. Date (Clinic Orders first on Inpt)'
        OnClick = SortbyStatusthenLocation1Click
      end
      object SortbyClinicOrderthenStatusthenStopDate1: TMenuItem
        Caption = 'Sort by Status Group/Status/Location/Drug Name'
        OnClick = SortbyClinicOrderthenStatusthenStopDate1Click
      end
      object SortbyDrugalphabeticallystatusactivestatusrecentexpired1: TMenuItem
        Caption = 
          'Sort by Drug (alphabetically), status active, status recent expi' +
          'red'
        OnClick = SortbyDrugalphabeticallystatusactivestatusrecentexpired1Click
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      OnClick = mnuActClick
      object mnuActNew: TMenuItem
        Caption = '&New Medication...'
        OnClick = mnuActNewClick
      end
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuActChange: TMenuItem
        Caption = '&Change...'
        OnClick = mnuActChangeClick
      end
      object mnuActDC: TMenuItem
        Caption = '&Discontinue / Cancel...'
        OnClick = mnuActDCClick
      end
      object mnuActUnhold: TMenuItem
        Caption = 'Re&lease Hold...'
        Hint = 'Release Hold'
        OnClick = mnuActUnholdClick
      end
      object mnuActHold: TMenuItem
        Caption = '&Hold...'
        OnClick = mnuActHoldClick
      end
      object mnuActRenew: TMenuItem
        Caption = 'Rene&w...'
        OnClick = mnuActRenewClick
      end
      object mnuActCopy: TMenuItem
        Caption = 'Co&py to New Order...'
        OnClick = mnuActCopyClick
      end
      object mnuActTransfer: TMenuItem
        Caption = '&Transfer to...'
        OnClick = mnuActCopyClick
      end
      object mnuActRefill: TMenuItem
        Caption = 'R&efill...'
        OnClick = mnuActRefillClick
      end
      object DocumentNonVAMeds1: TMenuItem
        Caption = 'Document Non-VA Meds'
        OnClick = DocumentNonVAMeds1Click
      end
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuActOneStep: TMenuItem
        Caption = 'One Step Clinic Admin'
        OnClick = mnuActOneStepClick
      end
      object Z6: TMenuItem
        Caption = '-'
      end
      object mnuActPark: TMenuItem
        Action = actPark
      end
      object mnuActUnpark: TMenuItem
        Action = actUnpark
      end
    end
  end
  object popMed: TPopupMenu
    OnPopup = popMedPopup
    Left = 116
    Top = 155
    object popMedDetails: TMenuItem
      Caption = 'Detai&ls...'
      OnClick = mnuViewDetailClick
    end
    object popMedHistory: TMenuItem
      Caption = 'Administration &History...'
      OnClick = mnuViewHistoryClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popMedChange: TMenuItem
      Caption = '&Change...'
      OnClick = mnuActChangeClick
    end
    object popMedDC: TMenuItem
      Caption = '&Discontinue...'
      OnClick = mnuActDCClick
    end
    object popMedRefill: TMenuItem
      Caption = 'R&efill...'
      OnClick = mnuActRefillClick
    end
    object popMedRenew: TMenuItem
      Caption = 'Rene&w...'
      OnClick = mnuActRenewClick
    end
    object DocumentNonVAMeds2: TMenuItem
      Caption = 'Document Non-VA Meds'
      OnClick = DocumentNonVAMeds1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object popMedNew: TMenuItem
      Caption = '&New Medication...'
      OnClick = mnuActNewClick
    end
    object mnuOptimizeFields: TMenuItem
      Caption = 'Adjust Field Size'
      Visible = False
      OnClick = mnuOptimizeFieldsClick
    end
    object popDivPark: TMenuItem
      Caption = '-'
    end
    object popPark: TMenuItem
      Action = actPark
    end
    object popUnpark: TMenuItem
      Action = actUnpark
    end
  end
  object ActionList1: TActionList
    Left = 168
    Top = 127
    object actPark: TAction
      Caption = 'Park'
      OnExecute = actParkExecute
    end
    object actUnpark: TAction
      Caption = 'Unpark - Generates a request to Fill/Refill'
      OnExecute = actUnparkExecute
    end
  end
end
