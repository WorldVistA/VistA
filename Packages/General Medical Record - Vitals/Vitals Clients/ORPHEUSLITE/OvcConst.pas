{*********************************************************}
{*                  OVCCONST.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcconst;
  {-Command and resource constants}

interface

const
  {value used to offset string resource id's}
  BaseOffset      = 32768; {***}

const
  {constants for exception messages}
  SCUnknownError           = 30168;
  SCDuplicateCommand       = 30169;
  SCTableNotFound          = 30170;
  SCNotDoneYet             = 30171;
  SCNoControllerAssigned   = 30172;
  SCCantCreateCommandTable = 30173;
  SCCantDelete             = 30174;
  SCInvalidKeySequence     = 30175;
  SCNotWordStarCommands    = 30176;
  SCNoCommandSelected      = 30177;
  SCDuplicateKeySequence   = 30178;
  SCRangeError             = 30179;
  SCInvalidNumber          = 30180;
  SCRequiredField          = 30181;
  SCInvalidDate            = 30182;
  SCInvalidTime            = 30183;
  SCBlanksInField          = 30184;
  SCPartialEntry           = 30185;
  SCRegionTooLarge         = 30186;
  SCOutOfMemoryForCopy     = 30187;
  SCInvalidParamValue      = 30188;
  SCNoTimersAvail          = 30189;
  SCTooManyEvents          = 30190;
  SCBadTriggerHandle       = 30191;
  SCOnSelectNotAssigned    = 30192;
  SCInvalidPageIndex       = 30193;
  SCInvalidDataType        = 30194;
  SCInvalidTabFont         = 30195;
  SCInvalidLabelFont       = 30196;
  SCOutOfMemory            = 30197;
  SCTooManyParas           = 30198;
  SCCannotJoin             = 30199;
  SCTooManyBytes           = 30200;
  SCParaTooLong            = 30201;
  SCInvalidPictureMask     = 30202;
  SCInvalidRange           = 30203;
  SCInvalidRealRange       = 30204;
  SCInvalidExtendedRange   = 30205;
  SCInvalidDoubleRange     = 30206;
  SCInvalidSingleRange     = 30207;
  SCInvalidCompRange       = 30208;
  SCInvalidDateRange       = 30209;
  SCInvalidTimeRange       = 30210;
  SCInvalidRangeValue      = 30211;
  SCRangeNotSupported      = 30212;
  SCInvalidLineOrParaIndex = 30213;
  SCNonFixedFont           = 30214;
  SCInvalidFontParam       = 30215;
  SCInvalidLineOrColumn    = 30216;
  SCSAEGeneral             = 30217;
  SCSAEAtMaxSize           = 30218;
  SCSAEOutOfBounds         = 30219;
  SCInvalidXMLFile         = 30220;
  SCUnterminatedElement    = 30221;
  SCBadColorConst          = 30222;
  SCBadColorValue          = 30223;
  SCInvalidFieldType       = 30224;
  SCBadAlarmHandle         = 30225;
  SCOnIsSelectedNotAssigned= 30226;
  SCInvalidDateForMask     = 30227;
  SCNoTableAttached        = 30228;
  SCViewerIOError          = 30232;
  SCViewerFileNotFound     = 30233;
  SCViewerPathNotFound     = 30234;
  SCViewerTooManyOpenFiles = 30235;
  SCViewerFileAccessDenied = 30236;
  SCControlAttached        = 30237;
  SCCantEdit               = 30238;
  SCChildTableError        = 30239;
  SCNoCollection           = 30241;
  SCNotOvcDescendant       = 30242;
  SCItemIncompatible       = 30243;
  SCLabelNotAttached       = 30244;
  SCClassNotSet            = 30245;
  SCCollectionNotFound     = 30246;
  SCDayConvertError        = 30247;
  SCMonthConvertError      = 30248;
  SCMonthNameConvertError  = 30249;
  SCYearConvertError       = 30250;
  SCDayRequired            = 30251;
  SCMonthRequired          = 30252;
  SCYearRequired           = 30253;
  SCInvalidDay             = 30254;
  SCInvalidMonth           = 30255;
  SCInvalidMonthName       = 30256;
  SCInvalidYear            = 30257;
  SCTableRowOutOfBounds    = 30258;
  SCTableMaxRows           = 30259;
  SCTableMaxColumns        = 30260;
  SCTableGeneral           = 30261;
  SCTableToManyColumns     = 30262;
  SCTableInvalidFieldIndex = 30263;
  SCTableHeaderNotAssigned = 30264;
  SCTableInvalidHeaderCell = 30265;
  SCGridTableName          = 30266;
  {general constants for string table resource entries}
  SCNoneStr                = 30268;
  SCccUser                 = 30269;
  SCccUserNum              = 30270;
  SCDeleteTable            = 30271;
  SCRenameTable            = 30272;
  SCEnterTableName         = 30273;
  SCNewTable               = 30274;
  SCDefaultTableName       = 30275;
  SCWordStarTableName      = 30276;
  SCUnknownTable           = 30277;
  SCDefaultEntryErrorText  = 30278;
  SCGotItemWarning         = 30279;
  SCSampleListItem         = 30280;
  SCAlphaString            = 30281;
  SCTallLowChars           = 30282;
  SCDefault                = 30283;
  SCDescending             = 30285;
  SCDefaultIndex           = 30286;
  SCRestoreMI              = 30287;
  SCCutMI                  = 30288;
  SCCopyMI                 = 30289;
  SCPasteMI                = 30290;
  SCDeleteMI               = 30291;
  SCSelectAllMI            = 30292;
  SCCalcBack               = 30293;
  SCCalcMC                 = 30294;
  SCCalcMR                 = 30295;
  SCCalcMS                 = 30296;
  SCCalcMPlus              = 30297;
  SCCalcMMinus             = 30298;
  SCCalcCT                 = 30299;
  SCCalcCE                 = 30300;
  SCCalcC                  = 30301;
  SCCalcSqrt               = 30302;
  SCCalNext                = 30303;
  SCCalLast                = 30304;
  SCCalFirst               = 30305;
  SCCal1st                 = 30306;
  SCCalSecond              = 30307;
  SCCal2nd                 = 30308;
  SCCalThird               = 30309;
  SCCal3rd                 = 30310;
  SCCalFourth              = 30311;
  SCCal4th                 = 30312;
  SCCalFinal               = 30313;
  SCCalBOM                 = 30314;
  SCCalEnd                 = 30315;
  SCCalEOM                 = 30316;
  SCCalYesterday           = 30317;
  SCCalToday               = 30318;
  SCCalTomorrow            = 30319;
  SCEditingSections        = 30320;
  SCEditingItems           = 30321;
  SCEditingFolders         = 30322;
  SCEditingPages           = 30323;
  SCEditingImages          = 30324;
  SCSectionBaseName        = 30325;
  SCItemBaseName           = 30326;
  SCFolderBaseName         = 30327;
  SCPageBaseName           = 30328;
  SCImageBaseName          = 30329;
  SCOwnerMustBeForm        = 30330;
  SCTimeConvertError       = 30331;
  SCCancelQuery            = 30332;
  SCNoPagesAssigned        = 30333;
  SCCalPrev                = 30334;
  SCCalBegin               = 30335;
  SCInvalidMinMaxValue     = 30336;
  SCFormUseOnly            = 30337;

  {misc constant values}
  SCYes                    = 30368;
  SCNo                     = 30369;
  SCTrue                   = 30370;
  SCFalse                  = 30371;
  SCHoursName              = 30372;
  SCMinutesName            = 30373;
  SCSecondsName            = 30374;
  SCCloseCaption           = 30375;

  {report view exceptions}
  SCViewFieldNotFound      = 30376;
  SCCantResolveField       = 30377;
  SCItemAlreadyExists      = 30378;
  SCAlreadyInTempMode      = 30379;
  SCItemNotFound           = 30380;
  SCUpdatePending          = 30381;
  SCOnCompareNotAssigned   = 30382;
  SCOnFilterNotAssigned    = 30383;
  SCGetAsFloatNotAssigned  = 30384;
  SCNotInTempMode          = 30385;
  SCItemNotInIndex         = 30387;
  SCNoActiveView           = 30388;
  SCItemIsNotGroup         = 30389;
  SCNotMultiSelect         = 30390;
  SCLineNoOutOfRange       = 30391;
  SCUnknownView            = 30392;
  SCOnKeySearchNotAssigned = 30393;
  SCOnEnumNotAssigned      = 30394;
  SCOnEnumSelectedNA       = 30395;

  {MRU list exceptions }
  SCNoMenuAssigned         = 30400;
  SCNoAnchorAssigned       = 30401;
  SCInvalidParameter       = 30402;
  SCInvalidOperation       = 30403;

  SCColorBlack             = 30500;
  SCColorMaroon            = 30501;
  SCColorGreen             = 30502;
  SCColorOlive             = 30503;
  SCColorNavy              = 30504;
  SCColorPurple            = 30505;
  SCColorTeal              = 30506;
  SCColorGray              = 30507;
  SCColorSilver            = 30508;
  SCColorRed               = 30509;
  SCColorLime              = 30510;
  SCColorYellow            = 30511;
  SCColorBlue              = 30512;
  SCColorFuchsia           = 30513;
  SCColorAqua              = 30514;
  SCColorWhite             = 30515;
  SCColorLightGray         = 30516;
  SCColorMediumGray        = 30517;
  SCColorDarkGray          = 30518;
  SCColorMoneyGreen        = 30519;
  SCColorSkyBlue           = 30520;
  SCColorCream             = 30521;

const
  cHotKeyChar     = '&'; {hotkey prefix character}

const
  {offset for resource id's}
  CommandResOfs  = BaseOffset + 1000; {***}

  {command codes - corresponding text offset by CommandOfs, stored in rc file}
  {*** must be contiguous ***}
  ccFirstCmd               =  0; {first defined command}
  ccNone                   =  0; {no command or not a known command}
  ccBack                   =  1; {backspace one character}
  ccBotOfPage              =  2; {move caret to end of last page}
  ccBotRightCell           =  3; {move to the bottom right hand cell in a table}
  ccCompleteDate           =  4; {use default date for current date sub field}
  ccCompleteTime           =  5; {use default time for current time sub field}
  ccCopy                   =  6; {copy highlighted text to clipboard}
  ccCtrlChar               =  7; {accept control character}
  ccCut                    =  8; {copy highlighted text to clipboard and delete it}
  ccDec                    =  9; {decrement the current entry field value}
  ccDel                    = 10; {delete current character}
  ccDelBol                 = 11; {delete from caret to beginning of line}
  ccDelEol                 = 12; {delete from caret to end of line}
  ccDelLine                = 13; {delete entire line}
  ccDelWord                = 14; {delete word to right of caret}
  ccDown                   = 15; {cursor down}
  ccEnd                    = 16; {caret to end of line}
  ccExtendDown             = 17; {extend selection down one line}
  ccExtendEnd              = 18; {extend highlight to end of field}
  ccExtendHome             = 19; {extend highlight to start of field}
  ccExtendLeft             = 20; {extend highlight left one character}
  ccExtendPgDn             = 21; {extend selection down one page}
  ccExtendPgUp             = 22; {extend selection up one page}
  ccExtendRight            = 23; {extend highlight right one character}
  ccExtendUp               = 24; {extend selection up one line}
  ccExtBotOfPage           = 25; {extend selection to bottom of page}
  ccExtFirstPage           = 26; {extend selection to first page}
  ccExtLastPage            = 27; {extend selection to last page}
  ccExtTopOfPage           = 28; {extend selection to top of page}
  ccExtWordLeft            = 29; {extend highlight left one word}
  ccExtWordRight           = 30; {extend highlight right one word}
  ccFirstPage              = 31; {first page in table}
  ccGotoMarker0            = 32; {editor & viewer, go to a position marker}
  ccGotoMarker1            = 33; {editor & viewer, go to a position marker}
  ccGotoMarker2            = 34; {editor & viewer, go to a position marker}
  ccGotoMarker3            = 35; {editor & viewer, go to a position marker}
  ccGotoMarker4            = 36; {editor & viewer, go to a position marker}
  ccGotoMarker5            = 37; {editor & viewer, go to a position marker}
  ccGotoMarker6            = 38; {editor & viewer, go to a position marker}
  ccGotoMarker7            = 39; {editor & viewer, go to a position marker}
  ccGotoMarker8            = 40; {editor & viewer, go to a position marker}
  ccGotoMarker9            = 41; {editor & viewer, go to a position marker}
  ccHome                   = 42; {caret to beginning of line}
  ccInc                    = 43; {increment the current entry field value}
  ccIns                    = 44; {toggle insert mode}
  ccLastPage               = 45; {last page in table}
  ccLeft                   = 46; {caret left by one character}
  ccNewLine                = 47; {editor, create a new line}
  ccNextPage               = 48; {next page in table}
  ccPageLeft               = 49; {move left a page in the table}
  ccPageRight              = 50; {move right a page in the table}
  ccPaste                  = 51; {paste text from clipboard}
  ccPrevPage               = 52; {previous page in table}
  ccRedo                   = 53; {re-do the last undone operation}
  ccRestore                = 54; {restore default and continue}
  ccRight                  = 55; {caret right by one character}
  ccScrollDown             = 56; {editor, scroll page up one line}
  ccScrollUp               = 57; {editor, scroll page down one line}
  ccSetMarker0             = 58; {editor & viewer, set a position marker}
  ccSetMarker1             = 59; {editor & viewer, set a position marker}
  ccSetMarker2             = 60; {editor & viewer, set a position marker}
  ccSetMarker3             = 61; {editor & viewer, set a position marker}
  ccSetMarker4             = 62; {editor & viewer, set a position marker}
  ccSetMarker5             = 63; {editor & viewer, set a position marker}
  ccSetMarker6             = 64; {editor & viewer, set a position marker}
  ccSetMarker7             = 65; {editor & viewer, set a position marker}
  ccSetMarker8             = 66; {editor & viewer, set a position marker}
  ccSetMarker9             = 67; {editor & viewer, set a position marker}
  ccTab                    = 68; {editor, for tab entry}
  ccTableEdit              = 69; {enter/exit table edit mode}
  ccTopLeftCell            = 70; {move to the top left cell in a table}
  ccTopOfPage              = 71; {move caret to beginning of first page}
  ccUndo                   = 72; {undo last operation}
  ccUp                     = 73; {cursor up}
  ccWordLeft               = 74; {caret left one word}
  ccWordRight              = 75; {caret right one word}

  ccLastCmd                = 75; {***} {last interfaced command}

  {internal}
  ccChar                   = 249; {regular character; generated internally}
  ccMouse                  = 250; {mouse selection; generated internally}
  ccMouseMove              = 251; {mouse move; generated internally}
  ccAccept                 = 252; {accept next key; internal}
  ccDblClk                 = 253; {mouse double click; generated internally}
  ccSuppress               = 254; {suppress next key; internal}
  ccPartial                = 255; {partial command; internal}

  {user defined commands start here}
  ccUserFirst              = 256;
  ccUser0                  = ccUserFirst + 0;
  ccUser1                  = ccUserFirst + 1;
  ccUser2                  = ccUserFirst + 2;
  ccUser3                  = ccUserFirst + 3;
  ccUser4                  = ccUserFirst + 4;
  ccUser5                  = ccUserFirst + 5;
  ccUser6                  = ccUserFirst + 6;
  ccUser7                  = ccUserFirst + 7;
  ccUser8                  = ccUserFirst + 8;
  ccUser9                  = ccUserFirst + 9;
  {...                     = ccUserFirst + 65535 - ccUserFirst}


{data type base offset}
const
  DataTypeOfs              =  BaseOffset + 1300; {***}

{entry field data type sub codes}
const
  fsubString               =  0; {field subclass codes}
  fsubChar                 =  1;
  fsubBoolean              =  2;
  fsubYesNo                =  3;
  fsubLongInt              =  4;
  fsubWord                 =  5;
  fsubInteger              =  6;
  fsubByte                 =  7;
  fsubShortInt             =  8;
  fsubReal                 =  9;
  fsubExtended             = 10;
  fsubDouble               = 11;
  fsubSingle               = 12;
  fsubComp                 = 13;
  fsubDate                 = 14;
  fsubTime                 = 15;


{constants for simple, picture, and numeric picture}
{mask samples used in the property editors}
const
  PictureMaskOfs           = BaseOffset + 1700; {***}

  {simple field mask characters}
  stsmFirst                = 34468;
  stsmLast                 = 34468 + 23;

  {numeric field picture masks}
  stnmFirst                = 34493;
  stnmLast                 = 34493 + 17;

  {picture field picture masks}
  stpmFirst                = 34518;
  stpmLast                 = 34518 + 23;

const
{String Resource Constants...}

{Note:  These should stay in numerical order.  It's not as important here as it
 is in the O32SR.pas file's Lookup Array, but you should still keep it in
 mind when editing these values...}

  {String Resource Index Constants}
  IccNone                   = 33768;
  IccBack                   = 33769;
  IccBotOfPage              = 33770;
  IccBotRightCell           = 33771;
  IccCompleteDate           = 33772;
  IccCompleteTime           = 33773;
  IccCopy                   = 33774;
  IccCtrlChar               = 33775;
  IccCut                    = 33776;
  IccDec                    = 33777;
  IccDel                    = 33778;
  IccDelBol                 = 33779;
  IccDelEol                 = 33780;
  IccDelLine                = 33781;
  IccDelWord                = 33782;
  IccDown                   = 33783;
  IccEnd                    = 33784;
  IccExtendDown             = 33785;
  IccExtendEnd              = 33786;
  IccExtendHome             = 33787;
  IccExtendLeft             = 33788;
  IccExtendPgDn             = 33789;
  IccExtendPgUp             = 33790;
  IccExtendRight            = 33791;
  IccExtendUp               = 33792;
  IccExtBotOfPage           = 33793;
  IccExtFirstPage           = 33794;
  IccExtLastPage            = 33795;
  IccExtTopOfPage           = 33796;
  IccExtWordLeft            = 33797;
  IccExtWordRight           = 33798;
  IccFirstPage              = 33799;
  IccGotoMarker0            = 33800;
  IccGotoMarker1            = 33801;
  IccGotoMarker2            = 33802;
  IccGotoMarker3            = 33803;
  IccGotoMarker4            = 33804;
  IccGotoMarker5            = 33805;
  IccGotoMarker6            = 33806;
  IccGotoMarker7            = 33807;
  IccGotoMarker8            = 33808;
  IccGotoMarker9            = 33809;
  IccHome                   = 33810;
  IccInc                    = 33811;
  IccIns                    = 33812;
  IccLastPage               = 33813;
  IccLeft                   = 33814;
  IccNewLine                = 33815;
  IccNextPage               = 33816;
  IccPageLeft               = 33817;
  IccPageRight              = 33818;
  IccPaste                  = 33819;
  IccPrevPage               = 33820;
  IccRedo                   = 33821;
  IccRestore                = 33822;
  IccRight                  = 33823;
  IccScrollDown             = 33824;
  IccScrollUp               = 33825;
  IccSetMarker0             = 33826;
  IccSetMarker1             = 33827;
  IccSetMarker2             = 33828;
  IccSetMarker3             = 33829;
  IccSetMarker4             = 33830;
  IccSetMarker5             = 33831;
  IccSetMarker6             = 33832;
  IccSetMarker7             = 33833;
  IccSetMarker8             = 33834;
  IccSetMarker9             = 33835;
  IccTab                    = 33836;
  IccTableEdit              = 33837;
  IccTopLeftCell            = 33838;
  IccTopOfPage              = 33839;
  IccUndo                   = 33840;
  IccUp                     = 33841;
  IccWordLeft               = 33842;
  IccWordRight              = 33843;

  IString                   = 34068;
  IChar                     = 34069;
  IBoolean                  = 34070;
  IYesNo                    = 34071;
  ILongInt                  = 34072;
  IWord                     = 34073;
  ISmallInt                 = 34074;
  IByte                     = 34075;
  IShortInt                 = 34076;
  IReal                     = 34077;
  IExtended                 = 34078;
  IDouble                   = 34079;
  ISingle                   = 34080;
  IComp                     = 34081;
  IDate                     = 34082;
  ITime                     = 34083;

  {Character Masks}
  ICharMask1                = 34468;
  ICharMask2                = 34469;
  ICharMask3                = 34470;
  ICharMask4                = 34471;
  ICharMask5                = 34472;
  ICharMask6                = 34473;
  ICharMask7                = 34474;
  ICharMask8                = 34475;
  ICharMask9                = 34476;
  ICharMask10               = 34477;
  ICharMask11               = 34478;
  ICharMask12               = 34479;
  ICharMask13               = 34480;
  ICharMask14               = 34481;
  ICharMask15               = 34482;
  ICharMask16               = 34483;
  ICharMask17               = 34484;
  ICharMask18               = 34485;
  ICharMask19               = 34486;
  ICharMask20               = 34487;
  ICharMask21               = 34488;
  ICharMask22               = 34489;
  ICharMask23               = 34490;
  ICharMask24               = 34491;

  {Sample Field Masks }
  IFieldMask1               = 34493;
  IFieldMask2               = 34494;
  IFieldMask3               = 34495;
  IFieldMask4               = 34496;
  IFieldMask5               = 34497;
  IFieldMask6               = 34498;
  IFieldMask7               = 34499;
  IFieldMask8               = 34500;
  IFieldMask9               = 34501;
  IFieldMask10              = 34502;
  IFieldMask11              = 34503;
  IFieldMask12              = 34504;
  IFieldMask13              = 34505;
  IFieldMask14              = 34506;
  IFieldMask15              = 34507;
  IFieldMask16              = 34508;
  IFieldMask17              = 34509;
  IFieldMask18              = 34510;

  IFieldMask19              = 34518;
  IFieldMask20              = 34519;
  IFieldMask21              = 34520;
  IFieldMask22              = 34521;
  IFieldMask23              = 34522;
  IFieldMask24              = 34523;
  IFieldMask25              = 34524;
  IFieldMask26              = 34525;
  IFieldMask27              = 34526;
  IFieldMask28              = 34527;
  IFieldMask29              = 34528;
  IFieldMask30              = 34529;
  IFieldMask31              = 34530;
  IFieldMask32              = 34531;
  IFieldMask33              = 34532;
  IFieldMask34              = 34533;
  IFieldMask35              = 34534;
  IFieldMask36              = 34535;
  IFieldMask37              = 34536;
  IFieldMask38              = 34537;
  IFieldMask39              = 34538;
  IFieldMask40              = 34539;
  IFieldMask41              = 34540;
  IFieldMask42              = 34541;

implementation

end.
