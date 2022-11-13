inherited frmAddlSigners: TfrmAddlSigners
  Left = 275
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Identify Additional Signers'
  ClientHeight = 359
  ClientWidth = 524
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 530
  ExplicitHeight = 388
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TPanel [0]
    Left = 0
    Top = 0
    Width = 524
    Height = 359
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlButtons: TORAutoPanel
      Left = 0
      Top = 324
      Width = 524
      Height = 35
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object cmdOK: TButton
        AlignWithMargins = True
        Left = 360
        Top = 3
        Width = 75
        Height = 29
        Align = alRight
        Caption = '&OK'
        TabOrder = 0
        OnClick = cmdOKClick
      end
      object cmdCancel: TButton
        AlignWithMargins = True
        Left = 441
        Top = 3
        Width = 75
        Height = 29
        Margins.Right = 8
        Align = alRight
        Cancel = True
        Caption = '&Cancel'
        TabOrder = 1
        OnClick = cmdCancelClick
      end
    end
    object pnlAdditional: TORAutoPanel
      Left = 0
      Top = 70
      Width = 524
      Height = 254
      Align = alClient
      TabOrder = 1
      object SrcLabel: TLabel
        Left = 11
        Top = 15
        Width = 202
        Height = 16
        AutoSize = False
        Caption = 'Select or enter additional signers'
      end
      object DstLabel: TLabel
        Left = 298
        Top = 15
        Width = 170
        Height = 16
        AutoSize = False
        Caption = 'Current additional signers'
      end
      object cboSrcList: TORComboBox
        Left = 11
        Top = 37
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
      end
      object DstList: TORListBox
        Left = 299
        Top = 37
        Width = 216
        Height = 204
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
    object pnlTop: TORAutoPanel
      Left = 0
      Top = 0
      Width = 524
      Height = 70
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblAuthor: TOROffsetLabel
        Left = 11
        Top = 6
        Width = 134
        Height = 31
        Caption = 'Author (not editable)'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object lblCosigner: TOROffsetLabel
        Left = 298
        Top = 6
        Width = 208
        Height = 28
        Caption = 'Expected Cosigner (not editable)     '
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object cboCosigner: TORComboBox
        Left = 298
        Top = 40
        Width = 216
        Height = 21
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
      end
      object txtAuthor: TCaptionEdit
        Left = 11
        Top = 43
        Width = 202
        Height = 21
        TabStop = False
        AutoSize = False
        Color = clCream
        ReadOnly = True
        TabOrder = 0
        Caption = 'Author (not editable)'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 224
    Top = 16
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
        'Component = cboCosigner'
        'Status = stsDefault')
      (
        'Component = txtAuthor'
        'Status = stsDefault')
      (
        'Component = frmAddlSigners'
        'Status = stsDefault')
      (
        'Component = btnRemoveAllSigners'
        'Status = stsDefault'))
  end
end
