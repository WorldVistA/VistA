inherited frmWVPregLacStatusUpdate: TfrmWVPregLacStatusUpdate
  Left = 0
  Top = 0
  Caption = 'Women'#39's Health - Pregnancy and Lactation Status Update'
  ClientHeight = 502
  ClientWidth = 767
  Color = clWhite
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object stxtReaderStop: TStaticText
    Left = 136
    Top = 0
    Width = 4
    Height = 4
    TabOrder = 0
    TabStop = True
  end
  object scrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 767
    Height = 502
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = scrollBoxResize
    object pnlForm: TPanel
      Left = 0
      Top = 0
      Width = 763
      Height = 497
      Align = alTop
      TabOrder = 0
      object grdLayout: TGridPanel
        Left = 1
        Top = 1
        Width = 761
        Height = 460
        Align = alClient
        BevelEdges = []
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlConveive
            Row = 0
          end
          item
            Column = 0
            Control = pnlPregnant
            Row = 1
          end
          item
            Column = 0
            Control = pnlLactationStatus
            Row = 2
          end>
        RowCollection = <
          item
            Value = 29.012918978614720000
          end
          item
            Value = 44.510062525242200000
          end
          item
            Value = 26.477018496143080000
          end
          item
            SizeStyle = ssAuto
          end>
        TabOrder = 0
        object pnlConveive: TPanel
          Left = 0
          Top = 0
          Width = 761
          Height = 133
          Align = alClient
          BevelEdges = []
          BevelOuter = bvNone
          TabOrder = 0
          object pnlConeiveLabel: TPanel
            Left = 0
            Top = 0
            Width = 761
            Height = 30
            Align = alTop
            BevelEdges = []
            BevelOuter = bvNone
            Color = clActiveCaption
            ParentBackground = False
            TabOrder = 0
            object stxtAbleToConceive: TStaticText
              AlignWithMargins = True
              Left = 5
              Top = 1
              Width = 753
              Height = 28
              Margins.Left = 5
              Margins.Top = 1
              Margins.Bottom = 1
              Align = alClient
              Caption = 'Medically Able To Conceive'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              Transparent = False
            end
          end
          object grdConceive: TGridPanel
            Left = 0
            Top = 30
            Width = 761
            Height = 103
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelEdges = []
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 28.128535175956220000
              end
              item
                Value = 25.768184180756410000
              end
              item
                Value = 23.600452502522400000
              end
              item
                Value = 22.502828140764980000
              end>
            ControlCollection = <
              item
                Column = 1
                Control = ckbxHysterectomy
                Row = 0
              end
              item
                Column = 2
                Control = ckbxMenopause
                Row = 0
              end
              item
                Column = 3
                Control = ckbxPermanent
                Row = 0
              end
              item
                Column = 0
                Control = robnAbleToConceiveNo
                Row = 0
              end
              item
                Column = 0
                Control = robnAbleToConceiveYes
                Row = 2
              end
              item
                Column = 1
                ColumnSpan = 3
                Control = pnlOther
                Row = 1
              end>
            Padding.Left = 4
            RowCollection = <
              item
                Value = 37.220952377412340000
              end
              item
                Value = 24.812030075187970000
              end
			  item
                Value = 37.967017547399690000
              end>
            TabOrder = 1
            object ckbxHysterectomy: TCheckBox
              Left = 220
              Top = 39
              Width = 191
              Height = 38
              Align = alClient
              Caption = 'Hysterectomy'
              Enabled = False
              TabOrder = 1
              OnClick = CheckOkToSave
            end
            object ckbxMenopause: TCheckBox
              Left = 415
              Top = 39
              Width = 174
              Height = 38
              Align = alClient
              Caption = 'Menopause'
              Enabled = False
              TabOrder = 2
              OnClick = CheckOkToSave
            end
            object ckbxPermanent: TCheckBox
              Left = 593
              Top = 39
              Width = 168
              Height = 38
              Align = alClient
              Caption = 'Permanent female sterilization'
              Enabled = False
              TabOrder = 3
              OnClick = CheckOkToSave
            end
            object robnAbleToConceiveNo: TRadioButton
              Left = 8
              Top = 39
              Width = 208
              Height = 38
              Align = alClient
              Caption = 'Not able to conceive'
              TabOrder = 0
              OnClick = AbleToConceiveYesNo
            end
            object robnAbleToConceiveYes: TRadioButton
              Left = 8
              Top = 0
              Width = 208
              Height = 39
              Align = alClient
              Caption = 'Able to conceive'
              TabOrder = 5
              TabStop = True
              OnClick = AbleToConceiveYesNo
            end
            object pnlOther: TPanel
              Left = 220
              Top = 77
              Width = 541
              Height = 26
              Align = alClient
              BevelEdges = []
              BevelOuter = bvNone
              TabOrder = 4
              object ststxtOther: TStaticText
                AlignWithMargins = True
                Left = 3
                Top = 6
                Width = 33
                Height = 17
                Margins.Top = 6
                Align = alLeft
                Caption = 'Other:'
                Enabled = False
                TabOrder = 0
                TabStop = True
              end
              object edtOther: TEdit
                AlignWithMargins = True
                Left = 42
                Top = 3
                Width = 479
                Height = 20
                Margins.Right = 20
                Margins.Bottom = 30
                Align = alClient
                Constraints.MinHeight = 20
                Constraints.MinWidth = 100
                Enabled = False
                TabOrder = 1
                OnChange = CheckOkToSave
                ExplicitHeight = 21
              end
            end
          end
        end
        object pnlPregnant: TPanel
          Left = 0
          Top = 133
          Width = 761
          Height = 204
          Align = alClient
          BevelEdges = []
          BevelOuter = bvNone
          TabOrder = 1
          object pnlPregStatusLabel: TPanel
            Left = 0
            Top = 0
            Width = 761
            Height = 25
            Align = alTop
            BevelEdges = []
            BevelOuter = bvNone
            Color = clActiveCaption
            ParentBackground = False
            TabOrder = 0
            object stxtCurrentlyPregnant: TStaticText
              AlignWithMargins = True
              Left = 5
              Top = 1
              Width = 753
              Height = 23
              Margins.Left = 5
              Margins.Top = 1
              Margins.Bottom = 1
              Align = alClient
              BevelEdges = []
              BevelOuter = bvNone
              Caption = 'Pregnancy Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              TabStop = True
              Transparent = False
            end
          end
          object grdPregStatus: TGridPanel
            Left = 0
            Top = 25
            Width = 761
            Height = 179
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelEdges = []
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 30.128575193419830000
              end
              item
                Value = 35.992180647638670000
              end
              item
                Value = 33.879244158941500000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = robnPregnantUnsure
                Row = 2
              end
              item
                Column = 0
                Control = robnPregnantNo
                Row = 1
              end
              item
                Column = 0
                Control = robnPregnantYes
                Row = 0
              end
              item
                Column = 1
                Control = pnlLMP
                Row = 0
              end
              item
                Column = 2
                Control = pnlEDD
                Row = 0
              end>
            Padding.Left = 4
            Padding.Top = 3
            RowCollection = <
              item
                Value = 33.286306085242010000
              end
              item
                Value = 33.453651590069900000
              end
              item
                Value = 33.260042324688080000
              end>
            TabOrder = 1
            object robnPregnantUnsure: TRadioButton
              Left = 8
              Top = 122
              Width = 224
              Height = 57
              Align = alClient
              Caption = 'Does not know'
              Enabled = False
              TabOrder = 2
              OnClick = PregnantYesNoUnsure
            end
            object robnPregnantNo: TRadioButton
              Left = 8
              Top = 64
              Width = 224
              Height = 55
              Align = alClient
              Caption = 'Not pregnant'
              Enabled = False
              TabOrder = 1
              TabStop = True
              OnClick = PregnantYesNoUnsure
            end
            object robnPregnantYes: TRadioButton
              Left = 8
              Top = 6
              Width = 224
              Height = 55
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alClient
              Caption = 'Pregnant'
              Enabled = False
              TabOrder = 0
              TabStop = True
              OnClick = PregnantYesNoUnsure
            end
            object pnlLMP: TPanel
              Left = 236
              Top = 6
              Width = 268
              Height = 55
              Margins.Bottom = 35
              Align = alClient
              BevelEdges = []
              BevelOuter = bvNone
              DoubleBuffered = True
              ParentDoubleBuffered = False
              TabOrder = 3
              object stxtLastMenstrualPeriod: TStaticText
                AlignWithMargins = True
                Left = 3
                Top = 8
                Width = 104
                Height = 44
                Margins.Top = 8
                Align = alLeft
                Caption = 'Last menstrual period'
                Enabled = False
                TabOrder = 0
              end
              object dteLMPD: TORDateBox
                AlignWithMargins = True
                Left = 113
                Top = 5
                Width = 150
                Height = 18
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 32
                Align = alClient
                AutoSize = False
                Constraints.MinHeight = 17
                Constraints.MinWidth = 31
                TabOrder = 1
                OnChange = dteLMPDChange
                OnExit = dteLMPDExit
                OnMouseLeave = dteLMPDMouseLeave
                DateOnly = True
                RequireTime = False
                Caption = ''
                OnDateDialogClosed = dteLMPDDateDialogClosed
              end
            end
            object pnlEDD: TPanel
              Left = 508
              Top = 6
              Width = 253
              Height = 55
              Align = alClient
              Anchors = []
              BevelEdges = []
              BevelOuter = bvNone
              DoubleBuffered = True
              ParentDoubleBuffered = False
              TabOrder = 4
              object stxtEDDMethod: TStaticText
                AlignWithMargins = True
                Left = 3
                Top = 8
                Width = 98
                Height = 44
                Margins.Top = 8
                Align = alLeft
                Caption = 'Expected due date*'
                Enabled = False
                TabOrder = 0
              end
              object dteEDD: TORDateBox
                AlignWithMargins = True
                Left = 107
                Top = 5
                Width = 141
                Height = 18
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 32
                Align = alClient
                AutoSize = False
                Constraints.MinHeight = 17
                Constraints.MinWidth = 31
                TabOrder = 1
                OnChange = dteEDDChange
                DateOnly = True
                RequireTime = False
                Caption = ''
              end
            end
          end
        end
        object pnlLactationStatus: TPanel
          Left = 0
          Top = 337
          Width = 761
          Height = 121
          Align = alClient
          BevelEdges = []
          BevelOuter = bvNone
          Caption = 'Lactation Status'
          ParentColor = True
          ShowCaption = False
          TabOrder = 2
          object pnlLactationLabel: TPanel
            Left = 0
            Top = 0
            Width = 761
            Height = 25
            Align = alTop
            BevelEdges = []
            BevelOuter = bvNone
            Color = clActiveCaption
            ParentBackground = False
            TabOrder = 0
            object stxtLactationStatus: TStaticText
              AlignWithMargins = True
              Left = 5
              Top = 1
              Width = 753
              Height = 23
              Margins.Left = 5
              Margins.Top = 1
              Margins.Bottom = 1
              Align = alClient
              Caption = 'Lactation Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              Transparent = False
            end
          end
          object grdLactation: TGridPanel
            AlignWithMargins = True
            Left = 4
            Top = 28
            Width = 757
            Height = 93
            Margins.Left = 4
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            BevelEdges = []
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = robnLactatingNo
                Row = 1
              end
              item
                Column = 0
                Control = robnLactatingYes
                Row = 0
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 1
            object robnLactatingNo: TRadioButton
              AlignWithMargins = True
              Left = 4
              Top = 49
              Width = 749
              Height = 40
              Align = alClient
              Caption = 'Not currently lactating'
              TabOrder = 1
              OnClick = robnLactatingYesNoClick
            end
            object robnLactatingYes: TRadioButton
              AlignWithMargins = True
              Left = 4
              Top = 4
              Width = 749
              Height = 39
              Align = alClient
              Caption = 'Currently lactating'
              TabOrder = 0
              TabStop = True
              OnClick = robnLactatingYesNoClick
            end
          end
        end
      end
      object pnlOptions: TPanel
        Left = 1
        Top = 461
        Width = 761
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        DesignSize = (
          761
          35)
        object btnSave: TButton
          Left = 601
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Caption = 'Save'
          Enabled = False
          ModalResult = 1
          TabOrder = 0
        end
        object btnCancel: TButton
          Left = 682
          Top = 1
          Width = 75
          Height = 25
          Anchors = [akRight, akBottom]
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 1
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 240
    Top = 448
    Data = (
      (
        'Component = frmWVPregLacStatusUpdate'
        'Status = stsDefault')
      (
        'Component = stxtReaderStop'
        'Status = stsDefault')
      (
        'Component = scrollBox'
        'Status = stsDefault')
      (
        'Component = pnlForm'
        'Status = stsDefault')
      (
        'Component = grdLayout'
        'Status = stsDefault')
      (
        'Component = pnlConveive'
        'Status = stsDefault')
      (
        'Component = pnlConeiveLabel'
        'Status = stsDefault')
      (
        'Component = stxtAbleToConceive'
        'Status = stsDefault')
      (
        'Component = grdConceive'
        'Status = stsDefault')
      (
        'Component = ckbxHysterectomy'
        'Status = stsDefault')
      (
        'Component = ckbxMenopause'
        'Status = stsDefault')
      (
        'Component = ckbxPermanent'
        'Status = stsDefault')
      (
        'Component = robnAbleToConceiveNo'
        'Status = stsDefault')
      (
        'Component = robnAbleToConceiveYes'
        'Status = stsDefault')
      (
        'Component = pnlOther'
        'Status = stsDefault')
      (
        'Component = ststxtOther'
        'Status = stsDefault')
      (
        'Component = edtOther'
        'Status = stsDefault')
      (
        'Component = pnlPregnant'
        'Status = stsDefault')
      (
        'Component = pnlPregStatusLabel'
        'Status = stsDefault')
      (
        'Component = stxtCurrentlyPregnant'
        'Status = stsDefault')
      (
        'Component = grdPregStatus'
        'Status = stsDefault')
      (
        'Component = pnlLactationStatus'
        'Status = stsDefault')
      (
        'Component = pnlLactationLabel'
        'Status = stsDefault')
      (
        'Component = stxtLactationStatus'
        'Status = stsDefault')
      (
        'Component = grdLactation'
        'Status = stsDefault')
      (
        'Component = robnLactatingNo'
        'Status = stsDefault')
      (
        'Component = pnlOptions'
        'Status = stsDefault')
      (
        'Component = btnSave'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = robnLactatingYes'
        'Status = stsDefault')
      (
        'Component = robnPregnantUnsure'
        'Status = stsDefault')
      (
        'Component = robnPregnantNo'
        'Status = stsDefault')
      (
        'Component = robnPregnantYes'
        'Status = stsDefault')
      (
        'Component = pnlLMP'
        'Status = stsDefault')
      (
        'Component = stxtLastMenstrualPeriod'
        'Status = stsDefault')
      (
        'Component = dteLMPD'
        'Status = stsDefault')
      (
        'Component = pnlEDD'
        'Status = stsDefault')
      (
        'Component = stxtEDDMethod'
        'Status = stsDefault')
      (
        'Component = dteEDD'
        'Status = stsDefault'))
  end
end
