inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 656
  ClientWidth = 816
  Constraints.MinHeight = 565
  Constraints.MinWidth = 695
  OldCreateOrder = True
  Position = poScreenCenter
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  ExplicitWidth = 832
  ExplicitHeight = 695
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 3
    Top = 32
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 560
    Width = 816
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
      Width = 288
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
      Width = 810
      Height = 73
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object gpBottom: TGridPanel
        Left = 0
        Top = 0
        Width = 810
        Height = 73
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 20.000000000000000000
          end
          item
            Value = 60.000000000000000000
          end
          item
            Value = 10.000000000000000000
          end
          item
            Value = 10.000000000000000000
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
          Width = 162
          Height = 73
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object lblESCode: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 27
            Width = 123
            Height = 13
            Margins.Top = 6
            Align = alBottom
            Caption = 'Electronic Signature Code'
          end
          object txtESCode: TCaptionEdit
            AlignWithMargins = True
            Left = 3
            Top = 46
            Width = 156
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
          Left = 162
          Top = 0
          Width = 486
          Height = 73
          Align = alClient
          Anchors = []
          BevelOuter = bvNone
          TabOrder = 1
          Visible = False
          object gpOrderActions: TGridPanel
            Left = 0
            Top = 0
            Width = 486
            Height = 73
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 34.000000000000000000
              end
              item
                Value = 22.000000000000000000
              end
              item
                Value = 22.000000000000000000
              end
              item
                Value = 22.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                ColumnSpan = 4
                Control = lblOrderPrompt
                Row = 0
              end
              item
                Column = 0
                Control = radSignChart
                Row = 1
              end
              item
                Column = 1
                ColumnSpan = 3
                Control = radRelease
                Row = 1
              end
              item
                Column = 0
                Control = radHoldSign
                Row = 2
              end
              item
                Column = 1
                ColumnSpan = 3
                Control = gpRelease
                Row = 2
              end>
            RowCollection = <
              item
                Value = 33.333229069804550000
              end
              item
                Value = 33.333120052000500000
              end
              item
                Value = 33.333650878194950000
              end>
            TabOrder = 0
            object lblOrderPrompt: TStaticText
              AlignWithMargins = True
              Left = 6
              Top = 7
              Width = 111
              Height = 17
              Margins.Left = 6
              Margins.Top = 0
              Margins.Bottom = 0
              Align = alBottom
              Caption = 'For orders, select from:'
              TabOrder = 0
            end
            object radSignChart: TRadioButton
              AlignWithMargins = True
              Left = 6
              Top = 27
              Width = 156
              Height = 18
              Margins.Left = 6
              Align = alClient
              Caption = '&Signed on Chart'
              TabOrder = 1
              OnClick = radReleaseClick
            end
            object radRelease: TRadioButton
              AlignWithMargins = True
              Left = 171
              Top = 27
              Width = 312
              Height = 18
              Margins.Left = 6
              Align = alClient
              Caption = '&Release to Service'
              TabOrder = 2
              Visible = False
              OnClick = radReleaseClick
            end
            object radHoldSign: TRadioButton
              AlignWithMargins = True
              Left = 6
              Top = 51
              Width = 156
              Height = 19
              Margins.Left = 6
              Align = alClient
              Caption = '&Hold until Signed'
              Checked = True
              TabOrder = 3
              TabStop = True
              OnClick = radReleaseClick
            end
            object gpRelease: TGridPanel
              Left = 165
              Top = 48
              Width = 321
              Height = 25
              Align = alClient
              BevelKind = bkFlat
              ColumnCollection = <
                item
                  Value = 33.333333333333340000
                end
                item
                  Value = 33.333333333333340000
                end
                item
                  Value = 33.333333333333340000
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
              object radVerbal: TRadioButton
                AlignWithMargins = True
                Left = 7
                Top = 4
                Width = 96
                Height = 13
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Verbal'
                Enabled = False
                TabOrder = 0
              end
              object radPhone: TRadioButton
                AlignWithMargins = True
                Left = 112
                Top = 4
                Width = 96
                Height = 13
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Telephone'
                Enabled = False
                TabOrder = 1
              end
              object radPolicy: TRadioButton
                AlignWithMargins = True
                Left = 217
                Top = 4
                Width = 96
                Height = 13
                Margins.Left = 6
                Align = alClient
                Anchors = []
                Caption = '&Policy'
                Enabled = False
                TabOrder = 2
              end
            end
          end
        end
        object cmdCancel: TButton
          AlignWithMargins = True
          Left = 732
          Top = 43
          Width = 75
          Height = 27
          Align = alBottom
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = cmdCancelClick
        end
        object cmdOK: TButton
          AlignWithMargins = True
          Left = 651
          Top = 43
          Width = 75
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
  object pnlDEAText: TPanel [2]
    Left = 0
    Top = 502
    Width = 816
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
      Width = 1574
      Height = 17
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
  object pnlTop: TPanel [3]
    Left = 0
    Top = 0
    Width = 816
    Height = 201
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 304
    inline fraCoPay: TfraCoPayDesc
      Left = 301
      Top = 0
      Width = 515
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
      OnResize = fraCoPayResize
      ExplicitLeft = 301
      ExplicitWidth = 3
      ExplicitHeight = 201
      inherited pnlSCandRD: TPanel
        Width = 248
        Height = 201
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 248
        ExplicitHeight = 201
        inherited lblSCDisplay: TLabel
          Width = 242
          ExplicitWidth = 254
        end
        inherited memSCDisplay: TCaptionMemo
          Width = 248
          Height = 179
          ExplicitWidth = 248
          ExplicitHeight = 179
        end
      end
      inherited pnlRight: TPanel
        Left = 248
        Width = 267
        Height = 201
        ExplicitLeft = 248
        ExplicitWidth = 267
        ExplicitHeight = 201
        inherited ScrollBox2: TScrollBox
          Width = 267
          Height = 179
          ExplicitLeft = 0
          ExplicitTop = 22
          ExplicitWidth = 267
          ExplicitHeight = 179
          inherited GridPanel1: TGridPanel
            Width = 263
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
            ExplicitWidth = 263
            inherited lblAO: TVA508StaticText
              ExplicitLeft = 34
              ExplicitTop = 1
              ExplicitHeight = 24
            end
            inherited lblAO2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 1
              ExplicitHeight = 24
            end
            inherited lblSC: TVA508StaticText
              ExplicitLeft = 35
              ExplicitTop = 25
              ExplicitHeight = 19
            end
            inherited lblSC2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 25
              ExplicitHeight = 19
            end
            inherited lblCV: TVA508StaticText
              ExplicitLeft = 35
              ExplicitTop = 44
              ExplicitHeight = 19
            end
            inherited lblCV2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 44
              ExplicitHeight = 19
            end
            inherited lblIR: TVA508StaticText
              ExplicitLeft = 38
              ExplicitTop = 63
              ExplicitHeight = 19
            end
            inherited lblIR2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 63
              ExplicitHeight = 19
            end
            inherited lblSWAC: TVA508StaticText
              ExplicitLeft = 17
              ExplicitTop = 82
              ExplicitHeight = 19
            end
            inherited lblSWAC2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 82
              ExplicitHeight = 19
            end
            inherited lblSHAD: TVA508StaticText
              ExplicitLeft = 26
              ExplicitTop = 101
              ExplicitHeight = 19
            end
            inherited lblSHAD2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 101
              ExplicitHeight = 19
            end
            inherited lblMST: TVA508StaticText
              ExplicitLeft = 26
              ExplicitTop = 120
              ExplicitHeight = 19
            end
            inherited lblMST2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 120
              ExplicitHeight = 19
            end
            inherited lblHNC: TVA508StaticText
              ExplicitLeft = 26
              ExplicitTop = 139
              ExplicitHeight = 19
            end
            inherited lblHNC2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 139
              ExplicitHeight = 19
            end
            inherited lblCL: TVA508StaticText
              ExplicitLeft = 36
              ExplicitTop = 158
              ExplicitHeight = 19
            end
            inherited lblCL2: TVA508StaticText
              ExplicitLeft = 57
              ExplicitTop = 158
              ExplicitHeight = 19
            end
          end
        end
        inherited lblCaption: TStaticText
          Width = 261
          ExplicitWidth = 261
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 301
      Height = 201
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 50
        Height = 13
        Align = alTop
        Caption = 'lblProvInfo'
      end
    end
  end
  object gpMain: TGridPanel [4]
    Left = 0
    Top = 201
    Width = 816
    Height = 301
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
      Width = 814
      Height = 149
      Align = alClient
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object lstReview: TCaptionCheckListBox
        Left = 0
        Top = 21
        Width = 814
        Height = 128
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
      end
      object lblSig: TStaticText
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 808
        Height = 17
        Margins.Bottom = 1
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
        ExplicitWidth = 254
      end
    end
    object pnlCSReview: TPanel
      Left = 1
      Top = 150
      Width = 814
      Height = 150
      Align = alClient
      Anchors = []
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object lstCSReview: TCaptionCheckListBox
        Left = 0
        Top = 24
        Width = 814
        Height = 126
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
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 814
        Height = 24
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 2
        object lblCSReview: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 166
          Height = 13
          Align = alLeft
          Caption = 'Controlled Substance EPCS Orders'
        end
        object lblSmartCardNeeded: TStaticText
          AlignWithMargins = True
          Left = 175
          Top = 3
          Width = 126
          Height = 17
          Align = alLeft
          Caption = 'SMART card required'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -9
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
        'Component = fraCoPay.ScrollBox2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.GridPanel1'
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
        'Component = Panel2'
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
