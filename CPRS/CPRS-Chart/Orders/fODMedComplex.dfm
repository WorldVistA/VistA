inherited frmODMedComplex: TfrmODMedComplex
  Left = 291
  Top = 307
  BorderIcons = []
  Caption = 'Complex Dose'
  ClientHeight = 227
  ClientWidth = 445
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 453
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel [0]
    Left = 6
    Top = 174
    Width = 433
    Height = 2
  end
  object grdDoses: TStringGrid [1]
    Left = 6
    Top = 6
    Width = 433
    Height = 135
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
    Left = 290
    Top = 184
    Width = 72
    Height = 21
    Caption = 'OK'
    TabOrder = 5
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 368
    Top = 184
    Width = 72
    Height = 21
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = cmdCancelClick
  end
  object cboRoute: TORComboBox [4]
    Left = 170
    Top = 200
    Width = 72
    Height = 21
    Style = orcsDropDown
    AutoSelect = False
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
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
    Visible = False
    OnClick = cboRouteClick
    OnExit = cboRouteExit
    CharsNeedMatch = 1
  end
  object cboSchedule: TORComboBox [5]
    Left = 169
    Top = 176
    Width = 72
    Height = 21
    Style = orcsDropDown
    AutoSelect = False
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
    Visible = False
    OnExit = cboScheduleExit
    CharsNeedMatch = 1
  end
  object pnlInstruct: TPanel [6]
    Left = 6
    Top = 177
    Width = 150
    Height = 21
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    OnEnter = pnlInstructEnter
    OnExit = pnlInstructExit
    object btnUnits: TSpeedButton
      Left = 86
      Top = 1
      Width = 63
      Height = 15
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
      Width = 86
      Height = 21
      Style = orcsDropDown
      AutoSelect = False
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
      CharsNeedMatch = 1
    end
  end
  object pnlDays: TPanel [7]
    Left = 6
    Top = 201
    Width = 67
    Height = 21
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    OnEnter = pnlDaysEnter
    OnExit = pnlDaysExit
    object Label1: TLabel
      Left = 43
      Top = 4
      Width = 22
      Height = 13
      Caption = 'days'
    end
    object txtDays: TCaptionEdit
      Left = 0
      Top = 0
      Width = 25
      Height = 21
      AutoSelect = False
      TabOrder = 0
      Text = '0'
      OnChange = txtDaysChange
      Caption = 'days'
    end
    object UpDown2: TUpDown
      Left = 25
      Top = 0
      Width = 15
      Height = 21
      Associate = txtDays
      Max = 999
      TabOrder = 1
    end
  end
  object cmdInsert: TButton [8]
    Left = 6
    Top = 149
    Width = 79
    Height = 17
    Caption = 'Insert Row'
    TabOrder = 7
    OnClick = cmdInsertClick
  end
  object cmdRemove: TButton [9]
    Left = 92
    Top = 149
    Width = 91
    Height = 17
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
