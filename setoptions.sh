#!/bin/bash

# Set the command line options for airupnp using env. variables
# Redirect the output of this script to the required options file.

# ---


# Which local port (IP address) to bind to
if [ "$BIND_IP" ]
then
    echo -n "-b ${BIND_IP} "
fi

# Strict list of model numbers to include. Exact matches. Case sensitive.
# **Overrides** the '-m' and '-n' options completely.
#
# Player model numbers
#   Play:1 : S1, S12
#   Play:3 : S3
#   Play:5 gen 1: S5
#   PlayBar: S9
#   ZonePlayers: ZP80, ZP90, and S15 (Connect), ZP100, ZP120 (Connect:Amp)
#   (Sub: Sub -- not included as a target; cannot be standalone)

if [ "$INC_MODELNUMBERS" != "NONE" ]
then
    echo -n "-o ${INC_MODELNUMBERS:-S1,S3,S5,S9,S12,ZP80,ZP90,S15,ZP100,ZP120} "
fi

# Model names to exclude. Supports partial matches.
if [ "$EXC_MODELNAMES" ]
then
    echo -n  "-m ${EXC_MODELNAMES:-} "
fi

# Model numbers to exclude. Supports partial matches.
if [ "$EXC_MODELNUMBERS" ]
then
    echo -n "-n ${EXC_MODELNUMBERS:-} "
fi
