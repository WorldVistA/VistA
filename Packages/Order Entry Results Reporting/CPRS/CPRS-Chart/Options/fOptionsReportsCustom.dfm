inherited frmOptionsReportsCustom: TfrmOptionsReportsCustom
  Left = 414
  Top = 329
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Individual CPRS Report Settings'
  ClientHeight = 387
  ClientWidth = 503
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 509
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel3: TBevel [0]
    Left = 0
    Top = 356
    Width = 503
    Height = 2
    Align = alBottom
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 358
    Width = 503
    Height = 29
    Align = alBottom
    TabOrder = 1
    object btnApply: TButton
      Left = 432
      Top = 4
      Width = 50
      Height = 22
      Hint = 'Click to save new settings'
      Caption = 'Apply'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 368
      Top = 4
      Width = 50
      Height = 22
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 304
      Top = 4
      Width = 51
      Height = 22
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 503
    Height = 353
    Align = alTop
    TabOrder = 0
    object grdReport: TCaptionStringGrid
      Left = 1
      Top = 73
      Width = 501
      Height = 272
      Align = alTop
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
      Height = 21
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
      Height = 21
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
      Height = 21
      TabOrder = 4
      Visible = False
      DateOnly = True
      RequireTime = False
      Caption = 'Date'
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 501
      Height = 72
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 8
        Width = 265
        Height = 13
        Caption = 'Type the first few letters of the report you are looking for:'
      end
      object edtSearch: TCaptionEdit
        Left = 24
        Top = 32
        Width = 433
        Height = 21
        TabOrder = 0
        OnChange = edtSearchChange
        OnKeyPress = edtSearchKeyPress
        Caption = 'Type the first few letters of the report you are looking for:'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
