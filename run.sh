#!/bin/bash

date > /tmp/qgis-demo-server-log.txt

DIR=`dirname $0`
source ${DIR}/functions.sh

# Any short lived container jobs go here

# Run the QGIS desktop client
run_qgis_desktop_container 
