#!/bin/bash
find /home/"$USER"/.config/google-chrome -name Singleton\* -exec rm {} \; # удалить блокирующие файлы для chrome
touch /home/"$USER"/.Xauthority                                           # для подключения дисплея
service ssh start
