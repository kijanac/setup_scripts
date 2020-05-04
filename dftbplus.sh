#!/bin/bash

mkdir "$1" && git clone https://github.com/dftbplus/dftbplus.git "$1" && cd "$1" && git submodule update --init --recursive

conda create -n dftbplus arpack liblapack m4 make mpich-mpicc mpich-mpifort openblas scalapack -c conda-forge -y

source $(conda info --base)/etc/profile.d/conda.sh && conda activate dftbplus

cp sys/make.x86_64-linux-gnu make.arch

sed -i "s|PREFIX = /usr|PREFIX = $1|" make.arch
sed -i "s|FXX = mpifort|FXX = $CONDA_PREFIX/bin/mpif90|" make.arch
sed -i "s|CC = gcc|CC = $CONDA_PREFIX/bin/mpicc|" make.arch
sed -i "s|SCALAPACKDIR = \$(PREFIX)/lib|SCALAPACKDIR = $CONDA_PREFIX/lib|" make.arch
sed -i "s|M4 = m4|M4 = $CONDA_PREFIX/bin/m4|" make.arch

sed -i 's|WITH_MPI := 0|WITH_MPI := 1|' make.config
sed -i 's|WITH_ARPACK := 0|WITH_ARPACK := 1|' make.config
sed -i 's|BUILD_API := 0|BUILD_API := 1|' make.config

make && make install # make && make test && make install

wget http://www.dftb.org/fileadmin/DFTB/public/slako-unpacked.tar.xz && tar -xf slako-unpacked.tar.xz && rm slako-unpacked.tar.xz
