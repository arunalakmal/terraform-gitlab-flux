variable "gitlab_token" {
  default = "NaN"
}

variable "target_path" {
  default = "clusters/dev"
}

variable "branch" {
  default = "master"
}

variable "gitlab_repo_path" {
  default = "techcrumble"
}

variable "gitlab_project_id" {
  default = "25354313"
}

variable "gitops_administrator_repo" {
  default = "techcrumble-gitops-administrator"
}

variable "kube_config_path" {
  default = "~/.kube/config"
}

variable "flux_namespace" {
  default = "flux-system"
}