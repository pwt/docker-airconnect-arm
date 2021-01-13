# Dockerfile that will build an arm32v7 image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberrypi3:stretch

### Run commands within QEMU ARM cross-build emulation ---------------------------------
RUN [ "cross-build-start" ]

RUN apt-get update && \
    apt-get install -y wget multiarch-support && \
#   wget https://github.com/philippe44/AirConnect/raw/0.2.43.0/bin/airupnp-arm && \
    wget https://github.com/philippe44/AirConnect/raw/9f1b0ef7e9882a034b5504136ea208c8ac6329ea/bin/airupnp-arm && \
    wget https://raw.githubusercontent.com/pwt/docker-airconnect-arm/master/bin/airupnp-arm-modified && \
#   wget https://github.com/philippe44/AirConnect/raw/0.2.43.0/bin/aircast-arm && \
    wget https://github.com/philippe44/AirConnect/raw/9f1b0ef7e9882a034b5504136ea208c8ac6329ea/bin/aircast-arm && \
    chmod +x airupnp-arm && \
    chmod +x airupnp-arm-modified && \
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
