#!/bin/bash -xe
# Install NVIDIA Driver
modinfo nvidia && which nvidia-smi
has_gpu_driver=$?
if [ $has_gpu_driver -ne 0 ]; then
  # Install Nvidia
  apt-get -o Dpkg::Use-Pty=0 update -qq  || echo " RC${?} Got an error on update???"
  apt-get -o Dpkg::Use-Pty=0 install -qq build-essential
  echo "Installing Nvidia drivers."
  arch='ppc64le'
  distro="ubuntu1804"
  version='418.116.00'
  driver_version=${arch}-${version}
  run_name=NVIDIA-Linux-${driver_version}.run
  sudo wget http://us.download.nvidia.com/tesla/${version}/${run_name}
  chmod +x ${run_name}
  ./${run_name} -a -s
  nvidia-smi

  # Install CUDA
  apt-get install linux-headers-$(uname -r)
  dpkg -i cuda-repo-${distro}_${version}_${arch}.deb
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${distro}/${arch}/7fa2af80.pub
  apt-get update
  apt-get install cuda

  # apt-get -o Dpkg::Use-Pty=0 remove -qq gcc make
else
  echo "Nvidia drivers installed on machine already. Skipping install of drivers."
fi
