#!/bin/bash

./configure --prefix=${PREFIX} \
            --with-zlib=yes \
            --with-png=yes \
            --without-harfbuzz \
            --with-bzip2=no \
            --enable-freetype-config

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install
