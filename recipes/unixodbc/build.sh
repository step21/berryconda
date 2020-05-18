#!/bin/bash

set -e
set -x

export CFLAGS="-O2 ${CFLAGS}"
export CXXFLAGS="-O2 ${CXXFLAGS}" 

autoreconf -vfi

./configure --sysconfdir=/etc --prefix=$PREFIX --build=${BUILD}

make -j${CPU_COUNT}
make install
