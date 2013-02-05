DMUFI00I ; ; 10-JAN-2013
 ;;0.1;FILEMAN EXTENSIONS FILES;;JAN 10, 2013
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PKG",218,0)
 ;;=FILEMAN EXTENSIONS FILES^DMUF^Package contains files for Fileman Extensions
 ;;^UTILITY(U,$J,"PKG",218,1,0)
 ;;=^^4^4^3130110^
 ;;^UTILITY(U,$J,"PKG",218,1,1,0)
 ;;=Package contains files for Fileman Extensions.
 ;;^UTILITY(U,$J,"PKG",218,1,2,0)
 ;;= 
 ;;^UTILITY(U,$J,"PKG",218,1,3,0)
 ;;=These are Unit Test or Documentation related and are not necessary for 
 ;;^UTILITY(U,$J,"PKG",218,1,4,0)
 ;;=the functioning of Fileman.
 ;;^UTILITY(U,$J,"PKG",218,4,0)
 ;;=^9.44PA^2^2
 ;;^UTILITY(U,$J,"PKG",218,4,1,0)
 ;;=1009.801
 ;;^UTILITY(U,$J,"PKG",218,4,1,222)
 ;;=y^y^^n^^^y^o^n
 ;;^UTILITY(U,$J,"PKG",218,4,2,0)
 ;;=1009.802
 ;;^UTILITY(U,$J,"PKG",218,4,2,222)
 ;;=y^y^^n^^^y^o^n
 ;;^UTILITY(U,$J,"PKG",218,4,"B",1009.801,1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",218,4,"B",1009.802,2)
 ;;=
 ;;^UTILITY(U,$J,"PKG",218,22,0)
 ;;=^9.49I^1^1
 ;;^UTILITY(U,$J,"PKG",218,22,1,0)
 ;;=0.1^3130110
 ;;^UTILITY(U,$J,"PKG",218,22,"B","0.1",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",218,"DIPT",0)
 ;;=^9.46
 ;;^UTILITY(U,$J,"SBF",1009.801,1009.801)
 ;;=
 ;;^UTILITY(U,$J,"SBF",1009.802,1009.802)
 ;;=
 ;;^UTILITY(U,$J,"SBF",1009.802,1009.812)
 ;;=
 ;;^UTILITY(U,$J,"SBF",1009.802,1009.822)
 ;;=
