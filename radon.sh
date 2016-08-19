Start=$(date +"%s")
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
KERNEL_DIR=$PWD
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/umang/toolchain/aarch64-linux-google-android-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=home/umang/toolchain/aarch64-linux-google-android-4.9/lib/
STRIP="/home/umang/toolchain/aarch64-linux-google-android-4.9/bin/aarch64-linux-android-strip"
make clean
make kenzo_defconfig
export KBUILD_BUILD_HOST="G5070"
export KBUILD_BUILD_USER="Umang"
make -j4
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/system/lib/modules/wlan.ko
cd $KERNEL_DIR/build
rm *.zip
cd $KERNEL_DIR/build/system/lib/modules/
$STRIP --strip-unneeded *.ko
cp $KERNEL_DIR/build/system/lib/modules/wlan.ko $KERNEL_DIR/build/system/lib/modules/pronto/pronto_wlan.ko
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red<<Failed to compile zImage, fix the errors first>>$white"
else
End=$(date +"%s")
Diff=$(($End - $Start))
cd $KERNEL_DIR/build
zip -r Radon-Kenzo-Miui.zip *
echo -e "$gre<<Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds>>$white"
fi
