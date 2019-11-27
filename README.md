# osm-tileserver-db

Implements a pgsql database with postgis extensions based on docker container.


## clone and build docker container
```
git clone git@github.com:stevo01/osm-tileserver-db.git
scripts/docker-service.sh build
```

## create docker volume
for persistent storage of database content
```
docker volume create openstreetmap-db
```

## start docker container
```
scripts/docker-service.sh start
```

## db access
+ db name is: gis
+ username = renderer
+ password = renderer
+ port=5433
