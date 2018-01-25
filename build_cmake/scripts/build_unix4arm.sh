#!/bin/bash

SCRIPT_DIR=`dirname $0`
mv /usr/bin/ld /usr/bin/ld_unix
ln -s /usr/bin/arm-linux-gnueabihf-ld /usr/bin/ld
pushd $SCRIPT_DIR/..
source /opt/fsl-imx-x11/4.1.15-2.0.0/environment-setup-cortexa9hf-neon-poky-linux-gnueabi
mkdir -p linux-ARM4EM60
pushd linux-ARM4EM60
core_count=`getconf _NPROCESSORS_ONLN`
CC=clang-3.9 CXX=clang++-3.9 cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLITECORE_BUILD_SQLITE=1 ../.. -DCMAKE_C_COMPILER_TARGET="arm-poky-linux-gnueabi" -DCMAKE_PREFIX_PATH="/opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi" -DCMAKE_C_FLAGS="--target=arm-poky-linux-gnueabi -march=armv7-a -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a9 --gcc-toolchain=/opt/fsl-imx-x11/4.1.15-2.0.0/ --sysroot=/opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi  -O2 -pipe -g -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/../../../../../arm-poky-linux-gnueabi/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/../../../../../arm-poky-linux-gnueabi/lib/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/lib/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/" -DCMAKE_CXX_FLAGS="--target=arm-poky-linux-gnueabi -march=armv7-a -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a9 --gcc-toolchain=/opt/fsl-imx-x11/4.1.15-2.0.0/ --sysroot=/opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi  -O2 -pipe -g -I /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/include/c++/5.3.0/ -I /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/include/c++/5.3.0/backward/ -I /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/include/c++/5.3.0/arm-poky-linux-gnueabi -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/../../../../../arm-poky-linux-gnueabi/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/x86_64-pokysdk-linux/usr/lib/arm-poky-linux-gnueabi/gcc/arm-poky-linux-gnueabi/5.3.0/../../../../../arm-poky-linux-gnueabi/lib/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/lib/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/arm-poky-linux-gnueabi/5.3.0/ -L /opt/fsl-imx-x11/4.1.15-2.0.0/sysroots/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/"
make -j `expr $core_count + 1`
../scripts/strip.sh `pwd`
popd
popd
rm -rf /usr/bin/ld 
mv /usr/bin/ld_unix /usr/bin/ld
