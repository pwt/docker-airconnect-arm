# Dockerfile that will build an arm32v7 image on an x86 build host

FROM resin/rpi-raspbian
# Resin base image required for cross-build capabilities

### Run commands within QEMU ARM cross-build emulation
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget && \
#   wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u10_armhf.deb && \
#   dpkg -i libssl1.0.0_1.0.1t-1+deb8u10_armhf.deb && \
    wget https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-arm && \
    chmod +x airupnp-arm

RUN [ "cross-build-end" ]
### End QEMU ARM emulation

# Pull in the config file
ADD ./config.xml /config.xml

# HEALTHCHECK --interval=1m --timeout=2s \
#  TBD

CMD /airupnp-arm -l 1000:2000
