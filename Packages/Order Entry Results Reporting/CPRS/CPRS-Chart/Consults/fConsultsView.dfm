inherited frmConsultsView: TfrmConsultsView
  Left = 320
  Top = 172
  BorderIcons = []
  Caption = 'List Selected Consults'
  ClientHeight = 386
  ClientWidth = 384
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 402
  ExplicitHeight = 431
  PixelsPerInch = 96
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 384
    Height = 353
    Align = alClient
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 196
      Height = 351
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object lblService: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 190
        Height = 16
        Align = alTop
        Caption = 'Service'
        ExplicitWidth = 46
      end
      object treService: TORTreeView
        AlignWithMargins = True
        Left = 3
        Top = 55
        Width = 190
        Height = 293
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 1
        OnChange = treServiceChange
        Caption = 'Service'
        NodePiece = 0
      end
      object cboService: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 190
        Height = 24
        Style = orcsDropDown
        Align = alTop
        AutoSelect = True
        Caption = 'Service'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 0
        Text = ''
        OnKeyPause = cboServiceSelect
        OnMouseClick = cboServiceSelect
        CharsNeedMatch = 1
      end
    end
    object Panel3: TPanel
      Left = 197
      Top = 1
      Width = 186
      Height = 351
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      ExplicitLeft = 200
      ExplicitTop = -1
      object lblStatus: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 180
        Height = 16
        Align = alTop
        Caption = 'Status'
        ExplicitWidth = 37
      end
      object lblBeginDate: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 117
        Width = 180
        Height = 16
        Align = alBottom
        Caption = 'Beginning Date'
        ExplicitTop = 127
        ExplicitWidth = 92
      end
      object lblEndDate: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 169
        Width = 180
        Height = 16
        Align = alBottom
        Caption = 'Ending Date'
        ExplicitTop = 179
        ExplicitWidth = 74
      end
      object Label1: TLabel
        Left = 0
        Top = 218
        Width = 186
        Height = 16
        Align = alBottom
        Caption = 'Group By'
        ExplicitTop = 228
        ExplicitWidth = 56
      end
      object lstStatus: TORListBox
        AlignWithMargins = True
        Left = 3
        Top = 25
        Width = 180
        Height = 86
        Align = alClient
        MultiSelect = True
        ParentShowHint = False
        PopupMenu = popStatus
        ShowHint = True
        TabOrder = 0
        Caption = 'Status'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        ExplicitHeight = 96
      end
      object calBeginDate: TORDateBox
        AlignWithMargins = True
        Left = 3
        Top = 139
        Width = 180
        Height = 24
        Align = alBottom
        TabOrder = 1
        DateOnly = False
        RequireTime = False
        Caption = 'Beginning Date'
        ExplicitTop = 149
      end
      object calEndDate: TORDateBox
        AlignWithMargins = True
        Left = 3
        Top = 191
        Width = 180
        Height = 24
        Align = alBottom
        TabOrder = 2
        DateOnly = False
        RequireTime = False
        Caption = 'Ending Date'
        ExplicitTop = 201
      end
      object cboGroupBy: TORComboBox
        AlignWithMargins = True
        Left = 3
        Top = 237
        Width = 180
        Height = 24
        Style = orcsDropDown
        Align = alBottom
        AutoSelect = True
        Caption = 'Group By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          '^(none)'
          'T^Consults/Procedures'
          'V^Service'
          'S^Status')
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
        TabOrder = 3
        Text = ''
        CharsNeedMatch = 1
        ExplicitTop = 247
      end
      object radSort: TRadioGroup
        AlignWithMargins = True
        Left = 3
        Top = 267
        Width = 180
        Height = 81
        Align = alBottom
        Caption = 'Sort Order'
        Items.Strings = (
          '&Ascending (oldest first)'
          '&Descending (newest first)')
        TabOrder = 4
        ExplicitTop = 257
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 353
    Width = 384
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 196
      Top = 3
      Width = 91
      Height = 27
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 293
      Top = 3
      Width = 88
      Height = 27
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 72
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Text = Beginning Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calEndDate'
        'Text = Ending Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = lstStatus'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = cboService'
        'Status = stsDefault')
      (
        'Component = cboGroupBy'
        'Status = stsDefault')
      (
        'Component = frmConsultsView'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault'))
  end
  object popStatus: TPopupMenu
    Left = 20
    Top = 123
    object popStatusSelectNone: TMenuItem
      Caption = 'Select None'
      OnClick = popStatusSelectNoneClick
    end
  end
end
