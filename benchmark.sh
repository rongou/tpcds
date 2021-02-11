#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

# warm page cache
#vmtouch -t -m 20G "${DATA_DIR}"

# evict page cache
vmtouch -e "${DATA_DIR}"

# clean up work directory
rm -fr "${SPARK_HOME}"/work/*

# clean up tmp directories
rm -fr /raid/spark-home/tmp/*
rm -fr /raid1/spark-home/tmp/*
rm -fr /raid2/spark-home/tmp/*
rm -fr /raid3/spark-home/tmp/*

"${DIR}"/spark-shell-gpu.sh -i <(
  echo "val args = Array(\"${DATA_DIR}\", \"${QUERY}\")"
  cat "${DIR}"/query.scala
)

echo "Total spill events:"
egrep "DeviceMemoryEventHandler: Spilled" "${SPARK_HOME}"/work/*/*/stderr | wc -l
echo "Total spill size:"
egrep "DeviceMemoryEventHandler: Spilled" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 6 | paste -sd+ | bc
echo ""

echo "Total # buffers written via GDS:"
egrep "RapidsGdsStore: Spilled" "${SPARK_HOME}"/work/*/*/stderr | wc -l
echo "Total bytes written via GDS:"
egrep "RapidsGdsStore: Spilled" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 8 | cut -d ":" -f 2 | paste -sd+ | bc
echo ""

echo "Total # buffers read via GDS:"
egrep "RapidsGdsStore: Created device buffer" "${SPARK_HOME}"/work/*/*/stderr | wc -l
echo "Total bytes read via GDS:"
egrep "RapidsGdsStore: Created device buffer" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 10 | cut -d ":" -f 2 | paste -sd+ | bc

