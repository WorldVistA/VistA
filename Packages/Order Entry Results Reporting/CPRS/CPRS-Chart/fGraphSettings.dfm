inherited frmGraphSettings: TfrmGraphSettings
  Left = 109
  Top = 60
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Graph Settings'
  ClientHeight = 381
  ClientWidth = 594
  Constraints.MinWidth = 600
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 600
  ExplicitHeight = 409
  PixelsPerInch = 96
  TextHeight = 16
  object bvlDefaults: TBevel [0]
    Left = 174
    Top = 218
    Width = 244
    Height = 1
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 349
    Width = 594
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object lblConversions: TLabel
      AlignWithMargins = True
      Left = 92
      Top = 3
      Width = 57
      Height = 26
      Align = alLeft
      Caption = 'Functions'
      ParentShowHint = False
      ShowHint = False
      Visible = False
      ExplicitHeight = 16
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 526
      Top = 3
      Width = 65
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Close'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object lstOptions: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 83
      Height = 26
      Align = alLeft
      Items.Strings = (
        '3D^A'
        'Clear Background^B'
        'Dates^C'
        'Fixed Date Range^M'
        'Gradient^D'
        'Hints^E'
        'Legend^F'
        'Lines^G'
        'Sort by Type^H'
        'Stay on Top^I'
        'Values^J'
        'Zoom, Horizontal^K'
        'Zoom, Vertical^L')
      Sorted = True
      TabOrder = 1
      Visible = False
    end
    object cboConversions: TORComboBox
      AlignWithMargins = True
      Left = 155
      Top = 3
      Width = 113
      Height = 24
      Style = orcsDropDown
      Align = alLeft
      AutoSelect = True
      Caption = ''
      Color = clWindow
      DropDownCount = 8
      Items.Strings = (
        '<none>'
        'Standard Deviations'
        'Inverse Values')
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      ParentShowHint = False
      ShowHint = False
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      Visible = False
      CharsNeedMatch = 1
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 594
    Height = 349
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object lblOptionsInfo: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 586
      Height = 16
      Align = alTop
      Caption = 'Settings saved as your defaults are applied to new graphs.'
      ParentShowHint = False
      ShowHint = False
      ExplicitWidth = 347
    end
    object Panel3: TPanel
      Left = 1
      Top = 23
      Width = 592
      Height = 325
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 177
        Height = 325
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel3'
        ShowCaption = False
        TabOrder = 0
        object lblSources: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 171
          Height = 16
          Align = alTop
          Caption = 'Sources Displayed:'
          ParentShowHint = False
          ShowHint = False
          ExplicitWidth = 118
        end
        object lstSourcesCopy: TListBox
          Left = 0
          Top = 277
          Width = 177
          Height = 16
          Align = alBottom
          Sorted = True
          TabOrder = 0
          Visible = False
        end
        object lstSources: TCheckListBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 171
          Height = 249
          Align = alClient
          ParentShowHint = False
          ShowHint = False
          Sorted = True
          TabOrder = 1
        end
        object Panel5: TPanel
          Left = 0
          Top = 293
          Width = 177
          Height = 32
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'Panel5'
          ShowCaption = False
          TabOrder = 2
          object btnAll: TButton
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 64
            Height = 26
            Align = alLeft
            Caption = 'All'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = btnAllClick
          end
          object brnClear: TButton
            AlignWithMargins = True
            Left = 110
            Top = 3
            Width = 64
            Height = 26
            Align = alRight
            Cancel = True
            Caption = 'Clear'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnClick = btnAllClick
          end
        end
      end
      object Panel6: TPanel
        Left = 177
        Top = 0
        Width = 159
        Height = 325
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel6'
        ShowCaption = False
        TabOrder = 1
        object lblOptions: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 153
          Height = 16
          Align = alTop
          Caption = 'Options:'
          ParentShowHint = False
          ShowHint = False
          ExplicitWidth = 49
        end
        object chklstOptions: TCheckListBox
          AlignWithMargins = True
          Left = 3
          Top = 25
          Width = 153
          Height = 262
          OnClickCheck = chklstOptionsClickCheck
          Align = alClient
          ParentShowHint = False
          ShowHint = False
          Sorted = True
          TabOrder = 0
        end
        object lstATypes: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 293
          Width = 153
          Height = 29
          Align = alBottom
          TabOrder = 1
          Visible = False
        end
      end
      object Panel7: TPanel
        Left = 336
        Top = 0
        Width = 256
        Height = 325
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel6'
        ShowCaption = False
        TabOrder = 2
        object lblMaxGraphs: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 250
          Height = 16
          Align = alTop
          Caption = 'Max Graphs in Display:'
          ParentShowHint = False
          ShowHint = False
          ExplicitWidth = 137
        end
        object lblMinGraphHeight: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 49
          Width = 250
          Height = 16
          Align = alTop
          Caption = 'Minimum Graph Height:'
          ParentShowHint = False
          ShowHint = False
          ExplicitWidth = 138
        end
        object lblMaxSelect: TLabel
          Left = 0
          Top = 92
          Width = 256
          Height = 16
          Align = alTop
          Caption = 'Max Items to Select:'
          ParentShowHint = False
          ShowHint = False
          WordWrap = True
          ExplicitWidth = 118
        end
        object lblOutpatient: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 135
          Width = 250
          Height = 16
          Align = alTop
          Caption = 'Outpatient Date Default:'
          ParentShowHint = False
          ShowHint = False
          WordWrap = True
          ExplicitWidth = 140
        end
        object lblInpatient: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 187
          Width = 250
          Height = 16
          Align = alTop
          Caption = 'Inpatient Date Default:'
          ParentShowHint = False
          ShowHint = False
          WordWrap = True
          ExplicitWidth = 130
        end
        object Panel8: TPanel
          Left = 0
          Top = 22
          Width = 256
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel6'
          ShowCaption = False
          TabOrder = 0
          object lblMaxGraphsRef: TLabel
            AlignWithMargins = True
            Left = 59
            Top = 3
            Width = 190
            Height = 18
            Margins.Left = 16
            Align = alLeft
            AutoSize = False
            ParentShowHint = False
            ShowHint = False
          end
          object txtMaxGraphs: TEdit
            Left = 0
            Top = 0
            Width = 43
            Height = 24
            Align = alLeft
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            Text = '5'
            OnChange = txtMaxGraphsChange
            OnExit = txtMaxGraphsExit
            OnKeyPress = txtMaxGraphsKeyPress
          end
          object spnMaxGraphs: TUpDown
            Left = 43
            Top = 0
            Width = 16
            Height = 24
            Associate = txtMaxGraphs
            Min = 1
            Max = 20
            ParentShowHint = False
            Position = 5
            ShowHint = False
            TabOrder = 1
            OnClick = spnMaxGraphsClick
          end
        end
        object Panel9: TPanel
          Left = 0
          Top = 68
          Width = 256
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel6'
          ShowCaption = False
          TabOrder = 1
          object lblMinGraphHeightRef: TLabel
            AlignWithMargins = True
            Left = 62
            Top = 3
            Width = 187
            Height = 18
            Margins.Left = 16
            Align = alLeft
            AutoSize = False
            ParentShowHint = False
            ShowHint = False
          end
          object txtMinGraphHeight: TEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 40
            Height = 18
            Align = alLeft
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            Text = '90'
            OnChange = txtMinGraphHeightChange
            OnExit = txtMinGraphHeightExit
            OnKeyPress = txtMinGraphHeightKeyPress
          end
          object spnMinGraphHeight: TUpDown
            Left = 43
            Top = 3
            Width = 16
            Height = 18
            Associate = txtMinGraphHeight
            Min = 10
            Max = 1000
            ParentShowHint = False
            Position = 90
            ShowHint = False
            TabOrder = 1
            OnClick = spnMinGraphHeightClick
          end
        end
        object Panel10: TPanel
          Left = 0
          Top = 108
          Width = 256
          Height = 24
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel6'
          ShowCaption = False
          TabOrder = 2
          object lblMaxSelectRef: TLabel
            AlignWithMargins = True
            Left = 62
            Top = 3
            Width = 187
            Height = 18
            Margins.Left = 16
            Align = alLeft
            AutoSize = False
            ParentShowHint = False
            ShowHint = False
          end
          object txtMaxSelect: TEdit
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 40
            Height = 18
            Align = alLeft
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            Text = '100'
            OnChange = txtMaxSelectChange
            OnExit = txtMaxSelectExit
            OnKeyPress = txtMaxSelectKeyPress
          end
          object spnMaxSelect: TUpDown
            AlignWithMargins = True
            Left = 43
            Top = 3
            Width = 16
            Height = 18
            Associate = txtMaxSelect
            Min = 1
            Max = 1000
            ParentShowHint = False
            Position = 100
            ShowHint = False
            TabOrder = 1
            OnClick = spnMaxSelectClick
          end
        end
        object cboDateRangeOutpatient: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 157
          Width = 250
          Height = 24
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 9
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
          TabStop = True
          Text = ''
          CharsNeedMatch = 1
        end
        object cboDateRangeInpatient: TORComboBox
          AlignWithMargins = True
          Left = 3
          Top = 209
          Width = 250
          Height = 24
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 9
          Items.Strings = (
            'S^Date Range...'
            '1^Today'
            '2^One Week'
            '3^Two Weeks'
            '4^One Month'
            '5^Six Months'
            '6^One Year'
            '7^Two Years'
            '8^All Results')
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
          TabOrder = 4
          TabStop = True
          Text = ''
          CharsNeedMatch = 1
        end
        object Panel11: TPanel
          Left = 0
          Top = 236
          Width = 256
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel11'
          ShowCaption = False
          TabOrder = 5
          object lblShow: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 88
            Height = 26
            Align = alLeft
            Alignment = taRightJustify
            Caption = 'Show Defaults:'
            ParentShowHint = False
            ShowHint = False
            ExplicitHeight = 16
          end
          object btnPublic: TButton
            AlignWithMargins = True
            Left = 189
            Top = 3
            Width = 64
            Height = 26
            Align = alRight
            Cancel = True
            Caption = 'Public'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = btnPublicClick
          end
          object btnPersonal: TButton
            AlignWithMargins = True
            Left = 109
            Top = 3
            Width = 74
            Height = 26
            Align = alRight
            Cancel = True
            Caption = 'Personal'
            TabOrder = 1
            OnClick = btnPublicClick
          end
          object lbl508Show: TVA508StaticText
            Name = 'lbl508Show'
            Left = 3
            Top = 3
            Width = 90
            Height = 18
            Alignment = taLeftJustify
            Caption = 'Show Defaults:'
            Enabled = False
            TabOrder = 2
            Visible = False
            ShowAccelChar = True
          end
        end
        object Panel12: TPanel
          Left = 0
          Top = 268
          Width = 256
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel11'
          ShowCaption = False
          TabOrder = 6
          object lblSave: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 98
            Height = 26
            Align = alLeft
            Alignment = taRightJustify
            Caption = 'Save as Default:'
            ParentShowHint = False
            ShowHint = False
            ExplicitHeight = 16
          end
          object btnPersonalSave: TButton
            AlignWithMargins = True
            Left = 109
            Top = 3
            Width = 74
            Height = 26
            Align = alRight
            Cancel = True
            Caption = 'Personal'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = SaveClick
          end
          object btnPublicSave: TButton
            AlignWithMargins = True
            Left = 189
            Top = 3
            Width = 64
            Height = 26
            Align = alRight
            Cancel = True
            Caption = 'Public'
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnClick = SaveClick
          end
          object lbl508Save: TVA508StaticText
            Name = 'lbl508Save'
            Left = 3
            Top = 3
            Width = 100
            Height = 18
            Alignment = taLeftJustify
            Caption = 'Save as Default:'
            Enabled = False
            TabOrder = 2
            Visible = False
            ShowAccelChar = True
          end
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 512
    Top = 104
    Data = (
      (
        'Component = lstATypes'
        'Status = stsDefault')
      (
        'Component = lstSourcesCopy'
        'Status = stsDefault')
      (
        'Component = chklstOptions'
        'Status = stsDefault')
      (
        'Component = txtMaxGraphs'
        'Label = lblMaxGraphs'
        'Status = stsOK')
      (
        'Component = spnMaxGraphs'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = lstSources'
        'Status = stsDefault')
      (
        'Component = btnPersonal'
        'Status = stsDefault')
      (
        'Component = cboConversions'
        'Status = stsDefault')
      (
        'Component = btnPublic'
        'Status = stsDefault')
      (
        'Component = btnPersonalSave'
        'Status = stsDefault')
      (
        'Component = btnPublicSave'
        'Status = stsDefault')
      (
        'Component = lstOptions'
        'Status = stsDefault')
      (
        'Component = frmGraphSettings'
        'Status = stsDefault')
      (
        'Component = cboDateRangeOutpatient'
        'Label = lblOutpatient'
        'Status = stsOK')
      (
        'Component = cboDateRangeInpatient'
        'Label = lblInpatient'
        'Status = stsOK')
      (
        'Component = lbl508Show'
        'Status = stsDefault')
      (
        'Component = lbl508Save'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
        'Status = stsDefault')
      (
        'Component = btnAll'
        'Status = stsDefault')
      (
        'Component = brnClear'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = Panel7'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = txtMinGraphHeight'
        'Status = stsDefault')
      (
        'Component = spnMinGraphHeight'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = txtMaxSelect'
        'Status = stsDefault')
      (
        'Component = spnMaxSelect'
        'Status = stsDefault')
      (
        'Component = Panel11'
        'Status = stsDefault')
      (
        'Component = Panel12'
        'Status = stsDefault'))
  end
end
