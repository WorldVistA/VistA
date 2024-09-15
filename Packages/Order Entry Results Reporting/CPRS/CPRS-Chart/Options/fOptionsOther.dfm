inherited frmOptionsOther: TfrmOptionsOther
  Left = 341
  Top = 96
  Hint = 'Use system default settings'
  HelpContext = 9110
  Align = alCustom
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Other Parameters'
  ClientHeight = 580
  ClientWidth = 314
  HelpFile = 'CPRSWT.HLP'
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitHeight = 605
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 548
    Width = 314
    Height = 32
    HelpContext = 9110
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    ExplicitTop = 528
    ExplicitWidth = 329
    object bvlBottom: TBevel
      Left = 0
      Top = 0
      Width = 314
      Height = 2
      Align = alTop
      ExplicitWidth = 329
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 155
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9996
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 131
      ExplicitTop = 7
      ExplicitHeight = 22
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 236
      Top = 5
      Width = 75
      Height = 24
      HelpContext = 9997
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 223
      ExplicitTop = 7
      ExplicitHeight = 22
    end
  end
  object Panel1: TPanel [1]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 308
    Height = 542
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    ExplicitTop = 400
    ExplicitHeight = 549
    object lblMedsTab: TLabel
      Left = 0
      Top = 113
      Width = 308
      Height = 29
      Hint = 'Set date ranges for displaying medication orders on Meds tab.'
      Align = alTop
      Caption = 'Set date ranges for Meds tab display:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      WordWrap = True
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 308
      Height = 113
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 314
      object lblTab: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 29
        Width = 302
        Height = 16
        Align = alTop
        Caption = 'Initial tab when CPRS starts:'
        ExplicitLeft = 8
        ExplicitTop = 27
        ExplicitWidth = 164
      end
      object Bevel1: TBevel
        AlignWithMargins = True
        Left = 3
        Top = 108
        Width = 302
        Height = 2
        Align = alBottom
        ExplicitLeft = -13
        ExplicitTop = 105
        ExplicitWidth = 327
      end
      object lblTabDefault: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 302
        Height = 20
        Align = alTop
        Caption = 'Chart tabs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 8
        ExplicitTop = 6
        ExplicitWidth = 74
      end
      object cboTab: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 51
        Width = 302
        Height = 24
        HelpContext = 9111
        Style = orcsDropDown
        Align = alTop
        AutoSelect = True
        Caption = 'Initial tab when CPRS starts:'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 1
        TabStop = True
        Text = ''
        CharsNeedMatch = 1
        ExplicitLeft = 8
        ExplicitTop = 48
        ExplicitWidth = 217
      end
      object chkLastTab: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 81
        Width = 302
        Height = 21
        HelpContext = 9112
        Align = alTop
        Caption = 'Use last selected tab on patient change'
        TabOrder = 2
        ExplicitLeft = 8
        ExplicitTop = 78
        ExplicitWidth = 305
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 393
      Width = 308
      Height = 149
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      ExplicitTop = 184
      ExplicitWidth = 314
      object Bevel2: TBevel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 302
        Height = 2
        Align = alTop
        ExplicitLeft = -13
        ExplicitTop = 195
        ExplicitWidth = 327
      end
      object lblEncAppts: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 11
        Width = 302
        Height = 20
        Hint = 'Set date range for Encounter Appointments.'
        Align = alTop
        Caption = 'Set date range for Encounter Appointments:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        WordWrap = True
        ExplicitWidth = 183
      end
      object Panel4: TPanel
        Left = 208
        Top = 34
        Width = 100
        Height = 115
        Align = alRight
        BevelOuter = bvNone
        Caption = 'Panel4'
        ShowCaption = False
        TabOrder = 0
        object btnEncDefaults: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 94
          Height = 26
          HelpContext = 9011
          Align = alTop
          Caption = 'Use Defaults'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnEncDefaultsClick
          ExplicitLeft = 120
          ExplicitTop = 15
          ExplicitWidth = 191
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 34
        Width = 208
        Height = 115
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel5'
        ShowCaption = False
        TabOrder = 1
        ExplicitLeft = -3
        ExplicitTop = 33
        ExplicitHeight = 163
        object Panel6: TPanel
          Left = 0
          Top = 26
          Width = 208
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel6'
          ShowCaption = False
          TabOrder = 0
          object txtTodayMinus: TStaticText
            AlignWithMargins = True
            Left = 16
            Top = 3
            Width = 82
            Height = 25
            Margins.Left = 16
            Align = alLeft
            Alignment = taRightJustify
            Caption = 'Today minus'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
            ExplicitLeft = 40
            ExplicitTop = 11
            ExplicitHeight = 20
          end
          object txtEncStart: TCaptionEdit
            AlignWithMargins = True
            Left = 104
            Top = 3
            Width = 46
            Height = 25
            HelpContext = 9015
            Align = alLeft
            MaxLength = 12
            TabOrder = 1
            Text = '0'
            OnChange = txtEncStartChange
            OnExit = txtEncStartExit
            Caption = 'Stop'
          end
          object spnEncStart: TUpDown
            Tag = 30
            Left = 152
            Top = 3
            Width = 15
            Height = 25
            HelpContext = 9015
            Associate = txtEncStart
            Min = -999
            Max = 999
            TabOrder = 2
            Thousands = False
          end
          object txtDaysMinus: TStaticText
            AlignWithMargins = True
            Left = 171
            Top = 3
            Width = 34
            Height = 25
            Align = alRight
            Caption = 'days'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 3
            ExplicitLeft = 174
            ExplicitTop = 11
            ExplicitHeight = 20
          end
        end
        object stStopEncAppts: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 60
          Width = 202
          Height = 20
          Align = alTop
          Caption = 'Stop Date:'
          TabOrder = 1
          ExplicitLeft = 12
          ExplicitTop = 143
          ExplicitWidth = 67
        end
        object Panel7: TPanel
          Left = 0
          Top = 83
          Width = 208
          Height = 31
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel7'
          ShowCaption = False
          TabOrder = 2
          object txtTodayPlus: TStaticText
            AlignWithMargins = True
            Left = 16
            Top = 3
            Width = 82
            Height = 25
            Margins.Left = 16
            Align = alLeft
            Alignment = taRightJustify
            Caption = 'Today plus'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 0
          end
          object txtEncStop: TCaptionEdit
            AlignWithMargins = True
            Left = 104
            Top = 3
            Width = 46
            Height = 25
            HelpContext = 9015
            Align = alLeft
            MaxLength = 12
            TabOrder = 1
            Text = '0'
            OnChange = txtEncStopChange
            OnExit = txtEncStopExit
            Caption = 'Stop'
          end
          object txtDaysPlus: TStaticText
            AlignWithMargins = True
            Left = 171
            Top = 3
            Width = 34
            Height = 25
            Align = alRight
            Caption = 'days'
            Color = clBtnFace
            ParentColor = False
            TabOrder = 2
            ExplicitLeft = 174
            ExplicitTop = 11
            ExplicitHeight = 20
          end
          object spnEncStop: TUpDown
            Tag = 30
            Left = 152
            Top = 3
            Width = 15
            Height = 25
            HelpContext = 9015
            Associate = txtEncStop
            Min = -999
            Max = 999
            TabOrder = 3
            Thousands = False
          end
        end
        object stStartEncAppts: TStaticText
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 202
          Height = 20
          Align = alTop
          Caption = 'Start Date:'
          TabOrder = 3
        end
      end
    end
    object grpOverAll: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 145
      Width = 302
      Height = 77
      Align = alTop
      Caption = 'Overall Meds Default'
      TabOrder = 2
      ExplicitTop = 132
      ExplicitWidth = 305
      object stStart: TStaticText
        Left = 26
        Top = 25
        Width = 66
        Height = 20
        Caption = 'Start Date:'
        TabOrder = 0
      end
      object dtStart: TORDateBox
        Left = 104
        Top = 21
        Width = 187
        Height = 24
        Hint = 
          'Start Date for All Meds -Overriden by Inpatient/Outpatient Setti' +
          'ngs Below'
        TabOrder = 1
        OnChange = dtStartChange
        OnExit = dtStartExit
        DateOnly = True
        RequireTime = False
        Caption = 'Start Date'
      end
      object stStop: TStaticText
        Left = 26
        Top = 48
        Width = 67
        Height = 20
        Caption = 'Stop Date:'
        TabOrder = 3
      end
      object dtStop: TORDateBox
        Left = 104
        Top = 48
        Width = 186
        Height = 24
        Hint = 
          'Stop Date for All Meds -Overriden by Inpatient/Outpatient Settin' +
          'gs Below'
        TabOrder = 4
        OnExit = dtStopExit
        DateOnly = True
        RequireTime = False
        Caption = 'Stop Date'
      end
    end
    object grpInpatientMeds: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 228
      Width = 302
      Height = 77
      Align = alTop
      Caption = 'Inpatient Meds'
      TabOrder = 3
      ExplicitTop = 215
      ExplicitWidth = 305
      object stStartIn: TStaticText
        Left = 26
        Top = 25
        Width = 66
        Height = 20
        Caption = 'Start Date:'
        TabOrder = 0
      end
      object dtStartIn: TORDateBox
        Left = 104
        Top = 21
        Width = 187
        Height = 24
        Hint = 'Start Date for Inpatient (Unit Dose/IV) Meds'
        TabOrder = 1
        OnExit = dtStartInExit
        DateOnly = True
        RequireTime = False
        Caption = 'Start Date'
      end
      object stStopIn: TStaticText
        Left = 26
        Top = 48
        Width = 67
        Height = 20
        Caption = 'Stop Date:'
        TabOrder = 3
      end
      object dtStopIn: TORDateBox
        Left = 104
        Top = 48
        Width = 186
        Height = 24
        Hint = 'Stop Date for Inpatient (Unit Dose/IV) Meds'
        TabOrder = 4
        OnExit = dtStopInExit
        DateOnly = True
        RequireTime = False
        Caption = 'Stop Date'
      end
    end
    object grpOutpatientMeds: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 311
      Width = 302
      Height = 77
      Align = alTop
      Caption = 'Outpatient / non-VA Meds'
      TabOrder = 4
      ExplicitTop = 298
      ExplicitWidth = 305
      object stStartOp: TStaticText
        Left = 26
        Top = 25
        Width = 66
        Height = 20
        Caption = 'Start Date:'
        TabOrder = 0
      end
      object dtStartOp: TORDateBox
        Left = 104
        Top = 21
        Width = 187
        Height = 24
        Hint = 'Start Date for Outpatient / non-VA Meds'
        TabOrder = 1
        OnExit = dtStartOpExit
        DateOnly = True
        RequireTime = False
        Caption = 'Start Date'
      end
      object stStopOp: TStaticText
        Left = 26
        Top = 48
        Width = 67
        Height = 20
        Caption = 'Stop Date:'
        TabOrder = 3
      end
      object dtStopOp: TORDateBox
        Left = 104
        Top = 48
        Width = 186
        Height = 24
        Hint = 'Stop Date for Outpatient / non-VA Meds'
        TabOrder = 4
        OnExit = dtStopOpExit
        DateOnly = True
        RequireTime = False
        Caption = 'Stop Date'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 264
    Top = 8
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lblTabDefault'
        'Status = stsDefault')
      (
        'Component = cboTab'
        'Status = stsDefault')
      (
        'Component = chkLastTab'
        'Status = stsDefault')
      (
        'Component = stStartEncAppts'
        'Status = stsDefault')
      (
        'Component = txtTodayMinus'
        'Status = stsDefault')
      (
        'Component = txtEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysMinus'
        'Status = stsDefault')
      (
        'Component = spnEncStart'
        'Status = stsDefault')
      (
        'Component = txtDaysPlus'
        'Status = stsDefault')
      (
        'Component = spnEncStop'
        'Status = stsDefault')
      (
        'Component = txtEncStop'
        'Status = stsDefault')
      (
        'Component = txtTodayPlus'
        'Status = stsDefault')
      (
        'Component = stStopEncAppts'
        'Status = stsDefault')
      (
        'Component = btnEncDefaults'
        'Status = stsDefault')
      (
        'Component = frmOptionsOther'
        'Status = stsDefault')
      (
        'Component = grpOverAll'
        'Status = stsDefault')
      (
        'Component = stStart'
        'Status = stsDefault')
      (
        'Component = dtStart'
        'Status = stsDefault')
      (
        'Component = stStop'
        'Status = stsDefault')
      (
        'Component = dtStop'
        'Status = stsDefault')
      (
        'Component = grpInpatientMeds'
        'Status = stsDefault')
      (
        'Component = stStartIn'
        'Status = stsDefault')
      (
        'Component = dtStartIn'
        'Status = stsDefault')
      (
        'Component = stStopIn'
        'Status = stsDefault')
      (
        'Component = dtStopIn'
        'Status = stsDefault')
      (
        'Component = grpOutpatientMeds'
        'Status = stsDefault')
      (
        'Component = stStartOp'
        'Status = stsDefault')
      (
        'Component = dtStartOp'
        'Status = stsDefault')
      (
        'Component = stStopOp'
        'Status = stsDefault')
      (
        'Component = dtStopOp'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault'))
  end
end
