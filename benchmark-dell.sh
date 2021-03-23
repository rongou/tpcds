#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# All queries:
#queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..99} ss_max{,b})

# Spilling queries:
queries=(q4 q11 q13 q14a q14b q16 q17 q23a q23b q24a q24b q25 q29 q64 q78 q80 q93 q95)

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
