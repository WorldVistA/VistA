object frDefaultSelector: TfrDefaultSelector
  Left = 0
  Top = 0
  Width = 362
  Height = 26
  TabOrder = 0
  DesignSize = (
    362
    26)
  object lblName: TLabel
    Left = 10
    Top = 5
    Width = 38
    Height = 13
    Caption = 'lblName'
    FocusControl = cbQualifiers
  end
  object cbQualifiers: TComboBox
    Left = 96
    Top = 2
    Width = 265
    Height = 21
    BevelInner = bvNone
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = True
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnEnter = cbQualifiersEnter
    OnExit = cbQualifiersExit
  end
end
