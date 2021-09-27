#!/usr/bin/env bash

usage() {
  cat << EOF
usage: script query# [-g] [-c concurrent_gpu_tasks] [-s shuffle_partitions] [-a] [-t allocation_threshold] [-u] [-async] [-i iterations]
EOF
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

export QUERY=$1
shift
export GDS_ENABLED="false"
export CONCURRENT_GPU_TASKS=1
export SHUFFLE_PARTITIONS=200
export ALIGNED_IO="false"
export ALIGNMENT_THRESHOLD="8m"
export UNSPILL="false"
export GDS_HOST_SPILL="false"
export MAX_PARTITION_BYTES=1g
export BATCH_SIZE_BYTES=1g
export GPU_MEMORY_POOL="ARENA"
export ITERATIONS=1

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -g)
    echo "Using GPUDirect Storage (GDS)"
    export GDS_ENABLED="true"
    shift
    ;;
  -h)
    export GDS_HOST_SPILL="true"
    shift
    ;;
  -c)
    export CONCURRENT_GPU_TASKS="$2"
    shift
    shift
    ;;
  -s)
    export SHUFFLE_PARTITIONS="$2"
    shift
    shift
    ;;
  -a)
    export ALIGNED_IO="true"
    shift
    ;;
  -t)
    export ALIGNMENT_THRESHOLD="$2"
    shift
    shift
    ;;
  -u)
    export UNSPILL="true"
    shift
    ;;
  -async)
    export GPU_MEMORY_POOL="ASYNC"
    shift
    ;;
  -i)
    export ITERATIONS="$2"
    shift
    shift
    ;;
  *) # unknown option
    usage
    ;;
  esac
done

green=$(tput setaf 2)
reset=$(tput sgr 0)
echo "${green}DATA_DIR=${DATA_DIR}"
echo "QUERY=${QUERY}"
echo "CONCURRENT_GPU_TASKS=${CONCURRENT_GPU_TASKS}"
#echo "SHUFFLE_PARTITIONS=${SHUFFLE_PARTITIONS}"
#echo "ALIGNED_IO=${ALIGNED_IO}"
#echo "ALIGNMENT_THRESHOLD=${ALIGNMENT_THRESHOLD}"
#echo "UNSPILL=${UNSPILL}"
#echo "GDS_ENABLED=${GDS_ENABLED}"
#echo "GDS_HOST_SPILL=${GDS_HOST_SPILL}"
echo "GPU_MEMORY_POOL=${GPU_MEMORY_POOL}"
echo "ITERATIONS=${ITERATIONS}${reset}"
