inherited frmPatientEd: TfrmPatientEd
  Left = 275
  Top = 267
  Caption = 'Patient Education'
  ClientHeight = 448
  ExplicitHeight = 493
  PixelsPerInch = 96
  TextHeight = 16
  object lblUnderstanding: TLabel [0]
    Left = 8
    Top = 331
    Width = 140
    Height = 16
    Caption = 'Level Of Understanding'
  end
  inherited lblSection: TLabel
    Width = 152
    Caption = 'Patient Education Section'
    ExplicitWidth = 152
  end
  inherited lblComment: TLabel
    Left = 8
    Top = 377
    ExplicitLeft = 8
    ExplicitTop = 377
  end
  inherited bvlMain: TBevel
    Width = 616
    Height = 192
    ExplicitWidth = 616
    ExplicitHeight = 192
  end
  object lblUCUM2: TLabel [5]
    Left = 269
    Top = 351
    Width = 61
    Height = 16
    Caption = 'lblUCUM2'
    Visible = False
  end
  object lblUCUM: TLabel [6]
    Left = 269
    Top = 331
    Width = 253
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Unified Code for Units of Measure  (UCUM)'
    Visible = False
  end
  object lblMag: TLabel [7]
    Left = 173
    Top = 331
    Width = 66
    Height = 16
    Anchors = [akRight, akBottom]
    Caption = 'Magnitude:'
    Visible = False
  end
  inherited btnOK: TBitBtn
    Top = 424
    TabOrder = 7
  end
  inherited btnCancel: TBitBtn
    Top = 424
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
          Caption = 'Level of Understanding'
          Width = 150
        end
        item
          Caption = 'Selected Patient Educations'
          Tag = 1
          Width = 300
        end>
      Caption = 'Selected Patient Educations'
      Pieces = '1,2'
      ExplicitLeft = 2
      ExplicitTop = 20
      ExplicitWidth = 610
    end
  end
  inherited edtComment: TCaptionEdit
    Left = 8
    Top = 394
    ExplicitLeft = 8
    ExplicitTop = 394
  end
  object cboPatUnderstanding: TORComboBox [12]
    Tag = 40
    Left = 8
    Top = 348
    Width = 140
    Height = 24
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Level Of Understanding'
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
    OnChange = cboPatUnderstandingChange
    CharsNeedMatch = 1
  end
  inherited btnRemove: TButton
    Left = 538
    Top = 394
    TabOrder = 6
    ExplicitLeft = 538
    ExplicitTop = 394
  end
  inherited btnSelectAll: TButton
    Left = 541
    Top = 327
    Height = 21
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 541
    ExplicitTop = 327
    ExplicitHeight = 21
  end
  inherited pnlMain: TPanel
    Height = 212
    TabOrder = 0
    ExplicitHeight = 212
    inherited splLeft: TSplitter
      Height = 212
    end
    inherited lbxSection: TORListBox
      Tag = 60
      Height = 212
    end
    inherited pnlLeft: TPanel
      Height = 212
      inherited lbSection: TORListBox
        Tag = 60
        TabOrder = 0
        Caption = 'Patient Education Section'
      end
      inherited btnOther: TButton
        Tag = 22
        Left = 48
        Width = 156
        Caption = 'Other Education Topic...'
        TabOrder = 1
        ExplicitLeft = 48
        ExplicitWidth = 156
      end
    end
  end
  object edtMag: TCaptionEdit [16]
    Left = 173
    Top = 348
    Width = 80
    Height = 24
    Anchors = [akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Visible = False
    OnChange = edtMagChange
    OnExit = edtMagExit
    OnKeyPress = edtMagKeyPress
    Caption = '0'
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
        'Status = stsDefault')
      (
        'Component = edtMag'
        'Status = stsDefault'))
  end
end
