inherited frmHealthFactors: TfrmHealthFactors
  Caption = 'Encounter Health Factors'
  ClientHeight = 586
  ClientWidth = 884
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 900
  ExplicitHeight = 625
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    Width = 884
    Height = 355
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 884
    ExplicitHeight = 355
    inherited pnlGrid: TPanel
      Width = 800
      Height = 349
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 800
      ExplicitHeight = 349
      inherited lstCaptionList: TCaptionListView
        Width = 790
        Height = 253
        Columns = <
          item
            Caption = 'Level/Severity'
          end
          item
            AutoSize = True
            Caption = 'Selected Health Factors'
            Tag = 1
          end>
        Caption = 'Selected Health Factors'
        Pieces = '1,2'
        ExplicitWidth = 790
        ExplicitHeight = 253
      end
      inherited pnlComments: TPanel
        Top = 302
        Width = 796
        Anchors = [akLeft]
        TabOrder = 2
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 302
        ExplicitWidth = 796
        inherited lblComment: TLabel
          Width = 790
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 790
          MaxLength = 245
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 790
        end
      end
      object gridMagUCUMData: TGridPanel
        Left = 0
        Top = 259
        Width = 796
        Height = 43
        Align = alBottom
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 20.000000000000000000
          end
          item
            Value = 25.000000000000000000
          end
          item
            Value = 55.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlLevelSeverity
            Row = 0
          end
          item
            Column = 2
            Control = pnlUCUM
            Row = 0
          end
          item
            Column = 1
            Control = pnlMagnitude
            Row = 0
          end>
        ParentBackground = False
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 1
        StyleElements = [seFont, seBorder]
        object pnlLevelSeverity: TPanel
          Left = 0
          Top = 0
          Width = 159
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          object lblHealthLevel: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 153
            Height = 13
            Align = alTop
            Caption = 'Level/Severity'
            ExplicitWidth = 69
          end
          object cboHealthLevel: TORComboBox
            Tag = 50
            AlignWithMargins = True
            Left = 3
            Top = 19
            Width = 153
            Height = 21
            Margins.Top = 0
            Style = orcsDropDown
            Align = alTop
            AutoSelect = True
            Caption = 'Level/Severity'
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
            TabOrder = 0
            Text = ''
            FlatCheckBoxes = False
            OnChange = cboHealthLevelChange
            CharsNeedMatch = 1
          end
        end
        object pnlUCUM: TPanel
          Left = 358
          Top = 0
          Width = 438
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 2
          object lblUCUM: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 435
            Height = 13
            Margins.Left = 0
            Align = alTop
            Caption = 'Unified Code for Units of Measure  (UCUM)'
            Visible = False
            ExplicitWidth = 203
          end
          object lblUCUM2: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 22
            Width = 435
            Height = 13
            Margins.Left = 0
            Align = alTop
            Caption = 'lblUCUM2'
            Layout = tlCenter
            Visible = False
            ExplicitWidth = 48
          end
        end
        object pnlMagnitude: TPanel
          Left = 159
          Top = 0
          Width = 199
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 1
          object lblMag: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 193
            Height = 13
            Align = alTop
            Caption = 'Magnitude:'
            Visible = False
            ExplicitWidth = 53
          end
          object edtMag: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 19
            Width = 193
            Height = 21
            Margins.Top = 0
            Align = alTop
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Visible = False
            OnChange = edtMagChange
            OnExit = edtMagExit
            OnKeyPress = edtMagKeyPress
            Caption = '0'
          end
        end
      end
    end
    inherited pnlGridRight: TPanel
      Left = 806
      Height = 355
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 806
      ExplicitHeight = 355
      inherited btnSelectAll: TButton
        TabStop = True
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Top = 559
    Width = 884
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 559
    ExplicitWidth = 884
    inherited btnOK: TBitBtn
      Left = 725
      ExplicitLeft = 725
    end
    inherited btnCancel: TBitBtn
      Left = 806
      ExplicitLeft = 806
    end
  end
  inherited pnlMain: TPanel
    Width = 884
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 884
    inherited grdMain: TGridPanel
      Width = 884
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 884
      inherited lblSection: TLabel
        Width = 439
        Caption = 'Health Factor Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 103
      end
      inherited lblList: TLabel
        Left = 445
        Width = 436
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 445
      end
      inherited lbSection: TORListBox
        Width = 436
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Health Factor Section'
        ExplicitWidth = 436
      end
      inherited lbxSection: TORListBox
        Left = 445
        Width = 436
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 445
        ExplicitWidth = 436
      end
      inherited btnOther: TButton
        Tag = 23
        Width = 436
        Caption = 'Other Health Factor...'
        ExplicitWidth = 436
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
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
        'Component = frmHealthFactors'
        'Status = stsDefault')
      (
        'Component = gridMagUCUMData'
        'Status = stsDefault')
      (
        'Component = pnlLevelSeverity'
        'Status = stsDefault')
      (
        'Component = cboHealthLevel'
        'Status = stsDefault')
      (
        'Component = pnlUCUM'
        'Status = stsDefault')
      (
        'Component = pnlMagnitude'
        'Status = stsDefault')
      (
        'Component = edtMag'
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
        'Component = pnlBottomAncestor'
        'Status = stsDefault'))
  end
end
