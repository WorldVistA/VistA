inherited frmFlags: TfrmFlags
  Left = 380
  Top = 122
  Width = 589
  Height = 607
  VertScrollBar.Range = 143
  Caption = 'Patient Record Flags'
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 589
  ExplicitHeight = 607
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 573
    Height = 569
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 1
      Top = 90
      Width = 571
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      ExplicitWidth = 713
    end
    object lblFlags: TLabel
      Left = 1
      Top = 95
      Width = 571
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Category II Flags'
      Layout = tlCenter
      ExplicitWidth = 101
    end
    object Splitter1: TSplitter
      Left = 1
      Top = 188
      Width = 571
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      ExplicitWidth = 713
    end
    object lblCat1: TLabel
      Left = 1
      Top = 1
      Width = 571
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Category I Flags'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 115
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 376
      Width = 571
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      MinSize = 45
      ExplicitTop = 512
      ExplicitWidth = 713
    end
    object memFlags: TRichEdit
      Left = 1
      Top = 193
      Width = 571
      Height = 183
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      HideScrollBars = False
      Constraints.MinHeight = 37
      Lines.Strings = (
        '')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
      WordWrap = False
    end
    object lstFlagsCat2: TORListBox
      Left = 1
      Top = 111
      Width = 571
      Height = 77
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      Constraints.MinHeight = 37
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = lstFlagsCat2Click
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstFlagsCat1: TORListBox
      Left = 1
      Top = 17
      Width = 571
      Height = 73
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvRaised
      Constraints.MinHeight = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = lstFlagsCat1Click
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object pnlNotes: TPanel
      Left = 1
      Top = 381
      Width = 571
      Height = 187
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 1
      object lblNoteTitle: TLabel
        Left = 1
        Top = 1
        Width = 569
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'lblNoteTitle'
        ExplicitWidth = 69
      end
      object lvPRF: TCaptionListView
        Left = 1
        Top = 17
        Width = 569
        Height = 131
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Columns = <
          item
            Caption = 'Used For Screen Readers'
            Width = 1
          end
          item
            AutoSize = True
            Caption = 'Date'
          end
          item
            AutoSize = True
            Caption = 'Action'
          end
          item
            AutoSize = True
            Caption = 'Author'
          end>
        Constraints.MinHeight = 62
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvPRFClick
        OnKeyDown = lvPRFKeyDown
      end
      object pnlBottom: TORAutoPanel
        Left = 1
        Top = 148
        Width = 569
        Height = 38
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          569
          38)
        object btnClose: TButton
          Left = 467
          Top = 6
          Width = 95
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Anchors = [akRight, akBottom]
          Cancel = True
          Caption = 'Close'
          Default = True
          ModalResult = 2
          TabOrder = 0
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmFlags'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = memFlags'
        'Text = Selected Flag'#39's Information'
        'Status = stsOK')
      (
        'Component = lstFlagsCat2'
        'Status = stsDefault')
      (
        'Component = lstFlagsCat1'
        'Text = Category One Flags'
        'Status = stsOK')
      (
        'Component = pnlNotes'
        'Status = stsDefault')
      (
        'Component = lvPRF'
        'Label = lblNoteTitle'
        'Status = stsOK')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault'))
  end
  object TimerTextFlash: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerTextFlashTimer
    Left = 376
    Top = 464
  end
end
