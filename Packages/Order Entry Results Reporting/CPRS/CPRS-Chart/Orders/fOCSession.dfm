inherited frmOCSession: TfrmOCSession
  Left = 366
  Top = 222
  BorderIcons = []
  Caption = 'Order Checks'
  ClientHeight = 580
  ClientWidth = 816
  Constraints.MinHeight = 625
  Constraints.MinWidth = 750
  DefaultMonitor = dmMainForm
  DoubleBuffered = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 834
  ExplicitHeight = 625
  PixelsPerInch = 120
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 424
    Width = 816
    Height = 156
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    DesignSize = (
      816
      156)
    object lblJustify: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 62
      Width = 806
      Height = 16
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Enter reason for overriding order checks:'
      ExplicitWidth = 241
    end
    object memNote: TMemo
      AlignWithMargins = True
      Left = 400
      Top = 4
      Width = 406
      Height = 50
      Margins.Left = 400
      Margins.Top = 4
      Margins.Right = 10
      Margins.Bottom = 4
      Align = alTop
      Alignment = taRightJustify
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'NOTE: The override reason is for tracking purposes'
        'and does not change or place new order(s).')
      ReadOnly = True
      TabOrder = 0
      OnEnter = memNoteEnter
      ExplicitWidth = 410
    end
    object txtJustify: TCaptionEdit
      AlignWithMargins = True
      Left = 6
      Top = 86
      Width = 804
      Height = 27
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 6
      Margins.Bottom = 4
      Align = alTop
      AutoSize = False
      MaxLength = 80
      TabOrder = 3
      OnKeyDown = txtJustifyKeyDown
      Caption = 'Enter justification for overriding critical order checks -'
    end
    object cmdCancelOrder: TButton
      Left = 4
      Top = 1
      Width = 219
      Height = 32
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel Checked Order(s)'
      ModalResult = 4
      TabOrder = 1
      OnClick = cmdCancelOrderClick
    end
    object cmdContinue: TButton
      Left = 266
      Top = 118
      Width = 157
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Accept Order(s)'
      TabOrder = 4
      OnClick = cmdContinueClick
    end
    object btnReturn: TButton
      Left = 430
      Top = 118
      Width = 156
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Return to Orders'
      TabOrder = 5
      OnClick = btnReturnClick
    end
    object cmdMonograph: TButton
      Left = 594
      Top = 118
      Width = 219
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Drug Interaction Monograph'
      TabOrder = 6
      OnClick = cmdMonographClick
    end
  end
  object pnlTop: TORAutoPanel [1]
    Left = 0
    Top = 0
    Width = 816
    Height = 424
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    object lblHover: TLabel
      AlignWithMargins = True
      Left = 19
      Top = 47
      Width = 793
      Height = 16
      Margins.Left = 19
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 
        'If the order check description is cut short, hover over the text' +
        ' to view the complete description.'
      WordWrap = True
      ExplicitTop = 39
      ExplicitWidth = 545
    end
    object grdchecks: TCaptionStringGrid
      AlignWithMargins = True
      Left = 4
      Top = 67
      Width = 808
      Height = 353
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ColCount = 3
      DefaultDrawing = False
      FixedColor = clBtnShadow
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowMoving, goTabs]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = grdchecksDrawCell
      OnEnter = grdchecksEnter
      OnKeyDown = grdchecksKeyDown
      OnMouseDown = grdchecksMouseDown
      OnMouseMove = grdchecksMouseMove
      OnSelectCell = grdchecksSelectCell
      Caption = ''
      JustToTab = True
      ExplicitTop = 59
      ExplicitHeight = 361
    end
    object pnlInstr: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 808
      Height = 35
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 
        'To cancel an order select the order by checking the checkbox and' +
        ' press the "Cancel Checked Order(s)" button.'
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 744
    Top = 88
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = txtJustify'
        'Status = stsDefault')
      (
        'Component = cmdCancelOrder'
        'Status = stsDefault')
      (
        'Component = cmdContinue'
        'Status = stsDefault')
      (
        'Component = btnReturn'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault')
      (
        'Component = frmOCSession'
        'Status = stsDefault')
      (
        'Component = cmdMonograph'
        'Status = stsDefault')
      (
        'Component = grdchecks'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlInstr'
        'Status = stsDefault'))
  end
end
