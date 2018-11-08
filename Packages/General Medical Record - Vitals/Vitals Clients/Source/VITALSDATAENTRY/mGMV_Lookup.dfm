object fraGMV_Lookup: TfraGMV_Lookup
  Left = 0
  Top = 0
  Width = 167
  Height = 38
  TabOrder = 0
  OnEnter = FrameEnter
  OnExit = FrameExit
  OnResize = FrameResize
  DesignSize = (
    167
    38)
  object cbxValues: TComboBox
    Left = 16
    Top = 0
    Width = 151
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    TabStop = False
    Visible = False
    OnClick = cbxValuesClick
    OnExit = cbxValuesExit
    OnKeyDown = cbxValuesKeyDown
  end
  object edtValue: TComboBox
    Left = 0
    Top = 0
    Width = 167
    Height = 21
    Style = csSimple
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'edtValue'
    OnChange = edtValueChange
    OnExit = edtValueExit
    OnKeyUp = edtValueKeyUp
  end
  object tmrLookup: TTimer
    Enabled = False
    Interval = 800
    OnTimer = tmrLookupTimer
    Left = 128
    Top = 8
  end
end
