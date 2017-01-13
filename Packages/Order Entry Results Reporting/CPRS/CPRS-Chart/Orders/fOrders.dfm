inherited frmOrders: TfrmOrders
  Left = 451
  Top = 177
  HelpContext = 4000
  Caption = 'Orders Page'
  ClientHeight = 727
  ClientWidth = 943
  HelpFile = 'overvw'
  Menu = mnuOrders
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 959
  ExplicitHeight = 785
  PixelsPerInch = 96
  TextHeight = 16
  inherited shpPageBottom: TShape
    Top = 721
    Width = 943
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ExplicitTop = 721
    ExplicitWidth = 943
  end
  inherited sptHorz: TSplitter
    Left = 144
    Height = 721
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    OnMoved = sptHorzMoved
    ExplicitLeft = 144
    ExplicitHeight = 721
  end
  inherited pnlLeft: TPanel
    Width = 144
    Height = 721
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 46
    ExplicitWidth = 144
    ExplicitHeight = 721
    object OROffsetLabel1: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 144
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'View Orders'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblWrite: TLabel
      Left = 0
      Top = 119
      Width = 144
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      AutoSize = False
      Caption = 'Write Orders'
      ParentShowHint = False
      ShowHint = True
      Layout = tlBottom
      OnMouseMove = lblWriteMouseMove
    end
    object sptVert: TSplitter
      Left = 0
      Top = 92
      Width = 144
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      OnMoved = sptVertMoved
    end
    object lstSheets: TORListBox
      Left = 0
      Top = 23
      Width = 144
      Height = 69
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Constraints.MinHeight = 37
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = lstSheetsClick
      Caption = 'View Orders'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstWrite: TORListBox
      Left = 0
      Top = 143
      Width = 144
      Height = 578
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = lstWriteClick
      Caption = 'Write Orders'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object btnDelayedOrder: TORAlignButton
      Left = 0
      Top = 97
      Width = 144
      Height = 22
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Write Delayed Orders'
      TabOrder = 2
      OnClick = btnDelayedOrderClick
      Alignment = taLeftJustify
    end
  end
  inherited pnlRight: TPanel
    Left = 149
    Width = 794
    Height = 721
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinWidth = 37
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    OnResize = pnlRightResize
    ExplicitLeft = 149
    ExplicitWidth = 794
    ExplicitHeight = 721
    object lblOrders: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 794
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Active Orders'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object imgHide: TImage
      Left = 640
      Top = 0
      Width = 16
      Height = 16
      Hint = 'All Active Orders not Visible'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        07544269746D6170F6000000424DF60000000000000076000000280000001000
        0000100000000100040000000000800000000000000000000000100000001000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF003333000000000EEE33330FF00FBFB0EE33330F0BFB0BFB0E33330FF000BF
        BFB033330FFF0BFBFBF033300000BF0FBFB0000FBFB0F0FB0BF0E0FB00000000
        BF00E0BFBFBFBFB0F0F0E0FBFB0000000FF0E0BFBFBFBFB0FFF0E0FBFB00000F
        0000E00FBFBFB0FF0FF0003000000FFF0F0333330FFFFFFF0033333300000000
        0333}
      ShowHint = True
      Transparent = True
    end
    object hdrOrders: THeaderControl
      Left = 0
      Top = 23
      Width = 794
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Sections = <
        item
          ImageIndex = -1
          Width = 0
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Service'
          Width = 50
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Order'
          Width = 210
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Start / Stop'
          Width = 100
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Provider'
          Width = 60
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Nurse'
          Width = 40
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Clerk'
          Width = 35
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Chart'
          Width = 35
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Status'
          Width = 50
        end
        item
          ImageIndex = -1
          MinWidth = 25
          Text = 'Location'
          Width = 40
        end>
      OnSectionClick = hdrOrdersSectionClick
      OnSectionResize = hdrOrdersSectionResize
      OnMouseDown = hdrOrdersMouseDown
      OnMouseUp = hdrOrdersMouseUp
    end
    object lstOrders: TCaptionListBox
      Left = 0
      Top = 44
      Width = 794
      Height = 677
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawVariable
      Align = alClient
      Color = clCream
      Ctl3D = False
      ItemHeight = 32
      MultiSelect = True
      ParentCtl3D = False
      PopupMenu = popOrder
      TabOrder = 1
      OnDblClick = lstOrdersDblClick
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'Active Orders'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstSheets'
        'Status = stsDefault')
      (
        'Component = lstWrite'
        'Status = stsDefault')
      (
        'Component = btnDelayedOrder'
        'Status = stsDefault')
      (
        'Component = hdrOrders'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmOrders'
        'Status = stsDefault'))
  end
  object mnuOrders: TMainMenu
    Left = 136
    Top = 60
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
      object Z1: TMenuItem
        Caption = '-'
      end
      object mnuViewActive: TMenuItem
        Caption = '&Active Orders (includes pending, recent activity)'
        OnClick = mnuViewActiveClick
      end
      object mnuViewCurrent: TMenuItem
        Caption = 'Current &Orders (active/pending status only)'
        OnClick = mnuViewCurrentClick
      end
      object EventRealeasedOrder1: TMenuItem
        Caption = 'Auto DC/Release Event Orders'
        OnClick = EventRealeasedOrder1Click
      end
      object mnuViewExpiring: TMenuItem
        Caption = '&Expiring Orders'
        OnClick = mnuViewExpiringClick
      end
      object mnuViewUnsigned: TMenuItem
        Caption = '&Unsigned Orders'
        OnClick = mnuViewUnsignedClick
      end
      object mnuViewExpired: TMenuItem
        Caption = '&Recently Expired Orders'
        OnClick = mnuViewExpiredClick
      end
      object Z2: TMenuItem
        Caption = '-'
      end
      object mnuViewCustom: TMenuItem
        Caption = '&Custom Order View...'
        OnClick = mnuViewCustomClick
      end
      object Z6: TMenuItem
        Caption = '-'
      end
      object mnuViewDfltSave: TMenuItem
        Caption = '&Save as Default View...'
        OnClick = mnuViewDfltSaveClick
      end
      object mnuViewDfltShow: TMenuItem
        Caption = '&Return to Default View'
        OnClick = mnuViewDfltShowClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuViewDetail: TMenuItem
        Caption = '&Details...'
        OnClick = mnuViewDetailClick
      end
      object mnuViewResult: TMenuItem
        Caption = '&Results...'
        OnClick = mnuViewResultClick
      end
      object mnuViewResultsHistory: TMenuItem
        Caption = 'Results History...'
        OnClick = mnuViewResultsHistoryClick
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      OnClick = mnuActClick
      object mnuActChange: TMenuItem
        Caption = '&Change...'
        OnClick = mnuActChangeClick
      end
      object mnuActCopy: TMenuItem
        Caption = 'Copy to &New Order...'
        OnClick = mnuActCopyClick
      end
      object mnuActDC: TMenuItem
        Caption = '&Discontinue / Cancel...'
        OnClick = mnuActDCClick
      end
      object mnuActRel: TMenuItem
        Caption = 'Release Delayed Orders'
        Visible = False
        OnClick = mnuActRelClick
      end
      object mnuActChgEvnt: TMenuItem
        Caption = 'Change Release Event'
        OnClick = mnuActChgEvntClick
      end
      object mnuActHold: TMenuItem
        Caption = '&Hold...'
        OnClick = mnuActHoldClick
      end
      object mnuActUnhold: TMenuItem
        Caption = 'Re&lease Hold...'
        OnClick = mnuActUnholdClick
      end
      object mnuActRenew: TMenuItem
        Caption = 'Rene&w...'
        OnClick = mnuActRenewClick
      end
      object Z4: TMenuItem
        Caption = '-'
      end
      object mnuActAlert: TMenuItem
        Caption = '&Alert when Results...'
        OnClick = mnuActAlertClick
      end
      object mnuActComplete: TMenuItem
        Caption = 'Co&mplete...'
        OnClick = mnuActCompleteClick
      end
      object mnuActFlag: TMenuItem
        Caption = '&Flag...'
        OnClick = mnuActFlagClick
      end
      object mnuActUnflag: TMenuItem
        Caption = '&Unflag...'
        OnClick = mnuActUnflagClick
      end
      object mnuActVerify: TMenuItem
        Caption = '&Verify...'
        OnClick = mnuActVerifyClick
      end
      object mnuActChartRev: TMenuItem
        Caption = 'Char&t Review...'
        OnClick = mnuActChartRevClick
      end
      object Z5: TMenuItem
        Caption = '-'
      end
      object mnuActRelease: TMenuItem
        Caption = 'R&elease without MD Signature...'
        OnClick = mnuActReleaseClick
      end
      object mnuActOnChart: TMenuItem
        Caption = 'Signature &On Chart...'
        OnClick = mnuActOnChartClick
      end
      object mnuActSign: TMenuItem
        Caption = 'Si&gn Selected...'
        OnClick = mnuActSignClick
      end
      object Z7: TMenuItem
        Caption = '-'
      end
      object mnuActOneStep: TMenuItem
        Caption = 'One Step Clinic Admin'
        OnClick = mnuActOneStepClick
      end
    end
    object mnuOpt: TMenuItem
      Caption = '&Options'
      GroupIndex = 5
      OnClick = mnuOptClick
      object mnuOptSaveQuick: TMenuItem
        Caption = '&Save as Quick Order...'
        OnClick = mnuOptSaveQuickClick
      end
      object mnuOptEditCommon: TMenuItem
        Caption = '&Edit Common List...'
        OnClick = mnuOptEditCommonClick
      end
    end
  end
  object popOrder: TPopupMenu
    OnPopup = popOrderPopup
    Left = 445
    Top = 300
    object popOrderDetail: TMenuItem
      Caption = 'Detai&ls...'
      OnClick = mnuViewDetailClick
    end
    object popOrderResult: TMenuItem
      Caption = '&Results...'
      OnClick = mnuViewResultClick
    end
    object popResultsHistory: TMenuItem
      Caption = 'Results History...'
      OnClick = mnuViewResultsHistoryClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popOrderChange: TMenuItem
      Tag = 1
      Caption = '&Change...'
      OnClick = mnuActChangeClick
    end
    object popOrderRel: TMenuItem
      Caption = 'Release Delayed Orders'
      Visible = False
      OnClick = mnuActRelClick
    end
    object mnuChgEvnt: TMenuItem
      Caption = 'Change Release Event'
      OnClick = mnuActChgEvntClick
    end
    object popOrderCopy: TMenuItem
      Tag = 1
      Caption = 'Copy to &New Order...'
      OnClick = mnuActCopyClick
    end
    object popOrderDC: TMenuItem
      Tag = 1
      Caption = '&Discontinue...'
      OnClick = mnuActDCClick
    end
    object popOrderRenew: TMenuItem
      Tag = 1
      Caption = 'Rene&w...'
      OnClick = mnuActRenewClick
    end
    object sepOrderVerify: TMenuItem
      Caption = '-'
    end
    object popOrderVerify: TMenuItem
      Tag = 2
      Caption = '&Verify...'
      OnClick = mnuActVerifyClick
    end
    object popOrderChartRev: TMenuItem
      Tag = 2
      Caption = 'Char&t Review'
      OnClick = mnuActChartRevClick
    end
    object popOrderSign: TMenuItem
      Tag = 1
      Caption = '&Sign...'
      OnClick = mnuActSignClick
    end
    object mnuOptimizeFields: TMenuItem
      Caption = 'Adjust Column Size'
      Visible = False
      OnClick = mnuOptimizeFieldsClick
    end
  end
end
