#!/bin/bash

# Returns the name of the modified binary if the environment variable
# SUPPRESS_FLUSH is set

if [[ -z ${SUPPRESS_FLUSH} ]];
then
    echo "airupnp-arm"
else
    echo "airupnp-arm-modified"
fi

