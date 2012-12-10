#!/bin/sh
#
#   This script must be run as root (or sudo)
#
cd $HOME
mkdir -p $HOME/fis-gtm-installation
mkdir -p $HOME/fis-gtm-installation/fis-gtm-V5.5-000
cd $HOME/fis-gtm-installation
wget -q -N http://sourceforge.net/projects/fis-gtm/files/GT.M-amd64-Linux/V5.5-000/gtm_V55000_linux_x8664_pro.tar.gz
cd $HOME/fis-gtm-installation/fis-gtm-V5.5-000
tar -xzf ../gtm_V55000_linux_x8664_pro.tar.gz

#
# The following is the ./configure script from fis-gtm but modifed
# to answer all the questions according to the default installation
# that we want.
# 


#################################################################
#								#
#	Copyright 2009, 2012 Fidelity Information Services, Inc #
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################

. ./arch.gtc

# Path to the correct echo program
if [ $arch = "sun"  -o  $arch = "solaris" ]; then
	echo=/usr/5bin/echo
elif [ $arch = "linux" ]; then
	echo="/bin/echo -e"
else
	echo=/bin/echo
fi

# add path to strip for solaris
if [ $arch = "sun"  -o  $arch = "solaris" ]; then
	PATH="$PATH:/usr/ccs/bin"
	export PATH
fi

# Options to ps
psopts="-ea"

# GTCM definitions
if [ -f gtcm_server ]; then
	deliver_gtcm="yes"
else
	deliver_gtcm="no"
fi

if [ -f gtcm_gnp_server ]; then
	deliver_gtcm_gnp="yes"
else
	deliver_gtcm_gnp="no"
fi

# create symbolic links if utf8 directory exists.  Ignore the "file exists" errors for the .o files
# which exist in both directories.

if [ -d utf8 ]; then
	(cd utf8; ln -s ../* . 2> /dev/null)
fi

# Native shared library extension.
if [ $arch = "hp" -a `uname -m` != "ia64" ]; then
	ext=".sl"
elif [ $arch = "zos" ]; then
	ext=".dll"
else
	ext=".so"
fi

# Flags to build shared libraries of M routines
if [ "dux" = $arch ] ; then ldflags="-shared -taso -lc" ; ldcmd="ld" # Tru64 UNIX
elif [ "hp" = $arch ] ; then ldflags="-b" ; ldcmd="ld" # HP-UX - all platforms
elif [ "ibm" = $arch ] ; then ldflags="-brtl -G -bexpfull -bnoentry -b64" ; ldcmd="ld" # AIX
elif [ "linux" = $arch ] ; then ldflags="-shared" ; ldcmd="ld" # Linux - all platforms
elif [ "solaris" = $arch ] ; then ldflags="-G -64" ; ldcmd="ld" # Solaris SPARC
elif [ "zos" = $arch ] ; then ldflags="-q64 -W c,DLL,XPLINK,EXPORTFULL -W l,DLL,XPLINK" ; ldcmd="xlc" # z/OS
else echo "Shared libary ldflags not set for this platform"; exit 1
fi

# Binaries
binaries="mupip mumps libgtmshr$ext lke dse  geteuid ftok semstat2"

# Normal scripts - executed by anyone
nscripts="gtmbase lowerc_cp"

# z/OS needs to copy the exports file
if [ $arch = "zos" ]; then
	nscripts="$nscripts gtmshr_symbols.x"
fi

# Root scripts - only executed by root
rscripts="gtmstart gtmstop"
if [ $deliver_gtcm = "yes" ]; then
	rscripts="$rscripts gtcm_run gtcm_slist"
	binaries="$binaries gtcm_server gtcm_pkdisp gtcm_play gtcm_shmclean"
fi

if [ $deliver_gtcm_gnp = "yes" ]; then
	binaries="$binaries gtcm_gnp_server"
fi

# Other files
hlpfiles="gdehelp.dat gtmhelp.dat *.h"
if [ $arch = "sco" ]; then
	ofiles="$hlpfiles esnecil"
elif [ $arch = "sun"  -o  $arch = "solaris" ]; then
	ofiles="$hlpfiles libgtmrpc.a"
	binaries="$binaries gtm_svc"
else
	ofiles="$hlpfiles"
fi

# Files that need to have $gtm_dist, $echo, etc. set in them.
pathmods="gtmbase.gtc gtmstart.gtc gtmstop.gtc gtmcshrc.gtc gtmprofile.gtc gtm.gtc gtmprofile_preV54000.gtc gdedefaults.gtc"

if [ $deliver_gtcm = "yes" ]; then
	pathmods="$pathmods gtcm_run.gtc gtcm_slist.gtc"
fi

# geteuid is no longer executable in distribution so change it
chmod 755 ./geteuid

if [ "`./geteuid`" != "root" ] ; then
	$echo "You must run Configure as root."
	exit
fi

$echo "                     GT.M Configuration Script"
$echo "Copyright 2009, 2012 Fidelity Information Services, Inc. Use of this"
$echo "software is restricted by the provisions of your license agreement."
$echo ""

# Native super user and group
if [ $arch = "zos" ]; then
	# because z/OS has no predefined notion of root or bin
	# use uid 0 for super user and group
	defowner=0
	rootuser=0
	binuser=0
else
	rootuser=root
	binuser=bin
	defowner=bin
fi

# create temporary file to test for valid user and group names
touch tmp_owngrp
$echo "Set the ($defowner) user account to own the files.\c"
resp=$defowner
if [ "$resp" = "" ] ; then
	owner=$defowner
else
	owner=$resp
fi

chown $owner tmp_owngrp 2> /dev/null
if [ 0 != "$?" ] ; then
	$echo $owner is not a valid user name - exiting!
	rm tmp_owngrp
	exit
fi

$echo "Setting the ($binuser) group should own the files? ($binuser) \c"
resp=$binuser
if [ "$resp" != "" ] ; then
	binuser=$resp
fi

chgrp $binuser tmp_owngrp 2> /dev/null
if [ 0 != "$?" ] ; then
	$echo $binuser is not a valid group name - exiting!
	rm tmp_owngrp
	exit 1
fi

$echo "Execution of GT.M will not be restricted to this group.\c"
resp="n"
if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
	group=$binuser
fi

rm tmp_owngrp

gtmdist="/usr/lib/fis-gtm/V5.5-000_x86_64"
$echo "GT.M will be installed in: ($gtmdist) \c"

# if gtmdist is relative then need to make it absolute

if [ `$echo $gtmdist | grep -c '^/'` -eq 0 ] ; then
    gtmdist=`pwd`/$gtmdist
fi

$echo ""

if [ -d $gtmdist ]; then
	$echo "Directory $gtmdist exists. If you proceed with this installation then"
	$echo "some files will be over-written. Is it ok to proceed? (y or n) \c"
	read resp
	if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
		chmod 0755 $gtmdist
		chown $owner $gtmdist
		chgrp $binuser $gtmdist
	else
		exit
	fi

else
	$echo "Directory $gtmdist does not exist. It will be created as part of"
	$echo "this installation. \c"

	resp="y"
	if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
		mkdir -p $gtmdist/plugin/r $gtmdist/plugin/o
		chmod 0755 $gtmdist
		chown $owner $gtmdist
		chgrp $binuser $gtmdist
	else
		exit
	fi
fi

if [ ! -w $gtmdist ]; then
	$echo "Directory $gtmdist is not writeable, so exiting"
	exit
fi

server_id=42

$echo ""
$echo "Installing GT.M...."
$echo ""


# Create $gtmdist/utf8 if this platform can support "UTF-8" mode.

# keep the utf8 libicu search code in gtm_test_install.csh in sync with the following!

if [ -d "utf8" ]; then
	unset gtm_icu_version
	# If package has utf8 directory, see if system has libicu and locale
	# Setup library path (in prep for looking for libicu and crypto libs)
	if [ "$arch" = "hp" ] ; then
		is64bit_gtm=`file mumps | grep "IA64" | wc -l`
	elif [ "$arch" = "zos" ] ; then
		is64bit_gtm=1
	else
		is64bit_gtm=`file mumps | grep "64-bit" | wc -l`
	fi
	if [ $is64bit_gtm -eq 1 ] ; then
		library_path="/usr/local/lib64 /usr/local/lib /usr/lib64 /usr/lib /lib64 /lib /usr/local/ssl/lib"
	else
		library_path="/usr/local/lib32 /usr/local/lib /usr/lib32 /usr/lib /lib32 /lib"
	fi
	$echo "UTF-8 support will NOT be installed? \c"
	resp="n"
	if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
		would_like_utf8=1
		$echo "Using the default ICU version \c"
		resp="n"
		if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
			$echo "Enter ICU version (at least ICU version 3.6 is required. Enter as <major-ver>.<minor-ver>): \c"
			read gtm_icu_version
			icu_ver=`$echo $gtm_icu_version | sed 's/\.//'`
			majmin=`$echo $icu_ver | cut -f 1 -d "."`
			if [ "$majmin" -lt "36" ] ; then
				$echo "WARNING: ICU version $gtm_icu_version is less than 3.6. \c"
				$echo "UTF-8 support will not be installed"
				would_like_utf8=0
				doutf8=0
			fi
		fi
	else
		would_like_utf8=0
		doutf8=0
	fi
	# Look for libicu libraries
	found_icu=0
	icu_ext=".so"
	if [ $arch = "ibm" ] ; then
		icu_ext=".a"
	elif [ $arch = "hp" ] ; then
		icu_ext=".sl"
	fi
	if [ "$would_like_utf8" -eq 1 ] ; then
		for libpath in $library_path
		do
			icu_lib_found=0
			if [ "$gtm_icu_version" = "" -a -f "$libpath/libicuio$icu_ext" ] ; then
				icu_lib_found=1
				# Find the actual version'ed library to which libicuio.{so,sl,a} points to
				icu_versioned_lib=`ls -l $libpath/libicuio$icu_ext | awk '{print $NF}'`
				# Find out vital parameters
				if [ $arch = "ibm" -o $arch = "zos" ]; then
					# From the version'ed library(eg. libicuio36.0.a) extract out
					# 36.0.a
					full_icu_ver_string=`$echo $icu_versioned_lib | sed 's/libicuio//g'`
					# Extract 36 from 36.0.a
					majmin=`$echo $full_icu_ver_string | cut -f 1 -d '.'`
				else
					full_icu_ver_string=`$echo $icu_versioned_lib | sed 's/libicuio\.//g'`
					majmin=`$echo $full_icu_ver_string | cut -f 2 -d '.'`
				fi
			elif [ "$gtm_icu_version" != "" ] ; then
				# If the user specified a desired version number, then check if the ICU
				# library with that version number exists.
				# AIX and z/OS reference ICU as libicuioVERSION.{so,a}
				# The other platforms reference the libraries as libicuio.{sl,so}.VERSION
				if [ -f "$libpath/libicuio$majmin$icu_ext" -o -f "$libpath/libicuio$icu_ext.$majmin" ] ; then
					icu_lib_found=1
				else
					icu_lib_found=0
				fi
			fi
			if [ $icu_lib_found -eq 1 ] ; then
				# Figure out the object mode(64 bit or 32 bit)  of ICU libraries on the target machine
				if [ $arch = "linux" -o $arch = "sun"  -o  $arch = "solaris" ] ; then
					icu_full_ver_lib=`ls -l $libpath/libicuio$icu_ext.$majmin 2>/dev/null | awk '{print $NF}'`
					is64bit_icu=`file $libpath/$icu_full_ver_lib 2>/dev/null | grep "64-bit" | wc -l`
				elif [ $arch = "hp" ] ; then
					icu_full_ver_lib=`ls -l $libpath/libicuio$icu_ext.$majmin 2>/dev/null | awk '{print $NF}'`
					is64bit_icu=`file $libpath/$icu_full_ver_lib 2>/dev/null | grep "IA64" | wc -l`
				elif [ $arch = "ibm" ] ; then
					icu_full_ver_lib=`ls -l $libpath/libicuio$majmin$icu_ext 2>/dev/null | awk '{print $NF}'`
					is64bit_icu=`nm -X64 $libpath/$icu_full_ver_lib 2>/dev/null | head -n 1 | wc -l`
				elif [ $arch = "zos" ] ; then
					icu_full_ver_lib=`ls -l $libpath/libicuio$majmin$icu_ext 2>/dev/null | awk '{print $NF}'`
					is64bit_icu=`file $libpath/$icu_full_ver_lib 2>/dev/null | grep "amode=64" |head -n1 |wc -l`
				fi
				# Make sure both GTM and ICU are in sync with object mode compatibility (eg both are 32 bit/64 bit )
				if [ "$is64bit_gtm" -eq 1 -a "$is64bit_icu" -ne 0 ] ; then
					found_icu=1
				elif [ "$is64bit_gtm" -ne 1 -a "$is64bit_icu" -eq 0 ] ; then
					found_icu=1
				else
					found_icu=0
				fi
				# If we have everything we want, then save the libpath that contains the proper ICU library and
				# set the gtm_icu_version
				if [ "$found_icu" -eq 1 -a "$majmin" -ge 36 ] ; then
					save_icu_libpath="$libpath"
					minorver=`expr $majmin % 10`
					majorver=`expr $majmin / 10`
					gtm_icu_version="$majorver.$minorver"
					export gtm_icu_version
					break
				fi
			fi
		done
		if [ "$found_icu" -eq 0 ] ; then
			if [ "$majmin" != "" ] ; then
				$echo "WARNING: ICU version $gtm_icu_version not found. Not installing UTF-8 support."
			else
				$echo "WARNING: Default ICU version not found. Not installing UTF-8 support."
			fi
		fi
		# Look for locale
		utflocale=`locale -a | grep -i .utf | sed 's/.lp64$//' | grep '8$' | head -n1`
		if [ "$utflocale" = "" ] ; then
			$echo "WARNING: UTF8 locale not found. Not installing UTF-8 support."
		fi
		# If both libicu and locale are on system then install UTF-8 support
		if [ "$found_icu" -ne 0  -a "$utflocale" != "" ] ; then
			doutf8=1
		else
			doutf8=0
		fi
	fi
else
	# If utf8 dir does not exist in package, can't install UTF-8 support
	doutf8=0
fi

#if gdedefaults exists on z/OS then remove it so tagging will occur correctly
if [ $arch = "zos" -a -f gdedefaults ] ; then
	rm gdedefaults
fi

# Modify the scripts as necessary for target configuration
cat << SEDSCRIPT > sedin$$
s|ARCH|$arch|g
s|ECHO|"$echo"|g
s|GTMDIST|$gtmdist|g
s|SERVERID|$server_id|g
SEDSCRIPT
for i in $pathmods
do
	dest=`basename $i .gtc`
	sed -f sedin$$ $i > $dest
	if [ "$doutf8" -ne 0 ]; then
		cd utf8
		if ( test -f "$dest" ) then rm $dest; fi
		ln -s ../$dest $dest
		cd ..
	fi
done
rm sedin$$
#on z/OS gdedefaults must be tagged ascii to be used by GTM.
if [ $arch = "zos" ]; then
	iconv -T -f IBM-1047 -t ISO8859-1 gdedefaults > t.gdedefaults
	mv t.gdedefaults gdedefaults
fi
if [ "$doutf8" -ne 0 ]; then
	if [ ! -d $gtmdist/utf8 ]; then
		mkdir -p $gtmdist/utf8 $gtmdist/plugin/o/utf8
	fi
fi

# copy debug files if necessary
if [ $arch = "zos" ] ; then
	for i in `ls *.mdbg 2> /dev/null` ; do
		cp $i $gtmdist
		rm -f $i
	done
fi

# Install COPYING if it is applicable
file=COPYING
if [ -f $file ]; then
	cp $file $gtmdist
	if [ "$doutf8" -ne 0 ]; then
		ln -s ../$file $gtmdist/utf8/$file
	fi
fi

# Install README.txt if it is applicable
file=README.txt
if [ -f $file ]; then
	cp $file $gtmdist
	if [ "$doutf8" -ne 0 ]; then
		ln -s ../$file $gtmdist/utf8/$file
	fi
fi

# Install the .cshrc and .profile files
cp gdedefaults gtmprofile gtmprofile_preV54000 gtm gtmcshrc $gtmdist
chmod 0444 $gtmdist/gdedefaults
chown $owner $gtmdist/gdedefaults
chmod 0755 $gtmdist/gtmprofile
chown $owner $gtmdist/gtmprofile
chmod 0755 $gtmdist/gtmprofile_preV54000
chown $owner $gtmdist/gtmprofile_preV54000
chmod 0755 $gtmdist/gtm
chown $owner $gtmdist/gtm
chmod 0755 $gtmdist/gtmcshrc
chown $owner $gtmdist/gtmcshrc

# Install the normal scripts
for i in $nscripts
do
	cp $i $gtmdist
	chmod 0755 $gtmdist/$i
	chown $owner $gtmdist/$i
done

# Install the root scripts
for i in $rscripts
do
	cp $i $gtmdist
	chmod 0744 $gtmdist/$i
	chown $rootuser $gtmdist/$i
done

# Install the normal binaries
for i in $binaries
do
	if [ $arch = "sun" -o $arch = "linux" ]; then
		install -g $binuser -o $owner -m 644 $i $gtmdist
	elif [ $arch = "ibm" ]; then
		/usr/bin/install -f $gtmdist -M 644 -O $owner -G $binuser $i
	elif [ -x /usr/sbin/install ]; then
		/usr/sbin/install -f $gtmdist -m 644 -u $owner -g $binuser $i $gtmdist
	elif [ $arch = "zos" ]; then
		cp $i $gtmdist/
		chmod 644 $gtmdist/$i
		chown $user:$binuser $gtmdist/$i
	else
		install -f $gtmdist -m 644 -u $owner -g $binuser $i $gtmdist
	fi
#		strip $gtmdist/$i >/dev/null 2>&1
done

# Install other individual files
for i in  $ofiles
do
	cp $i $gtmdist
	chown $owner $gtmdist/$i
done
if [ $arch = "sun" ]; then
	ranlib -t $gtmdist/libgtmrpc.a
fi

# For linux systems, attempt to execute the chcon command to allow use of the libgtmshr shared library. This
# command is required on many modern SELinux based systems but depends on the filesystem in use (requires context
# support). For that reason, we attempt the command and if it works, great. If it doesn't, oh well we tried.
if [ -f /usr/bin/chcon ]; then
	chcon -t texrel_shlib_t $gtmdist/libgtmshr$ext > /dev/null 2>&1
fi

# Create $gtmdist/plugin/gtmcrypt directory if this platform supports encryption

# Define variables to denote plugin and gtmcrypt directory names
plugin="plugin"
plugin_gtmcrypt="$plugin/gtmcrypt"

# Gtmcrypt files used to build (and install)
gtmcryptbldfiles="install.sh build.sh"

# Gtmcrypt Binaries
gtmcryptbinaries="maskpass"

# Gtmcrypt shared library
gtmcryptsharedlib="libgtmcrypt$ext"

# Gtmcrypt scripts
gtmcryptscripts="add_db_key.sh gen_sym_key.sh encrypt_sign_db_key.sh gen_keypair.sh pinentry-gtm.sh"
gtmcryptscripts="$gtmcryptscripts import_and_sign_key.sh gen_sym_hash.sh"

# Gtmcrypt related M file
gtmcryptmfile="pinentry.m"

# Gtmcrypt source files
gtmcryptsrcfiles="gtmcrypt_ref.c gtmcrypt_ref.h gtmcrypt_interface.h gtmxc_types.h maskpass.c"
gtmcryptsrcfiles="$gtmcryptsrcfiles gtmcrypt_dbk_ref.c gtmcrypt_dbk_ref.h gtmcrypt_pk_ref.c gtmcrypt_pk_ref.h"
gtmcryptsrcfiles="$gtmcryptsrcfiles gtmcrypt_sym_ref.h $gtmcryptbldfiles $gtmcryptmfile"

# Other Gtmcrypt related files
gtmcryptofiles="gtmcrypt.tab"

dogtmcrypt=0
if [ -d "$plugin_gtmcrypt" ]; then
	dogtmcrypt=1
	# Create plugin directory and gtmcrypt directory
	mkdir -p $gtmdist/plugin/gtmcrypt
	chmod 0755 $gtmdist/plugin
	chown $owner $gtmdist/plugin
	chgrp $binuser $gtmdist/plugin
	chmod 0755 $gtmdist/plugin/gtmcrypt
	chown $owner $gtmdist/plugin/gtmcrypt/
	chgrp $binuser $gtmdist/plugin/gtmcrypt


	#Install the plugin related scripts
	for i in $gtmcryptscripts
	do
		cp $plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt/$i
		chmod 0755 $gtmdist/$plugin_gtmcrypt/$i
		chown $owner $gtmdist/$plugin_gtmcrypt/$i
		chgrp $binuser $gtmdist/$plugin_gtmcrypt/$i
	done

	# Install the plugin binaries
	for i in $gtmcryptbinaries
	do
		if [ $arch = "sun" -o $arch = "linux" ]; then
			install -g $binuser -o $owner -m 755 $plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt
		elif [ $arch = "ibm" ]; then
			/usr/bin/install -f $gtmdist/$plugin_gtmcrypt -M 755 -O $owner -G $binuser $plugin_gtmcrypt/$i
		elif [ $arch = "zos" ]; then
			cp $plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt
			chmod 755 $gtmdist/$plugin_gtmcrypt/$i
			chown $user:$binuser $gtmdist/$plugin_gtmcrypt/$i
		elif [ -x /usr/sbin/install ]; then
			/usr/sbin/install -f $gtmdist/$plugin_gtmcrypt -m 755 -u $owner -g $binuser \
				$plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt
		else
			install -f $gtmdist/$plugin_gtmcrypt -m 755 -u $owner -g $binuser \
				$plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt
		fi
	done

	# Install the plugin shared library
	if [ $arch = "sun" -o $arch = "linux" ]; then
		install -g $binuser -o $owner -m 755 $plugin/$gtmcryptsharedlib $gtmdist/$plugin
	elif [ $arch = "ibm" ]; then
		/usr/bin/install -f $gtmdist/$plugin -M 755 -O $owner -G $binuser $plugin/$gtmcryptsharedlib
	elif [ $arch = "zos" ]; then
		cp $plugin/$gtmcryptsharedlib $gtmdist/$plugin
		chmod 755 $gtmdist/$plugin/$gtmcryptsharedlib
		chown $user:$binuser $gtmdist/$plugin/$gtmcryptsharedlib
	elif [ -x /usr/sbin/install ]; then
		/usr/sbin/install -f $gtmdist/$plugin -m 755 -u $owner -g $binuser $plugin/$gtmcryptsharedlib $gtmdist/$plugin
	else
		install -f $gtmdist/$plugin -m 755 -u $owner -g $binuser $plugin/$gtmcryptsharedlib $gtmdist/$plugin
	fi

        # Install the plugin related M file
        cp $plugin_gtmcrypt/$gtmcryptmfile $gtmdist/$plugin_gtmcrypt/$gtmcryptmfile
        chmod 0644 $gtmdist/$plugin_gtmcrypt/$gtmcryptmfile
        chown $owner $gtmdist/$plugin_gtmcrypt/$gtmcryptmfile
        chgrp $binuser $gtmdist/$plugin_gtmcrypt/$gtmcryptmfile

	# Install other plugin files
	for i in $gtmcryptofiles
	do
		cp $plugin_gtmcrypt/$i $gtmdist/$plugin_gtmcrypt
		chmod 0644 $gtmdist/$plugin_gtmcrypt/$i
		chown $owner $gtmdist/$plugin_gtmcrypt/$i
		chgrp $binuser $gtmdist/$plugin_gtmcrypt/$i
	done

	# Install gpgagent.tab
	# This is an external call table so the path to the shared library has to be adjusted
	echo "$gtmdist/plugin/libgtmcrypt.so" > $gtmdist/$plugin/gpgagent.tab
	cat $plugin/gpgagent.tab | sed 1d >> $gtmdist/$plugin/gpgagent.tab

	# Tar the source files
	(cd $plugin_gtmcrypt; chmod 0644 $gtmcryptsrcfiles; chown $owner $gtmcryptsrcfiles; chgrp $binuser $gtmcryptsrcfiles)
	(cd $plugin_gtmcrypt; chmod 0555 $gtmcryptbldfiles; chown $owner $gtmcryptbldfiles; chgrp $binuser $gtmcryptbldfiles)
	(cd $plugin_gtmcrypt; tar -cvf source.tar $gtmcryptsrcfiles >/dev/null 2>&1; mv source.tar $gtmdist/$plugin_gtmcrypt)
	(cd $gtmdist/$plugin_gtmcrypt; chmod 0644 source.tar; chown $owner source.tar; chgrp $binuser source.tar)
fi

# Install GDE, GTMHELP, and all the percent routines
cp *.o *.m $gtmdist

# Install a mirror image (using soft links) of $gtmdist under $gtmdist/utf8 if this platform can support "UTF-8" mode.
if [ "$doutf8" -ne 0 ]; then
	cd utf8
	for file in *
	do
		# Skip directories
		if [ -d $file ]; then
			continue
		fi
		# Install .o files
		base="`basename $file .o`"
		if [ "$base" != "$file" ]; then
			cp $file $gtmdist/utf8
		else
			# Soft link everything else
			if [ -f $gtmdist/utf8/$file ]; then
				rm -f $gtmdist/utf8/$file
			fi
			if [ -f $gtmdist/$file ]; then
				ln -s ../$file $gtmdist/utf8/$file
			fi
		fi
	done
	if [ "$dogtmcrypt" -ne 0 ]; then
		ln -s ../plugin $gtmdist/utf8/plugin
	fi
	cd ..
fi

$echo ""
$echo "All of the GT.M MUMPS routines are distributed with uppercase names."
$echo "You can create lowercase copies of these routines if you wish, but"
$echo "to avoid problems with compatibility in the future, consider keeping"
$echo "only the uppercase versions of the files."
$echo ""
$echo "Using only uppercase versions of the MUMPS routines.\c"
resp="n"
if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
	$echo ""
	$echo "Creating lowercase versions of the MUMPS routines."
	(cd $gtmdist; ./lowerc_cp *.m)
	if [ "$doutf8" -ne 0 ]; then
		(cd $gtmdist/utf8; ./lowerc_cp *.m)
	fi
fi

# Change mode to executable for mumps and libgtmshr to do the compiles
chmod 755 $gtmdist/mumps $gtmdist/libgtmshr$ext

gtmroutines=$gtmdist
gtmgbldir=$gtmdist/mumps.gld
gtm_dist=$gtmdist
export gtm_dist
export gtmroutines
export gtmgbldir

$echo ""
$echo "Compiling all of the MUMPS routines. This may take a moment."
$echo ""

# Ensure we are NOT in UTF-8 mode
gtm_chset="M"
export gtm_chset
(cd $gtmdist; ./mumps -noignore *.m; $echo $?>compstat ; \
 if [ "$is64bit_gtm" -eq 1 -o "linux" != $arch ] ; then $ldcmd $ldflags -o libgtmutil$ext *.o ; fi )

# Now work on UTF-8 mode
if [ "$doutf8" -ne 0 ]; then
	# Ensure we ARE in UTF-8 mode
	utflocale=`locale -a | grep -i en_us | grep -i utf | grep '8$'`
	if [ $arch = "zos" ]; then
		utflocale=`locale -a | grep -i en_us | grep -i utf | sed 's/.lp64$//' | grep '8$' | head -n1`
	fi

	if [ $utflocale = "" ]; then
		utflocale="C"
	fi
	if [ $arch != "zos" ]; then
		# don't set LC_CTYPE to avoid random error messages from EBCDIC utilities
		LC_CTYPE=$utflocale
		export LC_CTYPE
	else
		gtm_chset_locale=$utflocale
		export gtm_chset_locale
	fi
	unset LC_ALL
	gtm_chset="UTF-8"
	export gtm_chset
	if [ $arch = "ibm" ]; then
		export LIBPATH=$save_icu_libpath
	elif [ $arch = "zos" ]; then
		# on z/OS LIBPATH is the only library search path so we should preserve it
		export LIBPATH=${save_icu_libpath}:${LIBPATH}
	else
		LD_LIBRARY_PATH=$save_icu_libpath
		export LD_LIBRARY_PATH
	fi
	(gtm_dist=$gtmdist/utf8; export gtm_dist; cd $gtm_dist; ./mumps -noignore *.m; $echo $?>>$gtmdist/compstat; \
	if [ $is64bit_gtm -eq 1 -o "linux" != $arch ] ; then $ldcmd $ldflags -o libgtmutil$ext *.o ; fi )
	gtm_chset="M"
	export gtm_chset
fi

# Change mode to executable for the normal binaries
for i in $binaries
do
	chmod 755 $gtmdist/$i
done

chmod 0644 $gtmdist/*.m
chmod 0644 $gtmdist/*.o
chown $owner $gtmdist/*.m
chown $owner $gtmdist/*.o
chgrp $binuser $gtmdist/*.m
chgrp $binuser $gtmdist/*.o

if [ "$doutf8" -ne 0 ]; then
	chmod 0644 $gtmdist/utf8/*.m
	chmod 0644 $gtmdist/utf8/*.o
	chown $owner $gtmdist/utf8
	chown $owner $gtmdist/utf8/*.m
	chown $owner $gtmdist/utf8/*.o
	chgrp $binuser $gtmdist/utf8/*.m
	chgrp $binuser $gtmdist/utf8/*.o
fi

if [ "$dogtmcrypt" -ne 0 ]; then
	chmod 0644 $gtmdist/plugin/gtmcrypt/*.m
	chown $owner $gtmdist/plugin/gtmcrypt/*.m
	chgrp $binuser $gtmdist/plugin/gtmcrypt/*.m
fi

gtm_dist=$gtmdist
export gtm_dist

if [ -f $gtm_dist/libgtmutil$ext ] ; then
    gtmroutines=$gtm_dist/libgtmutil$ext
else
    gtmroutines=$gtmdist
fi
export gtmroutines

# Create the global directories for the help databases.

gtmgbldir=$gtmdist/gtmhelp.gld
export gtmgbldir

cat <<GDE.in1 | $gtmdist/mumps -direct
Do ^GDE
Change -segment DEFAULT	-block=2048	-file=$gtmdist/gtmhelp.dat
Change -region DEFAULT	-record=1020	-key=255
Exit
GDE.in1

gtmgbldir=$gtmdist/gdehelp.gld
export gtmgbldir

cat <<GDE.in2 | $gtmdist/mumps -direct
Do ^GDE
Change -segment DEFAULT	-block=2048	-file=$gtmdist/gdehelp.dat
Change -region DEFAULT	-record=1020	-key=255
Exit
GDE.in2

other_object_files="CHK2LEV.o CHKOP.o GENDASH.o GENOUT.o GETNEAR.o GTMHELP.o GTMHLPLD.o LOAD.o LOADOP.o"
other_object_files="$other_object_files LOADVX.o MSG.o TTTGEN.o TTTSCAN.o UNLOAD.o GTMDefinedTypesInit.o"
csh_script_files=""
if [ $arch = "zos" ]; then
	other_object_files="$other_object_files GENEXPORT.o"
fi

if [ "$doutf8" -ne 0 ]; then
	# make symbolic links to gtmhelp.gld and gdehelp.gld
	(cd $gtmdist/utf8; ln -s ../gtmhelp.gld gtmhelp.gld; ln -s ../gdehelp.gld gdehelp.gld)
fi

# make database files read only
chmod 0444 $gtmdist/*.dat
chmod 0444 $gtmdist/*.gld

# $other_object_files, $csh_script_files should be removed unconditionally
savedir=`pwd`
# temporarily change to $gtmdist
cd $gtmdist
\rm -rf $other_object_files $csh_script_files lowerc_cp

if [ -d utf8 ]; then
	cd utf8
	\rm -rf $other_object_files $csh_script_files lowerc_cp
fi
# change back to original directory
cd $savedir

# Optionally remove .o files if they are in a shared library
if [ -f $gtm_dist/libgtmutil$ext ] ; then
    $echo ""
    $echo "Object files of M routines placed in shared library $gtm_dist/libgtmutil$ext"
    $echo "Removing original .o object files \c"
    resp="n"
    if [ "n" = $resp -o "N" = $resp ] ; then rm -f $gtm_dist/*.o $gtm_dist/utf8/*.o ; fi
    $echo ""
fi

# change group ownership of all files if group restricted
# otherwise change to the default as some files were created with root group
if [ "$group" != "" ] ; then
	chgrp -R $group $gtmdist
	if [ "zos" = $arch ]; then
		chmod -Rh o-rwx $gtmdist
	else
		chmod -R o-rwx $gtmdist
	fi
else
	chgrp -R $binuser $gtmdist
fi

# Install real gtmsecshr with special permissions in $gtmdist/gtmsecshrdir
tgtmsecshrdir=$gtmdist/gtmsecshrdir
mkdir $tgtmsecshrdir
chmod 700 $tgtmsecshrdir
chgrp $binuser $tgtmsecshrdir

# Install gtmsecshr and the wrapper with special permissions
if [ $arch = "sun" -o $arch = "linux" ]; then
	install -m 4555 -o root -g $binuser gtmsecshr $gtmdist
	install -m 4500 -o root -g $binuser gtmsecshrdir/gtmsecshr $tgtmsecshrdir/gtmsecshr
elif [ $arch = "ibm" ]; then
	/usr/bin/install -f $gtmdist -M 4555 -O root -G $binuser gtmsecshr
	/usr/bin/install -f $tgtmsecshrdir -M 4500 -O root -G $binuser gtmsecshrdir/gtmsecshr
elif [ -x /usr/sbin/install ]; then
	/usr/sbin/install -f $gtmdist -m 4555 -u root -g $binuser gtmsecshr $gtmdist
	/usr/sbin/install -f $tgtmsecshrdir -m 4500 -u root -g $binuser gtmsecshrdir/gtmsecshr $tgtmsecshrdir
elif [ $arch = "zos" ]; then
	cp gtmsecshr $gtmdist/gtmsecshr
	cp gtmsecshrdir/gtmsecshr $tgtmsecshrdir/gtmsecshr
	chown $rootuser:$binuser $gtmdist/gtmsecshr $tgtmsecshrdir/gtmsecshr
	chmod 4555 $gtmdist/gtmsecshr
	chmod 4500 $tgtmsecshrdir/gtmsecshr
else
	install -f $gtmdist -m 4555 -u root -g $binuser gtmsecshr $gtmdist
	install -f $tgtmsecshrdir -m 4500 -u root -g $binuser gtmsecshrdir/gtmsecshr $tgtmsecshrdir
fi

if [ -d $gtmdist/utf8 ]; then
	(cd $gtmdist/utf8; ln -s ../gtmsecshrdir gtmsecshrdir; ln -s ../gtmsecshr gtmsecshr)
fi

strip $gtmdist/gtmsecshr > /dev/null 2>&1
strip $tgtmsecshrdir/gtmsecshr > /dev/null 2>&1

# change group ownership of wrapper if group restricted
# also remove user privileges for wrapper if group changed
if [ "$group" != "" ] ; then
	chgrp $group $gtmdist/gtmsecshr
	$echo ""
	$echo "Removing world permissions from gtmsecshr wrapper since group restricted to \"$group\""
	chmod 4550 $gtmdist/gtmsecshr
fi

# leave nothing writeable
chmod a-w $gtmdist
chmod a-w $gtmdist/*

if [ -d $gtmdist/utf8 ]; then
	chmod a-w $gtmdist/utf8/*
fi

if [ -d $gtmdist/plugin ]; then
	chmod a-w $gtmdist/plugin/*
fi

if [ -d $gtmdist/plugin/gtmcrypt ]; then
	chmod a-w $gtmdist/plugin/gtmcrypt/*
fi

# if we had a mumps error then remove executable bit recursively and exit
# this could include compile and/or library load errors
if [ 0 != `grep -c '[1-9]' $gtm_dist/compstat` ]; then
	$echo ""
	$echo "GT.M installation FAILED – please review error messages"
	$echo ""
	chmod -R a-x $gtmdist
	exit 1
fi

rm -f $gtmdist/compstat

$echo ""
$echo "Installation completed. Keeping all the temporary files"
$echo "in this directory, just in case you need them again. \c"
resp="n"

if [ "$resp" = "Y" -o "$resp" = "y" ] ; then
	\rm -rf $binaries $pathmods $rscripts $nscripts $dirs configure \
		*.gtc gtm* gde* GDE*.o _*.m _*.o mumps.dat mumps.gld geteuid $other_object_files $csh_script_files lowerc_cp\
		esnecil *.hlp core *.h libgtmrpc.a *.m gdehelp.* COPYING README.txt
	\rm -rf GETPASS.o plugin PINENTRY.o
	if [ -d utf8 ]; then
		\rm -rf utf8
	fi
fi

$echo ""
$echo "You will find the installation in the directory:"
$echo "$gtmdist"
