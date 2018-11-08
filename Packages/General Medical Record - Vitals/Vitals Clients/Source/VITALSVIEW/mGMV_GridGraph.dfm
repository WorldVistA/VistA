object fraGMV_GridGraph: TfraGMV_GridGraph
  Left = 0
  Top = 0
  Width = 935
  Height = 571
  ParentShowHint = False
  ShowHint = False
  TabOrder = 0
  Visible = False
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 935
    Height = 571
    Align = alClient
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object pnlGridGraph: TPanel
      Left = 0
      Top = 95
      Width = 935
      Height = 476
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object splGridGraph: TSplitter
        Left = 0
        Top = 205
        Width = 935
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        Color = clSilver
        ParentColor = False
        OnMoved = splGridGraphMoved
      end
      object pnlGraph: TPanel
        Left = 0
        Top = 0
        Width = 935
        Height = 205
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlGraph'
        Constraints.MinHeight = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object pnlDateRange: TPanel
          Left = 0
          Top = 0
          Width = 120
          Height = 205
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object pnlGraphOptions: TPanel
            Left = 0
            Top = 105
            Width = 120
            Height = 100
            Align = alBottom
            BevelOuter = bvNone
            PopupMenu = PopupMenu1
            TabOrder = 1
            object cbValues: TCheckBox
              Left = 8
              Top = 4
              Width = 97
              Height = 17
              Action = acValueCaptions
              Caption = 'Va&lues'
              PopupMenu = PopupMenu1
              TabOrder = 0
            end
            object ckb3D: TCheckBox
              Left = 8
              Top = 36
              Width = 41
              Height = 17
              Action = ac3D
              PopupMenu = PopupMenu1
              TabOrder = 2
            end
            object cbAllowZoom: TCheckBox
              Left = 8
              Top = 52
              Width = 97
              Height = 17
              Action = acZoom
              PopupMenu = PopupMenu1
              TabOrder = 3
            end
            object cbChrono: TCheckBox
              Left = 8
              Top = 20
              Width = 97
              Height = 17
              Caption = 'Ti&me Scale'
              Checked = True
              State = cbChecked
              TabOrder = 1
              OnClick = cbChronoClick
            end
            object pnlZoom: TPanel
              Left = 0
              Top = 69
              Width = 120
              Height = 31
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 4
              DesignSize = (
                120
                31)
              object sbPlus: TSpeedButton
                Left = 33
                Top = 4
                Width = 23
                Height = 22
                Action = acZoomIn
                Flat = True
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF007F7F7F000000000000000000000000007F7F7F00FF00FF0000FF
                  FF007F7F7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
                  000000FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
                  00007F7F7F00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F000000
                  0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF007F7F7F007F7F
                  7F00FFFFFF00BFBFBF00FFFFFF000000FF00FFFFFF00BFBFBF00FFFFFF007F7F
                  7F007F7F7F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00BFBFBF00FFFFFF00BFBFBF000000FF00BFBFBF00FFFFFF00BFBFBF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00BFBFBF00FFFFFF00BFBFBF000000FF00BFBFBF00FFFFFF00BFBFBF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF007F7F7F007F7F
                  7F00FFFFFF00BFBFBF00FFFFFF000000FF00FFFFFF00BFBFBF00FFFFFF007F7F
                  7F007F7F7F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
                  00007F7F7F00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F000000
                  0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF007F7F7F000000000000000000000000007F7F7F00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
              end
              object sbMinus: TSpeedButton
                Left = 56
                Top = 4
                Width = 23
                Height = 22
                Action = acZoomOut
                Flat = True
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF007F7F7F000000000000000000000000007F7F7F00FF00FF0000FF
                  FF007F7F7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
                  000000FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
                  00007F7F7F00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F000000
                  0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF007F7F7F007F7F
                  7F00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F
                  7F007F7F7F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00BFBFBF000000FF000000FF000000FF000000FF000000FF00BFBFBF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000007F7F
                  7F00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F
                  7F0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF007F7F7F007F7F
                  7F00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F
                  7F007F7F7F00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
                  00007F7F7F00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F000000
                  0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF007F7F7F000000000000000000000000007F7F7F00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
              end
              object sbReset: TSpeedButton
                Left = 79
                Top = 4
                Width = 27
                Height = 22
                Action = acZoomReset
                Anchors = [akTop, akRight]
                Flat = True
                Glyph.Data = {
                  36040000424D3604000000000000360000002800000010000000100000000100
                  2000000000000004000000000000000000000000000000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF000000FF000000FF000000FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF000000FF000000FF000000FF000000FF000000FF000000FF000000
                  FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF000000FF000000FF000000FF00FF00FF007F7F7F00000000007F7F7F00FF00
                  FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00FF000000
                  FF000000FF000000FF00FF00FF00FF00FF00000000000000000000000000FF00
                  FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF000000
                  FF000000FF00FF00FF00FF00FF00FF00FF007F7F7F00000000007F7F7F00FF00
                  FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF000000FF000000FF00FF00FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF000000FF000000FF00FF00FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF007F7F7F00000000007F7F7F00FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00000080000000000000008000FF00
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00
                  FF000000FF000000FF000000FF000000FF000000FF00FF00FF00FF00FF000000
                  FF000000FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00
                  FF00FF00FF000000FF000000FF000000FF000000FF00FF00FF00FF00FF000000
                  FF000000FF000000FF00FF00FF00FF00FF00000000000000000000000000FF00
                  FF00FF00FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00
                  FF000000FF000000FF000000FF00FF00FF007F7F7F00000000007F7F7F00FF00
                  FF000000FF000000FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00
                  FF00FF00FF000000FF000000FF000000FF000000FF000000FF000000FF000000
                  FF000000FF000000FF00FF00FF00FF00FF000000FF00FF00FF00FF00FF00FF00
                  FF00FF00FF00FF00FF00FF00FF000000FF000000FF000000FF000000FF000000
                  FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
              end
              object edZoom: TEdit
                Left = 8
                Top = 4
                Width = 23
                Height = 21
                Hint = 'Zoom percent'
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 0
                Text = '10'
              end
            end
          end
          object Panel5: TPanel
            Left = 0
            Top = 0
            Width = 120
            Height = 105
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object pnlPTop: TPanel
              Left = 0
              Top = 0
              Width = 120
              Height = 3
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
            end
            object pnlPRight: TPanel
              Left = 117
              Top = 3
              Width = 3
              Height = 99
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 3
            end
            object pnlPLeft: TPanel
              Left = 0
              Top = 3
              Width = 2
              Height = 99
              Align = alLeft
              BevelOuter = bvNone
              TabOrder = 1
            end
            object pnlPBot: TPanel
              Left = 0
              Top = 102
              Width = 120
              Height = 3
              Align = alBottom
              BevelOuter = bvNone
              TabOrder = 4
            end
            object pnlDateRangeTop: TPanel
              Left = 2
              Top = 3
              Width = 115
              Height = 99
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 2
              object lbDateRange: TListBox
                Left = 0
                Top = 25
                Width = 115
                Height = 74
                Align = alClient
                BevelInner = bvNone
                BevelOuter = bvNone
                BorderStyle = bsNone
                Color = clSilver
                Ctl3D = False
                ItemHeight = 13
                ParentCtl3D = False
                PopupMenu = PopupMenu1
                TabOrder = 1
                OnDblClick = cbxDateRangeClick
                OnEnter = lbDateRangeEnter
                OnExit = lbDateRangeExit
                OnKeyDown = lbDateRangeKeyDown
                OnMouseMove = lbDateRangeMouseMove
                OnMouseUp = lbDateRangeMouseUp
              end
              object Panel6: TPanel
                Left = 0
                Top = 0
                Width = 115
                Height = 25
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                Visible = False
                object lblDateRange: TLabel
                  Left = 8
                  Top = 8
                  Width = 69
                  Height = 13
                  Caption = '&Date Range'
                  FocusControl = lbDateRange
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'MS Sans Serif'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
              end
            end
          end
        end
        object pnlGraphBackground: TPanel
          Left = 120
          Top = 0
          Width = 815
          Height = 205
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Sorry, no graph available for this vital type.'
          TabOrder = 1
          object Bevel1: TBevel
            Left = 0
            Top = 0
            Width = 759
            Height = 205
            Align = alClient
          end
          object chrtVitals: TChart
            Left = 0
            Top = 0
            Width = 759
            Height = 205
            BackImage.Inside = True
            BackWall.Brush.Style = bsClear
            BottomWall.Size = 1
            Foot.Visible = False
            Gradient.EndColor = 15724527
            Legend.Alignment = laTop
            Legend.ColorWidth = 65
            Legend.Font.Charset = ANSI_CHARSET
            Legend.Font.Name = 'Times New Roman'
            Legend.HorizMargin = 5
            Legend.LegendStyle = lsSeries
            Legend.Shadow.Color = clSilver
            Legend.Shadow.HorizSize = 0
            Legend.Shadow.VertSize = 0
            Legend.Symbol.Width = 65
            Legend.TextStyle = ltsRightValue
            Legend.TopPos = 40
            Legend.VertMargin = 12
            MarginBottom = 2
            MarginLeft = 4
            MarginRight = 6
            MarginTop = 3
            PrintProportional = False
            Title.Alignment = taLeftJustify
            Title.Font.Color = clBlack
            Title.Font.Height = -13
            Title.Font.Name = 'Microsoft Sans Serif'
            Title.Frame.Color = clWhite
            Title.Frame.Style = psClear
            Title.Text.Strings = (
              'PtName, Ward Loc')
            Title.Visible = False
            OnClickLegend = chrtVitalsClickLegend
            OnClickSeries = chrtVitalsClickSeries
            OnScroll = scbHGraphChange
            BottomAxis.DateTimeFormat = 'M/d/yyyy'
            BottomAxis.Grid.Color = 3947580
            BottomAxis.Increment = 0.083333333333333300
            BottomAxis.LabelsMultiLine = True
            BottomAxis.LabelsSize = 35
            BottomAxis.MinorGrid.Color = clRed
            BottomAxis.MinorGrid.Visible = True
            BottomAxis.MinorTickCount = 0
            BottomAxis.MinorTickLength = 0
            BottomAxis.TickLength = 8
            Chart3DPercent = 10
            LeftAxis.ExactDateTime = False
            LeftAxis.Increment = 1.000000000000000000
            LeftAxis.LabelsFormat.Font.Height = -9
            LeftAxis.LabelsSeparation = 5
            LeftAxis.MinorTickCount = 4
            LeftAxis.MinorTickLength = 4
            LeftAxis.TickLength = 5
            LeftAxis.TickOnLabelsOnly = False
            Pages.MaxPointsPerPage = 10
            TopAxis.Visible = False
            View3D = False
            View3DOptions.Elevation = 330
            View3DOptions.Perspective = 0
            View3DOptions.Rotation = 316
            View3DOptions.VertOffset = 5
            Zoom.AnimatedSteps = 10
            OnAfterDraw = chrtVitalsAfterDraw
            OnBeforeDrawSeries = chrtVitalsBeforeDrawSeries
            Align = alClient
            BevelOuter = bvNone
            BevelWidth = 0
            Color = clWhite
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnDblClick = chrtVitalsDblClick
            OnResize = chrtVitalsResize
            DefaultCanvas = 'TGDIPlusCanvas'
            ColorPaletteIndex = 13
            object Series1: TLineSeries
              Marks.Visible = True
              Marks.Style = smsValue
              Marks.Arrow.Color = 4194368
              Marks.BackColor = 16777088
              Marks.Callout.Arrow.Color = 4194368
              Marks.Callout.Length = 4
              Marks.Color = 16777088
              SeriesColor = 10485760
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.Brush.Gradient.EndColor = 10485760
              Pointer.Gradient.EndColor = 10485760
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Width = 2
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 5
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series2: TLineSeries
              Marks.Visible = True
              Marks.Style = smsValue
              Marks.Arrow.Color = 4194368
              Marks.BackColor = 8454016
              Marks.Callout.Arrow.Color = 4194368
              Marks.Callout.Length = 4
              Marks.Color = 8454016
              SeriesColor = clGreen
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.Brush.Gradient.EndColor = clGreen
              Pointer.Gradient.EndColor = clGreen
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 5
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
            object Series3: TLineSeries
              Marks.Visible = True
              Marks.Style = smsValue
              Marks.Callout.Length = 4
              SeriesColor = 8421631
              Brush.BackColor = clDefault
              LinePen.Width = 2
              Pointer.Brush.Gradient.EndColor = 8421631
              Pointer.Gradient.EndColor = 8421631
              Pointer.HorizSize = 5
              Pointer.InflateMargins = True
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 5
              Pointer.Visible = True
              XValues.DateTime = True
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
          object pnlRight: TPanel
            Left = 759
            Top = 0
            Width = 56
            Height = 205
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
            Visible = False
          end
        end
      end
      object pnlGrid: TPanel
        Left = 0
        Top = 210
        Width = 935
        Height = 266
        Align = alBottom
        BevelOuter = bvLowered
        Constraints.MinHeight = 100
        TabOrder = 1
        object grdVitals: TStringGrid
          Left = 4
          Top = 33
          Width = 928
          Height = 230
          Align = alClient
          BorderStyle = bsNone
          Color = clBtnFace
          ColCount = 2
          DefaultColWidth = 112
          DefaultRowHeight = 14
          DefaultDrawing = False
          RowCount = 15
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 3
          OnDrawCell = grdVitalsDrawCell
          OnEnter = grdVitalsEnter
          OnExit = grdVitalsExit
          OnMouseDown = grdVitalsSelectCell
          OnMouseMove = grdVitalsMouseMove
          OnTopLeftChanged = grdVitalsTopLeftChanged
          RowHeights = (
            14
            14
            14
            15
            14
            14
            14
            14
            14
            14
            14
            14
            14
            14
            14)
        end
        object pnlGridTop: TPanel
          Left = 1
          Top = 1
          Width = 933
          Height = 29
          Align = alTop
          BevelOuter = bvNone
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          object pnlGSelect: TPanel
            Left = 0
            Top = 0
            Width = 119
            Height = 29
            Align = alLeft
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 0
            DesignSize = (
              119
              29)
            object Label1: TLabel
              Left = 11
              Top = 6
              Width = 39
              Height = 13
              Alignment = taRightJustify
              Caption = '&Graph:'
              FocusControl = cbxGraph
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              WordWrap = True
            end
            object cbxGraph: TComboBox
              Left = 4
              Top = 4
              Width = 111
              Height = 21
              BevelInner = bvNone
              BevelOuter = bvNone
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              Color = clSilver
              DropDownCount = 12
              TabOrder = 3
              OnChange = cbxGraphChange
              OnEnter = cbxGraphEnter
              OnExit = cbxGraphExit
            end
            object pnlGSelectLeft: TPanel
              Left = 0
              Top = 2
              Width = 2
              Height = 25
              Align = alLeft
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
            end
            object pnlGSelectRight: TPanel
              Left = 116
              Top = 2
              Width = 3
              Height = 25
              Align = alRight
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 2
            end
            object pnlGSelectBottom: TPanel
              Left = 0
              Top = 27
              Width = 119
              Height = 2
              Align = alBottom
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 4
              ExplicitLeft = 8
              ExplicitTop = 25
            end
            object pnlGSelectTop: TPanel
              Left = 0
              Top = 0
              Width = 119
              Height = 2
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
            end
          end
          object Panel4: TPanel
            Left = 119
            Top = 0
            Width = 814
            Height = 29
            Align = alClient
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            DesignSize = (
              814
              29)
            object trbHGraph: TTrackBar
              Left = 22
              Top = 1
              Width = 770
              Height = 27
              Anchors = [akLeft, akRight, akBottom]
              Ctl3D = True
              ParentCtl3D = False
              TabOrder = 0
              ThumbLength = 12
              TickMarks = tmTopLeft
              OnChange = scbHGraphChange
            end
          end
        end
        object pnlGBot: TPanel
          Left = 1
          Top = 263
          Width = 933
          Height = 2
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 5
        end
        object pnlGTop: TPanel
          Left = 1
          Top = 30
          Width = 933
          Height = 3
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
        end
        object pnlGLeft: TPanel
          Left = 1
          Top = 33
          Width = 3
          Height = 230
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 2
        end
        object pnlGRight: TPanel
          Left = 932
          Top = 33
          Width = 2
          Height = 230
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 4
        end
      end
    end
    object pnlTitle: TPanel
      Left = 0
      Top = 0
      Width = 935
      Height = 50
      Align = alTop
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      TabOrder = 0
      Visible = False
      object pnlPtInfo: TPanel
        Left = 0
        Top = 0
        Width = 233
        Height = 50
        Hint = 'Selected patient demographics.'
        Align = alLeft
        BevelOuter = bvNone
        Color = clSilver
        TabOrder = 0
        TabStop = True
        OnEnter = pnlPtInfoEnter
        OnExit = pnlPtInfoExit
        OnMouseDown = pnlPtInfoMouseDown
        OnMouseUp = pnlPtInfoMouseUp
        DesignSize = (
          233
          50)
        object Bevel2: TBevel
          Left = 224
          Top = 0
          Width = 9
          Height = 50
          Align = alRight
          Shape = bsRightLine
        end
        object edPatientName: TEdit
          Left = 8
          Top = 6
          Width = 217
          Height = 15
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clSilver
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = 'edPatientName'
          OnMouseDown = pnlPtInfoMouseDown
          OnMouseUp = pnlPtInfoMouseUp
        end
        object edPatientInfo: TEdit
          Left = 8
          Top = 25
          Width = 217
          Height = 15
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          BorderStyle = bsNone
          Color = clSilver
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = 'edPatientInfo'
          OnMouseDown = pnlPtInfoMouseDown
          OnMouseUp = pnlPtInfoMouseUp
        end
      end
      object Panel9: TPanel
        Left = 233
        Top = 0
        Width = 468
        Height = 50
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        OnResize = Panel9Resize
        DesignSize = (
          468
          50)
        object lblHospital: TLabel
          Left = 140
          Top = 6
          Width = 39
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          Caption = '             '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 7
          Top = 6
          Width = 126
          Height = 16
          Caption = 'Hospital Location:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Bevel3: TBevel
          Left = 459
          Top = 0
          Width = 9
          Height = 50
          Align = alRight
          Shape = bsRightLine
        end
        object pnlDateRangeInfo: TPanel
          Left = 0
          Top = 25
          Width = 466
          Height = 25
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object Label11: TLabel
            Left = 8
            Top = 4
            Width = 72
            Height = 16
            Caption = 'From - To:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblDateFromTitle: TLabel
            Left = 84
            Top = 4
            Width = 102
            Height = 16
            Caption = '                                  '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object pnlActions: TPanel
        Left = 701
        Top = 0
        Width = 234
        Height = 50
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 2
        object sbEnterVitals: TSpeedButton
          Left = 88
          Top = 2
          Width = 78
          Height = 44
          Action = acEnterVitals
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
            000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
            00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
            F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
            0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
            FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
            FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
            0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
            00333377737FFFFF773333303300000003333337337777777333}
          Layout = blGlyphTop
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
        end
        object sbEnteredInError: TSpeedButton
          Left = 2
          Top = 2
          Width = 86
          Height = 44
          Action = acEnteredInError
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            55555FFFFFFF5F55FFF5777777757559995777777775755777F7555555555550
            305555555555FF57F7F555555550055BB0555555555775F777F55555550FB000
            005555555575577777F5555550FB0BF0F05555555755755757F555550FBFBF0F
            B05555557F55557557F555550BFBF0FB005555557F55575577F555500FBFBFB0
            B05555577F555557F7F5550E0BFBFB00B055557575F55577F7F550EEE0BFB0B0
            B05557FF575F5757F7F5000EEE0BFBF0B055777FF575FFF7F7F50000EEE00000
            B0557777FF577777F7F500000E055550805577777F7555575755500000555555
            05555777775555557F5555000555555505555577755555557555}
          Layout = blGlyphTop
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
        end
        object sbtnAllergies: TSpeedButton
          Left = 166
          Top = 2
          Width = 63
          Height = 44
          Action = acPatientAllergies
          AllowAllUp = True
          Flat = True
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000C40E0000C40E00000001000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000000000000000000000000000000000000A0A0A0A0A0A
            0F0F0F0F0F0A0A0A0A0A0A0A0A0A0F04040404040F0F0F0A0A0A0A0A0A040404
            0404040404040F0F0A0A0A0A04040404040404040404040F0F0A0A0404040404
            0F0F0F0F040404040F0A0A04040404040F0F0F0F0F0404040F0F040404040404
            0F0F0F0404040404040F040404040F0F0F0F0F0404040404040F04040404040F
            0F0F0F0404040404040F0404040404040F0F0F0F04040404040F040404040404
            0404040404040404040A0A0404040404040F0F04040404040F0A0A0404040404
            0F0F0F0F040404040A0A0A0A04040404040F0F040404040A0A0A0A0A0A040404
            0404040404040A0A0A0A0A0A0A0A0A04040404040A0A0A0A0A0A}
          Layout = blGlyphTop
          Spacing = 1
        end
      end
    end
    object pnlDebug: TPanel
      Left = 0
      Top = 50
      Width = 935
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      Visible = False
      object sbTest: TStatusBar
        Left = 0
        Top = 0
        Width = 935
        Height = 39
        Align = alTop
        Panels = <>
      end
    end
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 400
    Top = 8
    object acResizeGraph: TAction
      Caption = 'Resi&ze'
      Hint = 'Maximize/Restore graph.'
      ImageIndex = 4
      OnExecute = acResizeGraphExecute
    end
    object acPrintGraph: TAction
      Caption = '&Print Graph'
      Hint = 'Print graph to a windows printer.'
      ImageIndex = 3
      ShortCut = 120
      OnExecute = acPrintGraphExecute
    end
    object acValueCaptions: TAction
      Caption = '&Values'
      Hint = 'Show/Hide individual value tags.'
      ImageIndex = 0
      ShortCut = 119
      OnExecute = acValueCaptionsExecute
    end
    object acGraphButtons: TAction
      Caption = 'H/V Graph Buttons '
      ShortCut = 16450
    end
    object acEnterVitals: TAction
      Caption = '&Enter Vitals'
      OnExecute = acEnterVitalsExecute
    end
    object ac3D: TAction
      Caption = '&3D'
      OnExecute = ac3DExecute
    end
    object acOptions: TAction
      Caption = '&Options'
    end
    object acEnteredInError: TAction
      Caption = 'E&ntered in Error'
      OnExecute = acEnteredInErrorExecute
    end
    object acCustomRange: TAction
      Caption = '&Add Range'
      OnExecute = acCustomRangeExecute
    end
    object acZoom: TAction
      Caption = 'Allow &Zoom'
      OnExecute = acZoomExecute
    end
    object acGraphOptions: TAction
      Caption = 'Graph Options'
      Hint = 'Show/hide graph options'
      ShortCut = 49231
      OnExecute = acGraphOptionsExecute
    end
    object acEnteredInErrorByTime: TAction
      Caption = 'Mark as Entered In Error'
      OnExecute = acEnteredInErrorByTimeExecute
    end
    object acPatientAllergies: TAction
      Caption = 'Allergies'
      OnExecute = acPatientAllergiesExecute
    end
    object ColorSelect1: TColorSelect
      Category = 'Dialog'
      Caption = 'Select Graph &Color...'
      Hint = 'Color Select'
      OnAccept = ColorSelect1Accept
    end
    object acZoomOut: TAction
      Hint = 'Zoom Graph Out'
      ImageIndex = 7
      OnExecute = acZoomOutExecute
    end
    object acZoomIn: TAction
      Hint = 'Zoom Graph In'
      ImageIndex = 5
      OnExecute = acZoomInExecute
    end
    object acZoomReset: TAction
      Hint = 'Reset Zoom to Original Value'
      ImageIndex = 9
      OnExecute = acZoomResetExecute
    end
    object acRPCLog: TAction
      Caption = 'Show Rpc Log'
      OnExecute = acRPCLogExecute
    end
    object acUpdateGridColors: TAction
      Caption = 'Update Grid Colors...'
      OnExecute = acUpdateGridColorsExecute
    end
    object acPatientInfo: TAction
      Caption = 'Patient Inquiry'
      ShortCut = 49233
      OnExecute = acPatientInfoExecute
    end
    object acVitalsReport: TAction
      Caption = 'Data Grid Report'
      ShortCut = 49223
      OnExecute = acVitalsReportExecute
    end
    object acShowGraphReport: TAction
      Caption = '&Show Graph Report'
      ShortCut = 49234
      OnExecute = acShowGraphReportExecute
    end
  end
  object ImageList1: TImageList
    Left = 432
    Top = 8
    Bitmap = {
      494C01010B000E00140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F7F007F7F
      7F00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F00000000000000000000000000000000000000FF000000
      FF000000FF00000000007F7F7F00000000007F7F7F00000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000007F7F7F007F7F
      7F000000000000000000000000007F7F7F00FFFFFF00000000007F7F7F007F7F
      7F007F7F7F00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF007F7F7F007F7F
      7F007F7F7F00000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000000000000000000000007F7F7F007F7F7F000000
      000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF00000000000000
      00007F7F7F007F7F7F00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F007F7F7F007F7F7F0000000000FFFFFF007F7F7F007F7F7F007F7F
      7F0000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000007F7F7F00000000007F7F7F0000000000000000000000
      00000000FF000000FF000000000000000000000000007F7F7F007F7F7F000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000007F7F7F00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000007F7F7F007F7F7F00FFFFFF000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000007F7F7F007F7F7F00FFFFFF000000
      00000000000000000000000000007F7F7F00FFFFFF00FFFFFF00000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F0000000000FFFF
      FF00000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000007F7F7F00000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000007F7F7F00FFFF
      FF00000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000008000000000000000800000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00FFFFFF000000
      000000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000007F7F7F00FFFF
      FF00000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000007F7F7F007F7F7F00FFFFFF00FFFF
      FF0000000000000000007F7F7F007F7F7F007F7F7F00FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000FFFFFF000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF0000000000000000007F7F7F0000000000FFFF
      FF00FFFFFF00000000007F7F7F007F7F7F007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000007F7F7F007F7F7F000000
      0000FFFFFF00FFFFFF007F7F7F007F7F7F007F7F7F00FFFFFF0000000000FFFF
      FF007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F0000000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF00000000007F7F7F00000000007F7F7F00000000000000FF000000
      FF000000FF000000FF000000FF000000000000000000000000007F7F7F007F7F
      7F0000000000FFFFFF00000000007F7F7F0000000000FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F0000000000FFFFFF00FFFFFF007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F7F007F7F
      7F0000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000007F7F7F000000000000FFFF007F7F7F000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF007F7F7F007F7F7F007F7F7F0000000000FFFFFF007F7F7F007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000007F7F7F000000000000FFFF007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000000000FFFF000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      00000000000000000000FFFFFF0000000000000000007F7F7F00FFFFFF000000
      00000000000000000000000000000000000000000000000000007F7F7F00BFBF
      BF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00FFFFFF00BFBF
      BF00FFFFFF000000FF00FFFFFF00BFBFBF00FFFFFF007F7F7F007F7F7F000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      0000000000007F7F7F00FFFFFF0000000000000000007F7F7F0000000000FFFF
      FF00000000000000000000000000000000007F7F7F007F7F7F00BFBFBF00FFFF
      FF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00BFBFBF00FFFF
      FF00BFBFBF000000FF00BFBFBF00FFFFFF00BFBFBF007F7F7F00000000000000
      0000000000000000000000000000000000007F7F7F00FFFFFF00000000000000
      0000FFFFFF007F7F7F00FFFFFF00FFFFFF00FFFFFF00000000007F7F7F00FFFF
      FF0000000000000000000000000000000000000000007F7F7F00FFFFFF00BFBF
      BF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF007F7F7F00000000000000
      0000000000000000000000000000000000007F7F7F00FFFFFF00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000007F7F7F00FFFF
      FF0000000000000000000000000000000000000000007F7F7F00BFBFBF000000
      FF000000FF000000FF000000FF000000FF00BFBFBF007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00BFBFBF00FFFF
      FF00BFBFBF000000FF00BFBFBF00FFFFFF00BFBFBF007F7F7F00000000000000
      0000000000000000000000000000000000007F7F7F0000000000FFFFFF000000
      0000000000007F7F7F00FFFFFF000000000000000000000000007F7F7F000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF00BFBF
      BF00FFFFFF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00FFFFFF00BFBF
      BF00FFFFFF000000FF00FFFFFF00BFBFBF00FFFFFF007F7F7F007F7F7F000000
      000000000000000000000000000000000000000000007F7F7F00FFFFFF000000
      0000000000007F7F7F000000000000000000000000007F7F7F00FFFFFF000000
      0000000000000000000000000000000000007F7F7F007F7F7F00BFBFBF00FFFF
      FF00BFBFBF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00FFFF
      FF00BFBFBF00FFFFFF00BFBFBF00FFFFFF007F7F7F0000000000000000000000
      000000000000000000000000000000000000000000007F7F7F0000000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00BFBF
      BF00FFFFFF00BFBFBF00FFFFFF00BFBFBF007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F0000000000FFFFFF00FFFFFF007F7F7F007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C60000FFFF0000FFFF0000FFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840084848400C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C60000000000C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C60000000000C6C6C600000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFF8FFFFFC1F0000FFF0F83FF0070000
      FFE1E00FE3830000FFC3C447CE410000F8878C639C310000E10F9C739EF80000
      CE1F3FF91F7800009F9F3EF91E3D0000BFAF3C7F1C3F0000304F3C7F1C200000
      20CF3C410C0000005FDF9C61A42000009F9F8C7190200000A73FC441CA800000
      C87FE00DE38D0000F1FFF83FF83F0000FFFFFFFDFFF8FFFDFFFFFFF8FFF0FFF8
      C003FFF1FFE1FFF1DFFBFFE3FFC3FFE3DFFBFFC7F887FFC7DFFBE08FE10FE08F
      DFFBC01FCE1FC01FDFFB803F9D9F803FDFFB001FB9AF001FDFFB001F304F001F
      DFFB001F20CF001FC003001F59DF001FC003001F9B9F001FC003803FA73F803F
      FFFFC07FC87FC07FFFFFE0FFF1FFE0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC007
      FFFFFEFFFF7F8003FFFFFCFFFF3F0001FFFFF8FFFF1F0001C1FFF0FFFF0F0001
      C1FFE003C0070000C1FFC003C0030000C1FFE003C00780000001F0FFFF0FC000
      0001F8FFFF1FE0010001FCFFFF3FE0070001FEFFFF7FF0070001FFFFFFFFF003
      0001FFFFFFFFF8030001FFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 464
    Top = 8
    object MarkasEnteredInError1: TMenuItem
      Action = acEnteredInError
    end
    object EnterVitals1: TMenuItem
      Action = acEnterVitals
    end
    object Allergies1: TMenuItem
      Action = acPatientAllergies
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ShowHideGraphOptions1: TMenuItem
      Action = acGraphOptions
    end
    object SelectGraphColor1: TMenuItem
      Action = ColorSelect1
    end
    object UpdateGridColors1: TMenuItem
      Action = acUpdateGridColors
      Visible = False
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Print1: TMenuItem
      Action = acPrintGraph
    end
  end
  object ColorDialog1: TColorDialog
    Left = 544
    Top = 8
  end
  object PrintDialog1: TPrintDialog
    Left = 136
    Top = 8
  end
end
