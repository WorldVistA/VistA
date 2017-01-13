inherited frmVisit: TfrmVisit
  Left = 426
  Top = 332
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Visit Selection'
  ClientHeight = 273
  ClientWidth = 438
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 444
  ExplicitHeight = 301
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 438
    Height = 273
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblSelect: TLabel
      Left = 8
      Top = 97
      Width = 146
      Height = 13
      Caption = 'Scheduled Clinic Appointments'
    end
    object lblVisitDate: TLabel
      Left = 254
      Top = 97
      Width = 85
      Height = 13
      Caption = 'Date/Time of Visit'
      Visible = False
    end
    object lblInstruct: TStaticText
      Left = 8
      Top = 8
      Width = 426
      Height = 17
      Caption = 
        'For outpatient encounters, a visit must be selected before writi' +
        'ng orders or progress notes.'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
      TabOrder = 7
    end
    object pnlVisit: TORAutoPanel
      Left = 8
      Top = 111
      Width = 422
      Height = 118
      BevelOuter = bvNone
      TabOrder = 4
      object timVisitDate: TORDateBox
        Left = 246
        Top = 0
        Width = 175
        Height = 21
        TabOrder = 1
        Text = 'NOW'
        DateOnly = False
        RequireTime = True
        Caption = ''
      end
      object cboLocation: TORComboBox
        Left = 0
        Top = -5
        Width = 230
        Height = 118
        Style = orcsSimple
        AutoSelect = True
        Caption = ''
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnNeedData = cboLocationNeedData
        CharsNeedMatch = 1
      end
      object grpCategory: TGroupBox
        Left = 248
        Top = 40
        Width = 175
        Height = 73
        Caption = 'Visit Category'
        TabOrder = 2
        object ckbHistorical: TCheckBox
          Left = 8
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Historical Visit'
          TabOrder = 0
        end
      end
    end
    object lstVisit: TORListBox
      Left = 8
      Top = 111
      Width = 422
      Height = 118
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Caption = 'Scheduled Clinic Appointments'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '3,5,4'
      TabPositions = '20'
    end
    object radAppt: TRadioButton
      Tag = 1
      Left = 8
      Top = 30
      Width = 233
      Height = 17
      Caption = 'Choose from &Clinic Appointments'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = radSelectorClick
    end
    object radAdmit: TRadioButton
      Tag = 2
      Left = 8
      Top = 51
      Width = 201
      Height = 17
      Caption = 'Choose from &Hospital Admissions'
      TabOrder = 1
      OnClick = radSelectorClick
    end
    object radNewVisit: TRadioButton
      Tag = 3
      Left = 8
      Top = 72
      Width = 189
      Height = 17
      Caption = 'Enter a &New Visit'
      TabOrder = 2
      OnClick = radSelectorClick
    end
    object cmdOK: TButton
      Left = 270
      Top = 245
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 5
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 358
      Top = 245
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 6
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = lblInstruct'
        'Status = stsDefault')
      (
        'Component = pnlVisit'
        'Status = stsDefault')
      (
        'Component = timVisitDate'
        'Text = Date/Time of visit. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cboLocation'
        'Status = stsDefault')
      (
        'Component = grpCategory'
        'Status = stsDefault')
      (
        'Component = ckbHistorical'
        'Status = stsDefault')
      (
        'Component = lstVisit'
        'Status = stsDefault')
      (
        'Component = radAppt'
        'Status = stsDefault')
      (
        'Component = radAdmit'
        'Status = stsDefault')
      (
        'Component = radNewVisit'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmVisit'
        'Status = stsDefault'))
  end
end
