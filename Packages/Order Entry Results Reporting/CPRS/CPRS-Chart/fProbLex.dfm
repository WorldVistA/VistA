inherited frmPLLex: TfrmPLLex
  Left = 239
  Top = 88
  Caption = 'Problem List  Lexicon Search'
  ClientHeight = 299
  ClientWidth = 427
  Constraints.MinHeight = 332
  Constraints.MinWidth = 434
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = nil
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 443
  ExplicitHeight = 337
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDialog: TPanel [0]
    Left = 0
    Top = 0
    Width = 427
    Height = 273
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 427
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
        Width = 104
        Height = 13
        Align = alTop
        Caption = 'Enter Term to Search:'
      end
      object ebLex: TCaptionEdit
        AlignWithMargins = True
        Left = 12
        Top = 25
        Width = 321
        Height = 24
        Margins.Left = 0
        Align = alClient
        AutoSize = False
        Constraints.MinHeight = 21
        TabOrder = 0
        OnChange = ebLexChange
        OnKeyPress = ebLexKeyPress
        Caption = 'Enter Term to Search'
      end
      object bbSearch: TBitBtn
        AlignWithMargins = True
        Left = 339
        Top = 25
        Width = 76
        Height = 24
        Hint = 'Search Problem List Subset of SNOMED CT'
        Margins.Right = 0
        Align = alRight
        Caption = '&Search'
        TabOrder = 1
        OnClick = bbSearchClick
        NumGlyphs = 2
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 246
      Width = 427
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
        Left = 258
        Top = 3
        Width = 75
        Height = 21
        Hint = 'Accept selected term.'
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alRight
        Caption = '&OK'
        Enabled = False
        TabOrder = 0
        OnClick = bbOKClick
        NumGlyphs = 2
      end
      object bbCan: TBitBtn
        AlignWithMargins = True
        Left = 339
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
        TabOrder = 2
        OnClick = bbCanClick
        NumGlyphs = 2
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
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Visible = False
        OnClick = bbExtendedSearchClick
        NumGlyphs = 2
      end
      object bbFreetext: TBitBtn
        Left = 105
        Top = 3
        Width = 96
        Height = 21
        Caption = '&Freetext Problem'
        Enabled = False
        TabOrder = 3
        Visible = False
        OnClick = bbFreetextClick
      end
    end
    object pnlList: TPanel
      Left = 0
      Top = 55
      Width = 427
      Height = 191
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
        Width = 178
        Height = 13
        Align = alTop
        Caption = 'Select from one of the following items:'
      end
      object lvLex: TListView
        Left = 12
        Top = 22
        Width = 403
        Height = 166
        Align = alClient
        Columns = <
          item
            Caption = 'Problem'
            Width = 300
          end
          item
            Caption = 'Code'
          end
          item
            Caption = 'ICD-9-CM'
          end>
        ColumnClick = False
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowHint = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lvLexChange
        OnClick = lvLexClick
        OnCustomDrawItem = lvLexCustomDrawItem
        OnEnter = lvLexEnter
        OnExit = lvLexExit
        OnInfoTip = lvLexInfoTip
      end
    end
  end
  object pnlStatus: TPanel [1]
    Left = 0
    Top = 273
    Width = 427
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
      Width = 421
      Height = 20
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelKind = bkFlat
      BevelOuter = bvLowered
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
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = bbOK'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = ebLex'
        'Label = lblSearch'
        'Status = stsOK')
      (
        'Component = bbSearch'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = frmPLLex'
        'Text = Lexicon Search Dialog'
        'Status = stsOK')
      (
        'Component = bbExtendedSearch'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = lvLex'
        'Status = stsDefault')
      (
        'Component = bbFreetext'
        'Status = stsDefault'))
  end
end
