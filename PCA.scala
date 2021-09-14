import com.nvidia.spark.ml.feature.PCA
import org.apache.spark.ml.feature.{PCA =>MLPCA}
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions.udf

val jsonDf = spark.read.json("/opt/data/sk-telecom/*/*.json")
val valuesDf = jsonDf.select(jsonDf.col("feature_value_scale.values"))
val convertToVector = udf((array: Array[Double]) => {
  Vectors.dense(array)
})
val vectorDf = valuesDf.withColumn("feature_value_vector", convertToVector($"values"))
val inputDf = vectorDf.select(vectorDf.col("feature_value_vector"))

val mlPca = new MLPCA().setInputCol("feature_value_vector").setOutputCol("feature_value_3d").setK(3).fit(inputDf)
val mlResult = mlPca.transform(inputDf).select("feature_value_3d")
mlResult.write.mode("overwrite").json("mllib-result")

val pca = new PCA().setInputCol("feature_value_vector").setOutputCol("feature_value_3d").setK(3).setMeanCentering(false).fit(inputDf)
val result = pca.transform(inputDf).select("feature_value_3d")
result.write.mode("overwrite").json("cublas-no-mean-centering")

:quit
