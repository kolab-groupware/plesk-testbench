#!/usr/bin/env bash
docker run --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d -p 8880:8880 -v $(pwd)/data:/root/data plesk/centos7:configured
