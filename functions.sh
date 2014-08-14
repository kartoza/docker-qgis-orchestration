#!/bin/bash

BASE_DIR=/var/www/
WEB_DIR=${BASE_DIR}/web

BTSYNC_GIT_REPO=docker-qgis-btsync
BTSYNC_IMAGE=qgis-btsync
BTSYNC_CONTAINER=qgis-btsync

POSTGIS_GIT_REPO=docker-postgis
POSTGIS_IMAGE=postgis
POSTGIS_CONTAINER=qgis-postgis

QGIS_SERVER_GIT_REPO=qgis-server
QGIS_SERVER_IMAGE=qgis-server
QGIS_SERVER_CONTAINER=qgis-server

QGIS_DESKTOP_GIT_REPO=docker-qgis-desktop
QGIS_DESKTOP_IMAGE=qgis-desktop
QGIS_DESKTOP_CONTAINER=qgis-desktop

function make_directories {

    if [ ! -d ${WEB_DIR} ]
    then
        mkdir -p ${WEB_DIR}
    fi

}

function kill_container {

    NAME=$1

    if docker ps -a | grep ${NAME} > /dev/null
    then
        echo "Killing ${NAME}"
        docker kill ${NAME}
        docker rm ${NAME}
    else
        echo "${NAME} is not running"
    fi

}

function build_btsync_image {

    echo ""
    echo "Building btsync image"
    echo "====================================="

    docker build -t kartoza/${BTSYNC_IMAGE} git://github.com/${ORG}/${BTSYNC_GIT_REPO}.git

}

function run_btsync_container {

    echo ""
    echo "Running btsync container"
    echo "====================================="

    make_directories

    kill_container ${BTSYNC_CONTAINER}

    docker run --name="${BTSYNC_CONTAINER}" \
        -v ${WEB_DIR}:/web \
        -p 8888:8888 \
        -p 55555:55555 \
        -d -t kartoza/${BTSYNC_IMAGE}

}

function build_postgis_image {

    echo ""
    echo "Building postgis image"
    echo "====================================="

    docker build -t kartoza/${POSTGIS_IMAGE} git://github.com/${ORG}/${POSTGIS_GIT_REPO}.git

}

function run_postgis_container {

    echo ""
    echo "Running postgis container"
    echo "====================================="

    make_directories

    kill_container ${POSTGIS_CONTAINER}

    docker run --name="${POSTGIS_CONTAINER}" \
        -d -t kartoza/${POSTGIS_IMAGE}

}

function build_qgis_server_image {

    echo ""
    echo "Building QGIS Server Image"
    echo "====================================="

    docker build -t kartoza/${QGIS_SERVER_IMAGE} git://github.com/${ORG}/${QGIS_SERVER_GIT_REPO}.git

}

function run_qgis_server_container {

    echo ""
    echo "Running QGIS Server container"
    echo "====================================="

    kill_container ${QGIS_SERVER_CONTAINER}

    make_directories

    # We mount BTSYNC volumes which provides
    # /web into this container
    # and we link POSTGIS and BTSYNC
    # to establish a dependency on them
    # when bringing this container up
    # The posgis link wil add a useful
    # entry to /etc/hosts that should be used
    # referencing postgis layers
    set -x
    docker run --name="${QGIS_SERVER_CONTAINER}" \
        --volumes-from ${BTSYNC_IMAGE} \
        --link=${POSTGIS_CONTAINER}:${POSTGIS_CONTAINER} \
	--link=${BTSYNC_CONTAINER}:${BTSYNC_CONTAINER} \
        -p 8198:80 \
        -d -t kartoza/${QGIS_SERVER_IMAGE}
}

function build_qgis_desktop_image {

    echo ""
    echo "Building QGIS Desktop Image"
    echo "====================================="

    docker build -t kartoza/${QGIS_DESKTOP_IMAGE} git://github.com/${ORG}/${QGIS_DESKTOP_GIT_REPO}.git

}

function run_qgis_desktop_container {

    echo ""
    echo "Running QGIS Desktop container"
    echo "====================================="
    xhost +
    # Users home is mounted as home
    # --rm will remove the container as soon as it ends

    # We mount BTSYNC volumes which provides
    # /web into this container
    # and we link POSTGIS and BTSYNC
    # to establish a dependency on them
    # when bringing this container up
    # The posgis link wil add a useful
    # entry to/etc/hosts that should be used
    # referencing postgis layers

    set -x
    docker run --rm --name="${QGIS_DESKTOP_CONTAINER}" \
	-i -t \
        --volumes-from ${BTSYNC_IMAGE} \
	-v ${HOME}:/home/${USER} \
        --link=${POSTGIS_CONTAINER}:${POSTGIS_CONTAINER} \
	--link=${BTSYNC_CONTAINER}:${BTSYNC_CONTAINER} \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	kartoza/${QGIS_DESKTOP_IMAGE}:latest 
    xhost -
}
