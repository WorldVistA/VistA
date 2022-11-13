inherited frmDiagnoses: TfrmDiagnoses
  Left = 304
  Top = 169
  AutoScroll = True
  Caption = 'Encounter Diagnoses'
  ExplicitWidth = 640
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 16
  inherited lblSection: TLabel
    Width = 114
    Caption = 'Diagnoses Section'
    ExplicitWidth = 114
  end
  inherited btnOK: TBitBtn
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 7
  end
  inherited btnCancel: TBitBtn
    Left = 539
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    TabOrder = 8
    ExplicitLeft = 539
  end
  inherited pnlGrid: TPanel
    Width = 523
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    ExplicitWidth = 523
    inherited lstCaptionList: TCaptionListView
      Width = 523
      Columns = <
        item
          Caption = 'Add to PL'
          Width = 80
        end
        item
          Caption = 'Primary'
          Width = 120
        end
        item
          Caption = 'Selected Diagnoses'
          Width = 150
        end>
      Pieces = '1,2,3'
      ExplicitWidth = 523
    end
  end
  inherited edtComment: TCaptionEdit
    Top = 345
    Height = 24
    TabOrder = 3
    ExplicitTop = 345
    ExplicitHeight = 24
  end
  object cmdDiagPrimary: TButton [8]
    Left = 541
    Top = 306
    Width = 75
    Height = 21
    Caption = 'Primary'
    Enabled = False
    TabOrder = 5
    OnClick = cmdDiagPrimaryClick
  end
  object ckbDiagProb: TCheckBox [9]
    Left = 537
    Top = 238
    Width = 76
    Height = 62
    Caption = 'Add to Problem list'
    TabOrder = 4
    WordWrap = True
    OnClick = ckbDiagProbClicked
  end
  inherited btnRemove: TButton
    Left = 540
    Top = 345
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 6
    ExplicitLeft = 540
    ExplicitTop = 345
  end
  inherited btnSelectAll: TButton
    Left = 454
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 454
  end
  inherited pnlMain: TPanel
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    inherited splLeft: TSplitter
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    inherited lbxSection: TORListBox
      Tag = 20
      Height = 196
      IntegralHeight = True
      OnDrawItem = lbxSectionDrawItem
      Pieces = '2,3'
      ExplicitHeight = 196
    end
    inherited pnlLeft: TPanel
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      inherited lbSection: TORListBox
        Tag = 20
        TabOrder = 0
      end
      inherited btnOther: TButton
        Tag = 12
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Other Diagnosis...'
        TabOrder = 1
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdDiagPrimary'
        'Status = stsDefault')
      (
        'Component = ckbDiagProb'
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
        'Component = frmDiagnoses'
        'Status = stsDefault'))
  end
end
