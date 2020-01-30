#!/bin/bash -xe
# Install NVIDIA Driver
modinfo nvidia && which nvidia-smi
has_gpu_driver=$?

if [ $has_gpu_driver -ne 0 ]; then
  # Install Nvidia
  apt-get -o Dpkg::Use-Pty=0 update -qq  || echo " RC${?} Got an error on update???"
  # make and gcc required for Nvidia driver install
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
  systemctl daemon-reload
  nvidia-smi
  # apt-get -o Dpkg::Use-Pty=0 remove -qq gcc make
else
  echo "Nvidia drivers installed on machine already. Skipping install of drivers."
fi

systemctl is-active --quiet nvidia-persistenced

if [ $? -ne 0 ]; then
  echo "Enabling nvidia-persistenced"
  systemctl enable nvidia-persistenced
fi
