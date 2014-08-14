#!/bin/bash
source functions.sh

echo ""
echo "----------------------------------------"
echo "This script will deploy QGIS Demo Server"
echo "images as a series of docker containers"
echo "----------------------------------------"
echo ""

run_btsync_container
run_postgis_container
run_qgis_server_container

