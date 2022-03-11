# MinIO variables
variable "minio_chart_name" {
  type        = string
  description = "MinIO Helm chart name."
}
variable "minio_chart_repo" {
  type        = string
  description = "MinIO Helm repository name."
}
variable "minio_chart_version" {
  type        = string
  description = "MinIO Helm repository version."
}

# Add minIO as artefact object storage
resource "helm_release" "minio" {
    repository      = var.minio_chart_repo
    chart           = var.minio_chart_name
    version         = var.minio_chart_version
    name            = "${var.name_prefix}-minio"
    namespace       = var.namespace
    timeout         = 90

    values = [
        file("helm-values/minio.yml")
    ]
}