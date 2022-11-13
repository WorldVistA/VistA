inherited frmPtSelOptns: TfrmPtSelOptns
  Left = 200
  Top = 190
  BorderStyle = bsNone
  Caption = 'frmPtSelOptns'
  ClientHeight = 288
  ClientWidth = 191
  DefaultMonitor = dmDesktop
  Position = poDesigned
  ExplicitWidth = 191
  ExplicitHeight = 288
  PixelsPerInch = 96
  TextHeight = 13
  object orapnlMain: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 191
    Height = 288
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    OnResize = orapnlMainResize
    DesignSize = (
      191
      288)
    object lblPtList: TLabel
      Left = 4
      Top = 1
      Width = 52
      Height = 13
      Caption = 'Patient List'
    end
    object lblDateRange: TLabel
      Left = 4
      Top = 244
      Width = 98
      Height = 13
      Caption = 'List Appointments for'
    end
    object lbHistory: TListBox
      Left = 4
      Top = 118
      Width = 184
      Height = 167
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBtnFace
      ItemHeight = 13
      TabOrder = 3
      OnClick = lbHistoryClick
      OnDblClick = lbHistoryDblClick
    end
    object bvlPtList: TORAutoPanel
      Left = 4
      Top = 20
      Width = 184
      Height = 94
      BevelOuter = bvLowered
      TabOrder = 0
      DesignSize = (
        184
        94)
      object radAll: TRadioButton
        Tag = 19
        Left = 116
        Top = 75
        Width = 60
        Height = 17
        Caption = '&All'
        TabOrder = 8
        OnClick = radHideSrcClick
      end
      object radWards: TRadioButton
        Tag = 17
        Left = 116
        Top = 39
        Width = 60
        Height = 17
        Caption = '&Wards'
        TabOrder = 6
        OnClick = radShowSrcClick
      end
      object radClinics: TRadioButton
        Tag = 16
        Left = 116
        Top = 21
        Width = 60
        Height = 17
        Caption = '&Clinics'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
        OnClick = radLongSrcClick
      end
      object radSpecialties: TRadioButton
        Tag = 14
        Left = 5
        Top = 58
        Width = 109
        Height = 17
        Caption = '&Specialties'
        TabOrder = 3
        OnClick = radShowSrcClick
      end
      object radTeams: TRadioButton
        Tag = 13
        Left = 5
        Top = 39
        Width = 109
        Height = 17
        Caption = '&Team/Personal'
        TabOrder = 2
        OnClick = radShowSrcClick
      end
      object radProviders: TRadioButton
        Tag = 12
        Left = 5
        Top = 21
        Width = 76
        Height = 17
        Caption = '&Providers'
        TabOrder = 1
        OnClick = radLongSrcClick
      end
      object radDflt: TRadioButton
        Tag = 11
        Left = 5
        Top = 3
        Width = 171
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'No &Default'
        TabOrder = 0
        OnClick = radHideSrcClick
      end
      object radPcmmTeams: TRadioButton
        Tag = 18
        Left = 116
        Top = 57
        Width = 60
        Height = 17
        Caption = 'PC&MM'
        TabOrder = 7
        OnClick = radShowSrcClick
      end
      object radHistory: TRadioButton
        Tag = 20
        Left = 5
        Top = 75
        Width = 76
        Height = 17
        Caption = '&History'
        DoubleBuffered = False
        ParentDoubleBuffered = False
        TabOrder = 4
        Visible = False
        OnClick = radHistoryClick
      end
    end
    object cboList: TORComboBox
      Left = 4
      Top = 116
      Width = 184
      Height = 122
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Patient List'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnChange = cboListChange
      OnEnter = cboListEnter
      OnExit = cboListExit
      OnKeyDown = cboListKeyDown
      OnKeyPause = cboListKeyPause
      OnMouseClick = cboListMouseClick
      OnNeedData = cboListNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboDateRange: TORComboBox
      Left = 4
      Top = 259
      Width = 180
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'List Appointments for'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      OnChange = cboDateRangeChange
      OnExit = cboDateRangeExit
      OnMouseClick = cboDateRangeMouseClick
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 136
    Top = 176
    Data = (
      (
        'Component = orapnlMain'
        'Status = stsDefault')
      (
        'Component = bvlPtList'
        'Status = stsDefault')
      (
        'Component = radAll'
        'Text = Patient List All'
        'Status = stsOK')
      (
        'Component = radWards'
        'Text = Patient List Wards'
        'Status = stsOK')
      (
        'Component = radClinics'
        'Text = Patient List Clinics'
        'Status = stsOK')
      (
        'Component = radSpecialties'
        'Text = Patient List Specialties'
        'Status = stsOK')
      (
        'Component = radTeams'
        'Text = Patient List Team/Personal'
        'Status = stsOK')
      (
        'Component = radProviders'
        'Text = Patient List Providers'
        'Status = stsOK')
      (
        'Component = radDflt'
        'Text = Patient List No Default'
        'Status = stsOK')
      (
        'Component = cboList'
        'Text = To select a provider use the arrow keys, then press enter'
        'Status = stsOK')
      (
        'Component = cboDateRange'
        'Status = stsDefault')
      (
        'Component = frmPtSelOptns'
        'Status = stsDefault')
      (
        'Component = radPcmmTeams'
        'Status = stsDefault')
      (
        'Component = radHistory'
        'Status = stsDefault')
      (
        'Component = lbHistory'
        'Status = stsDefault'))
  end
  object calApptRng: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Enter a date range -'
    LabelStart = 'First Appointment Date'
    LabelStop = 'Last Appointment Date'
    RequireTime = False
    Format = 'mmm d,yy'
    Left = 24
    Top = 176
  end
end
