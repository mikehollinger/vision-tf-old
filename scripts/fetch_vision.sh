#!/bin/bash -e
# Copyright 2019. IBM All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BASEDIR="$(dirname "$0")"
# shellcheck disable=SC2034
# shellcheck disable=SC2034
# shellcheck disable=SC1090
source ${BASEDIR}/env.sh
echo "Installing aria2..."
apt-get -o Dpkg::Use-Pty=0 update -qq  || echo " RC${?} Got an error on update???"
apt-get -o Dpkg::Use-Pty=0 install -qq aria2
echo "Downloading to ${RAMDISK}..."
pushd $RAMDISK
echo "Fetching  image tarball..."
#Use xargs to pass the stdout of the signing script to aria2c as an arugment
python3 $BASEDIR/sign.py --url $URLPAIVIMAGES | xargs -t aria2c -q -s160 -x16 $URLPAIVIMAGES
echo "Fetching deb"
python3 $BASEDIR/sign.py --url $URLPAIVDEB | xargs -t aria2c -q $URLPAIVDEB
echo "Uninstalling aria2"
apt-get -o Dpkg::Use-Pty=0 remove -qq aria2
echo "SUCCESS: Installation media downloaded successfully!"
popd
