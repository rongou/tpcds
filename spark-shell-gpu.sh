#!/usr/bin/env bash

: "${SPARK_HOME:?Need to set SPARK_HOME}"
: "${SPARK_MASTER_HOST:?Need to set SPARK_MASTER_HOST}"
: "${SPARK_CUDF_JAR:?Need to set SPARK_CUDF_JAR}"
: "${SPARK_RAPIDS_PLUGIN_JAR:?Need to set SPARK_RAPIDS_PLUGIN_JAR}"
: "${SPARK_RAPIDS_INTEGRATION_TESTS_JAR:?Need to set SPARK_RAPIDS_INTEGRATION_TESTS_JAR}"
: "${CONCURRENT_GPU_TASKS:?Need to set CONCURRENT_GPU_TASKS}"
: "${SHUFFLE_PARTITIONS:?Need to set SHUFFLE_PARTITIONS}"
: "${MAX_PARTITION_BYTES:?Need to set MAX_PARTITION_BYTES}"
: "${BATCH_SIZE_BYTES:?Need to set BATCH_SIZE_BYTES}"
: "${NVTX_ENABLED:?Need to set NVTX_ENABLED}"

"${SPARK_HOME}"/bin/spark-shell\
 --master spark://"${SPARK_MASTER_HOST}":7077\
 --conf spark.serializer=org.apache.spark.serializer.KryoSerializer\
 --conf spark.kryo.registrator=com.nvidia.spark.rapids.GpuKryoRegistrator\
 --conf spark.locality.wait=0s\
 --conf spark.sql.files.maxPartitionBytes="${MAX_PARTITION_BYTES}"\
 --conf spark.sql.shuffle.partitions="${SHUFFLE_PARTITIONS}"\
 --conf spark.shuffle.manager=com.nvidia.spark.rapids.spark301.RapidsShuffleManager\
\
 --conf spark.plugins=com.nvidia.spark.SQLPlugin\
 --conf spark.rapids.sql.concurrentGpuTasks="${CONCURRENT_GPU_TASKS}"\
 --conf spark.rapids.memory.pinnedPool.size=8G\
 --conf spark.rapids.sql.batchSizeBytes="${BATCH_SIZE_BYTES}"\
\
 --conf spark.driver.memory=10G\
 --conf spark.driver.extraJavaOptions=-Dai.rapids.cudf.nvtx.enabled="${NVTX_ENABLED}"\
\
 --conf spark.executor.extraClassPath="${SPARK_CUDF_JAR}":"${SPARK_RAPIDS_PLUGIN_JAR}"\
 --conf spark.executor.extraJavaOptions=-Dai.rapids.cudf.nvtx.enabled="${NVTX_ENABLED}"\
 --num-executors 1\
 --conf spark.executor.cores=6\
 --conf spark.executor.memory=64G\
 --conf spark.executor.resource.gpu.amount=1\
\
 --conf spark.task.cpus=1\
 --conf spark.task.resource.gpu.amount=0.1666\
\
 --jars "${SPARK_CUDF_JAR}","${SPARK_RAPIDS_PLUGIN_JAR}","${SPARK_RAPIDS_INTEGRATION_TESTS_JAR}"\
 "$@"
