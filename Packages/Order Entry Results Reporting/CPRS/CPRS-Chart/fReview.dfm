inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 529
  ClientWidth = 713
  Constraints.MinHeight = 565
  Constraints.MinWidth = 695
  OldCreateOrder = True
  Position = poScreenCenter
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  ExplicitWidth = 729
  ExplicitHeight = 568
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 256
    Top = 135
    Width = 46
    Height = 13
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 440
    Width = 713
    Height = 89
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      713
      89)
    object pnlSignature: TPanel
      Left = 8
      Top = 41
      Width = 152
      Height = 43
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object lblESCode: TLabel
        Left = 0
        Top = 0
        Width = 123
        Height = 13
        Caption = 'Electronic Signature Code'
      end
      object txtESCode: TCaptionEdit
        Left = 0
        Top = 14
        Width = 137
        Height = 21
        PasswordChar = '*'
        TabOrder = 0
        OnChange = txtESCodeChange
        Caption = 'Electronic Signature Code'
      end
    end
    object pnlOrderAction: TPanel
      Left = 151
      Top = 21
      Width = 373
      Height = 65
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label1: TStaticText
        Left = 0
        Top = 0
        Width = 111
        Height = 17
        Caption = 'For orders, select from:'
        TabOrder = 4
      end
      object radSignChart: TRadioButton
        Left = 0
        Top = 16
        Width = 101
        Height = 17
        Caption = '&Signed on Chart'
        TabOrder = 0
        OnClick = radReleaseClick
      end
      object radHoldSign: TRadioButton
        Left = 0
        Top = 36
        Width = 101
        Height = 17
        Caption = '&Hold until Signed'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = radReleaseClick
      end
      object grpRelease: TGroupBox
        Left = 120
        Top = 16
        Width = 241
        Height = 42
        TabOrder = 3
        Visible = False
        object radVerbal: TRadioButton
          Left = 8
          Top = 19
          Width = 53
          Height = 17
          Caption = '&Verbal'
          Enabled = False
          TabOrder = 0
        end
        object radPhone: TRadioButton
          Left = 80
          Top = 19
          Width = 77
          Height = 17
          Caption = '&Telephone'
          Enabled = False
          TabOrder = 1
        end
        object radPolicy: TRadioButton
          Left = 168
          Top = 19
          Width = 49
          Height = 17
          Caption = '&Policy'
          Enabled = False
          TabOrder = 2
        end
      end
      object radRelease: TRadioButton
        Left = 128
        Top = 16
        Width = 113
        Height = 17
        Caption = '&Release to Service'
        TabOrder = 2
        Visible = False
        OnClick = radReleaseClick
      end
    end
    object cmdOK: TButton
      Left = 552
      Top = 55
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 630
      Top = 55
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object lblHoldSign: TStaticText
      Left = 179
      Top = 2
      Width = 288
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 4
      Visible = False
    end
  end
  object pnlDEAText: TPanel [2]
    Left = 0
    Top = 400
    Width = 713
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object lblDEAText: TStaticText
      AlignWithMargins = True
      Left = 3
      Top = 0
      Width = 1574
      Height = 17
      Margins.Top = 0
      Margins.Bottom = 0
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
    Width = 713
    Height = 149
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 304
    DesignSize = (
      713
      149)
    inline fraCoPay: TfraCoPayDesc
      Left = 205
      Top = -1
      Width = 508
      Height = 152
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 205
      ExplicitTop = -1
      ExplicitWidth = 508
      ExplicitHeight = 152
      inherited pnlRight: TPanel
        Left = 242
        Width = 266
        Height = 152
        AutoSize = True
        ExplicitLeft = 242
        ExplicitWidth = 266
        ExplicitHeight = 152
        inherited Spacer2: TLabel
          Width = 266
          ExplicitWidth = 266
        end
        inherited lblCaption: TStaticText
          Width = 266
          Caption = 'Patient Orders Related To:'
          ExplicitWidth = 266
        end
        inherited ScrollBox1: TScrollBox
          Width = 266
          Height = 133
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          ExplicitWidth = 266
          ExplicitHeight = 133
          inherited pnlMain: TPanel
            Width = 245
            Height = 168
            ExplicitWidth = 245
            ExplicitHeight = 168
            inherited spacer1: TLabel
              Top = 20
              Width = 245
              Height = 4
              ExplicitLeft = 0
              ExplicitTop = 20
              ExplicitWidth = 246
              ExplicitHeight = 4
            end
            inherited pnlHNC: TPanel
              Top = 150
              Width = 245
              Height = 18
              ExplicitTop = 150
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblHNC2: TVA508StaticText
                Left = 50
                Width = 129
                Height = 18
                ExplicitLeft = 50
                ExplicitWidth = 129
                ExplicitHeight = 18
              end
              inherited lblHNC: TVA508StaticText
                Left = 12
                Width = 31
                Height = 18
                ExplicitLeft = 12
                ExplicitWidth = 31
                ExplicitHeight = 18
              end
            end
            inherited pnlMST: TPanel
              Top = 114
              Width = 245
              Height = 18
              ExplicitTop = 114
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblMST2: TVA508StaticText
                Width = 25
                Height = 18
                ExplicitWidth = 25
                ExplicitHeight = 18
              end
              inherited lblMST: TVA508StaticText
                Width = 31
                Height = 18
                ExplicitWidth = 31
                ExplicitHeight = 18
              end
            end
            inherited pnlSWAC: TPanel
              Top = 78
              Width = 245
              Height = 18
              ExplicitTop = 78
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblSWAC2: TVA508StaticText
                Width = 127
                Height = 18
                ExplicitWidth = 127
                ExplicitHeight = 18
              end
              inherited lblSWAC: TVA508StaticText
                Width = 40
                Height = 18
                ExplicitWidth = 40
                ExplicitHeight = 18
              end
            end
            inherited pnlIR: TPanel
              Top = 60
              Width = 245
              Height = 18
              ExplicitTop = 60
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblIR2: TVA508StaticText
                Width = 133
                Height = 18
                ExplicitWidth = 133
                ExplicitHeight = 18
              end
              inherited lblIR: TVA508StaticText
                Width = 19
                Height = 18
                ExplicitWidth = 19
                ExplicitHeight = 18
              end
            end
            inherited pnlAO: TPanel
              Top = 42
              Width = 245
              Height = 18
              ExplicitTop = 42
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblAO2: TVA508StaticText
                Width = 115
                Height = 18
                ExplicitWidth = 115
                ExplicitHeight = 18
              end
              inherited lblAO: TVA508StaticText
                Width = 19
                Height = 18
                ExplicitWidth = 19
                ExplicitHeight = 18
              end
            end
            inherited pnlSC: TPanel
              Top = 0
              Width = 245
              Height = 20
              ExplicitTop = 0
              ExplicitWidth = 245
              ExplicitHeight = 20
              inherited lblSC2: TVA508StaticText
                Width = 175
                Height = 18
                ExplicitWidth = 175
                ExplicitHeight = 18
              end
              inherited lblSC: TVA508StaticText
                Width = 27
                Height = 18
                ExplicitWidth = 27
                ExplicitHeight = 18
              end
            end
            inherited pnlCV: TPanel
              Top = 24
              Width = 245
              Height = 18
              ExplicitTop = 24
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblCV2: TVA508StaticText
                Width = 142
                Height = 18
                ExplicitWidth = 142
                ExplicitHeight = 18
              end
              inherited lblCV: TVA508StaticText
                Width = 27
                Height = 18
                ExplicitWidth = 27
                ExplicitHeight = 18
              end
            end
            inherited pnlSHD: TPanel
              Top = 96
              Width = 245
              Height = 18
              ExplicitTop = 96
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblSHAD: TVA508StaticText
                Width = 33
                Height = 18
                ExplicitWidth = 33
                ExplicitHeight = 18
              end
              inherited lblSHAD2: TVA508StaticText
                Left = 50
                Width = 160
                Height = 18
                ExplicitLeft = 50
                ExplicitWidth = 160
                ExplicitHeight = 18
              end
            end
            inherited pnlCL: TPanel
              Top = 132
              Width = 245
              Height = 18
              Margins.Left = 2
              Margins.Top = 2
              Margins.Right = 2
              Margins.Bottom = 2
              ExplicitTop = 132
              ExplicitWidth = 245
              ExplicitHeight = 18
              inherited lblCL: TVA508StaticText
                Left = 17
                Width = 17
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitLeft = 17
                ExplicitWidth = 17
                ExplicitHeight = 18
              end
              inherited lblCL2: TVA508StaticText
                Width = 72
                Height = 18
                Margins.Left = 2
                Margins.Top = 2
                Margins.Right = 2
                Margins.Bottom = 2
                ExplicitWidth = 72
                ExplicitHeight = 18
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Left = -1
        Width = 242
        Height = 152
        Align = alNone
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = -1
        ExplicitWidth = 242
        ExplicitHeight = 152
        inherited lblSCDisplay: TLabel
          AlignWithMargins = True
          Left = 3
          Width = 236
          Margins.Top = 0
          Margins.Bottom = 0
          ExplicitLeft = 3
          ExplicitWidth = 235
        end
        inherited memSCDisplay: TCaptionMemo
          Width = 242
          Height = 135
          ExplicitWidth = 242
          ExplicitHeight = 135
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = -1
      Width = 198
      Height = 152
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 8
        Top = 3
        Width = 50
        Height = 13
        Caption = 'lblProvInfo'
      end
    end
  end
  object gpMain: TGridPanel [4]
    Left = 0
    Top = 149
    Width = 713
    Height = 251
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
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
      Width = 711
      Height = 124
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lstReview: TCaptionCheckListBox
        Left = 0
        Top = 23
        Width = 711
        Height = 101
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
        Width = 705
        Height = 17
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
        ExplicitWidth = 254
      end
    end
    object pnlCSReview: TPanel
      Left = 1
      Top = 125
      Width = 711
      Height = 125
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblCSReview: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 166
        Height = 13
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
      end
      object lstCSReview: TCaptionCheckListBox
        Left = 0
        Top = 19
        Width = 711
        Height = 106
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
      object lblSmartCardNeeded: TStaticText
        AlignWithMargins = True
        Left = 189
        Top = 3
        Width = 126
        Height = 17
        Caption = 'SMART card required'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 56
    Top = 80
    Data = (
      (
        'Component = fraCoPay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCaption'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMain'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSHD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSCandRD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.memSCDisplay'
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
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = radSignChart'
        'Status = stsDefault')
      (
        'Component = radHoldSign'
        'Status = stsDefault')
      (
        'Component = grpRelease'
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
        'Component = gpMain'
        'Status = stsDefault'))
  end
end
