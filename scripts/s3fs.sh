#!/bin/bash -e
BASEDIR="$(dirname "$0")"
# shellcheck disable=SC1090
source ${BASEDIR}/env.sh

# Install s3fs- allowing us to present a COS bucket as a File System in User Space (FUSE).
echo "Installing s3fs..."
sudo apt install s3fs

# Store your COS credentials to authenticate later.
echo ${ACCESS_KEY_ID}:${SECRET_ACCESS_KEY} > ${BASEDIR}/.passwd-s3fs
chmod 600 ${BASEDIR}/.passwd-s3fs

# Need to get a copy over existing data from PAIV to the COS bucket.
# Create a temporary mount, copy the data across, and then unmount.
# mkdir ${BASEDIR}/temp/
# chmod 755 ${BASEDIR}/temp/
# s3fs ${BUCKET_NAME} ${BASEDIR}/temp/ -o url=http://${PUBLIC_ENDPOINT} -o passwd_file=${BASEDIR}/.passwd-s3fs
# echo "Copying existing files to COS..."
# cp -r /opt/powerai-vision/volume/data/ ${BASEDIR}/temp/
# umount ${BASEDIR}/temp/
#fusermount -uz ./temp/

# Now that we have a backup of existing files, we can overwrite and mount at the point where
# PAIV will save logs and user data.
echo "Mounting at /opt/powerai-vision/volume/data/"
mkdir /opt/powerai-vision/volume/data/ -p 
s3fs ${BUCKET_NAME} /opt/powerai-vision/volume/data/ -o url=http://${PUBLIC_ENDPOINT} -o passwd_file=${BASEDIR}/.passwd-s3fs -o nonempty

# Cleanup
echo "Cleanup..."
rm ${BASEDIR}/.passwd-s3fs
