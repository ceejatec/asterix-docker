# Docker container for AsterixDB (http://asterixdb.ics.uci.edu/).

# See https://github.com/ceejatec/naked-docker/ for details about the
# construction of the base image.

FROM ceejatec/naked-ubuntu:12.04
MAINTAINER chillery@lambda.nu

USER root

# JDK.
RUN apt-get update && \
    apt-get install -y openjdk-7-jre-headless && \
    rm -f /var/cache/apt/archives/*.deb

# Create "asterix" user with password-less sudo privs.
RUN useradd asterix -G sudo -m -s /bin/bash && \
    echo 'asterix:asterix' | chpasswd && \
    sed -ri 's/ALL\) ALL/ALL) NOPASSWD:ALL/' /etc/sudoers

# Copy Asterix application.
COPY build /asterix/

