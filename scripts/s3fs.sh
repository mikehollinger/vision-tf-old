#!/bin/bash -e
BASEDIR="$(dirname "$0")"
ACCESS_KEY_ID=0cb039eb6290492a9f24e6ffec71c7d7
SECRET_ACCESS_KEY=1b2cda43f1a59b521bf521bd1ee7f84c80d1dd7ec9df44de
BUCKET_NAME=paiv-trial
PUBLIC_ENDPOINT=s3.us-south.cloud-object-storage.appdomain.cloud
# shellcheck disable=SC1090
source ${BASEDIR}/env.sh

sudo apt install s3fs
echo ${ACCESS_KEY_ID}:${SECRET_ACCESS_KEY} > ${BASEDIR}/.passwd-s3fs
chmod 600 .passwd-s3fs
s3fs ${BUCKET_NAME} ./test2/ -o url=http://${PUBLIC_ENDPOINT} -o passwd_file=${BASEDIR}/.passwd-s3fs
rm ${BASEDIR}/.passwd-s3fs