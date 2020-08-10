#!/usr/bin/env bash

"${SPARK_HOME}"/bin/spark-shell\
 --master spark://"${SPARK_MASTER_HOST}":7077\
 --conf spark.locality.wait=0s\
\
 --conf spark.driver.memory=4G\
\
 --num-executors 1\
 --conf spark.executor.cores=6\
 --conf spark.executor.memory=64G\
\
 --conf spark.task.cpus=1\
\
 --jars "${SPARK_RAPIDS_INTEGRATION_TESTS_JAR}"
