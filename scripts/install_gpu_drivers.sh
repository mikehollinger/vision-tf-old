#!/bin/bash -xe
# Install NVIDIA Driver
modinfo nvidia && which nvidia-smi
has_gpu_driver=$?
if [ $has_gpu_driver -ne 0 ]; then
  echo "Installing Nvidia drivers."
  arch='ppc64le'
  version='418.116.00'
  driver_version=${arch}-${version}
  run_name=NVIDIA-Linux-${driver_version}.run
  sudo wget http://us.download.nvidia.com/tesla/${version}/${run_name}
  chmod +x ${run_name}
  ./${run_name} -a -s
  nvidia-smi
else
  echo "Nvidia drivers installed on machine already. Skipping install of drivers."
fi
