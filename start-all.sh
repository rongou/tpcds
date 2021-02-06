#!/usr/bin/env bash

"${SPARK_HOME}"/sbin/start-master.sh

export SPARK_WORKER_CORES=24
CLASS="org.apache.spark.deploy.worker.Worker"
MASTER=spark://"${SPARK_MASTER_HOST}":7077

export SPARK_WORKER_OPTS="-Dspark.worker.resource.gpu.amount=4 -Dspark.worker.resource.gpu.discoveryScript=${HOME}/rapids/getGpusResources-0.sh"
export SPARK_LOCAL_DIRS=/raid/spark-team/tmp
WORKER_NUM=1
WEBUI_PORT=8081
"${SPARK_HOME}/sbin"/spark-daemon.sh start $CLASS $WORKER_NUM --webui-port "$WEBUI_PORT" "$MASTER"

export SPARK_WORKER_OPTS="-Dspark.worker.resource.gpu.amount=4 -Dspark.worker.resource.gpu.discoveryScript=${HOME}/rapids/getGpusResources-1.sh"
export SPARK_LOCAL_DIRS=/raid1/spark-team/tmp
WORKER_NUM=2
WEBUI_PORT=8082
"${SPARK_HOME}/sbin"/spark-daemon.sh start $CLASS $WORKER_NUM --webui-port "$WEBUI_PORT" "$MASTER"

export SPARK_WORKER_OPTS="-Dspark.worker.resource.gpu.amount=4 -Dspark.worker.resource.gpu.discoveryScript=${HOME}/rapids/getGpusResources-2.sh"
export SPARK_LOCAL_DIRS=/raid2/spark-team/tmp
WORKER_NUM=3
WEBUI_PORT=8083
"${SPARK_HOME}/sbin"/spark-daemon.sh start $CLASS $WORKER_NUM --webui-port "$WEBUI_PORT" "$MASTER"

export SPARK_WORKER_OPTS="-Dspark.worker.resource.gpu.amount=4 -Dspark.worker.resource.gpu.discoveryScript=${HOME}/rapids/getGpusResources-3.sh"
export SPARK_LOCAL_DIRS=/raid3/spark-team/tmp
WORKER_NUM=4
WEBUI_PORT=8084
"${SPARK_HOME}/sbin"/spark-daemon.sh start $CLASS $WORKER_NUM --webui-port "$WEBUI_PORT" "$MASTER"
