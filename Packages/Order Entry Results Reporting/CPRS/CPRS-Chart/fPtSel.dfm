inherited frmPtSel: TfrmPtSel
  Left = 290
  Top = 232
  BorderIcons = [biSystemMenu]
  Caption = 'Patient Selection'
  ClientHeight = 555
  ClientWidth = 785
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 801
  ExplicitHeight = 593
  PixelsPerInch = 96
  TextHeight = 13
  object sptVert: TSplitter [0]
    Left = 0
    Top = 290
    Width = 785
    Height = 4
    Cursor = crVSplit
    Align = alTop
  end
  object pnlDivide: TORAutoPanel [1]
    Left = 0
    Top = 294
    Width = 785
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    BevelWidth = 2
    TabOrder = 0
    Visible = False
    object lblNotifications: TLabel
      Left = 4
      Top = 4
      Width = 58
      Height = 13
      Caption = 'Notifications'
    end
    object ggeInfo: TGauge
      Left = 212
      Top = 1
      Width = 100
      Height = 15
      BackColor = clHighlightText
      Color = clBtnFace
      ForeColor = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Progress = 0
      Visible = False
    end
  end
  object pnlPtSel: TORAutoPanel [2]
    Left = 0
    Top = 0
    Width = 785
    Height = 290
    Align = alTop
    BevelWidth = 2
    TabOrder = 3
    OnResize = pnlPtSelResize
    object lblPatient: TLabel
      Left = 216
      Top = 4
      Width = 33
      Height = 13
      Caption = 'Patient'
      ShowAccelChar = False
    end
    object lblPtDemo: TLabel
      Left = 494
      Top = 4
      Width = 104
      Height = 13
      Caption = 'Patient Demographics'
    end
    object cboPatient: TORComboBox
      Left = 216
      Top = 33
      Width = 272
      Height = 251
      Hint = 'Enter name or use "Last 4" (x1234) format'
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Patient'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      ParentShowHint = False
      Pieces = '2,3'
      ShowHint = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20,25,30'
      TabOrder = 1
      Text = ''
      OnChange = cboPatientChange
      OnDblClick = cboPatientDblClick
      OnEnter = cboPatientEnter
      OnExit = cboPatientExit
      OnKeyDown = cboPatientKeyDown
      OnKeyUp = cboPatientKeyUp
      OnKeyPause = cboPatientKeyPause
      OnMouseClick = cboPatientMouseClick
      OnNeedData = cboPatientNeedData
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cmdOK: TButton
      Left = 682
      Top = 3
      Width = 78
      Height = 21
      Caption = 'OK'
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 682
      Top = 24
      Width = 78
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object cmdSaveList: TButton
      Left = 494
      Top = 252
      Width = 175
      Height = 21
      Caption = 'Save Patient List Settings'
      TabOrder = 0
      OnClick = cmdSaveListClick
    end
  end
  object pnlNotifications: TORAutoPanel [3]
    Left = 0
    Top = 520
    Width = 785
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object txtCmdComments: TVA508StaticText
      Name = 'txtCmdComments'
      Left = 441
      Top = 0
      Width = 159
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Show Comments Button Disabled'
      TabOrder = 7
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdRemove: TVA508StaticText
      Name = 'txtCmdRemove'
      Left = 577
      Top = 0
      Width = 120
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Remove Button Disabled'
      TabOrder = 9
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdForward: TVA508StaticText
      Name = 'txtCmdForward'
      Left = 344
      Top = 0
      Width = 118
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Forward Button Disabled'
      TabOrder = 5
      Visible = False
      ShowAccelChar = True
    end
    object txtCmdProcess: TVA508StaticText
      Name = 'txtCmdProcess'
      Left = 232
      Top = 0
      Width = 118
      Height = 15
      Alignment = taLeftJustify
      Caption = 'Process Button Disabled'
      TabOrder = 3
      Visible = False
      ShowAccelChar = True
    end
    object cmdRemove: TButton
      Left = 577
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Remove'
      Enabled = False
      TabOrder = 8
      OnClick = cmdRemoveClick
    end
    object cmdComments: TButton
      Left = 441
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Show Comments'
      Enabled = False
      TabOrder = 6
      OnClick = cmdCommentsClick
    end
    object cmdForward: TButton
      Left = 335
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Forward'
      Enabled = False
      TabOrder = 4
      OnClick = cmdForwardClick
    end
    object cmdProcess: TButton
      Left = 229
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process'
      Enabled = False
      TabOrder = 2
      OnClick = cmdProcessClick
    end
    object cmdProcessAll: TButton
      Left = 120
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process All'
      TabOrder = 1
      OnClick = cmdProcessAllClick
    end
    object cmdProcessInfo: TButton
      Left = 11
      Top = 10
      Width = 95
      Height = 21
      Caption = 'Process Info'
      TabOrder = 0
      OnClick = cmdProcessInfoClick
    end
  end
  object lstvAlerts: TCaptionListView [4]
    Left = 0
    Top = 311
    Width = 785
    Height = 209
    Align = alClient
    Columns = <
      item
        Caption = 'Info'
        Width = 30
      end
      item
        Caption = 'Patient'
        Tag = 1
        Width = 120
      end
      item
        Caption = 'Location'
        Tag = 2
        Width = 60
      end
      item
        Caption = 'Urgency'
        Tag = 3
        Width = 67
      end
      item
        Caption = 'Alert Date/Time'
        Tag = 4
        Width = 110
      end
      item
        Caption = 'Message'
        Tag = 5
        Width = 280
      end
      item
        Caption = 'Forwarded By/When'
        Tag = 6
        Width = 180
      end>
    HideSelection = False
    HoverTime = 0
    IconOptions.WrapText = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = popNotifications
    ShowWorkAreas = True
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = lstvAlertsColumnClick
    OnCompare = lstvAlertsCompare
    OnDblClick = lstvAlertsDblClick
    OnInfoTip = lstvAlertsInfoTip
    OnKeyDown = lstvAlertsKeyDown
    OnMouseUp = lstvAlertsMouseUp
    OnSelectItem = lstvAlertsSelectItem
    Caption = 'Notifications'
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlDivide'
        'Status = stsDefault')
      (
        'Component = pnlPtSel'
        'Status = stsDefault')
      (
        'Component = cboPatient'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdSaveList'
        'Status = stsDefault')
      (
        'Component = pnlNotifications'
        'Status = stsDefault')
      (
        'Component = cmdProcessInfo'
        'Status = stsDefault')
      (
        'Component = cmdProcessAll'
        'Status = stsDefault')
      (
        'Component = cmdProcess'
        'Status = stsDefault')
      (
        'Component = cmdForward'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = lstvAlerts'
        'Status = stsDefault')
      (
        'Component = frmPtSel'
        'Status = stsDefault')
      (
        'Component = cmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdComments'
        'Status = stsDefault')
      (
        'Component = txtCmdRemove'
        'Status = stsDefault')
      (
        'Component = txtCmdForward'
        'Status = stsDefault')
      (
        'Component = txtCmdProcess'
        'Status = stsDefault'))
  end
  object popNotifications: TPopupMenu
    Left = 508
    Top = 323
    object mnuProcess: TMenuItem
      Caption = 'Process'
      OnClick = cmdProcessClick
    end
    object mnuForward: TMenuItem
      Caption = 'Forward'
      OnClick = cmdForwardClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuRemove: TMenuItem
      Caption = 'Remove'
      OnClick = cmdRemoveClick
    end
  end
end
