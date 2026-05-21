inherited frmAddlSigners: TfrmAddlSigners
  Left = 275
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Identify Additional Signers'
  ClientHeight = 388
  ClientWidth = 520
  Position = poScreenCenter
  ExplicitWidth = 532
  ExplicitHeight = 392
  TextHeight = 13
  object pnlBase: TPanel [0]
    Left = 0
    Top = 0
    Width = 520
    Height = 388
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 516
    ExplicitHeight = 353
    object pnlButtons: TORAutoPanel
      Left = 0
      Top = 353
      Width = 520
      Height = 35
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 318
      ExplicitWidth = 516
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 356
        Top = 3
        Width = 75
        Height = 29
        Align = alRight
        Caption = '&OK'
        TabOrder = 0
        OnClick = cmdOKClick
        ExplicitLeft = 352
      end
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 437
        Top = 3
        Width = 75
        Height = 29
        Margins.Right = 8
        Align = alRight
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 1
        OnClick = cmdCancelClick
        ExplicitLeft = 433
      end
    end
    object pnlAdditional: TORAutoPanel
      Left = 0
      Top = 99
      Width = 520
      Height = 254
      Align = alClient
      TabOrder = 1
      ExplicitTop = 77
      ExplicitWidth = 516
      ExplicitHeight = 241
      object SrcLabel: TLabel
        Left = 8
        Top = 6
        Width = 153
        Height = 13
        Caption = 'Select or enter additional signers'
      end
      object DstLabel: TLabel
        Left = 299
        Top = 6
        Width = 118
        Height = 13
        Caption = 'Current additional signers'
      end
      object cboSrcList: TORCheckComboBox
        AlignWithMargins = True
        Left = 8
        Top = 25
        Width = 202
        Height = 216
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Select or enter additional signers'
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
        TabOrder = 0
        TabStop = True
        Text = ''
        OnChange = cboSrcListChange
        OnDblClick = btnAddSignersClick
        OnKeyDown = cboSrcListKeyDown
        OnNeedData = NewPersonNeedData
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        MainCheckBoxCaption = 'Include Non-VA Providers'
        MainCheckBoxVisible = True
        MainCheckBoxAlignment = calBottom
        OnMainCheckboxClick = cboSrcListMainCheckboxClick
        DropdownStyle = ddsControl
      end
      object DstList: TORListBox
        AlignWithMargins = True
        Left = 299
        Top = 21
        Width = 216
        Height = 220
        ItemHeight = 13
        MultiSelect = True
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 1
        OnClick = DstListChange
        OnDblClick = btnRemoveSignersClick
        Caption = 'Current additional signers'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
        OnChange = DstListChange
      end
      object btnRemoveSigners: TButton
        Left = 216
        Top = 108
        Width = 77
        Height = 25
        Caption = '&Remove'
        Enabled = False
        TabOrder = 3
        OnClick = btnRemoveSignersClick
      end
      object btnAddSigners: TButton
        Left = 216
        Top = 77
        Width = 76
        Height = 25
        Caption = '&Add'
        Enabled = False
        TabOrder = 2
        OnClick = btnAddSignersClick
      end
      object btnRemoveAllSigners: TButton
        Left = 216
        Top = 139
        Width = 77
        Height = 25
        Caption = 'R&emove All'
        Enabled = False
        TabOrder = 5
        OnClick = btnRemoveAllSignersClick
      end
    end
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 520
      Height = 99
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      Padding.Top = 6
      Padding.Bottom = 8
      TabOrder = 0
      DesignSize = (
        520
        93)
      object lblAuthor: TLabel
        Left = 8
        Top = 36
        Width = 95
        Height = 13
        Caption = 'Author (not editable)'
        Transparent = False
      end
      object lblCosigner: TLabel
        Left = 299
        Top = 36
        Width = 168
        Height = 13
        Caption = 'Expected Cosigner (not editable)     '
        Transparent = False
      end
      object txtAuthor: TCaptionEdit
        Left = 8
        Top = 51
        Width = 180
        Height = 21
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        Color = clCream
        ReadOnly = True
        TabOrder = 0
        Caption = 'Author (not editable)'
      end
      object cboCosigner: TORCheckComboBox
        Left = 299
        Top = 51
        Width = 194
        Height = 40
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'object lblCosigner: TOROffsetLabel'
        Color = clCream
        DropDownCount = 8
        Enabled = False
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = True
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2,3'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 1
        TabStop = True
        Text = ''
        OnChange = cboCosignerChange
        OnExit = cboCosignerExit
        OnNeedData = cboCosignerNeedData
        CharsNeedMatch = 1
        MainCheckBoxCaption = 'Include Non-VA Providers'
        MainCheckBoxVisible = True
        MainCheckBoxAlignment = calBottom
        OnMainCheckboxClick = cboCosignerMainCheckboxClick
        DropdownStyle = ddsControl
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 112
    Top = 80
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlAdditional'
        'Status = stsDefault')
      (
        'Component = cboSrcList'
        'Status = stsDefault')
      (
        'Component = DstList'
        'Status = stsDefault')
      (
        'Component = btnRemoveSigners'
        'Status = stsDefault')
      (
        'Component = btnAddSigners'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = frmAddlSigners'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllSigners'
        'Status = stsDefault')
      (
        'Component = txtAuthor'
        'Status = stsDefault')
      (
        'Component = cboCosigner'
        'Status = stsDefault'))
  end
end
