inherited frmCover: TfrmCover
  Left = 256
  Top = 280
  HelpContext = 1000
  BorderIcons = []
  Caption = 'Cover Sheet'
  ClientHeight = 350
  ClientWidth = 632
  HelpFile = 'overvw'
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 648
  ExplicitHeight = 388
  PixelsPerInch = 96
  TextHeight = 13
  inherited shpPageBottom: TShape
    Top = 345
    Width = 632
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object pnlBase: TPanel [1]
    Left = 0
    Top = 0
    Width = 632
    Height = 345
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 10
    TabOrder = 0
    ExplicitWidth = 640
    ExplicitHeight = 356
    object sptBottom: TSplitter
      Left = 0
      Top = 226
      Width = 632
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Constraints.MinHeight = 5
      OnCanResize = sptBottomCanResize
      ExplicitTop = 237
      ExplicitWidth = 640
    end
    object pnlNotTheBottom: TPanel
      Left = 0
      Top = 0
      Width = 632
      Height = 226
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 640
      ExplicitHeight = 237
      object sptTop: TSplitter
        Left = 0
        Top = 120
        Width = 632
        Height = 5
        Cursor = crVSplit
        Align = alTop
        Constraints.MinHeight = 5
        OnCanResize = sptTopCanResize
        ExplicitWidth = 640
      end
      object pnlTop: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 120
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 640
        object spt_2: TSplitter
          Left = 416
          Top = 0
          Width = 5
          Height = 120
          Align = alRight
          Constraints.MinWidth = 5
          OnCanResize = spt_2CanResize
          ExplicitLeft = 424
        end
        object pnl_not3: TPanel
          Left = 0
          Top = 0
          Width = 416
          Height = 120
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 424
          object spt_1: TSplitter
            Left = 211
            Top = 0
            Width = 5
            Height = 120
            Color = clBtnFace
            Constraints.MinWidth = 5
            ParentColor = False
            OnCanResize = spt_1CanResize
          end
          object pnl_1: TPanel
            Left = 0
            Top = 0
            Width = 211
            Height = 120
            Align = alLeft
            BevelOuter = bvNone
            TabOrder = 0
            Visible = False
            object lbl_1: TOROffsetLabel
              Left = 0
              Top = 0
              Width = 211
              Height = 19
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
              Top = 19
              Width = 211
              Height = 101
              Align = alClient
              Ctl3D = True
              ItemHeight = 13
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
            Left = 216
            Top = 0
            Width = 200
            Height = 120
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            Visible = False
            ExplicitWidth = 208
            object lbl_2: TOROffsetLabel
              Left = 0
              Top = 0
              Width = 200
              Height = 19
              Align = alTop
              Caption = ' '
              HorzOffset = 2
              Transparent = False
              VertOffset = 6
              WordWrap = False
              ExplicitWidth = 208
            end
            object lst_2: TORListBox
              Tag = 20
              Left = 0
              Top = 19
              Width = 200
              Height = 101
              Align = alClient
              Ctl3D = True
              ItemHeight = 13
              ParentCtl3D = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = CoverItemClick
              OnExit = CoverItemExit
              Caption = ''
              ItemTipColor = clWindow
              LongList = False
              ExplicitWidth = 208
            end
          end
        end
        object pnl_3: TPanel
          Left = 421
          Top = 0
          Width = 211
          Height = 120
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          ExplicitLeft = 429
          object lbl_3: TOROffsetLabel
            Left = 0
            Top = 57
            Width = 211
            Height = 19
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 6
            WordWrap = False
          end
          object sptFlag: TSplitter
            Left = 0
            Top = 52
            Width = 211
            Height = 5
            Cursor = crVSplit
            Align = alTop
            Beveled = True
            Constraints.MinHeight = 5
          end
          object pnlFlag: TPanel
            Left = 0
            Top = 0
            Width = 211
            Height = 52
            Align = alTop
            Constraints.MinHeight = 40
            TabOrder = 0
            object lblFlag: TOROffsetLabel
              Left = 1
              Top = 1
              Width = 209
              Height = 15
              Align = alTop
              Caption = 'Patient Record Flags'
              HorzOffset = 2
              Transparent = False
              VertOffset = 2
              WordWrap = False
            end
            object lstFlag: TORListBox
              Left = 1
              Top = 16
              Width = 209
              Height = 35
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clMaroon
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ItemHeight = 13
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
            end
          end
          object lst_3: TORListBox
            Tag = 30
            Left = 0
            Top = 76
            Width = 211
            Height = 44
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 13
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
        Top = 125
        Width = 632
        Height = 101
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 640
        ExplicitHeight = 112
        object spt_3: TSplitter
          Left = 318
          Top = 0
          Width = 5
          Height = 101
          Constraints.MinWidth = 5
          OnCanResize = spt_3CanResize
          ExplicitHeight = 112
        end
        object pnl_4: TPanel
          Left = 0
          Top = 0
          Width = 318
          Height = 101
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          ExplicitHeight = 112
          object lbl_4: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 318
            Height = 13
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
            Top = 13
            Width = 318
            Height = 88
            Align = alClient
            Ctl3D = True
            ItemHeight = 13
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
            ExplicitHeight = 99
          end
        end
        object pnl_5: TPanel
          Left = 323
          Top = 0
          Width = 309
          Height = 101
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          ExplicitWidth = 317
          ExplicitHeight = 112
          object lbl_5: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 309
            Height = 13
            Align = alTop
            Caption = ' '
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
            ExplicitWidth = 317
          end
          object lst_5: TORListBox
            Tag = 50
            Left = 0
            Top = 13
            Width = 309
            Height = 88
            Align = alClient
            Ctl3D = True
            ItemHeight = 13
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
            ExplicitWidth = 317
            ExplicitHeight = 99
          end
        end
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 231
      Width = 632
      Height = 114
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitTop = 242
      ExplicitWidth = 640
      object spt_5: TSplitter
        Left = 372
        Top = 0
        Width = 5
        Height = 114
        Align = alRight
        Constraints.MinWidth = 5
        OnCanResize = spt_5CanResize
        ExplicitLeft = 380
      end
      object pnl_not8: TPanel
        Left = 0
        Top = 0
        Width = 372
        Height = 114
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 380
        object spt_4: TSplitter
          Left = 255
          Top = 0
          Width = 5
          Height = 114
          Constraints.MinWidth = 5
          OnCanResize = spt_4CanResize
        end
        object pnl_6: TPanel
          Left = 0
          Top = 0
          Width = 255
          Height = 114
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          object lbl_6: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 255
            Height = 13
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
            Top = 13
            Width = 255
            Height = 101
            Align = alClient
            Ctl3D = True
            ItemHeight = 13
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
          end
        end
        object pnl_7: TPanel
          Left = 260
          Top = 0
          Width = 112
          Height = 114
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          ExplicitWidth = 120
          object lbl_7: TOROffsetLabel
            Left = 0
            Top = 0
            Width = 112
            Height = 13
            Align = alTop
            HorzOffset = 2
            Transparent = False
            VertOffset = 0
            WordWrap = False
            ExplicitWidth = 120
          end
          object lst_7: TORListBox
            Tag = 70
            Left = 0
            Top = 13
            Width = 112
            Height = 101
            Align = alClient
            Ctl3D = True
            ItemHeight = 13
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
            ExplicitWidth = 120
          end
        end
      end
      object pnl_8: TPanel
        Left = 377
        Top = 0
        Width = 255
        Height = 114
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        Visible = False
        ExplicitLeft = 385
        object lbl_8: TOROffsetLabel
          Left = 0
          Top = 0
          Width = 255
          Height = 13
          Align = alTop
          HorzOffset = 2
          Transparent = False
          VertOffset = 0
          WordWrap = False
        end
        object lst_8: TORListBox
          Tag = 80
          Left = 0
          Top = 13
          Width = 255
          Height = 101
          Align = alClient
          Ctl3D = True
          ItemHeight = 13
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
