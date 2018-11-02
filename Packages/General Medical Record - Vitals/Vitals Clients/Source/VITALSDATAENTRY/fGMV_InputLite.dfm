object frmGMV_InputLite: TfrmGMV_InputLite
  Left = 624
  Top = 117
  HelpContext = 2
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Vitals Input'
  ClientHeight = 644
  ClientWidth = 811
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 614
    Width = 811
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MaxHeight = 30
    Constraints.MinHeight = 30
    TabOrder = 4
    object pnlButtons: TPanel
      Left = 516
      Top = 0
      Width = 295
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnSave: TButton
        Left = 103
        Top = 3
        Width = 95
        Height = 26
        Caption = '&Save'
        TabOrder = 1
        OnClick = acSaveInputExecute
      end
      object btnCancel: TButton
        Left = 198
        Top = 3
        Width = 95
        Height = 26
        Caption = 'E&xit'
        TabOrder = 2
        OnClick = btnCancelClick
      end
      object btnSaveAndExit: TButton
        Left = 8
        Top = 3
        Width = 95
        Height = 26
        Caption = 'Save &And Exit'
        TabOrder = 0
        OnClick = acSaveInputExecute
      end
    end
    object chkbCloseOnSave: TCheckBox
      Left = 16
      Top = 7
      Width = 241
      Height = 17
      Caption = 'Close window after saving vitals for all patients'
      TabOrder = 1
      Visible = False
    end
  end
  object pnlInput: TPanel
    Left = 0
    Top = 84
    Width = 811
    Height = 530
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object splParams: TSplitter
      Left = 165
      Top = 0
      Width = 4
      Height = 530
      Color = clSilver
      ParentColor = False
      ExplicitHeight = 532
    end
    object pnlParams: TPanel
      Left = 0
      Top = 0
      Width = 165
      Height = 530
      Align = alLeft
      BevelOuter = bvNone
      Constraints.MaxWidth = 350
      Constraints.MinWidth = 165
      TabOrder = 0
      OnResize = pnlParamsResize
      object splPatients: TSplitter
        Left = 0
        Top = 98
        Width = 165
        Height = 4
        Cursor = crVSplit
        Align = alTop
        Color = clSilver
        ParentColor = False
      end
      object gbxTemplates: TGroupBox
        Left = 0
        Top = 170
        Width = 165
        Height = 360
        Align = alClient
        Caption = '&Templates'
        TabOrder = 2
        object Panel2: TPanel
          Left = 2
          Top = 15
          Width = 4
          Height = 339
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
        end
        object Panel4: TPanel
          Left = 159
          Top = 15
          Width = 4
          Height = 339
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
        end
        object Panel5: TPanel
          Left = 2
          Top = 354
          Width = 161
          Height = 4
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
        end
        object Panel6: TPanel
          Left = 6
          Top = 15
          Width = 153
          Height = 339
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel6'
          TabOrder = 1
          object tv: TTreeView
            Left = 0
            Top = 0
            Width = 153
            Height = 299
            Align = alClient
            Images = ImageList1
            Indent = 19
            ParentShowHint = False
            RowSelect = True
            ShowHint = True
            TabOrder = 0
            OnChanging = tvChanging
            OnCollapsed = tvCollapsed
            OnExpanded = tvExpanded
          end
          object pnlTemplInfo: TPanel
            Left = 0
            Top = 299
            Width = 153
            Height = 40
            Align = alBottom
            BevelOuter = bvLowered
            TabOrder = 1
            Visible = False
            object lblTemplInfo: TLabel
              Left = 1
              Top = 1
              Width = 3
              Height = 13
              Align = alClient
              Alignment = taCenter
              Color = 13556195
              ParentColor = False
              Transparent = False
              WordWrap = True
            end
          end
        end
      end
      object gbDateTime: TGroupBox
        Left = 0
        Top = 102
        Width = 165
        Height = 68
        Align = alTop
        Caption = '&DateTime'
        TabOrder = 1
        Visible = False
        DesignSize = (
          165
          68)
        object dtpDate: TDateTimePicker
          Left = 8
          Top = 16
          Width = 149
          Height = 21
          Hint = 'Date vitals were taken'
          HelpContext = 2
          Anchors = [akLeft, akTop, akRight]
          CalAlignment = dtaRight
          Date = 37193.000000000000000000
          Time = 37193.000000000000000000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = dtpTimeChange
        end
        object dtpTime: TDateTimePicker
          Left = 7
          Top = 39
          Width = 150
          Height = 21
          Hint = 'Time vitals were taken'
          HelpContext = 2
          Anchors = [akLeft, akTop, akRight]
          Date = 37305.835035717600000000
          Time = 37305.835035717600000000
          Kind = dtkTime
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = dtpTimeChange
        end
      end
      object gbxPatients: TGroupBox
        Left = 0
        Top = 0
        Width = 165
        Height = 98
        Align = alTop
        Caption = 'P&atient List'
        Constraints.MaxHeight = 350
        TabOrder = 0
        object Panel1: TPanel
          Left = 2
          Top = 15
          Width = 4
          Height = 77
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
        end
        object Panel8: TPanel
          Left = 159
          Top = 15
          Width = 4
          Height = 77
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 2
        end
        object Panel9: TPanel
          Left = 2
          Top = 92
          Width = 161
          Height = 4
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
        end
        object lvSelPatients: TListView
          Left = 6
          Top = 15
          Width = 153
          Height = 77
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Name'
              Width = 0
            end
            item
              Caption = 'ID'
              Width = 0
            end
            item
              Caption = 'Info'
              Width = 0
            end
            item
              Caption = 'Status'
              Width = 0
            end>
          ReadOnly = True
          ShowColumnHeaders = False
          ShowWorkAreas = True
          SmallImages = imgTemplates
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvSelPatientsChange
          OnChanging = lvSelPatientsChanging
          OnClick = lvSelPatientsClick
        end
      end
    end
    object pnlTemplates: TPanel
      Left = 169
      Top = 0
      Width = 642
      Height = 530
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      object splLastVitals: TSplitter
        Left = 1
        Top = 256
        Width = 640
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        Color = clSilver
        ParentColor = False
        ExplicitTop = 258
        ExplicitWidth = 637
      end
      object pnlInputTemplate: TPanel
        Left = 1
        Top = 1
        Width = 640
        Height = 255
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlInputTemplate'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 0
          Top = 50
          Width = 640
          Height = 2
          Align = alTop
          Shape = bsBottomLine
          ExplicitWidth = 637
        end
        object pnlInputTemplateHeader: TPanel
          Left = 0
          Top = 0
          Width = 640
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Input Template'
          TabOrder = 0
        end
        object hc: THeaderControl
          Left = 0
          Top = 52
          Width = 640
          Height = 17
          Hint = '****'
          Sections = <
            item
              Alignment = taCenter
              ImageIndex = -1
              Text = '#'
              Width = 29
            end
            item
              ImageIndex = -1
              Text = 'Unavailable'
              Width = 0
            end
            item
              ImageIndex = -1
              Text = 'Refused'
              Width = 60
            end
            item
              ImageIndex = -1
              Text = 'Vital'
              Width = 111
            end
            item
              ImageIndex = -1
              Text = 'Value'
              Width = 90
            end
            item
              ImageIndex = -1
              Text = 'Units'
              Width = 75
            end
            item
              ImageIndex = -1
              Text = 'Qualifiers'
              Width = 50
            end>
          Style = hsFlat
          ShowHint = True
          ParentShowHint = False
          OnMouseMove = hcMouseMove
        end
        object pnlScrollBox: TPanel
          Left = 0
          Top = 69
          Width = 640
          Height = 186
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 4
          TabOrder = 3
          object sbxMain: TScrollBox
            Left = 4
            Top = 4
            Width = 632
            Height = 178
            Align = alClient
            BorderStyle = bsNone
            TabOrder = 0
          end
        end
        object pnlOptions: TPanel
          Left = 0
          Top = 24
          Width = 640
          Height = 26
          Align = alTop
          BevelOuter = bvNone
          Color = 12698049
          ParentBackground = False
          TabOrder = 1
          DesignSize = (
            640
            26)
          object bvU: TBevel
            Left = 8
            Top = 3
            Width = 105
            Height = 21
            Shape = bsFrame
            Visible = False
          end
          object bvUnavailable: TBevel
            Left = 135
            Top = 3
            Width = 21
            Height = 21
            Shape = bsFrame
            Visible = False
          end
          object lblUnavailable: TLabel
            Left = 160
            Top = 6
            Width = 56
            Height = 13
            Caption = 'Un&available'
            FocusControl = ckbUnavailable
            Visible = False
            WordWrap = True
          end
          object ckbOnPass: TCheckBox
            Left = 12
            Top = 5
            Width = 99
            Height = 17
            Hint = 'Mark all vitals in the template as "Patient On Pass"'
            Caption = '&Patient On Pass'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = ckbOnPassClick
            OnEnter = ckbOnPassEnter
            OnExit = ckbOnPassExit
          end
          object pnlCPRSMetricStyle: TPanel
            Left = 324
            Top = 0
            Width = 316
            Height = 26
            Align = alRight
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            object Bevel2: TBevel
              Left = 162
              Top = 0
              Width = 9
              Height = 26
              Shape = bsLeftLine
            end
            object Bevel3: TBevel
              Left = 0
              Top = 0
              Width = 9
              Height = 26
              Align = alLeft
              Shape = bsLeftLine
            end
            object chkCPRSSTyle: TCheckBox
              Left = 173
              Top = 5
              Width = 136
              Height = 17
              Hint = 'Switch between dropdown and check box presentation of metric'
              TabStop = False
              Alignment = taLeftJustify
              Caption = 'U&nits as Drop Down List'
              TabOrder = 2
              OnClick = acMetricStyleChangeExecute
            end
            object cbR: TCheckBox
              Left = 88
              Top = 5
              Width = 65
              Height = 17
              Hint = 'Enable template "Refused" checkboxes'
              TabStop = False
              Alignment = taLeftJustify
              Caption = 'Enable &R'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
              OnClick = cbRClick
            end
            object cbU: TCheckBox
              Left = 8
              Top = 5
              Width = 73
              Height = 17
              Hint = 'Enable template "Unavailable" checkboxes'
              TabStop = False
              Alignment = taLeftJustify
              Caption = 'Enable &U.'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 0
              OnClick = cbRClick
            end
          end
          object ckbUnavailable: TCheckBox
            Left = 140
            Top = 5
            Width = 11
            Height = 17
            Hint = 'Mark all vitals in the template as "Patient Unavailable" '
            Alignment = taLeftJustify
            Caption = 'Patient on Pass'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            Visible = False
            OnClick = ckbUnavailableClick
            OnEnter = ckbUnavailableEnter
            OnExit = ckbUnavailableExit
          end
          object chkOneUnavailableBox: TCheckBox
            Left = 148
            Top = 5
            Width = 14
            Height = 17
            Action = acUnavailableBoxStatus
            Alignment = taLeftJustify
            Anchors = [akTop, akRight]
            TabOrder = 3
            Visible = False
          end
          object Panel7: TPanel
            Left = 188
            Top = 0
            Width = 136
            Height = 26
            Align = alRight
            BevelOuter = bvNone
            Color = clSilver
            TabOrder = 0
            object Bevel4: TBevel
              Left = 0
              Top = 0
              Width = 9
              Height = 26
              Align = alLeft
              Shape = bsLeftLine
              Visible = False
            end
            object cbConversionWarning: TCheckBox
              Left = 8
              Top = 5
              Width = 121
              Height = 17
              TabStop = False
              Alignment = taLeftJustify
              Caption = 'Conversion &Warning '
              Checked = True
              State = cbChecked
              TabOrder = 0
              Visible = False
              OnClick = cbConversionWarningClick
            end
          end
        end
      end
      object pnlLatestVitalsBg: TPanel
        Left = 1
        Top = 261
        Width = 640
        Height = 268
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnlLatestVitalsBg'
        TabOrder = 1
        OnResize = pnlLatestVitalsBgResize
        object pnlLatestVitalsHeader: TPanel
          Left = 0
          Top = 0
          Width = 640
          Height = 24
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Latest vitals on file for this patient:'
          TabOrder = 0
        end
        object Panel13: TPanel
          Left = 0
          Top = 262
          Width = 640
          Height = 6
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 2
        end
        object strgLV: TStringGrid
          Left = 0
          Top = 24
          Width = 640
          Height = 238
          Align = alClient
          BorderStyle = bsNone
          ColCount = 7
          DefaultRowHeight = 15
          FixedCols = 0
          GridLineWidth = 0
          Options = [goFixedVertLine, goFixedHorzLine, goRangeSelect, goColSizing]
          TabOrder = 1
          OnDrawCell = strgLVDrawCell
          ColWidths = (
            89
            109
            71
            51
            249
            64
            64)
        end
      end
    end
  end
  object pnlTools: TPanel
    Left = 0
    Top = 26
    Width = 811
    Height = 41
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    object pnlPatient: TPanel
      Left = 1
      Top = 1
      Width = 232
      Height = 39
      Align = alLeft
      Color = clSilver
      Constraints.MinWidth = 165
      ParentBackground = False
      TabOrder = 0
      TabStop = True
      OnClick = pnlPatientClick
      OnEnter = pnlPatientEnter
      OnExit = pnlPatientExit
      OnMouseDown = pnlPatientMouseDown
      OnMouseUp = pnlPatientMouseUp
      DesignSize = (
        232
        39)
      object edPatientName: TEdit
        Left = 8
        Top = 5
        Width = 217
        Height = 15
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Color = clSilver
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = 'edPatientName'
        OnKeyDown = edPatientNameKeyDown
        OnMouseDown = pnlPatientMouseDown
        OnMouseUp = pnlPatientMouseUp
      end
      object edPatientInfo: TEdit
        Left = 8
        Top = 21
        Width = 217
        Height = 15
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Color = clSilver
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = 'edPatientInfo'
        OnKeyDown = edPatientNameKeyDown
        OnMouseDown = pnlPatientMouseDown
        OnMouseUp = pnlPatientMouseUp
      end
    end
    object pnlSettings: TPanel
      Left = 233
      Top = 1
      Width = 577
      Height = 39
      Align = alClient
      Color = clSilver
      ParentBackground = False
      TabOrder = 1
      object lblHospital: TLabel
        Left = 115
        Top = 5
        Width = 3
        Height = 13
      end
      object lblDateTime: TLabel
        Left = 115
        Top = 21
        Width = 3
        Height = 13
      end
      object lblHospitalCap: TLabel
        Left = 7
        Top = 5
        Width = 100
        Height = 13
        Caption = 'Hospital Location'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 7
        Top = 21
        Width = 61
        Height = 13
        Caption = 'Date/Time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object pnlParamTools: TPanel
        Left = 257
        Top = 1
        Width = 246
        Height = 37
        Align = alRight
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 1
        object SpeedButton4: TSpeedButton
          Left = 123
          Top = 1
          Width = 57
          Height = 35
          Action = acTemplateSelector
          Flat = True
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F000000757F757F757F757F757F757F757F757F757F757F757F757F757F
            757F757F757F0000000000000000000000000000000000000000000000000000
            0000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
            0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
            0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
            0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
            0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7FFF7F000000001F001F001F001F001F001F001F001F001F001F001F001F00
            1F001F0000000000186318631F001F001F001F001F001F001F001F001F001F00
            1863186300000000000000000000000000000000000000000000000000000000
            000000000000757F757F757F757F757F757F757F757F757F757F757F757F757F
            757F757F757F757F757F757F757F757F757F757F757F757F757F757F757F757F
            757F757F757F}
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
          Visible = False
        end
        object SpeedButton3: TSpeedButton
          Left = 68
          Top = 1
          Width = 55
          Height = 35
          Action = acHospitalSelector
          Flat = True
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F000000757F757F00000000000000000000000000000000000000000000
            757F757F757F757F757F757F000010421042104210421042104210420000757F
            757F757F757F757F757F757F757F757F00001863186318630000757F757F757F
            757F757F757F0000000000000000000000000000000000000000000000000000
            00000000757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007CFF7F
            FF7F0000757F0000FF7F10421863186318631863186318631863186318631042
            FF7F0000757F0000FF7F10420000000000000000000000000000000000001863
            FF7F0000757F0000FF7F10420000E003E003E003E003E003E003E00300001863
            FF7F0000757F0000FF7F10420000E0031F7C1F7C1F7C1F7C1F7CE00300001863
            FF7F0000757F0000FF7F10420000E003007C007CE003007C007CE00300001863
            FF7F0000757F0000FF7F10420000E003007C007CE003007C007CE00300001863
            FF7F0000757F0000FF7F10420000E003E003E003E003E003E003E00300001863
            FF7F0000757F0000FF7F10420000000000000000000000000000000000001863
            FF7F0000757F0000FF7F10421042104210421042104210421042104210421042
            FF7F0000757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            FF7F0000757F0000000000000000000000000000000000000000000000000000
            00000000757F}
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
        end
        object SpeedButton2: TSpeedButton
          Left = 2
          Top = 1
          Width = 66
          Height = 35
          Action = acDateTimeSelector
          Flat = True
          Glyph.Data = {
            42020000424D4202000000000000420000002800000010000000100000000100
            1000030000000002000000000000000000000000000000000000007C0000E003
            00001F000000757F000000000000000000000000000000000000000000000000
            0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
            0000757F757F757F0000FF7FFF7FFF7F10420000000000001042FF7FFF7FFF7F
            0000757F757F757F0000FF7FFF7F00001863FF7FFF7FFF7F18630000FF7FFF7F
            0000757F757F757F0000FF7F10421863FF7FFF7FFF7FFF7FFF7F18631042FF7F
            0000757F757F757F0000FF7F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF7F
            0000757F757F757F0000FF7F0000FF7FFF7FFF7F007C00000000FF7F0000FF7F
            0000757F757F757F0000FF7F0000FF7FFF7FFF7F0000FF7FFF7FFF7F0000FF7F
            0000757F757F757F0000FF7F10421863FF7FFF7F0000FF7FFF7F18631042FF7F
            0000757F757F757F0000FF7FFF7F00001863FF7F0000FF7F18630000FF7FFF7F
            0000757F757F757F0000FF7FFF7FFF7F10420000000000001042FF7FFF7FFF7F
            0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000
            0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
            0000757F757F757F0000007C007C007C007C007C007C007C007C0000FF7F0000
            757F757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00000000757F
            757F757F757F757F0000000000000000000000000000000000000000757F757F
            757F757F757F}
          Layout = blGlyphTop
          ParentShowHint = False
          ShowHint = True
        end
        object Panel10: TPanel
          Left = 126
          Top = 0
          Width = 60
          Height = 37
          Align = alRight
          BevelOuter = bvNone
          Color = clSilver
          TabOrder = 0
          object sbtnTemplateTree: TSpeedButton
            Left = 0
            Top = 1
            Width = 58
            Height = 35
            Action = acParamsShowHide
            AllowAllUp = True
            Flat = True
            Glyph.Data = {
              42020000424D4202000000000000420000002800000010000000100000000100
              1000030000000002000000000000000000000000000000000000007C0000E003
              00001F000000757F757F757F757F000000000000000000000000000000000000
              FF03FF03FF03757F757F757F757F0000FF7FFF7F00000000FF7FE07FFF7FE07F
              0000FF03FF03757F757F757F757F0000FF7F0000E07FFF7FE07F0000E07FFF7F
              E07F0000FF03757F757F757F757F0000FF7FFF7F000000000000E07FFF7FE07F
              FF7FE07F0000757F757F757F757F0000FF7FFF7FFF7F0000E07FFF7FE07FFF7F
              E07FFF7F0000757F757F757F00000000000000000000E07FFF7F0000FF7FE07F
              FF7FE07F0000000000000000FF7FE07FFF7FE07F0000FF7F0000FF7FE07F0000
              E07FFF7F0000FF030000FF7FE07F00000000000000000000000000000000E07F
              FF7F00000000FF030000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F0000FF7F
              0000FF7F0000FF030000FF7FE07FFF7FE07F0000000000000000000000000000
              FF7FFF7F0000FF030000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F0000FF7F
              FF7FFF7F0000FF030000FF7FE07FFF7FE07F00000000000000000000FF7F0000
              000000000000FF0300000000FF7FE07FFF7FE07FFF7FE07F0000FF7FFF7F0000
              FF7FFF7F000000000000757F000000000000000000000000FF7FFF7FFF7F0000
              FF7F0000757F757F757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
              0000757F757F757F757F757F757F000000000000000000000000000000000000
              757F757F757F}
            Layout = blGlyphTop
            ParentShowHint = False
            ShowHint = True
          end
        end
        object Panel3: TPanel
          Left = 186
          Top = 0
          Width = 60
          Height = 37
          Align = alRight
          BevelOuter = bvNone
          Color = clSilver
          TabOrder = 1
          object sbtnShowLatestVitals: TSpeedButton
            Left = 0
            Top = 1
            Width = 59
            Height = 35
            Action = acVitalsShowHide
            AllowAllUp = True
            Flat = True
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
              0000333377777777777733330FFFFFFFFFF033337F3FFF3F3FF733330F000F0F
              00F033337F777373773733330FFFFFFFFFF033337F3FF3FF3FF733330F00F00F
              00F033337F773773773733330FFFFFFFFFF033337FF3333FF3F7333300FFFF00
              F0F03333773FF377F7373330FB00F0F0FFF0333733773737F3F7330FB0BF0FB0
              F0F0337337337337373730FBFBF0FB0FFFF037F333373373333730BFBF0FB0FF
              FFF037F3337337333FF700FBFBFB0FFF000077F333337FF37777E0BFBFB000FF
              0FF077FF3337773F7F37EE0BFB0BFB0F0F03777FF3733F737F73EEE0BFBF00FF
              00337777FFFF77FF7733EEEE0000000003337777777777777333}
            Layout = blGlyphTop
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
          end
        end
      end
      object pnlMonitor: TPanel
        Left = 503
        Top = 1
        Width = 73
        Height = 37
        Align = alRight
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 0
        object sbMonitor: TSpeedButton
          Left = 0
          Top = 0
          Width = 73
          Height = 37
          Action = acMonitorGetData
          Align = alClient
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            33333333333FFFFFFFFF333333000000000033333377777777773333330FFFFF
            FFF03333337F333333373333330FFFFFFFF03333337F3FF3FFF73333330F00F0
            00F03333F37F773777373330330FFFFFFFF03337FF7F3F3FF3F73339030F0800
            F0F033377F7F737737373339900FFFFFFFF03FF7777F3FF3FFF70999990F00F0
            00007777777F7737777709999990FFF0FF0377777777FF37F3730999999908F0
            F033777777777337F73309999990FFF0033377777777FFF77333099999000000
            3333777777777777333333399033333333333337773333333333333903333333
            3333333773333333333333303333333333333337333333333333}
          Layout = blGlyphTop
          NumGlyphs = 2
          ParentFont = False
          ExplicitLeft = 5
          ExplicitTop = 4
          ExplicitHeight = 35
        end
      end
    end
  end
  object tlbInput: TToolBar
    Left = 0
    Top = 0
    Width = 811
    Height = 26
    AutoSize = True
    ButtonWidth = 96
    Caption = 'tlbInput'
    EdgeBorders = [ebTop, ebBottom]
    List = True
    TabOrder = 0
    object ToolButton2: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object SpeedButton5: TSpeedButton
      Left = 8
      Top = 0
      Width = 104
      Height = 22
      Action = acVitalsShowHide
      AllowAllUp = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
        0000333377777777777733330FFFFFFFFFF033337F3FFF3F3FF733330F000F0F
        00F033337F777373773733330FFFFFFFFFF033337F3FF3FF3FF733330F00F00F
        00F033337F773773773733330FFFFFFFFFF033337FF3333FF3F7333300FFFF00
        F0F03333773FF377F7373330FB00F0F0FFF0333733773737F3F7330FB0BF0FB0
        F0F0337337337337373730FBFBF0FB0FFFF037F333373373333730BFBF0FB0FF
        FFF037F3337337333FF700FBFBFB0FFF000077F333337FF37777E0BFBFB000FF
        0FF077FF3337773F7F37EE0BFB0BFB0F0F03777FF3733F737F73EEE0BFBF00FF
        00337777FFFF77FF7733EEEE0000000003337777777777777333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
    end
    object sbtnToolShowParams: TSpeedButton
      Left = 112
      Top = 0
      Width = 113
      Height = 22
      Action = acParamsShowHide
      AllowAllUp = True
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F000000757F757F757F757F000000000000000000000000000000000000
        FF03FF03FF03757F757F757F757F0000FF7FFF7F00000000FF7FE07FFF7FE07F
        0000FF03FF03757F757F757F757F0000FF7F0000E07FFF7FE07F0000E07FFF7F
        E07F0000FF03757F757F757F757F0000FF7FFF7F000000000000E07FFF7FE07F
        FF7FE07F0000757F757F757F757F0000FF7FFF7FFF7F0000E07FFF7FE07FFF7F
        E07FFF7F0000757F757F757F00000000000000000000E07FFF7F0000FF7FE07F
        FF7FE07F0000000000000000FF7FE07FFF7FE07F0000FF7F0000FF7FE07F0000
        E07FFF7F0000FF030000FF7FE07F00000000000000000000000000000000E07F
        FF7F00000000FF030000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F0000FF7F
        0000FF7F0000FF030000FF7FE07FFF7FE07F0000000000000000000000000000
        FF7FFF7F0000FF030000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F0000FF7F
        FF7FFF7F0000FF030000FF7FE07FFF7FE07F00000000000000000000FF7F0000
        000000000000FF0300000000FF7FE07FFF7FE07FFF7FE07F0000FF7FFF7F0000
        FF7FFF7F000000000000757F000000000000000000000000FF7FFF7FFF7F0000
        FF7F0000757F757F757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000
        0000757F757F757F757F757F757F000000000000000000000000000000000000
        757F757F757F}
      ParentShowHint = False
      ShowHint = True
    end
    object sbtnTemplates: TSpeedButton
      Left = 225
      Top = 0
      Width = 112
      Height = 22
      Action = acTemplateSelector
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F000000757F757F757F757F757F757F757F757F757F757F757F757F757F
        757F757F757F0000000000000000000000000000000000000000000000000000
        0000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
        0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
        0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
        0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F00000000FF7F00000000FF7F00000000FF7F00000000FF7F00000000
        0000FF7F00000000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F000000001F001F001F001F001F001F001F001F001F001F001F001F00
        1F001F0000000000186318631F001F001F001F001F001F001F001F001F001F00
        1863186300000000000000000000000000000000000000000000000000000000
        000000000000757F757F757F757F757F757F757F757F757F757F757F757F757F
        757F757F757F757F757F757F757F757F757F757F757F757F757F757F757F757F
        757F757F757F}
      Visible = False
    end
    object sbtnHospitals: TSpeedButton
      Left = 337
      Top = 0
      Width = 96
      Height = 22
      Action = acHospitalSelector
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F000000757F757F00000000000000000000000000000000000000000000
        757F757F757F757F757F757F000010421042104210421042104210420000757F
        757F757F757F757F757F757F757F757F00001863186318630000757F757F757F
        757F757F757F0000000000000000000000000000000000000000000000000000
        00000000757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007CFF7F
        FF7F0000757F0000FF7F10421863186318631863186318631863186318631042
        FF7F0000757F0000FF7F10420000000000000000000000000000000000001863
        FF7F0000757F0000FF7F10420000E003E003E003E003E003E003E00300001863
        FF7F0000757F0000FF7F10420000E0031F7C1F7C1F7C1F7C1F7CE00300001863
        FF7F0000757F0000FF7F10420000E003007C007CE003007C007CE00300001863
        FF7F0000757F0000FF7F10420000E003007C007CE003007C007CE00300001863
        FF7F0000757F0000FF7F10420000E003E003E003E003E003E003E00300001863
        FF7F0000757F0000FF7F10420000000000000000000000000000000000001863
        FF7F0000757F0000FF7F10421042104210421042104210421042104210421042
        FF7F0000757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        FF7F0000757F0000000000000000000000000000000000000000000000000000
        00000000757F}
    end
    object SpeedButton1: TSpeedButton
      Left = 433
      Top = 0
      Width = 104
      Height = 22
      Action = acDateTimeSelector
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F000000757F000000000000000000000000000000000000000000000000
        0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
        0000757F757F757F0000FF7FFF7FFF7F10420000000000001042FF7FFF7FFF7F
        0000757F757F757F0000FF7FFF7F00001863FF7FFF7FFF7F18630000FF7FFF7F
        0000757F757F757F0000FF7F10421863FF7FFF7FFF7FFF7FFF7F18631042FF7F
        0000757F757F757F0000FF7F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF7F
        0000757F757F757F0000FF7F0000FF7FFF7FFF7F007C00000000FF7F0000FF7F
        0000757F757F757F0000FF7F0000FF7FFF7FFF7F0000FF7FFF7FFF7F0000FF7F
        0000757F757F757F0000FF7F10421863FF7FFF7F0000FF7FFF7F18631042FF7F
        0000757F757F757F0000FF7FFF7F00001863FF7F0000FF7F18630000FF7FFF7F
        0000757F757F757F0000FF7FFF7FFF7F10420000000000001042FF7FFF7FFF7F
        0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F000000000000
        0000757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000FF7FFF7F
        0000757F757F757F0000007C007C007C007C007C007C007C007C0000FF7F0000
        757F757F757F757F0000FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00000000757F
        757F757F757F757F0000000000000000000000000000000000000000757F757F
        757F757F757F}
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 67
    Width = 811
    Height = 17
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Panels = <
      item
        Text = ' VS Monitor: CASMED'
        Width = 110
      end
      item
        Text = ' Model: '
        Width = 100
      end
      item
        Text = ' Port: COMx'
        Width = 68
      end
      item
        Alignment = taCenter
        Text = ' Status: Unknown'
        Width = 100
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
    ParentColor = True
    ParentShowHint = False
    ShowHint = False
    SizeGrip = False
    UseSystemFont = False
    Visible = False
  end
  object imgTemplates: TImageList
    BkColor = 11066107
    Left = 576
    Top = 128
    Bitmap = {
      494C010114001800240010001000FBDAA8000510FFFFFFFFFFFFFFFF424D7600
      000000000000760000002800000040000000600000000100040000000000000C
      0000000000000000000000000000000000000000000000008000008000000080
      8000800000008000800080800000C0C0C000808080000000FF0000FF000000FF
      FF00FF000000FF00FF00FFFF0000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007777777777777777777777777777
      7777777777777777777777777777777777777777700000077777777770000007
      777777777000000777777770000000000777777002222220077777700BBBBBB0
      07777770022222200777770BBBBBBBBBB077770222BB22222077770BBBBB0BBB
      B07777022222B222207770BBBBBBBBBBBB07702222BBB222220770BBBBBB00BB
      BB0770222222BB2222070BBB00BBB00BBBB070222BBBBB22220770BBBBBB000B
      BB0770222222BBB222070BBB000BB000BBB002222BB2BB2222200BBBBBBB0000
      BBB002222222BBBB22200BB0000000000BB00222BB222BB222200B0000000000
      0BB002BBBBBBBBBBB2200BB00B0000B00BB00222BB222BBB22200B0000000000
      0BB002BBBBBBBBBBB2200B00BBB00BBB00B00222222222BBB2200BBBBBBB0000
      BBB002222222BBBB22200B00BBB00BBB00B070222222222BB20770BBBBBB000B
      BB0770222222BBB222070BBBBBBBBBBBBBB0702222222222220770BBBBBB00BB
      BB0770222222BB2222070BBBBBBBBBBBBBB07702222222222077770BBBBB0BBB
      B07777022222B222207770BBBBBBBBBBBB07777002222220077777700BBBBBB0
      07777770022222200777770BBBBBBBBBB0777777700000077777777770000007
      7777777770000007777777700000000007777777777777777777777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      77777777000000000EEE77777777777777777777700000077777777770000007
      777777770FF00FBFB0EE77777000000777777770077777700777777007777770
      077777770F0BFB0BFB0E77700777777007777707777777777077770777777777
      707777770FF000BFBFB077077777077770777077770077777707707777007777
      770777770FFF0BFBFBF070777777007777077077770007777707707777000777
      770777700000BF0FBFB070777777000777070777700000777770077770000077
      7770000FBFB0F0FB0BF007777777000077700777700700777770077770070077
      7770E0FB00000000BF0007000000000007700777007770077770077700777007
      7770E0BFBFBFBFB0F0F007000000000007700777007770007770077700777000
      7770E0FBFB0000000FF007777777000077707077777777007707707777777700
      7707E0BFBFBFBFB0FFF070777777000777077077777777777707707777777777
      7707E0FBFB00000F000070777777007777077707777777777077770777777777
      7077E00FBFBFB0FF0FF077077777077770777770077777700777777007777770
      0777007000000FFF0F0777700777777007777777700000077777777770000007
      777777770FFFFFFF007777777000000777777777777777777777777777777777
      7777777700000000077777777777777777777777777777777777777770FF0779
      197077777777777777777000000000000077700000000007777778000FF07779
      1903000000000000000070FFFFFFFFFFF07700B7B7B7B7B0000080FFFF077779
      19330FFFFFFFFFFFFFF070FFF80008FFF0770B0B7B7B7B7B0FF00F00FF077779
      19330F00F00F00F000F070FF07FFF70FF0770FB0B7B7B7B7B0F000770F077779
      19370FFFFFFFFFFFFFF070F87FFFFF78F0770BFB0000000000F008770F077799
      99970F00F00F00F000F070F0FFFFFFF0F0770FBFBF0FFFFFFFF07780F0877011
      11170FFFFFFFFFFFFFF070F0FFF900F0F0770BFBFB0F000000F0770008770333
      07770F00F00F00F000F070F0FFF0FFF0F0770FBFBF0FFFFFFFF0777777703337
      07770FFFFFFFFFFFFFF070F87FF0FF78F07770FBFB0F000000F0770077033377
      07770F00F00F00F000F070FF07F0F70FF0777800000FFFFFFFF0707070333777
      07770FFFFFFFFFFFFFF070FFF80008FFF0777777770F00FF0000070003337777
      07770CCCCCCCCCCCCCC070FFFFFFFF0000777777770FFFFF0F07000000377778
      0877077CCCCCCCCCC77070FFFFFFFF0FF0777777770FFFFF0077770000077778
      0877000000000000000070999999990F07777777770000000777773000087778
      0877777777777777777770FFFFFFFF0077777777777777777777773370000077
      7777777777777777777770000000000777777777777777777777777777777777
      7777777777777777777777000000000007777000000000000007777770000007
      7777000000000000000077708888888077777077777777777707777007777770
      07770FF8FF8FF8FF8FF077777077707777777077777777777707770777007777
      707709F89F89F8FF8FF000000000000000077077770077777707707777000777
      770708888888888888800FFFFFFFFFF9FF077077770007777707707770000077
      77070FF8FF8FF8FF8FF00F87777777778F077077700000777707077770070077
      777009F89F89F89F89F00F80000000007F077077700700777707077700777007
      777008888888888888800F80AAAAAAA07F077077007770077707077700777000
      77700FF8FF8FF8FF8FF00F80ADDDDDA07F077077007770007707077777777700
      077009F89F89F89F89F00F80A99A99A07F077077777777000707707777777770
      070708888888888888800F80A99A99A07F077077777777700707707777777777
      77070FFFFF8FF8FF8FF00F80AAAAAAA07F077077777777777707770777777777
      70770FFFFF89F89F89F00F80000000007F077077777777777707777007777770
      077700000000000000000F88888888888F077000000000000007777770000007
      7777CCCCCC7777CCCCCC0FFFFFFFFFFFFF077777777777777777777777777777
      7777CCCCCCCCCCCCCCCC00000000000000077777777777777777777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      7777700000000000000777777000000777777777777777777777777777770777
      7777707777777777770777700BBBBBB007777777777777777777777777770077
      77777077777777777707770BBBBBBBBBB0777777777777777777777777770007
      7777707777777777770770BBBB00BBBBBB077777777777777777777777770000
      7777707777777777770770BBBB000BBBBB077777777777777777770000000000
      077770777777777777070BBBB00000BBBBB07777777777777777770000000000
      007770777777777777070BBBB00B00BBBBB07777777777777777770000000000
      077770777777777777070BBB00BBB00BBBB07777777777777777777777770000
      777770777777777777070BBB00BBB000BBB07777777777777777777777770007
      7777707777777777770770BBBBBBBB00BB077777777777777777777777770077
      7777707777777777770770BBBBBBBBBBBB077777777777777777777777770777
      77777077777777777707770BBBBBBBBBB0777777777777777777777777777777
      7777707777777777770777700BBBBBB007777777777777777777777777777777
      7777700000000000000777777000000777777777777777777777777777777777
      777777777777777777777777777777777777424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFF81FF81FF81FE007
      E007E007E007C003C003C003C003800180018001800100008001800180010000
      0000000000000000000000000000000000000000000000000000000000000000
      80018001800100008001800180010000C003C003C0038001E007E007E007C003
      F81FF81FF81FE007FFFFFFFFFFFFFFFFFFFFFFFFF000FFFFF81FF81FF000F81F
      E007E7E7F000E7E7C003DFFBF000DF7B8001BCFDF000BF3D8001BC7DE000BF1D
      0000783E00007F0E0000793E000040060000739E000040060000738E00007F0E
      8001BFCD0000BF1D8001BFFD0000BF3DC003DFFB0000DF7BE007E7E72001E7E7
      F81FF81FF003F81FFFFFFFFFF007FFFFFFFFF862FFFF8003801F80E000008003
      000001E000008003000001E000008003000031E100008003000031C100008003
      0000C181000080030000C307000080030000FE17000080038000CC3700008003
      8000A87700008003FC0040F700008003FC0101E300008003FC03C1E300008007
      FC07C0E3FFFF800FFFFFC83FFFFF801FFFFFFFFFFFFFC0078001F81F0000E00F
      BFFDE0070000F83FBFFDC00300000001BCFD800100000001BC7D800100000001
      B83D000000000001B93D000000000001B39D000000000001B38D000000000001
      BFC5800100000001BFE5800100000001BFFDC00300000001BFFDE00700000001
      8001F81F00000001FFFFFFFF00000001FFFFFFFFFFFFFFFFFFFFFFFF8001F81F
      FFFFFF7FBFFDE007FFFFFF3FBFFDC003FFFFFF1FBFFD8001FFFFFF0FBFFD8001
      FFFFC007BFFD0000FFFFC003BFFD0000FFFFC007BFFD0000FFFFFF0FBFFD0000
      FFFFFF1FBFFD8001FFFFFF3FBFFD8001FFFFFF7FBFFDC003FFFFFFFFBFFDE007
      FFFFFFFF8001F81FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object alInputVitals: TActionList
    Images = imgTemplates
    Left = 608
    Top = 128
    object acMetricStyleChange: TAction
      Caption = 'Change Metric Style'
      Hint = 'Switch between dropdown and check box presentation of metric'
      OnExecute = acMetricStyleChangeExecute
    end
    object acSavePreferences: TAction
      Caption = 'ac'
      OnExecute = acSavePreferencesExecute
    end
    object acLoadPreferences: TAction
      Caption = 'acLoadPreferences'
      OnExecute = acLoadPreferencesExecute
    end
    object acPatientSelected: TAction
      Caption = 'acPatientSelected'
    end
    object acTemplateClicked: TAction
      Caption = 'acTemplateClicked'
    end
    object acSetOnPass: TAction
      Caption = 'Patient on Pass'
      Hint = 'Set Patient "On Pass" mode'
      OnExecute = acSetOnPassExecute
    end
    object acSaveInput: TAction
      Caption = '&Save'
      OnExecute = acSaveInputExecute
    end
    object acCheckBoxesChange: TAction
      Caption = '"Patient On Pass" Check Boxes'
      Hint = 'Turns On/Off "Patient On Pass" check boxes'
    end
    object acDateTimeSelector: TAction
      Caption = '&Date/Time'
      Hint = 'Select Date and Time Vitals were measured'
      ImageIndex = 11
      ShortCut = 16452
      OnExecute = acDateTimeSelectorExecute
    end
    object acHospitalSelector: TAction
      Caption = '&Hospital'
      Hint = 'Select Hospital Location where Vitals were measured'
      ImageIndex = 7
      ShortCut = 16456
      OnExecute = acHospitalSelectorExecute
    end
    object acTemplateSelect: TAction
      Caption = 'Template'
    end
    object acParamsShowHide: TAction
      Caption = 'Exp. Vie&w'
      Hint = 'Show/Hide Hospital, Templates panel'
      ImageIndex = 14
      OnExecute = acParamsShowHideExecute
    end
    object acVitalsShowHide: TAction
      Caption = '&Latest V.'
      Hint = 'Show/Hide Latest Vitals List'
      OnExecute = acVitalsShowHideExecute
    end
    object acAdjustToolbars: TAction
      Caption = 'acAdjustToolbars'
      OnExecute = acAdjustToolbarsExecute
    end
    object acTemplateSelector: TAction
      Caption = 'Template'
      Hint = 'Select Vitals Template '
      ImageIndex = 10
      ShortCut = 16468
    end
    object WindowClose1: TWindowClose
      Category = 'Window'
      Caption = 'C&lose'
    end
    object acUnavailableBoxStatus: TAction
      Caption = 'One Unavailable &box'
      OnExecute = acUnavailableBoxStatusExecute
    end
    object acPatientInfo: TAction
      Caption = 'Patient In&quiry'
      OnExecute = acPatientInfoExecute
    end
    object acShowStatusBar: TAction
      Caption = 'Show/Hide Status Bar'
      OnExecute = acShowStatusBarExecute
    end
    object acEnableU: TAction
      Caption = 'Enable &U'
      OnExecute = acEnableUExecute
    end
    object acEnableR: TAction
      Caption = 'Enable &R'
      OnExecute = acEnableRExecute
    end
    object acExit: TAction
      Caption = 'E&xit'
      OnExecute = btnCancelClick
    end
    object acLatestVitals: TAction
      Caption = '&Latest Vitals Report'
      OnExecute = acLatestVitalsExecute
    end
    object acUnitsDDL: TAction
      Caption = 'U&nits as Drop Down List'
      OnExecute = acUnitsDDLExecute
    end
  end
  object ImageList1: TImageList
    Left = 536
    Top = 128
    Bitmap = {
      494C010104000900240010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000084848400FFFF
      FF0000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C6008484840000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600000000008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60084848400000000008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF0000000000000000000000000000FF
      FF000000000000000000000000000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60084848400000000000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF0000000000848484008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF0084848400000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      840000000000C6C6C6008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400FFFFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C6008484840000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      84008484840000FFFF008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF00000000000000000000FFFF000000000000FFFF000000
      00000000000000000000000000000000000084848400FFFFFF0000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C6008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000000000000000000084848400FFFFFF0000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF000000000000FFFF000000000000FFFF0000FFFF0000FF
      FF000000000000000000000000000000000084848400C6C6C60000FFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C6008484840084848400848484008484
      8400848484008484840000000000000000000000000084848400FFFFFF00C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C600FFFFFF0084848400848484008484
      840084848400848484008484840000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000084848400C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C600848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      8001E000C007C0070001C000C007C0070001C000C007C00700018000C007C007
      00018000C007C00700010000C007C00700010000C007C00700010000C007C007
      00018000C007C00700018000C007C00700038001C00FC00F80FFC07FC01FC01F
      C1FFE0FFC03FC03FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu2: TPopupMenu
    Left = 65
    Top = 135
    object PatienOnPass1: TMenuItem
      Action = acCheckBoxesChange
    end
  end
  object alDevice: TActionList
    Left = 352
    Top = 32
    object acGetCASMEDDescription: TAction
      OnExecute = acGetCASMEDDescriptionExecute
    end
    object acMonitorGetData: TAction
      Caption = 'Read &Monitor'
      OnExecute = acMonitorGetDataExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 128
    Top = 40
    object File1: TMenuItem
      Caption = 'File'
      object acPatientInfo1: TMenuItem
        Action = acPatientInfo
      end
      object LatestVitals1: TMenuItem
        Action = acLatestVitals
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ReadMonitor1: TMenuItem
        Action = acMonitorGetData
      end
      object DateTime1: TMenuItem
        Action = acDateTimeSelector
      end
      object Hospital1: TMenuItem
        Action = acHospitalSelector
      end
      object ShowHideStatusBar1: TMenuItem
        Action = acShowStatusBar
        Visible = False
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Action = acSaveInput
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object ExpView1: TMenuItem
        Action = acParamsShowHide
        Caption = 'Expanded Vie&w'
      end
      object LatestV1: TMenuItem
        Action = acVitalsShowHide
        Caption = '&Latest Vitals'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object EnableU1: TMenuItem
        Action = acEnableU
      end
      object EnableR1: TMenuItem
        Action = acEnableR
      end
      object UnitsasDropDownList1: TMenuItem
        Action = acUnitsDDL
      end
    end
  end
end
