inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 743
  Height = 667
  Caption = 'Infusion Order'
  Constraints.MinHeight = 492
  Constraints.MinWidth = 492
  DoubleBuffered = True
  ExplicitWidth = 743
  ExplicitHeight = 667
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMessage: TPanel [0]
    Left = 128
    Top = 740
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 740
    inherited imgMessage: TImage
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
    inherited memMessage: TRichEdit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
  end
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 0
    Width = 727
    Height = 629
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 5
    OnResize = ScrollBox1Resize
    object pnlForm: TPanel
      Left = 0
      Top = 0
      Width = 710
      Height = 738
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object pnlB1: TPanel
        Left = 0
        Top = 388
        Width = 710
        Height = 350
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alBottom
        TabOrder = 0
        object pnlBottom: TPanel
          Left = 1
          Top = 214
          Width = 708
          Height = 135
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 30
            Width = 698
            Height = 16
            Margins.Left = 6
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Caption = 'Order Sig'
            ExplicitTop = 34
            ExplicitWidth = 57
          end
          object lbl508Required: TVA508StaticText
            Name = 'lbl508Required'
            AlignWithMargins = True
            Left = 6
            Top = 4
            Width = 698
            Height = 18
            Margins.Left = 6
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            Alignment = taLeftJustify
            Caption = ' * Indicates a Required Field'
            TabOrder = 0
            ShowAccelChar = True
          end
          object pnlButtons: TPanel
            Left = 596
            Top = 50
            Width = 112
            Height = 85
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
          end
          object pnlMemOrder: TPanel
            Left = 0
            Top = 50
            Width = 596
            Height = 85
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
        object lblFirstDose: TVA508StaticText
          Name = 'lblFirstDose'
          AlignWithMargins = True
          Left = 5
          Top = 158
          Width = 700
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          Alignment = taLeftJustify
          Caption = 'First Dose'
          TabOrder = 1
          TabStop = True
          Visible = False
          ShowAccelChar = True
        end
        object lblAdminTime: TVA508StaticText
          Name = 'lblAdminTime'
          AlignWithMargins = True
          Left = 5
          Top = 184
          Width = 700
          Height = 18
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 12
          Align = alBottom
          Alignment = taLeftJustify
          Caption = 'Admin Time'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TabStop = True
          Visible = False
          ShowAccelChar = True
        end
        object pnlMiddle: TGridPanel
          Left = 1
          Top = 1
          Width = 708
          Height = 116
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = pnlMiddleSub1
              Row = 0
            end
            item
              Column = 1
              Control = pnlMiddleSub2
              Row = 0
            end
            item
              Column = 2
              Control = pnlMiddleSub3
              Row = 0
            end
            item
              Column = 3
              Control = pnlMiddleSub4
              Row = 0
            end>
          RowCollection = <
            item
              Value = 100.000000000000000000
            end>
          TabOrder = 3
          object pnlMiddleSub1: TGridPanel
            Left = 0
            Top = 0
            Width = 177
            Height = 116
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS11
                Row = 0
              end
              item
                Column = 0
                Control = pnlMS12
                Row = 1
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 0
            object pnlMS11: TPanel
              Left = 0
              Top = 0
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Panel8: TPanel
                Left = 0
                Top = 0
                Width = 177
                Height = 20
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                object txtAllIVRoutes: TLabel
                  Left = 15
                  Top = 0
                  Width = 162
                  Height = 20
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  Align = alRight
                  Caption = '(Expanded Med Route List)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -15
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  Visible = False
                  OnClick = txtAllIVRoutesClick
                  ExplicitHeight = 16
                end
                object lblRoute: TLabel
                  AlignWithMargins = True
                  Left = 6
                  Top = 0
                  Width = 9
                  Height = 20
                  Margins.Left = 6
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Route*'
                  ExplicitWidth = 41
                  ExplicitHeight = 16
                end
              end
              object cboRoute: TORComboBox
                AlignWithMargins = True
                Left = 4
                Top = 24
                Width = 169
                Height = 24
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Style = orcsDropDown
                Align = alClient
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
                Pieces = '2'
                Sorted = False
                SynonymChars = '<>'
                TabOrder = 1
                Text = ''
                OnChange = cboRouteChange
                OnClick = cboRouteClick
                OnExit = cboRouteExit
                OnKeyDown = cboRouteKeyDown
                OnKeyUp = cboRouteKeyUp
                CharsNeedMatch = 1
                UniqueAutoComplete = True
              end
            end
            object pnlMS12: TPanel
              Left = 0
              Top = 58
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object lblPriority: TLabel
                AlignWithMargins = True
                Left = 6
                Top = 4
                Width = 167
                Height = 16
                Margins.Left = 6
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alTop
                Caption = 'Priority*'
                ExplicitWidth = 46
              end
              object cboPriority: TORComboBox
                AlignWithMargins = True
                Left = 6
                Top = 24
                Width = 171
                Height = 24
                Margins.Left = 6
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Style = orcsDropDown
                Align = alClient
                AutoSelect = True
                Caption = 'Priority'
                Color = clWindow
                DropDownCount = 8
                ItemHeight = 16
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
                OnChange = cboPriorityChange
                OnExit = cboPriorityExit
                OnKeyUp = cboPriorityKeyUp
                CharsNeedMatch = 1
              end
            end
          end
          object pnlMiddleSub2: TGridPanel
            Left = 177
            Top = 0
            Width = 177
            Height = 116
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS21
                Row = 0
              end
              item
                Column = 0
                Control = pnlMS22
                Row = 1
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 1
            object pnlMS21: TPanel
              Left = 0
              Top = 0
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Panel9: TPanel
                Left = 0
                Top = 0
                Width = 177
                Height = 20
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                object lblType: TLabel
                  AlignWithMargins = True
                  Left = 6
                  Top = 0
                  Width = 47
                  Height = 20
                  Margins.Left = 6
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Type*'
                  ParentShowHint = False
                  ShowHint = True
                  ExplicitWidth = 37
                  ExplicitHeight = 16
                end
                object lblTypeHelp: TLabel
                  AlignWithMargins = True
                  Left = 53
                  Top = 0
                  Width = 87
                  Height = 20
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 37
                  Margins.Bottom = 0
                  Align = alRight
                  Caption = '(IV Type Help)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -15
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = False
                  OnClick = lblTypeHelpClick
                  ExplicitHeight = 16
                end
              end
              object cboType: TComboBox
                AlignWithMargins = True
                Left = 6
                Top = 24
                Width = 167
                Height = 24
                Margins.Left = 6
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alClient
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnChange = cboTypeChange
                OnKeyDown = cboTypeKeyDown
              end
            end
            object pnlMS22: TPanel
              Left = 0
              Top = 58
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object lblLimit: TLabel
                Left = 0
                Top = 0
                Width = 177
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alTop
                Caption = 'Duration or Total Volume (Optional)'
                ExplicitWidth = 209
              end
              object pnlXDuration: TPanel
                Left = 0
                Top = 16
                Width = 177
                Height = 42
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                OnEnter = pnlXDurationEnter
                object pnlDur: TGridPanel
                  Left = 0
                  Top = 0
                  Width = 177
                  Height = 42
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  Align = alClient
                  BevelOuter = bvNone
                  ColumnCollection = <
                    item
                      Value = 50.000000000000000000
                    end
                    item
                      Value = 50.000000000000000000
                    end>
                  ControlCollection = <
                    item
                      Column = 0
                      Control = pnlTxtDur
                      Row = 0
                    end
                    item
                      Column = 1
                      Control = pnlCbDur
                      Row = 0
                    end>
                  RowCollection = <
                    item
                      Value = 100.000000000000000000
                    end>
                  TabOrder = 0
                  object pnlTxtDur: TPanel
                    Left = 0
                    Top = 0
                    Width = 88
                    Height = 42
                    Margins.Left = 4
                    Margins.Top = 4
                    Margins.Right = 4
                    Margins.Bottom = 4
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object txtXDuration: TCaptionEdit
                      AlignWithMargins = True
                      Left = 6
                      Top = 10
                      Width = 78
                      Height = 26
                      Margins.Left = 6
                      Margins.Top = 10
                      Margins.Right = 4
                      Margins.Bottom = 0
                      Align = alClient
                      Constraints.MaxHeight = 26
                      TabOrder = 0
                      OnChange = txtXDurationChange
                      OnExit = txtXDurationExit
                      Caption = ''
                      ExplicitHeight = 24
                    end
                  end
                  object pnlCbDur: TPanel
                    Left = 88
                    Top = 0
                    Width = 89
                    Height = 42
                    Margins.Left = 4
                    Margins.Top = 4
                    Margins.Right = 4
                    Margins.Bottom = 4
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 1
                    object cboDuration: TComboBox
                      AlignWithMargins = True
                      Left = 6
                      Top = 10
                      Width = 77
                      Height = 24
                      Margins.Left = 6
                      Margins.Top = 10
                      Margins.Right = 6
                      Margins.Bottom = 4
                      Align = alClient
                      AutoComplete = False
                      TabOrder = 0
                      OnChange = cboDurationChange
                      OnEnter = cboDurationEnter
                    end
                  end
                end
              end
            end
          end
          object pnlMiddleSub3: TGridPanel
            Left = 354
            Top = 0
            Width = 177
            Height = 116
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS31
                Row = 0
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end
              item
                SizeStyle = ssAuto
              end>
            TabOrder = 2
            object pnlMS31: TPanel
              Left = 0
              Top = 0
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Panel10: TPanel
                Left = 0
                Top = 0
                Width = 177
                Height = 20
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                object lblSchedule: TLabel
                  AlignWithMargins = True
                  Left = 6
                  Top = 0
                  Width = 61
                  Height = 20
                  Margins.Left = 6
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Schedule *'
                  ExplicitWidth = 65
                  ExplicitHeight = 16
                end
                object txtNSS: TLabel
                  AlignWithMargins = True
                  Left = 67
                  Top = 0
                  Width = 85
                  Height = 20
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 25
                  Margins.Bottom = 0
                  Align = alRight
                  AutoSize = False
                  Caption = '(Day-of-Week)'
                  Color = clBtnFace
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -15
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentColor = False
                  ParentFont = False
                  OnClick = txtNSSClick
                  ExplicitLeft = 113
                end
              end
              object cboSchedule: TORComboBox
                AlignWithMargins = True
                Left = 6
                Top = 24
                Width = 95
                Height = 24
                Margins.Left = 6
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Style = orcsDropDown
                Align = alClient
                AutoSelect = True
                Caption = ''
                Color = clWindow
                DropDownCount = 8
                ItemHeight = 16
                ItemTipColor = clWindow
                ItemTipEnable = True
                ListItemsOnly = False
                LongList = False
                LookupPiece = 1
                MaxLength = 0
                Pieces = '1'
                Sorted = True
                SynonymChars = '<>'
                TabOrder = 1
                Text = ''
                OnChange = cboScheduleChange
                OnClick = cboScheduleClick
                OnExit = cboScheduleExit
                OnKeyDown = cboScheduleKeyDown
                OnKeyUp = cboScheduleKeyUp
                CharsNeedMatch = 1
                UniqueAutoComplete = True
              end
              object Panel6: TPanel
                Left = 105
                Top = 20
                Width = 72
                Height = 38
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 2
                object chkPRN: TCheckBox
                  AlignWithMargins = True
                  Left = 4
                  Top = 0
                  Width = 64
                  Height = 39
                  Margins.Left = 4
                  Margins.Top = 0
                  Margins.Right = 4
                  Margins.Bottom = 0
                  Align = alTop
                  Caption = 'PRN'
                  TabOrder = 0
                  OnClick = chkPRNClick
                end
              end
            end
          end
          object pnlMiddleSub4: TGridPanel
            Left = 531
            Top = 0
            Width = 177
            Height = 116
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS41
                Row = 0
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 3
            object pnlMS41: TPanel
              Left = 0
              Top = 0
              Width = 177
              Height = 58
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblInfusionRate: TLabel
                AlignWithMargins = True
                Left = 4
                Top = 0
                Width = 173
                Height = 16
                Margins.Left = 4
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Infusion Rate (ml/hr)*'
                ExplicitWidth = 124
              end
              object GridPanel1: TGridPanel
                Left = 0
                Top = 16
                Width = 177
                Height = 42
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alClient
                BevelOuter = bvNone
                ColumnCollection = <
                  item
                    Value = 50.000000000000000000
                  end
                  item
                    Value = 50.000000000000000000
                  end>
                ControlCollection = <
                  item
                    Column = 0
                    Control = Panel1
                    Row = 0
                  end
                  item
                    Column = 1
                    Control = Panel3
                    Row = 0
                  end>
                RowCollection = <
                  item
                    Value = 100.000000000000000000
                  end>
                TabOrder = 0
                object Panel1: TPanel
                  Left = 0
                  Top = 0
                  Width = 88
                  Height = 42
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 0
                  object txtRate: TCaptionEdit
                    AlignWithMargins = True
                    Left = 6
                    Top = 4
                    Width = 78
                    Height = 26
                    Margins.Left = 6
                    Margins.Top = 4
                    Margins.Right = 4
                    Margins.Bottom = 4
                    Align = alClient
                    AutoSelect = False
                    Constraints.MaxHeight = 26
                    TabOrder = 0
                    OnChange = txtRateChange
                    Caption = 'Infusion Rate'
                    ExplicitHeight = 24
                  end
                end
                object Panel3: TPanel
                  Left = 88
                  Top = 0
                  Width = 89
                  Height = 42
                  Margins.Left = 4
                  Margins.Top = 4
                  Margins.Right = 4
                  Margins.Bottom = 4
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 1
                  object cboInfusionTime: TComboBox
                    AlignWithMargins = True
                    Left = 6
                    Top = 4
                    Width = 79
                    Height = 24
                    Margins.Left = 6
                    Margins.Top = 4
                    Margins.Right = 4
                    Margins.Bottom = 4
                    Align = alClient
                    TabOrder = 0
                    OnChange = cboInfusionTimeChange
                    OnEnter = cboInfusionTimeEnter
                  end
                end
              end
            end
          end
        end
        object chkDoseNow: TCheckBox
          AlignWithMargins = True
          Left = 7
          Top = 121
          Width = 698
          Height = 21
          Margins.Left = 6
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 12
          Align = alBottom
          Caption = 'Give Additional Dose Now'
          Constraints.MinWidth = 181
          TabOrder = 4
          OnClick = chkDoseNowClick
        end
      end
      object pnlTop: TGridPanel
        Left = 0
        Top = 0
        Width = 710
        Height = 388
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        ColumnCollection = <
          item
            Value = 32.654668176316890000
          end
          item
            Value = 67.345331823683110000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = pnlTopRight
            Row = 0
          end
          item
            Column = 0
            Control = pnlCombo
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 1
        object pnlTopRight: TGridPanel
          Left = 232
          Top = 1
          Width = 477
          Height = 386
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = pnlTopRightTop
              Row = 0
            end
            item
              Column = 0
              Control = Panel2
              Row = 2
            end
            item
              Column = 0
              Control = cmdRemove
              Row = 1
            end>
          RowCollection = <
            item
              Value = 48.495496523256290000
            end
            item
              Value = 8.240509903676616000
            end
            item
              Value = 43.263993573067100000
            end>
          TabOrder = 0
          object pnlTopRightTop: TPanel
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 469
            Height = 179
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object pnlTopRightLbls: TPanel
              Left = 0
              Top = 0
              Width = 469
              Height = 30
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object lblAmount: TLabel
                Left = 132
                Top = 6
                Width = 106
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Caption = 'Volume/Strength*'
                WordWrap = True
              end
              object lblComponent: TLabel
                Left = 5
                Top = 6
                Width = 108
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Caption = 'Solution/Additive*'
              end
              object lblAddFreq: TLabel
                Left = 252
                Top = 6
                Width = 121
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Caption = 'Additive Frequency*'
              end
              object lblPrevAddFreq: TLabel
                Left = 377
                Top = 6
                Width = 96
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Caption = 'Prev. Add. Freq.'
              end
            end
            object grdSelected: TCaptionStringGrid
              Left = 0
              Top = 30
              Width = 469
              Height = 149
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              DefaultColWidth = 100
              DefaultRowHeight = 19
              DefaultDrawing = False
              FixedCols = 0
              RowCount = 1
              FixedRows = 0
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
              ScrollBars = ssVertical
              TabOrder = 1
              OnDrawCell = grdSelectedDrawCell
              OnKeyPress = grdSelectedKeyPress
              OnMouseDown = grdSelectedMouseDown
              Caption = ''
            end
            object txtSelected: TCaptionEdit
              Tag = -1
              Left = 27
              Top = 80
              Width = 55
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 2
              Text = 'meq.'
              Visible = False
              OnChange = txtSelectedChange
              OnExit = txtSelectedExit
              OnKeyDown = txtSelectedKeyDown
              Caption = 'Volume'
            end
            object cboSelected: TCaptionComboBox
              Tag = -1
              Left = 90
              Top = 80
              Width = 65
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Style = csDropDownList
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 4
              Visible = False
              OnCloseUp = cboSelectedCloseUp
              OnKeyDown = cboSelectedKeyDown
              Caption = 'Volume/Strength'
            end
            object cboAddFreq: TCaptionComboBox
              Left = 162
              Top = 80
              Width = 179
              Height = 24
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              TabOrder = 6
              Visible = False
              OnCloseUp = cboAddFreqCloseUp
              OnKeyDown = cboAddFreqKeyDown
              Caption = ''
            end
          end
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 4
            Top = 222
            Width = 469
            Height = 160
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object lblComments: TLabel
              Left = 0
              Top = 0
              Width = 469
              Height = 16
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alTop
              Caption = 'Comments'
              ExplicitWidth = 64
            end
            object memComments: TCaptionMemo
              Left = 0
              Top = 16
              Width = 469
              Height = 144
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alClient
              Lines.Strings = (
                'memComments')
              ScrollBars = ssVertical
              TabOrder = 0
              OnChange = ControlChange
              Caption = 'Comments'
            end
          end
          object cmdRemove: TButton
            AlignWithMargins = True
            Left = 261
            Top = 187
            Width = 93
            Height = 31
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 123
            Margins.Bottom = 0
            Align = alRight
            Caption = 'Remove'
            TabOrder = 2
            OnClick = cmdRemoveClick
          end
        end
        object pnlCombo: TPanel
          AlignWithMargins = True
          Left = 7
          Top = 5
          Width = 221
          Height = 378
          Margins.Left = 6
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object cboAdditive: TORComboBox
            Left = 0
            Top = 25
            Width = 221
            Height = 353
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsSimple
            Align = alClient
            AutoSelect = True
            Caption = 'Additives'
            Color = clWindow
            DropDownCount = 11
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = True
            LookupPiece = 0
            MaxLength = 0
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabPositions = '20'
            TabOrder = 1
            Text = ''
            OnExit = cboAdditiveExit
            OnMouseClick = cboAdditiveMouseClick
            OnNeedData = cboAdditiveNeedData
            CharsNeedMatch = 1
          end
          object tabFluid: TTabControl
            Left = 0
            Top = 0
            Width = 221
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alTop
            TabHeight = 15
            TabOrder = 2
            Tabs.Strings = (
              '   Solutions   '
              '   Additives   ')
            TabIndex = 0
            OnChange = tabFluidChange
          end
          object cboSolution: TORComboBox
            Left = 0
            Top = 25
            Width = 221
            Height = 353
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Style = orcsSimple
            Align = alClient
            AutoSelect = True
            Caption = 'Solutions'
            Color = clWindow
            DropDownCount = 11
            ItemHeight = 16
            ItemTipColor = clWindow
            ItemTipEnable = True
            ListItemsOnly = True
            LongList = True
            LookupPiece = 0
            MaxLength = 0
            Pieces = '2'
            Sorted = False
            SynonymChars = '<>'
            TabPositions = '20'
            TabOrder = 0
            Text = ''
            OnExit = cboSolutionExit
            OnMouseClick = cboSolutionMouseClick
            OnNeedData = cboSolutionNeedData
            CharsNeedMatch = 1
          end
        end
      end
    end
  end
  inherited memOrder: TCaptionMemo [2]
    AlignWithMargins = True
    Left = 12
    Top = 657
    Width = 682
    Height = 61
    Margins.Left = 6
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    ExplicitLeft = 12
    ExplicitTop = 657
    ExplicitWidth = 682
    ExplicitHeight = 61
  end
  inherited cmdAccept: TButton [3]
    AlignWithMargins = True
    Left = 741
    Top = 660
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 741
    ExplicitTop = 660
  end
  inherited cmdQuit: TButton [4]
    AlignWithMargins = True
    Left = 757
    Top = 695
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 757
    ExplicitTop = 695
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 8
    Data = (
      (
        'Component = memOrder'
        'Label = Label1'
        'Status = stsOK')
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
        'Component = frmODMedIV'
        'Status = stsDefault')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = lblFirstDose'
        'Status = stsDefault')
      (
        'Component = lbl508Required'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRight'
        'Status = stsDefault')
      (
        'Component = pnlTopRightTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRightLbls'
        'Status = stsDefault')
      (
        'Component = pnlCombo'
        'Status = stsDefault')
      (
        'Component = cboAdditive'
        'Status = stsDefault')
      (
        'Component = tabFluid'
        'Status = stsDefault')
      (
        'Component = cboSolution'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = txtSelected'
        'Status = stsDefault')
      (
        'Component = cboSelected'
        'Status = stsDefault')
      (
        'Component = cboAddFreq'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub1'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub2'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub3'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub4'
        'Status = stsDefault')
      (
        'Component = pnlMS11'
        'Status = stsDefault')
      (
        'Component = pnlMS12'
        'Status = stsDefault')
      (
        'Component = pnlMS21'
        'Status = stsDefault')
      (
        'Component = pnlMS22'
        'Status = stsDefault')
      (
        'Component = pnlMS31'
        'Status = stsDefault')
      (
        'Component = pnlMS41'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboType'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = pnlDur'
        'Status = stsDefault')
      (
        'Component = pnlTxtDur'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = pnlCbDur'
        'Status = stsDefault')
      (
        'Component = cboDuration'
        'Status = stsDefault')
      (
        'Component = GridPanel1'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = txtRate'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = cboInfusionTime'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlMemOrder'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = ScrollBox1'
        'Status = stsDefault')
      (
        'Component = pnlForm'
        'Status = stsDefault')
      (
        'Component = pnlB1'
        'Status = stsDefault'))
  end
  object VA508CompOrderSig: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompOrderSigStateQuery
    Left = 24
    Top = 184
  end
  object VA508CompRoute: TVA508ComponentAccessibility
    Component = cboRoute
    OnInstructionsQuery = VA508CompRouteInstructionsQuery
    Left = 104
    Top = 64
  end
  object VA508CompType: TVA508ComponentAccessibility
    Component = cboType
    OnInstructionsQuery = VA508CompTypeInstructionsQuery
    Left = 104
    Top = 8
  end
  object VA508CompSchedule: TVA508ComponentAccessibility
    Component = cboSchedule
    OnInstructionsQuery = VA508CompScheduleInstructionsQuery
    Left = 32
    Top = 120
  end
  object VA508CompGrdSelected: TVA508ComponentAccessibility
    Component = grdSelected
    OnCaptionQuery = VA508CompGrdSelectedCaptionQuery
    Left = 40
    Top = 56
  end
end
