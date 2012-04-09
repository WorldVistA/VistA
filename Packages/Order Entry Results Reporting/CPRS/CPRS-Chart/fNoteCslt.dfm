inherited frmNoteConsult: TfrmNoteConsult
  Left = 162
  Top = 178
  Caption = 'Consult Request Selection'
  ClientWidth = 547
  Position = poScreenCenter
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel [0]
    Left = 8
    Top = 44
    Width = 104
    Height = 13
    Caption = 'Consult Request Date'
  end
  object Label4: TLabel [1]
    Left = 136
    Top = 44
    Width = 36
    Height = 13
    Caption = 'Service'
  end
  object Label5: TLabel [2]
    Left = 268
    Top = 46
    Width = 49
    Height = 13
    Caption = 'Procedure'
  end
  object Label6: TLabel [3]
    Left = 423
    Top = 45
    Width = 30
    Height = 13
    Caption = 'Status'
  end
  object Label7: TLabel [4]
    Left = 488
    Top = 44
    Width = 38
    Height = 13
    Caption = '# Notes'
  end
  object Label1: TStaticText [5]
    Left = 8
    Top = 8
    Width = 313
    Height = 17
    Caption = 
      'This progress note title must be associated with a consult reque' +
      'st.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Label2: TStaticText [6]
    Left = 8
    Top = 22
    Width = 335
    Height = 17
    Caption = 
      'Select one of the following or press cancel and choose a differe' +
      'nt title.'
    TabOrder = 4
  end
  object lstRequests: TORListBox [7]
    Left = 8
    Top = 58
    Width = 531
    Height = 171
    ItemHeight = 13
    Items.Strings = (
      'a^b^c^d^e^f')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = lstRequestsClick
    Caption = 'Associated Consult Request'
    ItemTipColor = clWindow
    LongList = False
    Pieces = '2,3,4,5,6'
    TabPositions = '21,43,69,83'
  end
  object cmdOK: TButton [8]
    Left = 378
    Top = 242
    Width = 72
    Height = 21
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 1
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [9]
    Left = 466
    Top = 242
    Width = 72
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = cmdCancelClick
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = Label2'
        'Status = stsDefault')
      (
        'Component = lstRequests'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmNoteConsult'
        'Status = stsDefault'))
  end
end
