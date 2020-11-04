import ai.rapids.cudf.{NvtxColor, NvtxRange}
import com.nvidia.spark.rapids.tests._
import com.nvidia.spark.rapids.tests.tpcds._
import org.apache.spark.sql.{DataFrame, SparkSession}

val input = args(0)
val query = args(1)

TpcdsLikeSpark.setupAllParquet(spark, input)

val nvtxRange = new NvtxRange("RunQuery", NvtxColor.ORANGE)
try {
  val benchmark = new BenchmarkRunner(new TpcdsLikeBench(true))
  benchmark.collect(spark, query, 1)
} finally {
  nvtxRange.close()
}

System.exit(0)
