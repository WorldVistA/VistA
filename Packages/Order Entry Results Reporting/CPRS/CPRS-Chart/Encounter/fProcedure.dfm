inherited frmProcedures: TfrmProcedures
  Left = 548
  Top = 172
  Caption = 'Encounter Procedure'
  PixelsPerInch = 96
  TextHeight = 13
  object lblProcQty: TLabel [0]
    Left = 240
    Top = 375
    Width = 39
    Height = 13
    Caption = 'Quantity'
  end
  inherited lblSection: TLabel
    Width = 88
    Caption = 'Procedure Section'
    ExplicitWidth = 88
  end
  inherited lblList: TLabel
    Left = 154
    ExplicitLeft = 154
  end
  inherited bvlMain: TBevel
    Top = 232
    Width = 537
    Height = 166
    ExplicitTop = 232
    ExplicitWidth = 537
    ExplicitHeight = 166
  end
  object lblMod: TLabel [5]
    Left = 358
    Top = 6
    Width = 42
    Height = 13
    Hint = 'Modifiers'
    Caption = 'Modifiers'
    ParentShowHint = False
    ShowHint = True
  end
  object lblProvider: TLabel [6]
    Left = 6
    Top = 376
    Width = 42
    Height = 13
    Caption = 'Provider:'
  end
  inherited btnOK: TBitBtn
    Left = 544
    Top = 344
    TabOrder = 8
    ExplicitLeft = 544
    ExplicitTop = 344
  end
  inherited btnCancel: TBitBtn
    Top = 371
    TabOrder = 9
    ExplicitTop = 371
  end
  inherited pnlGrid: TPanel
    Width = 523
    TabOrder = 1
    ExplicitWidth = 523
    inherited lstRenameMe: TCaptionListView
      Width = 523
      Columns = <
        item
          Caption = 'Quantity'
          Width = 80
        end
        item
          Caption = 'Selected Procedures'
          Width = 120
        end>
      Caption = 'Selected Procedures'
      Pieces = '1,2'
      ExplicitWidth = 523
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 2
  end
  object spnProcQty: TUpDown [11]
    Left = 348
    Top = 371
    Width = 15
    Height = 21
    Associate = txtProcQty
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 5
  end
  object txtProcQty: TCaptionEdit [12]
    Left = 288
    Top = 371
    Width = 60
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '1'
    OnChange = txtProcQtyChange
    Caption = 'Quantity'
  end
  object cboProvider: TORComboBox [13]
    Left = 56
    Top = 371
    Width = 177
    Height = 21
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
    OnNeedData = cboProviderNeedData
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    Left = 454
    Top = 371
    TabOrder = 7
    ExplicitLeft = 454
    ExplicitTop = 371
  end
  inherited btnSelectAll: TButton
    Left = 374
    Top = 371
    Height = 21
    TabOrder = 6
    TabStop = True
    ExplicitLeft = 374
    ExplicitTop = 371
    ExplicitHeight = 21
  end
  inherited pnlMain: TPanel
    TabOrder = 0
    inherited splLeft: TSplitter
      Left = 145
      ExplicitLeft = 145
    end
    object splRight: TSplitter [1]
      Left = 349
      Top = 0
      Height = 204
      Align = alRight
      OnMoved = splRightMoved
    end
    inherited lbxSection: TORListBox
      Tag = 30
      Left = 148
      Width = 201
      ItemHeight = 14
      Pieces = '2,3'
      ExplicitLeft = 148
      ExplicitWidth = 201
    end
    inherited pnlLeft: TPanel
      Width = 145
      ExplicitWidth = 145
      inherited lbSection: TORListBox
        Tag = 30
        Width = 145
        TabOrder = 0
        ExplicitWidth = 145
      end
      inherited btnOther: TButton
        Tag = 13
        Left = 3
        Caption = 'Other Procedure...'
        TabOrder = 1
        ExplicitLeft = 3
      end
    end
    object lbMods: TORListBox
      Left = 352
      Top = 0
      Width = 260
      Height = 204
      Style = lbOwnerDrawFixed
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 14
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
