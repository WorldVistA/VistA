inherited frmReportsAdhocComponent1: TfrmReportsAdhocComponent1
  Left = 229
  Top = 195
  BorderIcons = [biSystemMenu]
  Caption = 'ADHOC Health Summary'
  ClientHeight = 452
  ClientWidth = 633
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 649
  ExplicitHeight = 490
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 185
    Top = 0
    Width = 5
    Height = 401
    Beveled = True
    OnCanResize = Splitter1CanResize
  end
  object ORComboBox1: TORComboBox [1]
    Left = 0
    Top = 0
    Width = 185
    Height = 401
    Style = orcsSimple
    Align = alLeft
    AutoSelect = True
    Caption = 'Available Components'
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
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 0
    Text = ''
    OnDblClick = btnAddComponentClick
    OnKeyDown = ORComboBox1KeyDown
    CharsNeedMatch = 1
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 401
    Width = 633
    Height = 51
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      633
      51)
    object btnCancelMain: TButton
      Left = 550
      Top = 18
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelMainClick
    end
    object btnOKMain: TButton
      Left = 462
      Top = 18
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKMainClick
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 8
      Width = 329
      Height = 41
      Caption = 'Lookup By:'
      TabOrder = 0
      object rbtnHeader: TRadioButton
        Left = 208
        Top = 16
        Width = 105
        Height = 17
        Caption = '&Display Header'
        TabOrder = 2
        OnClick = rbtnHeaderClick
      end
      object rbtnAbbrev: TRadioButton
        Left = 96
        Top = 16
        Width = 89
        Height = 17
        Caption = '&Abbreviation'
        TabOrder = 1
        OnClick = rbtnAbbrevClick
      end
      object rbtnName: TRadioButton
        Left = 8
        Top = 16
        Width = 65
        Height = 17
        Caption = '&Name'
        TabOrder = 0
        OnClick = rbtnNameClick
      end
    end
  end
  object Panel3: TPanel [3]
    Left = 190
    Top = 0
    Width = 443
    Height = 401
    Align = alClient
    TabOrder = 1
    object Splitter4: TSplitter
      Left = 219
      Top = 25
      Width = 5
      Height = 375
      Beveled = True
      OnCanResize = Splitter4CanResize
      ExplicitHeight = 376
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 441
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Component Selection(s)'
      TabOrder = 0
    end
    object ORListBox2: TORListBox
      Left = 26
      Top = 25
      Width = 193
      Height = 375
      Align = alLeft
      DragMode = dmAutomatic
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = ORListBox2Click
      OnDblClick = btnRemoveComponentClick
      OnDragDrop = ORListBox2DragDrop
      OnDragOver = ORListBox2DragOver
      OnEndDrag = ORListBox2EndDrag
      Caption = 'Selected Components'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object Panel6: TPanel
      Left = 1
      Top = 25
      Width = 25
      Height = 375
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object btnRemoveComponent: TButton
        Left = 4
        Top = 30
        Width = 17
        Height = 22
        Caption = '<'
        TabOrder = 1
        OnClick = btnRemoveComponentClick
      end
      object btnRemoveAllComponents: TButton
        Left = 4
        Top = 55
        Width = 17
        Height = 22
        Caption = '<<'
        TabOrder = 2
        OnClick = btnRemoveAllComponentsClick
      end
      object btnAddComponent: TButton
        Left = 4
        Top = 5
        Width = 17
        Height = 22
        Caption = '>'
        TabOrder = 0
        OnClick = btnAddComponentClick
      end
    end
    object Panel7: TPanel
      Left = 224
      Top = 25
      Width = 218
      Height = 375
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      object lblHeaderName: TLabel
        Left = 30
        Top = 8
        Width = 69
        Height = 13
        Caption = 'Header Name:'
        Enabled = False
      end
      object lblOccuranceLimit: TLabel
        Left = 30
        Top = 48
        Width = 83
        Height = 13
        Caption = 'Occurrence Limit:'
        Enabled = False
      end
      object lblTimeLimit: TLabel
        Left = 153
        Top = 48
        Width = 50
        Height = 13
        Caption = 'Time Limit:'
        Enabled = False
      end
      object lblItems: TLabel
        Left = 30
        Top = 184
        Width = 49
        Height = 13
        Caption = 'Sub-items:'
        Enabled = False
      end
      object pnl5Button: TKeyClickPanel
        Left = 0
        Top = 90
        Width = 17
        Height = 24
        Caption = 'Display selected component earlier'
        TabOrder = 0
        TabStop = True
        OnClick = SpeedButton5Click
        OnEnter = pnl5ButtonEnter
        OnExit = pnl5ButtonExit
        object SpeedButton5: TSpeedButton
          Left = 0
          Top = 1
          Width = 17
          Height = 22
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
            3333333333777F3333333333330F033333333333337F7F3333333333330F0333
            33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
            33333333337F7F3333333333330F033333333333FF7F7FFFF3333330000F0000
            3333333777737777F3333330FFFFFFF0333333373F333337333333330FFFFF03
            333333337F33337F333333330FFFFF033333333373F333733333333330FFF033
            3333333337F337F33333333330FFF03333333333373F373333333333330F0333
            33333333337F7F3333333333330F033333333333337373333333333333303333
            333333333337F333333333333330333333333333333733333333}
          NumGlyphs = 2
          OnClick = SpeedButton5Click
        end
      end
      object pnl6Button: TKeyClickPanel
        Left = 0
        Top = 115
        Width = 17
        Height = 24
        BevelOuter = bvNone
        Caption = 'Display selected component later'
        TabOrder = 1
        TabStop = True
        OnClick = SpeedButton6Click
        OnEnter = pnl5ButtonEnter
        OnExit = pnl5ButtonExit
        object SpeedButton6: TSpeedButton
          Left = 0
          Top = 1
          Width = 17
          Height = 22
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
            333333333337F33333333333333033333333333333373F3333333333330F0333
            33333333337F7F3333333333330F033333333333337373F33333333330FFF033
            3333333337F337F33333333330FFF033333333333733373F333333330FFFFF03
            333333337F33337F333333330FFFFF033333333373333373F3333330FFFFFFF0
            33333337FFFF3FF7F3333330000F000033333337777F777733333333330F0333
            33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
            33333333337F7F3333333333330F033333333333337F7F3333333333330F0333
            33333333337F7F33333333333300033333333333337773333333}
          NumGlyphs = 2
          OnClick = SpeedButton6Click
        end
      end
      object edtHeaderName: TCaptionEdit
        Left = 24
        Top = 24
        Width = 189
        Height = 21
        Enabled = False
        TabOrder = 2
        OnExit = edtHeaderNameExit
        Caption = 'Header Name'
      end
      object edtOccuranceLimit: TCaptionEdit
        Left = 24
        Top = 64
        Width = 79
        Height = 21
        Enabled = False
        TabOrder = 3
        OnExit = edtOccuranceLimitExit
        Caption = 'Occurance Limit'
      end
      object cboTimeLimit: TCaptionComboBox
        Left = 150
        Top = 64
        Width = 63
        Height = 21
        TabOrder = 4
        OnExit = cboTimeLimitExit
        Items.Strings = (
          '1D'
          '2D'
          '3D'
          '4D'
          '5D'
          '6D'
          '1W'
          '2W'
          '3W'
          '4W'
          '1M'
          '2M'
          '3M'
          '4M'
          '5M'
          '6M'
          '7M'
          '8M'
          '9M'
          '10M'
          '11M'
          '12M'
          '1Y'
          '2Y'
          '3Y'
          '4Y'
          '5Y'
          '6Y'
          '7Y'
          '8Y'
          '9Y'
          '10Y'
          'No Limit')
        Caption = 'Time Limit'
      end
      object gpbDisplay: TGroupBox
        Left = 24
        Top = 88
        Width = 189
        Height = 89
        Enabled = False
        TabOrder = 5
        object lblICD: TLabel
          Left = 24
          Top = 48
          Width = 82
          Height = 13
          Caption = 'ICD Text Display:'
          Enabled = False
        end
        object ckbHospitalLocation: TCheckBox
          Left = 24
          Top = 16
          Width = 153
          Height = 17
          Caption = 'Display Hospital Location'
          Enabled = False
          TabOrder = 0
          OnExit = ckbHospitalLocationExit
        end
        object ckbProviderNarrative: TCheckBox
          Left = 24
          Top = 32
          Width = 153
          Height = 17
          Caption = 'Display Provider Narrative'
          Enabled = False
          TabOrder = 1
          OnExit = ckbProviderNarrativeExit
        end
        object cboICD: TCaptionComboBox
          Left = 24
          Top = 64
          Width = 121
          Height = 21
          Enabled = False
          TabOrder = 2
          OnExit = cboICDExit
          Items.Strings = (
            'Long text'
            'Short text'
            'Code only'
            'Text only'
            'None')
          Caption = 'ICD Text Display'
        end
      end
      object ORListBox1: TORListBox
        Left = 24
        Top = 200
        Width = 185
        Height = 149
        Enabled = False
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Caption = 'Sub-items'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
      object btnEditSubitems: TButton
        Left = 120
        Top = 352
        Width = 89
        Height = 21
        Caption = 'Edit Sub-items'
        Enabled = False
        TabOrder = 7
        OnClick = btnEditSubitemsClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = ORComboBox1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = btnCancelMain'
        'Status = stsDefault')
      (
        'Component = btnOKMain'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = rbtnHeader'
        'Status = stsDefault')
      (
        'Component = rbtnAbbrev'
        'Status = stsDefault')
      (
        'Component = rbtnName'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = ORListBox2'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = btnRemoveComponent'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllComponents'
        'Status = stsDefault')
      (
        'Component = btnAddComponent'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = pnl5Button'
        'Status = stsDefault')
      (
        'Component = pnl6Button'
        'Status = stsDefault')
      (
        'Component = edtHeaderName'
        'Status = stsDefault')
      (
        'Component = edtOccuranceLimit'
        'Status = stsDefault')
      (
        'Component = cboTimeLimit'
        'Status = stsDefault')
      (
        'Component = gpbDisplay'
        'Status = stsDefault')
      (
        'Component = ckbHospitalLocation'
        'Status = stsDefault')
      (
        'Component = ckbProviderNarrative'
        'Status = stsDefault')
      (
        'Component = cboICD'
        'Status = stsDefault')
      (
        'Component = ORListBox1'
        'Status = stsDefault')
      (
        'Component = btnEditSubitems'
        'Status = stsDefault')
      (
        'Component = frmReportsAdhocComponent1'
        'Status = stsDefault'))
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 591
    Top = 6
  end
end
