#!/usr/bin/env bash

: "${SPARK_HOME:?Need to set SPARK_HOME}"
: "${SPARK_MASTER_HOST:?Need to set SPARK_MASTER_HOST}"

"${SPARK_HOME}"/bin/spark-shell\
 --master spark://"${SPARK_MASTER_HOST}":7077\
 --conf spark.serializer=org.apache.spark.serializer.KryoSerializer\
 --conf spark.kryoserializer.buffer=128m\
 --conf spark.locality.wait=0s\
 --conf spark.sql.adaptive.enabled=true\
 --conf spark.sql.broadcastTimeout=600\
\
 --conf spark.driver.memory=10G\
 --conf spark.driver.maxResultSize=0\
\
 --conf spark.executor.instances="${SPARK_EXECUTOR_INSTANCES}"\
 --conf spark.executor.cores="${SPARK_EXECUTOR_CORES}"\
 --conf spark.executor.memory=200G\
 --conf spark.executor.resource.gpu.amount=1\
\
 --conf spark.task.cpus=1\
 --conf spark.task.resource.gpu.amount="${SPARK_TASK_RESOURCE_GPU_AMOUNT}"\
\
 "$@"
