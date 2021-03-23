#!/usr/bin/env bash

"${SPARK_HOME}"/sbin/start-master.sh
"${SPARK_HOME}"/sbin/start-worker.sh spark://"${SPARK_MASTER_HOST}":7077
