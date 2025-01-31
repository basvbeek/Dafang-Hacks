#!/usr/bin/env bash

ROOTPATH=$(git rev-parse --show-toplevel)
echo "setting $ROOTPATH"
export TOOLCHAIN=${ROOTPATH}/toolchain/bin
CROSS_PREFIX=mipsel-linux-
export CC=${TOOLCHAIN}/${CROSS_PREFIX}gcc
export LD=${TOOLCHAIN}/${CROSS_PREFIX}ld
export CCLD=${TOOLCHAIN}/${CROSS_PREFIX}ld
export CXX=${TOOLCHAIN}/${CROSS_PREFIX}g++
export CPP=${TOOLCHAIN}/${CROSS_PREFIX}cpp
export CXXCPP=${TOOLCHAIN}/${CROSS_PREFIX}cpp
export AR=${TOOLCHAIN}/${CROSS_PREFIX}ar
export CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export PKG_CONFIG_PATH=$ROOTPATH/_install/lib/pkgconfig
export LIBRARY_PATH=$ROOTPATH/_install/lib
export CFLAGS="-O3 -lrt -I../_install/include/ ${NO_MOTION_SYSTEM_CALLS}"
export CPPFLAGS="-O3 -lrt -I../_install/include/ -std=c++11 ${NO_MOTION_SYSTEM_CALLS}"
export LDFLAGS="-O3 -L${LIBRARY_PATH}"
export INSTALLDIR=${ROOTPATH}/_install
export INSTALL=$(pwd)/install-sh

make -j4
