object frmEncounter: TfrmEncounter
  Left = 435
  Top = 175
  Width = 351
  Height = 350
  BorderIcons = [biSystemMenu]
  Caption = 'Provider & Location for Current Activities'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    343
    323)
  PixelsPerInch = 96
  TextHeight = 13
  object lblInstruct: TLabel
    Left = 6
    Top = 6
    Width = 253
    Height = 31
    AutoSize = False
    Caption = 
      'Select the appointment or visit that should be associated with t' +
      'he note or orders .'
    Visible = False
    WordWrap = True
  end
  object lblLocation: TLabel
    Tag = 9
    Left = 6
    Top = 133
    Width = 93
    Height = 13
    Caption = 'Encounter Location'
  end
  object lblProvider: TLabel
    Left = 6
    Top = 6
    Width = 91
    Height = 13
    Caption = 'Encounter Provider'
  end
  object cmdOK: TButton
    Left = 250
    Top = 20
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 250
    Top = 49
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cmdCancelClick
  end
  object txtLocation: TCaptionEdit
    Tag = 9
    Left = 6
    Top = 147
    Width = 212
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
    Text = '< Select a location from the tabs below.... >'
    Caption = 'Encounter Location'
  end
  object pgeVisit: TPageControl
    Tag = 9
    Left = 6
    Top = 171
    Width = 331
    Height = 147
    ActivePage = tabClinic
    Anchors = [akLeft, akTop, akBottom]
    TabIndex = 0
    TabOrder = 2
    OnChange = pgeVisitChange
    object tabClinic: TTabSheet
      Caption = 'Clinic Appointments'
      DesignSize = (
        323
        119)
      object lblClinic: TLabel
        Left = 4
        Top = 4
        Width = 127
        Height = 13
        Caption = 'Clinic Appointments / Visits'
      end
      object lblDateRange: TLabel
        Left = 138
        Top = 4
        Width = 71
        Height = 13
        Caption = '(T-30 thru T+1)'
      end
      object lstClinic: TORListBox
        Left = 0
        Top = 18
        Width = 321
        Height = 97
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = cmdOKClick
        Caption = 'Clinic Appointments / Visits (T-30 thru T+1)'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3,2,4'
        TabPositions = '20'
        OnChange = lstClinicChange
      end
    end
    object tabAdmit: TTabSheet
      Caption = 'Hospital Admissions'
      object lblAdmit: TLabel
        Left = 4
        Top = 4
        Width = 93
        Height = 13
        Caption = 'Hospital Admissions'
      end
      object lstAdmit: TORListBox
        Left = 4
        Top = 18
        Width = 352
        Height = 117
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnDblClick = cmdOKClick
        Caption = 'Hospital Admissions'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3,5,4'
        TabPositions = '20'
        OnChange = lstAdmitChange
      end
    end
    object tabNewVisit: TTabSheet
      Caption = 'New Visit'
      object lblVisitDate: TLabel
        Left = 220
        Top = 4
        Width = 85
        Height = 13
        Caption = 'Date/Time of Visit'
        Visible = False
      end
      object lblNewVisit: TLabel
        Left = 4
        Top = 4
        Width = 63
        Height = 13
        Caption = 'Visit Location'
      end
      object calVisitDate: TORDateBox
        Left = 220
        Top = 18
        Width = 140
        Height = 21
        TabOrder = 1
        Text = 'NOW'
        OnChange = calVisitDateChange
        OnExit = calVisitDateExit
        DateOnly = False
        RequireTime = True
      end
      object ckbHistorical: TORCheckBox
        Left = 220
        Top = 50
        Width = 140
        Height = 81
        Caption = 
          'Historical Visit: a visit that occurred at some time in the past' +
          ' or at some other location (possibly non-VA) but is not used for' +
          ' workload credit.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = ckbHistoricalClick
        WordWrap = True
        AutoSize = True
      end
      object cboNewVisit: TORComboBox
        Left = 4
        Top = 18
        Width = 208
        Height = 117
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Visit Location'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        OnChange = cboNewVisitChange
        OnDblClick = cmdOKClick
        OnNeedData = cboNewVisitNeedData
        CharsNeedMatch = 1
      end
    end
  end
  object cmdDateRange: TButton
    Tag = 9
    Left = 224
    Top = 145
    Width = 90
    Height = 21
    Caption = 'Date Range...'
    TabOrder = 3
    OnClick = cmdDateRangeClick
  end
  object cboPtProvider: TORComboBox
    Left = 6
    Top = 20
    Width = 235
    Height = 93
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Encounter Provider'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 2
    MaxLength = 0
    Pieces = '2,3'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 0
    OnDblClick = cmdOKClick
    OnNeedData = cboPtProviderNeedData
    CharsNeedMatch = 1
  end
  object dlgDateRange: TORDateRangeDlg
    DateOnly = True
    Instruction = 'Show appointments / visits in the date range:'
    LabelStart = 'From'
    LabelStop = 'Through'
    RequireTime = False
    Format = 'mmm d,yyyy'
    Left = 264
    Top = 4
  end
end
