#!/usr/bin/env bash

set -e # fail out if any step fails

. ../setCompilePath.sh

export INSTALL_MOD_PATH=${INSTALLDIR}

make clean
make uImage -j8
make modules
make headers_install
make modules_install