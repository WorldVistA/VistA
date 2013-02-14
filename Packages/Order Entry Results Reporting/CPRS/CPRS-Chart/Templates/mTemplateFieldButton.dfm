object fraTemplateFieldButton: TfraTemplateFieldButton
  Left = 0
  Top = 0
  Width = 136
  Height = 14
  AutoScroll = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  TabStop = True
  OnEnter = FrameEnter
  OnExit = FrameExit
  object pnlBtn: TPanel
    Left = 0
    Top = 0
    Width = 136
    Height = 14
    Align = alClient
    TabOrder = 0
    OnExit = FrameExit
    OnMouseDown = pnlBtnMouseDown
    OnMouseUp = pnlBtnMouseUp
    DesignSize = (
      136
      14)
    object lblText: TLabel
      Left = 2
      Top = -1
      Width = 132
      Height = 14
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Transparent = True
      Layout = tlCenter
      OnMouseDown = pnlBtnMouseDown
      OnMouseUp = pnlBtnMouseUp
      ExplicitWidth = 105
    end
    object pbFocus: TPaintBox
      Left = 1
      Top = 1
      Width = 134
      Height = 12
      Align = alClient
      OnMouseDown = pnlBtnMouseDown
      OnMouseUp = pnlBtnMouseUp
      OnPaint = pbFocusPaint
      ExplicitWidth = 107
    end
  end
end
