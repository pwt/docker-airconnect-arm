#!/bin/bash

# Runs aircast-arm if the environment variable is set

if [[ $INCLUDE_AIRCAST = "TRUE" ]]
then
    ./setconfig_aircast.sh > config_aircast.xml
    ./aircast-arm -Z -x config_aircast.xml
fi
