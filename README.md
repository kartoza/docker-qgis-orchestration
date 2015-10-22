QGIS Mapserver Demo Orchestration
=================================

Orchestration scripts for running QGIS demo server.

To use you need to have docker installed on any supported host. 

```
git clone https://github.com/kartoza/docker-qgis-orchestration.git
cd docker-qgis-orchestration
docker-compose build
docker-compose up -d
```

After deploy is run you should have 3 running containers e.g.:

```
CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS                                                                       NAMES
5142b661cb4e        kartoza/qgis-server:latest       /bin/sh -c apachectl   18 minutes ago      Up 18 minutes       0.0.0.0:8198->80/tcp                                                        qgis-server                                      
a1c711ccfc70        kartoza/postgis:latest           /bin/sh -c /start-po   18 minutes ago      Up 18 minutes       5432/tcp                                                                    qgis-postgis,qgis-server/qgis-postgis            
c1ecef31a1b8        kartoza/qgis-btsync:latest       /start.sh              18 minutes ago      Up 18 minutes       0.0.0.0:55555->55555/tcp, 0.0.0.0:8888->8888/tcp                            qgis-btsync,qgis-server/qgis-btsync 
```

Lastly you will probably want to set up a reverse proxy pointing to your QGIS Mapserver container (our orchestration scripts publish on 8198 by default). Here is a sample configuration for nginx:

```
upstream maps { server localhost:8198;}
 
server {
  listen      80;
  server_name demo.kartoza.com;
  location    / {
    proxy_pass  http://maps;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $remote_addr;
  }
}

```


--------

Tim Sutton and Richard Duivenvoorde, August 2014

