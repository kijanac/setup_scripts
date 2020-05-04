#!/bin/bash

mkdir "$1" && git clone https://github.com/zorkzou/Molden2AIM "$1/molden2aim"

cd "$1/molden2aim/src"

conda create -n molden2aim libgfortran -c conda-forge -y

source $(conda info --base)/etc/profile.d/conda.sh && conda activate molden2aim

gfortran -O3 edflib.f90 molden2aim.f90 -o molden2aim.exe
