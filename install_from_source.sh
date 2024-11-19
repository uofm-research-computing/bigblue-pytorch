#!/bin/bash

# Setup environment, you will need this "module load" and "source" line in any job script
module load cuda/12.3 python/3.10.13/gcc.8.5.0 gnu9/9.4.0
python3 -m venv /project/$USER/tensorTorch
source /project/$USER/tensorTorch/bin/activate

# pytorch and tensorflow installation
pip3 install --no-input typing_extensions pyyaml tensorflow==2.17.0 ninja
git clone https://github.com/pytorch/pytorch.git
cd pytorch/
git checkout v2.5.1
TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6+PTX" MAX_JOBS=12 python setup.py install
cd ..

# pytorch vision installation
git clone https://github.com/pytorch/vision.git
pip3 install --no-input expecttest flake8 typing mypy pytest pytest-mock scipy requests
cd vision
git checkout v0.20.1
TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6+PTX" MAX_JOBS=12 python setup.py install
cd ..

# pytorch audio installation, for some reason this needed the compiler specifically
git clone https://github.com/pytorch/audio
cd audio
git checkout v2.5.1
CXX=$(which g++) CC=$(which gcc) TORCH_CUDA_ARCH_LIST="7.0 7.5 8.0 8.6+PTX" MAX_JOBS=12 python setup.py install
cd ..

