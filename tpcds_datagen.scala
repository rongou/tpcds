// TPCDS Scale factor
val scaleFactor = "1000"

// data format.
val format = "parquet"
// If false, float type will be used instead of decimal.
val useDecimal = false
// If false, string type will be used instead of date.
val useDate = true
// If true, rows with nulls in partition key will be thrown away.
val filterNull = false
// If true, partitions will be coalesced into a single file during generation.
val shuffle = true

// s3/dbfs path to generate the data to.
val rootDir = s"/opt/data/tpcds/sf$scaleFactor-$format/useDecimal=$useDecimal,useDate=$useDate,filterNull=$filterNull"
// name of database to be created.
val databaseName = s"tpcds_sf${scaleFactor}" +
  s"""_${if (useDecimal) "with" else "no"}decimal""" +
  s"""_${if (useDate) "with" else "no"}date""" +
  s"""_${if (filterNull) "no" else "with"}nulls"""

// Create the table schema with the specified parameters.
import com.databricks.spark.sql.perf.tpcds.TPCDSTables
val sqlContext = spark.sqlContext
val tables = new TPCDSTables(sqlContext, dsdgenDir = "/home/rou/src/tpcds-kit/tools", scaleFactor = scaleFactor, useDoubleForDecimal = !useDecimal, useStringForDate = !useDate)

// Data generation tuning:

import org.apache.spark.deploy.SparkHadoopUtil
// Limit the memory used by parquet writer
//SparkHadoopUtil.get.conf.set("parquet.memory.pool.ratio", "0.1")
// Compress with snappy:
sqlContext.setConf("spark.sql.parquet.compression.codec", "snappy")
// TPCDS has around 2000 dates.
spark.conf.set("spark.sql.shuffle.partitions", "200")
// Don't write too huge files.
sqlContext.setConf("spark.sql.files.maxRecordsPerFile", "20000000")

val dsdgen_partitioned=200 // recommended for SF10000+.
val dsdgen_nonpartitioned=10 // small tables do not need much parallelism in generation.

// COMMAND ----------

// val tableNames = Array("") // Array("") = generate all.
//val tableNames = Array("call_center", "catalog_page", "catalog_returns", "catalog_sales", "customer", "customer_address", "customer_demographics", "date_dim", "household_demographics", "income_band", "inventory", "item", "promotion", "reason", "ship_mode", "store", "store_returns", "store_sales", "time_dim", "warehouse", "web_page", "web_returns", "web_sales", "web_site") // all tables

// generate all the small dimension tables
val nonPartitionedTables = Array("call_center", "catalog_page", "customer", "customer_address", "customer_demographics", "date_dim", "household_demographics", "income_band", "item", "promotion", "reason", "ship_mode", "store",  "time_dim", "warehouse", "web_page", "web_site")
nonPartitionedTables.foreach { t => {
  tables.genData(
      location = rootDir,
      format = format,
      overwrite = true,
      partitionTables = true,
      clusterByPartitionColumns = shuffle,
      filterOutNullPartitionValues = filterNull,
      tableFilter = t,
      numPartitions = dsdgen_nonpartitioned)
}}
println("Done generating non partitioned tables.")

// leave the biggest/potentially hardest tables to be generated last.
val partitionedTables = Array("inventory", "web_returns", "catalog_returns", "store_returns", "web_sales", "catalog_sales", "store_sales")
partitionedTables.foreach { t => {
  tables.genData(
      location = rootDir,
      format = format,
      overwrite = true,
      partitionTables = true,
      clusterByPartitionColumns = shuffle,
      filterOutNullPartitionValues = filterNull,
      tableFilter = t,
      numPartitions = dsdgen_partitioned)
}}
println("Done generating partitioned tables.")

// COMMAND ----------

// MAGIC %md
// MAGIC Create database

// COMMAND ----------

sql(s"drop database if exists $databaseName cascade")
sql(s"create database $databaseName")

// COMMAND ----------

sql(s"use $databaseName")

// COMMAND ----------

tables.createExternalTables(rootDir, format, databaseName, overwrite = true, discoverPartitions = true)

// COMMAND ----------

// MAGIC %md
// MAGIC Analyzing tables is needed only if cbo is to be used.

// COMMAND ----------

tables.analyzeTables(databaseName, analyzeColumns = true)
