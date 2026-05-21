inherited frmPatientEd: TfrmPatientEd
  Caption = 'Encounter Patient Education'
  ClientHeight = 481
  ClientWidth = 624
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 640
  ExplicitHeight = 520
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    Top = 130
    Width = 624
    Height = 324
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 130
    ExplicitWidth = 624
    ExplicitHeight = 324
    inherited pnlGrid: TPanel
      Width = 540
      Height = 318
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 540
      ExplicitHeight = 318
      inherited lstCaptionList: TCaptionListView
        Width = 530
        Height = 222
        Columns = <
          item
            Caption = 'Level of Understanding'
            Width = 150
          end
          item
            AutoSize = True
            Caption = 'Selected Patient Educations'
            Tag = 1
          end>
        Caption = 'Selected Patient Educations'
        Pieces = '1,2'
        ExplicitWidth = 530
        ExplicitHeight = 222
      end
      inherited pnlComments: TPanel
        Top = 271
        Width = 536
        TabOrder = 2
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 271
        ExplicitWidth = 536
        inherited lblComment: TLabel
          Width = 530
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 530
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 530
        end
      end
      object gridMagUCUMData: TGridPanel
        Left = 0
        Top = 228
        Width = 536
        Height = 43
        Align = alBottom
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 30.000000000000000000
          end
          item
            Value = 30.000000000000000000
          end
          item
            Value = 40.000000000000000000
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
          Width = 161
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 0
          object lblUnderstanding: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 155
            Height = 13
            Align = alTop
            Caption = 'Level of Understanding'
            ExplicitWidth = 110
          end
          object cboPatUnderstanding: TORComboBox
            Tag = 40
            AlignWithMargins = True
            Left = 3
            Top = 19
            Width = 155
            Height = 21
            Margins.Top = 0
            Style = orcsDropDown
            Align = alTop
            AutoSelect = True
            Caption = 'Level Of Understanding'
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
            OnChange = cboPatUnderstandingChange
            CharsNeedMatch = 1
          end
        end
        object pnlUCUM: TPanel
          Left = 322
          Top = 0
          Width = 214
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 2
          object lblUCUM: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 3
            Width = 211
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
            Width = 211
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
          Left = 161
          Top = 0
          Width = 161
          Height = 43
          Align = alClient
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 1
          object lblMag: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 155
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
            Width = 155
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
      Left = 546
      Height = 324
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 546
      ExplicitHeight = 324
      inherited btnSelectAll: TButton
        TabStop = True
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Top = 454
    Width = 624
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 454
    ExplicitWidth = 624
    inherited btnOK: TBitBtn
      Left = 465
      ExplicitLeft = 465
    end
    inherited btnCancel: TBitBtn
      Left = 546
      ExplicitLeft = 546
    end
  end
  inherited pnlMain: TPanel
    Width = 624
    Height = 130
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 624
    ExplicitHeight = 130
    inherited grdMain: TGridPanel
      Width = 624
      Height = 130
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 624
      ExplicitHeight = 130
      inherited lblSection: TLabel
        Width = 309
        Caption = 'Patient Education Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 123
      end
      inherited lblList: TLabel
        Left = 315
        Width = 306
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 315
      end
      inherited lbSection: TORListBox
        Width = 306
        Height = 84
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Patient Education Section'
        ExplicitWidth = 306
        ExplicitHeight = 84
      end
      inherited lbxSection: TORListBox
        Left = 315
        Width = 306
        Height = 108
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        ExplicitLeft = 315
        ExplicitWidth = 306
        ExplicitHeight = 108
      end
      inherited btnOther: TButton
        Tag = 22
        Top = 106
        Width = 306
        Caption = 'Other Education Topic...'
        ExplicitTop = 106
        ExplicitWidth = 306
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
        'Component = frmPatientEd'
        'Status = stsDefault')
      (
        'Component = gridMagUCUMData'
        'Status = stsDefault')
      (
        'Component = pnlLevelSeverity'
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
        'Component = cboPatUnderstanding'
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
