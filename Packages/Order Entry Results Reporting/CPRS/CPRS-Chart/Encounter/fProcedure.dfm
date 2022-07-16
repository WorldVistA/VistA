inherited frmProcedures: TfrmProcedures
  Left = 548
  Top = 172
  Caption = 'Encounter Procedure'
  ClientWidth = 657
  ExplicitWidth = 673
  PixelsPerInch = 120
  TextHeight = 13
  inherited bvlMain: TBevel [0]
    Left = 2
    Top = 229
    Width = 651
    Height = 178
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitLeft = 2
    ExplicitTop = 229
    ExplicitWidth = 651
    ExplicitHeight = 178
  end
  object lblProcQty: TLabel [1]
    Left = 371
    Top = 380
    Width = 39
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Quantity'
  end
  inherited lblSection: TLabel [2]
    Width = 88
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Procedure Section'
    ExplicitWidth = 88
  end
  inherited lblList: TLabel [3]
    Left = 193
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitLeft = 193
  end
  inherited lblComment: TLabel [4]
    Top = 331
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 331
  end
  object lblMod: TLabel [5]
    Left = 328
    Top = 6
    Width = 42
    Height = 13
    Hint = 'Modifiers'
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Modifiers'
    ParentShowHint = False
    ShowHint = True
  end
  object lblProvider: TLabel [6]
    Left = 8
    Top = 379
    Width = 42
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Provider:'
  end
  inherited btnOK: TBitBtn
    Left = 493
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 8
    ExplicitLeft = 493
  end
  inherited btnCancel: TBitBtn
    Left = 578
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 9
    ExplicitLeft = 578
  end
  inherited pnlGrid: TPanel
    Width = 646
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 1
    ExplicitWidth = 646
    inherited lstCaptionList: TCaptionListView
      Width = 646
      Margins.Left = 16
      Margins.Top = 6
      Margins.Right = 16
      Margins.Bottom = 6
      Columns = <
        item
          Caption = 'Quantity'
          Width = 100
        end
        item
          Caption = 'Selected Procedures'
          Width = 150
        end>
      Caption = 'Selected Procedures'
      Pieces = '1,2'
      ExplicitWidth = 646
    end
  end
  inherited edtComment: TCaptionEdit
    Top = 346
    Width = 561
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
    ExplicitTop = 346
    ExplicitWidth = 561
  end
  object spnProcQty: TUpDown [11]
    Left = 464
    Top = 376
    Width = 14
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Associate = txtProcQty
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 5
  end
  object txtProcQty: TCaptionEdit [12]
    Left = 417
    Top = 376
    Width = 47
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Enabled = False
    TabOrder = 4
    Text = '1'
    OnChange = txtProcQtyChange
    Caption = 'Quantity'
  end
  object cboProvider: TORComboBox [13]
    Left = 58
    Top = 376
    Width = 305
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Provider'
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
    TabOrder = 3
    TabStop = True
    Text = ''
    OnChange = cboProviderChange
    OnExit = cboProviderExit
    OnNeedData = cboProviderNeedData
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    Left = 578
    Top = 348
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 7
    ExplicitLeft = 578
    ExplicitTop = 348
  end
  inherited btnSelectAll: TButton
    Left = 578
    Top = 325
    Height = 21
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 6
    TabStop = True
    ExplicitLeft = 578
    ExplicitTop = 325
    ExplicitHeight = 21
  end
  inherited pnlMain: TPanel
    Width = 645
    Height = 207
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 0
    ExplicitWidth = 645
    ExplicitHeight = 207
    inherited splLeft: TSplitter
      Left = 181
      Height = 207
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 181
      ExplicitHeight = 207
    end
    object splRight: TSplitter [1]
      Left = 317
      Top = 0
      Height = 207
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      OnMoved = splRightMoved
      ExplicitLeft = 628
      ExplicitHeight = 319
    end
    inherited lbxSection: TORListBox
      Tag = 30
      Left = 184
      Width = 133
      Height = 207
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Pieces = '2,3'
      ExplicitLeft = 184
      ExplicitWidth = 133
      ExplicitHeight = 207
    end
    inherited pnlLeft: TPanel
      Width = 181
      Height = 207
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitWidth = 181
      ExplicitHeight = 207
      inherited lbSection: TORListBox
        Tag = 30
        Width = 181
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 0
        ExplicitWidth = 181
      end
      inherited btnOther: TButton
        Tag = 13
        Left = 42
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Other Procedure...'
        TabOrder = 1
        ExplicitLeft = 42
      end
    end
    object lbMods: TORListBox
      Left = 320
      Top = 0
      Width = 325
      Height = 207
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = lbOwnerDrawFixed
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnExit = lbModsExit
      Caption = 'Modifiers'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2,3'
      TabPosInPixels = True
      CheckBoxes = True
      CheckEntireLine = True
      OnClickCheck = lbModsClickCheck
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lbMods'
        'Label = lblMod'
        'Status = stsOK')
      (
        'Component = spnProcQty'
        'Status = stsDefault')
      (
        'Component = txtProcQty'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Status = stsDefault')
      (
        'Component = edtComment'
        'Label = lblComment'
        'Status = stsOK')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnSelectAll'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lbxSection'
        'Label = lblList'
        'Status = stsOK')
      (
        'Component = pnlLeft'
        'Status = stsDefault')
      (
        'Component = lbSection'
        'Label = lblSection'
        'Status = stsOK')
      (
        'Component = btnOther'
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
        'Component = frmProcedures'
        'Status = stsDefault'))
  end
end
