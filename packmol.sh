#!/bin/bash

git clone https://github.com/mcubeg/packmol "$1" && cd "$1"

conda create -n packmol libgfortran make -c conda-forge -y

source $(conda info --base)/etc/profile.d/conda.sh && conda activate packmol

make
