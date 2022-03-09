# Add kubernetes namespace to cluster 
resource "kubernetes_namespace" "mlplatform_namespace" {
    metadata {
        name = var.namespace
    }
}

# Add random password for DB
resource "random_password" "password"{
    length = 24
    special = true
    override_special ="_%@"
}

resource "kubernetes_secret" "postgresql_password" {
  metadata {
    name      = "${var.name_prefix}-mlflow-postgresql" # TODO hardcoded name
    namespace = var.namespace
  }
  data = {
    password = "mlflow123"
  }
}

# Add minIO as artefact object storage
resource "helm_release" "minio" {
    repository      = "https://charts.bitnami.com/bitnami"
    chart           = "minio"
    version         = "10.1.16"
    name            = "${var.name_prefix}-minio"
    namespace       = var.namespace
    timeout         = 90

    values = [
        yamlencode({ 
            accessKey = "minio"
            secretKey = "minio123"
            generate-name = "minio/minio"
            service = {
                port = 9000
            }
            resources = {
                requests = {
                    memory = "256Mi"
                }
            }
            buckets = [{
                name   = "mlflow-artifacts"
                policy = "none"
                purge  = "false"
            }]
            persistence = {
                size = "10Gi"
            }
        })
    ]
}

# Add postgreSQL as model metadata database
resource "helm_release" "postgresql" {
    depends_on      = [kubernetes_secret.postgresql_password]
    repository      = "https://charts.bitnami.com/bitnami"
    chart           = "postgresql"
    version         = "11.1.3"
    name            = "${var.name_prefix}-postgresql"
    namespace       = var.namespace
    timeout         = 90

    values = [
        yamlencode({
            auth = {
                rootPassword = "postgresql123"
                database     = "mlflow"
                username     = "mlflow"
                password     = "mlflow123"
            }
        })
    ]
}

# Add mlFlow as experiment tracking
resource "helm_release" "mlflow" {
    depends_on      = [helm_release.minio, helm_release.postgresql]
    repository      = "https://larribas.me/helm-charts"
    chart           = "mlflow"
    version         = "1.0.1"
    name            = "${var.name_prefix}-mlflow"
    namespace       = var.namespace
    timeout         = 90
    
    values = [
        yamlencode({
            backendStore = {
                postgresql = {
                    username = "mlflow"
                    password = "mlflow123"
                    host     = "${var.name_prefix}-database-postgresql.${var.namespace}.svc.cluster.local"
                    port     = 3306
                    database = "mlflow"
                }
            }
            awsAccessKeyId      = "minio"    
            awsSecretAccessKey  = "minio123"
            s3EndpointUrl       = "http://${var.name_prefix}-minio.${var.namespace}.svc.cluster.local:9000"
            defaultArtifactRoot = "s3://mlflow-artifacts/"
        })
    ]
}

/*
# Expose mlFlow to internet
resource "helm_release" "traefik" {
    depends_on      = [helm_release.mlflow]
    repository      = "https://helm.traefik.io/traefik"
    chart           = "traefik"
    version         = "10.14.2"
    name            = "${var.name_prefix}-traefik"
    namespace       = var.namespace
    timeout         = 90


}
*/


