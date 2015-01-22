# Docker container for Asterix CC

FROM ceejatec/centos-63-asterix:latest
MAINTAINER chillery@lambda.nu

ENTRYPOINT [ "/asterix/asterix_cc_startup.sh" ]

RUN yum -y install unzip

COPY asterix-installer-0.8.7-SNAPSHOT-binary-assembly.zip /asterix/
COPY asterix_cc_startup.sh /asterix/
COPY asterix_joe_startup.sh /asterix/
