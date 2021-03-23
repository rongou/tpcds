#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..99} ss_max{,b})
failed_queries=(q14a q14b q72)

declare -A configs
for i in "${queries[@]}"; do
  configs[${i}]="3 200 1g 1g"
done

for i in "${queries[@]}"; do
  if [[ " ${failed_queries[@]} " =~ " ${i} " ]]; then
    continue
  fi
  config="${configs[${i}]}"
  "${DIR}"/benchmark.sh "${i}" ${config} b
  "${DIR}"/benchmark.sh "${i}" ${config} g
  rm -f ./*.json
done
