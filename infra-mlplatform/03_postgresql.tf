# PostgreSQL variables
variable "postgresql_chart_name" {
  type        = string
  description = "PostgreSQL Helm chart name."
}
variable "postgresql_chart_repo" {
  type        = string
  description = "PostgreSQL Helm repository name."
}
variable "postgresql_chart_version" {
  type        = string
  description = "PostgreSQL Helm repository version."
}
variable "postgresql_k8s_secret_name" {
  type        = string
  description = "PostgreSQL K8s secret password name."
}

# Add password as k8s secret
resource "kubernetes_secret" "postgresql_password" {
  metadata {
    name      = var.postgresql_k8s_secret_name
    namespace = var.namespace
  }
  data = {
    password = "mlflow123"
  }
}

# Add postgreSQL as model metadata database
resource "helm_release" "postgresql" {
    depends_on      = [kubernetes_secret.postgresql_password]
    repository      = var.postgresql_chart_repo
    chart           = var.postgresql_chart_name
    version         = var.postgresql_chart_version
    name            = "${var.name_prefix}-postgresql"
    namespace       = var.namespace
    timeout         = 90

    values = [
        file("helm-values/postgresql.yml")
    ]
}
