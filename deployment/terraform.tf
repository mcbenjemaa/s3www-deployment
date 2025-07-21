provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

terraform {
  backend "kubernetes" {
    secret_suffix    = "s3www"
    load_config_file = true
    namespace        = "terraform"
    config_path      = "~/.kube/config"
  }
}
