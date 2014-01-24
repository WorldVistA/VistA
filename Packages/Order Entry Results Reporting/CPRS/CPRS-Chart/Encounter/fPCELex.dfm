inherited frmPCELex: TfrmPCELex
  Left = 239
  Top = 88
  Caption = 'Lookup Other Diagnosis'
  ClientHeight = 299
  Constraints.MinHeight = 332
  Constraints.MinWidth = 434
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = nil
  OnKeyDown = nil
  OnResize = nil
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
    TabOrder = 0
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
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 258
        Top = 3
        Width = 75
        Height = 21
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
        Left = 339
        Top = 3
        Width = 76
        Height = 21
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
        Left = 12
        Top = 3
        Width = 84
        Height = 21
        Hint = 'Search ICD-9-CM Diagnoses...'
        Align = alLeft
        Caption = '&Extend Search'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        OnClick = cmdExtendedSearchClick
        NumGlyphs = 2
      end
    end
    object pnlSearch: TPanel
      Left = 0
      Top = 0
      Width = 427
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 55
      Padding.Left = 12
      Padding.Top = 3
      Padding.Right = 12
      Padding.Bottom = 3
      TabOrder = 0
      object lblSearch: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 6
        Width = 101
        Height = 13
        Align = alTop
        Caption = 'Search for Diagnosis:'
      end
      object txtSearch: TCaptionEdit
        AlignWithMargins = True
        Left = 12
        Top = 25
        Width = 321
        Height = 24
        Margins.Left = 0
        Align = alClient
        Constraints.MinHeight = 21
        TabOrder = 0
        OnChange = txtSearchChange
        Caption = 'Search for Diagnosis'
        ExplicitHeight = 21
      end
      object cmdSearch: TButton
        AlignWithMargins = True
        Left = 339
        Top = 25
        Width = 76
        Height = 24
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
      Top = 55
      Width = 427
      Height = 191
      Align = alClient
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
        Width = 397
        Height = 13
        Align = alTop
        Caption = 'Select from one of the following items:'
        Visible = False
        ExplicitWidth = 178
      end
      object lvLex: TListView
        Left = 12
        Top = 22
        Width = 403
        Height = 166
        Align = alClient
        Columns = <
          item
            Caption = 'Term'
            Width = 349
          end
          item
            Caption = 'Code System'
            Width = 0
          end
          item
            Caption = 'Code'
          end
          item
            Caption = 'ICD-9-CM'
            Width = 0
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
        OnDblClick = lvLexDblClick
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
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    TabOrder = 1
    object lblStatus: TVA508StaticText
      Name = 'lblStatus'
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
    Left = 112
    Top = 248
    Data = (
      (
        'Component = txtSearch'
        'Label = lblSearch'
        'Status = stsOK')
      (
        'Component = cmdSearch'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = cmdOK'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = cmdCancel'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = frmPCELex'
        'Text = Other Diagnosis search dialog'
        'Status = stsOK')
      (
        'Component = cmdExtendedSearch'
        'Property = Hint'
        'Status = stsOK')
      (
        'Component = lvLex'
        'Status = stsDefault')
      (
        'Component = lblStatus'
        'Status = stsDefault'))
  end
end
