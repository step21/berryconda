#!/bin/bash

# The compiler flags interfere with th build and we need to overide them :-/
if [[ $(uname) == Darwin ]]; then
  unset CPPFLAGS
  export CPPFLAGS="-Wl,-rpath,$PREFIX/lib -I${PREFIX}/include"

  unset LDFLAGS
  export LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib -headerpad_max_install_names"
fi

autoreconf -vfi

# The --enable-silent-rules is needed because Travis CI dies on the long output from this build.
./configure --prefix=${PREFIX}\
            --host=$HOST \
            --enable-linux-lfs \
            --enable-silent-rules \
            --enable-shared \
            --with-ssl \
            --with-zlib \
            --with-jpeg \
            --disable-netcdf \
            --disable-fortran

make

# ncgen segfaults on macOS
if [[ $(uname) != Darwin ]]; then
make check
fi

make install


# Remove man pages.
rm -rf ${PREFIX}/share

# Avoid clashing names with netcdf.
mv ${PREFIX}/bin/ncdump ${PREFIX}/bin/h4_ncdump
mv ${PREFIX}/bin/ncgen ${PREFIX}/bin/h4_ncgen

# People usually Google these.
rm -rf ${PREFIX}/examples
