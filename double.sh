#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

"${DIR}"/benchmark.sh "$@" b
"${DIR}"/benchmark.sh "$@" g
rm ./*.json
