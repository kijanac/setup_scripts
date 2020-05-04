#!/bin/bash

mkdir "$1" && git clone https://github.com/LLNL/qball "$1/qball"

cd "$1/qball" && autoreconf -i && mkdir build && cd build

conda create -n qball autoconf fftw liblapack make mpich-mpicc mpich-mpicxx mpich-mpifort openblas scalapack -c conda-forge -y

source $(conda info --base)/etc/profile.d/conda.sh && conda activate qball

export CC="$CONDA_PREFIX"/bin/mpicc
export CXX="$CONDA_PREFIX"/bin/mpic++
export FC="$CONDA_PREFIX"/bin/mpif90

../configure --prefix="$1" --with-fftw3-prefix="$CONDA_PREFIX"/lib --with-blas="$CONDA_PREFIX"/lib --with-lapack="$CONDA_PREFIX"/lib/liblapack.so.3 --with-scalapack="$CONDA_PREFIX"/lib/libscalapack.so --with-blacs="$CONDA_PREFIX"/lib/libscalapack.so && make && make install

rm -rf "$1/qball"

