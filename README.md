# Add AirPlay to All Sonos Speakers Using AirConnect and Docker on a Raspberry Pi

This project provides a docker container version of the excellent AirConnect [1] utility, suitable for use on a Raspberry Pi, and focused on Sonos speakers. It starts the `airupnp-arm` service to enable AirPlay for any and all Sonos speakers and devices. The service is configured to exclude Sonos players that have native AirPlay 2 capability, preventing duplicate AirPlay entries.

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

The container is started with a default configuration that should work very well for most Sonos installations. However, configuration settings can be overridden by passing in optional environment variables to the container when it's started.

### Changing which speakers are included

The container is configured to include only Sonos devices that do not natively support AirPlay2. Specifically, the following Sonos devices are included: Play:1, Play:3, Play:5 (first generation), PlayBar, ZP80, Connect (ZP90), ZP100 and Connect:Amp (ZP120). All other Sonos and non-Sonos UPnP devices discovered on the network will be ignored.

To override this behaviour, you can use the `INC_MODELNUMBERS`, `EXC_MODELNUMBERS` and `EXC_MODELNAMES` environment variables.

- Set `INC_MODELNUMBERS` to `NONE` in order to inhibit specific inclusion of device model numbers. Alternatively, set it to the specific list of device model numbers you want to include.

- When `INC_MODELNUMBERS` is set to `NONE`, use the `EXC_MODELNUMBERS` and `EXC_MODELNAMES` environment variables to provide lists of device model numbers and names that you'd like to exclude.

Required environment variables and their values are supplied using the `-e` option as part of the `docker run` command line. As an example, to include only Playbars and Play:1 speakers, use:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e INC_MODELNUMBERS=S9,S1,S12 \
  psychlist/docker-airconnect-arm
```

Or, to include all UPnP devices except second generation Play:5s, use:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e INC_MODELNUMBERS=NONE \
  -e EXC_MODELNUMBERS=S6 \
  psychlist/docker-airconnect-arm
```

Note that the `-e INC_MODELNUMBERS=NONE` is required in order for the other options to be effective.

### Other configuration settings

The other available configuration parameters are:

`CODEC, METADATA, LATENCY, DRIFT, MAIN_LOG, UPNP_LOG, UTIL_LOG, RAOP_LOG`

So, for example, to change the codec to MP3 @ 256kb/s and to change the latency to 500ms/500ms, use the following command line:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e CODEC='mp3:320' \
  -e LATENCY='500:500:f' \
  psychlist/docker-airconnect-arm
```

Take a look at the AirConnect documentation [1] for more information on the available configuration values.

## Links

[1] https://github.com/philippe44/AirConnect \
[2] https://hub.docker.com/u/balenalib/ \
[3] https://hub.docker.com/r/psychlist/docker-airconnect-arm \
[4] https://github.com/pwt/docker-airconnect-arm/issues/5
