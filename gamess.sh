#!/bin/sh

export PPN=32

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH" # sets the variable if it isn't already

export INTELBIN=/opt/intel-2018-4/bin
export MKLROOT=/opt/intel-2018-4/mkl
export IMPIROOT=/opt/intel-2018-4/impi/2018.4.274

export GMS_SCRATCH=$HOME/scr/gms

export PATH=$INTELBIN:$PATH
export IFORT_VERNO=$(echo $((ifort -v) 2>& 1) | awk -F'.' '{print $1}' | awk -F' ' '{print $3}')

tar -xzvf gamess-current.tar.gz && cd gamess

./config <<< "
linux64



ifort
$IFORT_VERNO

mkl
$MKLROOT
proceed




















































mpi
impi
$IMPIROOT
no
no
"
cd ddi && ./compddi > compddi.log && cd ..
./compall > compall.log
./lked > lked.log

sed -i "s|set DDI_MPI_CHOICE=.*|set DDI_MPI_CHOICE=impi|" rungms
sed -i "s|set DDI_MPI_ROOT=.*|set DDI_MPI_ROOT=$IMPIROOT/intel64|" rungms

sed -i 's|setenv I_MPI_FABRICS dapl|#--setenv I_MPI_FABRICS dapl|' rungms
sed -i 's|setenv I_MPI_DAT_LIBRARY libdat2.so|#--setenv I_MPI_DAT_LIBRARY libdat2.so|' rungms

sed -i 's|#--setenv I_MPI_FABRICS tcp|setenv I_MPI_FABRICS tcp|' rungms
sed -i 's|#--setenv I_MPI_TCP_NETMASK ib0|setenv I_MPI_TCP_NETMASK ib0|' rungms

sed -i "0,/set TARGET=.*/ s|set TARGET=.*|set TARGET=mpi|" rungms
sed -i '0,/set SCR=.*/ s|set SCR=.*|set SCR=$GMS_SCRATCH|' rungms
sed -i '0,/set USERSCR=.*/ s|set USERSCR=.*|set USERSCR=$GMS_SCRATCH|' rungms
sed -i "0,/set GMSPATH=.*/ s|set GMSPATH=.*|set GMSPATH=$PWD|" rungms

sed -i "s| >\&|$PPN >\&|" runall
./runall 00
tests/standard/checktst

#sed -i "0,/set TARGET=.*/ s|set TARGET=.*|set TARGET=mpi|" rungms
#sed -i '0,/set SCR=.*/ s|set SCR=.*|set SCR=$GMS_SCRATCH|' rungms
#sed -i '0,/set USERSCR=.*/ s|set USERSCR=.*|set USERSCR=$GMS_SCRATCH|' rungms
#sed -i "0,/set GMSPATH=.*/ s|set GMSPATH=.*|set GMSPATH=/opt/gamess-30-9-2019|" rungms

# now move $GMSPATH/auxdata, $GMSPATH/gamess.00.x, $GMSPATH/gms-files.csh, and $GMSPATH/rungms to the appropriate folder
