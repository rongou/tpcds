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
: "${GDS_ENABLED:?Need to set GDS_ENABLED}"
: "${NVTX_ENABLED:?Need to set NVTX_ENABLED}"

"${SPARK_HOME}"/bin/spark-shell\
 --master spark://"${SPARK_MASTER_HOST}":7077\
 --conf spark.serializer=org.apache.spark.serializer.KryoSerializer\
 --conf spark.kryo.registrator=com.nvidia.spark.rapids.GpuKryoRegistrator\
 --conf spark.locality.wait=0s\
 --conf spark.sql.files.maxPartitionBytes="${MAX_PARTITION_BYTES}"\
 --conf spark.sql.shuffle.partitions="${SHUFFLE_PARTITIONS}"\
 --conf spark.shuffle.manager=com.nvidia.spark.rapids.spark301.RapidsShuffleManager\
 --conf spark.shuffle.service.enabled=false\
\
 --conf spark.plugins=com.nvidia.spark.SQLPlugin\
 --conf spark.rapids.sql.concurrentGpuTasks="${CONCURRENT_GPU_TASKS}"\
 --conf spark.rapids.memory.pinnedPool.size=8G\
 --conf spark.rapids.sql.batchSizeBytes="${BATCH_SIZE_BYTES}"\
 --conf spark.rapids.memory.gpu.direct.storage.spill.enabled="${GDS_ENABLED}"\
\
 --conf spark.driver.memory=10G\
 --conf spark.driver.extraJavaOptions=-Dai.rapids.cudf.nvtx.enabled="${NVTX_ENABLED}"\
\
 --conf spark.executor.extraClassPath="${SPARK_CUDF_JAR}":"${SPARK_RAPIDS_PLUGIN_JAR}"\
 --conf spark.executor.extraJavaOptions=-Dai.rapids.cudf.nvtx.enabled="${NVTX_ENABLED}"\
 --conf spark.executor.instances="${SPARK_EXECUTOR_INSTANCES}"\
 --conf spark.executor.cores="${SPARK_EXECUTOR_CORES}"\
 --conf spark.executor.memory=64G\
 --conf spark.executor.resource.gpu.amount=1\
\
 --conf spark.task.cpus=1\
 --conf spark.task.resource.gpu.amount="${SPARK_TASK_RESOURCE_GPU_AMOUNT}"\
\
 --jars "${SPARK_CUDF_JAR}","${SPARK_RAPIDS_PLUGIN_JAR}","${SPARK_RAPIDS_INTEGRATION_TESTS_JAR}"\
 "$@"
# --class com.nvidia.spark.rapids.tests.tpcds.ConvertFiles\
# --input /opt/data/tpcds-1TB-csv\
# --output /ssd/tpcds-1TB\
# --output-format parquet\
# --repartition\
# call_center=1\
# catalog_page=1\
# customer_address=1\
# customer=1\
# customer_demographics=1\
# date_dim=1\
# dbgen_version=1\
# household_demographics=1\
# income_band=1\
# item=1\
# promotion=1\
# reason=1\
# ship_mode=1\
# store=1\
# time_dim=1\
# warehouse=1\
# web_page=1\
# web_returns=1\
# web_site=1\
# catalog_returns=1\
# catalog_sales=1\
# inventory=1\
# store_returns=1\
# store_sales=1\
# web_sales=1


