#!/usr/bin/env bash

set -e # fail out if any step fails

. ../setCompilePath.sh

export INSTALL_MOD_PATH=${INSTALLDIR}/lib/modules/

make clean
make uImage -j8
make modules
make headers_install