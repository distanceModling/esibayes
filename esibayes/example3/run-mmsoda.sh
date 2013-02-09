
#Use this script interactively on one of the login nodes by typing ./run-mmsoda.sh at the LISA prompt.


echo "Unloading module matlab"
module unload matlab
echo

echo "Loading module openmpi/gnu"
module load openmpi/gnu
echo

echo "Loading module mcr"
module load mcr
echo

echo "Starting MPI job on node "`hostname`
ncpus=`cat /proc/cpuinfo | grep processor | wc -l`
((nprocs=2))
echo

echo "I detected that "`hostname`" has "$ncpus" processors. I'll start "$nprocs" processes."
echo

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

echo "Result of 'ldd matlabprog' is:"
ldd matlabprog
echo

echo "Result of 'ldd libmmpi.so' is:"
ldd libmmpi.so
echo

echo "The current LD_LIBRARY_PATH is:"
echo $LD_LIBRARY_PATH
echo

module list

if [ -d "$TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI" ]; then
    echo "Directory "$TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI" already exists...emptying contents."
    rm -rf "$TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI"
    echo
fi
echo "Making directory: $TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI"
mkdir "$TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI"
echo

echo "Setting MCR_CACHE_ROOT to: $TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI"
export MCR_CACHE_ROOT="$TMPDIR/mmsoda_Z9S7-SVFU-JJPX-WLBI"
echo

echo "The current MCR_CACHE_ROOT is:"
echo $MCR_CACHE_ROOT
echo

echo "Starting MPI run"
echo

mpirun -n $nprocs ./matlabprog -v 0 -b 500000 -t