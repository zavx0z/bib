#!/bin/sh
# Ubuntu 20.04LTS headless noVNC
# Connect to http://localhost:6080/
REPO=zavx0z/
IMAGE=bib
TAG=noVNC

if [ -z "$SUDO_UID" ]; then
  # not in sudo
  USER_ID=$(id -u)
  USER_NAME=$(id -n -u)
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi
docker run --detach \
  --shm-size=512mb \
  --publish 6080:80 \
  --publish 4444:4444 \
  --publish 5900:5900 \
  --publish 5901:5901 \
  --publish 8080:8080 \
  --volume /home/zavx0z/projects/no_vnc_api/:/home/"${USER_NAME}"/no_vnc_api:rw \
  --env USERNAME="${USER_NAME}" --env USERID="${USER_ID}" --env PASSWORD=uxusesus \
  --name ${IMAGE} \
  --privileged \
  ${REPO}${IMAGE}:${TAG}
#  --volume "${PWD}"/../browser_store:/home/"${USER_NAME}"/.config/google-chrome:rw \
#  --env GOOGLE_USER=metaversebdfl \
#  --env BITBUCKET_PASSWORD=ATBBQDTYaAMPtgkvNKfnpA3w44v4534B7C4F \
