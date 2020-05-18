#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${HOST} =~ .*linux.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

mkdir build_shared && cd $_
cmake \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=False \
    ${CMAKE_PLATFORM_FLAGS[@]} ..
make
make install
cd ..

mkdir build_static && cd $_
cmake \
    -DJAS_ENABLE_SHARED=OFF \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DJAS_ENABLE_AUTOMATIC_DEPENDENCIES=False \
    ${CMAKE_PLATFORM_FLAGS[@]} ..
make
make install
cd ..
