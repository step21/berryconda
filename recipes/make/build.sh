#!/usr/bin/env bash
set -ex

if [[ "$(uname)" == 'Linux' ]]; then
  rm -f tests/scripts/functions/wildcard
fi

if [[ ${target_platform} =~ .*aarch64.* || ${target_platform} =~ .*ppc64le.* ]]; then
  config_opts="--disable-dependency-tracking"
else
  config_opts=""
fi

./configure --prefix=$PREFIX ${config_opts}
# bootstrap building make without make
bash build.sh
# make
./make check
./make install
