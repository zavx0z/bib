#!/bin/sh
# Ubuntu 20.04LTS headless noVNC
# Connect to http://localhost:6080/
REPO=zavx0z/
IMAGE=bib
TAG=latest

if [ -z "$SUDO_UID" ]; then
  # not in sudo
  USER_ID=$(id -u)
  USER_NAME=$(id -n -u)
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi
docker run --rm --detach \
  --shm-size=512mb \
  --publish 6080:80 \
  --publish 5900:5900 \
  --volume "${PWD}"/../google-chrome:/home/"${USER_NAME}"/.config/google-chrome:rw \
  --volume "${PWD}"/../downloads:/home/"${USER_NAME}"/Downloads:rw \
  --volume /home/zavx0z/projects/chrome_bot/:/home/"${USER_NAME}"/chrome_bot:rw \
  --env USERNAME="${USER_NAME}" --env USERID="${USER_ID}" --env PASSWORD=uxusesus \
  --name ${IMAGE} \
  --privileged \
  ${REPO}${IMAGE}:${TAG}
#  --volume "${PWD}"/../browser_store:/home/"${USER_NAME}"/.config/google-chrome:rw \
#  --env GOOGLE_USER=metaversebdfl \
#  --env BITBUCKET_PASSWORD=ATBBQDTYaAMPtgkvNKfnpA3w44v4534B7C4F \
