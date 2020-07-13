#!/bin/bash

# Runs aircast-arm if the environment variable is set

if [[ $INCLUDE_AIRCAST = "TRUE" ]]
then
    ./aircast-arm -z
fi
