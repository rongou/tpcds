#!/usr/bin/env bash

"${SPARK_HOME}"/sbin/stop-worker.sh
"${SPARK_HOME}"/sbin/stop-master.sh
killall -9 -w -q spark
rm -fr "${SPARK_HOME}"/work/*
rm -fr /tmp/* 2>/dev/null
