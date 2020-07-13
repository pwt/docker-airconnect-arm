# Add AirPlay to All Sonos Speakers Using AirConnect and Docker on a Raspberry Pi

This project provides a Docker container version of the excellent AirConnect [1] utility, suitable for running on a Raspberry Pi, and optimised for use with Sonos speakers. It starts the `airupnp-arm` service which enables AirPlay for all Sonos speakers and devices. The service is configured by default only to include Sonos players that don't have native AirPlay 2 capability, preventing any duplicate AirPlay targets from being created.

The container includes a modified version of the `airupnp-arm` binary that greatly improves performance of AirConnect with Apple Music and iTunes. Use of this modified version is optional: see the discussion of the `SUPPRESS_FLUSH` option below.

AirConnect works with Sonos **S1** and **S2** software versions, and also works with 'split' S1/S2 Sonos systems.

The Docker container also configures a graphic for display by Sonos controller apps:

![iOS Screenshot](https://github.com/pwt/docker-airconnect-arm/blob/master/assets/iOS_screenshot.png)

### AirCast support

Optionally, `aircast-arm` can also be included, providing AirPlay capabilities for ChromeCast-enabled devices. This inclusion is experimental. To enable it, set the environment variable `INCLUDE_AIRCAST=TRUE` on the `docker run` command line. See the usage example below.

## Platforms

The image has been tested on the following Raspberry Pi models:

* Raspberry Pi 3 Model B Rev 1.2 (a02082)
* Raspberry Pi 3 Model B Plus Rev 1.3 (a020d3)
* Raspberry Pi 4 Model B Rev 1.1 (a03111) 

The docker image name is `psychlist/docker-airconnect-arm` on Docker Hub [3].

Feedback and suggestions are welcome: feel free to use the issue at [4] for this purpose.

## Requirements

A working Docker environment running on a Raspberry Pi. Internet access to pull the Docker image.

## Usage

The container is **started** as follows:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e SUPPRESS_FLUSH=TRUE \
  psychlist/docker-airconnect-arm
```

To include AirCast support, set the `INCLUDE_AIRCAST` environment variable to `TRUE` as shown below:
```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e SUPPRESS_FLUSH=TRUE \
  -e INCLUDE_AIRCAST=TRUE \
  psychlist/docker-airconnect-arm
```

If you subsequently want to **update to a newer version** of the image: (1) pull the new image, (2) remove the container, then (3) start a new instance of the container. This will stop any currently-running AirPlay streams:

```
docker pull psychlist/docker-airconnect-arm
docker rm --force airconnect
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e SUPPRESS_FLUSH=TRUE \
  psychlist/docker-airconnect-arm
```

## Changing the configuration

The container is started with a default configuration that should work very well for most Sonos installations. However, configuration settings can be overridden by passing in optional environment variables to the container when it's started.

### Using the SUPPRESS_FLUSH option to improve Apple Music and iTunes responsiveness

If the `SUPPRESS_FLUSH` environment variable is set to `TRUE` on the Docker command line (as it is in the examples on this page), a **modified version** of the `airupnp-arm` binary is run. The modified binary is built by me and can be found in the `bin/` directory of this repository. It prevents certain FLUSH commands from being sent to the speakers, which greatly improves the responsiveness (changing tracks, changing position within a track) of AirConnect when streaming is performed from the Apple Music apps, or from iTunes.

*The modified binary has been tested with Sonos speakers, but may not work well with other types of speaker.*

If you prefer not to use this option, and run the standard binary instead, just exclude the `-e SUPPRESS_FLUSH=TRUE` statements from the Docker command lines. The Docker image contains both the modified and unmodified forms of the binary.

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
  -e SUPPRESS_FLUSH=TRUE \
  -e INC_MODELNUMBERS=S9,S1,S12 \
  psychlist/docker-airconnect-arm
```

Or, to include all UPnP devices except second generation Play:5s, use:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=always \
  -e SUPPRESS_FLUSH=TRUE \
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
  -e SUPPRESS_FLUSH=TRUE \
  -e CODEC='mp3:320' \
  -e LATENCY='500:500:f' \
  psychlist/docker-airconnect-arm
```

Take a look at the AirConnect documentation [1] for more information on the available configuration values.

## Building your own Docker images

In order to build for ARM on Docker Hub, the Dockerfile makes use of the *crossbuild* capabilities provided by the Balena Raspbian distribution [2], which allows ARM images to be built under x86. (If you want to use this Dockerfile to build directly on a native ARM device, comment out or delete the two `cross-build` RUN statements.)

## Links

[1] https://github.com/philippe44/AirConnect \
[2] https://hub.docker.com/u/balenalib/ \
[3] https://hub.docker.com/r/psychlist/docker-airconnect-arm \
[4] https://github.com/pwt/docker-airconnect-arm/issues/5
