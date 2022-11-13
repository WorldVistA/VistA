inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 643
  ClientWidth = 852
  Constraints.MinHeight = 554
  Constraints.MinWidth = 862
  OldCreateOrder = True
  Position = poScreenCenter
  OnHelp = nil
  OnMouseMove = FormMouseMove
  ExplicitWidth = 868
  ExplicitHeight = 682
  PixelsPerInch = 96
  TextHeight = 13
  object laDiagnosis: TLabel [0]
    Left = 226
    Top = 228
    Width = 46
    Height = 13
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlDEAText: TPanel [1]
    AlignWithMargins = True
    Left = 4
    Top = 527
    Width = 844
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 1574
      Height = 17
      Margins.Left = 7
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
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
  object pnlEsig: TPanel [2]
    Left = 0
    Top = 584
    Width = 852
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    DesignSize = (
      852
      59)
    object lblESCode: TLabel
      Left = 9
      Top = -1
      Width = 123
      Height = 13
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TCaptionEdit
      Left = 7
      Top = 22
      Width = 169
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 650
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Caption = 'Sign'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 751
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  object pnlCombined: TORAutoPanel [3]
    Left = 0
    Top = 209
    Width = 852
    Height = 314
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    object pnlCSOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 157
      Width = 844
      Height = 153
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblCSOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 844
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ExplicitWidth = 170
      end
      object lblSmartCardNeeded: TStaticText
        Left = 226
        Top = -1
        Width = 157
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'SMART card required'
        Color = clBtnFace
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
      object clstCSOrders: TCaptionCheckListBox
        Left = 0
        Top = 17
        Width = 844
        Height = 136
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstOrdersClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        Style = lbOwnerDrawVariable
        TabOrder = 2
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
    object pnlOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 844
      Height = 145
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 844
        Height = 17
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        ExplicitWidth = 254
      end
      object clstOrders: TCaptionCheckListBox
        Left = 0
        Top = 17
        Width = 844
        Height = 128
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstOrdersClickCheck
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 1
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
  end
  object pnlTop: TPanel [4]
    Left = 0
    Top = 0
    Width = 852
    Height = 209
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    ExplicitWidth = 304
    DesignSize = (
      852
      209)
    inline fraCoPay: TfraCoPayDesc
      Left = 0
      Top = 0
      Width = 852
      Height = 193
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      AutoSize = True
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
      ExplicitWidth = 304
      ExplicitHeight = 193
      inherited pnlSCandRD: TPanel
        Width = 516
        Height = 193
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 516
        ExplicitHeight = 193
        inherited lblSCDisplay: TLabel
          Left = 221
          Top = -3
          Width = 500
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 221
          ExplicitTop = -3
          ExplicitWidth = 500
          ExplicitHeight = 20
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 226
          Top = 21
          Width = 288
          Height = 172
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 226
          ExplicitTop = 21
          ExplicitWidth = 288
          ExplicitHeight = 172
        end
      end
      inherited pnlRight: TPanel
        Left = 516
        Width = 336
        Height = 193
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitLeft = 516
        ExplicitWidth = 336
        ExplicitHeight = 193
        inherited ScrollBox2: TScrollBox
          Top = 0
          Width = 336
          Height = 193
          ExplicitTop = 0
          ExplicitWidth = 336
          ExplicitHeight = 193
          inherited GridPanel1: TGridPanel
            Width = 332
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
            ExplicitWidth = 332
          end
        end
        inherited lblCaption: TStaticText
          Left = 20
          Width = 296
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          ExplicitLeft = 20
          ExplicitWidth = 296
          ExplicitHeight = 20
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 213
      Height = 186
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 10
        Top = 4
        Width = 41
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'prov info'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 760
    Top = 88
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
        'Component = fraCoPay.lblHNC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV'
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
        'Component = frmSignOrders'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlOrderList'
        'Status = stsDefault')
      (
        'Component = lblOrderList'
        'Status = stsDefault')
      (
        'Component = clstOrders'
        'Status = stsDefault')
      (
        'Component = pnlCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = clstCSOrders'
        'Status = stsDefault')
      (
        'Component = pnlEsig'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlCombined'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault'))
  end
end
