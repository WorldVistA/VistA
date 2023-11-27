inherited frmRemCoverSheet: TfrmRemCoverSheet
  Left = 313
  Top = 150
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 
    'Clinical Reminders and Reminder Categories Displayed on Cover Sh' +
    'eet'
  ClientHeight = 616
  ClientWidth = 774
  Constraints.MinWidth = 462
  Position = poScreenCenter
  ExplicitWidth = 780
  ExplicitHeight = 645
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TORAutoPanel [0]
    Left = 0
    Top = 329
    Width = 774
    Height = 252
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      774
      252)
    object lblSeq: TLabel
      Left = 688
      Top = 100
      Width = 52
      Height = 26
      Anchors = [akLeft, akBottom]
      Caption = 'Sequence Number'
      WordWrap = True
    end
    object lblEdit: TLabel
      Left = 0
      Top = 0
      Width = 774
      Height = 13
      Align = alTop
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 5
    end
    object sbUp: TBitBtn
      Left = 671
      Top = 40
      Width = 42
      Height = 21
      Hint = 'Move Reminder Up List'
      Anchors = [akLeft, akBottom]
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
      TabOrder = 1
      OnClick = sbUpClick
    end
    object sbDown: TBitBtn
      Left = 671
      Top = 67
      Width = 42
      Height = 21
      Hint = 'Move Reminder Down List'
      Anchors = [akLeft, akBottom]
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
      TabOrder = 2
      OnClick = sbDownClick
    end
    object btnAdd: TBitBtn
      Left = 671
      Top = 165
      Width = 99
      Height = 26
      Hint = 
        'Adds a Reminder to the Coversheet at the selected level.  It wil' +
        'l also remove the lock of a Reminder (leaves Reminder on Coversh' +
        'eet) set at the same level as currently selected.'
      Anchors = [akLeft, akBottom]
      Caption = 'Add'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333003333333333333300333
        3333333333300333333333333330033333333330000000000333333000000000
        0333333333300333333333333330033333333333333003333333333333300333
        3333333333333333333333333333333333333333333333333333}
      Margin = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnAddClick
    end
    object btnRemove: TBitBtn
      Left = 671
      Top = 194
      Width = 99
      Height = 26
      Hint = 
        'Removes Reminders from the Coversheet display.  Will not remove ' +
        'Reminders which are locked at a higher level.'
      Anchors = [akLeft, akBottom]
      Caption = 'Remove'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333330000000000333333000000000
        0333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      Margin = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnRemoveClick
    end
    object btnLock: TBitBtn
      Left = 671
      Top = 223
      Width = 99
      Height = 26
      Hint = 
        'Adds Reminder to the Coversheet display.  It also Locks the Remi' +
        'nder so it can not be removed from the Coversheet display at a l' +
        'ower level.  For example, if a Reminder is locked at the User Cl' +
        'ass level, then it can not be removed from the Coversheet at the' +
        ' User level.'
      Anchors = [akLeft, akBottom]
      Caption = 'Add && Lock'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000003
        333333333F777773FF333333008888800333333377333F3773F3333077870787
        7033333733337F33373F3308888707888803337F33337F33337F330777880887
        7703337F33337FF3337F3308888000888803337F333777F3337F330777700077
        7703337F33377733337F33088888888888033373FFFFFFFFFF73333000000000
        00333337777777777733333308033308033333337F7F337F7F33333308033308
        033333337F7F337F7F33333308033308033333337F73FF737F33333377800087
        7333333373F77733733333333088888033333333373FFFF73333333333000003
        3333333333777773333333333333333333333333333333333333}
      Margin = 2
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = btnLockClick
    end
    object edtSeq: TCaptionEdit
      Left = 694
      Top = 134
      Width = 38
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      Text = '1'
      OnChange = edtSeqChange
      OnKeyPress = edtSeqKeyPress
      Caption = 'Sequence Number'
    end
    object udSeq: TUpDown
      Left = 732
      Top = 134
      Width = 15
      Height = 21
      Anchors = [akLeft, akBottom]
      Associate = edtSeq
      Max = 999
      Position = 1
      TabOrder = 4
      OnChangingEx = udSeqChangingEx
    end
    object pnlInfo: TPanel
      Left = 0
      Top = 13
      Width = 665
      Height = 239
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object splMain: TSplitter
        Left = 332
        Top = 0
        Height = 239
        Beveled = True
        ExplicitLeft = 245
        ExplicitHeight = 165
      end
      object pnlTree: TPanel
        Left = 0
        Top = 0
        Width = 332
        Height = 239
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object lblTree: TLabel
          Left = 0
          Top = 0
          Width = 332
          Height = 13
          Align = alTop
          Caption = '  Available Reminders && Categories'
          ExplicitWidth = 164
        end
        object tvAll: TORTreeView
          Left = 0
          Top = 13
          Width = 332
          Height = 226
          Align = alClient
          HideSelection = False
          Images = imgMain
          Indent = 19
          ReadOnly = True
          RightClickSelect = True
          RowSelect = True
          TabOrder = 0
          OnChange = tvAllChange
          OnCollapsed = tvAllExpanded
          OnDblClick = tvAllDblClick
          OnExpanding = tvAllExpanding
          OnExpanded = tvAllExpanded
          Caption = '  Available Reminders and Categories'
          NodePiece = 2
        end
      end
      object pnlCover: TPanel
        Left = 335
        Top = 0
        Width = 330
        Height = 239
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lvCover: TCaptionListView
          Left = 49
          Top = 0
          Width = 281
          Height = 239
          Align = alClient
          Columns = <
            item
              Caption = 'Reminders'
              Tag = 1
              Width = 255
            end
            item
              Caption = 'Sequence'
              Tag = 2
              Width = 40
            end>
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          SmallImages = imgMain
          SortType = stData
          StateImages = imgMain
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = lvCoverChange
          OnColumnClick = lvCoverColumnClick
          OnCompare = lvCoverCompare
          OnDblClick = lvCoverDblClick
          OnKeyDown = lvCoverKeyDown
          AutoSize = False
          Caption = 'Selected Reminders and Categories'
        end
        object pblMoveBtns: TPanel
          Left = 0
          Top = 0
          Width = 49
          Height = 239
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object sbCopyRight: TBitBtn
            AlignWithMargins = True
            Left = 3
            Top = 24
            Width = 43
            Height = 21
            Hint = 'Copy Reminder into Reminder List'
            Margins.Top = 24
            Align = alTop
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
            TabOrder = 0
            OnClick = sbCopyRightClick
            OnExit = sbCopyRightExit
          end
          object sbCopyLeft: TBitBtn
            Tag = 1
            AlignWithMargins = True
            Left = 3
            Top = 51
            Width = 43
            Height = 21
            Hint = 'Remove Reminder from Reminder List'
            Align = alTop
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
            TabOrder = 1
            OnClick = sbCopyLeftClick
          end
        end
      end
    end
  end
  object pnlUser: TPanel [1]
    Left = 0
    Top = 235
    Width = 774
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblRemLoc: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 163
      Height = 20
      Align = alLeft
      Caption = 'Location shown in Cumulative List:'
      ExplicitHeight = 13
    end
    object cbxUserLoc: TORComboBox
      AlignWithMargins = True
      Left = 172
      Top = 3
      Width = 456
      Height = 21
      Style = orcsDropDown
      Align = alLeft
      AutoSelect = True
      Caption = 'Location shown in Cumulative List'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnChange = cbxLocationChange
      OnDropDownClose = cbxDropDownClose
      OnExit = cbxUserLocExit
      OnKeyDown = cbxDivisionKeyDown
      OnNeedData = cbxLocationNeedData
      CharsNeedMatch = 1
    end
  end
  object pnlMiddle: TPanel [2]
    Left = 0
    Top = 0
    Width = 774
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 124
    TabOrder = 0
    object lblView: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 232
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Cover Sheet Reminders (Cumulative List)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlRight: TPanel
      Left = 664
      Top = 19
      Width = 110
      Height = 195
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblLegend: TLabel
        Left = 0
        Top = 182
        Width = 72
        Height = 13
        Align = alBottom
        Alignment = taCenter
        Caption = 'Icon Legend'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object btnView: TButton
        AlignWithMargins = True
        Left = 3
        Top = 0
        Width = 104
        Height = 30
        Hint = 'View Cover Sheet Reminders'
        Margins.Top = 0
        Align = alTop
        Caption = 'View C/S Rem.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnViewClick
        OnExit = btnViewExit
      end
      object cbLegend: TCheckBox
        AlignWithMargins = True
        Left = 8
        Top = 36
        Width = 99
        Height = 17
        Margins.Left = 8
        Align = alTop
        Caption = ' &Legend'
        TabOrder = 1
        OnClick = cbLegendClick
      end
    end
    object pnlTopLeft: TPanel
      Left = 0
      Top = 19
      Width = 664
      Height = 195
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsSingle
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object lvView: TCaptionListView
        Left = 0
        Top = 0
        Width = 662
        Height = 118
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Caption = 'Reminder'
            Tag = 1
            Width = 320
          end
          item
            Caption = 'Sequence'
            Tag = 2
            Width = 40
          end
          item
            Caption = 'Level'
            Tag = 3
            Width = 64
          end
          item
            Tag = 4
            Width = 154
          end>
        ReadOnly = True
        RowSelect = True
        SmallImages = imgMain
        SortType = stData
        StateImages = imgMain
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvViewChange
        OnColumnClick = lvViewColumnClick
        OnCompare = lvViewCompare
        OnExit = lvViewExit
        OnSelectItem = lvViewSelectItem
        AutoSize = False
        Caption = 'Cover Sheet Reminders (Cumulative List)'
      end
      object grdPanel: TGridPanel
        Left = 0
        Top = 118
        Width = 662
        Height = 75
        Align = alBottom
        BevelOuter = bvLowered
        Color = clCream
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = mlgnCat
            Row = 0
          end
          item
            Column = 1
            Control = mlgnAdd
            Row = 0
          end
          item
            Column = 0
            Control = mlgnRem
            Row = 1
          end
          item
            Column = 1
            Control = mlgnRemove
            Row = 1
          end
          item
            Column = 0
            Control = mlgnLock
            Row = 2
          end>
        ParentBackground = False
        RowCollection = <
          item
            Value = 33.631618661353820000
          end
          item
            Value = 33.631618661353820000
          end
          item
            Value = 32.736762677292360000
          end>
        ShowCaption = False
        TabOrder = 1
        Visible = False
        inline mlgnCat: TfraImgText
          Left = 1
          Top = 1
          Width = 330
          Height = 20
          Align = alTop
          Anchors = []
          AutoScroll = True
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 1
          ExplicitWidth = 330
          inherited gp: TGridPanel
            Width = 330
            ControlCollection = <
              item
                Column = 0
                Control = mlgnCat.img
                Row = 0
              end
              item
                Column = 1
                Control = mlgnCat.lblText
                Row = 0
              end>
            ExplicitWidth = 330
            inherited img: TImage
              Width = 30
              Height = 16
              Picture.Data = {
                07544269746D617076010000424D760100000000000076000000280000001E00
                0000100000000100040000000000000100000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
                DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00D0000000000DDDDD0000000000DD
                DD000BFBFBFBFB0DDDD00B8B8B8B8B0DDD000FBFBFBFBF0DDDD0F0B8B8B8B8B0
                DD000BFBFBFBFB0DDDD0BF0B8B8B8B8B0D000FBFBFBFBF0DDDD0FBF000000000
                0D000BFBFBFBFB0DDDD0BFBFBFBFB0DDDD000FBFBFBFBF0DDDD0FBFBFBFBF0DD
                DD000000000000DDDDD0BFBFBF000DDDDD00D0FBFB0DDDDDDDDD0BFBF0DDDDDD
                DD00D700007DDDDDDDDD700007DDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
                DD00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00DDDDDDDDDDDDDDDDDDDDDDDDDDDD
                DD00}
              Transparent = True
              ExplicitTop = 3
              ExplicitWidth = 30
            end
            inherited lblText: TStaticText
              Width = 97
              Caption = 'Reminder Category'
              ExplicitWidth = 97
            end
          end
        end
        inline mlgnAdd: TfraImgText
          Left = 331
          Top = 1
          Width = 330
          Height = 47
          Align = alTop
          Anchors = []
          AutoScroll = True
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          TabStop = True
          ExplicitLeft = 331
          ExplicitTop = 1
          ExplicitWidth = 330
          ExplicitHeight = 47
          inherited gp: TGridPanel
            Width = 330
            Height = 47
            ControlCollection = <
              item
                Column = 0
                Control = mlgnAdd.img
                Row = 0
              end
              item
                Column = 1
                Control = mlgnAdd.lblText
                Row = 0
              end>
            ExplicitWidth = 330
            ExplicitHeight = 47
            inherited img: TImage
              Width = 16
              Height = 16
              Picture.Data = {
                07544269746D6170F6000000424DF60000000000000076000000280000001000
                0000100000000100040000000000800000000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF00333333333333333333333333333333333333333333333333333333300333
                3333333333300333333333333330033333333333333003333333333000000000
                0333333000000000033333333330033333333333333003333333333333300333
                3333333333300333333333333333333333333333333333333333333333333333
                3333}
              Transparent = True
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 16
              ExplicitHeight = 41
            end
            inherited lblText: TStaticText
              Width = 178
              Hint = 
                'Reminder will be displayed on the Coversheet for the level ident' +
                'ified.'
              Caption = 'Add to Cover Sheet (Removes Lock)'
              ParentShowHint = False
              ShowHint = True
              ExplicitWidth = 178
            end
          end
        end
        inline mlgnRem: TfraImgText
          Left = 1
          Top = 26
          Width = 330
          Height = 20
          Align = alTop
          Anchors = []
          AutoScroll = True
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 26
          ExplicitWidth = 330
          inherited gp: TGridPanel
            Width = 330
            ControlCollection = <
              item
                Column = 0
                Control = mlgnRem.img
                Row = 0
              end
              item
                Column = 1
                Control = mlgnRem.lblText
                Row = 0
              end>
            ExplicitWidth = 330
            inherited img: TImage
              Width = 16
              Height = 16
              Picture.Data = {
                07544269746D6170F6000000424DF60000000000000076000000280000001000
                0000100000000100040000000000800000000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF0080018000008100888810009090001888880098F0F8900888870980FFF089
                07888099FFFFFFF990888090F000FF009088B099FFF0FFF990B8070980F0F089
                0708BB0098F0F8900BB800000999990000080887000000087708088887707888
                8708B078800B008870B808700BBBBB007808880BB0B0B0BB088880BB08B0B80B
                B088}
              ExplicitLeft = 3
              ExplicitTop = 3
              ExplicitWidth = 16
            end
            inherited lblText: TStaticText
              Width = 49
              Caption = 'Reminder'
              ExplicitWidth = 49
            end
          end
        end
        inline mlgnRemove: TfraImgText
          Left = 331
          Top = 26
          Width = 330
          Height = 20
          Align = alTop
          Anchors = []
          AutoScroll = True
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          TabStop = True
          ExplicitLeft = 331
          ExplicitTop = 26
          ExplicitWidth = 330
          inherited gp: TGridPanel
            Width = 330
            ControlCollection = <
              item
                Column = 0
                Control = mlgnRemove.img
                Row = 0
              end
              item
                Column = 1
                Control = mlgnRemove.lblText
                Row = 0
              end>
            ExplicitWidth = 330
            inherited img: TImage
              Width = 16
              Height = 16
              Picture.Data = {
                07544269746D6170F6000000424DF60000000000000076000000280000001000
                0000100000000100040000000000800000000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF00333333333333333333333333333333333333333333333333333333333333
                3333333333333333333333333333333333333333333333333333333000000000
                0333333000000000033333333333333333333333333333333333333333333333
                3333333333333333333333333333333333333333333333333333333333333333
                3333}
              Transparent = True
              ExplicitLeft = 3
              ExplicitTop = 3
              ExplicitWidth = 16
            end
            inherited lblText: TStaticText
              Width = 133
              Hint = 
                'Reminder will not be displayed on the Coversheet for the level i' +
                'dentified.'
              Caption = 'Remove From Cover Sheet'
              ParentShowHint = False
              ShowHint = True
              ExplicitWidth = 133
            end
          end
        end
        inline mlgnLock: TfraImgText
          Left = 1
          Top = 50
          Width = 330
          Height = 24
          Align = alClient
          Anchors = []
          AutoScroll = True
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          TabStop = True
          ExplicitLeft = 1
          ExplicitTop = 50
          ExplicitWidth = 330
          ExplicitHeight = 24
          inherited gp: TGridPanel
            Width = 330
            Height = 24
            ControlCollection = <
              item
                Column = 0
                Control = mlgnLock.img
                Row = 0
              end
              item
                Column = 1
                Control = mlgnLock.lblText
                Row = 0
              end>
            ExplicitWidth = 330
            ExplicitHeight = 24
            inherited img: TImage
              Width = 16
              Height = 16
              Picture.Data = {
                07544269746D6170F6000000424DF60000000000000076000000280000001000
                0000100000000100040000000000800000000000000000000000100000000000
                0000000000000000800000800000008080008000000080008000808000008080
                8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
                FF00333330000033333333300888880033333307787078770333308888707888
                8033307778808877703330888800088880333077770007777033308888888888
                8033330000000000033333308033308033333330803330803333333080333080
                3333333778000877333333330888880333333333300000333333333333333333
                3333}
              Transparent = True
              ExplicitLeft = 3
              ExplicitTop = 3
              ExplicitWidth = 16
              ExplicitHeight = 19
            end
            inherited lblText: TStaticText
              Width = 211
              Caption = 'Lock (can not be removed from lower level)'
              ParentShowHint = False
              ShowHint = True
              ExplicitWidth = 211
            end
          end
        end
      end
    end
    object lblCAC: TVA508StaticText
      Name = 'lblCAC'
      AlignWithMargins = True
      Left = 3
      Top = 217
      Width = 305
      Height = 15
      Align = alBottom
      Alignment = taCenter
      Caption = 'Select Cover Sheet Parameter Level to Display / Edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnExit = lblCACExit
      ShowAccelChar = True
    end
  end
  object pnlCAC: TORAutoPanel [3]
    Left = 0
    Top = 261
    Width = 774
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      774
      68)
    object cbSystem: TORCheckBox
      Tag = 1
      Left = 8
      Top = 4
      Width = 73
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'System'
      TabOrder = 0
      OnClick = cbEditLevelClick
      OnExit = cbSystemExit
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbDivision: TORCheckBox
      Tag = 2
      Left = 8
      Top = 26
      Width = 82
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'Division:'
      TabOrder = 1
      OnClick = cbEditLevelClick
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbService: TORCheckBox
      Tag = 3
      Left = 8
      Top = 48
      Width = 82
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'Service:'
      TabOrder = 3
      OnClick = cbEditLevelClick
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbxService: TORComboBox
      Tag = 3
      Left = 96
      Top = 46
      Width = 233
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Service'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 4
      Text = ''
      OnChange = cbxServiceChange
      OnDropDownClose = cbxDropDownClose
      OnKeyDown = cbxDivisionKeyDown
      OnNeedData = cbxServiceNeedData
      CharsNeedMatch = 1
    end
    object cbxDivision: TORComboBox
      Tag = 2
      Left = 96
      Top = 24
      Width = 233
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Division'
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
      TabOrder = 2
      Text = ''
      OnChange = cbxDivisionChange
      OnDropDownClose = cbxDropDownClose
      OnKeyDown = cbxDivisionKeyDown
      CharsNeedMatch = 1
    end
    object cbLocation: TORCheckBox
      Tag = 4
      Left = 353
      Top = 4
      Width = 88
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'Location:'
      TabOrder = 5
      OnClick = cbEditLevelClick
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbUserClass: TORCheckBox
      Tag = 5
      Left = 353
      Top = 26
      Width = 97
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'User Class:'
      TabOrder = 7
      OnClick = cbEditLevelClick
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbUser: TORCheckBox
      Tag = 6
      Left = 353
      Top = 48
      Width = 88
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'User:'
      TabOrder = 9
      OnClick = cbEditLevelClick
      AutoSize = True
      GroupIndex = 1
      RadioStyle = True
    end
    object cbxUser: TORComboBox
      Tag = 6
      Left = 456
      Top = 46
      Width = 209
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'User'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2,3'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 10
      Text = ''
      OnChange = cbxUserChange
      OnDropDownClose = cbxDropDownClose
      OnEnter = cbxUserEnter
      OnExit = cbxUserExit
      OnKeyDown = cbxDivisionKeyDown
      OnMouseClick = cbxUserMouseClick
      OnNeedData = cbxUserNeedData
      CharsNeedMatch = 1
    end
    object cbxClass: TORComboBox
      Tag = 5
      Left = 456
      Top = 24
      Width = 209
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'User Class'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 8
      Text = ''
      OnChange = cbxClassChange
      OnDropDownClose = cbxDropDownClose
      OnKeyDown = cbxDivisionKeyDown
      OnNeedData = cbxClassNeedData
      CharsNeedMatch = 1
    end
    object cbxLocation: TORComboBox
      Tag = 4
      Left = 456
      Top = 2
      Width = 209
      Height = 21
      Anchors = [akLeft, akBottom]
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Location'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 6
      Text = ''
      OnChange = cbxLocationChange
      OnDropDownClose = cbxDropDownClose
      OnKeyDown = cbxDivisionKeyDown
      OnNeedData = cbxLocationNeedData
      CharsNeedMatch = 1
    end
  end
  object pnlBtns: TPanel [4]
    Left = 0
    Top = 581
    Width = 774
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object btnOK: TButton
      AlignWithMargins = True
      Left = 479
      Top = 3
      Width = 90
      Height = 29
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      OnExit = btnOKExit
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 575
      Top = 3
      Width = 90
      Height = 29
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnApply: TButton
      AlignWithMargins = True
      Left = 671
      Top = 3
      Width = 100
      Height = 29
      Align = alRight
      Caption = 'Apply'
      Enabled = False
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 56
    Data = (
      (
        'Component = pnlBottom'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = sbUp'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = sbDown'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnLock'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = edtSeq'
        'Label = lblSeq'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = udSeq'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlInfo'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlTree'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = tvAll'
        'Label = lblTree'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = pnlCover'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lvCover'
        'Text = Remove Reminders'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = pblMoveBtns'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = sbCopyRight'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = sbCopyLeft'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlUser'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbxUserLoc'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlRight'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = mlgnCat'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = mlgnRem'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = mlgnAdd'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = mlgnRemove'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = mlgnLock'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnView'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlCAC'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbSystem'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbDivision'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbService'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbxService'
        'Text = Service:'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = cbxDivision'
        'Text = Division:'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = cbLocation'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbUserClass'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbUser'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbxUser'
        'Text = To select a user use the arrow keys, then press enter'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = cbxClass'
        'Text = User Class:'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = cbxLocation'
        'Text = Location:'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsOK')
      (
        'Component = pnlBtns'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = frmRemCoverSheet'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = pnlTopLeft'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lvView'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = lblCAC'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = grdPanel'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault')
      (
        'Component = cbLegend'
        'WatchEnable = False'
        'IgnoreWatchEnable = False'
        'Status = stsDefault'))
  end
  object imgMain: TImageList
    BkColor = clWhite
    Masked = False
    Left = 16
    Top = 56
    Bitmap = {
      494C010106000900040010001000FFFFFF00FF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000008484
      840084848400C6C6C600848484000000000084848400C6C6C600848484008484
      840000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600C6C6
      C600C6C6C600C6C6C600848484000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C60000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848484008484
      840084848400C6C6C600C6C6C60000000000C6C6C600C6C6C600848484008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600C6C6
      C600C6C6C600C6C6C600000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C60000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848484008484
      8400848484008484840000000000000000000000000084848400848484008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C60000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000FFFFFF00FFFFFF00FFFFFF0000000000C6C6C6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000FFFFFF00FFFFFF00FFFFFF0000000000C6C6C6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000FFFFFF00FFFFFF00FFFFFF0000000000C6C6C6000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      840084848400C6C6C600000000000000000000000000C6C6C600848484008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      8400FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      84000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000084000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      000000008400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000FF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400000000000000
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      FF000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
      0000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00000000000000
      00000000FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00000000000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000000000FFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      000000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000084848400000000000000
      FF00FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      FF00000000008484840000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFF
      FF000000000000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000FFFF0000FFFF00000000000000
      00000000FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000FF000000
      00000000000000FFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF008484
      840000000000000000000000000000000000000000000000000000000000FFFF
      FF00848484008484840000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400848484000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008484840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF000000000084848400FFFF
      FF00FFFFFF00000000000000000000FFFF000000000000000000FFFFFF00FFFF
      FF00848484000000000000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF007B7B
      7B00000000000000000000000000000000007B7B7B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00848484000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      000084848400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484000000
      000000000000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FF
      FF0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF0000FF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000FF
      FF0000000000FFFFFF0000FFFF000000000000FFFF00FFFFFF000000000000FF
      FF0000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFF83F00000000FFFFE00F00000000
      FFFFC00700000000FFFF800300000000FFFF800300000000FFFF800300000000
      FFFF800300000000E007800300000000E007C00700000000FFFFE38F00000000
      FFFFE38F00000000FFFFE38F00000000FFFFE00F00000000FFFFF01F00000000
      FFFFF83F00000000FFFFFFFF000000008823FFFFFFFFFFFFC007FFFFFFFFFFFF
      C6C7FFFFFFFFFFFF8BA3E007FFFFFE7F8FE3CAA7C00FFE7F88C3D5578007FE7F
      0EE1CAA7A003FE7F0AA1D5579001E00706C1CAA7A801E0070001D557954FFE7F
      6011C00FAAAFFE7F7879EA7F951FFE7F1831E07FCAFFFE7F4005FFFFC0FFFFFF
      C007FFFFFFFFFFFF8443FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object imgLblRemCoverSheet: TVA508ImageListLabeler
    Components = <
      item
        Component = tvAll
      end
      item
        Component = lvCover
      end>
    ImageList = imgMain
    Labels = <
      item
        Caption = 'Reminder'
        ImageIndex = 0
        OverlayIndex = -1
      end
      item
        Caption = 'Category'
        ImageIndex = 1
        OverlayIndex = -1
      end
      item
        Caption = 'Category'
        ImageIndex = 2
        OverlayIndex = -1
      end
      item
        Caption = 'Add'
        ImageIndex = 3
        OverlayIndex = -1
      end
      item
        Caption = 'Remove'
        ImageIndex = 4
        OverlayIndex = -1
      end
      item
        Caption = 'Lock'
        ImageIndex = 5
        OverlayIndex = -1
      end>
    Left = 16
    Top = 96
  end
  object compAccessCopyRight: TVA508ComponentAccessibility
    Component = sbCopyRight
    OnCaptionQuery = compAccessCopyRightCaptionQuery
    Left = 48
    Top = 368
  end
  object compAccessCopyLeft: TVA508ComponentAccessibility
    Component = sbCopyLeft
    OnCaptionQuery = compAccessCopyLeftCaptionQuery
    Left = 48
    Top = 416
  end
  object VA508ImageListLabeler1: TVA508ImageListLabeler
    Components = <
      item
        Component = lvView
      end>
    ImageList = imgMain
    Labels = <
      item
        ImageIndex = 0
        OverlayIndex = -1
      end
      item
        Caption = 'Category'
        ImageIndex = 1
        OverlayIndex = -1
      end
      item
        Caption = 'Category'
        ImageIndex = 2
        OverlayIndex = -1
      end
      item
        Caption = 'Add'
        ImageIndex = 3
        OverlayIndex = -1
      end
      item
        Caption = 'Remove'
        ImageIndex = 4
        OverlayIndex = -1
      end
      item
        Caption = 'Lock'
        ImageIndex = 5
        OverlayIndex = -1
      end>
    Left = 56
    Top = 96
  end
  object caMoveDown: TVA508ComponentAccessibility
    Component = sbDown
    OnCaptionQuery = caMoveDownCaptionQuery
    Left = 432
    Top = 416
  end
  object caMoveUP: TVA508ComponentAccessibility
    Component = sbUp
    OnCaptionQuery = caMoveUPCaptionQuery
    Left = 432
    Top = 360
  end
end
