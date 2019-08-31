# Docker Container Build of *AirConnect* (airupnpn) for Raspberry Pi, for Sonos speakers 

This Dockerfile builds a docker container version of the excellent AirConnect [1] utility, suitable for use on a Raspberry Pi, and focused on Sonos speakers. It starts the `airupnp-arm` service to enable AirPlay for any and all Sonos speakers and devices. The service is configured to exclude Sonos players that have native AirPlay 2 capability, preventing duplicate AirPlay entries.

It has been tested on the following Raspberry Pi models:

* Raspberry Pi 3 Model B Rev 1.2 (a02082)
* Raspberry Pi 3 Model B Plus Rev 1.3 (a020d3)
* Raspberry Pi 4 Model B Rev 1.1 (a03111)

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

## Changing the configuration

The container is started with a default configuration that should work well for most Sonos installations. However, configuration settings can be overridden by passing in environment variables to the container when it's started. The available configuration parameters are:

`CODEC, METADATA, LATENCY, DRIFT, MAIN_LOG, UPNP_LOG, UTIL_LOG, RAOP_LOG`

Required environment variables and their values are supplied using the `-e` option as part of the `docker run` command line. So, for example, to change the codec to MP3 @ 256kb/s and to change the latency to 500ms/500ms, use the following command line:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e CODEC='mp3:320' \
  -e LATENCY='500:500:f' \
  psychlist/docker-airconnect-arm
```

Take a look at the AirConnect documentation [1] for available configuration values.

## Links

[1] https://github.com/philippe44/AirConnect \
[2] https://hub.docker.com/u/balenalib/ \
[3] https://hub.docker.com/r/psychlist/docker-airconnect-arm \
[4] https://github.com/pwt/docker-airconnect-arm/issues/5
