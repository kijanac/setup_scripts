#!/bin/bash

mkdir "$1" && git clone https://gitlab.com/ape/ape.git/ "$1"

conda create -n ape autoconf gsl libgcc-ng libgfortran libxc make -c conda-forge -c psi4 -y

source $(conda info --base)/etc/profile.d/conda.sh && conda activate ape

cd "$1" && autoreconf -i && ./configure --with-libxc-prefix=$CONDA_PREFIX --prefix="$1"

make && make check && make install
#
#export CC="$CONDA_PREFIX"/bin/mpicc
#export CXX="$CONDA_PREFIX"/bin/mpic++
#export FC="$CONDA_PREFIX"/bin/mpif90
#
#../configure --prefix="$1" --with-fftw3-prefix="$CONDA_PREFIX"/lib --with-blas="$CONDA_PREFIX"/lib --with-lapack="$CONDA_PREFIX"/lib/liblapack.so.3 --with-scalapack="$CONDA_PREFIX"/lib/libscalapack.so --with-blacs="$CONDA_PREFIX"/lib/libscalapack.so && make && make install
#
#rm -rf "$1/qball"

