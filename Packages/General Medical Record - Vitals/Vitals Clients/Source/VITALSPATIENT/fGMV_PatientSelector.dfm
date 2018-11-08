object frmGMV_PatientSelector: TfrmGMV_PatientSelector
  Left = 294
  Top = 248
  Align = alBottom
  Caption = 'PatientSelector'
  ClientHeight = 593
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object pnlStatus: TPanel
    Left = 0
    Top = 554
    Width = 468
    Height = 39
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    DesignSize = (
      468
      39)
    object lblSelected: TLabel
      Left = 16
      Top = 16
      Width = 42
      Height = 13
      Caption = 'Selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 308
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 388
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pcMain: TPageControl
    Left = 0
    Top = 55
    Width = 468
    Height = 404
    ActivePage = tsUnit
    Align = alClient
    Constraints.MinHeight = 100
    Style = tsButtons
    TabOrder = 2
    TabStop = False
    OnChange = pcMainChange
    OnEnter = cmbUnitEnter
    OnExit = cmbUnitExit
    OnMouseUp = pcMainMouseUp
    object tsUnit: TTabSheet
      Caption = '   &Unit     '
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 165
        Width = 460
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
        ExplicitWidth = 468
      end
      object Panel3: TPanel
        Left = 0
        Top = 169
        Width = 460
        Height = 204
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        TabOrder = 1
        object lvUnitPatients: TListView
          Left = 2
          Top = 25
          Width = 456
          Height = 117
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel16: TPanel
          Left = 2
          Top = 142
          Width = 456
          Height = 60
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 2
          Visible = False
        end
        object Panel11: TPanel
          Left = 2
          Top = 2
          Width = 456
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel2: TBevel
            Left = 0
            Top = 11
            Width = 456
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 464
          end
          object Label14: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvUnitPatients
            Transparent = False
          end
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 165
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel17: TPanel
          Left = 0
          Top = 23
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            460
            23)
          object cmbUnit: TComboBox
            Left = 1
            Top = 1
            Width = 459
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbUnits: TListBox
          Left = 0
          Top = 46
          Width = 460
          Height = 119
          Align = alClient
          Color = clInfoBk
          ItemHeight = 13
          TabOrder = 2
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = lbUnitsKeyDown
        end
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel7: TBevel
            Left = 0
            Top = 11
            Width = 460
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 468
          end
          object Label15: TLabel
            Left = 8
            Top = 4
            Width = 91
            Height = 13
            Caption = 'Select Nursing &Unit'
            Transparent = False
          end
        end
      end
    end
    object tsWard: TTabSheet
      Caption = '  &Ward  '
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter2: TSplitter
        Left = 0
        Top = 165
        Width = 460
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
        ExplicitWidth = 468
      end
      object Panel1: TPanel
        Left = 0
        Top = 169
        Width = 460
        Height = 204
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        TabOrder = 1
        object lvWardPatients: TListView
          Left = 2
          Top = 25
          Width = 456
          Height = 133
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel15: TPanel
          Left = 2
          Top = 158
          Width = 456
          Height = 44
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 2
          Visible = False
        end
        object Panel19: TPanel
          Left = 2
          Top = 2
          Width = 456
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel8: TBevel
            Left = 0
            Top = 11
            Width = 456
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 464
          end
          object Label16: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvWardPatients
            Transparent = False
          end
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 165
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel20: TPanel
          Left = 0
          Top = 23
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            460
            23)
          object cmbWard: TComboBox
            Left = 1
            Top = 1
            Width = 459
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbWards: TListBox
          Left = 0
          Top = 46
          Width = 460
          Height = 119
          Align = alClient
          Color = clInfoBk
          ItemHeight = 13
          TabOrder = 2
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = lbUnitsKeyDown
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel9: TBevel
            Left = 0
            Top = 11
            Width = 460
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 468
          end
          object Label17: TLabel
            Left = 8
            Top = 4
            Width = 59
            Height = 13
            Caption = 'Select Ward'
            Transparent = False
          end
        end
      end
    end
    object tsTeam: TTabSheet
      Caption = '&Team'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter3: TSplitter
        Left = 0
        Top = 101
        Width = 460
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
        ExplicitWidth = 468
      end
      object Panel2: TPanel
        Left = 0
        Top = 105
        Width = 460
        Height = 268
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        TabOrder = 1
        object lvTeampatients: TListView
          Left = 2
          Top = 25
          Width = 456
          Height = 181
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel14: TPanel
          Left = 2
          Top = 206
          Width = 456
          Height = 60
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 2
          Visible = False
        end
        object Panel23: TPanel
          Left = 2
          Top = 2
          Width = 456
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel11: TBevel
            Left = 0
            Top = 11
            Width = 456
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 464
          end
          object Label19: TLabel
            Left = 8
            Top = 4
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            Enabled = False
            FocusControl = lvTeampatients
            Transparent = False
          end
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 101
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel24: TPanel
          Left = 0
          Top = 23
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            460
            23)
          object cmbTeam: TComboBox
            Left = 1
            Top = 1
            Width = 459
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            TabOrder = 0
            OnChange = cmbUnitChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyDown = cmbUnitKeyDown
            OnKeyPress = lvUnitPatientsKeyPress
          end
        end
        object lbTeams: TListBox
          Left = 0
          Top = 46
          Width = 460
          Height = 55
          Align = alClient
          Color = clInfoBk
          ItemHeight = 13
          TabOrder = 2
          OnClick = lbUnitsClick
          OnDblClick = lbUnitsDblClick
          OnEnter = lbUnitsEnter
          OnExit = lbUnitsExit
          OnKeyDown = cmbUnitKeyDown
        end
        object Panel25: TPanel
          Left = 0
          Top = 0
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Bevel12: TBevel
            Left = 0
            Top = 11
            Width = 460
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 468
          end
          object Label20: TLabel
            Left = 8
            Top = 4
            Width = 60
            Height = 13
            Caption = 'Select Team'
            Enabled = False
            Transparent = False
          end
        end
      end
    end
    object tsClinic: TTabSheet
      Caption = '&Clinic'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter4: TSplitter
        Left = 0
        Top = 121
        Width = 460
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
        ExplicitWidth = 468
      end
      object Panel4: TPanel
        Left = 0
        Top = 125
        Width = 460
        Height = 248
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'Panel1'
        Constraints.MinHeight = 120
        TabOrder = 1
        object lvClinicPatients: TListView
          Left = 2
          Top = 65
          Width = 456
          Height = 129
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 65
            end
            item
              Caption = 'Appt Dt'
              Width = 85
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvUnitPatientsKeyPress
        end
        object Panel13: TPanel
          Left = 2
          Top = 194
          Width = 456
          Height = 52
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 2
          Visible = False
          OnClick = lvUnitPatientsClick
        end
        object Panel26: TPanel
          Left = 2
          Top = 2
          Width = 456
          Height = 63
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            456
            63)
          object Bevel13: TBevel
            Left = 0
            Top = 51
            Width = 456
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 464
          end
          object Label21: TLabel
            Left = 8
            Top = 44
            Width = 52
            Height = 13
            Caption = 'Patient L&ist'
            FocusControl = lvClinicPatients
            Transparent = True
          end
          object Bevel15: TBevel
            Left = 0
            Top = 0
            Width = 456
            Height = 12
            Align = alTop
            Shape = bsBottomLine
            ExplicitWidth = 464
          end
          object Label23: TLabel
            Left = 10
            Top = 5
            Width = 160
            Height = 13
            Caption = 'Select Clinic Appointment  Date(s)'
            Transparent = False
          end
          object cmbPeriod: TComboBox
            Left = 0
            Top = 21
            Width = 462
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            TabOrder = 0
            OnEnter = cmbPeriodEnter
            OnExit = cmbPeriodExit
            OnKeyDown = lbUnitsKeyDown
            Items.Strings = (
              'Today'
              'Tomorrow'
              'Yesterday'
              'Past Week'
              'Past Month')
          end
        end
      end
      object pnlClinic: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 121
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Panel27: TPanel
          Left = 0
          Top = 23
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            460
            23)
          object cmbClinic: TComboBox
            Left = 1
            Top = 1
            Width = 461
            Height = 21
            Style = csSimple
            Anchors = [akLeft, akTop, akRight]
            Color = clInfoBk
            TabOrder = 0
            OnChange = cmbAllChange
            OnEnter = cmbUnitEnter
            OnExit = cmbUnitExit
            OnKeyPress = cmbClinicKeyPress
          end
        end
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 460
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            460
            23)
          object Bevel14: TBevel
            Left = 0
            Top = 11
            Width = 460
            Height = 12
            Align = alBottom
            Shape = bsTopLine
            ExplicitWidth = 468
          end
          object Label22: TLabel
            Left = 8
            Top = 4
            Width = 58
            Height = 13
            Caption = 'Select Clinic'
            Transparent = False
          end
          object lblLoadStatus: TLabel
            Left = 392
            Top = 4
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'lblLoadStatus'
            Visible = False
            ExplicitLeft = 400
          end
        end
        object pnlClinics: TPanel
          Left = 0
          Top = 46
          Width = 460
          Height = 75
          Align = alClient
          BevelOuter = bvNone
          Caption = 'pnlClinics'
          TabOrder = 2
          object sbClinics: TScrollBar
            Left = 444
            Top = 0
            Width = 16
            Height = 75
            Align = alRight
            Ctl3D = False
            Kind = sbVertical
            PageSize = 0
            ParentCtl3D = False
            TabOrder = 1
            TabStop = False
            Visible = False
            OnChange = sbClinicsChange
            OnScroll = sbClinicsScroll
          end
          object lbClinics0: TListBox
            Left = 0
            Top = 0
            Width = 444
            Height = 69
            Style = lbOwnerDrawFixed
            Align = alClient
            Color = clInfoBk
            Ctl3D = True
            IntegralHeight = True
            ItemHeight = 13
            ParentCtl3D = False
            Sorted = True
            TabOrder = 0
            Visible = False
            OnClick = lbUnitsClick
            OnDblClick = lbUnitsDblClick
            OnEnter = lbUnitsEnter
            OnExit = lbUnitsExit
            OnKeyDown = lbClinics0KeyDown
            OnMouseDown = lbClinics0MouseDown
            OnMouseUp = lbClinics0MouseUp
          end
        end
      end
    end
    object tsAll: TTabSheet
      Caption = '   &All  '
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel5: TPanel
        Left = 0
        Top = 45
        Width = 460
        Height = 328
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 1
        Caption = 'Panel1'
        TabOrder = 2
        object lvAllPatients: TListView
          Left = 1
          Top = 1
          Width = 458
          Height = 227
          Hint = 
            'To select a Patient, highlight the name and press "Enter" or  do' +
            'uble click the patient name.'
          Align = alClient
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Name'
              Width = 120
            end
            item
              Caption = 'SSN'
              MinWidth = 40
              Width = 80
            end
            item
              Caption = 'DOB'
              MinWidth = 40
              Width = 80
            end>
          HideSelection = False
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          SortType = stText
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
          OnChange = lvUnitPatientsChange
          OnClick = lvUnitPatientsClick
          OnDblClick = lvUnitPatientsDblClick
          OnEnter = lvUnitPatientsEnter
          OnExit = lvUnitPatientsExit
          OnKeyPress = lvAllPatientsKeyPress
        end
        object Panel12: TPanel
          Left = 1
          Top = 228
          Width = 458
          Height = 99
          Align = alBottom
          BevelOuter = bvLowered
          Color = clInfoBk
          TabOrder = 1
          Visible = False
        end
      end
      object Panel22: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 23
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Bevel10: TBevel
          Left = 0
          Top = 11
          Width = 460
          Height = 12
          Align = alBottom
          Shape = bsTopLine
          ExplicitWidth = 468
        end
        object Label18: TLabel
          Left = 8
          Top = 4
          Width = 187
          Height = 13
          Caption = 'Patient Name (Last, First or Last 4 SSN)'
          Transparent = False
        end
      end
      object Panel9: TPanel
        Left = 0
        Top = 23
        Width = 460
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          460
          22)
        object cmbAll: TComboBox
          Left = 1
          Top = 1
          Width = 459
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = clInfoBk
          TabOrder = 0
          OnChange = cmbAllChange
          OnEnter = cmbUnitEnter
          OnExit = cmbUnitExit
          OnKeyPress = cmbAllKeyPress
        end
      end
    end
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 49
    Width = 468
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      468
      6)
    object Bevel1: TBevel
      Left = 4
      Top = 5
      Width = 465
      Height = 6
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
      Visible = False
    end
    object Label2: TLabel
      Left = 12
      Top = -1
      Width = 89
      Height = 13
      Caption = 'Patient Groups List'
      Visible = False
    end
  end
  object pnlInfo: TPanel
    Left = 0
    Top = 459
    Width = 468
    Height = 95
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    DesignSize = (
      468
      95)
    object lblPatientName: TLabel
      Left = 184
      Top = 59
      Width = 86
      Height = 13
      Caption = 'lblPatientName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 112
      Top = 74
      Width = 63
      Height = 13
      Caption = 'Location / ID'
    end
    object lblPatientLocationID: TLabel
      Left = 184
      Top = 75
      Width = 116
      Height = 13
      Caption = 'lblPatientLocationID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 16
      Top = 66
      Width = 97
      Height = 13
      Caption = 'Selected Patient List'
      Visible = False
    end
    object Label1: TLabel
      Left = 133
      Top = 58
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Focused:'
    end
    object lblSelectStatus: TLabel
      Left = 16
      Top = 74
      Width = 86
      Height = 13
      Caption = 'lblSelectStatus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object mmList: TMemo
      Left = 320
      Top = 63
      Width = 146
      Height = 26
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      Ctl3D = False
      ParentCtl3D = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      Visible = False
    end
    object Panel29: TPanel
      Left = 0
      Top = 0
      Width = 468
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        468
        41)
      object Label5: TLabel
        Left = 14
        Top = 8
        Width = 75
        Height = 13
        Caption = 'Selected Paient'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 127
        Top = 8
        Width = 50
        Height = 13
        Caption = 'Name / ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblSelectedPatientNameID: TLabel
        Left = 184
        Top = 8
        Width = 149
        Height = 13
        Caption = 'lblSelectedPatientNameID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 114
        Top = 24
        Width = 63
        Height = 13
        Caption = 'Location / ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblSelectedPatientLocationNameID: TLabel
        Left = 184
        Top = 24
        Width = 198
        Height = 13
        Caption = 'lblSelectedPatientLocationNameID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblTarget: TLabel
        Left = 405
        Top = 8
        Width = 51
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'lblTarget'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        ExplicitLeft = 413
      end
    end
    object Panel30: TPanel
      Left = 0
      Top = 41
      Width = 468
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 1
      object Label11: TLabel
        Left = 14
        Top = -1
        Width = 78
        Height = 13
        Caption = 'Current Location'
      end
      object Label6: TLabel
        Left = 127
        Top = -1
        Width = 50
        Height = 13
        Caption = 'Name / ID'
      end
      object lblLocationName: TLabel
        Left = 184
        Top = -1
        Width = 95
        Height = 13
        Caption = 'lblLocationName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pnlSelection: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object pnlPtInfo: TPanel
      Left = 0
      Top = 0
      Width = 468
      Height = 49
      Hint = 'Selected patient demographics.'
      Align = alClient
      Color = 13365758
      ParentBackground = False
      TabOrder = 0
      OnMouseDown = pnlPtInfoMouseDown
      OnMouseUp = pnlPtInfoMouseUp
      object lblSelectedName: TLabel
        Left = 7
        Top = 5
        Width = 115
        Height = 13
        Caption = 'No Patient Selected'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPatientInfo: TLabel
        Left = 7
        Top = 21
        Width = 60
        Height = 13
        Caption = '000-00-0000'
      end
    end
  end
  object tmSearch: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmSearchTimer
    Left = 352
    Top = 8
  end
  object tmrLoad: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tmrLoadTimer
    Left = 384
    Top = 8
  end
end
