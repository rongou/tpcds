#!/usr/bin/env bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

# shellcheck source=.
source "${DIR}"/setup.sh

"${DIR}"/stop.sh
"${SPARK_HOME}"/sbin/start-master.sh

compute-sanitizer --target-processes	all\
 bash -c "\
 ${SPARK_HOME}/sbin/start-worker.sh spark://${SPARK_MASTER_HOST}:7077 &\
 ${DIR}/spark-submit-gpu.sh;\
 ${SPARK_HOME}/sbin/stop-worker.sh"
