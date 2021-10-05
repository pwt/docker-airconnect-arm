#!/bin/bash

# Set the command line options for aircast using env. variables

# Redirect the output of this script to the required options file.

# ---

# Which local port (IP address) to bind to
if [ "$BIND_IP" ]
then
    echo -n "-b ${BIND_IP:-} "
fi
