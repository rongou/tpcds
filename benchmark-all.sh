#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

"${DIR}"/benchmark.sh 5 6 12 128m 2g l
"${DIR}"/benchmark.sh 5 6 12 128m 2g p
"${DIR}"/benchmark.sh 16 6 12 256m 2g l
"${DIR}"/benchmark.sh 16 6 12 256m 2g p
"${DIR}"/benchmark.sh 21 6 12 256m 2g l
"${DIR}"/benchmark.sh 21 6 12 256m 2g p
"${DIR}"/benchmark.sh 22 6 18 128m 512m l
"${DIR}"/benchmark.sh 22 6 18 128m 512m p