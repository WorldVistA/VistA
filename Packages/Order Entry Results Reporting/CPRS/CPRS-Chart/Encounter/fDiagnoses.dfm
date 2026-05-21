inherited frmDiagnoses: TfrmDiagnoses
  Left = 304
  Top = 169
  AutoScroll = True
  Caption = 'Encounter Diagnoses'
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 210
    ExplicitHeight = 162
    inherited pnlGrid: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitHeight = 156
      inherited lstCaptionList: TCaptionListView
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
            AutoSize = True
            Caption = 'Selected Diagnoses'
          end>
        Caption = 'Selected Diagnoses'
        Pieces = '1,2,3'
        ExplicitHeight = 124
      end
      inherited pnlComments: TPanel
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 130
        inherited lblComment: TLabel
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    inherited pnlGridRight: TPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitHeight = 162
      inherited btnRemove: TButton
        Top = 97
        TabOrder = 3
        ExplicitTop = 97
      end
      inherited btnSelectAll: TButton
        Top = 73
        Margins.Top = 0
        TabOrder = 2
        TabStop = True
        ExplicitTop = 73
      end
      object ckbDiagProb: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 72
        Height = 43
        Align = alTop
        Caption = 'Add to Problem list'
        TabOrder = 0
        WordWrap = True
        OnClick = ckbDiagProbClicked
      end
      object cmdDiagPrimary: TButton
        AlignWithMargins = True
        Left = 0
        Top = 49
        Width = 75
        Height = 21
        Margins.Left = 0
        Margins.Top = 0
        Align = alTop
        Caption = 'Primary'
        Enabled = False
        TabOrder = 1
        OnClick = cmdDiagPrimaryClick
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlMain: TPanel
    StyleElements = [seFont, seClient, seBorder]
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 614
    inherited grdMain: TGridPanel
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 614
      inherited lblSection: TLabel
        Caption = 'Diagnoses Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 89
      end
      inherited lblList: TLabel
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 310
      end
      inherited lbSection: TORListBox
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 301
      end
      inherited lbxSection: TORListBox
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        Pieces = '2,3'
        ExplicitLeft = 310
        ExplicitWidth = 301
      end
      inherited btnOther: TButton
        Tag = 12
        Caption = 'Other Diagnosis...'
        ExplicitWidth = 301
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = cmdDiagPrimary'
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
        'Status = stsDefault')
      (
        'Component = pnlMainAncestor'
        'Status = stsDefault')
      (
        'Component = lstCaptionList'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = pnlGridRight'
        'Status = stsDefault')
      (
        'Component = ckbDiagProb'
        'Status = stsDefault')
      (
        'Component = pnlBottomAncestor'
        'Status = stsDefault'))
  end
end
