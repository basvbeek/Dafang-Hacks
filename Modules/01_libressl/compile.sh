#!/bin/bash

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d portable/.git ]; then
    # v3.9.2 is the last release with mips32 support.
    git clone -b v3.9.2 https://github.com/libressl-portable/portable.git
    cd portable
#    git checkout OPENBSD_6_6
    sed -i 's/program_invocation_short_name/"?"/g' crypto/compat/getprogname_linux.c
    cd ..
fi

cd portable
./autogen.sh
./configure --prefix=${INSTALLDIR} --host=mips-linux-gnu --with-pic
make -j4
make install
