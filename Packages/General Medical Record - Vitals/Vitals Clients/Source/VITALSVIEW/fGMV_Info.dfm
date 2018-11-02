object frmGMV_Info: TfrmGMV_Info
  Left = 370
  Top = 223
  Width = 666
  Height = 472
  Caption = 'Vitals Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  DesignSize = (
    658
    445)
  PixelsPerInch = 96
  TextHeight = 13
  object reReport: TRichEdit
    Left = 8
    Top = 8
    Width = 644
    Height = 388
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'VITALS LITE QUICK REFERENCE GUIDE'
      
        'The Vitals application is designed to collect the vital signs an' +
        'd measurements that are associated with a patient'#39's hospital sta' +
        'y or '
      
        'outpatient clinic visit, and store the data in the patient'#39's ele' +
        'ctronic medical record. A limited set of Vitals functionality is' +
        ' accessible '
      
        'through the CPRS cover sheet, provided by a DLL (Dynamic Link Li' +
        'brary) from Vitals. '
      'These topics are provided as a quick reference for Vitals Lite: '
      '"'#9'View Vitals Data'
      '"'#9'Enter Vitals Data'
      '"'#9'Correct Vitals Data '
      
        'Please refer to the Vitals 5.0 User Manual in the VistA Document' +
        'ation Library for more detailed information.'
      ''
      'VIEWING VITALS DATA'
      
        '1'#9'Select a patient in the CPRS Cover Sheet window, then click in' +
        'side the Vitals section. The Vitals Lite View opens, '
      
        'displaying existing vitals data values in a graph (top) and a gr' +
        'id (bottom). The time scale runs from left to right.'
      
        '2'#9'Select a date range to narrow down the amount of data to be di' +
        'splayed:'
      
        '"'#9'Click Date Range to select a customized date range, then set "' +
        'Start with" and "Go to" dates, or'
      
        '"'#9'Click a predetermined time frame from the box on the left of t' +
        'he graph. Today displays today'#39's data only, T-1 displays data '
      
        'for today plus one previous day, T-7 displays data for today plu' +
        's seven previous days, and so on. All Results displays all avail' +
        'able '
      'data for the selected patient. '
      '3'#9'Select a type of graph:'
      
        '"'#9'Click a vital type row heading in the grid (for example, Temp ' +
        'or B/P), or'
      
        '"'#9'Select a graph type from the drop-down list at the bottom left' +
        ' corner of the graph. '
      
        '4'#9'To print the graph as it appears on screen, right-click the gr' +
        'aph and select Print Graph. A standard Print dialog box opens. '
      'Select a printer and click OK. '
      ''
      'ENTERING VITALS DATA'
      
        '1'#9'Select a patient in the CPRS Cover Sheet window, then click in' +
        'side the Vitals section. The Vitals Lite View opens. '
      
        '2'#9'Click the Enter Vitals button above the graph. The vitals inpu' +
        't window opens. '
      
        '3'#9'The selected patient'#39's Name, SSN, and DOB are displayed at the' +
        ' top of the window. To select a different location, '
      'date/time, or template for this set of vitals:'
      
        'Click the Date/Time button to select a different date or differe' +
        'nt time.'
      
        'Click the Hospital Location button to select a different locatio' +
        'n.'
      
        'Click the Exp. View button to display or hide the Templates pane' +
        'l. To select a template, click any template name in the list. If' +
        ' no '
      
        'template has been selected, the default System template will be ' +
        'used.'
      
        'Click the Latest V. button to display or hide the latest vitals ' +
        'on file for this patient.'
      
        '4'#9'Type a value for each vital sign or measurement, then press En' +
        'ter to move to the next field. If you would like to select a '
      
        'different qualifier for a vital sign, click the down-arrow butto' +
        'n to display a list of its qualifiers. '
      
        '5'#9'Click Save. To enter additional vitals for this patient using ' +
        'a different date, time, and/or location, repeat steps 4-6. '
      
        'To discard the vitals you have entered, click Cancel. You will b' +
        'e prompted to confirm the cancellation.'
      
        'When you are finished entering vitals for this patient, click Sa' +
        've and Exit. The Vitals Input window closes.'
      ''
      'CORRECTING VITALS DATA'
      
        'An incorrect vitals data value cannot be deleted once it has bee' +
        'n saved - it must be marked "Entered in Error" and replaced with' +
        ' '
      
        'corrected data. Any data value that has been marked "in error" w' +
        'ill continue to be stored in the Vitals database, but will be re' +
        'moved '
      'from the patient'#39's data grid and graph.'
      
        '1'#9'In the Vitals Lite window, locate the data value(s) to be corr' +
        'ected, then click the Date/Time column heading. The '
      
        'Entered in Error window opens, showing all existing data values ' +
        'for the selected date.  '
      
        '2'#9'Click an incorrect value to select it, or use CTRL+ click to s' +
        'elect multiple values. In the Reason section, click the reason '
      
        'for the incorrect entry, then click the Mark as Entered in Error' +
        ' button. A confirmation screen opens. '
      
        '3'#9'Click Yes to confirm that the selected value has been entered ' +
        'in error, or click No to select a different value. All values '
      
        'that have been marked "Entered in Error" are removed from the da' +
        'ta grid and graph. '
      
        '4'#9'If necessary, enter new vitals data for this patient to replac' +
        'e the incorrect values.'
      ''
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object BitBtn1: TBitBtn
    Left = 571
    Top = 407
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Button1: TButton
    Left = 83
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Save &As...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 408
    Width = 75
    Height = 25
    Caption = '&Print'
    TabOrder = 3
    OnClick = Button2Click
  end
  object SaveDialog1: TSaveDialog
    Left = 32
    Top = 32
  end
  object PrintDialog1: TPrintDialog
    Left = 40
    Top = 64
  end
end
