inherited frmCover: TfrmCover
  Left = 259
  Top = 283
  HelpContext = 1000
  BorderIcons = []
  Caption = 'Cover Sheet'
  ClientHeight = 431
  ClientWidth = 778
  HelpFile = 'overvw'
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitLeft = 259
  ExplicitTop = 283
  ExplicitWidth = 796
  ExplicitHeight = 476
  PixelsPerInch = 120
  TextHeight = 16
  inherited shpPageBottom: TShape
    Top = 425
    Width = 778
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 425
    ExplicitWidth = 778
  end
  object pnlBase: TPanel [1]
    Left = 0
    Top = 0
    Width = 778
    Height = 425
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 12
    TabOrder = 0
    object sptBottom: TSplitter
      Left = 0
      Top = 278
      Width = 778
      Height = 6
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      Constraints.MinHeight = 6
      OnCanResize = sptBottomCanResize
    end
    object pnlNotTheBottom: TPanel
      Left = 0
      Top = 0
      Width = 778
      Height = 278
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object sptTop: TSplitter
        Left = 0
        Top = 148
        Width = 778
        Height = 6
        Cursor = crVSplit
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Constraints.MinHeight = 6
        OnCanResize = sptTopCanResize
      end
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 778
        Height = 148
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object spt_2: TSplitter
          Left = 512
          Top = 0
          Width = 6
          Height = 148
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          Constraints.MinWidth = 6
          OnCanResize = spt_2CanResize
        end
        object pnl_not3: TPanel
          Left = 0
          Top = 0
          Width = 512
          Height = 148
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object spt_1: TSplitter
            Left = 260
            Top = 0
            Width = 6
            Height = 148
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = clBtnFace
            Constraints.MinWidth = 6
            ParentColor = False
            OnCanResize = spt_1CanResize
          end
          object pnl_1: TPanel
            Left = 0
            Top = 0
            Width = 260
            Height = 148
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            Visible = False
            object lbl_1: TOROffsetLabel
              Left = 0
              Top = 0
              Width = 260
              Height = 23
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Caption = ' '
              HorzOffset = 2
              Transparent = False
              VertOffset = 6
              WordWrap = False
            end
            object lst_1: TORListBox
              Tag = 10
              Left = 0
              Top = 23
              Width = 260
              Height = 125
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Ctl3D = True
              ParentCtl3D = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = CoverItemClick
              OnExit = CoverItemExit
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              TabPositions = '2,3'
            end
          end
          object pnl_2: TPanel
            Left = 266
            Top = 0
            Width = 246
            Height = 148
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            Visible = False
            object lbl_2: TOROffsetLabel
              Left = 0
              Top = 0
              Width = 246
              Height = 23
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Caption = ' '
              HorzOffset = 2
              Transparent = False
              VertOffset = 6
              WordWrap = False
            end
            object lst_2: TORListBox
              Tag = 20
              Left = 0
              Top = 23
              Width = 246
              Height = 125
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Ctl3D = True
              ParentCtl3D = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = CoverItemClick
              OnExit = CoverItemExit
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
            end
          end
        end
        object pnl_3: TPanel
          Left = 518
          Top = 0
          Width = 260
          Height = 148
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object lbl_3: TOROffsetLabel
            Left = 0
            Top = 70
            Width = 260
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 6
            WordWrap = False
          end
          object sptFlag: TSplitter
            Left = 0
            Top = 64
            Width = 260
            Height = 6
            Cursor = crVSplit
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Beveled = True
            Constraints.MinHeight = 6
          end
          object pnlFlag: TPanel
            Left = 0
            Top = 0
            Width = 260
            Height = 64
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Constraints.MinHeight = 49
            TabOrder = 0
            object lblFlag: TOROffsetLabel
              Left = 1
              Top = 1
              Width = 258
              Height = 19
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Caption = 'Patient Record Flags'
              HorzOffset = 2
              Transparent = False
              VertOffset = 2
              WordWrap = False
              ExplicitWidth = 257
            end
            object lstFlag: TORListBox
              Left = 1
              Top = 20
              Width = 258
              Height = 43
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = lstFlagClick
              OnKeyDown = lstFlagKeyDown
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              Pieces = '2'
              ExplicitWidth = 257
            end
          end
          object lst_3: TORListBox
            Tag = 30
            Left = 0
            Top = 94
            Width = 260
            Height = 54
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = CoverItemClick
            OnExit = CoverItemExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            TabPositions = '20'
          end
        end
      end
      object pnlMiddle: TPanel
        Left = 0
        Top = 154
        Width = 778
        Height = 124
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object spt_3: TSplitter
          Left = 391
          Top = 0
          Width = 7
          Height = 124
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Constraints.MinWidth = 6
          OnCanResize = spt_3CanResize
        end
        object pnl_4: TPanel
          Left = 0
          Top = 0
          Width = 391
          Height = 124
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          object lbl_4: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 391
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
          end
          object lst_4: TORListBox
            Tag = 40
            Left = 0
            Top = 16
            Width = 391
            Height = 108
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CoverItemClick
            OnExit = CoverItemExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            TabPositions = '35'
          end
        end
        object pnl_5: TPanel
          Left = 398
          Top = 0
          Width = 380
          Height = 124
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object lbl_5: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 380
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
          end
          object lst_5: TORListBox
            Tag = 50
            Left = 0
            Top = 16
            Width = 380
            Height = 108
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CoverItemClick
            OnExit = CoverItemExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            TabPositions = '34,44'
          end
        end
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 284
      Width = 778
      Height = 141
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object spt_5: TSplitter
        Left = 458
        Top = 0
        Width = 6
        Height = 141
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        Constraints.MinWidth = 6
        OnCanResize = spt_5CanResize
        ExplicitHeight = 140
      end
      object pnl_not8: TPanel
        Left = 0
        Top = 0
        Width = 458
        Height = 141
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 140
        object spt_4: TSplitter
          Left = 314
          Top = 0
          Width = 6
          Height = 141
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Constraints.MinWidth = 6
          OnCanResize = spt_4CanResize
          ExplicitHeight = 140
        end
        object pnl_6: TPanel
          Left = 0
          Top = 0
          Width = 314
          Height = 141
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          ExplicitHeight = 140
          object lbl_6: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 314
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
          end
          object lst_6: TORListBox
            Tag = 60
            Left = 0
            Top = 16
            Width = 314
            Height = 125
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CoverItemClick
            OnExit = CoverItemExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            TabPositions = '34'
            ExplicitHeight = 124
          end
        end
        object pnl_7: TPanel
          Left = 320
          Top = 0
          Width = 138
          Height = 141
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          ExplicitHeight = 140
          object lbl_7: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 138
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
          end
          object lst_7: TORListBox
            Tag = 70
            Left = 0
            Top = 16
            Width = 138
            Height = 125
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = CoverItemClick
            OnExit = CoverItemExit
            Caption = ''
            ItemTipColor = clWindow
            LongList = False
            TabPositions = '4,13,15,24'
            ExplicitHeight = 124
          end
        end
      end
      object pnl_8: TPanel
        Left = 464
        Top = 0
        Width = 314
        Height = 141
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        Visible = False
        ExplicitHeight = 140
        object lbl_8: TOROffsetLabel
          Left = 0
          Top = 0
          Width = 314
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alTop
          HorzOffset = 2
          Transparent = False
          VertOffset = 0
          WordWrap = False
        end
        object lst_8: TORListBox
          Tag = 80
          Left = 0
          Top = 16
          Width = 314
          Height = 125
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          Ctl3D = True
          ParentCtl3D = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = CoverItemClick
          OnExit = CoverItemExit
          Caption = ''
          ItemTipColor = clWindow
          LongList = False
          TabPositions = '15,35'
          ExplicitHeight = 124
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = pnlNotTheBottom'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnl_not3'
        'Status = stsDefault')
      (
        'Component = pnl_1'
        'Status = stsDefault')
      (
        'Component = lst_1'
        'Status = stsDefault')
      (
        'Component = pnl_2'
        'Status = stsDefault')
      (
        'Component = lst_2'
        'Status = stsDefault')
      (
        'Component = pnl_3'
        'Status = stsDefault')
      (
        'Component = pnlFlag'
        'Status = stsDefault')
      (
        'Component = lstFlag'
        'Status = stsDefault')
      (
        'Component = lst_3'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = pnl_4'
        'Status = stsDefault')
      (
        'Component = lst_4'
        'Status = stsDefault')
      (
        'Component = pnl_5'
        'Status = stsDefault')
      (
        'Component = lst_5'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnl_not8'
        'Status = stsDefault')
      (
        'Component = pnl_6'
        'Status = stsDefault')
      (
        'Component = lst_6'
        'Status = stsDefault')
      (
        'Component = pnl_7'
        'Status = stsDefault')
      (
        'Component = lst_7'
        'Status = stsDefault')
      (
        'Component = pnl_8'
        'Status = stsDefault')
      (
        'Component = lst_8'
        'Status = stsDefault')
      (
        'Component = frmCover'
        'Status = stsDefault'))
  end
  object timPoll: TTimer
    Enabled = False
    Interval = 2600
    OnTimer = timPollTimer
    Left = 20
    Top = 32
  end
  object popMenuAllergies: TPopupMenu
    OnPopup = popMenuAllergiesPopup
    Left = 283
    Top = 46
    object popNewAllergy: TMenuItem
      Caption = 'Enter new allergy'
      OnClick = popNewAllergyClick
    end
    object popEditAllergy: TMenuItem
      Caption = 'Edit selected allergy'
      Visible = False
      OnClick = popEditAllergyClick
    end
    object popEnteredInError: TMenuItem
      Caption = 'Mark selected allergy as entered in error'
      OnClick = popEnteredInErrorClick
    end
    object popNKA: TMenuItem
      Caption = 'Mark patient as having "No Known Allergies" (NKA)'
      OnClick = popNKAClick
    end
  end
  object VA508ComponentAccessibility1: TVA508ComponentAccessibility
    Component = lst_2
    Instructions = 
      'To move to an item use the arrow keys or press the context key t' +
      'o access more options such as entering a new allergy.'
    Left = 360
    Top = 48
  end
end
