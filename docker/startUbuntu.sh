#!/bin/sh
# Ubuntu 20.04LTS headless noVNC
# Connect to http://localhost:6080/
REPO=zavx0z/
IMAGE=bib
TAG=0.0.1

if [ -z "$SUDO_UID" ]
then
  # not in sudo
  USER_ID=`id -u`
  USER_NAME=`id -n -u`
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi

#  --volume "${PWD}":/workspace:rw \
docker run --rm --detach \
  --shm-size=512mb \
  --publish 6080:80 \
  --publish 5900:5900 \
  --volume /home/zavx0z/projects/nnm/browser_store:/home/zavx0z/google:rw \
  --env USERNAME=${USER_NAME} --env USERID=${USER_ID} --env PASSWORD=uxusesus\
  --env RESOLUTION=1920x1080 \
  --name ${IMAGE} \
  --privileged \
  ${REPO}${IMAGE}:${TAG}