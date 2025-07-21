variable "chart" {
  type        = string
  description = "Chart path"
}

variable "name" {
  type        = string
  description = "Release name"
}

variable "namespace" {
  type        = string
  description = "Release namespace"
}

variable "service_type" {
  type        = string
  description = "Service type for the App"
  default     = "ClusterIP"
}

variable "values" {
  type        = list(string)
  description = "values files to use for the helm release"
  default     = []
}

variable "dependency_update" {
    type        = bool
    description = "Run helm dependency update before installing the chart"
    default     = true
}

variable "create_namespace" {
    type        = bool
    description = "Create the namespace if it does not exist"
    default     = true
}
