#!/usr/bin/env bash

. ../setCompilePath.sh

make distclean
make xiaofang1s_64mb_config
make
cp u-boot-with-spl.bin compiled_bootloader/xiaofang1s_64mb_v2.bin