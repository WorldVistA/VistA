unit uGMV_Const;

interface
uses
  Messages
  , uGMV_GlobalVars
  , uGMV_VitalTypes
  , Graphics
  ;

const

  DISPLAYCOLORS: array[0..15] of TColor = (
    clBlack,
    clMaroon,
    clGreen,
    clOlive,
    clNavy,
    clPurple,
    clTeal,
    clGray,
    clSilver,
    clRed,
    clLime,
    clYellow,
    clBlue,
    clFuchsia,
    clAqua,
    clWhite);

  DISPLAYNAMES: array[0..15] of string = (
    'Black',
    'Maroon',
    'Green',
    'Olive',
    'Navy',
    'Purple',
    'Teal',
    'Gray',
    'Silver',
    'Red',
    'Lime',
    'Yellow',
    'Blue',
    'Fuchsia',
    'Aqua',
    'White');

  CM_NOPATIENT = WM_APP + 401; //AAN 06/11/02
  CM_PATIENTFOUND = WM_APP + 402; //AAN 06/11/02
  CM_TEMPLATEUPDATED = WM_APP + 403; //AAN 06/11/02
  CM_TEMPLATEREFRESHED = WM_APP + 404; //AAN 06/11/02
  CM_VITALSELECTED = WM_APP + 405; //AAN 07/05/02
  CM_PTSEARCHING = WM_APP + 406; //AAN 07/18/02
  CM_PTLISTNOTFOUND = WM_APP + 407; //AAN 07/18/02
  CM_PTSEARCHDONE = WM_APP + 408; //AAN 07/18/02
  CM_PTSEARCHKBMODE = WM_APP + 409; //AAN 07/18/02
  CM_UPDATELOOKUP = WM_APP + 410; //AAN 07/18/02
  CM_PATIENTChanged = WM_APP + 411; //AAN 06/11/02
  CM_PTSEARCHDELAY = WM_APP + 412; //AAN 06/11/02
  CM_PTSEARCHSTART = WM_APP + 413; //AAN 06/11/02
  CM_PTLISTCHANGED = WM_APP + 414; //AAN 06/11/02
  CM_VITALCHANGED = WM_APP + 414; //AAN 06/11/02
  CM_SELECTPTLIST = WM_APP + 415; //AAN 06/11/02

  CM_SAVEINPUT = WM_APP + 416; //AAN 2003/06/06

  CM_PERIODCHANGED = WM_APP + 417; //AAN 06/11/02

  dfltGMVAbnormalText: integer = 9; //AAN 06/13/02
  dfltGMVAbnormalBkgd: integer = 15; //AAN 06/13/02
  dfltGMVAbnormalTodayBkgd: integer = 15; //AAN 06/13/02
  dfltGMVAbnormalBold: Boolean = False; //AAN 06/13/02
  dfltGMVAbnormalQuals: Boolean = True; //AAN 06/13/02
  dfltGMVNormalText: integer = 0; //AAN 06/13/02
  dfltGMVNormalBkgd: integer = 15; //AAN 06/13/02
  dfltGMVNormalTodayBkgd: integer = 15; //AAN 06/13/02
  dfltGMVNormalBold: Boolean = False; //AAN 06/13/02
  dfltGMVNormalQuals: Boolean = True; //AAN 06/13/02
  dfltGMVInquiryBkgd: integer = $00EACF80;
  dfltGMVInquiryTextBkgd:integer = $00EACF80; //clInfoBk;
  dfltGMVInquiryName: string = 'ORWPT PTINQ';

  GMV_VASitePos = 3;

  GMVIMAGES: array[TGMV_ImageIndex] of integer = (0, 1, 2, 3, 4, 5, 6, 7);
  BOOLEAN01: array[Boolean] of integer = (0, 1);
  BOOLEANYN: array[Boolean] of string = ('No', 'Yes');
  BOOLEANTF: array[Boolean] of string = ('False', 'True');
  BOOLEANUM: array[Boolean] of string = ('US', 'Metric');

  sMsgName = 'VistA Event - Clinical';
  sMsgReceiveName = 'VistA Event - Vitals';
  sMsgClose = 'VitalsClose';

  sMsgInvalidBP =
          'The entry should be in the following format:'+#13+
          'nnn/ or nnn/nnn or nnn/nnn/nnn' + #13+
          'for systolic/diastolic or systolic/intermediate/diastolic'+#13+
          'with values from 0 to 300.'
           ;

  //zzzzzzandria 070222
  // Disabling the qualifier update

  sMsgDisabledQualifiers =
        'In support of national standardization '+
        'Qualifiers management is not supported locally.'+#13#10+
        'If you wish to request a new term or modify an existing term'+#13#10+
        'please  refer to the New Term Rapid Turnaround (NTRT) web site located at'+#13#10+
        '                            http://vista.domain.ext/ntrt/ '+#13#10+
        'If you have any questions regarding this new term request process,'+#13#10+
         'please contact the ERT NTRT Coordinator via e-mail at VHA OI SDD HDS NTRT.';

  GMV_WEBSITE = 'http://vista.domain.ext/ClinicalSpecialties/vitals/';
  MetricList = 'HEIGHT TEMPERATURE WEIGHT CIRCUMFERENCE/GIRTH CENTRAL VENOUS PRESSURE'; // zzzzzzandria 060725 HD0000000149958

  GMV_DateTimeFormat = 'mm/dd/yyyy hh:nn:ss';
  GMV_DateFormat = 'mm/dd/yyyy';
  GMV_TimeFormat = 'hh:nn:ss';

implementation

end.
