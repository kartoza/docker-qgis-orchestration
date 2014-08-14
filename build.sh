#!/bin/bash
source functions.sh

echo ""
echo "----------------------------------------"
echo "This script will build the docker images "
echo "needed for QGIS Demo Server"
echo ""
echo "You can optionally pass a parameter which "
echo "is an alternate organisation or user name"
echo "which will let you build against your forks"
echo "of the official kartoza repos. e.g."
echo ""
echo "$0 [github organisation or user name]"
echo ""
echo "----------------------------------------"
echo ""


# See if we are using forks or official repo
if test -z "$1"
then
  echo "Using ${ORG} organsiation repos on github"
  export ORG=kartoza
else
  echo "Using personal forks: $1"
  export ORG=$1
fi

build_qgis_server_image
build_btsync_image


