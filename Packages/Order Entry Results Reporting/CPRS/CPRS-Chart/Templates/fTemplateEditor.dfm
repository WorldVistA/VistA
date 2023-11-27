inherited frmTemplateEditor: TfrmTemplateEditor
  Left = 321
  Top = 119
  HelpContext = 10000
  ActiveControl = tvPersonal
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Template Editor'
  ClientHeight = 639
  ClientWidth = 909
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 925
  ExplicitHeight = 678
  PixelsPerInch = 96
  TextHeight = 13
  object splMain: TSplitter [0]
    Left = 0
    Top = 300
    Width = 909
    Height = 3
    Cursor = crVSplit
    Align = alTop
    AutoSnap = False
    Beveled = True
    MinSize = 40
    OnCanResize = splMainCanResize
    OnMoved = splMainMoved
    ExplicitTop = 239
    ExplicitWidth = 740
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 909
    Height = 300
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 223
    TabOrder = 0
    object splMiddle: TSplitter
      Left = 260
      Top = 26
      Height = 274
      Align = alRight
      AutoSnap = False
      Beveled = True
      ExplicitLeft = 297
      ExplicitTop = 24
      ExplicitHeight = 215
    end
    object Bevel1: TBevel
      Left = 0
      Top = 22
      Width = 909
      Height = 4
      Align = alTop
      Shape = bsTopLine
      ExplicitWidth = 959
    end
    object pnlRightTop: TPanel
      Left = 263
      Top = 26
      Width = 646
      Height = 274
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object splProperties: TSplitter
        Left = 338
        Top = 0
        Height = 274
        Align = alRight
        AutoSnap = False
        Beveled = True
        ExplicitLeft = 402
        ExplicitHeight = 276
      end
      object pnlCopyBtns: TPanel
        Left = 0
        Top = 0
        Width = 28
        Height = 274
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          28
          274)
        object lblCopy: TLabel
          Left = -3
          Top = 76
          Width = 31
          Height = 19
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'Copy'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
        end
        object sbCopyRight: TBitBtn
          Left = 1
          Top = 125
          Width = 23
          Height = 23
          Hint = 'Copy Shared Template into Personal Template List'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
            1111111111111111111111111111111111111111111F11111111111111011111
            11111111117FF1111111111111001111111111111177FF111111111111000111
            1111111111777FF11111111111000011111111FFFF7777FF1111100000000001
            111117777777777FF1111000000000001111177777777777FF11100000000000
            01111777777777777F1110000000000001111777777777777111100000000000
            1111177777777777111110000000000111111777777777711111111111000011
            1111111111777711111111111100011111111111117771111111111111001111
            1111111111771111111111111101111111111111117111111111}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = sbCopyRightClick
        end
        object sbCopyLeft: TBitBtn
          Tag = 1
          Left = 1
          Top = 100
          Width = 23
          Height = 23
          Hint = 'Copy Personal Template into Shared Template List'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
            11111111111111111111111111111111111111111111F1111111111111101111
            111111111117F1111111111111001111111111111177F1111111111110001111
            111111111777F1111111111100001111111111117777FFFFFF11111000000000
            01111117777777777F1111000000000001111177777777777F11100000000000
            01111777777777777F1110000000000001111777777777777F11110000000000
            01111177777777777F1111100000000001111117777777777111111100001111
            111111117777F1111111111110001111111111111777F1111111111111001111
            111111111177F111111111111110111111111111111711111111}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = sbCopyLeftClick
        end
      end
      object pnlPersonal: TPanel
        Left = 28
        Top = 0
        Width = 310
        Height = 274
        Align = alClient
        BevelOuter = bvNone
        Constraints.MinWidth = 100
        TabOrder = 1
        object tvPersonal: TORTreeView
          Tag = 1
          Left = 0
          Top = 57
          Width = 310
          Height = 193
          Align = alClient
          DragMode = dmAutomatic
          Images = dmodShared.imgTemplates
          Indent = 19
          PopupMenu = popTemplatesPlus
          RightClickSelect = True
          TabOrder = 3
          OnChange = tvTreeChange
          OnDragDrop = tvTreeDragDrop
          OnDragOver = tvTreeDragOver
          OnEdited = tvTreeNodeEdited
          OnEndDrag = tvTreeEndDrag
          OnEnter = tvTreeEnter
          OnExpanding = tvPersonalExpanding
          OnGetImageIndex = tvTreeGetImageIndex
          OnGetSelectedIndex = tvTreeGetSelectedIndex
          OnKeyDown = tvTreeKeyDown
          OnStartDrag = tvTreeStartDrag
          Caption = 'Personal Templates'
          NodePiece = 0
          OnDragging = tvTreeDragging
        end
        object pnlPersonalBottom: TPanel
          Left = 0
          Top = 250
          Width = 310
          Height = 24
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 4
          object sbPerUp: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 218
            Top = 2
            Width = 21
            Height = 20
            Hint = 'Move Personal Template Up'
            Margins.Left = 0
            Margins.Top = 2
            Margins.Right = 0
            Margins.Bottom = 2
            Align = alRight
            Enabled = False
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
              1111111111111111111111111111111111111111111111111111111111111111
              111111111FFFFFF1111111110000001111111111777777F11111111100000011
              11111111777777F1111111110000001111111111777777F11111111100000011
              11111111777777F1111111110000001111111FFF777777FFFFF1000000000000
              0011777777777777771110000000000001111777777777777111110000000000
              1111117777777777111111100000000111111117777777711111111100000011
              1111111177777711111111111000011111111111177771111111111111001111
              1111111111771111111111111111111111111111111111111111}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = sbMoveUpClick
            ExplicitLeft = 216
          end
          object sbPerDown: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 195
            Top = 2
            Width = 21
            Height = 20
            Hint = 'Move Personal Template Down'
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            Enabled = False
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
              1111111111111111111111111111111111111111111111111111111111111111
              11111111111FF1111111111111001111111111111177FF111111111110000111
              1111111117777FF1111111110000001111111111777777FF1111111000000001
              111111177777777FF1111100000000001111117777777777FF11100000000000
              01111777777777777FF100000000000000117777777777777711111100000011
              11111111777777F1111111110000001111111111777777F11111111100000011
              11111111777777F1111111110000001111111111777777F11111111100000011
              1111111177777711111111111111111111111111111111111111}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = sbMoveDownClick
            ExplicitLeft = 191
          end
          object sbPerDelete: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 241
            Top = 2
            Width = 67
            Height = 20
            Hint = 'Delete Personal Template'
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            Caption = 'Delete'
            Enabled = False
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
              1111111111111111111111111111111111111111111111111111111111111111
              111111FF11111111FF111001111111100111177FF11111177F11100011111100
              01111777FF1111777111110001111000111111777FF117771111111000110001
              1111111777FF7771111111110000001111111111777777111111111110000111
              1111111117777F1111111111100001111111111117777FF11111111100000011
              11111111777777FF1111111000110001111111177711777FF111110001111000
              1111117771111777FF1110001111110001111777111111777111100111111110
              0111177111111117711111111111111111111111111111111111}
            Layout = blGlyphRight
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = sbDeleteClick
          end
          object cbPerHide: TCheckBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 187
            Height = 18
            Hint = 'Hide Inactive Personal Templates'
            Align = alClient
            Caption = 'Hide &Inactive'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = cbPerHideClick
            ExplicitWidth = 183
          end
        end
        object pnlPersonalGap: TPanel
          Tag = 1
          Left = 0
          Top = 17
          Width = 310
          Height = 2
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
        end
        object pnlPerSearch: TPanel
          Left = 0
          Top = 19
          Width = 310
          Height = 38
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          OnResize = pnlPerSearchResize
          DesignSize = (
            310
            38)
          object btnPerFind: TORAlignButton
            Tag = 1
            Left = 255
            Top = 0
            Width = 55
            Height = 21
            Hint = 'Find Template'
            Anchors = [akTop, akRight]
            Caption = 'Find'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btnFindClick
          end
          object edtPerSearch: TCaptionEdit
            Tag = 1
            Left = 0
            Top = 0
            Width = 255
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnChange = edtSearchChange
            OnEnter = edtPerSearchEnter
            OnExit = edtPerSearchExit
            Caption = 'Personal Templates'
          end
          object cbPerMatchCase: TCheckBox
            Tag = 1
            Left = 0
            Top = 21
            Width = 99
            Height = 17
            Caption = 'Match Case'
            TabOrder = 3
            OnClick = cbPerFindOptionClick
          end
          object cbPerWholeWords: TCheckBox
            Tag = 1
            Left = 105
            Top = 21
            Width = 137
            Height = 17
            Caption = 'Whole Words Only'
            TabOrder = 4
            OnClick = cbPerFindOptionClick
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 310
          Height = 17
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 5
          object lblPersonal: TLabel
            Tag = 1
            Left = 0
            Top = 0
            Width = 93
            Height = 17
            Align = alLeft
            Caption = '&Personal Templates'
            FocusControl = tvPersonal
            ExplicitHeight = 13
          end
        end
      end
      object pnlProperties: TPanel
        Left = 341
        Top = 0
        Width = 305
        Height = 274
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = pnlPropertiesResize
        object gbProperties: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 299
          Height = 268
          Align = alClient
          Caption = 'Template Properties'
          Constraints.MinWidth = 100
          TabOrder = 0
          DesignSize = (
            299
            268)
          object lblName: TLabel
            Left = 5
            Top = 20
            Width = 31
            Height = 13
            Caption = 'Na&me:'
            FocusControl = edtName
          end
          object lblLines: TLabel
            Left = 46
            Top = 226
            Width = 133
            Height = 32
            Hint = 
              'Indicates the number of blank lines to insert, in the group boil' +
              'erplate, between each item'#39's boilerplate.'
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'Number of Blank &Lines to insert between items'
            FocusControl = edtGap
            ParentShowHint = False
            ShowHint = True
            WordWrap = True
          end
          object lblType: TLabel
            Left = 5
            Top = 50
            Width = 74
            Height = 13
            Caption = 'Template T&ype:'
            FocusControl = cbxType
          end
          object lblRemDlg: TLabel
            Left = 5
            Top = 74
            Width = 81
            Height = 13
            Caption = 'Reminder &Dialog:'
            FocusControl = cbxRemDlgs
          end
          object cbExclude: TORCheckBox
            Left = 5
            Top = 169
            Width = 101
            Height = 56
            Hint = 
              'Removes this template'#39's boilerplate from the group'#39's boilerplate' +
              '.'
            Caption = 'E&xclude from Group Boilerplate'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            WordWrap = True
            OnClick = cbExcludeClick
            AutoSize = True
          end
          object cbActive: TCheckBox
            Left = 5
            Top = 95
            Width = 61
            Height = 17
            Hint = 'Makes a template or folder active or inactive.'
            Caption = 'A&ctive'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 3
            OnClick = cbActiveClick
          end
          object edtGap: TCaptionEdit
            Left = 5
            Top = 230
            Width = 20
            Height = 21
            Hint = 
              'Indicates the number of blank lines to insert, in the group boil' +
              'erplate, between each item'#39's boilerplate.'
            MaxLength = 1
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            Text = '0'
            OnChange = edtGapChange
            OnKeyPress = edtGapKeyPress
            Caption = 'Number of Blank Lines to insert between items'
          end
          object udGap: TUpDown
            Left = 25
            Top = 230
            Width = 15
            Height = 21
            Hint = 
              'Indicates the number of blank lines to insert, in the group boil' +
              'erplate, between each item'#39's boilerplate.'
            Associate = edtGap
            Max = 3
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
          end
          object edtName: TCaptionEdit
            Left = 64
            Top = 17
            Width = 229
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            MaxLength = 60
            TabOrder = 0
            OnChange = edtNameOldChange
            OnExit = edtNameExit
            Caption = 'Name'
          end
          object gbDialogProps: TGroupBox
            Left = 136
            Top = 115
            Width = 157
            Height = 98
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Dialog Properties'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            object cbDisplayOnly: TCheckBox
              Left = 6
              Top = 15
              Width = 131
              Height = 17
              Hint = 
                'Template boilerplate is for dialog display only, and can not be ' +
                'added to the note.'
              Caption = 'Display Only'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = cbDisplayOnlyClick
            end
            object cbOneItemOnly: TCheckBox
              Left = 6
              Top = 60
              Width = 113
              Height = 17
              Hint = 'Allow only one child item to be selected at a time'
              Caption = 'One Item Only'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = cbOneItemOnlyClick
            end
            object cbFirstLine: TCheckBox
              Left = 6
              Top = 30
              Width = 144
              Height = 17
              Hint = 
                'Only show the first line of text in the dialog, but include the ' +
                'entire template in the note'
              Caption = 'Only Show First Line'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = cbFirstLineClick
            end
            object cbHideDlgItems: TCheckBox
              Left = 6
              Top = 75
              Width = 147
              Height = 17
              Hint = 'Hide child items when parent template is not selected'
              Caption = 'Hide Dialog Items'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = cbHideDlgItemsClick
            end
            object cbIndent: TCheckBox
              Left = 6
              Top = 45
              Width = 147
              Height = 17
              Hint = 
                'Indent child items in the dialog.  Text insertion remains unchan' +
                'ged'
              Caption = 'Indent Dialog Items'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = cbIndentClick
            end
          end
          object cbHideItems: TORCheckBox
            Left = 5
            Top = 115
            Width = 101
            Height = 54
            Hint = 'Hide child items from template drawer view'
            Caption = 'Hide Items in Templates Dra&wer'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            WordWrap = True
            OnClick = cbHideItemsClick
            AutoSize = True
          end
          object cbxType: TCaptionComboBox
            Left = 120
            Top = 44
            Width = 173
            Height = 24
            Style = csOwnerDrawFixed
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 18
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = cbxTypeChange
            OnDrawItem = cbxTypeDrawItem
            Caption = 'Template Type'
          end
          object cbxRemDlgs: TORComboBox
            Left = 118
            Top = 71
            Width = 176
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Reminder Dialog'
            Color = clWindow
            DropDownCount = 12
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
            OnChange = cbxRemDlgsChange
            CharsNeedMatch = 1
          end
          object cbLock: TORCheckBox
            Left = 212
            Top = 234
            Width = 47
            Height = 16
            Caption = 'Lock'
            TabOrder = 12
            OnClick = cbLockClick
          end
        end
      end
    end
    object pnlShared: TPanel
      Left = 0
      Top = 26
      Width = 260
      Height = 274
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object tvShared: TORTreeView
        Left = 0
        Top = 57
        Width = 260
        Height = 193
        Align = alClient
        DragMode = dmAutomatic
        Images = dmodShared.imgTemplates
        Indent = 19
        PopupMenu = popTemplatesPlus
        RightClickSelect = True
        TabOrder = 3
        OnChange = tvTreeChange
        OnDragDrop = tvTreeDragDrop
        OnDragOver = tvTreeDragOver
        OnEdited = tvTreeNodeEdited
        OnEndDrag = tvTreeEndDrag
        OnEnter = tvTreeEnter
        OnExpanding = tvSharedExpanding
        OnGetImageIndex = tvTreeGetImageIndex
        OnGetSelectedIndex = tvTreeGetSelectedIndex
        OnKeyDown = tvTreeKeyDown
        OnStartDrag = tvTreeStartDrag
        Caption = 'Shared Templates'
        NodePiece = 0
        OnDragging = tvTreeDragging
      end
      object pnlSharedBottom: TPanel
        Left = 0
        Top = 250
        Width = 260
        Height = 24
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 4
        object sbShUp: TBitBtn
          AlignWithMargins = True
          Left = 143
          Top = 2
          Width = 22
          Height = 20
          Hint = 'Move Shared Template Up'
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alRight
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
            1111111111111111111111111111111111111111111111111111111111111111
            111111111FFFFFF1111111110000001111111111777777F11111111100000011
            11111111777777F1111111110000001111111111777777F11111111100000011
            11111111777777F1111111110000001111111FFF777777FFFFF1000000000000
            0011777777777777771110000000000001111777777777777111110000000000
            1111117777777777111111100000000111111117777777711111111100000011
            1111111177777711111111111000011111111111177771111111111111001111
            1111111111771111111111111111111111111111111111111111}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = sbMoveUpClick
          ExplicitLeft = 139
        end
        object sbShDown: TBitBtn
          AlignWithMargins = True
          Left = 167
          Top = 2
          Width = 22
          Height = 20
          Hint = 'Move Shared Template Down'
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alRight
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
            1111111111111111111111111111111111111111111111111111111111111111
            11111111111FF1111111111111001111111111111177FF111111111110000111
            1111111117777FF1111111110000001111111111777777FF1111111000000001
            111111177777777FF1111100000000001111117777777777FF11100000000000
            01111777777777777FF100000000000000117777777777777711111100000011
            11111111777777F1111111110000001111111111777777F11111111100000011
            11111111777777F1111111110000001111111111777777F11111111100000011
            1111111177777711111111111111111111111111111111111111}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = sbMoveDownClick
          ExplicitLeft = 165
        end
        object sbShDelete: TBitBtn
          AlignWithMargins = True
          Left = 191
          Top = 2
          Width = 67
          Height = 20
          Hint = 'Delete Shared Template'
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Align = alRight
          Caption = 'Delete'
          Enabled = False
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
            1111111111111111111111111111111111111111111111111111111111111111
            111111FF11111111FF111001111111100111177FF11111177F11100011111100
            01111777FF1111777111110001111000111111777FF117771111111000110001
            1111111777FF7771111111110000001111111111777777111111111110000111
            1111111117777F1111111111100001111111111117777FF11111111100000011
            11111111777777FF1111111000110001111111177711777FF111110001111000
            1111117771111777FF1110001111110001111777111111777111100111111110
            0111177111111117711111111111111111111111111111111111}
          Layout = blGlyphRight
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = sbDeleteClick
        end
        object cbShHide: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 135
          Height = 18
          Hint = 'Hide Inactive Shared Templates'
          Align = alClient
          Caption = '&Hide Inactive'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = cbShHideClick
          ExplicitWidth = 131
        end
      end
      object pnlSharedGap: TPanel
        Left = 0
        Top = 17
        Width = 260
        Height = 2
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object pnlShSearch: TPanel
        Left = 0
        Top = 19
        Width = 260
        Height = 38
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        OnResize = pnlShSearchResize
        DesignSize = (
          260
          38)
        object btnShFind: TORAlignButton
          Left = 205
          Top = 0
          Width = 55
          Height = 21
          Hint = 'Find Template'
          Anchors = [akTop, akRight]
          Caption = 'Find'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnFindClick
        end
        object edtShSearch: TCaptionEdit
          Left = 0
          Top = 0
          Width = 205
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = edtSearchChange
          OnEnter = edtShSearchEnter
          OnExit = edtShSearchExit
          Caption = 'Shared Templates'
        end
        object cbShMatchCase: TCheckBox
          Left = 0
          Top = 21
          Width = 99
          Height = 17
          Caption = 'Match Case'
          TabOrder = 3
          OnClick = cbShFindOptionClick
        end
        object cbShWholeWords: TCheckBox
          Left = 111
          Top = 21
          Width = 143
          Height = 17
          Caption = 'Whole Words Only'
          TabOrder = 4
          OnClick = cbShFindOptionClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 260
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 5
        object lblShared: TLabel
          Left = 0
          Top = 0
          Width = 86
          Height = 17
          Align = alLeft
          Caption = '&Shared Templates'
          FocusControl = tvShared
          ExplicitHeight = 13
        end
      end
    end
    object pnlToolBar: TPanel
      Left = 0
      Top = 0
      Width = 909
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object btnNew: TORAlignButton
        Left = 816
        Top = 0
        Width = 93
        Height = 22
        Action = acActionNewTemplate
        Align = alRight
        TabOrder = 0
      end
      object tbMain: TToolBar
        Left = 0
        Top = 0
        Width = 111
        Height = 22
        Align = alLeft
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 37
        Caption = 'tbMain'
        Flat = False
        GradientStartColor = clSkyBlue
        HotTrackColor = clGray
        GradientDirection = gdHorizontal
        ShowCaptions = True
        TabOrder = 1
        Transparent = False
        object tbMnuEdit: TToolButton
          Left = 0
          Top = 0
          Action = acMnuEdit
          PopupMenu = popEdit
        end
        object tbMnuAction: TToolButton
          Left = 37
          Top = 0
          Action = acMnuAction
        end
        object tbMnuTools: TToolButton
          Left = 74
          Top = 0
          Action = acMnuTools
        end
      end
    end
  end
  object pnlCOM: TPanel [2]
    Left = 0
    Top = 345
    Width = 909
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object lblCOMParam: TLabel
      Left = 283
      Top = 0
      Width = 77
      Height = 21
      Align = alLeft
      Caption = '  Passed Value: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object lblCOMObj: TLabel
      Left = 0
      Top = 0
      Width = 67
      Height = 21
      Align = alLeft
      Caption = ' COM Object: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object edtCOMParam: TCaptionEdit
      Left = 360
      Top = 0
      Width = 549
      Height = 21
      Align = alClient
      TabOrder = 2
      OnChange = edtCOMParamChange
      Caption = 'Passed Value'
    end
    object cbxCOMObj: TORComboBox
      Left = 67
      Top = 0
      Width = 216
      Height = 21
      Style = orcsDropDown
      Align = alLeft
      AutoSelect = True
      Caption = 'COM Object'
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
      TabOrder = 0
      Text = ''
      OnChange = cbxCOMObjChange
      CharsNeedMatch = 1
    end
  end
  object pnlLink: TPanel [3]
    Left = 0
    Top = 303
    Width = 909
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object lblLink: TLabel
      Left = 0
      Top = 0
      Width = 138
      Height = 21
      Align = alLeft
      Caption = ' Associated Consult Service: '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object cbxLink: TORComboBox
      Left = 138
      Top = 0
      Width = 771
      Height = 21
      Style = orcsDropDown
      Align = alClient
      AutoSelect = True
      Caption = ' Associated Consult Service'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = False
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      HideSynonyms = True
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '30,5000'
      TabOrder = 0
      TabStop = True
      Text = ''
      OnChange = cbxLinkChange
      OnEnter = cbxLinkEnter
      OnExit = cbxLinkExit
      OnNeedData = cbxLinkNeedData
      CharsNeedMatch = 1
    end
  end
  object Panel1: TPanel [4]
    Left = 0
    Top = 366
    Width = 909
    Height = 246
    Align = alClient
    TabOrder = 3
    object pnlBoilerplate: TPanel
      Left = 1
      Top = 1
      Width = 907
      Height = 244
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnCanResize = pnlBoilerplateCanResize
      OnResize = pnlBoilerplateResize
      object splBoil: TSplitter
        Left = 0
        Top = 21
        Width = 907
        Height = 3
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Beveled = True
        Visible = False
        OnMoved = splBoilMoved
        ExplicitTop = 43
        ExplicitWidth = 740
      end
      object splNotes: TSplitter
        Left = 0
        Top = 198
        Width = 907
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        AutoSnap = False
        Beveled = True
        Visible = False
        OnMoved = splBoilMoved
        ExplicitTop = 132
        ExplicitWidth = 740
      end
      object reBoil: TRichEdit
        Left = 0
        Top = 24
        Width = 907
        Height = 128
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Constraints.MinHeight = 30
        ParentFont = False
        PlainText = True
        PopupMenu = popBoilerplatePlus
        ScrollBars = ssVertical
        TabOrder = 1
        WantTabs = True
        Zoom = 100
        OnChange = reBoilChange
        OnKeyDown = reBoilKeyDown
        OnKeyPress = reBoilKeyPress
        OnKeyUp = reBoilKeyUp
        OnResizeRequest = reResizeRequest
        OnSelectionChange = reBoilSelectionChange
      end
      object pnlGroupBP: TPanel
        Left = 0
        Top = 152
        Width = 907
        Height = 46
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 30
        TabOrder = 2
        Visible = False
        object lblGroupBP: TLabel
          Left = 0
          Top = 0
          Width = 907
          Height = 13
          Align = alTop
          Caption = 'Group Boilerplate'
          ExplicitWidth = 81
        end
        object lblGroupRow: TLabel
          Left = 264
          Top = 0
          Width = 23
          Height = 13
          Caption = 'Line:'
        end
        object lblGroupCol: TLabel
          Left = 336
          Top = 0
          Width = 38
          Height = 13
          Caption = 'Column:'
        end
        object reGroupBP: TRichEdit
          Left = 0
          Top = 16
          Width = 907
          Height = 30
          Align = alClient
          Color = clCream
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          Constraints.MinHeight = 27
          ParentFont = False
          PlainText = True
          PopupMenu = popGroupPlus
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 1
          WantReturns = False
          Zoom = 100
          OnSelectionChange = reGroupBPSelectionChange
        end
        object pnlGroupBPGap: TPanel
          Left = 0
          Top = 13
          Width = 907
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object pnlBP: TPanel
        Left = 0
        Top = 0
        Width = 907
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblBoilerplate: TLabel
          Left = 0
          Top = 1
          Width = 96
          Height = 13
          Caption = 'Template &Boilerplate'
          FocusControl = reBoil
        end
        object lblBoilRow: TLabel
          Left = 296
          Top = 2
          Width = 23
          Height = 13
          Caption = 'Line:'
        end
        object lblBoilCol: TLabel
          Left = 360
          Top = 2
          Width = 38
          Height = 13
          Caption = 'Column:'
          Color = clBtnFace
          ParentColor = False
        end
        object cbLongLines: TCheckBox
          Left = 153
          Top = 1
          Width = 137
          Height = 17
          Caption = 'Allow Lon&g Lines'
          TabOrder = 0
          OnClick = cbLongLinesClick
        end
      end
      object pnlNotes: TPanel
        Left = 0
        Top = 201
        Width = 907
        Height = 43
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 30
        TabOrder = 3
        Visible = False
        object lblNotes: TLabel
          Left = 0
          Top = 0
          Width = 907
          Height = 13
          Align = alTop
          Caption = 'Template Notes:'
          ExplicitWidth = 78
        end
        object reNotes: TRichEdit
          Left = 0
          Top = 13
          Width = 907
          Height = 30
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          Constraints.MinHeight = 27
          ParentFont = False
          PlainText = True
          PopupMenu = popNotesPlus
          ScrollBars = ssVertical
          TabOrder = 0
          WantTabs = True
          Zoom = 100
          OnChange = reNotesChange
          OnKeyDown = reBoilKeyDown
          OnKeyPress = reBoilKeyPress
          OnKeyUp = reBoilKeyUp
          OnResizeRequest = reResizeRequest
        end
      end
    end
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 612
    Width = 909
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      909
      27)
    object btnApply: TButton
      Left = 834
      Top = 4
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 753
      Top = 4
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 673
      Top = 4
      Width = 75
      Height = 22
      Anchors = [akTop, akRight]
      Caption = 'OK'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object cbEditShared: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 156
      Height = 21
      Align = alLeft
      Caption = 'E&dit Shared Templates'
      TabOrder = 3
      OnClick = cbEditSharedClick
    end
    object cbEditUser: TCheckBox
      AlignWithMargins = True
      Left = 165
      Top = 3
      Width = 155
      Height = 21
      Align = alLeft
      Caption = 'E&dit User'#39's Templates'
      TabOrder = 4
      Visible = False
      OnClick = cbEditSharedClick
    end
    object cbNotes: TCheckBox
      AlignWithMargins = True
      Left = 326
      Top = 3
      Width = 125
      Height = 21
      Hint = 
        'Keep notes about a template that can be seen from the templates ' +
        'drawer'
      Align = alLeft
      Caption = 'Sh&ow Template Notes'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = cbNotesClick
    end
  end
  object pnlComCare: TPanel [6]
    Left = 0
    Top = 324
    Width = 909
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object lblComCare: TLabel
      Left = 0
      Top = 0
      Width = 909
      Height = 21
      Align = alClient
      Caption = 'This template has been locked and may not be edited.'
      ExplicitWidth = 256
      ExplicitHeight = 13
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 208
    Top = 144
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlRightTop'
        'Status = stsDefault')
      (
        'Component = pnlCopyBtns'
        'Status = stsDefault')
      (
        'Component = sbCopyRight'
        'Status = stsDefault')
      (
        'Component = sbCopyLeft'
        'Status = stsDefault')
      (
        'Component = pnlPersonal'
        'Status = stsDefault')
      (
        'Component = tvPersonal'
        'Status = stsDefault')
      (
        'Component = pnlPersonalBottom'
        'Status = stsDefault')
      (
        'Component = sbPerUp'
        'Status = stsDefault')
      (
        'Component = sbPerDown'
        'Status = stsDefault')
      (
        'Component = sbPerDelete'
        'Status = stsDefault')
      (
        'Component = cbPerHide'
        'Status = stsDefault')
      (
        'Component = pnlPersonalGap'
        'Status = stsDefault')
      (
        'Component = pnlPerSearch'
        'Status = stsDefault')
      (
        'Component = btnPerFind'
        'Text = Find Personal Template'
        'Status = stsOK')
      (
        'Component = edtPerSearch'
        'Status = stsDefault')
      (
        'Component = cbPerMatchCase'
        'Status = stsDefault')
      (
        'Component = cbPerWholeWords'
        'Status = stsDefault')
      (
        'Component = pnlProperties'
        'Status = stsDefault')
      (
        'Component = gbProperties'
        'Status = stsDefault')
      (
        'Component = cbExclude'
        'Status = stsDefault')
      (
        'Component = cbActive'
        'Status = stsDefault')
      (
        'Component = edtGap'
        'Status = stsDefault')
      (
        'Component = udGap'
        'Status = stsDefault')
      (
        'Component = edtName'
        'Status = stsDefault')
      (
        'Component = gbDialogProps'
        'Status = stsDefault')
      (
        'Component = cbDisplayOnly'
        'Status = stsDefault')
      (
        'Component = cbOneItemOnly'
        'Status = stsDefault')
      (
        'Component = cbFirstLine'
        'Status = stsDefault')
      (
        'Component = cbHideDlgItems'
        'Status = stsDefault')
      (
        'Component = cbIndent'
        'Status = stsDefault')
      (
        'Component = cbHideItems'
        'Status = stsDefault')
      (
        'Component = cbxType'
        'Status = stsDefault')
      (
        'Component = cbxRemDlgs'
        'Status = stsDefault')
      (
        'Component = cbLock'
        'Status = stsDefault')
      (
        'Component = pnlShared'
        'Status = stsDefault')
      (
        'Component = tvShared'
        'Status = stsDefault')
      (
        'Component = pnlSharedBottom'
        'Status = stsDefault')
      (
        'Component = sbShUp'
        'Status = stsDefault')
      (
        'Component = sbShDown'
        'Status = stsDefault')
      (
        'Component = sbShDelete'
        'Status = stsDefault')
      (
        'Component = cbShHide'
        'Status = stsDefault')
      (
        'Component = pnlSharedGap'
        'Status = stsDefault')
      (
        'Component = pnlShSearch'
        'Status = stsDefault')
      (
        'Component = btnShFind'
        'Text = Find Shared Template'
        'Status = stsOK')
      (
        'Component = edtShSearch'
        'Status = stsDefault')
      (
        'Component = cbShMatchCase'
        'Status = stsDefault')
      (
        'Component = cbShWholeWords'
        'Status = stsDefault')
      (
        'Component = pnlToolBar'
        'Status = stsDefault')
      (
        'Component = btnNew'
        'Status = stsDefault')
      (
        'Component = pnlCOM'
        'Status = stsDefault')
      (
        'Component = edtCOMParam'
        'Label = lblCOMParam'
        'Status = stsOK')
      (
        'Component = cbxCOMObj'
        'Status = stsDefault')
      (
        'Component = pnlLink'
        'Status = stsDefault')
      (
        'Component = cbxLink'
        'Label = lblLink'
        'Status = stsOK')
      (
        'Component = frmTemplateEditor'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = pnlBoilerplate'
        'Status = stsDefault')
      (
        'Component = reBoil'
        'Status = stsDefault')
      (
        'Component = pnlGroupBP'
        'Status = stsDefault')
      (
        'Component = reGroupBP'
        'Status = stsDefault')
      (
        'Component = pnlGroupBPGap'
        'Status = stsDefault')
      (
        'Component = pnlBP'
        'Status = stsDefault')
      (
        'Component = cbLongLines'
        'Status = stsDefault')
      (
        'Component = pnlNotes'
        'Status = stsDefault')
      (
        'Component = reNotes'
        'Status = stsDefault')
      (
        'Component = pnlComCare'
        'Status = stsDefault')
      (
        'Component = tbMain'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = cbEditShared'
        'Status = stsDefault')
      (
        'Component = cbEditUser'
        'Status = stsDefault')
      (
        'Component = cbNotes'
        'Status = stsDefault'))
  end
  object tmrAutoScroll: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrAutoScrollTimer
    Left = 120
    Top = 96
  end
  object dlgImport: TOpenDialog
    DefaultExt = 'txml'
    Filter = 'Template Files|*.txml|XML Files|*.xml|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 16
    Top = 152
  end
  object dlgExport: TSaveDialog
    DefaultExt = 'txml'
    Filter = 'Template Files|*.txml|XML Files|*.xml|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 71
    Top = 152
  end
  object imgLblTemplates: TVA508ImageListLabeler
    Components = <
      item
        Component = tvPersonal
      end
      item
        Component = tvShared
      end>
    Labels = <>
    RemoteLabeler = dmodShared.imgLblHealthFactorLabels
    Left = 208
    Top = 96
  end
  object alMain: TActionList
    Left = 312
    Top = 96
    object acEditRedo: TAction
      Category = 'Standard'
      Caption = '&Redo'
      Enabled = False
      ShortCut = 16473
      OnExecute = acEditRedoExecute
    end
    object acMnuEdit: TAction
      Category = 'Main Menu'
      Caption = '&Edit'
      OnExecute = acMnuEditExecute
    end
    object acMnuAction: TAction
      Category = 'Main Menu'
      Caption = '&Action'
      OnExecute = acMnuActionExecute
    end
    object acMnuTools: TAction
      Category = 'Main Menu'
      Caption = '&Tools'
      OnExecute = acMnuToolsExecute
    end
    object acEditUndo: TAction
      Category = 'Standard'
      Caption = '&Undo'
      Enabled = False
      ShortCut = 16474
      OnExecute = acEditUndoExecute
    end
    object acEditCut: TAction
      Category = 'Standard'
      Caption = 'Cu&t'
      Enabled = False
      ShortCut = 16472
      OnExecute = acEditCutExecute
    end
    object acEditCopy: TAction
      Category = 'Standard'
      Caption = '&Copy'
      Enabled = False
      ShortCut = 16451
      OnExecute = acEditCopyExecute
    end
    object acEditPaste: TAction
      Category = 'Standard'
      Caption = '&Paste'
      Enabled = False
      ShortCut = 16470
      OnExecute = acEditPasteExecute
    end
    object acEditSelectAll: TAction
      Category = 'Standard'
      Caption = 'Select &All'
      Enabled = False
      ShortCut = 16449
      OnExecute = acEditSelectAllExecute
    end
    object acEditInsertObject: TAction
      Category = 'reBoil'
      Caption = '&Insert Patient Data (Object)'
      Enabled = False
      ShortCut = 16457
      OnExecute = acEditInsertObjectExecute
    end
    object acEditInsertField: TAction
      Category = 'reBoil'
      Caption = 'Insert Template &Field'
      Enabled = False
      ShortCut = 16454
      OnExecute = acEditInsertFieldExecute
    end
    object acEditCheck: TAction
      Category = 'reBoil & Group'
      Caption = 'Check for &Errors'
      Enabled = False
      ShortCut = 16453
      OnExecute = acEditCheckExecute
    end
    object acEditPreview: TAction
      Category = 'reBoil & Group'
      Caption = 'Preview/Print Template'
      Enabled = False
      ShortCut = 16468
      OnExecute = acEditPreviewExecute
    end
    object acEditGrammar: TAction
      Category = 'reBoil & Notes'
      Caption = 'Check &Grammar'
      Enabled = False
      ShortCut = 16455
      OnExecute = acEditGrammarExecute
    end
    object acEditSpelling: TAction
      Category = 'reBoil & Notes'
      Caption = 'Check &Spelling'
      Enabled = False
      ShortCut = 16467
      OnExecute = acEditSpellingExecute
    end
    object acActionNewTemplate: TAction
      Category = 'Actions'
      Caption = '&New Template'
      OnExecute = acActionNewTemplateExecute
    end
    object acActionTemplateGenerate: TAction
      Category = 'Actions'
      Caption = '&Generate Template'
      OnExecute = acActionTemplateGenerateExecute
    end
    object acActionTemplateCopy: TAction
      Category = 'Actions'
      Caption = '&Copy Template'
      OnExecute = acActionTemplateCopyExecute
    end
    object acActionTemplatePaste: TAction
      Category = 'Actions'
      Caption = '&Paste Template'
      OnExecute = acActionTemplatePasteExecute
    end
    object acActionTemplateDelete: TAction
      Category = 'Actions'
      Caption = '&Delete Template'
      OnExecute = acActionTemplateDeleteExecute
    end
    object acActionTemplateSort: TAction
      Category = 'Actions'
      Caption = 'Sort'
      OnExecute = acActionTemplateSortExecute
    end
    object acActionTemplateFindShared: TAction
      Category = 'Actions'
      Caption = 'FInd &Shared Templates'
      OnExecute = acActionTemplateFindSharedExecute
    end
    object acActionTemplateFindPersonal: TAction
      Category = 'Actions'
      Caption = '&Find Personal Templates'
      OnExecute = acActionTemplateFindPersonalExecute
    end
    object acActionTemplateCollapseShared: TAction
      Category = 'Actions'
      Caption = 'Collapse Shared Tree'
      OnExecute = acActionTemplateCollapseSharedExecute
    end
    object acActionTemplateCollapsePersonal: TAction
      Category = 'Actions'
      Caption = 'Collapse Personal Tree'
      OnExecute = acActionTemplateCollapsePersonalExecute
    end
    object acToolsEdit: TAction
      Category = 'Tools'
      Caption = 'Edit Template &Fields'
      OnExecute = acToolsEditExecute
    end
    object acToolsImport: TAction
      Category = 'Tools'
      Caption = '&Import Template'
      ShortCut = 16449
      OnExecute = acToolsImportExecute
    end
    object acToolsExport: TAction
      Category = 'Tools'
      Caption = '&Export Template'
      OnExecute = acToolsExportExecute
    end
    object acToolsRefresh: TAction
      Category = 'Tools'
      Caption = '&Refresh Templates'
      OnExecute = acToolsRefreshExecute
    end
    object acToolsIcon: TAction
      Category = 'Tools'
      Caption = 'Template &Icon Legend'
      OnExecute = acToolsIconExecute
    end
    object acToolsCheckSharedTemplates: TAction
      Category = 'Tools'
      Caption = 'Error Check All &Shared Templates'
      OnExecute = acToolsCheckSharedTemplatesExecute
    end
    object acToolsCheckAllTemplateFields: TAction
      Category = 'Tools'
      Caption = 'Error Check All &Template Fields'
      OnExecute = acToolsCheckAllTemplateFieldsExecute
    end
    object acNodeTemplateCollapse: TAction
      Caption = 'Collapse &Tree'
      OnExecute = acNodeTemplateCollapseExecute
    end
    object acNodeTemplateFind: TAction
      Caption = '&Find Template'
      OnExecute = acNodeTemplateFindExecute
    end
  end
  object popEdit: TPopupMenu
    Left = 360
    Top = 128
    object MenuItem1: TMenuItem
      Action = acEditUndo
    end
    object Redo2: TMenuItem
      Action = acEditRedo
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Action = acEditCut
    end
    object MenuItem5: TMenuItem
      Action = acEditCopy
    end
    object MenuItem7: TMenuItem
      Action = acEditPaste
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuItem10: TMenuItem
      Action = acEditSelectAll
    end
    object MenuItem9: TMenuItem
      Caption = '-'
    end
    object InsertPatientDataObject1: TMenuItem
      Action = acEditInsertObject
    end
    object InsertTemplateField1: TMenuItem
      Action = acEditInsertField
    end
    object CheckforErrors1: TMenuItem
      Action = acEditCheck
    end
    object PreviewPrintTemplate1: TMenuItem
      Action = acEditPreview
    end
    object MenuItem11: TMenuItem
      Caption = '-'
    end
    object MenuItem12: TMenuItem
      Action = acEditGrammar
    end
    object MenuItem13: TMenuItem
      Action = acEditSpelling
    end
  end
  object popAction: TPopupMenu
    Left = 416
    Top = 128
    object MenuItem14: TMenuItem
      Action = acActionNewTemplate
    end
    object MenuItem15: TMenuItem
      Action = acActionTemplateGenerate
    end
    object MenuItem16: TMenuItem
      Action = acActionTemplateCopy
    end
    object MenuItem17: TMenuItem
      Action = acActionTemplatePaste
    end
    object MenuItem18: TMenuItem
      Action = acActionTemplateDelete
    end
    object MenuItem19: TMenuItem
      Caption = '-'
    end
    object MenuItem20: TMenuItem
      Action = acActionTemplateSort
    end
    object MenuItem21: TMenuItem
      Caption = '-'
    end
    object MenuItem22: TMenuItem
      Action = acActionTemplateFindShared
    end
    object FindPersonalTemplates1: TMenuItem
      Action = acActionTemplateFindPersonal
    end
    object N18: TMenuItem
      Caption = '-'
    end
    object CollapseSharedTree1: TMenuItem
      Action = acActionTemplateCollapseShared
    end
    object CollapsePersonalTree1: TMenuItem
      Action = acActionTemplateCollapsePersonal
    end
  end
  object popTools: TPopupMenu
    Left = 472
    Top = 128
    object MenuItem23: TMenuItem
      Action = acToolsEdit
    end
    object MenuItem24: TMenuItem
      Caption = '-'
    end
    object MenuItem25: TMenuItem
      Action = acToolsImport
    end
    object ExportTemplate1: TMenuItem
      Action = acToolsExport
    end
    object N19: TMenuItem
      Caption = '-'
    end
    object RefreshTemplates1: TMenuItem
      Action = acToolsRefresh
    end
    object emplateIconLegend1: TMenuItem
      Action = acToolsIcon
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object ErrorCheckAllSharedTemplates1: TMenuItem
      Action = acToolsCheckSharedTemplates
    end
    object ErrorCheckAllTemplateFields1: TMenuItem
      Action = acToolsCheckAllTemplateFields
    end
  end
  object popTemplatesPlus: TPopupMenu
    OnPopup = popTemplatesPlusPopup
    Left = 184
    Top = 218
    object NewTemplate2: TMenuItem
      Action = acActionNewTemplate
    end
    object GenerateTemplate1: TMenuItem
      Action = acActionTemplateGenerate
    end
    object CopyTemplate1: TMenuItem
      Action = acActionTemplateCopy
    end
    object PasteTemplate1: TMenuItem
      Action = acActionTemplatePaste
    end
    object DeleteTemplate1: TMenuItem
      Action = acActionTemplateDelete
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object Sort1: TMenuItem
      Action = acActionTemplateSort
    end
    object N22: TMenuItem
      Caption = '-'
    end
    object FindTemplate1: TMenuItem
      Action = acNodeTemplateFind
    end
    object acNodeTemplateCollapse1: TMenuItem
      Action = acNodeTemplateCollapse
    end
  end
  object popNotesPlus: TPopupMenu
    OnPopup = popNotesPlusPopup
    Left = 162
    Top = 429
    object MenuItem26: TMenuItem
      Action = acEditUndo
    end
    object Redo3: TMenuItem
      Action = acEditRedo
    end
    object MenuItem27: TMenuItem
      Caption = '-'
    end
    object MenuItem28: TMenuItem
      Action = acEditCut
    end
    object MenuItem29: TMenuItem
      Action = acEditCopy
    end
    object MenuItem30: TMenuItem
      Action = acEditPaste
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuItem32: TMenuItem
      Action = acEditSelectAll
    end
    object MenuItem33: TMenuItem
      Caption = '-'
    end
    object MenuItem34: TMenuItem
      Action = acEditGrammar
    end
    object MenuItem35: TMenuItem
      Action = acEditSpelling
    end
  end
  object popGroupPlus: TPopupMenu
    OnPopup = popGroupPlusPopup
    Left = 104
    Top = 413
    object MenuItem36: TMenuItem
      Action = acEditCopy
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MenuItem38: TMenuItem
      Action = acEditSelectAll
    end
    object MenuItem37: TMenuItem
      Caption = '-'
    end
    object CheckforErrors2: TMenuItem
      Action = acEditCheck
    end
    object PreviewPrintTemplate2: TMenuItem
      Action = acEditPreview
    end
  end
  object popBoilerplatePlus: TPopupMenu
    OnPopup = popBoilerplatePlusPopup
    Left = 40
    Top = 396
    object MenuItem39: TMenuItem
      Action = acEditUndo
    end
    object Redo1: TMenuItem
      Action = acEditRedo
    end
    object MenuItem40: TMenuItem
      Caption = '-'
    end
    object MenuItem41: TMenuItem
      Action = acEditCut
    end
    object MenuItem42: TMenuItem
      Action = acEditCopy
    end
    object MenuItem43: TMenuItem
      Action = acEditPaste
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItem44: TMenuItem
      Action = acEditSelectAll
    end
    object MenuItem45: TMenuItem
      Caption = '-'
    end
    object MenuItem46: TMenuItem
      Action = acEditInsertObject
    end
    object MenuItem47: TMenuItem
      Action = acEditInsertField
    end
    object MenuItem48: TMenuItem
      Action = acEditCheck
    end
    object MenuItem49: TMenuItem
      Action = acEditPreview
    end
    object MenuItem50: TMenuItem
      Caption = '-'
    end
    object MenuItem51: TMenuItem
      Action = acEditGrammar
    end
    object MenuItem52: TMenuItem
      Action = acEditSpelling
    end
  end
end
