inherited frmPrintLocation: TfrmPrintLocation
  Left = 293
  Top = 250
  Width = 450
  Height = 472
  AutoScroll = True
  BorderIcons = []
  Caption = 'Order Location'
  Constraints.MinWidth = 440
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  ExplicitWidth = 450
  ExplicitHeight = 472
  DesignSize = (
    442
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object lblEncounter: TLabel [0]
    Left = 0
    Top = 379
    Width = 280
    Height = 13
    Caption = 'Where would you like to continue processing patient data? '
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 442
    Height = 153
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object lblText: TLabel
      Left = 8
      Top = 16
      Width = 3
      Height = 13
    end
    object orpnlTopBottom: TORAutoPanel
      Left = 0
      Top = 112
      Width = 442
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object btnClinic: TButton
        Left = 145
        Top = 8
        Width = 75
        Height = 25
        Caption = 'All Clinic'
        TabOrder = 0
        OnClick = btnClinicClick
      end
      object btnWard: TButton
        Left = 230
        Top = 8
        Width = 75
        Height = 25
        Caption = 'All Ward'
        TabOrder = 1
        OnClick = btnWardClick
      end
    end
  end
  object pnlBottom: TORAutoPanel [2]
    Left = 0
    Top = 159
    Width = 442
    Height = 210
    TabOrder = 1
    object orderGrid: TStringGrid
      Left = 1
      Top = 1
      Width = 440
      Height = 208
      Align = alClient
      ColCount = 3
      Constraints.MinWidth = 440
      DefaultRowHeight = 30
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnDrawCell = OrderGridDrawCell
      OnKeyPress = orderGridKeyPress
      OnMouseDown = orderGridMouseDown
    end
    object pnlOrder: TPanel
      Left = 264
      Top = 56
      Width = 97
      Height = 25
      TabOrder = 0
      Visible = False
    end
    object cbolocation: TORComboBox
      Left = 240
      Top = 104
      Width = 121
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 1
      MaxLength = 0
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Visible = False
      OnChange = cbolocationChange
      OnExit = cbolocationExit
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
  end
  object ORpnlBottom: TORAutoPanel [3]
    Left = 0
    Top = 404
    Width = 442
    Height = 41
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 3
    object btnOK: TButton
      Left = 187
      Top = 3
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object cboEncLoc: TComboBox [4]
    Left = 284
    Top = 375
    Width = 104
    Height = 21
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 0
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
