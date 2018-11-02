{*********************************************************}
{*                OvcRvExpDef.PAS 4.08                   *}
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

unit ovcrvexpdef;

interface
uses
  Windows, SysUtils, Variants, OvcRvIdx, Classes;

type
  TOvcRvExpression = class;
  TOvcRvExpNode = class;
  TOvcRvExpEnumMethod = procedure(Node: TOvcRvExpNode) of object;
  TOvcRvExpAggregate = class;
  TOvcRvExpRelOp = (roNone, roEQ, roLE, roL, roG, roGE, roNE);
  TOvcRvExpNode = class
  private
    FParent : TOvcRvExpNode;
    FOwner : TOvcRvExpression;
    procedure AddAggregate(Target: TList); virtual;
    function GetType: TOvcDRDataType; virtual;
    function GetOwner: TOvcRvExpression;
    procedure SQLError(const ErrorMsg: string);
    procedure AssignError(Source: TOvcRvExpNode);
    procedure TypeMismatch;
    function BindField(const
      FieldName: string): TOvcAbstractRvField; virtual;
    function IsAggregate: Boolean; virtual;
  public
    constructor Create(AParent: TOvcRvExpNode);
    property Parent : TOvcRvExpNode read FParent;
    property Owner :   TOvcRvExpression read GetOwner;
    procedure Assign(const Source: TOvcRvExpNode); virtual; abstract;
  end;

  TOvcRvExpFieldRef = class(TOvcRvExpNode)
  private
    FFieldName: string;
    TypeKnown : Boolean;
    FType : TOvcDRDataType;
    FField : TOvcAbstractRvField;
    function GetType: TOvcDRDataType; override;
    procedure CheckType;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetField: TOvcAbstractRvField;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property FieldName : string read FFieldName write FFieldName;
    function GetValue(Data: Pointer) : Variant;
    property Field: TOvcAbstractRvField read GetField;
  end;

  TOvcRvExpSimpleExpression = class;

  TOvcRvExpAggFunction = (agCount, agMin, agMax, agSum, agAvg);

  TOvcRvExpAggregate = class(TOvcRvExpNode)
  private
    FAgFunction: TOvcRvExpAggFunction;
    FSimpleExpression : TOvcRvExpSimpleExpression;
    {FSourceField: TOvcAbstractRvField;}
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
    procedure AddAggregate(Target: TList); override;
    function Reduce: Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property AgFunction : TOvcRvExpAggFunction read FAgFunction write FAgFunction;
    property SimpleExpression : TOvcRvExpSimpleExpression read FSimpleExpression write FSimpleExpression;
    function GetValue(Data: Pointer): Variant;
    {procedure SetSourceField(SourceField: TOvcAbstractRvField);}
  end;

  TOvcRvExpColumn = class(TOvcRvExpNode)
  private
    FColumnName: string;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property ColumnName: string read FColumnName write FColumnName;
  end;

  TOvcRvExpIsOp = (ioNull, ioTrue, ioFalse, ioUnknown);
  TOvcRvExpIsTest = class(TOvcRvExpNode)
  private
    FUnaryNot : Boolean;
    FIsOp : TOvcRvExpIsOp;
    procedure MatchType(ExpectedType: TOvcDRDataType);
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property UnaryNot: Boolean read FUnaryNot write FUnaryNot;
    property IsOp : TOvcRvExpIsOp read FIsOp write FIsOp;
    function AsBoolean(const TestValue: Variant): Boolean;
  end;

  TOvcRvExpBetweenClause = class(TOvcRvExpNode)
  private
    FSimpleHigh: TOvcRvExpSimpleExpression;
    FSimpleLow: TOvcRvExpSimpleExpression;
    FNegated : Boolean;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property Negated : Boolean read FNegated write FNegated;
    property SimpleLow : TOvcRvExpSimpleExpression read FSimpleLow write FSimpleLow;
    property SimpleHigh : TOvcRvExpSimpleExpression read FSimpleHigh write FSimpleHigh;
    function AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
  end;

  TOvcRvExpLikePattern = class
  private
    LeadPattern,
    TrailPattern : string;
    LeadMask,
    TrailMask: string;
    FloatPatterns,
    FloatMasks: TStringList;
  public
    constructor Create(SearchPattern: string; const Escape: string);
    {S is the search pattern; Escape is an optional one-character escape
    character}
    {S contains the string to be searched for, and optionally one or more
    occurrences of
      '%' (match zero or more characters of any kind), and/or
      '_'  (match exactly one character of any kind)
      If the Escape character is specified, it defines a character to prefix '%'
    or '_' with
      to indicate a literal '%' or '_', respectively, in the search phrase S.}
     {the search must be case sensitive ('a' <> 'A') }
    destructor Destroy; override;
    function Find(const TextToSearch: string): Boolean;
     {examples:
        S = '%Berkeley%' - Find returns true if the string 'Berkeley' exists
    anywhere in TextToSearch
        S = 'S__' - Find returns true if TextToSearch is exactly thee characters
    long and starts with an upper-case 'S'
        S = '%c___' - Find returns True if length(TextToSearch) >= 4 and the
    last but three is 'c'
        S = '=_%' and Escape = '=' - Find returns True if TextToSearch begins
    with an underscore.
      }
  end;

  TOvcRvExpLikeClause = class(TOvcRvExpNode)
  private
    FSimpleExp: TOvcRvExpSimpleExpression;
    FEscapeExp: TOvcRvExpSimpleExpression;
    FNegated : Boolean;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    Limited: Boolean;
    LikePattern: TOvcRvExpLikePattern;
    function CanLimit: Boolean;
    function CanReplaceWithCompare: Boolean;
    procedure CheckIsConstant;
    function GetLowLimit(Data: Pointer): string;
    function GetHighLimit(Data: Pointer): string;
    function IsConstant: Boolean;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property SimpleExp : TOvcRvExpSimpleExpression read FSimpleExp write FSimpleExp;
    property EscapeExp: TOvcRvExpSimpleExpression read FEscapeExp write FEscapeExp;
    property Negated : Boolean read FNegated write FNegated;
    function AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
  end;

  TOvcRvExpSimpleExpressionList = class;

  TOvcRvExpInClause = class(TOvcRvExpNode)
  private
    FSimpleExp: TOvcRvExpSimpleExpressionList;
    FNegated : Boolean;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property SimpleExpList : TOvcRvExpSimpleExpressionList read FSimpleExp write FSimpleExp;
    property Negated : Boolean read FNegated write FNegated;
    function AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
  end;

  TOvcRvExpCondPrimary = class(TOvcRvExpNode)
  private
    FSimpleExp1: TOvcRvExpSimpleExpression;
    FRelOp: TOvcRvExpRelOp;
    FSimpleExp2: TOvcRvExpSimpleExpression;
    FBetweenClause : TOvcRvExpBetweenClause;
    FLikeClause : TOvcRvExpLikeClause;
    FInClause : TOvcRvExpInClause;
    FIsTest : TOvcRvExpIsTest;
    TypeChecked : Boolean;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    procedure CheckType;
    function GetType: TOvcDRDataType; override;
    function JustSimpleExpression: Boolean;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    destructor Destroy; override;
    procedure Assign(const Source: TOvcRvExpNode); override;
    property SimpleExp1 : TOvcRvExpSimpleExpression read FSimpleExp1 write FSimpleExp1;
    property RelOp : TOvcRvExpRelOp read FRelOp write FRelOp;
    property SimpleExp2 : TOvcRvExpSimpleExpression read FSimpleExp2 write FSimpleExp2;
    property BetweenClause : TOvcRvExpBetweenClause read FBetweenClause write FBetweenClause;
    property LikeClause : TOvcRvExpLikeClause read FLikeClause write FLikeClause;
    property InClause : TOvcRvExpInClause read FInClause write FInClause;
    property IsTest : TOvcRvExpIsTest read FIsTest write FIsTest;
    function AsBoolean(Data: Pointer): Boolean;
    function GetValue(Data: Pointer): Variant;
  end;

  TOvcRvExpCondFactor = class(TOvcRvExpNode)
  private
    FUnaryNot: Boolean;
    FCondPrimary: TOvcRvExpCondPrimary;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    TmpKnown: Boolean;
    TmpValue: Boolean;
    procedure CheckIsConstant;
    procedure Clear;
    function IsConstant: Boolean;
    function GetType: TOvcDRDataType; override;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property UnaryNot : Boolean read FUnaryNot write FUnaryNot;
    property CondPrimary : TOvcRvExpCondPrimary read FCondPrimary write FCondPrimary;
    function AsBoolean(Data: Pointer): Boolean;
    function GetValue(Data: Pointer): Variant;
  end;

  TFFObjectProc = procedure of object;

  TOvcRvExpCondTerm = class(TOvcRvExpNode)
  private
    CondFactorList : TList;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    function GetCondFactor(Index: Integer): TOvcRvExpCondFactor;
    procedure SetCondFactor(Index: Integer; const Value: TOvcRvExpCondFactor);
    function GetCondFactorCount: Integer;
    function GetType: TOvcDRDataType; override;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddCondFactor(Factor : TOvcRvExpCondFactor): TOvcRvExpCondFactor;
    function InsertCondFactor(Index: Integer; Factor : TOvcRvExpCondFactor): TOvcRvExpCondFactor;
    property CondFactorCount : Integer read GetCondFactorCount;
    property CondFactor[Index: Integer] : TOvcRvExpCondFactor read GetCondFactor write SetCondFactor;
    function AsBoolean(Data: Pointer): Boolean;
    function GetValue(Data: Pointer): Variant;
  end;

  TOvcRvExpression = class(TOvcRvExpNode)
  private
    CondTermList : TList;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    FOwnerReport: TOvcAbstractReportView;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    function GetCondTerm(Index: Integer): TOvcRvExpCondTerm;
    procedure SetCondTerm(Index: Integer; const Value: TOvcRvExpCondTerm);
    function GetCondTermCount: Integer;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function BindField(const
      FieldName: string): TOvcAbstractRvField; override;
    function GetOwnerReport: TOvcAbstractReportView;
  public
    function GetType: TOvcDRDataType; override;
    function Reduce: Boolean;
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddCondTerm(Term : TOvcRvExpCondTerm): TOvcRvExpCondTerm;
    property CondTermCount : Integer read GetCondTermCount;
    property CondTerm[Index: Integer] : TOvcRvExpCondTerm read GetCondTerm write SetCondTerm;
    function AsBoolean(Data: Pointer): Boolean;
    function GetValue(Data: Pointer): Variant;
    property OwnerReport: TOvcAbstractReportView read GetOwnerReport write FOwnerReport;
    function RefersTo(AField : TOvcAbstractRvField): Boolean;
  end;

  TOvcRvExpressionList = class(TOvcRvExpNode)
  private
    FExpressionList : TList;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure CheckIsConstant;
    procedure Clear;
    function IsConstant: Boolean;
    function GetExpression(Index: Integer): TOvcRvExpression;
    function GetExpressionCount: Integer;
    procedure SetExpression(Index: Integer;
      const Value: TOvcRvExpression);
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
    function GetType: TOvcDRDataType; override;
  public
    function GetValue(Data: Pointer) : Variant;
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddExpression(Expression: TOvcRvExpression): TOvcRvExpression;
    property ExpressionCount : Integer read GetExpressionCount;
    property Expression[Index: Integer] : TOvcRvExpression read GetExpression write SetExpression;
  end;

  TOvcRvExpFloatLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    DoubleValue : double;
    Converted: Boolean;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpIntegerLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    Int32Value: Integer;
    Converted: Boolean;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpStringLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    FType : TOvcDRDataType;
    Converted : Boolean;
    ShortStringValue : String;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpTimestampLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    DateTimeValue: TDateTime;
    Converted: Boolean;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpTimeLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    TimeValue : TDateTime;
    Converted : Boolean;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpDateLiteral = class(TOvcRvExpNode)
  private
    FValue : string;
    DateValue : TDateTime;
    Converted : Boolean;
    procedure ConvertToNative;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : string read FValue write FValue;
    function GetValue: Variant;
  end;

  TOvcRvExpBooleanLiteral = class(TOvcRvExpNode)
  private
    FValue : Boolean;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    property Value : Boolean read FValue write FValue;
    function GetValue: Boolean;
  end;

  TOvcRvExpLiteral = class(TOvcRvExpNode)
  private
    FFloatLiteral: TOvcRvExpFloatLiteral;
    FIntegerLiteral: TOvcRvExpIntegerLiteral;
    FStringLiteral: TOvcRvExpStringLiteral;
    FDateLiteral : TOvcRvExpDateLiteral;
    FTimeLiteral : TOvcRvExpTimeLiteral;
    FTimeStampLiteral : TOvcRvExpTimestampLiteral;
    FBooleanLiteral: TOvcRvExpBooleanLiteral;
    procedure Clear;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property BooleanLiteral : TOvcRvExpBooleanLiteral read FBooleanLiteral write FBooleanLiteral;
    property FloatLiteral : TOvcRvExpFloatLiteral read FFloatLiteral write FFloatLiteral;
    property IntegerLiteral : TOvcRvExpIntegerLiteral read FIntegerLiteral write FIntegerLiteral;
    property StringLiteral : TOvcRvExpStringLiteral read FStringLiteral write FStringLiteral;
    property DateLiteral : TOvcRvExpDateLiteral read FDateLiteral write FDateLiteral;
    property TimeLiteral : TOvcRvExpTimeLiteral read FTimeLiteral write FTimeLiteral;
    property TimeStampLiteral : TOvcRvExpTimestampLiteral read FTimestampLiteral write FTimestampLiteral;
    function GetValue : Variant;
  end;

  TOvcRvExpWhenClause = class(TOvcRvExpNode)
  private
    FWhenExp : TOvcRvExpression;
    FThenExp : TOvcRvExpSimpleExpression;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property WhenExp : TOvcRvExpression read FWhenExp write FWhenExp;
    property ThenExp : TOvcRvExpSimpleExpression read FThenExp write FThenExp;
  end;

  TOvcRvExpWhenClauseList = class(TOvcRvExpNode)
  private
    WhenClauseList : TList;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    function GetWhenClause(Index: Integer): TOvcRvExpWhenClause;
    function GetWhenClauseCount: Integer;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    property WhenClauseCount : Integer read GetWhenClauseCount;
    property WhenClause[Index: Integer]: TOvcRvExpWhenClause read GetWhenClause;
    function AddWhenClause(Value: TOvcRvExpWhenClause): TOvcRvExpWhenClause;
  end;

  TOvcRvExpCaseExpression = class(TOvcRvExpNode)
  private
    FWhenClauseList : TOvcRvExpWhenClauseList;
    FElseExp : TOvcRvExpSimpleExpression;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    procedure CheckIsConstant;
    function GetType: TOvcDRDataType; override;
    function IsConstant: Boolean;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property WhenClauseList : TOvcRvExpWhenClauseList read FWhenClauseList write FWhenClauseList;
    property ElseExp : TOvcRvExpSimpleExpression read FElseExp write FElseExp;
    function GetValue(Data: Pointer): Variant;
  end;

  TOvcRvExpScalarFunction = (sfCase, sfCharlen, sfLower, sfUpper, sfPosition,
    sfSubstring, sfTrim, sfFormatFloat, sfFormatDateTime, sfIntToHex, sfExtern);
  TOvcRvExpLTB = (ltbBoth, ltbLeading, ltbTrailing);
  TOvcRvExpScalarFunc = class(TOvcRvExpNode)
  private
    FSQLFunction : TOvcRvExpScalarFunction;
    FArg1 : TOvcRvExpSimpleExpression;
    FArg2 : TOvcRvExpSimpleExpression;
    FArg3 : TOvcRvExpSimpleExpression;
    FExpList: TOvcRvExpressionList;
    FCondArg1 : TOvcRvExpression;
    FLTB : TOvcRvExpLTB;
    FCaseExp : TOvcRvExpCaseExpression;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    FType : TOvcDRDataType;
    TypeKnown : Boolean;
    ConstantValue: Variant;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function GetType: TOvcDRDataType; override;
    procedure CheckType;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property SQLFunction : TOvcRvExpScalarFunction read FSQLFunction write FSQLFunction;
    property Arg1 : TOvcRvExpSimpleExpression read FArg1 write FArg1;
    property Arg2 : TOvcRvExpSimpleExpression read FArg2 write FArg2;
    property Arg3 : TOvcRvExpSimpleExpression read FArg3 write FArg3;
    property CondArg1: TOvcRvExpression read FCondArg1 write FCondArg1;
    property ExpList: TOvcRvExpressionList read FExpList write FExpList;
    property LTB : TOvcRvExpLTB read FLTB write FLTB;
    property CaseExp : TOvcRvExpCaseExpression read FCaseExp write FCaseExp;
    function GetValue(Data: Pointer): Variant;
  end;

  TOvcRvExpMulOp = (moMul, moDiv);
  TOvcRvExpFactor = class(TOvcRvExpNode)
  private
    TypeKnown : Boolean;
    FType : TOvcDRDataType;
    FMulOp: TOvcRvExpMulOp;
    FUnaryMinus : Boolean;
    FCondExp: TOvcRvExpression;
    FFieldRef: TOvcRvExpFieldRef;
    FLiteral: TOvcRvExpLiteral;
    FAggregate : TOvcRvExpAggregate;
    FScalarFunc : TOvcRvExpScalarFunc;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    function GetType: TOvcDRDataType; override;
    procedure CheckType;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function IsAggregate: Boolean; override;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    destructor Destroy; override;
    property MulOp :TOvcRvExpMulOp read FMulOp write FMulOp;
    property UnaryMinus : Boolean read FUnaryMinus write FUnaryMinus;
    property CondExp : TOvcRvExpression read FCondExp write FCondExp;
    property FieldRef : TOvcRvExpFieldRef read FFieldRef write FFieldRef;
    property Literal : TOvcRvExpLiteral read FLiteral write FLiteral;
    property Aggregate : TOvcRvExpAggregate read FAggregate write FAggregate;
    property ScalarFunc : TOvcRvExpScalarFunc read FScalarFunc write FScalarFunc;
    function GetValue(Data: Pointer): Variant;
  end;

  TOvcRvExpAddOp = (aoPlus, aoMinus, aoConcat);
  TOvcRvExpTerm = class(TOvcRvExpNode)
  private
    TypeKnown : Boolean;
    FType : TOvcDRDataType;
    FAddOp: TOvcRvExpAddOp;
    FactorList : TList;
    FIsConstantChecked: Boolean;
    FIsConstant: Boolean;
    ConstantValue: Variant;
    procedure Clear;
    procedure CheckIsConstant;
    function IsConstant: Boolean;
    function GetFactor(Index: Integer): TOvcRvExpFactor;
    procedure SetFactor(Index: Integer; const Value: TOvcRvExpFactor);
    function GetFactorCount: Integer;
    function GetType: TOvcDRDataType; override;
    procedure CheckType;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function IsAggregate: Boolean; override;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddFactor(Factor: TOvcRvExpFactor): TOvcRvExpFactor;
    property FactorCount : Integer read GetFactorCount;
    property Factor[Index: Integer] : TOvcRvExpFactor read GetFactor write SetFactor;
    property AddOp :TOvcRvExpAddOp read FAddOp write FAddOp;
    function GetValue(Data: Pointer): Variant;
    function IsAggregateExpression: Boolean;
  end;

  TOvcRvExpSimpleExpression = class(TOvcRvExpNode)
  private
    TypeKnown : Boolean;
    FType : TOvcDRDataType;
    FIsConstant : Boolean;
    FIsConstantChecked: Boolean;
    ConstantValue: Variant;
    procedure Clear;
    function GetTerm(Index: Integer): TOvcRvExpTerm;
    procedure SetTerm(Index: Integer; const Value: TOvcRvExpTerm);
    function GetTermCount: Integer;
    function GetType: TOvcDRDataType; override;
    procedure CheckType;
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function IsAggregate: Boolean; override;
    function IsConstant: Boolean;
    procedure CheckIsConstant;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  private
    TermList : TList;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddTerm(Term : TOvcRvExpTerm): TOvcRvExpTerm;
    property TermCount : Integer read GetTermCount;
    property Term[Index: Integer] : TOvcRvExpTerm read GetTerm write SetTerm;
    function GetValue(Data: Pointer): Variant;
    function IsAggregateExpression: Boolean;
  end;

  TOvcRvExpSimpleExpressionList = class(TOvcRvExpNode)
  private
    FExpressionList : TList;
    FIsConstant: Boolean;
    FIsConstantChecked: Boolean;
    procedure CheckIsConstant;
    procedure Clear;
    function IsConstant: Boolean;
    function GetExpression(Index: Integer): TOvcRvExpSimpleExpression;
    function GetExpressionCount: Integer;
    procedure SetExpression(Index: Integer;
      const Value: TOvcRvExpSimpleExpression);
    procedure MatchType(ExpectedType: TOvcDRDataType);
    function Contains(Data: Pointer; const TestValue: Variant): Boolean;
    function Reduce: Boolean;
    function RefersTo(AField: TOvcAbstractRvField): Boolean;
  public
    procedure Assign(const Source: TOvcRvExpNode); override;
    constructor Create(AParent: TOvcRvExpNode);
    destructor Destroy; override;
    function AddExpression(Expression: TOvcRvExpSimpleExpression): TOvcRvExpSimpleExpression;
    property ExpressionCount : Integer read GetExpressionCount;
    property Expression[Index: Integer] : TOvcRvExpSimpleExpression read GetExpression write SetExpression;
  end;

implementation
uses
  OVCStr, OvcRptVw;

var
  TimeDelta : double;
const
  ffSqlInConvThreshold = 8; {maximum length of expression list in
    an IN clause to convert to simple expressions}

type
  TReadSourceEvent = procedure(Sender: TObject;
    var OkToCopy: boolean) of object;
  TEvaluateFieldEvent = procedure(Sender: TObject;
    ColumnIndex : Integer; var Res : variant) of object;

function CreateLiteralStringExp(Parent: TOvcRvExpNode; const S: string): TOvcRvExpSimpleExpression;
var
  T : TOvcRvExpTerm;
  F : TOvcRvExpFactor;
  L : TOvcRvExpLiteral;
  SL : TOvcRvExpStringLiteral;
begin
  Result := TOvcRvExpSimpleExpression.Create(Parent);
  T := TOvcRvExpTerm.Create(Result);
  F := TOvcRvExpFactor.Create(T);
  L := TOvcRvExpLiteral.Create(F);
  SL := TOvcRvExpStringLiteral.Create(L);
  SL.Value := '''' + S + '''';
  L.StringLiteral := SL;
  F.Literal := L;
  T.AddFactor(F);
  Result.AddTerm(T);
end;

{ TOvcRvExpNode }

procedure TOvcRvExpNode.AddAggregate(Target: TList);
begin
end;

function TOvcRvExpNode.GetType: TOvcDRDataType;
begin
  raise Exception.CreateFmt('Internal error:GetType not implemented for %s',
    [ClassName]);
end;

function TOvcRvExpNode.IsAggregate: Boolean;
begin
  raise Exception.CreateFmt('Internal error:IsAggregate not implemented for %s',
    [ClassName]);
end;

function TOvcRvExpNode.GetOwner: TOvcRvExpression;
begin
  if (FOwner = nil) then begin
    Assert(Parent <> nil);
    FOwner := TOvcRvExpression(Parent);
    while FOwner.Parent <> nil do
      FOwner := TOvcRvExpression(FOwner.Parent);
    Assert(Owner is TOvcRvExpression);
  end;
  Result := FOwner;
end;

procedure TOvcRvExpNode.TypeMismatch;
begin
  SQLError('Type mismatch');
end;

procedure TOvcRvExpNode.AssignError(Source: TOvcRvExpNode);
begin
  raise Exception.CreateFmt('%s not compatible with %s',
    [Source.ClassName, ClassName]);
end;

function TOvcRvExpNode.BindField(const
  FieldName: string): TOvcAbstractRvField;
begin
  if Parent <> nil then
    Result := Parent.BindField(FieldName)
  else
    raise Exception.Create('No node could resolve field');
end;

procedure TOvcRvExpNode.SQLError(const ErrorMsg: string);
begin
  raise Exception.CreateFmt('Error in statement: %s "$s"', [ErrorMsg]);
end;

constructor TOvcRvExpNode.Create(AParent: TOvcRvExpNode);
begin
  inherited Create;
  FParent := AParent;
end;

{ TOvcRvExpSimpleExpression }

function TOvcRvExpSimpleExpression.AddTerm(Term: TOvcRvExpTerm): TOvcRvExpTerm;
begin
  TermList.Add(Term);
  Result := Term;
end;

procedure TOvcRvExpSimpleExpression.Assign(const Source: TOvcRvExpNode);
var
  i : Integer;
begin
  if Source is TOvcRvExpSimpleExpression then begin
    Clear;
    for i := 0 to pred(TOvcRvExpSimpleExpression(Source).TermCount) do begin
      AddTerm(TOvcRvExpTerm.Create(Self)).Assign(
        TOvcRvExpSimpleExpression(Source).Term[i]);
    end;
  end else
    AssignError(Source);
end;

constructor TOvcRvExpSimpleExpression.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  TermList := TList.Create;
end;

procedure TOvcRvExpSimpleExpression.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(TermCount) do
    Term[i].Free;
  TermList.Clear;
  inherited;
end;

destructor TOvcRvExpSimpleExpression.Destroy;
begin
  Clear;
  TermList.Free;
  inherited;
end;

function TOvcRvExpSimpleExpression.GetValue(Data: Pointer): variant;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  Result := Term[0].GetValue(Data);
  for i := 1 to pred(TermCount) do
    case Term[i].AddOp of
    aoPlus :
      Result := Result + Term[i].GetValue(Data);
    aoMinus :
      Result := Result - Term[i].GetValue(Data);
    aoConcat :
      Result := Result + Term[i].GetValue(Data);
    end;
end;

function TOvcRvExpSimpleExpression.IsAggregateExpression: Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(TermCount) do
    if Term[i].IsAggregateExpression then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpSimpleExpression.GetTerm(
  Index: Integer): TOvcRvExpTerm;
begin
  Result := TOvcRvExpTerm(TermList[Index]);
end;

function TOvcRvExpSimpleExpression.GetTermCount: Integer;
begin
  Assert(Self <> nil);
  Assert(TermList <> nil);
  Result := TermList.Count;
end;

procedure TOvcRvExpSimpleExpression.CheckType;
var
  i : Integer;
begin
  FType := Term[0].GetType;
  if TermCount > 1 then begin
    case Term[1].AddOp of
    aoPlus :
      case FType of
      dtString,
      dtFloat,
      dtInteger,
      dtDWord:
      ;
      else
        SQLError('Operator/operand mismatch');
      end;
    aoMinus :
      case FType of
      dtFloat,
      dtInteger,
      dtDWord:
        ;
      else
        SQLError('Operator/operand mismatch');
      end;
    aoConcat :
      case FType of
      dtString :
        ;
      else
        SQLError('Operator/operand mismatch');
      end;
    end;
    for i := 2 to pred(TermCount) do begin
      case Term[i].AddOp of
      aoPlus :
        case Term[i - 1].GetType of
        dtString,
        dtFloat,
        dtInteger,
        dtDWord:
          ;
        else
          SQLError('Operator/operand mismatch');
        end;
      aoMinus :
        case Term[i - 1].GetType of
        dtFloat,
        dtInteger,
        dtDWord:
        else
          SQLError('Operator/operand mismatch');
        end;
      aoConcat :
        case Term[i - 1].GetType of
        dtString :
          ;
        else
          SQLError('Operator/operand mismatch');
        end;
      end;
    end;
  end;
  TypeKnown := True;
end;

function TOvcRvExpSimpleExpression.GetType: TOvcDRDataType;
begin
  if not TypeKnown then
    CheckType;
  Result := FType
end;

function TOvcRvExpSimpleExpression.IsAggregate: Boolean;
begin
  Result := (TermCount = 1) and Term[0].IsAggregate;
end;

procedure TOvcRvExpSimpleExpression.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(TermCount) do
    if not Term[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  ConstantValue := GetValue(nil);
  FIsConstant := True;
end;

function TOvcRvExpSimpleExpression.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpSimpleExpression.MatchType(ExpectedType: TOvcDRDataType);
var
  i : Integer;
begin
  for i := 0 to pred(TermCount) do
    Term[i].MatchType(ExpectedType);
end;

function TOvcRvExpSimpleExpression.Reduce: Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(TermCount) do
    if Term[i].Reduce then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpSimpleExpression.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
var
  i: Integer;
begin
  for i := 0 to pred(TermCount) do
    if Term[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpSimpleExpression.SetTerm(Index: Integer;
  const Value: TOvcRvExpTerm);
begin
  TermList[Index] := Value;
end;

{ TOvcRvExpTerm }

function TOvcRvExpTerm.AddFactor(Factor: TOvcRvExpFactor): TOvcRvExpFactor;
begin
  FactorList.Add(Factor);
  Result := Factor;
end;

procedure TOvcRvExpTerm.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(FactorCount) do
    if not Factor[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  ConstantValue := GetValue(nil);
  FIsConstant := True;
end;

procedure TOvcRvExpTerm.CheckType;
var
  i : Integer;
begin
  FType := Factor[0].GetType;
  if FactorCount > 1 then begin
    case Factor[1].MulOp of
    moMul, moDiv :
      case FType of
      dtFloat,
      dtInteger,
      dtDWord:
        ;
      else
        SQLError('Operator/operand mismatch');
      end;
    end;
    for i := 2 to pred(FactorCount) do begin
      case Factor[i].MulOp of
      moMul, moDiv :
        case Factor[i - 1].GetType of
        dtFloat,
        dtInteger,
        dtDWord:
          ;
        else
          SQLError('Operator/operand mismatch');
        end;
      end;
    end;
  end;
  TypeKnown := True;
end;

procedure TOvcRvExpTerm.Assign(const Source: TOvcRvExpNode);
var
  i : Integer;
begin
  if Source is TOvcRvExpTerm then begin
    Clear;
    for i := 0 to pred(TOvcRvExpTerm(Source).FactorCount) do begin
      AddFactor(TOvcRvExpFactor.Create(Self)).Assign(
        TOvcRvExpTerm(Source).Factor[i]);
    end;
    AddOp := TOvcRvExpTerm(Source).AddOp;
  end else
    AssignError(Source);
end;

constructor TOvcRvExpTerm.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  FactorList := TList.Create;
end;

procedure TOvcRvExpTerm.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(FactorCount) do
    Factor[i].Free;
  FactorList.Clear;
end;

destructor TOvcRvExpTerm.Destroy;
begin
  Clear;
  FactorList.Free;
  inherited;
end;

function TOvcRvExpTerm.GetFactor(Index: Integer): TOvcRvExpFactor;
begin
  Result := TOvcRvExpFactor(FactorList[Index]);
end;

function TOvcRvExpTerm.GetFactorCount: Integer;
begin
  Result := FactorList.Count;
end;

function TOvcRvExpTerm.GetType: TOvcDRDataType;
begin
  if not TypeKnown then
    CheckType;
  Result := FType
end;

function TOvcRvExpTerm.GetValue(Data: Pointer): Variant;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  Result := Factor[0].GetValue(Data);
  for i := 1 to pred(FactorCount) do
    case Factor[1].MulOp of
    moMul :
      Result := Result * Factor[i].GetValue(Data);
    moDiv :
      Result := Result / Factor[i].GetValue(Data);
    end;
end;

function TOvcRvExpTerm.IsAggregate: Boolean;
begin
  Result := (FactorCount = 1) and Factor[0].IsAggregate;
end;

function TOvcRvExpTerm.IsAggregateExpression: Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(FactorCount) do
    if Factor[i].IsAggregate then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpTerm.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpTerm.MatchType(ExpectedType: TOvcDRDataType);
var
  i : Integer;
begin
  for i := 0 to pred(FactorCount) do
    Factor[i].MatchType(ExpectedType);
end;

function TOvcRvExpTerm.Reduce: Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(FactorCount) do
    if Factor[i].Reduce then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpTerm.RefersTo(AField: TOvcAbstractRvField): Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(FactorCount) do
    if Factor[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpTerm.SetFactor(Index: Integer;
  const Value: TOvcRvExpFactor);
begin
  FactorList[Index] := Value;
end;

{ TOvcRvExpression }

function TOvcRvExpression.AddCondTerm(Term: TOvcRvExpCondTerm): TOvcRvExpCondTerm;
begin
  CondTermList.Add(Term);
  Result := Term;
end;

function TOvcRvExpression.AsBoolean(Data: Pointer): Boolean;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  for i := 0 to pred(CondTermCount) do
    if CondTerm[i].AsBoolean(Data) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpression.Assign(const Source: TOvcRvExpNode);
var
  i : Integer;
begin
  if Source is TOvcRvExpression then begin
    Clear;
    for i := 0 to pred(TOvcRvExpression(Source).CondTermCount) do
      AddCondTerm(TOvcRvExpCondTerm.Create(Self)).Assign(
        TOvcRvExpression(Source).CondTerm[i]);
  end else
    AssignError(Source);
end;

procedure TOvcRvExpression.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(CondTermCount) do
    if not CondTerm[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  ConstantValue := GetValue(nil);
  FIsConstant := True;
end;

constructor TOvcRvExpression.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  CondTermList := TList.Create;
end;

procedure TOvcRvExpression.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(CondTermCount) do
    CondTerm[i].Free;
  CondTermList.Clear;
end;

destructor TOvcRvExpression.Destroy;
begin
  Clear;
  CondTermList.Free;
  inherited;
end;

function TOvcRvExpression.GetCondTerm(
  Index: Integer): TOvcRvExpCondTerm;
begin
  Result := TOvcRvExpCondTerm(CondTermList[Index]);
end;

function TOvcRvExpression.GetCondTermCount: Integer;
begin
  Result := CondTermList.Count;
end;

function TOvcRvExpression.GetType: TOvcDRDataType;
var
  i: Integer;
begin
  if CondTermCount > 1 then begin
    {force type conversion at lower level if necessary}
    for i := 0 to pred(CondTermCount) do
      CondTerm[i].GetType;
    Result := dtBoolean;
  end else
    Result := CondTerm[0].GetType;
end;

function TOvcRvExpression.GetValue(Data: Pointer): Variant;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  if CondTermCount > 1 then
    Result := AsBoolean(Data)
  else
    Result := CondTerm[0].GetValue(Data);
end;

function TOvcRvExpression.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpression.MatchType(ExpectedType: TOvcDRDataType);
begin
  if GetType <> ExpectedType then
    TypeMismatch;
end;

function TOvcRvExpression.Reduce: Boolean;
var
  i,j : Integer;
  InFactIX,
  InTermIX: Integer;
  NewTerm, LiftTerm : TOvcRvExpCondTerm;
  NewFactor: TOvcRvExpCondFactor;
  NewPrimary: TOvcRvExpCondPrimary;
  LiftInClause: TOvcRvExpInClause;
  LiftInExp: TOvcRvExpSimpleExpression;
  LiftExp : TOvcRvExpression;
begin
  Result := False;
  LiftInClause := nil;
  LiftInExp := nil;
  LiftExp := nil;
  InTermIX := -1; //just to make the compiler happy
  InFactIX := -1; //just to make the compiler happy
  for i := 0 to pred(CondTermCount) do begin
    {look for conditional terms nested inside redundant parens}
    {eliminate parens when found}
    LiftTerm := nil;
    LiftExp := nil;
    with CondTerm[i] do begin
      if CondFactorCount = 1 then begin
        with CondFactor[0] do
          if not UnaryNot then
            if (CondPrimary.RelOp = roNone) then
              if CondPrimary.SimpleExp1 <> nil then
                if CondPrimary.JustSimpleExpression then
                  with CondPrimary.SimpleExp1 do
                    if TermCount  = 1 then begin
                      with Term[0] do
                        if FactorCount = 1 then
                          with Factor[0] do
                            if CondExp <> nil then
                              with CondExp do
                                if CondTermCount = 1 then begin
                                  LiftTerm := TOvcRvExpCondTerm.Create(Self);
                                  LiftTerm.Assign(CondTerm[0]);
                                end;
                    end;
      end;
      if LiftTerm <> nil then begin
        Clear;
        Assign(LiftTerm);
        LiftTerm.Free;
        {Get out. We may have more to do here, but Global Logic will
         call us again, and there may be other transformations that can
         be applied first.}
        break;
      end;
      if Reduce then begin
        {term itself was reduced}
        continue;
        break;
      end;
      if not Result then begin
        {look for IN expressions to be converted to simple comparisons}
        for j := 0 to pred(CondFactorCount) do
          with CondFactor[j] do
            if not UnaryNot then {can't handle negated expressions}
              if CondPrimary.RelOp = roNone then
                if (CondPrimary.InClause <> nil)
                and not (CondPrimary.InClause.Negated)
                and (CondPrimary.InClause.SimpleExpList.ExpressionCount <=
                  ffSqlInConvThreshold) then begin
                  {Here's one. Make a copy of it and get up to the
                   root level since we'll be doing surgery on this
                   very node hierarchy we're current looking at}
                  LiftInClause := TOvcRvExpInClause.Create(Self);
                  LiftInClause.Assign(CondPrimary.InClause);
                  LiftInExp := TOvcRvExpSimpleExpression.Create(Self);
                  LiftInExp.Assign(CondPrimary.SimpleExp1);
                  InTermIX := i; // just a reference back to here
                  if CondFactorCount > 1 then
                    {we have other factors that need to be copied -
                     make note of where the IN is - we should copy
                     everything BUT}
                    InFactIX := j
                    {we're the only factor, make a note of that by
                     setting the InFactIX flag to -1 indicating no
                     other factors should be copied}
                  else
                    InFactIX := -1;
                  break;
                end;
      end;
      if not Result then begin
        {look for nested conditional expressions to be lifted out, like
          (A OR B) AND C to be converted to A AND C OR B AND C}
        for j := 0 to pred(CondFactorCount) do
          with CondFactor[j] do
            if not UnaryNot then
              if (CondPrimary.RelOp = roNone) then
                if CondPrimary.SimpleExp1 <> nil then
                  if CondPrimary.JustSimpleExpression then
                    with CondPrimary.SimpleExp1 do
                      if TermCount  = 1 then begin
                        with Term[0] do
                          if FactorCount = 1 then
                            with Factor[0] do
                              if CondExp <> nil then begin
                                LiftExp := TOvcRvExpression.Create(Self);
                                LiftExp.Assign(CondExp);
                                InTermIX := i; // A reference back to here
                                InFactIX := j; // A reference back to here
                              end;
                      end;
      end;
      if LiftInClause <> nil then
        break;
      if LiftExp <> nil then
        break;
    end;
  end;
  if LiftExp <> nil then begin
    {create a top-level conditional term for each nested term,
     then copy each conditional factor except the one we're converting
     to each new term:}
    for i := 0 to pred(LiftExp.CondTermCount) do begin
      NewTerm := TOvcRvExpCondTerm.Create(Self);
      NewTerm.Assign(LiftExp.CondTerm[i]);
      for j := 0 to pred(CondTerm[InTermIX].CondFactorCount) do
        if j <> InFactIX then begin
          NewFactor := TOvcRvExpCondFactor.Create(NewTerm);
          NewFactor.Assign(CondTerm[InTermIX].CondFactor[j]);
          NewTerm.AddCondFactor(NewFactor);
        end;
      AddCondTerm(NewTerm);
    end;
    LiftInClause.Free;
    LiftInExp.Free;
    LiftExp.Free;
    CondTerm[InTermIX].Free;
    CondTermList.Delete(InTermIX);
    Result := True;
    exit;
  end;
  if LiftInClause <> nil then begin
    {Okay - that was the easy bit, finding the IN clause.
     We now need to build conditional terms for each of the
     alternatives - each with a simple comparison corresponding
     to each entry in the IN clause list.}
    for i := 0 to pred(LiftInClause.SimpleExpList.ExpressionCount) do begin
      NewTerm := TOvcRvExpCondTerm.Create(Self);
      NewFactor := TOvcRvExpCondFactor.Create(NewTerm);
      NewPrimary := TOvcRvExpCondPrimary.Create(NewFactor);
      NewPrimary.SimpleExp1 := TOvcRvExpSimpleExpression.Create(NewPrimary);
      NewPrimary.SimpleExp1.Assign(LiftInExp);
      NewPrimary.SimpleExp2 := TOvcRvExpSimpleExpression.Create(NewPrimary);
      NewPrimary.SimpleExp2.Assign(LiftInClause.SimpleExpList.Expression[i]);
      NewPrimary.RelOp := roEQ;
      NewFactor.CondPrimary := NewPrimary;
      NewTerm.AddCondFactor(NewFactor);
      {If we didn't have any other conditional factors
       combined with the IN clause - IOW, we didn't have something like
           Exp IN [blahblah] AND something else,
       then we're actually done. All we need to do is add each term, then
       finish off by deleting the original term which held the IN clause.

       On the other hand, if we did have other factors, they all need to
       be copied to the new term:}
      if InFactIX <> -1 then begin
        with CondTerm[InTermIX] do
          for j := 0 to pred(CondFactorCount) do
            if j <> InFactIX then begin
              NewFactor := TOvcRvExpCondFactor.Create(NewTerm);
              NewFactor.Assign(CondFactor[j]);
              NewTerm.AddCOndFactor(NewFactor);
            end;
      end;

      AddCondTerm(NewTerm);
    end;
    LiftInClause.Free;
    LiftInExp.Free;
    //get rid of the original term with the IN clause
    CondTerm[InTermIX].Free;
    CondTermList.Delete(InTermIX);
    Result := True;
  end;
end;

function TOvcRvExpression.BindField(
  const FieldName: string): TOvcAbstractRvField;
begin
  Assert(OwnerReport <> nil);
  Result := OwnerReport.Fields.ItemByName(FieldName);
end;

function TOvcRvExpression.RefersTo(AField: TOvcAbstractRvField): Boolean;
var
  i: Integer;
begin
  if IsConstant then begin
    Result := False;
    exit;
  end;
  for i := 0 to pred(CondTermCount) do
    if CondTerm[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpression.SetCondTerm(Index: Integer;
  const Value: TOvcRvExpCondTerm);
begin
  CondTermList[Index] := Value;
end;


{ TOvcRvExpressionList }

function TOvcRvExpressionList.AddExpression(
  Expression: TOvcRvExpression): TOvcRvExpression;
begin
  FExpressionList.Add(Expression);
  Result := Expression;
end;

procedure TOvcRvExpressionList.Assign(const Source: TOvcRvExpNode);
var
  i: Integer;
begin
  if Source is TOvcRvExpressionList then begin
    Clear;
    for i := 0 to pred(TOvcRvExpressionList(Source).ExpressionCount) do
      AddExpression(TOvcRvExpression.Create(Self)).Assign(
        TOvcRvExpressionList(Source).Expression[i]);
  end else
    AssignError(Source);
end;

procedure TOvcRvExpressionList.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(ExpressionCount) do
    if not Expression[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  FIsConstant := True;
end;

constructor TOvcRvExpressionList.Create(
  AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  FExpressionList := TList.Create;
end;

procedure TOvcRvExpressionList.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(ExpressionCount) do
    Expression[i].Free;
  FExpressionList.Clear;
end;

destructor TOvcRvExpressionList.Destroy;
begin
  Clear;
  FExpressionList.Free;
  inherited;
end;

function TOvcRvExpressionList.GetType: TOvcDRDataType;
var
  ArgList: Variant;
  i: Integer;
  Res: Variant;
begin
  ArgList := VarArrayCreate([0, ExpressionCount - 1], varVariant);
  try
    for i := 0 to ExpressionCount - 1 do
      if Expression[i].IsConstant then
        ArgList[i] := Expression[i].GetValue(nil)
      else
        ArgList[i] := varNull;
    Res := Owner.OwnerReport.DoExtern(ArgList);
    case VarType(Res) of
    varSmallint,
    varInteger,
    varByte:
      Result := dtInteger;
    varSingle,
    varDouble,
    varCurrency:
      Result := dtFloat;
    varDate:
      Result := dtDateTime;
    varOleStr:
      Result := dtString;
    varBoolean:
      Result := dtBoolean;
    else
      Result := dtCustom;
    end;
  finally
    ArgList := varNull;
  end;
end;

function TOvcRvExpressionList.GetValue(Data: Pointer): Variant;
var
  ArgList: Variant;
  i: Integer;
begin
  ArgList := VarArrayCreate([0, ExpressionCount - 1], varVariant);
  try
    for i := 0 to ExpressionCount - 1 do
      ArgList[i] := Expression[i].GetValue(Data);
    Result := Owner.OwnerReport.DoExtern(ArgList);
  finally
    ArgList := varNull;
  end;
end;

function TOvcRvExpressionList.GetExpression(
  Index: Integer): TOvcRvExpression;
begin
  Result := TOvcRvExpression(FExpressionList[Index]);
end;

function TOvcRvExpressionList.GetExpressionCount: Integer;
begin
  Result := FExpressionList.Count;
end;

function TOvcRvExpressionList.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

function TOvcRvExpressionList.Reduce: Boolean;
var
  I : integer;
begin
  for i := 0 to pred(ExpressionCount) do
    if Expression[i].Reduce then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpressionList.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
var
  I : integer;
begin
  for i := 0 to pred(ExpressionCount) do
    if Expression[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpressionList.SetExpression(Index: Integer;
  const Value: TOvcRvExpression);
begin
  FExpressionList[Index] := Value;
end;


{ TOvcRvExpCondTerm }

function TOvcRvExpCondTerm.AddCondFactor(Factor: TOvcRvExpCondFactor): TOvcRvExpCondFactor;
begin
  CondFactorList.Add(Factor);
  Result := Factor;
end;

function TOvcRvExpCondTerm.InsertCondFactor(Index: Integer; Factor : TOvcRvExpCondFactor): TOvcRvExpCondFactor;
begin
  CondFactorList.Insert(Index, Factor);
  Result := Factor;
end;

function TOvcRvExpCondTerm.AsBoolean(Data: Pointer): Boolean;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  for i := 0 to pred(CondFactorCount) do
    if not CondFactor[i].AsBoolean(Data) then begin
      Result := False;
      exit;
    end;
  Result := True;
end;

procedure TOvcRvExpCondTerm.Assign(const Source: TOvcRvExpNode);
var
  i : Integer;
begin
  if Source is TOvcRvExpCondTerm then begin
    Clear;
    for i := 0 to pred(TOvcRvExpCondTerm(Source).CondFactorCount) do begin
      AddCondFactor(TOvcRvExpCondFactor.Create(Self)).Assign(
        TOvcRvExpCondTerm(Source).CondFactor[i]);
    end;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpCondTerm.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(CondFactorCount) do
    if not CondFactor[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  ConstantValue := GetValue(nil);
  FIsConstant := True;
end;

constructor TOvcRvExpCondTerm.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  CondFactorList := TList.Create;
end;

procedure TOvcRvExpCondTerm.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(CondFactorCount) do
    CondFactor[i].Free;
  CondFactorList.Clear;
end;

destructor TOvcRvExpCondTerm.Destroy;
begin
  Clear;
  CondFactorList.Free;
  inherited;
end;

function TOvcRvExpCondTerm.GetCondFactor(
  Index: Integer): TOvcRvExpCondFactor;
begin
  Result := TOvcRvExpCondFactor(CondFactorList[Index]);
end;

function TOvcRvExpCondTerm.GetCondFactorCount: Integer;
begin
  Result := CondFactorList.Count;
end;

function TOvcRvExpCondTerm.GetType: TOvcDRDataType;
var
  i: Integer;
begin
  if CondFactorCount > 1 then begin
    {force type conversion at lower level if necessary}
    for i := 0 to pred(CondFactorCount) do
      CondFactor[i].GetType;
    Result := dtBoolean;
  end else
    Result := CondFactor[0].GetType;
end;

function TOvcRvExpCondTerm.GetValue(Data: Pointer): Variant;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  if CondFactorCount > 1 then
    Result := AsBoolean(Data)
  else
    Result := CondFactor[0].GetValue(Data);
end;

function TOvcRvExpCondTerm.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

function TOvcRvExpCondTerm.Reduce: Boolean;
var
  i, j : Integer;
  LiftFactor : TOvcRvExpCondFactor;
  LiftTerm: TOvcRvExpCondTerm;
  B : Boolean;
begin
  {Look for conditional factors nested inside redundant parens}
  { - eliminate parens when found}
  {Look for BETWEEN expressions and convert them to two comparisons}
  Result := False;
  for i := 0 to pred(CondFactorCount) do begin
    LiftTerm := nil;
    with CondFactor[i] do begin
      if (CondPrimary.RelOp = roNone) then
        if CondPrimary.BetweenClause <> nil then begin
          if not CondPrimary.BetweenClause.Negated xor UnaryNot then begin
            {create a new CondPrimary to hold the >= comparison}
            LiftFactor := TOvcRvExpCondFactor.Create(Self);
            LiftFactor.CondPrimary := TOvcRvExpCondPrimary.Create(LiftFactor);
            LiftFactor.CondPrimary.RelOp := roGE;
            LiftFactor.CondPrimary.SimpleExp1 := TOvcRvExpSimpleExpression.Create(LiftFactor.CondPrimary);
            LiftFactor.CondPrimary.SimpleExp1.Assign(CondPrimary.SimpleExp1);
            LiftFactor.CondPrimary.SimpleExp2 := TOvcRvExpSimpleExpression.Create(LiftFactor.CondPrimary);
            LiftFactor.CondPrimary.SimpleExp2.Assign(CondPrimary.BetweenClause.SimpleLow);
            InsertCondFactor(i, LiftFactor);
            {convert current CondPrimary to a >= comparison}
            CondPrimary.RelOp := roLE;
            CondPrimary.SimpleExp2 := TOvcRvExpSimpleExpression.Create(CondPrimary);
            CondPrimary.SimpleExp2.Assign(CondPrimary.BetweenClause.SimpleHigh);
            CondPrimary.BetweenClause.Free;
            CondPrimary.BetweenClause := nil;
            Result := True;
            UnaryNot := False;
            break;
          end;
        end else
        if CondPrimary.LikeClause <> nil then begin
          if not CondPrimary.LikeClause.Negated xor UnaryNot then begin
            if CondPrimary.LikeClause.CanLimit then begin
              {create a new CondPrimary to hold the >= comparison}
              LiftFactor := TOvcRvExpCondFactor.Create(Self);
              LiftFactor.CondPrimary := TOvcRvExpCondPrimary.Create(LiftFactor);
              LiftFactor.CondPrimary.RelOp := roGE;
              LiftFactor.CondPrimary.SimpleExp1 := TOvcRvExpSimpleExpression.Create(LiftFactor.CondPrimary);
              LiftFactor.CondPrimary.SimpleExp1.Assign(CondPrimary.SimpleExp1);
              LiftFactor.CondPrimary.SimpleExp2 := CreateLiteralStringExp(LiftFactor, CondPrimary.LikeClause.GetLowLimit(nil));
              InsertCondFactor(i, LiftFactor);
              {create a new CondPrimary to hold the <= comparison}
              LiftFactor := TOvcRvExpCondFactor.Create(Self);
              LiftFactor.CondPrimary := TOvcRvExpCondPrimary.Create(LiftFactor);
              LiftFactor.CondPrimary.RelOp := roL;
              LiftFactor.CondPrimary.SimpleExp1 := TOvcRvExpSimpleExpression.Create(LiftFactor.CondPrimary);
              LiftFactor.CondPrimary.SimpleExp1.Assign(CondPrimary.SimpleExp1);
              LiftFactor.CondPrimary.SimpleExp2 := CreateLiteralStringExp(LiftFactor, CondPrimary.LikeClause.GetHighLimit(nil));
              InsertCondFactor(i, LiftFactor);
              if CondPrimary.LikeClause.CanReplaceWithCompare then begin
                {we no longer need the LIKE clause}
                CondFactor[i + 2].Free;
                CondFactorList.Delete(i + 2); // adjust for the two we just inserted
              end else
                CondPrimary.LikeClause.Limited := True;
              Result := True;
              break;
            end;
          end;
        end else
        if (CondPrimary.InClause = nil)
        and (CondPrimary.IsTest = nil) then
          if CondPrimary.SimpleExp1 <> nil then
            with CondPrimary.SimpleExp1 do
              if TermCount  = 1 then begin
                with Term[0] do
                  if FactorCount = 1 then
                    with Factor[0] do
                      if CondExp <> nil then
                        with CondExp do
                          if CondTermCount = 1 then
                            LiftTerm := CondTerm[0];
              end;
      if LiftTerm <> nil then begin
        //first lift all but the very first conditional factor to this level
        for j := 1 to pred(LiftTerm.CondFactorCount) do
          Self.AddCondFactor(TOvcRvExpCondFactor.Create(Self)).
            Assign(LiftTerm.CondFactor[j]);
        //then copy the contents of the first conditional factor
        //  (possibly the only one) into this one
        B := UnaryNot; // save UnaryNot setting
        LiftFactor := TOvcRvExpCondFactor.Create(Self);
        LiftFactor.Assign(LiftTerm.CondFactor[0]);
        Clear;
        Assign(LiftFactor);
        LiftFactor.Free;
        UnaryNot := UnaryNot xor B;
        Result := True;
        {Get out. We may have more to do here, but Global Logic will
         call us again, and there may be other transformations that can
         be applied first.}
        break;
      end;
      if Reduce then begin
        {factor itself was reduced}
        Result := True;
        break;
      end;
    end;
  end;
end;

function TOvcRvExpCondTerm.RefersTo(AField: TOvcAbstractRvField): Boolean;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := False;
    exit;
  end;
  for i := 0 to pred(CondFactorCount) do
    if CondFactor[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpCondTerm.SetCondFactor(Index: Integer;
  const Value: TOvcRvExpCondFactor);
begin
  CondFactorList[Index] := Value;
end;

{ TOvcRvExpFieldRef }

procedure TOvcRvExpFieldRef.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpFieldRef then begin
    FieldName := TOvcRvExpFieldRef(Source).FieldName;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpFieldRef.CheckType;
begin
  FType := Field.DataType;
  TypeKnown := True;
end;

function TOvcRvExpFieldRef.GetField: TOvcAbstractRvField;
begin
  if FField = nil then begin
    FField := Parent.BindField(FieldName);
    if FField = nil then
      raise Exception.Create('Unknown field:"' + FieldName + '"');
  end;
  Result := FField;
end;

function TOvcRvExpFieldRef.GetType: TOvcDRDataType;
begin
  if not TypeKnown then
    CheckType;
  Result := FType;
end;

function TOvcRvExpFieldRef.GetValue(Data: Pointer): Variant;
begin
  Result := Field.GetValue(Data);
end;

procedure TOvcRvExpFieldRef.MatchType(ExpectedType: TOvcDRDataType);
begin
  if GetType <> ExpectedType then
    case GetType of
    dtString,
    dtDateTime,
    dtBoolean,
    dtCustom :
      TypeMismatch;
    dtFloat,
    dtInteger,
    dtDWord:
      case ExpectedType of
      dtFloat,
      dtInteger,
      dtDWord:
        ;
      else
        TypeMismatch;
      end;
    end;
end;

function TOvcRvExpFieldRef.RefersTo(AField: TOvcAbstractRvField): Boolean;
begin
  Result := Field = AField;
end;

{ TOvcRvExpAggregate }

procedure TOvcRvExpAggregate.AddAggregate(Target: TList);
begin
  Target.Add(Self);
end;

procedure TOvcRvExpAggregate.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpAggregate then begin
    AgFunction := TOvcRvExpAggregate(Source).AgFunction;
    SimpleExpression.Free;
    SimpleExpression := nil;
    if assigned(TOvcRvExpAggregate(Source).SimpleExpression) then begin
      SimpleExpression := TOvcRvExpSimpleExpression.Create(Self);
      SimpleExpression.Assign(TOvcRvExpAggregate(Source).SimpleExpression);
    end;
  end else
    AssignError(Source);
end;

destructor TOvcRvExpAggregate.Destroy;
begin
  SimpleExpression.Free;
  inherited;
end;

{
procedure TOvcRvExpAggregate.SetSourceField(SourceField: TOvcAbstractRvField);
begin
  FSourceField := SourceField;
end;
}

function TOvcRvExpAggregate.GetValue(Data: Pointer): Variant;
begin
  Assert(Data <> nil);
  if TObject(Data) is TOvcRvIndex then begin
    case AgFunction of
    agCount :
      Result := TOvcRvIndex(Data).Count;
    agMin :
      Result := TOvcRvIndex(Data).Min(SimpleExpression);
    agMax :
      Result := TOvcRvIndex(Data).Max(SimpleExpression);
    agSum :
      Result := TOvcRvIndex(Data).Sum(SimpleExpression)
    else //agAvg :
      Result := TOvcRvIndex(Data).Avg(SimpleExpression)
    end;
  end else
  if TObject(Data) is TOvcRvIndexGroup then begin
    case AgFunction of
    agCount :
      Result := TOvcRvIndexGroup(Data).Count;
    agMin :
      Result := TOvcRvIndexGroup(Data).Min(SimpleExpression);
    agMax :
      Result := TOvcRvIndexGroup(Data).Max(SimpleExpression);
    agSum :
      Result := TOvcRvIndexGroup(Data).Sum(SimpleExpression)
    else //agAvg :
      Result := TOvcRvIndexGroup(Data).Avg(SimpleExpression)
    end;
  end else
    Assert(False);
end;

function TOvcRvExpAggregate.GetType: TOvcDRDataType;
begin
  if SimpleExpression = nil then
    Result := dtFloat
  else
    case SimpleExpression.GetType of
    dtFloat :
      Result := dtFloat;
    else
      case AgFunction of
      agCount,
      agAvg:
        Result := dtFloat;
      else
        Result := SimpleExpression.GetType;
      end;
    end;
end;

procedure TOvcRvExpAggregate.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtFloat,
  dtInteger,
  dtDWord:
    ;
  else
    TypeMismatch;
  end;
end;

function TOvcRvExpAggregate.Reduce: Boolean;
begin
  if SimpleExpression <> nil then
    Result := SimpleExpression.Reduce
  else
    Result := False;
end;

{ TOvcRvExpColumn }

procedure TOvcRvExpColumn.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpColumn then begin
    ColumnName := TOvcRvExpColumn(Source).ColumnName;
  end else
    AssignError(Source);
end;

{ TOvcRvExpIsTest }

function TOvcRvExpIsTest.AsBoolean(const TestValue: Variant): Boolean;
begin
  case IsOp of
  ioNull :
    Result := VarIsNull(TestValue) xor UnaryNot;
  ioTrue :
    if UnaryNot then
      Result := not TestValue
    else
      Result := TestValue;
  ioFalse :
    if UnaryNot then
      Result := TestValue
    else
      Result := not TestValue;
  else
  //ioUnknown :
    Result := VarIsNull(TestValue) xor UnaryNot;
  end;
end;

procedure TOvcRvExpIsTest.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpIsTest then begin
    UnaryNot := TOvcRvExpIsTest(Source).UnaryNot;
    IsOp := TOvcRvExpIsTest(Source).IsOp;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpIsTest.MatchType(ExpectedType: TOvcDRDataType);
begin
end;

{ TOvcRvExpBetweenClause }

function TOvcRvExpBetweenClause.AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
begin
  Result :=
    ((TestValue >= SimpleLow.GetValue(Data)) and
      (TestValue <= SimpleHigh.GetValue(Data))) xor Negated;
end;

procedure TOvcRvExpBetweenClause.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpBetweenClause then begin
    Negated := TOvcRvExpBetweenClause(Source).Negated;
    SimpleLow.Free;
    SimpleLow := TOvcRvExpSimpleExpression.Create(Self);
    SimpleLow.Assign(TOvcRvExpBetweenClause(Source).SimpleLow);
    SimpleHigh.Free;
    SimpleHigh := TOvcRvExpSimpleExpression.Create(Self);
    SimpleHigh.Assign(TOvcRvExpBetweenClause(Source).SimpleHigh);
  end else
    AssignError(Source);
end;

procedure TOvcRvExpBetweenClause.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant :=
    SimpleLow.IsConstant and SimpleHigh.IsConstant;
end;

destructor TOvcRvExpBetweenClause.Destroy;
begin
  SimpleLow.Free;
  SimpleHigh.Free;
  inherited;
end;

function TOvcRvExpBetweenClause.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpBetweenClause.MatchType(ExpectedType: TOvcDRDataType);
begin
  SimpleLow.MatchType(ExpectedType);
  SimpleHigh.MatchType(ExpectedType);
end;

function TOvcRvExpBetweenClause.Reduce: Boolean;
begin
  Result := SimpleLow.Reduce or SimpleHigh.Reduce;
end;

function TOvcRvExpBetweenClause.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
begin
  Result := FSimpleLow.RefersTo(AField) or FSimpleHigh.RefersTo(AField);
end;

{ TOvcRvExpLikePattern }

constructor TOvcRvExpLikePattern.Create(SearchPattern: string; const Escape: string);
var
  i: Integer;
  Mask : string;
  Esc: Char;
begin
  FloatPatterns := TStringList.Create;
  FloatMasks := TStringList.Create;

  {
    Search pattern is made up of
      0 or 1 lead pattern
      0-N floating patterns, and
      0 or 1 trail pattern.
    Patterns are separated by '%'.
    If search pattern starts with '%', it does not have a lead pattern.
    If search pattern ends with '%', it does not have a trail pattern.

    Place holders, '_', are not considered here but in Find.

  }

  {build a separate mask string for place holders so that we can use
   the same logic for escaped and non-escaped search patterns}

  Mask := SearchPattern;
  if Escape <> '' then begin
    i := length(SearchPattern);
    Esc := Escape[1];
    while i >= 2 do begin
      if SearchPattern[i - 1] = Esc then begin
        Mask[i] := ' '; // blank out the mask character
        //remove the escape
        Delete(Mask, i - 1, 1);
        Delete(SearchPattern, i - 1, 1);
      end;
      dec(i);
    end;
  end;

  if (SearchPattern = '') then
    exit;

  if Mask[1] <> '%' then begin
    {we have a lead pattern}
    i := pos('%', Mask);
    if i = 0 then begin
      {entire search pattern is a lead pattern}
      LeadPattern := SearchPattern;
      LeadMask := Mask;
      exit;
    end;

    LeadPattern := copy(SearchPattern, 1, i - 1);
    LeadMask := copy(Mask, 1, i - 1);

    Delete(SearchPattern, 1, i - 1);
    Delete(Mask, 1, i - 1);
  end;

  if (SearchPattern = '') then
    exit;

  i := length(Mask);

  if Mask[i] <> '%' then begin
    {we have a trail pattern}
    while (i > 0) and (Mask[i] <> '%') do
      dec(i);
    if i = 0 then begin
      {entire remaining pattern is a trail pattern}
      TrailPattern := SearchPattern;
      TrailMask := Mask;
      exit;
    end;

    TrailPattern := copy(SearchPattern, i + 1, MaxInt);
    TrailMask := copy(Mask, i + 1, MaxInt);

    Delete(SearchPattern, i + 1, MaxInt);
    Delete(Mask, i + 1, MaxInt);
  end;

  {we now have one or more floating patterns separated by '%'}

  if Mask = '' then
    exit;

  if Mask[1] <> '%' then
    exit;

  Delete(Mask, 1, 1);
  Delete(SearchPattern, 1, 1);

  repeat

    i := pos('%', Mask);

    if i = 0 then begin
      {entire remaining search pattern is one pattern}
      FloatPatterns.Add(SearchPattern);
      FloatMasks.Add(Mask);
      exit;
    end;

    FloatPatterns.Add(copy(SearchPattern, 1, i - 1));
    FloatMasks.Add(copy(Mask, 1, i - 1));

    Delete(SearchPattern, 1, i);
    Delete(Mask, 1, i);

  until SearchPattern = '';

end;

destructor TOvcRvExpLikePattern.Destroy;
begin
  FloatPatterns.Free;
  FloatMasks.Free;
  inherited;
end;

function Match(const Pattern, Mask: string; PatternLength: Integer;
  const TextToSearch: string; StartIndex: Integer): Boolean;
{look for an exact match of the pattern at StartIndex, disregarding
 locations with '_' in the mask}
var
  i : Integer;
begin
  i := length(TextToSearch);
  if i < PatternLength then begin
    Result := False;
    exit;
  end;
  for i := 1 to PatternLength do
    if (Mask[i] <> '_')
    and (TextToSearch[i + StartIndex - 1] <> Pattern[i]) then begin
        Result := False;
        exit;
      end;
  Result := True;
end;

function Scan(const Pattern, Mask: string; PatternLength: Integer;
  const TextToSearch: string; StartIndex: Integer): Integer;
{scan for a match of the pattern starting at StartIndex, disregarding
 locations with '_' in the mask. Return -1 if not found, otherwise
 return the position immediately following the matched phrase}
var
  L, i : Integer;
  Found : Boolean;
begin
  L := length(TextToSearch);
  repeat
    if L < PatternLength then begin
      Result := -1;
      exit;
    end;
    Found := True;
    for i := 1 to PatternLength do
      if (i - 1 > L) or (Mask[i] <> '_')
      and (TextToSearch[i + StartIndex - 1] <> Pattern[i]) then begin
        Found := False;
        break;
      end;
    if Found then begin
      Result := StartIndex + PatternLength;
      exit;
    end;
    inc(StartIndex);
    dec(L);
  until False;
end;

function TOvcRvExpLikePattern.Find(const TextToSearch: string): Boolean;
{Search the TextToSearch. Return true if the search pattern was found}
var
  i, l, StartPos, EndPos: Integer;
  P : string;
begin
  if LeadPattern <> '' then begin
    i := length(LeadPattern);
    if not Match(LeadPattern, LeadMask, i, TextToSearch, 1) then begin
      Result := False;
      exit;
    end;
    StartPos := i + 1;
  end else
    StartPos := 1;
  if TrailPattern <> '' then begin
    i := length(TextToSearch) - length(TrailPattern) + 1;
    if i < StartPos then begin
      Result := False;
      exit;
    end;
    if not Match(TrailPattern, TrailMask, length(TrailPattern), TextToSearch, i) then begin
      Result := False;
      exit;
    end;
    EndPos := i - 1;
  end else
    EndPos := length(TextToSearch);

  if FloatPatterns.Count = 0 then
    if length(TextToSearch) <> length(LeadPattern) + length(TrailPattern) then begin
      Result := False;
      exit;
    end;

  for i := 0 to pred(FloatPatterns.Count) do begin
    P := FloatPatterns[i];
    l := length(P);
    if l > EndPos - StartPos + 1 then begin
      Result := False;
      exit;
    end;
    StartPos := Scan(P, FloatMasks[i], l, TextToSearch, StartPos);
    if StartPos = -1 then begin
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

{ TOvcRvExpLikeClause }
function TOvcRvExpLikeClause.AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
begin
  if VarIsNull(TestValue) then begin
    Result := Negated;
    exit;
  end;
  if LikePattern = nil then
    if EscapeExp <> nil then
      LikePattern := TOvcRvExpLikePattern.Create(SimpleExp.GetValue(Data), EscapeExp.GetValue(Data))
    else
      LikePattern := TOvcRvExpLikePattern.Create(SimpleExp.GetValue(Data), '');
  Result := LikePattern.Find(TestValue) xor Negated;
  if not IsConstant then begin
    LikePattern.Free;
    LikePattern := nil;
  end;
end;

procedure TOvcRvExpLikeClause.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpLikeClause then begin
    if SimpleExp = nil then
      SimpleExp := TOvcRvExpSimpleExpression.Create(Self);
    SimpleExp.Assign(TOvcRvExpLikeClause(Source).SimpleExp);
    if (EscapeExp = nil) and (TOvcRvExpLikeClause(Source).EscapeExp <> nil) then begin
      EscapeExp := TOvcRvExpSimpleExpression.Create(Self);
      EscapeExp.Assign(TOvcRvExpLikeClause(Source).EscapeExp);
    end;
    Negated := TOvcRvExpLikeClause(Source).Negated;
  end else
    AssignError(Source);
end;

function TOvcRvExpLikeClause.CanLimit: Boolean;
var
  S: string;
begin
  Result := False;
  if not Limited
    and SimpleExp.IsConstant
    and ((EscapeExp = nil) or EscapeExp.IsConstant) then begin
      S := SimpleExp.GetValue(nil);
      if not CharInSet(S[1], ['%', '_']) then
        Result := True;
    end;
end;

function TOvcRvExpLikeClause.CanReplaceWithCompare: Boolean;
var
  S: string;
begin
  Result := False;
  if not Limited
    and SimpleExp.IsConstant
    and ((EscapeExp = nil) or EscapeExp.IsConstant) then begin
      S := SimpleExp.GetValue(nil);
      Result := (pos('_', S) = 0)
        and (length(S) > 1)
        and (pos('%', S) = length(S));
    end;
end;

procedure TOvcRvExpLikeClause.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant := SimpleExp.IsConstant and ((EscapeExp = nil) or EscapeExp.IsConstant);
end;

destructor TOvcRvExpLikeClause.Destroy;
begin
  SimpleExp.Free;
  EscapeExp.Free;
  LikePattern.Free;
  inherited;
end;

function TOvcRvExpLikeClause.GetHighLimit(Data: Pointer): string;
begin
  Result := GetLowLimit(Data);
  inc(Result[length(Result)]);
end;

function TOvcRvExpLikeClause.GetLowLimit(Data: Pointer): string;
var
  P : Integer;
begin
  Result := SimpleExp.GetValue(Data);
  P := 1;
  while (P <= length(Result))
    and not CharInSet(Result[P], ['%', '_']) do
      inc(P);
  dec(P);
  if P < length(Result) then
    Result := copy(Result, 1 , P);
end;

function TOvcRvExpLikeClause.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpLikeClause.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtString :
    SimpleExp.MatchType(ExpectedType);
  else
    SQLError('The LIKE operator may only be applied to plain text fields');
  end;
end;

function TOvcRvExpLikeClause.Reduce: Boolean;
begin
  Result := SimpleExp.Reduce or ((EscapeExp <> nil) and EscapeExp.Reduce);
end;

function TOvcRvExpLikeClause.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
begin
  Result := SimpleExp.RefersTo(AField) or ((EscapeExp <> nil) and EscapeExp.RefersTo(AField));
end;

{ TOvcRvExpInClause }

function TOvcRvExpInClause.AsBoolean(Data: Pointer; const TestValue: Variant): Boolean;
begin
  Result := SimpleExpList.Contains(Data, TestValue);
  Result := Result xor Negated;
end;

procedure TOvcRvExpInClause.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpInClause then begin
    SimpleExpList.Free;
    SimpleExpList := TOvcRvExpSimpleExpressionList.Create(Self);
    SimpleExpList.Assign(TOvcRvExpInClause(Source).SimpleExpList);
    Negated := TOvcRvExpInClause(Source).Negated;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpInClause.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant := SimpleExpList.IsConstant;
end;

destructor TOvcRvExpInClause.Destroy;
begin
  SimpleExpList.Free;
  inherited;
end;

function TOvcRvExpInClause.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpInClause.MatchType(ExpectedType: TOvcDRDataType);
begin
  SimpleExpList.MatchType(ExpectedType);
end;

function TOvcRvExpInClause.Reduce: Boolean;
begin
  Result := SimpleExpList.Reduce;
end;

function TOvcRvExpInClause.RefersTo(AField: TOvcAbstractRvField): Boolean;
begin
  Result := SimpleExpList.RefersTo(AField);
end;

function SimpleCompare(RelOp: TOvcRvExpRelOp; const Val1, Val2: Variant): Boolean;
begin
  if VarIsNull(Val1) or
     VarIsNull(Val2) then begin
    Result := False;
    Exit;
  end;
  Assert(RelOp <> roNone);
  case RelOp of
  roEQ :
    if (VarType(Val1) and VarTypeMask = VarDate)
    and (VarType(Val2) and VarTypeMask = VarDate) then
      Result := abs(double(Val1) - double(Val2)) < TimeDelta
    else
      Result := Val1 = Val2;
  roLE :
    Result := Val1 <= Val2;
  roL :
    Result := Val1 < Val2;
  roG :
    Result := Val1 > Val2;
  roGE :
    Result := Val1 >= Val2;
  else//roNE :
    if (VarType(Val1) and VarTypeMask = VarDate)
    and (VarType(Val2) and VarTypeMask = VarDate) then
      Result := abs(double(Val1) - double(Val2)) >= TimeDelta
    else
      Result := Val1 <> Val2;
  end;
end;

{ TOvcRvExpCondPrimary }
function TOvcRvExpCondPrimary.AsBoolean(Data: Pointer): Boolean;
begin
  Result := False;
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  if not TypeChecked then
    CheckType;

  if RelOp = roNone then
    if BetweenClause <> nil then
      Result := BetweenClause.AsBoolean(Data, SimpleExp1.GetValue(Data))
    else if LikeClause <> nil then
      Result := LikeClause.AsBoolean(Data, SimpleExp1.GetValue(Data))
    else if InClause <> nil then
      Result := InClause.AsBoolean(Data, SimpleExp1.GetValue(Data))
    else if IsTest <> nil then
      Result := IsTest.AsBoolean(SimpleExp1.GetValue(Data))
    else
      Result := SimpleExp1.GetValue(Data)
  else if SimpleExp2 <> nil then
    Result := SimpleCompare(RelOp, SimpleExp1.GetValue(Data), SimpleExp2.GetValue(Data))
  else
    SQLError('Simple expression or ANY/ALL clause expected');
end;

procedure TOvcRvExpCondPrimary.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpCondPrimary then begin

    Clear;

    if assigned(TOvcRvExpCondPrimary(Source).SimpleExp1) then begin
      SimpleExp1 := TOvcRvExpSimpleExpression.Create(Self);
      SimpleExp1.Assign(TOvcRvExpCondPrimary(Source).SimpleExp1);
    end;

    RelOp := TOvcRvExpCondPrimary(Source).RelOp;

    if assigned(TOvcRvExpCondPrimary(Source).SimpleExp2) then begin
      SimpleExp2 := TOvcRvExpSimpleExpression.Create(Self);
      SimpleExp2.Assign(TOvcRvExpCondPrimary(Source).SimpleExp2);
    end;

    if assigned(TOvcRvExpCondPrimary(Source).BetweenClause) then begin
      BetweenClause := TOvcRvExpBetweenClause.Create(Self);
      BetweenClause.Assign(TOvcRvExpCondPrimary(Source).BetweenClause);
    end;

    if assigned(TOvcRvExpCondPrimary(Source).LikeClause) then begin
      LikeClause := TOvcRvExpLikeClause.Create(Self);
      LikeClause.Assign(TOvcRvExpCondPrimary(Source).LikeClause);
    end;

    if assigned(TOvcRvExpCondPrimary(Source).InClause) then begin
      InClause := TOvcRvExpInClause.Create(Self);
      InClause.Assign(TOvcRvExpCondPrimary(Source).InClause);
    end;

    if assigned(TOvcRvExpCondPrimary(Source).IsTest) then begin
      IsTest := TOvcRvExpIsTest.Create(Self);
      IsTest.Assign(TOvcRvExpCondPrimary(Source).IsTest);
    end;

  end else
    AssignError(Source);
end;

procedure TOvcRvExpCondPrimary.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant := False;
  if SimpleExp1 <> nil then
    if not SimpleExp1.IsConstant then
        exit;
  case RelOp of
  roNone :
    if BetweenClause <> nil then
      if not BetweenClause.IsConstant then
        exit
      else
    else
    if LikeClause <> nil then
      if not LikeClause.IsConstant then
        exit
      else
    else
    if InClause <> nil then
      if not InClause.IsConstant then
        exit;
  else
    begin
       Assert(SimpleExp2 <> nil);
      if not SimpleExp2.IsConstant then
        exit;
    end;
  end;
  ConstantValue := GetValue(nil);
  FIsConstant := True;
end;

procedure TOvcRvExpCondPrimary.CheckType;
var
  T1 : TOvcDRDataType;
begin
  if SimpleExp1 <> nil then
    T1 := SimpleExp1.GetType
  else
    T1 := dtCustom; {anything that doesn't match a valid SQL type}

  if RelOp = roNone then begin
    if BetweenClause <> nil then
      BetweenClause.MatchType(T1)
    else if LikeClause <> nil then
      LikeClause.MatchType(T1)
    else if InClause <> nil then
      InClause.MatchType(T1)
    else if IsTest <> nil then
      IsTest.MatchType(T1);
  end else begin
    Assert(SimpleExp2 <> nil);
    SimpleExp2.MatchType(T1);
  end;
end;

procedure TOvcRvExpCondPrimary.Clear;
begin
  SimpleExp1.Free;
  SimpleExp1 := nil;
  BetweenClause.Free;
  BetweenClause := nil;
  LikeClause.Free;
  LikeClause := nil;
  InClause.Free;
  InClause := nil;
  IsTest.Free;
  IsTest := nil;
  SimpleExp2.Free;
  SimpleExp2 := nil;
  inherited;
end;


destructor TOvcRvExpCondPrimary.Destroy;
begin
  Clear;
  inherited;
end;

function TOvcRvExpCondPrimary.GetType: TOvcDRDataType;
begin
  if SimpleExp1 <> nil then
    Result := SimpleExp1.GetType
  else
    Result := dtBoolean; {should never happen}
  case RelOp of
  roNone :
    if (BetweenClause <> nil)
    or (LikeClause <> nil)
    or (InClause <> nil)
    or (IsTest <> nil) then
      Result := dtBoolean;
  else
    if SimpleExp2 <> nil then
      SimpleExp2.MatchType(Result);
    Result := dtBoolean;
  end;
end;

function TOvcRvExpCondPrimary.GetValue(Data: Pointer): Variant;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  case GetType of
  dtBoolean:
    Result := AsBoolean(Data)
  else
    Result := SimpleExp1.GetValue(Data);
  end;
end;

function TOvcRvExpCondPrimary.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

function TOvcRvExpCondPrimary.JustSimpleExpression: Boolean;
begin
  Result := (RelOp = roNone)
   and (BetweenClause = nil)
   and (LikeClause = nil)
   and (InClause = nil)
   and (IsTest = nil);
end;

function TOvcRvExpCondPrimary.Reduce: Boolean;
begin
  Result := True;
  if (SimpleExp1 <> nil) and SimpleExp1.Reduce then
    exit;
  if (SimpleExp2 <> nil) and SimpleExp2.Reduce then
    exit;
  if (BetweenClause <> nil) and BetweenClause.Reduce then
    exit;
  if (LikeClause <> nil) and LikeClause.Reduce then
    exit;
  if (InClause <> nil) and InClause.Reduce then
    exit;
  Result := False;
end;

function TOvcRvExpCondPrimary.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
begin
  if IsConstant then begin
    Result := False;
    exit;
  end;

  if RelOp = roNone then
    if BetweenClause <> nil then
      Result := BetweenClause.RefersTo(AField)
    else
    if LikeClause <> nil then
      Result := LikeClause.RefersTo(AField)
    else
    if InClause <> nil then
      Result := InClause.RefersTo(AField)
    else
    if IsTest <> nil then
      Result := False
    else
      Result := SimpleExp1.RefersTo(AField)
  else
    Result := SimpleExp1.RefersTo(AField) or SimpleExp2.RefersTo(AField);
end;

{ TOvcRvExpCondFactor }

function TOvcRvExpCondFactor.AsBoolean(Data: Pointer): Boolean;
begin
  if TmpKnown then begin
    Result := TmpValue;
    exit;
  end;
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  Result := CondPrimary.AsBoolean(Data);
  if UnaryNot then
    Result := not Result;
end;

procedure TOvcRvExpCondFactor.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpCondFactor then begin
    if CondPrimary = nil then
      CondPrimary := TOvcRvExpCondPrimary.Create(Self);
    CondPrimary.Assign(TOvcRvExpCondFactor(Source).CondPrimary);
    UnaryNot := TOvcRvExpCondFactor(Source).UnaryNot;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpCondFactor.CheckIsConstant;
begin
  FIsConstantChecked := True;
  if CondPrimary.IsConstant then begin
    ConstantValue := GetValue(nil);
    FIsConstant := True;
  end;
end;

procedure TOvcRvExpCondFactor.Clear;
begin
  if CondPrimary <> nil then
    CondPrimary.Clear;
end;

destructor TOvcRvExpCondFactor.Destroy;
begin
  CondPrimary.Free;
  inherited;
end;

function TOvcRvExpCondFactor.GetType: TOvcDRDataType;
begin
  if UnaryNot then
    Result := dtBoolean
  else
    Result := CondPrimary.GetType;
end;

function TOvcRvExpCondFactor.GetValue(Data: Pointer): Variant;
begin
  if TmpKnown then begin
    Result := TmpValue;
    exit;
  end;
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  if UnaryNot then
    Result := AsBoolean(Data)
  else
    Result := CondPrimary.GetValue(Data);
end;

function TOvcRvExpCondFactor.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

function TOvcRvExpCondFactor.Reduce: Boolean;
var
  LiftPrimary : TOvcRvExpCondPrimary;
begin
  {look for a conditional primary nested inside redundant parens}
  {eliminate parens when found}
  Result := False;
  LiftPrimary := nil;
  if (CondPrimary.RelOp = roNone) then
    with CondPrimary do begin
      if JustSimpleExpression then begin
        with SimpleExp1 do
          if TermCount  = 1 then
            with Term[0] do
              if FactorCount = 1 then
                with Factor[0] do
                  if CondExp <> nil then
                    with CondExp do
                      if CondTermCount = 1 then
                        with CondTerm[0] do
                          if CondFactorCount = 1 then
                            with CondFactor[0] do begin
                             LiftPrimary := TOvcRvExpCondPrimary.Create(Self);
                             LiftPrimary.Assign(CondPrimary);
                            end;
        if LiftPrimary <> nil then begin
          Clear;
          Assign(LiftPrimary);
          LiftPrimary.Free;
          Result := True;
        end else
        if Reduce then begin
          {expression itself was reduced}
          Result := True;
        end;
      end;
      if not Result then
        Result := Reduce;
    end;
  if not Result then begin {otherwise we'll be called again}
    {see if this a negated simple expression which can be reversed}
    if UnaryNot and (CondPrimary.RelOp <> roNone) then begin
      {it is, reverse condition and remove NOT}
      case CondPrimary.RelOp of
      roEQ : CondPrimary.RelOp := roNE;
      roLE : CondPrimary.RelOp := roG;
      roL : CondPrimary.RelOp := roGE;
      roG : CondPrimary.RelOp := roLE;
      roGE: CondPrimary.RelOp := roL;
      roNE : CondPrimary.RelOp := roEQ;
      end;
      UnaryNot := False;
      Result := True;
    end;
  end;
end;

function TOvcRvExpCondFactor.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
begin
  if IsConstant then begin
    Result := False;
    exit;
  end;
  Result := CondPrimary.RefersTo(AField);
end;

{ TOvcRvExpFloatLiteral }

procedure TOvcRvExpFloatLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpFloatLiteral then begin
    Value := TOvcRvExpFloatLiteral(Source).Value;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpFloatLiteral.ConvertToNative;
begin
  case GetType of
  dtFloat :
    DoubleValue := StrToFloat(Value);
  end;
  Converted := True;
end;

function TOvcRvExpFloatLiteral.GetType: TOvcDRDataType;
begin
  Result := dtFloat
end;

function TOvcRvExpFloatLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  case GetType of
  dtFloat:
    Result := DoubleValue;
  end;
end;

procedure TOvcRvExpFloatLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtFloat,
  dtInteger,
  dtDWord:
    ;
  else
    TypeMismatch;
  end;
end;

{ TOvcRvExpIntegerLiteral }

procedure TOvcRvExpIntegerLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpIntegerLiteral then begin
    Value := TOvcRvExpIntegerLiteral(Source).Value;
  end else
    AssignError(Source);
end;

function TOvcRvExpIntegerLiteral.GetType: TOvcDRDataType;
begin
  Result := dtInteger;
end;

procedure TOvcRvExpIntegerLiteral.ConvertToNative;
begin
  Int32Value := StrToInt(Value);
  Converted := True;
end;

function TOvcRvExpIntegerLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  Result := Int32Value;
end;

procedure TOvcRvExpIntegerLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtFloat,
  dtInteger,
  dtDWord:
    ;
  else
    TypeMismatch;
  end;
end;

{ TOvcRvExpStringLiteral }

procedure TOvcRvExpStringLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpStringLiteral then begin
    Value := TOvcRvExpStringLiteral(Source).Value;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpStringLiteral.ConvertToNative;
var
  S : string;
begin
  S := copy(Value, 2, length(Value) - 2); //strip quotes
  Assert(GetType = dtString);
  case GetType of
  dtString :
    ShortStringValue := S;
  end;
end;

constructor TOvcRvExpStringLiteral.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  FType := dtString;
end;

function TOvcRvExpStringLiteral.GetType: TOvcDRDataType;
begin
  Result := FType;
end;

function TOvcRvExpStringLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  Assert(GetType = dtString);
  case GetType of
  dtString:
    Result := ShortStringValue;
  end;
end;

procedure TOvcRvExpStringLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtString:
    begin
      FType := ExpectedType;
      Converted := False;
    end;
  else
    TypeMismatch;
  end;
end;

{ TOvcRvExpLiteral }

procedure TOvcRvExpLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpLiteral then begin
    Clear;

    if assigned(TOvcRvExpLiteral(Source).FloatLiteral) then begin
      FloatLiteral := TOvcRvExpFloatLiteral.Create(Self);
      FloatLiteral.Assign(TOvcRvExpLiteral(Source).FloatLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).IntegerLiteral) then begin
      IntegerLiteral := TOvcRvExpIntegerLiteral.Create(Self);
      IntegerLiteral.Assign(TOvcRvExpLiteral(Source).IntegerLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).StringLiteral) then begin
      StringLiteral := TOvcRvExpStringLiteral.Create(Self);
      StringLiteral.Assign(TOvcRvExpLiteral(Source).StringLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).DateLiteral) then begin
      DateLiteral := TOvcRvExpDateLiteral.Create(Self);
      DateLiteral.Assign(TOvcRvExpLiteral(Source).DateLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).TimeLiteral) then begin
      TimeLiteral := TOvcRvExpTimeLiteral.Create(Self);
      TimeLiteral.Assign(TOvcRvExpLiteral(Source).TimeLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).TimeStampLiteral) then begin
      TimeStampLiteral := TOvcRvExpTimeStampLiteral.Create(Self);
      TimeStampLiteral.Assign(TOvcRvExpLiteral(Source).TimeStampLiteral);
    end;

    if assigned(TOvcRvExpLiteral(Source).BooleanLiteral) then begin
      BooleanLiteral := TOvcRvExpBooleanLiteral.Create(Self);
      BooleanLiteral.Assign(TOvcRvExpLiteral(Source).BooleanLiteral);
    end;

  end else
    AssignError(Source);
end;

procedure TOvcRvExpLiteral.Clear;
begin
  FloatLiteral.Free;
  IntegerLiteral.Free;
  StringLiteral.Free;
  DateLiteral.Free;
  TimeLiteral.Free;
  TimeStampLiteral.Free;
  BooleanLiteral.Free;
  FloatLiteral:= nil;
  IntegerLiteral:= nil;
  StringLiteral:= nil;
  DateLiteral:= nil;
  TimeLiteral:= nil;
  TimeStampLiteral:= nil;
  BooleanLiteral := nil;
end;

destructor TOvcRvExpLiteral.Destroy;
begin
  Clear;
  inherited;
end;

function TOvcRvExpLiteral.GetValue: Variant;
begin
  if FloatLiteral <> nil then
    Result := FloatLiteral.GetValue
  else
  if IntegerLiteral <> nil then
    Result := IntegerLiteral.GetValue
  else
  if StringLiteral <> nil then
    Result := StringLiteral.GetValue
  else
  if DateLiteral <> nil then
    Result := DateLiteral.GetValue
  else
  if TimeLiteral <> nil then
    Result := TimeLiteral.GetValue
  else
  if TimestampLiteral <> nil then
    Result := TimestampLiteral.GetValue
  else
  if BooleanLiteral <> nil then
    Result := BooleanLiteral.GetValue
  else
    Assert(False);
end;

function TOvcRvExpLiteral.GetType: TOvcDRDataType;
begin
  Result := dtCustom; {dummy to suppress compiler warning}
  if FloatLiteral <> nil then
    Result := FloatLiteral.GetType
  else
  if IntegerLiteral <> nil then
    Result := IntegerLiteral.GetType
  else
  if StringLiteral <> nil then
    Result := StringLiteral.GetType
  else
  if DateLiteral <> nil then
    Result := DateLiteral.GetType
  else
  if TimeLiteral <> nil then
    Result := TimeLiteral.GetType
  else
  if TimestampLiteral <> nil then
    Result := TimestampLiteral.GetType
  else
  if BooleanLiteral <> nil then
    Result := BooleanLiteral.GetType
  else
    Assert(False);
end;

function IsValidDate(const S: String): Boolean;
begin
  if (length(S) <> 12)
  or (S[6] <> '-')
  or (S[9] <> '-') then
    Result := False
  else
    try
      EncodeDate(
        StrToInt(copy(S, 2, 4)),
        StrToInt(copy(S, 7, 2)),
        StrToInt(copy(S, 10, 2)));
      Result := True;
    except
      Result := False;
    end;
end;

function IsValidTime(const S: String): Boolean;
begin
  if (length(S) <> 10)
  or (S[4] <> ':')
  or (S[7] <> ':') then
    Result := False
  else
    try
      EncodeTime(
          StrToInt(copy(S, 2, 2)),
          StrToInt(copy(S, 5, 2)),
          StrToInt(copy(S, 8, 2)),
          0);
      Result := True;
    except
      Result := False;
    end;
end;

function IsValidTimestamp(const S: string): Boolean;
begin
  if (length(S) < 21)
  or (S[6] <> '-')
  or (S[9] <> '-')
  or (S[12] <> ' ')
  or (S[15] <> ':')
  or (S[18] <> ':') then
    Result := False
  else
    try
      EncodeDate(
        StrToInt(copy(S, 2, 4)),
        StrToInt(copy(S, 7, 2)),
        StrToInt(copy(S, 10, 2)));
      EncodeTime(
        StrToInt(copy(S, 13, 2)),
        StrToInt(copy(S, 16, 2)),
        StrToInt(copy(S, 19, 2)),
        0);
      Result := True;
    except
      Result := False;
    end;
end;

procedure TOvcRvExpLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  if FloatLiteral <> nil then
    FloatLiteral.MatchType(ExpectedType)
  else
  if IntegerLiteral <> nil then
    IntegerLiteral.MatchType(ExpectedType)
  else
  if StringLiteral <> nil then
    case ExpectedType of
    dtDateTime:
      begin
        {String literal, but caller was expecting a Date-type.}
         {See if the string literal represents a valid date.}
         {If it does, convert.}
        if IsValidDate(StringLiteral.Value) then begin
          DateLiteral := TOvcRvExpDateLiteral.Create(Self);
          DateLiteral.Value := StringLiteral.Value;
          StringLiteral.Free;
          StringLiteral := nil;
        end else
         {See if the string literal represents a valid time.}
         {If it does, convert.}
        if IsValidTime(StringLiteral.Value) then begin
          TimeLiteral := TOvcRvExpTimeLiteral.Create(Self);
          TimeLiteral.Value := StringLiteral.Value;
          StringLiteral.Free;
          StringLiteral := nil;
        end else
         {See if the string literal represents a valid time stamp}
         {If it does, convert.}
        if IsValidTimestamp(StringLiteral.Value) then begin
          TimeStampLiteral := TOvcRvExpTimestampLiteral.Create(Self);
          TimeStampLiteral.Value := StringLiteral.Value;
          StringLiteral.Free;
          StringLiteral := nil;
        end else
          TypeMismatch;
      end;
    else
      StringLiteral.MatchType(ExpectedType);
    end
  else
  if DateLiteral <> nil then
    DateLiteral.MatchType(ExpectedType)
  else
  if TimeLiteral <> nil then
    TimeLiteral.MatchType(ExpectedType)
  else
  if TimestampLiteral <> nil then
    TimestampLiteral.MatchType(ExpectedType)
  else
  if BooleanLiteral <> nil then
    BooleanLiteral.MatchType(ExpectedType)
  else
    Assert(False);
end;


{ TOvcRvExpFactor }

procedure TOvcRvExpFactor.CheckIsConstant;
begin
  FIsConstantChecked := True;
  if CondExp <> nil then
    FIsConstant := CondExp.IsConstant
  else
  if FieldRef <> nil then
    FIsConstant := False
  else
  if Literal <> nil then
    FIsConstant := True
  else
  if Aggregate <> nil then
    FIsConstant := False
  else
  if ScalarFunc <> nil then
    FIsConstant := ScalarFunc.IsConstant
  else
    Assert(False);
  if FIsConstant then begin
    FIsConstant := False;
    ConstantValue := GetValue(nil);
    FIsConstant := True;
  end;
end;

procedure TOvcRvExpFactor.CheckType;
begin
  if CondExp <> nil then
    FType:= CondExp.GetType
  else if FieldRef <> nil then
    FType := FieldRef.GetType
  else if Literal <> nil then
    FType := Literal.GetType
  else if Aggregate <> nil then
    FType := Aggregate.GetType
  else if ScalarFunc <> nil then
    FType := ScalarFunc.GetType
  else
    Assert(False);
  if UnaryMinus then
    case FType of
    dtFloat,
    dtInteger :
      ;
    else
      SQLError('Operator/operand mismatch');
    end;
  TypeKnown := True;
end;

procedure TOvcRvExpFactor.Clear;
begin
  CondExp.Free;
  FieldRef.Free;
  Literal.Free;
  Aggregate.Free;
  ScalarFunc.Free;
  CondExp:= nil;
  FieldRef:= nil;
  Literal:= nil;
  Aggregate:= nil;
  ScalarFunc:= nil;
end;

destructor TOvcRvExpFactor.Destroy;
begin
  Clear;
  inherited;
end;

function TOvcRvExpFactor.GetType: TOvcDRDataType;
begin
  if not TypeKnown then
    CheckType;
  Result := FType
end;

procedure TOvcRvExpFactor.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpFactor then begin
    Clear;

    MulOp := TOvcRvExpFactor(Source).MulOp;

    UnaryMinus := TOvcRvExpFactor(Source).UnaryMinus;

    if assigned(TOvcRvExpFactor(Source).CondExp) then begin
      CondExp := TOvcRvExpression.Create(Self);
      CondExp.Assign(TOvcRvExpFactor(Source).CondExp);
    end;

    if assigned(TOvcRvExpFactor(Source).FieldRef) then begin
      FieldRef := TOvcRvExpFieldRef.Create(Self);
      FieldRef.Assign(TOvcRvExpFactor(Source).FieldRef);
    end;

    if assigned(TOvcRvExpFactor(Source).Literal) then begin
      Literal := TOvcRvExpLiteral.Create(Self);
      Literal.Assign(TOvcRvExpFactor(Source).Literal);
    end;

    if assigned(TOvcRvExpFactor(Source).Aggregate) then begin
      Aggregate := TOvcRvExpAggregate.Create(Self);
      Aggregate.Assign(TOvcRvExpFactor(Source).Aggregate);
    end;

    if assigned(TOvcRvExpFactor(Source).ScalarFunc) then begin
      ScalarFunc := TOvcRvExpScalarFunc.Create(Self);
      ScalarFunc.Assign(TOvcRvExpFactor(Source).ScalarFunc);
    end;

  end else
    AssignError(Source);
end;

function TOvcRvExpFactor.GetValue(Data: Pointer): Variant;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  if CondExp <> nil then
    Result := CondExp.GetValue(Data)
  else
  if FieldRef <> nil then
    Result := FieldRef.GetValue(Data)
  else
  if Literal <> nil then
    Result := Literal.GetValue
  else
  if Aggregate <> nil then
    Result := Aggregate.GetValue(Data)
  else
  if ScalarFunc <> nil then
    Result := ScalarFunc.GetValue(Data)
  else
    Assert(False);
  if UnaryMinus then
    Result := - Result;
end;

function TOvcRvExpFactor.IsAggregate: Boolean;
begin
  Result := Aggregate <> nil;
end;

function TOvcRvExpFactor.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpFactor.MatchType(ExpectedType: TOvcDRDataType);
begin
  if CondExp <> nil then
    CondExp.MatchType(ExpectedType)
  else
  if FieldRef <> nil then
    FieldRef.MatchType(ExpectedType)
  else
  if Literal <> nil then
    Literal.MatchType(ExpectedType)
  else
  if Aggregate <> nil then
    Aggregate.MatchType(ExpectedType)
  else
  if ScalarFunc <> nil then
    ScalarFunc.MatchType(ExpectedType)
  else
    Assert(False);
end;

function TOvcRvExpFactor.Reduce: Boolean;
begin
  if CondExp <> nil then
    Result := CondExp.Reduce
  else
  if FieldRef <> nil then
    Result := False
  else
  if Literal <> nil then
    Result := False
  else
  if Aggregate <> nil then
    Result := Aggregate.Reduce
  else
  if ScalarFunc <> nil then
    Result := ScalarFunc.Reduce
  else
    Result := False;
end;

function TOvcRvExpFactor.RefersTo(AField: TOvcAbstractRvField): Boolean;
begin
  Result := False;
  if IsConstant then
    exit;
  if CondExp <> nil then
    Result := CondExp.RefersTo(AField)
  else
  if FieldRef <> nil then
    Result := FieldRef.RefersTo(AField)
  else
  if Literal <> nil then
    Result := False
  else
  if Aggregate <> nil then
    Assert(False)
  else
  if ScalarFunc <> nil then
    Result := ScalarFunc.RefersTo(AField)
  else
    Assert(False);
end;

{ TOvcRvExpSimpleExpressionList }

function TOvcRvExpSimpleExpressionList.AddExpression(
  Expression: TOvcRvExpSimpleExpression): TOvcRvExpSimpleExpression;
begin
  FExpressionList.Add(Expression);
  Result := Expression;
end;

procedure TOvcRvExpSimpleExpressionList.Assign(const Source: TOvcRvExpNode);
var
  i: Integer;
begin
  if Source is TOvcRvExpSimpleExpressionList then begin
    Clear;
    for i := 0 to pred(TOvcRvExpSimpleExpressionList(Source).ExpressionCount) do
      AddExpression(TOvcRvExpSimpleExpression.Create(Self)).Assign(
        TOvcRvExpSimpleExpressionList(Source).Expression[i]);
  end else
    AssignError(Source);
end;

procedure TOvcRvExpSimpleExpressionList.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(ExpressionCount) do
    if not Expression[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  FIsConstant := True;
end;

function TOvcRvExpSimpleExpressionList.Contains(Data: Pointer; const TestValue: Variant): Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(ExpressionCount) do
    if Expression[i].GetValue(Data) = TestValue then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

constructor TOvcRvExpSimpleExpressionList.Create(
  AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  FExpressionList := TList.Create;
end;

procedure TOvcRvExpSimpleExpressionList.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(ExpressionCount) do
    Expression[i].Free;
  FExpressionList.Clear;
end;

destructor TOvcRvExpSimpleExpressionList.Destroy;
begin
  Clear;
  FExpressionList.Free;
  inherited;
end;

function TOvcRvExpSimpleExpressionList.GetExpression(
  Index: Integer): TOvcRvExpSimpleExpression;
begin
  Result := TOvcRvExpSimpleExpression(FExpressionList[Index]);
end;

function TOvcRvExpSimpleExpressionList.GetExpressionCount: Integer;
begin
  Result := FExpressionList.Count;
end;

function TOvcRvExpSimpleExpressionList.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpSimpleExpressionList.MatchType(ExpectedType: TOvcDRDataType);
var
  i : Integer;
begin
  for i := 0 to pred(ExpressionCount) do
    Expression[i].MatchType(ExpectedType);
end;

function TOvcRvExpSimpleExpressionList.Reduce: Boolean;
var
  I : integer;
begin
  for i := 0 to pred(ExpressionCount) do
    if Expression[i].Reduce then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

function TOvcRvExpSimpleExpressionList.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
var
  I : integer;
begin
  for i := 0 to pred(ExpressionCount) do
    if Expression[i].RefersTo(AField) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TOvcRvExpSimpleExpressionList.SetExpression(Index: Integer;
  const Value: TOvcRvExpSimpleExpression);
begin
  FExpressionList[Index] := Value;
end;

{ TOvcRvExpTimestampLiteral }

procedure TOvcRvExpTimestampLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpTimeStampLiteral then begin
    Value := TOvcRvExpTimeStampLiteral(Source).Value;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpTimeStampLiteral.ConvertToNative;
begin
  if (length(Value) < 21)
  or (Value[6] <> '-')
  or (Value[9] <> '-')
  or (Value[12] <> ' ')
  or (Value[15] <> ':')
  or (Value[18] <> ':') then
    SQLError('Syntax error in time stamp literal');
  DateTimeValue :=
    EncodeDate(
      StrToInt(copy(Value, 2, 4)),
      StrToInt(copy(Value, 7, 2)),
      StrToInt(copy(Value, 10, 2)))
     +
     EncodeTime(
      StrToInt(copy(Value, 13, 2)),
      StrToInt(copy(Value, 16, 2)),
      StrToInt(copy(Value, 19, 2)),
      0);
  Converted := True;
end;

function TOvcRvExpTimestampLiteral.GetType: TOvcDRDataType;
begin
  Result := dtDateTime;
end;

function TOvcRvExpTimestampLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  Result := DateTimeValue;
end;

procedure TOvcRvExpTimestampLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtDateTime :
    ;
  else
    TypeMismatch;
  end;
  if not Converted then
    ConvertToNative;
end;

{ TOvcRvExpTimeLiteral }

procedure TOvcRvExpTimeLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpTimeLiteral then begin
    Value := TOvcRvExpTimeLiteral(Source).Value;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpTimeLiteral.ConvertToNative;
begin
  if (length(Value) <> 10)
  or (Value[4] <> ':')
  or (Value[7] <> ':') then
    SQLError('Syntax error in time literal');
  TimeValue := EncodeTime(
    StrToInt(copy(Value, 2, 2)),
    StrToInt(copy(Value, 5, 2)),
    StrToInt(copy(Value, 8, 2)),
    0);
  Converted := True;
end;

function TOvcRvExpTimeLiteral.GetType: TOvcDRDataType;
begin
  Result := dtDateTime;
end;

function TOvcRvExpTimeLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  Result := TimeValue;
end;

procedure TOvcRvExpTimeLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtDateTime :
    ;
  else
    TypeMismatch;
  end;
  if not Converted then
    ConvertToNative;
end;

{ TOvcRvExpDateLiteral }

procedure TOvcRvExpDateLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpDateLiteral then begin
    Value := TOvcRvExpDateLiteral(Source).Value;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpDateLiteral.ConvertToNative;
begin
  if (length(Value) <> 12)
  or (Value[6] <> '-')
  or (Value[9] <> '-') then
    SQLError('Syntax error in date literal');
  DateValue := EncodeDate(
    StrToInt(copy(Value, 2, 4)),
    StrToInt(copy(Value, 7, 2)),
    StrToInt(copy(Value, 10, 2)));
  Converted := True;
end;

function TOvcRvExpDateLiteral.GetType: TOvcDRDataType;
begin
  Result := dtDateTime;
end;

function TOvcRvExpDateLiteral.GetValue: Variant;
begin
  if not Converted then
    ConvertToNative;
  Result := DateValue;
end;

procedure TOvcRvExpDateLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtDateTime :
    ;
  else
    TypeMismatch;
  end;
  if not Converted then
    ConvertToNative;
end;

{ TOvcRvExpBooleanLiteral }

procedure TOvcRvExpBooleanLiteral.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpBooleanLiteral then begin
    Value := TOvcRvExpBooleanLiteral(Source).Value;
  end else
    AssignError(Source);
end;

function TOvcRvExpBooleanLiteral.GetType: TOvcDRDataType;
begin
  Result := dtBoolean;
end;

function TOvcRvExpBooleanLiteral.GetValue: Boolean;
begin
  Result := Value;
end;

procedure TOvcRvExpBooleanLiteral.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtBoolean : ;
  else
    TypeMismatch;
  end;
end;

{ TOvcRvExpScalarFunc }

procedure TOvcRvExpScalarFunc.CheckIsConstant;
begin
  FIsConstantChecked := True;
  case SQLFunction of
  sfCase :
    FIsConstant := CaseExp.IsConstant;
  sfCharlen :
    FIsConstant := Arg1.IsConstant;
  sfLower :
    FIsConstant := Arg1.IsConstant;
  sfUpper :
    FIsConstant := Arg1.IsConstant;
  sfPosition :
    FIsConstant := Arg2.IsConstant and Arg1.IsConstant;
  sfSubstring :
    FIsConstant :=
      Arg1.IsConstant and Arg2.IsConstant and
       ((Arg3 = nil) or (Arg3.IsConstant));
  sfTrim :
    FIsConstant :=
     ((Arg1 = nil) or (Arg1.IsConstant))
      and ((Arg2 = nil) or (Arg2.IsConstant));
  sfFormatFloat:
    FIsConstant := Arg1.IsConstant
      and Arg2.IsConstant
      and ((CondArg1 = nil) or (CondArg1.IsConstant));
  sfFormatDateTime:
    FIsConstant := Arg1.IsConstant
      and Arg2.IsConstant;
  sfIntToHex:
    FIsConstant := Arg1.IsConstant
      and ((Arg2 = nil) or Arg2.IsConstant);
  sfExtern:
    FIsConstant := ExpList.IsConstant;
  else
    Assert(False);
  end;
  if FIsConstant then begin
    FIsConstant := False;
    ConstantValue := GetValue(nil);
    FIsConstant := True;
  end;
end;

procedure TOvcRvExpScalarFunc.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpScalarFunc then begin
    Clear;
    SQLFunction := TOvcRvExpScalarFunc(Source).SQLFunction;
    if assigned(TOvcRvExpScalarFunc(Source).Arg1) then begin
      Arg1 := TOvcRvExpSimpleExpression.Create(Self);
      Arg1.Assign(TOvcRvExpScalarFunc(Source).Arg1);
    end;
    if assigned(TOvcRvExpScalarFunc(Source).Arg2) then begin
      Arg2 := TOvcRvExpSimpleExpression.Create(Self);
      Arg2.Assign(TOvcRvExpScalarFunc(Source).Arg2);
    end;
    if assigned(TOvcRvExpScalarFunc(Source).Arg3) then begin
      Arg3 := TOvcRvExpSimpleExpression.Create(Self);
      Arg3.Assign(TOvcRvExpScalarFunc(Source).Arg3);
    end;
    LTB := TOvcRvExpScalarFunc(Source).LTB;
    if assigned(TOvcRvExpScalarFunc(Source).CaseExp) then begin
      CaseExp := TOvcRvExpCaseExpression.Create(Self);
      CaseExp.Assign(TOvcRvExpScalarFunc(Source).CaseExp);
    end;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpScalarFunc.Clear;
begin
  CaseExp.Free;
  Arg1.Free;
  Arg2.Free;
  Arg3.Free;
  CaseExp:= nil;
  Arg1:= nil;
  Arg2:= nil;
  Arg3:= nil;
end;

destructor TOvcRvExpScalarFunc.Destroy;
begin
  Clear;
  inherited;
end;

procedure TOvcRvExpScalarFunc.CheckType;
begin
  case SQLFunction of
  sfCase :
    FType := CaseExp.GetType;
  sfCharlen :
    begin
      Arg1.MatchType(dtString);
      FType := dtInteger;
    end;
  sfLower :
    begin
      Arg1.MatchType(dtString);
      FType := dtString;
    end;
  sfUpper :
    begin
      Arg1.MatchType(dtString);
      FType := dtString;
    end;
  sfPosition :
    begin
      Arg1.MatchType(dtString);
      Arg2.MatchType(dtString);
      FType := dtInteger;
    end;
  sfSubstring :
    begin
      Arg1.MatchType(dtString);
      Arg2.MatchType(dtInteger);
      if Arg3 <> nil then
        Arg3.MatchType(dtInteger);
      FType := dtString;
    end;
  sfTrim :
    begin
      if Arg1 <> nil then
        Arg1.MatchType(dtString);
      if Arg2 <> nil then
        Arg2.MatchType(dtString);
      FType := dtString;
    end;
  sfFormatFloat,
  sfFormatDateTime,
  sfIntToHex : FType := dtString;
  sfExtern:
    FType := ExpList.GetType;
  else
    Assert(False);
  end;
  TypeKnown := True;
end;

function TOvcRvExpScalarFunc.GetType: TOvcDRDataType;
begin
  if not TypeKnown then
    CheckType;
  Result := FType;
end;

function TOvcRvExpScalarFunc.GetValue(Data: Pointer): Variant;
var
  S : string;
  WS : widestring;
  I1, I2 : Integer;
  Ch : Char;
  V : Variant;
  FF: TFloatFormat;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  case SQLFunction of
  sfCase :
    Result := CaseExp.GetValue(Data);
  sfCharlen :
    begin
      V := Arg1.GetValue(Data);
      if VarIsNull(V) then
        Result := V
      else
        Result := length(V);
    end;
  sfLower :
    begin
      V := Arg1.GetValue(Data);
      if VarIsNull(V) then
        Result := V
      else
        Result := AnsiLowerCase(V);
    end;
  sfUpper :
    begin
      V := Arg1.GetValue(Data);
      if VarIsNull(V) then
        Result := V
      else
        Result := AnsiUpperCase(V);
    end;
  sfPosition :
    begin
      WS := Arg1.GetValue(Data);
      if VarIsNull(WS) then
        Result := WS
      else
      if WS = '' then
        Result := 1
      else
        Result := pos(WS, Arg2.GetValue(Data));
    end;
  sfSubstring :
    begin
      V := Arg1.GetValue(Data);
      if VarIsNull(V) then
        Result := V
      else begin
        S := V;
        I1 := Arg2.GetValue(Data);
        if Arg3 = nil then
          Result := copy(S, I1, length(S))
        else begin
          I2 := Arg3.GetValue(Data);
          Result := copy(S, I1, I2);
        end;
      end;
    end;
  sfTrim :
    begin
      if Arg2 = nil then begin
        V := Arg1.GetValue(Data);
        if VarIsNull(V) then begin
          Result := V;
          exit;
        end;
        S := V;
        Ch := ' ';
      end else
      if Arg1 = nil then begin
        V := Arg2.GetValue(Data);
        if VarIsNull(V) then begin
          Result := V;
          exit;
        end;
        S := V;
        Ch := ' ';
      end else begin
        V := Arg1.GetValue(Data);
        if VarIsNull(V) then begin
          Result := V;
          exit;
        end;
        S := V;
        Ch := S[1];
        S := Arg2.GetValue(Data);
      end;
      case LTB of
      ltbBoth :
        begin
          while (length(S) > 0) and (S[1] = Ch) do
            Delete(S, 1, 1);
          while (length(S) > 0) and (S[length(S)] = Ch) do
            Delete(S, length(S), 1);
        end;
      ltbLeading :
        while (length(S) > 0) and (S[1] = Ch) do
          Delete(S, 1, 1);
      ltbTrailing :
        while (length(S) > 0) and (S[length(S)] = Ch) do
          Delete(S, length(S), 1);
      end;
      Result := S;
    end;
  sfFormatFloat :
    begin
      if (CondArg1 <> nil) and CondArg1.AsBoolean(Data) then
        FF := ffNumber
      else
        FF := ffFixed;
      Result := trim(FloatToStrF(Arg1.GetValue(Data), FF, 18, Arg2.GetValue(Data)));
    end;
  sfFormatDateTime :
    Result := FormatDateTime(Arg2.GetValue(Data), Arg1.GetValue(Data));
  sfIntToHex :
    begin
      if Arg2 <> nil then
        I1 := Arg2.GetValue(Data)
      else
        I1 := 0;
      Result := IntToHex(Arg1.Getvalue(Data), I1);
    end;
  sfExtern :
    Result := ExpList.GetValue(Data);
  else
    Assert(False);
  end;
end;

function TOvcRvExpScalarFunc.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

procedure TOvcRvExpScalarFunc.MatchType(ExpectedType: TOvcDRDataType);
begin
  case ExpectedType of
  dtDateTime:
    case GetType of
    dtDateTime:
      ; {ok}
    else
      TypeMismatch;
    end;
  else
    if GetType <> ExpectedType then
      TypeMismatch;
  end;
end;

function TOvcRvExpScalarFunc.Reduce: Boolean;
begin
  case SQLFunction of
  sfCase :
    Result := CaseExp.Reduce;
  sfCharlen :
    Result := Arg1.Reduce;
  sfLower :
    Result := Arg1.Reduce;
  sfUpper :
    Result := Arg1.Reduce;
  sfPosition :
    begin
      Result := Arg1.Reduce;
      if not Result and (Arg2 <> nil) then
        Result := Arg2.Reduce;
    end;
  sfSubstring :
    begin
      Result := Arg1.Reduce or Arg2.Reduce;
      if not Result and (Arg3 <> nil) then
        Result := Arg3.Reduce;
    end;
  sfTrim :
    begin
      if Arg2 = nil then begin
        Result := Arg1.Reduce
      end else
      if Arg1 = nil then begin
        Result := Arg2.Reduce;
      end else begin
        Result := Arg1.Reduce or Arg2.Reduce;
      end;
    end;
  sfFormatFloat,
  sfFormatDateTime,
  sfIntToHex:
    Result := Arg1.Reduce;
  sfExtern:
    Result := ExpList.Reduce;
  else
    Result := False;
  end;
end;

function TOvcRvExpScalarFunc.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
begin
  Result := False;
  if IsConstant then
    exit;
  case SQLFunction of
  sfCase :
    Result := CaseExp.RefersTo(AField);
  sfCharlen :
    Result := Arg1.RefersTo(AField);
  sfLower :
    Result := Arg1.RefersTo(AField);
  sfUpper :
    Result := Arg1.RefersTo(AField);
  sfPosition :
    Result := Arg1.RefersTo(AField) or Arg2.RefersTo(AField);
  sfSubstring :
    Result := Arg1.RefersTo(AField) or Arg2.RefersTo(AField);
  sfTrim :
    begin
      if Arg2 = nil then begin
        Result := Arg1.RefersTo(AField);
      end else
      if Arg1 = nil then begin
        Result := Arg2.RefersTo(AField);
      end else begin
        Result := Arg1.RefersTo(AField) or Arg2.RefersTo(AField);
      end;
    end;
  sfFormatFloat,
  sfFormatDateTime,
  sfIntToHex:
    Result := Arg1.RefersTo(AField);
  sfExtern:
    Result := ExpList.RefersTo(AField);
  else
    Assert(False);
  end;
end;

{ TOvcRvExpWhenClauseList}

function TOvcRvExpWhenClauseList.AddWhenClause(Value: TOvcRvExpWhenClause): TOvcRvExpWhenClause;
begin
  WhenClauseList.Add(Value);
  Result := Value;
end;

procedure TOvcRvExpWhenClauseList.Assign(const Source: TOvcRvExpNode);
var
  i : Integer;
begin
  if Source is TOvcRvExpWhenClauseList then begin
    Clear;
    for i := 0 to pred(TOvcRvExpWhenClauseList(Source).WhenClauseCount) do
      AddWhenClause(TOvcRvExpWhenClause.Create(Self)).Assign(
        TOvcRvExpWhenClauseList(Source).WhenClause[i]);
  end else
    AssignError(Source);
end;

procedure TOvcRvExpWhenClauseList.CheckIsConstant;
var
  i : Integer;
begin
  FIsConstantChecked := True;
  for i := 0 to pred(WhenClauseCount) do
    if not WhenClause[i].IsConstant then begin
      FIsConstant := False;
      exit;
    end;
  FIsConstant := True;
end;

constructor TOvcRvExpWhenClauseList.Create(AParent: TOvcRvExpNode);
begin
  inherited Create(AParent);
  WhenClauseList := TList.Create;
end;

procedure TOvcRvExpWhenClauseList.Clear;
var
  i : Integer;
begin
  for i := 0 to pred(WhenClauseCount) do
    WhenClause[i].Free;
  WhenClauseList.Clear;
end;

destructor TOvcRvExpWhenClauseList.Destroy;
begin
  Clear;
  WhenClauseList.Free;
  inherited;
end;

function TOvcRvExpWhenClauseList.GetWhenClause(
  Index: Integer): TOvcRvExpWhenClause;
begin
  Result := TOvcRvExpWhenClause(WhenClauseList[Index]);
end;

function TOvcRvExpWhenClauseList.GetWhenClauseCount: Integer;
begin
  Result := WhenClauseList.Count;
end;

function TOvcRvExpWhenClauseList.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

{ TOvcRvExpWhenClause }

procedure TOvcRvExpWhenClause.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpWhenClause then begin
    if WhenExp = nil then
      WhenExp := TOvcRvExpression.Create(Self);
    WhenExp.Assign(TOvcRvExpWhenClause(Source).WhenExp);
    ThenExp.Free;
    ThenExp := nil;
    if assigned(TOvcRvExpWhenClause(Source).ThenExp) then begin
      ThenExp := TOvcRvExpSimpleExpression.Create(Self);
      ThenExp.Assign(TOvcRvExpWhenClause(Source).ThenExp);
    end;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpWhenClause.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant := WhenExp.IsConstant and
    (not assigned(ThenExp) or
    ThenExp.IsConstant);
end;

destructor TOvcRvExpWhenClause.Destroy;
begin
  WhenExp.Free;
  ThenExp.Free;
  inherited;
end;

function TOvcRvExpWhenClause.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

{ TOvcRvExpCaseExpression }

procedure TOvcRvExpCaseExpression.Assign(const Source: TOvcRvExpNode);
begin
  if Source is TOvcRvExpCaseExpression then begin
    if WhenClauseList = nil then
      WhenClauseList := TOvcRvExpWhenClauseList.Create(Self);
    WhenClauseList.Assign(TOvcRvExpCaseExpression(Source).WhenClauseList);
    ElseExp.Free;
    ElseExp := nil;
    if Assigned(TOvcRvExpCaseExpression(Source).ElseExp) then begin
      ElseExp := TOvcRvExpSimpleExpression.Create(Self);
      ElseExp.Assign(TOvcRvExpCaseExpression(Source).ElseExp);
    end;
  end else
    AssignError(Source);
end;

procedure TOvcRvExpCaseExpression.CheckIsConstant;
begin
  FIsConstantChecked := True;
  FIsConstant :=
    WhenClauseList.IsConstant and ((ElseExp = nil) or ElseExp.IsConstant);
  if FIsConstant then begin
    FIsConstant := False;
    ConstantValue := GetValue(nil);
    FIsConstant := True;
  end;
end;

destructor TOvcRvExpCaseExpression.Destroy;
begin
  WhenClauseList.Free;
  ElseExp.Free;
  inherited;
end;

function TOvcRvExpCaseExpression.GetType: TOvcDRDataType;
begin
  if WhenClauseList.WhenClause[0].ThenExp <> nil then
    Result := WhenClauseList.WhenClause[0].ThenExp.GetType
  else
    Result := dtString; {actually NULL}
end;

function TOvcRvExpCaseExpression.GetValue(Data: Pointer): Variant;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := ConstantValue;
    exit;
  end;
  for i := 0 to pred(WhenClauseList.WhenClauseCount) do
    if WhenClauseList.WhenClause[i].WhenExp.AsBoolean(Data) then begin
      if WhenClauseList.WhenClause[i].ThenExp <> nil then
        Result := WhenClauseList.WhenClause[i].ThenExp.GetValue(Data)
      else
        Result := Null;
      exit;
    end;
  if ElseExp <> nil then
    Result := ElseExp.GetValue(Data)
  else
    Result := Null;
end;

function TOvcRvExpCaseExpression.IsConstant: Boolean;
begin
  if not FIsConstantChecked then
    CheckIsConstant;
  Result := FIsConstant;
end;

function TOvcRvExpCaseExpression.Reduce: Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(WhenClauseList.WhenClauseCount) do
    if WhenClauseList.WhenClause[i].WhenExp.Reduce then begin
      Result := True;
      exit;
    end else
    if WhenClauseList.WhenClause[i].ThenExp <> nil then
      if WhenClauseList.WhenClause[i].ThenExp.Reduce then begin
        Result := True;
        exit;
      end;
  if ElseExp <> nil then
    Result := ElseExp.Reduce
  else
    Result := False;
end;

function TOvcRvExpCaseExpression.RefersTo(
  AField: TOvcAbstractRvField): Boolean;
var
  i : Integer;
begin
  if IsConstant then begin
    Result := False;
    exit;
  end;
  for i := 0 to pred(WhenClauseList.WhenClauseCount) do begin
    if WhenClauseList.WhenClause[i].WhenExp.RefersTo(AField) then begin
      Result := True;
      exit;
    end;
    if WhenClauseList.WhenClause[i].ThenExp <> nil then
      if WhenClauseList.WhenClause[i].ThenExp.RefersTo(AField) then begin
        Result := True;
        exit;
      end;
  end;
  if ElseExp <> nil then
    Result := ElseExp.RefersTo(AField)
  else
    Result := False;
end;

function TOvcRvExpression.GetOwnerReport: TOvcAbstractReportView;
begin
  if FOwnerReport <> nil then
    Result := FOwnerReport
  else begin
    Assert(GetOwner <> nil);
    Result := GetOwner.OwnerReport;
  end;
  Assert(Result <> nil);
end;

initialization
  {calculate TimeDelta as one second}
  TimeDelta := EncodeTime(0, 0, 2, 0) - EncodeTime(0, 0, 1, 0);
end.


