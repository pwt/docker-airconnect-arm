# Dockerfile that will build an arm32v7 image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberrypi3

### Run commands within QEMU ARM cross-build emulation
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget multiarch-support && \
    wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u11_armhf.deb && \
    dpkg -i libssl1.0.0_1.0.1t-1+deb8u11_armhf.deb && \
#   Hold AirConnect at v0.2.12.0    
    wget https://raw.githubusercontent.com/philippe44/AirConnect/f170e077143ccdb5cefd99b2c25fcbf8925271c5/bin/airupnp-arm && \
#   wget https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-arm && \
    chmod +x airupnp-arm

# setconfig.sh dynamically creates the config.xml file, using environment variables
# (if present) to override defaults
ADD ./setconfig.sh setconfig.sh
RUN chmod +x setconfig.sh

RUN [ "cross-build-end" ]
### End QEMU ARM emulation

# Note: Exclude the Sonos players that support AirPlay 2 natively
# S6 = Play:5 gen 2
# S16 = Sonos Amp (new model)
CMD ./setconfig.sh > config.xml ; \
    ./airupnp-arm -x config.xml -Z -m PLAYBASE,BEAM,One -n S6,S16 
