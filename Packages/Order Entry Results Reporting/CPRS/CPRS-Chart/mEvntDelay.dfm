object fraEvntDelayList: TfraEvntDelayList
  Left = 0
  Top = 0
  Width = 366
  Height = 216
  Anchors = []
  AutoScroll = True
  TabOrder = 0
  TabStop = True
  object pnlDate: TPanel
    Left = 261
    Top = 0
    Width = 105
    Height = 216
    Align = alRight
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    Visible = False
    object lblEffective: TLabel
      Left = 4
      Top = 32
      Width = 83
      Height = 16
      Caption = 'Effective Date:'
    end
    object orDateBox: TORDateBox
      Left = 3
      Top = 48
      Width = 97
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'Today'
      DateOnly = False
      RequireTime = False
      Caption = 'Effective Date:'
    end
  end
  object pnlList: TPanel
    Left = 0
    Top = 0
    Width = 261
    Height = 216
    Align = alClient
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    object lblEvntDelayList: TLabel
      Left = 1
      Top = 1
      Width = 259
      Height = 16
      Align = alTop
      Caption = 'Event Delay List:'
      ExplicitWidth = 94
    end
    object mlstEvents: TORListBox
      Left = 1
      Top = 38
      Width = 259
      Height = 177
      Align = alClient
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = mlstEventsClick
      OnKeyUp = mlstEventsKeyUp
      Caption = ''
      ItemTipColor = clWindow
      LongList = False
      Pieces = '9'
      OnChange = mlstEventsChange
      RightClickSelect = True
      CheckEntireLine = True
      ExplicitTop = 35
      ExplicitHeight = 180
    end
    object edtSearch: TCaptionEdit
      Left = 1
      Top = 17
      Width = 259
      Height = 21
      Align = alTop
      TabOrder = 1
      OnChange = edtSearchChange
      OnKeyDown = edtSearchKeyDown
      Caption = ''
      ExplicitTop = 14
    end
  end
end
