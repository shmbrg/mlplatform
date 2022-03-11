# General variables
name_prefix                           = "mlp"
namespace                             = "mlplatform"

# MinIO variables
minio_chart_repo                      = "https://charts.bitnami.com/bitnami"
minio_chart_name                      = "minio"
minio_chart_version                   = "10.1.16"

# postgreSQL variables
postgresql_chart_repo                 = "https://charts.bitnami.com/bitnami"
postgresql_chart_name                 = "postgresql"
postgresql_chart_version              = "11.1.3"
postgresql_k8s_secret_name            = "mlp-mlflow-postgresql"

# mlFlow variables
mlflow_chart_repo                     = "https://larribas.me/helm-charts"
mlflow_chart_name                     = "mlflow"
mlflow_chart_version                  = "1.0.1"

# Traefik/Ingress variables
#ingress_gateway_chart_repo            = "https://helm.traefik.io/traefik"
#ingress_gateway_chart_name            = "traefik"
#ingress_gateway_chart_version         = "9.8.3"