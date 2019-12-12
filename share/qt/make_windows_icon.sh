#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/growerscoin.ico

convert ../../src/qt/res/icons/growerscoin-16.png ../../src/qt/res/icons/growerscoin-32.png ../../src/qt/res/icons/growerscoin-48.png ${ICON_DST}
