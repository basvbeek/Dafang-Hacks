#!/usr/bin/env bash
TOOLCHAIN=$(pwd)/toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mipsel-linux-
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export CFLAGS="-O3"
export CPPFLAGS="-O3"
export LDFLAGS="-O3"

if [ ! -d jpeg-9d ]
then
  wget https://www.ijg.org/files/jpegsrc.v9d.tar.gz
  tar xvfz jpegsrc.v9d.tar.gz
fi

cd jpeg-9d 
./configure --host=mips-linux-gnu --prefix=$(pwd)/_Install  --enable-static   --disable-shared
make clean
make
make install

# Do it in double, once with the disable-shared to have jpgretran stand alone
# and one without this option to create the shared lib (needed by other tool)
#cp _Install/bin/jpegtran _Install/bin/jpegtran.nolib
#
#./configure --host=mips-linux-gnu --prefix=$(pwd)/_Install  --enable-static
#make clean
#make
#make install
