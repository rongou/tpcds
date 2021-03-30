#!/usr/bin/env bash

# Spark
export SPARK_HOME=${HOME}/rou/spark
export JAR_HOME=${HOME}/rou/rapids

export SPARK_CUDF_JAR=${JAR_HOME}/cudf.jar
export SPARK_CUDF_NVTX_JAR=${JAR_HOME}/cudf-nvtx.jar
export SPARK_RAPIDS_PLUGIN_JAR=${JAR_HOME}/rapids-4-spark.jar
export SPARK_RAPIDS_INTEGRATION_TESTS_JAR=${JAR_HOME}/rapids-4-spark-integration-tests.jar

export SPARK_MASTER_HOST=127.0.0.1
export SPARK_LOCAL_IP=${SPARK_MASTER_HOST}

export SPARK_EXECUTOR_INSTANCES=8
export SPARK_EXECUTOR_CORES=16
export SPARK_TASK_RESOURCE_GPU_AMOUNT=0.0625

# Hadoop
export HADOOP_HOME=${HOME}/rou/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Profiling
export NVTX_ENABLED=false

# Data
export DATA_DIR="/raid/data/useDecimal=false,useDate=true,filterNull=false"
