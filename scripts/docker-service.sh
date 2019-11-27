#!/bin/bash

# start and stops the osm tile server

set -x

IMAGE_NAME="osm-tileserver-db"

function start() {
  docker run \
  		--name $IMAGE_NAME \
  		--rm=false \
  		--detach \
  		--publish 5433:5432 \
      -v openstreetmap-db:/var/lib/postgresql/11/main \
  		$IMAGE_NAME \
  		run
}

function stop() {
  docker container stop $IMAGE_NAME
  docker container rm $IMAGE_NAME
}

function build() {
  docker build -t $IMAGE_NAME ./src
}

case "$1" in
  start)
		start
	;;
  stop)
		stop
	;;
  restart)
    build
    stop
		start
	;;
  build)
    build
	;;
  connect)
		docker exec -i -t $IMAGE_NAME /bin/bash
	;;
  log)
		docker logs -f $IMAGE_NAME
	;;
  *)
	echo "Usage: docker.service.sh {start|stop|restart|build|connect|log}" >&2
	exit 1
	;;
esac

exit 0
