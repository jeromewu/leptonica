#!/bin/sh
#
# This script is for testing build using emscripten
#

export CPPFLAGS="-I${PWD}/usr/include"
export LDFLAGS="-L${PWD}/usr/lib"

build_zlib() {
  cd zlib
  emconfigure ./configure --prefix=${PWD}/../usr
  emmake make install -j4
  cd ..
}

build_libjpeg() {
  cd libjpeg
  emconfigure ./configure --prefix=${PWD}/../usr
  emmake make install -j4
  cd ..
}

build_libpng() {
  cd libpng
  emconfigure ./configure --prefix=${PWD}/../usr
  emmake make install -j4
  cd ..
}

build_libtiff() {
  cd libtiff
  emconfigure ./configure --prefix=${PWD}/../usr
  emmake make install -j4
  cd ..
}

build_leptonica() {
  rm -rf build
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=../usr
  emmake make install -j4
}

main() {
  build_zlib
  build_libjpeg
  build_libpng
  build_libtiff
  build_leptonica
}

main "$@"
