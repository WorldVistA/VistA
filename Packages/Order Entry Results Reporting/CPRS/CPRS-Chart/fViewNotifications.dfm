inherited frmViewNotifications: TfrmViewNotifications
  Left = 0
  Top = 0
  Caption = 'All Current Notifications for Patient'
  ClientHeight = 362
  ClientWidth = 722
  Constraints.MinHeight = 150
  Constraints.MinWidth = 734
  OnResize = FormResize
  ExplicitWidth = 734
  ExplicitHeight = 400
  TextHeight = 13
  object clvNotifications: TCaptionListView [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 716
    Height = 325
    Align = alClient
    Columns = <
      item
        Caption = 'My To Do'
      end
      item
        Caption = 'Info'
      end
      item
        Caption = 'Location'
        Width = 64
      end
      item
        Caption = 'Urgency'
        Width = 64
      end
      item
        Caption = 'Alert Date/Time'
        Width = 96
      end
      item
        Caption = 'Message'
      end
      item
        Caption = 'Ordering Provider'
      end
      item
        Caption = 'Forwarded By/When'
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = clvNotificationsColumnClick
    OnDblClick = acProcessExecute
    AutoSize = False
    Caption = 'clvNotifications'
    ExplicitWidth = 712
    ExplicitHeight = 324
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 331
    Width = 722
    Height = 31
    Align = alBottom
    AutoSize = True
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 330
    ExplicitWidth = 718
    object pnlBottomRight: TPanel
      Left = 401
      Top = 0
      Width = 321
      Height = 31
      Align = alRight
      AutoSize = True
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 397
      object btnClose: TButton
        AlignWithMargins = True
        Left = 245
        Top = 3
        Width = 73
        Height = 25
        Action = acClose
        Align = alRight
        TabOrder = 3
      end
      object btnDefer: TButton
        AlignWithMargins = True
        Left = 165
        Top = 3
        Width = 74
        Height = 25
        Action = acDefer
        Align = alRight
        TabOrder = 2
      end
      object btnProcess: TButton
        AlignWithMargins = True
        Left = 84
        Top = 3
        Width = 75
        Height = 25
        Action = acProcess
        Align = alRight
        TabOrder = 1
      end
      object btnDetails: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 75
        Height = 25
        Action = acDetails
        Align = alRight
        TabOrder = 0
      end
    end
    object pnlBottomLeft: TPanel
      Left = 0
      Top = 0
      Width = 401
      Height = 31
      Align = alLeft
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 0
      object lblFrom: TLabel
        Left = 3
        Top = 9
        Width = 26
        Height = 13
        Alignment = taRightJustify
        Caption = 'From:'
      end
      object lblTo: TLabel
        Left = 162
        Top = 9
        Width = 16
        Height = 13
        Alignment = taRightJustify
        Caption = 'To:'
      end
      object ordbFrom: TORDateBox
        Left = 32
        Top = 6
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'ordbFrom'
        OnChange = ordbFromChange
        DateOnly = True
        RequireTime = False
        Caption = ''
      end
      object ordbTo: TORDateBox
        Left = 181
        Top = 6
        Width = 121
        Height = 21
        TabOrder = 2
        Text = 'ordbTo'
        OnChange = ordbToChange
        DateOnly = True
        RequireTime = False
        Caption = ''
      end
      object btnUpdate: TButton
        AlignWithMargins = True
        Left = 320
        Top = 3
        Width = 78
        Height = 25
        Align = alRight
        Caption = '&Update List'
        TabOrder = 4
        OnClick = btnUpdateClick
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 16
    Top = 16
    Data = (
      (
        'Component = clvNotifications'
        'Status = stsDefault')
      (
        'Component = frmViewNotifications'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlBottomRight'
        'Status = stsDefault')
      (
        'Component = btnClose'
        'Status = stsDefault')
      (
        'Component = btnDefer'
        'Status = stsDefault')
      (
        'Component = btnProcess'
        'Status = stsDefault')
      (
        'Component = btnDetails'
        'Status = stsDefault')
      (
        'Component = pnlBottomLeft'
        'Status = stsDefault')
      (
        'Component = ordbFrom'
        'Label = lblFrom'
        'Status = stsOK')
      (
        'Component = ordbTo'
        'Label = lblTo'
        'Status = stsOK')
      (
        'Component = btnUpdate'
        'Status = stsDefault'))
  end
  object acList: TActionList
    OnUpdate = acListUpdate
    Left = 80
    Top = 16
    object acProcess: TAction
      Caption = '&Process'
      OnExecute = acProcessExecute
    end
    object acDefer: TAction
      Caption = '&Defer'
      OnExecute = acDeferExecute
    end
    object acClose: TAction
      Caption = '&Close'
      OnExecute = acCloseExecute
    end
    object acClearList: TAction
      Caption = 'acClearList'
      OnExecute = acClearListExecute
    end
    object acSortByColumn: TAction
      Caption = 'acSortByColumn'
      OnExecute = acSortByColumnExecute
    end
    object acDetails: TAction
      Caption = 'Det&ails'
      OnExecute = acDetailsExecute
    end
  end
end
