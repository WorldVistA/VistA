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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
    Visible = False
    ExplicitTop = 40
    ExplicitWidth = 240
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 282
    Width = 846
    Height = 282
    Align = alBottom
    ShowCaption = False
    TabOrder = 0
    Visible = False
    ExplicitTop = 281
    ExplicitWidth = 842
    object pnlMessages: TPanel
      Left = 1
      Top = 1
      Width = 844
      Height = 31
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      object chkMessageLog: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 171
        Height = 25
        Align = alLeft
        Caption = 'Monitor Windows &Message Log'
        TabOrder = 0
        ExplicitLeft = 4
        ExplicitTop = 4
        ExplicitHeight = 32
      end
      object btnClearMessages: TButton
        AlignWithMargins = True
        Left = 681
        Top = 3
        Width = 160
        Height = 25
        Align = alRight
        Caption = 'Clear Windows Message Log'
        TabOrder = 5
        ExplicitLeft = 676
        ExplicitTop = 4
        ExplicitHeight = 32
      end
      object chkMouse: TCheckBox
        AlignWithMargins = True
        Left = 249
        Top = 3
        Width = 105
        Height = 25
        Align = alLeft
        Caption = 'Mouse Messages'
        TabOrder = 2
        ExplicitLeft = 244
        ExplicitTop = 4
        ExplicitHeight = 32
      end
      object chkPaint: TCheckBox
        AlignWithMargins = True
        Left = 360
        Top = 3
        Width = 97
        Height = 25
        Align = alLeft
        Caption = 'Paint Messages'
        TabOrder = 3
        ExplicitLeft = 355
        ExplicitTop = 4
        ExplicitHeight = 32
      end
      object chkTimer: TCheckBox
        AlignWithMargins = True
        Left = 463
        Top = 3
        Width = 99
        Height = 25
        Align = alLeft
        Caption = 'Timer Messages'
        TabOrder = 4
        ExplicitLeft = 464
        ExplicitTop = 5
        ExplicitHeight = 26
      end
      object chkPauseMessages: TCheckBox
        AlignWithMargins = True
        Left = 180
        Top = 3
        Width = 63
        Height = 25
        Align = alLeft
        Caption = 'Pause'
        TabOrder = 1
        ExplicitLeft = 178
        ExplicitTop = 1
        ExplicitHeight = 38
      end
    end
    object reMessages: TRichEdit
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 838
      Height = 243
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
      Visible = False
      WordWrap = False
      ExplicitLeft = 1
      ExplicitTop = 41
      ExplicitWidth = 840
      ExplicitHeight = 240
    end
  end
  object pnlActivities: TPanel
    Left = 0
    Top = 0
    Width = 846
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object chkActivityLog: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 115
      Height = 25
      Align = alLeft
      Caption = 'Monitor &Activity Log'
      TabOrder = 0
      Visible = False
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitHeight = 32
    end
    object btnClearActivities: TButton
      AlignWithMargins = True
      Left = 721
      Top = 3
      Width = 122
      Height = 25
      Align = alRight
      Caption = 'Clear Activity Log'
      TabOrder = 3
      Visible = False
      ExplicitLeft = 716
      ExplicitTop = 4
      ExplicitHeight = 32
    end
    object chkPauseActivity: TCheckBox
      AlignWithMargins = True
      Left = 124
      Top = 3
      Width = 51
      Height = 25
      Align = alLeft
      Caption = 'Pause'
      TabOrder = 1
      OnClick = chkPauseActivityClick
    end
    object chkWrap: TCheckBox
      AlignWithMargins = True
      Left = 181
      Top = 3
      Width = 117
      Height = 25
      Align = alLeft
      Caption = 'Wrap Long Lines'
      TabOrder = 2
      OnClick = chkWrapClick
      ExplicitLeft = 238
    end
  end
  object reActivities: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 34
    Width = 840
    Height = 242
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
end
