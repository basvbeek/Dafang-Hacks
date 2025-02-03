#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/../toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export CROSS_COMPILE=${CROSS_COMPILE}
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
make clean
make
