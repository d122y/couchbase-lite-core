#!/bin/bash

SCRIPT_DIR=`dirname $0`
pushd $SCRIPT_DIR/..

mkdir -p lin-x86-x64
pushd lin-x86-x64
core_count=`getconf _NPROCESSORS_ONLN`
CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLITECORE_BUILD_SQLITE=1 ../..
make -j `expr $core_count + 1`
../scripts/strip.sh `pwd`
popd
popd
