################################################################################
# base system
################################################################################

FROM ubuntu:20.04 as system

#RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

# Avoid prompts for time zone
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Moscow
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

# built-in packages
RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils -y \
    && apt-get install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor nginx sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils xclip alsa-utils \
        mesa-utils libgl1-mesa-dri wget git

# install debs error if combine together
RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated xvfb x11vnc vim-tiny ttf-ubuntu-font-family ttf-wqy-zenhei

# Alternative VNC server
# RUN apt-get install -y tigervnc-scraping-server

# RUN apt-get update \
#     && apt-get install -y gpg-agent \
#     && curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
#     && (dpkg -i ./google-chrome-stable_current_amd64.deb || apt-get install -fy) \
#     && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add \
#     && rm google-chrome-stable_current_amd64.deb \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme xdotool


RUN apt-get update && apt-get install -y python3 python3-tk gcc make cmake tesseract-ocr

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
RUN wget https://github.com/krallin/tini/archive/v0.19.0.tar.gz \
 && tar zxf v0.19.0.tar.gz \
 && export CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"; \
    cd tini-0.19.0; cmake . && make && make install \
 && cd ..; rm -r tini-0.19.0 v0.19.0.tar.gz

# ffmpeg
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends --allow-unauthenticated \
#         ffmpeg \
#     && rm -rf /var/lib/apt/lists/* \
#     && mkdir /usr/local/ffmpeg \
#     && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

# Google-Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb && rm -f google-chrome-stable_current_amd64.deb

# Killsession app
COPY killsession/ /tmp/killsession
RUN cd /tmp/killsession; \
    gcc -o killsession killsession.c && \
    mv killsession /usr/local/bin && \
    chmod a=rx /usr/local/bin/killsession && \
    chmod a+s /usr/local/bin/killsession && \
    mv killsession.py /usr/local/bin/ && chmod a+x /usr/local/bin/killsession.py && \
    mkdir -p /usr/local/share/pixmaps && mv killsession.png /usr/local/share/pixmaps/ && \
    mv KillSession.desktop /usr/share/applications/ && chmod a+x /usr/share/applications/KillSession.desktop && \
    cd /tmp && rm -r killsession


# python
RUN apt-get update \
    && apt-get install -y python3-pip python3-dev build-essential \
    && pip3 install setuptools wheel

# bot librarys
COPY rootfs/requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

# python library novnc
COPY rootfs/usr/local/lib/web/backend/requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt \
    && ln -s /usr/bin/python3 /usr/local/bin/python

#clean
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# builder
################################################################################
FROM ubuntu:20.04 as builder

#RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg patch

# nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# build frontend
COPY web /src/web
RUN cd /src/web \
    && yarn upgrade \
    && yarn \
    && yarn build
RUN sed -i 's#app/locale/#novnc/app/locale/#' /src/web/dist/static/novnc/app/ui.js

RUN apt-get autoremove && apt-get autoclean

################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="zavx0z"

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY rootfs /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && chmod +x /usr/local/lib/web/frontend/static/websockify/run

RUN apt-get update && apt-get install -y openssh-server vim

# chrome configurator
RUN git clone "https://github.com/zavx0z/google-preferences.git" && pip install -r google-preferences/requirements.txt

EXPOSE 80 22 4444
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]
