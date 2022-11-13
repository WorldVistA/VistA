inherited frmExams: TfrmExams
  Left = 509
  Top = 223
  Caption = 'Encounter Examinations'
  ClientHeight = 458
  ExplicitHeight = 503
  PixelsPerInch = 96
  TextHeight = 16
  object lblExamResults: TLabel [0]
    Left = 8
    Top = 334
    Width = 45
    Height = 16
    Caption = 'Results'
  end
  inherited lblSection: TLabel
    Width = 82
    Caption = 'Exam Section'
    ExplicitWidth = 82
  end
  inherited lblComment: TLabel
    Left = 8
    Top = 376
    ExplicitLeft = 8
    ExplicitTop = 376
  end
  inherited bvlMain: TBevel
    Height = 194
    ExplicitHeight = 194
  end
  object lblUCUM2: TLabel [5]
    Left = 253
    Top = 352
    Width = 61
    Height = 16
    Caption = 'lblUCUM2'
    Visible = False
  end
  object lblUCUM: TLabel [6]
    Left = 253
    Top = 331
    Width = 253
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Unified Code for Units of Measure  (UCUM)'
    Visible = False
  end
  object lblMag: TLabel [7]
    Left = 157
    Top = 331
    Width = 66
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Magnitude:'
    Visible = False
  end
  inherited btnOK: TBitBtn
    Top = 434
    TabOrder = 7
  end
  inherited btnCancel: TBitBtn
    Top = 434
    TabOrder = 8
  end
  inherited pnlGrid: TPanel
    Width = 610
    TabOrder = 1
    ExplicitWidth = 610
    inherited lstCaptionList: TCaptionListView
      Width = 610
      Columns = <
        item
          Caption = 'Results'
          Width = 100
        end
        item
          Caption = 'Selected Exams'
          Tag = 1
          Width = 300
        end>
      Caption = 'Exams'
      Pieces = '1,2'
      ExplicitWidth = 433
    end
  end
  inherited edtComment: TCaptionEdit
    Left = 8
    Top = 391
    TabOrder = 4
    ExplicitLeft = 8
    ExplicitTop = 391
  end
  object cboExamResults: TORComboBox [12]
    Tag = 60
    Left = 8
    Top = 349
    Width = 121
    Height = 24
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Results'
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
    TabOrder = 3
    Text = ''
    OnChange = cboExamResultsChange
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    Left = 541
    Top = 393
    TabOrder = 6
    ExplicitLeft = 541
    ExplicitTop = 393
  end
  inherited btnSelectAll: TButton
    Left = 541
    Top = 331
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 541
    ExplicitTop = 331
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
  object edtMag: TCaptionEdit [16]
    Left = 157
    Top = 349
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
        'Status = stsDefault')
      (
        'Component = edtMag'
        'Status = stsDefault'))
  end
end
