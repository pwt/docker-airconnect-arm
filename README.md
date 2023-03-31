# Add AirPlay to Sonos with AirConnect and Docker on a Raspberry Pi

# Important: Sonos 15.2 Update 30-Mar-2023

**In the Sonos S2 v15.2 update released in late March, Sonos made a change that prevents AirConnect from working. Sonos S1 systems are currently unaffected.**

I'm exploring a temporary workaround for this issue and will update the container image once the change has been tested.

## Quickstart

### Installing Docker

**If you already have a working Docker installation on your Raspberry Pi, you can ignore this step.**

The commands to install Docker using its install script are shown below. In the final command below, replace `<your-user>`, with your Raspberry Pi user name (perhaps `pi`).

```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker <your-user>
```

Now **start a new terminal** for the final command to take effect. It's possible you will also have to reboot your device to start the Docker service correctly.

### Starting

Start the container using the following command line:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e INCLUDE_AIRCAST=TRUE \
  psychlist/docker-airconnect-arm
```

### Updating

Update the container using the following commands:

```
docker pull psychlist/docker-airconnect-arm && \
docker rm --force airconnect && \
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e INCLUDE_AIRCAST=TRUE \
  psychlist/docker-airconnect-arm
```

## Introduction

This project provides a Docker container version of the excellent AirConnect [1] utility, suitable for running on a Raspberry Pi, and optimised for use with Sonos speakers. It provides a network bridge allowing Apple devices to send AirPlay audio to speakers and other devices that don't natively support AirPlay. The container image is based on Alpline Linux and its total size is about 90MB.

The docker-airconnect-arm container hosts the AirConnect `airupnp-arm` service which enables AirPlay for all Sonos speakers and devices. The service is configured by default only to include Sonos players that don't have native AirPlay 2 capability, preventing any duplicate AirPlay targets from being created.

AirConnect works with Sonos **S1** and **S2** software versions, and also works with 'split' S1/S2 Sonos systems.

The Docker container also configures a graphic for display by Sonos controller apps:

![AirConnect Logo](https://github.com/pwt/docker-airconnect-arm/blob/master/assets/images/airconnect-logo-smaller.png)

### AirCast support

Although this Docker image is primarily targeted and optimised for Sonos environments, it's possible to include in addition the `aircast-arm` service, providing AirPlay capabilities for ChromeCast devices. To enable AirCast in your container, set the environment variable `INCLUDE_AIRCAST=TRUE` when starting the container. See the usage example below.

## Platforms

The image has been tested on the following Raspberry Pi models:

* Raspberry Pi Model B Rev 2 (000f)
* Raspberry Pi Zero W Rev 1.1 (90000c1)
* Raspberry Pi Zero 2 Rev 1.0 (902120)
* Raspberry Pi 3 Model B Rev 1.2 (a02082)
* Raspberry Pi 3 Model B Plus Rev 1.3 (a020d3)
* Raspberry Pi 4 Model B Rev 1.1 (a03111)

It may work on other ARM-based devices that support Docker.

The docker image name is `psychlist/docker-airconnect-arm` on Docker Hub [3].

Feedback and suggestions are welcome: feel free to use the issue at [4] for this purpose.

## Requirements

A working Docker environment running on a suitable Raspberry Pi connected to the same network as the target speakers. Internet access is required to pull the Docker image.

## Usage

The container is **started** as follows:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  psychlist/docker-airconnect-arm
```

To include AirCast support, set the `INCLUDE_AIRCAST` environment variable to `TRUE` in each `docker run` command line, as shown below:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
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
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  psychlist/docker-airconnect-arm
```

### Docker 'platform' warnings

If, on starting the container, there is a warning message along the lines of `WARNING: The requested image's platform (linux/arm/v7) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested`, then you can specify the `platform` on the `docker run` command line to suppress the warning:

```
docker run -d \
  --platform=linux/arm/v7 \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e INCLUDE_AIRCAST=TRUE \
  psychlist/docker-airconnect-arm
```

## Changing the configuration

The container is started with a default configuration that should work very well for most Sonos installations. However, configuration settings can be overridden by passing in optional environment variables to the container when it's started.

### Using the SUPPRESS_FLUSH option to improve Apple Music and iTunes responsiveness

If the `SUPPRESS_FLUSH` environment variable is set to `TRUE` on the Docker command line (as it is in the examples on this page), the airupnp service is run with the `--noflush` option, which greatly improves AirConnect's responsiveness (changing tracks, changing position within a track) when streaming from Apple apps.

*This option works well with Sonos speakers, but may not work well with other types of speaker.*

If you prefer not to use this option just omit the `-e SUPPRESS_FLUSH=TRUE` statements from the Docker command lines.

### Selecting the network interface

If your Raspberry Pi has multiple network interfaces, e.g., you're using both the wired and wireless interfaces, it's possible to specify which interface AirConnect binds to using the `BIND_IP` environment variable.

For example, add the following to the `docker run` command line options: `-e BIND_IP=192.168.0.50`, where the IP address specified is the one assigned to your chosen interface.

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
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e INC_MODELNUMBERS=S9,S1,S12 \
  psychlist/docker-airconnect-arm
```

Or, to include all UPnP devices except second generation Play:5s, use:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e INC_MODELNUMBERS=NONE \
  -e EXC_MODELNUMBERS=S6 \
  psychlist/docker-airconnect-arm
```

Note that the `-e INC_MODELNUMBERS=NONE` is required in order for the other options to be effective.

### Changing the artwork displayed by the Sonos controller apps

Use the `ARTWORK` environment variable to point to an image URL of your choice, instead of the default artwork supplied. The image must be available to the speakers and controllers over HTTP/S. For example:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e ARTWORK=https://raw.githubusercontent.com/pwt/docker-airconnect-arm/master/airconnect-logo.png \
  -e SUPPRESS_FLUSH=TRUE \
  psychlist/docker-airconnect-arm
```

### Other configuration settings

The other available configuration parameters are:

`CODEC, METADATA, LATENCY, DRIFT, MAX_PLAYERS, MAIN_LOG, UPNP_LOG, UTIL_LOG, RAOP_LOG`

So, for example, to change the codec to MP3 @ 256kb/s and to change the latency to 500ms/500ms, use the following command line:

```
docker run -d \
  --net=host \
  --name=airconnect \
  --restart=unless-stopped \
  -e SUPPRESS_FLUSH=TRUE \
  -e CODEC='mp3:320' \
  -e LATENCY='500:500:f' \
  psychlist/docker-airconnect-arm
```

Take a look at the AirConnect documentation [1] (in the Config File Parameters section) for more information on the available configuration values.

## Building your own Docker images

In order to build for ARM on x86 hosts, the Dockerfile makes use of the *crossbuild* capabilities provided by the Balena [2] base image for Alpine Linux , which allows ARM images to be built under x86. (If you want to use this Dockerfile to build directly on a native ARM host, comment out or remove the two `cross-build` RUN statements.)

## Links

[1] https://github.com/philippe44/AirConnect \
[2] https://hub.docker.com/u/balenalib/ \
[3] https://hub.docker.com/r/psychlist/docker-airconnect-arm \
[4] [https://github.com/pwt/docker-airconnect-arm/issues/5](https://github.com/pwt/docker-airconnect-arm/issues/5)
