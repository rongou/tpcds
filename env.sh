#!/usr/bin/env bash

export SPARK_BASE_DIR=/opt

# Spark
export SPARK_HOME=${SPARK_BASE_DIR}/spark
export JAR_HOME=${SPARK_BASE_DIR}/rapids

export SPARK_CUDF_JAR=${JAR_HOME}/cudf.jar
export SPARK_RAPIDS_PLUGIN_JAR=${JAR_HOME}/rapids-4-spark.jar
export SPARK_RAPIDS_BENCHMARKS_JAR=${JAR_HOME}/rapids-4-spark-benchmarks.jar

export SPARK_MASTER_HOST=127.0.0.1
export SPARK_LOCAL_IP=${SPARK_MASTER_HOST}

export SPARK_EXECUTOR_INSTANCES=1
export SPARK_EXECUTOR_CORES=24
export SPARK_TASK_RESOURCE_GPU_AMOUNT=0.0416

# Hadoop
export HADOOP_HOME=${SPARK_BASE_DIR}/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Profiling
export NVTX_ENABLED=false

# Data
export DATA_DIR="${SPARK_BASE_DIR}/data/tpcds/sf1000-parquet/useDecimal=true,useDate=true,filterNull=false"
