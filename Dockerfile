FROM debian:stretch-slim
ENV DISPLAY=:1
ARG VNC_PASSWORD=secret
ENV VNC_PASSWORD ${VNC_PASSWORD}
RUN dpkg --add-architecture i386

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    wget \
    gnupg2 \
    apt-transport-https \
    ca-certificates  \
    x11vnc \
    xorg \
    xvfb \
    openbox \
    menu \
    && rm -rf /var/lib/apt/lists/*

RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key

RUN touch /etc/apt/sources.list.d/wine.list && echo "deb https://dl.winehq.org/wine-builds/debian/ stretch main" >> /etc/apt/sources.list.d/wine.list

RUN apt-get update && apt-get install --no-install-recommends -y winehq-stable && rm -rf /var/lib/apt/lists/*

CMD Xvfb :1 -screen 0 1024x768x16 \
    & openbox-session \
    & x11vnc -display :1 -xkb -forever -passwd $VNC_PASSWORD
EXPOSE 5900