inherited frmOrders: TfrmOrders
  Left = 451
  Top = 177
  HelpContext = 4000
  Caption = 'Orders Page'
  ClientHeight = 591
  ClientWidth = 766
  HelpFile = 'overvw'
  Menu = mnuOrders
  ExplicitWidth = 782
  ExplicitHeight = 650
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 586
    Width = 766
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 586
    ExplicitWidth = 766
  end
  inherited sptHorz: TSplitter
    Left = 117
    Height = 586
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    OnMoved = sptHorzMoved
    ExplicitLeft = 95
    ExplicitHeight = 457
  end
  inherited pnlLeft: TPanel
    Width = 117
    Height = 586
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 37
    ExplicitWidth = 117
    ExplicitHeight = 586
    object OROffsetLabel1: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 117
      Height = 19
      Align = alTop
      Caption = 'View Orders'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object lblWrite: TLabel
      Left = 0
      Top = 97
      Width = 117
      Height = 19
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
      Top = 75
      Width = 117
      Height = 4
      Cursor = crVSplit
      Align = alTop
      OnMoved = sptVertMoved
    end
    object lstSheets: TORListBox
      Left = 0
      Top = 19
      Width = 117
      Height = 56
      Align = alTop
      Constraints.MinHeight = 30
      ItemHeight = 13
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
      Top = 116
      Width = 117
      Height = 470
      Align = alClient
      ItemHeight = 13
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
      Top = 79
      Width = 117
      Height = 18
      Align = alTop
      Caption = 'Write Delayed Orders'
      TabOrder = 2
      OnClick = btnDelayedOrderClick
      Alignment = taLeftJustify
    end
  end
  inherited pnlRight: TPanel
    Left = 121
    Width = 645
    Height = 586
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 30
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    OnResize = pnlRightResize
    ExplicitLeft = 121
    ExplicitWidth = 645
    ExplicitHeight = 586
    object lblOrders: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 645
      Height = 19
      Align = alTop
      Caption = 'Active Orders'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object imgHide: TImage
      Left = 520
      Top = 0
      Width = 16
      Height = 16
      Hint = 'All Active Orders not Visible'
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
      Top = 19
      Width = 645
      Height = 17
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
        end
        item
          ImageIndex = -1
          Width = 50
        end>
      OnSectionClick = hdrOrdersSectionClick
      OnSectionResize = hdrOrdersSectionResize
      OnMouseDown = hdrOrdersMouseDown
      OnMouseUp = hdrOrdersMouseUp
    end
    object lstOrders: TCaptionListBox
      Left = 0
      Top = 36
      Width = 645
      Height = 550
      Style = lbOwnerDrawVariable
      Align = alClient
      Color = clCream
      Ctl3D = False
      ItemHeight = 32
      MultiSelect = True
      ParentCtl3D = False
      ParentShowHint = False
      PopupMenu = popOrder
      ShowHint = True
      TabOrder = 1
      OnDblClick = lstOrdersDblClick
      OnDrawItem = lstOrdersDrawItem
      OnMeasureItem = lstOrdersMeasureItem
      Caption = 'Active Orders'
      OnHintShow = lstOrdersHintShow
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lstSheets'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lstWrite'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnDelayedOrder'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = hdrOrders'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = frmOrders'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault'))
  end
  object mnuOrders: TMainMenu
    Left = 200
    Top = 60
    object mnuView: TMenuItem
      Caption = '&View'
      GroupIndex = 3
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
      object mnuViewUAP: TMenuItem
        Caption = 'Unified Action Profile (UAP)'
        OnClick = mnuViewUAPClick
      end
      object mnuViewDM: TMenuItem
        Caption = 'Discharge Meds'
        OnClick = mnuViewDMClick
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
      object mnuActFlagComment: TMenuItem
        Caption = 'Flag Comments'
        OnClick = mnuActFlagCommentClick
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
      object N4: TMenuItem
        Caption = '-'
      end
      object Park1: TMenuItem
        Action = actPark
      end
      object UnparkGeneratesarequesttoFillRefill1: TMenuItem
        Action = actUnpark
      end
    end
    object mnuOpt: TMenuItem
      Caption = '&Options'
      GroupIndex = 5
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
    Tag = 1
    OnPopup = popOrderPopup
    Left = 213
    Top = 244
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
      Tag = 1
      Caption = 'Release Delayed Orders'
      Visible = False
      OnClick = mnuActRelClick
    end
    object popChgEvnt: TMenuItem
      Tag = 1
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
    object N3: TMenuItem
      Caption = '-'
    end
    object popPark: TMenuItem
      Action = actPark
    end
    object popUnpark: TMenuItem
      Action = actUnpark
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
    object N2: TMenuItem
      Caption = '-'
    end
    object popFlag: TMenuItem
      Tag = 1
      Caption = 'Flag...'
      OnClick = mnuActFlagClick
    end
    object popFlagComment: TMenuItem
      Tag = 1
      Caption = 'Flag Comment...'
      OnClick = mnuActFlagCommentClick
    end
    object popUnflag: TMenuItem
      Tag = 1
      Caption = 'Unflag...'
      OnClick = mnuActUnflagClick
    end
    object mnuAllowMultipleAssignment: TMenuItem
      Caption = 'Allow Multiple Assignment'
      Enabled = False
      Hint = 'Allow to assign the same flag comment to several order flags'
      OnClick = mnuAllowMultipleAssignmentClick
    end
  end
  object PopUAPOrder: TPopupMenu
    OnPopup = PopUAPOrderPopup
    Left = 216
    Top = 176
    object MnuDetailsUAP: TMenuItem
      Caption = 'Detai&ls...'
      OnClick = mnuViewDetailClick
    end
    object MnuDashUAP: TMenuItem
      Caption = '-'
    end
    object MnuContinueUAP: TMenuItem
      Caption = 'Continue...'
      OnClick = MnuContinueUAPClick
    end
    object MnuChangeUAP: TMenuItem
      Tag = 1
      Caption = '&Change...'
      OnClick = MnuChangeUAPClick
    end
    object MnuRenewUAP: TMenuItem
      Tag = 1
      Caption = 'Rene&w...'
      OnClick = MnuRenewUAPClick
    end
    object MnuDiscontinueUAP: TMenuItem
      Tag = 1
      Caption = '&Discontinue...'
      OnClick = MnuDiscontinueUAPClick
    end
    object MnuDash2UAP: TMenuItem
      Caption = '-'
    end
    object MnuSignUAP: TMenuItem
      Tag = 1
      Caption = '&Sign...'
      OnClick = mnuActSignClick
    end
  end
  object ActionList: TActionList
    Left = 352
    Top = 111
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
