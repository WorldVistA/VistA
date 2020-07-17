inherited frmODBBank: TfrmODBBank
  Left = 409
  Top = 244
  Width = 700
  Height = 626
  AutoScroll = True
  Caption = 'Blood Component and Diagnostic Test Order Form'
  OnShow = FormShow
  ExplicitWidth = 700
  ExplicitHeight = 626
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 0
    Width = 661
    Height = 3
    Cursor = crVSplit
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    ExplicitWidth = 855
  end
  object pnlComments: TPanel [1]
    Left = 15
    Top = 31
    Width = 668
    Height = 460
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 5
    Visible = False
    object lblOrdComment: TLabel
      Left = 31
      Top = 4
      Width = 108
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Order Comment'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnUpdateComments: TButton
      Left = 465
      Top = 218
      Width = 144
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Update Comments'
      TabOrder = 0
      OnClick = btnUpdateCommentsClick
    end
    object btnCancelComment: TButton
      Left = 349
      Top = 218
      Width = 94
      Height = 31
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelCommentClick
    end
  end
  inherited memOrder: TCaptionMemo
    Left = 5
    Top = 629
    Width = 561
    Height = 74
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Visible = False
    ExplicitLeft = 5
    ExplicitTop = 629
    ExplicitWidth = 561
    ExplicitHeight = 74
  end
  object pgeProduct: TPageControl [3]
    Left = 0
    Top = 3
    Width = 661
    Height = 621
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ActivePage = TabDiag
    Align = alTop
    TabOrder = 4
    OnChange = pgeProductChange
    object TabInfo: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Patient Information'
      ImageIndex = 3
      object edtInfo: TCaptionRichEdit
        Left = 0
        Top = 0
        Width = 653
        Height = 590
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        Zoom = 100
        Caption = 'Patient Info'
      end
    end
    object TabDiag: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Blood Bank Orders'
      ImageIndex = 2
      object lblReqComment: TOROffsetLabel
        Left = 375
        Top = 31
        Width = 135
        Height = 47
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object pnlFields: TPanel
        Left = 0
        Top = 181
        Width = 653
        Height = 263
        Hint = 'Data entered into these fields apply to the entire order.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        object lblDiagComment: TOROffsetLabel
          Left = 0
          Top = 160
          Width = 59
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Comment'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          HorzOffset = 2
          ParentFont = False
          Transparent = False
          VertOffset = 2
          WordWrap = True
        end
        object lblUrgency: TLabel
          Left = 0
          Top = -1
          Width = 56
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Urgency*'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblReason: TLabel
          Left = 0
          Top = 50
          Width = 120
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Reason for Request'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblSurgery: TLabel
          Left = 146
          Top = 0
          Width = 47
          Height = 16
          Hint = 
            'Enter the name of the surgical procedure that this request is fo' +
            'r.'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Surgery'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblRequiredField: TLabel
          Left = 498
          Top = 48
          Width = 154
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '* Indicates a required field'
        end
        object lblTNS: TLabel
          Left = 338
          Top = 0
          Width = 17
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'tns'
          Color = clActiveBorder
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Visible = False
        end
        object lblNoBloodReq: TLabel
          Left = 426
          Top = 26
          Width = 223
          Height = 16
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'No Blood Required for this Procedure'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object cboUrgency: TORComboBox
          Left = 5
          Top = 18
          Width = 123
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Urgency'
          Color = clWindow
          DropDownCount = 8
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = True
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnChange = cboUrgencyChange
          OnExit = cboUrgencyExit
          CharsNeedMatch = 1
        end
        object chkConsent: TCheckBox
          Left = 661
          Top = 115
          Width = 140
          Height = 21
          Hint = 'Informed Consent Signed On Chart?'
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Alignment = taLeftJustify
          Caption = 'Informed Consent?'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Visible = False
          OnClick = chkConsentClick
        end
        object cboSurgery: TORComboBox
          Left = 146
          Top = 18
          Width = 273
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = orcsDropDown
          AutoSelect = True
          Caption = 'Surgery'
          Color = clWindow
          DropDownCount = 8
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          ParentFont = False
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 1
          Text = ''
          OnChange = cboSurgeryChange
          OnClick = cboSurgeryClick
          CharsNeedMatch = 1
        end
        object cboReasons: TORComboBox
          Left = 5
          Top = 69
          Width = 656
          Height = 92
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = orcsSimple
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = False
          LookupPiece = 0
          MaxLength = 0
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 2
          Text = ''
          OnChange = cboReasonsChange
          OnEnter = cboReasonsEnter
          OnExit = cboReasonsExit
          CharsNeedMatch = 1
        end
        object memDiagComment: TRichEdit
          Left = 5
          Top = 180
          Width = 656
          Height = 75
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Zoom = 100
          OnChange = memDiagCommentChange
        end
      end
      object pnlSelect: TPanel
        Left = 0
        Top = 44
        Width = 653
        Height = 137
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 1
        object pnlDiagnosticTests: TGroupBox
          Left = 333
          Top = 0
          Width = 320
          Height = 138
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Diagnostic Tests'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = pnlDiagnosticTestsClick
          OnEnter = pnlDiagnosticTestsEnter
          OnExit = pnlDiagnosticTestsExit
          object lblCollType: TLabel
            Left = 16
            Top = 41
            Width = 99
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Collection Type*'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblCollTime: TLabel
            Left = 15
            Top = 88
            Width = 128
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Collection Date/Time'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object pnlCollTimeButton: TKeyClickPanel
            Left = 223
            Top = 103
            Width = 26
            Height = 26
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            BevelOuter = bvNone
            TabOrder = 5
            TabStop = True
            object cmdImmedColl: TSpeedButton
              Left = 0
              Top = 0
              Width = 26
              Height = 26
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -20
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              Glyph.Data = {
                D6000000424DD60000000000000076000000280000000C0000000C0000000100
                0400000000006000000000000000000000001000000010000000000000000000
                80000080000000808000800000008000800080800000C0C0C000808080000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                0000333333333333000033333333333300003333333333330000300330033003
                0000300330033003000033333333333300003333333333330000333333333333
                0000333333333333000033333333333300003333333333330000}
              ParentFont = False
              ParentShowHint = False
              ShowHint = False
              OnClick = cmdImmedCollClick
            end
          end
          object calCollTime: TORDateBox
            Left = 15
            Top = 103
            Width = 206
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnChange = calCollTimeChange
            OnEnter = calCollTimeEnter
            DateOnly = False
            RequireTime = False
            Caption = ''
          end
          object cboAvailTest: TORComboBox
            Left = 16
            Top = 16
            Width = 293
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Diagnostic Tests'
            Color = clWindow
            DropDownCount = 8
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentFont = False
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            TabStop = True
            Text = ''
            OnClick = cboAvailTestSelect
            OnEnter = cboAvailTestEnter
            OnExit = cboAvailTestExit
            OnNeedData = cboAvailTestNeedData
            CharsNeedMatch = 1
          end
          object cboCollType: TORComboBox
            Left = 15
            Top = 58
            Width = 246
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Collection Type'
            Color = clWindow
            DropDownCount = 8
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentFont = False
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 1
            Text = ''
            OnChange = cboCollTypeChange
            OnClick = cboCollTypeClick
            OnEnter = cboCollTypeEnter
            CharsNeedMatch = 1
          end
          object cboCollTime: TORComboBox
            Left = 15
            Top = 103
            Width = 206
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Collection Date/Time'
            Color = clWindow
            DropDownCount = 8
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentFont = False
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 2
            Text = ''
            OnChange = cboCollTimeChange
            OnEnter = cboCollTimeEnter
            CharsNeedMatch = 1
          end
          object txtImmedColl: TCaptionEdit
            Left = 15
            Top = 103
            Width = 206
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
            OnEnter = txtImmedCollEnter
            Caption = ''
          end
        end
        object pnlBloodComponents: TGroupBox
          Left = 5
          Top = 0
          Width = 320
          Height = 138
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Blood Components'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          OnClick = pnlBloodComponentsClick
          OnEnter = pnlBloodComponentsEnter
          OnExit = pnlBloodComponentsExit
          object lblQuantity: TLabel
            Left = 248
            Top = 0
            Width = 48
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Quantity'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblModifiers: TLabel
            Left = 9
            Top = 41
            Width = 55
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Modifiers'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblWanted: TLabel
            Left = 9
            Top = 88
            Width = 116
            Height = 16
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Caption = 'Date/Time Wanted'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object cboAvailComp: TORComboBox
            Left = 14
            Top = 16
            Width = 226
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Blood Components'
            Color = clWindow
            DropDownCount = 8
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = False
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentFont = False
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 0
            TabStop = True
            Text = ''
            OnEnter = cboAvailCompEnter
            OnExit = cboAvailCompExit
            OnMouseClick = cboAvailCompSelect
            OnNeedData = cboAvailCompNeedData
            CharsNeedMatch = 1
          end
          object tQuantity: TEdit
            Left = 248
            Top = 16
            Width = 31
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnChange = tQuantityChange
            OnClick = tQuantityClick
            OnEnter = tQuantityEnter
          end
          object cboModifiers: TORComboBox
            Left = 14
            Top = 58
            Width = 226
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsDropDown
            AutoSelect = True
            Caption = 'Modifier'
            Color = clWindow
            DropDownCount = 8
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = False
            LookupPiece = 0
            MaxLength = 0
            ParentFont = False
            Sorted = False
            SynonymChars = '<>'
            TabOrder = 2
            Text = ''
            OnChange = cboModifiersChange
            OnEnter = cboModifiersEnter
            CharsNeedMatch = 1
          end
          object calWantTime: TORDateBox
            Left = 14
            Top = 103
            Width = 226
            Height = 24
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnChange = calWantTimeChange
            OnEnter = calWantTimeEnter
            DateOnly = False
            RequireTime = False
            Caption = ''
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 653
        Height = 44
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = ' Personal Quick Orders'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object cboQuick: TORComboBox
          Left = 19
          Top = 14
          Width = 635
          Height = 24
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Style = orcsDropDown
          AutoSelect = True
          Caption = ''
          Color = clWindow
          DropDownCount = 8
          ItemHeight = 16
          ItemTipColor = clWindow
          ItemTipEnable = True
          ListItemsOnly = False
          LongList = True
          LookupPiece = 0
          MaxLength = 0
          Pieces = '2'
          Sorted = False
          SynonymChars = '<>'
          TabOrder = 0
          Text = ''
          OnClick = cboQuickClick
          CharsNeedMatch = 1
        end
      end
      object pnlSelectedTests: TGroupBox
        Left = 0
        Top = 444
        Width = 653
        Height = 136
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Selected Components and Tests'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Visible = False
        object lvSelectionList: TCaptionListView
          Left = 6
          Top = 19
          Width = 538
          Height = 114
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Columns = <
            item
              AutoSize = True
              Caption = 'Test/Component'
            end
            item
              AutoSize = True
              Caption = 'Qty'
            end
            item
              AutoSize = True
              Caption = 'Modifiers'
              MinWidth = 12
            end
            item
              Caption = 'ModifierItemIndex'
              Width = 0
            end
            item
              Caption = 'TestIEN'
              Width = 0
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
          OnClick = lvSelectionListClick
          AutoSize = False
          Caption = 'lvSelectionList'
          HideTinyColumns = True
        end
        object btnRemove: TButton
          Left = 563
          Top = 46
          Width = 93
          Height = 27
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Remove'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnRemoveClick
        end
        object btnRemoveAll: TButton
          Left = 563
          Top = 80
          Width = 93
          Height = 26
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Remove All'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnRemoveAllClick
        end
      end
    end
    object TabResults: TTabSheet
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Lab Results'
      object edtResults: TCaptionRichEdit
        Left = 0
        Top = 0
        Width = 653
        Height = 590
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Zoom = 100
        Caption = ''
      end
    end
  end
  inherited cmdAccept: TButton
    Left = 569
    Top = 629
    Width = 94
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 2
    Visible = False
    ExplicitLeft = 569
    ExplicitTop = 629
    ExplicitWidth = 94
  end
  inherited cmdQuit: TButton
    Left = 569
    Top = 676
    Width = 65
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 3
    ExplicitLeft = 569
    ExplicitTop = 676
    ExplicitWidth = 65
  end
  inherited pnlMessage: TPanel
    Left = 10
    Top = 641
    Width = 511
    Height = 62
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    ExplicitLeft = 10
    ExplicitTop = 641
    ExplicitWidth = 511
    ExplicitHeight = 62
    inherited imgMessage: TImage
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
    inherited memMessage: TRichEdit
      Top = 6
      Width = 450
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Font.Height = -14
      ExplicitTop = 6
      ExplicitWidth = 450
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODBBank'
        'Status = stsDefault')
      (
        'Component = pnlComments'
        'Status = stsDefault')
      (
        'Component = btnUpdateComments'
        'Status = stsDefault')
      (
        'Component = btnCancelComment'
        'Status = stsDefault')
      (
        'Component = pgeProduct'
        'Status = stsDefault')
      (
        'Component = TabInfo'
        'Status = stsDefault')
      (
        'Component = edtInfo'
        'Status = stsDefault')
      (
        'Component = TabDiag'
        'Status = stsDefault')
      (
        'Component = TabResults'
        'Status = stsDefault')
      (
        'Component = edtResults'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = cboUrgency'
        'Status = stsDefault')
      (
        'Component = chkConsent'
        'Status = stsDefault')
      (
        'Component = cboSurgery'
        'Status = stsDefault')
      (
        'Component = pnlSelect'
        'Status = stsDefault')
      (
        'Component = pnlDiagnosticTests'
        'Status = stsDefault')
      (
        'Component = cboAvailTest'
        'Status = stsDefault')
      (
        'Component = pnlBloodComponents'
        'Status = stsDefault')
      (
        'Component = cboAvailComp'
        'Status = stsDefault')
      (
        'Component = tQuantity'
        'Status = stsDefault')
      (
        'Component = cboModifiers'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = cboQuick'
        'Status = stsDefault')
      (
        'Component = pnlSelectedTests'
        'Status = stsDefault')
      (
        'Component = lvSelectionList'
        'Status = stsDefault')
      (
        'Component = btnRemove'
        'Status = stsDefault')
      (
        'Component = btnRemoveAll'
        'Status = stsDefault')
      (
        'Component = cboReasons'
        'Status = stsDefault')
      (
        'Component = memDiagComment'
        'Status = stsDefault')
      (
        'Component = cboCollType'
        'Status = stsDefault')
      (
        'Component = cboCollTime'
        'Status = stsDefault')
      (
        'Component = txtImmedColl'
        'Status = stsDefault')
      (
        'Component = calCollTime'
        'Text = Collection Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = pnlCollTimeButton'
        'Status = stsDefault')
      (
        'Component = calWantTime'
        'Text = Wanted Date/Time. Press the enter key to access.'
        'Status = stsOK'))
  end
  object dlgLabCollTime: TORDateTimeDlg
    FMDateTime = 2980923.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 435
    Top = 72
  end
  object ORWanted: TORDateTimeDlg
    FMDateTime = 2980923.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 343
    Top = 72
  end
end
