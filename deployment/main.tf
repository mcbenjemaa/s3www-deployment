module "helm-release" {
  source             = "./modules/helm-release"
  name               = "s3www"
  namespace          = "s3www"
  chart = "../charts/s3www"
  dependency_update = true

  values = [
    file("${path.module}/values/s3www-values.yaml"),
  ]
}
