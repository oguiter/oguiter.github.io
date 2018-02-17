#!/bin/bash

export ANDROID_HOME=/home/$USER/Android/Sdk/
export NDK_ROOT=/home/$USER/Android/Sdk/ndk-bundle

ANDROID_PLATFORM="android-21"
ANDROID_API=21

# In my case, FindJNI.cmake does not find java, so i had to manually specify these
# You could try without it and remove the cmake variable specification at the bottom of this file
##JAVA_HOME=/usr/lib/jvm/oracle-java8-jdk-amd64

JAVA_HOME=/usr/lib/jvm/jdk1.8.0_161
JAVA_AWT_LIBRARY=$JAVA_HOME/jre/lib/amd64
JAVA_JVM_LIBRARY=$JAVA_HOME/jre/lib/amd64
JAVA_INCLUDE_PATH=$JAVA_HOME/include
JAVA_INCLUDE_PATH2=$JAVA_HOME/include/linux
JAVA_AWT_INCLUDE_PATH=$JAVA_HOME/include

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

echo "##########################################################"
echo "# OpenCV4Android "
echo "##########################################################"
git clone https://github.com/opencv/opencv
mkdir opencv/build
cd opencv/build

#Run the build 
../platforms/android/build_sdk.py --sdk_path=$ANDROID_HOME --ndk_path=$NDK_ROOT --config="../platforms/android/ndk-16.config.py"

echo "##########################################################"
echo "#BUILD TESSERACT"
echo "##########################################################"
git clone --recursive https://github.com/rmtheis/tess-two.git tess2
cd tess2
#prepare for Android build
echo "sdk.dir=$ANDROID_HOME
ndk.dir=$ANDROID_HOME/ndk-bundle" > local.properties
./gradlew assemble
cd ..

echo "##########################################################"
echo " OpenAlpr"
echo "##########################################################"

git clone https://github.com/jav974/openalpr.git openalpr
mkdir openalpr/android-build

TESSERACT_SRC_DIR=$SCRIPTPATH/tess2/tess-two/jni/com_googlecode_tesseract_android/src

#just in case of rebuild...
rm -rf openalpr/src/openalpr/ocr/tesseract
mkdir openalpr/src/openalpr/ocr/tesseract

shopt -s globstar
cd $TESSERACT_SRC_DIR
cp **/*.h $SCRIPTPATH/openalpr/src/openalpr/ocr/tesseract

cd $SCRIPTPATH

### Supported flavors
declare -a ANDROID_ABIS=(
		"armeabi"
		 "armeabi-v7a"	
#		 "armeabi-v7a with NEON"
		 "arm64-v8a"
#		 "mips"
#		 "mips64"
		 "x86"
		 "x86_64"
			)

cd openalpr/android-build

for i in "${ANDROID_ABIS[@]}"
do
    echo "==================================================================="
	echo $i
    echo "==================================================================="
    if [ "$i" == "armeabi-v7a with NEON" ]; then abi="armeabi-v7a"; else abi="$i"; fi
    TESSERACT_LIB_DIR=$$SCRIPTPATH/tess2/tess-two//libs/$abi
    if [[ "$i" == armeabi* ]];
    then
    	arch="arm"
    	lib="lib"
    elif [[ "$i" == arm64-v8a ]];
    then
	    arch="arm64"
	    lib="lib"
    elif [[ "$i" == mips ]] || [[ "$i" == x86 ]];
    then
	    arch="$i"
	    lib="lib"
    elif [[ "$i" == mips64 ]] || [[ "$i" == x86_64 ]];
    then
	    arch="$i"
	    lib="lib64"
    fi
    
    echo "

######################################
Generating project for arch $i
######################################
 rm -rf "$i" && mkdir "$i"
 cd "$i"

	cmake \
	-DANDROID_TOOLCHAIN=clang \
	-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
	-DCMAKE_SHARED_LINKER_FLAGS="-Wl,--exclude-libs,libippicv.a -Wl,--exclude-libs,libippiw.a" \
	-DCMAKE_TOOLCHAIN_FILE=$NDK_ROOT/build/cmake/android.toolchain.cmake \
	-DANDROID_NDK=$NDK_ROOT \
	-DCMAKE_BUILD_TYPE=Release \
	-DANDROID_PLATFORM=$ANDROID_PLATFORM \
	-DANDROID_ABI="$i" \
	-DANDROID_STL=gnustl_static \
	-DANDROID_CPP_FEATURES="rtti exceptions" \
    -DANDROID_ARM_MODE=arm \
	-DTesseract_INCLUDE_BASEAPI_DIR=$TESSERACT_SRC_DIR/api \
	-DTesseract_INCLUDE_CCSTRUCT_DIR=$TESSERACT_SRC_DIR/ccstruct \
	-DTesseract_INCLUDE_CCMAIN_DIR=$TESSERACT_SRC_DIR/ccmain \
	-DTesseract_INCLUDE_CCUTIL_DIR=$TESSERACT_SRC_DIR/ccutil \
	-DTesseract_LIB=$TESSERACT_LIB_DIR/libtess.so \
	-DLeptonica_LIB=$TESSERACT_LIB_DIR/liblept.so \
	-DOpenCV_DIR=$SCRIPTPATH/OpenCV-android-sdk/sdk/native/jni \
   	-DJnigraphics_LIB=$NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-$arch/usr/$lib/libjnigraphics.so \
    -DPngt_LIB=$TESSERACT_LIB_DIR/libpngt.so \
	-DJpgt_LIB=$TESSERACT_LIB_DIR/libjpgt.so \
	-DJAVA_AWT_LIBRARY=$JAVA_AWT_LIBRARY \
	-DJAVA_JVM_LIBRARY=$JAVA_JVM_LIBRARY \
	-DJAVA_INCLUDE_PATH=$JAVA_INCLUDE_PATH \
	-DJAVA_INCLUDE_PATH2=$JAVA_INCLUDE_PATH2 \
	-DJAVA_AWT_INCLUDE_PATH=$JAVA_AWT_INCLUDE_PATH \
    ../../src/

cmake --build . -- -j$(nproc)
	echo "=========== Build for $i done ==========="
    
    cd ..
done

echo "
All done !!!"

