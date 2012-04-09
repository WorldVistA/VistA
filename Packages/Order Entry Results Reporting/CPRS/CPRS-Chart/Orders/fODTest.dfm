inherited frmODTest: TfrmODTest
  Left = 198
  Top = 304
  Caption = 'Test Order'
  PixelsPerInch = 96
  TextHeight = 13
  object lblMedication: TLabel [0]
    Left = 6
    Top = 4
    Width = 52
    Height = 13
    AutoSize = False
    Caption = 'Medication'
  end
  object lblDosage: TLabel [1]
    Left = 202
    Top = 4
    Width = 54
    Height = 13
    AutoSize = False
    Caption = 'Instructions'
  end
  object lblRoute: TLabel [2]
    Left = 314
    Top = 4
    Width = 29
    Height = 13
    AutoSize = False
    Caption = 'Route'
  end
  object lblSchedule: TLabel [3]
    Left = 392
    Top = 4
    Width = 45
    Height = 13
    AutoSize = False
    Caption = 'Schedule'
  end
  object lblQuantity: TLabel [4]
    Left = 470
    Top = 4
    Width = 39
    Height = 13
    AutoSize = False
    Caption = 'Quantity'
  end
  object lblRefills: TLabel [5]
    Left = 470
    Top = 45
    Width = 28
    Height = 13
    AutoSize = False
    Caption = 'Refills'
  end
  object lblPickup: TLabel [6]
    Left = 202
    Top = 101
    Width = 38
    Height = 13
    AutoSize = False
    Caption = 'Pick Up'
  end
  object lblSC: TLabel [7]
    Left = 314
    Top = 101
    Width = 43
    Height = 13
    AutoSize = False
    Caption = 'SC? Y/N'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel [8]
    Left = 392
    Top = 101
    Width = 31
    Height = 13
    AutoSize = False
    Caption = 'Priority'
  end
  object Label2: TLabel [9]
    Left = 202
    Top = 142
    Width = 49
    Height = 13
    Caption = 'Comments'
  end
  object cboMedication: TORComboBox [10]
    Left = 6
    Top = 18
    Width = 180
    Height = 167
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 11
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 5
  end
  object cboMedAlt: TORComboBox
    Left = 6
    Top = 18
    Width = 180
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Color = clWindow
    DropDownCount = 11
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = True
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 4
    Visible = False
  end
  object cboInstructions: TORComboBox
    Left = 202
    Top = 18
    Width = 106
    Height = 77
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 6
  end
  object cboRoute: TORComboBox
    Left = 314
    Top = 18
    Width = 72
    Height = 77
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 7
  end
  object cboSchedule: TORComboBox
    Left = 392
    Top = 18
    Width = 72
    Height = 77
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    MaxLength = 0
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 8
  end
  object txtQuantity: TEdit
    Left = 470
    Top = 18
    Width = 44
    Height = 21
    TabOrder = 9
    Text = 'txtQuantity'
  end
  object txtRefills: TMaskEdit
    Left = 472
    Top = 64
    Width = 29
    Height = 21
    EditMask = '90;0; '
    MaxLength = 2
    TabOrder = 10
    Text = '0'
  end
  object spnRefills: TUpDown
    Left = 501
    Top = 64
    Width = 15
    Height = 21
    Associate = txtRefills
    Min = 0
    Max = 11
    Position = 0
    TabOrder = 11
    Wrap = False
  end
  object cboPickup: TORComboBox
    Left = 202
    Top = 115
    Width = 106
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
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 12
  end
  object cboSC: TORComboBox
    Left = 314
    Top = 115
    Width = 72
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
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 13
  end
  object cboPriority: TORComboBox
    Left = 392
    Top = 115
    Width = 72
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
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 14
  end
  object memComments: TMemo
    Left = 202
    Top = 156
    Width = 311
    Height = 32
    Lines.Strings = (
      'memComments')
    TabOrder = 15
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 476
    Top = 108
  end
end
