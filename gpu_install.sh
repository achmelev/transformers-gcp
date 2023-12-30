#!/bin/sh

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install software-properties-common

#CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda-repo-ubuntu2204-12-2-local_12.2.2-535.104.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-2-local_12.2.2-535.104.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-2-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install cuda
cd $HOME
rm cuda-repo-ubuntu2204-12-2-local_12.2.2-535.104.05-1_amd64.deb
#Rest
sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install git
sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install python3-pip
sudo DEBIAN_FRONTEND=noninteractive  apt-get -y install python3-venv
mkdir $HOME/python
python3 -m venv $HOME/python
echo "PATH=$HOME/python/bin:\$PATH" >> .profile
$HOME/python/bin/pip install torch torchvision
mkdir transformers
cd transformers
git clone https://github.com/achmelev/pico-gpt.git

