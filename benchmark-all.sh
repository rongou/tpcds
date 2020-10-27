#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..99} ss_max{,b})
skip=(q4 q11 q13 q14a q14b q16 q17 q20 q23a q23b q24a q24b q25 q29 q50 q64 q67 q72 q95)

for i in "${queries[@]}"; do
  if [[ ! "${skip[*]}" =~ ${i} ]]; then
    "${DIR}"/benchmark.sh "${i}" 4 64 512m 2g l
    "${DIR}"/benchmark.sh "${i}" 4 64 512m 2g p
    rm ./*.json
  fi
done
