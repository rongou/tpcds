#!/usr/bin/env bash

# Spark
export SPARK_HOME=/opt/spark
export JAR_HOME=/opt/rapids

export SPARK_CUDF_JAR=${JAR_HOME}/cudf.jar
export SPARK_CUDF_PTDS_JAR=${JAR_HOME}/cudf-ptds.jar
export SPARK_CUDF_NVTX_JAR=${JAR_HOME}/cudf-nvtx.jar
export SPARK_CUDF_NVTX_PTDS_JAR=${JAR_HOME}/cudf-nvtx-ptds.jar
export SPARK_RAPIDS_PLUGIN_JAR=${JAR_HOME}/rapids-4-spark.jar
export SPARK_RAPIDS_INTEGRATION_TESTS_JAR=${JAR_HOME}/rapids-4-spark-integration-tests.jar

export SPARK_MASTER_HOST=127.0.0.1
export SPARK_LOCAL_IP=${SPARK_MASTER_HOST}

# Hadoop
export HADOOP_HOME=/opt/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Profiling
export NVTX_ENABLED=false
