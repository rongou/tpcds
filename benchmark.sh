#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

"${DIR}"/stop.sh
"${DIR}"/start.sh
"${DIR}"/spark-shell-gpu.sh -i <(
  echo 'val args = Array("'"--input"'", "'"${DATA_DIR}"'", "'"--input-format"'", "'"parquet"'", "'"--query"'", "'"${QUERY}"'")'
  cat "${DIR}"/query.scala
)
