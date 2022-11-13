object frmViewNotifications: TfrmViewNotifications
  Left = 0
  Top = 0
  Caption = 'All Current Notifications for Patient'
  ClientHeight = 424
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 17
  object clvNotifications: TCaptionListView
    AlignWithMargins = True
    Left = 6
    Top = 6
    Width = 789
    Height = 355
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    Columns = <
      item
        Caption = 'My To Do'
        Width = 63
      end
      item
        Caption = 'Info'
        Width = 63
      end
      item
        Caption = 'Location'
        Width = 80
      end
      item
        Caption = 'Urgency'
        Width = 80
      end
      item
        Caption = 'Alert Date/Time'
        Width = 120
      end
      item
        Caption = 'Message'
        Width = 63
      end
      item
        Caption = 'Ordering Provider'
        Width = 63
      end
      item
        Caption = 'Forwarded By/When'
        Width = 63
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
    HideTinyColumns = False
    ExplicitWidth = 941
    ExplicitHeight = 446
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 367
    Width = 801
    Height = 57
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = -6
    ExplicitTop = 370
    ExplicitWidth = 793
    DesignSize = (
      801
      57)
    object lblFrom: TLabel
      Left = 12
      Top = 18
      Width = 37
      Height = 17
      Alignment = taRightJustify
      Caption = 'From:'
    end
    object lblTo: TLabel
      Left = 197
      Top = 18
      Width = 21
      Height = 17
      Alignment = taRightJustify
      Caption = 'To:'
    end
    object btnClose: TButton
      Left = 721
      Top = 13
      Width = 73
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acClose
      Anchors = [akRight, akBottom]
      TabOrder = 0
      ExplicitLeft = 873
    end
    object btnDefer: TButton
      Left = 638
      Top = 13
      Width = 74
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acDefer
      Anchors = [akRight, akBottom]
      TabOrder = 1
      ExplicitLeft = 790
    end
    object btnProcess: TButton
      Left = 555
      Top = 13
      Width = 75
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Action = acProcess
      Anchors = [akRight, akBottom]
      TabOrder = 2
      ExplicitLeft = 592
    end
    object ordbFrom: TORDateBox
      Left = 55
      Top = 16
      Width = 121
      Height = 25
      TabOrder = 3
      Text = 'ordbFrom'
      OnChange = ordbFromChange
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object ordbTo: TORDateBox
      Left = 223
      Top = 16
      Width = 121
      Height = 25
      TabOrder = 4
      Text = 'ordbTo'
      OnChange = ordbToChange
      DateOnly = True
      RequireTime = False
      Caption = ''
    end
    object btnUpdate: TButton
      Left = 351
      Top = 13
      Width = 100
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      Caption = '&Update List'
      TabOrder = 7
      OnClick = btnUpdateClick
    end
    object btnDetails: TButton
      Left = 472
      Top = 13
      Width = 75
      Height = 30
      Action = acDetails
      Anchors = [akRight, akBottom]
      TabOrder = 8
      ExplicitLeft = 509
    end
  end
  object acList: TActionList
    OnUpdate = acListUpdate
    Left = 24
    Top = 48
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
