#!/bin/sh
REPO="zavx0z/"
IMAGE="bib"
TAG="webRTC"

USER_ID=1000
USER_NAME="zavx0z"
PASSWORD="uxusesus"
docker run --detach \
  --shm-size=512mb \
  --publish 8088:80 \
  --publish 8080:8080 \
  --publish 5900:5900 \
  --env USERNAME="${USER_NAME}" --env USERID="${USER_ID}" --env PASSWORD="${PASSWORD}" \
  --name ${IMAGE} \
  --privileged \
  ${REPO}${IMAGE}:${TAG}


#  --volume /home/zavx0z/projects/no_vnc_api/:/home/"${USER_NAME}"/no_vnc_api:rw \#