inherited frmImmunizations: TfrmImmunizations
  Left = 373
  Top = 169
  Caption = 'Encouner Immunization'
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lblReaction: TLabel [0]
    Left = 490
    Top = 274
    Width = 43
    Height = 13
    Caption = 'Reaction'
  end
  object lblSeries: TLabel [1]
    Left = 490
    Top = 236
    Width = 29
    Height = 13
    Caption = 'Series'
  end
  inherited lblSection: TLabel
    Width = 100
    Caption = 'Immunization Section'
    ExplicitWidth = 100
  end
  object lblContra: TLabel [6]
    Left = 509
    Top = 312
    Width = 74
    Height = 26
    Caption = 'Repeat Contraindicated'
    WordWrap = True
  end
  inherited btnOK: TBitBtn
    TabOrder = 8
  end
  inherited btnCancel: TBitBtn
    TabOrder = 9
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstRenameMe: TCaptionListView
      Columns = <
        item
          Caption = 'Series'
          Width = 80
        end
        item
          Caption = 'Reaction'
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Contra'
        end
        item
          Caption = 'Selected Immunizations'
          Width = 150
        end>
      Caption = 'Selected Immunizations'
      Pieces = '1,2,3,4'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object cboImmReaction: TORComboBox [11]
    Tag = 20
    Left = 490
    Top = 288
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Reaction'
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
    TabOrder = 5
    Text = ''
    OnChange = cboImmReactionChange
    CharsNeedMatch = 1
  end
  object cboImmSeries: TORComboBox [12]
    Tag = 10
    Left = 490
    Top = 250
    Width = 121
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Series'
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
    OnChange = cboImmSeriesChange
    CharsNeedMatch = 1
  end
  object ckbContra: TCheckBox [13]
    Left = 490
    Top = 319
    Width = 13
    Height = 13
    Enabled = False
    TabOrder = 6
    OnClick = ckbContraClick
    OnEnter = ckbContraEnter
    OnExit = ckbContraExit
  end
  inherited btnRemove: TButton
    TabOrder = 7
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  inherited pnlMain: TPanel
    TabOrder = 0
    inherited lbxSection: TORListBox
      Tag = 40
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 40
        TabOrder = 0
        Caption = 'Immunization Section'
      end
      inherited btnOther: TButton
        Tag = 20
        Caption = 'Other Immunization...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cboImmReaction'
        'Label = lblReaction'
        'Status = stsOK')
      (
        'Component = cboImmSeries'
        'Label = lblSeries'
        'Status = stsOK')
      (
        'Component = ckbContra'
        'Label = lblContra'
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
        'Component = frmImmunizations'
        'Status = stsDefault'))
  end
end
