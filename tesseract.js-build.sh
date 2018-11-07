#!/bin/bash
#
# This script is specific for building leptonica for tesseract.js
# 
# Before running this script, you need to install docker first.
#

check_command() {
  CMD=$1
  command -v $CMD >/dev/null 2>&1 || { echo >&2 "$CMD is not installed  Aborting."; exit 1; }
}

clean() {
  docker run \
    -v ${PWD}:/src \
    trzeci/emscripten:sdk-tag-1.38.16-64bit \
    sh -c 'cd ./src && emmake make -f makefile.static clean'
}

compile() {
  docker run \
    -v ${PWD}:/src \
    trzeci/emscripten:sdk-tag-1.38.16-64bit \
    sh -c 'cd ./src && emmake make -f makefile.static'
}

main() {
  check_command docker
  clean
  compile
}

main "$@"
