#!/bin/bash

git clone https://github.com/grimme-lab/xtb.git "$1" && cd "$1"
mkdir build
pushd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
ctest
popd
