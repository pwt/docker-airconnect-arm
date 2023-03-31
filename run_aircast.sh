#!/bin/bash

# Runs aircast-arm if the environment variable is set

if [[ $INCLUDE_AIRCAST = "TRUE" ]]
then
    ./setoptions_aircast.sh > ~/options_aircast.txt
    ./setconfig_aircast.sh > ~/config_aircast.xml
    ./aircast-linux-arm-static -z -x ~/config_aircast.xml $(cat ~/options_aircast.txt)
fi
