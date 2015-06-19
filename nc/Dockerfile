# Docker container for Asterix NC

FROM ceejatec/asterix-base:latest
MAINTAINER chillery@lambda.nu

# Create /nc and grant ownership to asterix
RUN mkdir /nc && chown asterix:asterix /nc

# Set up the entrypoint
USER asterix
WORKDIR /home/asterix
ENTRYPOINT [ "/asterix/asterix-startup.sh", "nc" ]
# Expose ports for up to 5 NCs
EXPOSE 5001 5011 5021 5031 5002 5012 5022 5003 5013 5023 5004 5014 5024 5005 5015 5025
