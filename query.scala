import com.nvidia.spark.rapids.tests._
import com.nvidia.spark.rapids.tests.tpcds._

TpcdsLikeSpark.setupAllParquet(spark, args(0))

val benchmark = new BenchmarkRunner(TpcdsLikeBench)
benchmark.collect(spark, args(1))

System.exit(0)
