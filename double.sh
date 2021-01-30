#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# clean up work directory
rm -fr "${SPARK_HOME}"/work/*

"${DIR}"/benchmark.sh "$@" b
"${DIR}"/benchmark.sh "$@" g
rm ./*.json
