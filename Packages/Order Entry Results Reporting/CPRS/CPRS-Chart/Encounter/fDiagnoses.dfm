inherited frmDiagnoses: TfrmDiagnoses
  Left = 304
  Top = 169
  AutoScroll = True
  Caption = 'Encounter Diagnoses'
  ExplicitWidth = 640
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblSection: TLabel
    Width = 89
    Caption = 'Diagnoses Section'
    ExplicitWidth = 89
  end
  inherited btnOK: TBitBtn
    TabOrder = 7
  end
  inherited btnCancel: TBitBtn
    TabOrder = 8
  end
  inherited pnlGrid: TPanel
    Width = 523
    TabOrder = 1
    ExplicitWidth = 523
    inherited lbGrid: TORListBox
      Tag = 20
      Width = 523
      Pieces = '1,2,3'
      ExplicitWidth = 523
    end
    inherited hcGrid: THeaderControl
      Width = 523
      Sections = <
        item
          ImageIndex = -1
          MinWidth = 60
          Text = 'Add to PL'
          Width = 60
        end
        item
          ImageIndex = -1
          MinWidth = 65
          Text = 'Primary'
          Width = 65
        end
        item
          ImageIndex = -1
          MinWidth = 110
          Text = 'Selected Diagnoses'
          Width = 110
        end>
      ExplicitWidth = 523
    end
  end
  inherited edtComment: TCaptionEdit
    TabOrder = 3
  end
  object cmdDiagPrimary: TButton [8]
    Left = 536
    Top = 306
    Width = 75
    Height = 21
    Caption = 'Primary'
    Enabled = False
    TabOrder = 5
    OnClick = cmdDiagPrimaryClick
  end
  object ckbDiagProb: TCheckBox [9]
    Left = 535
    Top = 258
    Width = 76
    Height = 38
    Caption = 'Add to Problem list'
    TabOrder = 4
    WordWrap = True
    OnClick = ckbDiagProbClicked
  end
  inherited btnRemove: TButton
    TabOrder = 6
  end
  inherited btnSelectAll: TButton
    Left = 454
    TabOrder = 2
    TabStop = True
    ExplicitLeft = 454
  end
  inherited pnlMain: TPanel
    TabOrder = 0
    inherited lbxSection: TORListBox
      Tag = 20
      Height = 196
      IntegralHeight = True
      OnDrawItem = lbxSectionDrawItem
      Pieces = '2,3'
      ExplicitHeight = 196
    end
    inherited pnlLeft: TPanel
      inherited lbSection: TORListBox
        Tag = 20
        TabOrder = 0
      end
      inherited btnOther: TButton
        Tag = 12
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
        'Component = lbGrid'
        'Status = stsDefault')
      (
        'Component = hcGrid'
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
