#!/usr/bin/env bash

if [[ $# -ne 6 ]]; then
    echo "usage: script query# concurrent_gpu_tasks shuffle_partitions max_partition_bytes batch_size_bytes l|p"
    exit 1
fi

export DATA_DIR="/opt/data/tpcds-100GB"
export QUERY=$1
export CONCURRENT_GPU_TASKS=$2
export SHUFFLE_PARTITIONS=$3
export MAX_PARTITION_BYTES=$4
export BATCH_SIZE_BYTES=$5

case $6 in
  l )
    echo "Using legacy default stream"
    export MODE="legacy"
    ;;
  p )
    echo "Using per-thread default stream"
    export MODE="ptds"
    export SPARK_CUDF_JAR=${SPARK_CUDF_PTDS_JAR}
    ;;
  * )
    echo "Need to specify l for legacy or p for ptds"
    exit 1
esac

green=$(tput setaf 2)
reset=$(tput sgr 0)
echo "${green}DATA_DIR=${DATA_DIR}"
echo "QUERY=${QUERY}"
echo "CONCURRENT_GPU_TASKS=${CONCURRENT_GPU_TASKS}"
echo "SHUFFLE_PARTITIONS=${SHUFFLE_PARTITIONS}"
echo "MAX_PARTITION_BYTES=${MAX_PARTITION_BYTES}"
echo "BATCH_SIZE_BYTES=${BATCH_SIZE_BYTES}"
echo "SPARK_CUDF_JAR=${SPARK_CUDF_JAR}${reset}"
