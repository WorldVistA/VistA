inherited frmTemplateFields: TfrmTemplateFields
  Left = 212
  Top = 155
  Caption = 'Insert Template Field'
  ClientHeight = 319
  ClientWidth = 450
  FormStyle = fsStayOnTop
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 458
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel [0]
    Left = 0
    Top = 226
    Width = 450
    Height = 28
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      450
      28)
    object btnCancel: TButton
      Left = 371
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = '&Done'
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnInsert: TButton
      Left = 291
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Insert Field'
      Default = True
      ModalResult = 4
      TabOrder = 2
      OnClick = btnInsertClick
    end
    object btnPreview: TButton
      Left = 211
      Top = 4
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '&Preview'
      Enabled = False
      TabOrder = 1
      OnClick = btnPreviewClick
    end
    object lblReq: TVA508StaticText
      Name = 'lblReq'
      AlignWithMargins = True
      Left = 10
      Top = 12
      Width = 132
      Height = 15
      Alignment = taLeftJustify
      Anchors = [akLeft, akBottom]
      Caption = '* Indicates a Required Field'
      TabOrder = 0
      ShowAccelChar = True
    end
  end
  object cboObjects: TORComboBox [1]
    Left = 0
    Top = 0
    Width = 450
    Height = 226
    Style = orcsSimple
    Align = alClient
    AutoSelect = True
    Caption = 'Template Field'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = True
    LongList = True
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2,3'
    HideSynonyms = True
    Sorted = False
    SynonymChars = '<Inactive>'
    TabPositions = '50,60,70,80,90'
    TabOrder = 0
    TabStop = True
    OnChange = cboObjectsChange
    OnDblClick = cboObjectsDblClick
    OnNeedData = cboObjectsNeedData
    CharsNeedMatch = 1
  end
  object pnlBottomSR: TPanel [2]
    Left = 0
    Top = 254
    Width = 450
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblSRCont2: TVA508StaticText
      Name = 'lblSRCont2'
      AlignWithMargins = True
      Left = 24
      Top = 45
      Width = 423
      Height = 15
      Margins.Left = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taLeftJustify
      Caption = 
        'speaking text that follows the template field, when the field re' +
        'ceives focus.'
      TabOrder = 3
      ShowAccelChar = True
    end
    object lblSRCont1: TVA508StaticText
      Name = 'lblSRCont1'
      AlignWithMargins = True
      Left = 10
      Top = 30
      Width = 437
      Height = 15
      Margins.Left = 10
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taLeftJustify
      Caption = 
        '*** Place this code after a template field to allow the screen r' +
        'eader to continue'
      TabOrder = 2
      ShowAccelChar = True
    end
    object lblSRStop: TVA508StaticText
      Name = 'lblSRStop'
      AlignWithMargins = True
      Left = 10
      Top = 15
      Width = 437
      Height = 15
      Margins.Left = 10
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taLeftJustify
      Caption = '** Screen reader will stop speaking at this point'
      TabOrder = 1
      ShowAccelChar = True
    end
    object pnlSRIntro: TPanel
      Left = 0
      Top = 0
      Width = 450
      Height = 15
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lblSRIntro1: TVA508StaticText
        Name = 'lblSRIntro1'
        AlignWithMargins = True
        Left = 10
        Top = 0
        Width = 127
        Height = 15
        Margins.Left = 10
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        Alignment = taLeftJustify
        Caption = 'Screen Reader Codes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ShowAccelChar = True
      end
      object lblSRIntro2: TVA508StaticText
        Name = 'lblSRIntro2'
        Left = 140
        Top = 0
        Width = 310
        Height = 15
        Align = alClient
        Alignment = taLeftJustify
        Caption = '(make templates user friendly for those using screen readers)'
        TabOrder = 1
        ShowAccelChar = True
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnInsert'
        'Status = stsDefault')
      (
        'Component = btnPreview'
        'Status = stsDefault')
      (
        'Component = cboObjects'
        'Status = stsDefault')
      (
        'Component = frmTemplateFields'
        'Status = stsDefault')
      (
        'Component = lblReq'
        'Status = stsDefault')
      (
        'Component = pnlBottomSR'
        'Status = stsDefault')
      (
        'Component = lblSRCont2'
        'Status = stsDefault')
      (
        'Component = lblSRCont1'
        'Status = stsDefault')
      (
        'Component = lblSRStop'
        'Status = stsDefault')
      (
        'Component = pnlSRIntro'
        'Status = stsDefault')
      (
        'Component = lblSRIntro1'
        'Status = stsDefault')
      (
        'Component = lblSRIntro2'
        'Status = stsDefault'))
  end
end
