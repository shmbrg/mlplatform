variable "name_prefix" {
  description = "Prefix for components."
  type        = string
  default     = "mlp"
}

variable "namespace" {
  description = "K8s namespace."
  type        = string
  default     = "mlplatform"
}