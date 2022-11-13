inherited frmOptionsReportsCustom: TfrmOptionsReportsCustom
  Left = 414
  Top = 329
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Individual CPRS Report Settings'
  ClientHeight = 381
  ClientWidth = 514
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 520
  ExplicitHeight = 406
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel3: TBevel [0]
    Left = 0
    Top = 347
    Width = 514
    Height = 2
    Align = alBottom
    ExplicitTop = 356
    ExplicitWidth = 503
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 349
    Width = 514
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 358
    ExplicitWidth = 503
    object btnApply: TButton
      AlignWithMargins = True
      Left = 433
      Top = 3
      Width = 78
      Height = 26
      Hint = 'Click to save new settings'
      Align = alRight
      Caption = 'Apply'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnApplyClick
      ExplicitLeft = 432
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 345
      Top = 3
      Width = 82
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 344
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 243
      Top = 3
      Width = 96
      Height = 26
      Align = alRight
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 264
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 514
    Height = 347
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 503
    ExplicitHeight = 353
    object grdReport: TCaptionStringGrid
      AlignWithMargins = True
      Left = 3
      Top = 60
      Width = 508
      Height = 284
      Align = alClient
      ColCount = 4
      DefaultRowHeight = 20
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 16
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs]
      ScrollBars = ssVertical
      TabOrder = 5
      OnDrawCell = grdReportDrawCell
      OnKeyDown = grdReportKeyDown
      OnKeyPress = grdReportKeyPress
      OnMouseDown = grdReportMouseDown
      Caption = 'Report Grid'
      ExplicitLeft = 1
      ExplicitTop = 73
      ExplicitWidth = 501
      ExplicitHeight = 272
      ColWidths = (
        219
        97
        89
        71)
    end
    object edtMax: TCaptionEdit
      Left = 264
      Top = 328
      Width = 89
      Height = 20
      BorderStyle = bsNone
      TabOrder = 1
      Visible = False
      OnExit = edtMaxExit
      OnKeyPress = edtMaxKeyPress
      Caption = ''
    end
    object odbStop: TORDateBox
      Left = 136
      Top = 328
      Width = 113
      Height = 24
      TabOrder = 3
      Visible = False
      OnExit = odbStopExit
      OnKeyPress = odbStopKeyPress
      DateOnly = True
      RequireTime = False
      Caption = 'Stop Date'
    end
    object odbStart: TORDateBox
      Left = 8
      Top = 328
      Width = 113
      Height = 24
      TabOrder = 2
      Visible = False
      OnExit = odbStartExit
      OnKeyPress = odbStartKeyPress
      DateOnly = True
      RequireTime = False
      Caption = 'Start Date'
    end
    object odbTool: TORDateBox
      Left = 360
      Top = 328
      Width = 121
      Height = 24
      TabOrder = 4
      Visible = False
      DateOnly = True
      RequireTime = False
      Caption = 'Date'
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 514
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 503
      object Label1: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 508
        Height = 16
        Align = alTop
        Caption = 'Type the first few letters of the report you are looking for:'
        ExplicitLeft = 16
        ExplicitTop = 8
        ExplicitWidth = 327
      end
      object edtSearch: TCaptionEdit
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 508
        Height = 24
        Align = alTop
        TabOrder = 0
        OnChange = edtSearchChange
        OnKeyPress = edtSearchKeyPress
        Caption = 'Type the first few letters of the report you are looking for:'
        ExplicitLeft = 24
        ExplicitTop = 32
        ExplicitWidth = 433
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 48
    Top = 136
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = grdReport'
        'Status = stsDefault')
      (
        'Component = edtMax'
        'Status = stsDefault')
      (
        'Component = odbStop'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = odbStart'
        'Text = start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = odbTool'
        'Text = Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = edtSearch'
        'Status = stsDefault')
      (
        'Component = frmOptionsReportsCustom'
        'Status = stsDefault'))
  end
end
