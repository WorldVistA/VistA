inherited frmFlags: TfrmFlags
  Left = 380
  Top = 122
  Width = 589
  Height = 607
  VertScrollBar.Range = 179
  Caption = 'Patient Record Flags'
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 589
  ExplicitHeight = 607
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 571
    Height = 562
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 1
      Top = 113
      Width = 569
      Height = 6
      Cursor = crVSplit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      ExplicitWidth = 714
    end
    object lblFlags: TLabel
      Left = 1
      Top = 119
      Width = 569
      Height = 16
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Category II Flags'
      Layout = tlCenter
      ExplicitWidth = 101
    end
    object Splitter1: TSplitter
      Left = 1
      Top = 231
      Width = 569
      Height = 6
      Cursor = crVSplit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      ExplicitTop = 235
      ExplicitWidth = 714
    end
    object lblCat1: TLabel
      Left = 1
      Top = 1
      Width = 569
      Height = 20
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Category I Flags'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      ExplicitWidth = 137
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 321
      Width = 569
      Height = 6
      Cursor = crVSplit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      MinSize = 45
      ExplicitTop = 470
      ExplicitWidth = 714
    end
    object memFlags: TRichEdit
      Left = 1
      Top = 237
      Width = 569
      Height = 84
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      HideScrollBars = False
      Constraints.MinHeight = 46
      Lines.Strings = (
        '')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      Zoom = 100
    end
    object lstFlagsCat2: TORListBox
      Left = 1
      Top = 135
      Width = 569
      Height = 96
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Constraints.MinHeight = 46
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
      Top = 21
      Width = 569
      Height = 92
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvRaised
      Constraints.MinHeight = 46
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 20
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
      Top = 327
      Width = 569
      Height = 234
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      TabOrder = 1
      object lblNoteTitle: TLabel
        Left = 1
        Top = 1
        Width = 567
        Height = 16
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        Caption = 'lblNoteTitle'
        ExplicitWidth = 69
      end
      object lvPRF: TCaptionListView
        Left = 1
        Top = 17
        Width = 567
        Height = 168
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
        Constraints.MinHeight = 78
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = lvPRFClick
        OnKeyDown = lvPRFKeyDown
        AutoSize = False
        HideTinyColumns = True
      end
      object pnlBottom: TORAutoPanel
        Left = 1
        Top = 185
        Width = 567
        Height = 48
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          567
          48)
        object btnClose: TButton
          Left = 439
          Top = 8
          Width = 119
          Height = 32
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
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
