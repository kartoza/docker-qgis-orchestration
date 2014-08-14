#!/bin/bash
source functions.sh

echo ""
echo "----------------------------------------"
echo "This script will deploy QGIS Demo Server"
echo "images as a series of docker containers"
echo "----------------------------------------"
echo ""

run_qgis_server_container
run_btsync_container


