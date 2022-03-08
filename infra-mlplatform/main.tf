# Add kubernetes namespace to cluster 
resource "kubernetes_namespace" "mlplatform_namespace" {
    metadata {
        name = "mlplatform"
    }
}

# Deploy a postgres database with helm chart to cluster (database for model metadata)
resource "helm_release" "postgresql" {
    name          = "postgresql"
    repository    = "https://charts.bitnami.com/bitnami"
    chart         = "postgresql"
    namespace     = kubernetes_namespace.mlplatform_namespace.metadata[0].name
}

# Deploy mlflow to cluster
resource "helm_release" "mlflow" {
    name        = "mlflow"
    repository  = "https://larribas.me/helm-charts"
    chart       = "mlflow"
    version     = "1.0.1"
    namespace     = kubernetes_namespace.mlplatform_namespace.metadata[0].name

    values      = [
        backendStore:
        postgres:
            username: my_user
            password: my_password
            host: my_host
            port: 5342
            database: my_db
    ]
}