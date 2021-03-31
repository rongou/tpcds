import com.nvidia.spark.rapids.tests._
import com.nvidia.spark.rapids.tests.tpcds._

TpcdsLikeSpark.setupAllParquet(spark, args(0), true)

val benchmark = new BenchmarkRunner(new TpcdsLikeBench(true))
benchmark.collect(spark, args(1), 1)

System.exit(0)
