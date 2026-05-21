inherited frmTemplateEditor: TfrmTemplateEditor
  Left = 321
  Top = 119
  HelpContext = 10000
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Template Editor'
  ClientHeight = 761
  ClientWidth = 1008
  Constraints.MinHeight = 800
  Constraints.MinWidth = 1024
  Position = poScreenCenter
  Scaled = False
  StyleElements = [seFont, seClient, seBorder]
  OnCloseQuery = FormCloseQuery
  ExplicitLeft = -251
  ExplicitWidth = 1024
  ExplicitHeight = 800
  TextHeight = 13
  object splMain: TSplitter [0]
    Left = 0
    Top = 300
    Width = 1008
    Height = 3
    Cursor = crVSplit
    Align = alTop
    AutoSnap = False
    Beveled = True
    MinSize = 40
    OnCanResize = splMainCanResize
    ExplicitTop = 239
    ExplicitWidth = 740
  end
  object pnlTop: TPanel [1]
    Left = 0
    Top = 0
    Width = 1008
    Height = 300
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 223
    TabOrder = 0
    ExplicitWidth = 951
    object grdTop: TGridPanel
      Left = 0
      Top = 0
      Width = 1008
      Height = 300
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 60.000000000000000000
        end
        item
          Value = 39.999999999999990000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = pnlToolBar
          Row = 0
        end
        item
          Column = 1
          Control = pnlToolbarRight
          Row = 0
        end
        item
          Column = 0
          Control = grdTopLeft
          Row = 1
        end
        item
          Column = 1
          Control = pnlProperties
          Row = 1
        end>
      RowCollection = <
        item
          Value = 10.000000000000000000
        end
        item
          Value = 90.000000000000000000
        end>
      TabOrder = 0
      ExplicitWidth = 951
      object pnlToolBar: TPanel
        Left = 0
        Top = 0
        Width = 605
        Height = 30
        Align = alClient
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 571
        object tbMain: TToolBar
          Left = 0
          Top = 0
          Width = 111
          Height = 28
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
          TabOrder = 0
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
      object pnlToolbarRight: TPanel
        Left = 605
        Top = 0
        Width = 403
        Height = 30
        Align = alClient
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 571
        ExplicitWidth = 380
        object btnNew: TORAlignButton
          AlignWithMargins = True
          Left = 307
          Top = 3
          Width = 93
          Height = 22
          Action = acActionNewTemplate
          Align = alRight
          TabOrder = 0
          ExplicitLeft = 284
        end
      end
      object grdTopLeft: TGridPanel
        Left = 0
        Top = 30
        Width = 605
        Height = 270
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 45.884547529499680000
          end
          item
            Value = 8.194817133962880000
          end
          item
            Value = 45.920635336537440000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlSharedtop
            Row = 0
          end
          item
            Column = 1
            Control = pnlGap1
            Row = 0
          end
          item
            Column = 2
            Control = pnlPersonalTop
            Row = 0
          end
          item
            Column = 0
            Control = pnlSharedMiddle
            Row = 1
          end
          item
            Column = 1
            Control = pnlCopyBtns
            Row = 1
          end
          item
            Column = 2
            Control = pnlPerSearchMain
            Row = 1
          end
          item
            Column = 0
            Control = pnlSharedBottom
            Row = 2
          end
          item
            Column = 1
            Control = pnlGap2
            Row = 2
          end
          item
            Column = 2
            Control = pnlPersonalBottom
            Row = 2
          end>
        RowCollection = <
          item
            Value = 17.650688646467430000
          end
          item
            Value = 71.391075265711590000
          end
          item
            Value = 10.958236087820980000
          end>
        TabOrder = 2
        ExplicitWidth = 571
        object pnlSharedtop: TPanel
          Left = 0
          Top = 0
          Width = 278
          Height = 48
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 262
          object lblShared: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 272
            Height = 13
            Align = alTop
            Caption = '&Shared Templates'
            FocusControl = tvShared
            ExplicitWidth = 86
          end
          object pnlMiddleTopSearch: TPanel
            Left = 0
            Top = 19
            Width = 278
            Height = 29
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitLeft = -6
            ExplicitTop = 41
            ExplicitWidth = 262
            object btnShFind: TORAlignButton
              AlignWithMargins = True
              Left = 220
              Top = 3
              Width = 55
              Height = 23
              Hint = 'Find Template'
              Align = alRight
              Caption = 'Find'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnFindClick
              ExplicitLeft = 204
            end
            object edtShSearch: TCaptionEdit
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 211
              Height = 23
              Align = alClient
              TabOrder = 0
              OnChange = edtSearchChange
              OnEnter = edtShSearchEnter
              OnExit = edtShSearchExit
              Caption = 'Shared Templates'
              ExplicitWidth = 195
              ExplicitHeight = 21
            end
          end
        end
        object pnlGap1: TPanel
          Left = 278
          Top = 0
          Width = 49
          Height = 48
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 3
          ExplicitLeft = 262
          ExplicitWidth = 47
        end
        object pnlPersonalTop: TPanel
          Left = 327
          Top = 0
          Width = 278
          Height = 48
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 5
          ExplicitLeft = 309
          ExplicitWidth = 262
          object lblPersonal: TLabel
            Tag = 1
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 272
            Height = 13
            Align = alTop
            Caption = '&Personal Templates'
            FocusControl = tvPersonal
            ExplicitWidth = 93
          end
          object pnlPersonalTopSearch: TPanel
            Left = 0
            Top = 19
            Width = 278
            Height = 29
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 262
            object btnPerFind: TORAlignButton
              Tag = 1
              AlignWithMargins = True
              Left = 220
              Top = 3
              Width = 55
              Height = 23
              Hint = 'Find Template'
              Align = alRight
              Caption = 'Find'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = btnFindClick
              ExplicitLeft = 204
            end
            object edtPerSearch: TCaptionEdit
              Tag = 1
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 211
              Height = 23
              Align = alClient
              TabOrder = 0
              OnChange = edtSearchChange
              OnEnter = edtPerSearchEnter
              OnExit = edtPerSearchExit
              Caption = #45924#31759
              ExplicitWidth = 195
              ExplicitHeight = 21
            end
          end
        end
        object pnlSharedMiddle: TPanel
          Left = 0
          Top = 48
          Width = 278
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 262
          object pnlShSearch: TPanel
            Left = 0
            Top = 0
            Width = 278
            Height = 25
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 262
            object cbShMatchCase: TCheckBox
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 99
              Height = 19
              Align = alLeft
              Caption = 'Match Case'
              TabOrder = 1
              OnClick = cbShFindOptionClick
            end
            object cbShWholeWords: TCheckBox
              AlignWithMargins = True
              Left = 108
              Top = 3
              Width = 167
              Height = 19
              Align = alClient
              Caption = 'Whole Words Only'
              TabOrder = 0
              OnClick = cbShFindOptionClick
              ExplicitWidth = 151
            end
          end
          object tvShared: TORTreeView
            AlignWithMargins = True
            Left = 3
            Top = 28
            Width = 272
            Height = 161
            Align = alClient
            DragMode = dmAutomatic
            Images = dmodShared.imgTemplates
            Indent = 19
            PopupMenu = popTemplatesPlus
            RightClickSelect = True
            TabOrder = 1
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
            ExplicitWidth = 256
          end
        end
        object pnlCopyBtns: TPanel
          Left = 278
          Top = 48
          Width = 49
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 4
          ExplicitLeft = 262
          ExplicitWidth = 47
          object lblCopy: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 70
            Width = 43
            Height = 19
            Margins.Top = 70
            Align = alTop
            Alignment = taCenter
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
            ExplicitLeft = -9
            ExplicitTop = 76
            ExplicitWidth = 31
          end
          object sbCopyLeft: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 3
            Top = 95
            Width = 43
            Height = 23
            Hint = 'Copy Personal Template into Shared Template List'
            Align = alTop
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
            ExplicitWidth = 41
          end
          object sbCopyRight: TBitBtn
            AlignWithMargins = True
            Left = 3
            Top = 124
            Width = 43
            Height = 23
            Hint = 'Copy Shared Template into Personal Template List'
            Align = alTop
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
            ExplicitWidth = 41
          end
        end
        object pnlPerSearchMain: TPanel
          Left = 327
          Top = 48
          Width = 278
          Height = 192
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 6
          ExplicitLeft = 309
          ExplicitWidth = 262
          object tvPersonal: TORTreeView
            Tag = 1
            AlignWithMargins = True
            Left = 3
            Top = 28
            Width = 272
            Height = 161
            Align = alClient
            DragMode = dmAutomatic
            Images = dmodShared.imgTemplates
            Indent = 19
            PopupMenu = popTemplatesPlus
            RightClickSelect = True
            TabOrder = 0
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
            ExplicitWidth = 256
          end
          object pnlPerSearch: TPanel
            Left = 0
            Top = 0
            Width = 278
            Height = 25
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitWidth = 262
            object cbPerMatchCase: TCheckBox
              Tag = 1
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 99
              Height = 19
              Align = alLeft
              Caption = 'Match Case'
              TabOrder = 0
              OnClick = cbPerFindOptionClick
            end
            object cbPerWholeWords: TCheckBox
              Tag = 1
              AlignWithMargins = True
              Left = 108
              Top = 3
              Width = 167
              Height = 19
              Align = alClient
              Caption = 'Whole Words Only'
              TabOrder = 1
              OnClick = cbPerFindOptionClick
              ExplicitWidth = 151
            end
          end
        end
        object pnlSharedBottom: TPanel
          Left = 0
          Top = 240
          Width = 278
          Height = 30
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitWidth = 262
          object cbShHide: TCheckBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 153
            Height = 24
            Hint = 'Hide Inactive Shared Templates'
            Align = alClient
            Caption = '&Hide Inactive'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbShHideClick
            ExplicitWidth = 137
          end
          object sbShDelete: TBitBtn
            AlignWithMargins = True
            Left = 209
            Top = 2
            Width = 67
            Height = 26
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
            TabOrder = 3
            OnClick = sbDeleteClick
            ExplicitLeft = 193
          end
          object sbShDown: TBitBtn
            AlignWithMargins = True
            Left = 159
            Top = 2
            Width = 22
            Height = 26
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
            ExplicitLeft = 143
          end
          object sbShUp: TBitBtn
            AlignWithMargins = True
            Left = 183
            Top = 2
            Width = 22
            Height = 26
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
            TabOrder = 2
            OnClick = sbMoveUpClick
            ExplicitLeft = 167
          end
        end
        object pnlGap2: TPanel
          Left = 278
          Top = 240
          Width = 49
          Height = 30
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 8
          ExplicitLeft = 262
          ExplicitWidth = 47
        end
        object pnlPersonalBottom: TPanel
          Left = 327
          Top = 240
          Width = 278
          Height = 30
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 7
          ExplicitLeft = 309
          ExplicitWidth = 262
          object cbPerHide: TCheckBox
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 161
            Height = 24
            Hint = 'Hide Inactive Personal Templates'
            Align = alClient
            Caption = 'Hide &Inactive'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = cbPerHideClick
            ExplicitWidth = 145
          end
          object sbPerDelete: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 215
            Top = 2
            Width = 61
            Height = 26
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
            TabOrder = 3
            OnClick = sbDeleteClick
            ExplicitLeft = 199
          end
          object sbPerDown: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 169
            Top = 2
            Width = 21
            Height = 26
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
            ExplicitLeft = 153
          end
          object sbPerUp: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 192
            Top = 2
            Width = 21
            Height = 26
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
            TabOrder = 2
            OnClick = sbMoveUpClick
            ExplicitLeft = 176
          end
        end
      end
      object pnlProperties: TPanel
        Left = 605
        Top = 30
        Width = 403
        Height = 270
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        OnResize = pnlPropertiesResize
        ExplicitLeft = 571
        ExplicitWidth = 380
        object gbProperties: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 397
          Height = 264
          Align = alClient
          Caption = 'Template Properties'
          Constraints.MinWidth = 100
          TabOrder = 0
          ExplicitWidth = 374
          object GridPanel3: TGridPanel
            Left = 2
            Top = 15
            Width = 393
            Height = 222
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 39.846005774783440000
              end
              item
                Value = 60.153994225216560000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = lblName
                Row = 0
              end
              item
                Column = 1
                Control = edtName
                Row = 0
              end
              item
                Column = 0
                Control = lblType
                Row = 1
              end
              item
                Column = 1
                Control = cbxType
                Row = 1
              end
              item
                Column = 0
                Control = lblRemDlg
                Row = 2
              end
              item
                Column = 1
                Control = cbxRemDlgs
                Row = 2
              end
              item
                Column = 0
                Control = Panel4
                Row = 3
              end
              item
                Column = 1
                Control = gbDialogProps
                Row = 3
              end>
            RowCollection = <
              item
                Value = 13.683031065307800000
              end
              item
                Value = 13.683031065307800000
              end
              item
                Value = 13.683031065307800000
              end
              item
                Value = 58.950906804076600000
              end>
            TabOrder = 0
            ExplicitWidth = 370
            object lblName: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 8
              Width = 151
              Height = 13
              Margins.Top = 8
              Align = alTop
              Anchors = []
              Caption = 'Na&me:'
              FocusControl = edtName
              ExplicitWidth = 31
            end
            object edtName: TCaptionEdit
              AlignWithMargins = True
              Left = 160
              Top = 3
              Width = 230
              Height = 21
              Align = alTop
              Anchors = []
              MaxLength = 60
              TabOrder = 0
              OnChange = edtNameOldChange
              OnExit = edtNameExit
              Caption = 'Name'
              ExplicitLeft = 126
              ExplicitWidth = 241
            end
            object lblType: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 38
              Width = 151
              Height = 13
              Margins.Top = 8
              Align = alTop
              Anchors = []
              Caption = 'Template T&ype:'
              FocusControl = cbxType
              ExplicitWidth = 74
            end
            object cbxType: TCaptionComboBox
              AlignWithMargins = True
              Left = 160
              Top = 33
              Width = 230
              Height = 24
              Align = alTop
              Style = csOwnerDrawFixed
              Anchors = []
              ItemHeight = 18
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = cbxTypeChange
              OnDrawItem = cbxTypeDrawItem
              Caption = 'Template Type'
              ExplicitLeft = 126
              ExplicitWidth = 241
            end
            object lblRemDlg: TLabel
              AlignWithMargins = True
              Left = 3
              Top = 69
              Width = 151
              Height = 13
              Margins.Top = 8
              Align = alTop
              Anchors = []
              Caption = 'Reminder &Dialog:'
              FocusControl = cbxRemDlgs
              ExplicitWidth = 81
            end
            object cbxRemDlgs: TORComboBox
              AlignWithMargins = True
              Left = 160
              Top = 64
              Width = 230
              Height = 21
              Style = orcsDropDown
              Align = alTop
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
              FlatCheckBoxes = False
              OnChange = cbxRemDlgsChange
              CharsNeedMatch = 1
              ExplicitLeft = 126
              ExplicitWidth = 241
            end
            object Panel4: TPanel
              Left = 0
              Top = 91
              Width = 157
              Height = 131
              Align = alClient
              Anchors = []
              BevelOuter = bvNone
              TabOrder = 3
              ExplicitWidth = 123
              object cbActive: TCheckBox
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 151
                Height = 17
                Hint = 'Makes a template or folder active or inactive.'
                Align = alTop
                Caption = 'A&ctive'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 0
                OnClick = cbActiveClick
                ExplicitWidth = 117
              end
              object cbExclude: TORCheckBox
                AlignWithMargins = True
                Left = 3
                Top = 61
                Width = 151
                Height = 29
                Hint = 
                  'Removes this template'#39's boilerplate from the group'#39's boilerplate' +
                  '.'
                Align = alTop
                Caption = 'Hide Items in Templates Dra&wer'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 2
                WordWrap = True
                OnClick = cbExcludeClick
                AutoSize = True
                ExplicitWidth = 117
              end
              object cbHideItems: TORCheckBox
                AlignWithMargins = True
                Left = 3
                Top = 26
                Width = 151
                Height = 29
                Hint = 'Hide child items from template drawer view'
                Align = alTop
                Caption = 'E&xclude from Group Boilerplate'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                WordWrap = True
                OnClick = cbHideItemsClick
                AutoSize = True
                ExplicitWidth = 117
              end
              object cbLock: TORCheckBox
                AlignWithMargins = True
                Left = 3
                Top = 96
                Width = 151
                Height = 16
                Align = alTop
                Caption = 'Lock'
                TabOrder = 3
                OnClick = cbLockClick
                AutoSize = True
                ExplicitWidth = 117
              end
            end
            object gbDialogProps: TGroupBox
              AlignWithMargins = True
              Left = 160
              Top = 94
              Width = 230
              Height = 125
              Align = alClient
              Anchors = []
              Caption = 'Dialog Properties'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              ExplicitLeft = 126
              ExplicitWidth = 241
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
          end
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 240
            Width = 387
            Height = 19
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitWidth = 364
            object lblLines: TLabel
              AlignWithMargins = True
              Left = 50
              Top = 3
              Width = 334
              Height = 13
              Hint = 
                'Indicates the number of blank lines to insert, in the group boil' +
                'erplate, between each item'#39's boilerplate.'
              Margins.Left = 30
              Align = alClient
              Caption = 'Number of Blank &Lines to insert between items'
              FocusControl = edtGap
              ParentShowHint = False
              ShowHint = True
              WordWrap = True
              ExplicitWidth = 218
            end
            object edtGap: TCaptionEdit
              Left = 0
              Top = 0
              Width = 20
              Height = 19
              Hint = 
                'Indicates the number of blank lines to insert, in the group boil' +
                'erplate, between each item'#39's boilerplate.'
              Align = alLeft
              MaxLength = 1
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Text = '0'
              OnChange = edtGapChange
              OnKeyPress = edtGapKeyPress
              Caption = 'Number of Blank Lines to insert between items'
            end
            object udGap: TUpDown
              Left = 20
              Top = 0
              Width = 15
              Height = 19
              Hint = 
                'Indicates the number of blank lines to insert, in the group boil' +
                'erplate, between each item'#39's boilerplate.'
              Associate = edtGap
              Max = 3
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object pnlCOM: TPanel [2]
    Left = 0
    Top = 345
    Width = 1008
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    ExplicitWidth = 951
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
      Width = 648
      Height = 21
      Align = alClient
      BevelInner = bvNone
      TabOrder = 2
      OnChange = edtCOMParamChange
      Caption = 'Passed Value'
      ExplicitWidth = 591
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
      FlatCheckBoxes = False
      OnChange = cbxCOMObjChange
      CharsNeedMatch = 1
    end
  end
  object pnlLink: TPanel [3]
    Left = 0
    Top = 303
    Width = 1008
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    ExplicitWidth = 951
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
      Width = 870
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
      FlatCheckBoxes = False
      OnChange = cbxLinkChange
      OnEnter = cbxLinkEnter
      OnExit = cbxLinkExit
      OnNeedData = cbxLinkNeedData
      CharsNeedMatch = 1
      ExplicitWidth = 813
    end
  end
  object Panel1: TPanel [4]
    Left = 0
    Top = 366
    Width = 1008
    Height = 368
    Align = alClient
    TabOrder = 3
    ExplicitWidth = 951
    ExplicitHeight = 246
    object pnlBoilerplate: TPanel
      Left = 1
      Top = 1
      Width = 1006
      Height = 366
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      OnCanResize = pnlBoilerplateCanResize
      OnResize = pnlBoilerplateResize
      ExplicitWidth = 949
      ExplicitHeight = 244
      object splBoil: TSplitter
        Left = 0
        Top = 21
        Width = 1006
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
        Top = 320
        Width = 1006
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
        Width = 1006
        Height = 250
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
        OnChange = reBoilChange
        OnKeyDown = reBoilKeyDown
        OnKeyPress = reBoilKeyPress
        OnKeyUp = reBoilKeyUp
        OnResizeRequest = reResizeRequest
        OnSelectionChange = reBoilSelectionChange
        ExplicitWidth = 949
        ExplicitHeight = 128
      end
      object pnlGroupBP: TPanel
        Left = 0
        Top = 274
        Width = 1006
        Height = 46
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 30
        TabOrder = 2
        Visible = False
        ExplicitTop = 152
        ExplicitWidth = 949
        object lblGroupBP: TLabel
          Left = 0
          Top = 0
          Width = 1006
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
          Width = 1006
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
          OnSelectionChange = reGroupBPSelectionChange
          ExplicitWidth = 949
        end
        object pnlGroupBPGap: TPanel
          Left = 0
          Top = 13
          Width = 1006
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 949
        end
      end
      object pnlBP: TPanel
        Left = 0
        Top = 0
        Width = 1006
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 949
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
        Top = 323
        Width = 1006
        Height = 43
        Align = alBottom
        BevelOuter = bvNone
        Constraints.MinHeight = 30
        TabOrder = 3
        Visible = False
        ExplicitTop = 201
        ExplicitWidth = 949
        object lblNotes: TLabel
          Left = 0
          Top = 0
          Width = 1006
          Height = 13
          Align = alTop
          Caption = 'Template Notes:'
          ExplicitWidth = 78
        end
        object reNotes: TRichEdit
          Left = 0
          Top = 13
          Width = 1006
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
          OnChange = reNotesChange
          OnKeyDown = reBoilKeyDown
          OnKeyPress = reBoilKeyPress
          OnKeyUp = reBoilKeyUp
          OnResizeRequest = reResizeRequest
          ExplicitWidth = 949
        end
      end
    end
  end
  object pnlBottom: TPanel [5]
    Left = 0
    Top = 734
    Width = 1008
    Height = 27
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitTop = 612
    ExplicitWidth = 951
    object btnApply: TButton
      AlignWithMargins = True
      Left = 930
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'Apply'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = btnApplyClick
      ExplicitLeft = 873
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 849
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 792
    end
    object btnOK: TButton
      AlignWithMargins = True
      Left = 768
      Top = 3
      Width = 75
      Height = 21
      Align = alRight
      Caption = 'OK'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = btnOKClick
      ExplicitLeft = 711
    end
    object cbEditShared: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 135
      Height = 21
      Align = alLeft
      Caption = 'E&dit Shared Templates'
      TabOrder = 3
      OnClick = cbEditSharedClick
    end
    object cbEditUser: TCheckBox
      AlignWithMargins = True
      Left = 144
      Top = 3
      Width = 133
      Height = 21
      Align = alLeft
      Caption = 'E&dit User'#39's Templates'
      TabOrder = 4
      Visible = False
      OnClick = cbEditSharedClick
    end
    object cbNotes: TCheckBox
      AlignWithMargins = True
      Left = 283
      Top = 3
      Width = 126
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
    Width = 1008
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    ExplicitWidth = 951
    object lblComCare: TLabel
      Left = 0
      Top = 0
      Width = 1008
      Height = 21
      Align = alClient
      Caption = 'This template has been locked and may not be edited.'
      ExplicitWidth = 256
      ExplicitHeight = 13
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 472
    Top = 424
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
        'Component = tvPersonal'
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
        'Component = tvShared'
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
        'Component = cbEditShared'
        'Status = stsDefault')
      (
        'Component = cbEditUser'
        'Status = stsDefault')
      (
        'Component = cbNotes'
        'Status = stsDefault')
      (
        'Component = grdTop'
        'Status = stsDefault')
      (
        'Component = pnlToolbarRight'
        'Status = stsDefault')
      (
        'Component = grdTopLeft'
        'Status = stsDefault')
      (
        'Component = pnlSharedtop'
        'Status = stsDefault')
      (
        'Component = pnlGap1'
        'Status = stsDefault')
      (
        'Component = pnlPersonalTop'
        'Status = stsDefault')
      (
        'Component = pnlSharedMiddle'
        'Status = stsDefault')
      (
        'Component = pnlCopyBtns'
        'Status = stsDefault')
      (
        'Component = pnlPerSearchMain'
        'Status = stsDefault')
      (
        'Component = pnlSharedBottom'
        'Status = stsDefault')
      (
        'Component = pnlGap2'
        'Status = stsDefault')
      (
        'Component = pnlPersonalBottom'
        'Status = stsDefault')
      (
        'Component = sbCopyLeft'
        'Status = stsDefault')
      (
        'Component = sbCopyRight'
        'Status = stsDefault')
      (
        'Component = pnlPersonalTopSearch'
        'Status = stsDefault')
      (
        'Component = pnlMiddleTopSearch'
        'Status = stsDefault')
      (
        'Component = pnlPerSearch'
        'Status = stsDefault')
      (
        'Component = GridPanel3'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault'))
  end
  object tmrAutoScroll: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tmrAutoScrollTimer
    Left = 40
    Top = 200
  end
  object dlgImport: TOpenDialog
    DefaultExt = 'txml'
    Filter = 'Template Files|*.txml|XML Files|*.xml|All Files|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 40
    Top = 128
  end
  object dlgExport: TSaveDialog
    DefaultExt = 'txml'
    Filter = 'Template Files|*.txml|XML Files|*.xml|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 143
    Top = 128
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
    Left = 560
    Top = 424
  end
  object alMain: TActionList
    Left = 416
    Top = 192
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
    Left = 144
    Top = 201
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
    Left = 282
    Top = 421
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
    Left = 176
    Top = 421
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
    Left = 56
    Top = 420
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
