inherited frmODMedComplex: TfrmODMedComplex
  Left = 291
  Top = 307
  BorderIcons = []
  Caption = 'Complex Dose'
  ClientHeight = 279
  ClientWidth = 548
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 453
  ExplicitHeight = 254
  PixelsPerInch = 120
  TextHeight = 16
  object Bevel1: TBevel [0]
    Left = 7
    Top = 214
    Width = 533
    Height = 3
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object grdDoses: TStringGrid [1]
    Left = 7
    Top = 7
    Width = 533
    Height = 167
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    DefaultColWidth = 78
    DefaultRowHeight = 21
    RowCount = 6
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
    ScrollBars = ssVertical
    TabOrder = 4
    OnDrawCell = grdDosesDrawCell
    OnKeyPress = grdDosesKeyPress
    OnMouseDown = grdDosesMouseDown
    OnMouseUp = grdDosesMouseUp
    RowHeights = (
      21
      21
      21
      21
      21
      21)
  end
  object cmdOK: TButton [2]
    Left = 357
    Top = 226
    Width = 89
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'OK'
    TabOrder = 5
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 453
    Top = 226
    Width = 89
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = cmdCancelClick
  end
  object cboRoute: TORComboBox [4]
    Left = 209
    Top = 246
    Width = 89
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = False
    Caption = ''
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
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 1
    Text = ''
    Visible = False
    OnClick = cboRouteClick
    OnExit = cboRouteExit
    CharsNeedMatch = 1
  end
  object cboSchedule: TORComboBox [5]
    Left = 208
    Top = 217
    Width = 89
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = False
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 2
    Text = ''
    Visible = False
    OnExit = cboScheduleExit
    CharsNeedMatch = 1
  end
  object pnlInstruct: TPanel [6]
    Left = 7
    Top = 218
    Width = 185
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    OnEnter = pnlInstructEnter
    OnExit = pnlInstructExit
    object btnUnits: TSpeedButton
      Left = 106
      Top = 1
      Width = 77
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'TABLET(S)'
      Flat = True
      Glyph.Data = {
        AE000000424DAE0000000000000076000000280000000E000000070000000100
        0400000000003800000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        330033333333333333003330333333733300330003333F87330030000033FFFF
        F30033333333333333003333333333333300}
      Layout = blGlyphRight
      NumGlyphs = 2
      Spacing = 0
      OnClick = btnUnitsClick
    end
    object cboInstruct: TORComboBox
      Left = -1
      Top = -1
      Width = 106
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = False
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 80
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      CharsNeedMatch = 1
    end
  end
  object pnlDays: TPanel [7]
    Left = 7
    Top = 247
    Width = 83
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    OnEnter = pnlDaysEnter
    OnExit = pnlDaysExit
    object Label1: TLabel
      Left = 53
      Top = 5
      Width = 30
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'days'
    end
    object txtDays: TCaptionEdit
      Left = 0
      Top = 0
      Width = 31
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      AutoSelect = False
      TabOrder = 0
      Text = '0'
      OnChange = txtDaysChange
      Caption = 'days'
    end
    object UpDown2: TUpDown
      Left = 31
      Top = 0
      Width = 18
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Associate = txtDays
      Max = 999
      TabOrder = 1
    end
  end
  object cmdInsert: TButton [8]
    Left = 7
    Top = 183
    Width = 98
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Insert Row'
    TabOrder = 7
    OnClick = cmdInsertClick
  end
  object cmdRemove: TButton [9]
    Left = 113
    Top = 183
    Width = 112
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Remove Row'
    TabOrder = 8
    OnClick = cmdRemoveClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = grdDoses'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = pnlInstruct'
        'Status = stsDefault')
      (
        'Component = cboInstruct'
        'Status = stsDefault')
      (
        'Component = pnlDays'
        'Status = stsDefault')
      (
        'Component = txtDays'
        'Status = stsDefault')
      (
        'Component = UpDown2'
        'Status = stsDefault')
      (
        'Component = cmdInsert'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = frmODMedComplex'
        'Status = stsDefault'))
  end
  object popUnits: TPopupMenu
    AutoPopup = False
    Left = 109
    Top = 193
  end
end
