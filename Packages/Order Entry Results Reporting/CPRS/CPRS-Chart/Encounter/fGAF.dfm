inherited frmGAF: TfrmGAF
  Left = 255
  Top = 178
  ActiveControl = edtScore
  Caption = 'frmGAF'
  ClientHeight = 591
  ClientWidth = 556
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 572
  ExplicitHeight = 630
  TextHeight = 13
  inherited pnlBottomAncestor: TPanel
    Top = 564
    Width = 556
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 564
    ExplicitWidth = 556
    inherited btnOK: TBitBtn
      Left = 397
      TabOrder = 1
      ExplicitLeft = 397
    end
    inherited btnCancel: TBitBtn
      Left = 478
      TabOrder = 2
      ExplicitLeft = 478
    end
    object btnURL: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 134
      Height = 21
      Hint = 'GAF Scale Rating Form'
      Align = alLeft
      Caption = 'Reference Information'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnURLClick
    end
  end
  inherited pnlMainAncestor: TPanel
    Width = 556
    Height = 564
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 556
    ExplicitHeight = 564
    object pnlBottom: TPanel [0]
      Left = 0
      Top = 321
      Width = 556
      Height = 243
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        556
        243)
      object lblScore: TLabel
        Left = 4
        Top = 47
        Width = 31
        Height = 13
        Caption = 'Score:'
      end
      object lblDate: TLabel
        Left = 4
        Top = 74
        Width = 83
        Height = 13
        Caption = 'Date Determined:'
      end
      object lblDeterminedBy: TLabel
        Left = 4
        Top = 101
        Width = 72
        Height = 13
        Caption = 'Determined By:'
      end
      object cboGAFProvider: TORCheckComboBox
        Left = 93
        Top = 98
        Width = 460
        Height = 142
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Determined By'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = True
        LookupPiece = 2
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 4
        Text = ''
        FlatCheckBoxes = False
        OnExit = cboGAFProviderExit
        OnNeedData = cboGAFProviderNeedData
        OnResize = pnlGAFProviderResize
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        MainCheckBoxCaption = 'Include Non-VA Providers'
        MainCheckBoxVisible = True
        MainCheckBoxAlignment = calBottom
        OnMainCheckboxClick = cboGAFProviderMainCheckboxClick
        DropdownStyle = ddsControl
      end
      object lblEntry: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 13
        Width = 550
        Height = 17
        Margins.Top = 13
        Margins.Bottom = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Global Assessment of Functioning (GAF) score entry:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object edtScore: TCaptionEdit
        Left = 93
        Top = 44
        Width = 33
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = edtScoreChange
        Caption = 'Score'
      end
      object udScore: TUpDown
        Left = 126
        Top = 44
        Width = 15
        Height = 21
        Associate = edtScore
        TabOrder = 2
      end
      object dteGAF: TORDateBox
        Left = 93
        Top = 71
        Width = 121
        Height = 21
        TabOrder = 3
        OnExit = dteGAFExit
        DateOnly = True
        RequireTime = False
        Caption = 'Date Determined:'
      end
    end
    inherited pnlGrid: TPanel
      Top = 35
      Width = 556
      Height = 286
      TabOrder = 1
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 0
      ExplicitTop = 35
      ExplicitWidth = 556
      ExplicitHeight = 286
      inherited lstCaptionList: TCaptionListView
        Width = 550
        Height = 280
        Columns = <
          item
            Caption = 'GAF Score'
            Width = 80
          end
          item
            Caption = 'Date Determined'
            Tag = 1
            Width = 120
          end
          item
            Caption = 'Determined By'
            Width = 100
          end
          item
            Caption = 'Comment'
            Width = 80
          end>
        Caption = 'Most recent Global Assessment of Functioning (GAF) scores'
        Pieces = '1,2,3,4'
        ExplicitLeft = 3
        ExplicitWidth = 550
        ExplicitHeight = 280
      end
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 556
      Height = 35
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object lblGAF: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 13
        Width = 550
        Height = 17
        Margins.Top = 13
        Margins.Bottom = 5
        Align = alTop
        Alignment = taCenter
        Caption = 'Most recent Global Assessment of Functioning (GAF) scores:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
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
        'Text = Determined Date/Time. Press the enter key to access.'
        'Status = stsOK')
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
