#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export CFLAGS="-O3"
export CPPFLAGS="-O3"
export LDFLAGS="-O3"

if [ ! -d libjpeg-turbo/.git ]
then
   git clone https://github.com/libjpeg-turbo/libjpeg-turbo
fi

cd libjpeg-turbo
./configure --host=mips-linux-gnu --prefix=$(pwd)/_Install  --enable-static   --disable-shared
make clean
make
make install
