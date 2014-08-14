QGIS Realtime Orchestration
=============================

Orchestration scripts for running QGIS demo server.

To use you need to have docker installed on any linux host. You
need a minimum of docker 1.0.0

There are three main scripts here:

* **build.sh**: This will build all the docker images. 
  You can optionally pass a parameter which is an alternate organisation or
  user name which will let you build against your forks of the official QGIS
  repos. e.g.

  ``./build.sh [github organisation or user name]``
  
  During the build process, these docker images will be built:
  * **AIFDR/docker-realtime-btsync**: This runs a btsync server that will
    contain the analysis datasets used during shakemap generation. The btsync 
    peer hosted here is read only. To push data to the server, you need to 
    have the write token (ask Tim or Akbar for it if needed). The 
    container run from this image will be a long running daemon. 
  * **AIFDR/docker-qgis-server**: This runs a QGIS mapserver container 
    which has apache, mod_fcgi and QGIS Mapserver installed in it.
  
* **deploy.sh**: This script will launch containers for all the long running
  daemons mentioned in the list above. Each container will be named with
  the base name of the image.
 
* **run.sh**: This script will run any short lived containerised apps.
  Currently there are no such apps in this architecture.
  

There is an additional script called `functions.sh` which contains common
functions shared by all scripts.

The orchestration scripts provided here will build against docker recipes
hosted in GitHub - there is no need to check them all out individually. So 
to use all you need to do is (on your host):


```
git clone git://github.com/kartoza/docker-qgis-orchestration.git
cd docker-qgis-orchestration
./build.sh
./deploy.sh
```

--------

Tim Sutton and Richard Duivenvoorde, August 2014

