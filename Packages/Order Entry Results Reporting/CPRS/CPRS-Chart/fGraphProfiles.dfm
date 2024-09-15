inherited frmGraphProfiles: TfrmGraphProfiles
  Left = 721
  Top = 528
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Select Items and Define Views'
  ClientHeight = 470
  ClientWidth = 526
  Constraints.MinWidth = 532
  Position = poMainFormCenter
  ExplicitWidth = 532
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectandDefine: TLabel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 520
    Height = 13
    Align = alTop
    Caption = 
      'Use Select/Define button or Right-click on graphs to select item' +
      's for display.'
    Enabled = False
    Visible = False
    WordWrap = True
    ExplicitWidth = 359
  end
  object pnlTempData: TPanel [1]
    Left = 0
    Top = 19
    Width = 526
    Height = 49
    Align = alTop
    TabOrder = 1
    Visible = False
    object lblSave: TLabel
      Left = 184
      Top = 16
      Width = 3
      Height = 13
      Visible = False
    end
    object lblClose: TLabel
      Left = 192
      Top = 0
      Width = 3
      Height = 13
      Visible = False
    end
    object lstActualItems: TORListBox
      Left = 8
      Top = 5
      Width = 97
      Height = 41
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
    end
    object lstDrugClass: TListBox
      Left = 112
      Top = 5
      Width = 97
      Height = 41
      ItemHeight = 13
      TabOrder = 1
    end
    object lstScratch: TListBox
      Left = 216
      Top = 5
      Width = 97
      Height = 41
      ItemHeight = 13
      TabOrder = 2
    end
    object lstTests: TListBox
      Left = 320
      Top = 5
      Width = 97
      Height = 41
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object Panel1: TPanel [2]
    Left = 0
    Top = 438
    Width = 526
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    object lblUser: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 36
      Height = 26
      Align = alLeft
      Caption = 'Person:'
      ParentShowHint = False
      ShowHint = False
      Visible = False
      WordWrap = True
      ExplicitHeight = 13
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 426
      Top = 3
      Width = 97
      Height = 26
      Align = alRight
      Cancel = True
      Caption = 'Close'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object Panel3: TPanel [3]
    Left = 0
    Top = 68
    Width = 526
    Height = 370
    Align = alClient
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 0
    object bvlBase: TBevel
      AlignWithMargins = True
      Left = 4
      Top = 331
      Width = 518
      Height = 3
      Align = alBottom
      ExplicitLeft = 3
      ExplicitTop = 705
      ExplicitWidth = 520
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 524
      Height = 295
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 0
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 177
        Height = 295
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object btnViews: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 171
          Height = 26
          Align = alTop
          Caption = 'Show Other Views'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          Visible = False
          OnClick = btnViewsClick
        end
        object btnDefinitions: TButton
          AlignWithMargins = True
          Left = 3
          Top = 266
          Width = 171
          Height = 26
          Align = alBottom
          Caption = 'View Definitions...'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          OnClick = btnDefinitionsClick
        end
        object pnlAllSources: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 35
          Width = 171
          Height = 225
          Align = alClient
          BevelOuter = bvNone
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          object splViews: TSplitter
            Left = 0
            Top = 83
            Width = 171
            Height = 3
            Cursor = crVSplit
            Align = alBottom
            ExplicitTop = 121
            ExplicitWidth = 128
          end
          object pnlOtherSources: TPanel
            Left = 0
            Top = 86
            Width = 171
            Height = 139
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 1
            TabOrder = 0
            object pnlOtherSourcesUser: TPanel
              Left = 1
              Top = 1
              Width = 169
              Height = 73
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblOtherPersons: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 30
                Width = 163
                Height = 13
                Align = alBottom
                Caption = 'Select Person:'
                ExplicitWidth = 69
              end
              object cboUser: TORComboBox
                AlignWithMargins = True
                Left = 3
                Top = 49
                Width = 163
                Height = 21
                Style = orcsDropDown
                Align = alBottom
                AutoSelect = True
                Caption = ''
                Color = clWindow
                DropDownCount = 6
                Items.Strings = (
                  '')
                ItemHeight = 13
                ItemTipColor = clWindow
                ItemTipEnable = True
                ListItemsOnly = False
                LongList = True
                LookupPiece = 2
                MaxLength = 0
                Pieces = '2'
                Sorted = False
                SynonymChars = '<>'
                TabOrder = 1
                TabStop = True
                Text = ''
                OnChange = cboUserChange
                OnEnter = cboUserEnter
                OnExit = cboUserExit
                OnKeyDown = cboUserKeyDown
                OnMouseClick = cboUserMouseClick
                OnNeedData = cboUserNeedData
                CharsNeedMatch = 1
              end
              object lbl508SelectOthers: TVA508StaticText
                Name = 'lbl508SelectOthers'
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 163
                Height = 15
                Align = alTop
                Alignment = taLeftJustify
                Caption = 'Select Views from others'
                TabOrder = 0
                ShowAccelChar = True
              end
            end
            object pnlOtherSourcesBottom: TPanel
              Left = 1
              Top = 74
              Width = 169
              Height = 64
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 1
              object lstOtherSources: TORListBox
                AlignWithMargins = True
                Left = 3
                Top = 23
                Width = 163
                Height = 38
                Align = alClient
                BevelInner = bvNone
                BevelOuter = bvNone
                ItemHeight = 13
                ParentShowHint = False
                ShowHint = False
                TabOrder = 0
                OnDblClick = lstSourcesDblClick
                OnEnter = lstOtherSourcesEnter
                OnExit = lstOtherSourcesExit
                Caption = ''
                ItemTipColor = clWindow
                LongList = False
                Pieces = '2'
                OnChange = lstOtherSourcesChange
              end
              object pnlOtherViews: TPanel
                Left = 0
                Top = 0
                Width = 169
                Height = 20
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 1
                object lblOtherViews: TLabel
                  AlignWithMargins = True
                  Left = 3
                  Top = 4
                  Width = 163
                  Height = 13
                  Align = alBottom
                  Caption = 'Other Views:'
                  ExplicitWidth = 60
                end
              end
            end
          end
          object pnlSources: TPanel
            Left = 0
            Top = 0
            Width = 171
            Height = 83
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object lblSource: TLabel
              Left = 0
              Top = 0
              Width = 171
              Height = 13
              Hint = 'These are the different types of data for graphing.'
              Align = alTop
              Caption = 'Sources:'
              ParentShowHint = False
              ShowHint = False
              ExplicitWidth = 42
            end
            object lstSources: TORListBox
              AlignWithMargins = True
              Left = 3
              Top = 16
              Width = 165
              Height = 64
              Align = alClient
              ItemHeight = 13
              ParentShowHint = False
              ShowHint = False
              TabOrder = 0
              OnDblClick = lstSourcesDblClick
              OnEnter = lstSourcesEnter
              OnExit = lstSourcesExit
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              OnChange = lstSourcesChange
            end
          end
        end
      end
      object Panel6: TPanel
        Left = 177
        Top = 0
        Width = 347
        Height = 295
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 347
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 0
          object lblSelectionInfo: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 89
            Height = 26
            Align = alLeft
            Caption = 'Select Items using:'
            ParentShowHint = False
            ShowHint = False
            ExplicitHeight = 13
          end
          object lbl508SelectionInfo: TVA508StaticText
            Name = 'lbl508SelectionInfo'
            AlignWithMargins = True
            Left = 2
            Top = 2
            Width = 90
            Height = 15
            Alignment = taLeftJustify
            Caption = 'Select items using:'
            Enabled = False
            TabOrder = 0
            Visible = False
            ShowAccelChar = True
          end
          object pnlSource: TPanel
            Left = 95
            Top = 0
            Width = 252
            Height = 32
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object radSourcePat: TRadioButton
              AlignWithMargins = True
              Left = 69
              Top = 0
              Width = 100
              Height = 29
              Hint = 
                'Use this for selecting patient items. Note: this form is used pr' +
                'imarily for defining views, #13 not selecting data.'
              Margins.Top = 0
              Align = alLeft
              Caption = 'Patient Items'
              TabOrder = 1
              OnClick = radSourceAllClick
            end
            object radSourceAll: TRadioButton
              AlignWithMargins = True
              Left = 3
              Top = 0
              Width = 60
              Height = 29
              Hint = 'Use this for defining views. It shows every possible item.'
              Margins.Top = 0
              Align = alLeft
              Caption = 'All Items'
              Checked = True
              TabOrder = 0
              TabStop = True
              OnClick = radSourceAllClick
            end
          end
        end
        object Panel8: TPanel
          Left = 0
          Top = 254
          Width = 347
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'Panel1'
          ShowCaption = False
          TabOrder = 1
          object lblEditInfo: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 341
            Height = 13
            Align = alTop
            Caption = 'Items for Graphing can be saved as Views.'
            ExplicitWidth = 202
          end
          object lblEditInfo1: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 22
            Width = 341
            Height = 13
            Align = alTop
            Caption = 'Edit Views by saving to the same name.'
            ExplicitWidth = 187
          end
          object lbl508EditInfo: TVA508StaticText
            Name = 'lbl508EditInfo'
            Left = 3
            Top = 2
            Width = 204
            Height = 15
            Alignment = taLeftJustify
            Caption = 'Items for Graphing can be saved as Views.'
            Enabled = False
            TabOrder = 0
            Visible = False
            ShowAccelChar = True
          end
          object lbl508EditInfo1: TVA508StaticText
            Name = 'lbl508EditInfo1'
            Left = 3
            Top = 24
            Width = 189
            Height = 15
            Alignment = taLeftJustify
            Caption = 'Edit Views by saving to the same name.'
            Enabled = False
            TabOrder = 1
            Visible = False
            ShowAccelChar = True
          end
        end
        object Panel9: TPanel
          Left = 0
          Top = 32
          Width = 127
          Height = 222
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel9'
          ShowCaption = False
          TabOrder = 2
          object lblSelection: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 121
            Height = 13
            Hint = 'Make selections move them to the right.'
            Align = alTop
            Caption = 'Items:'
            ParentShowHint = False
            ShowHint = False
            ExplicitWidth = 28
          end
          object cboAllItems: TORComboBox
            AlignWithMargins = True
            Left = 3
            Top = 22
            Width = 121
            Height = 197
            Style = orcsSimple
            Align = alClient
            AutoSelect = True
            Caption = ''
            Color = clWindow
            DropDownCount = 8
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = True
            LookupPiece = 0
            MaxLength = 0
            ParentShowHint = False
            Pieces = '3'
            ShowHint = False
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            Text = ''
            OnChange = cboAllItemsChange
            OnDblClick = cboAllItemsClick
            OnNeedData = cboAllItemsNeedData
            CharsNeedMatch = 1
          end
          object lstItemsSelection: TORListBox
            Left = 0
            Top = 19
            Width = 127
            Height = 203
            Align = alClient
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = False
            Sorted = True
            TabOrder = 1
            Visible = False
            OnDblClick = cboAllItemsClick
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            Pieces = '3'
            OnChange = cboAllItemsChange
          end
        end
        object Panel10: TPanel
          Left = 127
          Top = 32
          Width = 34
          Height = 222
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel10'
          ShowCaption = False
          TabOrder = 3
          object btnAddAll: TButton
            AlignWithMargins = True
            Left = 3
            Top = 24
            Width = 28
            Height = 21
            Margins.Top = 24
            Align = alTop
            Caption = '>>'
            Enabled = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = cboAllItemsClick
          end
          object btnAdd: TButton
            AlignWithMargins = True
            Left = 3
            Top = 51
            Width = 28
            Height = 21
            Align = alTop
            Caption = '>'
            Enabled = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnClick = cboAllItemsClick
          end
          object btnRemoveOne: TButton
            AlignWithMargins = True
            Left = 3
            Top = 78
            Width = 28
            Height = 21
            Align = alTop
            Caption = '<'
            Enabled = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 2
            OnClick = btnRemoveOneClick
          end
          object btnRemoveAll: TButton
            AlignWithMargins = True
            Left = 3
            Top = 105
            Width = 28
            Height = 21
            Align = alTop
            Caption = '<<'
            Enabled = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 3
            OnClick = btnRemoveAllClick
          end
        end
        object Panel11: TPanel
          Left = 161
          Top = 32
          Width = 186
          Height = 222
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel11'
          ShowCaption = False
          TabOrder = 4
          object lblDisplay: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 180
            Height = 13
            Hint = 
              'These items can be saved as a View and/or displayed on the graph' +
              '.'
            Align = alTop
            Caption = 'Items for Graphing:'
            ParentShowHint = False
            ShowHint = False
            ExplicitWidth = 89
          end
          object lstItemsDisplayed: TORListBox
            AlignWithMargins = True
            Left = 3
            Top = 22
            Width = 180
            Height = 197
            Align = alClient
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = False
            Sorted = True
            TabOrder = 0
            OnDblClick = lstItemsDisplayedDblClick
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            Pieces = '3'
            OnChange = lstItemsDisplayedChange
          end
        end
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 296
      Width = 524
      Height = 32
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel1'
      ShowCaption = False
      TabOrder = 1
      object btnClear: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 120
        Height = 26
        Align = alLeft
        Caption = 'Clear Selections'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        OnClick = btnClearClick
      end
      object btnDelete: TButton
        AlignWithMargins = True
        Left = 129
        Top = 3
        Width = 85
        Height = 26
        Align = alLeft
        Caption = 'Delete...'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        OnClick = btnDeleteClick
      end
      object btnRename: TButton
        AlignWithMargins = True
        Left = 220
        Top = 3
        Width = 85
        Height = 26
        Align = alLeft
        Caption = 'Rename...'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnClick = btnRenameClick
      end
      object btnSave: TButton
        AlignWithMargins = True
        Left = 311
        Top = 3
        Width = 112
        Height = 26
        Align = alLeft
        Caption = 'Save Personal...'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 3
        OnClick = btnSaveClick
      end
      object btnSavePublic: TButton
        AlignWithMargins = True
        Left = 424
        Top = 3
        Width = 97
        Height = 26
        Align = alRight
        Caption = 'Save Public...'
        Enabled = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 4
        OnClick = btnSaveClick
      end
    end
    object pnlApply: TPanel
      Left = 1
      Top = 337
      Width = 524
      Height = 32
      Align = alBottom
      BevelOuter = bvNone
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      object lblApply: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 138
        Height = 26
        Align = alLeft
        Caption = 'Display Items for Graphing to:'
        ExplicitHeight = 13
      end
      object lbl508Apply: TVA508StaticText
        Name = 'lbl508Apply'
        AlignWithMargins = True
        Left = 3
        Top = 2
        Width = 140
        Height = 15
        Alignment = taLeftJustify
        Caption = 'Display Items for Graphing to:'
        Enabled = False
        TabOrder = 0
        Visible = False
        ShowAccelChar = True
      end
      object radBoth: TRadioButton
        AlignWithMargins = True
        Left = 464
        Top = 3
        Width = 57
        Height = 26
        Align = alRight
        Caption = 'Both'
        TabOrder = 1
      end
      object radBottom: TRadioButton
        AlignWithMargins = True
        Left = 401
        Top = 3
        Width = 57
        Height = 26
        Align = alRight
        Caption = 'Bottom'
        TabOrder = 2
      end
      object radNeither: TRadioButton
        AlignWithMargins = True
        Left = 298
        Top = 3
        Width = 97
        Height = 26
        Align = alRight
        Caption = 'No Change'
        TabOrder = 3
      end
      object radTop: TRadioButton
        AlignWithMargins = True
        Left = 235
        Top = 3
        Width = 57
        Height = 26
        Align = alRight
        Caption = 'Top'
        Checked = True
        TabOrder = 4
        TabStop = True
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 448
    Top = 280
    Data = (
      (
        'Component = btnClear'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnRemoveOne'
        'Text = Remove selected item from graphing.'
        'Status = stsOK')
      (
        'Component = btnRemoveAll'
        'Text = Remove all items from graphing.'
        'Status = stsOK')
      (
        'Component = lstItemsDisplayed'
        'Label = lblDisplay'
        'Status = stsOK')
      (
        'Component = pnlSource'
        'Status = stsDefault')
      (
        'Component = radSourcePat'
        'Status = stsDefault')
      (
        'Component = radSourceAll'
        'Status = stsDefault')
      (
        'Component = lstItemsSelection'
        'Status = stsDefault')
      (
        'Component = pnlTempData'
        'Status = stsDefault')
      (
        'Component = lstActualItems'
        'Status = stsDefault')
      (
        'Component = lstDrugClass'
        'Status = stsDefault')
      (
        'Component = lstScratch'
        'Status = stsDefault')
      (
        'Component = lstTests'
        'Status = stsDefault')
      (
        'Component = pnlApply'
        'Status = stsDefault')
      (
        'Component = radNeither'
        'Status = stsDefault')
      (
        'Component = radBoth'
        'Status = stsDefault')
      (
        'Component = radBottom'
        'Status = stsDefault')
      (
        'Component = radTop'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Text = Add selected item to graphing.'
        'Status = stsOK')
      (
        'Component = btnAddAll'
        'Text = Add all items to graphing.'
        'Status = stsOK')
      (
        'Component = btnRename'
        'Status = stsDefault')
      (
        'Component = btnSavePublic'
        'Status = stsDefault')
      (
        'Component = cboAllItems'
        'Label = lblSelection'
        'Status = stsOK')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = frmGraphProfiles'
        'Status = stsDefault')
      (
        'Component = pnlAllSources'
        'Status = stsDefault')
      (
        'Component = pnlSources'
        'Status = stsDefault')
      (
        'Component = lstSources'
        'Status = stsDefault')
      (
        'Component = pnlOtherSources'
        'Status = stsDefault')
      (
        'Component = pnlOtherSourcesUser'
        'Status = stsDefault')
      (
        'Component = cboUser'
        'Text = To select a user use the arrow keys, then press enter'
        'Status = stsOK')
      (
        'Component = pnlOtherSourcesBottom'
        'Status = stsDefault')
      (
        'Component = lstOtherSources'
        'Label = lblOtherViews'
        'Status = stsOK')
      (
        'Component = btnViews'
        'Status = stsDefault')
      (
        'Component = btnDefinitions'
        'Status = stsDefault')
      (
        'Component = pnlOtherViews'
        'Status = stsDefault')
      (
        'Component = lbl508EditInfo'
        'Status = stsDefault')
      (
        'Component = lbl508EditInfo1'
        'Status = stsDefault')
      (
        'Component = lbl508Apply'
        'Status = stsDefault')
      (
        'Component = lbl508SelectOthers'
        'Status = stsDefault')
      (
        'Component = lbl508SelectionInfo'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = Panel5'
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
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = Panel11'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault'))
  end
end
