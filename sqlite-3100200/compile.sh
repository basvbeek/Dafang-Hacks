#!/usr/bin/env bash

ROOTPATH=$(git rev-parse --show-toplevel)
echo "setting $ROOTPATH"
export TOOLCHAIN=${ROOTPATH}/toolchain/bin
CROSS_PREFIX=mips-linux-gnu-
export CC=${TOOLCHAIN}/${CROSS_PREFIX}gcc
export LD=${TOOLCHAIN}/${CROSS_PREFIX}ld
export CCLD=${TOOLCHAIN}/${CROSS_PREFIX}ld
export CXX=${TOOLCHAIN}/${CROSS_PREFIX}g++
export CPP=${TOOLCHAIN}/${CROSS_PREFIX}cpp
export CXXCPP=${TOOLCHAIN}/${CROSS_PREFIX}cpp
export AR=${TOOLCHAIN}/${CROSS_PREFIX}ar
export CROSS_COMPILE=$TOOLCHAIN/mips-linux-gnu-
export PKG_CONFIG_PATH=$ROOTPATH/_install/lib/pkgconfig
export LIBRARY_PATH=$ROOTPATH/_install/lib
export CFLAGS="-muclibc -O3 -lrt -I../_install/include/ ${NO_MOTION_SYSTEM_CALLS}"
export CPPFLAGS="-muclibc -O3 -lrt -I../_install/include/ -std=c++11 ${NO_MOTION_SYSTEM_CALLS}"
export LDFLAGS="-muclibc -O3 -L${LIBRARY_PATH} -lpthread"
export INSTALLDIR=${ROOTPATH}/_install
export INSTALL=$(pwd)/install-sh

./configure --host=mips-linux-gnu --prefix=${INSTALLDIR}  \
    --disable-gtk-doc \
    --disable-gtk-doc-html \
    --disable-doc \
    --disable-docs \
    --disable-documentation \
    --with-xmlto=no \
    --with-fop=no \
    --disable-dependency-tracking \
    --disable-ipv6 \
    --enable-static \
    --enable-shared \
    --disable-static-shell \
    --enable-threadsafe \
    --disable-readline

make -j4
make install
