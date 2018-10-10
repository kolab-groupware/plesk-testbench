#!/usr/bin/env bash
CONTAINERID=$(docker run --rm --tmpfs /run -v $(pwd)/setup.sh:/setup.sh -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d -v $(pwd)/data:/root/data plesk/centos7:installed)
docker exec $CONTAINERID /setup.sh
docker commit $CONTAINERID plesk/centos7:configured
docker stop $CONTAINERID
