inherited frmGAF: TfrmGAF
  Left = 255
  Top = 178
  ActiveControl = edtScore
  Caption = 'frmGAF'
  OnActivate = FormActivate
  ExplicitLeft = 8
  ExplicitTop = 8
  PixelsPerInch = 96
  TextHeight = 13
  object lblScore: TLabel [0]
    Left = 139
    Top = 175
    Width = 31
    Height = 13
    Caption = 'Score:'
  end
  object lblDate: TLabel [1]
    Left = 139
    Top = 206
    Width = 83
    Height = 13
    Caption = 'Date Determined:'
  end
  object lblDeterminedBy: TLabel [2]
    Left = 139
    Top = 237
    Width = 72
    Height = 13
    Caption = 'Determined By:'
  end
  object Spacer1: TLabel [3]
    Left = 0
    Top = 0
    Width = 624
    Height = 13
    Align = alTop
    ExplicitWidth = 3
  end
  object Spacer2: TLabel [4]
    Left = 0
    Top = 122
    Width = 624
    Height = 13
    Align = alTop
    ExplicitWidth = 3
  end
  object lblGAF: TStaticText [5]
    Left = 0
    Top = 13
    Width = 624
    Height = 22
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Most recent Global Assessment of Functioning (GAF) scores:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object lblEntry: TStaticText [6]
    Left = 0
    Top = 135
    Width = 624
    Height = 30
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Global Assessment of Functioning (GAF) score entry:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
  end
  inherited btnOK: TBitBtn
    TabOrder = 6
  end
  inherited btnCancel: TBitBtn
    TabOrder = 7
  end
  inherited pnlGrid: TPanel
    Left = 0
    Top = 35
    Width = 624
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 35
    ExplicitWidth = 624
    inherited lbGrid: TORListBox
      Width = 624
      TabStop = False
      MultiSelect = True
      Caption = 'Most recent Global Assessment of Functioning (GAF) scores'
      Pieces = '1,2,3,4'
      ExplicitWidth = 624
    end
    inherited hcGrid: THeaderControl
      Width = 624
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 65
          Text = 'GAF Score'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 95
          Text = 'Date Determined'
          Width = 95
        end
        item
          ImageIndex = -1
          MinWidth = 85
          Text = 'Determined By'
          Width = 85
        end
        item
          ImageIndex = -1
          MinWidth = 60
          Text = 'Comment'
          Width = 60
        end>
      ExplicitWidth = 624
    end
  end
  object edtScore: TCaptionEdit [10]
    Left = 226
    Top = 171
    Width = 33
    Height = 21
    TabOrder = 1
    Text = '0'
    OnChange = edtScoreChange
    Caption = 'Score'
  end
  object udScore: TUpDown [11]
    Left = 259
    Top = 171
    Width = 15
    Height = 21
    Associate = edtScore
    TabOrder = 2
  end
  object dteGAF: TORDateBox [12]
    Left = 226
    Top = 202
    Width = 121
    Height = 21
    TabOrder = 3
    OnExit = dteGAFExit
    DateOnly = True
    RequireTime = False
    Caption = 'Date Determined:'
  end
  object cboGAFProvider: TORComboBox [13]
    Left = 226
    Top = 233
    Width = 212
    Height = 117
    Style = orcsSimple
    AutoSelect = True
    Caption = 'Determined By'
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
    TabOrder = 4
    OnExit = cboGAFProviderExit
    OnNeedData = cboGAFProviderNeedData
    CharsNeedMatch = 1
  end
  object btnURL: TButton [14]
    Left = 3
    Top = 376
    Width = 134
    Height = 21
    Hint = 'GAF Scale Rating Form'
    Caption = 'Reference Information'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = btnURLClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lblGAF'
        'Status = stsDefault')
      (
        'Component = lblEntry'
        'Status = stsDefault')
      (
        'Component = edtScore'
        'Status = stsDefault')
      (
        'Component = udScore'
        'Status = stsDefault')
      (
        'Component = dteGAF'
        'Status = stsDefault')
      (
        'Component = cboGAFProvider'
        'Status = stsDefault')
      (
        'Component = btnURL'
        'Status = stsDefault')
      (
        'Component = pnlGrid'
        'Status = stsDefault')
      (
        'Component = lbGrid'
        'Status = stsDefault')
      (
        'Component = hcGrid'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmGAF'
        'Status = stsDefault'))
  end
end
