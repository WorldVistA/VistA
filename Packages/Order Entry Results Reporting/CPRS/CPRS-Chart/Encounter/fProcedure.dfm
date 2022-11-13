inherited frmProcedures: TfrmProcedures
  Left = 548
  Top = 172
  Caption = 'Encounter Procedure'
  ClientHeight = 466
  ClientWidth = 666
  ExplicitWidth = 682
  ExplicitHeight = 505
  PixelsPerInch = 120
  TextHeight = 13
  object lblProcQty: TLabel [0]
    Left = 300
    Top = 385
    Width = 39
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Caption = 'Quantity'
  end
  inherited lblSection: TLabel
    Width = 88
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Procedure Section'
    ExplicitWidth = 88
  end
  inherited lblList: TLabel
    Left = 193
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitLeft = 193
  end
  inherited lblComment: TLabel
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited bvlMain: TBevel
    Top = 371
    Width = 660
    Height = 44
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    ExplicitTop = 464
    ExplicitWidth = 660
    ExplicitHeight = 44
  end
  object lblMod: TLabel [5]
    Left = 448
    Top = 8
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
    Top = 382
    Width = 42
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Caption = 'Provider:'
  end
  inherited btnOK: TBitBtn
    Left = 468
    Top = 428
    Height = 29
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 8
    ExplicitLeft = 468
    ExplicitTop = 428
    ExplicitHeight = 29
  end
  inherited btnCancel: TBitBtn
    Left = 568
    Top = 428
    Height = 29
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 9
    ExplicitLeft = 568
    ExplicitTop = 428
    ExplicitHeight = 29
  end
  inherited pnlGrid: TPanel
    Width = 654
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 1
    ExplicitWidth = 654
    inherited lstCaptionList: TCaptionListView
      Width = 654
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
      ExplicitWidth = 654
    end
  end
  inherited edtComment: TCaptionEdit
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
  end
  object spnProcQty: TUpDown [11]
    Left = 435
    Top = 381
    Width = 19
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Associate = txtProcQty
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 5
    ExplicitTop = 464
  end
  object txtProcQty: TCaptionEdit [12]
    Left = 360
    Top = 381
    Width = 75
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Enabled = False
    TabOrder = 4
    Text = '1'
    OnChange = txtProcQtyChange
    Caption = 'Quantity'
    ExplicitTop = 464
  end
  object cboProvider: TORComboBox [13]
    Left = 70
    Top = 381
    Width = 221
    Height = 21
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
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
    ExplicitTop = 464
  end
  inherited btnRemove: TButton
    Left = 568
    Top = 381
    Height = 26
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    TabOrder = 7
    ExplicitLeft = 568
    ExplicitTop = 383
    ExplicitHeight = 26
  end
  inherited btnSelectAll: TButton
    Left = 468
    Top = 381
    Height = 26
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    TabStop = True
    ExplicitLeft = 468
    ExplicitTop = 464
    ExplicitHeight = 26
  end
  inherited pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 208
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 666
    ExplicitHeight = 208
    inherited splLeft: TSplitter
      Left = 181
      Height = 208
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 181
      ExplicitHeight = 208
    end
    object splRight: TSplitter [1]
      Left = 338
      Top = 0
      Height = 208
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
      Width = 154
      Height = 208
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Pieces = '2,3'
      ExplicitLeft = 184
      ExplicitWidth = 100
      ExplicitHeight = 208
    end
    inherited pnlLeft: TPanel
      Width = 181
      Height = 208
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitWidth = 181
      ExplicitHeight = 208
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
        Left = 4
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Other Procedure...'
        TabOrder = 1
        ExplicitLeft = 4
      end
    end
    object lbMods: TORListBox
      Left = 341
      Top = 0
      Width = 325
      Height = 208
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
      ExplicitLeft = 287
      ExplicitHeight = 204
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
