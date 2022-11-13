inherited frmOrderView: TfrmOrderView
  Left = 340
  Top = 165
  Caption = 'Custom Order View'
  ClientHeight = 413
  ClientWidth = 421
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  ExplicitWidth = 437
  ExplicitHeight = 452
  PixelsPerInch = 96
  TextHeight = 13
  object pnlView: TPanel [0]
    Left = 0
    Top = 0
    Width = 421
    Height = 21
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnEnter = pnlViewEnter
    object lblView: TLabel
      Left = 1
      Top = 1
      Width = 419
      Height = 19
      Align = alClient
      Alignment = taCenter
      Caption = 'All Services, Active Orders'
      Layout = tlCenter
      ExplicitWidth = 153
      ExplicitHeight = 13
    end
    object lbl508View: TStaticText
      Left = 1
      Top = 1
      Width = 419
      Height = 19
      Align = alClient
      Alignment = taCenter
      BevelEdges = []
      Caption = 'All Services, Active Orders'
      TabOrder = 0
      Visible = False
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 21
    Width = 421
    Height = 278
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 211
      Top = 0
      Height = 278
      MinSize = 1
      OnMoved = Splitter1Moved
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 211
      Height = 278
      Align = alLeft
      Constraints.MinWidth = 15
      TabOrder = 0
      object lblFilter: TLabel
        Left = 1
        Top = 1
        Width = 209
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Order Status'
        Layout = tlCenter
        ExplicitWidth = 59
      end
      object trFilters: TCaptionTreeView
        Left = 1
        Top = 14
        Width = 209
        Height = 263
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = trFiltersChange
        OnClick = trFiltersClick
        Caption = 'Order Status'
      end
    end
    object Panel3: TPanel
      Left = 214
      Top = 0
      Width = 207
      Height = 278
      Align = alClient
      Constraints.MinWidth = 15
      TabOrder = 1
      object lblService: TLabel
        Left = 1
        Top = 1
        Width = 205
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Service/Section'
        Layout = tlCenter
        ExplicitWidth = 77
      end
      object treService: TCaptionTreeView
        Left = 1
        Top = 14
        Width = 205
        Height = 263
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = treServiceChange
        OnClick = treServiceClick
        Caption = 'Service/Section'
      end
    end
  end
  object Panel4: TPanel [2]
    Left = 0
    Top = 299
    Width = 421
    Height = 114
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      421
      114)
    object chkDateRange: TCheckBox
      Left = 5
      Top = 3
      Width = 372
      Height = 19
      Caption = 'Only List Orders Placed During Time Period'
      TabOrder = 0
      OnClick = chkDateRangeClick
      OnEnter = chkDateRangeEnter
    end
    object GroupBox1: TGroupBox
      Left = 4
      Top = 21
      Width = 399
      Height = 45
      TabOrder = 1
      object lblFrom: TLabel
        Left = 25
        Top = 19
        Width = 26
        Height = 13
        Caption = 'From:'
        Enabled = False
      end
      object lblThru: TLabel
        Left = 210
        Top = 19
        Width = 43
        Height = 13
        Caption = 'Through:'
        Enabled = False
      end
      object calFrom: TORDateBox
        Left = 55
        Top = 16
        Width = 128
        Height = 21
        Color = clBtnFace
        Enabled = False
        TabOrder = 0
        OnChange = calChange
        DateOnly = False
        RequireTime = False
        Caption = 'From Date'
      end
      object calThru: TORDateBox
        Left = 257
        Top = 16
        Width = 128
        Height = 21
        Color = clBtnFace
        Enabled = False
        TabOrder = 1
        OnChange = calChange
        DateOnly = False
        RequireTime = False
        Caption = 'Through Date'
      end
    end
    object chkInvChrono: TCheckBox
      Left = 6
      Top = 92
      Width = 204
      Height = 18
      Anchors = [akLeft, akBottom]
      Caption = 'Reverse Chronological Sequence'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object chkByService: TCheckBox
      Left = 6
      Top = 72
      Width = 187
      Height = 18
      Caption = 'Group Orders by Service'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cmdOK: TButton
      Left = 246
      Top = 78
      Width = 72
      Height = 23
      Anchors = [akLeft, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 4
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 328
      Top = 78
      Width = 72
      Height = 23
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlView'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = trFilters'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = treService'
        'Status = stsDefault')
      (
        'Component = Panel4'
        'Status = stsDefault')
      (
        'Component = chkDateRange'
        'Status = stsDefault')
      (
        'Component = GroupBox1'
        'Status = stsDefault')
      (
        'Component = calFrom'
        'Text = From Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = calThru'
        'Text = Through Date/Time. Press the enter key to access.'
        'Status = stsOK')
      (
        'Component = chkInvChrono'
        'Status = stsDefault')
      (
        'Component = chkByService'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmOrderView'
        'Status = stsDefault')
      (
        'Component = lbl508View'
        'Status = stsDefault'))
  end
end
