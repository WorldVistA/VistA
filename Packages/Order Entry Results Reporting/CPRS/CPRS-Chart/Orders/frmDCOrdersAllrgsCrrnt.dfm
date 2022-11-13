inherited frmDCOrdersAllrgsCrrnt: TfrmDCOrdersAllrgsCrrnt
  Left = 316
  Top = 226
  Caption = 'List of allergies currently recorded for the patient:'
  ClientHeight = 315
  ClientWidth = 466
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 474
  ExplicitHeight = 342
  PixelsPerInch = 96
  TextHeight = 16
  object lblAllergies: TLabel [0]
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 460
    Height = 16
    Align = alTop
    Caption = 'Allergy List:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 82
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 22
    Width = 466
    Height = 228
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lstAlleries: TCaptionListBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 460
      Height = 222
      Cursor = crHandPoint
      TabStop = False
      Style = lbOwnerDrawVariable
      Align = alClient
      BevelWidth = 3
      ExtendedSelect = False
      ItemHeight = 13
      TabOrder = 0
      StyleElements = [seFont]
      OnDrawItem = lstAlleriesDrawItem
      OnMeasureItem = lstAlleriesMeasureItem
      Caption = 'The following orders will be discontinued '
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 250
    Width = 466
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      466
      65)
    object lblVerifyAllrgyDisc: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 46
      Width = 460
      Height = 16
      Align = alBottom
      Alignment = taCenter
      Caption = 
        'Do you want to enter the allergy/adverse drug reaction for the m' +
        'edication being discontinued?'#9#39
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
      ExplicitTop = 49
      ExplicitWidth = 563
    end
    object cmdYes: TButton
      Left = 174
      Top = 36
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = '&Yes'
      Default = True
      ModalResult = 6
      TabOrder = 0
    end
    object cmdNo: TButton
      Left = 252
      Top = 36
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&No'
      ModalResult = 7
      TabOrder = 1
    end
    object mnoVerifyAllrgyDisc: TMemo
      Left = 0
      Top = 0
      Width = 466
      Height = 34
      Align = alTop
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        
          '                              Do you want to enter the allergy/a' +
          'dverse drug reaction'
        
          '                              for the medication being discontin' +
          'ued?')
      TabOrder = 2
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 328
    Top = 40
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = lstAlleries'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = cmdYes'
        'Status = stsDefault')
      (
        'Component = cmdNo'
        'Status = stsDefault')
      (
        'Component = frmDCOrdersAllrgsCrrnt'
        'Status = stsDefault')
      (
        'Component = mnoVerifyAllrgyDisc'
        'Status = stsDefault'))
  end
end
