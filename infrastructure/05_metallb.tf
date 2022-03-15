# metalLB variables
variable "metallb_chart_name" {
    type        = string
    description = "metallb Helm chart name."
}
variable "metallb_chart_repo" {
    type        = string
    description = "metallb Helm repository name."
}
variable "metallb_chart_version" {
    type        = string
    description = "metallb Helm repository version."
}

# Add metallb as experiment tracking
resource "helm_release" "metallb" {
    repository      = var.metallb_chart_repo
    chart           = var.metallb_chart_name
    version         = var.metallb_chart_version

    name            = "${var.name_prefix}-${var.metallb_chart_name}"
    namespace       = var.namespace
    timeout         = 90

    values = [
        file("helm-values/metallb.yml")
    ]
}