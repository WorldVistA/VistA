object frPDMPReviewItem: TfrPDMPReviewItem
  Left = 0
  Top = 0
  Width = 461
  Height = 99
  Ctl3D = False
  ParentBackground = False
  ParentCtl3D = False
  TabOrder = 0
  object pnlItem: TPanel
    Left = 0
    Top = 0
    Width = 461
    Height = 99
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object pnlRequired: TPanel
      Left = 0
      Top = 0
      Width = 13
      Height = 99
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlRequired'
      ShowCaption = False
      TabOrder = 0
      object lblRequired: TLabel
        AlignWithMargins = True
        Left = 6
        Top = 3
        Width = 7
        Height = 13
        Hint = 'Required comments should not be blank or exceed 25 chars'
        Margins.Left = 6
        Margins.Right = 0
        Align = alTop
        Caption = '*'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 3
        ExplicitWidth = 6
      end
    end
    object pnlCanvas: TPanel
      Left = 13
      Top = 0
      Width = 448
      Height = 99
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnlCanvas'
      ShowCaption = False
      TabOrder = 1
      object lblInfo: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 83
        Width = 3
        Height = 13
        Align = alBottom
        Caption = ' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object mm: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 0
        Width = 442
        Height = 77
        Margins.Top = 0
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object popBlank: TPopupMenu
    Left = 216
    Top = 32
  end
end
