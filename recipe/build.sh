#!/bin/bash
set -ex

mkdir -p build
cd build
cmake -DLIB_INSTALL_DIR="${PREFIX}/lib" \
  -DCMAKE_BUILD_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  ..
make -j "${CPU_COUNT}"
make install

if [ "$(uname)" == "Linux" ]; then
  # move to proper library directory
  if [ -d "$PREFIX/lib64" ]; then
    nofiles=$(cat "$PREFIX/lib64" | wc -l)

    if [ "$nofiles" != "0" ]; then
      mv $PREFIX/lib64/* $PREFIX/lib/
    fi
  fi
fi

# remove static libs
rm $PREFIX/lib/*.a
