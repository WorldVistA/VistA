inherited frmTIUTemplates: TfrmTIUTemplates
  Caption = 'TIU Templates '
  ClientHeight = 202
  ClientWidth = 292
  Position = poOwnerFormCenter
  ExplicitWidth = 308
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  object bvlNotesTitles: TBevel [0]
    Left = 0
    Top = 161
    Width = 292
    Height = 2
    Align = alBottom
    ExplicitLeft = 118
    ExplicitTop = 10
    ExplicitWidth = 225
  end
  object gpDetails: TGridPanel [1]
    Left = 0
    Top = 0
    Width = 292
    Height = 161
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 16.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 16.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = rgNavigationPos
        Row = 5
      end
      item
        Column = 1
        Control = ckbHighlight
        Row = 1
      end
      item
        Column = 1
        Control = gbHighlightColor
        Row = 3
      end>
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 8.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 8.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 55.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 8.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 44.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object rgNavigationPos: TRadioGroup
      Left = 16
      Top = 101
      Width = 260
      Height = 44
      Align = alClient
      Caption = 'Navigation Bar Position'
      Columns = 4
      Ctl3D = True
      ItemIndex = 0
      Items.Strings = (
        'Top'
        'Left'
        'Right'
        'Bottom')
      ParentCtl3D = False
      TabOrder = 2
      OnClick = rgNavigationPosClick
    end
    object ckbHighlight: TCheckBox
      Left = 16
      Top = 8
      Width = 260
      Height = 25
      Margins.Left = 12
      Align = alTop
      Caption = 'Highlight Required Fields without Value'
      TabOrder = 0
      OnClick = ckbHighlightClick
    end
    object gbHighlightColor: TGroupBox
      Left = 16
      Top = 38
      Width = 260
      Height = 55
      Align = alClient
      Caption = 'Highlight color'
      TabOrder = 1
      object cbHighlightColor: TColorBox
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 240
        Height = 22
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Align = alClient
        DefaultColorColor = clYellow
        Selected = clYellow
        Style = [cbStandardColors, cbPrettyNames]
        BevelInner = bvNone
        Color = clBtnFace
        TabOrder = 0
        OnChange = cbHighlightColorChange
      end
    end
  end
  object gpButtons: TGridPanel [2]
    Left = 0
    Top = 163
    Width = 292
    Height = 39
    Margins.Bottom = 55
    Align = alBottom
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 16.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 4.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 75.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 16.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 1
        Control = btnDefaults
        Row = 1
      end
      item
        Column = 3
        Control = btnOK
        Row = 1
      end
      item
        Column = 5
        Control = btnCancel
        Row = 1
      end>
    ParentBackground = False
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 8.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 22.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 8.000000000000000000
      end>
    TabOrder = 1
    object btnDefaults: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9996
      Align = alClient
      Caption = 'Defaults'
      TabOrder = 0
      OnClick = btnDefaultsClick
    end
    object btnOK: TButton
      Left = 122
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9996
      Align = alClient
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TButton
      Left = 201
      Top = 8
      Width = 75
      Height = 22
      HelpContext = 9997
      Align = alClient
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 248
    Top = 8
    Data = (
      (
        'Component = frmTIUTemplates'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = cbHighlightColor'
        'Status = stsDefault')
      (
        'Component = rgNavigationPos'
        'Status = stsDefault')
      (
        'Component = gpButtons'
        'Status = stsDefault')
      (
        'Component = btnDefaults'
        'Status = stsDefault')
      (
        'Component = gpDetails'
        'Status = stsDefault')
      (
        'Component = ckbHighlight'
        'Status = stsDefault')
      (
        'Component = gbHighlightColor'
        'Status = stsDefault'))
  end
end
