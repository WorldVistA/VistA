object fraPtSelOptns: TfraPtSelOptns
  Left = 0
  Top = 0
  Width = 228
  Height = 415
  TabOrder = 0
  object gpMain: TGridPanel
    Left = 0
    Top = 0
    Width = 228
    Height = 415
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblPtList
        Row = 0
      end
      item
        Column = 0
        Control = pnlRad
        Row = 1
      end
      item
        Column = 0
        Control = cboList
        Row = 2
      end
      item
        Column = 0
        Control = lblDateRange
        Row = 3
      end
      item
        Column = 0
        Control = cboDateRange
        Row = 4
      end
      item
        Column = 0
        Control = lbHistory
        Row = 5
      end>
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 105.000000000000000000
      end
      item
        Value = 49.999427793227360000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 21.000000000000000000
      end
      item
        Value = 50.000572206772640000
      end>
    TabOrder = 0
    object lblPtList: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 222
      Height = 15
      Align = alClient
      Caption = 'Patient List'
      Layout = tlCenter
      ExplicitWidth = 53
      ExplicitHeight = 13
    end
    object pnlRad: TPanel
      Left = 0
      Top = 21
      Width = 228
      Height = 105
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 0
      object gpRad: TGridPanel
        Left = 1
        Top = 1
        Width = 226
        Height = 103
        Align = alClient
        Caption = 'Patient List'
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
            Control = radDflt
            Row = 0
          end
          item
            Column = 0
            Control = radProviders
            Row = 1
          end
          item
            Column = 1
            Control = radClinics
            Row = 1
          end
          item
            Column = 0
            Control = radTeams
            Row = 2
          end
          item
            Column = 1
            Control = radWards
            Row = 2
          end
          item
            Column = 0
            Control = radSpecialties
            Row = 3
          end
          item
            Column = 1
            Control = radPcmmTeams
            Row = 3
          end
          item
            Column = 0
            Control = radHistory
            Row = 4
          end
          item
            Column = 1
            Control = radAll
            Row = 4
          end>
        RowCollection = <
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end>
        ShowCaption = False  
        TabOrder = 0
        object radDflt: TRadioButton
          Tag = 11
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 218
          Height = 14
          Align = alClient
          Caption = 'No &Default'
          TabOrder = 0
          OnClick = radHideSrcClick
        end
        object radProviders: TRadioButton
          Tag = 12
          AlignWithMargins = True
          Left = 4
          Top = 24
          Width = 106
          Height = 14
          Align = alClient
          Caption = '&Providers'
          TabOrder = 1
          OnClick = radLongSrcClick
        end
        object radClinics: TRadioButton
          Tag = 16
          AlignWithMargins = True
          Left = 116
          Top = 24
          Width = 106
          Height = 14
          Align = alClient
          Caption = '&Clinics'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 5
          OnClick = radLongSrcClick
        end
        object radTeams: TRadioButton
          Tag = 13
          AlignWithMargins = True
          Left = 4
          Top = 44
          Width = 106
          Height = 15
          Align = alClient
          Caption = '&Team/Personal'
          TabOrder = 2
          OnClick = radShowSrcClick
        end
        object radWards: TRadioButton
          Tag = 17
          AlignWithMargins = True
          Left = 116
          Top = 44
          Width = 106
          Height = 15
          Align = alClient
          Caption = '&Wards'
          TabOrder = 6
          OnClick = radShowSrcClick
        end
        object radSpecialties: TRadioButton
          Tag = 14
          AlignWithMargins = True
          Left = 4
          Top = 65
          Width = 106
          Height = 14
          Align = alClient
          Caption = '&Specialties'
          TabOrder = 3
          OnClick = radShowSrcClick
        end
        object radPcmmTeams: TRadioButton
          Tag = 18
          AlignWithMargins = True
          Left = 116
          Top = 65
          Width = 106
          Height = 14
          Align = alClient
          Caption = 'PC&MM'
          TabOrder = 7
          OnClick = radShowSrcClick
        end
        object radHistory: TRadioButton
          Tag = 20
          AlignWithMargins = True
          Left = 4
          Top = 85
          Width = 106
          Height = 14
          Align = alClient
          Caption = '&History'
          DoubleBuffered = False
          ParentDoubleBuffered = False
          TabOrder = 4
          Visible = False
          OnClick = radHistoryClick
        end
        object radAll: TRadioButton
          Tag = 19
          AlignWithMargins = True
          Left = 116
          Top = 85
          Width = 106
          Height = 14
          Align = alClient
          Caption = '&All'
          TabOrder = 8
          OnClick = radHideSrcClick
        end
      end
    end
    object cboList: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 129
      Width = 222
      Height = 112
      Style = orcsSimple
      Align = alClient
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
    object lblDateRange: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 247
      Width = 222
      Height = 25
      Align = alClient
      Caption = 'List Appointments for'
      Layout = tlBottom
      ExplicitWidth = 102
      ExplicitHeight = 13
    end
    object cboDateRange: TORComboBox
      AlignWithMargins = True
      Left = 3
      Top = 278
      Width = 222
      Height = 21
      Style = orcsDropDown
      Align = alClient
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
    object lbHistory: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 299
      Width = 222
      Height = 113
      Align = alClient
      Color = clBtnFace
      ItemHeight = 13
      TabOrder = 3
      OnClick = lbHistoryClick
      OnDblClick = lbHistoryDblClick
    end
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
