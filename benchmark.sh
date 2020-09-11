#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

"${DIR}"/stop.sh
"${DIR}"/start.sh
"${DIR}"/spark-shell-gpu.sh -i <(
  echo 'val args = Array("'"${DATA_DIR}"'", "'"${QUERY}"'")'
  cat "${DIR}"/query.scala
)
