inherited frmTemplateFieldEditor: TfrmTemplateFieldEditor
  Left = 294
  Top = 211
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Template Field Editor'
  ClientHeight = 420
  ClientWidth = 788
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  ExplicitWidth = 804
  ExplicitHeight = 455
  PixelsPerInch = 96
  TextHeight = 13
  object splLeft: TSplitter [0]
    Left = 429
    Top = 25
    Height = 366
    Beveled = True
    ExplicitLeft = 273
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 391
    Width = 788
    Height = 29
    Align = alBottom
    TabOrder = 3
    DesignSize = (
      788
      29)
    object lblReq: TStaticText
      Left = 132
      Top = 8
      Width = 134
      Height = 17
      Caption = '* Indicates a Required Field'
      TabOrder = 5
    end
    object btnOK: TButton
      Left = 548
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 628
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnApply: TButton
      Left = 708
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Apply'
      TabOrder = 3
      OnClick = btnApplyClick
    end
    object btnPreview: TButton
      Left = 435
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Preview'
      Enabled = False
      TabOrder = 0
      OnClick = btnPreviewClick
    end
    object cbHide: TCheckBox
      Left = 6
      Top = 6
      Width = 115
      Height = 17
      Caption = 'Hide Inactive Fields'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = cbHideClick
    end
  end
  object pnlObjs: TPanel [2]
    Left = 0
    Top = 25
    Width = 429
    Height = 366
    Align = alLeft
    Caption = 'pnlObjs'
    TabOrder = 1
    OnResize = pnlObjsResize
    object lblObjs: TLabel
      Left = 1
      Top = 1
      Width = 427
      Height = 13
      Align = alTop
      Caption = 'Template Fields'
      ExplicitWidth = 74
    end
    object cbxObjs: TORComboBox
      Left = 1
      Top = 14
      Width = 427
      Height = 351
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Template Fields'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2,3'
      HideSynonyms = True
      Sorted = False
      SynonymChars = '<Inactive>'
      TabPositions = '50,60,70,80,90'
      TabOrder = 0
      Text = ''
      OnChange = cbxObjsChange
      OnKeyDown = cbxObjsKeyDown
      OnNeedData = cbxObjsNeedData
      OnSynonymCheck = cbxObjsSynonymCheck
      CharsNeedMatch = 1
    end
  end
  object pnlRight: TPanel [3]
    Left = 432
    Top = 25
    Width = 356
    Height = 366
    Align = alClient
    Constraints.MinWidth = 356
    TabOrder = 2
    OnResize = FormResize
    object splBottom: TSplitter
      Left = 1
      Top = 278
      Width = 354
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
    end
    object pnlPreview: TPanel
      Left = 1
      Top = 281
      Width = 354
      Height = 84
      Align = alBottom
      TabOrder = 1
      OnResize = FormResize
      object lblNotes: TLabel
        Left = 1
        Top = 1
        Width = 352
        Height = 13
        Align = alTop
        Caption = 'Notes:'
        ExplicitWidth = 31
      end
      object reNotes: TRichEdit
        Left = 1
        Top = 14
        Width = 352
        Height = 69
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        PopupMenu = popText
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
        OnChange = reNotesChange
        OnEnter = edtpopControlEnter
        OnKeyUp = reNotesKeyUp
        OnResizeRequest = reItemsResizeRequest
      end
    end
    object pnlObjInfo: TPanel
      Left = 1
      Top = 1
      Width = 354
      Height = 277
      Align = alClient
      TabOrder = 0
      OnResize = FormResize
      DesignSize = (
        354
        277)
      object lblName: TLabel
        Left = 4
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Name:'
      end
      object lblS2: TLabel
        Left = 4
        Top = 75
        Width = 23
        Height = 13
        Caption = 'lblS2'
      end
      object lblLM: TLabel
        Left = 3
        Top = 194
        Width = 42
        Height = 13
        Hint = 'Text to replace template field when used in List Manager'
        Anchors = [akLeft, akBottom]
        Caption = 'LM Text:'
        ParentShowHint = False
        ShowHint = True
      end
      object lblS1: TLabel
        Left = 4
        Top = 53
        Width = 23
        Height = 13
        Caption = 'lblS1'
      end
      object lblType: TLabel
        Left = 4
        Top = 32
        Width = 27
        Height = 13
        Caption = 'Type:'
      end
      object lblTextLen: TLabel
        Left = 255
        Top = 31
        Width = 45
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Text Len:'
      end
      object lblLength: TLabel
        Left = 157
        Top = 31
        Width = 46
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Field Len:'
      end
      object lblS3: TLabel
        Left = 4
        Top = 97
        Width = 23
        Height = 13
        Caption = 'lblS3'
      end
      object lblLine: TLabel
        Left = 4
        Top = 152
        Width = 23
        Height = 13
        Caption = 'Line:'
      end
      object lblCol: TLabel
        Left = 4
        Top = 168
        Width = 18
        Height = 13
        Caption = 'Col:'
      end
      object edtName: TCaptionEdit
        Left = 50
        Top = 4
        Width = 300
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 60
        ParentFont = False
        PopupMenu = popText
        TabOrder = 2
        OnChange = edtNameChange
        OnEnter = edtpopControlEnter
        OnExit = edtNameExit
        Caption = 'Name'
      end
      object edtLMText: TCaptionEdit
        Left = 50
        Top = 189
        Width = 300
        Height = 22
        Hint = 'Text to replace template field when used in List Manager'
        Anchors = [akLeft, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        MaxLength = 70
        ParentFont = False
        ParentShowHint = False
        PopupMenu = popText
        ShowHint = True
        TabOrder = 11
        OnChange = edtLMTextChange
        OnEnter = edtpopControlEnter
        Caption = 'LM Text'
      end
      object cbxType: TORComboBox
        Left = 50
        Top = 27
        Width = 102
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Type'
        Color = clWindow
        DropDownCount = 11
        Items.Strings = (
          ''
          'E^Edit Box'
          'C^Combo Box'
          'B^Button'
          'X^Check Boxes'
          'R^Radio Buttons'
          'D^Date'
          'N^Number'
          'H^Hyperlink'
          'W^Word Processing'
          'T^Text')
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
        OnChange = cbxTypeChange
        CharsNeedMatch = 1
      end
      object edtTextLen: TCaptionEdit
        Left = 309
        Top = 27
        Width = 26
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 7
        Text = '0'
        OnChange = edtTextLenChange
        Caption = 'Text Length'
      end
      object udTextLen: TUpDown
        Left = 335
        Top = 27
        Width = 15
        Height = 21
        Anchors = [akTop, akRight]
        Associate = edtTextLen
        Max = 240
        TabOrder = 8
      end
      object pnlSwap: TPanel
        Left = 50
        Top = 49
        Width = 300
        Height = 140
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 9
        object edtDefault: TCaptionEdit
          Left = 0
          Top = 0
          Width = 300
          Height = 22
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          MaxLength = 70
          ParentFont = False
          PopupMenu = popText
          TabOrder = 1
          OnChange = edtDefaultChange
          OnEnter = edtpopControlEnter
          OnExit = ControlExit
          Caption = 'Default Value'
        end
        object pnlNum: TPanel
          Left = 0
          Top = 22
          Width = 300
          Height = 22
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object lblMin: TLabel
            Left = 53
            Top = 4
            Width = 20
            Height = 13
            Caption = 'Min:'
          end
          object lblInc: TLabel
            Left = 207
            Top = 4
            Width = 50
            Height = 13
            Caption = 'Increment:'
          end
          object lblMaxVal: TLabel
            Left = 129
            Top = 4
            Width = 23
            Height = 13
            Caption = 'Max:'
          end
          object udDefNum: TUpDown
            Left = 34
            Top = 0
            Width = 15
            Height = 21
            Associate = edtDefNum
            Min = -9999
            Max = 9999
            TabOrder = 3
            Thousands = False
          end
          object edtDefNum: TCaptionEdit
            Left = 0
            Top = 0
            Width = 34
            Height = 21
            TabOrder = 1
            Text = '0'
            OnChange = edtDefNumChange
            Caption = 'Default Number'
          end
          object udMinVal: TUpDown
            Left = 110
            Top = 0
            Width = 15
            Height = 21
            Associate = edtMinVal
            Min = -9999
            Max = 9999
            TabOrder = 5
            Thousands = False
          end
          object edtMinVal: TCaptionEdit
            Left = 76
            Top = 0
            Width = 34
            Height = 21
            TabOrder = 4
            Text = '0'
            OnChange = edtMinValChange
            Caption = 'Minimum'
          end
          object udInc: TUpDown
            Left = 285
            Top = 0
            Width = 15
            Height = 21
            Associate = edtInc
            Min = 1
            Max = 999
            Position = 1
            TabOrder = 11
          end
          object edtInc: TCaptionEdit
            Left = 259
            Top = 0
            Width = 26
            Height = 21
            TabOrder = 9
            Text = '1'
            OnChange = edtIncChange
            Caption = 'Increment'
          end
          object edtMaxVal: TCaptionEdit
            Left = 155
            Top = 0
            Width = 34
            Height = 21
            TabOrder = 6
            Text = '0'
            OnChange = edtMaxValChange
            Caption = 'Maimum'
          end
          object udMaxVal: TUpDown
            Left = 189
            Top = 0
            Width = 15
            Height = 21
            Associate = edtMaxVal
            Min = -9999
            Max = 9999
            TabOrder = 7
            Thousands = False
          end
        end
        object edtURL: TCaptionEdit
          Left = 0
          Top = 66
          Width = 300
          Height = 22
          Align = alTop
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          MaxLength = 240
          ParentFont = False
          PopupMenu = popText
          TabOrder = 5
          OnChange = edtURLChange
          OnEnter = edtpopControlEnter
          Caption = 'URL'
        end
        object reItems: TRichEdit
          Left = 0
          Top = 110
          Width = 300
          Height = 30
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PopupMenu = popText
          ScrollBars = ssVertical
          TabOrder = 7
          WantTabs = True
          OnChange = reItemsChange
          OnEnter = edtpopControlEnter
          OnExit = ControlExit
          OnKeyUp = reNotesKeyUp
          OnResizeRequest = reItemsResizeRequest
          OnSelectionChange = reItemsSelectionChange
        end
        object cbxDefault: TORComboBox
          Left = 0
          Top = 44
          Width = 300
          Height = 22
          Style = orcsDropDown
          Align = alTop
          AutoSelect = True
          Caption = 'Default Selection'
          Color = clWindow
          DropDownCount = 8
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ItemHeight = 14
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 3
          TabStop = True
          Text = ''
          OnChange = cbxDefaultChange
          CharsNeedMatch = 1
        end
        object pnlDate: TPanel
          Left = 0
          Top = 88
          Width = 300
          Height = 22
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 6
          DesignSize = (
            300
            22)
          object lblDateType: TLabel
            Left = 111
            Top = 4
            Width = 53
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Date Type:'
          end
          object edtDateDef: TCaptionEdit
            Left = 0
            Top = 0
            Width = 106
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            MaxLength = 70
            PopupMenu = popText
            TabOrder = 1
            OnChange = edtDefaultChange
            OnEnter = edtpopControlEnter
            Caption = 'Default Date'
          end
          object cbxDateType: TORComboBox
            Left = 167
            Top = 0
            Width = 133
            Height = 21
            Anchors = [akTop, akRight]
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Date Type'
            Color = clWindow
            DropDownCount = 8
            Items.Strings = (
              'D^Date'
              'T^Date & Time'
              'R^Date & Required Time'
              'C^Combo Style'
              'Y^Combo Year Only'
              'M^Combo Year & Month')
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
            TabOrder = 2
            Text = ''
            OnChange = cbxDateTypeChange
            CharsNeedMatch = 1
          end
        end
      end
      object edtLen: TCaptionEdit
        Left = 214
        Top = 27
        Width = 19
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 4
        Text = '1'
        OnChange = edtLenChange
        Caption = 'Field Length'
      end
      object udLen: TUpDown
        Left = 233
        Top = 27
        Width = 15
        Height = 21
        Anchors = [akTop, akRight]
        Associate = edtLen
        Min = 1
        Max = 70
        Position = 1
        TabOrder = 5
      end
      object gbIndent: TGroupBox
        Left = 232
        Top = 213
        Width = 118
        Height = 59
        Anchors = [akLeft, akBottom]
        Caption = ' Indent '
        TabOrder = 13
        object lblIndent: TLabel
          Left = 10
          Top = 14
          Width = 58
          Height = 13
          Caption = 'Indent Field:'
        end
        object lblPad: TLabel
          Left = 10
          Top = 37
          Width = 57
          Height = 13
          Caption = 'Indent Text:'
        end
        object edtIndent: TCaptionEdit
          Left = 72
          Top = 10
          Width = 21
          Height = 21
          TabOrder = 1
          Text = '0'
          OnChange = edtIndentChange
          Caption = 'Indent Field'
        end
        object udIndent: TUpDown
          Left = 93
          Top = 10
          Width = 15
          Height = 21
          Associate = edtIndent
          Max = 30
          TabOrder = 2
          Thousands = False
        end
        object udPad: TUpDown
          Left = 93
          Top = 33
          Width = 15
          Height = 21
          Associate = edtPad
          Max = 30
          TabOrder = 5
          Thousands = False
        end
        object edtPad: TCaptionEdit
          Left = 72
          Top = 33
          Width = 21
          Height = 21
          TabOrder = 3
          Text = '0'
          OnChange = edtPadChange
          Caption = 'Indent Text'
        end
      end
      object gbMisc: TGroupBox
        Left = 10
        Top = 213
        Width = 207
        Height = 59
        Anchors = [akLeft, akBottom]
        Caption = ' Miscellaneous '
        TabOrder = 12
        object cbActive: TCheckBox
          Left = 6
          Top = 14
          Width = 67
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = 'Inactive'
          ParentBiDiMode = False
          TabOrder = 0
          OnClick = cbActiveClick
        end
        object cbRequired: TCheckBox
          Left = 6
          Top = 37
          Width = 67
          Height = 17
          Caption = 'Required'
          TabOrder = 2
          OnClick = cbRequiredClick
        end
        object cbSepLines: TCheckBox
          Left = 83
          Top = 14
          Width = 99
          Height = 17
          Caption = 'Separate Lines'
          TabOrder = 1
          OnClick = cbSepLinesClick
        end
        object cbExclude: TCheckBox
          Left = 83
          Top = 37
          Width = 118
          Height = 17
          Caption = 'Exclude From Note'
          TabOrder = 3
          OnClick = cbExcludeClick
        end
      end
    end
  end
  object pnlTop: TPanel [4]
    Left = 0
    Top = 0
    Width = 788
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      788
      25)
    object MenuBar1: TMenuBar
      Left = 0
      Top = 0
      Width = 41
      Height = 25
      Align = alLeft
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 37
      Caption = 'MenuBar1'
      Menu = mnuMain
      ShowCaptions = True
      TabOrder = 0
    end
    object btnNew: TButton
      Left = 710
      Top = 2
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'New'
      TabOrder = 3
      OnClick = mnuNewClick
    end
    object btnCopy: TButton
      Left = 631
      Top = 2
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Copy'
      Enabled = False
      TabOrder = 2
      OnClick = mnuCopyClick
    end
    object btnDelete: TButton
      Left = 552
      Top = 2
      Width = 75
      Height = 21
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Delete'
      Enabled = False
      TabOrder = 1
      OnClick = mnuDeleteClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = lblReq'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = btnPreview'
        'Status = stsDefault')
      (
        'Component = cbHide'
        'Status = stsDefault')
      (
        'Component = pnlObjs'
        'Status = stsDefault')
      (
        'Component = cbxObjs'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'Status = stsDefault')
      (
        'Component = pnlPreview'
        'Status = stsDefault')
      (
        'Component = reNotes'
        'Status = stsDefault')
      (
        'Component = pnlObjInfo'
        'Status = stsDefault')
      (
        'Component = edtName'
        'Status = stsDefault')
      (
        'Component = edtLMText'
        'Status = stsDefault')
      (
        'Component = cbxType'
        'Status = stsDefault')
      (
        'Component = edtTextLen'
        'Status = stsDefault')
      (
        'Component = udTextLen'
        'Status = stsDefault')
      (
        'Component = pnlSwap'
        'Status = stsDefault')
      (
        'Component = edtDefault'
        'Status = stsDefault')
      (
        'Component = pnlNum'
        'Status = stsDefault')
      (
        'Component = udDefNum'
        'Status = stsDefault')
      (
        'Component = edtDefNum'
        'Status = stsDefault')
      (
        'Component = udMinVal'
        'Status = stsDefault')
      (
        'Component = edtMinVal'
        'Status = stsDefault')
      (
        'Component = udInc'
        'Status = stsDefault')
      (
        'Component = edtInc'
        'Status = stsDefault')
      (
        'Component = edtMaxVal'
        'Status = stsDefault')
      (
        'Component = udMaxVal'
        'Status = stsDefault')
      (
        'Component = edtURL'
        'Status = stsDefault')
      (
        'Component = reItems'
        'Status = stsDefault')
      (
        'Component = cbxDefault'
        'Status = stsDefault')
      (
        'Component = pnlDate'
        'Status = stsDefault')
      (
        'Component = edtDateDef'
        'Status = stsDefault')
      (
        'Component = cbxDateType'
        'Status = stsDefault')
      (
        'Component = edtLen'
        'Status = stsDefault')
      (
        'Component = udLen'
        'Status = stsDefault')
      (
        'Component = gbIndent'
        'Status = stsDefault')
      (
        'Component = edtIndent'
        'Status = stsDefault')
      (
        'Component = udIndent'
        'Status = stsDefault')
      (
        'Component = udPad'
        'Status = stsDefault')
      (
        'Component = edtPad'
        'Status = stsDefault')
      (
        'Component = gbMisc'
        'Status = stsDefault')
      (
        'Component = cbActive'
        'Status = stsDefault')
      (
        'Component = cbRequired'
        'Status = stsDefault')
      (
        'Component = cbSepLines'
        'Status = stsDefault')
      (
        'Component = cbExclude'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = MenuBar1'
        'Status = stsDefault')
      (
        'Component = btnNew'
        'Status = stsDefault')
      (
        'Component = btnCopy'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = frmTemplateFieldEditor'
        'Status = stsDefault'))
  end
  object mnuMain: TMainMenu
    Left = 8
    Top = 64
    object mnuAction: TMenuItem
      Caption = '&Action'
      OnClick = mnuActionClick
      object mnuNew: TMenuItem
        Caption = '&New'
        OnClick = mnuNewClick
      end
      object mnuCopy: TMenuItem
        Caption = '&Copy'
        OnClick = mnuCopyClick
      end
      object mnuDelete: TMenuItem
        Caption = '&Delete'
        OnClick = mnuDeleteClick
      end
      object mnuPreview: TMenuItem
        Caption = '&Preview'
        OnClick = btnPreviewClick
      end
    end
  end
  object popText: TPopupMenu
    OnPopup = popTextPopup
    Left = 339
    Top = 204
    object mnuBPUndo: TMenuItem
      Caption = '&Undo'
      ShortCut = 16474
      OnClick = mnuBPUndoClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object mnuBPCut: TMenuItem
      Caption = 'Cu&t'
      ShortCut = 16472
      OnClick = mnuBPCutClick
    end
    object mnuBPCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = mnuBPCopyClick
    end
    object mnuBPPaste: TMenuItem
      Caption = '&Paste'
      ShortCut = 16470
      OnClick = mnuBPPasteClick
    end
    object mnuBPSelectAll: TMenuItem
      Caption = 'Select &All'
      ShortCut = 16449
      OnClick = mnuBPSelectAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuBPCheckGrammar: TMenuItem
      Caption = 'Check &Grammar'
      ShortCut = 16455
      OnClick = mnuBPCheckGrammarClick
    end
    object mnuBPSpellCheck: TMenuItem
      Caption = 'Check &Spelling'
      ShortCut = 16467
      OnClick = mnuBPSpellCheckClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object mnuInsertTemplateField: TMenuItem
      Caption = 'Insert Template &Field'
      ShortCut = 16454
      OnClick = mnuInsertTemplateFieldClick
    end
  end
end
