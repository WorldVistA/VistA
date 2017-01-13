inherited frmHealthFactors: TfrmHealthFactors
  Left = 374
  Top = 205
  Caption = 'Health Factor page'
  PixelsPerInch = 96
  TextHeight = 13
  object lblHealthLevel: TLabel [0]
    Left = 490
    Top = 264
    Width = 69
    Height = 13
    Caption = 'Level/Severity'
  end
  inherited lblSection: TLabel
    Width = 103
    Caption = 'Health Factor Section'
    ExplicitWidth = 103
  end
  inherited btnOK: TBitBtn
    TabOrder = 6
  end
  inherited btnCancel: TBitBtn
    TabOrder = 7
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstRenameMe: TCaptionListView
      Columns = <
        item
          Caption = 'Level/Severity'
          Width = 140
        end
        item
          Caption = 'Selected Health Factors'
          Tag = 1
          Width = 150
        end>
      Caption = 'Selected Health Factors'
      Pieces = '1,2'
      ExplicitLeft = -2
      ExplicitTop = -3
    end
  end
  inherited edtComment: TCaptionEdit
    MaxLength = 245
    TabOrder = 3
  end
  object cboHealthLevel: TORComboBox [9]
    Tag = 50
    Left = 490
    Top = 280
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Level/Severity'
    Color = clWindow
    DropDownCount = 8
    Enabled = False
    ItemHeight = 13
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
    Text = ''
    OnChange = cboHealthLevelChange
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    TabOrder = 5
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  inherited pnlMain: TPanel
    TabOrder = 0
    inherited lbxSection: TORListBox
      Tag = 70
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 70
        TabOrder = 0
        Caption = 'Health Factor Section'
      end
      inherited btnOther: TButton
        Tag = 23
        Caption = 'Other Health Factor...'
        TabOrder = 1
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
        'Status = stsDefault'))
  end
end
