#!/bin/sh
#
# This script is for testing build using emscripten
#

NPROC=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l)
export CPPFLAGS="-I${PWD}/usr/include"
export LDFLAGS="-L${PWD}/usr/lib"

build_zlib() {
  cd zlib
  rm zconf.h
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${PWD}/../../usr
  emmake make install -j${NPROC}
  cd ../..
}

build_libjpeg() {
  cd libjpeg
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${PWD}/../../usr
  emmake make install -j${NPROC}
  cd ../..
}

build_libpng() {
  cd libpng
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${PWD}/../../usr \
    -D M_LIBRARY:PATH=/usr/lib/x86_64-linux-gnu
  emmake make install -j${NPROC}
  cd ../..
}

build_libtiff() {
  cd libtiff
  emconfigure ./configure --prefix=${PWD}/../usr
  emmake make install -j${NPROC}
  cd ..
}

build_leptonica() {
  rm -rf build
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=../usr
  emmake make install -j${NPROC}
}

main() {
  build_zlib
  build_libjpeg
  build_libpng
  build_libtiff
  build_leptonica
}

main "$@"
