inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 515
  ClientWidth = 672
  Constraints.MinWidth = 500
  OldCreateOrder = True
  Position = poScreenCenter
  OnHelp = nil
  OnMouseMove = FormMouseMove
  ExplicitWidth = 688
  ExplicitHeight = 554
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDEAText: TPanel [0]
    AlignWithMargins = True
    Left = 4
    Top = 399
    Width = 664
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
      Width = 664
      Height = 53
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
  object pnlEsig: TPanel [1]
    Left = 0
    Top = 456
    Width = 672
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
      672
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
      Left = 9
      Top = 20
      Width = 169
      Height = 21
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
      Left = 470
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
      Left = 566
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
  object pnlCombined: TORAutoPanel [2]
    Left = 0
    Top = 209
    Width = 672
    Height = 186
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    object gpMain: TGridPanel
      Left = 0
      Top = 0
      Width = 672
      Height = 186
      Align = alClient
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = pnlOrderList
          Row = 0
        end
        item
          Column = 0
          Control = pnlCSOrderList
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
      OnResize = gpMainResize
      object pnlOrderList: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 664
        Height = 85
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblOrderList: TStaticText
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 664
          Height = 17
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Align = alTop
          Caption = 'All Orders Except Controlled Substance EPCS Orders'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 0
        end
        object clstOrders: TCaptionCheckListBox
          Left = 0
          Top = 20
          Width = 664
          Height = 65
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
      object pnlCSOrderList: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 97
        Width = 664
        Height = 85
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Anchors = []
        BevelOuter = bvNone
        TabOrder = 1
        object clstCSOrders: TCaptionCheckListBox
          Left = 0
          Top = 17
          Width = 664
          Height = 68
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          OnClickCheck = clstOrdersClickCheck
          Align = alClient
          DoubleBuffered = True
          ParentDoubleBuffered = False
          Style = lbOwnerDrawVariable
          TabOrder = 0
          OnDrawItem = clstOrdersDrawItem
          OnKeyUp = clstOrdersKeyUp
          OnMeasureItem = clstOrdersMeasureItem
          OnMouseMove = clstOrdersMouseMove
          Caption = 'The following orders will be signed -'
        end
        object pnlCSTop: TPanel
          Left = 0
          Top = 0
          Width = 664
          Height = 17
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          object lblCSOrderList: TStaticText
            Left = 0
            Top = 0
            Width = 170
            Height = 17
            Align = alLeft
            Caption = 'Controlled Substance EPCS Orders'
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 0
          end
          object lblSmartCardNeeded: TStaticText
            AlignWithMargins = True
            Left = 176
            Top = 0
            Width = 126
            Height = 17
            Margins.Left = 6
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            Caption = 'SMART card required'
            Color = clBtnFace
            DoubleBuffered = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentDoubleBuffered = False
            ParentFont = False
            TabOrder = 1
            Transparent = False
            ExplicitLeft = 179
            ExplicitTop = -4
          end
        end
      end
    end
  end
  object pnlTop: TPanel [3]
    Left = 0
    Top = 0
    Width = 672
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
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 193
      Height = 209
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 0
      object lblProvInfo: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 187
        Height = 13
        Align = alTop
        Caption = 'prov info'
        ExplicitWidth = 41
      end
    end
    inline fraCoPay: TfraCoPayDesc
      Left = 193
      Top = 0
      Width = 479
      Height = 209
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      Visible = False
      ExplicitLeft = 193
      ExplicitWidth = 479
      ExplicitHeight = 209
      inherited gpMain: TGridPanel
        Width = 479
        Height = 209
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
        ExplicitWidth = 479
        ExplicitHeight = 209
        inherited pnlSCandRD: TPanel
          Width = 240
          Height = 209
          ExplicitWidth = 240
          ExplicitHeight = 209
          inherited lblSCDisplay: TLabel
            Width = 234
            ExplicitWidth = 412
          end
          inherited pnlBorderLeft: TPanel
            Width = 240
            Height = 187
            ExplicitWidth = 240
            ExplicitHeight = 187
            inherited memSCDisplay: TCaptionMemo
              Width = 234
              Height = 181
              ExplicitWidth = 234
              ExplicitHeight = 181
            end
          end
        end
        inherited pnlRight: TPanel
          Left = 240
          Width = 239
          Height = 209
          ExplicitLeft = 240
          ExplicitWidth = 239
          ExplicitHeight = 209
          inherited lblCaption: TStaticText
            Width = 233
            ExplicitWidth = 233
          end
          inherited pnlBorderRight: TPanel
            Width = 239
            Height = 186
            ExplicitWidth = 239
            ExplicitHeight = 186
            inherited gpRight: TGridPanel
              Width = 233
              Height = 180
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
              ExplicitWidth = 233
              ExplicitHeight = 180
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
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 32
    Data = (
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
        'Status = stsDefault')
      (
        'Component = gpMain'
        'Status = stsDefault')
      (
        'Component = fraCoPay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.gpMain'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSCandRD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlBorderLeft'
        'Status = stsDefault')
      (
        'Component = fraCoPay.memSCDisplay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCaption'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlBorderRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.gpRight'
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
        'Component = pnlCSTop'
        'Status = stsDefault'))
  end
end
