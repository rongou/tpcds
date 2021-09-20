#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..99} ss_max{,b})
failed_queries=(q23{a,b} q37 q82 q95)

for i in "${queries[@]}"; do
  if [[ " ${failed_queries[@]} " =~ " ${i} " ]]; then
    continue
  fi
  "${DIR}"/benchmark.sh "${i}" -c 3 -i 10
  "${DIR}"/benchmark.sh "${i}" -c 3 -async -i 10
  rm -f ./*.json
done
