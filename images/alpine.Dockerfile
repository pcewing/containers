FROM alpine:latest

# The --no-cache option for apk ensures that it always updates first and
# doesn't write anything to /var/cache/apk/ so no cleanup is necessary

# Upgrade base packages
RUN apk upgrade --no-cache

# Install packages
# - shadow 
#   - Necessary to use groupadd/useradd below which are important beause the
#     built-in addgroup/adduser utilities in Alpine don't support high values
#     for user/group IDs
# - bash
#   - Necessary because alpine only ships with sh by default
#
RUN apk add --no-cache shadow bash

ARG username
ARG uid
ARG gid

RUN /usr/sbin/groupadd -g $gid $username && \
    /usr/sbin/useradd -l $username -u $uid -g $gid -m -s /bin/bash
