#!/bin/bash

export PATH=/mnt/mxe/usr/bin:$PATH
MXE_PATH=/mnt/mxe

sed -i "s/WinIoCtl.h/winioctl.h/g" src/dbinc/win_db.h

CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
  CXX=$MXE_PATH/usr/bin/i686-w64-mingw32.static-g++ \
  ../dist/configure \
    --disable-replication \
    --enable-mingw \
    --enable-cxx \
    --host x86 \
    --prefix=$MXE_PATH/usr/i686-w64-mingw32.static

make

make install
