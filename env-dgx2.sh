#!/usr/bin/env bash

export SPARK_BASE_DIR=/raid/spark-team

# Spark
export SPARK_HOME=${HOME}/spark
export JAR_HOME=${HOME}/rapids

export SPARK_CUDF_JAR=${JAR_HOME}/cudf.jar
export SPARK_RAPIDS_PLUGIN_JAR=${JAR_HOME}/rapids-4-spark.jar
export SPARK_RAPIDS_BENCHMARKS_JAR=${JAR_HOME}/rapids-4-spark-benchmarks.jar

export SPARK_MASTER_HOST=127.0.0.1
export SPARK_LOCAL_IP=${SPARK_MASTER_HOST}

export SPARK_EXECUTOR_INSTANCES=16
export SPARK_EXECUTOR_CORES=3
export SPARK_TASK_RESOURCE_GPU_AMOUNT=0.3

# Hadoop
export HADOOP_HOME=${HOME}/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Profiling
export NVTX_ENABLED=false

# Data
export DATA_DIR="/raid2/spark-team/tpcds/sf5000-parquet/useDecimal=false,useDate=true,filterNull=false"
