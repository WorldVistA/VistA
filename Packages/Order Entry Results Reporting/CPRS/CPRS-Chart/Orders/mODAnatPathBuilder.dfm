inherited fraAnatPathBuilder: TfraAnatPathBuilder
  Left = 0
  Top = 0
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 219
  ClientWidth = 877
  Color = clWindow
  ParentFont = True
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 219
    Align = alLeft
    BevelOuter = bvNone
    Color = clWindow
    DoubleBuffered = False
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 0
    Visible = False
    object pnlSpacer4: TPanel
      Left = 0
      Top = 0
      Width = 220
      Height = 14
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object sbx1: TScrollBox
      Left = 0
      Top = 14
      Width = 220
      Height = 205
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
  object pnl2: TPanel
    Left = 220
    Top = 0
    Width = 220
    Height = 219
    Align = alLeft
    BevelOuter = bvNone
    Color = clWindow
    DoubleBuffered = False
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 1
    Visible = False
    object pnlSpacer5: TPanel
      Left = 0
      Top = 0
      Width = 220
      Height = 14
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object sbx2: TScrollBox
      Left = 0
      Top = 14
      Width = 220
      Height = 205
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
  object pnl3: TPanel
    Left = 440
    Top = 0
    Width = 220
    Height = 219
    Align = alLeft
    BevelOuter = bvNone
    Color = clWindow
    DoubleBuffered = False
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 2
    Visible = False
    object lblCheckList: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 3
      Height = 13
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Align = alTop
    end
    object lstCheckList: TCaptionCheckListBox
      AlignWithMargins = True
      Left = 6
      Top = 25
      Width = 208
      Height = 178
      Margins.Left = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnKeyUp = lstCheckListKeyUp
      Caption = ''
    end
    object pnlSpacer3: TPanel
      Left = 0
      Top = 209
      Width = 220
      Height = 10
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object pnl4: TPanel
    Left = 660
    Top = 0
    Width = 217
    Height = 219
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
    DoubleBuffered = False
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 3
    OnResize = pnl4Resize
    object lblWPField: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 3
      Height = 13
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Align = alTop
    end
    object memNote: TCaptionMemo
      AlignWithMargins = True
      Left = 6
      Top = 25
      Width = 205
      Height = 188
      Margins.Left = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      MaxLength = 2147483645
      PopupMenu = mnuNoteMemo
      ScrollBars = ssVertical
      TabOrder = 0
      OnEnter = memNoteEnter
      OnExit = memNoteExit
      Caption = ''
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 30
    Data = (
      (
        'Component = fraAnatPathBuilder'
        'Status = stsDefault')
      (
        'Component = pnl1'
        'Status = stsDefault')
      (
        'Component = pnlSpacer4'
        'Status = stsDefault')
      (
        'Component = sbx1'
        'Status = stsDefault')
      (
        'Component = pnl2'
        'Status = stsDefault')
      (
        'Component = pnlSpacer5'
        'Status = stsDefault')
      (
        'Component = sbx2'
        'Status = stsDefault')
      (
        'Component = pnl3'
        'Status = stsDefault')
      (
        'Component = lstCheckList'
        'Status = stsDefault')
      (
        'Component = pnlSpacer3'
        'Status = stsDefault')
      (
        'Component = pnl4'
        'Status = stsDefault')
      (
        'Component = memNote'
        'Status = stsDefault'))
  end
  object mnuNoteMemo: TPopupMenu
    Left = 772
    Top = 72
    object mnuNoteMemoCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = mnuNoteMemoCutClick
    end
    object mnuNoteMemoCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = mnuNoteMemoCopyClick
    end
    object mnuNoteMemoPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = mnuNoteMemoPasteClick
    end
    object mnuNoteMenuInsert: TMenuItem
      Caption = '&Insert'
      ShortCut = 8237
      OnClick = mnuNoteMemoPasteClick
    end
  end
  object VA508ListBox: TVA508ComponentAccessibility
    Tag = 1
    Component = lstCheckList
    OnCaptionQuery = VA508CaptionQuery
    Left = 528
    Top = 96
  end
end
