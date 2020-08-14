#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

export SPARK_CUDF_JAR=${SPARK_CUDF_NVTX_JAR}
export SPARK_CUDF_PTDS_JAR=${SPARK_CUDF_NVTX_PTDS_JAR}

# shellcheck source=.
source "${DIR}"/setup.sh

"${DIR}"/stop.sh
"${DIR}"/start.sh
"${DIR}"/spark-shell-gpu.sh -i <(
  echo 'val args = Array("'"${DATA_DIR}"'", "'"${QUERY}"'")'
  cat "${DIR}"/query.scala
)
