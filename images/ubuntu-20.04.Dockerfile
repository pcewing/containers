FROM ubuntu:20.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install \
        sudo

ARG username
ARG uid
ARG gid

# Add a non-root user and give them permission to run certain commands via sudo
# without providing a password
RUN groupadd -g $gid $username && \
    useradd -l $username -u $uid -g $gid -m -s /bin/bash && \
    echo "$username ALL = NOPASSWD: /usr/bin/apt-get,/usr/bin/apt" >> /etc/sudoers
