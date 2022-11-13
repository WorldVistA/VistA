inherited frmFlagComment: TfrmFlagComment
  Left = 365
  Top = 389
  Caption = 'Add Flag Comment'
  ClientHeight = 364
  ClientWidth = 575
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 591
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  object lblNewComment: TLabel [0]
    Left = 8
    Top = 293
    Width = 69
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'New Comment'
    ExplicitTop = 282
  end
  object txtComment: TCaptionEdit [1]
    Left = 8
    Top = 308
    Width = 559
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    Caption = 'Comment (optional)'
  end
  object cmdOK: TButton [2]
    Left = 346
    Top = 335
    Width = 143
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'Submit Comment'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [3]
    Left = 495
    Top = 335
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object memReason: TMemo [4]
    Left = 8
    Top = 8
    Width = 559
    Height = 276
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtComment'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Text = Submit Flagging Comment'
        'Status = stsOK')
      (
        'Component = cmdCancel'
        'Text = Cancel Flagging Comment'
        'Status = stsOK')
      (
        'Component = memReason'
        'Text = Add a Flagging Comment'
        'Status = stsOK')
      (
        'Component = frmFlagComment'
        'Status = stsDefault'))
  end
end
