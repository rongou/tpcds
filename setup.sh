#!/usr/bin/env bash

if [[ $# -ne 6 ]]; then
    echo "usage: script query# concurrent_gpu_tasks shuffle_partitions max_partition_bytes batch_size_bytes b|g"
    exit 1
fi

export QUERY=$1
export CONCURRENT_GPU_TASKS=$2
export SHUFFLE_PARTITIONS=$3
export MAX_PARTITION_BYTES=$4
export BATCH_SIZE_BYTES=$5

case $6 in
  b )
    echo "Using system memory as bounce buffers"
    export GDS_ENABLED="false"
    ;;
  g )
    echo "Using GPUDirect Storage (GDS)"
    export GDS_ENABLED="true"
    ;;
  * )
    echo "Need to specify b for system memory bounce or g for gds"
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
echo "GDS_ENABLED=${GDS_ENABLED}"
echo "SPARK_CUDF_JAR=${SPARK_CUDF_JAR}${reset}"
