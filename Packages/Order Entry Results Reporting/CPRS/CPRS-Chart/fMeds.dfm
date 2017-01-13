inherited frmMeds: TfrmMeds
  Left = 333
  Top = 55
  HelpContext = 3000
  VertScrollBar.Visible = False
  Caption = 'Medications Page'
  ClientHeight = 671
  ClientWidth = 701
  HelpFile = 'qnoback'
  Menu = mnuMeds
  Visible = True
  OnDestroy = FormDestroy
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 717
  ExplicitHeight = 725
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
    Top = 460
    Width = 701
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Color = clBtnFace
    Constraints.MaxHeight = 5
    Constraints.MinHeight = 4
    MinSize = 100
    ParentColor = False
    OnMoved = splitTopMoved
  end
  object pnlBottom: TORAutoPanel [2]
    Left = 0
    Top = 464
    Width = 701
    Height = 207
    Align = alBottom
    Constraints.MinHeight = 40
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object splitBottom: TSplitter
      Left = 1
      Top = 102
      Width = 699
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      Color = clBtnFace
      Constraints.MaxHeight = 5
      Constraints.MinHeight = 4
      MinSize = 100
      ParentColor = False
      OnMoved = splitBottomMoved
    end
    object pnlMedIn: TPanel
      Left = 1
      Top = 106
      Width = 699
      Height = 100
      Align = alBottom
      Constraints.MinHeight = 100
      TabOrder = 1
      object lstMedsIn: TCaptionListBox
        Tag = 2
        Left = 1
        Top = 17
        Width = 697
        Height = 82
        Style = lbOwnerDrawVariable
        Align = alClient
        Color = clCream
        Constraints.MinHeight = 65
        Ctl3D = False
        ItemHeight = 13
        MultiSelect = True
        ParentCtl3D = False
        PopupMenu = popMed
        TabOrder = 0
        OnClick = lstMedsInClick
        OnDblClick = lstMedsDblClick
        OnDrawItem = lstMedsDrawItem
        OnExit = lstMedsExit
        OnMeasureItem = lstMedsMeasureItem
        Caption = 'Inpatient Medications'
        ExplicitLeft = 0
        ExplicitTop = 23
      end
      object hdrMedsIn: THeaderControl
        Left = 1
        Top = 1
        Width = 697
        Height = 16
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
    end
    object pnlNonVA: TPanel
      Left = 1
      Top = 1
      Width = 699
      Height = 101
      Align = alClient
      Caption = 'pnlNonVA'
      Constraints.MinHeight = 40
      TabOrder = 0
      object lstMedsNonVA: TCaptionListBox
        Tag = 3
        Left = 1
        Top = 17
        Width = 697
        Height = 83
        Style = lbOwnerDrawVariable
        Align = alClient
        Color = clCream
        Constraints.MinHeight = 40
        Ctl3D = False
        ItemHeight = 13
        MultiSelect = True
        ParentCtl3D = False
        PopupMenu = popMed
        TabOrder = 0
        OnClick = lstMedsNonVAClick
        OnDblClick = lstMedsDblClick
        OnDrawItem = lstMedsDrawItem
        OnExit = lstMedsExit
        OnMeasureItem = lstMedsMeasureItem
        Caption = 'Inpatient Medications'
      end
      object hdrMedsNonVA: THeaderControl
        Left = 1
        Top = 1
        Width = 697
        Height = 16
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
            Text = 'Non-VA Medications'
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
    end
  end
  object pnlTop: TORAutoPanel [3]
    Left = 0
    Top = 22
    Width = 701
    Height = 438
    Align = alClient
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object lstMedsOut: TCaptionListBox
      Tag = 1
      Left = 1
      Top = 17
      Width = 699
      Height = 420
      Style = lbOwnerDrawVariable
      Align = alClient
      Color = clCream
      Constraints.MinHeight = 40
      Ctl3D = False
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      PopupMenu = popMed
      TabOrder = 0
      OnClick = lstMedsOutClick
      OnDblClick = lstMedsDblClick
      OnDrawItem = lstMedsDrawItem
      OnExit = lstMedsExit
      OnMeasureItem = lstMedsMeasureItem
      Caption = 'Outpatient Medications'
      ExplicitLeft = 0
    end
    object hdrMedsOut: THeaderControl
      Left = 1
      Top = 1
      Width = 699
      Height = 16
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
  end
  object pnlView: TPanel [4]
    Left = 0
    Top = 0
    Width = 701
    Height = 22
    Align = alTop
    TabOrder = 0
    object txtView: TVA508StaticText
      Name = 'txtView'
      Left = 9
      Top = 3
      Width = 36
      Height = 15
      Alignment = taLeftJustify
      Caption = 'txtView'
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 152
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlMedIn'
        'Status = stsDefault')
      (
        'Component = lstMedsIn'
        'Status = stsDefault')
      (
        'Component = hdrMedsIn'
        'Status = stsDefault')
      (
        'Component = pnlNonVA'
        'Status = stsDefault')
      (
        'Component = lstMedsNonVA'
        'Status = stsDefault')
      (
        'Component = hdrMedsNonVA'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lstMedsOut'
        'Status = stsDefault')
      (
        'Component = hdrMedsOut'
        'Status = stsDefault')
      (
        'Component = frmMeds'
        'Status = stsDefault')
      (
        'Component = pnlView'
        'Status = stsDefault')
      (
        'Component = txtView'
        'Status = stsDefault'))
  end
  object mnuMeds: TMainMenu
    Left = 56
    Top = 154
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
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuActOneStep: TMenuItem
        Caption = 'One Step Clinic Admin'
        OnClick = mnuActOneStepClick
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
  end
end
