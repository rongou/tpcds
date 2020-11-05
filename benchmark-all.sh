#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..71} q{73..99} ss_max{,b})

declare -A configs
for i in "${queries[@]}"; do
  configs[${i}]="6 6 1g 1g"
done

configs[q4]="6 24 1g 1g"
configs[q11]="6 24 1g 1g"
configs[q14a]="6 12 1g 1g"
configs[q14b]="6 12 1g 1g"
configs[q64]="5 5 1g 1g"
configs[q74]="6 18 1g 1g"
configs[q78]="6 12 1g 1g"
configs[q95]="6 30 1g 1g"

for i in "${queries[@]}"; do
  config="${configs[${i}]}"
  "${DIR}"/benchmark.sh "${i}" ${config} l
  "${DIR}"/benchmark.sh "${i}" ${config} p
  rm ./*.json
done
