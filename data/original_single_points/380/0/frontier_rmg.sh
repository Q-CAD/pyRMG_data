#!/bin/bash
#
# Change to your account
# Also change in the srun command below
#SBATCH -A MAT201
#
# Job naming stuff
#SBATCH -J rmg_input
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#
# Requested time
#SBATCH -t 02:00:00
#
# Requested queue
#SBATCH -p batch
#SBATCH -q debug
#
# Number of frontier nodes to use.
#SBATCH -N 126
#
# OMP num threads. Frontier reserves 8 of 64 cores on a node
# for the system. There are 8 logical GPUs per node so we use
# 8 MPI tasks/node with 7 OMP threads per node
export OMP_NUM_THREADS=7
#
# RMG threads. Max of 7 same as for OMP_NUM_THREADS but in some
# cases running with fewer may yield better performance because
# of cache effects.
export RMG_NUM_THREADS=5
#
# Don't change these
export MPICH_OFI_NIC_POLICY=NUMA
export MPICH_GPU_SUPPORT_ENABLED=0
#
# Load modules

module load PrgEnv-gnu/8.5.0
module load Core/24.00
module load cmake
module load bzip2/1.0.8
module load boost/1.85.0
module load craype-x86-milan
module load cray-fftw
module load cray-hdf5-parallel
module load craype-accel-amd-gfx90a
module load rocm/6.0.0
module load libfabric/1.15.2.0 # Reload previous libfabric

# Set variables
RMG_BINARY=/lustre/orion/mat201/world-shared/rjmorelock/rmgdft/build-frontier-gpu/rmg-gpu
NNODES=126
GPUS_PER_NODE=8

srun -A MAT201 --ntasks=$(($GPUS_PER_NODE * $NNODES)) -u -c7 --gpus-per-node=$GPUS_PER_NODE  --ntasks-per-gpu=1 --gpu-bind=closest $RMG_BINARY rmg_input

