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



