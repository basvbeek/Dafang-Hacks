#!/usr/bin/env bash

set -e # fail out if any step fails

. ../../setCompilePath.sh

CFLAGS="-O3 -I${INSTALLDIR}/include -I ${INSTALLDIR}/include/libnl3"
BINDIR=${INSTALLDIR}/bin
LIBDIR=${INSTALLDIR}/lib

cd wpa_supplicant
make 
