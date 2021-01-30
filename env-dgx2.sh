#!/usr/bin/env bash

export SPARK_BASE_DIR=/raid/spark-team/rou

# Spark
export SPARK_HOME=${SPARK_BASE_DIR}/spark
export JAR_HOME=${SPARK_BASE_DIR}/rapids

export SPARK_CUDF_JAR=${JAR_HOME}/cudf.jar
export SPARK_CUDF_NVTX_JAR=${JAR_HOME}/cudf-nvtx.jar
export SPARK_RAPIDS_PLUGIN_JAR=${JAR_HOME}/rapids-4-spark.jar
export SPARK_RAPIDS_INTEGRATION_TESTS_JAR=${JAR_HOME}/rapids-4-spark-integration-tests.jar

export SPARK_MASTER_HOST=127.0.0.1
export SPARK_LOCAL_IP=${SPARK_MASTER_HOST}

export SPARK_EXECUTOR_INSTANCES=16
export SPARK_EXECUTOR_CORES=6
export SPARK_TASK_RESOURCE_GPU_AMOUNT=0.1666

export SPARK_LOCAL_DIRS=${SPARK_BASE_DIR}/tmp

# Hadoop
export HADOOP_HOME=${SPARK_BASE_DIR}/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Profiling
export NVTX_ENABLED=false

# Data
export DATA_DIR="${SPARK_BASE_DIR}/../tpcds-1TB-parquet"
