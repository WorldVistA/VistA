inherited frmVisitType: TfrmVisitType
  Left = 260
  Caption = 'Encounter VisitType'
  ClientHeight = 501
  ClientWidth = 734
  StyleElements = [seFont, seClient, seBorder]
  ScaleMethod = smManual
  ExplicitWidth = 750
  ExplicitHeight = 540
  TextHeight = 13
  inherited pnlBottomAncestor: TPanel
    Top = 474
    Width = 734
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 474
    ExplicitWidth = 734
    inherited btnOK: TBitBtn
      Left = 575
      ExplicitLeft = 575
    end
    inherited btnCancel: TBitBtn
      Left = 656
      ExplicitLeft = 656
    end
  end
  inherited pnlMainAncestor: TPanel
    Width = 734
    Height = 474
    StyleElements = [seFont, seClient, seBorder]
    ExplicitWidth = 734
    ExplicitHeight = 474
    object grdMain: TGridPanel
      Left = 0
      Top = 0
      Width = 734
      Height = 474
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 16.666666666666670000
        end
        item
          Value = 16.666666666666670000
        end
        item
          Value = 16.666666666666670000
        end
        item
          Value = 16.666666666666670000
        end
        item
          Value = 16.666666666666670000
        end
        item
          Value = 16.666666666666650000
        end>
      ControlCollection = <
        item
          Column = 0
          ColumnSpan = 2
          Control = lblVTypeSection
          Row = 0
        end
        item
          Column = 2
          ColumnSpan = 2
          Control = lblVType
          Row = 0
        end
        item
          Column = 4
          ColumnSpan = 2
          Control = lblMod
          Row = 0
        end
        item
          Column = 0
          ColumnSpan = 2
          Control = lstVTypeSection
          Row = 1
        end
        item
          Column = 2
          ColumnSpan = 2
          Control = lbxVisits
          Row = 1
        end
        item
          Column = 4
          ColumnSpan = 2
          Control = lbMods
          Row = 1
        end
        item
          Column = 3
          ColumnSpan = 3
          Control = fraVisitRelated
          Row = 2
        end
        item
          Column = 0
          ColumnSpan = 6
          Control = grdBottom
          Row = 3
        end
        item
          Column = 0
          ColumnSpan = 3
          Control = pnlSC
          Row = 2
        end>
      RowCollection = <
        item
          SizeStyle = ssAuto
          Value = 18.000000000000000000
        end
        item
          Value = 33.594697448157420000
        end
        item
          Value = 33.187296275415960000
        end
        item
          Value = 33.218006276426620000
        end>
      TabOrder = 0
      object lblVTypeSection: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 239
        Height = 13
        Align = alTop
        Caption = 'Type of Visit'
        ExplicitWidth = 58
      end
      object lblVType: TLabel
        AlignWithMargins = True
        Left = 248
        Top = 3
        Width = 238
        Height = 13
        Align = alTop
        Caption = 'Section Name'
        ExplicitWidth = 67
      end
      object lblMod: TLabel
        AlignWithMargins = True
        Left = 492
        Top = 3
        Width = 239
        Height = 13
        Hint = 'Modifiers'
        Align = alTop
        Caption = 'Modifiers'
        ParentShowHint = False
        ShowHint = True
        ExplicitWidth = 42
      end
      object lstVTypeSection: TORListBox
        Tag = 10
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 239
        Height = 150
        Margins.Top = 0
        Align = alClient
        Anchors = []
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = lstVTypeSectionClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '3'
        FlatCheckBoxes = False
        CheckEntireLine = True
      end
      object lbxVisits: TORListBox
        Tag = 10
        AlignWithMargins = True
        Left = 248
        Top = 19
        Width = 238
        Height = 150
        Margins.Top = 0
        Style = lbOwnerDrawFixed
        Align = alClient
        Anchors = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = lbxVisitsClick
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,1'
        TabPosInPixels = True
        CheckBoxes = True
        FlatCheckBoxes = False
        CheckEntireLine = True
        OnClickCheck = lbxVisitsClickCheck
      end
      object lbMods: TORListBox
        AlignWithMargins = True
        Left = 492
        Top = 19
        Width = 239
        Height = 150
        Margins.Top = 0
        Style = lbOwnerDrawFixed
        Align = alClient
        Anchors = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Caption = ''
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2,3'
        TabPosInPixels = True
        CheckBoxes = True
        FlatCheckBoxes = False
        CheckEntireLine = True
        OnClickCheck = lbModsClickCheck
      end
      inline fraVisitRelated: TfraVisitRelated
        AlignWithMargins = True
        Left = 370
        Top = 175
        Width = 361
        Height = 145
        Align = alClient
        TabOrder = 4
        TabStop = True
        ExplicitLeft = 370
        ExplicitTop = 175
        ExplicitWidth = 361
        ExplicitHeight = 145
        inherited sbMain: TScrollBox
          Width = 361
          Height = 145
          ExplicitWidth = 361
          ExplicitHeight = 145
          inherited pnlMain: TPanel
            Width = 344
            Height = 150
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 344
            ExplicitHeight = 150
            inherited gbVisitRelatedTo: TGroupBox
              Width = 338
              Height = 144
              ExplicitWidth = 338
              ExplicitHeight = 144
              inherited lblNoSAAvailable: TLabel
                Top = 15
                Width = 334
                Height = 13
                StyleElements = [seFont, seClient, seBorder]
                ExplicitTop = 15
                ExplicitWidth = 147
                ExplicitHeight = 13
              end
              inherited gpMain: TGridPanel
                Top = 28
                Width = 328
                Height = 114
                ControlCollection = <
                  item
                    Column = 0
                    Control = fraVisitRelated.lblYes
                    Row = 0
                  end
                  item
                    Column = 1
                    Control = fraVisitRelated.lblNo
                    Row = 0
                  end>
                StyleElements = [seFont, seClient, seBorder]
                ExplicitTop = 28
                ExplicitWidth = 328
                ExplicitHeight = 114
                inherited lblYes: TLabel
                  Top = 2
                  Height = 13
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitTop = 2
                  ExplicitWidth = 18
                  ExplicitHeight = 13
                end
                inherited lblNo: TLabel
                  Top = 2
                  Height = 13
                  StyleElements = [seFont, seClient, seBorder]
                  ExplicitTop = 2
                  ExplicitWidth = 14
                  ExplicitHeight = 13
                end
              end
            end
          end
        end
      end
      object grdBottom: TGridPanel
        Left = 0
        Top = 323
        Width = 734
        Height = 151
        Align = alClient
        Anchors = []
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            SizeStyle = ssAuto
            Value = 25.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = lblProvider
            Row = 0
          end
          item
            Column = 2
            Control = lblCurrentProv
            Row = 0
          end
          item
            Column = 0
            Control = cboPtProvider
            Row = 1
          end
          item
            Column = 2
            Control = lbProviders
            Row = 1
          end
          item
            Column = 1
            Control = pnlBottomMiddle
            Row = 1
          end>
        RowCollection = <
          item
            SizeStyle = ssAuto
            Value = 50.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 8
        object lblProvider: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 311
          Height = 13
          Align = alTop
          Caption = 'Available providers'
          ExplicitWidth = 89
        end
        object lblCurrentProv: TLabel
          AlignWithMargins = True
          Left = 420
          Top = 3
          Width = 311
          Height = 13
          Align = alTop
          Caption = 'Current providers for this encounter'
          ExplicitWidth = 165
        end
        object cboPtProvider: TORCheckComboBox
          AlignWithMargins = True
          Left = 3
          Top = 19
          Width = 311
          Height = 129
          Margins.Top = 0
          Style = orcsSimple
          Align = alClient
          AutoSelect = True
          Caption = 'Available providers'
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 13
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = True
          LookupPiece = 2
          MaxLength = 0
          Pieces = '2,3'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          FlatCheckBoxes = False
          CheckEntireLine = True
          OnChange = cboPtProviderChange
          OnDblClick = cboPtProviderDblClick
          OnNeedData = cboPtProviderNeedData
          CharsNeedMatch = 1
          UniqueAutoComplete = True
          MainCheckBoxCaption = 'Include Non-VA Providers'
          MainCheckBoxVisible = True
          MainCheckBoxAlignment = calBottom
          OnMainCheckboxClick = cboPtProviderMainCheckboxClick
          DropdownStyle = ddsControl
        end
        object lbProviders: TORListBox
          AlignWithMargins = True
          Left = 420
          Top = 19
          Width = 311
          Height = 129
          Margins.Top = 0
          Align = alClient
          Anchors = []
          ItemHeight = 13
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnDblClick = lbProvidersDblClick
          Caption = 'Run (F9)'
          ItemTipColor = clWindow
          LongList = False
          Pieces = '2'
          OnChange = lbProvidersChange
          FlatCheckBoxes = False
          CheckEntireLine = True
        end
        object pnlBottomMiddle: TPanel
          Left = 317
          Top = 19
          Width = 100
          Height = 85
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 1
          object btnPrimary: TButton
            AlignWithMargins = True
            Left = 3
            Top = 29
            Width = 94
            Height = 25
            Margins.Top = 2
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Primary'
            TabOrder = 1
            OnClick = btnPrimaryClick
          end
          object btnDelete: TButton
            AlignWithMargins = True
            Left = 3
            Top = 58
            Width = 94
            Height = 25
            Margins.Top = 2
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Remove'
            TabOrder = 2
            OnClick = btnDeleteClick
          end
          object btnAdd: TButton
            AlignWithMargins = True
            Left = 3
            Top = 0
            Width = 94
            Height = 25
            Margins.Top = 0
            Margins.Bottom = 2
            Align = alTop
            Caption = 'Add'
            TabOrder = 0
            OnClick = btnAddClick
          end
        end
      end
      object pnlSC: TPanel
        Left = 0
        Top = 172
        Width = 367
        Height = 151
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        object lblSCDisplay: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 361
          Height = 13
          Align = alTop
          Anchors = []
          Caption = 'Service Connection && Rated Disabilities'
          ExplicitWidth = 186
        end
        object memSCDisplay: TCaptionMemo
          AlignWithMargins = True
          Left = 3
          Top = 19
          Width = 361
          Height = 129
          Margins.Top = 0
          Align = alClient
          Color = clBtnFace
          Lines.Strings = (
            '')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnEnter = memSCDisplayEnter
          Caption = ''
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 8
    Top = 24
    Data = (
      (
        'Component = frmVisitType'
        'Status = stsDefault')
      (
        'Component = lstVTypeSection'
        'Label = lblVTypeSection'
        'Status = stsOK')
      (
        'Component = fraVisitRelated'
        'Status = stsDefault')
      (
        'Component = fraVisitRelated.gbVisitRelatedTo'
        'Status = stsDefault')
      (
        'Component = memSCDisplay'
        'Label = lblSCDisplay'
        'Status = stsOK')
      (
        'Component = cboPtProvider'
        'Label = lblProvider'
        'Status = stsOK')
      (
        'Component = lbProviders'
        'Label = lblCurrentProv'
        'Status = stsOK')
      (
        'Component = pnlBottomAncestor'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = lbMods'
        'Label = lblMod'
        'Status = stsOK')
      (
        'Component = lbxVisits'
        'Label = lblVType'
        'Status = stsOK')
      (
        'Component = pnlMainAncestor'
        'Status = stsDefault')
      (
        'Component = grdMain'
        'Status = stsDefault')
      (
        'Component = grdBottom'
        'Status = stsDefault')
      (
        'Component = pnlBottomMiddle'
        'Status = stsDefault')
      (
        'Component = btnPrimary'
        'Status = stsDefault')
      (
        'Component = btnDelete'
        'Status = stsDefault')
      (
        'Component = btnAdd'
        'Status = stsDefault')
      (
        'Component = pnlSC'
        'Status = stsDefault'))
  end
end
