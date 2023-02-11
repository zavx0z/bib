#!/bin/bash
service ssh start

# rewrite Preferences google-chrome
python /google-preferences/PreferencesHandler.py --config="${HOME}"/chrome/config.yml

USER_DATA_DIR="${HOME}/.config/google-chrome"
find "${USER_DATA_DIR}" -name Singleton\* -exec rm {} \;
chown -R "${USER}:${USER}" "${USER_DATA_DIR}"

#mkdir "${USER_DATA_DIR}" &&
#  chown -R "${USER}:${USER}" "${USER_DATA_DIR}" &&
#  git clone -b "${GOOGLE_USER}" "https://zavx0z:${BITBUCKET_PASSWORD}@bitbucket.org/zavx0z/user_data_dir.git" "${USER_DATA_DIR}" &&
#  echo "clone ${GOOGLE_USER}" || find "${USER_DATA_DIR}" -name Singleton\* -exec rm {} \; &&
#  echo "remove Singleton files"
#
#pip install -U simulant
pip install -r "${HOME}/simulant/requirements_dev.txt"
