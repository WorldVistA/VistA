inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 651
  ClientWidth = 991
  Constraints.MinHeight = 554
  Constraints.MinWidth = 855
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 1009
  ExplicitHeight = 696
  PixelsPerInch = 120
  TextHeight = 16
  object laDiagnosis: TLabel [0]
    Left = 315
    Top = 166
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnosis'
    Visible = False
  end
  object gbxDxLookup: TGroupBox [1]
    Left = 686
    Top = 30
    Width = 124
    Height = 52
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Lookup Diagnosis'
    TabOrder = 0
    TabStop = True
    Visible = False
    object buDiagnosis: TButton
      Left = 12
      Top = 18
      Width = 102
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '&Diagnosis'
      Enabled = False
      TabOrder = 0
      OnClick = buDiagnosisClick
    end
  end
  object pnlCombined: TORAutoPanel [2]
    Left = 0
    Top = 238
    Width = 991
    Height = 254
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object pnlReview: TPanel
      Left = 0
      Top = 0
      Width = 991
      Height = 158
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        991
        158)
      object lstReview: TCaptionCheckListBox
        Left = 5
        Top = 38
        Width = 987
        Height = 120
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = lstReviewClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 15
        ParentShowHint = False
        PopupMenu = poBACopyPaste
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnClick = lstReviewClick
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseDown = lstReviewMouseDown
        OnMouseMove = lstReviewMouseMove
        Caption = 'Signature will be Applied to Checked Items'
      end
      object lblSig: TStaticText
        Left = 10
        Top = 10
        Width = 321
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
      end
    end
    object pnlCSReview: TPanel
      Left = 0
      Top = 158
      Width = 991
      Height = 96
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        991
        96)
      object lblCSReview: TLabel
        Left = 6
        Top = 9
        Width = 211
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Controlled Substance EPCS Orders'
      end
      object lstCSReview: TCaptionCheckListBox
        Left = 2
        Top = 32
        Width = 991
        Height = 64
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = lstCSReviewClickCheck
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnClick = lstCSReviewClick
        OnDrawItem = lstCSReviewDrawItem
        OnKeyUp = lstCSReviewKeyUp
        OnMeasureItem = lstCSReviewMeasureItem
        OnMouseDown = lstCSReviewMouseDown
        OnMouseMove = lstCSReviewMouseMove
        Caption = ''
      end
      object lblSmartCardNeeded: TStaticText
        Left = 225
        Top = 6
        Width = 157
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'SMART card required'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 542
    Width = 991
    Height = 109
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      991
      109)
    object pnlSignature: TPanel
      Left = 10
      Top = 50
      Width = 187
      Height = 53
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object lblESCode: TLabel
        Left = 0
        Top = 0
        Width = 155
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Electronic Signature Code'
      end
      object txtESCode: TCaptionEdit
        Left = 0
        Top = 17
        Width = 169
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        PasswordChar = '*'
        TabOrder = 0
        OnChange = txtESCodeChange
        Caption = 'Electronic Signature Code'
      end
    end
    object pnlOrderAction: TPanel
      Left = 186
      Top = 26
      Width = 459
      Height = 80
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label1: TStaticText
        Left = 0
        Top = 0
        Width = 140
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'For orders, select from:'
        TabOrder = 4
      end
      object radSignChart: TRadioButton
        Left = 0
        Top = 20
        Width = 124
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Signed on Chart'
        TabOrder = 0
        OnClick = radReleaseClick
      end
      object radHoldSign: TRadioButton
        Left = 0
        Top = 44
        Width = 124
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Hold until Signed'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = radReleaseClick
      end
      object grpRelease: TGroupBox
        Left = 148
        Top = 20
        Width = 296
        Height = 51
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Visible = False
        object radVerbal: TRadioButton
          Left = 10
          Top = 23
          Width = 65
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Verbal'
          Enabled = False
          TabOrder = 0
        end
        object radPhone: TRadioButton
          Left = 98
          Top = 23
          Width = 95
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Telephone'
          Enabled = False
          TabOrder = 1
        end
        object radPolicy: TRadioButton
          Left = 207
          Top = 23
          Width = 60
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Policy'
          Enabled = False
          TabOrder = 2
        end
      end
      object radRelease: TRadioButton
        Left = 158
        Top = 20
        Width = 139
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Release to Service'
        TabOrder = 2
        Visible = False
        OnClick = radReleaseClick
      end
    end
    object cmdOK: TButton
      Left = 793
      Top = 68
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 889
      Top = 68
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object lblHoldSign: TStaticText
      Left = 220
      Top = 2
      Width = 366
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 4
      Visible = False
    end
  end
  object pnlDEAText: TPanel [4]
    Left = 0
    Top = 492
    Width = 991
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 991
      Height = 50
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
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
  object pnlTop: TPanel [5]
    Left = 0
    Top = 0
    Width = 991
    Height = 238
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    inline fraCoPay: TfraCoPayDesc
      Left = 398
      Top = 0
      Width = 593
      Height = 238
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 398
      ExplicitWidth = 593
      ExplicitHeight = 238
      inherited pnlRight: TPanel
        Left = 266
        Width = 327
        Height = 238
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = True
        ExplicitLeft = 266
        ExplicitWidth = 327
        ExplicitHeight = 238
        inherited Spacer2: TLabel
          Top = 20
          Width = 327
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 20
          ExplicitWidth = 327
        end
        inherited lblCaption: TStaticText
          Width = 327
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Patient Orders Related To:'
          ExplicitWidth = 327
          ExplicitHeight = 20
        end
        inherited ScrollBox1: TScrollBox
          Top = 23
          Width = 327
          Height = 215
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          AutoSize = True
          ExplicitTop = 23
          ExplicitWidth = 327
          ExplicitHeight = 215
          inherited pnlMain: TPanel
            Width = 323
            Height = 205
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 323
            ExplicitHeight = 205
            inherited spacer1: TLabel
              Top = 22
              Width = 323
              Height = 4
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 22
              ExplicitWidth = 322
              ExplicitHeight = 4
            end
            inherited pnlHNC: TPanel
              Top = 139
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 139
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblHNC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblHNC: TVA508StaticText
                Left = 17
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 17
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlMST: TPanel
              Top = 117
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 117
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblMST2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblMST: TVA508StaticText
                Left = 16
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlSWAC: TPanel
              Top = 95
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 95
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblSWAC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblSWAC: TVA508StaticText
                Left = 4
                Width = 49
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 4
                ExplicitWidth = 49
                ExplicitHeight = 22
              end
            end
            inherited pnlIR: TPanel
              Top = 73
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 73
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblIR2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblIR: TVA508StaticText
                Left = 26
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 26
                ExplicitHeight = 22
              end
            end
            inherited pnlAO: TPanel
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblAO2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblAO: TVA508StaticText
                Left = 22
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 22
                ExplicitHeight = 22
              end
            end
            inherited pnlSC: TPanel
              Top = 26
              Width = 323
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 26
              ExplicitWidth = 323
              ExplicitHeight = 25
              inherited lblSC2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblSC: TVA508StaticText
                Left = 25
                Width = 33
                Height = 23
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 23
              end
            end
            inherited pnlCV: TPanel
              Top = 51
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 51
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblCV2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
              inherited lblCV: TVA508StaticText
                Left = 25
                Width = 33
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 22
              end
            end
            inherited pnlSHD: TPanel
              Top = 161
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 161
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblSHAD: TVA508StaticText
                Left = 16
                Width = 41
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 41
                ExplicitHeight = 22
              end
              inherited lblSHAD2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
            end
            inherited pnlCL: TPanel
              Top = 183
              Width = 323
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 183
              ExplicitWidth = 323
              ExplicitHeight = 22
              inherited lblCL: TVA508StaticText
                Left = 26
                Width = 31
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 26
                ExplicitWidth = 31
                ExplicitHeight = 22
              end
              inherited lblCL2: TVA508StaticText
                Left = 62
                Width = 235
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ExplicitLeft = 62
                ExplicitWidth = 235
                ExplicitHeight = 22
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 266
        Height = 238
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitWidth = 266
        ExplicitHeight = 238
        inherited lblSCDisplay: TLabel
          Width = 266
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitWidth = 266
          ExplicitHeight = 20
        end
        inherited memSCDisplay: TCaptionMemo
          Top = 20
          Width = 266
          Height = 218
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 20
          ExplicitWidth = 266
          ExplicitHeight = 218
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 398
      Height = 238
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 10
        Top = 4
        Width = 63
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'lblProvInfo'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 648
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
        'Component = gbxDxLookup'
        'Status = stsDefault')
      (
        'Component = buDiagnosis'
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
        'Component = pnlCombined'
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
        'Status = stsDefault'))
  end
  object poBACopyPaste: TPopupMenu
    Left = 576
    Top = 80
    object Copy1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = Copy1Click
    end
    object Paste1: TMenuItem
      Caption = '&Paste'
      Enabled = False
      ShortCut = 16470
      OnClick = Paste1Click
    end
    object Diagnosis1: TMenuItem
      Caption = '&Diagnosis...'
      ShortCut = 32836
      OnClick = buDiagnosisClick
    end
    object Exit1: TMenuItem
      Caption = '&Exit'
      ShortCut = 16453
      OnClick = Exit1Click
    end
  end
end
