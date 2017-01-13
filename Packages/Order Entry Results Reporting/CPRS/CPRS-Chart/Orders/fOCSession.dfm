inherited frmOCSession: TfrmOCSession
  Left = 366
  Top = 222
  Width = 844
  Height = 615
  HorzScrollBar.Visible = True
  VertScrollBar.Visible = True
  AutoScroll = True
  BorderIcons = []
  Caption = 'Order Checks'
  Constraints.MinHeight = 615
  Constraints.MinWidth = 615
  DefaultMonitor = dmMainForm
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnShow = FormShow
  ExplicitWidth = 844
  ExplicitHeight = 615
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBottom: TPanel [0]
    Left = 3
    Top = 420
    Width = 825
    Height = 155
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 810
    DesignSize = (
      825
      155)
    object lblJustify: TLabel
      Left = 10
      Top = 61
      Width = 283
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      Caption = 'Enter reason for overriding order checks:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memNote: TMemo
      Left = 450
      Top = 1
      Width = 359
      Height = 49
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'NOTE: The override reason is for tracking purposes and '
        'does not change or place new order(s).')
      ReadOnly = True
      TabOrder = 0
      OnEnter = memNoteEnter
      ExplicitLeft = 454
    end
    object txtJustify: TCaptionEdit
      Left = 10
      Top = 85
      Width = 805
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akRight]
      AutoSize = False
      MaxLength = 80
      TabOrder = 3
      OnKeyDown = txtJustifyKeyDown
      Caption = 'Enter justification for overriding critical order checks -'
      ExplicitWidth = 790
    end
    object cmdCancelOrder: TButton
      Left = 11
      Top = 1
      Width = 207
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel Checked Order(s)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 4
      ParentFont = False
      TabOrder = 1
      OnClick = cmdCancelOrderClick
    end
    object cmdContinue: TButton
      Left = 112
      Top = 119
      Width = 156
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akBottom]
      Caption = 'Accept Order(s)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = cmdContinueClick
      ExplicitLeft = 59
    end
    object btnReturn: TButton
      Left = 338
      Top = 119
      Width = 150
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akBottom]
      Cancel = True
      Caption = 'Return to Orders'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnReturnClick
      ExplicitLeft = 223
    end
    object cmdMonograph: TButton
      Left = 610
      Top = 119
      Width = 199
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'Drug Interaction Monograph'
      TabOrder = 6
      OnClick = cmdMonographClick
      ExplicitLeft = 595
    end
  end
  object pnlTop: TORAutoPanel [1]
    Left = 0
    Top = 0
    Width = 828
    Height = 412
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 813
    DesignSize = (
      828
      412)
    object lblHover: TLabel
      Left = 20
      Top = 39
      Width = 545
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 
        'If the order check description is cut short, hover over the text' +
        ' to view the complete description.'
    end
    object grdchecks: TCaptionStringGrid
      Left = 10
      Top = 61
      Width = 805
      Height = 351
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColCount = 3
      DefaultDrawing = False
      FixedColor = clBtnShadow
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowMoving, goTabs]
      ScrollBars = ssVertical
      TabOrder = 1
      OnDrawCell = grdchecksDrawCell
      OnEnter = grdchecksEnter
      OnKeyDown = grdchecksKeyDown
      OnMouseDown = grdchecksMouseDown
      OnMouseMove = grdchecksMouseMove
      OnMouseWheelDown = grdchecksMouseWheelDown
      OnMouseWheelUp = grdchecksMouseWheelUp
      OnSelectCell = grdchecksSelectCell
      Caption = ''
      JustToTab = True
      ExplicitWidth = 790
    end
    object lblInstr: TVA508StaticText
      Name = 'lblInstr'
      Left = 0
      Top = 15
      Width = 768
      Height = 18
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 0
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 
        'To cancel an order select the order by checking the checkbox and' +
        ' press the "Cancel Checked Order(s)" button.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 792
    Top = 8
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
        'Status = stsDefault'))
  end
end
