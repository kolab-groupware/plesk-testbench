#!/usr/bin/env bash
docker build . -t plesk/centos7
CONTAINERID=$(docker run --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d -v $(pwd)/install.sh:/install.sh -v $(pwd)/license:/license plesk/centos7:latest)
docker exec $CONTAINERID /install.sh
docker commit $CONTAINERID plesk/centos7:installed
docker stop $CONTAINERID
