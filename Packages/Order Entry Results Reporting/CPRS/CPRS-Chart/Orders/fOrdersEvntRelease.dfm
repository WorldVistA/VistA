inherited frmOrdersEvntRelease: TfrmOrdersEvntRelease
  Left = 196
  Top = 66
  BorderIcons = [biSystemMenu]
  Caption = 'Auto DC/Release Event Orders'
  ClientHeight = 328
  ClientWidth = 443
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 459
  ExplicitHeight = 366
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 85
    Align = alTop
    TabOrder = 0
    object lblPtInfo: TStaticText
      Left = 1
      Top = 1
      Width = 441
      Height = 52
      Align = alTop
      AutoSize = False
      TabOrder = 1
    end
    object Panel1: TPanel
      Left = 1
      Top = 53
      Width = 441
      Height = 31
      Align = alClient
      TabOrder = 0
      object Panel2: TPanel
        Left = 293
        Top = 1
        Width = 147
        Height = 29
        Align = alClient
        TabOrder = 0
        DesignSize = (
          147
          29)
        object btnApply: TButton
          Left = 80
          Top = 4
          Width = 63
          Height = 21
          Anchors = [akRight, akBottom]
          Caption = 'Apply'
          TabOrder = 2
          OnClick = btnApplyClick
          OnKeyDown = btnApplyKeyDown
        end
        object updown1: TUpDown
          Left = 61
          Top = 4
          Width = 16
          Height = 21
          Anchors = [akRight, akBottom]
          Associate = edtNumber
          Min = 1
          Max = 10000
          Position = 5
          TabOrder = 1
          OnClick = updown1Click
        end
        object edtNumber: TEdit
          Left = 5
          Top = 4
          Width = 56
          Height = 21
          Hint = 'Enter the number of events you would like to view'
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          Text = '5'
          OnChange = edtNumberChange
          OnClick = edtNumberClick
          OnKeyDown = edtNumberKeyDown
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 292
        Height = 29
        Align = alLeft
        TabOrder = 1
        object Label2: TLabel
          Left = 1
          Top = 1
          Width = 290
          Height = 13
          Align = alTop
          Caption = '  Enter the number of events you would like to view '
          WordWrap = True
          ExplicitWidth = 244
        end
        object Label3: TLabel
          Left = 1
          Top = 14
          Width = 290
          Height = 13
          Align = alTop
          Caption = '  (Input "ALL" to view all events):'
          ExplicitWidth = 156
        end
      end
    end
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 85
    Width = 443
    Height = 243
    Align = alClient
    TabOrder = 1
    OnResize = pnlBottomResize
    DesignSize = (
      443
      243)
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 441
      Height = 28
      Align = alTop
      AutoSize = False
      Caption = '  View orders released or discontinued by'
      Layout = tlCenter
    end
    object btnOK: TButton
      Left = 269
      Top = 214
      Width = 75
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 353
      Top = 214
      Width = 75
      Height = 20
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object grdEvtList: TCaptionStringGrid
      Left = 1
      Top = 29
      Width = 441
      Height = 166
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColCount = 2
      DefaultRowHeight = 22
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 7
      Options = [goFixedVertLine, goFixedHorzLine, goHorzLine, goRowSizing, goColSizing, goTabs, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = grdEvtListDblClick
      OnDrawCell = grdEvtListDrawCell
      OnKeyPress = grdEvtListKeyPress
      OnMouseDown = grdEvtListMouseDown
      Caption = 'View orders released or discontinued by'
      JustToTab = True
      ColWidths = (
        310
        125)
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = lblPtInfo'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = updown1'
        'Status = stsDefault')
      (
        'Component = edtNumber'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = grdEvtList'
        'Status = stsDefault')
      (
        'Component = frmOrdersEvntRelease'
        'Status = stsDefault'))
  end
end
