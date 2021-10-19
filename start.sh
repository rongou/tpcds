#!/usr/bin/env bash

if [[ "${SPARK_MASTER_HOST}" == "${SPARK_LOCAL_IP}" ]]; then
  "${SPARK_HOME}"/sbin/start-master.sh
fi
"${SPARK_HOME}"/sbin/start-worker.sh spark://"${SPARK_MASTER_HOST}":7077
