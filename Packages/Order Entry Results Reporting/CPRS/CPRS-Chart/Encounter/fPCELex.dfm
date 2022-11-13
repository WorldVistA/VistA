inherited frmPCELex: TfrmPCELex
  Left = 239
  Top = 88
  Caption = 'Lookup Other Diagnosis'
  ClientHeight = 442
  ClientWidth = 624
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Name = 'Tahoma'
  OnKeyDown = nil
  OnResize = FormResize
  ExplicitWidth = 642
  ExplicitHeight = 487
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDialog: TPanel [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 417
    Align = alClient
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object pnlButtons: TPanel
      Left = 0
      Top = 386
      Width = 624
      Height = 31
      Align = alBottom
      BevelEdges = []
      BevelOuter = bvNone
      Constraints.MaxHeight = 33
      Constraints.MinHeight = 25
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      TabOrder = 2
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 467
        Top = 3
        Width = 70
        Height = 25
        Hint = 'Click to accept selected term.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = '&OK'
        Enabled = False
        TabOrder = 1
        OnClick = cmdOKClick
      end
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 543
        Top = 3
        Width = 70
        Height = 25
        Hint = 'Click to cancel the search.'
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 2
        OnClick = cmdCancelClick
      end
      object cmdExtendedSearch: TBitBtn
        Left = 11
        Top = 3
        Width = 79
        Height = 25
        Hint = 'Search ICD-9-CM Diagnoses...'
        Align = alLeft
        Caption = '&Extend Search'
        Enabled = False
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = cmdExtendedSearchClick
      end
    end
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 624
      Height = 52
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 52
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      TabOrder = 0
      object lblSearch: TLabel
        Left = 11
        Top = 3
        Width = 602
        Height = 15
        Align = alTop
        AutoSize = False
        Caption = 'Search for Diagnosis:'
        Constraints.MinHeight = 15
        WordWrap = True
        ExplicitWidth = 442
      end
      object txtSearch: TCaptionEdit
        AlignWithMargins = True
        Left = 11
        Top = 21
        Width = 526
        Height = 25
        Margins.Left = 0
        Align = alClient
        Constraints.MinHeight = 20
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = txtSearchChange
        Caption = 'Search for Diagnosis'
        ExplicitHeight = 20
      end
      object cmdSearch: TButton
        AlignWithMargins = True
        Left = 543
        Top = 21
        Width = 70
        Height = 25
        Hint = 'Click to execute the search.'
        Margins.Right = 0
        Align = alRight
        Caption = '&Search'
        Default = True
        TabOrder = 1
        OnClick = cmdSearchClick
      end
    end
    object pnlList: TPanel
      Left = 0
      Top = 52
      Width = 624
      Height = 334
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 11
      Padding.Top = 3
      Padding.Right = 11
      Padding.Bottom = 3
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      DesignSize = (
        624
        334)
      object lblSelect: TVA508StaticText
        Name = 'lblSelect'
        Left = 11
        Top = 3
        Width = 602
        Height = 15
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Select from one of the following items:'
        TabOrder = 0
        Visible = False
        ShowAccelChar = True
      end
      inline tgfLex: TTreeGridFrame
        Left = 11
        Top = 18
        Width = 602
        Height = 313
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        ExplicitLeft = 11
        ExplicitTop = 18
        ExplicitWidth = 602
        ExplicitHeight = 313
        inherited tv: TTreeView
          Width = 602
          Height = 209
          BorderStyle = bsSingle
          OnChange = tgfLextvChange
          OnClick = tgfLextvClick
          OnDblClick = tgfLextvDblClick
          OnEnter = tgfLextvEnter
          OnExit = tgfLextvExit
          OnExpanding = tgfLextvExpanding
          ExplicitWidth = 602
          ExplicitHeight = 209
        end
        inherited pnlTop: TPanel
          Width = 602
          ExplicitWidth = 602
          inherited stTitle: TStaticText
            Width = 36
            Caption = 'Term'
            ExplicitWidth = 36
          end
        end
        inherited pnlSpace: TPanel
          Top = 233
          Width = 602
          ExplicitTop = 233
          ExplicitWidth = 602
        end
        inherited pnlHint: TPanel
          Top = 241
          Width = 602
          ExplicitTop = 241
          ExplicitWidth = 602
          inherited pnlTarget: TPanel
            Top = 241
            Width = 602
            ExplicitTop = 241
            ExplicitWidth = 602
            inherited mmoTargetCode: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlTargetCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'ICD-10-CM:  '
            end
          end
          inherited pnlCode: TPanel
            Top = 265
            Width = 602
            ExplicitTop = 265
            ExplicitWidth = 602
            inherited mmoCode: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'SNOMED CT:  '
            end
          end
          inherited pnlDesc: TPanel
            Width = 602
            ExplicitWidth = 602
            inherited mmoDesc: TMemo
              Width = 537
              ExplicitWidth = 537
            end
            inherited pnlDescText: TPanel
              Alignment = taRightJustify
              Caption = 'Description:  '
            end
          end
        end
      end
      object clbFilter: TCaptionCheckListBox
        Left = 400
        Top = 42
        Width = 185
        Height = 183
        OnClickCheck = clbFilterClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
        Visible = False
        Caption = ''
      end
      object btnFilter: TButton
        Left = 543
        Top = 0
        Width = 70
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Filter'
        Enabled = False
        TabOrder = 3
        Visible = False
        OnClick = btnFilterClick
      end
    end
  end
  object pnlStatus: TPanel [1]
    Left = 0
    Top = 417
    Width = 624
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblStatus: TVA508StaticText
      Name = 'lblStatus'
      Left = 0
      Top = 0
      Width = 624
      Height = 25
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvLowered
      Caption = ''
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 152
    Top = 336
    Data = (
      (
        'Component = txtSearch'
        'Status = stsDefault')
      (
        'Component = cmdSearch'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmPCELex'
        'Text = Other Diagnosis search dialog'
        'Status = stsOK')
      (
        'Component = cmdExtendedSearch'
        'Status = stsDefault')
      (
        'Component = lblStatus'
        'Status = stsDefault')
      (
        'Component = lblSelect'
        'Status = stsDefault')
      (
        'Component = tgfLex'
        'Status = stsDefault')
      (
        'Component = tgfLex.tv'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTop'
        'Status = stsDefault')
      (
        'Component = tgfLex.stTitle'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlDesc'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoDesc'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlDescText'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlCodeSys'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTarget'
        'Status = stsDefault')
      (
        'Component = tgfLex.mmoTargetCode'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlTargetCodeSys'
        'Status = stsDefault')
      (
        'Component = tgfLex.pnlSpace'
        'Status = stsDefault')
      (
        'Component = clbFilter'
        'Status = stsDefault')
      (
        'Component = btnFilter'
        'Status = stsDefault'))
  end
end
