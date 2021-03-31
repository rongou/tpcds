#!/usr/bin/env bash

set -e

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

queries=(q{1..13} q14{a,b} q{15..22} q{23,24}{a,b} q{25..38} q39{a,b} q{40..99} ss_max{,b})
failed_queries=(q31 q64 q72 q95)

declare -A configs
for i in "${queries[@]}"; do
  configs[${i}]="1 200 1g 1g"
done

for i in "${queries[@]}"; do
  if [[ " ${failed_queries[@]} " =~ " ${i} " ]]; then
    continue
  fi
  config="${configs[${i}]}"

  echo "Using rapids-4-spark_2.12-0.5.0-200c72d.jar"
  ln -sf rapids-4-spark_2.12-0.5.0-200c72d.jar ~/rapids/rapids-4-spark.jar
  "${DIR}"/benchmark.sh "${i}" ${config} b
  "${DIR}"/benchmark.sh "${i}" ${config} g
  rm -f ./*.json

  echo "Using rapids-4-spark_2.12-0.5.0-200c72d-stream.jar"
  ln -sf rapids-4-spark_2.12-0.5.0-200c72d-stream.jar ~/rapids/rapids-4-spark.jar
  "${DIR}"/benchmark.sh "${i}" ${config} b
  "${DIR}"/benchmark.sh "${i}" ${config} g
  rm -f ./*.json
done
