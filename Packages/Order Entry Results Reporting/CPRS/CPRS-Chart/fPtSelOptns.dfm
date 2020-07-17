inherited frmPtSelOptns: TfrmPtSelOptns
  Left = 200
  Top = 190
  BorderStyle = bsNone
  Caption = 'frmPtSelOptns'
  ClientHeight = 279
  ClientWidth = 190
  DefaultMonitor = dmDesktop
  Position = poDesigned
  OnCreate = FormCreate
  ExplicitWidth = 190
  ExplicitHeight = 279
  PixelsPerInch = 96
  TextHeight = 13
  object orapnlMain: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 190
    Height = 279
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblPtList: TLabel
      Left = 4
      Top = 1
      Width = 52
      Height = 13
      Caption = 'Patient List'
    end
    object lblDateRange: TLabel
      Left = 4
      Top = 240
      Width = 98
      Height = 13
      Caption = 'List Appointments for'
    end
    object bvlPtList: TORAutoPanel
      Left = 4
      Top = 24
      Width = 180
      Height = 96
      BevelOuter = bvLowered
      TabOrder = 0
      object radAll: TRadioButton
        Tag = 19
        Left = 1
        Top = 75
        Width = 60
        Height = 17
        Caption = '&All'
        TabOrder = 7
        OnClick = radHideSrcClick
      end
      object radWards: TRadioButton
        Tag = 17
        Left = 116
        Top = 39
        Width = 60
        Height = 17
        Caption = '&Wards'
        TabOrder = 5
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
        TabOrder = 4
        OnClick = radLongSrcClick
      end
      object radSpecialties: TRadioButton
        Tag = 14
        Left = 1
        Top = 57
        Width = 109
        Height = 17
        Caption = '&Specialties'
        TabOrder = 3
        OnClick = radShowSrcClick
      end
      object radTeams: TRadioButton
        Tag = 13
        Left = 1
        Top = 39
        Width = 109
        Height = 17
        Caption = '&Team/Personal'
        TabOrder = 2
        OnClick = radShowSrcClick
      end
      object radProviders: TRadioButton
        Tag = 12
        Left = 1
        Top = 21
        Width = 115
        Height = 17
        Caption = '&Providers'
        TabOrder = 1
        OnClick = radLongSrcClick
      end
      object radDflt: TRadioButton
        Tag = 11
        Left = 1
        Top = 3
        Width = 162
        Height = 17
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
        TabOrder = 6
        OnClick = radShowSrcClick
      end
    end
    object cboList: TORComboBox
      Left = 4
      Top = 121
      Width = 169
      Height = 116
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
      OnExit = cboListExit
      OnKeyPause = cboListKeyPause
      OnMouseClick = cboListMouseClick
      OnNeedData = cboListNeedData
      CharsNeedMatch = 1
    end
    object cboDateRange: TORComboBox
      Left = 4
      Top = 254
      Width = 169
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
      OnExit = cboDateRangeExit
      OnMouseClick = cboDateRangeMouseClick
      CharsNeedMatch = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 128
    Top = 192
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
        'Status = stsDefault')
      (
        'Component = cboDateRange'
        'Status = stsDefault')
      (
        'Component = frmPtSelOptns'
        'Status = stsDefault')
      (
        'Component = radPcmmTeams'
        'Text = Patient List PCMM Teams'
        'Status = stsOK'))
  end
  object calApptRng: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Enter a date range -'
    LabelStart = 'First Appointment Date'
    LabelStop = 'Last Appointment Date'
    RequireTime = False
    Format = 'mmm d,yy'
    Left = 72
    Top = 128
  end
end
