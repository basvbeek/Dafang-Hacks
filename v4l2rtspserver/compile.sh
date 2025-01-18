#!/usr/bin/env bash

# uncomment to disable the detectionOn/Off/Tracking script execution, instead rely on MQTT
#NO_MOTION_SYSTEM_CALLS="-UMOTION_SYSTEM_CALLS"

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
export INSTALL=${ROOTPATH}/_install
export CROSS_COMPILE=$TOOLCHAIN/mips-linux-gnu-
export PKG_CONFIG_PATH=$ROOTPATH/_install/lib/pkgconfig
export LIBRARY_PATH=$ROOTPATH/_install/lib
export CFLAGS="-muclibc -O3 -lrt -I../v4l2rtspserver-tools -I../v4l2cpp/inc -I../_install/include/freetype2 -I../_install/include/ ${NO_MOTION_SYSTEM_CALLS}"
export CPPFLAGS="-muclibc -O3 -lrt -I../v4l2rtspserver-tools -I../v4l2cpp/inc -I../_install/include/freetype2 -I../_install/include/ -std=c++11 ${NO_MOTION_SYSTEM_CALLS}"
export LDFLAGS="-muclibc -O3 -L${LIBRARY_PATH} -L${ROOTPATH}/v4l2cpp -lrt -lstdc++ -lpthread -ldl -lmosquitto -lssl -ltls -lcrypto"

rm CMakeCache.txt
rm -r CMakeFiles
cmake -DCMAKE_TOOLCHAIN_FILE="./dafang.toolchain"  -DCMAKE_INSTALL_PREFIX=../_install && make VERBOSE=1 -j4 install
make && make install