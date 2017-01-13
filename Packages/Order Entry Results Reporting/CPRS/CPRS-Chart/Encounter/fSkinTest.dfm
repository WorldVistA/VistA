inherited frmSkinTests: TfrmSkinTests
  Left = 213
  Top = 163
  Caption = 'Encounter Skin Test form'
  PixelsPerInch = 96
  TextHeight = 13
  object lblSkinResults: TLabel [0]
    Left = 490
    Top = 244
    Width = 35
    Height = 13
    Caption = 'Results'
  end
  object lblDTRead: TLabel [1]
    Left = 46
    Top = 380
    Width = 52
    Height = 13
    Caption = 'Date Read'
    Visible = False
  end
  object lblReading: TLabel [2]
    Left = 490
    Top = 290
    Width = 40
    Height = 13
    Caption = 'Reading'
  end
  object lblDTGiven: TLabel [3]
    Left = 216
    Top = 380
    Width = 54
    Height = 13
    Caption = 'Date Given'
    Visible = False
  end
  inherited lblSection: TLabel
    Width = 84
    Caption = 'Skin Test Section'
    ExplicitWidth = 84
  end
  inherited btnOK: TBitBtn
    TabOrder = 10
  end
  inherited btnCancel: TBitBtn
    TabOrder = 11
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstRenameMe: TCaptionListView
      Columns = <
        item
          Caption = 'Results'
          Width = 80
        end
        item
          Caption = 'Reading'
          Tag = 1
          Width = 120
        end
        item
          Caption = 'Selected Skin Tests'
          Width = 150
        end>
      Caption = 'Selected Skin Tests'
      Pieces = '1,2,3'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object UpDnReading: TUpDown [12]
    Left = 531
    Top = 304
    Width = 15
    Height = 21
    Associate = EdtReading
    Max = 40
    TabOrder = 6
    OnChanging = UpDnReadingChanging
  end
  object EdtReading: TCaptionEdit [13]
    Left = 490
    Top = 304
    Width = 41
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = '0'
    OnChange = EdtReadingChange
    Caption = 'Reading'
  end
  object edtDtRead: TCaptionEdit [14]
    Left = 104
    Top = 376
    Width = 97
    Height = 21
    TabOrder = 8
    Text = 'edtDtRead'
    Visible = False
    Caption = 'Date Read'
  end
  object edtDTGiven: TCaptionEdit [15]
    Left = 280
    Top = 376
    Width = 81
    Height = 21
    TabOrder = 9
    Text = 'edtDTGiven'
    Visible = False
    Caption = 'Date Given'
  end
  object cboSkinResults: TORComboBox [16]
    Tag = 30
    Left = 490
    Top = 260
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
    OnChange = cboSkinResultsChange
    CharsNeedMatch = 1
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
      Tag = 50
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 50
        TabOrder = 0
        Caption = 'Skin Test Section'
      end
      inherited btnOther: TButton
        Tag = 21
        Caption = 'Other Skin Test...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = UpDnReading'
        'Status = stsDefault')
      (
        'Component = EdtReading'
        'Label = lblReading'
        'Status = stsOK')
      (
        'Component = edtDtRead'
        'Label = lblDTRead'
        'Status = stsOK')
      (
        'Component = edtDTGiven'
        'Label = lblDTGiven'
        'Status = stsOK')
      (
        'Component = cboSkinResults'
        'Label = lblSkinResults'
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
        'Component = frmSkinTests'
        'Status = stsDefault'))
  end
end
