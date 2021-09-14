# Ubuntu 20.04 vm, full install
# user: student
# passwd: student

# install virtualbox guest additions
# (via context menu)

# install required programs (R, Python, curl, git, docker, ripgrep, ...) and dependencies for R libraries
sudo apt install \
     curl \
     git \
     cargo \
     libssl-dev \
     libcurl4-openssl-dev \
     libfreetype6-dev \
     libpoppler-cpp-dev \
     libxml2-dev \
     libgit2-dev \
     libgsl-dev \
     libgit2-dev \
     librsvg2-dev \
     libharfbuzz-dev \
     libfribidi-dev \
     libfreetype6-dev \
     libpng-dev \
     libtiff5-dev \
     libudunits2-dev \
     libjpeg-dev \
     libmagick++-dev \
     ripgrep \
     fd-find \
     xcape \
     r-base \
     firefox \
     vim-gtk3 \
     docker.io \
     python3 \
     python3-pip \
     gnome-tweaks \
     gdebi-core

sudo apt clean

# install jupyter notebooks via python's pip package manager
pip3 install jupyterlab notebook

# alternative: anaconda (simpler to use system python, pip and pipenv)
# https://docs.conda.io/en/latest/miniconda.html#linux-installers

git clone https://github.com/hliebert/course-unstructured-data ~/Desktop

# install R packages
Rscript ~/Desktop/course-unstructured-data/PC-lab-1/install.R

# install Rstudio
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.1073-amd64.deb
sudo gdebi rstudio-server-1.3.1073-amd64.deb

# install miniconda (if not already installed)
# https://docs.conda.io/en/latest/miniconda.html
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh --remote-name
sha256sum Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh

# install vscode (editor)
sudo snap install --classic code

# alternative editor: emacs + pre-set config
# git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
# ~/.emacs.d/bin/doom install
