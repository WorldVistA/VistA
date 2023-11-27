object fraDrawers: TfraDrawers
  Left = 0
  Top = 0
  Width = 223
  Height = 362
  Constraints.MinWidth = 161
  TabOrder = 0
  object pnlTemplate: TPanel
    Left = 0
    Top = 0
    Width = 223
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      223
      105)
    object pnlTemplates: TPanel
      Left = 0
      Top = 22
      Width = 223
      Height = 83
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object tvTemplates: TORTreeView
        Left = 0
        Top = 41
        Width = 223
        Height = 42
        Align = alClient
        DragMode = dmAutomatic
        HideSelection = False
        Images = dmodShared.imgTemplates
        Indent = 19
        ParentShowHint = False
        PopupMenu = popTemplates
        ReadOnly = True
        RightClickSelect = True
        ShowHint = False
        TabOrder = 0
        OnClick = tvTemplatesClick
        OnCollapsing = tvTemplatesCollapsing
        OnDblClick = tvTemplatesDblClick
        OnExpanding = tvTemplatesExpanding
        OnGetImageIndex = tvTemplatesGetImageIndex
        OnGetSelectedIndex = tvTemplatesGetSelectedIndex
        OnKeyDown = tvTemplatesKeyDown
        OnKeyUp = tvTemplatesKeyUp
        Caption = 'Templates'
        NodePiece = 2
        OnDragging = tvTemplatesDragging
      end
      object pnlTemplateSearch: TPanel
        Left = 0
        Top = 0
        Width = 223
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        DesignSize = (
          223
          41)
        object edtSearch: TCaptionEdit
          Left = 0
          Top = 1
          Width = 168
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = edtSearchChange
          OnEnter = edtSearchEnter
          OnExit = edtSearchExit
          Caption = 'Text to find'
        end
        object btnFind: TORAlignButton
          Left = 168
          Top = 1
          Width = 55
          Height = 21
          Action = acFind
          Anchors = [akTop, akRight]
          ParentShowHint = False
          PopupMenu = popTemplates
          ShowHint = True
          TabOrder = 2
        end
        object cbWholeWords: TCheckBox
          Left = 89
          Top = 22
          Width = 109
          Height = 17
          Caption = 'Whole Words Only'
          TabOrder = 3
          OnClick = cbFindOptionClick
        end
        object cbMatchCase: TCheckBox
          Left = 4
          Top = 22
          Width = 80
          Height = 17
          Caption = 'Match Case'
          TabOrder = 4
          OnClick = cbFindOptionClick
        end
      end
    end
    object btnTemplate: TBitBtn
      Left = 0
      Top = 1
      Width = 223
      Height = 22
      Action = acTemplates
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Templates'
      Glyph.Data = {
        3E010000424D3E010000000000007600000028000000280000000A0000000100
        040000000000C800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888888888888888888887788888888FF88888888FF88888888FF
        88888888F7888888887F888888887F888888880F8888888F877888888778F888
        888788F888888078F888888F887888888788F888888788F888888078F88888F8
        8877888877888F888878888F888807888F8888F88887888878888F888878888F
        888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
        777777F887777777F880000000F8888888888888888888888888888888888888
        8888}
      NumGlyphs = 4
      PopupMenu = popTemplates
      TabOrder = 1
    end
  end
  object pnlEncounter: TPanel
    Left = 0
    Top = 105
    Width = 223
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      223
      81)
    object btnEncounter: TBitBtn
      Left = 0
      Top = 1
      Width = 223
      Height = 22
      Action = acEncounter
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Encounter'
      Glyph.Data = {
        3E010000424D3E010000000000007600000028000000280000000A0000000100
        040000000000C800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888888888888888888887788888888FF88888888FF88888888FF
        88888888F7888888887F888888887F888888880F8888888F877888888778F888
        888788F888888078F888888F887888888788F888888788F888888078F88888F8
        8877888877888F888878888F888807888F8888F88887888878888F888878888F
        888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
        777777F887777777F880000000F8888888888888888888888888888888888888
        8888}
      NumGlyphs = 4
      TabOrder = 0
    end
    object pnlEncounters: TPanel
      Left = 0
      Top = 24
      Width = 223
      Height = 57
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lbEncounter: TORListBox
        Left = 0
        Top = 0
        Width = 223
        Height = 57
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          'Encounter')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        Caption = 'Encounter'
        ItemTipColor = clWindow
        LongList = False
      end
    end
  end
  object pnlReminder: TPanel
    Left = 0
    Top = 186
    Width = 223
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      223
      81)
    object btnReminder: TBitBtn
      Left = 0
      Top = 1
      Width = 223
      Height = 22
      Action = acReminders
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Reminders'
      Glyph.Data = {
        3E010000424D3E010000000000007600000028000000280000000A0000000100
        040000000000C800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888888888888888888887788888888FF88888888FF88888888FF
        88888888F7888888887F888888887F888888880F8888888F877888888778F888
        888788F888888078F888888F887888888788F888888788F888888078F88888F8
        8877888877888F888878888F888807888F8888F88887888878888F888878888F
        888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
        777777F887777777F880000000F8888888888888888888888888888888888888
        8888}
      NumGlyphs = 4
      TabOrder = 0
    end
    object pnlReminders: TPanel
      Left = 0
      Top = 24
      Width = 223
      Height = 57
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object tvReminders: TORTreeView
        Left = 0
        Top = 0
        Width = 223
        Height = 57
        HelpContext = 11300
        Align = alClient
        HideSelection = False
        Images = dmodShared.imgReminders
        Indent = 23
        ReadOnly = True
        RightClickSelect = True
        StateImages = dmodShared.imgReminders
        TabOrder = 0
        OnCollapsed = tvRemindersCurListChanged
        OnExpanded = tvRemindersCurListChanged
        OnKeyDown = tvRemindersKeyDown
        OnMouseUp = tvRemindersMouseUp
        Caption = 'Reminders'
        NodePiece = 0
        OnNodeCaptioning = tvRemindersNodeCaptioning
      end
    end
  end
  object pnlOrder: TPanel
    Left = 0
    Top = 267
    Width = 223
    Height = 91
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      223
      91)
    object btnOrder: TBitBtn
      Left = 0
      Top = 1
      Width = 223
      Height = 22
      Action = acOrders
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Orders'
      Glyph.Data = {
        3E010000424D3E010000000000007600000028000000280000000A0000000100
        040000000000C800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888888888888888888887788888888FF88888888FF88888888FF
        88888888F7888888887F888888887F888888880F8888888F877888888778F888
        888788F888888078F888888F887888888788F888888788F888888078F88888F8
        8877888877888F888878888F888807888F8888F88887888878888F888878888F
        888807888F888F8888877887788888F887888888F880788888F88FFFFFFF7887
        777777F887777777F880000000F8888888888888888888888888888888888888
        8888}
      NumGlyphs = 4
      TabOrder = 0
    end
    object pnlOrders: TPanel
      Left = 0
      Top = 24
      Width = 223
      Height = 67
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lbOrders: TORListBox
        Left = 0
        Top = 0
        Width = 223
        Height = 67
        Align = alClient
        ItemHeight = 13
        Items.Strings = (
          'Orders')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        Caption = 'Orders'
        ItemTipColor = clWindow
        LongList = False
      end
    end
  end
  object popTemplates: TPopupMenu
    OnPopup = popTemplatesPopup
    Left = 24
    Top = 70
    object mnuCopyTemplate: TMenuItem
      Action = acCopyTemplateText
    end
    object mnuInsertTemplate: TMenuItem
      Action = acInsertTemplate
    end
    object mnuPreviewTemplate: TMenuItem
      Action = acPreviewTemplate
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuGotoDefault: TMenuItem
      Action = acGotoDefault
    end
    object mnuDefault: TMenuItem
      Action = acMarkDefault
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuViewNotes: TMenuItem
      Action = acViewTemplateNotes
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuFindTemplates: TMenuItem
      Action = acFindTemplate
    end
    object mnuCollapseTree: TMenuItem
      Action = acCollapseTree
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuEditTemplates: TMenuItem
      Action = acEditTemplates
    end
    object mnuNewTemplate: TMenuItem
      Action = acNewTemplate
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuViewTemplateIconLegend: TMenuItem
      Action = acIconLegend
    end
  end
  object al: TActionList
    Left = 72
    Top = 70
    object acTemplates: TAction
      Category = 'Buttons'
      Caption = 'Templates'
      OnExecute = acTemplatesExecute
      OnUpdate = acTemplatesUpdate
    end
    object acEncounter: TAction
      Category = 'Buttons'
      Caption = 'Encounter'
      OnExecute = acEncounterExecute
      OnUpdate = acEncounterUpdate
    end
    object acReminders: TAction
      Category = 'Buttons'
      Caption = 'Reminders'
      OnExecute = acRemindersExecute
      OnUpdate = acRemindersUpdate
    end
    object acOrders: TAction
      Category = 'Buttons'
      Caption = 'Orders'
      OnExecute = acOrdersExecute
      OnUpdate = acOrdersUpdate
    end
    object acFind: TAction
      Category = 'Buttons'
      Caption = 'Find'
      OnExecute = acFindExecute
      OnUpdate = acFindUpdate
    end
    object acCopyTemplateText: TAction
      Category = 'TemplateMenu'
      Caption = 'Copy Template Text'
      ShortCut = 16451
      OnExecute = acCopyTemplateTextExecute
    end
    object acInsertTemplate: TAction
      Category = 'TemplateMenu'
      Caption = '&Insert Template'
      ShortCut = 16429
      OnExecute = acInsertTemplateExecute
    end
    object acPreviewTemplate: TAction
      Category = 'TemplateMenu'
      Caption = 'Previe&w/Print Template'
      ShortCut = 16471
      OnExecute = acPreviewTemplateExecute
    end
    object acGotoDefault: TAction
      Category = 'TemplateMenu'
      Caption = '&Goto Default'
      ShortCut = 16455
      OnExecute = acGotoDefaultExecute
    end
    object acMarkDefault: TAction
      Category = 'TemplateMenu'
      Caption = '&Mark as Default'
      ShortCut = 16416
      OnExecute = acMarkDefaultExecute
    end
    object acViewTemplateNotes: TAction
      Category = 'TemplateMenu'
      Caption = '&View Template Notes'
      ShortCut = 16470
      OnExecute = acViewTemplateNotesExecute
    end
    object acFindTemplate: TAction
      Category = 'TemplateMenu'
      Caption = '&Find Templates'
      ShortCut = 16454
      OnExecute = acFindTemplateExecute
      OnUpdate = acFindTemplateUpdate
    end
    object acCollapseTree: TAction
      Category = 'TemplateMenu'
      Caption = '&Collapse Tree'
      OnExecute = acCollapseTreeExecute
    end
    object acEditTemplates: TAction
      Category = 'TemplateMenu'
      Caption = '&Edit Templates'
      OnExecute = acEditTemplatesExecute
    end
    object acNewTemplate: TAction
      Category = 'TemplateMenu'
      Caption = 'Create &New Template'
      OnExecute = acNewTemplateExecute
    end
    object acIconLegend: TAction
      Category = 'TemplateMenu'
      Caption = 'Template Icon Legend'
      OnExecute = acIconLegendExecute
    end
  end
end
