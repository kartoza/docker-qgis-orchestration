QGIS Mapserver Demo Orchestration
=================================

Orchestration scripts for running QGIS maps server.

To use you need to have docker and docker-compose installed on any supported host. 

# Get the code

First check out the sources to your local machine:

```
git clone https://github.com/qgis/docker-qgis-orchestration.git
cd docker-qgis-orchestration
```

# Build and run the services

On OSX or Windows, we recommend using docker machine:

```
docker-machine create --driver virtualbox maps.kartoza.com
docker-machine start maps.kartoza.com
eval "$(docker-machine env maps.kartoza.com)"
docker-compose up -d qgis-server
```

On Linux you probably don't use docker-machine so just do:

```
docker-compose up -d
```

# Verify everything is running

After deploy is run you should have 3 running containers e.g.:

```
docker ps
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                  NAMES
2cffc0ce7729        kartoza/qgis-server       "/bin/sh -c 'apachect"   24 minutes ago      Up 24 minutes       0.0.0.0:8198->80/tcp   maps.kartoza.com
e730206a9f89        kartoza/postgis:9.4-2.1   "/bin/sh -c /start-po"   24 minutes ago      Up 24 minutes       5432/tcp               db.maps.kartoza.com
c35949d6f660        kartoza/btsync            "/start.sh"              24 minutes ago      Up 24 minutes       8888/tcp, 55555/tcp    btsync.maps.kartoza.com
```

# Test the service

You can test the service is running on OSX or windows by pointing to port `8198` of your docker machine:

```
docker-machine ls
```

Take a note of the IP address of the maps.kartoza.com machined and then open your browser at http://<ip address>:8198


On Linux simply test by pointing your browser at http:///localhost:8198


# Reverse proxy for nginx

Lastly you will probably want to set up a reverse proxy pointing to your QGIS
Mapserver container (our orchestration scripts publish on `8198` by default).
If you are using nginx on the host, you can simply do:

```

```


--------

Tim Sutton and Richard Duivenvoorde, August 2014

