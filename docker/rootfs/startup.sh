#!/bin/bash

DISPLAY=:1
RESOLUTION="2920x1106"
echo "set display $DISPLAY"
sed -i -e "s|%DISPLAY%|$DISPLAY|" /etc/supervisor/conf.d/supervisord.conf

if [ -n "$VNC_PASSWORD" ]; then
  echo -n "$VNC_PASSWORD" >/.password1
  x11vnc -storepasswd $(cat /.password1) /.password2
  sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf
  chmod 400 /.password*
  export VNC_PASSWORD=
fi

if [ -n "$X11VNC_ARGS" ]; then
  sed -i "s/^command=x11vnc.*/& ${X11VNC_ARGS}/" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$OPENBOX_ARGS" ]; then
  sed -i "s#^command=/usr/bin/openbox.*#& ${OPENBOX_ARGS}#" /etc/supervisor/conf.d/supervisord.conf
fi

if [ -n "$RESOLUTION" ]; then
  sed -i "s/1920x1080/$RESOLUTION/" /usr/local/bin/xvfb.sh
fi

USER=${USERNAME:-root}

HOME=/root
if [ "$USER" != "root" ]; then
  echo "* enable custom user: $USER"
  if [ -z "$PASSWORD" ]; then
    echo "  set default password to \"ubuntu\""
    PASSWORD=ubuntu
  fi
  echo "  Password set to $PASSWORD"
  UIDOPT=""
  UIDVAL=""
  if [ -z "$USERID" ]; then
    echo "  user id in container may not match user id on host"
  else
    echo "  setting user id to $USERID"
    UIDOPT="--non-unique --uid"
    UIDVAL=$USERID
  fi
  useradd --create-home --skel /root --shell /bin/bash --user-group --groups adm,sudo $UIDOPT $UIDVAL $USER
  HOME=/home/$USER
  echo "$USER:$PASSWORD" | chpasswd
  cp -r /root/{.profile,.bashrc,.config} ${HOME}
  chown -R $USER:$USER ${HOME}
  [ -d "/dev/snd" ] && chgrp -R adm /dev/snd
fi

sed -i -e "s|%USER%|$USER|" -e "s|%HOME%|$HOME|" /etc/supervisor/conf.d/supervisord.conf

# nginx workers
sed -i 's|worker_processes .*|worker_processes 1;|' /etc/nginx/nginx.conf

# nginx ssl
if [ -n "$SSL_PORT" ] && [ -e "/etc/nginx/ssl/nginx.key" ]; then
  echo "* enable SSL"
  sed -i 's|#_SSL_PORT_#\(.*\)443\(.*\)|\1'$SSL_PORT'\2|' /etc/nginx/sites-enabled/default
  sed -i 's|#_SSL_PORT_#||' /etc/nginx/sites-enabled/default
fi

# nginx http base authentication
if [ -n "$HTTP_PASSWORD" ]; then
  echo "* enable HTTP base authentication"
  htpasswd -bc /etc/nginx/.htpasswd "$USER" "$HTTP_PASSWORD"
  sed -i 's|#_HTTP_PASSWORD_#||' /etc/nginx/sites-enabled/default
fi

# dynamic prefix path renaming
if [ -n "$RELATIVE_URL_ROOT" ]; then
  echo "* enable RELATIVE_URL_ROOT: $RELATIVE_URL_ROOT"
  sed -i 's|#_RELATIVE_URL_ROOT_||' /etc/nginx/sites-enabled/default
  sed -i 's|_RELATIVE_URL_ROOT_|'"$RELATIVE_URL_ROOT"'|' /etc/nginx/sites-enabled/default
fi

# Check for files in /etc/startup/ that should be sourced to customize the Docker image
for stsrc in /etc/startup/*.sh; do
  if [ -r "$stsrc" ]; then
    source "$stsrc"
  fi
done

# clearup
PASSWORD=
HTTP_PASSWORD=



exec /usr/local/bin/tini -- supervisord -n -c /etc/supervisor/supervisord.conf

