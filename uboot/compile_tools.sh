#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/../toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-


export HOSTCC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export CFLAGS="-O2"
export CPPFLAGS="-O2"
export LDFLAGS="-O2"
export PATH=$TOOLCHAIN:$PATH
rm tools/env/fw_printenv
make env

HOST=192.168.0.99
ftp-upload -h ${HOST} -u root --password ismart12 -d /system/sdcard/bin/ tools/env/fw_printenv