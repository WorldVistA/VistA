inherited frmPrintLocation: TfrmPrintLocation
  Left = 293
  Top = 250
  Height = 472
  AutoScroll = True
  BorderIcons = []
  Caption = 'Order Location'
  Constraints.MinWidth = 542
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  ExplicitWidth = 542
  ExplicitHeight = 472
  DesignSize = (
    526
    434)
  PixelsPerInch = 96
  TextHeight = 16
  object lblEncounter: TLabel [0]
    Left = 0
    Top = 466
    Width = 347
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Where would you like to continue processing patient data? '
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 636
    Height = 188
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object lblText: TLabel
      Left = 10
      Top = 20
      Width = 3
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object orpnlTopBottom: TORAutoPanel
      Left = 0
      Top = 138
      Width = 636
      Height = 50
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object btnClinic: TButton
        Left = 178
        Top = 10
        Width = 93
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'All Clinic'
        TabOrder = 0
        OnClick = btnClinicClick
      end
      object btnWard: TButton
        Left = 283
        Top = 10
        Width = 92
        Height = 31
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'All Ward'
        TabOrder = 1
        OnClick = btnWardClick
      end
    end
  end
  object pnlBottom: TORAutoPanel [2]
    Left = 0
    Top = 196
    Width = 544
    Height = 258
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    object orderGrid: TStringGrid
      Left = 1
      Top = 1
      Width = 542
      Height = 256
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ColCount = 3
      Constraints.MinWidth = 542
      DefaultRowHeight = 30
      DefaultDrawing = False
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnDrawCell = OrderGridDrawCell
      OnKeyPress = orderGridKeyPress
      OnMouseDown = orderGridMouseDown
    end
    object pnlOrder: TPanel
      Left = 325
      Top = 69
      Width = 119
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      Visible = False
    end
    object cbolocation: TORComboBox
      Left = 295
      Top = 128
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 1
      MaxLength = 0
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      Visible = False
      OnChange = cbolocationChange
      OnExit = cbolocationExit
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
  end
  object ORpnlBottom: TORAutoPanel [3]
    Left = 0
    Top = 497
    Width = 544
    Height = 51
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 3
    object btnOK: TButton
      Left = 230
      Top = 4
      Width = 92
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object cboEncLoc: TComboBox [4]
    Left = 350
    Top = 462
    Width = 220
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = orpnlTopBottom'
        'Status = stsDefault')
      (
        'Component = btnClinic'
        'Status = stsDefault')
      (
        'Component = btnWard'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = orderGrid'
        'Status = stsDefault')
      (
        'Component = pnlOrder'
        'Status = stsDefault')
      (
        'Component = cbolocation'
        'Status = stsDefault')
      (
        'Component = ORpnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = cboEncLoc'
        'Status = stsDefault')
      (
        'Component = frmPrintLocation'
        'Status = stsDefault'))
  end
end
