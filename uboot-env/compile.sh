#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/../toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export CFLAGS="-O2"
export CPPFLAGS="-O2"
export LDFLAGS="-O2"
make
