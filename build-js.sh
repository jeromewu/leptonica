#!/bin/sh
#
# This script is for testing build using emscripten
#

rm -rf build
mkdir build
cd build
emmake cmake ..
emmake make
