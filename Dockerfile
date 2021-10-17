# Dockerfile that will build an ARM image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberry-pi-alpine:3.11

### Run commands within QEMU ARM cross-build emulation ---------------------------------
RUN [ "cross-build-start" ]

RUN install_packages wget

RUN wget https://github.com/philippe44/AirConnect/raw/0.2.51.1/bin/airupnp-arm-static && \
    wget https://github.com/philippe44/AirConnect/raw/0.2.51.1/bin/aircast-arm-static && \
    chmod +x airupnp-arm-static && \
    chmod +x aircast-arm-static

# setconfig.sh and setoptions.sh dynamically create the config.xml and options.txt files,
# using environment variables (if present) to override defaults.
ADD ./setconfig.sh setconfig.sh
ADD ./setoptions.sh setoptions.sh
ADD ./run_aircast.sh run_aircast.sh
ADD ./setconfig_aircast.sh setconfig_aircast.sh
ADD ./setoptions_aircast.sh setoptions_aircast.sh
RUN chmod +x setconfig.sh setoptions.sh run_aircast.sh setconfig_aircast.sh \
             setoptions_aircast.sh

# Run container as non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN [ "cross-build-end" ]
### End QEMU ARM emulation -------------------------------------------------------------

USER appuser

# 'run_aircast.sh` will run aircast-arm daemonised if
#    INCLUDE_AIRCAST is set.

CMD ./run_aircast.sh ; \
    ./setconfig.sh > ~/config.xml ; \
    ./setoptions.sh > ~/options.txt ; \
    ./airupnp-arm-static -Z -x ~/config.xml $(cat ~/options.txt)
