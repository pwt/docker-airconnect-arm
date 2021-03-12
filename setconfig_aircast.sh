#!/bin/bash

# Dynamically generates the config_aircast.xml file

# Various settings below will be obtained from the environment if the variables are set,
# otherwise the defaults will be used.

echo "<?xml version=\"1.0\"?>"
echo "<aircast>"
echo "     <common>"
echo "         <enabled>1</enabled>"
echo "         <max_volume>100</max_volume>"
echo "         <codec>${CODEC:-flc}</codec>"
echo "         <metadata>${METADATA:-1}</metadata>"
echo "         <artwork>https://raw.githubusercontent.com/pwt/docker-airconnect-arm/master/airconnect-logo.png</artwork>"
echo "         <latency>${LATENCY:-1000:1000:f}</latency>"
echo "         <drift>${DRIFT:-1}</drift>"
echo "         <max_players>${MAX_PLAYERS:-32}</max_players>"
if [ "$SUPPRESS_FLUSH" ]
then
echo "         <flush>0</flush>"
else
echo "         <flush>1</flush>"
fi
echo "     </common>"
echo "     <main_log>${MAIN_LOG:-info}</main_log>"
echo "     <util_log>${UTIL_LOG:-warn}</util_log>"
echo "     <raop_log>${RAOP_LOG:-warn}</raop_log>"
echo "     <log_limit>2</log_limit>"
echo "</aircast>"
