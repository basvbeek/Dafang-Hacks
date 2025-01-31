#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/../toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export CROSS_COMPILE=${CROSS_COMPILE}
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export CFLAGS="-O2 -DDEBUG_TRACE -DFAKE_ROOT "
export CPPFLAGS="-O2"
export LDFLAGS="-O2"
make clean
make