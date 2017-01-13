inherited frmExams: TfrmExams
  Left = 509
  Top = 223
  Caption = 'Encounter Examinations'
  PixelsPerInch = 96
  TextHeight = 13
  object lblExamResults: TLabel [0]
    Left = 490
    Top = 264
    Width = 35
    Height = 13
    Caption = 'Results'
  end
  inherited lblSection: TLabel
    Width = 65
    Caption = 'Exam Section'
    ExplicitWidth = 65
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
          Caption = 'Results'
          Width = 100
        end
        item
          Caption = 'Selected Exams'
          Tag = 1
          Width = 120
        end>
      Caption = 'Exams'
      Pieces = '1,2'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object cboExamResults: TORComboBox [9]
    Tag = 60
    Left = 490
    Top = 280
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Results'
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
    OnChange = cboExamResultsChange
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
      Tag = 80
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        TabOrder = 0
        Caption = 'Exam Section'
      end
      inherited btnOther: TButton
        Tag = 24
        Caption = 'Other Exam...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboExamResults'
        'Label = lblExamResults'
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
        'Component = frmExams'
        'Status = stsDefault'))
  end
end
