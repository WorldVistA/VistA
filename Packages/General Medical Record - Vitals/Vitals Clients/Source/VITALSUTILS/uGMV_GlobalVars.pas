unit uGMV_GlobalVars;

interface

var

  GMVAllowUserTemplates: Boolean = False;

  GMVAbnormalText: integer = 9;
  GMVAbnormalBkgd: integer = 15;
  GMVAbnormalTodayBkgd: integer = 15;
  GMVAbnormalBold: Boolean = False;
  GMVAbnormalQuals: Boolean = True;

  GMVNormalText: integer = 0;
  GMVNormalBkgd: integer = 15;
  GMVNormalTodayBkgd: integer = 15;
  GMVNormalBold: Boolean = False;
  GMVNormalQuals: Boolean = True;

  GMVInquiryBkgd: integer = $00CBF1FE; //$00EACF80;  
  GMVInquiryTextBkgd: integer = $00EACF80;//clInfoBk;
  GMVInitialDFN: string = '';

  GMVSearchDelay:String = '5';
  GMVTemplate:String = '';
  GMVInquiryName: String = 'ORWPT PTINQ';

  g_hAppMutex: THandle; // One instance of a program
  AllowMultipleCopiesKey: String = '/multi';

  GMV_PlugInDir:String = 'PLUGINS';

  GMV_PlugInReady: String = 'checkReadiness'; // may be not the best choice...
  GMV_PlugInReset: String = 'resetMonitor'; // may be not the best choice...
  GMV_PlugInGetStatus: String = 'getState'; // may be not the best choice...
  GMV_PlugInGetBufferLength: String = 'getBufferLength'; // may be not the best choice...

implementation

end.



