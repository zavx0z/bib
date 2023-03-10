#!/bin/bash
# rewrite Preferences google-chrome
python3 /google-preferences/PreferencesHandler.py --config="${HOME}"/.config/chrome_config.yml
USER_DATA_DIR="${HOME}/.config/google-chrome"
find "${USER_DATA_DIR}" -name Singleton\* -exec rm {} \;
chown -R "${USER}:${USER}" "${USER_DATA_DIR}"
