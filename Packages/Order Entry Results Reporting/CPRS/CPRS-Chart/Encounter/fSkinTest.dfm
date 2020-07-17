inherited frmSkinTests: TfrmSkinTests
  Left = 213
  Top = 163
  Caption = 'Encounter Skin Test form'
  ClientWidth = 657
  ExplicitWidth = 673
  ExplicitHeight = 438
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
    Left = 497
    TabOrder = 8
    ExplicitLeft = 497
  end
  inherited btnCancel: TBitBtn
    Left = 577
    TabOrder = 9
    ExplicitLeft = 577
  end
  inherited pnlGrid: TPanel
    TabOrder = 1
    inherited lstCaptionList: TCaptionListView
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
      OnSelectItem = lstCaptionListSelectItem
      Caption = 'Selected Skin Tests'
      Pieces = '1,2,3'
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object edtDtRead: TCaptionEdit [12]
    Left = 104
    Top = 376
    Width = 97
    Height = 21
    TabOrder = 6
    Text = 'edtDtRead'
    Visible = False
    Caption = 'Date Read'
  end
  object edtDTGiven: TCaptionEdit [13]
    Left = 280
    Top = 376
    Width = 81
    Height = 21
    TabOrder = 7
    Text = 'edtDTGiven'
    Visible = False
    Caption = 'Date Given'
  end
  object cboSkinResults: TORComboBox [14]
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
    TabOrder = 5
  end
  inherited btnSelectAll: TButton
    TabOrder = 2
    TabStop = True
  end
  object cboReading: TComboBox [17]
    Left = 492
    Top = 309
    Width = 119
    Height = 21
    TabOrder = 13
    OnChange = cboReadingChange
    Items.Strings = (
      ''
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30'
      '31'
      '32'
      '33'
      '34'
      '35'
      '36'
      '37'
      '38'
      '39'
      '40'
      '41'
      '42'
      '43'
      '44'
      '45'
      '46'
      '47'
      '48'
      '49'
      '50')
  end
  inherited pnlMain: TPanel
    Width = 645
    TabOrder = 0
    ExplicitWidth = 645
    inherited lbxSection: TORListBox
      Tag = 50
      Width = 438
      ExplicitWidth = 438
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
        'Status = stsDefault')
      (
        'Component = cboReading'
        'Status = stsDefault'))
  end
end
