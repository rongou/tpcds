#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

# warm page cache
#vmtouch -t -m 20G "${DATA_DIR}"
rm -fr "${SPARK_HOME}"/work/*

"${DIR}"/spark-shell-gpu.sh -i <(
  echo "val args = Array(\"${DATA_DIR}\", \"${QUERY}\")"
  cat "${DIR}"/query.scala
)
