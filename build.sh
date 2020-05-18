#!/bin/bash

LOG_FILE=build.log

for directory in ./recipes/*/ ; do
  PKG=$(basename $directory)
  echo "Now processing {$PKG}"
  if [ ! -f rpix/noarch/$PKG*.tar.bz2 ] && [ ! -f rpix/linux-armv7l/$PKG*.tar.bz2 ] ;
    then
      echo "Now running conda"
      conda-build --python 3 --variant-config-file conda_build_config.yaml --output-folder ./rpix --repository rpix $directory
      if [ $? -eq 0 ]
        then
          echo "Successfully built package {$directory}" 2>&1 | tee -a $LOG_FILE
      else
        echo "Error when building package {$directory}" 2>&1 | tee -a $LOG_FILE
      fi
  fi
done
