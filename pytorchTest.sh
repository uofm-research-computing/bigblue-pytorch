#!/bin/bash
#SBATCH -c 12
#SBATCH --mem=12G
#SBATCH -p agpuq
#SBATCH -t 00:10:00
#SBATCH --gres=gpu:1

module load python/3.10.13/gcc.8.5.0
source /project/$USER/tensorTorch/bin/activate

python3 pytorchTest.py
