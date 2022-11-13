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
    ExplicitLeft = 14
    ExplicitWidth = 122
    DesignSize = (
      136
      14)
    object spRequired: TShape
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 128
      Height = 6
      Align = alClient
      Brush.Color = clBtnFace
      Pen.Color = clBtnFace
      Shape = stRoundRect
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 14
      ExplicitHeight = 14
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
  end
end
