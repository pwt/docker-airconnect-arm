# Dockerfile that will build an arm32v7 image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberrypi3:buster

### Run commands within QEMU ARM cross-build emulation ---------------------------------
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget multiarch-support && \
    wget https://github.com/philippe44/AirConnect/raw/0.2.51.1/bin/airupnp-arm && \
    wget https://github.com/philippe44/AirConnect/raw/0.2.51.1/bin/aircast-arm && \
    chmod +x airupnp-arm && \
    chmod +x aircast-arm

# setconfig.sh and setoptions.sh dynamically create the config.xml and options.txt files,
# using environment variables (if present) to override defaults.
ADD ./setconfig.sh setconfig.sh
ADD ./setoptions.sh setoptions.sh
ADD ./run_aircast.sh run_aircast.sh
ADD ./setconfig_aircast.sh setconfig_aircast.sh
RUN chmod +x setconfig.sh setoptions.sh run_aircast.sh setconfig_aircast.sh

RUN [ "cross-build-end" ]
### End QEMU ARM emulation -------------------------------------------------------------

# 'run_aircast.sh` will run aircast-arm daemonised if
#    INCLUDE_AIRCAST is set.

CMD ./run_aircast.sh ; \
    ./setconfig.sh > config.xml ; \
    ./setoptions.sh > options.txt ; \
    ./airupnp-arm -Z -x config.xml $(cat options.txt)
