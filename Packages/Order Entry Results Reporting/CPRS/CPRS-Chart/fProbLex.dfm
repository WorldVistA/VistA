inherited frmPLLex: TfrmPLLex
  Left = 239
  Top = 88
  Caption = 'Problem List  Lexicon Search'
  ClientHeight = 442
  ClientWidth = 624
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  OldCreateOrder = True
  OnHelp = nil
  OnKeyDown = nil
  ExplicitWidth = 642
  ExplicitHeight = 487
  PixelsPerInch = 96
  TextHeight = 16
  object pnlDialog: TPanel [0]
    Left = 0
    Top = 0
    Width = 624
    Height = 416
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 624
      Height = 55
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 55
      Locked = True
      Padding.Left = 12
      Padding.Top = 3
      Padding.Right = 12
      Padding.Bottom = 3
      TabOrder = 0
      object lblSearch: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 6
        Width = 594
        Height = 16
        Align = alTop
        Caption = 'Enter Term to Search:'
        ExplicitWidth = 129
      end
      object ebLex: TCaptionEdit
        AlignWithMargins = True
        Left = 12
        Top = 28
        Width = 518
        Height = 21
        Margins.Left = 0
        Align = alClient
        AutoSize = False
        Constraints.MinHeight = 21
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnChange = ebLexChange
        OnKeyPress = ebLexKeyPress
        Caption = 'Enter Term to Search'
      end
      object bbSearch: TBitBtn
        AlignWithMargins = True
        Left = 536
        Top = 28
        Width = 76
        Height = 21
        Hint = 'Search Problem List Subset of SNOMED CT'
        Margins.Right = 0
        Align = alRight
        Caption = '&Search'
        NumGlyphs = 2
        TabOrder = 1
        OnClick = bbSearchClick
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 389
      Width = 624
      Height = 27
      Align = alBottom
      BevelEdges = []
      BevelOuter = bvNone
      Constraints.MaxHeight = 33
      Constraints.MinHeight = 27
      Padding.Left = 12
      Padding.Top = 3
      Padding.Right = 12
      Padding.Bottom = 3
      TabOrder = 2
      object bbOK: TBitBtn
        AlignWithMargins = True
        Left = 456
        Top = 3
        Width = 74
        Height = 21
        Hint = 'Accept selected term.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = '&OK'
        Enabled = False
        NumGlyphs = 2
        TabOrder = 2
        OnClick = bbOKClick
      end
      object bbCan: TBitBtn
        AlignWithMargins = True
        Left = 536
        Top = 3
        Width = 76
        Height = 21
        Hint = 'Cancel Lexicon Search'
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alRight
        Cancel = True
        Caption = '&Cancel'
        NumGlyphs = 2
        TabOrder = 3
        OnClick = bbCanClick
      end
      object bbExtendedSearch: TBitBtn
        Left = 12
        Top = 3
        Width = 84
        Height = 21
        Hint = 'Search SNOMED CT Clinical Findings Hierarchy...'
        Align = alLeft
        Caption = '&Extend Search'
        Enabled = False
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = bbExtendedSearchClick
      end
      object bbFreetext: TBitBtn
        Left = 105
        Top = 3
        Width = 96
        Height = 21
        Caption = '&Freetext Problem'
        Enabled = False
        TabOrder = 1
        Visible = False
        OnClick = bbFreetextClick
      end
    end
    object pnlList: TPanel
      Left = 0
      Top = 55
      Width = 624
      Height = 334
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      Padding.Left = 12
      Padding.Top = 3
      Padding.Right = 12
      Padding.Bottom = 3
      TabOrder = 1
      object lblSelect: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 6
        Width = 594
        Height = 16
        Align = alTop
        Caption = 'Select from one of the following items:'
        ExplicitWidth = 221
      end
      inline tgfLex: TTreeGridFrame
        Left = 12
        Top = 25
        Width = 600
        Height = 306
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
        TabOrder = 0
        TabStop = True
        ExplicitLeft = 12
        ExplicitTop = 25
        ExplicitWidth = 600
        ExplicitHeight = 306
        inherited tv: TTreeView
          Width = 600
          Height = 202
          BorderStyle = bsSingle
          OnChange = tgfLextvChange
          OnDblClick = tgfLextvDblClick
          OnEnter = tgfLextvEnter
          OnExit = tgfLextvExit
          ExplicitWidth = 600
          ExplicitHeight = 202
        end
        inherited pnlTop: TPanel
          Width = 600
          ExplicitWidth = 600
          inherited stTitle: TStaticText
            Width = 55
            Caption = 'Problem'
            ExplicitWidth = 55
          end
        end
        inherited pnlSpace: TPanel
          Top = 226
          Width = 600
          ExplicitTop = 226
          ExplicitWidth = 600
        end
        inherited pnlHint: TPanel
          Top = 234
          Width = 600
          ExplicitTop = 234
          ExplicitWidth = 600
          inherited pnlTarget: TPanel
            Top = 285
            Width = 600
            ExplicitTop = 285
            ExplicitWidth = 600
            inherited mmoTargetCode: TMemo
              Width = 535
              ExplicitWidth = 535
            end
            inherited pnlTargetCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'ICD-10-CM:  '
            end
          end
          inherited pnlCode: TPanel
            Top = 261
            Width = 600
            ExplicitTop = 261
            ExplicitWidth = 600
            inherited mmoCode: TMemo
              Width = 535
              ExplicitWidth = 535
            end
            inherited pnlCodeSys: TPanel
              Alignment = taRightJustify
              Caption = 'SNOMED CT:  '
            end
          end
          inherited pnlDesc: TPanel
            Width = 600
            ExplicitWidth = 600
            inherited mmoDesc: TMemo
              Width = 535
              ExplicitWidth = 535
            end
            inherited pnlDescText: TPanel
              Alignment = taRightJustify
              Caption = 'Description:  '
            end
          end
        end
      end
    end
  end
  object pnlStatus: TPanel [1]
    Left = 0
    Top = 416
    Width = 624
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MaxHeight = 32
    Constraints.MinHeight = 26
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 0
    object lblstatus: TVA508StaticText
      Name = 'lblstatus'
      Left = 3
      Top = 3
      Width = 618
      Height = 20
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
    Left = 224
    Top = 248
    Data = (
      (
        'Component = bbCan'
        'Status = stsDefault')
      (
        'Component = bbOK'
        'Status = stsDefault')
      (
        'Component = ebLex'
        'Label = lblSearch'
        'Status = stsOK')
      (
        'Component = bbSearch'
        'Status = stsDefault')
      (
        'Component = frmPLLex'
        'Text = Lexicon Search Dialog'
        'Status = stsOK')
      (
        'Component = bbExtendedSearch'
        'Status = stsDefault')
      (
        'Component = bbFreetext'
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
        'Status = stsDefault'))
  end
end
