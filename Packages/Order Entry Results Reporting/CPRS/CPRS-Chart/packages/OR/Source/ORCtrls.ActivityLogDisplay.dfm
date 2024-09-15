object frmActivityLogDisplay: TfrmActivityLogDisplay
  Left = 0
  Top = 0
  Caption = 'Activity Log'
  ClientHeight = 564
  ClientWidth = 846
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnClose = ORFormClose
  OnCreate = ORFormCreate
  OnDestroy = ORFormDestroy
  OnShow = ORFormShow
  OldCreateOrder = False
  TextHeight = 13
  object splMain: TSplitter
    Left = 0
    Top = 279
    Width = 846
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 40
    ExplicitWidth = 240
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 282
    Width = 846
    Height = 282
    Align = alBottom
    Caption = 'pnlBottom'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 281
    ExplicitWidth = 842
    object pnlMessages: TPanel
      Left = 1
      Top = 1
      Width = 844
      Height = 40
      Align = alTop
      Caption = 'pnlMessages'
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 840
      object cbMessageLog: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 171
        Height = 32
        Align = alLeft
        Caption = 'Monitor Windows &Message Log'
        TabOrder = 0
        OnClick = cbMessageLogClick
      end
      object btnClearMessages: TButton
        AlignWithMargins = True
        Left = 680
        Top = 4
        Width = 160
        Height = 32
        Align = alRight
        Caption = 'Clear Windows Message Log'
        TabOrder = 1
        ExplicitLeft = 676
      end
      object cbMouse: TCheckBox
        AlignWithMargins = True
        Left = 244
        Top = 4
        Width = 105
        Height = 32
        Align = alLeft
        Caption = 'Mouse Messages'
        TabOrder = 2
      end
      object cbPaint: TCheckBox
        AlignWithMargins = True
        Left = 355
        Top = 4
        Width = 97
        Height = 32
        Align = alLeft
        Caption = 'Paint Messages'
        TabOrder = 3
      end
      object cbTimer: TCheckBox
        AlignWithMargins = True
        Left = 458
        Top = 4
        Width = 99
        Height = 32
        Align = alLeft
        Caption = 'Timer Messages'
        TabOrder = 4
      end
      object cbPauseMessages: TCheckBox
        Left = 178
        Top = 1
        Width = 63
        Height = 38
        Align = alLeft
        Caption = 'Pause'
        TabOrder = 5
      end
    end
    object reMessages: TRichEdit
      Left = 1
      Top = 41
      Width = 844
      Height = 240
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      Visible = False
      WordWrap = False
      ExplicitWidth = 840
    end
  end
  object pnlActivities: TPanel
    Left = 0
    Top = 0
    Width = 846
    Height = 40
    Align = alTop
    Caption = 'pnlActivities'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 842
    object cbActivityLog: TCheckBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 115
      Height = 32
      Align = alLeft
      Caption = 'Monitor &Activity Log'
      TabOrder = 0
      OnClick = cbActivityLogClick
    end
    object btnClearActivities: TButton
      AlignWithMargins = True
      Left = 720
      Top = 4
      Width = 122
      Height = 32
      Align = alRight
      Caption = 'Clear Activity Log'
      TabOrder = 1
      ExplicitLeft = 716
    end
    object cbPauseActivity: TCheckBox
      Left = 122
      Top = 1
      Width = 97
      Height = 38
      Align = alLeft
      Caption = 'Pause'
      TabOrder = 2
    end
  end
  object reActivities: TRichEdit
    Left = 0
    Top = 40
    Width = 846
    Height = 239
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
    ExplicitWidth = 842
    ExplicitHeight = 238
  end
end
