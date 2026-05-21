inherited frmProcedures: TfrmProcedures
  Left = 548
  Top = 172
  Caption = 'Encounter Procedure'
  ClientHeight = 702
  ClientWidth = 858
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 874
  ExplicitHeight = 741
  TextHeight = 13
  inherited pnlMainAncestor: TPanel
    Width = 858
    Height = 471
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 858
    ExplicitHeight = 471
    inherited pnlGrid: TPanel
      Width = 774
      Height = 465
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 774
      ExplicitHeight = 465
      inherited lstCaptionList: TCaptionListView
        Top = 27
        Width = 768
        Height = 401
        Columns = <
          item
            Caption = 'Quantity'
            Width = 80
          end
          item
            AutoSize = True
            Caption = 'Selected Procedures'
          end>
        Caption = 'Selected Procedures'
        Pieces = '1,2'
        ExplicitLeft = 3
        ExplicitTop = 27
        ExplicitWidth = 768
        ExplicitHeight = 401
      end
      inherited pnlComments: TPanel
        Top = 0
        Width = 774
        Height = 24
        Align = alTop
        Caption = ''
        StyleElements = [seFont, seClient, seBorder]
        ExplicitTop = 0
        ExplicitWidth = 774
        ExplicitHeight = 24
        inherited lblComment: TLabel
          Height = 18
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited edtComment: TCaptionEdit
          Width = 707
          Height = 21
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 707
        end
      end
      object gridProvider: TGridPanel
        Left = 0
        Top = 431
        Width = 774
        Height = 34
        Align = alBottom
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 80.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlProvider
            Row = 0
          end
          item
            Column = 1
            Control = pnlQuantity
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 2
        object pnlProvider: TPanel
          Left = 0
          Top = 0
          Width = 619
          Height = 34
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object lblProvider: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 7
            Width = 42
            Height = 24
            Margins.Top = 7
            Align = alLeft
            Caption = 'Provider:'
            ExplicitHeight = 13
          end
          object cboProvider: TORCheckComboBox
            AlignWithMargins = True
            Left = 51
            Top = 3
            Width = 559
            Height = 28
            Margins.Right = 9
            Style = orcsDropDown
            Align = alClient
            AutoSelect = True
            Caption = '`'
            Color = clWindow
            DropDownCount = 8
            Enabled = False
            ItemHeight = 13
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = True
            LookupPiece = 2
            MaxLength = 0
            Pieces = '2,3'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            TabStop = True
            Text = ''
            FlatCheckBoxes = False
            OnChange = cboProviderChange
            OnExit = cboProviderExit
            OnNeedData = cboProviderNeedData
            CharsNeedMatch = 1
            MainCheckBoxCaption = 'Include Non-VA Providers'
            MainCheckBoxVisible = True
            MainCheckBoxAlignment = calRight
            OnMainCheckboxClick = cboProviderMainCheckboxClick
            DropdownStyle = ddsControl
          end
        end
        object pnlQuantity: TPanel
          Left = 619
          Top = 0
          Width = 155
          Height = 34
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          OnResize = pnlQuantityResize
          DesignSize = (
            155
            34)
          object lblProcQty: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 7
            Width = 42
            Height = 24
            Margins.Top = 7
            Align = alLeft
            Caption = 'Quantity:'
            ExplicitHeight = 13
          end
          object spnProcQty: TUpDown
            AlignWithMargins = True
            Left = 132
            Top = 3
            Width = 17
            Height = 21
            Margins.Left = 0
            Margins.Right = 0
            Anchors = [akTop, akRight]
            Associate = txtProcQty
            Min = 1
            Max = 999
            Position = 1
            TabOrder = 1
          end
          object txtProcQty: TCaptionEdit
            AlignWithMargins = True
            Left = 51
            Top = 3
            Width = 81
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Enabled = False
            TabOrder = 0
            Text = '1'
            OnChange = txtProcQtyChange
            Caption = 'Quantity'
          end
        end
      end
    end
    inherited pnlGridRight: TPanel
      Left = 780
      Height = 471
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 780
      ExplicitHeight = 471
      inherited btnSelectAll: TButton
        TabStop = True
      end
    end
  end
  inherited pnlBottomAncestor: TPanel
    Top = 675
    Width = 858
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 675
    ExplicitWidth = 858
    inherited btnOK: TBitBtn
      Left = 699
      ExplicitLeft = 699
    end
    inherited btnCancel: TBitBtn
      Left = 780
      ExplicitLeft = 780
    end
  end
  inherited pnlMain: TPanel
    Width = 858
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 858
    inherited grdMain: TGridPanel
      Width = 858
      ColumnCollection = <
        item
          Value = 33.333333333333340000
        end
        item
          Value = 33.333333333333340000
        end
        item
          Value = 33.333333333333310000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = lblSection
          Row = 0
        end
        item
          Column = 1
          Control = lblList
          Row = 0
        end
        item
          Column = 0
          Control = lbSection
          Row = 1
        end
        item
          Column = 1
          Control = lbxSection
          Row = 1
          RowSpan = 2
        end
        item
          Column = 0
          Control = btnOther
          Row = 2
        end
        item
          Column = 2
          Control = lblMod
          Row = 0
        end
        item
          Column = 2
          Control = lbMods
          Row = 1
          RowSpan = 2
        end
        item
          Column = 2
          Row = 3
        end>
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 858
      inherited lblSection: TLabel
        Width = 283
        Caption = 'Procedure Section'
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 88
      end
      inherited lblList: TLabel
        Left = 289
        Width = 280
        StyleElements = [seFont, seClient, seBorder]
        ExplicitLeft = 289
      end
      inherited lbSection: TORListBox
        Width = 280
        Height = 154
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 280
        ExplicitHeight = 154
      end
      inherited lbxSection: TORListBox
        Left = 289
        Width = 280
        StyleElements = [seFont, seClient, seBorder]
        Caption = 'Section Name'
        Pieces = '2,1'
        ExplicitLeft = 289
        ExplicitWidth = 280
      end
      inherited btnOther: TButton
        Tag = 13
        Top = 176
        Width = 280
        Height = 25
        Caption = 'Other Procedure...'
        TabOrder = 3
        ExplicitTop = 176
        ExplicitWidth = 280
        ExplicitHeight = 25
      end
      object lblMod: TLabel
        AlignWithMargins = True
        Left = 575
        Top = 3
        Width = 280
        Height = 13
        Hint = 'Modifiers'
        Align = alTop
        Caption = 'Modifiers'
        ParentShowHint = False
        ShowHint = True
        ExplicitWidth = 42
      end
      object lbMods: TORListBox
        AlignWithMargins = True
        Left = 575
        Top = 19
        Width = 280
        Height = 182
        Margins.Top = 0
        Style = lbOwnerDrawFixed
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnExit = lbModsExit
        Caption = 'Modifiers'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPosInPixels = True
        CheckBoxes = True
        FlatCheckBoxes = False
        CheckEntireLine = True
        OnClickCheck = lbModsClickCheck
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lbMods'
        'Label = lblMod'
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
        'Component = frmProcedures'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Text = Provider'
        'Status = stsOK')
      (
        'Component = spnProcQty'
        'Status = stsDefault')
      (
        'Component = txtProcQty'
        'Status = stsDefault')
      (
        'Component = gridProvider'
        'Status = stsDefault')
      (
        'Component = pnlProvider'
        'Status = stsDefault')
      (
        'Component = pnlQuantity'
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
