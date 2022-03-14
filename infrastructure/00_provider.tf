terraform {
    required_version = ">= 1.1.7"
}

# Add minikube as provider
provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context_cluster = "minikube"
}

# Add helm as provider
provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
        config_context_cluster = "minikube"
    }
}

