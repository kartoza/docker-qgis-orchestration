#!/bin/bash

BASE_DIR=/var/www/
WEB_DIR=${BASE_DIR}/web

BTSYNC_IMAGE=docker-qgis-btsync
POSTGIS_IMAGE=docker-postgis
QGIS_SERVER_IMAGE=docker-qgis-server

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

    docker build -t kartoza/${BTSYNC_IMAGE} git://github.com/${ORG}/${BTSYNC_IMAGE}.git

}

function run_btsync_container {

    echo ""
    echo "Running btsync container"
    echo "====================================="

    make_directories

    kill_container ${BTSYNC_IMAGE}

    docker run --name="${BTSYNC_IMAGE}" \
        -v ${WEB_DIR}:/web \
        -p 8888:8888 \
        -p 55555:55555 \
        -d -t kartoza/${BTSYNC_IMAGE}

}

function build_postgis_image {

    echo ""
    echo "Building postgis image"
    echo "====================================="

    docker build -t kartoza/${POSTGIS_IMAGE} git://github.com/${ORG}/${POSTGIS_IMAGE}.git

}

function run_postgis_container {

    echo ""
    echo "Running postgis container"
    echo "====================================="

    make_directories

    kill_container ${POSTGIS_IMAGE}

    docker run --name="${POSTGIS_IMAGE}" \
        -d -t kartoza/${POSTGIS_IMAGE}

}

function build_qgis_server_image {

    echo ""
    echo "Building QGIS Server Image"
    echo "====================================="

    docker build -t kartoza/${QGIS_SERVER_IMAGE} git://github.com/${ORG}/${QGIS_SERVER_IMAGE}.git

}

function run_qgis_server_container {

    echo ""
    echo "Running QGIS Server container"
    echo "====================================="

    kill_container ${QGIS_SERVER_IMAGE}

    make_directories

    cp web/index.html ${WEB_DIR}/
    cp -r web/resource ${WEB_DIR}/

    docker run --name="${QGIS_SERVER_IMAGE}" \
        -v ${WEB_DIR}:/web \
        -l ${POSTGIS_IMAGE}:${POSTGIS_IMAGE}
        -l ${BTSYNC_IMAGE}:${BTSYNC_IMAGE}
        -p 8198:80 \
        -d -t kartoza/${QGIS_SERVER_IMAGE}


}
