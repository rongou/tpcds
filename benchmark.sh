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

match="DeviceMemoryEventHandler: Spilled"
attempts=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 6 | paste -sd+ | bc)
echo "# spill events: ${attempts}"
echo "Spilled bytes: ${bytes:-0}"

if [[ "${GDS_ENABLED}" == "false" ]]; then
  match="RapidsDeviceMemoryStore: Spilling device memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 9 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers spilled device->host: ${buffers}"
  echo "Bytes spilled device->host: ${bytes:-0}"

  match="RapidsHostMemoryStore: Spilling host memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 9 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers spilled host->disk: ${buffers}"
  echo "Bytes spilled host->disk: ${bytes:-0}"

  match="RapidsHostMemoryStore: Unspilling host memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 9 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers unspilled host->device: ${buffers}"
  echo "Bytes unspilled host->device: ${bytes:-0}"

  match="RapidsDiskStore: Unspilling local disk buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 9 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers unspilled disk->device: ${buffers}"
  echo "Bytes unspilled disk->device: ${bytes:-0}"

  match="RapidsDeviceMemoryStore: Skipping spilling device memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 10 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers skipped spilling device->host: ${buffers}"
  echo "Bytes skipped spilling device->host: ${bytes:-0}"

  match="RapidsHostMemoryStore: Skipping spilling host memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 10 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers skipped spilling host->disk: ${buffers}"
  echo "Bytes skipped spilling host->disk: ${bytes:-0}"
fi

if [[ "${GDS_ENABLED}" == "true" ]]; then
  match="RapidsGdsStore: Spilled"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 8 | cut -d ":" -f 2 | paste -sd+ | bc)
  echo "# buffers spilled device->GDS: ${buffers}"
  echo "Bytes spilled device->GDS: ${bytes:-0}"

  match="RapidsGdsStore: Created device buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 10 | cut -d ":" -f 2 | paste -sd+ | bc)
  echo "# buffers unspilled GDS->device: ${buffers}"
  echo "Bytes unspilled GDS->device: ${bytes:-0}"

  match="RapidsDeviceMemoryStore: Skipping spilling device memory buffer"
  buffers=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | wc -l)
  bytes=$(grep "${match}" "${SPARK_HOME}"/work/*/*/stderr | cut -d " " -f 10 | sed "s/size=//" | paste -sd+ | bc)
  echo "# buffers skipped spilling device->GDS: ${buffers}"
  echo "Bytes skipped spilling device->GDS: ${bytes:-0}"
fi
