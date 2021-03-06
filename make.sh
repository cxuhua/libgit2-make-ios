

if [ ! -d "$1" ]
then
	echo		"You must specify souce directory."
	echo		""
	echo		"USAGE:"
	echo		""
	echo		"	build.sh <src-dir-path>"
	echo		""
	exit		1
fi







declare			CURDIR="`pwd`"

cd				"`dirname \"$0\"`"
declare			SCRTDIR="`pwd`"

cd				"$1"
declare			SRCDIR="`pwd`"

cd				"$CURDIR"
declare			PKGDIR="$CURDIR"/build
declare			PKGNAME="libgit2.a"
declare			DSTDIR="$PKGDIR"/temp
declare			PDIR_DEV_ARMV7="$DSTDIR"/"Platform (iphoneos-armv7)"
declare			PDIR_DEV_ARMV6="$DSTDIR"/"Platform (iphoneos-armv6)"
declare			PDIR_SIM_I386="$DSTDIR"/"Platform (iphonesimulator-i386)"
declare			SDKVER="5.1"

declare			TCFILE_DEV="$SCRTDIR"/"Eonil's CMake Toolchain for iOS - Device"
declare			TCFILE_SIM="$SCRTDIR"/"Eonil's CMake Toolchain for iOS - Simulator"

declare			LOC_DEV="$PKGDIR"/"sdk-paths-iphoneos"
declare			LOC_SIM="$PKGDIR"/"sdk-paths-iphonesimulator"

rm				-rf	"$PKGDIR"
mkdir			-p	"$PKGDIR"
mkdir			-p	"$PDIR_DEV_ARMV7"
mkdir			-p	"$PDIR_DEV_ARMV6"
mkdir			-p	"$PDIR_SIM_I386"

cd				"$DSTDIR"











########		Resolve SDK paths.
sh				"$SCRTDIR"/"SDK Locator"/Locate.sh "$LOC_DEV" iphoneos
sh				"$SCRTDIR"/"SDK Locator"/Locate.sh "$LOC_SIM" iphonesimulator
chmod			+x "$LOC_DEV"
chmod			+x "$LOC_SIM"




########		iPhone Device - ARMv7
cd				"$PDIR_DEV_ARMV7"
.				"$LOC_DEV"
declare			-x	CC=`xcrun -sdk iphoneos -find cc`
declare			-x	CXX=`xcrun -sdk iphoneos -find c++`
declare			-x	LD=`xcrun -sdk iphoneos -find ld`
declare			-x	CFLAGS="-arch armv7 -isysroot \"$SDK_DIR\" -miphoneos-version-min=4.0"
declare			-x	CXXFLAGS=$CFLAGS
declare			-x	LDFLAGS=$CFLAGS
cmake			"$SRCDIR"	-G "Unix Makefiles" -D"BUILD_SHARED_LIBS"="OFF" -D"CMAKE_TOOLCHAIN_FILE"="$TCFILE_DEV"
make
lipo			-info "$PDIR_DEV_ARMV7"/"$PKGNAME"



########		iPhone Device - ARMv6
cd				"$PDIR_DEV_ARMV6"
.				"$LOC_DEV"
declare			-x	CC=`xcrun -sdk iphoneos -find cc`
declare			-x	CXX=`xcrun -sdk iphoneos -find c++`
declare			-x	LD=`xcrun -sdk iphoneos -find ld`
declare			-x	CFLAGS="-arch armv6 -isysroot \"$SDK_DIR\" -miphoneos-version-min=4.0"
declare			-x	CXXFLAGS=$CFLAGS
declare			-x	LDFLAGS=$CFLAGS
cmake			"$SRCDIR"	-G "Unix Makefiles" -D"BUILD_SHARED_LIBS"="OFF" -D"CMAKE_TOOLCHAIN_FILE"="$TCFILE_DEV"
make
lipo			-info "$PDIR_DEV_ARMV6"/"$PKGNAME"



########		iPhone Simulator - i386
cd				"$PDIR_SIM_I386"
.				"$LOC_SIM"
declare			-x	CC=`xcrun -sdk iphonesimulator -find cc`
declare			-x	CXX=`xcrun -sdk iphonesimulator -find c++`
declare			-x	LD=`xcrun -sdk iphonesimulator -find ld`
declare			-x	CFLAGS="-arch i386 -isysroot \"$SDK_DIR\" -miphoneos-version-min=4.0"
declare			-x	CXXFLAGS=$CFLAGS
declare			-x	LDFLAGS=$CFLAGS
cmake			"$SRCDIR"	-G "Unix Makefiles" -D"BUILD_SHARED_LIBS"="OFF" -D"CMAKE_TOOLCHAIN_FILE"="$TCFILE_DEV"
make
lipo			-info "$PDIR_SIM_I386"/"$PKGNAME"



########		LIPO - Join all thin binaries.
cd				"$PKG_DIR"
lipo			-create -arch armv7 "$PDIR_DEV_ARMV7"/"$PKGNAME" -arch armv6 "$PDIR_DEV_ARMV6"/"$PKGNAME" -arch i386 "$PDIR_SIM_I386"/"$PKGNAME" -o "$PKGDIR"/"$PKGNAME"
lipo			-info "$PKGDIR"/"$PKGNAME"



