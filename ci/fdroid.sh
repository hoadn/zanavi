#! /bin/bash

if [ `uname -m` == 'x86_64' ] ; then SUFFIX2='_64' ; else SUFFIX2='' ; fi && \
export PATH=$PATH:$_SDK_/tools:$_SDK_/platform-tools:$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/bin && \
rm build.xml && \
mkdir nav2 && \
for i in `ls -1`; do if [ "$i" != "nav2" ]; then mv $i nav2/ ; fi ; done && \
mv nav2 navit && \
mkdir android-build && \
cd android-build/ && \
DEBUG_="-fpic -ffunction-sections -fstack-protector -fomit-frame-pointer -fno-strict-aliasing -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__  -Wno-psabi -march=armv5te -msoft-float -mthumb -finline-limit=64 -DHAVE_API_ANDROID -DANDROID  -Wa,--noexecstack -O3 -I$_NDK_/platforms/android-14/arch-arm/usr/include -nostdlib -Wl,-rpath-link=$_NDK_/platforms/android-14/arch-arm/usr/lib -L$_NDK_/platforms/android-14/arch-arm/usr/lib" && \
../navit/configure RANLIB=arm-linux-androideabi-ranlib AR=arm-linux-androideabi-ar CC="arm-linux-androideabi-gcc -O2 $DEBUG_ -L. -L$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/lib/gcc/arm-linux-androideabi/4.8/ -lgcc -ljnigraphics " CXX="arm-linux-androideabi-g++ -O2 -fno-rtti -fno-exceptions -L$_NDK_/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86$SUFFIX2/lib/gcc/arm-linux-androideabi/4.8/ -lgcc -ljnigraphics " --host=arm-eabi-linux_android --enable-avoid-float --enable-avoid-unaligned --disable-glib --disable-gmodule --disable-vehicle-gpsd --enable-vehicle-demo --disable-binding-dbus --disable-speech-cmdline --disable-gui-gtk --disable-font-freetype --disable-fontconfig --disable-graphics-gtk-drawing-area --disable-maptool --enable-cache-size=20971520 --enable-svg2png-scaling=8,16,32,48,64,96,192,384 --enable-svg2png-scaling-nav=48,64,59,96,192,384 --enable-svg2png-scaling-flag=32 --with-xslts=android,plugin_menu --with-saxon=saxonb-xslt --enable-transformation-roll --with-android-project="android-21" && \
export AND_API_LEVEL_C=14 && \
export NDK=$_NDK_ && \
export DO_RELEASE_BUILD=1 && \
export DO_PNG_BUILD=1 && \
export NDK_CCACHE="" && \
make && \
pwd && \
cd navit && \
make apkg-release || pwd && \
cd android-support-v7-appcompat && \
cat local.properties |sed -e "s#/home/navit/_navit_develop/_need/SDK/_unpack/android-sdk-linux_x86#$_SDK_#" > l.txt && \
mv l.txt local.properties && \
cat local.properties && \
echo android update project -t android-21 -p . && \
cd .. && \
pwd && \
cp -av ../../navit/trans_img/* ./android/res/ && \
cp -av ../../navit/trans_img/* ../../android-build/navit/android/res/ && \
cp -av ../../navit/trans_img/* ../../navit/navit/android/res/ && \
cd ./android && \
pwd && \
cat AndroidManifest.xml | sed -e 's#android:debuggable="true"#android:debuggable="false"#' > l.txt && \
mv l.txt AndroidManifest.xml && \
cat src/com/zoffcc/applications/zanavi/Navit.java | sed -e 's#static final boolean FDBL = false;#static final boolean FDBL = true;#' > l.txt && \
mv l.txt src/com/zoffcc/applications/zanavi/Navit.java && \
ant release && \
cd ../../../ && \
pwd && \
cat android-build/navit/android/project.properties | sed -e 's#^android.library.reference.*$#android.library.reference.1=./android-support-v7-appcompat#' > l.txt && \
mv l.txt android-build/navit/android/project.properties && \
ln -s android-build/navit/android-support-v7-appcompat . && \
ln -s android-build/navit/android/* .

