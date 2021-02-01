#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

# warm page cache
#vmtouch -t -m 20G "${DATA_DIR}"

# evict page cache
vmtouch -e "${DATA_DIR}"

# clean up work directory
rm -fr "${SPARK_HOME}"/work/*

"${DIR}"/spark-shell-gpu.sh -i <(
  echo "val args = Array(\"${DATA_DIR}\", \"${QUERY}\")"
  cat "${DIR}"/query.scala
)

echo "Checking spilled buffers:"
egrep "DeviceMemoryEventHandler: Spilled" "${SPARK_HOME}"/work/*/*/stderr | wc -l
