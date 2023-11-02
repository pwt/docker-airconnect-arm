# Dockerfile that will build an ARM image on an x86 build host
# Remove the 'cross-buld' commands to build on a native ARM host

# Balena base image required for cross-build capabilities
FROM balenalib/raspberry-pi-alpine:3.18

### Run commands within QEMU ARM cross-build emulation, if required  ###########
# RUN [ "cross-build-start" ]

# RUN install_packages wget
RUN apk update && apk -U upgrade && apk add --no-cache wget unzip

RUN wget https://github.com/philippe44/AirConnect/releases/download/1.3.0/AirConnect-1.3.0.zip && \
    unzip AirConnect-1.3.0.zip airupnp-linux-armv6-static aircast-linux-armv6-static && \
    rm AirConnect-1.3.0.zip && \
    chmod +x airupnp-linux-armv6-static && \
    chmod +x aircast-linux-armv6-static

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

# RUN [ "cross-build-end" ]
### End QEMU ARM emulation  ####################################################

USER appuser

# 'run_aircast.sh` will run aircast-arm daemonised if
#    INCLUDE_AIRCAST is set.

CMD ./run_aircast.sh ; \
    ./setconfig.sh > ~/config.xml ; \
    ./setoptions.sh > ~/options.txt ; \
    ./airupnp-linux-armv6-static -Z -x ~/config.xml $(cat ~/options.txt)
