provider "kubernetes" {
  load_config_file = false
#   config_path = var.kube_config_path
}
provider "gitlab" {
  token = var.gitlab_token
}
