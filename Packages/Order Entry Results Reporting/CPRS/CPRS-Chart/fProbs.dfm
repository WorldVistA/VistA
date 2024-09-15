inherited frmProblems: TfrmProblems
  Left = 303
  Top = 268
  HelpContext = 2000
  Caption = 'Problems List Page'
  ClientHeight = 355
  ClientWidth = 631
  HelpFile = 'overvw'
  Menu = mnuProbs
  OnMouseMove = FormMouseMove
  ExplicitWidth = 647
  ExplicitHeight = 413
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 350
    Width = 631
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Constraints.MinHeight = 5
    ExplicitTop = 350
    ExplicitWidth = 631
  end
  inherited sptHorz: TSplitter
    Left = 159
    Width = 2
    Height = 350
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    OnMoved = sptHorzMoved
    ExplicitLeft = 159
    ExplicitWidth = 2
    ExplicitHeight = 350
  end
  inherited pnlLeft: TPanel
    Width = 159
    Height = 350
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 37
    ExplicitWidth = 159
    ExplicitHeight = 350
    object pnlButtons: TPanel
      Left = 0
      Top = 304
      Width = 159
      Height = 46
      Align = alBottom
      BevelOuter = bvNone
      Constraints.MinHeight = 46
      TabOrder = 3
      object bbOtherProb: TORAlignButton
        Left = 0
        Top = 2
        Width = 159
        Height = 22
        Align = alBottom
        Caption = 'Other Problem'
        TabOrder = 0
        OnClick = bbOtherProbClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
      object bbCancel: TORAlignButton
        Left = 0
        Top = 24
        Width = 159
        Height = 22
        Align = alBottom
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = bbCancelClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
    end
    object pnlView: TPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblView: TOROffsetLabel
        Left = 0
        Top = 0
        Width = 159
        Height = 19
        Align = alTop
        Caption = 'View options'
        HorzOffset = 2
        Transparent = False
        VertOffset = 6
        WordWrap = False
      end
      object lstView: TORListBox
        Left = 0
        Top = 19
        Width = 159
        Height = 97
        Align = alTop
        ExtendedSelect = False
        ItemHeight = 13
        Items.Strings = (
          'A^Active'
          'I^Inactive'
          'B^Both active and inactive'
          'R^Removed')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstViewClick
        OnExit = lstViewExit
        OnMouseMove = FormMouseMove
        Caption = 'View options'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object bbNewProb: TORAlignButton
        Tag = 100
        Left = 0
        Top = 116
        Width = 159
        Height = 24
        Align = alTop
        Caption = 'New problem'
        TabOrder = 1
        OnClick = lstProbActsClick
        OnExit = bbNewProbExit
        OnMouseMove = FormMouseMove
      end
    end
    object pnlProbEnt: TPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      OnResize = pnlProbEntResize
      object lblProbEnt: TLabel
        Left = 0
        Top = 270
        Width = 159
        Height = 13
        Align = alBottom
        AutoSize = False
        Caption = 'Enter new problem:'
      end
      object edProbEnt: TCaptionEdit
        Left = 0
        Top = 283
        Width = 159
        Height = 21
        Align = alBottom
        TabOrder = 0
        OnExit = lstViewExit
        OnKeyPress = edProbEntKeyPress
        Caption = 'Enter new problem'
      end
    end
    object pnlProbList: TORAutoPanel
      Left = 0
      Top = 0
      Width = 159
      Height = 304
      Align = alClient
      BevelOuter = bvNone
      Constraints.MinHeight = 90
      TabOrder = 0
      object sptProbPanel: TSplitter
        Left = 0
        Top = 157
        Width = 159
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object pnlProbCats: TPanel
        Left = 0
        Top = 0
        Width = 159
        Height = 157
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblProbCats: TLabel
          Left = 0
          Top = 0
          Width = 159
          Height = 13
          Align = alTop
          AutoSize = False
          Caption = 'Problem categories'
        end
        object lstCatPick: TORListBox
          Left = 0
          Top = 13
          Width = 159
          Height = 144
          Hint = 'Select problem category'
          TabStop = False
          Align = alClient
          ExtendedSelect = False
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstCatPickClick
          OnExit = lstViewExit
          OnMouseMove = FormMouseMove
          Caption = 'Problem categories'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
        end
      end
      object pnlProbs: TPanel
        Left = 0
        Top = 160
        Width = 159
        Height = 144
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblProblems: TLabel
          Left = 0
          Top = 0
          Width = 159
          Height = 13
          Align = alTop
          AutoSize = False
          Caption = 'Problems'
          Constraints.MaxHeight = 16
          Constraints.MinHeight = 13
        end
        object lstProbPick: TORListBox
          Left = 0
          Top = 13
          Width = 159
          Height = 131
          Hint = 'Select problem to add'
          Align = alClient
          Ctl3D = False
          ExtendedSelect = False
          ItemHeight = 13
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = lstProbPickClick
          OnDblClick = lstProbPickDblClick
          Caption = 'Problems'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2,3'
        end
      end
    end
  end
  inherited pnlRight: TPanel
    Left = 161
    Width = 470
    Height = 350
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Constraints.MinWidth = 30
    OnExit = pnlRightExit
    OnResize = pnlRightResize
    ExplicitLeft = 161
    ExplicitWidth = 470
    ExplicitHeight = 350
    object lblProbList: TOROffsetLabel
      Left = 0
      Top = 0
      Width = 470
      Height = 19
      Align = alTop
      Caption = 'Active Problems List'
      HorzOffset = 2
      Transparent = False
      VertOffset = 6
      WordWrap = False
    end
    object pnlProbDlg: TPanel
      Left = 0
      Top = 36
      Width = 470
      Height = 314
      Align = alClient
      TabOrder = 0
      Visible = False
      OnMouseMove = FormMouseMove
    end
    object wgProbData: TCaptionListBox
      Left = 0
      Top = 36
      Width = 470
      Height = 314
      Style = lbOwnerDrawVariable
      Align = alClient
      Color = clCream
      ItemHeight = 13
      MultiSelect = True
      ParentShowHint = False
      PopupMenu = popProb
      ShowHint = True
      TabOrder = 1
      OnClick = wgProbDataClick
      OnDblClick = wgProbDataDblClick
      OnDrawItem = wgProbDataDrawItem
      OnMeasureItem = wgProbDataMeasureItem
      OnMouseMove = FormMouseMove
      Caption = 'Active Problems List'
    end
    object HeaderControl: THeaderControl
      Left = 0
      Top = 19
      Width = 470
      Height = 17
      Sections = <
        item
          ImageIndex = -1
          Text = 'Column 0'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Stat/Ver'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 20
          Text = 'Description'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Onset Date'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 16
          Text = 'Last Updated'
          Width = 80
        end
        item
          ImageIndex = -1
          Text = 'Column 5'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Location'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Provider'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Service'
          Width = 65
        end
        item
          ImageIndex = -1
          Text = 'Column 9'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 10'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 11'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column12'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 13'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Column 14'
          Width = 0
        end
        item
          ImageIndex = -1
          Text = 'Inactive Flag'
          Width = 0
        end>
      OnSectionClick = HeaderControlSectionClick
      OnSectionResize = HeaderControlSectionResize
      OnMouseDown = HeaderControlMouseDown
      OnMouseUp = HeaderControlMouseUp
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = bbOtherProb'
        'Status = stsDefault')
      (
        'Component = bbCancel'
        'Status = stsDefault')
      (
        'Component = pnlView'
        'Status = stsDefault')
      (
        'Component = lstView'
        'Status = stsDefault')
      (
        'Component = bbNewProb'
        'Status = stsDefault')
      (
        'Component = pnlProbEnt'
        'Status = stsDefault')
      (
        'Component = edProbEnt'
        'Status = stsDefault')
      (
        'Component = pnlProbList'
        'Status = stsDefault')
      (
        'Component = pnlProbCats'
        'Status = stsDefault')
      (
        'Component = lstCatPick'
        'Status = stsDefault')
      (
        'Component = pnlProbs'
        'Status = stsDefault')
      (
        'Component = lstProbPick'
        'Status = stsDefault')
      (
        'Component = pnlProbDlg'
        'Status = stsDefault')
      (
        'Component = wgProbData'
        'Status = stsDefault')
      (
        'Component = HeaderControl'
        'Status = stsDefault')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = frmProblems'
        'Status = stsDefault'))
  end
  object popProb: TPopupMenu
    Left = 282
    Top = 313
    object popChange: TMenuItem
      Tag = 400
      Caption = '&Change...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popInactivate: TMenuItem
      Tag = 200
      Caption = '&Inactivate'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popVerify: TMenuItem
      Tag = 250
      Caption = '&Verify...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N36: TMenuItem
      Caption = '-'
      Enabled = False
    end
    object popAnnotate: TMenuItem
      Tag = 600
      Caption = '&Annotate...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N37: TMenuItem
      Caption = '-'
      Enabled = False
      Visible = False
    end
    object popRemove: TMenuItem
      Tag = 500
      Caption = '&Remove...'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object popRestore: TMenuItem
      Tag = 550
      Caption = 'Re&store'
      Enabled = False
      OnClick = lstProbActsClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object popViewDetails: TMenuItem
      Tag = 300
      Caption = 'View Details'
      OnClick = lstProbActsClick
    end
    object mnuOptimizeFields: TMenuItem
      Caption = 'Adjust Column Size'
      Visible = False
      OnClick = mnuOptimizeFieldsClick
    end
  end
  object mnuProbs: TMainMenu
    Left = 243
    Top = 313
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
        Tag = 700
        Caption = '&Active Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewInactive: TMenuItem
        Tag = 800
        Caption = '&Inactive Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewBoth: TMenuItem
        Tag = 900
        Caption = '&Both Active/Inactive Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewRemoved: TMenuItem
        Tag = 950
        Caption = '&Removed Problems'
        OnClick = lstProbActsClick
      end
      object mnuViewFilters: TMenuItem
        Tag = 975
        Caption = 'Fi&lters...'
        OnClick = lstProbActsClick
      end
      object mnuViewComments: TMenuItem
        Caption = 'Show &Comments'
        OnClick = mnuViewCommentsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuViewSave: TMenuItem
        Caption = 'Sa&ve as Default View'
        OnClick = mnuViewSaveClick
      end
      object mnuViewRestoreDefault: TMenuItem
        Caption = 'Return to De&fault View'
        OnClick = mnuViewRestoreDefaultClick
      end
    end
    object mnuAct: TMenuItem
      Caption = '&Action'
      GroupIndex = 4
      object mnuActNew: TMenuItem
        Tag = 100
        Caption = '&New Problem...'
        OnClick = lstProbActsClick
      end
      object Z3: TMenuItem
        Caption = '-'
      end
      object mnuActChange: TMenuItem
        Tag = 400
        Caption = '&Change...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActInactivate: TMenuItem
        Tag = 200
        Caption = '&Inactivate'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActVerify: TMenuItem
        Tag = 250
        Caption = '&Verify...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuActAnnotate: TMenuItem
        Tag = 600
        Caption = '&Annotate...'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object Z4: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuActRemove: TMenuItem
        Tag = 500
        Caption = '&Remove'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object mnuActRestore: TMenuItem
        Tag = 550
        Caption = 'Re&store'
        Enabled = False
        OnClick = lstProbActsClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuActDetails: TMenuItem
        Tag = 300
        Caption = 'View &Details'
        Enabled = False
        OnClick = lstProbActsClick
      end
    end
  end
end
