# Dockerfile that will build an arm32v7 image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberrypi3:stretch

### Run commands within QEMU ARM cross-build emulation ---------------------------------
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget multiarch-support && \
#   wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb && \
#   dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_armhf.deb && \
#   wget https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/airupnp-arm && \
#   Temporarily pin to v0.2.28.1 ##########################
    wget https://github.com/philippe44/AirConnect/raw/6fc84b42f16d65b8e0c2c61e0f9e7ffd781c638c/bin/airupnp-arm && \
    wget https://raw.githubusercontent.com/pwt/docker-airconnect-arm/master/bin/airupnp-arm-modified && \
    chmod +x airupnp-arm && \
    chmod +x airupnp-arm-modified && \
#   wget https://raw.githubusercontent.com/philippe44/AirConnect/master/bin/aircast-arm && \
    wget https://github.com/philippe44/AirConnect/raw/6fc84b42f16d65b8e0c2c61e0f9e7ffd781c638c/bin/aircast-arm && \
    chmod +x aircast-arm

# setconfig.sh and setoptions.sh dynamically create the config.xml and options.txt files,
# using environment variables (if present) to override defaults.
# setbinary determines whicn binary to use.
ADD ./setconfig.sh setconfig.sh
ADD ./setoptions.sh setoptions.sh
ADD ./setbinary.sh setbinary.sh
ADD ./run_aircast.sh run_aircast.sh
ADD ./setconfig_aircast.sh setconfig_aircast.sh
RUN chmod +x setconfig.sh setoptions.sh setbinary.sh run_aircast.sh setconfig_aircast.sh

RUN [ "cross-build-end" ]
### End QEMU ARM emulation -------------------------------------------------------------


# 'run_aircast.sh` will run aircast-arm daemonised if 
#    INCLUDE_AIRCAST is set.

# Dynamically generate the config.xml and options.txt files,
# then run either airupnp-arm or airupnp-arm-modified depending on whether
# SUPPRESS_FLUSH is set

CMD ./run_aircast.sh ; \
    ./setconfig.sh > config.xml ; \
    ./setoptions.sh > options.txt ; \
    ./$(./setbinary.sh) -Z -x config.xml $(cat options.txt)
