#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

export NVTX_ENABLED=true
green=$(tput setaf 2)
reset=$(tput sgr 0)
echo "${green}NVTX_ENABLED=${NVTX_ENABLED}${reset}"

"${DIR}"/stop.sh
"${SPARK_HOME}"/sbin/start-master.sh

nsys profile\
 -t cuda,nvtx,osrt\
 -s cpu\
 -o "${QUERY}"-c"${CONCURRENT_GPU_TASKS}"-"${GPU_MEMORY_POOL}"\
 --stats true\
 -f true\
 -c nvtx\
 -p RunQuery@Java\
 -e NSYS_NVTX_PROFILER_REGISTER_ONLY=0\
 bash -c " \
${SPARK_HOME}/sbin/start-worker.sh spark://${SPARK_MASTER_HOST}:7077 & \
${DIR}/spark-shell-gpu.sh -i <(
  echo 'val args = Array(\"'${DATA_DIR}'\", \"'${QUERY}'\")'
  cat ${DIR}/query-profile.scala); \
${SPARK_HOME}/sbin/stop-worker.sh"
