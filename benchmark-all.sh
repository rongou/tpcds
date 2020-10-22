#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

declare -A queries
for i in q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..71} q{73..99} ss_max{,b}
do
  queries[$i]=6
done

queries[q4]=108
queries[q11]=18
queries[q64]=12
queries[q74]=12
queries[q78]=12
queries[q80]=12
queries[q95]=18

for i in q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..71} q{73..99} ss_max{,b}
do
  p="${queries[$i]}"
  "${DIR}"/benchmark.sh "${i}" 6 ${p} 2g 2g l
  "${DIR}"/benchmark.sh "${i}" 6 ${p} 2g 2g p
  rm ./*.json
done
