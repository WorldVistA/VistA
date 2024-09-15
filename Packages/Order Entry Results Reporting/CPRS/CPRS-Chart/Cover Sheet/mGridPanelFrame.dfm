object fraGridPanelFrame: TfraGridPanelFrame
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 505
  Height = 385
  Margins.Left = 2
  Margins.Top = 2
  Margins.Right = 2
  Margins.Bottom = 2
  DoubleBuffered = True
  ParentDoubleBuffered = False
  PopupMenu = pmn
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 385
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object pnlHeader: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 499
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnlHeader'
      DoubleBuffered = True
      ParentColor = True
      ParentDoubleBuffered = False
      ShowCaption = False
      TabOrder = 0
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 28
        Top = 3
        Width = 443
        Height = 19
        Align = alClient
        Caption = 'lblTitle'
        Layout = tlCenter
        ExplicitWidth = 30
        ExplicitHeight = 13
      end
      object sbtnExpandCollapse: TSpeedButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 19
        Height = 19
        Align = alLeft
        Flat = True
        Visible = False
        ExplicitLeft = 288
        ExplicitTop = 8
        ExplicitHeight = 22
      end
      object sbtnRefresh: TSpeedButton
        AlignWithMargins = True
        Left = 477
        Top = 3
        Width = 19
        Height = 19
        Align = alRight
        Flat = True
        Visible = False
        ExplicitLeft = 473
      end
    end
    object pnlWorkspace: TPanel
      AlignWithMargins = True
      Left = 34
      Top = 33
      Width = 469
      Height = 350
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlWorkspace'
      DoubleBuffered = True
      ParentBackground = False
      ParentColor = True
      ParentDoubleBuffered = False
      ShowCaption = False
      TabOrder = 1
    end
    object pnlVertHeader: TPanel
      Left = 0
      Top = 31
      Width = 32
      Height = 354
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object img: TImage
        Left = 0
        Top = 0
        Width = 32
        Height = 354
        Align = alClient
        ExplicitTop = 31
      end
    end
  end
  object pmn: TPopupMenu
    Left = 232
    Top = 56
    object pmnExpandCollapse: TMenuItem
      Caption = 'Expand/Collapse'
    end
    object pmnRefresh: TMenuItem
      Caption = 'Refresh'
    end
    object pmnCustomize: TMenuItem
      Caption = 'Customize ...'
    end
    object pmnShowError: TMenuItem
      Caption = 'Show Error ...'
      Visible = False
    end
  end
end
