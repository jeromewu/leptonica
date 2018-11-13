#!/bin/sh
#
# This script is for testing build using emscripten
#

build_libtiff() {
  cd libtiff
  emconfigure ./configure --prefix=${PWD}/usr
  emmake make install -j4
  cd ..
}

build_leptonica() {
  mkdir build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=../usr \
    -DSTATIC=ON
  emmake make install -j4
}

main() {
  build_libtiff
  build_leptonica
}

main "$@"
