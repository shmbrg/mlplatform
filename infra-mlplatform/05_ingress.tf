# Traefik/Ingress variables
variable "ingress_gateway_chart_name" {
    type        = string
    description = "Ingress Gateway Helm chart name."
}
variable "ingress_gateway_chart_repo" {
    type        = string
    description = "Ingress Gateway Helm repository name."
}
variable "ingress_gateway_chart_version" {
    type        = string
    description = "Ingress Gateway Helm repository version."
}


# Deploy Ingress Controller Traefik (ingress gateway)
resource "helm_release" "ingress_gateway" {
    depends_on      = [helm_release.mlflow]

    repository      = var.ingress_gateway_chart_repo
    chart           = var.ingress_gateway_chart_name
    version         = var.ingress_gateway_chart_version

    name            = "${var.name_prefix}-${var.ingress_gateway_chart_name}"
    namespace       = var.namespace
    timeout         = 90

    values = [
      file("helm-values/traefik.yml")
    ]
}