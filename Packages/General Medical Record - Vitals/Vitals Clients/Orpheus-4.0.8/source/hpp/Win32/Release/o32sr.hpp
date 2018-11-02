// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32sr.pas' rev: 29.00 (Windows)

#ifndef O32srHPP
#define O32srHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <ovcconst.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32sr
{
//-- forward type declarations -----------------------------------------------
struct SrMsgNumLookupRec;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD SrMsgNumLookupRec
{
public:
	int MessageNum;
	System::UnicodeString MessageStr;
};


typedef System::StaticArray<SrMsgNumLookupRec, 376> O32sr__1;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::ResourceString _RSNoneStr;
#define O32sr_RSNoneStr System::LoadResourceString(&O32sr::_RSNoneStr)
extern DELPHI_PACKAGE System::ResourceString _RSccUser;
#define O32sr_RSccUser System::LoadResourceString(&O32sr::_RSccUser)
extern DELPHI_PACKAGE System::ResourceString _RSccUserNum;
#define O32sr_RSccUserNum System::LoadResourceString(&O32sr::_RSccUserNum)
extern DELPHI_PACKAGE System::ResourceString _RSDeleteTable;
#define O32sr_RSDeleteTable System::LoadResourceString(&O32sr::_RSDeleteTable)
extern DELPHI_PACKAGE System::ResourceString _RSRenameTable;
#define O32sr_RSRenameTable System::LoadResourceString(&O32sr::_RSRenameTable)
extern DELPHI_PACKAGE System::ResourceString _RSEnterTableName;
#define O32sr_RSEnterTableName System::LoadResourceString(&O32sr::_RSEnterTableName)
extern DELPHI_PACKAGE System::ResourceString _RSNewTable;
#define O32sr_RSNewTable System::LoadResourceString(&O32sr::_RSNewTable)
extern DELPHI_PACKAGE System::ResourceString _RSDefaultTableName;
#define O32sr_RSDefaultTableName System::LoadResourceString(&O32sr::_RSDefaultTableName)
extern DELPHI_PACKAGE System::ResourceString _RSWordStarTableName;
#define O32sr_RSWordStarTableName System::LoadResourceString(&O32sr::_RSWordStarTableName)
extern DELPHI_PACKAGE System::ResourceString _RSGridTableName;
#define O32sr_RSGridTableName System::LoadResourceString(&O32sr::_RSGridTableName)
extern DELPHI_PACKAGE System::ResourceString _RSUnknownTable;
#define O32sr_RSUnknownTable System::LoadResourceString(&O32sr::_RSUnknownTable)
extern DELPHI_PACKAGE System::ResourceString _RSDefaultEntryErrorText;
#define O32sr_RSDefaultEntryErrorText System::LoadResourceString(&O32sr::_RSDefaultEntryErrorText)
extern DELPHI_PACKAGE System::ResourceString _RSGotItemWarning;
#define O32sr_RSGotItemWarning System::LoadResourceString(&O32sr::_RSGotItemWarning)
extern DELPHI_PACKAGE System::ResourceString _RSSampleListItem;
#define O32sr_RSSampleListItem System::LoadResourceString(&O32sr::_RSSampleListItem)
extern DELPHI_PACKAGE System::ResourceString _RSAlphaString;
#define O32sr_RSAlphaString System::LoadResourceString(&O32sr::_RSAlphaString)
extern DELPHI_PACKAGE System::ResourceString _RSTallLowChars;
#define O32sr_RSTallLowChars System::LoadResourceString(&O32sr::_RSTallLowChars)
extern DELPHI_PACKAGE System::ResourceString _RSDefault;
#define O32sr_RSDefault System::LoadResourceString(&O32sr::_RSDefault)
extern DELPHI_PACKAGE System::ResourceString _RSYes;
#define O32sr_RSYes System::LoadResourceString(&O32sr::_RSYes)
extern DELPHI_PACKAGE System::ResourceString _RSNo;
#define O32sr_RSNo System::LoadResourceString(&O32sr::_RSNo)
extern DELPHI_PACKAGE System::ResourceString _RSTrue;
#define O32sr_RSTrue System::LoadResourceString(&O32sr::_RSTrue)
extern DELPHI_PACKAGE System::ResourceString _RSFalse;
#define O32sr_RSFalse System::LoadResourceString(&O32sr::_RSFalse)
extern DELPHI_PACKAGE System::ResourceString _RSDescending;
#define O32sr_RSDescending System::LoadResourceString(&O32sr::_RSDescending)
extern DELPHI_PACKAGE System::ResourceString _RSDefaultIndex;
#define O32sr_RSDefaultIndex System::LoadResourceString(&O32sr::_RSDefaultIndex)
extern DELPHI_PACKAGE System::ResourceString _RSDuplicateCommand;
#define O32sr_RSDuplicateCommand System::LoadResourceString(&O32sr::_RSDuplicateCommand)
extern DELPHI_PACKAGE System::ResourceString _RSTableNotFound;
#define O32sr_RSTableNotFound System::LoadResourceString(&O32sr::_RSTableNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSNotDoneYet;
#define O32sr_RSNotDoneYet System::LoadResourceString(&O32sr::_RSNotDoneYet)
extern DELPHI_PACKAGE System::ResourceString _RSNoControllerAssigned;
#define O32sr_RSNoControllerAssigned System::LoadResourceString(&O32sr::_RSNoControllerAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSCantCreateCommandTable;
#define O32sr_RSCantCreateCommandTable System::LoadResourceString(&O32sr::_RSCantCreateCommandTable)
extern DELPHI_PACKAGE System::ResourceString _RSCantDelete;
#define O32sr_RSCantDelete System::LoadResourceString(&O32sr::_RSCantDelete)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidKeySequence;
#define O32sr_RSInvalidKeySequence System::LoadResourceString(&O32sr::_RSInvalidKeySequence)
extern DELPHI_PACKAGE System::ResourceString _RSNotWordStarCommands;
#define O32sr_RSNotWordStarCommands System::LoadResourceString(&O32sr::_RSNotWordStarCommands)
extern DELPHI_PACKAGE System::ResourceString _RSNoCommandSelected;
#define O32sr_RSNoCommandSelected System::LoadResourceString(&O32sr::_RSNoCommandSelected)
extern DELPHI_PACKAGE System::ResourceString _RSDuplicateKeySequence;
#define O32sr_RSDuplicateKeySequence System::LoadResourceString(&O32sr::_RSDuplicateKeySequence)
extern DELPHI_PACKAGE System::ResourceString _RSRangeError;
#define O32sr_RSRangeError System::LoadResourceString(&O32sr::_RSRangeError)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidNumber;
#define O32sr_RSInvalidNumber System::LoadResourceString(&O32sr::_RSInvalidNumber)
extern DELPHI_PACKAGE System::ResourceString _RSRequiredField;
#define O32sr_RSRequiredField System::LoadResourceString(&O32sr::_RSRequiredField)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDate;
#define O32sr_RSInvalidDate System::LoadResourceString(&O32sr::_RSInvalidDate)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidTime;
#define O32sr_RSInvalidTime System::LoadResourceString(&O32sr::_RSInvalidTime)
extern DELPHI_PACKAGE System::ResourceString _RSBlanksInField;
#define O32sr_RSBlanksInField System::LoadResourceString(&O32sr::_RSBlanksInField)
extern DELPHI_PACKAGE System::ResourceString _RSPartialEntry;
#define O32sr_RSPartialEntry System::LoadResourceString(&O32sr::_RSPartialEntry)
extern DELPHI_PACKAGE System::ResourceString _RSRegionTooLarge;
#define O32sr_RSRegionTooLarge System::LoadResourceString(&O32sr::_RSRegionTooLarge)
extern DELPHI_PACKAGE System::ResourceString _RSOutOfMemoryForCopy;
#define O32sr_RSOutOfMemoryForCopy System::LoadResourceString(&O32sr::_RSOutOfMemoryForCopy)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidParamValue;
#define O32sr_RSInvalidParamValue System::LoadResourceString(&O32sr::_RSInvalidParamValue)
extern DELPHI_PACKAGE System::ResourceString _RSNoTimersAvail;
#define O32sr_RSNoTimersAvail System::LoadResourceString(&O32sr::_RSNoTimersAvail)
extern DELPHI_PACKAGE System::ResourceString _RSTooManyEvents;
#define O32sr_RSTooManyEvents System::LoadResourceString(&O32sr::_RSTooManyEvents)
extern DELPHI_PACKAGE System::ResourceString _RSBadTriggerHandle;
#define O32sr_RSBadTriggerHandle System::LoadResourceString(&O32sr::_RSBadTriggerHandle)
extern DELPHI_PACKAGE System::ResourceString _RSOnSelectNotAssigned;
#define O32sr_RSOnSelectNotAssigned System::LoadResourceString(&O32sr::_RSOnSelectNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidPageIndex;
#define O32sr_RSInvalidPageIndex System::LoadResourceString(&O32sr::_RSInvalidPageIndex)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDataType;
#define O32sr_RSInvalidDataType System::LoadResourceString(&O32sr::_RSInvalidDataType)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidTabFont;
#define O32sr_RSInvalidTabFont System::LoadResourceString(&O32sr::_RSInvalidTabFont)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidLabelFont;
#define O32sr_RSInvalidLabelFont System::LoadResourceString(&O32sr::_RSInvalidLabelFont)
extern DELPHI_PACKAGE System::ResourceString _RSOutOfMemory;
#define O32sr_RSOutOfMemory System::LoadResourceString(&O32sr::_RSOutOfMemory)
extern DELPHI_PACKAGE System::ResourceString _RSTooManyParas;
#define O32sr_RSTooManyParas System::LoadResourceString(&O32sr::_RSTooManyParas)
extern DELPHI_PACKAGE System::ResourceString _RSCannotJoin;
#define O32sr_RSCannotJoin System::LoadResourceString(&O32sr::_RSCannotJoin)
extern DELPHI_PACKAGE System::ResourceString _RSTooManyBytes;
#define O32sr_RSTooManyBytes System::LoadResourceString(&O32sr::_RSTooManyBytes)
extern DELPHI_PACKAGE System::ResourceString _RSParaTooLong;
#define O32sr_RSParaTooLong System::LoadResourceString(&O32sr::_RSParaTooLong)
extern DELPHI_PACKAGE System::ResourceString _RSUnknownError;
#define O32sr_RSUnknownError System::LoadResourceString(&O32sr::_RSUnknownError)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidPictureMask;
#define O32sr_RSInvalidPictureMask System::LoadResourceString(&O32sr::_RSInvalidPictureMask)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidRange;
#define O32sr_RSInvalidRange System::LoadResourceString(&O32sr::_RSInvalidRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidRealRange;
#define O32sr_RSInvalidRealRange System::LoadResourceString(&O32sr::_RSInvalidRealRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidExtendedRange;
#define O32sr_RSInvalidExtendedRange System::LoadResourceString(&O32sr::_RSInvalidExtendedRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDoubleRange;
#define O32sr_RSInvalidDoubleRange System::LoadResourceString(&O32sr::_RSInvalidDoubleRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidSingleRange;
#define O32sr_RSInvalidSingleRange System::LoadResourceString(&O32sr::_RSInvalidSingleRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidCompRange;
#define O32sr_RSInvalidCompRange System::LoadResourceString(&O32sr::_RSInvalidCompRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDateRange;
#define O32sr_RSInvalidDateRange System::LoadResourceString(&O32sr::_RSInvalidDateRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidTimeRange;
#define O32sr_RSInvalidTimeRange System::LoadResourceString(&O32sr::_RSInvalidTimeRange)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidRangeValue;
#define O32sr_RSInvalidRangeValue System::LoadResourceString(&O32sr::_RSInvalidRangeValue)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidMinMaxValue;
#define O32sr_RSInvalidMinMaxValue System::LoadResourceString(&O32sr::_RSInvalidMinMaxValue)
extern DELPHI_PACKAGE System::ResourceString _RSRangeNotSupported;
#define O32sr_RSRangeNotSupported System::LoadResourceString(&O32sr::_RSRangeNotSupported)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidLineOrParaIndex;
#define O32sr_RSInvalidLineOrParaIndex System::LoadResourceString(&O32sr::_RSInvalidLineOrParaIndex)
extern DELPHI_PACKAGE System::ResourceString _RSNonFixedFont;
#define O32sr_RSNonFixedFont System::LoadResourceString(&O32sr::_RSNonFixedFont)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidFontParam;
#define O32sr_RSInvalidFontParam System::LoadResourceString(&O32sr::_RSInvalidFontParam)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidLineOrColumn;
#define O32sr_RSInvalidLineOrColumn System::LoadResourceString(&O32sr::_RSInvalidLineOrColumn)
extern DELPHI_PACKAGE System::ResourceString _RSSAEGeneral;
#define O32sr_RSSAEGeneral System::LoadResourceString(&O32sr::_RSSAEGeneral)
extern DELPHI_PACKAGE System::ResourceString _RSSAEAtMaxSize;
#define O32sr_RSSAEAtMaxSize System::LoadResourceString(&O32sr::_RSSAEAtMaxSize)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidXMLFile;
#define O32sr_RSInvalidXMLFile System::LoadResourceString(&O32sr::_RSInvalidXMLFile)
extern DELPHI_PACKAGE System::ResourceString _RSUnterminatedElement;
#define O32sr_RSUnterminatedElement System::LoadResourceString(&O32sr::_RSUnterminatedElement)
extern DELPHI_PACKAGE System::ResourceString _RSBadColorConstant;
#define O32sr_RSBadColorConstant System::LoadResourceString(&O32sr::_RSBadColorConstant)
extern DELPHI_PACKAGE System::ResourceString _RSBadColorValue;
#define O32sr_RSBadColorValue System::LoadResourceString(&O32sr::_RSBadColorValue)
extern DELPHI_PACKAGE System::ResourceString _RSSAEOutOfBounds;
#define O32sr_RSSAEOutOfBounds System::LoadResourceString(&O32sr::_RSSAEOutOfBounds)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidFieldType;
#define O32sr_RSInvalidFieldType System::LoadResourceString(&O32sr::_RSInvalidFieldType)
extern DELPHI_PACKAGE System::ResourceString _RSBadAlarmHandle;
#define O32sr_RSBadAlarmHandle System::LoadResourceString(&O32sr::_RSBadAlarmHandle)
extern DELPHI_PACKAGE System::ResourceString _RSOnIsSelectedNotAssigned;
#define O32sr_RSOnIsSelectedNotAssigned System::LoadResourceString(&O32sr::_RSOnIsSelectedNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDateForMask;
#define O32sr_RSInvalidDateForMask System::LoadResourceString(&O32sr::_RSInvalidDateForMask)
extern DELPHI_PACKAGE System::ResourceString _RSViewerIOError;
#define O32sr_RSViewerIOError System::LoadResourceString(&O32sr::_RSViewerIOError)
extern DELPHI_PACKAGE System::ResourceString _RSViewerFileNotFound;
#define O32sr_RSViewerFileNotFound System::LoadResourceString(&O32sr::_RSViewerFileNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSViewerPathNotFound;
#define O32sr_RSViewerPathNotFound System::LoadResourceString(&O32sr::_RSViewerPathNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSViewerTooManyOpenFiles;
#define O32sr_RSViewerTooManyOpenFiles System::LoadResourceString(&O32sr::_RSViewerTooManyOpenFiles)
extern DELPHI_PACKAGE System::ResourceString _RSViewerFileAccessDenied;
#define O32sr_RSViewerFileAccessDenied System::LoadResourceString(&O32sr::_RSViewerFileAccessDenied)
extern DELPHI_PACKAGE System::ResourceString _RSControlAttached;
#define O32sr_RSControlAttached System::LoadResourceString(&O32sr::_RSControlAttached)
extern DELPHI_PACKAGE System::ResourceString _RSCantEdit;
#define O32sr_RSCantEdit System::LoadResourceString(&O32sr::_RSCantEdit)
extern DELPHI_PACKAGE System::ResourceString _RSChildTableError;
#define O32sr_RSChildTableError System::LoadResourceString(&O32sr::_RSChildTableError)
extern DELPHI_PACKAGE System::ResourceString _RSNoTableAttached;
#define O32sr_RSNoTableAttached System::LoadResourceString(&O32sr::_RSNoTableAttached)
extern DELPHI_PACKAGE System::ResourceString _RSNoCollection;
#define O32sr_RSNoCollection System::LoadResourceString(&O32sr::_RSNoCollection)
extern DELPHI_PACKAGE System::ResourceString _RSNotOvcDescendant;
#define O32sr_RSNotOvcDescendant System::LoadResourceString(&O32sr::_RSNotOvcDescendant)
extern DELPHI_PACKAGE System::ResourceString _RSItemIncompatible;
#define O32sr_RSItemIncompatible System::LoadResourceString(&O32sr::_RSItemIncompatible)
extern DELPHI_PACKAGE System::ResourceString _RSLabelNotAttached;
#define O32sr_RSLabelNotAttached System::LoadResourceString(&O32sr::_RSLabelNotAttached)
extern DELPHI_PACKAGE System::ResourceString _RSClassNotSet;
#define O32sr_RSClassNotSet System::LoadResourceString(&O32sr::_RSClassNotSet)
extern DELPHI_PACKAGE System::ResourceString _RSCollectionNotFound;
#define O32sr_RSCollectionNotFound System::LoadResourceString(&O32sr::_RSCollectionNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSDayConvertError;
#define O32sr_RSDayConvertError System::LoadResourceString(&O32sr::_RSDayConvertError)
extern DELPHI_PACKAGE System::ResourceString _RSMonthConvertError;
#define O32sr_RSMonthConvertError System::LoadResourceString(&O32sr::_RSMonthConvertError)
extern DELPHI_PACKAGE System::ResourceString _RSMonthNameConvertError;
#define O32sr_RSMonthNameConvertError System::LoadResourceString(&O32sr::_RSMonthNameConvertError)
extern DELPHI_PACKAGE System::ResourceString _RSYearConvertError;
#define O32sr_RSYearConvertError System::LoadResourceString(&O32sr::_RSYearConvertError)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidDay;
#define O32sr_RSInvalidDay System::LoadResourceString(&O32sr::_RSInvalidDay)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidMonth;
#define O32sr_RSInvalidMonth System::LoadResourceString(&O32sr::_RSInvalidMonth)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidMonthName;
#define O32sr_RSInvalidMonthName System::LoadResourceString(&O32sr::_RSInvalidMonthName)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidYear;
#define O32sr_RSInvalidYear System::LoadResourceString(&O32sr::_RSInvalidYear)
extern DELPHI_PACKAGE System::ResourceString _RSDayRequired;
#define O32sr_RSDayRequired System::LoadResourceString(&O32sr::_RSDayRequired)
extern DELPHI_PACKAGE System::ResourceString _RSMonthRequired;
#define O32sr_RSMonthRequired System::LoadResourceString(&O32sr::_RSMonthRequired)
extern DELPHI_PACKAGE System::ResourceString _RSYearRequired;
#define O32sr_RSYearRequired System::LoadResourceString(&O32sr::_RSYearRequired)
extern DELPHI_PACKAGE System::ResourceString _RSOwnerMustBeForm;
#define O32sr_RSOwnerMustBeForm System::LoadResourceString(&O32sr::_RSOwnerMustBeForm)
extern DELPHI_PACKAGE System::ResourceString _RSTimeConvertError;
#define O32sr_RSTimeConvertError System::LoadResourceString(&O32sr::_RSTimeConvertError)
extern DELPHI_PACKAGE System::ResourceString _RSCancelQuery;
#define O32sr_RSCancelQuery System::LoadResourceString(&O32sr::_RSCancelQuery)
extern DELPHI_PACKAGE System::ResourceString _RSNoPagesAssigned;
#define O32sr_RSNoPagesAssigned System::LoadResourceString(&O32sr::_RSNoPagesAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSRestoreMI;
#define O32sr_RSRestoreMI System::LoadResourceString(&O32sr::_RSRestoreMI)
extern DELPHI_PACKAGE System::ResourceString _RSCutMI;
#define O32sr_RSCutMI System::LoadResourceString(&O32sr::_RSCutMI)
extern DELPHI_PACKAGE System::ResourceString _RSCopyMI;
#define O32sr_RSCopyMI System::LoadResourceString(&O32sr::_RSCopyMI)
extern DELPHI_PACKAGE System::ResourceString _RSPasteMI;
#define O32sr_RSPasteMI System::LoadResourceString(&O32sr::_RSPasteMI)
extern DELPHI_PACKAGE System::ResourceString _RSDeleteMI;
#define O32sr_RSDeleteMI System::LoadResourceString(&O32sr::_RSDeleteMI)
extern DELPHI_PACKAGE System::ResourceString _RSSelectAllMI;
#define O32sr_RSSelectAllMI System::LoadResourceString(&O32sr::_RSSelectAllMI)
extern DELPHI_PACKAGE System::ResourceString _RSTableRowOutOfBounds;
#define O32sr_RSTableRowOutOfBounds System::LoadResourceString(&O32sr::_RSTableRowOutOfBounds)
extern DELPHI_PACKAGE System::ResourceString _RSTableMaxRows;
#define O32sr_RSTableMaxRows System::LoadResourceString(&O32sr::_RSTableMaxRows)
extern DELPHI_PACKAGE System::ResourceString _RSTableMaxColumns;
#define O32sr_RSTableMaxColumns System::LoadResourceString(&O32sr::_RSTableMaxColumns)
extern DELPHI_PACKAGE System::ResourceString _RSTableGeneral;
#define O32sr_RSTableGeneral System::LoadResourceString(&O32sr::_RSTableGeneral)
extern DELPHI_PACKAGE System::ResourceString _RSTableToManyColumns;
#define O32sr_RSTableToManyColumns System::LoadResourceString(&O32sr::_RSTableToManyColumns)
extern DELPHI_PACKAGE System::ResourceString _RSTableInvalidFieldIndex;
#define O32sr_RSTableInvalidFieldIndex System::LoadResourceString(&O32sr::_RSTableInvalidFieldIndex)
extern DELPHI_PACKAGE System::ResourceString _RSTableHeaderNotAssigned;
#define O32sr_RSTableHeaderNotAssigned System::LoadResourceString(&O32sr::_RSTableHeaderNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSTableInvalidHeaderCell;
#define O32sr_RSTableInvalidHeaderCell System::LoadResourceString(&O32sr::_RSTableInvalidHeaderCell)
extern DELPHI_PACKAGE System::ResourceString _RSTableInvalidData;
#define O32sr_RSTableInvalidData System::LoadResourceString(&O32sr::_RSTableInvalidData)
extern DELPHI_PACKAGE System::ResourceString _RSCalcBack;
#define O32sr_RSCalcBack System::LoadResourceString(&O32sr::_RSCalcBack)
extern DELPHI_PACKAGE System::ResourceString _RSCalcMC;
#define O32sr_RSCalcMC System::LoadResourceString(&O32sr::_RSCalcMC)
extern DELPHI_PACKAGE System::ResourceString _RSCalcMR;
#define O32sr_RSCalcMR System::LoadResourceString(&O32sr::_RSCalcMR)
extern DELPHI_PACKAGE System::ResourceString _RSCalcMS;
#define O32sr_RSCalcMS System::LoadResourceString(&O32sr::_RSCalcMS)
extern DELPHI_PACKAGE System::ResourceString _RSCalcMPlus;
#define O32sr_RSCalcMPlus System::LoadResourceString(&O32sr::_RSCalcMPlus)
extern DELPHI_PACKAGE System::ResourceString _RSCalcMMinus;
#define O32sr_RSCalcMMinus System::LoadResourceString(&O32sr::_RSCalcMMinus)
extern DELPHI_PACKAGE System::ResourceString _RSCalcCT;
#define O32sr_RSCalcCT System::LoadResourceString(&O32sr::_RSCalcCT)
extern DELPHI_PACKAGE System::ResourceString _RSCalcCE;
#define O32sr_RSCalcCE System::LoadResourceString(&O32sr::_RSCalcCE)
extern DELPHI_PACKAGE System::ResourceString _RSCalcC;
#define O32sr_RSCalcC System::LoadResourceString(&O32sr::_RSCalcC)
extern DELPHI_PACKAGE System::ResourceString _RSCalcSqrt;
#define O32sr_RSCalcSqrt System::LoadResourceString(&O32sr::_RSCalcSqrt)
extern DELPHI_PACKAGE System::ResourceString _RSCalNext;
#define O32sr_RSCalNext System::LoadResourceString(&O32sr::_RSCalNext)
extern DELPHI_PACKAGE System::ResourceString _RSCalLast;
#define O32sr_RSCalLast System::LoadResourceString(&O32sr::_RSCalLast)
extern DELPHI_PACKAGE System::ResourceString _RSCalPrev;
#define O32sr_RSCalPrev System::LoadResourceString(&O32sr::_RSCalPrev)
extern DELPHI_PACKAGE System::ResourceString _RSCalFirst;
#define O32sr_RSCalFirst System::LoadResourceString(&O32sr::_RSCalFirst)
extern DELPHI_PACKAGE System::ResourceString _RSCal1st;
#define O32sr_RSCal1st System::LoadResourceString(&O32sr::_RSCal1st)
extern DELPHI_PACKAGE System::ResourceString _RSCalSecond;
#define O32sr_RSCalSecond System::LoadResourceString(&O32sr::_RSCalSecond)
extern DELPHI_PACKAGE System::ResourceString _RSCal2nd;
#define O32sr_RSCal2nd System::LoadResourceString(&O32sr::_RSCal2nd)
extern DELPHI_PACKAGE System::ResourceString _RSCalThird;
#define O32sr_RSCalThird System::LoadResourceString(&O32sr::_RSCalThird)
extern DELPHI_PACKAGE System::ResourceString _RSCal3rd;
#define O32sr_RSCal3rd System::LoadResourceString(&O32sr::_RSCal3rd)
extern DELPHI_PACKAGE System::ResourceString _RSCalFourth;
#define O32sr_RSCalFourth System::LoadResourceString(&O32sr::_RSCalFourth)
extern DELPHI_PACKAGE System::ResourceString _RSCal4th;
#define O32sr_RSCal4th System::LoadResourceString(&O32sr::_RSCal4th)
extern DELPHI_PACKAGE System::ResourceString _RSCalFinal;
#define O32sr_RSCalFinal System::LoadResourceString(&O32sr::_RSCalFinal)
extern DELPHI_PACKAGE System::ResourceString _RSCalBOM;
#define O32sr_RSCalBOM System::LoadResourceString(&O32sr::_RSCalBOM)
extern DELPHI_PACKAGE System::ResourceString _RSCalBegin;
#define O32sr_RSCalBegin System::LoadResourceString(&O32sr::_RSCalBegin)
extern DELPHI_PACKAGE System::ResourceString _RSCalEOM;
#define O32sr_RSCalEOM System::LoadResourceString(&O32sr::_RSCalEOM)
extern DELPHI_PACKAGE System::ResourceString _RSCalEnd;
#define O32sr_RSCalEnd System::LoadResourceString(&O32sr::_RSCalEnd)
extern DELPHI_PACKAGE System::ResourceString _RSCalYesterday;
#define O32sr_RSCalYesterday System::LoadResourceString(&O32sr::_RSCalYesterday)
extern DELPHI_PACKAGE System::ResourceString _RSCalToday;
#define O32sr_RSCalToday System::LoadResourceString(&O32sr::_RSCalToday)
extern DELPHI_PACKAGE System::ResourceString _RSCalTomorrow;
#define O32sr_RSCalTomorrow System::LoadResourceString(&O32sr::_RSCalTomorrow)
extern DELPHI_PACKAGE System::ResourceString _RSEditingSections;
#define O32sr_RSEditingSections System::LoadResourceString(&O32sr::_RSEditingSections)
extern DELPHI_PACKAGE System::ResourceString _RSEditingItems;
#define O32sr_RSEditingItems System::LoadResourceString(&O32sr::_RSEditingItems)
extern DELPHI_PACKAGE System::ResourceString _RSEditingFolders;
#define O32sr_RSEditingFolders System::LoadResourceString(&O32sr::_RSEditingFolders)
extern DELPHI_PACKAGE System::ResourceString _RSEditingPages;
#define O32sr_RSEditingPages System::LoadResourceString(&O32sr::_RSEditingPages)
extern DELPHI_PACKAGE System::ResourceString _RSEditingImages;
#define O32sr_RSEditingImages System::LoadResourceString(&O32sr::_RSEditingImages)
extern DELPHI_PACKAGE System::ResourceString _RSSectionBaseName;
#define O32sr_RSSectionBaseName System::LoadResourceString(&O32sr::_RSSectionBaseName)
extern DELPHI_PACKAGE System::ResourceString _RSItemBaseName;
#define O32sr_RSItemBaseName System::LoadResourceString(&O32sr::_RSItemBaseName)
extern DELPHI_PACKAGE System::ResourceString _RSFolderBaseName;
#define O32sr_RSFolderBaseName System::LoadResourceString(&O32sr::_RSFolderBaseName)
extern DELPHI_PACKAGE System::ResourceString _RSPageBaseName;
#define O32sr_RSPageBaseName System::LoadResourceString(&O32sr::_RSPageBaseName)
extern DELPHI_PACKAGE System::ResourceString _RSImageBaseName;
#define O32sr_RSImageBaseName System::LoadResourceString(&O32sr::_RSImageBaseName)
extern DELPHI_PACKAGE System::ResourceString _RSHoursName;
#define O32sr_RSHoursName System::LoadResourceString(&O32sr::_RSHoursName)
extern DELPHI_PACKAGE System::ResourceString _RSMinutesName;
#define O32sr_RSMinutesName System::LoadResourceString(&O32sr::_RSMinutesName)
extern DELPHI_PACKAGE System::ResourceString _RSSecondsName;
#define O32sr_RSSecondsName System::LoadResourceString(&O32sr::_RSSecondsName)
extern DELPHI_PACKAGE System::ResourceString _RSCloseCaption;
#define O32sr_RSCloseCaption System::LoadResourceString(&O32sr::_RSCloseCaption)
extern DELPHI_PACKAGE System::ResourceString _RSViewFieldNotFound;
#define O32sr_RSViewFieldNotFound System::LoadResourceString(&O32sr::_RSViewFieldNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSCantResolveField;
#define O32sr_RSCantResolveField System::LoadResourceString(&O32sr::_RSCantResolveField)
extern DELPHI_PACKAGE System::ResourceString _RSItemAlreadyExists;
#define O32sr_RSItemAlreadyExists System::LoadResourceString(&O32sr::_RSItemAlreadyExists)
extern DELPHI_PACKAGE System::ResourceString _RSAlreadyInTempMode;
#define O32sr_RSAlreadyInTempMode System::LoadResourceString(&O32sr::_RSAlreadyInTempMode)
extern DELPHI_PACKAGE System::ResourceString _RSItemNotFound;
#define O32sr_RSItemNotFound System::LoadResourceString(&O32sr::_RSItemNotFound)
extern DELPHI_PACKAGE System::ResourceString _RSUpdatePending;
#define O32sr_RSUpdatePending System::LoadResourceString(&O32sr::_RSUpdatePending)
extern DELPHI_PACKAGE System::ResourceString _RSOnCompareNotAssigned;
#define O32sr_RSOnCompareNotAssigned System::LoadResourceString(&O32sr::_RSOnCompareNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSOnFilterNotAssigned;
#define O32sr_RSOnFilterNotAssigned System::LoadResourceString(&O32sr::_RSOnFilterNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSGetAsFloatNotAssigned;
#define O32sr_RSGetAsFloatNotAssigned System::LoadResourceString(&O32sr::_RSGetAsFloatNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSNotInTempMode;
#define O32sr_RSNotInTempMode System::LoadResourceString(&O32sr::_RSNotInTempMode)
extern DELPHI_PACKAGE System::ResourceString _RSItemNotInIndex;
#define O32sr_RSItemNotInIndex System::LoadResourceString(&O32sr::_RSItemNotInIndex)
extern DELPHI_PACKAGE System::ResourceString _RSNoActiveView;
#define O32sr_RSNoActiveView System::LoadResourceString(&O32sr::_RSNoActiveView)
extern DELPHI_PACKAGE System::ResourceString _RSItemIsNotGroup;
#define O32sr_RSItemIsNotGroup System::LoadResourceString(&O32sr::_RSItemIsNotGroup)
extern DELPHI_PACKAGE System::ResourceString _RSNotMultiSelect;
#define O32sr_RSNotMultiSelect System::LoadResourceString(&O32sr::_RSNotMultiSelect)
extern DELPHI_PACKAGE System::ResourceString _RSLineNoOutOfRange;
#define O32sr_RSLineNoOutOfRange System::LoadResourceString(&O32sr::_RSLineNoOutOfRange)
extern DELPHI_PACKAGE System::ResourceString _RSUnknownView;
#define O32sr_RSUnknownView System::LoadResourceString(&O32sr::_RSUnknownView)
extern DELPHI_PACKAGE System::ResourceString _RSOnKeySearchNotAssigned;
#define O32sr_RSOnKeySearchNotAssigned System::LoadResourceString(&O32sr::_RSOnKeySearchNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSOnEnumNotAssigned;
#define O32sr_RSOnEnumNotAssigned System::LoadResourceString(&O32sr::_RSOnEnumNotAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSOnEnumSelectedNA;
#define O32sr_RSOnEnumSelectedNA System::LoadResourceString(&O32sr::_RSOnEnumSelectedNA)
extern DELPHI_PACKAGE System::ResourceString _RSNoMenuAssigned;
#define O32sr_RSNoMenuAssigned System::LoadResourceString(&O32sr::_RSNoMenuAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSNoAnchorAssigned;
#define O32sr_RSNoAnchorAssigned System::LoadResourceString(&O32sr::_RSNoAnchorAssigned)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidParameter;
#define O32sr_RSInvalidParameter System::LoadResourceString(&O32sr::_RSInvalidParameter)
extern DELPHI_PACKAGE System::ResourceString _RSInvalidOperation;
#define O32sr_RSInvalidOperation System::LoadResourceString(&O32sr::_RSInvalidOperation)
extern DELPHI_PACKAGE System::ResourceString _RSFormUseOnly;
#define O32sr_RSFormUseOnly System::LoadResourceString(&O32sr::_RSFormUseOnly)
extern DELPHI_PACKAGE System::ResourceString _RSColorBlack;
#define O32sr_RSColorBlack System::LoadResourceString(&O32sr::_RSColorBlack)
extern DELPHI_PACKAGE System::ResourceString _RSColorMaroon;
#define O32sr_RSColorMaroon System::LoadResourceString(&O32sr::_RSColorMaroon)
extern DELPHI_PACKAGE System::ResourceString _RSColorGreen;
#define O32sr_RSColorGreen System::LoadResourceString(&O32sr::_RSColorGreen)
extern DELPHI_PACKAGE System::ResourceString _RSColorOlive;
#define O32sr_RSColorOlive System::LoadResourceString(&O32sr::_RSColorOlive)
extern DELPHI_PACKAGE System::ResourceString _RSColorNavy;
#define O32sr_RSColorNavy System::LoadResourceString(&O32sr::_RSColorNavy)
extern DELPHI_PACKAGE System::ResourceString _RSColorPurple;
#define O32sr_RSColorPurple System::LoadResourceString(&O32sr::_RSColorPurple)
extern DELPHI_PACKAGE System::ResourceString _RSColorTeal;
#define O32sr_RSColorTeal System::LoadResourceString(&O32sr::_RSColorTeal)
extern DELPHI_PACKAGE System::ResourceString _RSColorGray;
#define O32sr_RSColorGray System::LoadResourceString(&O32sr::_RSColorGray)
extern DELPHI_PACKAGE System::ResourceString _RSColorSilver;
#define O32sr_RSColorSilver System::LoadResourceString(&O32sr::_RSColorSilver)
extern DELPHI_PACKAGE System::ResourceString _RSColorRed;
#define O32sr_RSColorRed System::LoadResourceString(&O32sr::_RSColorRed)
extern DELPHI_PACKAGE System::ResourceString _RSColorLime;
#define O32sr_RSColorLime System::LoadResourceString(&O32sr::_RSColorLime)
extern DELPHI_PACKAGE System::ResourceString _RSColorYellow;
#define O32sr_RSColorYellow System::LoadResourceString(&O32sr::_RSColorYellow)
extern DELPHI_PACKAGE System::ResourceString _RSColorBlue;
#define O32sr_RSColorBlue System::LoadResourceString(&O32sr::_RSColorBlue)
extern DELPHI_PACKAGE System::ResourceString _RSColorFuchsia;
#define O32sr_RSColorFuchsia System::LoadResourceString(&O32sr::_RSColorFuchsia)
extern DELPHI_PACKAGE System::ResourceString _RSColorAqua;
#define O32sr_RSColorAqua System::LoadResourceString(&O32sr::_RSColorAqua)
extern DELPHI_PACKAGE System::ResourceString _RSColorWhite;
#define O32sr_RSColorWhite System::LoadResourceString(&O32sr::_RSColorWhite)
extern DELPHI_PACKAGE System::ResourceString _RSColorLightGray;
#define O32sr_RSColorLightGray System::LoadResourceString(&O32sr::_RSColorLightGray)
extern DELPHI_PACKAGE System::ResourceString _RSColorMediumGray;
#define O32sr_RSColorMediumGray System::LoadResourceString(&O32sr::_RSColorMediumGray)
extern DELPHI_PACKAGE System::ResourceString _RSColorDarkGray;
#define O32sr_RSColorDarkGray System::LoadResourceString(&O32sr::_RSColorDarkGray)
extern DELPHI_PACKAGE System::ResourceString _RSColorMoneyGreen;
#define O32sr_RSColorMoneyGreen System::LoadResourceString(&O32sr::_RSColorMoneyGreen)
extern DELPHI_PACKAGE System::ResourceString _RSColorSkyBlue;
#define O32sr_RSColorSkyBlue System::LoadResourceString(&O32sr::_RSColorSkyBlue)
extern DELPHI_PACKAGE System::ResourceString _RSColorCream;
#define O32sr_RSColorCream System::LoadResourceString(&O32sr::_RSColorCream)
extern DELPHI_PACKAGE System::ResourceString _ccNoneStr;
#define O32sr_ccNoneStr System::LoadResourceString(&O32sr::_ccNoneStr)
extern DELPHI_PACKAGE System::ResourceString _ccBackStr;
#define O32sr_ccBackStr System::LoadResourceString(&O32sr::_ccBackStr)
extern DELPHI_PACKAGE System::ResourceString _ccBotOfPageStr;
#define O32sr_ccBotOfPageStr System::LoadResourceString(&O32sr::_ccBotOfPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccBotRightCellStr;
#define O32sr_ccBotRightCellStr System::LoadResourceString(&O32sr::_ccBotRightCellStr)
extern DELPHI_PACKAGE System::ResourceString _ccCompleteDateStr;
#define O32sr_ccCompleteDateStr System::LoadResourceString(&O32sr::_ccCompleteDateStr)
extern DELPHI_PACKAGE System::ResourceString _ccCompleteTimeStr;
#define O32sr_ccCompleteTimeStr System::LoadResourceString(&O32sr::_ccCompleteTimeStr)
extern DELPHI_PACKAGE System::ResourceString _ccCopyStr;
#define O32sr_ccCopyStr System::LoadResourceString(&O32sr::_ccCopyStr)
extern DELPHI_PACKAGE System::ResourceString _ccCtrlCharStr;
#define O32sr_ccCtrlCharStr System::LoadResourceString(&O32sr::_ccCtrlCharStr)
extern DELPHI_PACKAGE System::ResourceString _ccCutStr;
#define O32sr_ccCutStr System::LoadResourceString(&O32sr::_ccCutStr)
extern DELPHI_PACKAGE System::ResourceString _ccDecStr;
#define O32sr_ccDecStr System::LoadResourceString(&O32sr::_ccDecStr)
extern DELPHI_PACKAGE System::ResourceString _ccDelStr;
#define O32sr_ccDelStr System::LoadResourceString(&O32sr::_ccDelStr)
extern DELPHI_PACKAGE System::ResourceString _ccDelBolStr;
#define O32sr_ccDelBolStr System::LoadResourceString(&O32sr::_ccDelBolStr)
extern DELPHI_PACKAGE System::ResourceString _ccDelEolStr;
#define O32sr_ccDelEolStr System::LoadResourceString(&O32sr::_ccDelEolStr)
extern DELPHI_PACKAGE System::ResourceString _ccDelLineStr;
#define O32sr_ccDelLineStr System::LoadResourceString(&O32sr::_ccDelLineStr)
extern DELPHI_PACKAGE System::ResourceString _ccDelWordStr;
#define O32sr_ccDelWordStr System::LoadResourceString(&O32sr::_ccDelWordStr)
extern DELPHI_PACKAGE System::ResourceString _ccDownStr;
#define O32sr_ccDownStr System::LoadResourceString(&O32sr::_ccDownStr)
extern DELPHI_PACKAGE System::ResourceString _ccEndStr;
#define O32sr_ccEndStr System::LoadResourceString(&O32sr::_ccEndStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendDownStr;
#define O32sr_ccExtendDownStr System::LoadResourceString(&O32sr::_ccExtendDownStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendEndStr;
#define O32sr_ccExtendEndStr System::LoadResourceString(&O32sr::_ccExtendEndStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendHomeStr;
#define O32sr_ccExtendHomeStr System::LoadResourceString(&O32sr::_ccExtendHomeStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendLeftStr;
#define O32sr_ccExtendLeftStr System::LoadResourceString(&O32sr::_ccExtendLeftStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendPgDnStr;
#define O32sr_ccExtendPgDnStr System::LoadResourceString(&O32sr::_ccExtendPgDnStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendPgUpStr;
#define O32sr_ccExtendPgUpStr System::LoadResourceString(&O32sr::_ccExtendPgUpStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendRightStr;
#define O32sr_ccExtendRightStr System::LoadResourceString(&O32sr::_ccExtendRightStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtendUpStr;
#define O32sr_ccExtendUpStr System::LoadResourceString(&O32sr::_ccExtendUpStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtBotOfPageStr;
#define O32sr_ccExtBotOfPageStr System::LoadResourceString(&O32sr::_ccExtBotOfPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtFirstPageStr;
#define O32sr_ccExtFirstPageStr System::LoadResourceString(&O32sr::_ccExtFirstPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtLastPageStr;
#define O32sr_ccExtLastPageStr System::LoadResourceString(&O32sr::_ccExtLastPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtTopOfPageStr;
#define O32sr_ccExtTopOfPageStr System::LoadResourceString(&O32sr::_ccExtTopOfPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtWordLeftStr;
#define O32sr_ccExtWordLeftStr System::LoadResourceString(&O32sr::_ccExtWordLeftStr)
extern DELPHI_PACKAGE System::ResourceString _ccExtWordRightStr;
#define O32sr_ccExtWordRightStr System::LoadResourceString(&O32sr::_ccExtWordRightStr)
extern DELPHI_PACKAGE System::ResourceString _ccFirstPageStr;
#define O32sr_ccFirstPageStr System::LoadResourceString(&O32sr::_ccFirstPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker0Str;
#define O32sr_ccGotoMarker0Str System::LoadResourceString(&O32sr::_ccGotoMarker0Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker1Str;
#define O32sr_ccGotoMarker1Str System::LoadResourceString(&O32sr::_ccGotoMarker1Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker2Str;
#define O32sr_ccGotoMarker2Str System::LoadResourceString(&O32sr::_ccGotoMarker2Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker3Str;
#define O32sr_ccGotoMarker3Str System::LoadResourceString(&O32sr::_ccGotoMarker3Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker4Str;
#define O32sr_ccGotoMarker4Str System::LoadResourceString(&O32sr::_ccGotoMarker4Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker5Str;
#define O32sr_ccGotoMarker5Str System::LoadResourceString(&O32sr::_ccGotoMarker5Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker6Str;
#define O32sr_ccGotoMarker6Str System::LoadResourceString(&O32sr::_ccGotoMarker6Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker7Str;
#define O32sr_ccGotoMarker7Str System::LoadResourceString(&O32sr::_ccGotoMarker7Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker8Str;
#define O32sr_ccGotoMarker8Str System::LoadResourceString(&O32sr::_ccGotoMarker8Str)
extern DELPHI_PACKAGE System::ResourceString _ccGotoMarker9Str;
#define O32sr_ccGotoMarker9Str System::LoadResourceString(&O32sr::_ccGotoMarker9Str)
extern DELPHI_PACKAGE System::ResourceString _ccHomeStr;
#define O32sr_ccHomeStr System::LoadResourceString(&O32sr::_ccHomeStr)
extern DELPHI_PACKAGE System::ResourceString _ccIncStr;
#define O32sr_ccIncStr System::LoadResourceString(&O32sr::_ccIncStr)
extern DELPHI_PACKAGE System::ResourceString _ccInsStr;
#define O32sr_ccInsStr System::LoadResourceString(&O32sr::_ccInsStr)
extern DELPHI_PACKAGE System::ResourceString _ccLastPageStr;
#define O32sr_ccLastPageStr System::LoadResourceString(&O32sr::_ccLastPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccLeftStr;
#define O32sr_ccLeftStr System::LoadResourceString(&O32sr::_ccLeftStr)
extern DELPHI_PACKAGE System::ResourceString _ccNewLineStr;
#define O32sr_ccNewLineStr System::LoadResourceString(&O32sr::_ccNewLineStr)
extern DELPHI_PACKAGE System::ResourceString _ccNextPageStr;
#define O32sr_ccNextPageStr System::LoadResourceString(&O32sr::_ccNextPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccPageLeftStr;
#define O32sr_ccPageLeftStr System::LoadResourceString(&O32sr::_ccPageLeftStr)
extern DELPHI_PACKAGE System::ResourceString _ccPageRightStr;
#define O32sr_ccPageRightStr System::LoadResourceString(&O32sr::_ccPageRightStr)
extern DELPHI_PACKAGE System::ResourceString _ccPasteStr;
#define O32sr_ccPasteStr System::LoadResourceString(&O32sr::_ccPasteStr)
extern DELPHI_PACKAGE System::ResourceString _ccPrevPageStr;
#define O32sr_ccPrevPageStr System::LoadResourceString(&O32sr::_ccPrevPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccRedoStr;
#define O32sr_ccRedoStr System::LoadResourceString(&O32sr::_ccRedoStr)
extern DELPHI_PACKAGE System::ResourceString _ccRestoreStr;
#define O32sr_ccRestoreStr System::LoadResourceString(&O32sr::_ccRestoreStr)
extern DELPHI_PACKAGE System::ResourceString _ccRightStr;
#define O32sr_ccRightStr System::LoadResourceString(&O32sr::_ccRightStr)
extern DELPHI_PACKAGE System::ResourceString _ccScrollDownStr;
#define O32sr_ccScrollDownStr System::LoadResourceString(&O32sr::_ccScrollDownStr)
extern DELPHI_PACKAGE System::ResourceString _ccScrollUpStr;
#define O32sr_ccScrollUpStr System::LoadResourceString(&O32sr::_ccScrollUpStr)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker0Str;
#define O32sr_ccSetMarker0Str System::LoadResourceString(&O32sr::_ccSetMarker0Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker1Str;
#define O32sr_ccSetMarker1Str System::LoadResourceString(&O32sr::_ccSetMarker1Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker2Str;
#define O32sr_ccSetMarker2Str System::LoadResourceString(&O32sr::_ccSetMarker2Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker3Str;
#define O32sr_ccSetMarker3Str System::LoadResourceString(&O32sr::_ccSetMarker3Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker4Str;
#define O32sr_ccSetMarker4Str System::LoadResourceString(&O32sr::_ccSetMarker4Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker5Str;
#define O32sr_ccSetMarker5Str System::LoadResourceString(&O32sr::_ccSetMarker5Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker6Str;
#define O32sr_ccSetMarker6Str System::LoadResourceString(&O32sr::_ccSetMarker6Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker7Str;
#define O32sr_ccSetMarker7Str System::LoadResourceString(&O32sr::_ccSetMarker7Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker8Str;
#define O32sr_ccSetMarker8Str System::LoadResourceString(&O32sr::_ccSetMarker8Str)
extern DELPHI_PACKAGE System::ResourceString _ccSetMarker9Str;
#define O32sr_ccSetMarker9Str System::LoadResourceString(&O32sr::_ccSetMarker9Str)
extern DELPHI_PACKAGE System::ResourceString _ccTabStr;
#define O32sr_ccTabStr System::LoadResourceString(&O32sr::_ccTabStr)
extern DELPHI_PACKAGE System::ResourceString _ccTableEditStr;
#define O32sr_ccTableEditStr System::LoadResourceString(&O32sr::_ccTableEditStr)
extern DELPHI_PACKAGE System::ResourceString _ccTopLeftCellStr;
#define O32sr_ccTopLeftCellStr System::LoadResourceString(&O32sr::_ccTopLeftCellStr)
extern DELPHI_PACKAGE System::ResourceString _ccTopOfPageStr;
#define O32sr_ccTopOfPageStr System::LoadResourceString(&O32sr::_ccTopOfPageStr)
extern DELPHI_PACKAGE System::ResourceString _ccUndoStr;
#define O32sr_ccUndoStr System::LoadResourceString(&O32sr::_ccUndoStr)
extern DELPHI_PACKAGE System::ResourceString _ccUpStr;
#define O32sr_ccUpStr System::LoadResourceString(&O32sr::_ccUpStr)
extern DELPHI_PACKAGE System::ResourceString _ccWordLeftStr;
#define O32sr_ccWordLeftStr System::LoadResourceString(&O32sr::_ccWordLeftStr)
extern DELPHI_PACKAGE System::ResourceString _ccWordRightStr;
#define O32sr_ccWordRightStr System::LoadResourceString(&O32sr::_ccWordRightStr)
extern DELPHI_PACKAGE System::ResourceString _StringStr;
#define O32sr_StringStr System::LoadResourceString(&O32sr::_StringStr)
extern DELPHI_PACKAGE System::ResourceString _CharStr;
#define O32sr_CharStr System::LoadResourceString(&O32sr::_CharStr)
extern DELPHI_PACKAGE System::ResourceString _BooleanStr;
#define O32sr_BooleanStr System::LoadResourceString(&O32sr::_BooleanStr)
extern DELPHI_PACKAGE System::ResourceString _YesNoStr;
#define O32sr_YesNoStr System::LoadResourceString(&O32sr::_YesNoStr)
extern DELPHI_PACKAGE System::ResourceString _LongIntStr;
#define O32sr_LongIntStr System::LoadResourceString(&O32sr::_LongIntStr)
extern DELPHI_PACKAGE System::ResourceString _WordStr;
#define O32sr_WordStr System::LoadResourceString(&O32sr::_WordStr)
extern DELPHI_PACKAGE System::ResourceString _SmallIntStr;
#define O32sr_SmallIntStr System::LoadResourceString(&O32sr::_SmallIntStr)
extern DELPHI_PACKAGE System::ResourceString _ByteStr;
#define O32sr_ByteStr System::LoadResourceString(&O32sr::_ByteStr)
extern DELPHI_PACKAGE System::ResourceString _ShortIntStr;
#define O32sr_ShortIntStr System::LoadResourceString(&O32sr::_ShortIntStr)
extern DELPHI_PACKAGE System::ResourceString _RealStr;
#define O32sr_RealStr System::LoadResourceString(&O32sr::_RealStr)
extern DELPHI_PACKAGE System::ResourceString _ExtendedStr;
#define O32sr_ExtendedStr System::LoadResourceString(&O32sr::_ExtendedStr)
extern DELPHI_PACKAGE System::ResourceString _DoubleStr;
#define O32sr_DoubleStr System::LoadResourceString(&O32sr::_DoubleStr)
extern DELPHI_PACKAGE System::ResourceString _SingleStr;
#define O32sr_SingleStr System::LoadResourceString(&O32sr::_SingleStr)
extern DELPHI_PACKAGE System::ResourceString _CompStr;
#define O32sr_CompStr System::LoadResourceString(&O32sr::_CompStr)
extern DELPHI_PACKAGE System::ResourceString _DateStr;
#define O32sr_DateStr System::LoadResourceString(&O32sr::_DateStr)
extern DELPHI_PACKAGE System::ResourceString _TimeStr;
#define O32sr_TimeStr System::LoadResourceString(&O32sr::_TimeStr)
extern DELPHI_PACKAGE System::ResourceString _CharMask1Str;
#define O32sr_CharMask1Str System::LoadResourceString(&O32sr::_CharMask1Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask2Str;
#define O32sr_CharMask2Str System::LoadResourceString(&O32sr::_CharMask2Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask3Str;
#define O32sr_CharMask3Str System::LoadResourceString(&O32sr::_CharMask3Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask4Str;
#define O32sr_CharMask4Str System::LoadResourceString(&O32sr::_CharMask4Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask5Str;
#define O32sr_CharMask5Str System::LoadResourceString(&O32sr::_CharMask5Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask6Str;
#define O32sr_CharMask6Str System::LoadResourceString(&O32sr::_CharMask6Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask7Str;
#define O32sr_CharMask7Str System::LoadResourceString(&O32sr::_CharMask7Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask8Str;
#define O32sr_CharMask8Str System::LoadResourceString(&O32sr::_CharMask8Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask9Str;
#define O32sr_CharMask9Str System::LoadResourceString(&O32sr::_CharMask9Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask10Str;
#define O32sr_CharMask10Str System::LoadResourceString(&O32sr::_CharMask10Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask11Str;
#define O32sr_CharMask11Str System::LoadResourceString(&O32sr::_CharMask11Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask12Str;
#define O32sr_CharMask12Str System::LoadResourceString(&O32sr::_CharMask12Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask14Str;
#define O32sr_CharMask14Str System::LoadResourceString(&O32sr::_CharMask14Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask15Str;
#define O32sr_CharMask15Str System::LoadResourceString(&O32sr::_CharMask15Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask16Str;
#define O32sr_CharMask16Str System::LoadResourceString(&O32sr::_CharMask16Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask17Str;
#define O32sr_CharMask17Str System::LoadResourceString(&O32sr::_CharMask17Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask18Str;
#define O32sr_CharMask18Str System::LoadResourceString(&O32sr::_CharMask18Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask19Str;
#define O32sr_CharMask19Str System::LoadResourceString(&O32sr::_CharMask19Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask20Str;
#define O32sr_CharMask20Str System::LoadResourceString(&O32sr::_CharMask20Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask21Str;
#define O32sr_CharMask21Str System::LoadResourceString(&O32sr::_CharMask21Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask22Str;
#define O32sr_CharMask22Str System::LoadResourceString(&O32sr::_CharMask22Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask23Str;
#define O32sr_CharMask23Str System::LoadResourceString(&O32sr::_CharMask23Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask24Str;
#define O32sr_CharMask24Str System::LoadResourceString(&O32sr::_CharMask24Str)
extern DELPHI_PACKAGE System::ResourceString _CharMask25Str;
#define O32sr_CharMask25Str System::LoadResourceString(&O32sr::_CharMask25Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask1Str;
#define O32sr_FieldMask1Str System::LoadResourceString(&O32sr::_FieldMask1Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask2Str;
#define O32sr_FieldMask2Str System::LoadResourceString(&O32sr::_FieldMask2Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask3Str;
#define O32sr_FieldMask3Str System::LoadResourceString(&O32sr::_FieldMask3Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask4Str;
#define O32sr_FieldMask4Str System::LoadResourceString(&O32sr::_FieldMask4Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask5Str;
#define O32sr_FieldMask5Str System::LoadResourceString(&O32sr::_FieldMask5Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask6Str;
#define O32sr_FieldMask6Str System::LoadResourceString(&O32sr::_FieldMask6Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask7Str;
#define O32sr_FieldMask7Str System::LoadResourceString(&O32sr::_FieldMask7Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask8Str;
#define O32sr_FieldMask8Str System::LoadResourceString(&O32sr::_FieldMask8Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask9Str;
#define O32sr_FieldMask9Str System::LoadResourceString(&O32sr::_FieldMask9Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask10Str;
#define O32sr_FieldMask10Str System::LoadResourceString(&O32sr::_FieldMask10Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask11Str;
#define O32sr_FieldMask11Str System::LoadResourceString(&O32sr::_FieldMask11Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask12Str;
#define O32sr_FieldMask12Str System::LoadResourceString(&O32sr::_FieldMask12Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask13Str;
#define O32sr_FieldMask13Str System::LoadResourceString(&O32sr::_FieldMask13Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask14Str;
#define O32sr_FieldMask14Str System::LoadResourceString(&O32sr::_FieldMask14Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask15Str;
#define O32sr_FieldMask15Str System::LoadResourceString(&O32sr::_FieldMask15Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask16Str;
#define O32sr_FieldMask16Str System::LoadResourceString(&O32sr::_FieldMask16Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask17Str;
#define O32sr_FieldMask17Str System::LoadResourceString(&O32sr::_FieldMask17Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask18Str;
#define O32sr_FieldMask18Str System::LoadResourceString(&O32sr::_FieldMask18Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask19Str;
#define O32sr_FieldMask19Str System::LoadResourceString(&O32sr::_FieldMask19Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask20Str;
#define O32sr_FieldMask20Str System::LoadResourceString(&O32sr::_FieldMask20Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask21Str;
#define O32sr_FieldMask21Str System::LoadResourceString(&O32sr::_FieldMask21Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask22Str;
#define O32sr_FieldMask22Str System::LoadResourceString(&O32sr::_FieldMask22Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask23Str;
#define O32sr_FieldMask23Str System::LoadResourceString(&O32sr::_FieldMask23Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask24Str;
#define O32sr_FieldMask24Str System::LoadResourceString(&O32sr::_FieldMask24Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask25Str;
#define O32sr_FieldMask25Str System::LoadResourceString(&O32sr::_FieldMask25Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask26Str;
#define O32sr_FieldMask26Str System::LoadResourceString(&O32sr::_FieldMask26Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask27Str;
#define O32sr_FieldMask27Str System::LoadResourceString(&O32sr::_FieldMask27Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask28Str;
#define O32sr_FieldMask28Str System::LoadResourceString(&O32sr::_FieldMask28Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask29Str;
#define O32sr_FieldMask29Str System::LoadResourceString(&O32sr::_FieldMask29Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask30Str;
#define O32sr_FieldMask30Str System::LoadResourceString(&O32sr::_FieldMask30Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask31Str;
#define O32sr_FieldMask31Str System::LoadResourceString(&O32sr::_FieldMask31Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask32Str;
#define O32sr_FieldMask32Str System::LoadResourceString(&O32sr::_FieldMask32Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask33Str;
#define O32sr_FieldMask33Str System::LoadResourceString(&O32sr::_FieldMask33Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask34Str;
#define O32sr_FieldMask34Str System::LoadResourceString(&O32sr::_FieldMask34Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask35Str;
#define O32sr_FieldMask35Str System::LoadResourceString(&O32sr::_FieldMask35Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask36Str;
#define O32sr_FieldMask36Str System::LoadResourceString(&O32sr::_FieldMask36Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask37Str;
#define O32sr_FieldMask37Str System::LoadResourceString(&O32sr::_FieldMask37Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask38Str;
#define O32sr_FieldMask38Str System::LoadResourceString(&O32sr::_FieldMask38Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask39Str;
#define O32sr_FieldMask39Str System::LoadResourceString(&O32sr::_FieldMask39Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask40Str;
#define O32sr_FieldMask40Str System::LoadResourceString(&O32sr::_FieldMask40Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask41Str;
#define O32sr_FieldMask41Str System::LoadResourceString(&O32sr::_FieldMask41Str)
extern DELPHI_PACKAGE System::ResourceString _FieldMask42Str;
#define O32sr_FieldMask42Str System::LoadResourceString(&O32sr::_FieldMask42Str)
static const System::Word SrMaxMessages = System::Word(0x178);
extern DELPHI_PACKAGE O32sr__1 SrMsgNumLookup;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ResourceStrByNumber(System::Word Num);
}	/* namespace O32sr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32SR)
using namespace O32sr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32srHPP
