# Ubuntu latest is the current LTS
FROM ubuntu:latest
# You should update this to the latest from https://github.com/genuinetools/img/releases
ENV IMG_VERSION v0.5.11

USER root
RUN apt-get update && apt-get -y install wget uidmap unzip && wget https://github.com/genuinetools/img/releases/download/${IMG_VERSION}/img-linux-amd64 -O /usr/local/bin/img && chmod 555 /usr/local/bin/img

