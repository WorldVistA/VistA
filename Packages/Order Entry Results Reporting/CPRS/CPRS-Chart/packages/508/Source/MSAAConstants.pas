unit MSAAConstants;
interface

const

  DISPID_ACC_PARENT           = -5000;
  DISPID_ACC_CHILDCOUNT       = -5001;
  DISPID_ACC_CHILD            = -5002;
  DISPID_ACC_NAME             = -5003;
  DISPID_ACC_VALUE            = -5004;
  DISPID_ACC_DESCRIPTION      = -5005;
  DISPID_ACC_ROLE             = -5006;
  DISPID_ACC_STATE            = -5007;
  DISPID_ACC_HELP             = -5008;
  DISPID_ACC_HELPTOPIC        = -5009;
  DISPID_ACC_KEYBOARDSHORTCUT = -5010;
  DISPID_ACC_FOCUS            = -5011;
  DISPID_ACC_SELECTION        = -5012;
  DISPID_ACC_DEFAULTACTION    = -5013;
  DISPID_ACC_SELECT           = -5014;
  DISPID_ACC_LOCATION         = -5015;
  DISPID_ACC_NAVIGATE         = -5016;
  DISPID_ACC_HITTEST          = -5017;
  DISPID_ACC_DODEFAULTACTION  = -5018;

  NAVDIR_MIN        = $0;
  NAVDIR_UP         = $1;
  NAVDIR_DOWN       = $2;
  NAVDIR_LEFT       = $3;
  NAVDIR_RIGHT      = $4;
  NAVDIR_NEXT       = $5;
  NAVDIR_PREVIOUS   = $6;
  NAVDIR_FIRSTCHILD = $7;
  NAVDIR_LASTCHILD  = $8;
  NAVDIR_MAX        = $9;

  SELFLAG_NONE            =  $0;
  SELFLAG_TAKEFOCUS       =  $1;
  SELFLAG_TAKESELECTION   =  $2;
  SELFLAG_EXTENDSELECTION =  $4;
  SELFLAG_ADDSELECTION    =  $8;
  SELFLAG_REMOVESELECTION = $10;
  SELFLAG_VALID           = $1F;

  STATE_SYSTEM_NORMAL          =        $0;
  STATE_SYSTEM_UNAVAILABLE     =        $1;
  STATE_SYSTEM_SELECTED        =        $2;
  STATE_SYSTEM_FOCUSED         =        $4;
  STATE_SYSTEM_PRESSED         =        $8;
  STATE_SYSTEM_CHECKED         =       $10;
  STATE_SYSTEM_MIXED           =       $20;
  STATE_SYSTEM_INDETERMINATE   = STATE_SYSTEM_MIXED;
  STATE_SYSTEM_READONLY        =       $40;
  STATE_SYSTEM_HOTTRACKED      =       $80;
  STATE_SYSTEM_DEFAULT         =      $100;
  STATE_SYSTEM_EXPANDED        =      $200;
  STATE_SYSTEM_COLLAPSED       =      $400;
  STATE_SYSTEM_BUSY            =      $800;
  STATE_SYSTEM_FLOATING        =     $1000;
  STATE_SYSTEM_MARQUEED        =     $2000;
  STATE_SYSTEM_ANIMATED        =     $4000;
  STATE_SYSTEM_INVISIBLE       =     $8000;
  STATE_SYSTEM_OFFSCREEN       =    $10000;
  STATE_SYSTEM_SIZEABLE        =    $20000;
  STATE_SYSTEM_MOVEABLE        =    $40000;
  STATE_SYSTEM_SELFVOICING     =    $80000;
  STATE_SYSTEM_FOCUSABLE       =   $100000;
  STATE_SYSTEM_SELECTABLE      =   $200000;
  STATE_SYSTEM_LINKED          =   $400000;
  STATE_SYSTEM_TRAVERSED       =   $800000;
  STATE_SYSTEM_MULTISELECTABLE =  $1000000;
  STATE_SYSTEM_EXTSELECTABLE   =  $2000000;
  STATE_SYSTEM_ALERT_LOW       =  $4000000;
  STATE_SYSTEM_ALERT_MEDIUM    =  $8000000;
  STATE_SYSTEM_ALERT_HIGH      = $10000000;
  STATE_SYSTEM_PROTECTED       = $20000000;
  STATE_SYSTEM_VALID           = $3FFFFFFF;

  ROLE_SYSTEM_TITLEBAR           =  $1;
  ROLE_SYSTEM_MENUBAR            =  $2;
  ROLE_SYSTEM_SCROLLBAR          =  $3;
  ROLE_SYSTEM_GRIP               =  $4;
  ROLE_SYSTEM_SOUND              =  $5;
  ROLE_SYSTEM_CURSOR             =  $6;
  ROLE_SYSTEM_CARET              =  $7;
  ROLE_SYSTEM_ALERT              =  $8;
  ROLE_SYSTEM_WINDOW             =  $9;
  ROLE_SYSTEM_CLIENT             =  $A;
  ROLE_SYSTEM_MENUPOPUP          =  $B;
  ROLE_SYSTEM_MENUITEM           =  $C;
  ROLE_SYSTEM_TOOLTIP            =  $D;
  ROLE_SYSTEM_APPLICATION        =  $E;
  ROLE_SYSTEM_DOCUMENT           =  $F;
  ROLE_SYSTEM_PANE               = $10;
  ROLE_SYSTEM_CHART              = $11;
  ROLE_SYSTEM_DIALOG             = $12;
  ROLE_SYSTEM_BORDER             = $13;
  ROLE_SYSTEM_GROUPING           = $14;
  ROLE_SYSTEM_SEPARATOR          = $15;
  ROLE_SYSTEM_TOOLBAR            = $16;
  ROLE_SYSTEM_STATUSBAR          = $17;
  ROLE_SYSTEM_TABLE              = $18;
  ROLE_SYSTEM_COLUMNHEADER       = $19;
  ROLE_SYSTEM_ROWHEADER          = $1A;
  ROLE_SYSTEM_COLUMN             = $1B;
  ROLE_SYSTEM_ROW                = $1C;
  ROLE_SYSTEM_CELL               = $1D;
  ROLE_SYSTEM_LINK               = $1E;
  ROLE_SYSTEM_HELPBALLOON        = $1F;
  ROLE_SYSTEM_CHARACTER          = $20;
  ROLE_SYSTEM_LIST               = $21;
  ROLE_SYSTEM_LISTITEM           = $22;
  ROLE_SYSTEM_OUTLINE            = $23;
  ROLE_SYSTEM_OUTLINEITEM        = $24;
  ROLE_SYSTEM_PAGETAB            = $25;
  ROLE_SYSTEM_PROPERTYPAGE       = $26;
  ROLE_SYSTEM_INDICATOR          = $27;
  ROLE_SYSTEM_GRAPHIC            = $28;
  ROLE_SYSTEM_STATICTEXT         = $29;
  ROLE_SYSTEM_TEXT               = $2A;
  ROLE_SYSTEM_PUSHBUTTON         = $2B;
  ROLE_SYSTEM_CHECKBUTTON        = $2C;
  ROLE_SYSTEM_RADIOBUTTON        = $2D;
  ROLE_SYSTEM_COMBOBOX           = $2E;
  ROLE_SYSTEM_DROPLIST           = $2F;
  ROLE_SYSTEM_PROGRESSBAR        = $30;
  ROLE_SYSTEM_DIAL               = $31;
  ROLE_SYSTEM_HOTKEYFIELD        = $32;
  ROLE_SYSTEM_SLIDER             = $33;
  ROLE_SYSTEM_SPINBUTTON         = $34;
  ROLE_SYSTEM_DIAGRAM            = $35;
  ROLE_SYSTEM_ANIMATION          = $36;
  ROLE_SYSTEM_EQUATION           = $37;
  ROLE_SYSTEM_BUTTONDROPDOWN     = $38;
  ROLE_SYSTEM_BUTTONMENU         = $39;
  ROLE_SYSTEM_BUTTONDROPDOWNGRID = $3A;
  ROLE_SYSTEM_WHITESPACE         = $3B;
  ROLE_SYSTEM_PAGETABLIST        = $3C;
  ROLE_SYSTEM_CLOCK              = $3D;

  CHILDID_SELF = 0;

  //=== Property GUIDs (used by annotation interfaces)

  PROPID_ACC_NAME: TGUID             = (D1:$608d3df8; D2:$8128; D3:$4aa7; D4:($a4, $28, $f5, $5e, $49, $26, $72, $91));
  PROPID_ACC_VALUE: TGUID            = (D1:$123fe443; D2:$211a; D3:$4615; D4:($95, $27, $c4, $5a, $7e, $93, $71, $7a));
  PROPID_ACC_DESCRIPTION: TGUID      = (D1:$4d48dfe4; D2:$bd3f; D3:$491f; D4:($a6, $48, $49, $2d, $6f, $20, $c5, $88));
  PROPID_ACC_ROLE: TGUID             = (D1:$cb905ff2; D2:$7bd1; D3:$4c05; D4:($b3, $c8, $e6, $c2, $41, $36, $4d, $70));
  PROPID_ACC_STATE: TGUID            = (D1:$a8d4d5b0; D2:$0a21; D3:$42d0; D4:($a5, $c0, $51, $4e, $98, $4f, $45, $7b));
  PROPID_ACC_HELP: TGUID             = (D1:$c831e11f; D2:$44db; D3:$4a99; D4:($97, $68, $cb, $8f, $97, $8b, $72, $31));
  PROPID_ACC_KEYBOARDSHORTCUT: TGUID = (D1:$7d9bceee; D2:$7d1e; D3:$4979; D4:($93, $82, $51, $80, $f4, $17, $2c, $34));

  PROPID_ACC_HELPTOPIC: TGUID        = (D1:$787d1379; D2:$8ede; D3:$440b; D4:($8a, $ec, $11, $f7, $bf, $90, $30, $b3));
  PROPID_ACC_FOCUS: TGUID            = (D1:$6eb335df; D2:$1c29; D3:$4127; D4:($b1, $2c, $de, $e9, $fd, $15, $7f, $2b));
  PROPID_ACC_SELECTION: TGUID        = (D1:$b99d073c; D2:$d731; D3:$405b; D4:($90, $61, $d9, $5e, $8f, $84, $29, $84));
  PROPID_ACC_PARENT: TGUID           = (D1:$474c22b6; D2:$ffc2; D3:$467a; D4:($b1, $b5, $e9, $58, $b4, $65, $73, $30));

  PROPID_ACC_NAV_UP: TGUID           = (D1:$016e1a2b; D2:$1a4e; D3:$4767; D4:($86, $12, $33, $86, $f6, $69, $35, $ec));
  PROPID_ACC_NAV_DOWN: TGUID         = (D1:$031670ed; D2:$3cdf; D3:$48d2; D4:($96, $13, $13, $8f, $2d, $d8, $a6, $68));
  PROPID_ACC_NAV_LEFT: TGUID         = (D1:$228086cb; D2:$82f1; D3:$4a39; D4:($87, $05, $dc, $dc, $0f, $ff, $92, $f5));
  PROPID_ACC_NAV_RIGHT: TGUID        = (D1:$cd211d9f; D2:$e1cb; D3:$4fe5; D4:($a7, $7c, $92, $0b, $88, $4d, $09, $5b));
  PROPID_ACC_NAV_PREV: TGUID         = (D1:$776d3891; D2:$c73b; D3:$4480; D4:($b3, $f6, $07, $6a, $16, $a1, $5a, $f6));
  PROPID_ACC_NAV_NEXT: TGUID         = (D1:$1cdc5455; D2:$8cd9; D3:$4c92; D4:($a3, $71, $39, $39, $a2, $fe, $3e, $ee));
  PROPID_ACC_NAV_FIRSTCHILD: TGUID   = (D1:$cfd02558; D2:$557b; D3:$4c67; D4:($84, $f9, $2a, $09, $fc, $e4, $07, $49));
  PROPID_ACC_NAV_LASTCHILD: TGUID    = (D1:$302ecaa5; D2:$48d5; D3:$4f8d; D4:($b6, $71, $1a, $8d, $20, $a7, $78, $32));

  PROPID_ACC_ROLEMAP: TGUID          = (D1:$f79acda2; D2:$140d; D3:$4fe6; D4:($89, $14, $20, $84, $76, $32, $82, $69));
  PROPID_ACC_VALUEMAP: TGUID         = (D1:$da1c3d79; D2:$fc5c; D3:$420e; D4:($b3, $99, $9d, $15, $33, $54, $9e, $75));
  PROPID_ACC_STATEMAP: TGUID         = (D1:$43946c5e; D2:$0ac0; D3:$4042; D4:($b5, $25, $07, $bb, $db, $e1, $7f, $a7));
  PROPID_ACC_DESCRIPTIONMAP: TGUID   = (D1:$1ff1435f; D2:$8a14; D3:$477b; D4:($b2, $26, $a0, $ab, $e2, $79, $97, $5d));

  PROPID_ACC_DODEFAULTACTION: TGUID  = (D1:$1ba09523; D2:$2e3b; D3:$49a6; D4:($a0, $59, $59, $68, $2a, $3c, $48, $fd));

implementation
end.
