#!/bin/sh
REPO="zavx0z/"
IMAGE="bib"
TAG="noVNC_0.0.3"

USER_ID=1000
USER_NAME="zavx0z"
PASSWORD="uxusesus"
docker run --detach --rm \
  --shm-size=512mb \
  --publish 4444:4444 \
  --publish 5900:5900 \
  --publish 5901:5901 \
  --publish 8080:8080 \
  --volume /home/zavx0z/projects/no_vnc_api/:/home/"${USER_NAME}"/no_vnc_api:rw \
  --env USERNAME="${USER_NAME}" --env USERID="${USER_ID}" --env PASSWORD="${PASSWORD}" \
  --name ${IMAGE} \
  --privileged \
  ${REPO}${IMAGE}:${TAG}
