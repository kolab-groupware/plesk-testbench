#!/usr/bin/env bash

CONTAINERID=$(docker run -d --rm --tmpfs /run -v $(pwd)/container.sh:/container.sh -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v $(pwd)/../../data:/root/data plesk/centos7:installed)
docker exec $CONTAINERID /container.sh
RET=$?
if [ $RET -eq 0 ]; then
    echo "SUCCESS"
else
    echo "FAILURE"
fi
docker stop $CONTAINERID
exit $RET
