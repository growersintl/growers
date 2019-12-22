#!/bin/bash

export PATH=/mnt/mxe/usr/bin:$PATH
MXE_PATH=/mnt/mxe/usr/bin
MXE_INCLUDE_PATH=/mnt/mxe/usr/i686-w64-mingw32.static/include
MXE_LIB_PATH=/mnt/mxe/usr/i686-w64-mingw32.static/lib

#####################################################################################
# Note: for some reason, qmake-qt5 doesn't generate Makefile.release.               #
# For this reason, we'll build with qmake-qt5 but specify qt5 lrelease bin to link. #
#####################################################################################

$MXE_PATH/i686-w64-mingw32.static-qmake-qt4 \
  USE_QRCODE=1 \
  USE_UPNP=1 \
  BOOST_LIB_SUFFIX=-mt \
  BOOST_THREAD_LIB_SUFFIX=_win32-mt \
  BOOST_INCLUDE_PATH=$MXE_INCLUDE_PATH/boost \
  BOOST_LIB_PATH=$MXE_LIB_PATH \
  OPENSSL_INCLUDE_PATH=$MXE_INCLUDE_PATH/openssl \
  OPENSSL_LIB_PATH=$MXE_LIB_PATH \
  BDB_INCLUDE_PATH=$MXE_INCLUDE_PATH \
  BDB_LIB_PATH=$MXE_LIB_PATH \
  MINIUPNPC_INCLUDE_PATH=$MXE_INCLUDE_PATH \
  MINIUPNPC_LIB_PATH=$MXE_LIB_PATH \
  QRENCODE_INCLUDE_PATH=$MXE_INCLUDE_PATH \
  QRENCODE_LIB_PATH=$MXE_LIB_PATH \
  QMAKE_LRELEASE=/mnt/mxe/usr/i686-w64-mingw32.static/qt/bin/lrelease \
    growers-qt.pro $*

make -f Makefile.Release
