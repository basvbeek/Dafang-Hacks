#!/usr/bin/env bash

set -e # fail out if any step fails

. ../../setCompilePath.sh

./configure \
    --target=mipsel-buildroot-linux-musl \
    --host=mipsel-buildroot-linux-musl \
    --build=x86_64-pc-linux-gnu \
    --prefix=${INSTALLDIR} \
    --exec-prefix=${INSTALLDIR} \
    --sysconfdir=${INSTALLDIR}/etc \
    --localstatedir=${INSTALLDIR}/var \
    --program-prefix= \
    --disable-gtk-doc \
    --disable-gtk-doc-html \
    --disable-doc \
    --disable-docs \
    --disable-documentation \
    --with-xmlto=no \
    --with-fop=no \
    --disable-dependency-tracking \
    --enable-ipv6 \
    --disable-nls \
    --disable-static \
    --enable-shared \
    --disable-cli \
    --disable-unit-tests

make 
