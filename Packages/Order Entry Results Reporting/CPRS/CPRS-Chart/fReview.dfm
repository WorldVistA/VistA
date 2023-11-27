inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 510
  ClientWidth = 645
  OldCreateOrder = True
  Position = poScreenCenter
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  ExplicitTop = -75
  ExplicitWidth = 661
  ExplicitHeight = 549
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 414
    Width = 645
    Height = 96
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object lblHoldSign: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 639
      Height = 17
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taCenter
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 0
      Visible = False
    end
    object pnlBottomCanvas: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 20
      Width = 639
      Height = 73
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object gpBottom: TGridPanel
        Left = 0
        Top = 0
        Width = 639
        Height = 73
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 140.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 80.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 80.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlSignature
            Row = 0
          end
          item
            Column = 1
            Control = pnlOrderAction
            Row = 0
          end
          item
            Column = 3
            Control = cmdCancel
            Row = 0
          end
          item
            Column = 2
            Control = cmdOK
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        object pnlSignature: TPanel
          Left = 0
          Top = 0
          Width = 140
          Height = 73
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitLeft = -6
          object lblESCode: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 134
            Height = 13
            Margins.Top = 6
            Align = alBottom
            Caption = 'Electronic Signature Code'
            ExplicitWidth = 123
          end
          object txtESCode: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 46
            Width = 134
            Height = 21
            Margins.Bottom = 6
            Align = alBottom
            PasswordChar = '*'
            TabOrder = 0
            OnChange = txtESCodeChange
            Caption = 'Electronic Signature Code'
          end
        end
        object pnlOrderAction: TPanel
          Left = 140
          Top = 0
          Width = 339
          Height = 73
          Align = alClient
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object gpOrderActions: TGridPanel
            Left = 0
            Top = 0
            Width = 339
            Height = 73
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end
              item
                SizeStyle = ssAbsolute
                Value = 110.000000000000000000
              end
              item
                SizeStyle = ssAbsolute
                Value = 200.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 1
                ColumnSpan = 2
                Control = lblOrderPrompt
                Row = 0
              end
              item
                Column = 1
                Control = radSignChart
                Row = 1
              end
              item
                Column = 2
                Control = radRelease
                Row = 1
              end
              item
                Column = 1
                Control = radHoldSign
                Row = 2
              end
              item
                Column = 2
                Control = gpRelease
                Row = 2
              end
              item
                Column = 0
                Control = lblGap
                Row = 0
                RowSpan = 3
              end>
            RowCollection = <
              item
                Value = 33.333229069804550000
              end
              item
                Value = 33.333120052000510000
              end
              item
                Value = 33.333650878194920000
              end>
            TabOrder = 0
            ExplicitLeft = 3
            object lblOrderPrompt: TStaticText
              AlignWithMargins = True
              Left = 35
              Top = 7
              Width = 301
              Height = 17
              Margins.Left = 6
              Margins.Top = 0
              Margins.Bottom = 0
              Align = alBottom
              Caption = 'For orders, select from:'
              TabOrder = 0
              ExplicitLeft = 42
              ExplicitWidth = 297
            end
            object radSignChart: TRadioButton
              AlignWithMargins = True
              Left = 35
              Top = 27
              Width = 101
              Height = 19
              Margins.Left = 6
              Align = alClient
              Caption = '&Signed on Chart'
              TabOrder = 1
              OnClick = radReleaseClick
              ExplicitLeft = 6
              ExplicitWidth = 96
            end
            object radRelease: TRadioButton
              AlignWithMargins = True
              Left = 145
              Top = 27
              Width = 191
              Height = 19
              Margins.Left = 6
              Align = alClient
              Caption = '&Release to Service'
              TabOrder = 2
              Visible = False
              OnClick = radReleaseClick
              ExplicitLeft = 111
              ExplicitWidth = 225
            end
            object radHoldSign: TRadioButton
              AlignWithMargins = True
              Left = 35
              Top = 52
              Width = 101
              Height = 18
              Margins.Left = 6
              Align = alClient
              Caption = '&Hold until Signed'
              Checked = True
              TabOrder = 3
              TabStop = True
              OnClick = radReleaseClick
              ExplicitLeft = 6
              ExplicitWidth = 96
            end
            object gpRelease: TGridPanel
              Left = 139
              Top = 49
              Width = 200
              Height = 24
              Align = alClient
              BevelKind = bkFlat
              ColumnCollection = <
                item
                  SizeStyle = ssAbsolute
                  Value = 55.000000000000000000
                end
                item
                  SizeStyle = ssAbsolute
                  Value = 80.000000000000000000
                end
                item
                  SizeStyle = ssAbsolute
                  Value = 60.000000000000000000
                end>
              ControlCollection = <
                item
                  Column = 0
                  Control = radVerbal
                  Row = 0
                end
                item
                  Column = 1
                  Control = radPhone
                  Row = 0
                end
                item
                  Column = 2
                  Control = radPolicy
                  Row = 0
                end>
              RowCollection = <
                item
                  Value = 100.000000000000000000
                end>
              TabOrder = 4
              ExplicitLeft = 136
              ExplicitTop = 52
              object radVerbal: TRadioButton
                AlignWithMargins = True
                Left = 7
                Top = 4
                Width = 46
                Height = 12
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Verbal'
                Enabled = False
                TabOrder = 0
                ExplicitTop = 1
              end
              object radPhone: TRadioButton
                AlignWithMargins = True
                Left = 62
                Top = 4
                Width = 71
                Height = 12
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Telephone'
                Enabled = False
                TabOrder = 1
                ExplicitTop = 1
              end
              object radPolicy: TRadioButton
                AlignWithMargins = True
                Left = 142
                Top = 4
                Width = 51
                Height = 12
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Policy'
                Enabled = False
                TabOrder = 2
                ExplicitLeft = 147
                ExplicitTop = 1
              end
            end
            object lblGap: TLabel
              Left = 0
              Top = 0
              Width = 29
              Height = 73
              Align = alClient
              Alignment = taCenter
              Caption = 'Gap'
              Layout = tlCenter
              Visible = False
              ExplicitLeft = -3
              ExplicitWidth = 33
            end
          end
        end
        object cmdCancel: TButton
          AlignWithMargins = True
          Left = 562
          Top = 43
          Width = 74
          Height = 27
          Align = alBottom
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = cmdCancelClick
        end
        object cmdOK: TButton
          AlignWithMargins = True
          Left = 482
          Top = 43
          Width = 74
          Height = 27
          Align = alBottom
          Caption = 'OK'
          Default = True
          TabOrder = 3
          OnClick = cmdOKClick
        end
      end
    end
  end
  object pnlDEAText: TPanel [1]
    Left = 0
    Top = 356
    Width = 645
    Height = 58
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    TabOrder = 0
    object lblDEAText: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 639
      Height = 52
      Align = alClient
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'By completing the two-factor authentication protocol at this tim' +
        'e, you are legally signing the prescription(s) and authorizing t' +
        'he transmission of the above informationto the pharmacy for disp' +
        'ensing.  The two-factor authentication protocol may only be comp' +
        'leted by the practitioner whose name and DEA registration number' +
        ' appear above. '
      TabOrder = 0
    end
  end
  object pnlTop: TPanel [2]
    Left = 0
    Top = 0
    Width = 645
    Height = 201
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    inline fraCoPay: TfraCoPayDesc
      Left = 145
      Top = 0
      Width = 500
      Height = 201
      Align = alClient
      Constraints.MinWidth = 500
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 145
      ExplicitWidth = 500
      ExplicitHeight = 201
      inherited gpMain: TGridPanel
        Width = 500
        Height = 201
        ControlCollection = <
          item
            Column = 0
            Control = fraCoPay.pnlSCandRD
            Row = 0
          end
          item
            Column = 1
            Control = fraCoPay.pnlRight
            Row = 0
          end>
        ExplicitWidth = 500
        ExplicitHeight = 201
        inherited pnlSCandRD: TPanel
          Width = 250
          Height = 201
          ExplicitWidth = 250
          ExplicitHeight = 201
          inherited lblSCDisplay: TLabel
            Width = 244
            ExplicitWidth = 254
          end
          inherited pnlBorderLeft: TPanel
            Width = 250
            Height = 179
            ExplicitWidth = 250
            ExplicitHeight = 179
            inherited memSCDisplay: TCaptionMemo
              Width = 244
              Height = 173
              ExplicitWidth = 244
              ExplicitHeight = 173
            end
          end
        end
        inherited pnlRight: TPanel
          Left = 250
          Width = 250
          Height = 201
          ExplicitLeft = 250
          ExplicitWidth = 250
          ExplicitHeight = 201
          inherited lblCaption: TStaticText
            Width = 244
            ExplicitWidth = 244
          end
          inherited pnlBorderRight: TPanel
            Width = 250
            Height = 178
            ExplicitWidth = 250
            ExplicitHeight = 178
            inherited gpRight: TGridPanel
              Width = 244
              Height = 172
              ControlCollection = <
                item
                  Column = 0
                  Control = fraCoPay.lblAO
                  Row = 0
                end
                item
                  Column = 1
                  Control = fraCoPay.lblAO2
                  Row = 0
                end
                item
                  Column = 0
                  Control = fraCoPay.lblSC
                  Row = 1
                end
                item
                  Column = 1
                  Control = fraCoPay.lblSC2
                  Row = 1
                end
                item
                  Column = 0
                  Control = fraCoPay.lblCV
                  Row = 2
                end
                item
                  Column = 1
                  Control = fraCoPay.lblCV2
                  Row = 2
                end
                item
                  Column = 0
                  Control = fraCoPay.lblIR
                  Row = 3
                end
                item
                  Column = 1
                  Control = fraCoPay.lblIR2
                  Row = 3
                end
                item
                  Column = 0
                  Control = fraCoPay.lblSWAC
                  Row = 4
                end
                item
                  Column = 1
                  Control = fraCoPay.lblSWAC2
                  Row = 4
                end
                item
                  Column = 0
                  Control = fraCoPay.lblSHAD
                  Row = 5
                end
                item
                  Column = 1
                  Control = fraCoPay.lblSHAD2
                  Row = 5
                end
                item
                  Column = 0
                  Control = fraCoPay.lblMST
                  Row = 6
                end
                item
                  Column = 1
                  Control = fraCoPay.lblMST2
                  Row = 6
                end
                item
                  Column = 0
                  Control = fraCoPay.lblHNC
                  Row = 7
                end
                item
                  Column = 1
                  Control = fraCoPay.lblHNC2
                  Row = 7
                end
                item
                  Column = 0
                  Control = fraCoPay.lblCL
                  Row = 8
                end
                item
                  Column = 1
                  Control = fraCoPay.lblCL2
                  Row = 8
                end>
              ExplicitWidth = 244
              ExplicitHeight = 172
              inherited lblAO: TVA508StaticText
                Left = 27
                Width = 23
                ExplicitWidth = 23
                ExplicitHeight = 19
              end
              inherited lblAO2: TVA508StaticText
                Width = 118
                ExplicitWidth = 118
                ExplicitHeight = 19
              end
              inherited lblSC: TVA508StaticText
                ExplicitHeight = 19
              end
              inherited lblSC2: TVA508StaticText
                ExplicitHeight = 19
              end
              inherited lblCV: TVA508StaticText
                ExplicitHeight = 19
              end
              inherited lblCV2: TVA508StaticText
                Width = 145
                ExplicitWidth = 145
                ExplicitHeight = 19
              end
              inherited lblIR: TVA508StaticText
                Left = 31
                Width = 19
                ExplicitWidth = 19
                ExplicitHeight = 19
              end
              inherited lblIR2: TVA508StaticText
                Width = 136
                ExplicitWidth = 136
                ExplicitHeight = 19
              end
              inherited lblSWAC: TVA508StaticText
                Left = 10
                Width = 40
                ExplicitWidth = 40
                ExplicitHeight = 19
              end
              inherited lblSWAC2: TVA508StaticText
                Width = 130
                ExplicitWidth = 130
                ExplicitHeight = 19
              end
              inherited lblSHAD: TVA508StaticText
                Left = 19
                Width = 31
                ExplicitWidth = 31
                ExplicitHeight = 19
              end
              inherited lblSHAD2: TVA508StaticText
                ExplicitHeight = 19
              end
              inherited lblMST: TVA508StaticText
                Left = 19
                Width = 31
                ExplicitWidth = 31
                ExplicitHeight = 19
              end
              inherited lblMST2: TVA508StaticText
                Width = 28
                ExplicitWidth = 28
                ExplicitHeight = 19
              end
              inherited lblHNC: TVA508StaticText
                Left = 19
                Width = 31
                ExplicitWidth = 31
                ExplicitHeight = 19
              end
              inherited lblHNC2: TVA508StaticText
                Width = 132
                ExplicitWidth = 132
                ExplicitHeight = 19
              end
              inherited lblCL: TVA508StaticText
                ExplicitHeight = 19
              end
              inherited lblCL2: TVA508StaticText
                ExplicitHeight = 19
              end
            end
          end
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 201
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 139
        Height = 13
        Align = alTop
        Caption = 'lblProvInfo'
        ExplicitWidth = 50
      end
    end
  end
  object gpMain: TGridPanel [3]
    Left = 0
    Top = 201
    Width = 645
    Height = 155
    Align = alClient
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlReview
        Row = 0
      end
      item
        Column = 0
        Control = pnlCSReview
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 3
    object pnlReview: TPanel
      Left = 1
      Top = 1
      Width = 643
      Height = 76
      Align = alClient
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object lstReview: TCaptionCheckListBox
        Left = 0
        Top = 21
        Width = 643
        Height = 55
        OnClickCheck = lstReviewClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseMove = lstReviewMouseMove
        Caption = 'Signature will be Applied to Checked Items'
        ExplicitTop = 18
      end
      object lblSig: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 637
        Height = 17
        Margins.Bottom = 1
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
      end
    end
    object pnlCSReview: TPanel
      Left = 1
      Top = 77
      Width = 643
      Height = 77
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      OnResize = pnlCSReviewResize
      object lstCSReview: TCaptionCheckListBox
        Left = 0
        Top = 21
        Width = 643
        Height = 56
        OnClickCheck = lstReviewClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseMove = lstReviewMouseMove
        Caption = ''
      end
      object pnlCSTop: TPanel
        Left = 0
        Top = 0
        Width = 643
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        Caption = 'pnlCSTop'
        ShowCaption = False
        TabOrder = 2
        object lblCSReview: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 166
          Height = 15
          Margins.Right = 0
          Align = alLeft
          Caption = 'Controlled Substance EPCS Orders'
          ExplicitHeight = 13
        end
        object lblSmartCardNeeded: TStaticText
          AlignWithMargins = True
          Left = 175
          Top = 3
          Width = 126
          Height = 15
          Margins.Left = 6
          Align = alLeft
          Caption = 'SMART card required'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Transparent = False
        end
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 744
    Top = 40
    Data = (
      (
        'Component = fraCoPay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSCandRD'
        'Status = stsDefault')
      (
        'Component = frmReview'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlSignature'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = pnlOrderAction'
        'Status = stsDefault')
      (
        'Component = radSignChart'
        'Status = stsDefault')
      (
        'Component = radHoldSign'
        'Status = stsDefault')
      (
        'Component = radVerbal'
        'Status = stsDefault')
      (
        'Component = radPhone'
        'Status = stsDefault')
      (
        'Component = radPolicy'
        'Status = stsDefault')
      (
        'Component = radRelease'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lblHoldSign'
        'Status = stsDefault')
      (
        'Component = pnlReview'
        'Status = stsDefault')
      (
        'Component = lstReview'
        'Status = stsDefault')
      (
        'Component = lblSig'
        'Status = stsDefault')
      (
        'Component = pnlCSReview'
        'Status = stsDefault')
      (
        'Component = lstCSReview'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlBottomCanvas'
        'Status = stsDefault')
      (
        'Component = fraCoPay.memSCDisplay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCL'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCL2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCaption'
        'Status = stsDefault')
      (
        'Component = pnlCSTop'
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = gpBottom'
        'Status = stsDefault')
      (
        'Component = gpOrderActions'
        'Status = stsDefault')
      (
        'Component = gpRelease'
        'Status = stsDefault'))
  end
end
