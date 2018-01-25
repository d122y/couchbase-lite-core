#!/bin/bash

PREFIX=""
WORKING_DIR="${1}"

if [[ $# > 1 ]]; then
  PREFIX="${2}"
fi

pushd $WORKING_DIR
COMMAND="find . -name \"*.a\" | xargs ${STRIP} --strip-unneeded"
eval ${COMMAND}
rm libLiteCore.so
make -j8 LiteCore
COMMAND="${OBJCOPY} --only-keep-debug libLiteCore.so libLiteCore.so.sym"
eval ${COMMAND}
COMMAND="${STRIP} --strip-unneeded libLiteCore.so"
eval ${COMMAND}
COMMAND="${OBJCOPY} --add-gnu-debuglink=libLiteCore.so.sym libLiteCore.so"
eval ${COMMAND}
popd
