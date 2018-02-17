Title: OpenAlpr For Android 2.3.0
Status: published
Date: 2018-02-17 14:00
Modified: 2018-02-17 14:00
Category: Devel
Tags: #openalpr, #android, #opencv

Well, time to use the "english" language...sounds better this morning :)

Why would you like to build OpenAlpr for Android from scratch ? ...maybe because you won't be able to find a suitable set of files, up to date. The famous work done by Sandro Machado ([https://github.com/SandroMachado/openalpr-android](https://github.com/SandroMachado/openalpr-android)) is based on version 1.1.2 ...and OpenAlpr is now on 2.3.0

It is also a funny game to master all the steps!

# Android SDK setup

Because of recent changes in Android tools (some of them disappeared between release 25 and 26), we have to install an older release. But i don't want to contaminate my existing setup !!! So, install everything in a different directory

``` bash
mkdir -p $HOME/Android/Sdk25
cd $HOME/Android/Sdk25
```

Get the zip file !!! This version is MANDATORY

``` bash
wget https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
unzip tools_r25.2.3-linux.zip
```

And install missing tools, with the SDK Manager:

``` bash
./tools/bin/sdkmanager "platform-tools" "build-tools;27.0.3" "platforms;android-27" "ndk-bundle"
```

# Java Oracle install

Get Java (e.g.: Linux x64) from  oracle.com ( Official link is: ( [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html))

or, if you don't want to go thru your browser (e.g.: on a build server), you can direct download with:

``` bash
wget --no-cookies --no-check-certificate --header \
"Cookie: oraclelicense=accept-securebackup-cookie" \
"http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
```

Then, we can install it to a usual directory:

``` bash
sudo mkdir -p /usr/lib/jvm
sudo tar xzf jdk-8u161-linux-x64.tar.gz -C /usr/lib/jvm
```

(You can check the whole Java path (something like /usr/lib/jvm/jdk1.8.0_161 ))

# Code: Build OpenCV4Android

Sure, i could use the official one ([https://opencv.org/platforms/android/](https://opencv.org/platforms/android/)) ... but remember "funny", "master all the steps"...

## OpenCV sources

Create your work/project/test/sandbox as a directory:

``` bash
mkdir $HOME/MyWork
cd $HOME/MyWork
```

Download the source from the official repo
( tested at git clone at e268fdc0ed89be11ce2e6d7a8832254fc4b67ccc  (master 20180215))

``` bash
git clone https://github.com/opencv/opencv
mkdir -p opencv/build
```

Start the build process, and take a coffee break !

``` bash
../platforms/android/build_sdk.py --sdk_path=$HOME/Android/Sdk25 --ndk_path=$HOME/Android/Sdk25/ndk-bundle --config="../platforms/android/ndk-16.config.py"
```

As we are building with ndk R16, only the following configurations will be generated:

`
"armeabi-v7a", "armeabi-v7a with NEON", "armeabi", "arm64-v8a", "x86_64", "x86")
`

All the generated library are in

``$HOME/MyWork/opencv/build/OpenCV-android-sdk``

I let you investigate how to cutomize the build process (e.g.: disable examples ...)

# Build  Tesseract for Android

As usual, get the source

``` bash
cd $HOME/MyWork
git clone --recursive https://github.com/rmtheis/tess-two.git tess2
cd tess2
```

Prepare the properties for Android build:

``` bash
echo "sdk.dir=$HOME/Android/Sdk25
ndk.dir=$HOME/Android/Sdk25/ndk-bundle" > local.properties
```

And let's rock !

``` bash
./gradlew assemble
```

( ! Tesseract for Android is buggy for x86_64)

# What about OpenALPR for Android ?

Same steps:

``` bash
cd $HOME/MyWork
git clone https://github.com/jav974/openalpr.git openalpr
mkdir openalpr/android-build
```

Don't forget to associate Tesseract libs:

``` bash
export TESSERACT_SRC_DIR=$HOME/MyWork/tess2/tess-two/jni/com_googlecode_tesseract_android/src
```

just in case of rebuild...

``` bash
rm -rf $HOME/MyWork/openalpr/src/openalpr/ocr/tesseract
mkdir $HOME/MyWork/openalpr/src/openalpr/ocr/tesseract
cp $TESSERACT_SRC_DIR/**/*.h $HOME/MyWork/openalpr/src/openalpr/ocr/tesseract
```

Move to the following directory:

``` bash
cd $HOME/MyWork/openalpr/android-build
```

The supported flavors could be "armeabi" "armeabi-v7a" "arm64-v8a" "x86" "x86_64" but, because of others libs limitations, we only keep "armeabi" "armeabi-v7a" "arm64-v8a" "x86"

Here's how to generate CMake files for building armeabi-v7a libs:

``` bash
export TESSERACT_LIB_DIR=$HOME/MyWork/tess2/tess-two//libs/armeabi-v7a
export arch="arm"
export lib="lib"

rm -rf armeabi-v7a && mkdir armeabi-v7a
cd armeabi-v7a

cmake \
-DANDROID_TOOLCHAIN=clang \
-DCMAKE_ANDROID_NDK_TOOLCHAIN_VERSION=clang \
-DCMAKE_SHARED_LINKER_FLAGS="-Wl,--exclude-libs,libippicv.a -Wl,--exclude-libs,libippiw.a" \
-DCMAKE_TOOLCHAIN_FILE=$HOME/Android/Sdk25/ndk-bundle/build/cmake/android.toolchain.cmake \
-DANDROID_NDK=$HOME/Android/Sdk25/ndk-bundle \
-DCMAKE_BUILD_TYPE=Release \
-DANDROID_PLATFORM="android-21" \
-DANDROID_ABI="armeabi-v7a" \
-DANDROID_STL=gnustl_static \
-DANDROID_CPP_FEATURES="rtti exceptions" \
-DTesseract_INCLUDE_BASEAPI_DIR=$TESSERACT_SRC_DIR/api \
-DTesseract_INCLUDE_CCSTRUCT_DIR=$TESSERACT_SRC_DIR/ccstruct \
-DTesseract_INCLUDE_CCMAIN_DIR=$TESSERACT_SRC_DIR/ccmain \
-DTesseract_INCLUDE_CCUTIL_DIR=$TESSERACT_SRC_DIR/ccutil \
-DTesseract_LIB=$TESSERACT_LIB_DIR/libtess.so \
-DLeptonica_LIB=$TESSERACT_LIB_DIR/liblept.so \
-DOpenCV_DIR=$HOME/MyWork/opencv/build/OpenCV-android-sdk/sdk/native/jni \
-DPngt_LIB=$TESSERACT_LIB_DIR/libpngt.so \
-DJpgt_LIB=$TESSERACT_LIB_DIR/libjpgt.so \
-DJnigraphics_LIB=$HOME/Android/Sdk25/ndk-bundle/platforms/android-21/arch-arm/usr/lib/libjnigraphics.so \
-DANDROID_ARM_MODE=arm \
-DJAVA_AWT_LIBRARY=/usr/lib/jvm/jdk1.8.0_161/jre/lib/amd64 \
-DJAVA_JVM_LIBRARY=/usr/lib/jvm/jdk1.8.0_161/jre/lib/amd64 \
-DJAVA_INCLUDE_PATH=/usr/lib/jvm/jdk1.8.0_161/include \
-DJAVA_INCLUDE_PATH2=/usr/lib/jvm/jdk1.8.0_161/include/linux \
-DJAVA_AWT_INCLUDE_PATH=/usr/lib/jvm/jdk1.8.0_161/include \
../../src/
```

Run for the build...

``` bash
cmake --build . -- -j$(nproc)
```

et voilà !

(Check the following script: [build_all_from_git.sh](./static/build_all_from_git.sh))

reference:

- <https://github.com/openalpr/openalpr/wiki/Android-compilation>
- <https://gist.github.com/jav974/072425f14927e6ca2c7a4439d8ac5457>
- <https://github.com/SandroMachado/openalpr-android>
