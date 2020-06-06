#!/bin/bash

# Returns the name of the modified binary if the environment variable
# SUPPRESS_FLUSH is set to 'TRUE'

if [[ ${SUPPRESS_FLUSH} == TRUE ]];
then
    echo "airupnp-arm-modified"
else
    echo "airupnp-arm"
fi
