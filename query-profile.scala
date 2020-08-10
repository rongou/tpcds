import ai.rapids.cudf.{NvtxColor, NvtxRange}
import com.nvidia.spark.rapids.tests.tpcxbb._
import org.apache.spark.sql.{DataFrame, SparkSession}

val input = args(0)
val queryIndex = args(1).toInt

TpcxbbLikeSpark.setupAllParquet(spark, input)

val queryRunner: SparkSession => DataFrame = queryIndex match {
  case 5 => Q5Like.apply
  case 16 => Q16Like.apply
  case 21 => Q21Like.apply
  case 22 => Q22Like.apply
  case _ => throw new IllegalArgumentException(s"Unknown TPCx-BB query number: $queryIndex")
}

val nvtxRange = new NvtxRange("RunQuery", NvtxColor.ORANGE)
try {
  queryRunner(spark).collect
} finally {
  nvtxRange.close()
}

System.exit(0)
