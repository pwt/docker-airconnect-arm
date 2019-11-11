#!/bin/bash

# Set the command line options for airupnp using env. variables
# Allows for options to be omitted completely by setting vars to 'NONE'
# Allows for options to be set, by including values for the vars
# Allows for defaults to be used, by not seeting the vars

# Redirect the output of this script to the required options file.

# ---

# Strict list of model numbers to include. Exact matches. Case sensitive.
# **Overrides** the '-m' and '-n' options completely.
#
# Player model numbers
#   Play:1 : S1, S12
#   Play:3 : S3
#   Play:5 gen 1: S5
#   PlayBar: S9
#   ZonePlayers: ZP80, ZP90 (Connect), ZP100, ZP120 (Connect:Amp)
#   (Sub: Sub -- not included as a target; cannot be standalone)

if [ "$INC_MODELNUMBERS" != "NONE" ]
then
    echo "-o ${INC_MODELNUMBERS:-S1,S3,S5,S9,S12,ZP80,ZP90,ZP100,ZP120} \\"
fi

# Model names to exclude. Supports partial matches.
if [ "$EXC_MODELNAMES" != "NONE" ]
then
    echo "-m ${EXC_MODELNAMES:-} \\"
fi

# Model numbers to exclude. Supports partial matches.
if [ "$EXC_MODELNUMBERS" != "NONE" ]
then
    echo "-n ${EXC_MODELNUMBERS:-} \\"
fi
