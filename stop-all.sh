#!/usr/bin/env bash

SPARK_WORKER_INSTANCES=4 "${SPARK_HOME}"/sbin/stop-slave.sh
"${SPARK_HOME}"/sbin/stop-master.sh
killall -9 -w -q spark
rm -fr "${SPARK_HOME}"/work/*
rm -fr /tmp/* 2>/dev/null
