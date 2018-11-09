# Docker Container Build of *AirConnect* for Raspberry Pi

This Dockerfile builds a docker container version of the excellent AirConnect [1] utility, suitable for use on a Raspberry Pi.

In order to build for ARM on Docker Hub, the Dockerfile makes use of the *crossbuild* capabilities provided by the Resin Raspbian distribution [2], which allows ARM images to be build under x86. (If you want to use this Dockerfile to build directly on a native ARM device, comment out or delete the two `cross-build` RUN statements.) 

The docker image name is `psychlist/docker-airconnect-arm` on Docker Hub.

## Usage

The container is started as follows:

```
docker run -d \
  --net=host \
  --name airconnect \
  --restart=always \
  psychlist/docker-airconnect-arm
```

[1] https://github.com/philippe44/AirConnect

[2] https://hub.docker.com/r/resin/rpi-raspbian
