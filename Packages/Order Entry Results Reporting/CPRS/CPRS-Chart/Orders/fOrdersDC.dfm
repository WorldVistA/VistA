inherited frmDCOrders: TfrmDCOrders
  Left = 316
  Top = 226
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Discontinue / Cancel Orders'
  ClientHeight = 602
  ClientWidth = 784
  Position = poScreenCenter
  OnClose = nil
  OnCloseQuery = FormCloseQuery
  OnDestroy = nil
  OnDeactivate = nil
  OnHide = nil
  OnKeyDown = nil
  OnShow = nil
  ExplicitWidth = 800
  ExplicitHeight = 641
  PixelsPerInch = 96
  TextHeight = 13
  object SplVert: TSplitter [0]
    Left = 450
    Top = 0
    Height = 555
    ExplicitLeft = 552
    ExplicitTop = 280
    ExplicitHeight = 100
  end
  object DetailsPanel: TPanel [1]
    AlignWithMargins = True
    Left = 456
    Top = 3
    Width = 320
    Height = 551
    Margins.Right = 8
    Margins.Bottom = 1
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clCream
    Constraints.MinWidth = 200
    ParentBackground = False
    TabOrder = 1
    object MemDetail: TMemo
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 301
      Height = 534
      Margins.Right = 12
      Margins.Bottom = 10
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clCream
      Constraints.MinWidth = 200
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object RootPanel: TPanel [2]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 444
    Height = 549
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MaxWidth = 800
    Constraints.MinHeight = 50
    Constraints.MinWidth = 100
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object SplHoriz: TSplitter
      Left = 0
      Top = 250
      Width = 444
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = 3
      ExplicitTop = 251
    end
    object CancelPanel: TPanel
      Left = 0
      Top = 0
      Width = 444
      Height = 250
      Align = alTop
      BevelKind = bkFlat
      BevelOuter = bvNone
      Constraints.MinHeight = 100
      TabOrder = 0
      object LblCancel: TLabel
        Left = 0
        Top = 0
        Width = 440
        Height = 13
        Align = alTop
        Caption = '    The following will be cancelled'
        Layout = tlBottom
        ExplicitWidth = 156
      end
      object cnlOrders: TCaptionListBox
        AlignWithMargins = True
        Left = 10
        Top = 21
        Width = 420
        Height = 217
        Margins.Left = 10
        Margins.Top = 8
        Margins.Right = 10
        Margins.Bottom = 8
        Style = lbOwnerDrawVariable
        Align = alClient
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnDrawItem = cnlOrdersDrawItem
        OnMeasureItem = cnlOrdersMeasureItem
        Caption = 'The following orders will be cancelled '
        OnChange = cnlOrdersChange
      end
    end
    object pnlMain: TPanel
      Left = 0
      Top = 253
      Width = 444
      Height = 296
      Margins.Top = 5
      Align = alClient
      BevelKind = bkFlat
      BevelOuter = bvNone
      BorderWidth = 7
      Constraints.MinHeight = 200
      TabOrder = 1
      OnResize = pnlMainResize
      object LblDiscontinue: TLabel
        Left = 7
        Top = 7
        Width = 426
        Height = 13
        Align = alTop
        Caption = '  The following will be discontinued'
        WordWrap = True
        ExplicitWidth = 164
      end
      object lblReason: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 168
        Width = 420
        Height = 13
        Align = alBottom
        Caption = '  Reason for Discontinue (select one)'
        Layout = tlBottom
        ExplicitWidth = 175
      end
      object lstOrders: TCaptionListBox
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 420
        Height = 139
        Style = lbOwnerDrawVariable
        Align = alClient
        Constraints.MinHeight = 50
        ItemHeight = 13
        TabOrder = 0
        OnDrawItem = lstOrdersDrawItem
        OnMeasureItem = lstOrdersMeasureItem
        Caption = 'The following orders will be discontinued '
        OnChange = lstOrdersChange
      end
      object pnlReason: TORListBox
        AlignWithMargins = True
        Left = 10
        Top = 187
        Width = 420
        Height = 95
        Align = alBottom
        Constraints.MinHeight = 20
        IntegralHeight = True
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Caption = 'Reason for Discontinue (select one)'
        ItemTipColor = clWindow
        LongList = False
        Pieces = '2'
      end
    end
  end
  object BtnPanel: TPanel [3]
    AlignWithMargins = True
    Left = 3
    Top = 558
    Width = 775
    Height = 41
    Margins.Right = 6
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object cmdCancel: TButton
      AlignWithMargins = True
      Left = 700
      Top = 3
      Width = 72
      Height = 35
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 622
    end
    object cmdOK: TButton
      AlignWithMargins = True
      Left = 622
      Top = 3
      Width = 72
      Height = 35
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 376
    Top = 40
    Data = (
      (
        'Component = frmDCOrders'
        'Status = stsDefault')
      (
        'Component = DetailsPanel'
        'Status = stsDefault')
      (
        'Component = RootPanel'
        'Status = stsDefault')
      (
        'Component = CancelPanel'
        'Status = stsDefault')
      (
        'Component = cnlOrders'
        'Status = stsDefault')
      (
        'Component = pnlMain'
        'Status = stsDefault')
      (
        'Component = lstOrders'
        'Status = stsDefault')
      (
        'Component = MemDetail'
        'Status = stsDefault')
      (
        'Component = pnlReason'
        'Status = stsDefault')
      (
        'Component = BtnPanel'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault'))
  end
end
