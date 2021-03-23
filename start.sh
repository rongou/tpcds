#!/usr/bin/env bash

"${SPARK_HOME}"/sbin/start-master.sh
"${SPARK_HOME}"/sbin/start-slave.sh spark://"${SPARK_MASTER_HOST}":7077
