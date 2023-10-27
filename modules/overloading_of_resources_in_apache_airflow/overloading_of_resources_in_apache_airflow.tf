resource "shoreline_notebook" "overloading_of_resources_in_apache_airflow" {
  name       = "overloading_of_resources_in_apache_airflow"
  data       = file("${path.module}/data/overloading_of_resources_in_apache_airflow.json")
  depends_on = [shoreline_action.invoke_update_deployment]
}

resource "shoreline_file" "update_deployment" {
  name             = "update_deployment"
  input_file       = "${path.module}/data/update_deployment.sh"
  md5              = filemd5("${path.module}/data/update_deployment.sh")
  description      = "Review the current parallelism and concurrency settings in Apache Airflow and adjust them to a level that can be supported by the available system resources."
  destination_path = "/tmp/update_deployment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_deployment" {
  name        = "invoke_update_deployment"
  description = "Review the current parallelism and concurrency settings in Apache Airflow and adjust them to a level that can be supported by the available system resources."
  command     = "`chmod +x /tmp/update_deployment.sh && /tmp/update_deployment.sh`"
  params      = ["AIRFLOW_NAMESPACE","DEPLOYMENT_NAME","DESIRED_PARALLELISM","DESIRED_CONCURRENCY","NAMESPACE"]
  file_deps   = ["update_deployment"]
  enabled     = true
  depends_on  = [shoreline_file.update_deployment]
}

