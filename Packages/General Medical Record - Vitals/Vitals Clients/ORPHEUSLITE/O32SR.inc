{*********************************************************}
{*                      O32SR.INC                        *}
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

{Orhpheus String Resources - To create language specific versions of Orpheus
 controls, translate these strings to the desired language and re-compile.}

resourcestring
  RSNoneStr                 = '(None)';
  RSccUser                  = 'ccUser';
  RSccUserNum               = 'ccUser%d';
  RSDeleteTable             = 'Delete the %s table?';
  RSRenameTable             = 'Rename Table';
  RSEnterTableName          = 'Enter new table name for %s:';
  RSNewTable                = 'NewTable';
  RSDefaultTableName        = 'Default';
  RSWordStarTableName       = 'WordStar';
  RSGridTableName           = 'Grid';
  RSUnknownTable            = '(Unknown)';
  RSDefaultEntryErrorText   = 'Entry Error';
  RSGotItemWarning          = '%d. *** Warning *** OnGetItem not assigned!';
  RSSampleListItem          = '%d. - Sample virtual list box item';
  RSAlphaString             = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  RSTallLowChars            = 'Wy';
  RSDefault                 = 'Default';
  RSYes                     = 'Y';
  RSNo                      = 'N';
  RSTrue                    = 'T';
  RSFalse                   = 'F';
  RSDescending              = ' - Desc';
  RSDefaultIndex            = '(Default)';
  RSDuplicateCommand        = 'Duplicate command found while adding a new command to the table';
  RSTableNotFound           = 'Command table not found or command table index out of range';
  RSNotDoneYet              = 'This feature is not implemented at this time';
  RSNoControllerAssigned    = 'No Controller assigned';
  RSCantCreateCommandTable  = 'Unable to create command table';
  RSCantDelete              = 'Can''t delete this table. Must have at least one command table defined';
  RSInvalidKeySequence      = 'Invalid or no key sequence entered';
  RSNotWordStarCommands     = 'Keys entered are not WordStar style commands';
  RSNoCommandSelected       = 'No command selected';
  RSDuplicateKeySequence    = 'Duplicate key sequence';
  RSRangeError              = 'Value is not within required range';
  RSInvalidNumber           = 'Value is not valid for this field type';
  RSRequiredField           = 'A value is required in this field';
  RSInvalidDate             = 'Value is not a valid date';
  RSInvalidTime             = 'Value is not a valid time';
  RSBlanksInField           = 'This field should contain no blanks';
  RSPartialEntry            = 'This field should be either empty or completely full';
  RSRegionTooLarge          = 'Region is too large (> 64K)';
  RSOutOfMemoryForCopy      = 'Could not allocate memory for clipboard copy';
  RSInvalidParamValue       = 'Parameter value is invalid';
  RSNoTimersAvail           = 'No Window''s timers are available';
  RSTooManyEvents           = 'Too many trigger events';
  RSBadTriggerHandle        = 'Invalid trigger handle';
  RSOnSelectNotAssigned     = 'OnSelect event is not assigned';
  RSInvalidPageIndex        = 'Invalid page index value';
  RSInvalidDataType         = 'Invalid data type for this field';
  RSInvalidTabFont          = 'Invalid font. Non toTop oriented tabs require a True-Type font';
  RSInvalidLabelFont        = 'Invalid font. Rotated text requires a True-Type font';
  RSOutOfMemory             = 'insufficient memory for requested operation';
  RSTooManyParas            = 'Current operation will exceed the maximum number of allowed paragraphs';
  RSCannotJoin              = 'Cannot join paragraphs. New paragraph size exceeds maximum paragraph size';
  RSTooManyBytes            = 'Current operation will exceed the maximum text size';
  RSParaTooLong             = 'Current operation will exceed the maximum paragraph size';
  RSUnknownError            = 'Unknown Error condition';
  RSInvalidPictureMask      = 'Invalid picture mask: %s';
  RSInvalidRange            = 'Invalid range. Enter a value between (%d) and (%d)';
  RSInvalidRealRange        = 'Invalid range. Enter a value between (-1.7e+38) and (+1.7e+38)';
  RSInvalidExtendedRange    = 'Invalid range. Enter a value between (-1.1e+4932) and (+1.1e+4932)';
  RSInvalidDoubleRange      = 'Invalid range. Enter a value between (-1.7e+308) and (+1.7e+308)';
  RSInvalidSingleRange      = 'Invalid range. Enter a value between (-3.4e+38) and (+3.4e+38)';
  RSInvalidCompRange        = 'Invalid range. Enter a value between (-9.2e+18) and (+9.2e+18)';
  RSInvalidDateRange        = 'Invalid date range. Enter a value using ''%s'' as the format';
  RSInvalidTimeRange        = 'Invalid time range. Enter a value using ''%s'' as the format';
  RSInvalidRangeValue       = 'Invalid range value';
  RSInvalidMinMaxValue      = 'Invalid value - Maximum must always be greater than Minimum';
  RSRangeNotSupported       = 'Range limits for the currently selected data type are not supported';
  RSInvalidLineOrParaIndex  = 'Invalid line or paragraph index';
  RSNonFixedFont            = 'Invalid font assignment. Font must be a fixed font';
  RSInvalidFontParam        = 'Invalid font assignemnt. Font must be a TFont or TOvcFixedFont';
  RSInvalidLineOrColumn     = 'Invalid line or column';
  RSSAEGeneral              = 'Unknown sparse array error';
  RSSAEAtMaxSize            = 'Sparse array is at the maximum size';
  RSInvalidXMLFile          = 'Invalid XMLStore File Format';
  RSUnterminatedElement     = 'Improperly terminated element';
  RSBadColorConstant        = 'Invalid color constant';
  RSBadColorValue           = 'Invalid color value';
  RSSAEOutOfBounds          = 'Index is out of bounds for sparse array';
  RSInvalidFieldType        = 'Requested field type is not supported';
  RSBadAlarmHandle          = 'Invalid alarm handle';
  RSOnIsSelectedNotAssigned = 'OnIsSelected event is not assigned';
  RSInvalidDateForMask      = 'Invalid date value for picture mask. (Year is outside the Epoch range)';
  RSViewerIOError           = 'Viewer triggered I/O error %d';
  RSViewerFileNotFound      = 'Viewer: file not found';
  RSViewerPathNotFound      = 'Viewer: path not found or invalid file name';
  RSViewerTooManyOpenFiles  = 'Viewer: too many open files';
  RSViewerFileAccessDenied  = 'Viewer: file access denied';
  RSControlAttached         = 'This control is already attached to %s';
  RSCantEdit                = 'Could not enter edit mode';
  RSChildTableError         = 'Data Source can not be a child table. Component %s has a MasterSource defined';
  RSNoTableAttached         = 'DataSource must be attached to a TTable (or compatible) source';
  RSNoCollection            = 'No collection exists in the owner component';
  RSNotOvcDescendant        = 'Owner must be a TOvcComponent or TOvcCustomComponent descendant';
  RSItemIncompatible        = 'Item incompatible with collection';
  RSLabelNotAttached        = 'Label not attached';
  RSClassNotSet             = 'Item class not set';
  RSCollectionNotFound      = 'No collection found for this type';
  RSDayConvertError         = 'Error converting day';
  RSMonthConvertError       = 'Error converting month';
  RSMonthNameConvertError   = 'Error converting month name';
  RSYearConvertError        = 'Error converting year';
  RSInvalidDay              = 'Invalid day';
  RSInvalidMonth            = 'Invalid month';
  RSInvalidMonthName        = 'Invalid month name';
  RSInvalidYear             = 'Invalid year';
  RSDayRequired             = 'Day is required';
  RSMonthRequired           = 'Month is required';
  RSYearRequired            = 'Year is required';
  RSOwnerMustBeForm         = 'Owner must be a TForm or descendant';
  RSTimeConvertError        = 'Error converting time value';
  RSCancelQuery             = 'Cancel and lose changes?';
  RSNoPagesAssigned         = 'No notebook pages assigned';
  RSRestoreMI               = '&Restore';
  RSCutMI                   = 'Cu&t';
  RSCopyMI                  = '&Copy';
  RSPasteMI                 = '&Paste';
  RSDeleteMI                = '&Delete';
  RSSelectAllMI             = 'Select &All';
  RSTableRowOutOfBounds     = 'Table row out of bounds';
  RSTableMaxRows            = 'Table max rows error';
  RSTableMaxColumns         = 'Table max columns error';
  RSTableGeneral            = 'Table general error';
  RSTableToManyColumns      = 'Too many columns';
  RSTableInvalidFieldIndex  = 'Invalid field index';
  RSTableHeaderNotAssigned  = 'Header not assigned';
  RSTableInvalidHeaderCell  = 'Invalid header cell';
  RSCalcBack                = 'Back';
  RSCalcMC                  = 'MC';
  RSCalcMR                  = 'MR';
  RSCalcMS                  = 'MS';
  RSCalcMPlus               = 'M+';
  RSCalcMMinus              = 'M-';
  RSCalcCT                  = 'CT';
  RSCalcCE                  = 'CE';
  RSCalcC                   = 'C';
  RSCalcSqrt                = 'Sqrt';
  RSCalNext                 = 'NEXT';
  RSCalLast                 = 'LAST';
  RSCalPrev                 = 'PREV';
  RSCalFirst                = 'FIRST';
  RSCal1st                  = '1ST';
  RSCalSecond               = 'SECOND';
  RSCal2nd                  = '2ND';
  RSCalThird                = 'THIRD';
  RSCal3rd                  = '3RD';
  RSCalFourth               = 'FOURTH';
  RSCal4th                  = '4TH';
  RSCalFinal                = 'FINAL';
  RSCalBOM                  = 'BOM';
  RSCalBegin                = 'BEGIN';
  RSCalEOM                  = 'EOM';
  RSCalEnd                  = 'END';
  RSCalYesterday            = 'YESTERDAY';
  RSCalToday                = 'TODAY';
  RSCalTomorrow             = 'TOMORROW';
  RSEditingSections         = 'Header Sections Editor';
  RSEditingItems            = 'Folder Items Editor';
  RSEditingFolders          = 'Folder Editor';
  RSEditingPages            = 'Tab Pages Editor';
  RSEditingImages           = 'Image List Editor';
  RSSectionBaseName         = 'Section';
  RSItemBaseName            = 'Item';
  RSFolderBaseName          = 'Folder';
  RSPageBaseName            = 'Page';
  RSImageBaseName           = 'Image';
  RSHoursName               = 'Hours';
  RSMinutesName             = 'Minutes';
  RSSecondsName             = 'Seconds';
  RSCloseCaption            = 'Close';
  RSViewFieldNotFound       = 'The view field %s was not found';
  RSCantResolveField        = 'Unable to resolve view field %s';
  RSItemAlreadyExists       = 'Can''t add item %p - it already exists in the index';
  RSAlreadyInTempMode       = 'The view is already in temporary index mode';
  RSItemNotFound            = 'Specified report view data item %p was not found';
  RSUpdatePending           = 'This report view operation is invalid while updates are pending';
  RSOnCompareNotAssigned    = 'OnCompareFields not assigned';
  RSOnFilterNotAssigned     = 'OnFilter not assigned';
  RSGetAsFloatNotAssigned   = 'GetAsFloat not assigned';
  RSNotInTempMode           = 'Report view is not in temporary index mode';
  RSItemNotInIndex          = 'The specified data item (%p) is not in the index';
  RSNoActiveView            = 'No active view';
  RSItemIsNotGroup          = 'Item at line %d is not a group';
  RSNotMultiSelect          = 'This report view operation is only allowed when multiselect is enabled';
  RSLineNoOutOfRange        = 'Invalid index %d';
  RSUnknownView             = 'Unknown view: %s';
  RSOnKeySearchNotAssigned  = 'The OnKeySearch event is not assigned';
  RSOnEnumNotAssigned       = 'The OnEnum event is not assigned';
  RSOnEnumSelectedNA        = 'OnEnumSelected not assigned';
  RSNoMenuAssigned          = 'No menu item assigned';
  RSNoAnchorAssigned        = 'No anchor item assigned';
  RSInvalidParameter        = 'Invalid parameter: mpAnchor';
  RSInvalidOperation        = 'Invalid operation: Call AddSplit for split menus';
  RSFormUseOnly             = 'This component can only be used on forms';
  RSColorBlack              = 'Black';
  RSColorMaroon             = 'Maroon';
  RSColorGreen              = 'Green';
  RSColorOlive              = 'Olive';
  RSColorNavy               = 'Navy';
  RSColorPurple             = 'Purple';
  RSColorTeal               = 'Teal';
  RSColorGray               = 'Gray';
  RSColorSilver             = 'Silver';
  RSColorRed                = 'Red';
  RSColorLime               = 'Lime';
  RSColorYellow             = 'Yellow';
  RSColorBlue               = 'Blue';
  RSColorFuchsia            = 'Fuchsia';
  RSColorAqua               = 'Aqua';
  RSColorWhite              = 'White';
  RSColorLightGray          = 'Light Gray';
  RSColorMediumGray         = 'Medium Gray';
  RSColorDarkGray           = 'Dark Gray';
  RSColorMoneyGreen         = 'Money Green';
  RSColorSkyBlue            = 'Sky Blue';
  RSColorCream              = 'Cream';

  {end - Index based resource strings}


