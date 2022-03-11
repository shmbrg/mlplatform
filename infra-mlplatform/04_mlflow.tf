# mlFlow variables
variable "mlflow_chart_name" {
  type        = string
  description = "mlFlow Helm chart name."
}
variable "mlflow_chart_repo" {
  type        = string
  description = "mlFlow Helm repository name."
}
variable "mlflow_chart_version" {
  type        = string
  description = "mlFlow Helm repository version."
}

# Add mlFlow as experiment tracking
resource "helm_release" "mlflow" {
    depends_on      = [helm_release.minio, helm_release.postgresql]
    repository      = var.mlflow_chart_repo
    chart           = var.mlflow_chart_name
    version         = var.mlflow_chart_version
    name            = "${var.name_prefix}-mlflow"
    namespace       = var.namespace
    timeout         = 90

    values = [
        file("helm-values/mlflow.yml")
    ]
}