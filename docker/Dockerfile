################################################################################
# base system
################################################################################
FROM ubuntu:20.04 as system
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Moscow
ENV DISPLAY :1
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends --allow-unauthenticated \
    apt-utils \
    sudo \
    supervisor \
    nginx \
    openbox \
    xvfb \
    x11vnc \
    alsa-utils \
    mesa-utils \
    curl \
    net-tools \
    xz-utils \
    dbus-x11 \
    x11-utils \
    xclip \
    wget \
    git \
    vim-tiny \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    python3-tk \
    gcc \
    make \
    cmake

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
RUN wget https://github.com/krallin/tini/archive/v0.19.0.tar.gz \
 && tar zxf v0.19.0.tar.gz \
 && export CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"; \
    cd tini-0.19.0; cmake . && make && make install \
 && cd ..; rm -r tini-0.19.0 v0.19.0.tar.gz

# Google-Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb && rm -f google-chrome-stable_current_amd64.deb

COPY rootfs /

# chrome configurator
RUN git clone "https://github.com/zavx0z/google-preferences.git" && pip3 install -r google-preferences/requirements.txt

# backend
COPY signal/requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
COPY signal/main.py /usr/local/lib/web/

#clean
RUN apt-get autoclean -y  \
    && apt-get autoremove -y  \
    && rm -rf /var/lib/apt/lists/* &&  \
    rm -rf /tmp/*
################################################################################
# builder
################################################################################
FROM ubuntu:20.04 as builder
RUN apt-get update && apt-get install -y --no-install-recommends  \
    curl  \
    ca-certificates  \
    gnupg  \
    patch  \
    sudo
# nodejs yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn
# build frontend
COPY screen_share /src/web
RUN cd /src/web \
    && yarn upgrade \
    && yarn \
    && yarn build
# clean
RUN apt-get autoremove && apt-get autoclean
################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="zavx0z"

COPY --from=builder /src/web/build/ /usr/local/lib/web/build/

ENV HOME=/home/ubuntu SHELL=/bin/bash
EXPOSE 4444 5900 8080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]