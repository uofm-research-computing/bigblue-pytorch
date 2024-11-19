#!/bin/bash
#SBATCH -c 12
#SBATCH --mem=12G
#SBATCH -p agpuq
#SBATCH -t 00:10:00
#SBATCH --gres=gpu:1

module load singularity

singularity exec --cleanenv --nv --bind /project:/project --bind /scratch:/scratch pytorch.sif python3 pytorchTest.py
