inherited frmPatientEd: TfrmPatientEd
  Left = 275
  Top = 267
  Caption = 'Patient Education'
  PixelsPerInch = 96
  TextHeight = 13
  object lblUnderstanding: TLabel [0]
    Left = 490
    Top = 264
    Width = 112
    Height = 13
    Caption = 'Level Of Understanding'
  end
  inherited lblSection: TLabel
    Width = 123
    Caption = 'Patient Education Section'
    ExplicitWidth = 123
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
          Caption = 'Level of Understanding'
          Width = 150
        end
        item
          Caption = 'Selected Patient Educations'
          Tag = 1
          Width = 150
        end>
      Caption = 'Selected Patient Educations'
      Pieces = '1,2'
      ExplicitLeft = -2
      ExplicitTop = -3
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object cboPatUnderstanding: TORComboBox [9]
    Tag = 40
    Left = 490
    Top = 280
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Level Of Understanding'
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
    OnChange = cboPatUnderstandingChange
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
      Tag = 60
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 60
        TabOrder = 0
        Caption = 'Patient Education Section'
      end
      inherited btnOther: TButton
        Tag = 22
        Caption = 'Other Education Topic...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboPatUnderstanding'
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
        'Component = frmPatientEd'
        'Status = stsDefault'))
  end
end
