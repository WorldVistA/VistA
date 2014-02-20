inherited frmOCSession: TfrmOCSession
  Left = 366
  Top = 222
  Width = 714
  Height = 530
  HorzScrollBar.Visible = True
  VertScrollBar.Visible = True
  AutoScroll = True
  BorderIcons = []
  Caption = 'Order Checks'
  Constraints.MinHeight = 500
  Constraints.MinWidth = 500
  DefaultMonitor = dmMainForm
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseWheelDown = FormMouseWheelDown
  OnShow = FormShow
  ExplicitWidth = 714
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 352
    Width = 706
    Height = 146
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      706
      146)
    object lblJustify: TLabel
      Left = 9
      Top = 58
      Width = 234
      Height = 13
      Anchors = [akLeft]
      Caption = 'Enter reason for overriding order checks:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object memNote: TMemo
      Left = 392
      Top = 12
      Width = 306
      Height = 40
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        'NOTE: The override reason is for tracking purposes and '
        'does not change or place new order(s).')
      ReadOnly = True
      TabOrder = 0
      OnEnter = memNoteEnter
    end
    object txtJustify: TCaptionEdit
      Left = 8
      Top = 80
      Width = 682
      Height = 21
      Anchors = [akLeft]
      AutoSize = False
      MaxLength = 80
      TabOrder = 3
      OnKeyDown = txtJustifyKeyDown
      Caption = 'Enter justification for overriding critical order checks -'
    end
    object cmdCancelOrder: TButton
      Left = 9
      Top = 17
      Width = 168
      Height = 21
      Caption = 'Cancel Checked Order(s)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 4
      ParentFont = False
      TabOrder = 1
      OnClick = cmdCancelOrderClick
    end
    object cmdContinue: TButton
      Left = 219
      Top = 112
      Width = 127
      Height = 23
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Accept Order(s)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = cmdContinueClick
    end
    object btnReturn: TButton
      Left = 352
      Top = 112
      Width = 122
      Height = 23
      Anchors = [akLeft, akTop, akRight, akBottom]
      Cancel = True
      Caption = 'Return to Orders'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = btnReturnClick
    end
    object cmdMonograph: TButton
      Left = 536
      Top = 107
      Width = 162
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'Drug Interaction Monograph'
      TabOrder = 6
      OnClick = cmdMonographClick
    end
  end
  object pnlTop: TORAutoPanel [1]
    Left = 0
    Top = 0
    Width = 706
    Height = 346
    Align = alTop
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      706
      346)
    object lblHover: TLabel
      Left = 16
      Top = 32
      Width = 445
      Height = 13
      Caption = 
        'If the order check description is cut short, hover over the text' +
        ' to view the complete description.'
    end
    object grdchecks: TCaptionStringGrid
      Left = 16
      Top = 67
      Width = 682
      Height = 279
      Margins.Top = 0
      Anchors = [akLeft, akBottom]
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
      JustToTab = True
    end
    object lblInstr: TVA508StaticText
      Name = 'lblInstr'
      Left = 0
      Top = 12
      Width = 641
      Height = 15
      Margins.Bottom = 0
      Alignment = taLeftJustify
      AutoSize = True
      Caption = 
        'To cancel an order select the order by checking the checkbox and' +
        ' press the "Cancel Checked Order(s)" button.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
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
