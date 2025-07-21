terraform {
  required_version = ">= 1.2.4"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.2"
    }
  }
}

resource "helm_release" "release" {
  name       = var.name
  chart      = var.chart
  namespace = var.namespace
  create_namespace = var.create_namespace
  dependency_update = var.dependency_update
  wait = false

  values = var.values
}
