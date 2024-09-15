inherited fraAnatPathSpecimen: TfraAnatPathSpecimen
  Left = 0
  Top = 0
  Align = alClient
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 218
  ClientWidth = 667
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object grdHeader: TGridPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 67
    Align = alTop
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 70.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 180.000000000000000000
      end
      item
        Value = 55.000000000000010000
      end
      item
        SizeStyle = ssAbsolute
        Value = 100.000000000000000000
      end
      item
        Value = 45.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 2
        Control = lblDescription
        Row = 0
      end
      item
        Column = 2
        ColumnSpan = 3
        Control = edtSpecimenDesc
        Row = 0
      end
      item
        Column = 5
        Control = btnDelete
        Row = 0
      end
      item
        Column = 0
        Control = lblSpecimen
        Row = 2
        RowSpan = 2
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = lblCharLimit
        Row = 1
      end
      item
        Column = 2
        ColumnSpan = 4
        Control = lblEmptySpace
        Row = 1
      end
      item
        Column = 1
        ColumnSpan = 2
        Control = edtSpecimen
        Row = 2
      end
      item
        Column = 3
        Control = lblCollSamp
        Row = 2
      end
      item
        Column = 4
        ColumnSpan = 2
        Control = cbxCollSamp
        Row = 2
      end>
    RowCollection = <
      item
        Value = 38.000000000000000000
      end
      item
        Value = 24.000000000000000000
      end
      item
        Value = 38.000000000000000000
      end>
    TabOrder = 0
    object lblDescription: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 244
      Height = 18
      Align = alClient
      Alignment = taRightJustify
      Caption = '*Specimen Description/Anatomic Site'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 16
    end
    object edtSpecimenDesc: TEdit
      AlignWithMargins = True
      Left = 254
      Top = 4
      Width = 358
      Height = 18
      Align = alClient
      MaxLength = 75
      TabOrder = 0
      OnChange = ledtSpecimenDescChange
      OnExit = edtSpecimenDescExit
      OnKeyDown = ledtSpecimenDescKeyDown
      OnKeyPress = ledtSpecimenDescKeyPress
      ExplicitHeight = 21
    end
    object btnDelete: TBitBtn
      AlignWithMargins = True
      Left = 618
      Top = 4
      Width = 44
      Height = 18
      Align = alClient
      Caption = 'Delete'
      TabOrder = 1
      OnClick = btnDeleteClick
    end
    object lblSpecimen: TLabel
      Left = 1
      Top = 40
      Width = 70
      Height = 26
      Align = alClient
      Alignment = taRightJustify
      Caption = '*Specimen '
      Layout = tlCenter
      ExplicitLeft = 17
      ExplicitWidth = 54
      ExplicitHeight = 13
    end
    object lblCharLimit: TLabel
      Left = 1
      Top = 25
      Width = 250
      Height = 15
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = '  --- 75 Character Limit ---'
      ExplicitLeft = 159
      ExplicitTop = 28
      ExplicitWidth = 330
    end
    object lblEmptySpace: TLabel
      Left = 251
      Top = 25
      Width = 414
      Height = 15
      Align = alClient
      Alignment = taCenter
      Caption = 'Empty Space'
      Visible = False
      ExplicitWidth = 62
      ExplicitHeight = 13
    end
    object edtSpecimen: TEdit
      AlignWithMargins = True
      Left = 74
      Top = 43
      Width = 319
      Height = 20
      Align = alClient
      TabOrder = 2
      ExplicitHeight = 21
    end
    object lblCollSamp: TLabel
      Left = 396
      Top = 40
      Width = 100
      Height = 26
      Align = alClient
      Alignment = taRightJustify
      Caption = '*Collection Sample '
      Layout = tlCenter
      ExplicitLeft = 404
      ExplicitWidth = 92
      ExplicitHeight = 13
    end
    object cbxCollSamp: TORComboBox
      Tag = 3
      AlignWithMargins = True
      Left = 499
      Top = 41
      Width = 163
      Height = 21
      Margins.Top = 1
      Margins.Bottom = 1
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = 'Collect Sample'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 3
      Text = ''
      OnChange = cbxCollSampChange
      OnEnter = cboCollSampAction
      OnKeyPause = cboCollSampAction
      OnMouseClick = cboCollSampAction
      CharsNeedMatch = 1
    end
  end
  object sbxMain: TScrollBox
    Left = 0
    Top = 67
    Width = 667
    Height = 151
    Align = alClient
    Color = clWhite
    ParentColor = False
    TabOrder = 1
    object gplBody: TGridPanel
      Left = 0
      Top = 0
      Width = 663
      Height = 144
      Align = alTop
      BevelEdges = []
      BevelOuter = bvNone
      Color = clWhite
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <>
      DoubleBuffered = False
      ExpandStyle = emFixedSize
      ParentBackground = False
      ParentDoubleBuffered = False
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 100.000000000000000000
        end>
      TabOrder = 0
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 320
    Top = 123
    Data = (
      (
        'Component = fraAnatPathSpecimen'
        'Status = stsDefault')
      (
        'Component = cbxCollSamp'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = edtSpecimenDesc'
        'Status = stsDefault')
      (
        'Component = gplBody'
        'Status = stsDefault')
      (
        'Component = grdHeader'
        'Status = stsDefault')
      (
        'Component = edtSpecimen'
        'Status = stsDefault')
      (
        'Component = sbxMain'
        'Status = stsDefault'))
  end
  object VA508SpecimenDescription: TVA508ComponentAccessibility
    Tag = 1
    Component = edtSpecimenDesc
    OnCaptionQuery = VA508CaptionQuery
    Left = 320
    Top = 3
  end
  object VA508Specimen: TVA508ComponentAccessibility
    Tag = 2
    Component = edtSpecimen
    OnCaptionQuery = VA508CaptionQuery
    Left = 168
    Top = 35
  end
  object VA508CollectionSample: TVA508ComponentAccessibility
    Tag = 3
    Component = cbxCollSamp
    OnCaptionQuery = VA508CaptionQuery
    Left = 520
    Top = 43
  end
end
