provider "kubernetes" {
#   config_path = var.kube_config_path
}
provider "gitlab" {
  token = var.gitlab_token
}
