# Introduction
Installing pytorch on bigblue isn't too difficult, but the default install pulls different GPU libraries. This is great if everything is compatible, but terrible when they aren't compatible. Also, given the large dependency list, it is preferable to install it in /project instead of /home. To make this easier, we will use a python virtual environment.

# Installation
Installation doesn't need to occur on a GPU node specifically. BigBlue's login nodes are capable of compiling or pulling any GPU library. To pull this project, run:
```
git clone https://github.com/uofm-research-computing/bigblue-pytorch.git
```

There are three installation options listed below.

## 1. PIP installation
To install via pip, just run:
```
module load python/3.10.13/gcc.8.5.0
python3 -m venv /project/$USER/pytorchEnv
source /project/$USER/tensorTorch/bin/activate
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```

To use the environment properly, make sure you run the following or add it to your submission scripts:
```
module load python/3.10.13/gcc.8.5.0
source /project/$USER/pytorchEnv/bin/activate
```

If you load the environment, you can also install jupyter notebook or any other library with `pip3 install package`.

Try out the submission script provided to see if it works:
```
sbatch pytorchTest.sh
```

### After installation
Run the following to clean up:
```
pip3 cache purge
```

## 2. With tensorflow
Since BigBlue is using the CUDA 12.3 driver, you'll have to install both tensorflow and pytorch without including GPU libraries. This script can be run on the login node:
```
bash install_from_source.sh
```

Get some coffee. It takes about 30 minutes to compile, maybe a little longer.

### After installation
Run the following to clean up:
```
pip3 cache purge
```

## 3. Container installation
Run the following to build the "sif" container using singularity:
```
module load singularity
singularity build --fakeroot pytorch.sif pytorch.def # Don't need "--fakeroot" on itiger cluster
```

Try the batch job with:
```
sbatch pytorchContainer.sh
```

### After installation
Run:
```
singularity cache clean
```

# Problems

## No GPU?
You are probably running it on the login node. Please don't do that. If you want to run a non-jupyter notebook interactive job, please run the following:
```
module load python/3.10.13/gcc.8.5.0 # add "cuda" and "gnu9/9.4.0" when using the source installation
source /project/$USER/pytorchEnv/bin/activate
srun -c 12 -p igpuq --mem=12G -t 01:00:00 --gres=gpu:1 --pty python3
```

## Trouble with PTAX or other random issues
You might have a version of CUDA installed in your main python library folder under `/home/$USER/.local/`. You will need to selectively prune this with `pip3 list installed`, locating the libraries, and removing them one by one with `pip3 uninstall packageName`.

If you're frustrated and just want to start over, run the following to reset your main python directory (WARNING: this will likely remove almost everything else you've installed!):
```
pip3 cache purge
rm -rf ~/.local
exit
```

Then login and rerun your installation of the virtual environment.

## Other environments
If you have more than one python environment loaded through other means, you probably want to unload that environment before installing or loading this one. Also, make sure `~/.bashrc` isn't referencing any other versions of python or loading that environment. After doing that, logout and login again.

# Citations and other reading material
[pytorch installation guide](https://pytorch.org/get-started/locally/)

[pytorch github](https://github.com/pytorch/pytorch)

[pytorch vision](https://github.com/pytorch/vision)

[pytorch audio](https://github.com/pytorch/audio)

[pytorch CUDA compatibility](https://github.com/pytorch/pytorch/blob/main/RELEASE.md#release-compatibility-matrix)

[tensorflow CUDA compatibility](https://www.tensorflow.org/install/source#linux)

[pytorch container](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch) Note: check the "tags" if you run into compatibility issues
