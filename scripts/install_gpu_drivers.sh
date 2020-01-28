#!/bin/bash -xe
# Install NVIDIA Driver
arch='ppc64le'
version='418.116.00'
driver_version=${arch}-${version}
run_name=NVIDIA-Linux-${driver_version}.run
sudo wget http://us.download.nvidia.com/tesla/${version}/${run_name}
chmod +x ${run_name}
./${run_name} -a -s
nvidia-smi
