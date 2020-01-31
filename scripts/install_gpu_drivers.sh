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
  # run_name=NVIDIA-Linux-${driver_version}.run
  # sudo wget http://us.download.nvidia.com/tesla/${version}/${run_name}
  # chmod +x ${run_name}
  # ./${run_name} -a -s
  deb_name=http://us.download.nvidia.com/tesla/${version}/nvidia-driver-local-repo-${distro}-${version}_1.0-1_${arch}.deb
  wget ${deb_name}
  dpkg -i nvidia-driver-local-repo-${distro}-${version}.*.deb
  apt-get -o Dpkg::Use-Pty=0 update -qq  || echo " RC${?} Got an error on update???"
  apt-get -o Dpkg::Use-Pty=0 install -qq nvidia-driver-418
  # Purge the repo
  dpkg -P `dpkg -l | grep nvidia-driver-local-repo-ubuntu | cut -d " " -f 3`
  apt-get clean -y
  rm nvidia-driver-local-repo-${distro}-${version}.*.deb
  systemctl daemon-reload
  systemctl enable nvidia-persistenced
  nvidia-smi
  # apt-get -o Dpkg::Use-Pty=0 remove -qq gcc make
else
  echo "Nvidia drivers installed on machine already. Skipping install of drivers."
fi

systemctl is-active nvidia-persistenced || systemctl enable nvidia-persistenced
