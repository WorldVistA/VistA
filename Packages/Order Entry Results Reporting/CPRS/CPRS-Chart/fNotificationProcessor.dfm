inherited frmNotificationProcessor: TfrmNotificationProcessor
  Left = 0
  Top = 0
  Caption = 'CPRS Notification Processor'
  ClientHeight = 362
  ClientWidth = 596
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    596
    362)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlBottom: TBevel
    Left = 0
    Top = 322
    Width = 596
    Height = 40
    Align = alBottom
    Shape = bsSpacer
    ExplicitTop = 312
    ExplicitWidth = 484
  end
  object memNotificationSpecifications: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 26
    Width = 590
    Height = 103
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'memNotificationSpecifications'
      
        '1234567890123456789012345678901234567890123456789012345678901234' +
        '5678901234567890')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object stxtNotificationName: TStaticText
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 590
    Height = 17
    Align = alTop
    Caption = 'stxtNotificationName'
    TabOrder = 0
  end
  object rbtnNewNote: TRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 135
    Width = 590
    Height = 17
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Create New Note'
    TabOrder = 2
    OnClick = NewOrAddendClick
  end
  object rbtnAddendOneOfTheFollowing: TRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 158
    Width = 590
    Height = 17
    Align = alTop
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Addend one of the following notes'
    TabOrder = 3
    OnClick = NewOrAddendClick
  end
  object lbxCurrentNotesAvailable: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 181
    Width = 590
    Height = 138
    Align = alClient
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 4
    OnClick = NewOrAddendClick
  end
  object btnCancel: TButton
    Left = 450
    Top = 329
    Width = 138
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Return to Notifications'
    ModalResult = 2
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 369
    Top = 329
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnDefer: TButton
    Left = 8
    Top = 329
    Width = 107
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Defer Notification'
    ModalResult = 2
    TabOrder = 7
    OnClick = btnDeferClick
  end
end
