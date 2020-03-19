#!/bin/sh
#
# This script is for building using emscripten
#

NPROC=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l)
EM_TOOLCHAIN_FILE=/emsdk_portable/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake
CUR_DIR=${PWD}
INSTALL_DIR=${CUR_DIR}/usr
LIB_DIR=${INSTALL_DIR}/lib
INC_DIR=${INSTALL_DIR}/include
ZLIB_LIB=${LIB_DIR}/libz.a
JPEG_LIB=${LIB_DIR}/libjpeg.a
PNG_LIB=${LIB_DIR}/libpng.a
TIFF_LIB=${LIB_DIR}/libtiff.a
LIBM_LIB=${LIB_DIR}/libopenlibm.a
export CPPFLAGS="-I${PWD}/usr/include"
export LDFLAGS="-L${PWD}/usr/lib"

build_zlib() {
  cd zlib
  rm zconf.h
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -D BUILD_SHARED_LIBS=OFF
  emmake make install -j${NPROC}
  cd ${CUR_DIR}
}

build_libm() {
  cd openlibm
  git checkout v0.7.0 Make.inc
  sed -i 's/CC = $(TOOLPREFIX)gcc/CC = $(TOOLPREFIX)emcc/g' Make.inc
  sed -i 's/AR = $(TOOLPREFIX)ar/AR = $(TOOLPREFIX)emar/g' Make.inc
  emmake make -j${NPROC}
  cp libopenlibm.a ${LIB_DIR}/
  cd ${CUR_DIR}
}

build_libjpeg() {
  cd libjpeg
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -D BUILD_SHARED_LIBS=OFF
  emmake make install -j${NPROC}
  cd ${CUR_DIR}
}

build_libpng() {
  cd libpng
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -D ZLIB_LIBRARY=${ZLIB_LIB} \
    -D ZLIB_INCLUDE_DIR=${INC_DIR} \
    -D M_LIBRARY:PATH=${LIBM_LIB} \
    -D PNG_STATIC=ON \
    -D PNG_SHARED=OFF \
    -D PNG_TESTS=NO
  emmake make install -j${NPROC}
  cd ${CUR_DIR}
}

build_libtiff() {
  cd libtiff
  emconfigure ./configure \
    --prefix=${INSTALL_DIR} \
    --disable-shared
  emmake make install -j${NPROC}
  cd ${CUR_DIR}
}

build_leptonica() {
  rm -rf build
  mkdir -p build
  cd build
  emmake cmake .. \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DCMAKE_TOOLCHAIN_FILE=${EM_TOOLCHAIN_FILE} \
    -D ZLIB_LIBRARY=${ZLIB_LIB} \
    -D ZLIB_INCLUDE_DIR=${INC_DIR} \
    -D JPEG_LIBRARY=${JPEG_LIB} \
    -D JPEG_INCLUDE_DIR=${INC_DIR} \
    -D PNG_LIBRARY=${PNG_LIB} \
    -D PNG_PNG_INCLUDE_DIR=${INC_DIR} \
    -D TIFF_LIBRARY=${TIFF_LIB} \
    -D TIFF_INCLUDE_DIR=${INC_DIR}
  emmake make install -j${NPROC}
}

main() {
  build_zlib
  build_libm
  build_libjpeg
  build_libpng
  build_libtiff
  build_leptonica
}

main "$@"
