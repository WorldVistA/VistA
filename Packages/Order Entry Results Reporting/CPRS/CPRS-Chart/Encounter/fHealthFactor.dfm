inherited frmHealthFactors: TfrmHealthFactors
  Left = 374
  Top = 205
  Caption = 'Health Factor page'
  ClientHeight = 460
  ClientWidth = 648
  ExplicitWidth = 666
  ExplicitHeight = 505
  PixelsPerInch = 120
  TextHeight = 16
  object lblHealthLevel: TLabel [0]
    Left = 9
    Top = 340
    Width = 88
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Level/Severity'
  end
  inherited lblSection: TLabel
    Width = 128
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Health Factor Section'
    ExplicitWidth = 128
  end
  inherited lblList: TLabel
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited lblComment: TLabel
    Left = 8
    Top = 379
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 8
    ExplicitTop = 379
  end
  inherited bvlMain: TBevel
    Left = -3
    Top = 223
    Width = 641
    Height = 205
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitLeft = -3
    ExplicitTop = 223
    ExplicitWidth = 641
    ExplicitHeight = 205
  end
  object lblMag: TLabel [5]
    Left = 173
    Top = 340
    Width = 66
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Magnitude:'
    Visible = False
  end
  object lblUCUM: TLabel [6]
    Left = 269
    Top = 340
    Width = 253
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Unified Code for Units of Measure  (UCUM)'
    Visible = False
  end
  object lblUCUM2: TLabel [7]
    Left = 269
    Top = 361
    Width = 61
    Height = 16
    Caption = 'lblUCUM2'
    Visible = False
  end
  inherited btnOK: TBitBtn
    Left = 477
    Top = 436
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 7
    ExplicitLeft = 477
    ExplicitTop = 436
  end
  inherited btnCancel: TBitBtn
    Left = 568
    Top = 436
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    TabOrder = 8
    ExplicitLeft = 568
    ExplicitTop = 436
  end
  inherited pnlGrid: TPanel
    Width = 627
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 1
    ExplicitWidth = 627
    inherited lstCaptionList: TCaptionListView
      Width = 627
      Margins.Left = 16
      Margins.Top = 6
      Margins.Right = 16
      Margins.Bottom = 6
      Columns = <
        item
          Caption = 'Level/Severity'
          Width = 150
        end
        item
          Caption = 'Selected Health Factors'
          Tag = 1
          Width = 300
        end>
      Caption = 'Selected Health Factors'
      Pieces = '1,2'
      ExplicitWidth = 627
    end
  end
  inherited edtComment: TCaptionEdit
    Top = 398
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    MaxLength = 245
    TabOrder = 3
    ExplicitTop = 398
  end
  object cboHealthLevel: TORComboBox [12]
    Tag = 50
    Left = 9
    Top = 358
    Width = 151
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Level/Severity'
    Color = clWindow
    DropDownCount = 8
    Enabled = False
    ItemHeight = 16
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 4
    TabStop = True
    Text = ''
    OnChange = cboHealthLevelChange
    CharsNeedMatch = 1
  end
  object edtMag: TCaptionEdit [13]
    Left = 173
    Top = 358
    Width = 80
    Height = 24
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Visible = False
    OnChange = edtMagChange
    OnExit = edtMagExit
    OnKeyPress = edtMagKeyPress
    Caption = '0'
  end
  inherited btnRemove: TButton
    Top = 398
    Height = 23
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    ExplicitTop = 398
    ExplicitHeight = 23
  end
  inherited btnSelectAll: TButton
    Left = 558
    Top = 327
    Height = 23
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 558
    ExplicitTop = 327
    ExplicitHeight = 23
  end
  inherited pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 213
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 648
    ExplicitHeight = 213
    inherited splLeft: TSplitter
      Height = 213
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitHeight = 213
    end
    inherited lbxSection: TORListBox
      Tag = 70
      Width = 441
      Height = 213
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitWidth = 441
      ExplicitHeight = 213
    end
    inherited pnlLeft: TPanel
      Height = 213
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitHeight = 213
      inherited lbSection: TORListBox
        Tag = 70
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        TabOrder = 0
        Caption = 'Health Factor Section'
      end
      inherited btnOther: TButton
        Tag = 23
        Left = 58
        Top = 184
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Other Health Factor...'
        TabOrder = 1
        ExplicitLeft = 58
        ExplicitTop = 184
        ExplicitHeight = 23
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboHealthLevel'
        'Label = lblHealthLevel'
        'Status = stsOK')
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
        'Component = frmHealthFactors'
        'Status = stsDefault')
      (
        'Component = edtMag'
        'Status = stsDefault'))
  end
end
