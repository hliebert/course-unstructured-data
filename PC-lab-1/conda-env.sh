#!/usr/bin/env bash
set -euo pipefail

# create a project folder (not necessary for env but let's be tidy)
mkdir ~/myrproject
cd ~/myrproject

# install miniconda (if not already installed)
# https://docs.conda.io/en/latest/miniconda.html
# curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh --remote-name
# sha256sum Miniconda3-latest-Linux-x86_64.sh
# bash Miniconda3-latest-Linux-x86_64.sh
# rm Miniconda3-latest-Linux-x86_64.sh

# curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh --remote-name
# shasum -a 256 filename
# bash Miniconda3-latest-MacOSX-x86_64.sh
# rm Miniconda3-latest-MacOSX-x86_64.sh

# info about current environment and install
conda info

# help/man pages typically behind --help flag
conda --help
conda env --help

# list environments
conda env list

# create and remove test env
conda create --name testenv
conda env remove --name testenv

# current R version
R --version

# create new project environment and install r into it
conda create --name myrproject r-base=4.0

# activate it
conda activate myrproject

# check R version within project environment
R --version

# install devtools package
conda install r-devtools

# list currently installed packages
conda list

# list changes
conda list --revision

# pipe packages to file
conda list --explicit > list.txt

# export environment file
conda env export > environment.yml

# this is less explicit, less good for reproducibility but will work better across different OS
conda env export --from-history > environment.yml

# deactivate environment
conda deactivate

# and remove it again
conda env remove --name myrproject

# recreate it from a file (first line must contain name)
# conda env create --file environment.yml

# you can also edit the file and update your environment from there
# conda env update --file environment.yml  --prune

# or clone it
# conda create --name asimilarproject --clone myrproject


# setting up the environment for the course using the provided file
conda env create --file setup/environment.yml
conda env list
conda activate course-unstructured
