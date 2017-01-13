inherited frmSurgeryView: TfrmSurgeryView
  Left = 333
  Top = 256
  BorderIcons = []
  Caption = 'List Selected Cases'
  ClientHeight = 202
  ClientWidth = 358
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 374
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 358
    Height = 202
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBeginDate: TLabel
      Left = 4
      Top = 10
      Width = 48
      Height = 13
      Caption = 'Start Date'
    end
    object lblEndDate: TLabel
      Left = 4
      Top = 67
      Width = 48
      Height = 13
      Caption = 'Stop Date'
    end
    object lblMaxDocs: TLabel
      Left = 4
      Top = 125
      Width = 107
      Height = 13
      Caption = 'Max Number to Return'
    end
    object calBeginDate: TORDateBox
      Left = 4
      Top = 24
      Width = 156
      Height = 21
      TabOrder = 0
      DateOnly = False
      RequireTime = False
      Caption = 'Start Date'
    end
    object calEndDate: TORDateBox
      Left = 4
      Top = 81
      Width = 156
      Height = 21
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'Stop Date'
    end
    object cmdOK: TButton
      Left = 97
      Top = 172
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 5
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 177
      Top = 172
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 6
      OnClick = cmdCancelClick
    end
    object edMaxDocs: TCaptionEdit
      Left = 4
      Top = 138
      Width = 156
      Height = 21
      MaxLength = 6
      TabOrder = 2
      Caption = 'Max Number to Return'
    end
    object grpTreeView: TGroupBox
      Left = 177
      Top = 9
      Width = 175
      Height = 150
      Caption = 'Sorting/Grouping of Cases'
      TabOrder = 3
      object lblGroupBy: TOROffsetLabel
        Left = 10
        Top = 71
        Width = 49
        Height = 15
        Caption = 'Group By:'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object cboGroupBy: TORComboBox
        Left = 10
        Top = 85
        Width = 153
        Height = 21
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Group By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          'D^Surgery Date'
          'P^Procedure'
          'S^Surgeon'
          'T^Type of Procedure')
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
      object radTreeSort: TRadioGroup
        Left = 9
        Top = 20
        Width = 155
        Height = 49
        Caption = 'Sort Order'
        Items.Strings = (
          '&Ascending'
          '&Descending')
        TabOrder = 0
      end
    end
    object cmdClear: TButton
      Left = 190
      Top = 125
      Width = 146
      Height = 21
      Caption = 'Clear Sort/Group'
      TabOrder = 4
      OnClick = cmdClearClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Text = Start Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calEndDate'
        'Text = Stop Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = edMaxDocs'
        'Status = stsDefault')
      (
        'Component = grpTreeView'
        'Status = stsDefault')
      (
        'Component = cboGroupBy'
        'Status = stsDefault')
      (
        'Component = radTreeSort'
        'Status = stsDefault')
      (
        'Component = cmdClear'
        'Status = stsDefault')
      (
        'Component = frmSurgeryView'
        'Status = stsDefault'))
  end
end
