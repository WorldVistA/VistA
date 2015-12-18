{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Wally Fort, Joel Ivey
	Description: Encryption and decryption functions.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit Hash;


interface

uses SysUtils, Classes;


{function and procedure prototypes}
function Decrypt(EncryptedText: string): string;
function Encrypt(NormalText: string): string;

const
  maxKeys = 20;
  CipherPad: array[0..maxKeys - 1] of string = (

   'VEB_0|=f3Y}m<5i$`W>znGA7P:O%H69[2r)jKh@uo\wMb*Da !+T?q4-JI#d;8ypUQ]g"~''&Cc.LNt/kX,e{vl1FRZs(xS',
 'D/Jg><p]1W6Rtqr.QYo8TBEMK-aAIyO(xG7lPz;=d)N}2F!U ,e0~$fk"j[m*3s5@XnZShv+`b''{u&_\9%|wL4ic:V?H#C',
 '?lBUvZq\fwk+u#:50`SOF9,dp&*G-M=;{8Ai6/N7]bQ1szC!(PxW_YV~)3Lm.EIXD2aT|hKj$rnR@["c g''<>t%4oJHy}e',
 'MH,t9K%TwA17-Bzy+XJU?<>4mo @=6:Ipfnx/Y}R8Q\aN~{)VjEW;|Sq]rl[0uLFd`g5Z#e!3$b"P_.si&G(2''Cvkc*ODh',
 'vMy>"X?bSLCl)''jhzHJk.fVc6#*[0OuP@\{,&r(`Es:K!7wi$5F; DoY=p%e<t}4TQA2_W9adR]gNBG1~nIZ+3x-Um|8q/',
 ':"XczmHx;oA%+vR$Mtr CBTU_w<uEK5f,SW*d8OaFGh]j''{7-~Qp#yqP>09si|VY1J!/[lN23&L4`=.D6)ZIb\n?}(ek@g',
 'j7Qh[YU.u6~xm<`vfe%_g-MRF(#iK=trl}C)>GEDN *$OdHzBA98aLJ|2WP:@ko0wy4I/S&,q'']5!13XcVs\?Zp"+{;Tbn',
 '\UVZ;.&]%7fGq`*SA=Kv/-Xr1OBHiwhP5ukYo{2"}d |NsT,>!x6y~cz[C)pe8m9LaRI(MEFlt:Qg#D''n$W04b@_+?j<3J',
 'MgSvV"U''dj5Yf6K*W)/:z$oi7GJ|t(1Ak=ZC,@]Q0?8DnbE[+L`{mq>;aOR}wcB4sF_e9rh2l\x<. PyNpu%IT!&3#HX~-',
 'rFkn4Z0cH7)`6Xq|yL #wmuW?Gf!2YES;.B_D=el}hN[M&x(*AasU9otd+{]g>TQjp<:v%5O"zI\@$Rb~8i-3/''V1,CJPK',
 '\''%u+W)mK41L#:A6!;7("tnyRlaOe09]3EFd ITf.`@P[Q{B$_iYhZo*kbc|HUgz=D>Svr8x,X~-<NsjM}C/&J?p2wV5qG',
 'QCl_329e+DTp&\?jNys V]k*M"X!$Y6[i@g>{RvF''01(45LJZU,:-uAwtB;7|%fx.n`IhSE<OoW~=bdP#/KHzrc)8mG}aq',
 '!{w*PR[B9Oli~T, rFc"/?ast8=)-_Dgo<E#n4HYA%f''N;0@S7pJ`kGIedM|+C2yjvL5b3K6\Z]V(.h}umxz>XQ$qUW:1&',
 '}:SHZ|O~A-bcyJ4%''5vM+ ;eo.$B)Vp\,kTDz1sGL`]*=mg2nxYPd&lErN3[8qF0@u"a_>wQKI{f6C7?9RX(t#i/U<j!Wh',
 ',ry*|7<1keO:Wi C/zh4IZ>x!F[_("Dbu%Hl5Pg=]QG.LKcJ0&ont@+{;ATX6jMwBv?2#f`q\}VYm''8Es$NpU)dR~S9a3-',
 'h,=/:pJ$@mlY-`bwQ)e3Xt8.RUSMV 2A;j[PN}TE9x~kL&<ns5q>_#c1%K+rIuFoa(zyDWdH]?\GB0g*4f6"Z!''v{7|OiC',
 '/$*b.ts0vOx_-o"l3MHI~}!E`eJimPd>Sn&wzFUh?Kf4)g5X<,8pD:9LA{a[k;''|GyYQ=R2B\#q+cru6N1W@(C TV]7Z%j',
 'qEoC?YWNtV{Brg,I(i:e7Jd#6m!D8XT"n[$~1*ZcxL.Kh2s4%Q&ju\5Gvazw+9pF@k`HA)=U3/< -}''0b;|PfSRl_MO]y>',
 '`@X:!R[\tY5OBcZPh$rM_a-"vgJG%|}oIH)wWQ*jDVxlp,''+S zu(&7?>KCn4y1dE02q6b<;F=8]9NAmT{Li3f/esUk.~#',
 '\Zr'';/SMsG76Lj$aBc[#k>u=_O@2J&X{Aft xV4~vz8Q}q)0K.NIpRnYwDhg+<"H-!(PF:m*]?,WCT|dE9o53%`liUey1b');


implementation

uses mfunstr {for Translate function};


function Encrypt(normalText: string): string;
var
  associatorIndex, identifierIndex: integer;
begin
  Randomize;
  associatorIndex := random(MaxKeys);
  repeat
    identifierIndex := Random(MaxKeys);
  until associatorIndex <> identifierIndex; {make sure indexes are different}

  Result := chr(AssociatorIndex+32) +
            Translate(NormalText, CipherPad[AssociatorIndex],
                      CipherPad[IdentifierIndex]) +
            chr(identifierIndex+32);
end;



function Decrypt(EncryptedText: string): string;
var
  AssociatorIndex, IdentifierIndex: integer;
begin
  IdentifierIndex := Ord(EncryptedText[1])-32;
  AssociatorIndex := Ord(EncryptedText[Length(EncryptedText)])-32;
  Result := Translate(copy(EncryptedText,2,Length(EncryptedText)-2),
                      CipherPad[AssociatorIndex],
                      CipherPad[IdentifierIndex]);
end;

end.
