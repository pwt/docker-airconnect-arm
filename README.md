# Docker Container Build of *AirConnect* for Raspberry Pi

This Dockerfile builds a docker container version of the excellent AirConnect [1] utility, suitable for use on a Raspberry Pi. It starts only the `airupnp-arm` service to enable AirPlay for any and all Sonos speakers and devices. The service is configured to exclude Sonos players that have native AirPlay 2 capability, preventing duplicate AirPlay entries.

It has been tested on the following Raspberry Pi models:

* Raspberry Pi 3 Model B Rev 1.2 (a02082)
* Raspberry Pi 3 Model B Plus Rev 1.3 (a020d3)

In order to build for ARM on Docker Hub, the Dockerfile makes use of the *crossbuild* capabilities provided by the Balena Raspbian distribution [2], which allows ARM images to be built under x86. (If you want to use this Dockerfile to build directly on a native ARM device, comment out or delete the two `cross-build` RUN statements.) 

The docker image name is `psychlist/docker-airconnect-arm` on Docker Hub [3].

Feedback and suggestions are welcome: feel free to use the issue at [4].

## Requirements

A working Docker environment. Internet access to pull the Docker image.

## Usage

The container is started as follows:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  psychlist/docker-airconnect-arm
```

If you subsequently want to update to a more recent version of the image: (1) pull the new image, (2) remove the container, then (3) start a new instance of the container. This will stop any currently-running AirPlay streams:

```
docker pull psychlist/docker-airconnect-arm
docker rm --force airconnect
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  psychlist/docker-airconnect-arm
```

## Links

[1] https://github.com/philippe44/AirConnect \
[2] https://hub.docker.com/u/balenalib/ \
[3] https://hub.docker.com/r/psychlist/docker-airconnect-arm \
[4] https://github.com/pwt/docker-airconnect-arm/issues/5
