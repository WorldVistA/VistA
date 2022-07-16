object frDSTMgr: TfrDSTMgr
  Left = 0
  Top = 0
  Width = 199
  Height = 50
  Color = clBtnFace
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object btnLaunchToolbox: TButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 193
    Height = 44
    Action = acDST
    Align = alClient
    TabOrder = 0
  end
  object alDST: TActionList
    Left = 160
    Top = 8
    object acDST: TAction
      Caption = 'Launch DST'
      OnExecute = acDSTExecute
    end
  end
end
