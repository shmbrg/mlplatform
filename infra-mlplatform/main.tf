# Add kubernetes namespace to cluster 
resource "kubernetes_namespace" "mlplatform_namespace" {
    metadata {
        name = "mlplatform"
    }
}

# Add random password for DB
resource "random_password" "password"{
    length = 24
    special = true
    override_special ="_%@"
}

# Deploy a postgres database with helm chart to cluster (database for model metadata)
resource "helm_release" "postgresql" {
    name          = "postgresql"
    namespace     = kubernetes_namespace.mlplatform_namespace.metadata[0].name

    repository    = "https://charts.bitnami.com/bitnami"
    chart         = "postgresql"
}

# Deploy mlflow to cluster
resource "helm_release" "mlflow" {
    name        = "mlflow"
    namespace   = kubernetes_namespace.mlplatform_namespace.metadata[0].name

    repository  = "https://larribas.me/helm-charts"
    chart       = "mlflow"
    version     = "1.0.1"

    values = [<<EOF
        backendStore:
            postgres:
                username: postgresql
                password: ${random_password.password.result}
                host: my_host
                port: 5342
                database: postgresql
        EOF
    ]
}