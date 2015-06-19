# Docker container for Asterix CC

FROM ceejatec/asterix-base:latest
MAINTAINER chillery@lambda.nu

# Create /cc and grant ownership to asterix
RUN mkdir /cc && chown asterix:asterix /cc

# Set up the entrypoint
USER asterix
WORKDIR /cc
ENTRYPOINT [ "/asterix/asterix-startup.sh", "cc" ]
EXPOSE 19000 19001 19002
