object RequiredFieldsFrame: TRequiredFieldsFrame
  Left = 0
  Top = 0
  Width = 659
  Height = 25
  Color = clSilver
  Ctl3D = True
  ParentBackground = False
  ParentColor = False
  ParentCtl3D = False
  TabOrder = 0
  object gpButtons: TGridPanel
    Left = 8
    Top = 0
    Width = 643
    Height = 25
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = btnFirst
        Row = 0
      end
      item
        Column = 2
        Control = btnPrev
        Row = 0
      end
      item
        Column = 3
        Control = btnNext
        Row = 0
      end
      item
        Column = 4
        Control = btnLast
        Row = 0
      end
      item
        Column = 0
        Control = stxtTotalRequired
        Row = 0
      end>
    ParentBackground = False
    PopupMenu = PopupMenu1
    RowCollection = <
      item
        Value = 100.000000000000000000
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    TabOrder = 0
    object btnFirst: TButton
      Left = 343
      Top = 0
      Width = 75
      Height = 25
      Action = acFirst
      Align = alClient
      TabOrder = 1
    end
    object btnPrev: TButton
      Left = 418
      Top = 0
      Width = 75
      Height = 25
      Action = acPrev
      Align = alClient
      TabOrder = 2
    end
    object btnNext: TButton
      Left = 493
      Top = 0
      Width = 75
      Height = 25
      Action = acNext
      Align = alClient
      TabOrder = 3
    end
    object btnLast: TButton
      Left = 568
      Top = 0
      Width = 75
      Height = 25
      Action = acLast
      Align = alClient
      TabOrder = 4
    end
    object stxtTotalRequired: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 5
      Width = 337
      Height = 17
      Margins.Top = 5
      Align = alClient
      BevelInner = bvSpace
      BevelKind = bkSoft
      BevelOuter = bvNone
      Caption = 'All Required Fields have Values'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
    end
  end
  object pnlLmargin: TPanel
    Left = 0
    Top = 0
    Width = 8
    Height = 25
    Align = alLeft
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
  end
  object pnlRMargin: TPanel
    Left = 651
    Top = 0
    Width = 8
    Height = 25
    Align = alRight
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    Left = 264
    object T1: TMenuItem
      Caption = 'Top'
      OnClick = T1Click
    end
    object L1: TMenuItem
      Caption = 'Left'
      OnClick = T1Click
    end
    object R1: TMenuItem
      Caption = 'Right'
      OnClick = T1Click
    end
    object B1: TMenuItem
      Caption = 'Bottom'
      OnClick = T1Click
    end
  end
  object ActionList1: TActionList
    Left = 312
    object acFirst: TAction
      Caption = '&First'
      OnExecute = acFirstExecute
    end
    object acPrev: TAction
      Caption = '< Pre&v'
      OnExecute = acPrevExecute
    end
    object acNext: TAction
      Caption = 'Nex&t >'
      OnExecute = acNextExecute
    end
    object acLast: TAction
      Caption = '&Last'
      OnExecute = acLastExecute
    end
  end
end
