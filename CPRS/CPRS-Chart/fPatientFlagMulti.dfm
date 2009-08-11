inherited frmFlags: TfrmFlags
  Left = 380
  Top = 122
  Width = 504
  Height = 532
  VertScrollBar.Range = 116
  Caption = 'Patient Record Flags'
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 504
  ExplicitHeight = 532
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 80
    Width = 497
    Height = 5
    Align = alNone
  end
  object Splitter2: TSplitter [1]
    Left = 0
    Top = 349
    Width = 496
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    MinSize = 45
  end
  object pnlTop: TORAutoPanel [2]
    Left = 0
    Top = 0
    Width = 496
    Height = 113
    Align = alTop
    Constraints.MinHeight = 40
    Constraints.MinWidth = 300
    TabOrder = 0
    object lblFlags: TLabel
      Left = 1
      Top = 54
      Width = 494
      Height = 13
      Align = alTop
      Caption = 'Category II Flags'
      Layout = tlCenter
      ExplicitWidth = 79
    end
    object lblCat1: TLabel
      Left = 1
      Top = 1
      Width = 494
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
    object lstFlagsCat2: TORListBox
      Left = 1
      Top = 67
      Width = 494
      Height = 45
      Align = alClient
      ItemHeight = 13
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = lstFlagsCat2Click
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
    object lstFlagsCat1: TORListBox
      Left = 1
      Top = 14
      Width = 494
      Height = 40
      Align = alTop
      BevelKind = bkTile
      BevelOuter = bvRaised
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = lstFlagsCat1Click
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
    end
  end
  object memFlags: TRichEdit [3]
    Left = 0
    Top = 113
    Width = 496
    Height = 236
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    HideScrollBars = False
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
  object pnlNotes: TPanel [4]
    Left = 0
    Top = 353
    Width = 496
    Height = 152
    Align = alBottom
    TabOrder = 2
    object lblNoteTitle: TLabel
      Left = 1
      Top = 1
      Width = 53
      Height = 13
      Align = alTop
      Caption = 'lblNoteTitle'
    end
    object lvPRF: TCaptionListView
      Left = 1
      Top = 14
      Width = 494
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
      Width = 494
      Height = 31
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        494
        31)
      object btnClose: TButton
        Left = 409
        Top = 5
        Width = 77
        Height = 21
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Close'
        ModalResult = 2
        TabOrder = 0
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lstFlagsCat2'
        'Status = stsDefault')
      (
        'Component = lstFlagsCat1'
        'Status = stsDefault')
      (
        'Component = memFlags'
        'Status = stsDefault')
      (
        'Component = pnlNotes'
        'Status = stsDefault')
      (
        'Component = lvPRF'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = frmFlags'
        'Status = stsDefault'))
  end
  object TimerTextFlash: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerTextFlashTimer
    Left = 240
    Top = 24
  end
end
