# Dockerfile that will build an arm32v7 image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberrypi3:stretch

### Run commands within QEMU ARM cross-build emulation ---------------------------------
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget multiarch-support && \
    wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb && \
    dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb && \
    wget https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-arm && \
    wget https://raw.githubusercontent.com/pwt/docker-airconnect-arm/master/bin/airupnp-arm-modified && \
    chmod +x airupnp-arm && \
    chmod +x airupnp-arm-modified

# setconfig.sh and setoptions.sh dynamically create the config.xml and options.txt files,
# using environment variables (if present) to override defaults.
# setbinary determines whicn binary to use.
ADD ./setconfig.sh setconfig.sh
ADD ./setoptions.sh setoptions.sh
ADD ./setbinary.sh setbinary.sh
RUN chmod +x setconfig.sh setoptions.sh setbinary.sh

RUN [ "cross-build-end" ]
### End QEMU ARM emulation -------------------------------------------------------------

# First, dynamically generate the config.xml and options.txt files,
# then run either airupnp-arm or airupnp-arm-modified depending on whether
# SUPPRESS_FLUSH is set
CMD ./setconfig.sh > config.xml ; \
    ./setoptions.sh > options.txt ; \
    ./$(./setbinary.sh) -Z -x config.xml $(cat options.txt)
