FROM docker-hub.battle.net/cloud/centos:7 as d2-legacy-base

ARG username
ARG uid
ARG gid

RUN groupadd -g $gid $username && \
    useradd -l $username -u $uid -g $gid -m -s /bin/bash
