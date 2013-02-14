inherited frmFlags: TfrmFlags
  Left = 380
  Top = 122
  Width = 589
  Height = 607
  VertScrollBar.Range = 116
  Caption = 'Patient Record Flags'
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 589
  ExplicitHeight = 607
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 581
    Height = 573
    Align = alClient
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 1
      Top = 73
      Width = 579
      Height = 4
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = 0
      ExplicitTop = 38
      ExplicitWidth = 494
    end
    object lblFlags: TLabel
      Left = 1
      Top = 77
      Width = 579
      Height = 13
      Align = alTop
      Caption = 'Category II Flags'
      Layout = tlCenter
      ExplicitWidth = 79
    end
    object Splitter1: TSplitter
      Left = 1
      Top = 153
      Width = 579
      Height = 4
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 31
      ExplicitWidth = 494
    end
    object lblCat1: TLabel
      Left = 1
      Top = 1
      Width = 579
      Height = 13
      Align = alTop
      Caption = 'Category I Flags'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 93
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 416
      Width = 579
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      MinSize = 45
      ExplicitTop = 157
    end
    object memFlags: TRichEdit
      Left = 1
      Top = 157
      Width = 579
      Height = 259
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      HideScrollBars = False
      Constraints.MinHeight = 30
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
      Top = 90
      Width = 579
      Height = 63
      Align = alTop
      Constraints.MinHeight = 30
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = lstFlagsCat2Click
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstFlagsCat1: TORListBox
      Left = 1
      Top = 14
      Width = 579
      Height = 59
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvRaised
      Constraints.MinHeight = 30
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = lstFlagsCat1Click
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object pnlNotes: TPanel
      Left = 1
      Top = 420
      Width = 579
      Height = 152
      Align = alBottom
      TabOrder = 1
      object lblNoteTitle: TLabel
        Left = 1
        Top = 1
        Width = 577
        Height = 13
        Align = alTop
        Caption = 'lblNoteTitle'
        ExplicitWidth = 53
      end
      object lvPRF: TCaptionListView
        Left = 1
        Top = 14
        Width = 577
        Height = 106
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
        Constraints.MinHeight = 50
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
        Top = 120
        Width = 577
        Height = 31
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          577
          31)
        object btnClose: TButton
          Left = 494
          Top = 5
          Width = 77
          Height = 21
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
